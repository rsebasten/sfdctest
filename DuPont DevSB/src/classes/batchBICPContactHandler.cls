/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Updating contact metadata on lead

<AS20161031>
Modified By: Arjun Sharma
Modification Date: 31-Oct-2016
Modification: To avoid the Too many query rows: 50001 implement QueryLocator

<AS20161220>
Modified By: Arjun Sharma
Modification Date: 20-Dec-2016
Modification: Change filter criteria for query

<AS20170428>
Modified By: Arjun Sharma
Modification Date: 28-Apr-2017
Modification: Added  boolean variable to bypass the trigger
***************************************************************************************************/
global class batchBICPContactHandler implements Database.Batchable<sObject>,Database.Stateful{
    
    public static final Integer batchJobSize = Integer.valueOf(Label.CPSF_Dodge_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_CPSF_Batch_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    //<AS20161220> Start
    public Set<Id> contactIds = new Set<Id>();
    
    public batchBICPContactHandler(Set<Id> contactId){
        contactIds.addAll(contactId);
    }
    //<AS20161220> End    
    
    //<AS20161031> Start
    public Database.QueryLocator start(Database.BatchableContext BC){       
        String query = 'SELECT Name,ConstructionPts__ContactID__c,ConstructionPts__Contact_email__c,ConstructionPts__Contact_extension__c,ConstructionPts__Contact_phone__c,ConstructionPts__Contact_title__c,LastModifiedDate FROM ConstructionPts__CP_Contact__c Where Id IN :contactIds';//<AS20161220>
        return Database.getQueryLocator(query);
    }//<AS20161031> End
    public void execute(Database.BatchableContext info, List<ConstructionPts__CP_Contact__c> cpContactList){
        //<AS20170428> start
        BI_CPUtil.CPSF_leadTrigPass= true;
        //<AS20170428> End
        BI_CPContactHandler cpContactHandler = new BI_CPContactHandler();
        cpContactHandler.onAfterUpdateCPContact(cpContactList);
    }
    // execute consecutive batch
    public void finish(Database.BatchableContext info){
    }

}
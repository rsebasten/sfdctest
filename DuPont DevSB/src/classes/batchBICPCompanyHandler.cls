/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Updating company metadata on lead

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
Modification: Added new field in query and added boolean variable to bypass the trigger
***************************************************************************************************/
global class batchBICPCompanyHandler implements Database.Batchable<sObject>,Database.Stateful{
    
    public static final Integer batchJobSize = Integer.valueOf(Label.CPSF_Dodge_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_CPSF_Batch_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    //<AS20161220> Start
    public Set<Id> companyIds = new Set<Id>();
    public Set<Id> contactIds = new Set<Id>();
    
    public batchBICPCompanyHandler(Set<Id> companyId,Set<Id> contactId){
        companyIds.addAll(companyId);
        contactIds.addAll(contactId);     
    }
    //<AS20161220> End
    
    //<AS20161031> Start
    public Database.QueryLocator start(Database.BatchableContext BC){       
        //<AS20170428>
        String query = 'SELECT Name,ConstructionPts__Company_key__c,ConstructionPts__Address__c,ConstructionPts__City__c,ConstructionPts__State__c,ConstructionPts__Zipcode__c,ConstructionPts__Country__c,ConstructionPts__County__c,LastModifiedDate FROM ConstructionPts__CP_Company__c Where Id IN : companyIds';//<AS20161220>
        return Database.getQueryLocator(query);
    }//<AS20161031> End
    public void execute(Database.BatchableContext info, List<ConstructionPts__CP_Company__c> cpCompanyList){
        //<AS20170428> start
        BI_CPUtil.CPSF_leadTrigPass= true;
        //<AS20170428> End
        BI_CPCompanyHandler cpCompanyHandler = new BI_CPCompanyHandler();
        cpCompanyHandler.onAfterUpdateCPCompany(cpCompanyList);
    }
    // execute consecutive batch
    public void finish(Database.BatchableContext info){
        batchBICPContactHandler batch = new batchBICPContactHandler(contactIds);//<AS20161220>
        Database.executeBatch(batch,batchJobSize);//<AS20161220>
    }

}
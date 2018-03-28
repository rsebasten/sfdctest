/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Create new Lead based on newly inserted Dodge Roles, and
                Update Lead based on updated Dodge Roles,
                by combination of CP Project's Dodge Report Number, Dodge Company's Dodge Company Id,
                Dodge Role Type's RoleTypeID and Dodge Contact's ContactID which is related to Legacy Lead ID of Lead
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
Modification: boolean variable to bypass the trigger

***************************************************************************************************/
global class batchBICPRoleHandler implements Database.Batchable<sObject>,Database.Stateful{
    
    public static final Integer batchJobSize = Integer.valueOf(Label.CPSF_Dodge_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_CPSF_Batch_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    //<AS20161220> Start
    Set<Id> setCompanyIds = new Set<Id>();
    Set<Id> setContactIds = new Set<Id>();
    //<AS20161220> End  
    
    //<AS20161031> Start
    public Database.QueryLocator start(Database.BatchableContext BC){       
        String query = 'Select Id, Name, ConstructionPts__CP_Company__c, ConstructionPts__CP_Contact__c, ConstructionPts__CP_Project__c, ConstructionPts__CP_Role_Type__c, ConstructionPts__RoleProjectID__c FROM ConstructionPts__CP_Roles__c where lastmodifieddate>=:Lastmodifiedfilter And ConstructionPts__CP_Project__r.ConstructionPts__SFDC_Upload_Time__c >=:Lastmodifiedfilter';
        return Database.getQueryLocator(query);
    }//<AS20161031> End
    public void execute(Database.BatchableContext info, List<ConstructionPts__CP_Roles__c> cpRoleList){
        
        
        //<AS20170428> start
        BI_CPUtil.CPSF_leadTrigPass= true;
        //<AS20170428> End
        
        BI_CPRoleHandler cpRoleHandler = new BI_CPRoleHandler();
  
        //<AS20161220> Start
        for(ConstructionPts__CP_Roles__c role : cpRoleList){
            setCompanyIds.add(role.ConstructionPts__CP_Company__c);
            setContactIds.add(role.ConstructionPts__CP_Contact__c);
        }
        //<AS20161220> End        
        cpRoleHandler.onAfterInsertUpdateCPRole(cpRoleList);
    }
    // execute consecutive batch
    public void finish(Database.BatchableContext info){
        batchBICPCompanyHandler batch = new batchBICPCompanyHandler(setCompanyIds,setContactIds);//<AS20161220>
        Database.executeBatch(batch,batchJobSize);//<AS20161220>
    }

}
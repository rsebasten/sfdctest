/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Create and update External Initiative based on newly inserted CP Project

<AS20161220>
Modified By: Arjun Sharma
Modification Date: 20-Dec-2016
Modification: Change filter criteria for query


<AS20170428>
Modified By: Arjun Sharma
Modification Date: 28-Apr-2017
Modification: Changes the Batch size of Lead creation

***************************************************************************************************/
global class batchBICPProject implements Database.Batchable<sObject>{
    //<AS20170428>start
    //public static final Integer batchJobSize = Integer.valueOf(Label.
    public static final Integer batchJobSize = Integer.valueOf(Label.CPSF_Dodge_Role_Batch_Size);
     //<AS20170428>End
    public static Integer batchFilter = Integer.valueOf(Label.CIC_CPSF_Batch_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    public Database.QueryLocator start(Database.BatchableContext BC){       
        String query = 'SELECT Name,ConstructionPts__Bid_Date__c,ConstructionPts__City__c,ConstructionPts__Country__c,ConstructionPts__County__c,ConstructionPts__Address__c,ConstructionPts__Stage255__c,ConstructionPts__Features_Info__c,ConstructionPts__Search_Names__c,ConstructionPts__Report_Number__c,ConstructionPts__Report_Version__c,ConstructionPts__Project_Type__c,ConstructionPts__Project_Report_URL__c,ConstructionPts__Stories_above__c,ConstructionPts__Stories_below__c,ConstructionPts__Total_Sq_Ft__c,LastModifiedDate,ConstructionPts__Market_Segment_Name__c,ConstructionPts__Type_Of_Work__c,ConstructionPts__Ownership__c,ConstructionPts__Spec_Alerts__c,ConstructionPts__Structural__c,ConstructionPts__State__c,ConstructionPts__Value__c,ConstructionPts__Zipcode__c,ConstructionPts__Status__c FROM ConstructionPts__CP_Project__c where ConstructionPts__SFDC_Upload_Time__c >=:Lastmodifiedfilter';//<AS20161220>
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext info, List<ConstructionPts__CP_Project__c> scope){
        BI_CPProjectHandler cpProjectHandler = new BI_CPProjectHandler();
        cpProjectHandler.onAfterInsertUpdateCPProject(scope);
    }
    // execute consecutive batch
    public void finish(Database.BatchableContext info){
       Database.executeBatch(new batchBICPRoleHandler(),batchJobSize);
    }

}
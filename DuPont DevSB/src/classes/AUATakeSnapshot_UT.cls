/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Unit Test for AUATakeSnapshot
********************************************************************************/
@isTest
public class AUATakeSnapshot_UT {
    public static testMethod void LoadData() {
        CRM_IT_Project__c crmProject = new CRM_IT_Project__c(name='Test CRM Project');
        insert crmProject;
        User_Access_Review__c uar = new User_Access_Review__c(name='Test User Access Review Audit 2016',Process_Owner__c=UserInfo.getUserId(), CRM_IT_Project__c=crmProject.id, Start_Date__c=Date.today());    
        Insert uar;
        executeTest(uar);
        
        
    }
    
    public static  void executeTest(User_Access_Review__c uar) {
        Test.startTest();
        AUATakeSnapshot.startSnapshotProcess(uar.id);
        Test.stopTest();
    }
}
/***********************************************************************************************
Email :rohitkumar.saini@tcs.com
Date :2015/1/19
Description : Test class for batch_jobMonitoring class
 ***********************************************************************************************/
@isTest

public class batch_jobMonitoring_UT {
  public static testMethod void test_Unitcase1() {

      /*IssueAutoAssignmentSettings__c issueAutoAssign = new IssueAutoAssignmentSettings__c();
      issueAutoAssign.Value__c= '2';
      issueAutoAssign.Name = 'AssociateHoursEndingShift';
      insert issueAutoAssign;*/
      
        test.startTest();
         batch_jobMonitoring hcu = new batch_jobMonitoring();
         String sch = '00 08 19 19 1 ? 2019';       
        String jobID = system.schedule('batch job monitoriig', sch, hcu);

         test.stopTest();
    }   
    
    
}
/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:   UT for utilSchedule
********************************************************************************/
@isTest
private class utilSchedule_UT {

	static testMethod void test() {
		
		insert new ScheduledApex__c(name='testJob1', cronExpr__c='0 0 0 * * ?', ClassName__c='sched_RefreshMetadata', isActive__c=true);
		insert new ScheduledApex__c(name='testJob2', cronExpr__c='0 0 0 * * ?', ClassName__c='invalidClass', isActive__c=true);
		
		
		system.assertEquals(utilSchedule.isApexScheduleDisabled, false); //always false for UT
		utilSchedule.abortApexJobs();
		utilSchedule.scheduleApexJobs();
		utilSchedule.abortApexJobs();
		system.debug(utilSchedule.getSchedExprByDate(datetime.Now()));
		
		Test.startTest();
		utilSchedule.abortAllJobs();
		Test.stopTest();
	}  
 	
}
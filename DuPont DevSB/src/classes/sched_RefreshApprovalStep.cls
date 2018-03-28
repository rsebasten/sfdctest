/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com

Description:  Schedulable class for ProcessStep

TES20120227: added utilSchedule.isApexScheduleDisabled
********************************************************************************/
global class sched_RefreshApprovalStep implements Schedulable {
    
    global void execute(SchedulableContext SC) {
    	if (!utilSchedule.isApexScheduleDisabled)
        	Database.executeBatch(new batch_RefreshApprovalStep(),200);
    }   
	static testMethod void testSchedule() {
        
        Test.startTest();
        system.schedule('TestSchedule','0 0 1 * * ?',new sched_RefreshApprovalStep());
        Test.stopTest();
    } 	
}
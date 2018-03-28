/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Schedulable for: batchViaTech_getOrderRequest 

	system.schedule('ViaTech_getOrderRequest 7AM', '0 0 7 * * ?', new schedViaTech_getOrderRequest());
	system.schedule('ViaTech_getOrderRequest 9AM', '0 0 9 * * ?', new schedViaTech_getOrderRequest());
	system.schedule('ViaTech_getOrderRequest 11AM', '0 0 11 * * ?', new schedViaTech_getOrderRequest());
	system.schedule('ViaTech_getOrderRequest 1PM', '0 0 13 * * ?', new schedViaTech_getOrderRequest());
	
TES20130603 - 	added utilSchedule.isApexScheduleDisabled check
********************************************************************************/
global class schedViaTech_getOrderRequest implements Schedulable {
    
    global void execute(SchedulableContext SC) {
    	
    	if (!utilSchedule.isApexScheduleDisabled) {
	        Date StartDT=Date.Today().addDays(-30);
	        Date EndDT=Date.Today().addDays(1);
	        batchViaTech_getOrderRequest b = new batchViaTech_getOrderRequest(StartDT,EndDT); 
	        database.executeBatch(b,1);
    	}
    }
}
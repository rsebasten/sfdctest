/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Schedulable class for Demand SnapShot
********************************************************************************/
global class schedDemandSnapShot implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		if (!utilSchedule.isApexScheduleDisabled)
        	Database.executeBatch(new batchDemandSnapShot(),200);
    }
 	
}
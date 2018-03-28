/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Schedulable class for Metadata Logic

TES20120227: added utilSchedule.isApexScheduleDisabled
********************************************************************************/
global class sched_RefreshMetaDataLogic implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		if (!utilSchedule.isApexScheduleDisabled)
        	Database.executeBatch(new batchRefreshMetadataLogic(),50);
    }	
	
}
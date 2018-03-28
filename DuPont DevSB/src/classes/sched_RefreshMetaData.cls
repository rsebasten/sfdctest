/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Schedulable class for Metadata database info

Caveates:  because the session is not avail data obtained from the 
	Metadata API is not avail such as:
	new forceId,  detecting API names changes via ForceId
	Metadata Layout info (Page Layout,Recordtype and picklist relationships)

TES20120227: added utilSchedule.isApexScheduleDisabled
********************************************************************************/
global class sched_RefreshMetaData implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		if (!utilSchedule.isApexScheduleDisabled)
        	Database.executeBatch(new batchRefreshMetadata(),1);
    }

}
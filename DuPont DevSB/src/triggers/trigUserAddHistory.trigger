/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  This trigger adds the User change history to UserHistory__c

Caveates:
 Needed to set the API to version 12.0 otherwise returns: MIXED_DML_OPERATION, DML operation on setup 
 object is not permitted after you have updated a non-setup object (or vice versa) on changes 
 to UserRoleId
 
 Changes to fields that startwith: UserPermissions... or UserPreferences... are not detected
 
 Author: TCS COO 
Email: niha.saha@tcs.com
Description: Logic has been written in TriggerHandlerBase class "ctrlRemoveDeactUserLisence" on 04052016
change log:
    1. RS03132016: Automation for Service Max license removal whenever user is de-activated
********************************************************************************/
trigger trigUserAddHistory on User (after insert, after update) {
 if(System.Label.Trigger_On_Off  == 'On'){  
        //Modified on 05052016 by Niha Saha
       
        //if(Trigger.ISUPDATE){
        //   ctrlRemoveDeactUserLisence.Userdeactivation_AfterUpdate(trigger.new);
        //}
        
        //Modified on 05052016 by Niha Saha
        if (Trigger.isInsert)
            UserHistory.User_AfterInsert(trigger.new);

        else if (Trigger.isUpdate)
            UserHistory.User_AfterUpdate(trigger.old, trigger.new);
 }
}
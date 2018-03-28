/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  One way sync from Campaign -> SiteObject
********************************************************************************/

trigger trigCampSubCenter on Campaign (before delete, after insert, after update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        if (Trigger.isAfter && ( Trigger.isInsert || Trigger.isUpdate )) {
            SubscriptionCenter.Campaign_AfterUpsert(Trigger.newMap);
        }   
    
        if (Trigger.isBefore && Trigger.isDelete ) {
            SubscriptionCenter.Campaign_BeforeDelete(Trigger.oldMap);   
        }   
    }
}
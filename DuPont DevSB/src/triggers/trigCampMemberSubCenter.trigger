/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  CampaignMember (from a List) -> SiteObjectValue

TESII20100203 - Allow INSYNC After Inserts,  otherwise second sub-batch does not get processed
********************************************************************************/
trigger trigCampMemberSubCenter on CampaignMember (before insert, before update, after insert, after update) {
 
    system.debug('DISABLE_CM_UPSERT_TRIGGER:'+SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER);
    if(System.Label.Trigger_On_Off  == 'On'){   
        if (Trigger.isBefore) {
            if (Trigger.isUpdate || Trigger.isInsert ) {
                system.debug('Refresh SubscriptionID__c...');
                SubscriptionCenter.CampaignMember_BeforeUpsert(Trigger.new);
            }
        }
        
        if (Trigger.isAfter && (! SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER)) {
                SubscriptionCenter.CampaignMember_AfterUpsert(Trigger.newMap);
        }
    }
}
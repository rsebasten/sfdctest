/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger used to copy changes from SiteObjectValue__c over to the 

* TESII20100510: SF2SF Disabled (as per email from Floris)
********************************************************************************/
trigger trigSOVSyncCampMembers on SiteObjectValue__c (after insert, after update) {
    

        integer FRESH_LEAD_TIME = 5;  //number of minutes til lead goes stale an is no longer search and related to a subscription
    
        //Sync the SOVs across Dupont Instances
       //TESII20100510: SubscriptionCenter.S2S_SOV(Trigger.new);
  if(System.Label.Trigger_On_Off  == 'On'){  

    if (Trigger.isAfter && (!SubscriptionCenter.DISABLE_SOV_UPSERT_TRIGGER)) {
     
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //MAP of SOVS for This Org by SubscriptionId and MAP LeadandContactIds by email
        //CampaignMember.SubscriptionId = SiteObjectValue__c.ExternalId = ORGID+CampaignID+email
        //FRESH Lead entered within FRESH_LEAD_TIME
        //////////////////////////////////////////////////////////////////////////////////////////////
        MAP<string,SiteObjectValue__c> SOVsInOrg        = new MAP<string,SiteObjectValue__c>();
        SET<string> emailsInOrg                         = new SET<string>();
        MAP<string,SET<string>> FreshLeadIds            = new MAP<string,SET<string>>();
       // MAP<string,SET<string>> LeadIds                 = new MAP<string,SET<string>>();
        MAP<string,SET<string>> contactIds              = new MAP<string,SET<string>>();
        
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //GET all the SOV relating to LIST in this ORG and map by SubscriptionId (SiteObjectValue__c.ExternalId)
        //also get a unique set of emails from the SOVs
        //Populates SOVsInOrg and EmailsInOrg
        ///////////////////////////////////////////////////////////////////////////////////////////////
        for (SiteObjectValue__c sov :Trigger.new) {
            
            if (sov.email__c !=null) {
                if ( sov.externalId__c.startsWith( UserInfo.getOrganizationId().substring(0,15) ) ) {
                    SOVsInOrg.put(sov.ExternalId__c,sov);
                    emailsInOrg.add(sov.email__c.toLowerCase());
                }
            }   
        }
        
        
        if (emailsInOrg.size()>0) {
            
            ///////////////////////////////////////////////////////////////////////////////////////////////
            // Get Fresh leads In Org by Email
            ///////////////////////////////////////////////////////////////////////////////////////////////
            for (Lead l : [
                    Select Id, email, createddate 
                    from Lead 
                    where CreatedDate > :DateTime.now().addMinutes((FRESH_LEAD_TIME*-1))
                        AND email in: emailsInOrg 
                        ]) {
                string em=l.email;
                if (! FreshLeadIds.containskey(em) )
                    FreshLeadIds.put(em,new SET<string>());
                FreshLeadIds.get(em).add(l.id);
            }
        
            ///////////////////////////////////////////////////////////////////////////////////////////////
            //Get all Contact in org 
            ///////////////////////////////////////////////////////////////////////////////////////////////
            for (Contact c : [
                    Select Id, email 
                    from Contact 
                    WHERE Id IN (   SELECT ContactId 
                                    FROM CampaignMember 
                                    WHERE Campaign.RecordTypeId=:SubscriptionCenter.RTYPE_CAMP_SUBLIST 
                                ) 
                    AND email in: emailsInOrg 
            ]) {
                string em=c.email;
                if (! contactIds.containskey(em) )
                    contactIds.put(em,new SET<string>());
                contactIds.get(em).add(c.id);
            }
        
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //MAP Campaign Members by SubscriptionIds
        ///////////////////////////////////////////////////////////////////////////////////////////////
        Map<string,LIST<CampaignMember>> cmembers = new Map<string,LIST<CampaignMember>>();
        for (CampaignMember cm : [
            Select Id, LeadId, ContactId, SubscriptionId__c, status, campaignId
            from CampaignMember
            where ( SubscriptionId__c in :SOVsInOrg.KeySet() )
            FOR UPDATE
            ]) {
                if (! cmembers.containsKey(cm.SubscriptionId__c))
                    cmembers.put(cm.SubscriptionId__c, new LIST<CampaignMember>());
                cmembers.get(cm.SubscriptionId__c).add(cm);
        }
        
        
        system.debug('-------SOVs.KeySet()------>'+SOVsInOrg.KeySet());
        system.debug('-------cmembers------>'+cmembers);
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //Populate the cmembersToUpsert
        ///////////////////////////////////////////////////////////////////////////////////////////////
        MAP<string,Lead> newLeadMap = new MAP<string,Lead>();
        MAP<string,CampaignMember> cmembersToUpsert = new MAP<string,CampaignMember>();
        MAP<string,CampaignMember> cmembersToUpdate = new MAP<string,CampaignMember>();
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //loop each SOV in this Org
        ///////////////////////////////////////////////////////////////////////////////////////////////
        for (SiteObjectValue__c sov : SOVsInOrg.values()) {
            string em=sov.email__c.toLowerCase();
            string campid=sov.ExternalId__c.substring(15,30);
    
            if (FreshLeadIds.containskey(em) || cmembers.containsKey(sov.ExternalId__c)) {
    
                //SET<string> MemberIds = new SET<string>();
                
                ////////////////////////////////////////////////////////////////
                //if a campaign Members already exist for this email
                ////////////////////////////////////////////////////////////////
                if (cmembers.containsKey(sov.ExternalId__c)) {
                    //update each campaign member to new status
                    for (CampaignMember cm : cmembers.get(sov.ExternalId__c)) {
                        cm.Status=sov.value__c;
                        //cm.LastUpdatedLocation__c=sov.LastUpdatedLocation__c;
                        if (cm.ContactId!=null) {
                             string uid=String.valueOf(cm.CampaignId).substring(0,15)+String.valueOf(cm.ContactId).substring(0,15);
                             cmembersToUpdate.put(uid,cm);
                            // MemberIds.add(cm.ContactId);
                        }
                        else if (cm.LeadId!=null) {
                            string uid=String.valueOf(cm.CampaignId).substring(0,15)+String.valueOf(cm.LeadId).substring(0,15);
                            cmembersToUpdate.put(uid,cm);
                           // MemberIds.add(cm.LeadId);
                        }
                    }
                    system.debug('---These Campaign Members already exist for this email:' + cmembers.get(sov.ExternalId__c));
                }
                
                
                ////////////////////////////////////////////////////////////////
                //Add any fresh leads (leads added in last 5 min)
                ////////////////////////////////////////////////////////////////
                if (FreshLeadIds.containskey(em)) {
                        MAP<string,CampaignMember> members = SubscriptionCenter.SOVtoCampaignMembers(sov,FreshLeadIds.get(em));
                        cmembersToUpsert.putAll(members);
                        system.debug('---fresh leads being added:' + FreshLeadIds.get(em));
                }
                
                
            }
                
            else {
                ////////////////////////////////////////////////////////////////
                //No Fresh leads or Existing Members....
                ////////////////////////////////////////////////////////////////
                //Add Contacts If any
                if (contactIds.containskey(em)) {
                    MAP<string,CampaignMember> members = SubscriptionCenter.SOVtoCampaignMembers(sov,contactIds.get(em));
                    cmembersToUpsert.putAll(members);
                    system.debug('---No Fresh leads or Existing Members....Contacts being added:' + contactIds.get(em));
                }
                else {
                    ////////////////////////////////////////////////////////////////
                    //create new lead and add to cmembersToUpsert
                    //all we know about this lead is the email address,  so its the lastname and company
                    ////////////////////////////////////////////////////////////////
                    if (! newLeadMap.containsKey(em))  
                        newLeadMap.put(sov.email__c,new Lead(lastname=em, company=em, email=em));
                    // create a new lead
                    CampaignMember cm = new CampaignMember();
                    //cm.LastUpdatedLocation__c=sov.LastUpdatedLocation__c;
                    cm.Status=sov.value__c;
                    cm.CampaignId=sov.ExternalId__c.substring(15,30);
                    cm.Lead=newLeadMap.get(em);
                    cmembersToUpsert.put(sov.ExternalId__c.substring(15,30)+em,cm);
                    system.debug('No email match creating a dummy Lead.   ->'+em);
                }
            }
        }
        
        system.debug('----newLeadMap----------->'+newLeadMap);
    
            
        ////////////////////////////////////////////////////////////////
        //Add any new Leads if needed
        ////////////////////////////////////////////////////////////////        
        if (newLeadMap.size()>0) {
            insert newLeadMap.values();
        }

    
        ////////////////////////////////////////////////////////////////
        //Upsert the Member records
        ////////////////////////////////////////////////////////////////    
        if (cmembersToUpsert.size()>0 || cmembersToUpdate.size()>0) {
            //Map the LeadId of NewLeads
            for ( campaignmember cm : cmembersToUpsert.values()) {
                system.debug('----cm.Lead.id----------->'+cm.Lead.id);
                if (cm.id==null && cm.Leadid==null && newLeadMap.containskey(cm.Lead.email) )
                    cm.LeadId=newLeadMap.get(cm.Lead.email).id;
            }
            //Merge the update and inserts...they need to be seperated cause
            //updates need to overright matching inserts to prevent duplicate record insertion errors
            system.debug('----cmembersToUpdate----------->'+cmembersToUpdate);
            system.debug('----cmembersToInsert----------->'+cmembersToUpsert);
            cmembersToUpsert.putAll(cmembersToUpdate);
            system.debug('----cmembersToUpsert----------->'+cmembersToUpsert);
            //try { 
                SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER=true;
                upsert cmembersToUpsert.values();
                SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER=false;
            //}
            //catch(DmlException dmlEx) {
            //  system.debug('caucht DML Exception: '+dmlEx);
            //}
        }
    }//isAfter    

 }  
}//end trigger
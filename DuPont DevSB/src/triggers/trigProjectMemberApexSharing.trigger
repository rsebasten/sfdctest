/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Date: 26th Dec 2011
Description: Granting R/W access through Apex Sharing on the CRM IT Project Records 
if the Access field on CRM IT Project Member Record is set to R/W 
********************************************************************************/
trigger trigProjectMemberApexSharing on Project_Member__c(after insert,after update,before delete) {
     if(System.Label.Trigger_On_Off  == 'On'){  
         ProjectMemberHandler h = new ProjectMemberHandler();
         h.onTrigger();
     }
}
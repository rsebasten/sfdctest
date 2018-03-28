/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Primary trigger for Segmentation 
********************************************************************************/
trigger trigReason on Reason__c (after insert, after update, before insert, before update) {
  if(System.Label.Trigger_On_Off  == 'On'){  
    if (trigger.isBefore) {
        Reason.inherit(Trigger.new);  
    }
    if (trigger.isAfter) {
        if (! Trigger.isDelete) {
                //update the siblings: will need to monitor and may need to move to a batch process (async)
                //this will cause recursion and could potentially cause a stack depth error 
                //or a update limit (currently (10k per execution))
                update [Select Id from Reason__c where parent__c in: Trigger.new];
                update [Select Id from Reason__c where primaryReason__c in: Trigger.new];
        }
    }
  }
}
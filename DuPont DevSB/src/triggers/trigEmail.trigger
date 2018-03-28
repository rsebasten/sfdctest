/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  trigger for Email
********************************************************************************/
trigger trigEmail on Email__c (after insert, after update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        EmailHandler h = new EmailHandler();
        h.onTrigger();  
    }
}
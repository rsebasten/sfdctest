/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Divya Ramakrishnaiah
Email: divya.ramakrishnaiah@usa.dupont.com
Description:  Core trigger for External Initiative
*******************************************************************************/
trigger trigExternalInitiative on External_Initiative__c(after insert, before update, after update){
    if(System.Label.Trigger_On_Off  == 'On'){   
        ExternalInitiativeHandler extInitHandler = new ExternalInitiativeHandler();
        extInitHandler.onTrigger();
    }
}
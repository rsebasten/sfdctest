/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Description:  Trigger to generate Sample name based on active ingredient,country and date
Modifications: <TJ20151123> Added Event Before Update.
 *****************************************************************************/
//<TJ20151123> Added Event Before Update.
trigger trigSample on Trademark_Abuse_Sample__c (before Insert,before Update) {
    
    if(System.Label.Trigger_On_Off  == 'On'){  
        SampleHandler sampleHandlerInstance=new SampleHandler(); 
        sampleHandlerInstance.onTrigger();
    }
}
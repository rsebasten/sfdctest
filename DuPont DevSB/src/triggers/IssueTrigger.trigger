/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Niha Saha
Email: niha.saha@tcs.com
Description:  Core trigger In Issue Object
NS20160303 - For Duration of Each Status In Hours of Issue Object 
********************************************************************************/



trigger IssueTrigger on Issue__c (before insert, before update) {
    if(label.Disable_Triggers == 'No'){
    if(Trigger.isBefore && Trigger.IsInsert){
        IssueTriggerHandler2.beforeInsert(Trigger.new);
    }else if(Trigger.isBefore && Trigger.IsUpdate){
        IssueTriggerHandler2.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    } 

}
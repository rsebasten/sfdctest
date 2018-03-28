/*******************************************************************************
Author: krishnaveni Duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  Trigger for BAC Solution
********************************************************************************/

trigger CtrlBACSolutionTrigger on Body_Armor_Solution__c (after insert, after update) {
    
  public static Boolean sFlag = false;    
  if(System.Label.Trigger_On_Off  == 'On'){   
    if(trigger.isAfter){
        Set<Id> bacIds = new Set<Id>();
        Set<Id> solIds = new Set<Id>();
        
        for(Body_Armor_Solution__c bacS : trigger.new){
            bacIds.add(bacS.BA_Configuration__c);
            solIds.add(bacS.Id);
        }    
        if(trigger.isInsert){
            sFlag = true;
            CtrlBACSolutionTriggerHandler.OnAfterInsertorUpdate(bacIds,solIds,sFlag);
        }
        if(trigger.isUpdate){  
           sFlag = false;
           CtrlBACSolutionTriggerHandler.OnAfterInsertorUpdate(bacIds,solIds,sFlag);       
        }
    }
  }
}
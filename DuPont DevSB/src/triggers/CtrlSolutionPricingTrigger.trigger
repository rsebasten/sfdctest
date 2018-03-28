/*******************************************************************************
Author: krishnaveni Duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  Trigger for Solution Pricing
********************************************************************************/

trigger CtrlSolutionPricingTrigger on Solution_Pricing__c(after insert, after update) {
    
  public static Boolean spFlag = false;      
  if(System.Label.Trigger_On_Off  == 'On'){     
    if(trigger.isAfter){
        Set<Id> spIds = new Set<Id>();
        for(Solution_Pricing__c bacSP : trigger.new){
            spIds.add(bacSP.BA_Configuration__c);
        }    
        if(trigger.isInsert){
            spFlag = true;
            CtrlSolutionPricingTriggerHandler.OnAfterInsertorUpdate(spIds,spFlag);
        }
        if(trigger.isUpdate){  
            spFlag = false;
            CtrlSolutionPricingTriggerHandler.OnAfterInsertorUpdate(spIds,spFlag);       
        }
    }
  }
}
/*******************************************************************************
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  Trigger for Functional Design Requirement.
 ********************************************************************************/

trigger ctrlFDRTrigger on Functional_Design_Requirement__c (after insert, after update) {
    
  public static Boolean fdrFlag = false;  
  if(System.Label.Trigger_On_Off  == 'On'){     
    if(trigger.isAfter){
        Set<Id> bacIds = new Set<Id>();
        Set<Id> fdrIds = new Set<Id>();
        for(Functional_Design_Requirement__c fdrRec : trigger.new){
            bacIds.add(fdrRec.BA_Configuration__c);
            fdrIds.add(fdrRec.Id);
        }    
        if(trigger.isInsert){
            fdrFlag = true;
            CtrlFDRTriggerHandler.OnAfterInsertorUpdate(bacIds,fdrIds,fdrFlag); 
        }
        else if(trigger.isUpdate){ 
            fdrFlag = false;
            CtrlFDRTriggerHandler.OnAfterInsertorUpdate(bacIds,fdrIds,fdrFlag);       
        }
    }
  }
}
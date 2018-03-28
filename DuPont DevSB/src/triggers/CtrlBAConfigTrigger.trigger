/*******************************************************************************. 
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  Trigger for Team Member
********************************************************************************/
trigger CtrlBAConfigTrigger on BA_Configuration__c (after insert, after update) {
  
 public static Boolean bacFlag = false;  
 if(System.Label.Trigger_On_Off == 'On'){    
    if(trigger.isAfter){
        Set<Id> bacIds = new Set<Id>();
        Set<Id> sbacId= new Set<Id>();
        
        for(BA_Configuration__c bac : trigger.new){
            bacIds.add(bac.id);
        }
        if(trigger.isInsert){
          bacFlag = true;
          CtrlBAConfigTriggerHandler.OnAfterInsertorUpdate(bacIds,bacFlag);
        }
        else if(trigger.isUpdate){
            bacFlag = false;
            for(BA_Configuration__c bac : trigger.new){
                
                    BA_Configuration__c st = Trigger.oldMap.get(bac.id);
                    if (bac.Status__c <> null && bac.Status__c!= st.Status__c){ 
                        system.debug('---inside status change--'+bac.Status__c);
                      sbacId.add(bac.id);
                        CtrlBAConfigTriggerHandler.OnAfterStatusUpdate(sbacId,st.Status__c,bac.Status__c);    
                    }
                    if(bac.bac_Progress__c <> null && bac.bac_Progress__c != st.bac_Progress__c){
                        system.debug('---inside progress change--'+bac.bac_Progress__c);
                        sbacId.add(bac.id);
                        CtrlBAConfigTriggerHandler.OnAfterCampaignProgressUpdate(sbacId,st.bac_Progress__c,bac.bac_Progress__c);
                    }
                    /*else if( bac.Source_of_IT__c <> null && (bac.Source_of_IT__c != st.Source_of_IT__c && bac.Source_of_IT__c == st.Source_of_IT__c)){
                       system.debug('---inside source of it change--'+bac.Source_of_IT__c);
                     }*/
                    else{   
                        system.debug('---inside campaign change--');
                        bacIds.add(bac.id);
                        CtrlBAConfigTriggerHandler.OnAfterInsertorUpdate(bacIds,bacFlag);
                    }
                  
               
            }
        }
    }
  }
}
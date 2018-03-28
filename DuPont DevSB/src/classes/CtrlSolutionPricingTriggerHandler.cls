/*******************************************************************************
Author: krishnaveni Duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  Sends push notifications when solution pricing is inserted/updated
********************************************************************************/

public class CtrlSolutionPricingTriggerHandler{
    public static Set<String> users = new Set<String>();
    public static Messaging.PushNotification msg =  new Messaging.PushNotification();
    public static Map<String, Object> payload = new Map<String, Object>();
    public static List<BAC_Team_Member__c> tmList;
    public static List<Solution_Pricing__c> spList;
    
    public static void OnAfterInsertorUpdate(Set<ID> BACIds, Boolean Flag){
      	tmList=new List<BAC_Team_Member__c>();
        spList=new List<Solution_Pricing__c>();
       	Map<Id,Id> bacIdToTMIdMap=new Map<Id,Id>();
    	Map<Id,Solution_Pricing__c> bacIdToSPMap=new Map<Id,Solution_Pricing__c>();
        
        tmList = [select id, Team_Member_Name__r.name, Team_Member_Name__r.id,BA_Configuration__r.OwnerId from BAC_Team_Member__c 
                	where BA_Configuration__r.id in :(BACIds) and BA_Configuration__r.Active__c = true limit 1000];
      	spList = [select id,name,BA_Configuration__c,BA_Configuration__r.name,CreatedById,LastModifiedById,BA_Configuration__r.OwnerId from Solution_Pricing__c where  BA_Configuration__c in :(BACIds) and 
                	BA_Configuration__r.Active__c = true limit 1000];
        
        if(tmList.size()>0){
            for(BAC_Team_Member__c teamMember : tmList){
                users.add(String.valueOf(teamMember.Team_Member_Name__r.id));
            }
        }
        if(spList.size()>0){
            for(Solution_Pricing__c sp : spList){
                  users.add(String.valueOf(sp.BA_Configuration__r.OwnerId));    
              }
        }
        //insert records in push notification log object
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        
        if(spList.size()>0){
            for(Solution_Pricing__c sp : spList){
                if(Flag){
                    payload = Messaging.PushNotificationPayload.apple('Solution Package for "'+sp.BA_Configuration__r.name+'" is available ','', 1, null);
                }
                else{
                    payload = Messaging.PushNotificationPayload.apple('Solution Package for "'+sp.BA_Configuration__r.name+'" is now available ','', 1, null);
                }
                msg.setPayload(payload);
                System.debug(payload);    
                if(Users.size()>0){
                 msg.send('Kevlar_iPad',Users);  
                }
            } 
        }    
       
    }
}
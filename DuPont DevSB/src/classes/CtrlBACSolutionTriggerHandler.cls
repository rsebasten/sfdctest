/*******************************************************************************
Author: krishnaveni Duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  Send push notification when SAP/HAP solution is inserted/updated
********************************************************************************/

public class CtrlBACSolutionTriggerHandler{
    public static Set<String> users = new Set<String>();
    public static Messaging.PushNotification msg =  new Messaging.PushNotification();
    public static Map<String, Object> payload = new Map<String, Object>();
    public static List<BAC_Team_Member__c> tmList;
    public static List<Body_Armor_Solution__c> sList;
    
    public static void OnAfterInsertorUpdate(Set<ID> BACIds,Set<Id> solIds,Boolean Flag){
       	tmList=new List<BAC_Team_Member__c>();
        sList=new List<Body_Armor_Solution__c>();
        Map<Id,Id> bacIdToTMIdMap=new Map<Id,Id>();
    	Map<Id,Body_Armor_Solution__c> bacIdToBASMap=new Map<Id,Body_Armor_Solution__c>();
        
        tmList = [select id, Team_Member_Name__r.name, Team_Member_Name__r.id,BA_Configuration__r.OwnerId from BAC_Team_Member__c
                  where BA_Configuration__r.id in :(BACIds) and BA_Configuration__r.Active__c = true limit 1000]; 
       	sList = [select id,name,BA_Configuration__c,CreatedById,LastModifiedById,BA_Configuration__r.OwnerId,BA_Configuration__r.name,recordtype.developerName from Body_Armor_Solution__c 
                 where Id in :(solIds) and BA_Configuration__r.Active__c = true limit 1000];
        
        if(tmList.size()>0){
            for(BAC_Team_Member__c teamMember : tmList){
                users.add(String.valueOf(teamMember.Team_Member_Name__r.id));
              }
        }
        if(sList.size()>0){
            for(Body_Armor_Solution__c sp : sList){
                users.add(String.valueOf(sp.BA_Configuration__r.OwnerId));       
            }
        }
     	//insert records in push notification log object
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        
        if(sList.size()>0){
            for(Body_Armor_Solution__c s : sList){ 
                if(s.recordtype.developerName == 'SAP_Solution'){
                    if(Flag){
                        payload = Messaging.PushNotificationPayload.apple('SAP Solution for "'+s.BA_Configuration__r.name+'" is updated ','', 1, null);
                    }
                    else{
                        payload = Messaging.PushNotificationPayload.apple('SAP Solution for "'+s.BA_Configuration__r.name+'" is updated ','', 1, null);
                    }
                }    
                else if(s.recordtype.developerName == 'HAP_Solution') {
                    if(Flag){
                        payload = Messaging.PushNotificationPayload.apple('HAP Solution for "'+s.BA_Configuration__r.name+'" is updated ','', 1, null);
                    }
                    else{   
                        payload = Messaging.PushNotificationPayload.apple('HAP Solution for "'+s.BA_Configuration__r.name+'" is updated ','', 1, null);
                    }                
                }  
                msg.setPayload(payload);
                System.debug(payload); 
                if(users.size()>0){
                	msg.send('Kevlar_iPad',Users); 
                	}
            	}
            }  
        }
        
    }
/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  Sends push notifications when SAP/HAP design is inserted/updated
********************************************************************************/
public class CtrlFDRTriggerHandler{
    public static Set<String> users = new Set<String>();
    public static Messaging.PushNotification msg =  new Messaging.PushNotification();
    public static Map<String, Object> payload = new Map<String, Object>();
    public static List<BAC_Team_Member__c> tmList;
    public static List<Functional_Design_Requirement__c> fdrList;
    public static Integer limitcount;
    
    public static void OnAfterInsertorUpdate(Set<ID> BACIds,Set<Id> fdrIds,Boolean Flag){
       	fdrList=new List<Functional_Design_Requirement__c>();
        tmList=new List<BAC_Team_Member__c>();
        
        fdrList = [select id,name,BA_Configuration__c,BA_Configuration__r.OwnerId,BA_Configuration__r.name,recordtype.developerName 
                   	from Functional_Design_Requirement__c  
                  	where Id in :(fdrIds) and BA_Configuration__r.Active__c = true limit 1000]; 
       	tmList = [select id, Team_Member_Name__r.id from BAC_Team_Member__c 
                 	where BA_Configuration__r.id in :(BACIds) and BA_Configuration__r.Active__c = true limit 1000];
       	
        if(tmList.size()>0){
            for(BAC_Team_Member__c teamMember : tmList){
                users.add(String.valueOf(teamMember.Team_Member_Name__r.id));
            }
        }
        if(fdrList.size()>0){            
            for(Functional_Design_Requirement__c fdr : fdrList){
                users.add(String.valueOf(fdr.BA_Configuration__r.OwnerId));
            }
        }
        //insert records in push notification log object
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        
        for(Functional_Design_Requirement__c s: fdrList){
           if(s.recordtype.developerName == 'Body_Armor_Functional_Design'){
               if(Flag){
                   payload = Messaging.PushNotificationPayload.apple('SAP Design of "'+s.BA_Configuration__r.name+'" is accepted','', 1, null);
               }
               else{
                   payload = Messaging.PushNotificationPayload.apple('SAP Design of "'+s.BA_Configuration__r.name+'" is accepted','', 1, null);
               }
            }    
            else if(s.recordtype.developerName == 'HAP_Functional_Design') {
                 if(Flag){
                   payload = Messaging.PushNotificationPayload.apple('HAP Design of "'+s.BA_Configuration__r.name+'" is accepted','', 1, null);
                 }
                 else{
                   payload = Messaging.PushNotificationPayload.apple('HAP Design of "'+s.BA_Configuration__r.name+'" is accepted','', 1, null);
                 }                
            } 
            else if(s.recordtype.developerName == 'Other_Requirement') {
                 if(Flag){
                   payload = Messaging.PushNotificationPayload.apple('Performance Requirement of "'+s.BA_Configuration__r.name+'" is updated','', 1, null);
                 }
                 else{
                   payload = Messaging.PushNotificationPayload.apple('Performance Requirement of "'+s.BA_Configuration__r.name+'" is updated','', 1, null);
                 }                
            }  
            msg.setPayload(payload);
            System.debug(payload);
            if(users.size()>0){
            	msg.send('Kevlar_iPad',users); 
            }
            // limitcount = System.Limits.getMobilePushApexCalls();            
        }    
    } 
}
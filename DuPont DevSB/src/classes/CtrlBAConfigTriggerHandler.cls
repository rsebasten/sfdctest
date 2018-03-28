/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  Send push notification when campaign is inserted/updated
********************************************************************************/
public class CtrlBAConfigTriggerHandler{
    public static Set<String> users = new Set<String>();
    public static Messaging.PushNotification msg =  new Messaging.PushNotification();
    public static Map<String, Object> payload = new Map<String, Object>();
    public static List<BAC_Team_Member__c> tmList;
    public static List<BA_Configuration__c> bacList;
    
    public static void OnAfterInsertorUpdate(Set<ID> BACIds,Boolean Flag){
        createTMAndBACMap(BACIds);
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        for(BA_Configuration__c bac : bacList){
        	msg =  new Messaging.PushNotification();
            if(Flag){
                system.debug('Flag inside if--->'+Flag);
                payload = Messaging.PushNotificationPayload.apple('A new Campaign ' +bac.name+' is added in your list. Created by '+bac.CreatedBy.name,'default', 1, null);
            }
            else{
                //createPushNotificationLog(BACIds);
                system.debug('Flag inside else--->'+Flag);
                payload = Messaging.PushNotificationPayload.apple(bac.name+' has new updates','default', 1, null);
            }        
            msg.setPayload(payload);
            System.debug(payload);
         	msg.send('Kevlar_iPad',users);
         
        }    
    }  
   	public static void OnAfterStatusUpdate(Set<ID> BACIds,String oldStatus,String newStatus){
        createTMAndBACMap(BACIds);
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        for(BA_Configuration__c bac : bacList){
        	msg =  new Messaging.PushNotification();        
            payload = Messaging.PushNotificationPayload.apple('Status of '+ bac.name + ' changed from ' +oldStatus +' to '+newStatus+' by '+bac.LastModifiedBy.name,'', null, null);
            msg.setPayload(payload);
            System.debug(payload);
            msg.send('Kevlar_iPad',users);
            System.debug('Update Status = '+users);
        }  
         
  	}
	// To send notification on Campaign progress Update
		public static void OnAfterCampaignProgressUpdate(Set<ID> BACIds,String oldProgressStatus,String newProgressStatus){
        createTMAndBACMap(BACIds);
        CtrlKevlarSvcHelper.createPushNotificationLog(BACIds,tmList,users);
        for(BA_Configuration__c bac : bacList){
            msg =  new Messaging.PushNotification(); 
            if(oldProgressStatus != newProgressStatus && newProgressStatus.equalsIgnoreCase('Solutions Created'))
            {
                payload = Messaging.PushNotificationPayload.apple('Solution Package for '+ bac.name +' is available','',null, null);
            }
            else if(oldProgressStatus != newProgressStatus && newProgressStatus.equalsIgnoreCase('Specifications Generated'))
            {
                payload = Messaging.PushNotificationPayload.apple('Tender Specification for '+ bac.name +' is generated','',null,null);
            }
            else if(oldProgressStatus != newProgressStatus && newProgressStatus.equalsIgnoreCase('Commercials Generated'))
            {
                payload = Messaging.PushNotificationPayload.apple('Solution Pricing for '+ bac.name + ' is now available','',null,null);
            }
            else if(oldProgressStatus != newProgressStatus)	
            {
                payload = Messaging.PushNotificationPayload.apple('Campaign progress status of ' + bac.name + ' is changed to '+ newProgressStatus,'',null,null);
            }
			msg.setPayload(payload);
            System.debug(payload);
            msg.send('Kevlar_iPad',users);
            System.debug('Update Campaign Progress Status = '+users);
        }  
         
  	}
	
    public static void createTMAndBACMap(Set<Id> BACIds){
        tmList=new List<BAC_Team_Member__c>();
        bacList=new List<BA_Configuration__c>();
        tmList = [select id, Team_Member_Name__r.id from BAC_Team_Member__c where BA_Configuration__r.id in :(BACIds)
                 	AND BA_Configuration__r.Active__c = true limit 1000];  
      	bacList = [select id,name,CreatedBy.name,OwnerId,LastModifiedBy.name from BA_Configuration__c where id in :(BACIds) and Active__c = true 
                   limit 1000];
        if(tmList.size()>0){    
            for(BAC_Team_Member__c teamMember : tmList){
                users.add(String.valueOf(teamMember.Team_Member_Name__r.id));
            }
        }
        
        if(bacList.size()>0){
            for(BA_Configuration__c bac : bacList){
                users.add(String.valueOf(bac.OwnerId));            
            }
        }
        
     }   
    
    /*public static void createPushNotificationLog(Set<Id> BACIds){
        system.debug('logged in user : ' + UserInfo.getUserId() + UserInfo.getName());
        List<BA_Push_Notification_Log__c> bpnList=new List<BA_Push_Notification_Log__c>();
        Map<String,Boolean> pushMapFromUser=new Map<String,Boolean>();
        Map<String,Boolean> pushMapFromLog=new Map<String,Boolean>();
        Map<String,Id> userToTeamMemberMap=new Map<String,Id>();
        if(users.size()>0){
            users.remove(UserInfo.getUserId());
        }
        for(String s : users){
            String key=s+'/'+bacList[0].Id;
            pushMapFromUser.put(key, true);
        }
        bpnList=[select BA_Configuration__c,Push_Notification_Receiver__r.Team_Member_Name__c from BA_Push_Notification_Log__c where BA_Configuration__c IN: BACIds 
                 AND Push_Notification_Receiver__r.Team_Member_Name__c IN: users];
        if(bpnList.size()>0){
            for(BA_Push_Notification_Log__c bpn : bpnList){
                pushMapFromLog.put(bpn.Push_Notification_Receiver__r.Team_Member_Name__c+'/'+bpn.BA_Configuration__c, true);
            }
        }
        bpnList.clear();
        for(BAC_Team_Member__c tm : tmList){
            userToTeamMemberMap.put(tm.Team_Member_Name__r.id, tm.Id);
        }
        for(String s : pushMapFromUser.keySet()){
            if(!pushMapFromLog.containsKey(s)){
                BA_Push_Notification_Log__c bpn=new BA_Push_Notification_Log__c();
                List<String> temp=s.split('/');
                bpn.BA_Configuration__c=temp[1];
                bpn.Push_Notification_Receiver__c=userToTeamMemberMap.get(temp[0]);
                bpnList.add(bpn);
            }
        }
        if(bpnList.size()>0){
            insert bpnList;
        }
    }*/
}
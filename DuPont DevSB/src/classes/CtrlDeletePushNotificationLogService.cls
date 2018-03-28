/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class will delete PushNotificationLog when user will read the notification on his/her device
 ********************************************************************************/

@RestResource(urlMapping='/DeletePushNotificationLog/*')
global class CtrlDeletePushNotificationLogService {
	//wrapper class
    public class DeletePushNotificationWrapper{
        public String receiverID;
        public String bacConfigurationID;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String respMsg='';
        String prettyJson='';
        
        try{
           	DeletePushNotificationWrapper tWrap = (DeletePushNotificationWrapper) JSON.deserialize(req.requestBody.toString(), DeletePushNotificationWrapper.class);
            List<BA_Push_Notification_Log__c> pnLogList=new List<BA_Push_Notification_Log__c>([select Id from BA_Push_Notification_Log__c
                                                              where Push_Notification_Receiver__c=:tWrap.receiverID
                                                              and BA_Configuration__c=:tWrap.bacConfigurationID]);
            if(pnLogList.size()>0){
                respMsg='Push Notifications Map Deleted';
                delete pnLogList;
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),respMsg,'200', null, null, null,'null');         
            }
            else{
                respMsg='No Push Notifications Map found';
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('200'),respMsg,'200', null, null, null,'null');         
            }
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),null,null,'Delete operation failed!',null, '203',null);
        }
    }
}
/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class will send PushNotificationMap which will be used to show notification bell on campaign list home page
 ********************************************************************************/

@RestResource(urlMapping='/GetPushNotificationMap/*')
global class CtrlGetPushNotificationMapService {
	//wrapper class
    public class GetPushNotificationWrapper{
        public String receiverID;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String respMsg='';
        String prettyJson='';
        
        try{
            system.debug('req.requestBody.toString() : ' + req.requestBody.toString());
           	GetPushNotificationWrapper tWrap = (GetPushNotificationWrapper) JSON.deserialize(req.requestBody.toString(), GetPushNotificationWrapper.class);
           	respMsg='Push Notifications Map Sent';
            JsonGenerator gen=JSON.createGenerator(true);
            gen.writeStartObject();
            	gen.writeFieldName('records');//records array starts
            		gen.writeStartArray();
                        for(BA_Push_Notification_Log__c pn : [select IsNotificationRead__c,BA_Configuration__c, Push_Notification_Receiver__c 
                                                              from BA_Push_Notification_Log__c where 
                                                              Push_Notification_Receiver__c=:tWrap.receiverID]){
                             gen.writeStartObject();
                             	gen.writeStringField('receiverID', pn.Push_Notification_Receiver__c);
                                gen.writeStringField('bacConfigurationID', pn.BA_Configuration__c);
                                gen.writeBooleanField('isRead', pn.IsNotificationRead__c);
                             gen.writeEndObject();
                        }
            		gen.writeEndArray();//records array ends
            gen.writeEndObject();
            prettyJson=gen.getAsString();
            system.debug('prettyJson : ' + prettyJson);
           	return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),respMsg,'200', prettyJson, null, null,'null');         
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),null,null,'Data loading failed!',null, '203',null);
        }
    }
}
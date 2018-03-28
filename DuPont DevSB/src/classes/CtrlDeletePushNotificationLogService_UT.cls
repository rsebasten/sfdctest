/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class creates the data for CtrlDeletePushNotificationLogService test classes

 ********************************************************************************/
@isTest
private class CtrlDeletePushNotificationLogService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static List<Material_Master__c> materialMasterList = new List<Material_Master__c>();
    public static Material_Master__c mm1,mm3; 
    public static Profile  p;
    public static User user1;
    public static BA_Configuration__c bac;
    public static BA_Push_Notification_Log__c pushNotificationLog;
    static{
    m1 = testData_Kevlar_UT.getMessage1(); 
    respMsgList.add(m1);
    m3 = testData_Kevlar_UT.getMessage3();
    respMsgList.add(m3);  
    insert respMsgList;
    
    p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    
    user1 = new User();     
    user1.Username = 'testName1@abc.com';
    user1.LastName = 'name';
    user1.Alias = 'tn';
    user1.CommunityNickname = 'test';
    user1.TimeZoneSidKey = 'America/Chicago';
    user1.LocaleSidKey = 'en_US';
    user1.EmailEncodingKey = 'UTF-8';
    user1.ProfileId = p.id;
    user1.LanguageLocaleKey = 'en_US';
    user1.email = 'testName1@abc.com';
    user1.isActive = true;
    insert user1;
    
    bac = new BA_Configuration__c();
    bac.Name='abcd';
    bac.Active__c= true;
    bac.status__c='Tender in progress';
    bac.BAC_Progress__c='New Campaigns';
    bac.ownerid = user1.id;
    insert bac;
    
    pushNotificationLog = new BA_Push_Notification_Log__c();
    pushNotificationLog.BA_Configuration__c = bac.id;
    pushNotificationLog.IsNotificationRead__c = true;
    pushNotificationLog.Push_Notification_Receiver__c = user1.id;
    insert pushNotificationLog;
    
    }
 static testMethod void testDoPost() {
 
    String JsonMsg='{'+
    '"receiverID" : "'+user1.id+'",'+
    '"bacConfigurationID" : "'+bac.id+'"'+
    '}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeletePushNotificationLog';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDeletePushNotificationLogService testDeletePushLog=new CtrlDeletePushNotificationLogService();   
    CtrlDeletePushNotificationLogService.doPost(); 
    Test.stopTest();
 }
static testMethod void testDoPost1() {
 
    String JsonMsg='{}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeletePushNotificationLog';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDeletePushNotificationLogService testDeletePushLog=new CtrlDeletePushNotificationLogService();   
    CtrlDeletePushNotificationLogService.doPost(); 
    Test.stopTest();
 }
 static testMethod void testDoPost2() {
 
    String JsonMsg='{'+
    '"receiverID" : "'+user1.id+'",'+
    '"bacConfigurationID" : ""'+
    '}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeletePushNotificationLog';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDeletePushNotificationLogService testDeletePushLog=new CtrlDeletePushNotificationLogService();   
    CtrlDeletePushNotificationLogService.doPost(); 
    Test.stopTest();
 }
}
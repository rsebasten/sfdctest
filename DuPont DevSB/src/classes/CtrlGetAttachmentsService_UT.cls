/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlGetAttachmentsService.
 ********************************************************************************/
@isTest
private class CtrlGetAttachmentsService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static Profile  p;
    public static User user1;
    public static BA_Configuration__c bac;
    public static Attachment attach;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage22();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2);  
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
        
        bac = new BA_Configuration__c ();
        bac.Name='abcd';
        bac.Active__c= true;
        bac.status__c='Tender in progress';
        bac.BAC_Progress__c='New Campaigns';
        bac.ownerid = user1.id;
        insert bac;
        
        attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=bac.id;
        attach.Description = 'supportingdocs';
        insert attach;
    }
static testMethod void testDoPost() {
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+bac.id+'",'+
    '"description" : "supportingdocs"'+
    '}';
    
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetAttachment';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlGetAttachmentsService testGetAtch=new CtrlGetAttachmentsService();   
    CtrlGetAttachmentsService.doPost(); 
    Test.stopTest();
    }
static testMethod void testDoPost1() {
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+bac.id+'",'+
    '"description" : ""'+
    '}';
    
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetAttachment';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlGetAttachmentsService testGetAtch=new CtrlGetAttachmentsService();   
    CtrlGetAttachmentsService.doPost(); 
    Test.stopTest();
    }   
}
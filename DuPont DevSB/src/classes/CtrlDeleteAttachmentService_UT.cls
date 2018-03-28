/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlDeleteAttachmentService.
 ********************************************************************************/
@isTest
private class CtrlDeleteAttachmentService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;    
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);
        m2 = testData_Kevlar_UT.getMessage37(); 
        respMsgList.add(m2);     
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);  
        insert respMsgList;
        }
static testMethod void testDoPost() {
 // Adding dummy value   
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User user1 = new User();     
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
    
    BA_Configuration__c bac=new BA_Configuration__c ();
    bac.Name='abcd';
    bac.Active__c= true;
    bac.status__c='Tender in progress';
    bac.BAC_Progress__c='New Campaigns';
    bac.ownerid = user1.id;
    insert bac;
   
   String rdId2 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'SAP Solution'].Id; 
    
    Body_Armor_Solution__c bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = bac.id;
    bas.name='sap solution1';
    bas.RecordTypeId=rdId2;
    insert bas; 
    
    System.debug('Inserted bas: '+ bas.Id);

    Attachment attach=new Attachment();     
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId=bas.id;
    insert attach;
    System.debug('Inserted atatch: '+ attach.Id);   

    String JsonMsg='{'+
    '"fileIds" : ["'+attach.id+'"]'+       
    '}';    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeleteAttachment';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDeleteAttachmentService testTHR=new CtrlDeleteAttachmentService();   
    CtrlDeleteAttachmentService.doPost(); 
    Test.stopTest();
    }
  static testMethod void testDoPost1() { 
    Test.startTest();
    CtrlDeleteAttachmentService testTHR=new CtrlDeleteAttachmentService();   
    CtrlDeleteAttachmentService.doPost(); 
    Test.stopTest();
    
    }
   
}
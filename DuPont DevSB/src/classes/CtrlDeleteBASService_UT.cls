/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlDeleteBASService.
 ********************************************************************************/
@isTest
private class CtrlDeleteBASService_UT {
   
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static User user1;
    public static BA_Configuration__c dat1;
    public static Profile p;
    public static Body_Armor_Solution__c bas;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage24();
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
        
        dat1=new BA_Configuration__c ();
        dat1.Name='abcd';
        dat1.Active__c= true;
        dat1.status__c='Tender in progress';
        dat1.BAC_Progress__c='New Campaigns';
        dat1.ownerid = user1.id;
        insert dat1;     
        
        String rdId2 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'SAP Solution'].Id; 
        
        bas = new Body_Armor_Solution__c();
        bas.BA_Configuration__c = dat1.id;
        bas.name='sap solution1';
        bas.RecordTypeId=rdId2;
        insert bas; 
        
        System.debug('Inserted bas: '+ bas.Id);
    }
static testMethod void testDoPost() {
 // Adding dummy value  

    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+
    '"baSolutionID" : ["'+bas.id+'"]'+
    '}';
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeleteBAS';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;

    CtrlDeleteBASService testTHR=new CtrlDeleteBASService();   
    CtrlDeleteBASService.doPost(); 
    Test.stopTest();
    }
   static testMethod void testDoPost1() {

    String JsonMsg= '';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DeleteBAS';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDeleteBASService testTHR=new CtrlDeleteBASService();   
    CtrlDeleteBASService.doPost(); 
    Test.stopTest();
    }
}
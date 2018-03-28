/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlUpdateCampaignProgressService.
 ********************************************************************************/
@isTest
private class CtrlUpdateCampaignProgressService_UT {
public static Kevlar_Response_Messages__c m1,m2,m3;
public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
public static Profile  p;
public static User user1;
public static BA_Configuration__c dat1,bac;
static{
    m1 = testData_Kevlar_UT.getMessage1(); 
    respMsgList.add(m1);
    m2 = testData_Kevlar_UT.getMessage39();
    respMsgList.add(m2);  
    m3 = testData_Kevlar_UT.getMessage3();
    respMsgList.add(m3);  
    insert respMsgList;
 // Adding dummy value   
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
    
    dat1=new BA_Configuration__c();
    dat1.Name='abcd';
    dat1.Active__c= true;
    dat1.BAC_Progress__c='New Campaigns';
    dat1.ownerid = user1.id;
    insert dat1;
    bac=new BA_Configuration__c();
    bac.Name='abcd12234';
    bac.Active__c= true;
    bac.BAC_Progress__c='Pricing Completed';
    bac.ownerid = user1.id;
    insert bac;
    
}
static testMethod void testDoPost() { 
   

    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+  
    '"bacProgress" : "Specifications Generated"'+     
    '}';
    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateCampaignProgress';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlUpdateCampaignProgressService testTHR=new CtrlUpdateCampaignProgressService();   
    CtrlUpdateCampaignProgressService.doPost(); 
    Test.stopTest();
    }

    static testMethod void testDoPost2() { 
   

    String JsonMsg2='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+  
    '"bacProgress" : "Pricing Completed"'+     
    '}';
    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateCampaignProgress';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg2);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateCampaignProgressService testTHR=new CtrlUpdateCampaignProgressService();   
    CtrlUpdateCampaignProgressService.doPost(); 
    Test.stopTest();
    }
    static testMethod void testDoPost3() { 
   

    String JsonMsg3='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+  
    '"bacProgress" : "Solutions Created"'+     
    '}';
    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateCampaignProgress';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg3);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateCampaignProgressService testTHR=new CtrlUpdateCampaignProgressService();   
    CtrlUpdateCampaignProgressService.doPost(); 
    Test.stopTest();
    }
     static testMethod void testDoPost1() { 
   

    String JsonMsg1='{'+
    '"bacConfigurationID" : "'+bac.id+'",'+  
   '"bacProgress" : "Commercials Generated"'+     
    '}';
    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateCampaignProgress';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg1);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateCampaignProgressService testTHR=new CtrlUpdateCampaignProgressService();   
    CtrlUpdateCampaignProgressService.doPost(); 
    Test.stopTest();
    }
  static testMethod void testDoPost4() { 
  
   String JsonMsg3='';
    
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateCampaignProgress';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg3);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateCampaignProgressService testTHR=new CtrlUpdateCampaignProgressService();   
    CtrlUpdateCampaignProgressService.doPost(); 
    Test.stopTest();
    
    }
   
}
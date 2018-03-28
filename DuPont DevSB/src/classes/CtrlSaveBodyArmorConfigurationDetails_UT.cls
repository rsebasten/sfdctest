/*******************************************************************************
(C)2015
Author: Palavi Sharma
Email: Palavi.sharma3@tcs.com
Description:  This class tests the CtrlBodyArmorConfigurationDetails.
 ********************************************************************************/

@isTest
private class CtrlSaveBodyArmorConfigurationDetails_UT {
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> InsertList = new List<Kevlar_Response_Messages__c>(); 

static testMethod void testDoPost() {
    m1 = testData_Kevlar_UT.getMessage1(); 
    InsertList.add(m1);       
    m4 = testData_Kevlar_UT.getMessage11();
    InsertList.add(m4);
    m2 = testData_Kevlar_UT.getMessage2(); 
    InsertList.add(m2); 
    insert InsertList;
    
    // Adding dummy value   
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     List<User> userList = new List<User>();
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
     userList.add(user1);
      
     User user2 = new User();
     user2.Username = 'testName2@abc.com';
     user2.LastName = 'name2';
     user2.Alias = 'tn2';
     user2.CommunityNickname = 'test2';
     user2.TimeZoneSidKey = 'America/Chicago';
     user2.LocaleSidKey = 'en_US';
     user2.EmailEncodingKey = 'UTF-8';
     user2.ProfileId = p.id;
     user2.LanguageLocaleKey = 'en_US';
     user2.email = 'testName2@abc.com';
     user2.isActive = true;
     
     userList.add(user2);
     insert userList;
                 
    
    /* String JsonMsg= '[{  '+
    '"name" : "BAC test",'+
    '"Active" : true,'+
    '"Body_Armor_Configuration_ID":"ABCD123456",'+
    '"Sensitive_country_flag": false,'+
    '"teamMemberUserId"'+' :'+'"00519000000rymb;00519000000yQz6"'+
    '}]';  */  
    
    String JsonMsg= '[{  '+
    '"name" : "BAC test",'+
    '"Active" : true,'+
    '"BodyArmorConfigurationID":"ABCD123456",'+
    '"Sensitive_country_flag": false,'+
    '"teamMemberUserId": "'+user1.id+';'+user2.id+'"'+
    '}]';    
      
    
    Test.startTest();       
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/SaveBAC';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlSaveBodyArmorConfigurationDetails testbac=new CtrlSaveBodyArmorConfigurationDetails();  
    CtrlSaveBodyArmorConfigurationDetails.doPost();  
    Test.stopTest();        
    }
 static testMethod void testDoPost1() {       
     m3 = testData_Kevlar_UT.getMessage3();
    InsertList.add(m3);  
    insert InsertList;
    Test.startTest();
    CtrlSaveBodyArmorConfigurationDetails  testuser=new CtrlSaveBodyArmorConfigurationDetails();  
    CtrlSaveBodyArmorConfigurationDetails.doPost();  
    Test.stopTest();
  }  
}
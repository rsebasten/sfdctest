/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlUpdateBACService.
 ********************************************************************************/
@isTest
private class CtrlUpdateBACService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static BA_Configuration__c  bac;
    public static User user1,user2;
    
    static {
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage13();
        respMsgList.add(m4);   
        m2 = testData_Kevlar_UT.getMessage40(); 
        respMsgList.add(m2); 
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);  
        insert respMsgList;
     
     // Adding dummy value   
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     List<User> userList = new List<User>();
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
     userList.add(user1);
      
     user2 = new User();
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
        
    bac= new BA_Configuration__c();
    bac.name='test';     
    bac.Body_Armor_Configuration_ID__c='ABCD123456';
    bac.Active__c = true; 
    bac.Sensitive_Destination_Committee_Approv__c = true;
    bac.ownerid = user1.id;
    insert bac;
    
    List<BAC_Team_Member__c> listBTM = new List<BAC_Team_Member__c>();
    BAC_Team_Member__c btm1 = new BAC_Team_Member__c();
    btm1.Active__c = true;
    btm1.BA_Configuration__c = bac.id;
    btm1.Team_Member_Name__c = user1.id;
    listBTM.add(btm1);
    BAC_Team_Member__c btm2 = new BAC_Team_Member__c();
    btm2.Active__c = true;
    btm2.BA_Configuration__c = bac.id;
    btm2.Team_Member_Name__c = user2.id;
    listBTM.add(btm2);
    
    insert listBTM;   
    }    
     static testMethod void testDoPost(){    
    	    String JsonMsg='[{ '+
    '"Id" : "'+bac.id+'",'+
    '"Active": true,'+
    '"Sensitive_country_flag": false,'+
    '"lastSync": "2017-05-22T12:30:00.000Z",'+ 
    '"teamMemberUserId": "'+user1.id+';'+user2.id+'"'+
    '}] ';
    
    Test.startTest();     
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/UpdateBAC';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateBACService testbac=new CtrlUpdateBACService(); 
    CtrlUpdateBACService.doPost();  
    Test.stopTest();
}  
 static testMethod void testDoPost1() { 
    Test.startTest();
    CtrlUpdateBACService testbac=new CtrlUpdateBACService();  
    CtrlUpdateBACService.doPost();  
    Test.stopTest();
  }    
}
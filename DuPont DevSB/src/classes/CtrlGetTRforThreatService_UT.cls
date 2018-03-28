/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlGetTRforThreatService.
 ********************************************************************************/
@isTest
private class CtrlGetTRforThreatService_UT {
   
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 

static{
    m1 = testData_Kevlar_UT.getMessage1(); 
    respMsgList.add(m1);       
    m4 = testData_Kevlar_UT.getMessage20();
    respMsgList.add(m4);  
    m2 = testData_Kevlar_UT.getMessage2(); 
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
   
     BA_Configuration__c dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     insert dat1;
     
      Threat_Master__c trt1 = new Threat_Master__c();
        //tr1.BA_Configuration__c=bac.id;
        trt1.Threat_Type__c = 'Bullet';
        trt1.Active__c = true;
       
        trt1.Comments__c = 'testing by xxx';
        insert trt1;
      Threat_Master__c trt2 = new Threat_Master__c();
       //tr2.BA_Configuration__c=bac.id;
        trt2.Threat_Type__c = 'Fragment'; 
         trt1.Comments__c = 'testing by xxx';       
        insert trt2;     
      
        
      Threat_Master__c trt3 = new Threat_Master__c();
       //tr3.BA_Configuration__c=bac.id;
        trt3.Threat_Type__c = 'NBT';
        trt3.Comments__c = 'testing by xxx';
        insert trt3;
     
     
    Testing_Req_for_Threat__c tr1 = new Testing_Req_for_Threat__c();
    tr1.BA_Configuration__c=dat1.id;
    tr1.Threat_Type__c = 'Bullet';
    tr1.Threat_Selection__c = trt1.id;
    tr1.Active__c = true;
    tr1.Number_of_shots__c = '';
    tr1.Contact_Shot__c = 'No';
    tr1.Indoor_Outdoor__c = 'Outdoor';
    tr1.Clay__c = 'Roma';
    tr1.Type__c = 'test';
    tr1.Shooting_Distance__c = 23.000;
    tr1.Test_Standard__c = 'Other';
    tr1.Velocity__c = 270.00000;
    tr1.Velocity_Tolerance_m_s__c = 2.00;
     tr1.Angled_Shot__c = '[23,34]';
    tr1.Weapon__c = 'test';
    tr1.Shot_Location__c = null;
    tr1.Comments__c = 'testing by xxx';
    insert tr1;
    Testing_Req_for_Threat__c tr2 = new Testing_Req_for_Threat__c();
    tr2.BA_Configuration__c=dat1.id;
    tr2.Threat_Type__c = 'Fragment';
    tr2.Threat_Selection__c = trt2.id;
    tr2.Active__c = true;
     tr2.Type__c = 'test';
    tr2.Angled_Shot__c = '5';
    tr2.Number_of_shots__c = '4';
    tr2.Contact_Shot__c = '2';
    tr2.Indoor_Outdoor__c = 'Outdoor';
    tr2.Clay__c = 'Roma';
    tr1.Weapon__c = 'test';
    tr2.Test_Standard__c = 'Other';
    tr2.Comments__c = 'testing by xxx';
    tr2.Weapon__c = 'test';
    tr2.V50__c = 2;
    tr2.Velocity_Tolerance_m_s__c = 23.00;
    insert tr2;     
    Testing_Req_for_Threat__c tr3 = new Testing_Req_for_Threat__c();
    tr3.BA_Configuration__c=dat1.id;
    tr3.Threat_Type__c = 'NBT';
    tr3.Threat_Selection__c = trt3.id;
    tr3.Active__c = true;
    tr3.Angled_Shot__c = '[23,34]';
    tr3.Number_of_shots__c = '4';
    tr3.Contact_Shot__c = '2';
    tr3.Indoor_Outdoor__c = 'Outdoor';
    tr3.Clay__c = 'Roma';
    tr3.Test_Standard__c = 'Other';
    tr3.Comments__c = 'testing by xxx';
    tr3.Penetration_Allowed__c = 'yes';
    tr3.Shot_Location__c = 'test';
    tr3.No_Of_Stabs__c = '3';
    tr3.Threat_Level__c = 'kr1';
    tr3.Energy_Level_NBT__c = 'E1';
    tr3.Energy_Level_Joule_NBT__c = '24';
    tr3.Stab_Location__c = '3';
    insert tr3;

 String JsonMsg='{'+
        '"bacConfigurationID" : "'+dat1.id+'",'+
        '"threatType1" : "Bullet",'+
        '"threatType2" : "Fragment",'+
        '"threatType3" : "NBT"'+
        '}';
        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetTR';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;


        CtrlGetTRforThreatService testTHR=new CtrlGetTRforThreatService();   
        CtrlGetTRforThreatService.doPost(); 
        Test.stopTest();
    }
    static testMethod void testDoPost1() {
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
   
     BA_Configuration__c dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     insert dat1;
     
      Threat_Master__c trt1 = new Threat_Master__c();
        //tr1.BA_Configuration__c=bac.id;
        trt1.Threat_Type__c = 'Bullet';
        trt1.Active__c = true;
       
        trt1.Comments__c = 'testing by xxx';
        insert trt1;
      Threat_Master__c trt2 = new Threat_Master__c();
       //tr2.BA_Configuration__c=bac.id;
        trt2.Threat_Type__c = 'Fragment'; 
         trt1.Comments__c = 'testing by xxx';       
        insert trt2;     
      
        
      Threat_Master__c trt3 = new Threat_Master__c();
       //tr3.BA_Configuration__c=bac.id;
        trt3.Threat_Type__c = 'NBT';
        trt3.Comments__c = 'testing by xxx';
        insert trt3;
     
     
    Testing_Req_for_Threat__c tr1 = new Testing_Req_for_Threat__c();
    tr1.BA_Configuration__c=dat1.id;
    tr1.Threat_Type__c = 'Bullet';
    tr1.Threat_Selection__c = trt1.id;
    tr1.Active__c = true;
    tr1.Number_of_shots__c = '';
    tr1.Contact_Shot__c = '';
    tr1.Indoor_Outdoor__c = '';
    tr1.Clay__c = '';
    tr1.Type__c = '';
    tr1.Shooting_Distance__c = null;
    tr1.Test_Standard__c = '';
    tr1.Velocity__c = null;
    tr1.Velocity_Tolerance_m_s__c = null;
     tr1.Angled_Shot__c = '';
    tr1.Weapon__c = '';
    tr1.Shot_Location__c = '';
    tr1.Comments__c = '';
    insert tr1;
    Testing_Req_for_Threat__c tr2 = new Testing_Req_for_Threat__c();
    tr2.BA_Configuration__c=dat1.id;
    tr2.Threat_Type__c = 'Fragment';
    tr2.Threat_Selection__c = trt2.id;
    tr2.Active__c = true;
     tr2.Type__c = '';
    tr2.Angled_Shot__c = '';
    tr2.Number_of_shots__c = '';
    tr2.Contact_Shot__c = '';
    tr2.Indoor_Outdoor__c = '';
    tr2.Clay__c = '';
    tr1.Weapon__c = '';
    tr2.Test_Standard__c = '';
    tr2.Comments__c = '';
    tr2.Weapon__c = '';
    tr2.V50__c = null;
    tr2.Velocity_Tolerance_m_s__c = null;
    insert tr2;     
    Testing_Req_for_Threat__c tr3 = new Testing_Req_for_Threat__c();
    tr3.BA_Configuration__c=dat1.id;
    tr3.Threat_Type__c = 'NBT';
    tr3.Threat_Selection__c = trt3.id;
    tr3.Active__c = true;
    tr3.Angled_Shot__c = '';
    tr3.Number_of_shots__c = '';
    tr3.Contact_Shot__c = '';
    tr3.Indoor_Outdoor__c = '';
    tr3.Clay__c = '';
    tr3.Test_Standard__c = '';
    tr3.Comments__c = '';
    tr3.Penetration_Allowed__c = '';
    tr3.Shot_Location__c = '';
    tr3.No_Of_Stabs__c = '';
    tr3.Threat_Level__c = '';
    tr3.Energy_Level_NBT__c = '';
    tr3.Energy_Level_Joule_NBT__c = '';
    tr3.Stab_Location__c = '';
    insert tr3;

 String JsonMsg='{'+
        '"bacConfigurationID" : "'+dat1.id+'",'+
        '"threatType1" : "Bullet",'+
        '"threatType2" : "Fragment",'+
        '"threatType3" : "NBT"'+
        '}';
        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetTR';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;


        CtrlGetTRforThreatService testTHR=new CtrlGetTRforThreatService();   
        CtrlGetTRforThreatService.doPost(); 
        Test.stopTest();
    }
      }
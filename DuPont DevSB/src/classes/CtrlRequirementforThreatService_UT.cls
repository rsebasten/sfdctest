/*******************************************************************************
(C)2016
Author: Krishnaveni Duggaraju
Email: krishnaveni.duggaraju3@tcs.com
Description:  This class tests the CtrlRequirementforThreatService.
 ********************************************************************************/
@isTest
private class CtrlRequirementforThreatService_UT {
public static User user1;
public static BA_Configuration__c  bac;
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
public static Testing_Req_for_Threat__c tr1,tr2,tr3,tr4,tr5,tr6;
public static List<Testing_Req_for_Threat__c> trList= new List<Testing_Req_for_Threat__c>();
public static Threat_Master__c  trt1,trt2,trt3;
public static List<Threat_Master__c> trtList= new List<Threat_Master__c>();
Set<Id> newThreatsId=new Set<Id>();
    static{
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        //List<User> userList = new List<User>();
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
        
        bac= new BA_Configuration__c();
        bac.name='test';     
        bac.Body_Armor_Configuration_ID__c='ABCD123456';
        bac.Active__c = true; 
        bac.Sensitive_Destination_Committee_Approv__c = true;
        bac.ownerid = user1.id;
        insert bac;
        trt1 = new Threat_Master__c();
        //tr1.BA_Configuration__c=bac.id;
        trt1.Threat_Type__c = 'Bullet';
        trt1.Active__c = true;      
        trt1.Contact_Shot__c = 'No';
        trt1.Indoor_Outdoor__c = 'Outdoor';
        trt1.Clay__c = 'Roma';
        trt1.Type__c = 'test';
        trt1.Shooting_Distance__c = 23.000;
        trt1.Test_Standard__c = '[xxxxx;xxxx]';
        trt1.Velocity__c = 270.00000;
        trt1.Velocity_Tolerance_m_s__c = 2.00;
        trt1.Angled_Shot__c = '[23;34]';
        trt1.Weapon__c = 'test';
        trt1.Shot_Locations__c = null;
        trt1.Comments__c = 'testing by xxx';
         trtList.add(trt1);
        trt2 = new Threat_Master__c();
        //tr2.BA_Configuration__c=bac.id;
        trt2.Threat_Type__c = 'Fragment'; 
        trt2.Active__c = true;     
        trt2.Contact_Shot__c = 'No';
        trt2.Indoor_Outdoor__c = 'Outdoor';
        trt2.Clay__c = 'Roma';
        trt2.Type__c = 'test';
        trt2.Shooting_Distance__c = 23.000;
        trt2.Test_Standard__c = '[xxxxx;xxxx]';
        trt2.Velocity__c = 270.00000;
        trt2.Velocity_Tolerance_m_s__c = 2.00;
        trt2.Angled_Shot__c = '[23;34]';
        trt2.Weapon__c = 'test';
        trt2.Shot_Locations__c = null;
        trt2.Comments__c = 'testing by xxx';
        trtList.add(trt2);
        
        
        trt3 = new Threat_Master__c();
        trt3.Active__c = true;
        //tr3.BA_Configuration__c=bac.id;
        trt3.Threat_Type__c = 'NBT';
        trt3.Comments__c = 'testing by xxx';
        trtList.add(trt3);
        insert trtList;
        
                                         
        tr1 = new Testing_Req_for_Threat__c();
        tr1.BA_Configuration__c=bac.id;
        tr1.Threat_Type__c = 'Bullet';
        tr1.Threat_Selection__c = trt1.id;
        tr1.Active__c = true;
        tr1.Number_of_shots__c = '';
        tr1.Contact_Shot__c = 'No';
        tr1.Indoor_Outdoor__c = 'Outdoor';
        tr1.Clay__c = 'Roma';
        tr1.Type__c = 'test';
        tr1.Shooting_Distance__c = 23.000;
        tr1.Test_Standard__c = '[xxxxx;xxxx]';
        tr1.Velocity__c = 270.00000;
        tr1.Velocity_Tolerance_m_s__c = 2.00;
        tr1.Angled_Shot__c = '[23;34]';
        tr1.Weapon__c = 'test';
        tr1.Shot_Location__c = null;
        tr1.Comments__c = 'testing by xxx';
        trList.add(tr1);
        tr2 = new Testing_Req_for_Threat__c();
        tr2.BA_Configuration__c=bac.id;
        tr2.Threat_Type__c = 'Fragment';
        tr2.Threat_Selection__c = trt2.id;
        tr2.Active__c = true;
        tr2.Type__c = 'test';
        tr2.Angled_Shot__c = '5';
        tr2.Number_of_shots__c = '4';
        tr2.Contact_Shot__c = '2';
        tr2.Indoor_Outdoor__c = 'Outdoor';
        tr2.Clay__c = 'Roma';
        tr2.Weapon__c = 'test';
        tr2.Test_Standard__c = '[xxxxx;xxxx]';
        tr2.Comments__c = 'testing by xxx';
        tr2.Weapon__c = 'test';
        tr2.V50__c = 2;
        tr2.Velocity_Tolerance_m_s__c = 23.00;
        trList.add(tr2); 
        tr3 = new Testing_Req_for_Threat__c();
        tr3.BA_Configuration__c=bac.id;
        tr3.Threat_Type__c = 'NBT';
        tr3.Threat_Selection__c = trt3.id;
        tr3.Active__c = true;
        tr3.Angled_Shot__c = '[23;34]';
        tr3.Number_of_shots__c = '4';
        tr3.Contact_Shot__c = '2';
        tr3.Indoor_Outdoor__c = 'Outdoor';
        tr3.Clay__c = 'Roma';
        tr3.Test_Standard__c = '[xxxxx;xxxx]';
        tr3.Comments__c = 'testing by xxx';
        tr3.Penetration_Allowed__c = 'yes';
        tr3.Shot_Location__c = 'test';
        tr3.No_Of_Stabs__c = '3';
        tr3.Threat_Level__c = 'kr1';
        tr3.Energy_Level_NBT__c = 'E1';
        tr3.Energy_Level_Joule_NBT__c = '24';
        tr3.Stab_Location__c = '3';
        trList.add(tr3);
        tr4 = new Testing_Req_for_Threat__c();
        tr4.BA_Configuration__c=bac.id;
        tr4.Threat_Type__c = 'Fragment';
        tr4.Threat_Selection__c = trt2.id;
        tr4.Active__c = true;
        tr4.Type__c = '';
        tr4.Angled_Shot__c = '';
        tr4.Number_of_shots__c = '';
        tr4.Contact_Shot__c = '';
        tr4.Indoor_Outdoor__c = '';
        tr4.Clay__c = '';
        tr4.Weapon__c = '';
        tr4.Test_Standard__c = '[xxxxx;xxxx]';
        tr4.Comments__c = '';
        tr4.Weapon__c = '';
        tr4.V50__c = null;
        tr4.Velocity_Tolerance_m_s__c = null;
        trList.add(tr4);
        tr5 = new Testing_Req_for_Threat__c();
        tr5.BA_Configuration__c=bac.id;
        tr5.Threat_Type__c = 'NBT';
        tr5.Threat_Selection__c = trt3.id;
        tr5.Active__c = true;
        tr5.Angled_Shot__c = '';
        tr5.Number_of_shots__c = '';
        tr5.Contact_Shot__c = '';
        tr5.Indoor_Outdoor__c = '';
        tr5.Clay__c = '';
        tr5.Test_Standard__c = '[xxxxx;xxxx]';
        tr5.Comments__c = '';
        tr5.Penetration_Allowed__c = '';
        tr5.Shot_Location__c = '';
        tr5.No_Of_Stabs__c = '';
        tr5.Threat_Level__c = '';
        tr5.Energy_Level_NBT__c = '';
        tr5.Energy_Level_Joule_NBT__c = '';
        tr5.Stab_Location__c = '';
        trList.add(tr5);
           tr6 = new Testing_Req_for_Threat__c();
        tr6.BA_Configuration__c=bac.id;
        tr6.Threat_Type__c = 'Bullet';
        tr6.Threat_Selection__c = trt1.id;
        tr6.Active__c = true;
        tr6.Number_of_shots__c = '';
        tr6.Contact_Shot__c = '';
        tr6.Indoor_Outdoor__c = '';
        tr6.Clay__c = '';
        tr6.Type__c = '';
        tr6.Shooting_Distance__c = null;
        tr1.Test_Standard__c = '[xxxxx;xxxx]';
        tr6.Velocity__c = null;
        tr6.Velocity_Tolerance_m_s__c = null;
        tr6.Angled_Shot__c = ']';
        tr6.Weapon__c = '';
        tr6.Shot_Location__c = null;
        tr6.Comments__c = '';
        trList.add(tr6);
        insert trList; 
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage29();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2);  
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3); 
         
        insert respMsgList;
    }

static testMethod void testDoPost() { 

 String jsonThreat= '[{'+
 '"bacConfigurationID" : "'+bac.id+'",'+
'"dml":"save",'+
'"nonBallistic": [{'+

    '"name": "Single Side Knife P1 B",'+
    '"threattype":"nbt",'+
    
    '"value": [{'+
        '"name": "P1B VAPM",'+
        '"nbtId": "'+trt3.id+'",'+
        '"comments": "xxx"'+
    '},{'+
            '"name": "P1A VAPM",'+
            '"nbtId": "",'+
            '"comments": "xxxyyyy"'+
        '}]}],'+

'"fragments": [{'+
        '"fragmentType": "64 - gr RCC",'+
        '"threattype":"fragment",'+
        '"fragmentId": "'+trt2.id+'",'+
        '"gram": 0.13,'+
        '"grains": 2,'+
        '"comments": "xxx"'+
    '}],'+

'"bullets": [{'+
        '"name": ".357 MAG",'+
        '"threattype":"bullet",'+
        '"value": [{'+

                '"bulletType": "Remington SPFN, R357M3",'+
                '"bulletId": "'+trt1.id+'",'+
                '"weight": 12,'+
                '"velocity": 373,'+
                '"comments": "xxxx"'+
            '}'+
        ']'+

    '}]'+
 '}]';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/TRforThreat';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonThreat);
    RestContext.request = req;
    RestContext.response= res;
    CtrlRequirementforThreatService testRforT=new CtrlRequirementforThreatService();   
    CtrlRequirementforThreatService.doPost(); 
    Test.stopTest();
}   
static testMethod void testDoPost1() { 
  
    String jsonThreat= '[{'+
     '"bacConfigurationID" : "'+bac.id+'",'+
      '"deleted" : ["'+tr2.id+'"],'+
    '"dml":"update",'+
    '"nonBallistic": [{'+

        '"name": "Single Side Knife P1 B",'+
        '"threattype":"nbt",'+
        
        '"value": [{'+
            '"name": "P1B VAPM",'+
            '"nbtId": "'+tr3.id+'",'+
            '"comments": "xxx"'+
        '},{'+
            '"name": "P1A VAPM",'+
            '"nbtId": "",'+
            '"comments": "xxxyyyy"'+
        '}]}],'+

    '"fragments": [{'+
            '"fragmentType": "64 - gr RCC",'+
            '"threattype":"fragment",'+
            '"fragmentId": "'+tr2.id+'",'+
            '"gram": 0.13,'+
            '"grains": 2,'+
            '"comments": "xxx"'+
        '},{'+
        '"fragmentType": "17 - gr RCC",'+
        '"threattype":"fragment",'+
        '"fragmentId": "",'+
        '"gram": 0.13,'+
        '"grains": 2,'+
        '"comments": "xxxyyy"'+
    '}],'+

    '"bullets": [{'+
            '"name": ".357 MAG",'+
            '"threattype":"bullet",'+
            '"value": [{'+

                    '"bulletType": "Remington SPFN, R357M3",'+
                    '"bulletId": "'+tr1.id+'",'+
                    '"weight": 12,'+
                    '"velocity": 373,'+
                    '"comments": "xxxx"'+
                '}'+
            ']'+

        '}]'+
     '}]';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/TRforThreat';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonThreat);
    RestContext.request = req;
    RestContext.response= res;
    CtrlRequirementforThreatService testRforT=new CtrlRequirementforThreatService();   
    CtrlRequirementforThreatService.doPost(); 
    Test.stopTest();
}   
static testMethod void testDoPost2() { 
  
    String jsonThreat= '[{'+
     '"bacConfigurationID" : "'+bac.id+'",'+
    '"dml":"save",'+
    '"nonBallistic": [{'+

        '"name": "Single Side Knife P1 B",'+
        '"threattype":"nbt",'+
        
        '"value": [{'+
            '"name": "P1B VAPM",'+
            '"nbtId": "'+tr5.id+'",'+
            '"comments": "xxx"'+
        '}]}],'+

    '"fragments": [{'+
            '"fragmentType": "64 - gr RCC",'+
            '"threattype":"fragment",'+
            '"fragmentId": "'+tr4.id+'",'+
            '"gram": 0.13,'+
            '"grains": 2,'+
            '"comments": "xxx"'+
        '},{'+
        '"fragmentType": "17 - gr RCC",'+
        '"threattype":"fragment",'+
        '"fragmentId": "",'+
        '"gram": 0.13,'+
        '"grains": 2,'+
        '"comments": "xxx"'+
    '}],'+

    '"bullets": [{'+
            '"name": ".357 MAG",'+
            '"threattype":"bullet",'+
            '"value": [{'+

                    '"bulletType": "Remington SPFN, R357M3",'+
                    '"bulletId": "'+tr6.id+'",'+
                    '"weight": 12,'+
                    '"velocity": 373,'+
                    '"comments": "xxxx"'+
                '}'+
            ']'+

        '}]'+
     '}]';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/TRforThreat';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonThreat);
    RestContext.request = req;
    RestContext.response= res;
    CtrlRequirementforThreatService testRforT=new CtrlRequirementforThreatService();   
    CtrlRequirementforThreatService.doPost(); 
    Test.stopTest();
}      
}
/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlUpdateTRforThreatService.
 ********************************************************************************/
@isTest
private class CtrlUpdateTRforThreatService_UT{
   
    public static BA_Configuration__c  bac;
    public static User user1;
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static Testing_Req_for_Threat__c  tr1,tr2,tr3,tr4,tr5;
    public static List<Testing_Req_for_Threat__c> trList = new List<Testing_Req_for_Threat__c>(); 
    public static Threat_Master__c  trt1,trt2,trt3,trt4,trt5; 
    public static list<Threat_Master__c> threatList = new List<Threat_Master__c>();
    static{
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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
        trt1.Manual_Testing__c = false;   
        trt1.Contact_Shot__c = 'No';
        trt1.Indoor_Outdoor__c = 'Outdoor';
        trt1.Clay__c = 'Roma';
        trt1.Type__c = 'test';
        trt1.Shooting_Distance__c = 23.000;
        trt1.Test_Standard__c = 'Other';
        trt1.Velocity__c = 270.00000;
        trt1.Velocity_Tolerance_m_s__c = 2.00;
        trt1.Angled_Shot__c = '[23,34]';
        trt1.Weapon__c = 'test';
        trt1.Shot_Locations__c = null;
        trt1.Comments__c = 'testing by xxx';
        threatList.add(trt1);
        
        trt5 = new Threat_Master__c();
        //tr1.BA_Configuration__c=bac.id;
        trt5.Threat_Type__c = 'Bullet';
        trt5.Active__c = true;   
        trt5.Manual_Testing__c = false;   
        trt5.Contact_Shot__c = 'No';
        trt5.Indoor_Outdoor__c = '';
        trt5.Clay__c = '';
        trt5.Type__c = '';
        trt5.Shooting_Distance__c = null;
        trt5.Test_Standard__c = '';
        trt5.Velocity__c = null;
        trt5.Velocity_Tolerance_m_s__c = null;
        trt5.Angled_Shot__c = '[23,34]';
        trt5.Weapon__c = '';
        trt5.Shot_Locations__c = null;
        trt5.Comments__c = '';
        threatList.add(trt5);
       
        trt2 = new Threat_Master__c();
        //tr2.BA_Configuration__c=bac.id;
        trt2.Threat_Type__c = 'Fragment'; 
        trt2.Active__c = true;   
        trt2.Manual_Testing__c = false;
        trt2.Contact_Shot__c = 'No';
        trt2.Indoor_Outdoor__c = 'Outdoor';
        trt2.Clay__c = 'Roma';
        trt2.Type__c = 'test';
        trt2.Shooting_Distance__c = 23.000;
        trt2.Test_Standard__c = 'Other';
        trt2.Velocity__c = 270.00000;
        trt2.Velocity_Tolerance_m_s__c = 2.00;
        trt2.Angled_Shot__c = '[23,34]';
        trt2.Weapon__c = 'test';
        trt2.Shot_Locations__c = null;
        trt2.Comments__c = 'testing by xxx';
        threatList.add(trt2);
        
        trt4 = new Threat_Master__c();
        //tr2.BA_Configuration__c=bac.id;
        trt4.Threat_Type__c = 'Fragment'; 
        trt4.Active__c = true;   
        trt4.Manual_Testing__c = false;
        trt4.Contact_Shot__c = '';
        trt4.Indoor_Outdoor__c = '';
        trt4.Clay__c = '';
        trt4.Type__c = '';
        trt4.Shooting_Distance__c = null;
        trt4.Test_Standard__c = '';
        trt4.Velocity__c = null;
        trt4.Velocity_Tolerance_m_s__c = null;
        trt4.Angled_Shot__c = '[null,null]';
        trt4.Weapon__c = '';
        trt4.Shot_Locations__c = null;
        trt4.Comments__c = '';
        threatList.add(trt4);  
        
        trt3 = new Threat_Master__c();
        trt3.Active__c = true;
        //tr3.BA_Configuration__c=bac.id;
        trt3.Threat_Type__c = 'NBT';
        trt3.Comments__c = 'testing by xxx';
        trt3.Manual_Testing__c = true;
        threatList.add(trt3);
        trt5 = new Threat_Master__c();
        //tr2.BA_Configuration__c=bac.id;
        trt5 .Threat_Type__c = 'NBT'; 
        trt5 .Active__c = true;   
        trt5 .Manual_Testing__c = false;
        trt5 .Contact_Shot__c = '';
        trt5 .Indoor_Outdoor__c = '';
        trt5 .Clay__c = '';
        trt5 .Type__c = '';
        trt5 .Shooting_Distance__c = null;
        trt5 .Test_Standard__c = '';
        trt5 .Velocity__c = null;
        trt5 .Velocity_Tolerance_m_s__c = null;
        trt5 .Angled_Shot__c = '[null,null]';
        trt5 .Weapon__c = '';
        trt5 .Shot_Locations__c = null;
        trt5 .Comments__c = '';
        threatList.add(trt5 );
        if(threatList.size()>0){
        insert threatList;
        }
         
        tr1 = new Testing_Req_for_Threat__c();
        tr1.BA_Configuration__c=bac.id;
        tr1.Threat_Type__c = 'Bullet';
        tr1.Threat_Selection__c = trt1.id;
        tr1.Active__c = true;
        tr1.Manual_Testing__c = false;
        tr1.Angled_Shot__c = '5';
        tr1.Number_of_shots__c = '4';
        tr1.Contact_Shot__c = '2';
        tr1.Indoor_Outdoor__c = 'Outdoor';
        tr1.Clay__c = 'Roma';
        tr1.Test_Standard__c = 'Other';
        tr1.Comments__c = 'testing by xxx';
        trList.add(tr1);
        tr2 = new Testing_Req_for_Threat__c();
        tr2.BA_Configuration__c=bac.id;
        tr2.Threat_Type__c = 'Fragment';
        tr2.Threat_Selection__c = trt2.id;
        tr2.Active__c = true;
        tr2.Manual_Testing__c = false;
        tr2.Angled_Shot__c = '5';
        tr2.Number_of_shots__c = '4';
        tr2.Contact_Shot__c = '2';
        tr2.Indoor_Outdoor__c = 'Outdoor';
        tr2.Clay__c = 'Roma';
        tr2.Test_Standard__c = 'Other';
        tr2.Comments__c = 'testing by xxx';
        tr2.Weapon__c = 'test';
        tr2.V50__c = 2.00;
        tr2.Velocity_Tolerance_m_s__c = 23.00;
        trList.add(tr2);  
        tr3 = new Testing_Req_for_Threat__c();
        tr3.BA_Configuration__c=bac.id;
        tr3.Threat_Type__c = 'NBT';
        tr3.Threat_Selection__c = trt3.id;
        tr3.Active__c = true;
        tr3.Manual_Testing__c = true;
        tr3.Angled_Shot__c = '5';
        tr3.Number_of_shots__c = '4';
        tr3.Contact_Shot__c = '2';
        tr3.Indoor_Outdoor__c = 'Outdoor';
        tr3.Clay__c = 'Roma';
        tr3.Test_Standard__c = 'Other';
        tr3.Comments__c = 'testing by xxx';
        tr3.Threat_Level__c = 'kr1';
        tr3.Energy_Level_NBT__c = 'E1';
        tr3.Energy_Level_Joule_NBT__c = '24';
        trList.add(tr3);
        tr4 = new Testing_Req_for_Threat__c();
        tr4.BA_Configuration__c=bac.id;
        tr4.Threat_Type__c = 'NBT';
        tr4.Threat_Selection__c = trt5.id;
        tr4.Active__c = true;
        tr4.Manual_Testing__c = true;
        tr4.Angled_Shot__c = '';
        tr4.Number_of_shots__c = '';
        tr4.Contact_Shot__c = '';
        tr4.Indoor_Outdoor__c = '';
        tr4.Clay__c = '';
        tr4.Test_Standard__c = '';
        tr4.Comments__c = '';
        tr4.Threat_Level__c = '';
        tr4.Energy_Level_NBT__c = '';
        tr4.Energy_Level_Joule_NBT__c = '';
        trList.add(tr4);
        tr5 = new Testing_Req_for_Threat__c();
        tr5.BA_Configuration__c=bac.id;
        tr5.Threat_Type__c = 'Fragment';
        tr5.Threat_Selection__c = trt4.id;
        tr5.Active__c = true;
        tr5.Manual_Testing__c = true;
        tr5.Angled_Shot__c = '';
        tr5.Number_of_shots__c = '';
        tr5.Contact_Shot__c = '';
        tr5.Indoor_Outdoor__c = '';
        tr5.Clay__c = '';
        tr5.Test_Standard__c = '';
        tr5.Comments__c = '';
        tr5.Threat_Level__c = '';
        tr5.Energy_Level_NBT__c = '';
        tr5.Energy_Level_Joule_NBT__c = '';
        trList.add(tr5);
        insert trList;
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage16();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2);  
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);  
        insert respMsgList;
        
        
        
}

  static testMethod void testDoPost() {   
     String JsonMsg = '[{'+    
    '"bacConfigurationID" : "'+bac.id+'",'+
     '   "lastSync": "2020-12-20T11:49:46.000+0000",'+
    '"bullets": {'+
    '"icw": true,'+
    '"threatType": "Bullet",'+
    '"clay": "Roma Plastilina",'+
    '"indoorOutdoor": "Outdoor",'+
    '"wetTesting": true,'+
    '"environmentalTesting": true,'+
    '"testStandard": ["China GA 141"],'+
    '"comments": "dfsdf",'+
    '"records": [{'+
       ' "name": ".357 MAG",'+
       ' "bulletId":  "'+trt1.id+'",'+
       ' "sequence" : "",'+
        '"bulletType": "Remington SPFN, R357M3",'+
        '"shootingDistance": 14.234,'+
       ' "velocity": 400.234,'+
       ' "velocityRange": 15.45,'+
       ' "weapon": "test",'+
       ' "v50" : 444,'+
       ' "shotLocation": "Shot Locations1",'+
       ' "numberOfShots": "2",'+
       ' "angledShot": ["23"],'+
        '"contactShot": "NO",'+
       ' "bfd": 45.00,'+
       ' "comment": "commentbullet2 Updated"'+
    '}]'+
    '},'+ 
    '"fragments" : {'+
    '"icw": true,'+
      '"environmentalTesting" : false,'+
      '"clay" : "Roma Plastilina",'+
      '"wetTesting" : false,'+
      '"threatType" : "Fragment",'+
      '"testStandard" : ["NIJ 0101.04"],'+
      '"indoorOutdoor" : "Indoor",'+
      '"comments" : "",'+
      '"records" : ['+
        '{'+
          '"velocity" : 0,'+
          '"weapon" : "Barrel",'+
          '"fragmentType" : "indian navy fragment",'+
          '"name" : "indian navy fragment",'+
          '"v50" : 0,'+
          '"sequence" : "",'+
          '"comment" : "",'+
          '"velocityRange" : 0,'+
          '"fragmentId" : "'+trt2.id+'"'+
        '},{'+
          '"velocity" : 0,'+
          '"weapon" : "Barrel",'+
          '"fragmentType" : "indian navy fragment",'+
          '"name" : "indian navy fragment",'+
          '"v50" : 0,'+
          '"sequence" : "",'+
          '"comment" : "",'+
          '"velocityRange" : 0,'+
          '"fragmentId" : null'+
        '}]'+
     '},'+     
      '"nonBallistic" : {'+
      '"environmentalTesting" : false,'+
      '"clay" : "Roma Plastilina",'+
      '"wetTesting" : false,'+
      '"threatType" : "NBT",'+
      '"testStandard" : ["NIJ 0101.04"],'+
      '"icw" : false,'+
      '"indoorOutdoor" : "Indoor",'+
      '"comments" : "",'+
      '"manualTesting" : true,' +
      '"records" : ['+
        '{'+
          '"nonBallisticType" : "S1",'+
          '"threatLevel" : "KR1",'+
          '"stabLocations" : "",'+
          '"sequence" : "",'+
          '"joules" : "",'+
          '"permissiblePenetration" : "",'+
          '"energyLevel" : "",'+
          '"mass" : 0,'+
          '"numberOfStabs" : "",'+
          '"nbtId" : "'+trt3.id+'",'+
          '"comment" : "",'+
          '"name" : "Double Side Knife S1",'+
          '"angledShot" : ["25"]'+
           '},{'+
          '"nonBallisticType" : "S1",'+
          '"threatLevel" : "KR1",'+
          '"stabLocations" : "",'+
          '"sequence" : "",'+
          '"joules" : "",'+
          '"permissiblePenetration" : "",'+
          '"energyLevel" : "",'+
          '"mass" : 0,'+
          '"numberOfStabs" : "",'+
          '"nbtId" : null,'+
          '"comment" : "",'+
          '"name" : "Double Side Knife S12",'+
          '"angledShot" : ["45"]'+
          '}]'+      
      '}' +  
      '}]';
  
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateTRThreat';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;

    CtrlUpdateTRforThreatService testUpdateTR=new CtrlUpdateTRforThreatService();   
    CtrlUpdateTRforThreatService.doPost(); 
    Test.stopTest();
}

static testMethod void testDoPost2() {   
     
     String JsonMsg = '[{'+    
    '"bacConfigurationID" : "'+bac.id+'",'+
     '   "lastSync": "2020-12-20T11:49:46.000+0000",'+
    '"bullets": {'+
    '"icw": true,'+
    '"threatType": "Bullet",'+
    '"clay": "",'+
    '"indoorOutdoor": "",'+
    '"wetTesting": true,'+
    '"environmentalTesting": true,'+
    '"testStandard": [""],'+
    '"comments": "",'+
    '"records": [{'+
       ' "name": "",'+
       ' "bulletId":  "'+trt1.id+'",'+
       ' "sequence" : "",'+
        '"bulletType": "",'+
        '"shootingDistance": 14.234,'+
       ' "velocity": null,'+
       ' "velocityRange": null,'+
       ' "weapon": "",'+
       ' "v50" : null,'+
       ' "shotLocation": "",'+
       ' "numberOfShots": "2",'+
       ' "angledShot": ["23"],'+
        '"contactShot": "NO",'+
       ' "bfd": null,'+
       ' "comment": ""'+
    '}]'+
    '},'+ 
    '"fragments" : {'+
    '"icw": true,'+
      '"environmentalTesting" : false,'+
      '"clay" : "",'+
      '"wetTesting" : false,'+
      '"threatType" : "Fragment",'+
      '"testStandard" : [""],'+
      '"indoorOutdoor" : "",'+
      '"comments" : "",'+
      '"records" : ['+
        '{'+
          '"velocity" : 0,'+
          '"weapon" : "",'+
          '"fragmentType" : "",'+
          '"name" : "",'+
          '"v50" : 0,'+
          '"sequence" : "",'+
          '"comment" : "",'+
          '"velocityRange" : 0,'+
          '"fragmentId" : "'+trt4.id+'"'+
        '}]'+
     '},'+     
      '"nonBallistic" : {'+
      '"environmentalTesting" : false,'+
      '"clay" : "",'+
      '"wetTesting" : false,'+
      '"threatType" : "NBT",'+
      '"testStandard" : [""],'+
      '"icw" : false,'+
      '"indoorOutdoor" : "",'+
      '"comments" : "",'+
      '"manualTesting" : true,' +
      '"records" : ['+
        '{'+
          '"nonBallisticType" : "",'+
          '"threatLevel" : "",'+
          '"stabLocations" : "",'+
          '"sequence" : "",'+
          '"joules" : "",'+
          '"permissiblePenetration" : "",'+
          '"energyLevel" : "",'+
          '"mass" : 0,'+
          '"numberOfStabs" : "",'+
          '"nbtId" : "'+trt5.id+'",'+
          '"comment" : "",'+
          '"name" : "",'+
          '"angledShot" : ["25"]'+
           '}]'+      
      '}' +  
      '}]';
  
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateTRThreat';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;

    CtrlUpdateTRforThreatService testUpdateTR=new CtrlUpdateTRforThreatService();   
    CtrlUpdateTRforThreatService.doPost(); 
    Test.stopTest();
}       
}
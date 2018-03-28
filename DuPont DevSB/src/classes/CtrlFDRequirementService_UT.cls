/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlFDRequirementService.
 ********************************************************************************/
@isTest
private class CtrlFDRequirementService_UT {
    public static User user1;
    public static BA_Configuration__c  bac;
    public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 

    
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
        
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage16();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage34(); 
        respMsgList.add(m2); 
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);   
        m5 = testData_Kevlar_UT.getMessage29();
        respMsgList.add(m5);  
        insert respMsgList;
    }
    
    static testMethod void testDoPost_BAFD() { 
        String JsonMsg= '[{'+        
        '"name": "SAP Design 1",'+
        '"fdrRecordType" : "Body Armor Functional Design",'+
        '"bacConfigurationID" : "'+bac.id+'",'+
        '"active" : true,'+
        '"color" : "Green",'+
        '"backPlate" : true,'+
        '"frontPlate" : true,'+
        '"sidePlate" : true,'+
        '"platePockets" : true,'+
        '"shoulder" : true,'+
        '"neckAndCollar" : true,'+
        '"groin" : true,'+
        '"pouches" : true,'+
        '"quickRelease" : true,'+
        '"molleSystem" : true,'+
        '"selectedSizes":['+    
            '{"size":"XS","value":true},'+
            '{"size":"S","value":true},'+
            '{"size":"M","value":true},'+
            '{"size":"L","value":true},'+
            '{"size":"XL","value":true},'+
            '{"size":"XXL","value":true}'+
        '],'+
            '"dimension":[{'+
            '"name":"XS","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110},'+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']},'+
            '{"name":"S","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110}, '+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']},'+
			'{"name":"M","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110}, '+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']},'+
			'{"name":"L","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110}, '+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']},'+
			'{"name":"XL","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110}, '+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']},'+
			'{"name":"XXL","value":['+
            '{"name":"A","value":110}, '+
            '{"name":"B","value":110}, '+
            '{"name":"C","value":110}, '+
            '{"name":"D","value":110}, '+
            '{"name":"E","value":110} '+
            ']}'+
            '],'+
            '"surfaceAreaOfBodyArmor":[{'+
            '"name":"XS",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '},'+
			'{"name":"S",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '},'+
			'{"name":"M",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '},'+
			'{"name":"L",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '},'+
			'{"name":"XL",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '},'+
			'{"name":"XXL",'+
            '"torsoSurfaceArea":100,'+
            '"shoulderLRSurfaceArea":100,'+
            '"neckCollarSurfaceArea" : 100,'+
            '"groinSurfaceArea" : 100,'+
            '"totalSurfaceArea" : 100'+
            '}'+
            '],'+
            '"surfaceAreaOfPounch":['+
            '{"name" : "XS",'+
            '"surfaceArea" : 1001},'+
            '{"name" : "S",'+
            '"surfaceArea" : 1001},'+
            '{"name" : "M",'+
            '"surfaceArea" : 1001},'+
            '{"name" : "L",'+
            '"surfaceArea" : 1001},'+
            '{"name" : "XL",'+
            '"surfaceArea" : 1001},'+
            '{"name" : "XXL",'+
            '"surfaceArea" : 1001}'+
            ']'	+ 
          '}]';  
            
 		system.debug('---'+JsonMsg);
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FDR';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlFDRequirementService.doPost(); 
        Test.stopTest();
    }
    
    static testMethod void testPost_SaveHAP(){
        String jsonHAP=     '[{'+
        '   "bacConfigurationID" : "'+bac.id+'",'+
        '   "fdrRecordType": "HAP Functional Design",'+  
        '   "name": "HAP Design Test_1",'+
        '   "Active": true,'+
        '   "records": ['+
        '   {'+
        '       "hapType": "Front Plate",'+
        '       "keepDimensionsSameForAllTheSize": true,'+
        '       "plateDesign": "Flat",'+
        '       "thicknessLimit": "23",'+
        '       "dimension": ['+
        '           {'+
        '               "name": "XS",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 1400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 225'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 250'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 275'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 300'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 325'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 350'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 425'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }'+
        ''+
        '       ],'+
        '       "surfacearea": ['+
        '           {'+
        '               "name": "XS",'+
        '               "value": 1'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": 2'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": 3'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": 4'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": 5'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": 6'+
        '           }]'+
        '   },'+
        '   {'+
        '       "hapType": "Back Plate",'+
            '       "keepDimensionsSameForAllTheSize": true,'+
        '       "plateDesign": "Flat",'+
        '       "thicknessLimit": "23",'+
        '       "dimension": ['+
        '           {'+
        '               "name": "XS",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 1400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 225'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 250'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 275'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 300'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 325'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 350'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 425'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]          }'+
        ''+
        '       ],'+
        '       "surfacearea": [{'+
        '               "name": "XS",'+
        '               "value": 1'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": 2'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": 3'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": 4'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": 5'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": 6'+
        '           }]'+
        '   },'+
        '   {'+
        '       "hapType": "Side Plate",'+
            '       "keepDimensionsSameForAllTheSize": true,'+
        '       "plateDesign": "Flat",'+
        '       "thicknessLimit": "23",'+
        '       "dimension": ['+
        '           {'+
        '               "name": "XS",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 1400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 225'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 250'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 275'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 300'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 325'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 350'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 10'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 375'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": [{'+
        '                   "name": "A",'+
        '                   "value": 400'+
        '               }, {'+
        '                   "name": "B",'+
        '                   "value": 425'+
        '               }, {'+
        '                   "name": "C",'+
        '                   "value": 12'+
        '               }, {'+
        '                   "name": "D",'+
        '                   "value": 7'+
        '               }]'+
        '           }'+
        ''+
        '       ],'+
        '       "surfacearea": [{'+
        '               "name": "XS",'+
        '               "value": 1'+
        '           }, {'+
        '               "name": "S",'+
        '               "value": 2'+
        '           }, {'+
        '               "name": "M",'+
        '               "value": 3'+
        '           }, {'+
        '               "name": "L",'+
        '               "value": 4'+
        '           }, {'+
        '               "name": "XL",'+
        '               "value": 5'+
        '           }, {'+
        '               "name": "XXL",'+
        '               "value": 6'+
        '           }'+
        ''+
        '       ]'+
        '   }'+
        '   ]'+
        '}]';
        system.debug('json temp : ' + jsonHAP);
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FDR';  
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(jsonHAP);
            RestContext.request = req;
            RestContext.response= res;
            CtrlFDRequirementService testFDR=new CtrlFDRequirementService();   
            CtrlFDRequirementService.doPost(); 
        Test.stopTest();
    }
    static testMethod void testPost_SaveOther(){
        String jsonOther = ' [{'+
       '   "bacConfigurationID" : "'+bac.id+'",'+
        '"fdrRecordType" :"Other Requirement",'+
        '"name" : "other Details1",'+
        '"active" : true,'+
        
        '"weight":['+
               ' {"size": "XS" ,'+
                '"outerCarrier":7,'+
                '"sapPouch":3'+
               ' },'+
                ' {"size": "M" ,'+
                ' "outerCarrier":7,'+
                ' "sapPouch":3'+
                ' },'+
                 '{"size": "L" ,'+
                ' "outerCarrier":7,'+
                 '"sapPouch":3'+
                ' }'+
                ' ,'+
                ' {"size": "XL" ,'+
               '  "outerCarrier":7,'+
                ' "sapPouch":3'+
                ' },'+
                ' {"size": "XXL" ,'+
               '  "outerCarrier":7,'+
               '  "sapPouch":3'+
                ' },'+
                  ' {"size": "S" ,'+
               '  "outerCarrier":7,'+
               '  "sapPouch":3'+
                ' }'+
           '  ],'+
            
        '"weightLimit":['+
                  '  {   "size" : "XS" ,'+
                       ' "sap":7,'+
                      '  "hap":3'+
                  '  },'+
                   ' {   "size" : "S" ,'+
                      '  "sap":7,'+
                      '  "hap":3'+
                   ' },'+
                   ' {   "size" : "M" ,'+
                      '  "sap":7,'+
                     '   "hap":3'+
                   ' }'+
                   ' ,'+
                  '  {  "size" : "XL" ,'+
                      '  "sap":7,'+
                      '  "hap":3'+
                  '  },'+
                   '  {  "size" : "XXL" ,'+
                       ' "sap":7,'+
                       ' "hap":3'+
                  '  },'+
                    '  {  "size" : "L" ,'+
                       ' "sap":7,'+
                       ' "hap":3'+
                   ' }'+
              '  ],'+
       ' "totalWeightLimit":['+
                    ' {  "size" : "XS" ,'+
                       ' "weightLimit":23'+
                    ' },'+
                    ' {  "size" : "S" ,'+
                       ' "weightLimit":23'+
                  '   },'+
                    ' {    "size" : "M" ,'+
                       ' "weightLimit":23'+
                   '  }'+
                   '  ,'+
                  '   {'+
                     ' "size" : "L" ,'+
                       ' "weightLimit":23'+
                   ' }, ' +
                  '   {    "size" : "XL" ,'+
                        '"weightLimit":23'+
                   '  }'+
                  '   ,'+
                   '  {    "size" : "XXL" ,'+
                       ' "weightLimit":23'+
                   '  }'+
                  '  ],'+
            
        '"flammabilityProtection":true,'+
       ' "flammabilityStandard": "Other",'+
        '"flammabilityComment":"xxxx",'+
       ' "standardizedPanel": true,'+
       ' "panelFlexibilityReference": "Other",'+
        '"FlammabilityStandardOtherComment": "Flammability Other",'+
        ' "panelFlexibilityOtherComment": "Flexibility Other",'+
       ' "panelComment":"xxxx",'+
       ' "requireThirdPartyCertification":true,'+
        '"standardName":["name","test"],'+
      '  "standardComment":"xxx",'+
      '  "testLabComment":"xxxeeee",'+
        '"testLaboratory":["std1"]'+
            
        '}]';
        system.debug('json temp : ' + jsonOther);
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FDR';  
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(jsonOther);
            RestContext.request = req;
            RestContext.response= res;
            CtrlFDRequirementService testFDR=new CtrlFDRequirementService();   
            CtrlFDRequirementService.doPost(); 
        Test.stopTest();
    }
}
/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlUpdateFDRService.
 ********************************************************************************/
@isTest
private class CtrlUpdateFDRService_UT {
    
public static User user1;
public static BA_Configuration__c  bac;
public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5,m6,m7;
public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
public static Functional_Design_Requirement__c fdr1,fdr2,fdr3;
public static Map<String,Id> rTNameToIDMap;
    
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
    m2 = testData_Kevlar_UT.getMessage2(); 
    respMsgList.add(m2); 
     m3 = testData_Kevlar_UT.getMessage3();
    respMsgList.add(m3); 
     m5 = testData_Kevlar_UT.getMessage17();
    respMsgList.add(m5);
     m6 = testData_Kevlar_UT.getMessage517();
    respMsgList.add(m6);
     m7 = testData_Kevlar_UT.getMessage545();
    respMsgList.add(m7);  
    insert respMsgList;
    
    List<RecordType> fdrRTList=new List<RecordType>();
    List<Functional_Design_Requirement__c> fdrList = new List<Functional_Design_Requirement__c>();
    rTNameToIDMap=new Map<String,Id>();
    
    fdrRTList=[Select Id,developerName From RecordType Where SobjectType = 'Functional_Design_Requirement__c' AND (developerName = 'Body_Armor_Functional_Design' OR 
              developerName='HAP_Functional_Design' OR developerName='Other_Requirement')];
    for(RecordType rt :fdrRTList){
        rTNameToIDMap.put(rt.developerName,rt.id);
    }
        
    fdr1= new Functional_Design_Requirement__c();
    fdr2= new Functional_Design_Requirement__c();
    fdr3= new Functional_Design_Requirement__c();
    
    fdr1.name='FDR123';
    fdr1.RecordTypeId=rTNameToIDMap.get('HAP_Functional_Design');
    fdr1.Active__c=true;
    fdr1.BA_Configuration__c=bac.id;
    fdr1.Keep_FP_dimensions_same_for_all_the_size__c=false;
    fdr1.Keep_BP_dimensions_same_for_all_the_size__c=false;
    fdr1.Keep_SP_dimensions_same_for_all_the_size__c=false;
    fdrList.add(fdr1);
    fdr2.name='FDR456';
    fdr2.RecordTypeId=rTNameToIDMap.get('Other_Requirement');
    fdr2.Active__c=true;
    fdr2.BA_Configuration__c=bac.id;
    fdr2.Flammability_Protection_Needed__c=false;
    fdrList.add(fdr2);
    fdr3.name='FDR789';
    fdr3.RecordTypeId=rTNameToIDMap.get('Body_Armor_Functional_Design');
    fdr3.Active__c=true;
    fdr3.Front_plate__c = true;
    fdr3.Back_plate__c = true;
    fdr3.Side_plate__c = true;
    fdr3.BA_Configuration__c=bac.id;
    fdrList.add(fdr3);
    
    insert fdrList;
}


static testMethod void testPostBAFD(){
    String jsonBAFD = '[{'+
		''+
		'"active":true,'+
		'"bacConfigurationID":"'+bac.id +'",'+
		'"backPlate":true,'+
		'"color":"Khaki Green",'+
		'"fdrRecordType":"Body Armor Functional Design",'+
		'"lastSync":"2050-06-30T12:28:31.000Z",'+
		'"id" : "'+ fdr3.id +'",'+
		'"frontPlate":false,'+
		'"groin":false,'+
		'"groinShape":"",'+
		'"molleSystem":true,'+
		'"name":"SAP Design 2",'+
		'"neckAndCollar":true,'+
		'"platePockets":true,'+
		'"pouches":false,'+
		'"quickRelease":true,'+
		'"shoulder":true,'+
		'"sidePlate":false,'+
		'"selectedSizes":['+
		'	{'+
		'		"size":"XS",'+
		'		"value":true'+
		'	},'+
		'	{'+
		'		"size":"S",'+
		'		"value":true'+
		'	},'+
		'	{'+
		'		"size":"M",'+
		'		"value":true'+
		'	},'+
		'	{'+
		'		"size":"L",'+
		'		"value":true'+
		'	},'+
		'	{'+
		'		"size":"XL",'+
		'		"value":true'+
		'	},'+
		'	{'+
		'		"size":"XXL",'+
		'		"value":true'+
		'	}'+
		'],'+
		'"dimension":[{'+
		'        "name":"XS",'+
		'    "value":[{'+
		'            "name":"A",'+
		'			"value":110'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":220'+
		'        },'+
		'        {'+
		'            "name":"C",'+
		'			"value":146'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":237'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":292'+
		'        }]'+
		'    },'+
		'    {'+
		'        "name":"S",'+
		'		"value":[{'+
		'            "name":"A",'+
		'			"value":406'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":254'+
		'		},'+
		'        {'+
		'            "name":"C",'+
		'			"value":123'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":288'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":343'+
		'        }]'+
		'    },'+
		'    {'+
		'        "name":"M",'+
		'		"value":[{'+
		'            "name":"A",'+
		'			"value":520'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":279'+
		'        },'+
		'        {'+
		'            "name":"C",'+
		'			"value":196'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":339'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":394'+
		'        }]'+
		'    },'+
		'    {'+
		'        "name":"L",'+
		'		"value":[{'+
		'            "name":"A",'+
		'			"value":634'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":304'+
		'        },'+
		'        {'+
		'            "name":"C",'+
		'			"value":221'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":390'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":445'+
		'        }]'+
		'    },'+
		'    {'+
		'        "name":"XL","value":[{'+
		'            "name":"A",'+
		'			"value":748'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":329'+
		'        },'+
		'        {'+
		'            "name":"C",'+
		'			"value":246'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":441'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":496'+
		'        }]'+
		'    },'+
		'    {'+
		'        "name":"XXL",'+
		'		"value":[{'+
		'            "name":"A",'+
		'			"value":862'+
		'        },'+
		'        {'+
		'            "name":"B",'+
		'			"value":354'+
		'        },'+
		'        {'+
		'            "name":"C",'+
		'			"value":27'+
		'        },'+
		'        {'+
		'            "name":"D",'+
		'			"value":492'+
		'        },'+
		'        {'+
		'            "name":"E",'+
		'			"value":547'+
		'        }]'+
		'    }],'+
		'"surfaceAreaOfBodyArmor":[{'+
		'        "name":"XS",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'    },'+
		'    {'+
		'        "name":"S",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'	},'+
		'    {'+
		'        "name":"M",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'	},'+
		'    {'+
		'        "name":"L",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'	},'+
		'    {'+
		'        "name":"XL",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'	},'+
		'    {'+
		'        "name":"XXL",'+
		'		"torsoSurfaceArea":100,'+
		'		"shoulderLRSurfaceArea":100,'+
		'		"neckCollarSurfaceArea" : 100,'+
		'		"groinSurfaceArea" : 100,'+
		'		"totalSurfaceArea" : 100'+
		'	}],'+
		'"surfaceAreaOfPounch":[{'+
		'        "name":"XS",'+
		'		"surfaceArea":100'+
		'    },'+
		'    {'+
		'        "name":"S",'+
		'		"surfaceArea":200'+
		'    },'+
		'    {'+
		'        "name":"M",'+
		'		"surfaceArea":301'+
		'    },'+
		'    {'+
		'        "name":"L",'+
		'		"surfaceArea":400'+
		'    },'+
		'    {'+
		'        "name":"XL",'+
		'		"surfaceArea":50'+
		'    },'+
		'    {'+
		'        "name":"XXL",'+
		'		"surfaceArea":600'+
		'    }]'+
		'}'+
		']';
    system.debug('---->'+jsonBAFD);
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateFDR';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonBAFD);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateFDRService FDR=new CtrlUpdateFDRService();   
    CtrlUpdateFDRService.doPost(); 
    Test.stopTest();
}
    
 // test code when plate selection gets reset
 
      /*  static testMethod void testDoPostHAP2() {   
        String jsonHAP=     '[{'+
        '   "bacConfigurationID" : "'+bac.id+'",'+
        '   "fdrRecordType": "HAP Functional Design",'+
        '   "Id" :"'+fdr1.id+'",'+
        '   "lastSync":"2020-12-20T11:49:46.000+0000",'+
        '   "name": "HAP Design Test_1",'+
        '   "Active": true,'+
        '   "frontPlate":false,'+    
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
        '           }'+
        ''+
        '       ]'+
        '   }'+
        '   ]'+
        '}]';
    
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UpdateFDR';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonHAP);
        RestContext.request = req;
        RestContext.response= res;
        CtrlUpdateFDRService FDR=new CtrlUpdateFDRService();   
        CtrlUpdateFDRService.doPost(); 
        Test.stopTest();
    } */

static testMethod void testDoPostHAP() {   
    String jsonHAP=     '[{'+
    '   "bacConfigurationID" : "'+bac.id+'",'+
    '   "fdrRecordType": "HAP Functional Design",'+
    '   "Id" :"'+fdr1.id+'",'+
    '   "lastSync":"2020-12-20T11:49:46.000+0000",'+
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
    '           }'+
    ''+
    '       ]'+
    '   }'+
    '   ]'+
    '}]';

    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateFDR';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonHAP);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateFDRService FDR=new CtrlUpdateFDRService();   
    CtrlUpdateFDRService.doPost(); 
    Test.stopTest();
}   
static testMethod void testDoPostOther() {   
    String jsonOther = ' [{'+
   '   "bacConfigurationID" : "'+bac.id+'",'+
    '"fdrRecordType" :"Other Requirement",'+
     '   "Id" :"'+fdr2.id+'",'+
    '   "lastSync":"2020-12-20T11:49:46.000+0000",'+
    '   "name": "other Details1",'+
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
   '"FlammabilityStandardOtherComment": "Flammability Other",'+
    '"flammabilityComment":"xxxx",'+
   ' "standardizedPanel": true,'+
   ' "panelFlexibilityReference": "Other",'+
  ' "panelFlexibilityOtherCommen": "Flexibility Other",'+
   ' "panelComment":"xxxx",'+
   ' "requireThirdPartyCertification":true,'+
    '"standardName":["name"],'+
  '  "standardComment":"xxx",'+
   '  "testLabComment":"xxxttt",'+
    '"testLaboratory":["std1"]'+
        
    '}]';
    system.debug('json temp : ' + jsonOther);
    Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/UpdateFDR';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonOther);
        RestContext.request = req;
        RestContext.response= res;
        CtrlUpdateFDRService testFDR=new CtrlUpdateFDRService();   
        CtrlUpdateFDRService.doPost(); 
    Test.stopTest();
}
static testMethod void testDoPostHAP1() {   
    String jsonHAP=     '[{'+
    '   "bacConfigurationID" : "'+bac.id+'",'+
    '   "fdrRecordType": "HAP Functional Design",'+
    '   "Id" :"'+fdr1.id+'",'+
    '   "lastSync":"2020-12-20T11:49:46.000+0000",'+
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
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }'+
    ''+
    '       ],'+
    '       "surfacearea": [{'+
    '               "name": "XS",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": null'+
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
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }'+
    ''+
    '       ],'+
    '       "surfacearea": [{'+
    '               "name": "XS",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": null'+
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
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": [{'+
    '                   "name": "A",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "B",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "C",'+
    '                   "value": null'+
    '               }, {'+
    '                   "name": "D",'+
    '                   "value": null'+
    '               }]'+
    '           }'+
    ''+
    '       ],'+
    '       "surfacearea": [{'+
    '               "name": "XS",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "S",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "M",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "L",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XL",'+
    '               "value": null'+
    '           }, {'+
    '               "name": "XXL",'+
    '               "value": null'+
    '           }'+
    ''+
    '       ]'+
    '   }'+
    '   ]'+
    '}]';

    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateFDR';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonHAP);
    RestContext.request = req;
    RestContext.response= res;
    CtrlUpdateFDRService FDR=new CtrlUpdateFDRService();   
    CtrlUpdateFDRService.doPost(); 
    Test.stopTest();
}   
}
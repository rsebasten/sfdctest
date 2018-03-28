/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlSaveBAMService.
 ********************************************************************************/
@isTest
private class CtrlSaveBAMService_UT {   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static Body_Armor_Solution__c bas,bs,bs2,bs1;
    Public static List<Body_Armor_Solution__c> basList=new List<Body_Armor_Solution__c>();
    public static User user1;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm,mm1 ;
    Public static List<Material_Master__c> mmList=new List<Material_Master__c>();
    public static Material_Type__c mtype,mtype1;
    Public static List<Material_Type__c> mtypeList=new List<Material_Type__c>();
    public static Profile p;
    public static Map<String,Id> rTNameToIDMap;
    Public static List<RecordType> basRTList=new List<RecordType>();
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage38();
        respMsgList.add(m4); 
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
    
    rTNameToIDMap=new Map<String,Id>();
    
     basRTList=[Select Id,developerName From RecordType Where SobjectType = 'Body_Armor_Solution__c' AND (developerName = 'SAP_Solution' OR 
          developerName='HAP_Solution')];
     for(RecordType rt :basRTList){
     rTNameToIDMap.put(rt.developerName,rt.id);
     }   
   
    bs = new Body_Armor_Solution__c();
    bs.BA_Configuration__c = dat1.id;
    bs.name='hap solution1';
    bs.Body_Armor_Solution_ID_iOS__c = 'test123';
    bs.RecordTypeId=rTNameToIDMap.get('HAP_Solution');
    bs.Comments__c = 'yyyyy';
    basList.add(bs);
    bs1 = new Body_Armor_Solution__c();
    bs1.BA_Configuration__c = dat1.id;
    bs1.name='hap solution2';
    bs1.Body_Armor_Solution_ID_iOS__c = 'testtest';
    bs1.RecordTypeId=rTNameToIDMap.get('HAP_Solution');
    bs1.Comments__c = 'tttttt';
    basList.add(bs1);
    bs2 = new Body_Armor_Solution__c();
    bs2.BA_Configuration__c = dat1.id;
    bs2.name='hap solution3';
    bs2.Body_Armor_Solution_ID_iOS__c = 'testtest1';
    bs2.RecordTypeId=rTNameToIDMap.get('HAP_Solution');
    bs2.Comments__c = 'xxxxxx';
    basList.add(bs2);
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = dat1.id;
    bas.name='Sap solution1';
    bas.Body_Armor_Solution_ID_iOS__c = 'test123';
    bas.RecordTypeId=rTNameToIDMap.get('SAP_Solution');
    bas.Related_To_BAM_HAP_1__c = bs.id;
    bas.Related_To_BAM_HAP_2__c = bs1.id;
    bas.Related_To_BAM_HAP_3__c = bs2.id;
    bas.Comments__c = 'dfasdfa';
    bas.IsSelectedBAM__c = true;
    basList.add(bas);
    insert basList; 
    
    System.debug('Inserted bas: '+ bas.Id);
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    mm.Material_Orign__c = 'Dupont';
    mmList.add(mm);
    mm1 = new Material_Master__c();
    mm1.Material_Type__c = 'Partner';
    mm1.Material_Orign__c = 'Partner';
    mmList.add(mm1);
    insert mmList;
    mtype = new Material_Type__c();
    mtype.name = 'test';
    mtype.SAP_Material__c = mm.Id;
    mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype);
    mtype1 = new Material_Type__c();
    mtype1.name = 'test';
    mtype1.SAP_Material__c = mm1.Id;
    mtype1.Number_of_Layers__c = '2';
    mtype1.Body_Armor_SAP_Solution__c = bas.id;
    mtype1.Material_used__c = 'Partner';
    mtype1.GSM__c = 2;
    mtype1.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype1);
    insert mtypeList;
    
    }
   static testMethod void testDoPost() { 
        String JsonMsg= '{'+  
        '"bacConfigurationID" : "'+dat1.id+'",'+       
        '"solutions" : ['+
        '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs.id+'"'+
        '},'+
       '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs1.id+'"'+
        '},'+         
       '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs2.id+'"'+
       ' }]'+
        '}';
 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SaveBAM';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlSaveBAMService testFDR=new CtrlSaveBAMService();   
        CtrlSaveBAMService.doPost(); 
        Test.stopTest();
    }
    static testMethod void testDoPost_1() { 
        String JsonMsg= '{'+  
        '"bacConfigurationID" : "'+dat1.id+'",'+       
        '"solutions" : ['+
        '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs.id+'"'+
        '},'+              
       '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs2.id+'"'+
       ' }]'+
        '}';
 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SaveBAM';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlSaveBAMService testFDR=new CtrlSaveBAMService();   
        CtrlSaveBAMService.doPost(); 
        Test.stopTest();
    }
     static testMethod void testDoPost_2() { 
        String JsonMsg= '{'+  
        '"bacConfigurationID" : "'+dat1.id+'",'+       
        '"solutions" : ['+
        '{'+
          '"sapSolutionID":  "'+bas.id+'",'+
          '"hapSolutionID":  "'+bs.id+'"'+
        '}]'+
        '}';
 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SaveBAM';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlSaveBAMService testFDR=new CtrlSaveBAMService();   
        CtrlSaveBAMService.doPost(); 
        Test.stopTest();
    }
     static testMethod void testDoPost_3() { 
        String JsonMsg= '';
       
 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SaveBAM';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlSaveBAMService testFDR=new CtrlSaveBAMService();   
        CtrlSaveBAMService.doPost(); 
        Test.stopTest();
    }
}
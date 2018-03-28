/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlHAPSolutionService .
 ********************************************************************************/
@isTest
private class CtrlHAPSolutionService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>();
    public static Body_Armor_Solution__c bas;
    public static User user1;
    public static BA_Configuration__c bac;
    public static  Material_Master__c mm ;
    public static Material_Type__c mtype;
    public static Profile p;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage25();
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
    
    bac=new BA_Configuration__c ();
    bac.Name='abcd';
    bac.Active__c= true;
    bac.status__c='Tender in progress';
    bac.BAC_Progress__c='New Campaigns';
    bac.ownerid = user1.id;
    insert bac;
     
    String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'HAP Solution'].Id;
    
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = bac.id;
    bas.name='hap solution1';
    bas.RecordTypeId=rdId1;
    insert bas; 
    
    System.debug('Inserted bas: '+ bas.Id);
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    insert mm;
   /* 
    mtype = new Material_Type__c();
    mtype.name = 'test';
    mtype.SAP_Material__c = mm.Id;
 //   mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Comments__c= 'xxxxxxx';
    insert mtype;*/
    }
static testMethod void testDoPost() {
 // Adding dummy value  
    String JsonMsg='[{'+
   ' "bacConfigurationID" : "'+bac.id+'",'+
    '"basRecordType" : "HAP Solution",'+
   ' "name" : "HAP Solution test1",'+
    '"active" : true,'+
   ' "solutionComment" : "xxxx",'+
   ' "records" : [  '+                 
                '{'+
                   ' "hapType" :  "Back Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
                '},   '  +                              
                   '{'+
                      ' "hapType" :  "Front Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
               '},   '  +                              
                   '{'+
                      ' "hapType" :  "Side Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
                '}'+
  ' ],'+
   ' "weight":          ['+
                              '{ "size" : "XS", "value" : 12},'+
                              '{ "size" : "S", "value" : 12},'+
                             ' { "size" : "M", "value" : 12},'+
                              '{ "size" : "L", "value" : 12},'+
                              '{ "size" : "XL","value" : 12},'+
                              '{ "size" : "XXL","value" : 12} '+
                        ' ]'+
   
'}]';
    
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/SAPSolution';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlHAPSolutionService testTHR=new CtrlHAPSolutionService ();   
    CtrlHAPSolutionService.doPost(); 
    Test.stopTest();
    }
    
   static testMethod void testDoPost1() {
 // Adding dummy value  
    String JsonMsg='[{'+
   ' "bacConfigurationID" : "'+bac.id+'",'+
    '"basRecordType" : "HAP Solution",'+
   ' "name" : "HAP Solution test1",'+
    '"active" : true,'+
   ' "arealDensity" : 2,'+
   ' "sapThickness" : 2,'+
    '"iosId" : "abcds1234",'+
   ' "solutionComment" : "xxxx",'+
   '"baSolutionID": "'+bas.id+'",'+
   ' "lastSync":"2020-12-20T11:49:46.000+0000",'+
  ' "records" : [  '+                 
                '{'+
                   ' "hapType" :  "Back Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
                '},   '  +                              
                   '{'+
                      ' "hapType" :  "Front Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
                '},   '  +                              
                   '{'+
                      ' "hapType" :  "Side Plate",'+
                    ' "material" : "Boron",'+
                    '   "materialType" : "m1",'+
                      ' "numberOfLayers" : 2,'+  
                      ' "arealDensity" : 2,'+
                       ' "tileThickness" : 2,'+                   
                     '  "comments" : "eee"'+
                '}'+
  ' ],'+
   ' "weight":          ['+
                              '{ "size" : "XS", "value" : 12},'+
                              '{ "size" : "S", "value" : 12},'+
                             ' { "size" : "M", "value" : 12},'+
                              '{ "size" : "L", "value" : 12},'+
                              '{ "size" : "XL","value" : 12},'+
                              '{ "size" : "XXL","value" : 12} '+
                        ' ]'+
   
  '}]';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/SAPSolution';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlHAPSolutionService  testTHR=new CtrlHAPSolutionService ();   
    CtrlHAPSolutionService.doPost(); 
    Test.stopTest();
    }
   
}
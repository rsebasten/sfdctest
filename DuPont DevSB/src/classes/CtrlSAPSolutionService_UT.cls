/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlPopulateSAPSolutionService.
 ********************************************************************************/
@isTest
private class CtrlSAPSolutionService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>();
    public static Body_Armor_Solution__c bas;
    public static User user1;
    public static BA_Configuration__c bac;
    public static  Material_Master__c mm,mm1 ;
    public static List<Material_Master__c> mmList = new List<Material_Master__c>();
    public static Material_Type__c mtype,mtype1;
    public static List<Material_Type__c> mTypeList = new List<Material_Type__c>();
    public static Profile p;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage31();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage34(); 
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
     
    String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and  Name = 'SAP Solution'].Id;
    
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = bac.id;
    bas.name='hap solution1';
    bas.Body_Armor_Solution_ID_iOS__c = 'test123';
    bas.RecordTypeId=rdId1;
    bas.Comments__c = 'dfasdfa';
    insert bas; 
    
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
    mTypeList.add(mtype);
    mtype1 = new Material_Type__c();
    mtype1.name = 'test';
    mtype1.SAP_Material__c = mm1.Id;
    mtype1.Number_of_Layers__c = '2';
    mtype1.Body_Armor_SAP_Solution__c = bas.id;
    mtype1.Material_used__c = 'Partner';
    mtype1.GSM__c = 2;
    mtype1.Comments__c= 'xxxxxxx';
    mTypeList.add(mtype1);
    insert mTypeList;
    }
static testMethod void testDoPost() {
 // Adding dummy value  
    String JsonMsg='[{'+
   ' "bacConfigurationID" : "'+bac.id+'",'+
    '"basRecordType" : "SAP Solution",'+
   ' "name" : "SAP Solution test1",'+
    '"active" : true,'+
   ' "arealDensity" : 2,'+
   ' "sapThickness" : 2,'+
    '"iosBASolutionID" : "abcds1234",'+
   ' "solutionComments" : "xxxx",'+ 
   ' "weight":          ['+
                              '{ "size" : "XS", "value" : 12},'+
                              '{ "size" : "S", "value" : 12},'+
                             ' { "size" : "M", "value" : 12},'+
                              '{ "size" : "L", "value" : 12},'+
                              '{ "size" : "XL","value" : 12},'+
                              '{ "size" : "XXL","value" : 12} '+
                        ' ],'+
  ' "materials" : [  '+                 
                '{'+
                    ' "materialName" : "Dupont",'+
                    '   "materialOrigin" : "Dupont",'+
                      ' "noOfLayers" : 2,'+
                      ' "gsm" : 2,'+    
                       ' "materialID" : "'+mm.id+'" ,'+                
                     '  "comments" : "eee"'+
                '},   '  +                              
                                '{'+
                       '"materialName" : "Partner",'+
                      ' "materialOrigin" : "Partner",'+
                      ' "noOfLayers" : 4,'+
                      ' "gsm" : 3,'+   
                       ' "materialID" :"'+mm1.id+'" ,'+                     
                      ' "comments" : "efff"'+
                '}'+
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
    CtrlSAPSolutionService testTHR=new CtrlSAPSolutionService();   
    CtrlSAPSolutionService.doPost(); 
    Test.stopTest();
    }
 
   static testMethod void testDoPost1() {
 // Adding dummy value  
    String JsonMsg='[{'+
   ' "bacConfigurationID" : "'+bac.id+'",'+
    '"basRecordType" : "SAP Solution",'+
   ' "name" : "SAP Solution test1",'+
    '"active" : true,'+
   ' "arealDensity" : 2,'+
   ' "sapThickness" : 2,'+
    '"iosBASolutionID" : "abcds1234",'+
   ' "solutionComments" : "xxxx",'+
      '"baSolutionID": "'+bas.id+'",'+
   ' "lastSync":"2020-12-20T11:49:46.000+0000",'+
   ' "weight":          ['+
                              '{ "size" : "XS", "value" : 12},'+
                              '{ "size" : "S", "value" : 12},'+
                             ' { "size" : "M", "value" : 12},'+
                              '{ "size" : "L", "value" : 12},'+
                              '{ "size" : "XL","value" : 12},'+
                              '{ "size" : "XXL","value" : 12} '+
                        ' ],'+
   ' "materials" : [  '+                 
                '{'+
                    ' "materialName" : "Dupont",'+
                    '   "materialOrigin" : "Dupont",'+
                      ' "noOfLayers" : 2,'+
                      ' "gsm" : 2,'+  
                       ' "materialID" : "'+mm.id+'" ,'+                    
                     '  "comments" : "eee"'+
                '},   '  +                              
                 '{'+
                       '"materialName" : "Partner123",'+
                      ' "materialOrigin" : "Dupont",'+
                      ' "noOfLayers" : 4,'+
                      ' "gsm" : 3,'+   
                       ' "materialID" : "" ,'+                  
                      ' "comments" : "efff"'+
                '},   '  +                              
                  '{'+
                       '"materialName" : "Partner",'+
                      ' "materialOrigin" : "Partner",'+
                      ' "noOfLayers" : 4,'+
                      ' "gsm" : 3,'+   
                       ' "materialID" :"'+mm1.id+'" ,'+                   
                      ' "comments" : "efff"'+
                '}'+
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
    CtrlSAPSolutionService testTHR=new CtrlSAPSolutionService();   
    CtrlSAPSolutionService.doPost(); 
    Test.stopTest();
    }
}
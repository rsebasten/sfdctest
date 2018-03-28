/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlPopulateSAPSolutionService.
 ********************************************************************************/
@isTest
private class CtrlPopulateSAPSolutionService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static Body_Armor_Solution__c bas,bas1;
    public static User user1;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm ;
    public static Material_Type__c mtype,mtype1;     
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
    
    dat1=new BA_Configuration__c ();
    dat1.Name='abcd';
    dat1.Active__c= true;
    dat1.status__c='Tender in progress';
    dat1.BAC_Progress__c='New Campaigns';
    dat1.ownerid = user1.id;
    insert dat1;
     
    String rdId2 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'SAP Solution'].Id; 
    List<Body_Armor_Solution__c> basList = new List<Body_Armor_Solution__c>();
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = dat1.id;
    bas.name='sap solution1';
    bas.RecordTypeId=rdId2;
    bas.Active__c= true;
    bas.Areal_Density__c =2;
    bas.SAP_Thickness__c =2;
    bas.Comments__c= 'xxxx';
    bas.SAP_weight_of_XL_size__c = 12;
    bas.SAP_weight_of_XXL_size__c = 12;
    bas.SAP_weight_of_XS_size__c = 12;
    bas.SAP_weight_of_L_size__c = 12;
    bas.SAP_weight_of_M_size__c = 12;
    bas.SAP_weight_of_S_size__c = 12;
    basList.add(bas);
    
    bas1 = new Body_Armor_Solution__c();
    bas1.BA_Configuration__c = dat1.id;
    bas1.name='sap solution1';
    bas1.RecordTypeId=rdId2;
    bas1.Active__c= true;
    bas1.Areal_Density__c = null;
    bas1.SAP_Thickness__c =null;
    bas1.SAP_weight_of_XL_size__c = null;
    bas1.SAP_weight_of_XXL_size__c = null;
    bas1.SAP_weight_of_XS_size__c = null;
    bas1.SAP_weight_of_L_size__c = null;
    bas1.SAP_weight_of_M_size__c = null;
    bas1.SAP_weight_of_S_size__c = null;
    bas1.Comments__c= '';
    basList.add(bas1);
    insert basList; 
    
    System.debug('Inserted bas: '+ bas.Id);
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    insert mm;
    
    List<Material_Type__c> mtypeList = new List<Material_Type__c>(); 
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
    mtype1.name = '';
    mtype1.SAP_Material__c = mm.Id;
    mtype1.Number_of_Layers__c = '';
    mtype1.Body_Armor_SAP_Solution__c = bas1.id;
    mtype1.Material_used__c = '';
    mtype1.GSM__c = null;
    mtype1.Comments__c= '';    
    mtypeList.add(mtype1);    
    insert mtypeList;
    
    }
static testMethod void testDoPost() {
 // Adding dummy value   
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'"'+
    '}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/PopulateSAPSolution';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlPopulateSAPSolutionService testPopulateSAP=new CtrlPopulateSAPSolutionService();   
    CtrlPopulateSAPSolutionService.doPost(); 
    Test.stopTest();
    }
  static testMethod void testDoPost1() {
 // Adding dummy value   
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'"'+
    '}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/PopulateSAPSolution';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlPopulateSAPSolutionService testPopulateSAP=new CtrlPopulateSAPSolutionService();   
    CtrlPopulateSAPSolutionService.doPost(); 
    Test.stopTest();
    } 
}
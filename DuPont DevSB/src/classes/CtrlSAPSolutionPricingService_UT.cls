/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlSAPSolutionPricingService.
 ********************************************************************************/
@isTest
private class CtrlSAPSolutionPricingService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList= new List<Kevlar_Response_Messages__c>(); 
    public static Body_Armor_Solution__c bas;
    public static User user1;
    public static Solution_Pricing__c sp;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm ;
    public static Material_Type__c mtype;     
    public static Profile p;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage27();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage28(); 
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
    insert bas; 
    
    System.debug('Inserted bas: '+ bas.Id);
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    insert mm;
     
    mtype = new Material_Type__c();
    mtype.name = 'test';
    mtype.SAP_Material__c = mm.Id;
 //   mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_Price_SAP__c = 10.2;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Material_Price_SAP__c = 10;
    mtype.Comments__c= 'xxxxxxx';
   
    insert mtype;
    
   String rdIdsp = [Select Id From RecordType Where SobjectType = 'Solution_Pricing__c' and Name = 'SAP Solution Pricing'].Id; 
    
    sp = new Solution_Pricing__c();
    sp.name= 'sp price1';
    sp.Active__c= true;
    sp.RecordTypeId=rdIdsp;
    sp.BA_Configuration__c = dat1.id;
    sp.Select_SAP_Solution__c = bas.id;
    sp.Total_cost_of_Body_Armour_for_size_XXL__c = 2;
    sp.Total_cost_of_Body_Armour_for_size_XL__c = 2;
    sp.Total_cost_of_Body_Armour_for_size_L__c = 2;
    sp.Total_cost_of_Body_Armour_for_size_XS__c = 2;
    sp.Total_cost_of_Body_Armour_for_size_S__c = 2;
    sp.Total_cost_of_Body_Armour_for_size_M__c = 2;
    sp.Material_Wastage_Comment__c = 'xxxxxx';
    sp.Cost_Of_Outer_Carrier__c = 2;
    sp.Cost_Of_SAP_Pouches__c = 3;
    sp.SAP_Material_Wastage__c = 2;
    sp.BAM_Margin__c = 3;
    sp.Cost_Comment__c = 'xxxx';
    insert sp;
    }
static testMethod void testDoPost() {
 // Adding dummy value   
    String JsonMsg='[{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+
    '"active" : true,'+
    '"baSolutionID":"'+bas.id+'",'+
    '"iosBASolutionPricingID":"test1234",'+
    '"name":"solutionprice1",'+
    '"costOfOuterCarrier":200,'+
    '"costOfPouches":250,'+
    '"costComment":"xxxxx",'+
    '"sapMaterialWastage":1.5,'+
    '"wastageComment":"xxxxxyyyy",'+
    '"bamMargin":2.0,'+
    '"marginComment":"yyyyy",'+
    '"lastSync":"2020-12-20T11:49:46.000+0000",'+
    '"baSolutionPricingID":"'+sp.id+'",'+
    '"materials":'+
                '['+
                    '{'+
                        '"materialID":"'+mm.id+'",'+
                        '"materialName":"Dupont",'+
                        '"materialPrice":"100"'+
                    '}'+
                   
                '],'+
                '"totalPrice":  '+
                            '['+
                                  '{ "size" : "XS", "cost" : 12},'+
                                 ' { "size" : "M", "cost" : 12},'+
                                 ' {"size" : "L","cost" : 12},'+
                                  ' {"size" : "S","cost" : 12},'+
                                 ' { "size" : "XL", "cost" : 12},'+
                                 ' { "size" : "XXL", "cost" : 12} '+
                            '] '+

'}]';

    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/SAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlSAPSolutionPricingService testPopulateSAP=new CtrlSAPSolutionPricingService();   
    CtrlSAPSolutionPricingService.doPost(); 
    Test.stopTest();
}
static testMethod void testDoPost1() {
 // Adding dummy value   
    String JsonMsg='[{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+
    '"active" : true,'+
    '"baSolutionID":"'+bas.id+'",'+
    '"iosBASolutionPricingID":"test1234",'+
    '"name":"solutionprice1",'+
    '"costOfOuterCarrier":200,'+
    '"costOfPouches":250,'+
    '"costComment":"xxxxx",'+
    '"sapMaterialWastage":1.5,'+
    '"wastageComment":"xxxxxyyyy",'+
    '"bamMargin":2.0,'+
    '"marginComment":"yyyyy",'+
    '"materials":'+
                '['+
                    '{'+
                        '"materialID":"'+mm.id+'",'+
                        '"materialName":"Dupont",'+
                        '"materialPrice":"100"'+
                    '}'+
                '],'+
                '"totalPrice":  '+
                            '['+
                                  '{ "size" : "XS", "cost" : 12},'+
                                 ' { "size" : "M", "cost" : 12},'+
                                 ' {"size" : "L","cost" : 12},'+
                                  ' {"size" : "S","cost" : 12},'+
                                 ' { "size" : "XL", "cost" : 12},'+
                                 ' { "size" : "XXL", "cost" : 12} '+
                            '] '+

'}]';

    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/SAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlSAPSolutionPricingService testPopulateSAP=new CtrlSAPSolutionPricingService();   
    CtrlSAPSolutionPricingService.doPost(); 
    Test.stopTest();
}  
}
/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlHAPSolutionPricingService .
 ********************************************************************************/
@isTest
private class CtrlHAPSolutionPricingService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList= new List<Kevlar_Response_Messages__c>();
    public static Body_Armor_Solution__c bas,bas1;
    public static User user1;
    public static Solution_Pricing__c hp;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm,mm1,mm2 ;
    public static Material_Type__c mtype,mtype1;
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
     
    String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'HAP Solution'].Id;
    
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    insert mm;
  
    mm1 = new Material_Master__c();
    mm1.Material_Type__c = 'test';
    insert mm1;
  
    mm2 = new Material_Master__c();
    mm2.Material_Type__c = 'test1';
    insert mm2;
    
    
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = dat1.id;
    bas.name='hap solution1';
    bas.RecordTypeId=rdId1;
    bas.Active__c= true;
    bas.Backing_Material_FP__c= mm.id;
    bas.Backing_Material_BP__c= mm1.id;
    bas.Backing_Material_SP__c= mm2.id;
    bas.BP_areal_density__c = 2;
    bas.FP_areal_density__c = 2;
    bas.SP_areal_density__c = 2;
    bas.BP_Plate_Solution_Thickness__c = 2;
    bas.FP_Plate_Solution_Thickness__c = 2;
    bas.SP_Plate_Solution_Thickness__c = 2;
    bas.SP_tile_Thickness__c = 2;
    bas.BP_tile_Thickness__c = 2;
    bas.FP_tile_Thickness__c = 2;
    bas.Backing_layers_BP__c = 2;
    bas.Backing_layers_FP__c = 2;
    bas.Backing_layers_SP__c = 2;
    bas.SP_miscellaneous_price__c = 12;
    bas.BP_miscellaneous_price__c = 12;
    bas.FP_miscellaneous_price__c = 12;
    bas.SP_backing_material_price__c = 10;
    bas.FP_backing_material_price__c = 10;
    bas.BP_backing_material_price__c = 10;
    bas.Material_Master_BP__c = mm.id;
    bas.Material_Master_FP__c = mm1.id;
    bas.Material_Master_SP__c = mm2.id;
    bas.SP_BM_Areal_Density__c = 2;
    bas.FP_BM_Areal_Density__c = 2;
    bas.BP_BM_Areal_Density__c = 2;
    bas.BackingLayerPrice_FP__c = 2;
    bas.BackingLayerPrice_BP__c = 2;
    bas.BackingLayerPrice_SP__c = 2;
    bas.FP_Material_Price__c = 2;
    bas.BP_Material_Price__c = 2;
    bas.SP_Material_Price__c = 2;
    bas.Total_weight_of_XS_size__c = 12;
    bas.Total_weight_of_S_size__c = 12;
    bas.Total_weight_of_M_size__c = 12;
    bas.Total_weight_of_L_size__c = 12;
    bas.Total_weight_of_XL_size__c = 12;
    bas.Total_weight_of_XXL_size__c = 12;
    bas.SP_Comment__c  = 'xxxxx';    
    bas.FP_Comment__c  = 'xxxxx';  
    bas.BP_Comment__c  = 'xxxxx';  
    insert bas; 
    System.debug('Inserted bas: '+ bas.Id);
   
    
    
   /* mtype = new Material_Type__c();
    mtype.name = 'test';
    mtype.SAP_Material__c = mm.Id;
    mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_Price_SAP__c = 10.2;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Material_Price_SAP__c = 10;
    mtype.Comments__c= 'xxxxxxx'; */
   
    
    String rdIdhap = [Select Id From RecordType Where SobjectType = 'Solution_Pricing__c' and Name = 'HAP Solution Pricing'].Id; 
    
    hp = new Solution_Pricing__c();
    hp.Active__c= true;
    hp.name= 'sp price1';
    hp.RecordTypeId=rdIdhap ;
    hp.BA_Configuration__c = dat1.id;
    hp.Select_HAP_Solution__c= bas.id;
    hp.Total_cost_of_Body_Armour_for_size_XXL__c = 2;
    hp.Total_cost_of_Body_Armour_for_size_XL__c = 2;
    hp.Total_cost_of_Body_Armour_for_size_L__c = 2;
    hp.Total_cost_of_Body_Armour_for_size_XS__c = 2;
    hp.Total_cost_of_Body_Armour_for_size_S__c = 2;
    hp.Total_cost_of_Body_Armour_for_size_M__c = 2;
    hp.Material_Wastage_Comment__c = 'xxxxxx';
    hp.Cost_Of_Outer_Carrier__c = 2;
    hp.Solution_package_id_iOS__c = 'abcdISO123';
    hp.Cost_Of_SAP_Pouches__c = 3;
    hp.HAP_Material_Wastage__c= 2;
    hp.BAM_Margin__c = 3;
    hp.Cost_Comment__c = 'xxxx';
    insert hp;
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
    '"baSolutionPricingID":"'+hp.id+'",'+
    '"materials": [{'+
        '"hapType": "Back Plate",'+
        '"materialName": "Boron",'+
        '"materialID": "'+mm2.id+'",'+
        '"materialPrice": 1.02,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm2.id+'",'+
        '"backingMaterialPrice": 1235.25,'+
        '"priceForBackingLayer": 1235.20,'+
        '"miscPrice": 2500.252'+
        '}, {'+
        '"hapType": "Side Plate",'+
        '"materialName": "ide Plate Material",'+
        '"materialID":"'+mm1.id+'",'+
        '"materialPrice": 5236.25,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm1.id+'",'+
        '"backingMaterialPrice": 25.25,'+
        '"priceForBackingLayer": 2.25,'+
        '"miscPrice": 12.25'+
       ' }, {'+
       ' "hapType": "Front Plate",'+
        '"materialName": "Front Plate material",'+
        '"materialID":"'+mm.id+'",'+
       ' "materialPrice": 456.25,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm.id+'",'+
        '"backingMaterialPrice": 46.35,'+
        '"priceForBackingLayer": 5236.25,'+
        '"miscPrice": 12.25'+
       ' }],'+
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
    req.requestURI = '/services/apexrest/HAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlHAPSolutionPricingService testTHR=new CtrlHAPSolutionPricingService();   
    CtrlHAPSolutionPricingService.doPost(); 
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
    '"baSolutionPricingID":"",'+
    '"materials": [{'+
        '"hapType": "Back Plate",'+
        '"materialName": "Boron",'+
        '"materialID": "'+mm2.id+'",'+
        '"materialPrice": 1.02,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm2.id+'",'+
        '"backingMaterialPrice": 1235.25,'+
        '"priceForBackingLayer": 1235.20,'+
        '"miscPrice": 2500.252'+
        '}, {'+
        '"hapType": "Side Plate",'+
        '"materialName": "ide Plate Material",'+
        '"materialID":"'+mm1.id+'",'+
        '"materialPrice": 5236.25,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm1.id+'",'+
        '"backingMaterialPrice": 25.25,'+
        '"priceForBackingLayer": 2.25,'+
        '"miscPrice": 12.25'+
       ' }, {'+
       ' "hapType": "Front Plate",'+
        '"materialName": "Front Plate material",'+
        '"materialID":"'+mm.id+'",'+
       ' "materialPrice": 456.25,'+
        '"backingMaterial": "UHMPE Type",'+
        '"bmMaterialID": "'+mm.id+'",'+
        '"backingMaterialPrice": 46.35,'+
        '"priceForBackingLayer": 5236.25,'+
        '"miscPrice": 12.25'+
       ' }],'+
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
    req.requestURI = '/services/apexrest/HAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlHAPSolutionPricingService testTHR=new CtrlHAPSolutionPricingService();   
    CtrlHAPSolutionPricingService.doPost(); 
    Test.stopTest();
    }
}
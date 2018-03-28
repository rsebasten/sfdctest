/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlPopulateHAPSolutionPricingService .
 ********************************************************************************/
@isTest
private class CtrlPopulateHAPSolutionPricingService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>();
    public static Body_Armor_Solution__c bas,bas1;
    public static User user1;
    public static Solution_Pricing__c hp,hp1;
    public static List<Solution_Pricing__c> hpList = new List<Solution_Pricing__c>();
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm,mm1,mm2 ;
    public static List<Material_Master__c> mmList = new List<Material_Master__c>();
    public static List<Material_Type__c> mtypeList = new List<Material_Type__c>();
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
     
    String rdId1 = [Select Id From RecordType Where SobjectType = 'Body_Armor_Solution__c' and Name = 'HAP Solution'].Id;
    
    mm = new Material_Master__c();
    mm.Material_Type__c = 'Dupont';
    mmList.add(mm);
  
    mm1 = new Material_Master__c();
    mm1.Material_Type__c = 'test';
    mmList.add(mm1);
  
    mm2 = new Material_Master__c();
    mm2.Material_Type__c = 'test1';
    mmList.add(mm2);
    insert mmList;
    
    
    bas = new Body_Armor_Solution__c();
    bas.BA_Configuration__c = dat1.id;
    bas.name='hap solution1';
    bas.RecordTypeId=rdId1;
    bas.Active__c= true;
    bas.Backing_Material_FP__c= mm.id;
    bas.Backing_Material_BP__c= mm1.id;
    bas.Backing_Material_SP__c= mm2.id;
    bas.BackingLayerPrice_SP__c = 2;
    bas.BackingLayerPrice_FP__c = 2;
    bas.BackingLayerPrice_BP__c = 2;
    bas.FP_backing_material_price__c = 10;
    bas.BP_backing_material_price__c = 10;
    bas.SP_backing_material_price__c = 10;
    bas.Body_Armor_Solution_ID_iOS__c = 'abcs123';
    bas.SP_backing_material_price__c = 2;
    bas.FP_backing_material_price__c = 2;
    bas.BP_backing_material_price__c = 2;
    bas.BP_miscellaneous_price__c = 10;
    bas.FP_miscellaneous_price__c = 10;
    bas.SP_miscellaneous_price__c = 10;
    bas.SP_Material_Price__c = 10;
    bas.FP_Material_Price__c = 10;
    bas.BP_Material_Price__c = 10;
    bas.Material_Master_SP__c = mm2.id;
    bas.Material_Master_BP__c = mm1.id;
    bas.Material_Master_FP__c = mm.id;
    bas.Comments__c = 'tttttt';  
    insert bas; 
    System.debug('Inserted bas: '+ bas.Id);
    bas1 = new Body_Armor_Solution__c();
    bas1.BA_Configuration__c = dat1.id;    
    bas1.RecordTypeId=rdId1;
    bas1.Active__c= true;
    bas1.Body_Armor_Solution_ID_iOS__c = 'abcs1';
    insert bas1; 
    
    
    /*mtype = new Material_Type__c();
    mtype.name = 'test2';
    mtype.SAP_Material__c = mm.Id;   
//    mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype);
    mtype1 = new Material_Type__c();
    mtype1.name = '';
    mtype1.SAP_Material__c = mm.Id;   
 //   mtype1.Number_of_Layers__c = '';
    mtype1.Body_Armor_SAP_Solution__c = bas1.id;
    mtype1.Material_used__c = '';
    mtype1.GSM__c = Null;
    mtype1.Comments__c= '';
    mtypeList.add(mtype1);
    insert mtypeList; */
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
    hp.Solution_package_id_iOS__c = 'abcd123';
    //hp.Material_Wastage_Comment__c = 'xxxxxx';
    hp.Cost_Of_Outer_Carrier__c = 2;
    hp.Solution_package_id_iOS__c = 'abcdISO123';
    hp.Cost_Of_SAP_Pouches__c = 3;
    hp.HAP_Material_Wastage__c= 2;
    hp.BAM_Margin__c = 3;
    hp.Cost_Comment__c = 'xxxx';   
    hpList.add(hp);
    hp1 = new Solution_Pricing__c();
    hp1.Active__c= true;
    hp1.name= '';
    hp1.RecordTypeId=rdIdhap ;
    hp1.BA_Configuration__c = dat1.id;
    hp1.Select_HAP_Solution__c= bas1.id;
    hp1.Total_cost_of_Body_Armour_for_size_XXL__c = null;
    hp1.Total_cost_of_Body_Armour_for_size_XL__c = null;
    hp1.Total_cost_of_Body_Armour_for_size_L__c = null;
    hp1.Total_cost_of_Body_Armour_for_size_XS__c = null;
    hp1.Total_cost_of_Body_Armour_for_size_S__c = null;
    hp1.Total_cost_of_Body_Armour_for_size_M__c = null;
    hp1.Solution_package_id_iOS__c = 'test';
    //hp1.Material_Wastage_Comment__c = '';
    hp1.Cost_Of_Outer_Carrier__c = null;
    hp1.Cost_Of_SAP_Pouches__c = null;
    hp1.HAP_Material_Wastage__c= null;
    hp1.BAM_Margin__c = null;
    hp1.Cost_Comment__c = ''; 
    hpList.add(hp1); 
    insert hpList;
    }
static testMethod void testDoPost() {
 // Adding dummy value   
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+
    '"baSolutionID":["'+bas.id+'"]'+
    '}';
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/PopulateHAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlPopulateHAPSolutionPricingService testTHR=new CtrlPopulateHAPSolutionPricingService();   
    CtrlPopulateHAPSolutionPricingService.doPost(); 
    Test.stopTest();
    }
     static testMethod void testDoPost1() {
 // Adding dummy value   
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'",'+
    '"baSolutionID":["'+bas1.id+'"]'+
    '}';
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/PopulateHAPSolutionPricing';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlPopulateHAPSolutionPricingService testTHR=new CtrlPopulateHAPSolutionPricingService();   
    CtrlPopulateHAPSolutionPricingService.doPost(); 
    Test.stopTest();
    }
  
}
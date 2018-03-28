/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlPopulateHAPSolutionService.
 ********************************************************************************/
@isTest
private class CtrlPopulateHAPSolutionService_UT {
   
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> InsertList = new List<Kevlar_Response_Messages__c>();
    public static Body_Armor_Solution__c bas,bas1;
    public static List<Body_Armor_Solution__c> basList = new List<Body_Armor_Solution__c>();
    public static List<Material_Type__c> mtypeList = new List<Material_Type__c>();
    public static User user1;
    public static BA_Configuration__c dat1;
    public static  Material_Master__c mm,mm1,mm2 ;
    public static Material_Type__c mtype,mtype1;
    public static Profile p;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        InsertList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage25();
        InsertList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        InsertList.add(m2);  
        m3 = testData_Kevlar_UT.getMessage3();
        InsertList.add(m3);  
        insert InsertList;
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
    bas.Body_Armor_Solution_ID_iOS__c = 'abcs123';
    bas.SP_tile_Thickness__c = 2;
    bas.BP_tile_Thickness__c = 2;
    bas.FP_tile_Thickness__c = 2;
    bas.Backing_layers_BP__c = 2;
    bas.Backing_layers_FP__c = 2;
    bas.Backing_layers_SP__c = 2;
    bas.SP_BM_Areal_Density__c = 2;
    bas.FP_BM_Areal_Density__c = 2;
    bas.BP_BM_Areal_Density__c = 2;
    bas.No_Of_Layers_BP__c = 2;
    bas.No_Of_Layers_FP__c = 2;
    bas.No_Of_Layers_SP__c = 2;
    bas.BP_Weight__c = 2;
    bas.FP_Weight__c = 2;
    bas.SP_Weight__c = 2;
    bas.Total_weight_of_XS_size__c = 12;
    bas.Total_weight_of_S_size__c = 12;
    bas.Total_weight_of_M_size__c = 12;
    bas.Total_weight_of_L_size__c = 12;
    bas.Total_weight_of_XL_size__c = 12;
    bas.Total_weight_of_XXL_size__c = 12;
    bas.Material_Master_SP__c = mm2.id;
    bas.Material_Master_BP__c = mm1.id;
    bas.Material_Master_FP__c = mm.id;
    bas.SP_Comment__c  = 'xxxxx';    
    bas.FP_Comment__c  = 'xxxxx';  
    bas.BP_Comment__c  = 'xxxxx';  
    bas.Comments__c = 'tttttt';
    basList.add(bas);
    System.debug('Inserted bas: '+ bas.Id);
    bas1 = new Body_Armor_Solution__c();
    bas1.BA_Configuration__c = dat1.id;
    bas1.name='';
    bas1.RecordTypeId=rdId1;
    bas1.Active__c= true;
    bas1.Backing_Material_FP__c= mm.id;
    bas1.Backing_Material_BP__c= mm1.id;
    bas1.Backing_Material_SP__c= mm2.id;
    bas1.BP_areal_density__c = null;
    bas1.FP_areal_density__c = null;
    bas1.SP_areal_density__c = null;
    bas1.BP_Plate_Solution_Thickness__c = null;
    bas1.FP_Plate_Solution_Thickness__c = null;
    bas1.SP_Plate_Solution_Thickness__c = null;
    bas1.Body_Armor_Solution_ID_iOS__c = 'test';
    bas1.SP_tile_Thickness__c = null;
    bas1.BP_tile_Thickness__c = null;
    bas1.FP_tile_Thickness__c = null;
    bas1.Backing_layers_BP__c = null;
    bas1.Backing_layers_FP__c = null;
    bas1.Backing_layers_SP__c = null;
    bas1.SP_BM_Areal_Density__c = null;
    bas1.FP_BM_Areal_Density__c = null;
    bas1.BP_BM_Areal_Density__c = null;
    bas1.No_Of_Layers_BP__c = null;
    bas1.No_Of_Layers_FP__c = null;
    bas1.No_Of_Layers_SP__c = null;
    bas1.BP_Weight__c = null;
    bas1.FP_Weight__c = null;
    bas1.SP_Weight__c = null;
    bas1.SP_Comment__c  = '';    
    bas1.FP_Comment__c  = '';  
    bas1.BP_Comment__c  = '';
    bas1.Comments__c = '';
    bas1.Total_weight_of_XS_size__c = null;
    bas1.Total_weight_of_S_size__c = null;
    bas1.Total_weight_of_M_size__c = null;
    bas1.Total_weight_of_L_size__c = null;
    bas1.Total_weight_of_XL_size__c = null;
    bas1.Total_weight_of_XXL_size__c = null;
    basList.add(bas1);      
    insert basList; 
    
    
  /*  mtype = new Material_Type__c();
    mtype.name = 'test2';
    mtype.SAP_Material__c = mm.Id;   
  //  mtype.Number_of_Layers__c = '2';
    mtype.Body_Armor_SAP_Solution__c = bas.id;
    mtype.Material_used__c = 'Dupont';
    mtype.GSM__c = 2;
    mtype.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype);      
    mtype1 = new Material_Type__c();
    mtype1.name = 'test2';
    mtype1.SAP_Material__c = mm.Id;   
  //  mtype1.Number_of_Layers__c = '2';
    mtype1.Body_Armor_SAP_Solution__c = bas1.id;
    mtype1.Material_used__c = 'Dupont';
    mtype1.GSM__c = 2;
    mtype1.Comments__c= 'xxxxxxx';
    mtypeList.add(mtype1);      
    insert mtypeList;*/
    }
static testMethod void testDoPost() {
 // Adding dummy value   
    String JsonMsg='{'+
    '"bacConfigurationID" : "'+dat1.id+'"'+
    '}';
    Test.startTest();

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/PopulateHAPSolution';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;


    CtrlPopulateHAPSolutionService testTHR=new CtrlPopulateHAPSolutionService();   
    CtrlPopulateHAPSolutionService.doPost(); 
    Test.stopTest();
    }
   
}
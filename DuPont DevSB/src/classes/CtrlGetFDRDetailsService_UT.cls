/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class insert the record in Function design object with selected values of fileds.
 ********************************************************************************************/

@isTest
private class CtrlGetFDRDetailsService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    Public static List<RecordType> fdrRTList=new List<RecordType>();
    Public static List<Functional_Design_Requirement__c> fdrList = new List<Functional_Design_Requirement__c>();
    public static Map<String,Id> rTNameToIDMap;
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage19();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2); 
        m3 = testData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);  
        insert respMsgList;
        
        rTNameToIDMap=new Map<String,Id>();
        
        fdrRTList=[Select Id,developerName From RecordType Where SobjectType = 'Functional_Design_Requirement__c' AND (developerName = 'Body_Armor_Functional_Design' OR 
          developerName='HAP_Functional_Design' OR developerName='Other_Requirement')];
        for(RecordType rt :fdrRTList){
        rTNameToIDMap.put(rt.developerName,rt.id);
        }
    }
    
 static testMethod void testDoPost() {
   
     // Adding dummy value   
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User user1 = new User();     
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
     
   
     BA_Configuration__c dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     insert dat1;
     
     BAC_Team_Member__c tem= new BAC_Team_Member__c();
     tem.BA_Configuration__c = dat1.id;
     tem.name='TM1';
     tem.Team_Member_Name__c=user1.id;
     insert tem; 
     
     Functional_Design_Requirement__c fdr= new Functional_Design_Requirement__c();
     fdr.BA_Configuration__c = dat1.id;
     fdr.name='FDRONE';
     fdr.RecordTypeId=rTNameToIDMap.get('Body_Armor_Functional_Design');
     fdr.Groin_Shape__c = 'xxx';
     fdr.Color__c = 'Black';
     fdr.Dimension_of_XS_size_A__c = 2;
     fdr.Dimension_of_XS_size_B__c = 2;
     fdr.Dimension_of_XS_size_C__c = 2;
     fdr.Dimension_of_XS_size_D__c = 2;
     fdr.Dimension_of_XS_size_E__c = 2;
     fdr.Surface_Area_of_Body_Armour_XS__c= 2;
     fdr.Surface_Area_of_Body_Armour_S__c= 2;
     fdr.Surface_Area_of_Body_Armour_L__c= 2;
     fdr.Surface_Area_of_Body_Armour_M__c= 2;
     fdr.Surface_Area_of_Body_Armour_XL__c= 2;
     fdr.Surface_Area_of_Body_Armour_XXL__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_XS__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_S__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_L__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_M__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_XL__c= 2;
     fdr.Surface_Area_of_SAP_Pouch_XXL__c= 2;
     insert fdr; 
    
     String JsonMsg= '{'+
      '"bacConfigurationID" : "'+dat1.id+'",'+
      '"fdrRecordType" : "Body Armor Functional Design"'+  
      '}';
     
     Test.startTest();

     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
     req.requestURI = '/services/apexrest/GetFDR';  
     req.httpMethod = 'POST';
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;
     CtrlGetFDRDetailsService testuserId=new CtrlGetFDRDetailsService();  
     CtrlGetFDRDetailsService.doPost();  
     Test.stopTest();

   }
    static testMethod void testDoPost2() {
       
     // Adding dummy value   
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User user1 = new User();     
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
     
   
     BA_Configuration__c dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     insert dat1;
     
     BAC_Team_Member__c tem= new BAC_Team_Member__c();
     tem.BA_Configuration__c = dat1.id;
     tem.name='TM1';
     tem.Team_Member_Name__c=user1.id;
     insert tem;      
       
      Functional_Design_Requirement__c fdr= new Functional_Design_Requirement__c();
     fdr.BA_Configuration__c = dat1.id;
     fdr.name='FDRONE';
     fdr.RecordTypeId=rTNameToIDMap.get('Body_Armor_Functional_Design');
     fdr.Back_plate__c=true;
     fdr.Front_plate__c=true;
     fdr.Side_plate__c=true;
     insert fdr; 
     
     Functional_Design_Requirement__c fdr1= new Functional_Design_Requirement__c();
     fdr1.BA_Configuration__c = dat1.id;
     fdr1.name='FDRONE123';
     fdr1.RecordTypeId=rTNameToIDMap.get('HAP_Functional_Design');
     fdr1.Plate_Design_of_SP__c = 'Curved';
     fdr1.Plate_Design_of_BP__c = 'Curved';
     fdr1.Plate_Design_of_front_plate__c = 'Curved';
     fdr1.Surface_Area_FP_size_XS__c = 2;
     fdr1.Surface_Area_FP_size_S__c = 2;
     fdr1.Surface_Area_FP_size_M__c = 2;
     fdr1.Surface_Area_FP_size_L__c = 2;
     fdr1.Surface_Area_FP_size_XXL__c = 2;
     fdr1.Surface_Area_FP_size_XL__c = 2;
     fdr1.Surface_Area_BP_size_XS__c = 2;
     fdr1.Surface_Area_BP_size_S__c = 2;
     fdr1.Surface_Area_BP_size_M__c = 2;
     fdr1.Surface_Area_BP_size_L__c = 2;
     fdr1.Surface_Area_BP_size_XXL__c = 2;
     fdr1.Surface_Area_BP_size_XL__c = 2;
     fdr1.Surface_Area_SP_size_XS__c = 2;
     fdr1.Surface_Area_SP_size_S__c = 2;
     fdr1.Surface_Area_SP_size_M__c = 2;
     fdr1.Surface_Area_SP_size_L__c = 2;
     fdr1.Surface_Area_SP_size_XXL__c = 2;
     fdr1.Surface_Area_SP_size_XL__c = 2;
     fdr1.Thickness_Limit_of_SP__c = 2;
     fdr1.Thickness_Limit_of_front_plate__c = 2;
     fdr1.Thickness_Limit_of_BP__c = 2;
     insert fdr1; 
    
     String JsonMsg= '{'+
      '"bacConfigurationID" : "'+dat1.id+'",'+
      '"fdrRecordType" : "HAP Functional Design"'+  
      '}';
     Test.startTest();
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
     req.requestURI = '/services/apexrest/GetFDR';  
     req.httpMethod = 'POST';
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;
     CtrlGetFDRDetailsService testuserId=new CtrlGetFDRDetailsService();  
     CtrlGetFDRDetailsService.doPost();  
     Test.stopTest();

   }
    static testMethod void testDoPost3() {       
     // Adding dummy value   
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User user1 = new User();     
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
     
   
     BA_Configuration__c dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     insert dat1;
     
     BAC_Team_Member__c tem= new BAC_Team_Member__c();
     tem.BA_Configuration__c = dat1.id;
     tem.name='TM1';
     tem.Team_Member_Name__c=user1.id;
     insert tem; 
     
     Functional_Design_Requirement__c fdr1= new Functional_Design_Requirement__c();
     fdr1.BA_Configuration__c = dat1.id;
     fdr1.name='FDRONE';
     fdr1.RecordTypeId=rTNameToIDMap.get('Other_Requirement');
     fdr1.SAP_pouch_weight_L__c = 2;
     fdr1.SAP_pouch_weight_XL__c = 2;
     fdr1.SAP_pouch_weight_XXL__c = 2;
     fdr1.SAP_pouch_weight_S__c = 2;
     fdr1.SAP_pouch_weight_XS__c = 2;
     fdr1.SAP_pouch_weight_M__c = 2;
     fdr1.Outer_carrier_weight_XXL__c = 2;
     fdr1.Outer_carrier_weight_XL__c = 2;
     fdr1.Outer_carrier_weight_L__c = 2;
     fdr1.Outer_carrier_weight_S__c = 2;
     fdr1.Outer_carrier_weight_XS__c = 2;
     fdr1.Outer_carrier_weight_M__c = 2;
     fdr1.Weight_limit_HAP_XXL__c = 2;
     fdr1.Weight_limit_HAP_XL__c = 2;
     fdr1.Weight_limit_HAP_L__c = 2;
     fdr1.Weight_limit_HAP_XS__c = 2;
     fdr1.Weight_limit_HAP_S__c = 2;
     fdr1.Weight_limit_HAP_M__c = 2;
     fdr1.Weight_limit_SAP_XXL__c = 2;
     fdr1.Weight_limit_SAP_XL__c = 2;
     fdr1.Weight_limit_SAP_L__c = 2;
     fdr1.Weight_limit_SAP_XS__c = 2;
     fdr1.Weight_limit_SAP_S__c = 2;
     fdr1.Weight_limit_SAP_M__c = 2;
     fdr1.Total_weight_body_armor_XS__c =2;
     fdr1.Total_weight_body_armor_S__c =2;
     fdr1.Total_weight_body_armor_XXL__c =2;
     fdr1.Total_weight_body_armor_XL__c =2;
     fdr1.Total_weight_body_armor_L__c =2;
     fdr1.Total_weight_body_armor_M__c =2;
     //fdr1.Flammability_Protection_Standards__c = 'Other';
     fdr1.Flammability_Tests__c = 'Other' ;   
     fdr1.Flammability_Standard_Other_Comment__c = 'commentone' ;
     fdr1.Comment_Flammability__c ='xxxx';
     fdr1.Comment_Flexibility__c = 'rrrr';
     fdr1.Panel_Flexibility_Reference__c = 'Other';
     fdr1.Panel_Flexibility_Reference_OtherComment__c = 'commentone xxx';
     
     insert fdr1; 
     
    
     String JsonMsg= '{'+
      '"bacConfigurationID" : "'+dat1.id+'",'+
      '"fdrRecordType" : "Other Requirement"'+  
      '}';
     
     Test.startTest();
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
     req.requestURI = '/services/apexrest/GetFDR';  
     req.httpMethod = 'POST';
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;
     CtrlGetFDRDetailsService testuserId=new CtrlGetFDRDetailsService();  
     CtrlGetFDRDetailsService.doPost();  
     Test.stopTest();

   }
static testMethod void testDoPostExp() {
    Test.startTest();
    CtrlGetFDRDetailsService testuserId=new CtrlGetFDRDetailsService();  
    CtrlGetFDRDetailsService.doPost();  
    Test.stopTest();
  }  
   
}
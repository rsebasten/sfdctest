/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlGetMaterialMasterDetails.
 ********************************************************************************/
@isTest
private class CtrlGetMaterialMasterDetails_UT {
    
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static List<Material_Master__c> materialMasterList=new List<Material_Master__c>();
    public static Material_Master__c mm1,mm2,mm3,mm4;
    static{
        m1 = TestData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = TestData_Kevlar_UT.getMessage26();
        respMsgList.add(m4);  
        m2 = TestData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2); 
        m3 = TestData_Kevlar_UT.getMessage3();
        respMsgList.add(m3);   
        insert respMsgList;
    }
    
    static testMethod void testDoPost() {
        String JsonMsg='{}';
        
        mm1 = new Material_Master__c();
        mm1.Areal_Density__c=22;
        mm1.Material_ID__c='2asddf2';
        mm1.Material_Type__c = 'SAP';
        mm1.Material_Orign__c = 'DuPont';
        mm1.Material_Quality__c = 'Yarns';
        mm1.Thickness__c = 12;
        mm1.GSM__c = 3;
        mm1.Price__c = 10;
        mm1.Price_in_Euro__c = 12;
        mm1.Volume_Density__c = 2;
        
        mm2 = new Material_Master__c();
        mm2.Areal_Density__c=10;
        mm2.Material_ID__c='2asddf2we';
        mm2.Material_Type__c = 'SAP';
        mm2.Material_Orign__c = 'Partner';
        mm2.Material_Quality__c = 'Fabric';
        mm2.Thickness__c = 10;
        mm2.GSM__c = 2;
        mm2.Price__c = 12;
        mm2.Price_in_Euro__c = 10;
        mm2.Volume_Density__c = 3;       
        
        mm3 = new Material_Master__c();
        mm3.Areal_Density__c=13;
        mm3.Material_ID__c='2asddf2w12e';
        mm3.Material_Type__c = 'SAP';
        mm3.Material_Orign__c = 'Partner';
        mm3.Material_Quality__c = 'Structure';
        mm3.Thickness__c = 10;
        mm3.GSM__c = 2;
        mm3.Price__c = 12;
        mm3.Price_in_Euro__c = 10;
        mm3.Volume_Density__c = 3;  
           
        materialMasterList.add(mm1);
        materialMasterList.add(mm2);
        materialMasterList.add(mm3);
        insert materialMasterList;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaterialMaster';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlGetMaterialMasterDetails testMM=new CtrlGetMaterialMasterDetails();   
        CtrlGetMaterialMasterDetails.doPost(); 
        Test.stopTest();
    }
        
   static testMethod void testDoPost1() { 
        String JsonMsg='{}';       
        mm4= new Material_Master__c();
        mm4.Areal_Density__c=null;
        mm4.Material_ID__c='';
        mm4.Material_Type__c = '';
        mm4.Material_Orign__c = '';
        mm4.Material_Quality__c = '';
        mm4.Thickness__c = null;
        mm4.GSM__c = null;
        mm4.Price__c = null;
        mm4.Price_in_Euro__c = null;
        mm4.Volume_Density__c = null;  
        materialMasterList.add(mm4);
        
       	insert materialMasterList;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaterialMaster';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CtrlGetMaterialMasterDetails testMM=new CtrlGetMaterialMasterDetails();   
        CtrlGetMaterialMasterDetails.doPost(); 
        Test.stopTest();
    }
}
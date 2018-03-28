/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlDefaultPricingMasterService 
 ********************************************************************************/
@isTest
private class CtrlDefaultPricingMasterService_UT {
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>();
public static KevlarDefaultPricingMaster__c k,k1;
public static List<KevlarDefaultPricingMaster__c> defaultPMList=KevlarDefaultPricingMaster__c.getAll().values();
static testMethod void testDoPost() {
    m1 = testData_Kevlar_UT.getMessage1(); 
    respMsgList.add(m1);       
    m4 = testData_Kevlar_UT.getMessage32();
    respMsgList.add(m4);  
    m2 = testData_Kevlar_UT.getMessage33(); 
    respMsgList.add(m2); 
    insert respMsgList;
    
    k1= new KevlarDefaultPricingMaster__c();
    k1.Name = 'PMtest-EURO';
    k1.Cost_of_Outer_Carrier__c= 25.000;
    k1.Cost_of_SAP_pouches__c= 12;
    k1.SAP_Material_Wastage__c=10;
    k1.HAP_Material_Wastage__c = 10;
    k1.BAM_Margin__c =10;
    defaultPMList.add(k1); 
        insert defaultPMList;     
       String JsonMsg='{'+
        ' "lastSync":"2020-12-20T11:49:46.000+0000"'+          
     '}';
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DefaultPricingMaster';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlDefaultPricingMasterService testuserId=new CtrlDefaultPricingMasterService();
    CtrlDefaultPricingMasterService.doPost();  
    Test.stopTest();
}    
   
}
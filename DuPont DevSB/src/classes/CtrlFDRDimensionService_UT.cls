/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlFDRDimensionService.
 ********************************************************************************/
@isTest
private class CtrlFDRDimensionService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    public static List<Kevlar_SAP_Pouch_and_Others_Weight__c> pouchWeightList = new List<Kevlar_SAP_Pouch_and_Others_Weight__c>();
    public static List<Kevlar_Outer_Carrier_Weight__c> carrierWeightList = new List<Kevlar_Outer_Carrier_Weight__c>();
    public static Kevlar_Outer_Carrier_Weight__c w1;
    public static Kevlar_SAP_Pouch_and_Others_Weight__c k1;
    static{
            m1 = testData_Kevlar_UT.getMessage1(); 
            respMsgList.add(m1);       
            m4 = testData_Kevlar_UT.getMessage18();
            respMsgList.add(m4);  
            m2 = testData_Kevlar_UT.getMessage2(); 
            respMsgList.add(m2);
            m3 = testData_Kevlar_UT.getMessage3();     
            respMsgList.add(m3);     
            insert respMsgList;    
        	k1 = new Kevlar_SAP_Pouch_and_Others_Weight__c();
        	k1.name = 'XS';
        	k1.Weight__c = 0.5;
        	pouchWeightList.add(k1);
        	insert pouchWeightList;
         	w1 = new Kevlar_Outer_Carrier_Weight__c();
        	w1.name = 'S';
        	w1.weight__c = 0.35;
        	carrierWeightList.add(w1);
        	insert carrierWeightList;
        }
static testMethod void testDoPost() {
     String JsonMsg= '{}'; 
    Test.startTest();  
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/DesignRequirementsData';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;    
    CtrlFDRDimensionService testBACPD=new CtrlFDRDimensionService();   
    CtrlFDRDimensionService.doPost(); 
    Test.stopTest();
}
static testMethod void testDoPost1() { 
    Functional_Design_Requirement__c f = new Functional_Design_Requirement__c();
    f.SAP_Lower_Limit_M__c = ''; 
    f.SAP_Upper_Limit_M__c= '';           
    f.Factor_SAP__c= '';             
    f.HAP_BP_Upper_Limit_M__c= '';   
    f.HAP_FP_Upper_Limit_M__c= ''; 
    f.HAP_SP_Upper_Limit_M__c= '';   
    f.Factor_HAP_BP__c= '';   
    f.Factor_HAP_FP__c= ''; 
    f.Factor_HAP_SP__c= '';   
    f.HAP_BP_Lower_Limit_M__c= '';  
    f.HAP_SP_Lower_Limit_M__c= ''; 
    f.HAP_FP_Lower_Limit_M__c= '';   
    Test.startTest();
    CtrlFDRDimensionService testuserId=new CtrlFDRDimensionService();
    CtrlFDRDimensionService.doPost();  
    Test.stopTest();
}    
}
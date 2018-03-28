/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class CtrlOthersDropdownsService_UT.
 ********************************************************************************************/

@isTest
private class CtrlOthersDropdownsService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>();
    static{
            m1 = testData_Kevlar_UT.getMessage1(); 
            respMsgList.add(m1);       
            m4 = testData_Kevlar_UT.getMessage21();
            respMsgList.add(m4);  
            m2 = testData_Kevlar_UT.getMessage2(); 
            respMsgList.add(m2);
            m3 = testData_Kevlar_UT.getMessage3();     
            respMsgList.add(m3);     
            insert respMsgList;    
        } 
static testMethod void testDoPost() {
    String JsonMsg= '{}'; 
    Test.startTest();  
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/OthersDropdowns';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res; 
    CtrlOthersDropdownsService testuserId=new CtrlOthersDropdownsService();
    CtrlOthersDropdownsService.doPost();  
    Test.stopTest();    
}   
static testMethod void testDoPost1() { 
    Functional_Design_Requirement__c f = new Functional_Design_Requirement__c();
    f.Flammability_Tests__c = ''; 
    f.Panel_Flexibility_Reference__c = '';   
    f.Third_party_testing_standards__c = ''; 
   // f.Names_of_Labs__c = '';           
    Test.startTest();
    CtrlOthersDropdownsService testuserId=new CtrlOthersDropdownsService();
    CtrlOthersDropdownsService.doPost();  
    Test.stopTest();
}
}
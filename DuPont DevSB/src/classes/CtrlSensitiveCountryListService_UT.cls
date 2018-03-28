/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlSensitiveCountryListService
 ********************************************************************************/
@isTest

private class CtrlSensitiveCountryListService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList= new List<Kevlar_Response_Messages__c>(); 
    static{
            m1 = testData_Kevlar_UT.getMessage1(); 
            respMsgList.add(m1);       
            m4 = testData_Kevlar_UT.getMessage8();
            respMsgList.add(m4);  
            m2 = testData_Kevlar_UT.getMessage2(); 
            respMsgList.add(m2);
            m3 = testData_Kevlar_UT.getMessage3();     
            respMsgList.add(m3);     
            insert respMsgList;    
        }
static testMethod void testDoPost() {
    String JsonMsg='{""}';
    Test.startTest();
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/Sensitive_Country';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlSensitiveCountryListService testSensitiveCountry=new CtrlSensitiveCountryListService();
    CtrlSensitiveCountryListService.doPost();  
    Test.stopTest();    
}    
static testMethod void testDoPost1() {
    BA_Configuration__c f = new  BA_Configuration__c();         
    f.BAC_Sensitive_Country__c = '';
    Test.startTest();
    CtrlSensitiveCountryListService testSensitiveCountry=new CtrlSensitiveCountryListService();
    CtrlSensitiveCountryListService.doPost();  
    Test.stopTest();
}
}
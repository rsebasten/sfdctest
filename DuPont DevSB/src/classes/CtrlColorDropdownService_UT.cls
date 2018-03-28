/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlColorDropdownService.
 ********************************************************************************/
@isTest
private class CtrlColorDropdownService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static Kevlar_Color_of_BA__c k1;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    static{
        m1 = testData_Kevlar_UT.getMessage1(); 
        respMsgList.add(m1);       
        m4 = testData_Kevlar_UT.getMessage6();
        respMsgList.add(m4);  
        m2 = testData_Kevlar_UT.getMessage2(); 
        respMsgList.add(m2);
        m3 = testData_Kevlar_UT.getMessage3();     
        respMsgList.add(m3);     
        insert respMsgList;    
    }
static testMethod void testDoPost() {  
    k1= new Kevlar_Color_of_BA__c();
    k1.name = 'BlueColorCode';
    k1.Color__c = 'Navy Blue';
    k1.RGB_Code__c = 'rgb(0,32,96)';
    insert k1;
    String JsonMsg='{""}';
    Test.startTest();
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/Color';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CtrlColorDropdownService testColor=new CtrlColorDropdownService();
    CtrlColorDropdownService.doPost();  
    Test.stopTest();
}
static testMethod void testDoPost1() {
    Functional_Design_Requirement__c f = new  Functional_Design_Requirement__c();
    f.color__c = '';
    Test.startTest();
    CtrlColorDropdownService testColor=new CtrlColorDropdownService();
    CtrlColorDropdownService.doPost();  
    Test.stopTest();
}
}
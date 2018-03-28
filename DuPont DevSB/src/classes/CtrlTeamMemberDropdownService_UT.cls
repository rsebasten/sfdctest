/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlTeamMemberDropdownService.
 ********************************************************************************/
@isTest
private class CtrlTeamMemberDropdownService_UT {
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> InsertList = new List<Kevlar_Response_Messages__c>(); 

static testMethod void testDoPost() {
    m1 = testData_Kevlar_UT.getMessage1(); 
    InsertList.add(m1);       
    m4 = testData_Kevlar_UT.getMessage5();
    InsertList.add(m4);  
    m2 = testData_Kevlar_UT.getMessage2(); 
    InsertList.add(m2); 
    insert InsertList;    
    String JsonMsg= '{}';
 
    Test.startTest();  
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/TMS';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;     
    CtrlTeamMemberDropdownService testTHR=new CtrlTeamMemberDropdownService();   
    CtrlTeamMemberDropdownService.doPost();         
    Test.stopTest(); 
}    
static testMethod void testDoPost1() {    
    m3 = testData_Kevlar_UT.getMessage3();
    InsertList.add(m3);  
    insert InsertList;
    List<User> result = [Select  name from User WHERE name =''];     
    Test.startTest();
    CtrlTeamMemberDropdownService testuserId=new CtrlTeamMemberDropdownService();
    CtrlTeamMemberDropdownService.doPost();  
    Test.stopTest();
}    
}
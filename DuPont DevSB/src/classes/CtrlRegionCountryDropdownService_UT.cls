/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlRegionCountryDropdownService
 ********************************************************************************/
@isTest
private class CtrlRegionCountryDropdownService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static Kevlar_RegionCountry_Mapping__c k,k1,k2,k3,k4;
    public static List<Kevlar_Response_Messages__c> respMsgList= new List<Kevlar_Response_Messages__c>();
    public static List<Kevlar_RegionCountry_Mapping__c> InsertMapping= new List<Kevlar_RegionCountry_Mapping__c>();
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
    k1= new Kevlar_RegionCountry_Mapping__c();
    k1.name = 'AP-India';
    k1.Country__c = 'India';
    k1.Region__c = 'AP';
    InsertMapping.add(k1); 
    
    k2 = new Kevlar_RegionCountry_Mapping__c();
    k2.name = 'EMEA-Iraq';
    k2.Country__c = 'Iraq';
    k2.Region__c = 'EMEA';
    InsertMapping.add(k2); 
    
    k3 = new Kevlar_RegionCountry_Mapping__c();
    k3.name = 'NA-Canada';
    k3.Country__c = 'Canada';
    k3.Region__c = 'NA';
    InsertMapping.add(k3); 
    
    k4 = new Kevlar_RegionCountry_Mapping__c();
    k4.name = 'LA-Argentina';
    k4.Country__c = 'Argentina';
    k4.Region__c = 'LA';
    InsertMapping.add(k4); 
    insert InsertMapping;     
    String JsonMsg='{""}';
    Test.startTest();
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/Region_Country';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;   
    CtrlRegionCountryDropdownService testRegionCountry=new CtrlRegionCountryDropdownService();
    CtrlRegionCountryDropdownService.doPost();  
    Test.stopTest();    
}
static testMethod void testDoPost1() { 
    k = new Kevlar_RegionCountry_Mapping__c();
    k.name = 'test';
    k.Country__c = 'test';
    k.Region__c = 'test';
    InsertMapping.add(k); 
    insert InsertMapping;
    
    String JsonMsg='{""}';
    Test.startTest();
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    req.requestURI = '/services/apexrest/Region_Country';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;   
    CtrlRegionCountryDropdownService testRegionCountry=new CtrlRegionCountryDropdownService();
    CtrlRegionCountryDropdownService.doPost();  
    Test.stopTest();    
}  

}
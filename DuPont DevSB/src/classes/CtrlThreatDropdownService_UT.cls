/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class CtrlThreatDropdownService_UT.
 ********************************************************************************************/

@isTest
private class CtrlThreatDropdownService_UT {
    public static Kevlar_Response_Messages__c m1,m2,m3,m4;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    static{
            m1 = testData_Kevlar_UT.getMessage1(); 
            respMsgList.add(m1);       
            m4 = testData_Kevlar_UT.getMessage30();
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
        req.requestURI = '/services/apexrest/ThreatDefaultDropdowns';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;   
        CtrlThreatDropdownService testuserId=new CtrlThreatDropdownService();
        CtrlThreatDropdownService.doPost();  
        Test.stopTest();    
    }   
    static testMethod void testDoPost1() {
        Threat_Master__c f = new Threat_Master__c();
        f.Test_Standard__c = '';
        f.V50__c= null; 
        f.Velocity_V50__c= '';   
        f.Angle_NBT__c= ''; 
        f.Stab_Location__c = '';  
        f.No_Of_Stabs__c= ''; 
        f.Penetration_Allowed__c= '';   
        f.Energy_Level_Joule_NBT__c= ''; 
        f.Energy_Level_NBT__c= '';
        f.Angled_Shot__c= ''; 
        f.Number_of_shots__c= '';
        f.Shooting_Mechnism__c= ''; 
        f.Shot_Locations__c= '';
                 
        Test.startTest();
        CtrlThreatDropdownService testuserId=new CtrlThreatDropdownService();
        CtrlThreatDropdownService.doPost();  
        Test.stopTest();
    }
}
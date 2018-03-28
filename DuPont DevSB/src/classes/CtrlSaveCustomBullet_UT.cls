/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: Pallavi.sharma3@tcs.com
Description:  This class tests the CtrlUpdateFDRService.
 ********************************************************************************/
@isTest
private class CtrlSaveCustomBullet_UT {
	public static User user1;
    public static BA_Configuration__c  bac;
    public static Kevlar_Response_Messages__c m1,m2,m3,m4,m5,m6,m7;
    public static List<Kevlar_Response_Messages__c> respMsgList = new List<Kevlar_Response_Messages__c>(); 
    
    static{
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            //List<User> userList = new List<User>();
           
            m1 = testData_Kevlar_UT.getMessage1(); 
            respMsgList.add(m1);       
            m4 = testData_Kevlar_UT.getMessage16();
            respMsgList.add(m4);  
            m2 = testData_Kevlar_UT.getMessage2(); 
            respMsgList.add(m2); 
             m3 = testData_Kevlar_UT.getMessage3();
            respMsgList.add(m3); 
             m5 = testData_Kevlar_UT.getMessage17();
            respMsgList.add(m5);
             m6 = testData_Kevlar_UT.getMessage517();
            respMsgList.add(m6);
             m7 = testData_Kevlar_UT.getMessage546();
            respMsgList.add(m7);  
            insert respMsgList;
    }
    
    static TestMethod void testDoPost(){
      String jsonStr = '{'+
		'"bulletName":".357 MAG",'+
		'"iosId" : "test12345",'+
		'"bulletType":"Remington SPFN, R357M3",'+
		'"weight":12.235,'+
		'"velocity":23.314,'+
		'"shootingDistance":24.10,'+
		'"range":20.23,'+
		'"v50":30.32,'+
		'"shootingMechanism":"Barrel/Weapon",  '+
		'"shotLocations":"Building",'+
		'"numberOfShots":"5",'+
		'"angledShot": ["-60","-45","-30"], '+
		'"contactShot":true,   '+
		'"bfdNeeded": 3.46'+
		'} ';
        system.debug('---->'+jsonStr);
        
        Test.startTest();

         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
         req.requestURI = '/services/apexrest/SaveCustomBullet';  
         req.httpMethod = 'POST';
         req.requestBody = Blob.valueof(jsonStr);
         RestContext.request = req;
         RestContext.response= res;
        CtrlSaveCustomBullet.doPost();
         Test.stopTest();

        
        
        
    }
}
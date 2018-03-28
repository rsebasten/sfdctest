@isTest
private class ctrlBPDHitExtSystem_UT{
            
        static testMethod void testctrlBPDCaseSave_UT() {

        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
         Final Id BrandProtectionAbuseSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createCustomSettingData();   
        
        geoValidation.validateInTestMode=false;
        
        Date d = Date.newinstance(2014, 12, 27);
       
StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
mock.setStaticResource('mockResponse');
mock.setStatusCode(200);
mock.setHeader('Content-Type', 'application/json');

StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
mock1.setStaticResource('MockResponse_Corian');
mock1.setStatusCode(200);
mock1.setHeader('Content-Type', 'application/json');

        Case cas = new Case();
        cas.Sample_Received_Date__c = d;
        cas.status = 'new';
        cas.Brand__c= 'Kevlar';
        cas.Subject= 'test';
        cas.Description= 'This is a test case';
        //cas.Additional_Information__c= 'test abc';
        cas.Qty__c=20.00;
        cas.RecordTypeId = CaseRecordType;
        insert cas;


 Case cas1 = new Case();
        cas1.Sample_Received_Date__c = d;
        cas1.status = 'new';
        cas1.Brand__c= 'Kevlar2';
        cas1.Subject= 'test1';
        cas1.Description= 'This is a tes1 case';
       // cas1.Additional_Information__c= 'test abc';
        cas1.Qty__c=20.00;
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
 
// Set the mock callout mode
       test.starttest();
        PageReference pageRef = Page.BPDHitExtSystem;
        Test.setCurrentPage(pageRef);

Test.setMock(HttpCalloutMock.class, mock);
// Call the method that performs the callout       
           ApexPages.currentPage().getParameters().put('id',cas.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(cas);
        ctrlBPDHitExtSystem cs = new ctrlBPDHitExtSystem(controller);
        cs.hitTheServer();
        cs.doSave();  
 
PageReference pageRef1 = Page.BPDHitExtSystem;
        Test.setCurrentPage(pageRef1);
// Set the mock callout mode
Test.setMock(HttpCalloutMock.class, mock1);   

        ApexPages.currentPage().getParameters().put('id',cas1.id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(cas1);
        ctrlBPDHitExtSystem cs1 = new ctrlBPDHitExtSystem(controller1);
        cs1.hitTheServer();
        cs1.doSave();
            test.stoptest();     
        }
        }
        }
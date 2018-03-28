/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDExcelDownload
***************************************************************************************/

@isTest
private class ctrlBPDExcelDownload_UT{
        static testMethod void test() {        
                   
        Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
        Final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America',Phone='9912818460');
        insert user1;
        System.runas(user1){  
        
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createCustomSettingData();   
        
        geoValidation.validateInTestMode=false;
        
        Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
             
         Date d = Date.newinstance(2014, 12, 27);
        Case cas =new Case();
        cas.Order_Number__c = '123abc';
        cas.Sample_Received_Date__c = d;
        cas.RecordTypeId = CaseRecordType;
        insert cas;
        
        Case_Details__c caseDetails = new Case_Details__c();
        caseDetails.Brand__c ='kevlar';
        caseDetails.Company__c='Infosys';
        caseDetails.Related_Case__c=cas.id;
        caseDetails.RecordTypeId = CaseDetailsRecordType;
        insert caseDetails;
        
        Trademark_Abuse_Sample__c sample = new Trademark_Abuse_Sample__c();
        sample.Product_Collection_Method__c='Purchased';
        sample.External_Sample_Collector__c='mary';
        sample.Formulation__c=10;
        sample.Sample_Packaging_Analysis__c='123';
        sample.Product_Quantity_Collected__c=12;
        sample.Internal_Sample_Collector2__c=user1.id;
        sample.Case__c=cas.id;
        sample.RecordTypeId = CropSample;
        insert sample;
       
        Trademark_Abuse_Sample_Analysis__c sampleAnalysis = new Trademark_Abuse_Sample_Analysis__c();
        sampleAnalysis.Lab_Name__c=bp.id;
        sampleAnalysis.Lab_Type__c='Primary';
        sampleAnalysis.Trademark_Abuse_Sample__c=sample.id;
        insert sampleAnalysis;
        
          PageReference pageRef = Page.BPDExcelDownload;
          Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',sampleAnalysis.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(sample);
        
        ctrlBPDExcelDownload ad = new ctrlBPDExcelDownload(controller);
        
        
        Test.stopTest();
       }
     }
   }
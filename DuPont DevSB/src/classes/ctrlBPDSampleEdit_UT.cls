/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDSampleEdit
***************************************************************************************/

@isTest
private class  ctrlBPDSampleEdit_UT{
        static testMethod void test() {
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
        Final Id BrandProtection=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH  Svmx_TestData_Util_UT.createCustomSettingData();  
        
        geoValidation.validateInTestMode=false;
        
        Date d = Date.newinstance(2014, 12, 27);
        Case cas =new Case();
        cas.Order_Number__c = '123abc';
        cas.Sample_Received_Date__c = d;
        cas.RecordTypeId = CaseRecordType;
        insert cas;
        
         Date da = Date.newinstance(2014, 12, 27);
        Trademark_Abuse_Sample__c sample = new Trademark_Abuse_Sample__c();
        sample.Identification_Date__c = da;
        sample.Active_Ingredients__c='sfs';
        sample.Country__c='wdhg';
        sample.Case__c=cas.id;
        sample.RecordTypeId = BrandProtection; 
        insert sample;

        sample.Identification_Date__c = d;
        sample.Active_Ingredients__c='asc';
        sample.Country__c='asdca';
        
        update sample;  
          
        PageReference pageRef = Page.BPDSampleSave;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',sample.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(sample);
       
        ctrlBPDSampleEdit cb = new ctrlBPDSampleEdit(controller); 
        cb.doSave();
        Test.stopTest();
        }
        }
        }
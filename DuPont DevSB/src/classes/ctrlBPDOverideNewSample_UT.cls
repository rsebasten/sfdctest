/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDOverideNewSample
***************************************************************************************/

@isTest(SeeAllData=false)
private class  ctrlBPDOverideNewSample_UT{
        static testMethod void test() {               
        
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
        Final Id BrandProtection=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        //[20170102] Merge&Spin: Load test data for custom setting
        List<SObject> lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
        geoValidation.validateInTestMode=false;
        
/* PKH

        SVMXListSettings__c sv = new SVMXListSettings__c(Name='WarrantyLA',Static_Value__c = 'WarrantyLA');
        insert sv;
        SVMXListSettings__c sv1 = new SVMXListSettings__c(Name='ContractLA',Static_Value__c = 'WarrantyLA');
        insert sv1;
        SVMXListSettings__c sv2 = new SVMXListSettings__c(Name='BillableEMEA',Static_Value__c = 'WarrantyLA');
        insert sv2;
        SVMXListSettings__c sv3 = new SVMXListSettings__c(Name='WarrantyEMEA',Static_Value__c = 'WarrantyLA');
        insert sv3;
        SVMXListSettings__c sv4 = new SVMXListSettings__c(Name='Hardware ServiceEMEA',Static_Value__c = 'WarrantyLA');
        insert sv4;
        SVMXListSettings__c sv5 = new SVMXListSettings__c(Name='Hardware SalesEMEA',Static_Value__c = 'WarrantyLA');
        insert sv5;
        SVMXListSettings__c sv6 = new SVMXListSettings__c(Name='ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv6;
        SVMXListSettings__c sv7 = new SVMXListSettings__c(Name='Uptime ContractTypeEMEA',Static_Value__c = 'WarrantyLA');
        insert sv7;
        SVMXListSettings__c sv8 = new SVMXListSettings__c(Name='Uptime ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv8;
PKH */        
        Date d = Date.newinstance(2014, 12, 27);
        Case cas =new Case();
        cas.Order_Number__c = '123abc';
        cas.Sample_Received_Date__c = d;
        cas.RecordTypeId = CaseRecordType;
        insert cas;
        Case_Details__c cd = new Case_Details__c ();
        cd.Related_Case__c =cas.id;
        cd.Address__c='hiiii';
        insert cd;
        
        Trademark_Abuse_Sample__c sample = new Trademark_Abuse_Sample__c();
        sample.Identification_Date__c = d;
        sample.Active_Ingredients__c='sfs';
        sample.Country__c='wdhg';
        sample.Case__c=cas.id;
        sample.Trademark_Abuse_Case_Details__c =cd.id;
        
          
        PageReference pageRef = Page.BPDOverrideNewSample;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        //[20170102] Merge&Spin: Map for retrieving field ID based on custom setting name
        map<string,string> fieldIdMap = new map<string,string>();
        for(sobject sobj:lstobjectFieldMapping)
        {
            Object_Field_ID_Mapping__c objectField = (Object_Field_ID_Mapping__c) sobj;
            fieldIdMap.put(objectField.name,objectField.field_id__c);
        }
        ApexPages.currentPage().getParameters().put('retURL','retURL');
        //[20170102] Merge&Spin: Remove hardcoded ID for field.
        ApexPages.currentPage().getParameters().put(fieldIdMap.get('Sample/Trap Purchase_Case')+'_lkid',null);
        ApexPages.StandardController controller = new ApexPages.StandardController(sample);
       
        ctrlBPDOverideNewSample  cb = new ctrlBPDOverideNewSample(controller); 
        cb.redirectToPage();
        cb.cancel();
        cb.retPage();
        Test.stopTest();
        }
        }
        }
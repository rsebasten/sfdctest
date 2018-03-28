/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDSampleAnalysisEdit
***************************************************************************************/

@isTest
private class ctrlBPDSampleAnalysisEdit_UT{
        static testMethod void test() {
         Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
         Final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){                  
        
         //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createDocument('BPDAttachmentImage'); 
        Document document;

        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'BPDAttachmentImage';
        document.FolderId = userinfo.getuserid();
        insert document;  
        
        geoValidation.validateInTestMode=false;
        
        Business_Partner__c b = new Business_Partner__c();
        b.Name='Azimsulfuron';
        b.Partner_Country__c='India';
        b.Partner_Region__c='NA';
        insert b;
        
         Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
        Date d = Date.newinstance(2014, 12, 27);
        Trademark_Abuse_Sample__c s = new Trademark_Abuse_Sample__c();
        s.Identification_Date__c=d;
        s.Active_Ingredients__c='Diuron(DIU)';
        s.Country__c='INDIA';
        s.RecordTypeId=CropSample;
        insert s;
              
        Trademark_Abuse_Sample_Analysis__c sample = new Trademark_Abuse_Sample_Analysis__c();
        sample.Lab_Name__c = bp.id;
        sample.Trademark_Abuse_Sample__c=s.id;
        sample.Analysis_type__c = 'Basic';
        sample.Appearance__c = 'test';
        sample.Quality_of_Packaging__c='Comparable';
        sample.Compounds_found_in_FTIR__c='2,4D;Acetamiprid';
        sample.Active_for_Brand_found_in_HPLC1__c='Acetamiprid;Abamectin';
        insert sample;
        
        Attachment a = new Attachment();
        a.ParentId=sample.id;
        a.name='POU-';
        a.body = blob.valueof('Attachment inside');
        insert a;
        
        
        PageReference pageRef = Page.BPDSampleAnalysisEdit;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',sample.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(sample);
        
        ctrlBPDSampleAnalysisEdit  ss = new ctrlBPDSampleAnalysisEdit(controller);
        ss.SelectedMaterials.add(new SelectOption('Acetamiprid','Acetamiprid'));
        ss.SelectedMaterialsCompound.add(new SelectOption('2,4D','2,4D'));
        ss.bl =  blob.valueof('Contains Attachment');
        ss.searchActiveForBrand = 'a';
        ss.searchCompound = 'd';
        ss.doSave();
        ss.BrandAnswer();
        ss.CompoundAnswer();
        ss.SearchActiveForBrandvalue();
        ss.SearchCompoundValue();
        Test.stopTest();
  }
}
}
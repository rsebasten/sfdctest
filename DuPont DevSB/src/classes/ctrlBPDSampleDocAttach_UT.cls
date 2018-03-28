/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDSampleDocAttach
***************************************************************************************/

@isTest
private class ctrlBPDSampleDocAttach_UT{
        static testMethod void testctrlBPDSampleDocAttach_UT() {
        Final Id BrandProtectionAbuseSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){ 
        Document document; 
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'BPDAttachmentImage';
        document.FolderId = userinfo.getuserid();
        insert document;
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createDocument('BPDAttachmentImage');
        
        geoValidation.validateInTestMode=false;
        
         Date d = Date.newinstance(2014, 12, 27);

        Trademark_Abuse_Sample__c s = new Trademark_Abuse_Sample__c();
        
        s.Sample_Comments__c = 'test';
        s.Sample_Conclusion__c = 'verified';
        s.Sample_Technical_Analysis__c = 'abcd';
        s.Sample_Packaging_Analysis__c = 'efgh';
        s.RecordTypeId = BrandProtectionAbuseSample;
        insert s;

       Attachment a = new Attachment();
        a.ParentId=s.id;
        a.name='S-';
        a.body = blob.valueof('Attachment inside');
        insert a;
        
        Attachment a1 = new Attachment();
        a1.ParentId=s.id;
        a1.name='PA-';
        a1.body = blob.valueof('Attachmdsfent inside');
        insert a1;
        
        Attachment a2 = new Attachment();
        a2.ParentId=s.id;
        a2.name='TA-';
        a2.body = blob.valueof('Attachmfsent inside');
        insert a2;
        
        
        PageReference pageRef = Page.BPDSampleDocAttach;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',s.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(s);
        
        ctrlBPDSampleDocAttach sa = new ctrlBPDSampleDocAttach(controller);
        sa.bl = blob.valueof('Contains Attachment');
        sa.PAbl = blob.valueof('Contains Attachment1');
        sa.TAbl= blob.valueof('Contains Attachment2');
        sa.savingCase();
               
        Test.stopTest();
        }
     }
   }
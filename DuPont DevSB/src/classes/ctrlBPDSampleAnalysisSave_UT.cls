/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDSampleAnalysisSave
***************************************************************************************/

@isTest
private class ctrlBPDSampleAnalysisSave_UT{
        static testMethod void test() {
        Final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
        Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
        
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
        insert sample;
        
        
        Attachment a = new Attachment();
        a.ParentId=sample.id;
        a.name='POU-';
        a.body = blob.valueof('Attachment inside');
        insert a;
        
        
                     
        PageReference pageRef = Page.BPDSampleAnalysisSave;
        Test.setCurrentPage(pageRef);
          
        ApexPages.currentPage().getParameters().put('id',s.id);
        ApexPages.StandardController controll = new ApexPages.StandardController(s);
        
        
        Test.startTest();
        ctrlBPDSampleAnalysisSave  ss = new ctrlBPDSampleAnalysisSave(controll);
        ss.bl =  blob.valueof('Contains Attachment');
        ss.initialSample.Lab_Name__c =bp.id;
        ss.searchActiveForBrand = 'a';
        ss.searchCompound = 'd';
        ss.SelectedMaterials.add(new SelectOption('Acetamiprid','Acetamiprid'));
        ss.SelectedMaterialsCompound.add(new SelectOption('2,4D','2,4D'));
        system.debug('SelectedMaterial'+ss.SelectedMaterials.size());
        ss.doSave();
        ss.doCancel();
        ss.BrandAnswer();
        ss.CompoundAnswer();
        ss.SearchActiveForBrandvalue();
        ss.SearchCompoundValue();
        Test.stopTest();
  }
}
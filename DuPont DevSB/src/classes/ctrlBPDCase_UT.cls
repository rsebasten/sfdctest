/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDCase
***************************************************************************************/

@isTest
private class ctrlBPDCase_UT{
        static testMethod void test() {
      Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
         System.runas(user1){  
//[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH  Svmx_TestData_Util_UT.createCustomSettingData();     
        geoValidation.validateInTestMode=false;
       BPD_Sample_Settings__c bpd1 = new BPD_Sample_Settings__c();
       bpd1.Name='abc';
       bpd1.Distinguisher_Field__c='Brand';
       bpd1.Owning_Org__c='test';
       insert bpd1;
       
       BPD_Sample_Settings__c bpd2 = new BPD_Sample_Settings__c();
       bpd2.Name='abc1';
       bpd2.Distinguisher_Field__c='Brand';
       bpd2.Owning_Org__c='test';
       insert bpd2;

       
        
        Date d = Date.newinstance(2014, 12, 27);
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
        
        Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c = :cas1.Id];
        c1.Type_of_Record__c='Web';
        c1.How_Trademark_is_Used__c='Company Name';
        c1.Infringement_Type__c='Copyright';
        c1.Infringing_Product_Description__c='aaa';
        c1.Company__c='bbb';
        c1.Procedural_Status__c='Legal - In Progress';
        c1.Address__c='abc';
        c1.City__c='d';
        c1.State__c='e';
        c1.Target_Country__c='i';
        c1.Zip_Postal_Code__c='100';
        c1.Crop_Phase_Status__c='Incident';
        c1.RecordTypeId = CaseDetailsRecordType;
       
        update c1;
        
           
            Trademark_Abuse_Sample__c sample1 = new Trademark_Abuse_Sample__c();
            sample1.Country__c='India';
            sample1.Identification_Date__c=d;
            sample1.Active_Ingredients__c='Mancozeb';
            sample1.RecordTypeId=SampleRecordType;
            sample1.Case__c=cas1.id;
            insert sample1;
            
        Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
            Trademark_Abuse_Sample_Analysis__c sampleresult1 = new Trademark_Abuse_Sample_Analysis__c();
            sampleresult1.Lab_Name__c=bp.id;
            sampleresult1.Trademark_Abuse_Sample__c=sample1.id;
            insert sampleresult1;

        PageReference pageRef = Page.BPDCase;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrlBPDCase cs = new ctrlBPDCase();
        cs.permissions=true;
        cs.initialCaseDetail.Infringement_Type__c= 'Copyright';
        cs.initialCaseDetail.Company__c= 'bbb';
        cs.initialCaseDetail.Record_Origination__c = 'Customs Seizure';
        cs.initialCaseDetail.Target_Country__c= 'India';
        cs.initialSample.Country__c= 'India';
        cs.initialSample.Identification_Date__c= d;
        cs.initialSample.Active_Ingredients__c= 'Mancozeb';
        cs.initialSampleResult.Lab_Name__c=bp.id;
        cs.flagVar=true;
        cs.flagSample=true;
        cs.flagSample1=true;
        cs.SelectedMaterials.add(new SelectOption('abc','abc'));
         cs.SelectedMaterials.add(new SelectOption('abc1','abc'));
        cs.searchBrand = 'a';
        cs.doSave();
        cs.SelectedSBUs.add(new SelectOption('abc','abc'));
        cs.SelectedSBUs.add(new SelectOption('abc1','abc'));
        cs.doSave();
        cs.initialCaseDetail.Facts_of_the_Case__c='test';
        cs.initialCaseDetail.Facts_of_the_Case__c='test';
        date myDate = date.newInstance(1990, 11, 21);
        cs.initialCaseDetail.Date_Opened__c=myDate;
        cs.permissions=false;
        cs.doSave();  
        cs.permissions=true;    
        // cs.doSave();
        cs.doCancel();
        cs.brandselect();
        cs.SearchBrandvalue();
        cs.selectBrands();
        Test.stopTest();
        }
     }
     
     
     static testMethod void test1() {
      Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH--- Svmx_TestData_Util_UT.createCustomSettingData(); 
       BPD_Sample_Settings__c bpd1 = new BPD_Sample_Settings__c();
       bpd1.Name='abc';
       bpd1.Distinguisher_Field__c='Brand';
       bpd1.Owning_Org__c='test';
       insert bpd1;
       
       BPD_Sample_Settings__c bpd2 = new BPD_Sample_Settings__c();
       bpd2.Name='abc1';
       bpd2.Distinguisher_Field__c='Brand';
       bpd2.Owning_Org__c='test';
       insert bpd2;

       
        
        Date d = Date.newinstance(2014, 12, 27);
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
        
        Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c = :cas1.Id];
        c1.Type_of_Record__c='Web';
        c1.How_Trademark_is_Used__c='Company Name';
        c1.Infringement_Type__c='Copyright';
        c1.Infringing_Product_Description__c='aaa';
        c1.Company__c='bbb';
        c1.Procedural_Status__c='Legal - In Progress';
        c1.Address__c='abc';
        c1.City__c='d';
        c1.State__c='e';
        c1.Target_Country__c='i';
        c1.Zip_Postal_Code__c='100';
        c1.Crop_Phase_Status__c='Incident';
        c1.RecordTypeId = CaseDetailsRecordType;
       
        update c1;
        
           
            Trademark_Abuse_Sample__c sample1 = new Trademark_Abuse_Sample__c();
            sample1.Country__c='India';
            sample1.Identification_Date__c=d;
            sample1.Active_Ingredients__c='Mancozeb';
            sample1.RecordTypeId=SampleRecordType;
            sample1.Case__c=cas1.id;
            insert sample1;
            
        Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
            Trademark_Abuse_Sample_Analysis__c sampleresult1 = new Trademark_Abuse_Sample_Analysis__c();
            sampleresult1.Lab_Name__c=bp.id;
            sampleresult1.Trademark_Abuse_Sample__c=sample1.id;
            insert sampleresult1;

        PageReference pageRef = Page.BPDCase;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrlBPDCase cs = new ctrlBPDCase();
        cs.permissions=false;
        cs.initialCaseDetail.Infringement_Type__c= 'Copyright';
        cs.initialCaseDetail.Company__c= 'bbb';
        cs.initialCaseDetail.Record_Origination__c = 'Customs Seizure';
        cs.initialCaseDetail.Target_Country__c= 'India';
        cs.initialSample.Country__c= 'India';
        cs.initialSample.Identification_Date__c= d;
        cs.initialSample.Active_Ingredients__c= 'Mancozeb';
        cs.initialSampleResult.Lab_Name__c=bp.id;
        cs.flagVar=true;
        cs.flagSample=true;
        cs.flagSample1=true;
        cs.SelectedMaterials.add(new SelectOption('abc','abc'));         
        cs.searchBrand = 'a';
        cs.permissions=true;
        cs.doSave();
        cs.doCancel();
        cs.brandselect();
        cs.SelectedMaterials.add(new SelectOption('abc1','abc'));
        cs.SearchBrandvalue();
        cs.selectBrands();
        cs.chkBox();
        Test.stopTest();
        }
     }
    static testMethod void test2() {
      Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Corporate',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH  Svmx_TestData_Util_UT.createCustomSettingData(); 
       BPD_Sample_Settings__c bpd1 = new BPD_Sample_Settings__c();
       bpd1.Name='abc';
       bpd1.Distinguisher_Field__c='Brand';
       bpd1.Owning_Org__c='test';
       insert bpd1;
       
       BPD_Sample_Settings__c bpd2 = new BPD_Sample_Settings__c();
       bpd2.Name='abc1';
       bpd2.Distinguisher_Field__c='Brand';
       bpd2.Owning_Org__c='test';
       insert bpd2;

       
        
        Date d = Date.newinstance(2014, 12, 27);
              
                    
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
        
         Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c = :cas1.Id];
        c1.Type_of_Record__c='Web';
        c1.How_Trademark_is_Used__c='Company Name';
        c1.Infringement_Type__c='Copyright';
        c1.Infringing_Product_Description__c='aaa';
        c1.Company__c='bbb';
        c1.Procedural_Status__c='Legal - In Progress';
        c1.Address__c='abc';
        c1.City__c='d';
        c1.State__c='e';
        c1.Target_Country__c='i';
        c1.Zip_Postal_Code__c='100';
        c1.Crop_Phase_Status__c='Incident';
        c1.RecordTypeId = CaseDetailsRecordType;
       
        update c1;
        
           
            Trademark_Abuse_Sample__c sample1 = new Trademark_Abuse_Sample__c();
            sample1.Country__c='India';
            sample1.Identification_Date__c=d;
            sample1.Active_Ingredients__c='Mancozeb';
            sample1.RecordTypeId=SampleRecordType;
            sample1.Case__c=cas1.id;
            insert sample1;
            
        Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
            Trademark_Abuse_Sample_Analysis__c sampleresult1 = new Trademark_Abuse_Sample_Analysis__c();
            sampleresult1.Lab_Name__c=bp.id;
            sampleresult1.Trademark_Abuse_Sample__c=sample1.id;
            insert sampleresult1;

        PageReference pageRef = Page.BPDCase;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrlBPDCase cs = new ctrlBPDCase();
        cs.initialCaseDetail.Infringement_Type__c= 'Copyright';
        cs.initialCaseDetail.Company__c= 'bbb';
        cs.initialCaseDetail.Record_Origination__c = 'Customs Seizure';
        cs.initialCaseDetail.Target_Country__c= 'India';
        cs.initialSample.Country__c= 'India';
        cs.initialSample.Identification_Date__c= d;
        cs.initialSample.Active_Ingredients__c= '';
        cs.initialSampleResult.Lab_Name__c=bp.id;
        cs.flagVar=true;
        cs.flagSample=true;
        cs.flagSample1=true;
        cs.permissions=true;
        cs.SelectedMaterials.add(new SelectOption('abc','abc')); 
        cs.userSBU='Corporate';
        cs.searchBrand = 'a';
        cs.doSave();
        cs.doCancel();
        cs.brandselect();
        cs.SelectedMaterials.add(new SelectOption('abc1','abc'));
        cs.SearchBrandvalue();
        cs.selectBrands();
        
        cs.chkBox();
        Test.stopTest();
        }
     }
    
     static testMethod void test3() {
      Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','ComplaintManager');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Corporate',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH  Svmx_TestData_Util_UT.createCustomSettingData(); 
       BPD_Sample_Settings__c bpd1 = new BPD_Sample_Settings__c();
       bpd1.Name='abc';
       bpd1.Distinguisher_Field__c='Brand';
       bpd1.Owning_Org__c='test';
       insert bpd1;
       
       BPD_Sample_Settings__c bpd2 = new BPD_Sample_Settings__c();
       bpd2.Name='abc1';
       bpd2.Distinguisher_Field__c='Brand';
       bpd2.Owning_Org__c='test';
       insert bpd2;

       
        
        Date d = Date.newinstance(2014, 12, 27);
              
                  
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
        
         Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c = :cas1.Id];
        c1.Type_of_Record__c='Web';
        c1.How_Trademark_is_Used__c='Company Name';
        c1.Infringement_Type__c='Copyright';
        c1.Infringing_Product_Description__c='aaa';
        c1.Company__c='bbb';
        c1.Procedural_Status__c='Legal - In Progress';
        c1.Address__c='abc';
        c1.City__c='d';
        c1.State__c='e';
        c1.Target_Country__c='i';
        c1.Zip_Postal_Code__c='100';
        c1.Crop_Phase_Status__c='Incident';
        c1.RecordTypeId = CaseDetailsRecordType;
       
        update c1;
        
           
            Trademark_Abuse_Sample__c sample1 = new Trademark_Abuse_Sample__c();
            sample1.Country__c='India';
            sample1.Identification_Date__c=d;
            sample1.Active_Ingredients__c='Mancozeb';
            sample1.RecordTypeId=SampleRecordType;
            sample1.Case__c=cas1.id;
            insert sample1;
            
        Business_Partner__c bp = new Business_Partner__c();
        bp.Name ='Barra Mansa';
        bp.RecordTypeId=CPCSample;
        insert bp;
        
            Trademark_Abuse_Sample_Analysis__c sampleresult1 = new Trademark_Abuse_Sample_Analysis__c();
            sampleresult1.Lab_Name__c=bp.id;
            sampleresult1.Trademark_Abuse_Sample__c=sample1.id;
            insert sampleresult1;

        PageReference pageRef = Page.BPDCase;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        ctrlBPDCase cs = new ctrlBPDCase();
        cs.initialCaseDetail.Infringement_Type__c= '';
        cs.initialCaseDetail.Company__c= '';
        cs.initialCaseDetail.Record_Origination__c = '';
        cs.initialCaseDetail.Target_Country__c= '';
        cs.initialSample.Country__c= '';
        cs.initialSample.Identification_Date__c= d;
        cs.initialSample.Active_Ingredients__c= '';
        cs.initialSampleResult.Lab_Name__c=bp.id;
        cs.flagVar=true;
        cs.flagSample=false;
        cs.flagSample1=true;
        cs.permissions=false;
        cs.SelectedMaterials.add(new SelectOption('abc','abc')); 
        cs.userSBU='test';
        cs.searchBrand = 'a';
        cs.doSave();
        cs.doCancel();
        cs.brandselect();
        cs.SelectedMaterials.add(new SelectOption('abc1','abc'));
        cs.SearchBrandvalue();
        cs.selectBrands();
        
        cs.chkBox();
        Test.stopTest();
        }
     }
    
   }
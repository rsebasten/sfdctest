/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author :Bharagvi Alluri<bharagvi.alluri@tcs.com>
Description: This class is Unit Test class for class ctrlBPDSampleViewByActive2
***************************************************************************************/

@isTest
private class ctrlBPDSampleViewByActive2_UT{
/*
        static testMethod void test1() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
       
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

          
               
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(c1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'Case_Details__c';
         cs.selectedField= 'Country_text__c';
         cs.selectedCriteria= 'Contains';
         cs.searchRecords();
         cs.showFields();
         cs.doQuery();   
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=true;
         cs.hasPrev =false;
         cs.next();
         cs.prev();
         cs.pageNumber=1;
         cs.first();
         cs.last();
         
         Test.stopTest();
        }
        
        
      } 
      
     static testMethod void test2() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
             
        
        Date d = Date.newinstance(2014, 12, 27);
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
     
        
           
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

          
               
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(sample1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'Trademark_Abuse_Sample__c';
         cs.selectedField= 'Active_Ingredients__c';
         cs.selectedCriteria= 'Ends With';
         cs.searchRecords();
         cs.showFields();
         cs.doQuery();  
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=true;
         cs.hasPrev =false;
         cs.next();
         cs.prev();
         cs.pageNumber=1;
         cs.first();
         cs.last();
         
         Test.stopTest();
        }
        
        
      } 
      
      static testMethod void test3() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
        Date d = Date.newinstance(2014, 12, 27);
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
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

          
               
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(sampleresult1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'Trademark_Abuse_Sample_Analysis__c';
         cs.selectedField= 'Overall_Conclusion__c';
         cs.selectedCriteria= 'Does Not Equal';
         cs.searchRecords();
         cs.showFields();
         cs.doQuery();   
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=true;
         cs.hasPrev =false;
         cs.next();
         cs.prev();
         cs.pageNumber=1;
         cs.first();
         cs.last();
         
         Test.stopTest();
        }
        
        
      } 
      
       static testMethod void test4() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
       
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
        
           
    
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(c1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'ALL';
         cs.selectedField= 'Country_text__c';
         cs.selectedCriteria= 'Does Not Contain';
         cs.searchText='Test';
         cs.searchRecords();
         cs.showFields();
         cs.doQuery();   
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=false;
         cs.hasPrev =true;
         cs.next();
         cs.prev();
         cs.pageNumber=3;
         cs.first();
         cs.last();
         
         Test.stopTest();
        }
        
        
      } 
      
      static testMethod void test5() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
       
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
           
                 
               
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(c1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'ALL';
         cs.selectedField= 'Country_text__c';
         cs.selectedCriteria= 'Equals';
         cs.searchText='Test';
         cs.searchRecords();
         cs.showFields();
         cs.doQuery();   
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=false;
         cs.hasPrev =true;
         cs.next();
         cs.prev();
         cs.pageNumber=1;
         cs.first();
         cs.last();
         
         Test.stopTest();
        }
        
        
      } 
      
      static testMethod void test6() {
           Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      Final Id CPCSample=Rtype.getIdByDevName('Business_Partner__c','CPC_Sample_Analysis_Laboratories');
       Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',
        EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',
        LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12',
         EPass_ID__c='NA0000',User_Owning_Org__c='',UserOwningSBUOrg__c='Crop Protection',
         User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
     system.debug('recordtypeid****'+CaseRecordType);
       
       SVMXListSettings__c SVM1 = new SVMXListSettings__c(name='WarrantyLA', Static_Value__c='Warranty');
       SVMXListSettings__c SVM2 = new SVMXListSettings__c(name='ContractLA', Static_Value__c='Contract');
       SVMXListSettings__c SVM3 = new SVMXListSettings__c(name='BillableEMEA', Static_Value__c='Billable');
       SVMXListSettings__c SVM4 = new SVMXListSettings__c(name='Hardware ServiceEMEA', Static_Value__c='Hardware Service');
       SVMXListSettings__c SVM5 = new SVMXListSettings__c(name='Hardware SalesEMEA', Static_Value__c='Hardware Sales');
       SVMXListSettings__c SVM6 = new SVMXListSettings__c(name='ContractEMEA', Static_Value__c='ContractE');
       SVMXListSettings__c SVM7 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA', Static_Value__c='Uptime ContractType');
       SVMXListSettings__c SVM8 = new SVMXListSettings__c(name='Uptime ContractEMEA', Static_Value__c='Uptime Contract');
       SVMXListSettings__c SVM9 = new SVMXListSettings__c(name='WarrantyEMEA', Static_Value__c='WarrantyE');
       insert SVM1;
       insert SVM2; 
       insert SVM3; 
       insert SVM4;
       insert SVM5;
       insert SVM6;
       insert SVM7;
       insert SVM8;
       insert SVM9;       
       
       
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
           
                 
               
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(c1);
         ctrlBPDSampleViewByActive2 cs = new ctrlBPDSampleViewByActive2();
         cs.selectedObject= 'ALL';
         cs.selectedField= 'Country_text__c';
         cs.searchText=null ;
         cs.selectedCriteria= 'Begins With';
         cs.showFields();
         cs.searchRecords();
         cs.doQuery();   
         cs.getCaseDetails();
         cs.refresh();
         cs.hasNext=false;
         cs.hasPrev =true;
         cs.next();
         cs.prev();
         cs.pageNumber=2;
         cs.first();
         cs.last();
         
         
         Test.stopTest();
        }
        
        
      } */
}
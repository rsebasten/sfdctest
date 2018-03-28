/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDBrandEdit
***************************************************************************************/

@isTest
private class ctrlBPDBrandEdit_UT{
        static testMethod void test() {
       Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
      Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
//[12232016] Called Utility class to create Custom setting data
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){ 
         Test.startTest();
        //PKH Svmx_TestData_Util_UT.createCustomSettingData();    
        geoValidation.validateInTestMode=false;
        
         BPD_Sample_Settings__c bp = new  BPD_Sample_Settings__c();
         bp.Owning_Org__c='Crop Protection';
         bp.name='Acanto';
         insert bp;  
         
         BPD_Sample_Settings__c bp1 = new  BPD_Sample_Settings__c();
         bp1.Owning_Org__c='Crop Protection';
         bp1.name='Acend';
         insert bp1; 
        
        Date d = Date.newinstance(2014, 12, 27);
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        
        cas1=[select id from Case where id=:cas1.id];
        system.debug('aaaa'+cas1);
            
        Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c =:cas1.Id];
        c1.Owning_SBU__c='Titanium Technologies;Crop Protection';
        c1.brand__c='Acanto;Acend';
        c1.RecordTypeId = CaseDetailsRecordType;
        update c1;
      
              
        PageReference pageref=Page.BPDBrandEdit;
        Test.setCurrentPage(pageRef);
        
        
        ApexPages.currentPage().getParameters().put('id',cas1.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(cas1);
       
        ctrlBPDBrandEdit  cb = new ctrlBPDBrandEdit(controller);
        cb.brandselect();
        cb.SaveBrand();
        Test.stopTest();
        }
        }
        }
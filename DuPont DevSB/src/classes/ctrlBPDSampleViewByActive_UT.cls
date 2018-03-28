/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDSampleViewByActive
***************************************************************************************/

@isTest
private class ctrlBPDSampleViewByActive_UT{
        static testMethod void test() {
         //KT: Crop_sample to Brand_Protection_Abuse_Sample
         Final Id SampleRecordType=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
      
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
        Date d = Date.newinstance(2014, 12, 27);
        
        Trademark_Abuse_Sample__c sample = new Trademark_Abuse_Sample__c();
        sample.Country__c='India';
        sample.Active_Ingredients__c='Mancozeb';
        sample.Identification_Date__c=d;
        sample.RecordTypeId=SampleRecordType;
        insert sample;
        
        Test.startTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(sample);
         ctrlBPDSampleViewByActive cs = new ctrlBPDSampleViewByActive(controller);
         cs.selectedItemValue = 'Mancozeb (MAN)';
         cs.country = 'BAHRAIN';
         cs.samplePurchase= 'test';
         cs.recid=r1.id;
         cs.getActiveIngredients();   
         cs.methodone();
         cs.nimsinow();
         cs.getTrademarkAbuseSample();
         cs.refresh();
         cs.hasNext=true;
         cs.hasPrev =false;
         cs.next();
         cs.prev();
         cs.pageNumber=1;
         cs.first();
         cs.last();
         cs.getRecords();
         Test.stopTest();
        }
        }
        }
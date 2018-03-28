/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class SampleHandler
***************************************************************************************/

@isTest
private class SampleHandler_UT{
 static testMethod void test() {
 Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
 final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c', 'Brand_Protection_Abuse_Sample');
 final Id BPDCase=Rtype.getIdByDevName('Case', 'Brand_Protection_Legal_Case');        
 Profile p1 = [select id from profile where Name='System Administrator' limit 1];
 //UserRole r1= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
 UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];

 User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
 insert user1;
  System.runas(user1){  
  geoValidation.validateInTestMode=false;
  
  Test.StartTest();
  BPD_Sample_Settings__c b = new BPD_Sample_Settings__c();
        b.Abbreviation__c = 'IDN';
        b.Name='INDONESIA';
        insert b;
        
        BPD_Sample_Settings__c b1 = new BPD_Sample_Settings__c();
        b1.Abbreviation__c = 'SUR';
        b1.Name='Surfactant';
        insert b1;
         Date d = Date.newinstance(2014, 12, 27);
     
        Trademark_Abuse_Sample__c s = new Trademark_Abuse_Sample__c();
        s.Active_Ingredients__c='Surfactant';
        s.Country__c = 'INDONESIA';
        s.Identification_Date__c=d;
        s.RecordTypeId=CropSample;
        insert s;
        
        
      Test.stopTest();  
         }
     }
   }
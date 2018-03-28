/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: test Class to cover Batch Process scheduleCSAccountDailyUpdate. 
********************************************************************************/
@isTest
private class scheduleCSAccountDailyUpdate_UT{

static testMethod void testschedule() {

Test.StartTest();
CS_Account_Load_Settings__c s= new CS_Account_Load_Settings__c(Name='Batch Criteria',AccountGroup__c='Z001 ( Sold-to party )',AccountOwner__c='Customer Service',AccountOwnerUserName__c='customerservice@dupont.com',RecordType_Name__c='ERP Customer - Extended Data',
SendErrorNotificationTo__c='anup_kumar14@infosys.com');
insert s;
CS_YKPartnerMapping__c cs=new CS_YKPartnerMapping__c(Name='25590',Shared_Service_Center__c='CSCI');
insert cs;
scheduleCSAccountDailyUpdate shcheduledClass = new scheduleCSAccountDailyUpdate();

String sch = '0 0 0 15 3 ? 2022';
system.schedule('Test', sch, shcheduledClass); 
Test.stopTest(); 

}





}
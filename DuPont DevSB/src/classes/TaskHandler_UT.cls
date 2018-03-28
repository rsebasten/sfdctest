/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Vinayak Vijayakumar
Email: Vinayak.Vijayakumar@usa.dupont.com
Date : 29th May 2011
Description : Test class for TaskHandler Modification Log 
* ============================================================================= 
* Ver   Date        Author               Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   29-Aug-11   Vinayak VijayaKumar Initial Code
* 1.1   05-Sep-11   Vinayak Vijayakumar Changed Rtype.getIdByName to Rtype.getIdByDevName, 
                                           as there was Translation Issue.
**************************************************************************************************************/

@isTest
private class TaskHandler_UT{

    static testMethod void testTask() {
        // TO DO: implement unit test
        final Id TASK_COMP_RTYPE=Rtype.getIdByDevName('Task','CustomerFollowup');  
        final Id BI_EMEA_CASE_RTYPE=Rtype.getIdByDevName('Case','BI_EMEA_Case');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        //UserRole r1= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        User user2 = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t123', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        insert user2;
        User sysUser = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain12345',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.sys@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert sysUser;
        Test.startTest();
        System.runAs ( sysUser ) {
            Account acc1 = new Account(name='test Account1', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123',ownerId=User1.Id);
            insert acc1;
            Case case1 = new Case(subject='Unit Test',Status='New',RecordTypeId=BI_EMEA_CASE_RTYPE);            
            insert case1;
            Task task1=new Task(WhatId=case1.Id,Status='Not Started',RecordTypeId=TASK_COMP_RTYPE,Description='test BODY_SEARCHSTR description');
            insert task1;
            task1.Status='Completed';
            update task1;
            ctrlEmailTaskDetails cETD= new ctrlEmailTaskDetails();
            cETD.activityId=task1.Id;
            String activityId=cETD.activityId;
        }
    }

/*    
    static testMethod void testTask1() {
        final Id CUPS_RTYPE=Rtype.getIdByDevName('Task','Notification');
        Id CUPSSaveRecId=RType.getIdByDevName('CUPS_Request__c','DPP_Poly_PA_Approved');
        //Profile profileId1 = [select id from profile where Name='System Administrator' limit 1];
        Profile profileId1=[select id from Profile where Name='DPP-Polymers Standard CUPS PA User'];
        User userTest=new User(LastName='testLastName11',FirstName='tesobj1FirstName11',Alias='tUser1',ProfileId=profileId1.id,Email='vamsi_chinnam@infosys.com',Username='testCUPS_User1@dupont.com.test2',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US',Approver_Role__c='District Sales Manager'); 
        insert userTest;
        
        system.runas(userTest){
            Account testAccount = new Account();
            testAccount.Name = 'My Test Account';
            insert testAccount; 
            testAccount = [Select id,Name from Account where id =: testAccount.Id];
            testAccount.IsPartner = true;
            update testAccount;
            CUPS_Request__c cupsReq= new CUPS_Request__c(Distribution_Pricing_Analyst__c=userTest.id,Type__c ='Price Authorization',Approval_Status__c='Draft',Distribution_Leader__c=userTest.id,Distributor_District__c='district',Distributor_Sales_Rep__c=userTest.id,Distributor_Account__c=testAccount.id,Ship_To_Customer_Name__c=testAccount.id,Sold_To_Customer_Name__c=testAccount.id,recordTypeId=CUPSSaveRecId,Start_Date__c=Date.newInstance(2012,07,01),Stage__c = 'Current PA',Cups_Admin__c = userTest.id,Credit_Processed_Date__c = Date.newInstance(2012,07,05),deletion_date__c =Date.newInstance(2012,07,05),ownerId=userTest.Id, Distributor_Name__c = 'My Test Account');
            insert cupsReq;
            Task task1=new Task(WhatId=cupsReq.Id,Status='Not Started',RecordTypeId=CUPS_RTYPE, ownerId=userTest.Id,Description='test BODY_SEARCHSTR description');
            insert task1;
            task1.status = 'Not Started';
            update task1;
            task1.status = 'completed';
            try{
                update task1;
            }
            catch(exception e){
                //Asser your result here
                system.assert(e.getMessage().contains('You are not authorized to update once the Task is closed'));
            }
            try{
                delete task1;
            }
            catch(exception e){
                //Asser your result here
                system.assert(e.getMessage().contains('You are not authorized to delete the closed task'));
            }
        }
    }
*/
    
    static testMethod void testTask2() {
     Final Id GenericTask=Rtype.getIdByDevName('Task','GenericTask');  
     Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
     String BPD_PROOFOFUSE_SEARCHSTR = 'Proof of Use';
     String BPD_PROPERUSE_SEARCHSTR = 'Proper Use';
     String BPD_CD1_SEARCHSTR1 = 'Cease and Desist - Notice of Trademark Infringement';
     String BPD_CD1_SEARCHSTR2 = 'Cease and Desist - Unauthorized Use of';
     String BPD_CD2_SEARCHSTR = 'Cease & Desist - Second Notice of Trademark Infringement';
     String BPD_BPCLOSURE_SEARCHSTR = 'Confirmation of Trademark Compliance';
     Profile p1 = [select id from profile where Name='System Administrator' limit 1];
     //UserRole r1= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
     UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
     User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
     insert user1;
     System.runas(user1){  
     Case cas = new Case(subject='Unit Test',Status='New',RecordTypeId=CaseRecordType);            
            insert cas;
            List<Task> t = new List<Task>();
            Task task=new Task(WhatId=cas.Id,Subject=BPD_PROPERUSE_SEARCHSTR,Status='Completed',RecordTypeId=GenericTask, ownerId=user1.Id,Description='test BODY_SEARCHSTR description');
            t.add(task);
            Task task1=new Task(WhatId=cas.Id,Subject=BPD_PROOFOFUSE_SEARCHSTR,Status='Completed',RecordTypeId=GenericTask, ownerId=user1.Id,Description='test BODY_SEARCHSTR description');
            t.add(task1);
            Task task2=new Task(WhatId=cas.Id,Subject=BPD_CD1_SEARCHSTR1,Status='Completed',RecordTypeId=GenericTask, ownerId=user1.Id,Description='test BODY_SEARCHSTR description');
            t.add(task2);
            Task task3=new Task(WhatId=cas.Id,Subject=BPD_CD2_SEARCHSTR,Status='Completed',RecordTypeId=GenericTask, ownerId=user1.Id,Description='test BODY_SEARCHSTR description');
            t.add(task3);
            Task task4=new Task(WhatId=cas.Id,Subject=BPD_BPCLOSURE_SEARCHSTR,Status='Completed',RecordTypeId=GenericTask, ownerId=user1.Id,Description='test BODY_SEARCHSTR description');
            insert task4;
            insert t;  
        }
        }
        
   
    //<jj04012016> START NEW CODE    
    static testMethod void testTask3() {
        
        Final Id prog=Rtype.getIdByDevName('Task','CustomerFollowup');
        Account a = new account (name='Test', ShippingCountry='US');
        insert a;
        Opportunity o = new opportunity (AccountId=a.id, name='OppTest', stagename='Prospect', closeDate=Date.today(), Amount=1);
        insert o;
        list<task> lt = new list<task>();
        lt.add(new Task(WhatId=o.Id,OwnerId=UserInfo.getUserId(),Type='Client',Status='Not Started',RecordTypeId=prog));
        lt.add(new Task(WhatId=o.Id,OwnerId=UserInfo.getUserId(),Type='Internal',Status='Not Started',RecordTypeId=prog));
        insert lt;
        lt[0].Status='Completed';
        lt[1].Status='Completed';
        update lt;
    
    }   
    //<jj04012016> END NEW CODE
}
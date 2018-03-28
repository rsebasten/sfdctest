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
Description : Test class for ContractHandler

 * Modification Log 
 * ============================================================================= 
 * Ver   Date        Author                 Modification 
 * ---   ---------   ----------- ----------------------------------------------- 
 * 1.0   19-Sep-11   Vinayak VijayaKumar    Initial Code
 * 1.1   19-Sep-11   Vinayak Vijayakumar    Changed Rtype.getIdByName to Rtype.getIdByDevName, 
                                           as there was Translation Issue.
 * 1.2   26-Jul-12   Ibtesamuddin Mohammed  Added Test Functionality for dynamic Approval                                
 **************************************************************************************************************/

@isTest
private class ContractHandler_UT{

    static testMethod void testContracts() {
        // TO DO: implement unit test
        final Id CONT_ONE_DUPONT_APPR_RTYPE=Rtype.getIdByDevName('Contract','OneDupont_Contracts_Approved');
        final Id CONT_ONE_DUPONT_RTYPE=Rtype.getIdByDevName('Contract','OneDupont_Contracts');
        final Id CONT_ONE_DUPONT_ACTIVATED_RTYPE=Rtype.getIdByDevName('Contract','OneDupont_Contracts_Activated');
        final Id BI_EMEA_CONTRACTS=Rtype.getIdByDevName('Contract','BI_Contracts');
        final Id DSS_CONTRACT_RTYPE = Rtype.getIdByDevName('Contract','DSS_Global_Contracts');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        User user2 = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t123', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America',ManagerId=user1.id);
        insert user1;
        insert user2;
        User sysUser = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain12345',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.sys@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert sysUser;
        List<Approval.ProcessSubmitRequest> reqList = new List<Approval.ProcessSubmitRequest>();
        List<Contract> insertContractList = new List<Contract>();
        List<Contract> updateContractList = new List<Contract>();

        System.runAs ( sysUser ) {
            try{

//Unit test code for dynamic approval logic - start
                Account accc = new Account(name='test Account1', country__c = 'UNITED STATES',ownerId=sysUser.Id);
                insert accc;
                //KT [11072017]: To remove sector__c ='Services', reference
                Opportunity opp = new Opportunity (account = accc, name='test', stagename='target', closeDate=Date.Today(), CurrencyIsoCode='USD',Amount=1600000);
                Contact c1 = new Contact (accountid=accc.id, firstName='one', lastname='tester', email='test1@test.com',Title='beta tester 1', Prefered_Language__c='ENGLISH', mailingState='DE');
                insert opp;
                insert c1;
                For(Integer i = 0;i<100;i++){
                    //Contract contr1 = new Contract(Name='Unit Test'+i,AccountId=accc.Id,Status='Draft',Category__c='Non-Standard',StartDate=Date.Today(),Opportunity__c=opp.id,CustomerSigned=c1,RecordTypeId=DSS_CONTRACT_RTYPE,ownerId=sysUser.Id,CurrencyIsoCode='USD');
                    Contract contr1 = new Contract(Name='Unit Test'+i,AccountId=accc.Id,Status='Draft',StartDate=Date.Today(),Opportunity__c=opp.id,CustomerSigned=c1,RecordTypeId=DSS_CONTRACT_RTYPE,ownerId=sysUser.Id,CurrencyIsoCode='USD');
                    insertContractList.add(contr1);
                }

                insert insertContractList;
                For(Contract c : insertContractList){
                    c.Step_Number__c = 1;
                    updateContractList.add(c);
                    Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
                    app.setObjectId(c.Id);
                    reqList.add(app);
                }

                Test.startTest();
                update updateContractList;
                approval.ProcessResult[] result = Approval.process(reqList);

//Unit test code for dynamic approval logic - end


                Account acc1 = new Account(name='test Account1', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123',ownerId=User1.Id);
                insert acc1;
                Contract contr1 = new Contract(Name='Unit Test',AccountId=acc1.Id,Status='Draft',RecordTypeId=CONT_ONE_DUPONT_RTYPE,ownerId=User2.Id);
                insert contr1;
                contr1.RecordTypeId=CONT_ONE_DUPONT_APPR_RTYPE;
                update contr1;
                Attachment attach1=new Attachment(); 
                attach1.Name='Unit Test Attachment';
                attach1.OwnerId = user1.Id;
                Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body1');
                attach1.body=bodyBlob1;
                attach1.parentId=contr1.id;
                attach1.ContentType='application/pdf';
                insert attach1;
                contr1.status='Activated';
                update contr1;                

                Contract contr2 = new Contract(Name='Unit Test',AccountId=acc1.Id,Status='Draft',RecordTypeId=CONT_ONE_DUPONT_RTYPE,ownerId=User2.Id);
                insert contr2;    
                contr1.RecordTypeId=CONT_ONE_DUPONT_APPR_RTYPE;
                contr2.Related_Contract__c=contr1.Id;
                update contr2;

                Attachment attach2=new Attachment(); 
                attach2.Name='Unit Test Attachment';
                attach2.OwnerId = user2.Id;
                Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body2');
                attach2.body=bodyBlob2;
                attach2.parentId=contr2.id;
                attach2.ContentType='application/pdf';
                insert attach2;

                Attachment attach3=new Attachment(); 
                attach3.Name='Unit Test Attachment';
                attach3.OwnerId = user2.Id;
                Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body3');
                attach3.body=bodyBlob3;
                attach3.parentId=contr2.id;
                attach3.ContentType='application/msword';
                insert attach3;

                contr2.RecordTypeId=CONT_ONE_DUPONT_ACTIVATED_RTYPE;
                contr2.Approval_Status__c='Received & Activated';
                contr2.status='Activated';

                update contr2;    
                Account acc2 = new Account(name='test Account2', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123',ownerId=User2.Id);
                insert acc2;
                List<Contract> contr3 = new List<Contract>();
                contr3.add(new Contract(Name='Unit Test 1',AccountId=acc2.Id,Status='Draft',RecordTypeId=BI_EMEA_CONTRACTS,ownerId=User2.Id,Type__c='DuPont',Contract_Location__c='ABCD',StartDate=Date.today(),Contract_Expiration_Date__c=Date.today().addYears(10)));

                insert contr3;

            }
            catch(DMLException e){
                e.getMessage();
            }

        }
    }
}
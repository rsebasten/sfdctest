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
Description : Test class for trigCase and CaseHandler
* Modification Log 
* ============================================================================= 
* Ver   Date        Author                 Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   29-May-11   Vinayak VijayaKumar    Initial Code
* 1.1   05-Jun-11   Vinayak Vijayakumar    Changed Rtype.getIdByName to Rtype.getIdByDevName, 
                                           as there was Translation Issue.
*1.2    17-Oct-11   Vinayak Vijayakumar    Centralized test class for all the Case triggers
*1.3    01-May-12   Mohammed Ahmed         Added sample records to cover the UpdateBilling Type logic  
*1.4    20-Oct-16   Abhinav Bhatnagar        Bulkifying queries to avoid Too Many SOQL exception <AB20161020>  
**************************************************************************************************************/

@isTest
private class CaseHandler_UT{

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        final Id AGCP_CPC_LA_PRC_RTYPE=Rtype.getIdByDevName('Case','BI_NA_Surf_Tech_Inquiry');
        final Id DPC_NA_RES_CASE_RTYPE=Rtype.getIdByDevName('Case','DPC_NA_Product_Complaint_Resolve');
        final Id DPC_NA_INV_CASE_RTYPE=Rtype.getIdByDevName('Case','DPC_NA_Product_Complaint_Investigate');
        final Id DPC_NA_CLR_CASE_RTYPE=Rtype.getIdByDevName('Case','DIMC_AP_Complaint');
        final Id DEC_PG_LA_CASE_RTYPE=Rtype.getIdByName('Case', 'DEC-PG LA Service');
        final Id DEC_PG_EMEA_CASE_RTYPE=Rtype.getIdByName('Case', 'DEC-PG EMEA Service');
        List<Case> updateCaseList=new List<case>();
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        //UserRole r1= [Select id from UserRole where Name='DuPont Fully Owned' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        //<AB20161020> Start
        LIST<User> users = new List<User>();
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        User user2 = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.test@usa.dupont.com.t123', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        //insert user1;
        //insert user2;
        User sysUser = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain12345',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Vinayak.Vijayakumar@infosys.com',UserName='Vinayak.Vijayakumar.sys@usa.dupont.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        //insert sysUser;
        users.add(user1);
        users.add(user2);
        users.add(sysUser);
        //<AB20161020> End
        insert users;
        //Test.startTest();-- Commented By Praveen 25/05/2012
        System.runAs ( sysUser ) {
            //<AB20161020> Start
            List<Material__c> materials = new List<Material__c>();
            Material__c material1 = new Material__c(name='Test', Material_Manager__c=user1.Id);
            Material__c material2 = new Material__c(name='Test1', Material_Manager__c=user2.Id);
            //insert material1;
            //insert material2;
            materials.add(material1);
            materials.add(material2);
            insert materials;
            List<Case> cases = new List<Case>();
            Case case1 = new Case(subject='Unit Test',related_material__c=material1.Id, Status='New',RecordTypeId=AGCP_CPC_LA_PRC_RTYPE);
            //insert case1;
            Case case3 = new Case(subject='Unit Test', ownerId=user1.Id,Status='New',Code__c='blue',Manufacturer__c='Audi',RecordTypeId=DPC_NA_CLR_CASE_RTYPE);
            //insert case3;
            cases.add(case1);
            cases.add(case3);
            insert cases;
            //<AB20161020> ENd
            case1.related_material__c=material2.Id;
            update case1;
            case1.related_material__c=null;
            update case1;
            List<RecordType > lstaccountRecTypes = new list<RecordType >();
            lstaccountRecTypes  = [select Id ,name from RecordType where sobjectType = 'account' and name ='ERP customer'];
            Account acc1 = new Account(name='test Account1', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123',recordtypeId=lstaccountRecTypes[0].Id);
            insert acc1;
            Date d = Date.newinstance(2015, 01, 02);
            
             //<AB20161020> Start

            List<Case> cases1 = new List<Case>();

            Case ca = new Case();
            ca.Investigation_Completion_Date__c=d;
            ca.RecordTypeId=DPC_NA_RES_CASE_RTYPE;
            //insert ca;
            cases1.add(ca);
            Case cs = new Case();
            cs.AccountId=acc1.Id;
            cs.RecordTypeId= DPC_NA_CLR_CASE_RTYPE;           
            //insert cs;
            cases1.add(cs);
            Case case2 = new Case(subject='Unit Test',AccountId=acc1.Id,Status='New',RecordTypeId=DPC_NA_INV_CASE_RTYPE);
            //insert case2;
            cases1.add(case2);
            insert cases1;
             //<AB20161020> End

            case2.Investigation_Completion_Date__c=System.Today();
            update case2;
            case3.ownerId=user2.Id;
            update case3;
          
            
            Test.startTest();            
            /*TAG01052012 : Sample records insertion to cover the UpdateBillingType logic*/
            Account acc=new Account(Name='ABC',CurrencyIsoCode='USD',Owning_Organization__c='DEC-Packaging Graphics',Type='Agent',Industry='Packaging',Country__c='INDIA');
            insert acc;
            Contact cont=new Contact(LastName='PARAGON LABELS - BOSTON',AccountId=acc.Id,Email='cyrel-svmx-support@usa.dupon.com',Phone='(800) 345-9999'); 
            insert cont;
            
            //SVMXC__Site__c site=new SVMXC__Site__c(Name='PARAGON',SVMXC__Street__c='INDUSTRIAL ESTATE',SVMXC__Country__c='United States',SVMXC__Zip__c='PE21 7SZ',SVMXC__Account__c=acc.Id);
            //insert site;
            //SVMXC__Service_Contract__c contract=new SVMXC__Service_Contract__c(Name='XYZ',SVMXC__Company__c=acc.Id,PM_EMC_Coverage__c='Product',SVMXC__Start_Date__c=System.today(),SVMXC__End_Date__c=(System.today()+14),SVMXC__Service_Level__c=null,Contract_Type__c='Hardware Contract Service');
            //insert contract;
            
            //Case c=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_LA_CASE_RTYPE,SVMXC__Service_Contract__c=contract.Id,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c);
            
            //SVMXC__Installed_Product__c ip=new SVMXC__Installed_Product__c(Name='1234',SVMXC__Status__c='Installed');
            //insert ip;
            //SVMXC__Warranty__c warranty=new SVMXC__Warranty__c(SVMXC__Installed_Product__c=ip.Id,SVMXC__End_Date__c=System.Today());
            //insert warranty;
            
            //Case c1=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_LA_CASE_RTYPE,SVMXC__Service_Contract__c=null,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c1);
            //Case c2=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Service_Contract__c=null,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c2);
            //Case c3=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Service_Contract__c=null,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c3);
            //Case c4=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Service_Contract__c=contract.Id,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c4);
            
            //SVMXC__Service_Contract__c contract1=new SVMXC__Service_Contract__c(Name='XYZ',SVMXC__Company__c=acc.Id,PM_EMC_Coverage__c='Product',SVMXC__Start_Date__c=System.today(),SVMXC__End_Date__c=(System.today()+14),SVMXC__Service_Level__c=null,Contract_Type__c='Uptime Contract');
            //insert contract1;
            
            //Case c5=new Case(Status='Close',ContactId=cont.Id,SVMXC__Site__c=site.Id,Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Service_Contract__c=contract1.Id,SVMXC__Warranty__c=null,SVMXC__Billing_Type__c='Billable',Priority='Medium');
            //updateCaseList.add(c5);
            //Added by Praveen 22/May/2012
            //Case c6=new Case(Status='Open',SVMXC__Component__c=ip.id,Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Billing_Type__c='Billable',Priority='Medium');
             //updateCaseList.add(c6);
             insert updateCaseList;
           //SVMXC__Service_Order__c workOrder2 = New SVMXC__Service_Order__c(Case_Reason__c='test1',ERP_Company_Code__c='test123',CreatedDate=system.now(),ERP_Material_Code__c='erptest123',SVMXC__Priority__c='Medium',SVMXC__Component__c=ip.id,SVMXC__Locked_By_DC__c=false);                                                     
           //insert workOrder2;
            //Case c7=new Case(Status='Open',SVMXC__Component__c=ip.id,Origin='Phone',Reason='EMC',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,Priority='Medium');          
            //insert c7; 
            Test.stopTest();

        }   
       //Test.stopTest(); - Commented By Praveen 
    }
    
    public static testMethod void LoadData() {
        List <Case> cases = new List<Case>();
        Case case1 = null;
        try{
            final Id CS_ORDER_RTYPE=Rtype.getIdByDevName('Case','CS_Order');
            final Id CS_SERVICEREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_ServiceRequest');
            final Id CS_INTERNALREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_InternalRequest');
            final Id CS_ACCOUNT1_RTYPE=Rtype.getIdByDevName('Account','ERP_Customer_General_Data');
            final Id CS_ACCOUNT2_RTYPE=Rtype.getIdByDevName('Account','CS_ERPCustomer');
            final Id CS_BPL_CASE_RTYPE=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
            final Id DPC_NA_PRODUCT_COMPLAINT_RESOLVE=Rtype.getIdByDevName('Case','DPC_NA_Product_Complaint_Resolve');
            final Id DEC_PG_EMEA_CASE_RTYPE=Rtype.getIdByName('Case', 'DEC-PG EMEA Service');
            final Id DPC_NA_RES_CASE_RTYPE=Rtype.getIdByDevName('Case','DPC_NA_Product_Complaint_Resolve');
            Profile p1 = [select id from profile where Name='System Administrator' limit 1];
            
            Test.startTest();
            Account acc1 = new Account(name='Test Account',RecordTypeId=CS_ACCOUNT2_RTYPE);//[select id from Account where RecordTypeId=:CS_ACCOUNT2_RTYPE LIMIT 1];
            insert acc1;
            User usr1 = new User(LastName='XYZ',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test.test@test23.com',UserName='test.test@test23.com', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
            insert usr1;
            //SVMXC__Installed_Product__c ip=new SVMXC__Installed_Product__c(Name='1234',SVMXC__Status__c='Installed');
            //insert ip;
            //SVMXC__Service_Order__c workOrder2 = New SVMXC__Service_Order__c(Case_Reason__c='test1',ERP_Company_Code__c='test123',CreatedDate=system.now(),ERP_Material_Code__c='erptest123',SVMXC__Priority__c='Medium',SVMXC__Component__c=ip.id,SVMXC__Locked_By_DC__c=false);                                                     
           //insert workOrder2;
            System.runAs(usr1){
                case1 = new Case(subject='Unit Test',Accountid=acc1.id,ownerid=usr1.id,  Status='New',RecordTypeId=CS_INTERNALREQUEST_RTYPE,CaseCategory__c='New Order',CaseSubCategory__c='Others');
                cases.add(case1);            
                Case case2 = new Case(subject='Unit Test',  Status='New',RecordTypeId=CS_BPL_CASE_RTYPE,CaseCategory__c='New Order',CaseSubCategory__c='Others');
                cases.add(case2); 
                Case case3 = new Case(subject='Unit Test',  Status='New',RecordTypeId=DPC_NA_PRODUCT_COMPLAINT_RESOLVE,CaseCategory__c='New Order',CaseSubCategory__c='Others');
                cases.add(case3);
                //Case case4=new Case(Status='Open',SVMXC__Component__c=ip.id,Owning_Organization__c='DEC-Packaging Graphics',RecordtypeId=DEC_PG_EMEA_CASE_RTYPE,SVMXC__Billing_Type__c='Billable',Priority='Medium');
                //cases.add(case4);
                insert cases;
                case1.ownerid=usr1.id;
                case1.status='In Progress';
                update case1;
                case1.Status='Closed';
                case2.Status='In Progress';
                case3.Status='In Progress';
                case3.Investigation_Completion_Date__c=date.today();
                case3.RecordTypeId=DPC_NA_RES_CASE_RTYPE;
                update cases;
                
            }
            
            
            
            
        }catch(Exception e){
            
            System.debug('Exception Occured ===>>> '+e.getStackTraceString());
             }
        executeTest(cases);
        Test.stopTest();
    }
    
    public static  void executeTest(List<Case> cases) {
        ID batchprocessid = Database.executeBatch(new batchCSFillFCA(cases),5);
        
    }
    //<AJ20161111>START Used to cover updateParentCase method in CaseHandler class
    static testMethod void test_updateParentCase()
    {
        final Id AGCP_CPC_EMEA_Complaint_RTYPE=Rtype.getIdByName('Case','AGCP-CPC EMEA Complaint');
        final Id AGCP_CPC_Case_Material_RTYPE=Rtype.getIdByName('Case_Material__c','AGCP-CPC EMEA Complaint');
        Test.startTest();
        //KT [11072017]: To remove Problem_Categories__c='Logistic'reference
        Case emea_Case=new Case(Status='New',RecordtypeId=AGCP_CPC_EMEA_Complaint_RTYPE,Priority='Medium');
        insert emea_Case;
        Case_Material__c caseMaterial = new Case_Material__c();
        caseMaterial.Case__c = emea_Case.id; 
        caseMaterial.recordTypeID = AGCP_CPC_Case_Material_RTYPE;
        insert caseMaterial;
        emea_Case.status = 'In Progress';
        update emea_Case;
        emea_Case.status = 'EMEA Pending - QM';
        update emea_Case;
        emea_Case.status = 'Owner Assigned';
        update emea_Case;
        //KT [11072017]: To remove Problem_Categories__c='Logistic'reference
        Case emea_Case_child=new Case(Status='New',ParentId = emea_Case.id,RecordtypeId=AGCP_CPC_EMEA_Complaint_RTYPE,Priority='Medium');
        insert emea_Case_child;
        emea_Case_child.status = 'Section Investigation Closed';
        update emea_Case_child;
        Test.stopTest();
    }
    //<AJ20161111>END
}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Unit Test for batchCSFillFCA
********************************************************************************/
@isTest(seealldata=true)
/******************************************************************************* 
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description: Test Class for filling first close age on cases which are closed.
This should be a one time activity.
********************************************************************************/

public class batchCSFillFCA_UT {
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
    
}
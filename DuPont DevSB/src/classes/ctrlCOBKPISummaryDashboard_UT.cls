/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlCOBKPISummaryDashboard
*******************************************************************************/
//[01202017] Merge&Spin: Created test class for 'ctrlCOBKPISummaryDashboard' class.
@isTest
public class ctrlCOBKPISummaryDashboard_UT {
    public static testMethod void test1(){
        Customer_Data_Request__c customerData = new Customer_Data_Request__c();
        customerData.RecordTypeId= Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
        customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '4860 - DUP (Thailand) Ltd';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
        	customerData.SBU__c = 'C5 - Electronics and Communications';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z001 ( Sold-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'US-USA';
            customerData.Existing_Country__c = 'US-USA';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Leveraged_CSR__c = false;
        	customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='500';
        	customerData.Start_Date__c = system.today();
        	customerData.End_Date__c = System.today().addDays(5);
        	customerData.Request_Status__c = 'Request Completed in SAP' ;
            insert customerData;  
        PageReference pg = Page.COB_KPISummaryDashboard_new ;
        test.setCurrentPage(pg);
        ctrlCOBKPISummaryDashboard ctrl = new ctrlCOBKPISummaryDashboard();
        ctrl.OnboardingReq = customerData; 
        List<SelectOption> sellingCompanyCodeList = ctrl.getsellingCompanyCode();
        List<SelectOption> SBUCodeList  = ctrl.getSBUCode();
        ctrl.setcompanyCodeList('4860 - DUP (Thailand) Ltd');
        ctrl.setSBU('C5 - Electronics and Communications');
        ctrl.DateSubmit();
        
    }
}
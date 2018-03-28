/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Nishanth H
Email: nishanth_h@infosys.com
Description:  Test class for Apex Class: ctrlCOBDataReqNewEdit
********************************************************************************/

@isTest
public class ctrlCOBDataReqNewEdit_UT {

 public static final string NEWCUSTOMERCREATION_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
 public static final string EXTENDEXISTINGCUSTOMER_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');
 public static final string PARTNERFUNCTIONLINK_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
 public static final string MISCELLANEOUS_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request');
 public static final string MODIFY_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');
 
 public static testMethod void method1() {
 
 Test.StartTest();
 
       Account vAccount = new Account();
        vAccount.Name='TestAccount';
        vAccount.OwnerId = userInfo.getUserId();
        vAccount.ERP_Company_Code__c='E456';
        vAccount.VAT_Number__c='V768';
        vAccount.Country__c='India';
        insert vAccount;

   Customer_Data_Request__c cdr = new Customer_Data_Request__c();
        cdr.Customer_Name__c='TestA';
        cdr.Customer_Name_2__c='TestB';
        cdr.recordtypeId= NEWCUSTOMERCREATION_COB_RTYPE;
        cdr.Sold_To_Office_House_Number__c = 'test';
        cdr.Sold_to_State_Province__c = 'test';
        insert cdr;
   Customer_Data_Request__c cdr1=new Customer_Data_Request__c();       
 
   ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        insert ERPCust;

    ApexPages.StandardController sc = new ApexPages.standardController(cdr);
    ctrlCOBDataReqNewEdit con = new ctrlCOBDataReqNewEdit(sc);
    con.getRecordTypes();
    ApexPages.currentPage().getParameters().put('clone','clone');
    ApexPages.currentPage().getParameters().put('Account', vAccount.Id); 
    ApexPages.currentPage().getParameters().put('ERPCustomer', ERPCust.Id);
    ApexPages.currentPage().getParameters().put('Search','Duplicate');
   // Apexpages.currentpage().getParameters().put('Case',cas.id);
    ctrlCOBDataReqNewEdit con2 = new ctrlCOBDataReqNewEdit(sc);

  con.newEdit();
  con.so=cdr1;
  con.newEdit();
  con.so=cdr1;
  con.redirect();
  con.so=cdr;
  con.redirect();
  
  cdr.RecordTypeId=EXTENDEXISTINGCUSTOMER_COB_RTYPE ;
  update cdr;
  con.redirect();
  
  cdr.RecordTypeId=PARTNERFUNCTIONLINK_COB_RTYPE ;
  update cdr;  
  con.redirect();
  
  cdr.RecordTypeId=MISCELLANEOUS_COB_RTYPE ;
  update cdr; 
  con.redirect();
  
  cdr.RecordTypeId=MODIFY_COB_RTYPE ;
  cdr.Proposed_Terms_of_Payment__c='8A06-NET 30 DAYS EOM';
  cdr.Proposed_Credit_Limit__c='500';
  cdr.Proposed_Credit_Term_Type__c='Open Credit';
  cdr.Proposed_Credit_Limit_Currency_Code__c='BHD - Bahrain Dinar';
  cdr.Estimated_Number_of_Orders_per_Month__c=10;
  cdr.Estimated_Average_Monthly_Purchases__c=5;
  update cdr; 
  con.redirect();
  
  cdr.RecordTypeId=null;
  con.redirect();
  
  con.so=cdr1;
  con.redirect();
  
  con.RTypeSelected=EXTENDEXISTINGCUSTOMER_COB_RTYPE;
  con.Search='Duplicate';
  con.redirect();
  
  con.Search='Modify';
  con.RTypeSelected=NEWCUSTOMERCREATION_COB_RTYPE ;
  con.redirect();
  
  con.RTypeSelected=EXTENDEXISTINGCUSTOMER_COB_RTYPE;
  con.redirect();
  
  con.RTypeSelected=PARTNERFUNCTIONLINK_COB_RTYPE ;
  con.redirect();
  
  con.RTypeSelected=MISCELLANEOUS_COB_RTYPE ;
  con.redirect();
  
  con.RTypeSelected=MODIFY_COB_RTYPE ;
  con.redirect();
  
  con.RTypeSelected=null;
  con.redirect();
  
  con.cancel();

test.stopTest();
}
}
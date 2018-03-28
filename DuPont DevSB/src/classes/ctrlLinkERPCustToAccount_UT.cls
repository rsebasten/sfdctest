/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Mounika Kompalli
Email: mounika_kompalli@infosys.com
Description:Test class written for the class ctrlLinkERPCustToAccount
 ********************************************************************************/ 
@IsTest
private class ctrlLinkERPCustToAccount_UT 
{
 //   public static Account testAccount { GET { return new Account(name='TestCo: ', country__c='United States'); }}

    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User u = new User(Alias = 'standt45', Email='standarduser13@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1212', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser13434@testorg.com');
            
   static testMethod void ctrlLinkERPCustToAccountut() { 
     
        Customer_Data_Request__c req1,req3;
        Customer_Data_Request__c req = new Customer_Data_Request__c();
        Customer_Data_Request__c req2 = new Customer_Data_Request__c();
        list<ERP_Customer__c> lst_ERPCust1 = new list<ERP_Customer__c>();
        ID selectedRecordTypeId = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
        List <Customer_Data_Request__c> custDataToUpdate = new List <Customer_Data_Request__c>();   
        String countryCode; 
        
        Account a1 = new Account(name='TestCo: ', country__c='United States'); 
        insert a1;
        
           
        
        req.Requestor_Name__c = UserInfo.getUserId();
        req.Requestor_Email__c = 'sai_lakkimsetty@infosys.com';
        req.SF_Region__c ='Asia Pacific';
        req.Company_Code__c = '9999-Dummy China Value';
        req.Group_Key__c ='6000000';
        req.Distribution_Channel__c = '10-Dupont Std';
        req.Account_Group__c='Z001(Sold-to Party)';
        req.Division__c = '01-Product Division 01';
        req.Customer_Name__c='Test Customer';
        req.Sold_to_Street__c='Walters Street';
        req.Sold_to_City__c='New Jersey';
        req.Sold_to_Country__c='US-USA';
        req.Sold_to_e_mail__c='sam@gmail.com';
        // req1.Customer__c=ERPCust.name;
        //req.Customer_Contact_Name__c='Test1';
        //req.Customer_Contact_Telephone__c='123232323';
        req.Proposed_Terms_of_Payment__c='15 PROX';
        req.Proposed_Credit_Limit__c='100';
        req.Proposed_Credit_Limit_Currency_Code__c='USD-American Dollar';
        req.Default_Incoterms_2__c='Test Term';
        req.Estimated_Average_Monthly_Purchases__c=100;
        req.Estimated_Number_of_Orders_per_Month__c=20;
        req.Registration_number__c='458889';
        req.Sold_To_Office_House_Number__c = '124';
        req.Sold_to_State_Province__c ='Michigun';
        req.Record_Locked__c=false;
        req.Relevant_for_POD__c=false;
        req.Sold_To_Customer_Number__c='Test2';
        req.Source_Cluster__c='Test1';
        req.Sales_Organization__c='B9F6';
        req.Request_Status__c= 'Request Completed in SAP';
        req.Account__c=a1.id;
        custDataToUpdate.add(req);
        insert custDataToUpdate;
         
         ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.Account_Group_Code__c='Z001';
        ERPCust.Customer_Code__c='Test2';
        ERPCust.Source_Cluster__c='Test1';
        ERPCust.Sales_Org_Code__c='B9F6';
        ERPCust.Distribution_Channel__c='Test Customer 1';
        ERPCust.Division__c='01-Product Division 01';
        ERPCust.Distribution_Channel_Code__c='10';
        ERPCust.Division_Code__c='01';
        lst_ERPCust1.add(ERPCust);
         insert lst_ERPCust1;
    
           ctrlLinkERPCustToAccount cup = new ctrlLinkERPCustToAccount();
      
      
        
      }

}
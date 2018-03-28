@isTest
public class CtrlCustOnboardingRqstTimTrack_UT {

 static testMethod void ctrlCustomerOnboardingRequestMethod() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Service']; 
        User u1 = new User(Alias = 'st2', Email='standarduser13@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing1212', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standard2user13434@testorg.com');
        //User u1= [SELECT Id,Alias,Email,LastName,UserName FROM User WHERE Alias='DheerajP'];
        insert u1;
        System.runas(u1){

            boolean run=true;
            Id RecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;


            Customer_Data_Request__c cdr2 = new Customer_Data_Request__c();
            //cdr2.Requestor_Name__c = UserInfo.getUserId();
            cdr2.Requestor_Name__c =u1.id;
            cdr2.Requestor_Email__c = 'nishanth_h@infosys.com';
            cdr2.SF_Region__c ='Asia Pacific';
            cdr2.Company_Code__c = '0003 - E.I. DuPont India Private Limited';
            cdr2.Distribution_Channel__c = '10-Dupont Std';
            cdr2.Account_Group__c='Z001(Sold-to Party)';
            cdr2.Division__c = '01-Product Division 01';
            cdr2.Customer_Name__c='Test Customer2';
            cdr2.Sold_to_Street__c='Walters Street';
            cdr2.Sold_to_City__c='New Jersey';
            cdr2.Sold_to_Country__c ='IN - India';
            cdr2.Sold_to_e_mail__c='sam1@gmail.com';
            cdr2.Default_Incoterms_2__c='Test Term';
            cdr2.Estimated_Average_Monthly_Purchases__c=100;
            cdr2.Estimated_Number_of_Orders_per_Month__c=20;
            cdr2.Registration_number__c='458889';
            cdr2.Sold_To_Office_House_Number__c = '124';
            cdr2.Sold_to_State_Province__c ='Michigun';
            cdr2.Proposed_Cash_Management_Group__c = 'FC - Receivables in foreign currency';
            cdr2.Proposed_Cred_rep_grp__c = '00P-Sabine Combrink';
            cdr2.Proposed_credit_information_number__c = 100;
            cdr2.Proposed_Credit_Limit__c='100';
            cdr2.Proposed_Credit_Limit_Currency_Code__c='USD-American Dollar';
            cdr2.Proposed_Customer_credit_group__c = 'A100 : COMPOSITES';
            cdr2.Proposed_Non_Standard_Terms_of_Payment__c = '15 PROX';   
            cdr2.Proposed_Payment_Index__c = 1234;
            cdr2.Proposed_Rating__c = 'Star';
            cdr2.Proposed_Reference_date__c = date.newInstance(2014, 11, 21);
            cdr2.Proposed_Risk_Category__c = '102 - Automatic Approval';
            cdr2.Proposed_Terms_of_Payment__c = '15 PROX';
            cdr2.Request_Status__c = 'Awaiting Credit Approval';
            cdr2.Approved_Credit_Limit__c = '582';
            cdr2.Destination_Credit_limit__c = '589';
            cdr2.Proposed_Credit_Limit__c = '586';
            cdr2.Preferred_Bank_Name__c = 'Other';
            cdr2.Alternative_Preferred_Bank_Name__c = 'Test';
            cdr2.Record_Locked__c=false;
            cdr2.Relevant_for_POD__c=false; 
            cdr2.Approved_Terms_of_Payment__c='Cash In Advance';
            cdr2.Destination_Terms_of_Payment__c='Cash In Advance';
            cdr2.Proposed_Customer_Group__c='Z00';
            cdr2.Approved_Customer_Group__c='Z00';  
            cdr2.Approved_Risk_Category__c='null';
            cdr2.SBU__c = 'Asds';
            cdr2.Escalated_Approval_Time__c=1;
            cdr2.Destination_risk_category__c='NA';
            cdr2.Approved_Credit_Term_Type__c='Cash';
            //cdr2.Last_Modified_Time__c = DateTime.newInstance(2014, 11,11);
            //Rohit saini 28th march 2016
            cdr2.Last_Modified_Time__c = DateTime.newInstance(2015, 11,11);
            
            cdr2.recordtypeid = recid;
            
          
            //insert cdr2;

            //End new set of data
            List<Customer_Data_Request__c> customerList = new List<Customer_Data_Request__c>();
            customerList.add(cdr2);
            insert customerList; 

            CtrlCustomerOnboardingRequestTimeTracker instTrackRequestStatusChangeInstance = new CtrlCustomerOnboardingRequestTimeTracker();   
            instTrackRequestStatusChangeInstance.calculateTime(system.today(),system.today()+1);
            instTrackRequestStatusChangeInstance.calculateTime(system.today(),null);
            instTrackRequestStatusChangeInstance.getRequestInformation(customerList);
            ID ReqId=cdr2.id;
            ID selectedRecordTypeId=cdr2.id;

            cdr2.Last_Modified_Time__c = DateTime.newInstance(2015, 11,12);                 
            cdr2.Request_Status__c = 'Awaiting Data Analyst (DMS Team) Approval';
            
            CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Request_Status__c = 'Awaiting Data Analyst (DMS Team) Approval';
            update cdr2;
         
            CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Request_Status__c = 'Awaiting Destination Credit Approval';
            update cdr2; 
            
            CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Last_Modified_Time__c = DateTime.newInstance(2017, 11,11);                 
            cdr2.Request_Status__c = 'Awaiting Credit Approval';
            update cdr2; 
            
           /* CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Request_Status__c = ' Request Sent for Re-Work';
            update cdr2; */
            
           /* CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Request_Status__c = ' Awaiting DOA approval';
            update cdr2; */
            
          /*  CtrlCustomerOnboardingRequestTimeTracker.run=true;
            cdr2.Request_Status__c = 'Awaiting DOA approval'; */
          
            customerList = new List<Customer_Data_Request__c>();
            customerList .add(cdr2);
            update customerList;
           /* cdr2.Request_Status__c = 'Awaiting Credit Approval';
            customerList = new List<Customer_Data_Request__c>();
            customerList .add(cdr2); */
          //  update customerList;
            run=false;
          

          

        }

      }
    }
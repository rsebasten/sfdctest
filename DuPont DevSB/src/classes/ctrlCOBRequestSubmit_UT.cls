@isTest
public class ctrlCOBRequestSubmit_UT {
    public static final string Miscellaneous_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request'); 
        public static final string Partner_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
        public static final string NewCustomerCreation_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation'); 
        public static final string ExtendExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Extend_Existing_Customer'); 
        public static final string ModifyExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');     
       public static string CompanyCodeCountry_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Country_Selling_Company_Code_Rules');
       public static string Queue_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Queue_Rules');
       static testMethod void unitTestCaseMethod1() {
       
       test.StartTest();
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);*/
        
        insert GMlist;

        System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'INR';
        ERPCustGen1.Country_Code__c='IN';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'INR';
        ERPCust1.Country_Code__c='IN';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '4860 - DUP (Thailand) Ltd';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
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
           // customerData.Assigned_to_Leverage_CSR__c = false;
          //  Assigned_to_Leverage_CSR__c 
            customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='500';
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();

Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='4860 - DUP (Thailand) Ltd';
br1.CDR_Sold_to_Country__c= 'TH - Thailand';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
insert brlist;    
            
            List<Business_Rules__c> brlist1 = new List<Business_Rules__c>();
Business_Rules__c BQ1 = new Business_Rules__c();
BQ1.recordtypeid = Queue_Rule_Rtype ;
BQ1.selling_company_code__c ='4860 - DUP (Thailand) Ltd';
BQ1.Destination_Queue__c= 'Customer On-boarding CSR - Thailand Queu';
brlist1.add(BQ1);

 
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);
        //     string testresult1 = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(null,selectedRecordTypeId,initVarInstance);
            ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);
            ctrlCOBCustomerOnboardingRequestSubmit.CopyProposedToApprovedCredit(customerData);
            customerData.IsCreditApproved__c=true;
            customerData.Proposed_Credit_Term_Type__c ='Open Credit';
            update customerData;
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId,initVarInstance);
            customerData.IsCreditApproved__c=false;
            customerData.Proposed_Credit_Term_Type__c='Letter Of Credit';
            customerData.Preferred_Bank_Name__c = 'Bank of India';
            update customerData;
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId,initVarInstance);
              
            test.StopTest(); 
           
             customerData.RecordTypeId = newCustomerRecId1 ;
             customerData.Miscellaneous_Type_Intent__c='Mass load - finance data';
             update customerData;
            
            String selectedRecordTypeId1 = String.valueOf(newCustomerRecId1);
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance);
            
            customerData.Request_Status__c ='Request Completed in SAP';
           
            update customerData;
           String selectedRecordTypeId2 = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance);
             }
       }
       
      static testMethod void unitTestCaseMethod2() {   
       
         test.StartTest();
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       // Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;

        System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'INR';
        ERPCustGen1.Country_Code__c='IN';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'INR';
        ERPCust1.Country_Code__c='IN';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
            Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
           //  Id newCustomerRecId3 = [Select Id, Name from RecordType where DeveloperName = 'Partner_COB_RTYPE' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0029 - DU PONT CHINA LIMITED';
            customerData.sold_to_country__c='HK - Hong Kong';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
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
           // customerData.Assigned_to_Leverage_CSR__c = false;
          //  Assigned_to_Leverage_CSR__c 
            customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='500';
          
              customerData.Credit_Approval_Required__c = false;
             
         customerData.Proposed_Terms_of_Payment__c='L001-Letter of Credit at Sight';
            
             customerData.Proposed_Credit_Limit__c='500';
             customerData.Proposed_Credit_Limit_Currency_Code__c='INR - Indian Rupee';
            customerData.Estimated_Number_of_Orders_per_Month__c=10;
            customerData.Estimated_Average_Monthly_Purchases__c=5;
            insert customerData;  
            
            
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;  
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();

Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br1.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br1);
            insert brlist;  
           String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId1 = String.valueOf(newCustomerRecId1);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
           string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId1,initVarInstance); 
           ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);  
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance); 
           customerData.Leveraged_CSR__c = true;
           customerData.Assigned_to_Leverage_CSR__c = false;
           update customerData;
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance); 
           test.StopTest(); 
           customerData.Credit_Approval_Required__c = true;
           customerData.Leveraged_CSR__c = false;
           customerData.Assigned_to_Leverage_CSR__c = true;
           customerData.Account_Group__c = 'Z002 (Ship-to party)';
            system.debug('----ownerid before--->'+customerData);
           update customerData;
            system.debug('----ownerid after--->'+customerData);
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance);
           
          /*customerData.RecordTypeId = newCustomerRecId2;
           update customerData;
           String selectedRecordTypeId2 = String.valueOf(newCustomerRecId2);
           String requestId2 = String.valueOf(customerData.Id);
           string result2 = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId2,selectedRecordTypeId2,initVarInstance);
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance); */
           
           
       }
      } 
      
         static testMethod void unitTestCaseMethod3() {
       
       
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
     /*   GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;

        System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'INR';
        ERPCustGen1.Country_Code__c='IN';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'INR';
        ERPCust1.Country_Code__c='IN';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
             Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
             //Id newCustomerRecId3 = [Select Id, Name from RecordType where DeveloperName = 'Partner_COB_RTYPE' limit 1].Id;
            customerData.RecordTypeId= newCustomerRecId;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0003 - E.I. DuPont India Private Limited';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
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
           // customerData.Assigned_to_Leverage_CSR__c = false;
          //  Assigned_to_Leverage_CSR__c 
            customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='500';
            customerData.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
           // br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;
            
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();

Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='0003 - E.I. DuPont India Private Limited';
br1.CDR_Sold_to_Country__c= 'IN - India';
brlist.add(br1);
            insert brlist;
             String requestId = String.valueOf(customerData.Id);
             String selectedRecordTypeId1 = String.valueOf(newCustomerRecId1);
             ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
             customerData.RecordTypeId = newCustomerRecId1; 
             update customerData;
             
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance); 
           
          customerData.Request_Status__c ='Request Completed in SAP';
          update customerData;
          ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance);
           
           String requestId2 = String.valueOf(customerData.Id);
            String selectedRecordTypeId2 = String.valueOf(newCustomerRecId2);
        
            //ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
             customerData.RecordTypeId = newCustomerRecId2; 
             update customerData;
             
            
             
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance);
           customerData.Credit_Approval_Required__c=true; 
           update customerData;
           test.StartTest(); 
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance);
           
           customerData.IsCreditApproved__c=true;
           customerData.Proposed_Credit_Term_Type__c='DA (Delivery On Acceptance) or DP (Delivery on Payment)';
           update customerData; 
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance);
           
           /*customerData.Credit_Approval_Required__c=false; 
           customerData.Request_Status__c ='Draft/Data Gathering';
            customerData.Proposed_Credit_Term_Type__c='Cash In Advance';
           update customerData; 
           ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance); */
          
          customerData.Request_Status__c ='Request Completed in SAP';
          update customerData;
          
          ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId2,initVarInstance);
            test.StopTest();
         }
        }  
      static testMethod void unitTestCaseMethod4() {
           test.StartTest();
       Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1; 
       System.runAs(U1){ 
             ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'INR';
        ERPCustGen1.Country_Code__c='IN';
        ERPCustGen1.DUNS_Number__c='2323232';
         ERPCustGen1.Account_Group__c='Z001(Sold-to Party)';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'INR';
        ERPCust1.Country_Code__c='IN';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
          Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       // Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;
       
       
              Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
             Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
             //Id newCustomerRecId3 = [Select Id, Name from RecordType where DeveloperName = 'Partner_COB_RTYPE' limit 1].Id;
            customerData.RecordTypeId= newCustomerRecId2 ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0218 - DuPont Trading Shanghai';
            customerData.Sold_to_country__c='CN - China';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 ( Sold-to party)';
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
            customerData.Customer__c=ERPCustGen1.Id;
            customerData.Proposed_Credit_Term_Type__c='Open Credit';
           // customerData.Assigned_to_Leverage_CSR__c = false;
          //  Assigned_to_Leverage_CSR__c 
            
            //customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='5000000';
            customerData.Request_Status__c ='Draft/Data Gathering';
            customerData.IsCreditapproved__c=true;
            customerData.Credit_Approval_Required__c=true;
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
insert br;
           List<Business_Rules__c> brlist = new List<Business_Rules__c>();

Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='0218 - DuPont Trading Shanghai';
br1.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br1);  
           insert brlist;  
             ERP_Relationship__c rel= new ERP_Relationship__c();
        rel.ERP_Customer__c=ERPCustGen1.Id ;
        rel.Related_ERP_Customer__c=ERPCustGen1.Id;
        insert rel;
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId2);
           ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);
            ctrlCOBCustomerOnboardingRequestSubmit.CopyProposedToApprovedCredit(customerData);
      ctrlCOBCustomerOnboardingRequestSubmit con=new ctrlCOBCustomerOnboardingRequestSubmit();
           ctrlCOBCustomerOnboardingRequestSubmit.RelatedlistItemsValidation(customerData);
           ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
           string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);
           ctrlCOBCustomerOnboardingRequestSubmit.getRequestInformation(customerData.id);
           string p2=ctrlCOBCustomerOnboardingRequestSubmit.currentUserProfile();
           ctrlCOBCustomerOnboardingRequestSubmit.accessCheck(customerData.id,p2);
     
           test.StopTest();
      }
    }
    
    static testMethod void unitTestCaseMethod5() {
         test.StartTest();
     //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1; 
    Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       // Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;
     System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'INR';
        ERPCustGen1.Country_Code__c='IN';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'INR';
        ERPCust1.Country_Code__c='IN';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
             Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
            // Id newCustomerRecId3 = [Select Id, Name from RecordType where DeveloperName = 'Partner_COB_RTYPE' limit 1].Id;
            customerData.RecordTypeId= Partner_COB_RTYPE ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '2380 - Dup Austl Pty Ltd';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
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
           // customerData.Assigned_to_Leverage_CSR__c = false;
          //  Assigned_to_Leverage_CSR__c 
            customerData.Proposed_Credit_Term_Type__c ='Cash In Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='500';
            customerData.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
           // br.CDR_Credit_Limit_Upper__c = 50000;
           // br.CDR_Credit_Limit_Lower__c = 0;
            insert br;
         
         List<Business_Rules__c> brlist = new List<Business_Rules__c>();

Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='2380 - Dup Austl Pty Ltd';
br1.CDR_Sold_to_Country__c= 'AU - Australia';
brlist.add(br1); 
         insert brlist;  
             String requestId = String.valueOf(customerData.Id);
             String selectedRecordTypeId1 = String.valueOf(newCustomerRecId1);
             ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
             customerData.RecordTypeId = NewCustomerCreation_COB_RTYPE ; 
             customerData.Request_Status__c='Request Completed in SAP';
             update customerData;
             
              Customer_Data_Request_Line_Item__c cli=new Customer_Data_Request_Line_Item__c();
 cli.Customer_Name__c='TestA';
 cli.Customer_Name_2__c='TestB';
 cli.Customer_Data_Request__c=customerData.id;
 cli.Local_Version__c='Arabic';
 cli.Country__c='AD - Andorran';
 cli.Local_Language_Country__c='AF - Afghanistan';
 //cli.RecordtypeId=Partner_COB_RTYPE ;
 insert cli;
      ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);
            ctrlCOBCustomerOnboardingRequestSubmit.CopyProposedToApprovedCredit(customerData);
    ctrlCOBCustomerOnboardingRequestSubmit con=new ctrlCOBCustomerOnboardingRequestSubmit(); 
   ctrlCOBCustomerOnboardingRequestSubmit.RelatedlistItemsValidation(customerData);
     ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance); 
         
         string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit( customerData.Id ,selectedRecordTypeId1,initVarInstance);
        // String selectedRecordTypeId3 = String.valueOf(newCustomerRecId3);
         // ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId3,initVarInstance); 
           ctrlCOBCustomerOnboardingRequestSubmit.getRequestInformation(customerData.id);
           string p2=ctrlCOBCustomerOnboardingRequestSubmit.currentUserProfile();
           ctrlCOBCustomerOnboardingRequestSubmit.accessCheck(customerData.id,p2);
          test.StopTest();
    }
    
    }
    
    static testMethod void unitTestCaseMethod6() {
       
       test.StartTest();
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_ANZ'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
        GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);
        
        insert GMlist;

        System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'AUD';
        ERPCustGen1.Country_Code__c='AU';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'AUD';
        ERPCust1.Country_Code__c='AU';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
            Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId2 ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0443 - DuPont (New Zealand) Ltd.';
            customerData.Sold_to_Country__c= 'CN - China';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z001 ( Sold-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'NZ-New zealand';
            customerData.Existing_Country__c = 'NZ-New zealand';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'D643';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Leveraged_CSR__c = false;
           // customerData.Assigned_to_Leverage_CSR__c = false;
            customerData.Credit_Approval_Required__c=true;
            customerData.Proposed_Credit_Term_Type__c ='Open Credit';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='50000';
            //customerData.Request_Status__c ='Draft/Data Gathering';
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();

      Business_Rules__c br1 = new Business_Rules__c();
      br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
      br1.selling_company_code__c ='0443 - DuPont (New Zealand) Ltd.';
      br1.CDR_Sold_to_Country__c= 'NZ - New zealand';
      brlist.add(br1);
              insert brlist;       
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId2);
            String selectedRecordTypeId1 = String.valueOf(newCustomerRecId1);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);
        //     string testresult1 = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(null,selectedRecordTypeId,initVarInstance);
            ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);
            ctrlCOBCustomerOnboardingRequestSubmit.CopyProposedToApprovedCredit(customerData);
            customerData.IsCreditApproved__c=true;
            customerData.Proposed_Credit_Term_Type__c ='Open Credit';
            customerData.Existing_Country__c = 'US - USA';
            update customerData;
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId,initVarInstance);
            customerData.IsCreditApproved__c=false;
            customerData.Proposed_Credit_Term_Type__c='Cash in Advance';
            update customerData;
           // ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId,initVarInstance);
              
            test.StopTest(); 
           
             
             }
       }
    static testMethod void unitTestCaseMethod7() {
       
       test.StartTest();
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='Dupont_CDR_Users_ASEAN'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
        GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);
        
        insert GMlist;

        System.runAs(U1){   
            ERP_Customer__c ERPCustGen1 = new ERP_Customer__c ();
        ERPCustGen1.Name = 'TestCustomer134';
        ERPCustGen1.Currency_Code__c= 'AUD';
        ERPCustGen1.Country_Code__c='AU';
        ERPCustGen1.DUNS_Number__c='2323232';
        insert ERPCustGen1;
       
        ERP_Customer__c ERPCust1 = new ERP_Customer__c ();
        ERPCust1.Name = 'TestCustomer';
        ERPCust1.Currency_Code__c= 'AUD';
        ERPCust1.Country_Code__c='AU';
        ERPCust1.DUNS_Number__c='2323232';
        ERPCust1.Account_Group__c='Z001(Sold-to Party)';
        ERPCust1.Customer_General_Data__c = ERPCustGen1.Id;
        insert ERPCust1;
        
        RecordType recAccID1 = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID1,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust1.id);
        insert acc;
        
            Customer_Data_Request__c customerData = new Customer_Data_Request__c();
          
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            Id newCustomerRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Miscellaneous_customer_data_request' limit 1].Id;
            Id newCustomerRecId2 = [Select Id, Name from RecordType where DeveloperName = 'Modify_Existing_Customer_Data' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0514 - DuPont Vietnam Ltd.';
            customerData.Sold_to_Country__c= 'VN - Vietnam';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z001 ( Sold-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'VN - Vietnam';
            customerData.Existing_Country__c = 'VN - Vietnam';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'D643';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Leveraged_CSR__c = false;
           // customerData.Assigned_to_Leverage_CSR__c = false;
            customerData.Credit_Approval_Required__c=true;
            customerData.Proposed_Credit_Term_Type__c ='Cash in Advance';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Proposed_Credit_Limit_Est__c='50000';
            customerData.Request_Status__c ='Draft/Data Gathering';
            insert customerData;  
           Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Cash in Advance';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();

      Business_Rules__c br1 = new Business_Rules__c();
      br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
      br1.selling_company_code__c ='0514 - DuPont Vietnam Ltd.';
      br1.CDR_Sold_to_Country__c= 'VN - Vietnam';
      brlist.add(br1);
              insert brlist;       
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId2);
            String selectedRecordTypeId1 = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);
        //     string testresult1 = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(null,selectedRecordTypeId,initVarInstance);
            ctrlCOBCustomerOnboardingRequestSubmit.fetchCountryCode(customerData);
            ctrlCOBCustomerOnboardingRequestSubmit.CopyProposedToApprovedCredit(customerData);
            customerData.IsCreditApproved__c=true;
            customerData.Proposed_Credit_Term_Type__c ='Open Credit';
            customerData.Existing_Country__c = 'US - USA';
            customerData.credit_approval_required__c=false;
            customerData.Request_Status__c='Draft/Data Gathering';
            update customerData;
            ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId1,initVarInstance);
            customerData.IsCreditApproved__c=false;
            customerData.Proposed_Credit_Term_Type__c='Cash in Advance';
                       
            update customerData;
           // ctrlCOBCustomerOnboardingRequestSubmit.requestFlow(customerData,selectedRecordTypeId,initVarInstance);
              
            test.StopTest(); 
           
             
             }
       }
    }
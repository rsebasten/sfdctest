@isTest
public class ctrlCOBCustomerSearch_UT
{    
    public static final string CST_Account_Rtype= Rtype.getIdByDevName('Account','CS_ERPCustomer');
    public static final string CST_Case_Number_CS_InternalRequest_Rtype = Rtype.getIdByDevName('Case','CS_InternalRequest');
    public static testMethod void CustomerSearch1()
    {
        test.startTest();
        
        Id CustCrRecordTypeId = Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('New Customer Creation').getRecordTypeId();
        Id ERPExtendedRecordTypeId = Schema.SObjectType.ERP_Customer__c.getRecordTypeInfosByName().get('ERP Customer - Extended Data').getRecordTypeId();      
        Id ERPCustomerGeneral= Schema.SObjectType.ERP_Customer__c.getRecordTypeInfosByName().get('ERP Customer - General Data').getRecordTypeId();
        //GroupMember gr = [SELECT GroupId,UserOrGroupId from GroupMember where UserOrGroupId =: UserInfo.getUserId()];
            
            
        ERP_Customer__c ERPCust = new ERP_Customer__c();
        ERPCust.Account_Group__c='Z001 ( Sold-to party )';
        ERPCust.City__c='Bangalore';
        ERPCust.State__c ='Karnataka';
        ERPCust.Street__c = 'JP Nagar';
        ERPCust.VAT_Number__c='00123';
        ERPCust.Tax_Code__c='V007';
        ERPCust.ZIP_Postal_Code__c='560068';
        ERPCust.Customer_Code__c='C6457';
        ERPCust.RecordTypeId=ERPExtendedRecordTypeId;
        ERPCust.Name ='Test';
        insert ERPCust;
        
         ERP_Customer__c ERPCust1 = new ERP_Customer__c();
        ERPCust1.Account_Group__c='Z001 ( Sold-to party )';
        ERPCust1.City__c='Bangalore';
        ERPCust1.State__c ='Karnataka';
        ERPCust1.Street__c = 'JP Nagar';
        ERPCust1.VAT_Number__c='00123';
        ERPCust1.Tax_Code__c='V007';
        ERPCust1.ZIP_Postal_Code__c='560068';
        ERPCust1.Customer_Code__c='C6457';
        ERPCust1.RecordTypeId=ERPExtendedRecordTypeId;
        ERPCust1.Name ='Test';
        insert ERPCust1;
        
        ERP_Customer__c ERPCustGeneral = new ERP_Customer__c();
        ERPCustGeneral.Account_Group__c='Z001 ( Sold-to party )';
        ERPCustGeneral.City__c='Bangalore';
        ERPCustGeneral.State__c ='Karnataka';
        ERPCustGeneral.Street__c = 'JP Nagar';
        ERPCustGeneral.VAT_Number__c='00123';
        ERPCustGeneral.Tax_Code__c='V007';
        ERPCustGeneral.ZIP_Postal_Code__c='560068';
        ERPCustGeneral.Customer_Code__c='C6457';
        ERPCustGeneral.RecordTypeId=ERPCustomerGeneral;
        ERPCustGeneral.Name ='Test';
        insert ERPCustGeneral;
              
        ERP_Customer_Localization__c ErpLocal = new ERP_Customer_Localization__c();
        ErpLocal.Language__c='EN';
        ErpLocal.ERP_Customer__c=ERPCust.Id;
        insert ErpLocal;
        
        ERP_Relationship__c vERPRelation = new ERP_Relationship__c();
        vERPRelation.ERP_Customer__c=ERPCust.Id;
        vERPRelation.Related_ERP_Customer__c=ERPCust.Id;
        vERPRelation.Name__c='TestRel';
        insert vERPRelation;
        
        Account vAccount = new Account();
        vAccount.Name='TestAccount';
        vAccount.OwnerId = userInfo.getUserId();
        vAccount.ERP_Customer__c=ERPCust.Id;
        vAccount.ERP_Company_Code__c='E456';
        vAccount.VAT_Number__c='V768';
        vAccount.Country__c='India';
//[05112017] Merge&Spin: Added record type attribute to account record
        vAccount.RecordTypeId = RType.getIdByDevName('Account','ERP_Account');
        insert vAccount;
        
        Account AccountGeneral= new Account();
        AccountGeneral.Name='TestAccountGeneral';
        AccountGeneral.OwnerId = userInfo.getUserId();
        AccountGeneral.VAT_Number__c='V768';
        AccountGeneral.Country__c='India';
 //[05112017] Merge&Spin: Added record type attribute to account record
        AccountGeneral.RecordTypeId = RType.getIdByDevName('Account','ERP_Customer_General');
        insert AccountGeneral;

/*PKH        
        SVMXListSettings__c sv = new SVMXListSettings__c(Name='WarrantyLA',Static_Value__c = 'WarrantyLA');
        insert sv;
        SVMXListSettings__c sv1 = new SVMXListSettings__c(Name='ContractLA',Static_Value__c = 'WarrantyLA');
        insert sv1;
        SVMXListSettings__c sv2 = new SVMXListSettings__c(Name='BillableEMEA',Static_Value__c = 'WarrantyLA');
        insert sv2;
        SVMXListSettings__c sv3 = new SVMXListSettings__c(Name='WarrantyEMEA',Static_Value__c = 'WarrantyLA');
        insert sv3;
        SVMXListSettings__c sv4 = new SVMXListSettings__c(Name='Hardware ServiceEMEA',Static_Value__c = 'WarrantyLA');
        insert sv4;
        SVMXListSettings__c sv5 = new SVMXListSettings__c(Name='Hardware SalesEMEA',Static_Value__c = 'WarrantyLA');
        insert sv5;
        SVMXListSettings__c sv6 = new SVMXListSettings__c(Name='ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv6;
        SVMXListSettings__c sv7 = new SVMXListSettings__c(Name='Uptime ContractTypeEMEA',Static_Value__c = 'WarrantyLA');
        insert sv7;
        SVMXListSettings__c sv8 = new SVMXListSettings__c(Name='Uptime ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv8;

PKH*/        

        Case cas = new Case(subject='Unit Test', Status='New',recordtypeId = CST_Case_Number_CS_InternalRequest_Rtype );
        insert cas;
        
        PageReference pageRef = Page.COBCustomerSearch;
        Test.setCurrentPage(pageRef);   
        ApexPages.currentPage().getParameters().put('qp', 'yyyy');    
        ctrlCOBCustomerSearch vCOBCust = new ctrlCOBCustomerSearch();
        
        List<ctrlCOBCustomerSearch.CustomerWrapperClass> CustomerWrapperList1 = new List<ctrlCOBCustomerSearch.CustomerWrapperClass>();
        ctrlCOBCustomerSearch.CustomerWrapperClass vWrpper1 = new ctrlCOBCustomerSearch.CustomerWrapperClass(ERPCust.Id,'Test','abc','67','100','Test1','C100','SOrg45',true,'Bangalore','Karnataka','India','560068','Bommanahalli','ERPClust','2345','Channel1','Div1',true,'Active','xyz'); 
        CustomerWrapperList1.add(vWrpper1);
        
        List<ctrlCOBCustomerSearch.CustomerWrapperClass> CustomerWrapperList2 = new List<ctrlCOBCustomerSearch.CustomerWrapperClass>();
        ctrlCOBCustomerSearch.CustomerWrapperClass vWrpper2 = new ctrlCOBCustomerSearch.CustomerWrapperClass(ERPCust.Id,'Test1','abc','69','100','Test1','C100','SOrg45',true,'Bangalore','Karnataka','India','560078','JP Nagar','ERPClust','2345','Channel1','Div5',true,'Active','xyz'); 
        CustomerWrapperList2.add(vWrpper2);
        
        List<ctrlCOBCustomerSearch.AccountWrapperClass> AccountWrapperList = new List<ctrlCOBCustomerSearch.AccountWrapperClass>();  
        ctrlCOBCustomerSearch.AccountWrapperClass vWrapper1 = new ctrlCOBCustomerSearch.AccountWrapperClass(vAccount.Id,'Test','V-002','TestRegion','India','Test-003','TsetType',true,'TestName','SFDC',CustCrRecordTypeId,vAccount.OwnerId,'TestSBU','093475867234');
        AccountWrapperList.add(vWrapper1);
        
        ctrlCOBCustomerSearch.AccountWrapperClass vWrapper2 = new ctrlCOBCustomerSearch.AccountWrapperClass(vAccount.Id,'Test','V-002','TestRegion','India','Test-003','TsetType',true,'TestName','SFDC',CST_Account_Rtype,vAccount.OwnerId,'TestSBU','093475867234');
        vCOBCust.CustomerRelatedAccountWrapperList = new List<ctrlCOBCustomerSearch.AccountWrapperClass>();
        vCOBCust.CustomerRelatedAccountWrapperList.add(vWrapper2);
        
        
      //  vCOBCust.currentSelectionCustomerId2='a1B19000000HVv0';
        vCOBCust.currentSelectionCustomerName2='Test';
        vCOBCust.accountSearchCustomer='TestSearch';
        vCOBCust.ExistingERPCustomer='TestExistERP';
        vCOBCust.caseNumberinfo='TestCase';
        vCOBCust.getLanguages();
        vCOBCust.TypeOfTable='Customer';              
        vCOBCust.getSearch(); 
        
        vCOBCust.identifyCST='CST Customer';      
        vCOBCust.TypeofSearchProceed();
        
        vCOBCust.search = 'Duplicate Search';
        vCOBCust.selectSelected=true;
        vCOBCust.identifyCST ='CST Customer';
        vCOBCust.TypeofSearchProceed();
        vCOBCust.cdr.Case_Number__c = cas.Id;
        vCOBCust.TypeofSearchProceed();
        //vCOBCust.findMatchCustomers();
        
       // vCOBCust.setSearch('Duplicate Search');
       // vCOBCust.findMatchCustomers();
        
        vCOBCust.localLanguage='EN';
        vCOBCust.CustName='Test';
        vCOBCust.findMatchCustomers();
        
        vCOBCust.identifyCST='CST Customer';
        vCOBCust.currentSelectionAccountId=null;
        vCOBCust.openDownloadPopUpFlag();
        vCOBCust.search='Extend a Customer';
        vCOBCust.redirectLink();
        
        vCOBCust.currentSelectionCustomerId= ERPCust.Id;
        vCOBCust.currentSelectionCustomerName= ERPCust.Name;
        
        vCOBCust.currentSelectionCustomerId2= ERPCust.Id;
        vCOBCust.currentSelectionCustomerName2= ERPCust.Name;
        
        vCOBCust.currentSelectionCustomerId3= ERPCust.Id;
        vCOBCust.currentSelectionCustomerName3= ERPCust.Name;
        vCOBCust.currentSelectionAccountId = vAccount.Id;
        vCOBCust.openDownloadPopUpFlag(); 
        vCOBCust.IsListRender3 = true;
        vCOBCust.redirectLink();
        vCOBCust.search='Modify Search';
        vCOBCust.redirectLink();
        vCOBCust.search='Duplicate Search';
        vCOBCust.redirectLink();
        vCOBCust.identifyCST='Non CST Customer';
        vCOBCust.redirectLink();
        
        vCOBCust.getDisableCustExtendPrevious();
        vCOBCust.getDisableCustExtendNext();
        vCOBCust.getCustomer_total_size3();
        vCOBCust.getPageNumberExtend();
        vCOBCust.Customer_total_size3=1;
        
        vCOBCust.getTotalPagesExtend();
         vCOBCust.CustName='Testing';
        vCOBCust.search='Modify Search';
        vCOBCust.currentSelectionCustomerAccountGroup='test';
        vCOBCust.ClearCustomerList();
        
        vCOBCust.search='Extend a Customer';
        vCOBCust.identifyCST='Non CST Customer';
        vCOBCust.ClearCustomerList();
        vCOBCust.identifyCST='CST Customer';
        vCOBCust.ClearCustomerList();
        
        vCOBCust.CustName1='Test';
        vCOBCust.VAT1 = 'V768';
        vCOBCust.Country1= 'India';
        vCOBCust.GenericAccountSearch();
        VCOBCust.findMatchCustomers();
        
        vCOBCust.CustName1='gfhjhgjh';
        vCOBCust.VAT1 = 'eyu';
        vCOBCust.Country1= 'Inhgjhdia';
        vCOBCust.AccountGrp1= 'sold';
        vCOBCust.identifyCST='CST Customer';
        vCOBCust.GenericAccountSearch();
        
        vCOBCust.search='Modify Search';
        vCOBCust.isGenericAccountSearchExecute=true;
        VCOBCust.extendsearch();
        VCOBCust.findMatchCustomers();
        vCOBCust.CustomerWrapperList1.add(vWrpper1);
        vCOBCust.AccountSearch();
        
        vCOBCust.identifyCST='Non CST Customer';
        vCOBCust.AccountSearch();
        vCOBCust.IsListRender = true;
        vCOBCust.IsListRender2= true;
        vCOBCust.CustomerWrapperList2.add(vWrpper2);
        vCOBCust.AccountSearch();
        vCOBCust.ClearCustomerList2();
        
        vCOBCust.search='Extend a Customer';
        ctrlCOBCustomerSearch.CustomerWrapperClass vWrpper3 = new ctrlCOBCustomerSearch.CustomerWrapperClass(ERPCust.Id,'Test1','abc','69','100','Test1','C100','SOrg45',true,'Bangalore','Karnataka','India','560078','JP Nagar','ERPClust','2345','Channel1','Div5',true,'Active','xyz');
        vCOBCust.CustomerWrapperList2.add(vWrpper3);
        vCOBCust.IsListRender2= false;
        vCOBCust.IsListRender3= true;
        
        vCOBCust.AccountSearch();
        vCOBCust.ClearAccountList();
        vCOBCust.ClearCustomerList2();
        vCOBCust.isGenericAccountSearchExecute=false;
        vCOBCust.IsCustomerRelatedAccountListRender=true; 
        VCOBCust.extendsearch();
        
        vCOBCust.search='Duplicate Search';
        vCOBCust.CustName2='Test';
        vCOBCust.VAT2='V768';
        vCOBCust.Country2= 'India';
        vCOBCust.localLanguage='';
        vCOBCust.isCustomerExtendedSearchExecute= true;
        vCOBCust.populateCustomer();
        vCOBCust.GenericAccountSearch();
        vCOBCust.TypeOfTable='Customer';
        vCOBCust.Next();  
        
        vCOBCust.TypeOfTable='GenericAccount';
        vCOBCust.Next();
        vCOBCust.Previous();
        vCOBCust.TypeOfTable='RelatedAccount';
        vCOBCust.Next(); 
        vCOBCust.Previous();
        vCOBCust.TypeOfTable='CustomerExtendSearch';
        vCOBCust.Next(); 
        vCOBCust.Previous();
        vCOBCust.end();
        vCOBCust.TypeOfTable='Customer';
        
        vCOBCust.TypeOfTable='RelatedAccount';
        
        
        
        vCOBCust.GenericAccount_total_size=50;
        vCOBCust.RelatedAccount_total_size=40;       
        vCOBCust.Customer_total_size=35;
        
        vCOBCust.TypeOfTable='Customer';       
        vCOBCust.end();
        
        vCOBCust.TypeOfTable='GenericAccount';       
        vCOBCust.end();
        
        vCOBCust.TypeOfTable='RelatedAccount';       
        vCOBCust.end();
        
        vCOBCust.getDisablePrevious();
        vCOBCust.getDisableNext();
        vCOBCust.getCustomer_total_size();
        vCOBCust.getPageNumber();
        
        vCOBCust.GenericAccount_total_size=50;
        vCOBCust.RelatedAccount_total_size=40;       
        vCOBCust.Customer_total_size=35;
        vCOBCust.getRelatedAccountTotalPages();
        vCOBCust.getTotalPages();
        vCOBCust.getDisableGenericAccountPrevious();
        vCOBCust.getDisableGenericAccountNext();
        vCOBCust.getDisableRelatedAccountPrevious();
        vCOBCust.getDisableRelatedAccountNext();
        vCOBCust.getRelatedAccount_total_size();
        vCOBCust.getGenericAccount_total_size();
        vCOBCust.getGenericAccountPageNumber();
        vCOBCust.getRelatedAccountPageNumber();
        
        vCOBCust.GenericAccount_total_size=100;
        vCOBCust.RelatedAccount_total_size=100;       
        vCOBCust.Customer_total_size=200;              
        vCOBCust.getGenericAccountTotalPages();
        
       vCOBCust.onChangeSearch();
       vCOBCust.search='Extend a Customer';
        vCOBCust.CustName2='Test';
       // vCOBCust.populateCustomer();
        
        ctrlCOBCustomerSearch.CustomerWrapperClass vWrpper4 = new ctrlCOBCustomerSearch.CustomerWrapperClass(ERPCustGeneral.Id,'abc','Test1','69','100','Test1','C100','SOrg45',true,'Bangalore','Karnataka','India','560078','JP Nagar','ERPClust','2345','Channel1','Div5',true,'Active','xyz');
        vCOBCust.CustomerWrapperList1=new List<ctrlCOBCustomerSearch.CustomerWrapperClass>();
        vCOBCust.CustomerWrapperList1.clear();
        vCOBCust.CustomerWrapperList1.add(vWrpper4);
        vCOBCust.IsListRender2= false;
        vCOBCust.IsListRender= true;
        vCOBCust.AccountSearch();
        

            
             
       test.stopTest();
  }  
  
   public static testMethod void CustomerSearch2(){
        Id CustCrRecordTypeId = Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('New Customer Creation').getRecordTypeId();
        Id ERPExtendedRecordTypeId = Schema.SObjectType.ERP_Customer__c.getRecordTypeInfosByName().get('ERP Customer - Extended Data').getRecordTypeId();      
        Id ERPCustomerGeneral= Schema.SObjectType.ERP_Customer__c.getRecordTypeInfosByName().get('ERP Customer - General Data').getRecordTypeId();
        //GroupMember gr = [SELECT GroupId,UserOrGroupId from GroupMember where UserOrGroupId =: UserInfo.getUserId()];
            
            
        ERP_Customer__c ERPCust = new ERP_Customer__c();
        ERPCust.Account_Group__c='Z001 ( Sold-to party )';
        ERPCust.City__c='Bangalore';
        ERPCust.State__c ='Karnataka';
        ERPCust.Street__c = 'JP Nagar';
        ERPCust.VAT_Number__c='00123';
        ERPCust.Tax_Code__c='V007';
        ERPCust.ZIP_Postal_Code__c='560068';
        ERPCust.Customer_Code__c='C6457';
        ERPCust.RecordTypeId=ERPExtendedRecordTypeId;
        ERPCust.Name ='Test';
        insert ERPCust;
        
         ERP_Customer__c ERPCust1 = new ERP_Customer__c();
        ERPCust1.Account_Group__c='Z001 ( Sold-to party )';
        ERPCust1.City__c='Bangalore';
        ERPCust1.State__c ='Karnataka';
        ERPCust1.Street__c = 'JP Nagar';
        ERPCust1.VAT_Number__c='00123';
        ERPCust1.Tax_Code__c='V007';
        ERPCust1.ZIP_Postal_Code__c='560068';
        ERPCust1.Customer_Code__c='C6457';
        ERPCust1.RecordTypeId=ERPExtendedRecordTypeId;
        ERPCust1.Name ='Test';
        insert ERPCust1;
        
        ERP_Customer__c ERPCustGeneral = new ERP_Customer__c();
        ERPCustGeneral.Account_Group__c='Z001 ( Sold-to party )';
        ERPCustGeneral.City__c='Bangalore';
        ERPCustGeneral.State__c ='Karnataka';
        ERPCustGeneral.Street__c = 'JP Nagar';
        ERPCustGeneral.VAT_Number__c='00123';
        ERPCustGeneral.Tax_Code__c='V007';
        ERPCustGeneral.ZIP_Postal_Code__c='560068';
        ERPCustGeneral.Customer_Code__c='C6457';
        ERPCustGeneral.RecordTypeId=ERPCustomerGeneral;
        ERPCustGeneral.Name ='Test';
        insert ERPCustGeneral;
              
        ERP_Customer_Localization__c ErpLocal = new ERP_Customer_Localization__c();
        ErpLocal.Language__c='EN';
        ErpLocal.ERP_Customer__c=ERPCust.Id;
        ErpLocal.Customer_Name__c ='Test';
        ErpLocal.External_ERP_ID__c='WB1-55420944-C';
        insert ErpLocal;
        
        ERP_Relationship__c vERPRelation = new ERP_Relationship__c();
        vERPRelation.ERP_Customer__c=ERPCust.Id;
        vERPRelation.Related_ERP_Customer__c=ERPCust.Id;
        vERPRelation.Name__c='TestRel';
        insert vERPRelation;
        
        Account vAccount = new Account();
        vAccount.Name='TestAccount';
        vAccount.OwnerId = userInfo.getUserId();
        vAccount.ERP_Customer__c=ERPCust.Id;
        vAccount.ERP_Company_Code__c='E456';
        vAccount.VAT_Number__c='V768';
        vAccount.Country__c='India';
//[05112017] Merge&Spin: Added record type attribute to account record
       vAccount.RecordTypeId = RType.getIdByDevName('Account','ERP_Account');
        insert vAccount;
        
        Account AccountGeneral= new Account();
        AccountGeneral.Name='TestAccountGeneral';
        AccountGeneral.OwnerId = userInfo.getUserId();
        AccountGeneral.VAT_Number__c='V768';
        AccountGeneral.Country__c='India';
//[05112017] Merge&Spin: Added record type attribute to account record
       AccountGeneral.RecordTypeId = RType.getIdByDevName('Account','ERP_Customer_General');
        insert AccountGeneral;

/*
        
        SVMXListSettings__c sv = new SVMXListSettings__c(Name='WarrantyLA',Static_Value__c = 'WarrantyLA');
        insert sv;
        SVMXListSettings__c sv1 = new SVMXListSettings__c(Name='ContractLA',Static_Value__c = 'WarrantyLA');
        insert sv1;
        SVMXListSettings__c sv2 = new SVMXListSettings__c(Name='BillableEMEA',Static_Value__c = 'WarrantyLA');
        insert sv2;
        SVMXListSettings__c sv3 = new SVMXListSettings__c(Name='WarrantyEMEA',Static_Value__c = 'WarrantyLA');
        insert sv3;
        SVMXListSettings__c sv4 = new SVMXListSettings__c(Name='Hardware ServiceEMEA',Static_Value__c = 'WarrantyLA');
        insert sv4;
        SVMXListSettings__c sv5 = new SVMXListSettings__c(Name='Hardware SalesEMEA',Static_Value__c = 'WarrantyLA');
        insert sv5;
        SVMXListSettings__c sv6 = new SVMXListSettings__c(Name='ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv6;
        SVMXListSettings__c sv7 = new SVMXListSettings__c(Name='Uptime ContractTypeEMEA',Static_Value__c = 'WarrantyLA');
        insert sv7;
        SVMXListSettings__c sv8 = new SVMXListSettings__c(Name='Uptime ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv8;
 */

        Case cas = new Case(subject='Unit Test', Status='New',recordtypeId = CST_Case_Number_CS_InternalRequest_Rtype );
        insert cas;
       ctrlCOBCustomerSearch vCOBCust1 = new ctrlCOBCustomerSearch();
       vCOBCust1.CustName1 = 'Test';
       vCOBCust1.identifyCST='Non CST Customer';
       vCOBCust1.search='Extend a Customer';
       vCOBCust1.GenericAccountSearch();
       ctrlCOBCustomerSearch.AccountWrapperClass vWrapper2 = new ctrlCOBCustomerSearch.AccountWrapperClass(vAccount.Id,'Test','V-002','TestRegion','India','Test-003','TsetType',true,'TestName','SFDC',CST_Account_Rtype,vAccount.OwnerId,'TestSBU','093475867234');
        vCOBCust1.CustomerRelatedAccountWrapperList = new List<ctrlCOBCustomerSearch.AccountWrapperClass>();
        vCOBCust1.CustomerRelatedAccountWrapperList.add(vWrapper2);
       vCOBCust1.IsCustomerRelatedAccountListRender=true;
       vCOBCust1.IsGenericAccountListRender=false;
       vCOBCust1.currentSelectionAccountId=null;
       vCOBCust1.extendsearch();
       vCOBCust1.IsGenericAccountListRender=true;
       vCOBCust1.extendsearch();
       vCOBCust1.setSearch('Extend');
       vCOBCust1.localLanguage='Chinese';
       vCOBCust1.CustName1 = 'Test';
       vCOBCust1.customerQuery();
       Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;  
        
        
        Account vAccount1 = new Account();
        vAccount1.Name='TestAccount';
        vAccount1.OwnerId = U1.Id;
        vAccount1.ERP_Customer__c=ERPCust.Id;
        vAccount1.ERP_Company_Code__c='E456';
        vAccount1.VAT_Number__c='V768';
        vAccount1.Country__c='India';
        insert vAccount1;
        system.RunAs(U1){
            List<Account> acc = new List<Account>();
            acc.add(vAccount1);
            vCOBCust1.AccountShareList(acc);
        }
       
   }
    
}
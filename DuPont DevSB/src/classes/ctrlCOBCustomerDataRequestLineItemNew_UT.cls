/*
 * Merge&Spin - Removed (SeeAllData=false)
 * 
*/

@isTest
public class ctrlCOBCustomerDataRequestLineItemNew_UT{
public static string CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Create new bill to, ship to, payer').getRecordTypeId();    
public static string LINKCONTACT_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Link Contact').getRecordTypeId();
public static string LINKEXISTINGPARTNER_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Link Existing Partner Function').getRecordTypeId();
public static string CREATENEWPARTNERFUNCTION_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Create new partner function').getRecordTypeId();
public static string MISCELLANEOUS_CDR_RTYPE = Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('Miscellaneous customer data request').getRecordTypeId();
public static string customerOnboardingContactRecorType= Rtype.getIdByDevName('Contact','Customer_Onboarding_External_Contact');   
public static string NEWCUSTOMERCREATION_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');

public static testMethod void ctrlLineTest() {
  
 test.StartTest();
        
     COB_Region__c CobCustom= new COB_Region__c();
        CobCustom.Name='abc';
        CobCustom.Country__c='IN - India'; 
        CobCustom.Region__c='IN - 22 - Tamil Nadu';
        insert CobCustom;
        
   Id ERPId = [Select Id, Name from RecordType where DeveloperName = 'ERP_Customer_Extended_Data' limit 1].Id;       
      ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        ERPCust.RecordTypeId = ERPId;
        insert ERPCust;  
         
        Account vAccount = new Account();
        vAccount.Name='TestAccount';
        vAccount.OwnerId = userInfo.getUserId();
        vAccount.ERP_Customer__c=ERPCust.Id;
        vAccount.ERP_Company_Code__c='E456';
        vAccount.VAT_Number__c='V768';
        vAccount.Country__c='India';
        insert vAccount;
        
    Contact con=new Contact();
    con.FirstNameLocal='Nishanth';
    con.LastNameLocal='Haridas';
    con.AccountId=vAccount.Id;
    con.Phone='342424234';
    con.Email='nish@infy.com';
    con.LastName='abc';
    insert con; 
   
    Customer_Data_Request__c cdr = new Customer_Data_Request__c();
        cdr.Customer_Name__c='TestA';
        cdr.Customer_Name_2__c='TestB';
        cdr.Account__c=vAccount.Id;
        cdr.Record_Locked__c=true;
        cdr.recordtypeid=Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('Miscellaneous customer data request').getRecordTypeId();
        insert cdr;  
       
 Customer_Data_Request_Line_Item__c cli=new Customer_Data_Request_Line_Item__c();
 cli.Customer_Name__c='TestA';
 cli.Customer_Name_2__c='TestB';
 cli.Customer_Data_Request__c=cdr.id;
 cli.Local_Version__c='Arabic';
 cli.Country__c='AD - Andorran';
 cli.Local_Language_Country__c='AF - Afghanistan';
 insert cli;
 


ApexPages.currentPage().getParameters().put('lkid',cdr.Id); 

ctrlCOBCustomerDataRequestLineItemNew line=new ctrlCOBCustomerDataRequestLineItemNew();

line.displayShipTo();
line.cancel();

line.custOnboardingReq.Account__c=vAccount.id;
line.copyAddress='true';
line.selectedRecordTypeId=CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE;
line.custOnboardingReq.RecordTypeId=NEWCUSTOMERCREATION_COB_RTYPE ;
line.prepopulate();

line.custOnboardingReq.RecordTypeId=MISCELLANEOUS_CDR_RTYPE;
line.prepopulate();
line.custOnboardingReq.RecordTypeId=LINKCONTACT_CDRLI_RTYPE;
line.PopulateContact();
line.copyAddress='false';
line.prepopulate();

ApexPages.currentPage().getParameters().put('sixthParam','IN - India');
//line.CustDataReqLineItem .Country__c='IN - India';
line.fetchRegionValues();

line.CustDataReqLineItem.Local_Language_Country__c='AF - Afghanistan';
line.fetchLocalLangValues();
line.fetchLocalRegionValues();

cli.Local_Version__c='';
update cli;
line.getdisplayLangDetails();

line.CustDataReqLineItem.Local_Version__c ='Arabic';
line.getdisplayLangDetails();

line.custOnboardingReq.Record_Locked__c=false;
line.newrecordLockValidation();

ApexPages.currentPage().getParameters().put('id',cdr.Id); 
line.custOnboardingReq.Record_Locked__c=true;
line.recordLockValidation();

line.custOnboardingReq.Record_Locked__c=false;
line.recordLockValidation();

line.goBack();
line.Done();

//line.CustDataReqLineItem.Local_Version__c='Arabic';
line.CustDataReqLineItem.Local_Language_Country__c='';
line.CustDataReqLineItem.Street__c='';
line.CustDataReqLineItem.City__c='';
line.CustDataReqLineItem.Postal_Code__c='';
line.SaveAddress();

line.CustDataReqLineItem.Local_Version__c='';
//line.CustDataReqLineItem.Local_Language_Country__c='CN - China';
//line.CustDataReqLineItem.Local_Language_State_Province__c = '';
//line.SaveAddress();


//line.fetchLocalValues(); 
line.checkLocalLanguage();
line.getDisablePrevious();
line.getDisableNext();
line.Next();
line.Previous();
line.getContacts_total_size();
line.getPageNumber();
line.getTotalPages();

line.newLineItemCreationValidation();


line.clearContactList();
line.selectedRecordTypeId =LINKCONTACT_CDRLI_RTYPE;
line.customerLinkage();
line.saveContact();
//line.saveContactnew();
line.cancelnew();
line.newContactCreation();
line.cancelContact();
 
ctrlCOBCustomerDataRequestLineItemNew.contactWrapper empW = new ctrlCOBCustomerDataRequestLineItemNew.contactWrapper(true,'ab','cd','ef','gh','ij','kl');
test.stopTest();
}

public static testMethod void ctrlLineTest1() {

Customer_Data_Request__c cdr = new Customer_Data_Request__c();
        cdr.Customer_Name__c='TestA';
        cdr.Customer_Name_2__c='TestB';
        cdr.Record_Locked__c=true;
        cdr.recordtypeid=Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('Miscellaneous customer data request').getRecordTypeId(); 
        insert cdr;
        
        COB_Region__c CobCustom= new COB_Region__c();
        CobCustom.Name='abc';
        CobCustom.Country__c='IN - India'; 
        CobCustom.Region__c='IN - 22 - Tamil Nadu';
        insert CobCustom;
        
         Account vAccount = new Account();
        vAccount.Name='TestAccount';
        vAccount.OwnerId = userInfo.getUserId();
        //vAccount.ERP_Customer__c=ERPCust.Id;
        vAccount.ERP_Company_Code__c='E456';
        vAccount.VAT_Number__c='V768';
        vAccount.Country__c='India';
        insert vAccount;
        
    
  
         
 Customer_Data_Request_Line_Item__c cli=new Customer_Data_Request_Line_Item__c();
 cli.Customer_Name__c='TestA';
 cli.Customer_Name_2__c='TestB';
 cli.Customer_Data_Request__c=cdr.id;
 cli.Local_Version__c='Arabic';
 cli.Country__c='AD - Andorran';
 cli.Local_Language_Country__c='AF - Afghanistan';
 insert cli;
 

ApexPages.currentPage().getParameters().put('action','edit') ;
ApexPages.currentPage().getParameters().put('id',cli.Id); 

ctrlCOBCustomerDataRequestLineItemNew line=new ctrlCOBCustomerDataRequestLineItemNew();
line.saveContactnew();




}

}
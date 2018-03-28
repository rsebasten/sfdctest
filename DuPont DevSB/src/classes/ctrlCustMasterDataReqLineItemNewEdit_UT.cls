@isTest
public class ctrlCustMasterDataReqLineItemNewEdit_UT{

 public static final string CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Create_new_bill_to_ship_to_payer');
    public static final string LINKCONTACT_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Link_Contact');
    public static final string LINKEXISTINGPARTNER_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Link_Existing_Partner_Function');
    public static final string CREATENEWPARTNERFUNCTION_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Create_new_partner_function');



Public static testMethod void MasterDataReq(){
 Test.StartTest();
 
  Customer_Data_Request__c cdr = new Customer_Data_Request__c();
        cdr.Customer_Name__c='TestA';
        cdr.Customer_Name_2__c='TestB';
        cdr.Record_Locked__c=true;
        cdr.Sold_To_Office_House_Number__c = 'test';
        cdr.Sold_to_State_Province__c = 'test';
        insert cdr;       
 
   Customer_Data_Request_Line_Item__c cli=new Customer_Data_Request_Line_Item__c();
     cli.Customer_Name__c='TestA';
     cli.Customer_Name_2__c='TestB';
     cli.Customer_Data_Request__c=cdr.id;
     cli.Local_Version__c='Arabic';
     cli.Country__c='AD - Andorran';
     cli.Local_Language_Country__c='AF - Afghanistan';
     insert cli;
   
   Customer_Data_Request_Line_Item__c cdrli=new Customer_Data_Request_Line_Item__c();

  ApexPages.StandardController sd = new ApexPages.standardController(cdrli);
  ctrlCustMasterDataReqLineItemNewEdit con1 = new ctrlCustMasterDataReqLineItemNewEdit(sd);
  con1.redirect();
  
  cdrli.recordtypeId=CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE;
  con1.redirect();
  
  cdrli.recordtypeId=LINKCONTACT_CDRLI_RTYPE ;
  con1.redirect();
  
  cdrli.recordtypeId=LINKEXISTINGPARTNER_CDRLI_RTYPE;
  con1.redirect();
  
  cdrli.recordtypeId=CREATENEWPARTNERFUNCTION_CDRLI_RTYPE;
  con1.redirect();
  
  ApexPages.StandardController sc = new ApexPages.standardController(cli);
  ctrlCustMasterDataReqLineItemNewEdit con = new ctrlCustMasterDataReqLineItemNewEdit(sc);
  con.redirect();

  cli.recordtypeId=CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE;
  update cli;
  con.redirect();
  
  cli.recordtypeId=LINKCONTACT_CDRLI_RTYPE ;
  update cli;
  con.redirect();
  
  cli.recordtypeId=LINKEXISTINGPARTNER_CDRLI_RTYPE;
  update cli;
  con.redirect();
  
  cli.recordtypeId=CREATENEWPARTNERFUNCTION_CDRLI_RTYPE;
  update cli;
  con.redirect();
  
  //ApexPages.hasMessages.put(ApexPages.SEVERITY.ERROR,'Error');
  con.redirect();

test.stopTest();
}
}
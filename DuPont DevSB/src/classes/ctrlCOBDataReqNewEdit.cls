/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Nishant Chopra , Alvin_Johnson@infosys.com
Email: nishant_chopra01@infosys.com
Description:  Controller for page: COBDataReqNewEdit
 ********************************************************************************/ 
public with sharing class ctrlCOBDataReqNewEdit {

    public static final string NEWCUSTOMERCREATION_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
    public static final string EXTENDEXISTINGCUSTOMER_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Extend_Existing_Customer');
    public static final string PARTNERFUNCTIONLINK_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
    public static final string MISCELLANEOUS_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request');
    public static final string MODIFY_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');
    public String RTypeSelected{get;set;}
    public String retURL{get;set;}
    Public String Clone{get;set;}
    Public String Account{get;set;}
    Public String UserProfile;
    Public String erpCust;
    Public String CaseId;
    Public String search;
    Public String accountId;
    Public string accountLink;
    public Customer_Data_Request__c so; 
    Public List<RecordType> recordTypeList{get;set;}
    Public List<RecordType> recordTypeListSorted{get;set;}

    Public List<String> rec{get; set;}
    public list<SelectOption> getRecordTypes() {
        list<SelectOption> options = new list<SelectOption>();

        options.add(new SelectOption(NEWCUSTOMERCREATION_COB_RTYPE,'New Customer Creation'));
        options.add(new SelectOption(MODIFY_COB_RTYPE,'Modify Existing Customer Data'));
        options.add(new SelectOption(EXTENDEXISTINGCUSTOMER_COB_RTYPE,'Extend Existing Customer'));
        options.add(new SelectOption(PARTNERFUNCTIONLINK_COB_RTYPE,'Create partner function/Link Contact/Link Existing Partner'));
        options.add(new SelectOption(MISCELLANEOUS_COB_RTYPE,'Miscellaneous customer data request'));

        return options;
    }

    /**
     * Name: ctrlCOBDataReqNewEdit
     * Params: None
     * Description: Constructor of the class.  
     */  
    public ctrlCOBDataReqNewEdit(ApexPages.StandardController controller) {
        UserProfile = [Select Name,Id from Profile where Id =:UserInfo.getProfileID()].Name;
        recordTypeList=[SELECT ID, name, Description FROM RecordType WHERE SObjectType = 'Customer_Data_Request__c' and ( id=:EXTENDEXISTINGCUSTOMER_COB_RTYPE or id=: NEWCUSTOMERCREATION_COB_RTYPE or id=:MODIFY_COB_RTYPE or id=:PARTNERFUNCTIONLINK_COB_RTYPE or id=:MISCELLANEOUS_COB_RTYPE )];
        recordTypeListSorted= new List<RecordType>();

        rec = new List<String>();
        rec.add(NEWCUSTOMERCREATION_COB_RTYPE);
        rec.add(MODIFY_COB_RTYPE);
        rec.add(EXTENDEXISTINGCUSTOMER_COB_RTYPE);
        rec.add(PARTNERFUNCTIONLINK_COB_RTYPE);
        rec.add(MISCELLANEOUS_COB_RTYPE);
        for(String r : rec){

            for(RecordType rt : recordTypeList){
                if(rt.ID == r){
                    recordTypeListSorted.add(rt);
                    break;
                }    
            }
        }

        if(ApexPages.currentPage().getParameters().containsKey('clone')){
            Clone=ApexPages.currentPage().getParameters().get('clone');
        }
        so=(Customer_Data_Request__c)controller.getRecord();      


        if(ApexPages.currentPage().getParameters().containsKey('ERPCustomer')){
            erpCust=ApexPages.currentPage().getParameters().get('ERPCustomer');
        }
        if(ApexPages.currentPage().getParameters().containsKey('Case')){
            CaseId=ApexPages.currentPage().getParameters().get('Case');
        }
        if(ApexPages.currentPage().getParameters().containsKey('Search')){
            search=ApexPages.currentPage().getParameters().get('Search');
        }
        if(ApexPages.currentPage().getParameters().containsKey('Account')){
            accountId=ApexPages.currentPage().getParameters().get('Account');
        }
        if(ApexPages.currentPage().getParameters().containsKey('AccountLink')){
            accountLink=ApexPages.currentPage().getParameters().get('AccountLink');
        }
    }
    public pageReference newEdit(){

        if(so.get('Id')!=null){
            return redirect();
        }

        return null;
    }

    /**
     * Name: redirect
     * Params: None
     * Description: Method to redirect to respective recordtype VF pages  
     */  
    public pageReference redirect(){
        PageReference returnURL;
        SET<String> rtypes = new SET<String>();
        rtypes.add(NEWCUSTOMERCREATION_COB_RTYPE); 
        rtypes.add(EXTENDEXISTINGCUSTOMER_COB_RTYPE);
        rtypes.add(PARTNERFUNCTIONLINK_COB_RTYPE);
        rtypes.add(MISCELLANEOUS_COB_RTYPE);
        rtypes.add(MODIFY_COB_RTYPE);
        if(so.get('Id')!=null){

            if(String.valueof(so.get('RecordTypeId'))!=null && String.valueof(so.get('RecordTypeId')) == NEWCUSTOMERCREATION_COB_RTYPE){
                returnURL= new PageReference('/apex/COBNewCustomerCreation?RecordTypeId='+so.get('RecordTypeId')+'&Id='+so.get('Id')+'&Clone='+Clone+'&Account='+Account);
                return returnURL;
            }

            else if(String.valueof(so.get('RecordTypeId'))!=null && String.valueof(so.get('RecordTypeId')) == EXTENDEXISTINGCUSTOMER_COB_RTYPE){
                returnURL= new PageReference('/apex/COBExtendExistingCustomer?RecordTypeId='+so.get('RecordTypeId')+'&Id='+so.get('Id')+'&Clone='+Clone+'&Account='+Account+'&ERPCustomer='+erpCust);
                return returnURL;
            }

            else if(String.valueof(so.get('RecordTypeId'))!=null && String.valueof(so.get('RecordTypeId')) == PARTNERFUNCTIONLINK_COB_RTYPE){
                returnURL= new PageReference('/apex/COBPartnerLink?RecordTypeId='+so.get('RecordTypeId')+'&Id='+so.get('Id')+'&Clone='+Clone+'&Account='+Account);
                return returnURL;
            }

            else if(String.valueof(so.get('RecordTypeId'))!=null && String.valueof(so.get('RecordTypeId')) == MISCELLANEOUS_COB_RTYPE){
                returnURL= new PageReference('/apex/COBMiscellaneousRequest?RecordTypeId='+so.get('RecordTypeId')+'&Id='+so.get('Id')+'&Clone='+Clone+'&Account='+Account);
                return returnURL;
            }

            else if(String.valueof(so.get('RecordTypeId'))!=null && String.valueof(so.get('RecordTypeId')) == MODIFY_COB_RTYPE){
                returnURL= new PageReference('/apex/COBModifyExistingCustomer?RecordTypeId='+so.get('RecordTypeId')+'&Id='+so.get('Id')+'&Clone='+Clone+'&Account='+Account+'&ERPCustomer='+erpCust);
                return returnURL;
            }

            else
            {
                returnURL= new PageReference('/apex/COBCustomerSearch');

                return returnURL;
            }

        }
        else if(so== null ||so.get('Id')==null ){
            if(String.valueof(so.get('Account__c'))!=null ){
                accountId=String.valueof(so.get('Account__c'));
            }
            if(String.valueof(RTypeSelected)!=NEWCUSTOMERCREATION_COB_RTYPE && search=='Duplicate'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can only Create New Customer from Duplicate search'));
                return null;
            }
            if(String.valueof(RTypeSelected)!=EXTENDEXISTINGCUSTOMER_COB_RTYPE && search=='Extend'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can only Extend Existing Customer from Extend Customer Select search'));
                return null;
            }
            if(String.valueof(RTypeSelected)!=MODIFY_COB_RTYPE && String.valueof(RTypeSelected)!=PARTNERFUNCTIONLINK_COB_RTYPE && String.valueof(RTypeSelected)!=MISCELLANEOUS_COB_RTYPE && search=='Modify'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can create only Modify Existing Customer Request/Miscellaneous Customer Data Request/Create Partner Function, Link Contact, Link Existing Partner Request from Modify Customer Select search'));
                return null;
            }

            if(String.valueof(RTypeSelected)!=null && String.valueof(RTypeSelected) == NEWCUSTOMERCREATION_COB_RTYPE){
                returnURL= new PageReference('/apex/COBNewCustomerCreation?RecordTypeId='+RTypeSelected+'&Id=null&Clone='+Clone+'&Account='+accountId+'&ERPCustomer='+erpCust+'&Case='+CaseId+'&Search='+search+'&AccountLink='+accountLink);
                return returnURL;
            }

            else if(String.valueof(RTypeSelected)!=null && String.valueof(RTypeSelected)  == EXTENDEXISTINGCUSTOMER_COB_RTYPE){
                returnURL= new PageReference('/apex/COBExtendExistingCustomer?RecordTypeId='+RTypeSelected+'&Id=null&Clone='+Clone+'&Account='+accountId+'&ERPCustomer='+erpCust+'&Case='+CaseId+'&Search='+search+'&AccountLink='+accountLink);
                return returnURL;
            }

            else if(String.valueof(RTypeSelected)!=null && String.valueof(RTypeSelected)  == PARTNERFUNCTIONLINK_COB_RTYPE){
                returnURL= new PageReference('/apex/COBPartnerLink?RecordTypeId='+RTypeSelected+'&Id=null&Clone='+Clone+'&Account='+accountId+'&ERPCustomer='+erpCust+'&Case='+CaseId+'&Search='+search+'&AccountLink='+accountLink);
                return returnURL;
            }

            else if(String.valueof(RTypeSelected)!=null && String.valueof(RTypeSelected)  == MISCELLANEOUS_COB_RTYPE){
                returnURL= new PageReference('/apex/COBMiscellaneousRequest?RecordTypeId='+RTypeSelected+'&Id=null&Clone='+Clone+'&Account='+accountId+'&ERPCustomer='+erpCust+'&Case='+CaseId+'&Search='+search+'&AccountLink='+accountLink);
                return returnURL;
            }

            else if(String.valueof(RTypeSelected)!=null && String.valueof(RTypeSelected)  == MODIFY_COB_RTYPE){
                returnURL= new PageReference('/apex/COBModifyExistingCustomer?RecordTypeId='+RTypeSelected+'&Id=null&Clone='+Clone+'&Account='+accountId+'&ERPCustomer='+erpCust+'&Case='+CaseId+'&Search='+search+'&AccountLink='+accountLink);
                return returnURL;
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }

    }

    /**
     * Name: cancel
     * Params: None
     * Description: Method to redirect cancel button 
     */  
    public PageReference cancel(){
        PageReference returnURL= new PageReference('/apex/COBCustomerSearch');
        return returnURL;
    }
}
public with Sharing class ctrlCustMasterDataReqLineItemNewEdit{

    public static final string CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Create_new_bill_to_ship_to_payer');
    public static final string LINKCONTACT_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Link_Contact');
    public static final string LINKEXISTINGPARTNER_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Link_Existing_Partner_Function');
    public static final string CREATENEWPARTNERFUNCTION_CDRLI_RTYPE = Rtype.getIdByDevName('Customer_Data_Request_Line_Item__c','Create_new_partner_function');
    private static Customer_Data_Request_Line_Item__c cdrli;  
    
    
     public ctrlCustMasterDataReqLineItemNewEdit(ApexPages.StandardController controller) {
        cdrli=(Customer_Data_Request_Line_Item__c)controller.getRecord();
        
     }
     
     
     public PageReference redirect() {
        PageReference returnURL;

        SET<String> rtypes = new SET<String>();
        rtypes.add(CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE); 
        rtypes.add(LINKCONTACT_CDRLI_RTYPE);
        rtypes.add(LINKEXISTINGPARTNER_CDRLI_RTYPE);
        rtypes.add(CREATENEWPARTNERFUNCTION_CDRLI_RTYPE);
        
        if (returnURL==null && (rtypes.CONTAINS(String.valueof(cdrli.get('RecordTypeId')))||(String.valueof(cdrli.get('RecordTypeId'))==null))){
            if(cdrli.get('Id')==null){
            
            
                if(String.valueof(cdrli.get('RecordTypeId'))==null || (String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE)){
                    String RecordTypeID = CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE;
                    returnURL= new PageReference('/apex/COBCDRLineItemNew?RecordTypeId='+RecordTypeID+'&lkid='+cdrli.Customer_Data_Request__c  );
                    return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == LINKCONTACT_CDRLI_RTYPE){
                     String RecordTypeID = LINKCONTACT_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemLinkContact?RecordTypeId='+cdrli.get('RecordTypeId')+'&lkid='+cdrli.Customer_Data_Request__c);
                     return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == LINKEXISTINGPARTNER_CDRLI_RTYPE){
                     String RecordTypeID = LINKEXISTINGPARTNER_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemPartner?RecordTypeId='+cdrli.get('RecordTypeId')+'&lkid='+cdrli.Customer_Data_Request__c);
                     return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == CREATENEWPARTNERFUNCTION_CDRLI_RTYPE){
                     String RecordTypeID = CREATENEWPARTNERFUNCTION_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemPartner?RecordTypeId='+cdrli.get('RecordTypeId')+'&lkid='+cdrli.Customer_Data_Request__c);
                     return returnURL;
                 }
             }
             else
             {
                 if(String.valueof(cdrli.get('RecordTypeId'))==null || (String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE)){
                    String RecordTypeID = CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE;
                    returnURL= new PageReference('/apex/COBCDRLineItemNew?RecordTypeId='+RecordTypeID+'&Id='+cdrli.get('Id')+'&action=edit');
                    return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == LINKCONTACT_CDRLI_RTYPE){
                     String RecordTypeID = LINKCONTACT_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemLinkContact?RecordTypeId='+cdrli.get('RecordTypeId')+'&Id='+cdrli.get('Id')+'&action=edit');
                     return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == LINKEXISTINGPARTNER_CDRLI_RTYPE){
                     String RecordTypeID = LINKEXISTINGPARTNER_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemPartner?RecordTypeId='+cdrli.get('RecordTypeId')+'&Id='+cdrli.get('Id')+'&action=edit');
                     return returnURL;
                 }
                 else if(String.valueof(cdrli.get('RecordTypeId'))!=null && String.valueof(cdrli.get('RecordTypeId')) == CREATENEWPARTNERFUNCTION_CDRLI_RTYPE){
                     String RecordTypeID = CREATENEWPARTNERFUNCTION_CDRLI_RTYPE;
                     returnURL= new PageReference('/apex/COBCDRLineItemPartner?RecordTypeId='+cdrli.get('RecordTypeId')+'&Id='+cdrli.get('Id')+'&action=edit');
                     return returnURL;
                 }
             }        
        }
        if (returnURL==null && !ApexPages.hasMessages(ApexPages.SEVERITY.ERROR)) 
            returnURL=defaultFields.onOverrideNew(cdrli);        
        return returnURL;             
     }   
    
}
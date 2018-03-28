/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Email Service to handle Customer Service cases through Internal request Email Address. 
    Change History                                                    Date 
*** AA 09032015 -- Added Code for Cluster Accounts Functionality ...  09/03/205
*** VS 10212015-- Moved below line after not null check of email case 10/21/2015 
    (Line No.60) In order to avoid null pointer exception.
    emailCase.CustomerServiceCenter__c = regionValue;
     emailCase.Priority = EMAIL_PRIORITY;
     
 // AA20151123 - Changes for adding attachment to email.
//AB20160517 - Changes to accomodate Dummy BU Account with Type as DuPont
//AB20160513 - Updated INTERNAL_REQ_CATEGORY to 'New Internal Request' as suggested by business be the default case category for internal request
********************************************************************************/
global with sharing class emailCSInternalRequestHandler implements Messaging.InboundEmailHandler {
    Private Static Final String EMAIL_VAL = 'Email';
    Private Static Final String EMAIL_PRIORITY = 'Medium';
    Private Static Final String INTERNAL_REQ_CATEGORY ='New Internal Request';//AB20160513
    Private Static Final String ORIGIN = 'Email';
    Private Static Final String ACCOUNT_RECTYPE = 'ERP Customer';
    Private Static Final String CONTACT_RECTYPE = 'CS-Contact';
    Private Static Final String SUCCESS = 'success';
    private static Final string SUCCESS_EMAIL = 'success with email';
    Private Static Final String COMPARE_STRING = '@';
    Private Static Final String BU_ACCOUNT_TYPE = 'DuPont';//AB20160517
    
    /* This method creates Cases based on the emails coming through eFax channel. */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String errorMsg = Label.CS_ErrorMessage;
        String senderEmailAddress = email.fromAddress;
        String isSuccess;
        Integer lmt = Limits.getLimitQueryRows(); 
        Case emailCase = null;
        try
        {
            Id internalRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseIRRecordType).getRecordTypeId();
            String toEmailAddress = envelope.toAddress.substring(0,envelope.toAddress.indexOf(COMPARE_STRING));
             
            if(toEmailAddress != null && CS_EmailAddressSettings__c.getInstance() != null)
            {
                CS_EmailAddressSettings__c emailSettings = CS_EmailAddressSettings__c.getValues(toEmailAddress);
                String regionValue = emailSettings.CS_Region__c;
             /* AA 09032015 - Added Code for Cluster Accounts Functionality ...   */
                List<Contact> contactWithAccountList = [SELECT AccountId,Email,Id,Account.Type //AB20160517 fetch account type
                                                    FROM Contact 
                                                    WHERE Email =: senderEmailAddress and RecordType.Name =:CONTACT_RECTYPE 
                                                          and AccountId!=null and Account.RecordType.Name =:ACCOUNT_RECTYPE 
                                                          and Account.Status__c =:Label.CS_Active 
                                                    LIMIT :lmt];
            /* AB20160517 Changes Starts */
            Integer iBUAccCounter = 0;//AB20160517 To count the number of BU Accounts the contact appears in
            Id idBUAccId = null; //AB20160517 To capture BU Account Id
            for(Contact con : contactWithAccountList)
            {
               iBUAccCounter = (con.Account.Type!=null&&con.Account.Type==BU_ACCOUNT_TYPE)?++iBUAccCounter:iBUAccCounter;//AB20160517 Increment if BU Account is associated with the contact
                idBUAccId = (con.Account.Type!=null&&con.Account.Type==BU_ACCOUNT_TYPE)? con.Account.Id : idBUAccId; //AB20160517 if BU Account is associated with the contact
            }
            /* AB20160517 Changes Ends */    
             if(!contactWithAccountList.isEmpty() && ((contactWithAccountList.size() == 1 || iBUAccCounter==1) && iBUAccCounter<2)){
                   isSuccess = emailCSDenialOfServiceHelper.getIntReqCaseDayLimit();
                    if(isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS ){
                        emailCase = utilCSEmailService.createCaseWithAccountContact(email, internalRecTypeId, INTERNAL_REQ_CATEGORY , ORIGIN, iBUAccCounter==1?idBUAccId:contactWithAccountList[0].AccountId, contactWithAccountList[0].Id);//AB20160517 if BU Account present use BU Account otherwise original account
                        
                    }
             }else{
                List<Contact> contactList = [SELECT id, AccountId, name FROM Contact WHERE Name =:Label.CS_CustomerService LIMIT 1];
                if(!contactList.isEmpty() && contactList.size() == 1){
                      isSuccess = emailCSDenialOfServiceHelper.getIntReqCaseDayLimit();
                    if(isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS ){
                        emailCase = utilCSEmailService.createCaseWithAccountContact(email, internalRecTypeId, INTERNAL_REQ_CATEGORY , ORIGIN, contactList[0].AccountId, contactList[0].Id);
                    }
                }
                 //<SB02092016>
                else
                    emailCase = utilCSEmailService.createCaseWithoutAccountContact(email, internalRecTypeId, INTERNAL_REQ_CATEGORY , ORIGIN);
                 //<SB02092016>
             }
                if(emailCase != null){
                    emailCase.CustomerServiceCenter__c = regionValue;
                    emailCase.Priority = EMAIL_PRIORITY;
                    Database.DMLOptions dmlOpts= utilCSEmailService.invokeAssignmentRule();
                    emailCase.setOptions(dmlOpts); 
                    Database.SaveResult saveResultOrder = Database.insert(emailCase, false);
                    if (saveResultOrder.isSuccess()) {
                        // AA20151123 - Changes for adding attachment to email.
                        EmailMessage emailMsg = utilCSEmailService.attachEmail(email , emailCase);
                        if(emailMsg!=null)
                            utilCSEmailService.attachAttachments(email,emailMsg);  
                    }
                    
                    if (saveResultOrder.isSuccess() && isSuccess == SUCCESS_EMAIL ){
                        emailCSDenialOfServiceHelper.sendEmail(emailcase.id, senderEmailAddress, toEmailAddress);
                    }
                }
            }
            result.success = true;
        }
        catch(Exception e)
        {
            String er = e.getMessage();
            String toEmailAddress;
            String EmailSubject;
            String name = 'Error in class : emailCSInternalRequestHandler';        
            utilCSEmailService.CreateBatchMonitor(name,ErrorMsg,er,SenderEmailAddress,toEmailAddress,EmailSubject);
            System.debug('The following exception has occurred: ' + e.getMessage()+ errorMsg);
            result.success = false;
            result.message = errorMsg ;

        }      
    return result;
    }        
}
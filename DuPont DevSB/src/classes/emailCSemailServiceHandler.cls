/*******************************************************************************
Copyright ? 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Email Service to handle cases through Email. 

//  <ShashankB20150924> Added email subject check before case creation at line 30
// <VS20151027>Removed code related to subject check at line 30
// AA20151123 - Changes for adding attachment to email.
// SG20151204 - Changes in the Workingestion process for handling multiple contacts
//SG20012015 - Chnaged the logic if Inative Parent Account is Associate to the case it should go the unassigned case by passing the validation rule
//AB20160517 - Changes to accomodate Dummy BU Account with Type as DuPont
********************************************************************************/
global with sharing class emailCSemailServiceHandler implements Messaging.InboundEmailHandler {
    Private Static Final String ORDER_CATEGORY ='New Order';
    Private Static Final String SR_CATEGORY = 'New Service Request'; 
    Private Static Final String ORIGIN = 'Email';
    Private Static Final String ACCOUNT_RECTYPE = 'ERP Customer';
    Private Static Final String CONTACT_RECTYPE = 'CS-Contact';
    Private Static Final String SUCCESS = 'success';
    Private Static Final String COMPARE_STRING = '@';
    private static Final string LIMIT_EXCEED = 'limitExceed';
    private static Final string SUCCESS_EMAIL = 'success with email';
    private static final String CASE_SOURCE = 'Customer'; 
    Private Static Final String BU_ACCOUNT_TYPE = 'DuPont';//AB20160517
    
            
    /* This method creates Cases based on the emails coming through Email channel. */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String senderEmailAddress = email.fromAddress;
        String toAddress = envelope.toAddress.substring(0,envelope.toAddress.indexOf(COMPARE_STRING));
        String errorMsg = Label.CS_ErrorMessage;
        String isSuccess; 
        String Status;
        Case  emailCase = null;
        CS_EmailAddressSettings__c emailSettings = CS_EmailAddressSettings__c.getValues(toAddress);
        String regionValue = emailSettings.CS_Region__c;
        try{
           
            Id orderRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseOrderRecordType).getRecordTypeId();
            Id serviceReqRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseSRRecordType).getRecordTypeId();
            String toEmailAddress = emailSettings.Name;

            String requestTypeVal = emailSettings.CS_RequestType__c;
            Integer lmt = Limits.getLimitQueryRows(); 
            //SGDec2015 - Included Parent Account Id, Status in the Query
            List<Contact> contactWithAccountList = [SELECT Account.parentId, Account.Parent.Status__c, AccountId,Email,Id,Account.Type //AB20160517 fetch account type
                                                    FROM Contact 
                                                    WHERE Email =: senderEmailAddress and RecordType.Name =:CONTACT_RECTYPE 
                                                          and AccountId!=null and Account.RecordType.Name =:ACCOUNT_RECTYPE 
                                                          and Account.Status__c =:Label.CS_Active 
                                                    LIMIT :lmt];
            system.debug(senderEmailAddress + '**' + CONTACT_RECTYPE + '**' + ACCOUNT_RECTYPE + '**' + Label.CS_Active);                                    
            set<Id> ParentId = new set<Id>();                    //SGDec2015 Logic to Add all the Parent Account Ids in the Set
            Id ParId;
            Integer iBUAccCounter = 0;//AB20160517 To count the number of BU Accounts the contact appears in
            Id idBUAccId = null; //AB20160517 To capture BU Account Id
            for(Contact con : contactWithAccountList)
            {
                ParentId.add(con.Account.parentId);
                ParId= con.Account.parentId;
                Status = con.Account.Parent.Status__c;
                iBUAccCounter = (con.Account.Type!=null&&con.Account.Type==BU_ACCOUNT_TYPE)?++iBUAccCounter:iBUAccCounter;//AB20160517 Increment if BU Account is associated with the contact
                idBUAccId = (con.Account.Type!=null&&con.Account.Type==BU_ACCOUNT_TYPE)? con.Account.Id : idBUAccId; //AB20160517 if BU Account is associated with the contact
            }
            
            
            
            if(!contactWithAccountList.isEmpty() && ((contactWithAccountList.size() == 1 || iBUAccCounter==1) && iBUAccCounter<2))//AB20160517 if there is only one associated BU Account
            {
                isSuccess = emailCSDenialOfServiceHelper.getAssignedCaseDayLimit(iBUAccCounter==1?idBUAccId:contactWithAccountList[0].AccountId);//AB20160517 if BU Account present use BU Account otherwise original account
                if (isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS) 
                {
                    if(CS_EmailAddressSettings__c.getInstance() != null)
                    {
                        if(toEmailAddress != null && requestTypeVal == ORDER_CATEGORY )
                        {
                          emailCase = utilCSEmailService.createCaseWithAccountContact(email, orderRecordType, ORDER_CATEGORY, ORIGIN, iBUAccCounter==1?idBUAccId:contactWithAccountList[0].AccountId, contactWithAccountList[0].Id);//AB20160517 if BU Account present use BU Account otherwise original account
                        }
                        else if(toEmailAddress != null && requestTypeVal == SR_CATEGORY ) 
                             {
                                emailCase = utilCSEmailService.createCaseWithAccountContact(email, serviceReqRecordType, SR_CATEGORY, ORIGIN, iBUAccCounter==1?idBUAccId:contactWithAccountList[0].AccountId, contactWithAccountList[0].Id);//AB20160517 if BU Account present use BU Account otherwise original account
                             }
                    }
                }
           }   
           else
           {
           
               //SGDec2015 Added Logic to Check if there is one Active Parent Account for Multiple Sales Account then Create Case With Parent Account    
               if(ParentId.size() == 1  && Status == 'Active')  
               {
                  
                   isSuccess = emailCSDenialOfServiceHelper.getAssignedCaseDayLimit(contactWithAccountList[0].AccountId);
                   if (isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS) 
                   {
                       if(toEmailAddress != null && requestTypeVal == ORDER_CATEGORY )
                       {
                           
                           emailCase = utilCSEmailService.createCaseWithAccountContact(email, orderRecordType, ORDER_CATEGORY, ORIGIN, ParId, null);
                           
                       } 
                       else if(toEmailAddress != null && requestTypeVal == SR_CATEGORY)
                            {
                                emailCase = utilCSEmailService.createCaseWithAccountContact(email, serviceReqRecordType, SR_CATEGORY, ORIGIN, ParId, null); 
                            }
                   }
               }
               else
               {
                   isSuccess = emailCSDenialOfServiceHelper.getUnAssignedCaseDayLimit();
                   if(isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS )
                   {
                       if(toEmailAddress != null && requestTypeVal == ORDER_CATEGORY )
                       {
                           emailCase = utilCSEmailService.createCaseWithoutAccountContact(email, orderRecordType, ORDER_CATEGORY, ORIGIN);
                       }
                       else if(toEmailAddress != null && requestTypeVal == SR_CATEGORY )
                            {
                              emailCase = utilCSEmailService.createCaseWithoutAccountContact(email, serviceReqRecordType, SR_CATEGORY, ORIGIN);  
                            }
                   } 
                }
            }
            
                     
            if(emailCase != null){
                Database.DMLOptions dmlOpts= utilCSEmailService.invokeAssignmentRule();
                emailCase.Case_Source__c= CASE_SOURCE;
                system.debug('Region : ' + regionValue);  
                emailCase.CustomerServiceCenter__c = regionValue;              
                emailCase.setOptions(dmlOpts);
                Database.SaveResult saveResultOrder = Database.insert(emailCase, false);
                if (saveResultOrder.isSuccess()) {
                    // AA20151123 - Changes for adding attachment to email.
                    EmailMessage emailMsg = utilCSEmailService.attachEmail(email , emailCase);
                    if(emailMsg!=null)
                        utilCSEmailService.attachAttachments(email,emailMsg); 
                }
                if (saveResultOrder.isSuccess() && isSuccess == SUCCESS_EMAIL ){
                                                emailCSDenialOfServiceHelper.sendEmail(emailcase.id, senderEmailAddress, toAddress);
                }
            }
        result.success = true;
        
        }catch(Exception e){
            String er = e.getMessage();
            String name = 'Error in class : emailCSemailServiceHandler';
            String EmailSubject;         
            utilCSEmailService.CreateBatchMonitor(name,ErrorMsg,er,SenderEmailAddress,ToAddress,EmailSubject);
            
            System.debug('The following exception has occurred: ' + e.getMessage()+ errorMsg);
            result.success = false;result.message = errorMsg ;
        }
        return result;
    }
  }
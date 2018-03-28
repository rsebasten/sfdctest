/*******************************************************************************
 Copyright ? 2015 DuPont. All rights reserved.
 Author: Prerna Chandak
 Email: prerna.chandak@accenture.com
 Description: Email Service to handle cases through eFax. 

// AA20151123 - Changes for adding attachment to email.

********************************************************************************/
 global with sharing class emailCSeFaxServiceHandler implements Messaging.InboundEmailHandler {
     Private Static Final String ORDER_CATEGORY='New Order';
     Private Static Final String ORIGIN = 'Fax';
     Private Static Final String EMAIL_PRIORITY = 'Medium';
     Private Static Final String EMAIL_VAL = 'Email';
     Private Static Final String SUCCESS = 'success';
     private static Final string SUCCESS_EMAIL = 'success with email';
     Private Static Final String COMPARE_STRING = '@';
     private static final String CASE_SOURCE = 'Customer';        
     
    /* This method creates Cases based on the emails coming through eFax channel. */
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
     Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     Case emailCase = null; 
       String toEmailAddress = envelope.toAddress.substring(0,envelope.toAddress.indexOf(COMPARE_STRING));
         String senderEmailAddress = email.fromAddress;
         String emailsubject= email.subject;
         String errorMsg = Label.CS_ErrorMessage;
    try{      
        Id orderRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseOrderRecordType).getRecordTypeId();
         
         if(toEmailAddress != null && CS_EmailAddressSettings__c.getInstance() != null){        
            CS_EmailAddressSettings__c emailSettings = CS_EmailAddressSettings__c.getValues(toEmailAddress);
             String regionValue = emailSettings.CS_Region__c;
             system.debug('Region value....'+regionValue );
             Database.DMLOptions dmlOpts= utilCSEmailService.invokeAssignmentRule();
             String isSuccess = emailCSDenialOfServiceHelper.getUnAssignedCaseDayLimit();
             if(isSuccess == SUCCESS_EMAIL || isSuccess == SUCCESS ){
                
                 emailCase = utilCSEmailService.createCaseWithoutAccountContact(email, orderRecordType, ORDER_CATEGORY, ORIGIN);
                
             }
            
             if(emailCase != null){
                 emailCase.CustomerServiceCenter__c = regionValue;
                 emailCase.Priority = EMAIL_PRIORITY;
                 emailCase.Case_Source__c= CASE_SOURCE;             
                 emailCase.setOptions(dmlOpts);
                 system.debug('Case values....'+emailCase);
                 Database.SaveResult saveResultOrder = Database.insert(emailCase, false);
                 if (saveResultOrder.isSuccess()) {
                 // AA20151123 - Changes for adding attachment to email.
                    EmailMessage emailMsg = utilCSEmailService.attachEmail(email , emailCase);
                    if(emailMsg!=null)
                        utilCSEmailService.attachAttachments(email,emailMsg);  
                                
                       if (isSuccess == SUCCESS_EMAIL )
                        {
                            emailCSDenialOfServiceHelper.sendEmail(emailcase.id, senderEmailAddress,toEmailAddress );
                        }
                        
                       
                        
                   }  
                  /*<KV04062016>*/  else
                    {
                        for(Database.Error err : saveResultOrder.getErrors()) {
                        String er = err.getMessage();
                        String name = 'Error in class : emailCSeFaxServiceHandler';
                        
                        System.debug('The following error has occurred.');                   
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Emails fields that affected this error: ' + err.getFields());
                        utilCSEmailService.CreateBatchMonitor(name,ErrorMsg,er,SenderEmailAddress,toEmailAddress,emailsubject);
                        } /*<KV04062016>*/
                    }
                                
             }//end of if(emailCase != null)
                      
         } 
          result.success = true; 
                     
    }
     catch(Exception e){
           System.debug('The following exception has occurred: ' + e.getMessage()+ errorMsg);
        result.success = false;
        result.message = Label.CS_ErrorMessage + e.getMessage() ;
         
     }                      
    return result;
     }
 }
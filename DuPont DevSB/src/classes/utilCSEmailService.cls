/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: This is a helper class for email service handler class.

Change History:                                                                  Date:  
1. PC 08172015 - Added code to capture all Ccaddresses.                          8/17/2015  
2. PC 08192015 - Added code change to limit the length of Emailbody.             8/19/2015
3. AA 09012015 - Added Null Condition for HTML body and Plaintext body           9/01/2015 
4. VS 10212015 -- Methods Added "handleThreadEmail"                              10/21/2015  
                "getCaseRecordFromThreadId",to for handling thread emails.                    
                If CSR replies to an email which has thread id in it either subject or  email body and 
                while replying To address contains Work Ingestion email id for Order/Service Request
                /FAX/Internal request,reply email will get attach to the existing case record.
                In case User temper the thread id new case will be created in system as per
                 Send to email address.
                 
5. AA20151123 - Return type for the email changed to add attachments to email.
6. KV04062016 - Added CreateBatchMonitor method and limitations for EmailPlainTextbody
7. AA04052016 - Changed code to handle attachments for thread email.
8. KV05102016 - Changed code to convert plain text to HTML.
********************************************************************************/
public with sharing class utilCSEmailService{
    private static final String OBJECT_TYPE = 'Case';
    private static final String STATUS_VAL = '0';
    /* KV05102016 */  public static string bodyText = null; 
    /* KV05102016 */ public static  List<Case> extCaseRecord = new List<Case>();
    /* VS 10212015 -- this method will check if email subject or body contains thread id
    If yes it will call attachEmail method else method will return false and exit. */
    public static boolean handleThreadEmail(Messaging.InboundEmail email){
       // List<Case>  extCaseRecord= new List<Case>();
        if(email.subject != null && email.subject.contains('[ ref:') && email.subject.contains(':ref ]')){
            extCaseRecord = getCaseRecordFromThreadId(email.subject);
            if(extCaseRecord.isEmpty() && email.plainTextBody != null){
                extCaseRecord = getCaseRecordFromThreadId(email.plainTextBody);
            }
            if(!extCaseRecord.isEmpty()){
                System.debug('if case is ematy'+extCaseRecord);
                //AA04052016 - Changed code to handle attachments for thread email.
                EmailMessage emailMsg = utilCSEmailService.attachEmail(email,extCaseRecord[0]); 
                if(emailMsg!=null)
                    utilCSEmailService.attachAttachments(email,emailMsg);
                return true;
            }else{
                return false;
            }
        }else if (email.plainTextBody != null && email.plainTextBody.contains('ref:') && email.plainTextBody.contains(':ref') ){
            extCaseRecord = getCaseRecordFromThreadId(email.plainTextBody);
            if(!extCaseRecord.isEmpty()){
                //AA04052016 - Changed code to handle attachments for thread email.
                EmailMessage emailMsg = utilCSEmailService.attachEmail(email,extCaseRecord[0]); 
                if(emailMsg!=null)
                    utilCSEmailService.attachAttachments(email,emailMsg);
                return true;
            }else
                return false;
        }else{
            return false;
        }
    }
    
    /* VS 10212015 -- Method Added to for extracing the thread id from
     email's body and subject.Incase of valid thread id ,we retrieve associated 
    case record */
     Public static List<Case> getCaseRecordFromThreadId(string emailValue){
        //List<Case> extCaseRecord = new List<Case>();
        Id caseId;
        string threadid;
        /*Added specific check to handle scenario where CSR is replying to an email which contains temper thread id in its subject
        while reply Salesforce will add Valid Thread Id value again in subject.So the valid thread id parameters (ref:,:ref)will be at
        available at 2nd occurance .*/
        Integer startValueOfThread =emailValue.countMatches('ref:');
        Integer EndValueOfThread = emailValue.countMatches(':ref');

        if(startValueOfThread ==2 && EndValueOfThread ==2 )
        {
            threadid  = emailValue.substring(emailValue.lastindexOf('ref:'),emailValue.lastindexOf(':ref')+4);
        }else
        threadid  = emailValue.substring(emailValue.indexOf('ref:'),emailValue.indexOf(':ref')+4);
        
        //Returns the case ID corresponding to the specified email thread ID.
        try{
            caseId = Cases.getCaseIdFromEmailThreadId(threadid);
        }catch(Exception ex)
        {
            return extCaseRecord;
        }
        //Check if Case record exists with case Id
        if(caseId != null){
            extCaseRecord =[Select id from Case where Id=:caseId  limit 1];
            return extCaseRecord;
        }
    return extCaseRecord;
        
    }

    /*This will method will be used to create cases when Account and Contact doesn't exist in application for customer*/
    public static Case createCaseWithoutAccountContact(Messaging.InboundEmail email,String recTypeId,String category,String origin){
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
            Case emailToCase = new Case();
            try{
                /* AA 10142015 -- Method call for handling thread emails. ***/
                if(utilCSEmailService.handleThreadEmail(email)){
                    return null;
                }else{
               
                    emailToCase.Subject = email.Subject;
                    emailToCase.Origin = origin;
                    emailToCase.RecordTypeId = recTypeId;
                    emailToCase.CaseCategory__c= category;
                    emailToCase.SuppliedEmail = email.fromAddress;
                    
                  /*<NS05192016*/  String emailend1 = '\n\n' + '“Email exceeds the description length, please see the email attachment for additional text”.';
                   /*<NS05192016>*/   
               /* NS05192016 */ 
                if (string.isEmpty(email.plainTextBody)) 
                    bodyText = HtmlToText(email.htmlBody); 
                else 
                    bodyText = email.plainTextBody;  /* KV05102016 */ 
                    emailToCase.Description = bodyText.length() > 32000?(bodyText.substring(0,31900)+emailend1) :bodyText ; 
                   
                  /* emailToCase.Description = email.plainTextBody.length() > 32000?(email.plainTextBody.substring(0,31900)+emailend1) 

:email.plainTextBody;*/

                    
                    system.debug('emailToCase '+emailToCase);
                }
            }
            catch(Exception e){
                system.debug(Label.CS_ErrorMessage+e.getMessage());
                
            } 
            return emailToCase; 
    }
    /* KV05102016 */ 
    public static string HtmlToText(string html){ 
                   //replace all html tags
            /*KV01302016*/
                   string result = html.replaceAll('<[^>]+>',' ');
                 
                   System.debug('result '+result );
                   result = result.replace('table.with-border, table.with-border td,','');
                   System.debug('result '+result );
                   result = result.replace('table.with-border th { border-collapse: collapse; border: 1px solid black;','');
                   
                   System.debug('result '+result );
                   result = result.replace('&nbsp;','');
                   result = result.replace('border-collapse: collapse;','');
                   result = result.replace('border: 1px solid black;','');
                   result = result.replace('{','');
                   result = result.replace('}','');
                   result = result.replace('table.with-border td,','');
                   result = result.replace('table.with-border,','');
                   result = result.replace('table.with-border th','');
                   System.debug('result '+result );
                   return result ; 
           /*KV01302016*/
                
                }  
                
    /*This will method will be used to create cases when Account and Contact exists in application for customer*/
    public static Case createCaseWithAccountContact(Messaging.InboundEmail email,String recTypeId,String category,String origin,string accountId,string conatctId){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Case emailToCase = new Case();
        try{
            /* AA 10142015 -- Method call for handling thread emails. ***/
            if(utilCSEmailService.handleThreadEmail(email)){
                return null;
            }else{
                
                emailToCase.Subject = email.Subject; /*<KV04062016>*/  
                emailToCase.Origin = origin;
                emailToCase.RecordTypeId = recTypeId;
                emailToCase.CaseCategory__c = category;
                emailToCase.SuppliedEmail = email.fromAddress ;
                   
                emailToCase.AccountId = accountId;
                emailToCase.ContactId = conatctId;
                
                String emailend1 = '\n\n' + '“Email exceeds the description length, please see the email attachment for additional text”.';
               /*<KV04062016>*/   
               
                /*if (string.isEmpty(email.plainTextBody)) 
                   bodyText = (email.htmlBody); 
                else 
                   bodyText = email.plainTextBody; */
                    if (string.isEmpty(email.plainTextBody)) 
                    bodyText = HtmlToText(email.htmlBody); 
                else 
                    bodyText = email.plainTextBody;  
                
               
                emailToCase.Description = bodyText.length() > 32000?(bodyText.substring(0,31900)+emailend1) :bodyText ;                             
                
                system.debug('emailToCase '+emailToCase);
            }
        }catch(Exception e){
        
            system.debug(Label.CS_ErrorMessage+e.getMessage());
        } 
        return emailToCase; 
    }

    /*Description: This method will assign the current acive assignment rule to Case record */
    public static Database.DMLOptions invokeAssignmentRule(){
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    try{
        AssignmentRule assignmentRule = new AssignmentRule();
        assignmentRule = [select id from AssignmentRule where SobjectType =:OBJECT_TYPE  and Active = true limit 1];
        dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id;
    }
    catch(Exception e){
        system.debug(Label.CS_ErrorMessage+e.getMessage());
    }
    return dmlOpts;
    }  

    /* PC 08172015 - Added code to capture all Ccaddresses.  */
    public static String fetchAllAddresses(String[] attribute){
        String AddressToFill ;
        Integer index=0;
        for (string val :attribute)
        {    
            if(AddressToFill != null){
                AddressToFill = AddressToFill +';'+ attribute[index];
            }
            else
                AddressToFill = attribute[index];
                index++;
        }
        return AddressToFill;
    }
    
    /*Description: This method will attach the customer email request as attachment to the created case*/
    // AA20151123 - Return type for the email changed to add attachments to email.
    public static EmailMessage attachEmail(Messaging.InboundEmail email, Case emailCase){
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    try{
        
        /* PC 08192015 - Added code change to limit the length of Emailbody. */
        Integer fieldLength = Schema.SObjectType.EmailMessage.fields.HtmlBody.getLength();
        /* AA 09012015 -- Added Null Condition for HTML body and Plaintext body */
        String htmlBodyToFill = '';
        String plainTextbodyToFill='';
        if(email.htmlBody!=null)
            htmlBodyToFill = (Blob.valueOf(email.htmlBody).size()> fieldLength ? string.valueOf(email.htmlBody).substring(0,fieldLength):email.htmlBody);
        if(email.plainTextBody!=null)
            plainTextbodyToFill = (Blob.valueOf(email.plainTextBody).size()> fieldLength ? string.valueOf(email.plainTextBody).substring

(0,fieldLength):email.plainTextBody);
        
        String toAddressToFill;
        String ccAddressToFill ;
        String bccAddressToFill;
        
        if(email.toAddresses!= null){

           toAddressToFill = fetchAllAddresses(email.toAddresses);
          }  
      
        
        if(email.ccAddresses != null){
        
           ccAddressToFill = fetchAllAddresses(email.ccAddresses);
          }  
                
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = email.fromAddress,
        FromName = email.fromName,
        ToAddress = toAddressToFill,
        CcAddress = ccAddressToFill,
        Subject = email.subject,
        TextBody = plainTextbodyToFill ,
        HtmlBody = htmlBodyToFill,
        ParentId = emailCase.Id,
        Incoming= true, 
        Status = STATUS_VAL)); 
        
        Database.insert(newEmail);
        return newEmail[0];
       }
    catch(Exception e){
        system.debug(Label.CS_ErrorMessage+e.getMessage());
        return null;
        }  
    }

    /*Description: This method will get the attachment from the customer email request and will add the same as attachments
    --- to the created case*/
    public static void attachAttachments(Messaging.InboundEmail email, EmailMessage emailCase){
        /*<NS03082016 <NS03082016 Batch Monitoing when ever email attachment has been stripped from Email Message of Case>*/
        String senderEmailAddress = email.fromAddress;
        String toAddress = emailCase.toAddress;
        String errorMsg = Label.CS_ErrorMessage;
        Id caseid = emailCase.Parent.id ;
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try{
            List<Attachment> attList = new List<Attachment>();
            // This will extract all blob attachments from email
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0)
            {     
                for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments) 
                {
                    Attachment attachment = new Attachment(); 
                    attachment.Name = file.fileName;
                    attachment.Body = file.body;
                    attachment.ParentId = emailCase.id;
                    attList.add(attachment);
                }
            } 
            if (email.textAttachments!= null && email.textAttachments.size() > 0){
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) 
                {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = emailCase.id;
                    attList.add(attachment);
                }
            }
            if(!attList.isEmpty())
            {
                Database.insert(attList);
            }
        }
        catch(Exception e){
            system.debug(Label.CS_ErrorMessage+e.getMessage());
            /*<NS03082016 Batch Monitoing when ever email attachment has been stripped from Email Message of Case>*/
            //emailCSDenialOfServiceHelper.sendEmail(caseid , senderEmailAddress, toAddress );
            CreateBatchMonitor('CSAttachmentFailure',Label.CS_ErrorMessage+e.getMessage(),'Exception',senderEmailAddress ,toAddress,'Email Attachment failure');
        }  
    }
     /*<KV04062016> Added for Creating record in Batch Monitor object in case of email exception*/ 
   /*<KV04062016>*/ public static void CreateBatchMonitor(String name,String ErrorMsg,String Except,String SenderEmailAddress,String ToAddress,String EmailSubject){
    try
    {
         Batch_Monitor__c bm=new Batch_Monitor__c();
         bm.name=name;
         bm.Batch_Job_Error__c= errorMsg.length()>255?errorMsg.substring(0, 254):errorMsg;
         bm.Status__c='Exception';
         bm.Description__c='SenderEmailAddress : '+senderEmailAddress+' ToAddress : '+toAddress+' Subject :  '+ EmailSubject +' @ '+system.now() +' Exception : ';
         bm.Description__c+= Except.length()>32768?Except.substring(0, 32767):Except;
            
         insert bm;
     }
     catch(Exception e)
     {
         system.debug(' ErrorMessage : ' +e.getMessage());
     }  
    
    }     
    
}
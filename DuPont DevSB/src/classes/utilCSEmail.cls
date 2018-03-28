/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * ?¯¯??¯¯(??)¯¯??¯¯’
 * Change history (key updates):
 * 4th April, 2015 -> created the class
 * 26th May, 2015 -> removed the NULL from FirstName
**/
public with sharing class utilCSEmail{
    private static final String INITIAL_VAL = '';
    private static final String SENDERDISPLAYNAME = 'Customer Service batch - Automation';
    private static final String SUBJECT = 'Result of ApexBatch class ';
    private static final String SALUTATION = '<p>This log is related to the job scheduled by  ';
    private static final String HTMLBDY = '</p><p>This is a receipt of <b>Batch Logs</b>.</p>'+
        '<div style="float:left; clear:both;margin-bottom:1.5rem;padding-left:4rem;font-weight:bold;">'+
        '    <div style="float:left;margin-top:0.25rem;border:2.5px outset #262221;font-weight:normal;text-align:center;">'+
        '        <div style="display:inline;float:left; clear:both;">'+
        '            <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
        '                Initial Batch Status'+
        '            </div>'+
        '        </div>'+
        '        <div style="display:inline;float:left; clear:both;">';
    private static final String ERRORBODY_1 = '            <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
            '                <b style="color: red">(Errors)</b>&nbsp; Number of errors occured: <b style="color: red">';
    
    private static final String ERRORBODY_2 = '</b> Please find attached the error logs.'+
            '                <br/><br/>'+
            '            </div>';
    private static final String ERROREDOUTBODY = '            <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
            '                <b style="color: red">(Errors)</b>&nbsp; <ERRORPLACEHOLDER>'+
            '                <br/><br/>'+
            '            </div>';
    private static final String NOTERROREDOUTBODY = '            <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
            '                <b style="color: green;">(Success)</b>&nbsp; All the records from batch are successfully processed.'+
            '                <br/><br/>'+
            '            </div>';
    private static final String SIGNATURE = '        </div><br/><br/>'+
            '    </div><br/><br/>'+
            '</div><br/>            '+
            '<p>Sincerely,</p>'+
            '<p>SFDC OneDuPont Team.</p>';
    
    private static final String TABSPACE = '\t\t\t\t\t\t\t\t\t                                           ';
    private static final String FILENAME = 'BatchErrorLog.txt';
    private static final String USER = 'User: ';
    private static final String SPACE = ' ';
    private static final String LINEBREAK = '\n';
    private static final String TAB = '\t';
    private static final String REFTIME = 'Reference Time: ';
    private static final String DASHES = '-----------------------------------------------------------------------------------------------------------------------------';
    private static final String ERPCUSTINSERTS = 'ERP Customer Inserts:';
    private static final String ERPCUSTUPDATES = 'ERP Customer Updates:';
    private static final String ERRHEADERS = 'ERP Customer ID\tError Message';
    private static final String FAILDESC = 'Description of records Failed';
    private static final String COMMONREASON = 'The records are failed due to the following common reasons:';
    private static final String SEMICOLON = ';';
    private static final String COMMA = ',';
    private static final String ERRORPLACEHOLDER = '<ERRORPLACEHOLDER>';
    private static final List<String> PLACEHOLDER = new List<String>{
        'There got some Apex related error while processing the batch.',
        'There are no records existing in Database for this batch.'
    };

    /**
     * This method will create body of the template to be sent as email.
     * @author sanchit.dua
     * @param batchErrorLog - the instance containing the error messages if any
     * @param batchClassName - batch class name
     * @param erroredOut - if its true then error template otherwise success is shown in the email body
     */
    public static void finishEmail(utilCSBatchErrorLog batchErrorLog, String batchClassName, boolean erroredOut){
        Messaging.SingleEmailMessage receiptMessage=new Messaging.SingleEmailMessage();
        List<String> sendToList = new List<String>();
        String userEmail = UserInfo.getUserEmail() != NULL ? UserInfo.getUserEmail() : INITIAL_VAL;
        
        try{
            CS_Account_Load_Settings__c accountLoad = CS_Account_Load_Settings__c.getall().values()[0];
            
            if(!String.isEmpty(accountLoad.SendErrorNotificationTo__c))
            sendToList.addAll(accountLoad.SendErrorNotificationTo__c.split(SEMICOLON));
            sendToList.add(userEmail);
            receiptMessage.setToAddresses(sendToList);
            receiptMessage.setSenderDisplayName(SENDERDISPLAYNAME); 
            receiptMessage.setSubject(SUBJECT+batchClassName);
            receiptMessage.setUseSignature(false);
            // HTML body
            String htmlBody = SALUTATION; 
            String firstName = UserInfo.getFirstName() != NULL ? UserInfo.getFirstName() : INITIAL_VAL;
            String lastName = UserInfo.getLastName() != NULL ? UserInfo.getLastName() : INITIAL_VAL;
            htmlBody = htmlBody + firstName + lastName + COMMA + HTMLBDY;
            if( erroredOut == NULL )
                htmlBody = htmlBody + ERROREDOUTBODY.replace(ERRORPLACEHOLDER, PLACEHOLDER.get(1));
            else if(!batchErrorLog.erpIdWithMsg.isEmpty() || !batchErrorLog.erpIds.isEmpty() || !batchErrorLog.commonMessages.isEmpty()) 
                htmlBody = htmlBody + ERRORBODY_1 +(batchErrorLog.erpIdWithMsg.size() + batchErrorLog.erpIds.size())+ERRORBODY_2;
            else if(erroredOut)
                htmlBody = htmlBody + ERROREDOUTBODY.replace(ERRORPLACEHOLDER, PLACEHOLDER.get(0));
            else if(!erroredOut)
                htmlBody = htmlBody + NOTERROREDOUTBODY;
            
            htmlBody = htmlBody + SIGNATURE;
            receiptMessage.setHtmlBody(htmlBody);                           
           
            if(!batchErrorLog.erpIdWithMsg.isEmpty() || !batchErrorLog.erpIds.isEmpty() || !batchErrorLog.commonMessages.isEmpty()) { 
                List<Messaging.EmailFileAttachment> emailFileAttachements = new List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                String attachmentData = INITIAL_VAL;
                attachmentData = utilCSEmail.constructEmailInformation(batchErrorLog);
                attachment.setBody(Blob.valueOf(attachmentData));
                attachment.setFileName(FILENAME);
                attachment.setInline(false);
                emailFileAttachements.add(attachment);
                receiptMessage.setFileAttachments(emailFileAttachements);
            }
            
            Messaging.sendEmail(new list<Messaging.Email>{receiptMessage});
        }
        catch(Exception e){
            system.debug(Label.CS_ErrorMessage+e.getMessage());
        } 
    }//END 
    
    /**
     * @param utilCSBatchErrorLog
     *                          The utilCSBatchErrorLog reference containing all the details about Errors occured along with the reason for the records failed
     * @return
     *          The String representing all the DuPont-Email itself
     */
    private static String constructEmailInformation(utilCSBatchErrorLog batcherrorLog) { 
        // Consolidated Map is constructed here if its necessary
       
        if( !batchErrorLog.erpIds.isEmpty() ){
            List<String> commonMessages = new List<String>(batchErrorLog.commonMessages);
            Integer listLimit = commonMessages.size()-1;
            Integer counter = 0;
            
            for(Id erpId: batchErrorLog.erpIds){
                if(counter <= listLimit){
                    batchErrorLog.consolidatedMsgs.add(new utilCSBatchErrorLog.insertReporter(String.valueOf(erpId), commonMessages.get(counter)));
                }else{
                    batchErrorLog.consolidatedMsgs.add(new utilCSBatchErrorLog.insertReporter(String.valueOf(erpId), INITIAL_VAL));
                }
                counter++;
            }
        }
        String textEmailInformation = INITIAL_VAL;
        textEmailInformation = textEmailInformation +TABSPACE+USER+UserInfo.getFirstName()+SPACE+UserInfo.getLastName()+LINEBREAK;
        textEmailInformation = textEmailInformation + TABSPACE +REFTIME+ DateTime.now();
        // TODO
        textEmailInformation = textEmailInformation + LINEBREAK;
        textEmailInformation = textEmailInformation + DASHES;
        textEmailInformation = textEmailInformation + LINEBREAK+LINEBREAK;
        
        textEmailInformation = textEmailInformation + FAILDESC +LINEBREAK;
        
        
        textEmailInformation = textEmailInformation + LINEBREAK+TAB+COMMONREASON+LINEBREAK+LINEBREAK;
        if( !batchErrorLog.erpIdWithMsg.isEmpty() ) {
                
            textEmailInformation = textEmailInformation + TAB+ERPCUSTUPDATES+LINEBREAK;
            textEmailInformation = textEmailInformation + TAB+TAB+ERRHEADERS+LINEBREAK;
            
            for(String key: batchErrorLog.erpIdWithMsg.keySet()){
                textEmailInformation = textEmailInformation + TAB+TAB +key+TAB+batchErrorLog.erpIdWithMsg.get(key)+LINEBREAK;
            }
            textEmailInformation = textEmailInformation + LINEBREAK;
            
            if( !batchErrorLog.consolidatedMsgs.isEmpty() ) {
                textEmailInformation = textEmailInformation + TAB+ERPCUSTINSERTS+LINEBREAK;
                textEmailInformation = textEmailInformation + TAB+TAB+ERRHEADERS+LINEBREAK;
                
                for(utilCSBatchErrorLog.InsertReporter wrapperRef: batchErrorLog.consolidatedMsgs){
                    textEmailInformation = textEmailInformation + TAB+TAB+wrapperRef.erpId+SPACE+TAB+SPACE+wrapperRef.errMsg+LINEBREAK;
                }
            }
            
        } else if( !batchErrorLog.consolidatedMsgs.isEmpty() ) {
            textEmailInformation = textEmailInformation + TAB+ERPCUSTINSERTS+LINEBREAK;
            textEmailInformation = textEmailInformation + TAB+TAB+ERRHEADERS+LINEBREAK;
            
            for(utilCSBatchErrorLog.InsertReporter wrapperRef: batchErrorLog.consolidatedMsgs)
                textEmailInformation = textEmailInformation + TAB+TAB+wrapperRef.erpId+TAB+wrapperRef.errMsg+LINEBREAK;
        }
        
        return textEmailInformation;
    } // END private static String constructEmailInformation(utilCSBatchErrorLog batcherrorLog)
}
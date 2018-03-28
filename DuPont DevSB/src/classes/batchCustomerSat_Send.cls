/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to send the Customer List to CustomerSAT (markettools.com)

********************************************************************************/
global class batchCustomerSat_Send implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.stateful {
    
    global final string FILE_PREFIX = UserInfo.getUserId()+DateTime.now().formatGmt('yyyyMMddHHmm');
    global final string query;
    global MAP<string,string> results = new MAP<string,string>();
    global integer batchNo=1;
    global string surveyId;
       
    
    global batchCustomerSat_Send(string aSurveyId, String q){
        surveyId=aSurveyId;
        Query=q;
        }
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
        }
        
    global void execute(Database.BatchableContext BC, LIST<SObject> scope){
        
        LIST<CustomerLoyaltySurvey__c> CLSs = (LIST<CustomerLoyaltySurvey__c>) scope;
        system.debug('-----CLS records:' + CLSs.size());
        CustomerSat.SampleData sd = new CustomerSat.SampleData(surveyId, CLSs);
        system.debug('-----sampleRows:' + sd.sampleRows.size());
        //sd.AddTestEmail();
        string filespec = FILE_PREFIX+'__'+String.valueOf(batchNo);
       
       
        string FileID;
        if (! Test.isRunningTest()) {
            HttpResponse resp = sd.Send(filespec);
            FileID=resp.getHeader('ImportedFileID');
        }
        if (FileID==null) FileID='Unsuccessful';
        
        results.put(filespec,FileID);
        
        //TODO: Write to scope the sent batch, timestamp, and FileId.
        //BatchStatus, LastBatchStatusDate, BatchId
        for (CustomerLoyaltySurvey__c CLS : CLSs) {
            CLS.SYS_SurveyId__c = surveyId;
            CLS.SYS_LastUploadDate__c = DateTime.Now();
            CLS.SYS_UploadFileName__c = filespec;
            CLS.SYS_UploadResponse__c = FileID;
        }
        
        ///* UN---DEBUG THIS
        update CLSs;
        //*/

        /*
        //START DEBUG: Send payload to Me via email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'thomas.snyder@usa.dupont.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('CustomerSat.Send_SampleData Payload');
        
        Messaging.EmailFileAttachment tAtt = new Messaging.EmailFileAttachment();
        tAtt.fileName = 'SFDC Payload to CSAT';
        tAtt.setBody(Blob.valueOf(sd.ToXml()));
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {tAtt});
        mail.setPlainTextBody('payload sent:\n\n');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //END DEBUG
        */
        
        batchNo++;
        
        

        
    }
    

    
    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            From AsyncApexJob where Id =:BC.getJobId()
                            ];
        
        
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('CustomerSat.Send_SampleData ' + a.Status);
        
        string s = 'The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.\n\n';
        s+='FileName                          \tFileID\n';
        s+='----------------------------------\t------\n';
        for (string fn : results.keyset())
            s+=fn+'\t'+results.get(fn)+'\n';
        mail.setPlainTextBody(s);

        //Workaround to run test class coverage when deliverability is off
        if (!Test.isRunningTest()) 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    
    
    
    }

}
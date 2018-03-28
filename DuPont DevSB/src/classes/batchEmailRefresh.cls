/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved.    
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to batchEmailRefresh
Database.executeBatch(new batchEmailRefresh(),200);

Loop through all the emails records a recalc Totals and set Lead/Contact to lastMod
<20170913:Santhosh Kumar> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
<20171015:Santhosh Kumar> : Modified the code to reduce the emails records in the scope based on the Lastmodifieddate condition.
<20171130:Santhosh Kumar> : Modified the code to fix the issues (Aggregate query has too many rows for direct assignment, use FOR loop & Too many DML query rows:10001)
*************************************************************************************************************************************************************************/
global class batchEmailRefresh implements Database.Batchable<sobject> , Database.Stateful{ 
    global DmlResults unsuccessfuls;
    //<20171015:Santhosh Kumar> : Satrt
    string jobEndtime ;
    DateTime dateTimeFormatval = system.today(); 
    list<Email__c> lstEmails = new list<Email__c>();
    boolean isBatchScheduled = false;
    global batchEmailRefresh() {
          Integer batchRecCount = [select count() from AsyncApexJob where ApexClass.name ='batchEmailRefresh'];
          if(batchRecCount>0){
          isBatchScheduled = true;
          dateTimeFormatval  = [select Id,ApexClass.name, CreatedDate,CompletedDate,JobType, LastProcessed, MethodName, ParentJobId, Status from AsyncApexJob where ApexClass.name ='batchEmailRefresh' order by CompletedDate desc limit 1].CompletedDate;
      }
      
      //<20171015:Santhosh Kumar> : End
        unsuccessfuls = new DmlResults(); 
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //<20171015:Santhosh Kumar> : Start
        if(!isBatchScheduled){
          dateTimeFormatval = [select Id,ApexClass.name, CreatedDate,CompletedDate,JobType, LastProcessed, MethodName, ParentJobId, Status from AsyncApexJob where Id =: BC.getJobId() order by CompletedDate desc limit 1].CreatedDate; 
        }
        jobEndtime = dateTimeFormatval.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //<20171130:Santhosh Kumar> : Start
        string query = 'Select Id FROM Email__c where LastModifiedBy.name!=\'BatchSFDC Deployuser\' and lastmodifieddate >='+ jobEndtime;
        //<20171130:Santhosh Kumar> : End
        //<20171015:Santhosh Kumar> : End
         
        if (Test.isRunningTest())
                query+=' LIMIT 200';
        return Database.getQueryLocator(query);     
    }
        
    global void execute(Database.BatchableContext BC, LIST<sobject> scope) {
    
        //<20171015:Santhosh Kumar> : Start
        //<20171130:Santhosh Kumar> : Start
        lstEmails = new list<Email__c>();
        LIST<Email__c> emailRec = new LIST<Email__c>([Select Id, TotalContacts__c, TotalLeads__c,Contact__c, Lead__c, 
                                                    (Select Id from Contacts__r order by lastModifiedDate desc), 
                                                    (Select Id from Leads__r order by lastModifiedDate desc)
                                                    FROM Email__c where id in: scope ]);    
            for (Email__c e : emailRec) {                                       
            e.TotalLeads__c=e .Leads__r.size();
                e .TotalContacts__c=e .Contacts__r.size();
                if (e.Leads__r.size()>0)
                    e.Lead__c=e .Leads__r[0].id;
                else
                    e .Lead__c=null;
                if (e .Contacts__r.size()>0)  
                    e .Contact__c=e .Contacts__r[0].id; 
                else
                    e .Contact__c=null;
            
            lstEmails.add(e);
        }
         //<20171130:Santhosh Kumar> : End
        unsuccessfuls.add(DmlResults.dmlUpdate(lstEmails,false)); 
        //<20171015:Santhosh Kumar> : End
    }
    

    
    global void finish(Database.BatchableContext BC) {
    //<20170913:Santhosh Kumar> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
       // utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
    //<20170913:Santhosh Kumar> : End
    }

}
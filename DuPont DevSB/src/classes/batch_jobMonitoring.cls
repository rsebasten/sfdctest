/*****************************************************************************
Author: Rohit saini
Email: rohitkumar.saini@tcs.com
Date: 1/19/2016
Description: class to monitor job failures, to create batch monitor object record and to create issue for batch failure.
@version  1.0

<VL20160920>
Last Modified By    :   Vijay Laxmi
Last Modified Date  :   20 Sep 2016
Description         :   Adding a field name (SFDC_Instance__c) to batch monitor object 

********************************************************************************/


global class batch_jobMonitoring implements Schedulable, Database.Batchable<sObject> {
    public static final Integer batchJobSize=2;
    public static final string sfdcInstance=label.Current_Org_SFDC_Instance; //'One DuPont Corporate';
    public static final string RTYPE_ISSUE = Rtype.getIdByDevName('Issue__c','DuPont Administration');
    public static final Id systemAdminId=[select id, name from user where name ='BatchSFDC DeployUser' limit 1].id;
   public static final Id sfdcAdminQueueId=[select id, DeveloperName from group where DeveloperName = 'SFDCAdminSupport' limit 1].id;
    global void execute(SchedulableContext SC) {
          Id batchJobId = Database.executeBatch(new batch_jobMonitoring(), batchJobSize);
        }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        DateTime lastRun=system.now()-7;
        List<Batch_Monitor__c> lstExistingbatchMonitor= [select id, name, createdDate from Batch_Monitor__c order by createdDate desc];
        if(lstExistingbatchMonitor!=null && lstExistingbatchMonitor.size()>0){
            lastRun=lstExistingbatchMonitor.get(0).createdDate;
        }
        //system.debug('lastRun::'+lastRun);
        String queryString='select id, TotalJobItems, status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, ExtendedStatus, CompletedDate,'+
            'ApexClassID,ApexClass.Name from asyncApexjob where (status=\'failed\' or ExtendedStatus!=null or NumberOfErrors>0 ) and CompletedDate > :lastRun and JobType in (\'BatchApex\', \'ScheduledApex\')';
        if(Test.isrunningTest()){
           queryString='select id, TotalJobItems, status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, ExtendedStatus, CompletedDate,'+
            'ApexClassID, ApexClass.Name from asyncApexjob limit 2';
       }
       return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext BC, List<sObject> Scope){
        List<AsyncApexjob> failedjobs=(List<AsyncApexjob>)Scope;
        List<Batch_Monitor__c> lstNewbatchMonitor=new  List<Batch_Monitor__c>();
        for(AsyncApexjob job: failedjobs){
            lstNewbatchMonitor.add(createBatchMonitor(job));
        }
        insert lstNewbatchMonitor;
        
        /*
            Map<Issue__c, Batch_Monitor__c> issueBMMap= createIssues(lstNewbatchMonitor);
           if(issueBMMap!=null && issueBMMap.Keyset()!=null && issueBMMap.Keyset().size()>0){
          Map<string, Batch_Monitor__c> IssuestringBMMap= new Map<string, Batch_Monitor__c>() ;
           for(Issue__c issue: issueBMMap.keySet()){
            IssuestringBMMap.put(issue.name+issue.Description__c, issueBMMap.get(issue));  
           }
            List <Issue__c> listIssues=new List<Issue__c>();
            listIssues.addAll(issueBMMap.Keyset());
           insert listIssues;
      
           for(Issue__c issue: listIssues){
             IssuestringBMMap.get(issue.name+issue.Description__c).related_issue__c=issue.id;
         }
         update  IssuestringBMMap.values();

        }*/
        
    }
    public void finish(Database.BatchableContext BC){
        
     }
   
    Batch_Monitor__c createBatchMonitor(AsyncApexjob job){
        Batch_Monitor__c bm=new Batch_Monitor__c();
        bm.name='Error in ';
        if(job.ApexClass.name!=null){
           bm.name+='class: '+job.ApexClass.name; 
        }
        if(job.MethodName!=null){
           bm.name+=' method name: '+job.MethodName; 
        }
        bm.name=(bm.name.length()>80?bm.name.substring(0,79): bm.name);
                
        if(job.ExtendedStatus!=null){
            bm.Batch_Job_Error__c=(job.ExtendedStatus.length()>255?job.ExtendedStatus.substring(0,254): job.ExtendedStatus);
        }
        
        if(job.Id!=null){
            bm.AsyncApexJob_Id__c=job.Id;
        }
        
        bm.Status__c=job.status;
          //<Start> <VL20160920>
        bm.SFDC_Instance__c=sfdcInstance;
        //<End> <VL20160920>
        bm.Description__c='method name: '+job.MethodName+
            ',\r\n class name: '+ job.ApexClass.name+
            ',\r\n TotalJobItems:'+job.TotalJobItems+
            ',\r\n JobItemsProcessed:'+job.JobItemsProcessed+
            ',\r\n NumberOfErrors:'+job.NumberOfErrors+
            ',\r\n JobType:'+job.JobType+
            ',\r\n CompletedDate:'+job.CompletedDate+
            ',\r\n Exception: '+ job.ExtendedStatus;
        bm.Description__c=bm.Description__c.length()>32768?bm.Description__c.substring(0, 32767):bm.Description__c;
          return bm;
          
    }
    
  /*Map<Issue__c, Batch_Monitor__c> createIssues( List<Batch_Monitor__c> lstNewbatchMonitor){
    List<String> lstSubjects=new List<String>();
      for(Batch_Monitor__c bm: lstNewbatchMonitor){
          string s='Batch Job Failure ';
          if(bm.name!=null){
              s+=bm.name;
              s=(s.length()>80?s.substring(0, 79):s);
              
             system.debug('s::'+s);

              lstSubjects.add(s);
          }
      }
         
      List<Issue__c> existingIssues=[select id, name from issue__c where name in :lstSubjects and status__c!='Completed'];
      Set<String> setSubject=new Set<String> ();
      for(Issue__c issue: existingIssues){
          setSubject.add(issue.name);
          system.debug('::'+issue.name);

      }
      List<Batch_Monitor__c> toProcess=new List<Batch_Monitor__c>();
      for(Batch_Monitor__c bm: lstNewbatchMonitor){
          string issueName='Batch Job Failure '+bm.name;
          system.debug('issueName'+issueName);
          if(!setSubject.contains(issueName.length()>80?issueName.substring(0, 79):issueName)){
              toProcess.add(bm);
              system.debug('issueName'+issueName);
          }
      }
     
      Map<Issue__c, Batch_Monitor__c> issueToBatchMonitorMap=new Map<Issue__c, Batch_Monitor__c>();
        for(Batch_Monitor__c bm: toProcess){
          issueToBatchMonitorMap.put(createIssue(bm), bm); 
        }
        return issueToBatchMonitorMap;
    }
    
      Issue__c createIssue(Batch_Monitor__c bm){
    Issue__c issue = new Issue__c();
    issue.SFDC_Instance__c=sfdcInstance;
    issue.Type__c='Other';
    issue.Classification__c= 'Correct (Break/Fix)'; 
    issue.Status__c='Not started';
    issue.RecordTypeId=RTYPE_ISSUE;
    issue.Severity__c='Medium';
    issue.Application__c='CRM(Standard functionality)';
    issue.Name='Batch Job Failure ';
    if(bm.name!=null){
      issue.Name+=bm.name;
    }
    issue.Name=(issue.Name.length()>80?issue.Name.substring(0, 79):issue.Name);
    issue.Description__c=bm.Description__c+'\r\n\r\n Batch monitor record id:'+bm.Id;
    issue.Submitted_By__c=systemAdminId;
    issue.Submitted_DateTime__c=Date.Today();
    issue.ownerid=sfdcAdminQueueId;  
    return issue;  
      
    }*/
    
    
}
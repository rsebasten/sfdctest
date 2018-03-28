/*****************************************************************************
Author: Vijay Laxmi
Email: vijay.laxmi1@tcs.com
Date: 9/14/2016
Description: Class to create issue after batchMonitor record creation for batch failure.
@version  1.0

********************************************************************************/

public class trig_AutoCreateIssueHandler{


    public static final Integer batchJobSize=2;
    public static final string sfdcInstance= Label.Current_Org_SFDC_Instance;               //'One DuPont Corporate';
    public static final string RTYPE_ISSUE = Rtype.getIdByDevName('Issue__c','DuPont Administration');
    public static final string RTYPE_ISSUE_Utility = Rtype.getIdByDevName('Issue__c','Price Approval');
    public static final Id systemAdminId=[select id, name from user where name ='BatchSFDC DeployUser' limit 1].id;
    public static final Id sfdcAdminQueueId=[select id, DeveloperName from group where DeveloperName = 'SFDCAdminSupport' limit 1].id;
    public static final Id sfdcUtilityQueueId=[select id, DeveloperName from group where DeveloperName = 'SFDC_Utility_Support_Queue' limit 1].id;
//SFDC Utility Support Queue
/*    

public void OnAfterInsert(Batch_Monitor__c[] newRecords){    

List<Issue__c > Childs = new List<Issue__c >();
    
     List<Issue__c> existingIssues=[select id, name from issue__c where (status__c!='Completed' and Submitted_By__c=:systemAdminId)];
      Set<String> setSubject=new Set<String> ();
      for(Issue__c issue: existingIssues)
      {
          setSubject.add(issue.name);
          system.debug('::'+issue.name);

      }
      
      List<Batch_Monitor__c> toProcess=new List<Batch_Monitor__c>();
    
      for(Batch_Monitor__c bm: newRecords)
      {
          string issueName='Batch Job Failure '+bm.name;
          system.debug('issueName'+issueName);
          if(!setSubject.contains(issueName.length()>80?issueName.substring(0, 79):issueName))
          {
              toProcess.add(bm);
              system.debug('issueName'+issueName);
          }
      }
      
   
Map<Issue__c, Batch_Monitor__c> issueToBatchMonitorMap=new Map<Issue__c, Batch_Monitor__c>();
        for(Batch_Monitor__c bm: toProcess){
            system.debug('In Create issues'+ bm);
     
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

Childs.add(issue);


system.debug('I have got the child'+Childs);
      
    }        
          
          
          
     system.debug('************insertingIssue'+Childs); 

    insert Childs;
    
    system.debug('@@@@@@@@'+Childs);
    
  }

*/

public void OnAfterInsert(Batch_Monitor__c[] newRecords){   
 
 
 List<Issue__c > issueList = new List<Issue__c >();
 for(Batch_Monitor__c bm : newRecords)
    {
        
  
    Issue__c issue = new Issue__c();
    
    
    issue.SFDC_Instance__c=bm.SFDC_Instance__c;
    issue.Type__c='Other';
    issue.Classification__c= 'Correct (Break/Fix)'; 
    issue.Status__c='Not started';
    
    issue.Severity__c='Medium';
    issue.Name='Batch Job Failure ';
    if(bm.name!=null){
        issue.Name+=bm.name;
    }
    issue.Name=(issue.Name.length()>80?issue.Name.substring(0, 79):issue.Name);
    issue.Description__c=bm.Description__c+'\r\n\r\n Batch monitor record id:'+bm.Id;
    issue.Submitted_By__c=systemAdminId;
    issue.Submitted_DateTime__c=Date.Today();
    if(bm.SFDC_Instance__c==Label.Current_Org_SFDC_Instance) //'One DuPont Corporate'
    {
    issue.Application__c='CRM (Standard functionality)';
    //issue.ownerid=sfdcAdminQueueId;
    issue.RecordTypeId=RTYPE_ISSUE;
    }
    else
    
    {
        issue.Application__c='Price Approval';
        //issue.ownerid=sfdcUtilityQueueId;
        issue.RecordTypeId=RTYPE_ISSUE_Utility;
    }
    
        issueList.add(issue);
    
    }

    insert issueList;
    
    List<Issue__c> issuesToUpdate =new List<Issue__c> ();
    
    for(Issue__c issue :issueList ){
        if(issue.SFDC_Instance__c==Label.Current_Org_SFDC_Instance){ //'One DuPont Corporate'
            issue.ownerid=sfdcAdminQueueId;
        }
        else
        {
            issue.ownerid=sfdcUtilityQueueId;
        }
        issuesToUpdate.add(issue);
    
    }
    update issuesToUpdate;
    system.debug('@@@@@@@@'+issueList);
}

}
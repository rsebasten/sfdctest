public class ctrlEmailTaskDetails{
    public string XactivityId;
    public Task task{get;set;}
    public Case casedetails{get;set;}
    public String fullRecordURL{get;set;}
    public string activityId{
       get{return XactivityId;}
       set{
            XactivityId = value;
            task = [Select subject,Id,Status,SubType__c,ActivityDate,Completion_Date__c,whatId,Owner.Name from task where Id = :XactivityId];
            casedetails = [select CaseNumber from Case where Id =:task.WhatId];
            fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
          }
      }
}
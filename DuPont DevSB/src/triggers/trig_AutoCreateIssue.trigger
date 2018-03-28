/****************************************************************************
Author: Vijay Laxmi
Email: vijay.laxmi1@tcs.com
Date: 9/14/2016
Description: Trigger to create issue after batchMonitor record creation for batch failure.
@version  1.0

********************************************************************************/

trigger  trig_AutoCreateIssue on Batch_Monitor__c (after insert) 
    {
    
        trig_AutoCreateIssueHandler issueHandler = new trig_AutoCreateIssueHandler();
        if(Trigger.isInsert && Trigger.isAfter)
        {
            issueHandler.OnAfterInsert(Trigger.new);
             
        }  
    }
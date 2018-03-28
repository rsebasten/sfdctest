/***************************************************
Copyright @ 2010 DuPont. All rights reserved.
Author:Smita Kadian/Divya Ramakrishnaiah
Email:Smita.Kadian@usa.dupont.com/
      Divya.Ramakrishnaiah@usa.dupont.com
Date:08 June 2011
Description:Batch class to perform the deletion of the 'Group Report 
            Result', child object records, inserted in the previous run of the user.
****************************************************/
global class batchGroupDelete implements Database.Batchable<sObject>{
	public Id loggedInUserId{get;set;}
	public List<String> batchRecordDelete = new List<String>();
	String userMail1;
	public boolean startException = false;
	public boolean executeException = false;
	//Constructor
	global batchGroupDelete(Id aLoggedInUserId,LIst<Group_Report__c> groupReportList,String userMail){
		loggedInUserId=aLoggedInUserId;
		for(Group_Report__c g :groupReportList)
			batchRecordDelete.add(g.Id);
		userMail1=userMail;
	}
	//This method executes once at the beginning. It executes the above query and dispatches it in batches to the execute method.
	global Database.QueryLocator start(Database.BatchableContext BC){
		try{
			return Database.getQueryLocator('Select id from Group_Report_Result__c where CreatedById=:loggedInUserId and Group_Report__c IN : batchRecordDelete');
		}
		catch(Exception e){
			startException=true;
			Database.QueryLocator scope = Database.getQueryLocator('Select Id from Group_Report_Result__c where name=\'ser3m@#$%#$#@chw*^e223\'');
			return scope;
		}
	}

	global void execute(Database.BatchableContext BC, List<sObject>  scope){
		try{
			Set<Id> groupResultIdSet=new Set<Id>();
			for(SObject s : scope){
				Group_Report_Result__c g=(Group_Report_Result__c)s;
				groupResultIdSet.add(g.id);
			}
			List<Group_Report_Result__c> groupResultToDeleteList= new List<Group_Report_Result__c>();
			groupResultToDeleteList=[Select g.id from Group_Report_Result__c g where g.Id IN :groupResultIdSet];
			if(groupResultToDeleteList.size()!=0){
				delete groupResultToDeleteList;
			}
		}
		catch(Exception e){
			executeException=true;
		}
	}
	
	//A method called at the end of the entire processing.
	global void finish(Database.BatchableContext BC){
		if(startException==true || executeException ==true){			
			User loggedInUserDetail = [SELECT id, email FROM User WHERE id = :loggedInUserId];
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
			String[] toAddresses = new String[] {loggedInUserDetail.Email};
			mail.setToAddresses(toAddresses);
			mail.setSubject('Batch APEX*i : Not Processed'); 
			mail.setPlainTextBody('Hi,  \n\nThe Apex job created by you is completed.\n \nThe entered filter values(1 or more) were invalid for processing. \n'+userMail1+'\n\nNOTE : Please enter specified formats for filter values.\n\nThanks');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });			
		}
		else{
			List<Group_Report__c> masterRecordUpdateList = new List<Group_Report__c>();
			masterRecordUpdateList = [Select g.id,g.Record_Status__c from Group_Report__c g where g.Id IN :batchRecordDelete];
			if(masterRecordUpdateList.size()>0){
				for(Group_Report__c gr:masterRecordUpdateList){
					gr.Record_Status__c='Expired';
					update gr;
				}
			}
			AsyncApexJob apexJobRunning = [Select Id, Status, NumberOfErrors, JobItemsProcessed,   TotalJobItems, CreatedBy.Name , CreatedBy.Email , CreatedDate, CompletedDate  from AsyncApexJob where Id =:BC.getJobId()];
			List<AsyncApexJob> myCPPInsertBatch=new List<AsyncApexJob>();
			myCPPInsertBatch=[Select Id, Status from AsyncApexJob where CreatedById =:loggedInUserId and ApexClass.Name='batchGroupRunReport' and  (Status='Processing' OR Status='Queued' OR Status='Preparing') ];
			if(myCPPInsertBatch.size()==0){
				//Send an email to the Apex job's submitter notifying of job completion.
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {apexJobRunning.CreatedBy.Email};
				mail.setToAddresses(toAddresses);
				mail.setSubject('Batch APEX*d : ' + apexJobRunning.Status);
				mail.setPlainTextBody('Hi,  \n\nThe Apex job created by: '+apexJobRunning.CreatedBy.Name+'('+apexJobRunning.CreatedBy.Email+') is completed.\nThe process began at '+apexJobRunning.CreatedDate+' and finished at '+apexJobRunning.CompletedDate+'.\n \n'+userMail1+'\n\nNOTE : You can now go back to the VisualForce Page, and click on the link to view the list of group results for your applied filters or export to the CSV or excel file.\n\nThanks');
				Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
			}
		}
	}
}
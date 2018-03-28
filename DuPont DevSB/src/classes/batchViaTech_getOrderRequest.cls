/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch used to get OrderRequest from ViaTech and save to Lead/Request/RequestItems
Database.executeBatch(new batchViaTech_getOrderRequest(Date.newInstance(2010,9,1),Date.newInstance(2010,10,0)),1);

TES20131106 check if scope.isempty in execution to stop error from appearing in job log when 
	no new sample requests are available.
********************************************************************************/
global class batchViaTech_getOrderRequest implements Database.Batchable<string>, Database.AllowsCallouts, Database.stateful {
	global date startDT;
	global date endDT;
	
	global batchViaTech_getOrderRequest() {}
	global batchViaTech_getOrderRequest(Date aStartDT, Date aEndDT) {
		endDT   = (aEndDT==null) ? Date.today().addDays(1) : aEndDT;
		startDT = (aStartDT==null) ? endDT.addDays(-ViaTech.DAYS_OF_BACKLOG) : aStartDT;	
	}
	
			
	global LIST<string> start(Database.BatchableContext BC){
		return new LIST<string>(ViaTech.getOrderRequestIndex(startDT,endDT));
	}

	global void execute(Database.BatchableContext BC, LIST<string> scope) {
		if (!scope.isEmpty())
			system.debug(ViaTech.getOrderRequest(scope[0]));
	}


	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
							From AsyncApexJob where Id =:BC.getJobId()
							];
		
		// Send an email to the Apex job's submitter notifying of job completion.
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('SFDC-BI-batchViaTech_getOrderRequest() ' + a.Status);
		
		string s = 'The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.\n\n';
		mail.setPlainTextBody(s);
		
		if (a.NumberOfErrors>0)
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	
	}

}
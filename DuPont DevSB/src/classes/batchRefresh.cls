/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Batch Refresh
Used to force all the triggers to rerun

TES20111207:  no longer an atomic update.  now uses DMLResults/utilEmail.batchOnFinish
	to report exceptions
********************************************************************************/
global class batchRefresh implements Database.Batchable<Sobject>, Database.Stateful  {
global final string query;
global DmlResults unsuccessfuls;

	global batchRefresh(String q){
		Query=q;
		}
	global Database.QueryLocator start(Database.BatchableContext BC){
		unsuccessfuls = new DmlResults();
		return Database.getQueryLocator(query);
		}
	global void execute(Database.BatchableContext BC, LIST<SObject> scope){
		unsuccessfuls.add(new DmlResults(database.update(scope,false),scope));
	}
	global void finish(Database.BatchableContext BC) {
	utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
	}

}
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to upsert ApprovalStep
Database.executeBatch(new batch_RefreshApprovalStep(),200);

********************************************************************************/
global class batch_RefreshApprovalStep implements Database.Batchable<Sobject>, Database.Stateful {

	global DmlResults unsuccessfuls;
	global Date startDT;
	
    global batch_RefreshApprovalStep() {this(ApprovalStep.getApprovalStepLastModDT()); }
    global batch_RefreshApprovalStep(Date dt) {
    	unsuccessfuls = new DmlResults();
    	startDT = (dt==null) ? Date.newInstance(2000,1,1) : dt;
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC){
    	//pass in Opps with schedules
    	if (Test.isRunningTest()) {
			return Database.getQueryLocator([SELECT Id FROM ProcessInstance LIMIT 200]);
    	}
    	else {
            return Database.getQueryLocator([SELECT Id FROM ProcessInstance WHERE SystemModstamp >= :startDT]);		
    	}
    }
        
    global void execute(Database.BatchableContext BC, LIST<SObject> scope) {
			unsuccessfuls.add(ApprovalStep.onExecute(BC,scope));
    }
	
    global void finish(Database.BatchableContext BC) {
		utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);
    }

}
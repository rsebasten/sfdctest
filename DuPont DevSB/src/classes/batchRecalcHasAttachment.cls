/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to RecalcHasAttachment
	This class will update any row where the has Attachment needs to be updated
	be aware that workflow and triggers will fire on this update.
Database.executeBatch(new batchRecalcHasAttachment(query),200);

TES20120503:  Added support for Notes
********************************************************************************/
global class batchRecalcHasAttachment implements Database.Batchable<Sobject>, Database.Stateful {

	global DmlResults unsuccessfuls;
	global boolean hasNote;  //flag for has Notes
	private string query; 
	
	global batchRecalcHasAttachment(string SOQL) { this(SOQL,false);}
    global batchRecalcHasAttachment(string SOQL, boolean isNote) {
    	query = SOQL;
    	unsuccessfuls = new DmlResults();
    	hasNote=isNote;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){	
		return Database.getQueryLocator(query);    
        }
        
    global void execute(Database.BatchableContext BC, LIST<Sobject> scope) {
		unsuccessfuls.add(HasAttachment.executeBatch(scope,hasNote));	
    } 	
    
    global void finish(Database.BatchableContext BC) {
		utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);   
    }
    

}
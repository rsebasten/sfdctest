/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to Refresh Metadata
Database.executeBatch(new batchRefreshMetadataFileProperties(),1);

Must run with batch of 1 due to callOut limit per execution
********************************************************************************/
global class batchRefreshMetadataFileProperties implements Database.Batchable<Metadata.ListMetadataInstruction>, Database.AllowsCallouts, Database.Stateful {
	
global final LIST<Metadata.ListMetadataInstruction> instructions;
global DmlResults unsuccessfuls;
private string sess;
private boolean softDelete;

	global batchRefreshMetadataFileProperties() { this(null, Metadata.buildListMetadataInstructions()); }
	global batchRefreshMetadataFileProperties(string session, LIST<Metadata.ListMetadataInstruction> instrs ){
		instructions=instrs;
		softDelete=true;
		system.debug(sess);
		sess = (session==null) ? UserInfo.getSessionId() : session;
		}
		
		
	global LIST<Metadata.ListMetadataInstruction> start(Database.BatchableContext BC){
		unsuccessfuls = new DmlResults();
//[01242017] Merge&Spin: added isRunningTest condition to avoid 'No more than one executeBatch can be called from within a test method'
//						error in test run
        if(test.isRunningTest()){
            LIST<Metadata.ListMetadataInstruction> instruction = new LIST<Metadata.ListMetadataInstruction>();
            instruction.add(instructions[0]);
            return instruction;
        }
        else
        	return instructions;
		}
		
		
	global void execute(Database.BatchableContext BC, LIST<Metadata.ListMetadataInstruction> scope){
		API.SESSION=sess;
		Metadata.ListMetadataInstruction instr = (Metadata.ListMetadataInstruction) scope[0];
		system.debug('------instruction-----: '+instr);
		LIST<Metadata__c> metas = Metadata.listMetadata(instr);
		
		if (metas.size()>0) {
			unsuccessfuls.add(new DmlResults(database.upsert(metas,Metadata__c.ForceId__c,false),metas));
			//handle deletes
			LIST<Metadata__c> metadataToDelete = Metadata.ProcessDeletedMetadataByInstruction(metas,instr);
			if (softDelete)
				unsuccessfuls.add(new DmlResults(database.update(metadataToDelete,false),metadataToDelete));
			else
				unsuccessfuls.add(new DmlResults(database.delete(metadataToDelete,false),metadataToDelete));
		}	
	}

	global void finish(Database.BatchableContext BC) {
		Metadata.processDeleteOrphanMetadataRecords();
		utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
	}
	
}
/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Main Class for the ApprovalStep batch class.
'ApprovalStep' is a custom Object and Apex code that exposes the Approval Process data.  
The AP data in the SDFC objects ProcessInstance 
and ProcessInstanceStep is replicated to a custom object ApprovalStep__c via an Apex Job.
********************************************************************************/
public with sharing class ApprovalStep {
	
	private static MAP<string,string> splookupField = getApprovalStepLookupFields();
	private static Map<String, String> globalPrefixMap  = getGlobalPrefixMap();	
	
	
 	public static ApprovalStep__c createApprovalStep(ProcessInstanceStep s) {
        	ApprovalStep__c ps = new ApprovalStep__c();
        	ps.stepId__c				=s.Id;
        	ps.ProcessInstanceId__c		=s.ProcessInstanceId;
			ps.StepStatus__c			=s.StepStatus;
			ps.Status__c				=s.ProcessInstance.Status;
			ps.ProcessCreatedByName__c	=s.ProcessInstance.CreatedBy.Name;
			ps.ProcessCreatedDT__c		=s.ProcessInstance.CreatedDate;
			ps.ProcessLastModifiedDT__c	=s.ProcessInstance.SystemModstamp;
			ps.StepCreatedDT__c			=s.CreatedDate;
			ps.ActorName__c				=s.Actor.Name;
			ps.OrigActorName__c			=s.OriginalActor.Name;
			ps.Comments__c				=s.Comments;
			ps.TargetId__c				=s.ProcessInstance.TargetObjectId;
			//Map Target id to correct lookups
			string targetPrefix = String.valueOf(s.ProcessInstance.TargetObjectId).substring(0,3);	 
			string sotype = globalPrefixMap.get(targetPrefix);
			if (splookupField.containsKey(sotype))
				ps.put(splookupField.get(sotype),s.ProcessInstance.TargetObjectId);
			system.debug(sotype);	
			system.debug(ps);
		return ps;
 	}
	
	
	public static DMLResults onExecute(Database.BatchableContext BC, LIST<ProcessInstance> scope) {
		DMLResults unsuccessfuls = new DMLResults();
			//SET<string> ProcessIds = new SET<string>();
			//for (sobject s : scope)
			//	ProcessIds.add(s.Id);
				
		MAP<string,ProcessInstanceStep> steps = new MAP<string,ProcessInstanceStep>([
			Select s.Id, StepStatus, Actor.Name, OriginalActor.Name,  s.Comments, s.CreatedDate, s.CreatedBy.Name, s.SystemModstamp,
				s.ProcessInstanceId, pi.TargetObjectId, pi.Status,  pi.CreatedBy.Name,  pi.CreatedDate, pi.SystemModstamp, pi.LastModifiedDate, pi.LastModifiedBy.Name
			FROM ProcessInstanceStep s, s.ProcessInstance pi
			WHERE s.ProcessInstanceId in :scope
				]);

		LIST<ApprovalStep__c> stepsToUpsert = new LIST<ApprovalStep__c>();  
        for (ProcessInstanceStep s : steps.values()) {
        	ApprovalStep__c ps = ApprovalStep.createApprovalStep(s);
        	stepsToUpsert.add(ps);
        }

		if (stepsToUpsert.size()>0)
			unsuccessfuls.add(new DmlResults(database.upsert(stepsToUpsert,ApprovalStep__c.stepId__c,false),stepsToUpsert));

		return unsuccessfuls;	
	}
	
	public static Date getApprovalStepLastModDT() {
		Date rtn;
		try {
		 rtn = [SELECT ProcessLastModifiedDT__c FROM ApprovalStep__c ORDER BY ProcessLastModifiedDT__c desc LIMIT 50000][0].ProcessLastModifiedDT__c.date();
		} catch(Exception ex) {}
		system.debug(rtn);
		return rtn;
	}
	
	
	//MAP<Schema.sObjectType,fieldName>
	public static MAP<string,string> getApprovalStepLookupFields() {
		MAP<string,string> rtn = new MAP<string,string>();
		Map<String, Schema.SObjectField> flds = Schema.SObjectType.ApprovalStep__c.fields.getMap();
		for (Schema.SObjectField f : flds.values()) {
			Schema.DescribeFieldResult dfr = f.getDescribe();
			if (dfr.getType()==Schema.DisplayType.REFERENCE && dfr.isCustom()) {
				if (dfr.getReferenceTo().size()==1)
					rtn.put(String.valueOf(dfr.getReferenceTo()[0]),String.valueOf(f));
			}
		}
		system.debug(rtn);
		return rtn; 
	}

	//getGlobalPrefixMap: Returns Map<Prefix, SObjectTypeName (case-sensitive)> for all SObjects 
	private static Map<String, String> getGlobalPrefixMap() {
		MAP<string,Schema.Sobjecttype> gdescr = Schema.getGlobalDescribe();
		Map<String, String> rtn = new Map<String, String>();
		for(String sObj : gdescr.keySet()) {
			Schema.Describesobjectresult dsr = gdescr.get(sObj).getDescribe();
			String pre = dsr.getKeyPrefix();
			if (pre!=null && dsr.isAccessible()) 
				rtn.put(pre,String.valueOf(gdescr.get(sObj)));
		}
		return rtn;
	}

//*****************************************************************************************
// TEST Method(s)
//*****************************************************************************************
   public static testMethod void test() {

        Test.startTest();
		Database.executeBatch(new batch_RefreshApprovalStep(),200);
        Test.stopTest();
    }  


	
}
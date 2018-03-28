/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Utility class used for Schedable classes 

This helper class is to aid in the depolyment of code for scheduled classes
	- ability to activate/deactive the scheduled Jobs from sfdc console
	- to enable/disable the running of the Jobs if a flag is not set in custom settings
TES20120910 - fixed bug in isApexScheduleDisabled not working as expected when a GeneralSetting record not present. (Sandbox)
TES20130404 - added getSchedExprByDate()
TES20130415 - added schedDemandSnapshot to scheduleApexJobs()
TES20130603 - scheduleApexJobs() is no-longer hardcoded uses the custom setting: ScheduledApex__c to drive
********************************************************************************/
public with sharing class utilSchedule {

	public static boolean isApexScheduleDisabled {
  		GET {
  			GeneralSettings__c gs=null;
  			boolean rtn=true;
  			try {
				gs = GeneralSettings__c.getOrgDefaults();
  			}catch(Exception ex){}
  			rtn=(gs!=null && gs.get('Disable_ApexSchedule__c')!=null) ? gs.Disable_ApexSchedule__c : true; 
			if (Test.isRunningTest()) 
  				return false;
			else 
				return rtn;
		}
	}


	/*
	//CORE
	system.schedule('CORE_ScheduleHistory_7PM',		'0 0 19 * * ?',		new sched_RefreshScheduleHistory());
	system.schedule('CORE_Metadata_Logic_3AM',		'0 0 3 * * ?',		new sched_RefreshMetadataLogic());
	system.schedule('CORE_Metadata_DB_12AM',		'0 0 0 * * ?',		new sched_RefreshMetadata());
	system.schedule('CORE_ApprovalStep_5AM',		'0 0 5 * * ?',		new sched_RefreshApprovalStep());
		
	//Customer SAT
	system.schedule('CSAT getFeedback 2AM',			'0 0 2 * * ?',		new schedCustomerSat_getFeedback());
	system.schedule('CSAT getFeedback 2PM',			'0 0 14 * * ?',		new schedCustomerSat_getFeedback());
	
	//Demand
	system.schedule('DemandSnapshot_12AM',			'0 0 0 * * ?',		new schedDemandSnapshot());
	
	*/
	public static void scheduleApexJobs() {
		for (ScheduledApex__c sched : ScheduledApex__c.getAll().values()) {
			if (sched.isActive__c) {
				try {
					system.schedule(sched.name,	sched.CronExpr__c, (Schedulable) Type.forName(null,sched.ClassName__c).newInstance());
				} 
				catch(Exception ex) {}
			}			
		}	
	}

			
	public static string getSchedExprByDate(datetime dt){
        return String.format('{0} {1} {2} {3} {4} ? {5}', 
        	new string[]{ string.valueof(dt.second()),string.valueof(dt.minute()),string.valueof(dt.hour()), 
        		string.valueof(dt.day()),string.valueof(dt.month()),string.valueof(dt.year()) });
		
	}
			
	public static void abortApexJobs() {
		for(CronTrigger c : [Select Id, CronExpression From CronTrigger WHERE NextFireTime!=NULL AND EndTime=NULL LIMIT 150])
			System.abortJob(c.Id);
		}
		
	//LIMIT OF 150 MANY NEED TO EXCUTE MULTIPLE TIMES
	//CONSIDER A BATCH CLASS FOR FUTURE REVISION
	public static void abortAllJobs() {
		for(CronTrigger c : [Select Id, CronExpression From CronTrigger LIMIT 150])
			System.abortJob(c.Id);
		}

	 	
	}
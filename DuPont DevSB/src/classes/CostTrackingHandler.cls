/*******************************************************************************
Copyright © 2014 Delaware Digital Design, Inc. All rights reserved. 
Copyright © 2014 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger Handler for Cost_Tracking__c
********************************************************************************/
public class CostTrackingHandler extends TriggerHandlerBase {

	public static boolean triggerInProgress=false;

	public override void bulkafter() {
		if (!triggerInProgress) {
			SumTotalCostsToCase();
		}
	}
	
	private void SumTotalCostsToCase() {
	
		//get scope of cases to recalc total costs
		SET<Id> caseIds = new SET<Id>();
		for(Cost_Tracking__c ct : (LIST<Cost_Tracking__c>) this.records.values()) {
			if (ct.Case__c!=null)
				caseIds.add(ct.Case__c);	
		}
		
		//Aggregate Costs on Cost_Tracking__c and save to parent Case(s)
		if (!caseIds.isEmpty()) {
			LIST<Case> casesToUpdate = new LIST<Case>();
			
			LIST<sobject> aggr = [Select Case__c,
				count(id) cnt, sum(ActualCost__c) ac, sum(EstimatedCost__c) ec from Cost_Tracking__c 
	 			where case__c in: caseIds 
	 			group by Case__c];		
			
			for (sobject so : aggr) {
				Case cs = new Case(id=(ID)so.get('case__c'));
				cs.CostTrackingCount__c		= (integer) so.get('cnt');
	 			cs.TotalActualCost__c 		= (decimal) so.get('ac');
	 			cs.TotalEstimatedCost__c 	= (decimal) so.get('ec');
	 			casesToUpdate.add(cs);
			}	
			update casesToUpdate;
		}
	}

}
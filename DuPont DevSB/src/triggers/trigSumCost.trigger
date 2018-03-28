/*
 * Modification log
 * ==================================================================================================
 * ver        Date        Author                Modification
 * ---        ----       --------------         ------------
 * 1.0      2015-12-23   Diego Delgado          Trigger used to sum up total cost of Cost Tracking to a Case Action
*/
trigger trigSumCost on Cost_Tracking__c (after delete, after insert, after undelete, after update) {

    List<Cost_Tracking__c> costList = new List<Cost_Tracking__c>();
  if(System.Label.Trigger_On_Off  == 'On'){  
    if(trigger.isDelete){
        costList = trigger.old;
    }
    
    else{
        costList = trigger.new;
    }
    
    Set<Id> caseActionIds = new Set<Id>();
    for ( Cost_Tracking__c cost : costList ){
        caseActionIds.add( cost.Case_Action__c );
    }
    
    List<Cost_Tracking__c> costTrackings = [select Id, ActualCost__c, Case_Action__c from Cost_Tracking__c where Case_Action__c IN :caseActionIds AND ActualCost__c != null AND RecordType.DeveloperName = 'Pioneer_LA_AF_Complaint'];

    Map<Id,List<Cost_Tracking__c>> costTrackingsByCaseAction = new Map<Id,List<Cost_Tracking__c>>();

    for ( Cost_Tracking__c cost : costTrackings ){
   
        if (cost.Case_Action__c == null) 
            continue;
    
        if (!costTrackingsByCaseAction.containsKey(cost.Case_Action__c) ){
            costTrackingsByCaseAction.put( cost.Case_Action__c , new List<Cost_Tracking__c>());
        }
    
        costTrackingsByCaseAction.get( cost.Case_Action__c ).add(cost);
    
    }

    List<Case_Action__c> caseActions = new List<Case_Action__c>();

    for ( Id caseActionId : costTrackingsByCaseAction.keySet() ){
    
        Decimal total = 0 ;
        
        for (  Cost_Tracking__c costTracking : costTrackingsByCaseAction.get( caseActionId )  )  {
            total = total + costTracking.ActualCost__c;            
        }
    
        caseActions.add( new Case_Action__c( Id=caseActionId , Actual_Total_Cost__c=total)  );      
    }
    
    update caseActions;
  }
}
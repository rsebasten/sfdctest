/*****************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Ankit Gupta
Email: Ankit.Gupta@usa.dupont.com
Description:  Trigger Handler for Call Report
******************************************************/
public class callReportHandler extends TriggerHandlerBase{

    public override void bulkBefore(){
        scoreCallReport(Trigger.new,this.getRulesEngineResults());       
    }

    public void scoreCallReport(List<Call_Report__c> listCallReport,RulesEngine.Results res){  
        for(Call_Report__c cr:listCallReport){           
              RulesEngine.EvalResults evR = res.mapResults.get(cr);
              if (evR!=null && evR.rules!=null) {
                for (RulesEngine.RuleResult rr :  evR.rules.values()) {
                   if (rr.rule.rule_type__c =='Scoring') {    
                     // To score__c remove reference
                     //cr.score__c=Decimal.valueof(rr.result);
                   }
                }              
            }
        }
     }
    
    //<jj20160201> START OF CODE Added After Trigger Call to NH Call Report Handler
    public override void bulkAfter(){
        //NH_Call_Report_Helper.AssignTask(this);       
    }
    //<jj20160201> END OF CODE
}
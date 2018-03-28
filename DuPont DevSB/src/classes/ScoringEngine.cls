/********************************************************************************************
Created By : Ankit Gupta<Ankit.Gupta@usa.dupont.com>
Created Date : 2012/9/3
Last Modified Date: 2013/03/15
Description : This controller class contains the logic to rate and calculate the total score
        the objects based on the Rule and Rule Item .
        
TES20130208 some cleanup and refactor for use with RulesEngine, no change in logic.
TES20130311 re-wrote rules engine so it can be used for multi-recordtypes, objects and later
  enhanced for diff field datatypes and/or operations   
*********************************************************************************************/
public with sharing class ScoringEngine {
   
  public static RulesEngine.RuleResult execute(Rule__c rule,Sobject sobj){ 

      RulesEngine.RuleResult rtn=new RulesEngine.RuleResult();   
      decimal totalScore=0;
      rtn.Rule=rule;   

      //get Describe   
      Util.Describe descr = Util.getDescribe(sobj);   
      
      //loop through rule items
      for(Rule_Item__c ruleItem : rule.rule_items__r) {
        
        Schema.DescribeFieldResult dfr = descr.FieldInfo(ruleItem.Field_API__c);
        if (dfr!=null) {
          
          Schema.SOAPtype soapType=dfr.getSOAPType();
          Schema.Displaytype displayType=dfr.getType();
          
           if (soapType == Schema.Soaptype.STRING) {
             String val=String.valueOf(sobj.get(dfr.getName()));
             if (val==null) {
               if (ruleItem.value__c==null)
                 totalScore+=ruleItem.score__c;
             }
            else {
              if (displayType == Schema.Displaytype.MultiPicklist) {
                //only equal is supported for Muti-picks
                SET<string> arr = new SET<string>();
                arr.addAll(val.split(';'));
                if (arr.contains(ruleItem.value__c))
                  totalScore+=ruleItem.score__c;
              }
               else {
                 if (ruleItem.operator__c=='equals') {
                   if (val==ruleItem.value__c)
                     totalScore+=ruleItem.score__c;
                 }
                 else if (ruleItem.operator__c=='contains') {
                   SET<string> arr = new SET<string>();
                  arr.addAll(ruleItem.value__c.split(';'));
                   if (arr.contains(val))
                    totalScore+=ruleItem.score__c;
                 }
               }
             }
          } //Schema.Soaptype.STRING
          
          //else if (soapType == Schema.Soaptype.INTEGER  ) ...
          //else if (soapType == Schema.Soaptype.DATETIME ) ...
          //else if (soapType == Schema.Soaptype.DATE   ) ...
          //else if (soapType == Schema.Soaptype.BOOLEAN  ) ...
          
        }//valid DFR          
      } //next  ruleItem
      rtn.result=String.valueof(totalScore);
      
    return rtn;
  }
  

 }
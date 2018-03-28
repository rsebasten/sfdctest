/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder,Ankit Gupta
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com , Ankit.Gupta@usa.dupont.com
Description:  Lead Scoring class to update the score and rating for leads
********************************************************************************/
public class leadScoring {         
        
  private static MAP<id,MAP<string,decimal>> cacheTypeScore;
              
   //method to cache all rules and rule items with fieldAPI as Type__c
   public static MAP<id,MAP<string,decimal>> getTypeScore() {
     if (cacheTypeScore==null) {
       cacheTypeScore = new MAP<id,MAP<string,decimal>>();
       for(rule__c r : [SELECT id,(SELECT score__c,value__c 
                        from Rule_Items__r where Field_API__c='Type__c')
                        FROM rule__c r where Sobject_Type__c='Lead' AND r.rule_type__c='Scoring']) {    
          if (!cacheTypeScore.containsKey(r.id)) {
             cacheTypeScore.put(r.id,new MAP<string,decimal>());
             for (Rule_Item__c ri : r.Rule_Items__r)
               cacheTypeScore.get(r.id).put(ri.value__c,ri.score__c);
          }
       }
       return cacheTypeScore;
     } 
      else
       return cacheTypeScore;
   }              
                
   // update the records with the Rating and Score calculated via the RulesEngine & ScoringEngine  
   public static void scoreLeads(LIST<Lead> leads, RulesEngine.Results ruleResults) {
     for (Lead l : leads) {
       if (l.Scoring_Type__c=='Automated-SFDC') {
          RulesEngine.EvalResults evR = ruleResults.mapResults.get(l);
          if (evR!=null && evR.rules!=null) {
             for (RulesEngine.RuleResult rr :  evR.rules.values()) {
               if (rr.rule.rule_type__c =='Scoring') {                  
                  decimal typScore=0;
                  if (getTypeScore()!=null && getTypeScore().get(rr.rule.id)!=null)
                     typScore=getTypeScore().get(rr.rule.id).get(l.type__c);
                      l.qual_level__c=rr.rating;                        
                      l.int_level__c=String.valueof(Integer.valueof(typScore));
                      l.qual_score__c=Decimal.valueof(rr.result);
                      if(typScore!=0.0 && typScore!=null){                     
                        l.rating =rr.rating +'-'+l.int_level__c;
                      }
                      else{
                      l.rating =rr.rating;            
                     }
                }
               }
            }
         }
     }
   }
}
/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder, Ankit Gupta
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com, Ankit.Gupta@usa.dupont.com
Description : This apex class contains the logic to identify the EvalResults and the 
              corresponding rules for the particular ruleType .
********************************************************************************/
public with sharing class RulesEngine {

    public static Results getResults(LIST<sObject> sobjects){
        if (sobjects.size()>0) {
            string sobjectType=String.valueOf(sobjects[0].getSObjectType());
            return  getResults(sobjects,sobjectType);
        }
        return new Results();
    }   
    
    
    public static Results getResults(LIST<sObject> sobjects,String soType) { 
         Results rtn=new Results();
         
        try{ 
            //Get all the rules for this soType  
            Map<Id,Rule__c> mapRules = new Map<Id,Rule__c>([
                SELECT id,sobject_type__c,range__c,geo_region__c,rule_type__c,Record_Type__c,Write_To__c,Owning_organization__c,
                (SELECT id,Field_API__c,score__c,value__c,Operator__c from Rule_Items__r ri where ri.IsActive__c= true)
                FROM rule__c r WHERE r.Sobject_Type__c=:soType AND r.IsActive__c = true]);
            
            Rtype.SObjectRTypes orts = new Rtype.SObjectRTypes(sOType);
            
            //TODO: preprocess sobject records to pull in fields from foreign relations
                                
            //loop through sobjs in batch
            for(Sobject sobj : sobjects){               
                EvalResults soEvalResults = new EvalResults(); 
                soEvalResults.record=sobj;        
                string myRT=orts.IdToDevName(String.valueOf(sobj.get('recordTypeId')));
                
                //loop through rules          
                for(Rule__c rule : mapRules.values()){                  
                    if ((rule.geo_region__c ==null || sobj.get('region__c')== rule.geo_region__c ) && 
                        (myRT == rule.record_Type__c || rule.record_Type__c==null ) 
                        && (rule.Owning_organization__c==null || sobj.get('Owning_organization__c')== rule.Owning_organization__c)){ 
                       RuleResult ruleRes=executeRule(rule,sobj);
                       soEvalResults.rules.put(ruleRes.rule.Id,ruleRes); 
                    }
                } //next rule
                
                
                //dont add sobj mapping if no rules
                if  (soEvalResults.rules.size()>0)
                    rtn.mapResults.put(sobj,soEvalResults);
            
            } //next sobj     
        }
        catch(Exception e){
            e.setMessage('capture Exception ');
        }      
        return rtn;
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    // determine which rule engine to run  (based on Rule.rule_type__c)
    //  this gives us ability to write new optimized rules without effecting existing code
    //////////////////////////////////////////////////////////////////////////////////////////////
    public static RuleResult executeRule(Rule__c inRule,Sobject sobj) {   //1rule,1sobj
        RuleResult rtn=new RuleResult();
            
        if( inRule.rule_type__c == 'scoring' ){       
            rtn = ScoringEngine.execute(inRule,sobj);       
        }
        if( inRule.rule_type__c == 'scoring2' ){          
            //rtn = ScoringEngine2.execute(inRule,sobj);          
        }
        //add you new rules engines here....
        
        
        //else if( inRule.rule_type__c == 'superfastboolean' ) {        
        //  exampleEngine.execute(inRule,sobj); 
        //}
        return rtn;

     } 
     
    //////////////////////////////////////////////////////////////////////////////////////////////
    //  Inner Classes
    //////////////////////////////////////////////////////////////////////////////////////////////
        
     //many sobj,many rules   
     public class Results{  
        public MAP<sobject,EvalResults> mapResults;   
        public Results() {
            mapResults=new MAP<sobject,EvalResults>();
        }
    } 
    //////////////////////////////////////////////////////////////////////////////////////////////
    //1 sobj,many rules
    public class EvalResults{  
        
            public sobject record;
            public  MAP<Id, RuleResult> rules;  
            EvalResults() {
                rules = new MAP<Id, RuleResult>();
            }
    } 
    
    ////////////////////////////////////////////////////////////////////////////////////////////// 
    //1 sobj,1 rules  
    public class RuleResult {
      public Rule__c Rule;
      public String result;
      public String rating {
      get{
          String rtng;      
          List<Integer> listNum=new List<integer>();
          List<String> listAlpha=new List<String>();

          for(String str : rule.Range__c.split('&')){
            String[] tmp=str.split('=');
            listNum.add(Integer.valueof(tmp[0]));
            listAlpha.add(tmp[1]);      
          }       
       
           for(Integer k=0;k<listNum.size();k++){ 
             if(Decimal.valueof(result) >= listNum.get(k)){ 
                rtng=listAlpha.get(k); 
                break;
             }
          }      
          return rtng;
       } 
      }
    }
        
}
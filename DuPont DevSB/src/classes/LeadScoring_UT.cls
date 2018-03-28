@isTest
private class LeadScoring_UT{

    static testMethod void leadScoringTest(){
    List<Lead> leadScoringList=new List<Lead>();
    Rule__c ruleObj=new Rule__c(Name='Test Rule',IsActive__c=true,Geo_Region__c='EMEA',SObject_Type__c='Lead',Record_Type__c='Level2DPPEMEA',Rule_Type__c='Scoring',Range__c='70=A&50=B&30=C&10=D&0=E',owning_organization__c='DPP-IPP');
    insert ruleObj;
    Rule_Item__c ruleItemObj=new Rule_Item__c(Name='Test RuleItem1',IsActive__c=true,Field_API__c='Market_Segment__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Oil & Gas',Score__c=9);
    insert ruleItemObj;
    Rule_Item__c ruleItemObj1=new Rule_Item__c(Name='Test RuleItem2',IsActive__c=true,Field_API__c='Market_Segment__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Wood Industry',Score__c=7);
    insert ruleItemObj1;
    Rule_Item__c ruleItemObj2=new Rule_Item__c(Name='Test RuleItem3',IsActive__c=true,Field_API__c='Influence_Type__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Buyer',Score__c=24);
    insert ruleItemObj2;
    Rule_Item__c ruleItemObj3=new Rule_Item__c(Name='Test RuleItem4',IsActive__c=true,Field_API__c='Influence_Type__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Key Decision Maker',Score__c=36);
    insert ruleItemObj3;
    Rule_Item__c ruleItemObj4=new Rule_Item__c(Name='Test RuleItem5',Field_API__c='Type__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Career Opportunities',Score__c=4);
    insert ruleItemObj4;
    Rule_Item__c ruleItemObj5=new Rule_Item__c(Name='Test RuleItem6',Field_API__c='Type__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Certifications and Specifications',Score__c=1);
    insert ruleItemObj5;
    Rule_Item__c ruleItemObj6=new Rule_Item__c(Name='Test RuleItem7',IsActive__c=true,Field_API__c='S_P_Applications__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Ballistics',Score__c=9);
    insert ruleItemObj6;    
    Rule_Item__c ruleItemObj8=new Rule_Item__c(Name='Test RuleItem9',IsActive__c=true,Field_API__c='S_P_Applications__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Liquid Metal',Score__c=6);
    insert ruleItemObj8;
    Rule_Item__c ruleItemObj9=new Rule_Item__c(Name='Test RuleItem10',IsActive__c=true,Field_API__c='S_P_Applications__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Fire Services',Score__c=9);
    insert ruleItemObj9;
    Rule_Item__c ruleItemObj10=new Rule_Item__c(Name='Test RuleItem11',IsActive__c=true,Field_API__c='S_P_Applications__c',Rule__c=ruleObj.id,Operator__c='equals',Value__c='Chemical Industrial',Score__c=9);
    insert ruleItemObj10;   
    Lead leadObj;
    Lead leadObj1;
    //[01022017] Merge&Spin: Replaced hard coding of record type Id
        string Level2DPPEMEA_RType = RType.getIdByDevName('Lead','Level2DPPEMEA');
    for(Integer k=0;k<1;k++){
        leadObj=new Lead(lastName='testLeadScoring',Influence_Type__c='Buyer',Market_Segment__c='Oil & Gas',Company='Test Company',recordTypeId=Level2DPPEMEA_RType, qual_score__c=null,
                             S_P_Applications__c='Ballistics;Fire Services;Chemical Industrial;Liquid Metal',Region__c='EMEA',Status='Capture',Type__c='Career Opportunities',Scoring_Type__c='Automated-SFDC',owning_organization__c='DPP-IPP');
        leadObj1=new Lead(lastName='testLeadScoring1',Influence_Type__c='Buyer',Market_Segment__c='Oil & Gas',Company='Test Company',recordTypeId=Level2DPPEMEA_RType,
                             S_P_Applications__c='Ballistics;Fire Services;Chemical Industrial;Liquid Metal',Region__c='EMEA',Status='Capture',Scoring_Type__c='Automated-SFDC',owning_organization__c='DPP-IPP');
    }
    leadScoringList.add(leadObj);
    leadScoringList.add(leadObj1);
    Insert leadScoringList;
    //assert the result of the ruleEngine
    if(leadScoringList.get(0).qual_score__c!=null)
        System.assertEquals(66, leadScoringList.get(0).qual_score__c); 
       
    LeadScoring leadScoringObj=new LeadScoring();    
    leadScoringList.get(0).influence_type__c='Key Decision Maker';    
    update leadScoringList;           
    }
    
        public static testmethod void leadTestMethod() {
        List<Lead> objLeadList = new List<Lead>();
        Campaign objCampaign = new Campaign(Name='Test');
        Insert objCampaign;
        objCampaign.Origin_Tracking_Code__c =objCampaign.Id;
        Update objCampaign;
        for(Integer i=0;i<25;i++){
            Lead objLead = new Lead(lastname='Test', Origin_Tracking_Code__c=objCampaign.Id, Company='Test Company');
            objLeadList.add(objLead);
        }
        Insert objLeadList;
    }
 }
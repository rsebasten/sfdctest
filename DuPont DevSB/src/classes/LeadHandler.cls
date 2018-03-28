/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Lead trigger handler

TES20131104 - Added logic for dealing with trigger sub-batching (this.hasFired)
NS20160303 - For PopulatePreferredLanguage in Lead Object
MR20160518 - Assign Regions for N&H using Organizational_Group__c (duplicate account and contact process)
    
********************************************************************************/
public class LeadHandler extends TriggerHandlerBase {

    static final string CAMPAIGN_PREFIX = Campaign.sObjectType.getDescribe().getKeyPrefix();

    static boolean InProcess = false;   //avoid recursion
  
    public override void bulkAfter(){
        if (!this.hasFired) //new sub-batch
            InProcess=false;
        if (!InProcess) {
            InProcess=true;
            if (Trigger.IsInsert) {
                EmailBase.leads_onAfter();
                originTrackingCodeToMembers(System.Trigger.new);
            }
            if (Trigger.IsUpdate) { 
                EmailBase.leads_onAfter();
            }
        }
    }    
    /* NS20160303
    START LOGIC
     Issue # :IS ID-00066047
    Description:  Once in field Origin Name is selected Brasil 800 in Lead Object,
             After Saving automatically into the field PREFERRED LANGUAGE should be filled with PORTUGUESE.*/
    
    public static void  PopulatePreferredLanguage(List<Lead> Leadlist){
        if(Trigger.IsBEFORE){
            if(Trigger.IsINSERT ||Trigger.IsUpdate){
                for(Lead leadobj:Leadlist){
                    if(leadobj.Origin_Name__c =='Brasil 800'){
                        leadobj.Preferred_Language__c ='PORTUGUESE'; 
                    } 
                }
            }
        }
        
    }
    /*END LOGIC */
  public override void bulkBefore(){
    if (Trigger.IsInsert) {
        LeadContactMapping.Lead_OnBeforeInsert(Trigger.new);
    }
    LeadScoring.scoreLeads(Trigger.new,this.getRulesEngineResults());
    
    // TES20131114:  Attenpt to fix Autoresponse issue
    for  (Lead l : (LIST<Lead>) Trigger.new) {
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.EmailHeader.triggerAutoResponseEmail = true;
        //dmlo.AssignmentRuleHeader.UseDefaultRule=true;
        //dmlo.EmailHeader.triggerUserEmail = true; 
        l.setOptions(dmlo);
    } 
    //<MR20160518> Assign Regions for N&H using Organizational_Group__c
    //NH_Lead_Helper.AssignRegion(this);
  }   


  private static void originTrackingCodeToMembers(LIST<Lead> leads){
    //group leads (potential members) by campaign id
    MAP<Id, LIST<Lead>> leadsByCamp = new MAP<Id, LIST<Lead>>();  //MAP<campId,LIST<Lead>>
    for(Lead objLead: leads){
      string campid=tCodeToCampId(objLead.Origin_Tracking_Code__c);
      if (campid!=null) {
        if (!leadsByCamp.containsKey(campid))
          leadsByCamp.put(campid, new LIST<Lead>());
        leadsByCamp.get(campid).add(objLead);
      }
    }
    //validate campaign existence
    LIST<string> exemptListTypes = new LIST<string>{'Subscriber','Master'};
    Map<Id,Campaign> campaignMap = new Map<Id,Campaign>([
       SELECT Id FROM Campaign WHERE Id IN :leadsByCamp.keySet() 
      AND List_Type__c not in :exemptListTypes]);
    
    //insert members
    LIST<CampaignMember> newMembers = new LIST<CampaignMember>();  
    for(Id campId : leadsByCamp.keySet()) {
      if (campaignMap.containskey(campId)) {
        for (Lead l : leadsByCamp.get(campid))
          newMembers.add(new CampaignMember(campaignid=campid,leadid=l.id));
      }
    }
    database.insert(newMembers,false);
  }


  private static string tCodeToCampId(string tcode) {
    if (tcode!=null && tcode.contains(CAMPAIGN_PREFIX)){
      integer  campaignIdIndex=tcode.indexOf(CAMPAIGN_PREFIX, 0);
      if  (campaignIdIndex+15<=tcode.Length())
        return tcode.substring(campaignIdIndex, campaignIdIndex+15);
    }
    return null;
  }

}
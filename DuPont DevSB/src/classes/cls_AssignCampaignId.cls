/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Santosh Kumar
Email: kumar.santosh32@tcs.com
Description:  Asynchronous class for inserting campaign member for customers giving consent to opt-in on ask a question tab.
Created Date: 10/12/2016
Version: 1.0
********************************************************************************/

public class cls_AssignCampaignId{

@future
    public static void assignCampId(String strLeadId){
      
      try{
          DPSKevlarCustomSetting__c dps = DPSKevlarCustomSetting__c.getOrgDefaults();
          Campaign objCamp = [Select name from Campaign where name = :dps.KV_Campaing_Name__c and IsActive = true Limit 1];
          if(objCamp != null){ 
              CampaignMember cml = new CampaignMember();
              cml.CampaignId = objCamp.Id;
              cml.LeadId = strLeadId;
              SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER=true;
              
              insert cml;
          }     
      }
      catch (Exception e) 
      {
          System.debug('Error in Campaign Mem creation' + e.getMessage() + ' Line:' + e.getLineNumber() + ' Cause:' + e.getCause() + ' StackTrace:' + e.getStackTraceString());
      }    
    
    } 


}
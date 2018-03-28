/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Handle copying child realtionship on Lead after conversion

TES20120319 - Added Convertion support to Future_Business_Development__c 
SHIV20141215 - Added an if condition to ensure that the trigger is run on Update only

<VL20161020>
Modified By: Vijay Laxmi
Modification Date: 20-Oct-2016
Modification: Added conition to not run the trigger for CIC Project Lead creation

<VL20170428>
Modified By: Vijay Laxmi
Modification Date: 28-Apr-2017
Modification: Added if conition to not run the trigger for CPSF Project Lead creation
              

********************************************************************************/
trigger trigLeadOnConvert on Lead (After Update) {
//SHIV20141215
//<VL20161020>
 //<VL20170428>start
    if(Trigger.IsUpdate && ctrlCIC_Parse.cic_related_Lead==false && !BI_CPUtil.CPSF_leadTrigPass){ 
    //<VL20170428>End
    Map<Id,String> MapOfConvertedContactId = new Map<Id,String>();
    
    Map<Id,Lead> convertedLeads = new Map<Id,Lead>([
        SELECT Id, Name,  ConvertedContactId, ConvertedOpportunityId, ConvertedAccountId,Lead_Country__c,Region__c
        FROM Lead 
        WHERE Id in :Trigger.newMap.keyset() AND isConverted=true AND Lead_Country__c!=NULL AND Region__c!=NULL
        ]);
    //starts    
    for(lead leadmapvalues:convertedLeads.values()){
         MapOfConvertedContactId.put(leadmapvalues.ConvertedContactId,leadmapvalues.Lead_Country__c);
         
     }
    
    //Map Contact Geo Region and country fields ,Modified by 06/01/2016
    List<Contact> contactList= [select Id,Region__c,Contact_Country__c from Contact WHERE Contact.Id IN :MapOfConvertedContactId.keyset()];
    
    for(Contact c : contactList)
    {
      for(Lead l : convertedLeads.values())
      {
          if(c.Id == l.ConvertedContactId)
          {
              c.Region__c= l.Region__c;
              c.Contact_Country__c = l.Lead_Country__c ;
          }
      }  
    }
    update contactList;
    //ends

    //Convert the Requests scripts
    Request__c[] requests = [
        SELECT Id, Contact__c, Lead__c FROM Request__c 
        WHERE Lead__c in :convertedLeads.keyset()
        ];                 
    for (Request__c r: requests  ) {
         r.Contact__c = convertedLeads.Get(r.Lead__c).ConvertedContactId;
    }
    
    update requests;
    
    
    //Convert the Call scripts
    SFDC_Script_Header__c[] ScriptHeaders = [
            SELECT Id, Contact__c, Lead__c
            FROM SFDC_Script_Header__c 
            WHERE Lead__c in :convertedLeads.keyset()
            ];       
    for (SFDC_Script_Header__c sh : ScriptHeaders  ) {
         sh.Contact__c    = convertedLeads.Get(sh.Lead__c).ConvertedContactId;
         sh.Account__c    = convertedLeads.Get(sh.Lead__c).ConvertedAccountId;
         sh.Opportunity__c  = convertedLeads.Get(sh.Lead__c).ConvertedOpportunityId;
    }
    update ScriptHeaders;

    //Convert the FBDs
    //TES20120319 START
    LIST<Future_Business_Development__c> fbds = [
        //SELECT Id, Related_Opportunity__c, Related_Lead__c
        SELECT Id, Related_Lead__c 
        FROM Future_Business_Development__c 
        WHERE Related_Lead__c in :convertedLeads.keyset()
        ];              
    for (Future_Business_Development__c fbd : fbds  ) {
        //fbd.Related_Opportunity__c  = convertedLeads.Get(fbd.Related_Lead__c).ConvertedOpportunityId;
    }
    update fbds;        
    //TES20120319 END
}

}
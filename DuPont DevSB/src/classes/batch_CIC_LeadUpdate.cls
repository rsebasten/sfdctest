/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/17/2016
Description:    Class to update Lead for Lookup External Initiative with ExternalInitiativeID
                In finish method of batch_CIC_LeadUpdate we are calling another batch "batch_CIC_Oppty" to create Opportunity for those External Initiative where Opportunity not present


***************************************************************************************************/

global class batch_CIC_LeadUpdate implements Database.Batchable<sObject> 
{
    public static final Integer batchJobSize = Integer.valueOf(Label.CIC_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_LastModified_Date_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
	
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        // Fetching the Lead for CIC Project
        String query =   'select id,name,External_Initiative__c,Legacy_Lead_ID__c from Lead where ((lastmodifieddate>=:lastmodifiedFilter)  and (Legacy_Lead_ID__c LIKE \'CIC%\'))';
        return Database.getQueryLocator(query);       
    }
    public void execute(Database.BatchableContext info, List<Lead> le)
    {
        map<String,id> mapEIID_EIRecordID =new  map<String,id>();
        List<Lead> lstLead = new   List<Lead>();
        set<string> externalInitiativeIdSet = new set<string>();
        for(Lead lead1 : le)
        {
            String mapEIidget = '';
            //Fetching the External Initiative id from Legacy_Lead_ID__c
            if(lead1.Legacy_Lead_ID__c!=null)
            {
              String EI_ID = lead1.Legacy_Lead_ID__c.substringAfter('^');
              String EI_ID1 = EI_ID.substringBefore('^');
              mapEIidget =EI_ID1; 
            }            
            externalInitiativeIdSet.add(mapEIidget);
        }
        for(External_Initiative__c EId : [select id,External_ID__c from External_Initiative__c where External_ID__c in:externalInitiativeIdSet])
        {
            mapEIID_EIRecordID.put(EId.External_ID__c,EId.id );
        }        
        for(Lead lead1 :le)
        {
            String mapEIidget = '';
            if(lead1.Legacy_Lead_ID__c!=null)
            {
                String EI_ID = lead1.Legacy_Lead_ID__c.substringAfter('^');
                String EI_ID1 = EI_ID.substringBefore('^');
                mapEIidget =EI_ID1; 
                //mapEIidget=(lead1.Legacy_Lead_ID__c).substringBefore('^');
            }
            if(mapEIID_EIRecordID!=null && lead1.Legacy_Lead_ID__c!=null && mapEIID_EIRecordID.get(mapEIidget)!=null)
            {
                // Mapping the Lead on External Initiative
                lead1.External_Initiative__c=mapEIID_EIRecordID.get(mapEIidget);    
                lstLead.add(lead1);
            }
        }
        // Updating the Lead with External Initiative Id
        if(lstLead!=null)
        {
            update lstLead;
        }
    }
    // Calling another batch class "batch_CIC_Oppty" to create Oppty for those ExternalInitiative where oppty not present
    public void finish(Database.BatchableContext info) 
    {
        Database.executeBatch(new batch_CIC_Oppty(),batchJobSize);  
    }
}
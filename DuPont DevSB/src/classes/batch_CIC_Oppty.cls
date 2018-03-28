/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/10/2016
Description:    Class to create opportunity if not present on ExternalInitiative for Project Level "Parent" only

***************************************************************************************************/

global class batch_CIC_Oppty  implements Database.Batchable<sObject> 
{
    public static final Integer batchJobSize = Integer.valueOf(Label.CIC_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_LastModified_Date_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    public static String EIdatasoce = system.Label.CIC_External_Initiative_Data_Source;
    public static String EI_ProjectLevel ='Parent';
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        // Fetching the External Initiative for CIC Project
        String query  ='select id,External_ID__c,Country__c,EI_Region__c,Full_External_Initiative_Name__c,Description__c,External_Search_Name__c,Name,City__c from External_Initiative__c where ((Data_Source__c=:EIdatasoce) and (lastmodifieddate>=:lastmodifiedFilter) and Project_Level__c=:EI_ProjectLevel)';
        return Database.getQueryLocator(query);          
    }
    public void execute(Database.BatchableContext info, List<External_Initiative__c> ei)
    {
        set<id> setEIID = new  set<id>();
        for(External_Initiative__c EId : ei)
        {
            setEIID.add(EId.id);
        }
        // Fetching the Opportunity for which External Initiative ids is already present
        list<opportunity> lstopp =  [
                                    select id,External_Initiative__c,owner.id,owner.name,owner.DefaultCurrencyIsoCode
                                    from Opportunity 
                                    where External_Initiative__c in:setEIID
                                    ];
        map<id,opportunity>  mapEIIDOpp = new map<id,opportunity>();
        for(opportunity opp : lstopp)
        {
            mapEIIDOpp.put(opp.External_Initiative__c,Opp); 
        }
        List<External_Initiative__c> lstExternal = new   List<External_Initiative__c>();
        // External Initiative is not containing oppty we are adding in List "lstExternal" and calling the "Addopportunities_CIC" method from BI_MHC class to create new  Opportunity
        for(External_Initiative__c Ext :ei)
        {
            if(!mapEIIDOpp.containskey(Ext.id))         
                lstExternal.add(Ext);
        }
        BI_MHC.Addopportunities_CIC(lstExternal);
    }
    public void finish(Database.BatchableContext info) {}
}
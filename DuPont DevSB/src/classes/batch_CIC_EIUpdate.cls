/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/10/2016
Description:    Class to update External Initiative with Parent Project ID when Level is "sub"

<VL20161202>
Modified By: Vijay Laxmi
Modification Date: 02-Dec-2016
Modification: null check we are adding to resolve batch failure error "salesforce.com internal error"

<VL20171030>
Modified By: Vijay Laxmi
Modification Date: 30-Oct-2017
Modification: Duplicate Lead Management regarding project # CRM-2017-10-4383  

***************************************************************************************************/
global class batch_CIC_EIUpdate implements Database.Batchable<sObject> 
{
    public static final Integer batchJobSize = Integer.valueOf(Label.CIC_Batch_Size);
    public static Integer batchFilter = Integer.valueOf(Label.CIC_LastModified_Date_Filter);
    public static datetime Lastmodifiedfilter = system.today().adddays(batchFilter);
    public static String EIdatasoce = system.Label.CIC_External_Initiative_Data_Source;
    
    public Database.QueryLocator start(Database.BatchableContext BC)
  {
    // Fetching the External Initiative for CIC Project
    String query = 'select id,External_ID__c,Project_Level__c,Parent_External_Initiative__c,Parent_Project_Id__c from External_Initiative__c where ((Data_Source__c=:EIdatasoce) and (lastmodifieddate>=:lastmodifiedFilter))';
    return Database.getQueryLocator(query);     
  }
  public void execute(Database.BatchableContext info, List<External_Initiative__c> ei)
  {
    map<String,id> mapEIID_EIRecordID =new  map<String,id>();
    List<External_Initiative__c> lstExternal = new   List<External_Initiative__c>();
    set<string> parentid = new set<string>();
    for(External_Initiative__c EId :ei)
    {
        //<VL20161202>
      if(EId.Parent_Project_Id__c != null)
      {
        parentid.add(EId.Parent_Project_Id__c);
      }    
    }
    for(External_Initiative__c EId : [select id,External_ID__c from External_Initiative__c where External_ID__c in:parentid])
    {
      mapEIID_EIRecordID.put(EId.External_ID__c,EId.id);
    }
    for(External_Initiative__c Ext :ei)
    {
      if(mapEIID_EIRecordID!=null && Ext.Project_Level__c=='sub' && mapEIID_EIRecordID.get(ext.Parent_Project_Id__c)!=null)
      {
        ext.Parent_External_Initiative__c=mapEIID_EIRecordID.get(ext.Parent_Project_Id__c);  
        lstExternal.add(Ext);
      }
    }
      update lstExternal;
  }
  // Calling another Batch to map Lead with ExternalInitiative
  public void finish(Database.BatchableContext info) 
  {
     //<VL20171030> Earlier requirement to  Calling another Batch to map Lead with ExternalInitiative but as per new requirement no need to map EI and Lead so we commenting Lead map batch and calling opportunity creation batch
     // Database.executeBatch(new batch_CIC_LeadUpdate(),batchJobSize);
     Database.executeBatch(new batch_CIC_Oppty(),batchJobSize);  
  }
}
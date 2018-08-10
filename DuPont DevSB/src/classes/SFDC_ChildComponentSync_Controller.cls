public class SFDC_ChildComponentSync_Controller {

    public OneDuPontMetaData__c syncRecord{get;set;}
    public String buSelection{get;set;}
    public final ApexPages.StandardController controller = null;
    
     public SFDC_ChildComponentSync_Controller(ApexPages.StandardController stdController){
        this.syncRecord = (OneDuPontMetaData__c)stdController.getRecord();
        this.syncRecord = [SELECT Id, Name, AgCo_CRM_Metadata_Remediation__c,AgCo_CRM_Remediation_Reason_Note__c,
                           AgCo_Remediation_Level__c
                           FROM OneDuPontMetaData__c WHERE Id=:syncRecord.id];
        this.controller = stdController;
        
         
        // Clear the picklists 
        this.syncRecord.AgCo_Remediation_Level__c = null;
        this.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = '*Child Component of a Custom Object being delete*';
        this.syncRecord.AgCo_CRM_Metadata_Remediation__c = null;
        this.buSelection = 'None';
    }
   


     // Sync the metadata 
    public PageReference updateLines(){
        
        if ((buSelection=='None') || (syncRecord.AgCo_Remediation_Level__c==null) ||
            (syncRecord.AgCo_CRM_Remediation_Reason_Note__c==null) ||(syncRecord.AgCo_CRM_Metadata_Remediation__c==null) )
        {
            // SUCCESS
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Required Fields'));
        	return null;
        }
        
        List<OneDuPontMetadata__c> updateList = new List<OneDuPontMetadata__c>();
        for (OneDuPontMetadata__c c : [SELECT ID,
                                       IB_Remediation_Level__c,
                                       IB_CRM_Remediation_Reason_Note__c,
                                       IB_CRM_Metadata_Remediation__c,
                                       NH_Remediation_Level__c,
                                       NH_CRM_Remediation_Reason_Note__c,
                                       NH_CRM_Metadata_Remediation__c,
                                       SS_Remediation_Levels__c,
                                       SS_CRM_Remediation_Reason_Note__c,
                                       SS_CRM_Metadata_Remediation__c,
                                       PS_Remediation_Level__c,
                                       PS_CRM_Remediation_Reason_Note__c,
                                       PS_CRM_Remediation__c,
                                       FMC_Remediation_Level__c,
                                       FMC_CRM_Remediation_Reason_Note__c,
                                       FMC_CRM_Metadata_Remediation__c,
                                       AgCo_Remediation_Level__c,
                                       AgCo_CRM_Remediation_Reason_Note__c,
                                       AgCo_CRM_Metadata_Remediation__c,
                                       EC_Remediation_Level__c,
                                       EC_CRM_Remediation_Reason_Note__c,
                                       EC_CRM_Metadata_Remediation__c,
                                       MS_Remediation_Level__c,
                                       MS_CRM_Remediation_Reason_Note__c,
                                       MS_CRM_Metadata_Remediation__c,
                                       Destination_Org__c
                                       FROM OneDuPontMetadata__c WHERE ParentMetaData__c=:syncRecord.Id])
        {
            
            String destinationOrg = c.Destination_Org__c;
            if (c.Destination_Org__c==null){continue;}
            
            if (buSelection=='IB' && destinationOrg.contains('IB')){ 
                c.IB_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.IB_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.IB_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='AgCo' && destinationOrg.contains('AgCo')){
                c.AgCo_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.AgCo_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.AgCo_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='FMC' && destinationOrg.contains('Remedy')){
                c.FMC_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.FMC_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.FMC_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='PS' && destinationOrg.contains('DPS')){
                c.PS_CRM_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.PS_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.PS_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='SS' && destinationOrg.contains('DSS')){
                c.SS_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.SS_Remediation_Levels__c = syncRecord.AgCo_Remediation_Level__c;
                c.SS_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='EC' && destinationOrg.contains('EC')){
                c.EC_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.EC_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.EC_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='MS' && destinationOrg.contains('MatCo')){
                c.MS_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.MS_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.MS_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            if (buSelection=='NH'&& destinationOrg.contains('NH')){
                c.NH_CRM_Metadata_Remediation__c = syncRecord.AgCo_CRM_Metadata_Remediation__c;
                c.NH_Remediation_Level__c = syncRecord.AgCo_Remediation_Level__c;
                c.NH_CRM_Remediation_Reason_Note__c = syncRecord.AgCo_CRM_Remediation_Reason_Note__c;      
            }
            
            updateList.add(c); 
        }
        
        update updateList;       
        
        // SUCCESS
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Updated the Children Metadata Components'));
        return null;
    }
    
    // Cancel and return
    public PageReference cancel(){
        return controller.cancel();
    }

}
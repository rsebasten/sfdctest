public class SFDC_CorpPackage_SyncLines_Controller {
    
    public Corporate_Package__c corpPackage;
    public final ApexPages.StandardController controller = null;
    public list<copado__Step__c> stepList;
    public List<Attachment> attachmentList;
    public copado__Deployment__c deployRecord;
    public Set<Id> attachmentIdSet;
    public List<Corporate_Metadata_Components__c> deleteList;
    public List<Corporate_Metadata_Components__c> upsertList;
    public Set<String> metadataKeySet;
    public SFDC_CorpPackage_SyncLines_Controller.metadataList corpLines;


    public SFDC_CorpPackage_SyncLines_Controller(ApexPages.StandardController stdController){
        this.corpPackage = (Corporate_Package__c)stdController.getRecord();
        this.corpPackage = [SELECT Id,Copado_Deployment__c FROM Corporate_Package__c WHERE Id=:corpPackage.id];
        this.controller = stdController;
    }
    
    public PageReference syncLines(){
        
        // Initiation
        attachmentIdSet = new Set<Id>();
        upsertList = new List<Corporate_Metadata_Components__c>();
        deleteList = new List<Corporate_Metadata_Components__c>();
        metadataKeySet = new Set<String>();
        String deployId;
          
        // Get the Deploy record
        try{
            deployId = corpPackage.Copado_Deployment__c;
        	deployId = deployId.mid(deployId.indexOf('?id=')+4,15);
        	deployRecord = [SELECT ID FROM copado__Deployment__c WHERE ID=:deployID LIMIT 1];
        }catch (Exception E){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+'Cannot Query the Deployment Record using the id '+deployID+'.  Error: '+E));return null;
        }	
        
        // Get the related steps
        for (copado__Step__c stepList : [SELECT Id,copado__Attachment_Id__c FROM copado__Step__c WHERE copado__Deployment__c=:deployRecord.Id AND copado__Type__c='Metadata']){
            attachmentIdSet.add(stepList.Id);
        }		
        
        // Parse the Attachments JSON to internal object 
        try{    
            attachmentList = [SELECT Id,Body FROM Attachment WHERE ParentId IN:attachmentIdSet]; 
            for (Attachment a : attachmentList){
                String s='{"itemList":'+a.Body.toString()+'}';
                corplines = (SFDC_CorpPackage_SyncLines_Controller.metadataList) System.JSON.deserializeStrict(s, SFDC_CorpPackage_SyncLines_Controller.metadataList.class);
            	
                // Inner Loop through the corp lines
                for (SFDC_CorpPackage_SyncLines_Controller.metadataItem line: corplines.itemList){
                	metadataKeySet.add(line.t+'.'+line.n);
            	}
            }   
        }catch (Exception E){ 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot Parse the Attachments.  Error: '+E));
            return null;
        }
        
        // Build lists for deletion
        deleteList = new List<Corporate_Metadata_Components__c>();
        try{
        	deleteList = [SELECT ID FROM Corporate_Metadata_Components__c WHERE Corporate_Package__c=:corpPackage.Id];
        }catch (Exception E){} 
        
        // Build List for upsert
        for (OneDuPontMetadata__c metaMapping : [SELECT ID FROM OneDuPontMetadata__c WHERE MetaDataName__c IN:metadataKeySet]){
            Corporate_Metadata_Components__c newC = new Corporate_Metadata_Components__c();
            newC.Corporate_Package__c = corpPackage.Id;
            newC.Metdata_Mapping_One_Dupont__c = metaMapping.Id;
            upsertList.add(newC);
        } 
        
        // Insert and delete the Corp Lines
        try{
            delete deleteList;
            upsert upsertList;
        }catch (Exception E){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Inserting Component Records  Error: '+E));return null;
        }

        // SUCCESS
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Synced the Metadata Lines'));
        return null;
    }
    
    public PageReference cancel(){return controller.cancel();}
    
    // Inner class for JSON Deserialize
    // 
    public class metadataList{
        public List<metadataItem> itemList;
    }
    
    public class metadataItem{
        public String t;
        public String n;
        public Boolean s;
    }
}
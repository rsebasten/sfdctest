public class SFDC_MetadataSync_Controller {

	public Metadata_Sync__c metadataSyncRecord;
    public final ApexPages.StandardController controller = null;
    
     public SFDC_MetadataSync_Controller(ApexPages.StandardController stdController){
        this.metadataSyncRecord = (Metadata_Sync__c)stdController.getRecord();
        this.metadataSyncRecord = [SELECT Id, Name, Copado_Deployment__c, Sync_Level__c, Last_Metadata_Sync__c FROM Metadata_Sync__c WHERE Id=:metadataSyncRecord.id];
        this.controller = stdController;
    }
     
    // Sync the metadata 
    public PageReference syncLines(){
        // Initiation
        Set<Id> attachmentIdSet = new Set<Id>();
        copado__Deployment__c deployRecord;
        List<Attachment> attachmentList;
        
        Set<String> jsonKeySet = new Set<String>();

        // Query Copado Deploy Record
        try{
        	deployRecord = [SELECT ID FROM copado__Deployment__c WHERE Id=:metadataSyncRecord.Copado_Deployment__c LIMIT 1];
        }catch (Exception E){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+'Cannot Query the Deployment Record using the id '+metadataSyncRecord.Copado_Deployment__c+'.  Error: '+E));return null;
        }	

        // Query the steps.  SHould be 1
        for (copado__Step__c stepList : [SELECT Id,copado__Attachment_Id__c FROM copado__Step__c WHERE copado__Deployment__c=:deployRecord.Id AND copado__Type__c='Metadata']){
           	System.debug('StepID ' + stepList.Id);
            attachmentIdSet.add(stepList.Id);
        }		

        // Use Case 1: metadata records in the deployment which exist in OneDuPontMetaData__c
        // Rules:
        // - Add the BU to DestOrg to OneDuPontMetaData__c records if not master sync
        // - Update OneDuPontMetaData__c status and date fields for the corresponding BU
        // Logic:
        // - Retrieve Metadata keys from Deployment (JSON)
        // - Query OneDuPontMetaData__c for records matching the metadata keys
        // - Update the values
        // - Update the records
        try{    
            attachmentList = [SELECT Id,Body FROM Attachment WHERE ParentId IN:attachmentIdSet]; 
            for (Attachment a : attachmentList){
           		System.debug('AttachmentID ' + a.Id);
                String s='{"itemList":'+a.Body.toString()+'}';
                s=s.remove(',"s":true');
                s=s.replace('","n":"', '.');
                System.Debug(s.left(200));

                // Deserialize using the string             
                SFDC_MetadataSync_Controller.metadataList jsonLine = (SFDC_MetadataSync_Controller.metadataList) System.JSON.deserializeStrict(s, SFDC_MetadataSync_Controller.metadataList.class);
                s = null; // Clear the string
              
                // Call Process
                processJSON(jsonLine,metadataSyncRecord.Sync_Level__c,metadataSyncRecord.Name);     
            }
        }catch (Exception E){ 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot Parse the Attachments.  Error: '+E));
            return null;
        }

        // Update the Metadata Sync record with the date time stamp
        metadataSyncRecord.Last_Metadata_Sync__c = system.today();
        Update metadataSyncRecord;
        
        // SUCCESS
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Synced the Metadata'));
        return null;
    }
    
    @future
    private static void asyncInsert(Set<String> jKeySet, String syncLevel, String bu)
    {
        System.Debug('in the asyncInsert '+jKeySet);
        List<OneDuPontMetaData__c> mds = new List<OneDuPontMetaData__c>();
        
        // Get a map of exisitng metadata types
        Map<String,ID> metadataTypeMap = new Map<String,Id>();
        for (MetadataTypeSF__c t : [SELECT ID,ExternalId__c FROM MetadataTypeSF__c]){
            metadataTypeMap.put(t.ExternalId__c,t.Id);
        } 
        
        for (String key2 : jKeySet) { 
            System.Debug('Looping with '+key2);
            OneDuPontMetaData__c md = new OneDuPontMetaData__c();
            md.MetaDataName__c = key2;
            md.External_ID__c = key2;
            md.Destination_Org__c = '';
            setBuStatus(md, bu, syncLevel);
            try{
                String mType = key2.substringBefore('.');  // Fix to get the First part of the key which should be the Metadata Type
            	md.MetaDataType__c = metadataTypeMap.get(mType);
                mds.add(md);
            }catch (Exception E){
                System.Debug('Exception '+E);
                continue;}
        }    
        insert mds;
    }
        
    
    private static void processJSON(SFDC_MetadataSync_Controller.metadataList jsonLines,String syncLevel, String bu) {
        
        Set<String> jsonKeySet = new Set<String>();       

         // Inner Loop through the corp lines
        for (SFDC_MetadataSync_Controller.metadataItem line: jsonLines.itemList){
            jsonKeySet.add(line.t);
        }
        
        // Clear Item lines to reduce cache
        jsonLines.itemList.clear();
        jsonLines = null;
        
        // Batch Mode 1 - Update all existing with BU
        SFDC_MetadataSyncBatchable a = new SFDC_MetadataSyncBatchable();
        a.batchMode = 1;
        a.Name = bu; 
        a.syncLevel = syncLevel;
        a.jkeySet = jsonKeySet;
        
        // Batch Mode 2 - Update all not in list with removing BU - IE removed from BU
		SFDC_MetadataSyncBatchable b = new SFDC_MetadataSyncBatchable();  
        b.batchMode = 2;
        b.Name = bu;
        b.syncLevel = syncLevel;
        b.jKeySet = jsonKeySet;
        
        // Batch Mode 3 - Delete all orphans
		SFDC_MetadataSyncBatchable c = new SFDC_MetadataSyncBatchable();  
        c.batchMode = 3;
        c.Name = bu;
        c.syncLevel = syncLevel;
        c.jKeySet = jsonKeySet;
        
        // Execute Batches      
        if(!Test.isRunningTest()){
            Database.ExecuteBatch(a,200);
            Database.ExecuteBatch(b,200);
            Database.ExecuteBatch(c,200);
        }
        
       System.debug(LoggingLevel.INFO, 'Insert List Size before removing existing' + jsonKeySet.size());
        
        // REMOVE Existing Metadata Lines from List.  Remaining should be new Inserts
        for (OneDuPontMetaData__c md : [SELECT External_ID__c FROM OneDuPontMetaData__c WHERE External_ID__c IN :jsonKeySet]) {
            jsonKeySet.remove(md.External_ID__c);
        }
               
        System.debug(LoggingLevel.INFO, 'Insert List Size after removing existing' + jsonKeySet.size());
      
        // Divide up into batches for Async call
        Set<String>tempKeySet = new Set<String>();
        for (String key2 : jsonKeySet) {   
            tempKeySet.add(key2);
            // Insert in batches of 10K
            if (tempKeySet.size() == 9999) {
                asyncInsert(tempKeySet,syncLevel,bu);         
                tempKeySet.clear();
            } 
        }
        // Insert last batch
        if (tempKeySet.size()>0){
            asyncInsert(tempKeySet,syncLevel,bu);
            tempKeySet.clear();
        }
    }

    public static OneDuPontMetadata__c setBuStatus(OneDuPontMetaData__c md, String bu, String status) {
             
        if (bu.equals('AgCo')) {
            md.AgCo_Status__c = status;
            md.AgCO_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('MatCo')) {
            md.Matco_Status__c = status;
			md.Matco_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('NH')) {
            md.N_H_Status__c = status;
            md.NH_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('IB')) {
            md.IB_Status__c = status;
            md.IB_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('DPS')) {
            md.DPS_Status__c = status;
            md.DPS_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('DSS')) {
            md.DSS_Status__c = status;
            md.DSS_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('EC')) {
            md.E_C_Status__c = status;
            md.EC_Last_Mapped_Date__c = system.today();
        }
        else if (bu.equals('Remedy')) {
            md.Remedy_Status__c = status;
            md.Remedy_Last_Mapped_Date__c = system.today();
        }
        
        // Set Destination for all BUs 
        if (md.Destination_Org__c==null){
                md.Destination_Org__c = bu;
            }else if (!md.Destination_Org__c.contains(bu))
                md.Destination_Org__c += '; ' + bu;
        
        return md;
    }
     
    // Cancel and return
    public PageReference cancel(){
        return controller.cancel();
    }
    
        // Inner class for JSON Deserialize
    // 
    public class metadataList{
        public List<metadataItem> itemList;
    }
    
    public class metadataItem{
        public String t;
    }
    
  
}
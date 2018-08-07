global class SFDC_InstallPackageBatch implements Database.Batchable<sObject>{
	
    global String query;
    global Map<String,Id> objectMap;

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        // Query to get the id of the Custom Object Type
        MetadataTypeSF__c customObjectType = [SELECT ID,Name,ExternalId__c FROM MetadataTypeSF__c WHERE Name='CustomObject' LIMIT 1];
        
        query = 'SELECT ID,Name,ParentMetaData__c,MetaDataType__c,External_ID__c '
            +   'FROM OneDuPontMetaData__c WHERE MetaDataType__c !=\''+customObjectType.id+'\''; 
        System.Debug(query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext info,List<OneDuPontMetadata__c> scope){
        
         // Query to get the id of the Install Package Type
        MetadataTypeSF__c customObjectType = [SELECT ID,Name,ExternalId__c FROM MetadataTypeSF__c WHERE Name='CustomObject' LIMIT 1];
        
        // Put the Object -> Id in a map
        objectMap = new Map<String,Id>();
        for (OneDuPontMetaData__c md : [SELECT Id,Name,External_Id__c FROM OneDuPontMetadata__c WHERE MetadataType__c=:customObjectType.id]){
			String baseKey = md.External_Id__c;
            String workFlowKey;
            String translationKey; 
            String layoutKey;
            String picklistKey;
            baseKey= baseKey.remove('CustomObject.');
         	workFlowKey = 'Workflow.'+baseKey;
            translationKey = 'CustomObjectTranslation.'+baseKey;
            layoutKey = 'Layout.'+baseKey;  
            picklistKey = 'PicklistValue.'+baseKey;
            baseKey='.'+baseKey+'.';
            System.Debug('Adding to map '+baseKey+' -'+md.Id);
            objectMap.put(workFlowKey,md.Id);
            objectMap.put(translationKey,md.Id);
            objectMap.put(layoutKey,md.Id);
            objectMap.put(picklistKey,md.Id);
            objectMap.put(baseKey,md.Id);
        }
               
        for (OneDuPontMetadata__c mc : scope){
            String compare = mc.External_Id__c;
            mc.ParentMetaData__c = null; // Clear it
            for (String s : objectMap.keySet()){
                System.Debug('s = '+s);
                System.Debug('Compare ='+compare);
                if (compare.contains(s)){
                    mc.ParentMetaData__c = objectMap.get(s); // Add the Parent
                }
            }
        }
        update scope;
    }
    global void finish(Database.BatchableContext info){}
}
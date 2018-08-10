global class SFDC_InstalledPackageBatch implements Database.Batchable<sObject>{
	
    global String query;
    global Map<String,Id> installPackageMap;

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        // Query to get the id of the Install Package Type
        MetadataTypeSF__c installedPackageType = [SELECT ID,Name,ExternalId__c FROM MetadataTypeSF__c WHERE Name='InstalledPackage' LIMIT 1];
        
        query = 'SELECT ID,Name,InstalledPackage__c,MetaDataType__c,External_ID__c '
            +   'FROM OneDuPontMetaData__c WHERE MetaDataType__c !=\''+installedPackageType.id+'\''; 
        System.Debug(query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext info,List<OneDuPontMetadata__c> scope){
        
         // Query to get the id of the Install Package Type
        MetadataTypeSF__c installedPackageType = [SELECT ID,Name,ExternalId__c FROM MetadataTypeSF__c WHERE Name='InstalledPackage' LIMIT 1];
        
        // Put the Package -> Id in a map
        installPackageMap = new Map<String,Id>();
        for (OneDuPontMetaData__c md : [SELECT Id,Name,External_Id__c FROM OneDuPontMetadata__c WHERE MetadataType__c=:installedPackageType.id]){
			String key = md.External_Id__c;
            key= key.remove('InstalledPackage.');
            key +='__';
            System.Debug('Adding to map '+key+' -'+md.Id);
            installPackageMap.put(key,md.Id);
        }
               
        for (OneDuPontMetadata__c mc : scope){
            String compare = mc.External_Id__c;
            mc.installedPackage__c = null; // Clear it
            for (String s : installPackageMap.keySet()){
                System.Debug('s = '+s);
                System.Debug('Compare ='+compare);
                if (compare.contains(s)){
                    mc.InstalledPackage__c = installPackageMap.get(s); // Add the installed package
                }
            }
        }
        update scope;
    }
    global void finish(Database.BatchableContext info){}
}
global class SFDC_MetadataSyncBatchable implements Database.Batchable<sObject>{
	
    global String query;
    global String name;
    global String syncLevel;
    global Set<String> jKeySet;
    global Integer batchMode;

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        if (batchMode==1){
            query = 'SELECT Destination_Org__c, MetaDataName__c, One_DuPont_Source__c '
                    + 'FROM OneDuPontMetaData__c WHERE ';
                for (String a : jKeySet){
                    query +='External_ID__c = \''+a+'\' OR ';
                }
            query = query.substring(0, query.length()-4); 
        }
        
        if (batchMode==2){
            query = 'SELECT Destination_Org__c, MetaDataName__c, One_DuPont_Source__c '
                + 'FROM OneDuPontMetaData__c WHERE Destination_Org__c != \''+name+'\' AND Destination_Org__c includes (\''+name+'\') AND MetaDataType__c !=\'a2f41000001qP1IAAU\' AND ' ;
                for (String a : jKeySet){
                    query +='External_ID__c != \''+a+'\' AND ';
                }
            query = query.substring(0, query.length()-4); 
        }
        
        if (batchMode==3){
            query = 'SELECT Destination_Org__c, MetaDataName__c, One_DuPont_Source__c '
                  + 'FROM OneDuPontMetaData__c WHERE Destination_Org__c = \''+name+'\' AND MetaDataType__c !=\'a2f41000001qP1IAAU\' AND ' ;
                for (String a : jKeySet){
                    query +='External_ID__c !=\''+a+'\' AND ';
                }
            query = query.substring(0, query.length()-4); 
        }
            
        System.Debug(query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext info,List<OneDuPontMetadata__c> scope){
        
        List<OneDuPontMetadata__c> removeList = new List<OneDuPontMetadata__c>(); 
        for (OneDuPontMetadata__c mc : scope){
            if (batchMode==1){
        		mc = SFDC_MetadataSync_Controller.setBuStatus(mc, name, syncLevel);
            }
            if (batchMode==2){
                String s = mc.Destination_Org__c;
                
                if (s.contains(name+';')){s = s.remove(name+';');}
                else if (s.contains(name)){s = s.remove(name);}
                mc.Destination_Org__c = s;
            }
            if (batchMode==3){
                mc.Destination_Org__c = '';
            }
        }
        // Update
        if (batchMode==1 || batchMode==2){
        	update scope;
        }
        // Update
        if (batchMode==3){
            update scope;  // Changed to an update to just clear the destination org for single BU removal rather than delete
        }
    }
    global void finish(Database.BatchableContext info){}
}
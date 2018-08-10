global class BatchProcessANTLogs implements Database.Batchable<sObject>{

   

   global Database.QueryLocator start(Database.BatchableContext BC){
      String NewStatus = 'New'; 
      String query = 'SELECT ID, Name, Log__c, Status__c, Target_Org__c  FROM ANT_Log__c WHERE Status__c=:NewStatus';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<ANT_Log__c> scope){
     
     List<ANTLogWrapper> ANTLogWrprList = new List<ANTLogWrapper>();
     
     for(ANT_Log__c al : scope){
         ANTLogWrapper alw = new ANTLogWrapper(al);
         System.debug('# ANTLogWrapper MetaData:-['+alw.MetaDataName+']-');
         System.debug('# ANTLogWrapper Dependent MetaData Set:-['+alw.DependentMetaDataNameSet+']-'); 
         ANTLogWrprList.add(new ANTLogWrapper(al));  
     }
     
     Map<String, OneDuPontMetaData__c> MetaDataObjectMap = ANTLogManager.getMetaDataObjectMap(ANTLogWrprList);
     
     List<Remediation_Metadata_Dependency__c> RemMDList = ANTLogManager.createRemediationMetadataDependencyRecords(ANTLogWrprList, MetaDataObjectMap);
     
     if(!RemMDList.isEmpty()){
         Schema.SObjectField f = Remediation_Metadata_Dependency__c.Fields.External_ID__c;
         Database.UpsertResult [] RemmDDepUpsertRsl = Database.upsert(RemMDList,f,false); 
         System.debug('# RemmDDepUpsertRsl ->'+RemmDDepUpsertRsl); 
     }
     
     List<ANT_Log__c> AntLogList = new List<ANT_Log__c>();
     for(ANTLogWrapper alw : ANTLogWrprList){
         ANT_Log__c al = alw.ANTLog;
         al.Status__c = alw.ProcessingStatus;
         al.Processing_Log__c = alw.ProcessingLog;
         AntLogList.add(al);
     }
     
     if(!AntLogList.isEmpty()){
         update AntLogList;
     }
     
    }

   global void finish(Database.BatchableContext BC){
   }
}
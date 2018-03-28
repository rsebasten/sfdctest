/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Delete all orphaned Metadata Items
Database.executeBatch(new batchDeleteMetadata(),200);
TES20130710 fixed bug in batchDeleteMetadata()
<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
********************************************************************************/
global class batchDeleteMetadata implements Database.Batchable<Sobject>, Database.Stateful  {
    string query;
    global boolean softDelete;
    global DmlResults unsuccessfuls;

    global batchDeleteMetadata(){
        //this deletes all the orphaned metadataitems
        softDelete=false; //TES20130710
        query='SELECT Id FROM MetadataItem__c WHERE Metadata__c=null OR Metadata__r.IsDeleted__c=true';
        query+=' OR RelatedMetadata__c=null OR RelatedMetadata__r.IsDeleted__c=true';
        if (Test.IsRunningTest())
            query+=' LIMIT 200';    
        }
    global batchDeleteMetadata(string q) { this(q, false);}
    global batchDeleteMetadata(string q, boolean softDel) {
        softDelete=softDel;
        query=q;
        if (Test.IsRunningTest())
            query+=' LIMIT 200';    
        }   
            
    global Database.QueryLocator start(Database.BatchableContext BC){
        unsuccessfuls = new DmlResults();
        return Database.getQueryLocator(query);
        }
        
    global void execute(Database.BatchableContext BC, LIST<SObject> scope){
        if (softDelete) {
            LIST<Metadata__c> mdToSoftDelete = (LIST<Metadata__c>) scope;
            for (Metadata__c md : mdToSoftDelete)
                Metadata.setMetadataToIsDeleted(md);
            unsuccessfuls.add(new DmlResults(database.update(mdToSoftDelete,false),mdToSoftDelete));
        }
        else
            unsuccessfuls.add(new DmlResults(database.delete(scope,false),scope));
    }
    
    global void finish(Database.BatchableContext BC) {
    //<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
        //utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
        //<20170908:Shubham Agarwal> : End 
    }
}
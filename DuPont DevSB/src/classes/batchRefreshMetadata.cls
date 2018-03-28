/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to Refresh Metadata
Database.executeBatch(new batchRefreshMetadata(),1);
Database.executeBatch(new batchRefreshMetadata(new SET<string>{'Account'}),1);

TES111116 - using DMLResults to limit exceptions (currently limited to 1000) this was causing heap space issues
    when first run since there were a lot of missing metdata items 
    
TES20130508 finish(): lowered the limit from 3000 to 1000 for deleting picklist values due to gov limit errors.
RS20160128 Execute(): Rohit saini 2016/01/28 Added try catch around whole code in Execute method Issue IS ID-00064089
<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
********************************************************************************/
global class batchRefreshMetadata implements Database.Batchable<Schema.SObjectType>, Database.AllowsCallouts, Database.Stateful {
    
    
    global DmlResults unsuccessfuls;
    private string sess;
    private LIST<string> sobjectList;

    global batchRefreshMetadata() { this(UserInfo.getSessionId(),null); }
    global batchRefreshMetadata(string so) { this(UserInfo.getSessionId(), new SET<string>{so}); }
    global batchRefreshMetadata(SET<string> sos) { this(UserInfo.getSessionId(),sos); }
    global batchRefreshMetadata(string session, SET<string> sos) {
        unsuccessfuls = new DmlResults();
        if (sos!=null && sos.size()>0 ) {
            sobjectList = new LIST<string>(sos);
        }
        sess = session;
    }
        
    global LIST<Schema.SObjectType> start(Database.BatchableContext BC){
        
        if (sess!=null) 
            unsuccessfuls.add(Metadata.refreshSObjectForceIds(sess).results);
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if (Test.isRunningTest())
            sobjectList = new LIST<string>{string.valueOf(gd.values()[0])};

        if (sobjectList!=null) {
            LIST<Schema.SObjectType> rtn = new LIST<Schema.SObjectType>();
            for (string s : sobjectList) {
                if (gd.containsKey(s.toLowercase()))
                    rtn.add(gd.get(s.toLowercase()));
            }
            return rtn; 
        }
        else
            return gd.values();
        
    }
        
    global void execute(Database.BatchableContext BC, LIST<Schema.SObjectType> scope) {
       //Rohit saini 2016/01/29 Added try catch around whole code of Execute method Issue IS ID-00064089
        try{ 
        for (Schema.SObjectType sty : scope) {
            
            //Issue with payload too big (this seems to only happen in a test env)
            if (sess!=null) {
                unsuccessfuls.add(Metadata.refreshFieldFileProperties(String.valueOf(sty),sess).results);
            }
            unsuccessfuls.add(MetaData.refreshMetaDatabase(sty).results);
        } 
        }Catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'Exception :'+e.getStackTraceString());
        }   
    }

        
    global void finish(Database.BatchableContext BC) {
        LIST<metadata__c> mdToDelete = [Select Id, Name, fActiveStatus__c, parent__r.name from Metadata__c 
            where type__c='PICKLISTENTRY' AND 
            (   (parent__c=null OR parent__r.isDeleted__c=true)
                OR lastmodifiedDate < LAST_N_DAYS:1) LIMIT 1000];
        if (mdToDelete.size()>0)
            delete mdToDelete;

        Metadata.processDeleteOrphanMetadataRecords();    
        //<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.   
       // utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);   
         //<20170908:Shubham Agarwal> : End 
    }

}
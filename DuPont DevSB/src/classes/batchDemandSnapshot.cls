/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to DoSomething
Database.executeBatch(new batchDemandSnapshot(),200);
<AB20140911> - Updated for updating fields Last Snapshot Taken and Last Snapshot Taken By
<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
********************************************************************************/
global class batchDemandSnapshot implements Database.Batchable<Sobject>, Database.Stateful {

    global DmlResults unsuccessfuls;
    
    
    global batchDemandSnapshot() {
        unsuccessfuls= new DmlResults();
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        if (Test.IsRunningTest()) {
        return Database.getQueryLocator([
            SELECT Id FROM DemandItemSchedule__c WHERE DemandItem__r.Demand__r.SnapShotDay__c =: Date.Today().day() 
                AND BaseDate__c >= :Date.Today().addMonths(-1) LIMIT 200]);
        }
        return Database.getQueryLocator([
            SELECT Id FROM DemandItemSchedule__c WHERE DemandItem__r.Demand__r.SnapShotDay__c =: Date.Today().day()
                AND BaseDate__c >= :Date.Today().addMonths(-1) ]);
        }
        
    global void execute(Database.BatchableContext BC, LIST<SObject> scope) {
            Util.Describe descrDIS = new Util.Describe('DemandItemSchedule__c');
            LIST<DemandItemSchedule__c> diss =  (LIST<DemandItemSchedule__c>) descrDIS.getObjects(scope);
            for (DemandItemSchedule__c dis : diss) {
                integer offset = Date.Today().monthsBetween(dis.BaseDate__c);
                if (offset>=0) {
                    string qtySSField = 'QtyFcst'+offset+'__c'; 
                    string revSSField = 'RevFcst'+offset+'__c';
                    if (descrDIS.FieldExist(qtySSField))
                        dis.put(qtySSField,dis.QtyFcst__c);
                    if (descrDIS.FieldExist(revSSField))
                        dis.put(revSSField,dis.RevFcst__c);     
                     //   <AB20140911> Starts
                     dis.Last_Snapshot_Date__c = Date.today();
                     dis.Last_Snapshot_Taken_By__c = UserInfo.getUserId();
                    //<AB20140911> Ends
                }
            }
            unsuccessfuls.add(new DmlResults(database.update(diss,false),diss));
    } 
    
    global void finish(Database.BatchableContext BC) {
     //<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
       // utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
       //<20170908:Shubham Agarwal> : End  
    }

}
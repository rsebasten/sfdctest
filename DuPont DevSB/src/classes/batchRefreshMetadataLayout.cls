/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class to upsert the metadata__c and MetadataItem__c
 to the information on: 
    recordtype->picklist relation  (MetadataItem__c)
    recordtype->Layout relation (metadata__c)
    Layout->Field relation (MetadataItem__c)

//Use batch of 1 for all objects
Database.executeBatch(new batchRefreshMetadataLayout(),1);

//Can use batch of 5 for an single object but surprisingly it runs faster with batch of 1
Database.executeBatch(new batchRefreshMetadataLayout('Account'),5);
<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.

********************************************************************************/
global class batchRefreshMetadataLayout implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {

    global DmlResults unsuccessfuls;
    private string sess;
    private string sObjectType;
    
    global batchRefreshMetadataLayout() { this(null); }
    global batchRefreshMetadataLayout(string aSObjectType) {
        unsuccessfuls = new DmlResults();
        sess = UserInfo.getSessionId();
        sObjectType = aSObjectType;
    }

    global LIST<RecordType> start(Database.BatchableContext BC){    
        
        SET<string> SObjs = new SET<string>();  
        
        if (sObjectType!=null)
            SObjs.add(sObjectType);
        else {
            //get all objects
            for ( Schema.Sobjecttype sty :  Schema.getGlobalDescribe().values()) {
                Schema.Describesobjectresult DSR = sty.getDescribe(); 
                //strips out some of backend objects _History Tables, etc...
                if (DSR.getKeyPrefix()!=null)
                    SObjs.add(String.valueOf(sty));
            }
        }
        
        //  determine the complex objects (where rtype count>5)
        //  these will need to be done recordtype by recordtype     
        SET<string> complexSObjs = new SET<string>();
        for (AggregateResult ar: [
            Select sobjectType from RecordType 
            Where sobjectType in: SObjs
            group By sobjectType
            having count(Id)>5 ]) {
                complexSObjs.add((string)ar.get('sobjectType'));
            }   

        LIST<RecordType> rtn = new LIST<RecordType>([
            Select Id, SobjectType 
            from RecordType 
            where SobjectType in : complexSObjs 
            ]);
            
        SObjs.removeAll(complexSObjs);
        
        for (string t : SObjs)
            rtn.add(new RecordType(sobjectType=t));
        
        if (test.isRunningTest())
            return new LIST<RecordType>{rtn[0]};
        else
            return rtn;
        }
        
    global void execute(Database.BatchableContext BC, LIST<RecordType> scope) {
        API.SESSION=sess;
        
        //Can use batch of 5 for an single object but surprisingly it runs faster with batch of 1
        SET<Id> recordTypeIds = new SET<Id>();
        for (RecordType rt : scope)
            recordTypeIds.add(rt.id);
        unsuccessfuls.add(Metadata.refreshLayoutInfo(scope[0].SObjectType,recordTypeIds));
        
    } 
    

    global void finish(Database.BatchableContext BC) {
        API.SESSION=sess;
        unsuccessfuls.add(Metadata.processDeleteLayout());
        //<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
       // utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);
         //<20170908:Shubham Agarwal> : End  
    }
    

}
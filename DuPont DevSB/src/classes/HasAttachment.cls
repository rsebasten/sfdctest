/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  main class for HasAttachment, This utility allows you to track if a record 
has an attachment related to it,  by adding a custom checkbox field with the API name 
HasAttachment__c. 

Instructions:

1. add a custom checkbox field with the API name HasAttachment__c
2. refresh the status of this field by using the command below:
        HasAttachment.Refresh(‘{SObjectType}’);

TES20120503:  Updated hasAttachment to support hasNote
********************************************************************************/
public without sharing class HasAttachment {

    public static final     string HAS_NOTE_FIELD           {get; set;} 
    public static final     string HAS_ATTACHMENT_FIELD     {get; set;} 
    static {    HAS_NOTE_FIELD          ='HasNote__c'; 
                HAS_ATTACHMENT_FIELD    ='HasAttachment__c'; 
        }
        
    private static boolean FUTURE = false;          //Dont use auto optimizer, always run trigger async 
    private static integer BATCHSIZE = 50;          //future Batchsize (default = 50)
    private static integer ASYNC_THRESHOLD = 15;    //number of sobjectTypes in batch to trigger Async process (default = 20-)

    private static Map<String, String> globalPrefixMap  = Util.getGlobalPrefixMap();
    

    public class HasNoteException extends Exception {} 
    
    public static void ProcessHasNoteOrAttachment(LIST<sobject> sos, boolean isDelete, string fieldname ) {
        
                
        //MAP all the parent Types and Ids
        SET<Id> pIds = new SET<Id>();
        for (sobject so : sos) 
            pIds.add((Id) so.get('ParentId'));
        
        //If delete check for siblings and remove from population
        if (isDelete)
            pIds.removeAll(getSiblings(pIds));
        
        //Map parents to get a count and determine the best plan of action (sync/async)
        MAP<String,SET<Id>> parents=createParentMap(pIds);

        //Update the Parents (Limits.getLimitQueries() fro trigger = 20)
        if (parents.size()<= ASYNC_THRESHOLD && (!FUTURE) ) {
                updateHasNoteOrAttachment(parents,isDelete, fieldname);
        }
        else {
            //Do this with a batch and future calls
            MAP<integer,MAP<String,SET<Id>>> batches = new MAP<integer,MAP<String,SET<Id>>>();
            integer batchCnt=0;
            integer batchItemCnt=0;
            batches.put(batchCnt, new MAP<String,SET<Id>>());
            for ( string sot : parents.keyset() ) {
                batches.get(batchCnt).put(sot,parents.get(sot));
                batchItemCnt++;
                if ( batchItemCnt >= BATCHSIZE ) {
                    batches.put(++batchCnt, new MAP<String,SET<Id>>());
                    batchItemCnt=0;
                }   
            }
            
            system.debug(batches);
            for (integer i : batches.keySet()) {
                //dismantle parent map since the type is not allowed in @future calls
                SET<Id> parentIds = new SET<Id>();
                for ( string sot : parents.keyset() ) 
                    parentIds.addAll(parents.get(sot));

                futureUpdateHasNoteOrAttachment(pIds, isDelete, fieldname);
            }
        }
    }
            

    //Only send a Map of getLimitFieldsDescribes() otherwise a limit error will occure
    private static void updateHasNoteOrAttachment(SET<Id> parentIds, boolean isDelete, string fieldname) { updateHasNoteOrAttachment(HasAttachment.createParentMap(parentIds),isDelete, fieldname); }
    private static void updateHasNoteOrAttachment(MAP<String,SET<Id>> parents, boolean isDelete, string fieldname) {
        system.debug('Query Limits: '+ Limits.getQueries()+'/'+Limits.getLimitQueries());
        for (string parentType : parents.KeySet()) {
            //if (Limits.getQueries() < Limits.getLimitQueries() ) {
                try {
                    LIST<sobject> writeToObjects = database.query('Select Id, '+fieldname+' from '+parentType+' WHERE id in '+Util.inClause(parents.get(parentType))+' AND '+fieldname+'='+isDelete);
                    for (sobject so : writeToObjects)
                        so.put(fieldname,(!isDelete));
                    database.update(writeToObjects,false);
                    system.debug('UPDATE: '+writeToObjects+'  |||\n Query Limits: '+ Limits.getQueries()+'/'+Limits.getLimitQueries());
                }       
                catch(Exception ex) {}
        }
    }

    @future
    private static void futureUpdateHasNoteOrAttachment(SET<Id> parentIds, boolean isDelete, string fieldname) {
        updateHasNoteOrAttachment(parentIds, isDelete, fieldname);
    }



    
/////////////////////////////////////////////////////////////////////////////
// Batch Methods
/////////////////////////////////////////////////////////////////////////////
    public static void refreshHasAttachment(string sobjectType) {
        refresh(sobjectType, HAS_ATTACHMENT_FIELD, false);
    }
    public static void refreshHasNote(string sobjectType) {
        refresh(sobjectType, HAS_NOTE_FIELD, true);
    }
    
    private static void refresh(string sobjectType, string fieldname, boolean isNote) {
        
        Util.Describe descr;
        try {
            descr = new Util.Describe(sobjectType);
        }
        catch (Exception ex) {
            throw new HasNoteException('The sObject type is invalid.');
        }
                
        if (! descr.FieldExist(fieldname))
            throw new HasNoteException('The sObject does not contain an '+fieldname+' field.');
            
        if (descr.fieldInfo(fieldname).getSoapType()!=Schema.Soaptype.Boolean )
            throw new HasNoteException('The '+fieldname+' field must be of boolean type.');
            
        string query='Select Id from '+sobjectType;
        
       Database.executeBatch(new batchRecalcHasAttachment(query, isNote),200);
    }
/////////////////////////////////////////////////////////////////////////////
    public static DmlResults executeBatch(LIST<sobject> scope) { return executeBatch(scope, false); }
    public static DmlResults executeBatch(LIST<sobject> scope, boolean isNote) {    

        DmlResults rtn = new DmlResults();  
    
        if (scope!=null && scope.size()>0 )  {
            string sobjectType = String.valueOf(scope[0].getSObjectType());     

            SET<id> scopeIds = new SET<id>();
            SET<id> WithntIds = new SET<id>();
            SET<id> WithoutntIds = new SET<id>();   
            
            //get scopeIds
            for (Sobject so : scope)
                scopeIds.add(so.id);
        
            //WithntIds - Ids of records with Notes
            string obj='Attachment';
            string fieldname = HAS_ATTACHMENT_FIELD;
            if (isNote) {
                obj='Note';
                fieldname = HAS_NOTE_FIELD;
            }
            string query='Select ParentID from '+obj+' WHERE ParentId In'+Util.inClause(scopeIds);
            for (sobject so : database.query(query) )
                WithntIds.add((Id) so.get('ParentId'));
     
            //WithoutntIds: get Ids of records witout Notes
            WithoutntIds.AddAll(scopeIds);
            WithoutntIds.RemoveAll(WithntIds);
                
                
            //Update records where hasNote=false but should be true 
            if (WithntIds.size()>0) {
                query='Select Id, '+fieldname+' FROM '+sobjectType;
                query+=' WHERE id in '+Util.inClause(WithntIds)+' AND '+fieldname+'=false';
                query+=' FOR UPDATE';
                LIST<sobject> updateTrue  = database.query(query);
                if (updateTrue.size()>0) {
                    for (sobject so : updateTrue )
                        so.put(fieldname,true);
                
                    rtn.add(new DmlResults(Database.update(updateTrue,false),updateTrue));

                }
            }
    
            //Update records where hasNote=ftrue but should be false        
            if (WithoutntIds.size()>0) {
                query='Select Id, '+fieldname+' FROM '+sobjectType;
                query+=' WHERE id in '+Util.inClause(WithoutntIds)+' AND '+fieldname+'=true';
                query+=' FOR UPDATE';
                LIST<sobject> updateFalse  = database.query(query);
                if (updateFalse.size()>0) {
                    for (sobject so : updateFalse )
                        so.put(fieldname,false);
                
                rtn.add(new DmlResults(Database.update(updateFalse,false),updateFalse));
                    
                }
            }
        }
        return rtn; 
    }


    //get parentId of SET that have other attachments 
    public static SET<Id> getSiblings(SET<ID> parentIds) {

        SET<Id> siblings = new SET<Id>();
        for (AggregateResult ar : [
                Select ParentId
                from Attachment 
                where ParentId in :parentIds 
                group by ParentId
                having count(Id) > 0    
                ])
            siblings.add((Id) ar.get('ParentId'));          
        return siblings;
    }

    //create grouping map from a set of multi-Obj parentIds MAP<sobjectType,SET<Id>>
    public static MAP<String,SET<Id>> createParentMap(SET<ID> ids) {
        MAP<string,SET<Id>> rtn = new MAP<string,SET<Id>>();    
        for (Id id : ids) {
            string parentType = globalPrefixMap.get(String.valueOf(id).SubString(0,3));
            if (! rtn.containsKey(parentType))
                rtn.put(parentType,new SET<Id>());
            rtn.get(parentType).add(id);
        }
        return rtn;
    }



}
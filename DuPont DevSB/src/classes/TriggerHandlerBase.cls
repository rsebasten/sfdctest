/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved.
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Abstract Class that trigger handle class with extend
    provides common methods for grouping records by recordType

TES20121019 added method: rTypeIdToSetting();
TES20131104: Added hasFired property to help issues caused with sub-batching
    //-------------------------------------------------------------------------------------------------------------	
	//If batch size is over 100 the batch is splited into parts of 100 or lower. For each subbatch trigger code is 
	//executed but stays in the same context (so governer limits count for both subbatches). But the static variable
	// is not reset! By this behaviour you may have run your trigger code for the first 100 records but not for the 
	//last 100 records of the batch!  This does not happen using tools using a current version of the API.  
    // EX:  loading via the API v12 would cause it to consistantly sub-batch, while API v28 would cause it not to sub-batch
    //Additionally it seems the 'Import Leads' button on SFDC home page and 'Manage Member - Add Leads' also causes
    //splits which leads me to believe internally it is using a older version of the API to do these creates.
	//-------------------------------------------------------------------------------------------------------------
	// Note: When the trigger fires Before Insert events there are no ids to hash, to get around this hash it uses this.records
    // keyset (idsHash) which creates temporary Ids.  Keep in mind that this will also create a new hash for subsequent events
    // since the temporary Id will not match the subsequent triggered events
********************************************************************************/
public abstract class TriggerHandlerBase implements ITriggerHandler {


    public static LIST<string> stack = new LIST<string>();
    public static MAP<string,RType.SObjectRTypes> cacheAllRTypes = new MAP<string,RType.SObjectRTypes>();

    private static integer currDepth=0;
    private static integer fireCnt=0;
    public static Schema.sObjectType initiator;
    


	public static LIST<TriggerHistoryItem> TriggerHistory = new LIST<TriggerHistoryItem>();
    public class TriggerHistoryItem {
    	public Datetime timestamp;
    	public Schema.sObjectType sobjectType;
    	public integer index; 	
    	public integer idsHash;  //hash of records.values() this changes at each invokation
    	public integer recordsHash;
    	public integer guidSeed;
    	public string eventCode;
    	public TriggerHistoryItem(TriggerHandlerBase i) {
    		timestamp=Datetime.Now();
    		//instance metrics
    		sobjectType=i.sObjectType;
    		idsHash=i.idsHash;
    		recordsHash=i.recordsHash;
    		//stamp static metrics
    		eventCode=TriggerHandlerBase.getEventCode();
    		guidSeed=TriggerHandlerBase.guidSeed;
    		index=TriggerHandlerBase.firecnt;
    	}
    }	
    	

	private static SET<integer> cacheHasFired = new SET<integer>();
	public boolean hasFired {
		get {
			system.debug('cacheHasFired:'+cacheHasFired);
			return cacheHasFired.contains(this.records.keySet().hashcode());
		}
	}

    //stopRecursion: if true this trigger will run only run 1 iteration for the initiator object
   // public static boolean stopRecursion = false;


    ////////////////////////////////////////////////////////////////////
    //produce a Map of records  (before inserts contain fake ids)
    ///////////////////////////////////////////////////////////////////
    public integer IdsHash { get{ return this.records.keySet().hashcode();} }		
    public integer recordsHash { get{return new SET<sobject>(this.records.values()).hashcode();} }
    private static integer guidseed=0;  //used for Ids in inserts (static required since sub-batches use this for hash)
    private MAP<Id,Sobject> cacheRecordsMap; //cache cannot be static
    public MAP<Id,Sobject> records {
        GET {
            if (cacheRecordsMap==null) {
                cacheRecordsMap = new MAP<Id,Sobject>();
                if (Trigger.isBefore) {
                    if (Trigger.isDelete)
                        cacheRecordsMap=Trigger.oldMap;
                    else if (Trigger.isUpdate || Trigger.IsUndelete)
                        cacheRecordsMap=Trigger.newMap;
                    else if (Trigger.IsInsert) {
                        for (SObject so : Trigger.new)
                            cacheRecordsMap.put(Util.genId(guidseed++),so);
                    }
                }
                else if (Trigger.isAfter) {
                    if (Trigger.isDelete)
                        cacheRecordsMap=Trigger.oldMap;
                    else if (Trigger.isInsert || Trigger.isUpdate || Trigger.IsUndelete)
                        cacheRecordsMap=Trigger.newMap;
                }
            }
            return cacheRecordsMap;
        } //GET
    }


    ////////////////////////////////////////////////////////////////////////
    // Describe Methods
    private Schema.sObjectType cacheObjectType;
    public Schema.sObjectType sObjectType {
        GET {
            if (cacheObjectType==null)
                cacheObjectType=records.values()[0].getSObjectType();
            return cacheObjectType;
        }
    }
    public string sotype {
        get {return string.valueOf(this.sObjectType).tolowerCase(); }
    }


    public Schema.DescribeSObjectResult DSR {
            GET {
             return sObjectType.getDescribe();
        }
    }

    //
    ////////////////////////////////////////////////////////////////////////


    ////////////////////////////////////////////////////////////////////////
    // RecordType Methods

    // ALL recordtypes for current sObject

    public RType.SObjectRTypes rTypes {
        GET {
            if (!cacheAllRTypes.containsKey(sotype))
                cacheAllRTypes.put(sotype,new RType.SObjectRTypes(DSR.getName()));
            return cacheAllRTypes.get(sotype);
        }
    }

    // ALL RecordTypeSettings__c for current sObject
    // MAP<RT.developerName,RecordTypeSettings__c>
    public MAP<string,RecordTypeSettings__c> rTSettings {
        GET {
            return rTypes.RTSettings;
            }
    }

    // Map for ALL recordtypes  for current sObject
    public MAP<id,RecordType> mapRTypes {
        GET {
            return rTypes.getMap();
        }
    }


    //TES20121019
    //Get the recordtype setting for a particular RecordTypeId
    public RecordTypeSettings__c rTypeIdToSetting(Id id) {
        RecordTypeSettings__c rtn;
        try {
            rtn=rTSettings.get(rTypes.IdToDevName(id));
        }catch(Exception ex){}
        return rtn;
    }

    ///////////////////////////////////////////////////////////////////
    // Groups records by recordtype developerName
    // result: MAP<recordTypeDevName,MAP<recordId,record>>
    ///////////////////////////////////////////////////////////////////
    private  MAP<string, MAP<id,SObject>> cacheRecordsByRT;
    public MAP<string, MAP<id,SObject>> recordsByRT {
        GET {
            if (cacheRecordsByRT==null) {
                cacheRecordsByRT = new MAP<string, MAP<id,SObject>>();
                for (id soid : records.KeySet()) {
                    sobject so = records.get(soid);
                    string rtid=(string) so.get('RecordtypeId');
                    string devName = rTypes.IdToDevName(rtid);
                    if (devName!=null) {
                        if (!cacheRecordsByRT.containsKey(devName))
                            cacheRecordsByRT.put(devName,new MAP<id,SObject>());
                        cacheRecordsByRT.get(devName).put(soid,so);
                    }
                }
            }
            return cacheRecordsByRT;
        }
    }

    ///////////////////////////////////////////////////////////////////


    public MAP<id,SObject> getRecordsByRT(string devName) {
        if (recordsByRT.containsKey(devName))
            return recordsByRT.get(devName);
        else
            return new MAP<id,Sobject>();
    }

     ///////////////////////////////////////////////////////////////////

	public RulesEngine.Results cacheRulesEngineResults;
	public RulesEngine.Results getRulesEngineResults() {
		if (cacheRulesEngineResults==null) {

			cacheRulesEngineResults= RulesEngine.getResults(this.records.values());
		}
		return cacheRulesEngineResults;
	}

    ///////////////////////////////////////////////////////////////////

    public virtual void onTrigger() {
        currDepth++;
        fireCnt++;
        string ev = getEventCode();
        stack.add(sotype+':'+ev+':['+currDepth+']:'+fireCnt);
        TriggerHistory.add(new TriggerHistoryItem(this));
        
        system.debug('OnTrigger Method ------------TriggerHandlerBase for sobject:'+this.sobjectType+' currDepth: '+currDepth+' fireCnt: '+fireCnt+'\n initiator: '+initiator+' stack: '+stack);
		
			for (TriggerHistoryItem hi : TriggerHistory )
				system.debug(hi);
		//try {
	        //if ((this.getIteration()>0) && stopRecursion && (this.sobjectType==initiator) ) {
	
	            // Before Trigger
	            if (Trigger.isBefore)
	            {
	                // Call the bulk before to handle any caching of data and enable bulkification
	                this.bulkBefore();
	
	                // Iterate through the records to be deleted passing them to the handler.
	                if (Trigger.isDelete)
	                {
	                    for (SObject so : Trigger.old)
	                    {
	                        this.beforeDelete(so);
	                    }
	                }
	                // so instanceOf Contact || so.getSObjectType()==Contact.sObjectTypeso instanceOf Contact || so.getSObjectType()==Contact.sObjectTypeso instanceOf Contact || so.getSObjectType()==Contact.sObjectTypeIterate through the records to be inserted passing them to the handler.
	                else if (Trigger.isInsert)
	                {
	                    for (SObject so : Trigger.new)
	                    {
	                        this.beforeInsert(so);
	                    }
	                }
	                // Iterate through the records to be updated passing them to the handler.
	                else if (Trigger.isUpdate)
	                {
	                    for (SObject so : Trigger.old)
	                    {
	                        this.beforeUpdate(so, Trigger.newMap.get(so.Id));
	                    }
	                }
	            }
	            else
	            {
	                // Call the bulk after to handle any caching of data and enable bulkification
	                system.debug('calling bulk after');
	                this.bulkAfter();
	
	
	                // Iterate through the records deleted passing them to the handler.
	                if (Trigger.isDelete)
	                {
	                    for (SObject so : Trigger.old)
	                    {
	                        this.afterDelete(so);
	                    }
	                }
	                // Iterate through the records inserted passing them to the handler.
	                else if (Trigger.isInsert)
	                {
	                    for (SObject so : Trigger.new)
	                    {
	                        this.afterInsert(so);
	                    }
	                }
	                // Iterate through the records updated passing them to the handler.
	                else if (Trigger.isUpdate)
	                {
	                    for (SObject so : Trigger.old)
	                    {
	                        this.afterUpdate(so, Trigger.newMap.get(so.Id));
	                    }
	                }
	
	            }
	
	            // Perform any post processing
	            this.andFinally();
	            
	            
	            //mark as fired
				cacheHasFired.add(this.records.keySet().hashcode());
				system.debug('cacheHasFired:'+cacheHasFired);

		//}
		//catch(Exception ex) {
			//insert new ApexException__c(user__c=UserInfo.getUserId(), message__c=String.valueOf(ex));
			//throw ex;
		//}
        //}//end recursion check
    currDepth--;
    }

    public virtual void bulkBefore(){}
    public virtual void bulkAfter(){}
    public virtual void beforeInsert(SObject so){}
    public virtual void beforeUpdate(SObject oldSo, SObject so){}
    public virtual void beforeDelete(SObject so){}
    public virtual void afterInsert(SObject so){}
    public virtual void afterUpdate(SObject oldSo, SObject so){}
    public virtual void afterDelete(SObject so){}
    public virtual void andFinally(){}
  
    
    //--------------------------------------------------------------------------
    //Static Methods
    //--------------------------------------------------------------------------
    
    
    public static string getEventCode() {
		string ev = (trigger.isBefore) ? 'B' : 'A';
        if (trigger.isInsert) ev+='I';
        else if (trigger.isUpdate) ev+='U';
        else if (trigger.isDelete) ev+='D';
        else if (trigger.isUndelete) ev+='UD';
        else ev='UNK';
        return ev;
    }

}
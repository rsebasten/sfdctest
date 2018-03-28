/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  helper methods used for logging  failed DML results
********************************************************************************/
public class DmlResults {

        
    public static integer RESULT_LIMIT=1000;

	//public enum DMLResultType { Save , Upsert, Delete, Undelete};
	public LIST<DmlResults.Result> results {get; private set;}
	{ results = new LIST<DmlResults.Result>(); }
	
	
	public DMLResults() {}
	public DMLResults(LIST<Database.Saveresult> lst) { this(lst,null,false);}
	public DMLResults(LIST<Database.Saveresult> lst,  LIST<sobject> records) { this(lst,records,false); }
	public DMLResults(LIST<Database.Saveresult> lst,  LIST<sobject> records, boolean includeSuccess) {
		integer cnt=0;
		for (Database.Saveresult o : lst) {
			if (includeSuccess || (!o.isSuccess())) {
				Result r = new Result(o);
				try { r.record = string.valueOf(records[cnt]); } catch(exception ex) { system.debug(ex); }
				this.add(r);
			}	
		cnt++;	
		}	
	}
	public DMLResults(LIST<Database.Deleteresult> lst) { this(lst,null,false);}
	public DMLResults(LIST<Database.Deleteresult> lst, LIST<sobject> records) { this(lst,records,false); }
	public DMLResults(LIST<Database.Deleteresult> lst, LIST<sobject> records, boolean includeSuccess) {
		integer cnt=0;
		for (database.Deleteresult o : lst) {
			if (includeSuccess || (!o.isSuccess())) {
				Result r = new Result(o);
				try { r.record = string.valueOf(records[cnt]); } catch(exception ex) { system.debug(ex); }
				this.add(r);
			}	
		cnt++;	
		}		
	}
	public DMLResults(LIST<Database.Upsertresult> lst) { this(lst,null,false);}
	public DMLResults(LIST<Database.Upsertresult> lst, LIST<sobject> records) {this(lst,records,false); }
	public DMLResults(LIST<Database.Upsertresult> lst, LIST<sobject> records, boolean includeSuccess) {
		integer cnt=0;
		for (database.Upsertresult o : lst) {	
			if (includeSuccess || (!o.isSuccess())) {
				Result r = new Result(o);
				try { r.record = string.valueOf(records[cnt]); }catch(exception ex) { system.debug(ex); }
				this.add(r);
			}	
		cnt++;	
		}	
	}
	
	public void add(DmlResults.Result r) {
		if (results.size()<RESULT_LIMIT)
		results.add(r);
	}	
	public void add(DmlResults dmlr) {
		if (results.size()<RESULT_LIMIT)
		results.addAll(dmlr.results);
	}
	public void add(LIST<DmlResults.Result> lst) {
		if (results.size()<RESULT_LIMIT)
		results.addAll(lst);
	}


	public static DmlResults dmlInsert(LIST<sObject> records,Boolean opt_allOrNone) {
		return new DmlResults(Database.insert(records, opt_allOrNone),records);
	}
	//public static DmlResults dmlUpsert(LIST<sObject> records, Schema.Sobjectfield External_ID_Field, Boolean opt_allOrNone) {
	//	return new DmlResults(Database.upsert(records, (Schema.Sobjectfield) External_ID_Field, opt_allOrNone),records);
	//}
	public static DmlResults dmlUpdate(LIST<sObject> records,Boolean opt_allOrNone) {
		return new DmlResults(Database.update(records,opt_allOrNone),records);
	}
	public static DmlResults dmlDelete(LIST<sObject>records,Boolean opt_allOrNone) {
		return new DmlResults(Database.delete(records,opt_allOrNone),records);
	}


	public class Result {
		public string record 		{get;set;}
		public Id id 				{get;set;}
		//Database.Error[] errors = new Database.Error[]{};
		public string errors 		{get;set;}
		public boolean success 		{get;set;}
		
		public Result(Database.Saveresult r) { this(r,null); }
		public Result(Database.Saveresult r, sobject sObj) {
			id=r.getId();
			errors=string.valueOf(r);
			success=r.isSuccess();
			record=(sObj!=null) ? string.valueOf(sObj) : null;
		}
		public Result(database.Deleteresult r) { this(r,null); }
		public Result(database.Deleteresult r,sobject sObj) {
			id=r.getId();
			errors=string.valueOf(r);
			success=r.isSuccess();
			record=(sObj!=null) ? string.valueOf(sObj) : null;
		}
		public Result(database.Upsertresult r) { this(r,null); }
		public Result(database.Upsertresult r,sobject sObj) {
			id=r.getId();
			errors=string.valueOf(r);
			success=r.isSuccess();
			record=(sObj!=null) ? string.valueOf(sObj) : null;
		}
		/*
		public sObject record  {
			GET {return rec}
			SET	{rec = null}
			}
		}
		*/
	}
}
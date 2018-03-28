/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: 
********************************************************************************/
public class ctrlDataAnalysis {
			
	public string sobjectType 		{get; set;}
	public string field				{get; set;}
	public string gtype				{get; set;}
	public string groupByFilter		{get; set;} //like value
	public string groupBy			{get; set;}
	public string groupByAlias		{get; set;}
	public API.SOAPEnvelope env		{get; set;}
	public string soql				{get; set;}
	public string customSoql		{get; set;}
	public integer recordLimit		{get; set;}
	
	private transient Util.describe descr;
	public transient LIST<DataAnalysis.Record> results {get; private set;}
	private transient integer mTotalRecords;
	
	//////////////////////////////////////////////////////////////////////////////////
	//constructors
	public ctrlDataAnalysis() {
		recordLimit=2000;
		sobjectType=ApexPages.currentPage().getParameters().get('so');
		field=ApexPages.currentPage().getParameters().get('fld');

		string fname=ApexPages.currentPage().getParameters().get('fname');
		if (fname!=null && fname.contains('.')) {
			string[] arr = fname.split('\\.');
			sobjectType=arr[0];
			field=arr[1];
		}
				
		string lim = ApexPages.currentPage().getParameters().get('lim');
		if (lim!=null && integer.valueOf(lim)<=2000)
			recordLimit=integer.valueOf(lim);
			
			
		gtype 			= ApexPages.currentPage().getParameters().get('gtype');		
		groupByFilter 	= ApexPages.currentPage().getParameters().get('gfilter');			
		analyze();
	}


	//////////////////////////////////////////////////////////////////////////////////
	private Util.describe descrSO {
		get {
		if (descr==null)
			descr = new Util.describe(sobjectType);
		return descr;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	public void customAnalyze() {
		soql=customSoql;
		results = soqlQuery();
	}
	//////////////////////////////////////////////////////////////////////////////////
	public void analyze() {
		soql='';
		// validate the field and determine field patch  (ie. reference fields return the Name)
		string fieldpath=field;
		if (field==null) 
			return;
		else {
			Schema.DescribeFieldResult dfr = descrSO.fieldInfo(field);
	
			if (dfr==null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Cannot analyze data.  field does not exist. ( '+sobjectType+'.'+field+' )'));
				results=new LIST<DataAnalysis.Record>();
				return;	
			}
			if (!dfr.isGroupable()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Cannot analyze data.  field is not groupable. ( '+sobjectType+'.'+field+' : '+dfr.getType()+' )'));
				results=new LIST<DataAnalysis.Record>();
				return;
			}
			else if (dfr.getType()==Schema.DisplayType.Reference) {
				fieldpath=dfr.getRelationshipName()+'.'+Util.getNameField(sobjectType);
			}		
		}		
		
		//determine/validate grouping
		groupBy=null;
		groupByAlias=null;		
		if (!Util.isBlank(gtype)) {
			if (gtype=='recordtype') {
				if (descrSO.fieldExist('RecordTypeId')) {
					groupBy='RecordType.Name';
					groupByAlias='RecordType_Name';
				}
				else {
					//try to pull recordtype from Master-Detail Parent if avail.
					try {
						Schema.DescribeFieldResult parentDfr = descrSO.primaryRelationship;
						if (parentDfr!=null) {
							//check parent object for RecordTypeId
							Util.describe parentDescr = new Util.describe(string.valueOf(parentDfr.referenceTo[0]));
							if (parentDescr.fieldExist('RecordTypeId')) {
								groupBy=parentDfr.getRelationshipName()+'.RecordType.Name';
								groupByAlias=parentDescr.DSR.getname().replace('__c','')+'_RecordType_Name';					
							}
						}
					}catch(Exception ex){}				
					if (groupBy==null) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No recordtype available.'));
						results=new LIST<DataAnalysis.Record>();	
					}	
				}
			}
			else if (gtype=='program') {
				if (descrSO.fieldExist('Program__c')) {
					groupBy='Program__c';
					groupByAlias='Program';
				}
				else {
					//try to pull program from Master-Detail Parent if avail.
					try {
						Schema.DescribeFieldResult parentDfr = descrSO.primaryRelationship;
						if (parentDfr!=null) {
							//check parent object 
							Util.describe parentDescr = new Util.describe(string.valueOf(parentDfr.referenceTo[0]));
							if (parentDescr.fieldExist('Program__c')) {
								groupBy=parentDfr.getRelationshipName()+'.Program__c';
								groupByAlias=parentDescr.DSR.getname().replace('__c','')+'_Program';					
							}
						}
					}catch(Exception ex){}				
					if (groupBy==null) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No program available.'));
						results=new LIST<DataAnalysis.Record>();	
					}	
				}
			}
			else {
					groupBy=gtype;
					groupByAlias='Custom_GroupBy';			
			}		
		}
			
		
		//build the query		
		results = new LIST<DataAnalysis.Record>();
		if (Util.isBlank(soql)) {
			if (groupBy==null) 
				soql='SELECT '+fieldpath+', count(Id) cnt FROM '+sobjectType+' GROUP BY '+fieldpath;		
			else { 
				soql='SELECT '+fieldpath+','+groupBy+' '+groupByAlias+', count(Id) cnt FROM '+sobjectType;
				if (!Util.isBlank(groupByFilter)) 
					soql+=' WHERE '+groupBy+' LIKE \''+groupByFilter+'\'';
				soql+=' GROUP BY '+fieldpath+','+groupBy;
			}
			soql+=' ORDER BY count(Id) desc LIMIT '+String.valueOf(recordLimit);
		}
		results = soqlQuery();
	}

		
		
    public class PieData {
        public String name { get; set; }
        public Integer data { get; set; }
        public PieData(String name, Integer data) {
            this.name = (name!=null) ? name : '<null>';
            this.data = data;
        }
    }
    
    //TOP ten the group all others
	public LIST<PieData> getPieData() {
		LIST<PieData> rtn = new LIST<PieData>();
		if (results!=null) {
			integer cnt=0;
			for (integer i=0;i<9;i++) {
				if (results.size()>i) {
					integer rcnt=results[i].getCount();
					string nm = results[i].fields[0].value;
					if (results[i].fields.size()>2)
						nm = results[i].fields[0].value+' - '+results[i].fields[1].value;
					cnt+=rcnt;
					rtn.add(new PieData(nm,rcnt));
				}
			}
			if (results.size()>9) {
				integer remcnt=totalRecords-cnt;
				rtn.add(new PieData('<Others>',remcnt));
			}
		}
		return rtn;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////
	public LIST<DataAnalysis.Record> soqlQuery() {
		return DataAnalysis.getRecords(env, soql);
		/*
		for(AggregateResult ar : listResults)
    		mapCustIDToTotal.put(ar.get('Cust_ID__c'), ar.get('expr0'));

		
		return
		*/
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	public LIST<SelectOption> sObjectTypes {
		GET {
			LIST<string> l = new LIST<string>();
			for ( Schema.Sobjecttype sot :  Schema.getGlobalDescribe().values()) {
				//strips out some of backend objects _History Tables, etc...
				if (sot.getDescribe().getKeyPrefix()!=null)
					l.add(String.valueOf(sot));
			}
			l.sort();
			return Util.createSelectOptions(l);
		}
	}


	public void sObjectType_onChange() {
		descr=null;
		field=null;
		gtype=null;
	}

	//////////////////////////////////////////////////////////////////////////////////
	public LIST<SelectOption> fields {
		GET {
			LIST<string> l = new LIST<string>();
			for ( string f :  groupableFieldMAP.values())
					l.add(f);
			l.sort();
			return Util.createSelectOptions(l);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////
    //MAP<'lowercase fldname', fldname>
    private MAP<string,string> groupableFieldMAP { 
        GET {
            MAP<string,string> flds = new MAP<string,string>(); //queryable field
            for (SObjectField sf : descrSO.fieldMap.values()) {
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                if (dfr.isGroupable()) 
                    flds.put(String.valueof(sf).tolowercase(),String.valueof(sf));  //get the case specific name
            }
        return flds;
        }   
    }

	//////////////////////////////////////////////////////////////////////////////////
	public integer totalRecords {
		GET {
			if (mTotalRecords==null) {
					try {
						string soql='Select count(Id) cnt from '+sobjectType;
						if (groupBy!=null && !Util.isBlank(groupByFilter)) 
							soql+=' WHERE '+groupBy+' LIKE \''+groupByFilter+'\'';
						for (dom.Xmlnode n : API.query(soql).getRootElement().getChildElement('Body', API.NS_SOAP).getChildElement('queryResponse',API.NS_PARTNER).getChildElement('result',API.NS_PARTNER).getChildElements() ) {
							if(n.getName()=='records') {
								DataAnalysis.Record r = new DataAnalysis.Record(0,n);
								mTotalRecords=Integer.valueOf(r.getField('cnt').value);
								return mTotalRecords;
							}
		 				}
					} catch(Exception ex) { return 0; }
			}
			return mTotalRecords;
		}	
	}
}
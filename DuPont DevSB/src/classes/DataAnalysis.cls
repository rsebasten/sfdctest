/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: 
********************************************************************************/
public class DataAnalysis {
			

//*****************************************************************************************
// Inner classes
//*****************************************************************************************		

	//serializable record
	public virtual class Record {
		public integer ordinal	 	{get; set;}
		public LIST<Field> fields	{get; set;}
		private MAP<string,integer> mapName;
		
		public Record(integer idx, dom.Xmlnode rec) {
			ordinal=idx;
			mapName=new MAP<string,integer>();
			fields=parseFields(rec);
		}
		
		
		public Field getfield(string fld) {
			Field rtn;
			try { rtn=fields[mapName.get(fld)];	}
			catch(Exception ex) {}
			return rtn;
		}
		
		
		public integer getCount() {
			return Integer.valueOf(getfield('cnt').value);
		}
		
		private LIST<Field> parseFields(dom.Xmlnode r) {
			LIST<Field> rtn = new LIST<Field>();
			for (dom.Xmlnode n : r.getChildElements()) {
				if (!n.getName().equals('type') && !n.getName().equals('Id')) {
					Field f = new Field(rtn.size(),n);
					mapName.put(f.name,rtn.size());
					rtn.add(f);
				}
			}
		return rtn;
		} 	
	}

/*
	//not serializable
	public virtual class oldRecord {
		public integer ordinal	 	{get; set;}
		dom.Xmlnode r;
		public oldRecord(integer idx, dom.Xmlnode rec) {
			ordinal=idx;
			r=rec;
		}
		public Field getfield(string fld) {
			Field rtn;
			try { 
				//rtn=r.getChildElement(fld,'urn:sobject.partner.soap.sforce.com').getText();	
				rtn=new Field(0,r.getChildElement(fld,'urn:sobject.partner.soap.sforce.com'));	
			}
			catch(Exception ex) {}
			return rtn;
		}
		
		public integer getCount() {
			return Integer.valueOf(getfield('cnt'));
		}
		
		public LIST<Field> fields {
			GET {
				LIST<Field> rtn = new LIST<Field>();
				for (dom.Xmlnode n : r.getChildElements()) {
					if (!n.getName().equals('type') && !n.getName().equals('Id'))
						rtn.add(new Field(rtn.size(),n));
				}
			return rtn;
			}
		} 	
	}
*/

	
	public virtual class Field {
		public integer ordinal	 	{get; set;}
		public string soaptype 		{get; set;}
		public string name			{get; set;}
		public string value			{get; set;}
		public Field(integer idx,dom.Xmlnode f) {
			ordinal=idx;
			name=f.getName();
			string isNull=f.getAttribute('nil','http://www.w3.org/2001/XMLSchema-instance');
			if (isNull!='true') {
				value=f.getText();
				soaptype=f.getAttribute('type','http://www.w3.org/2001/XMLSchema-instance');
			}
		}		
	}
	
	

//*****************************************************************************************
// Helper Method(s)
//*****************************************************************************************

	public static LIST<Record> getRecords(API.SoapEnvelope env, string soql) {
		LIST<Record> recs = new LIST<Record>();
		try {
			dom.Xmlnode body = API.query(env,soql).getRootElement().getChildElement('Body', API.NS_SOAP);
			if (body.getChildElement('queryResponse',API.NS_PARTNER)!=null)
				for (dom.Xmlnode n : body.getChildElement('queryResponse',API.NS_PARTNER).getChildElement('result',API.NS_PARTNER).getChildElements() ) {
					if(n.getName()=='records') 
		        		recs.add(new Record(recs.size(),n));
	
				}
			else
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Fault: '+body.getChildElement('Fault', API.NS_SOAP).getChildElement('faultstring',null).getText()));
		}
		catch(Exception ex) {
			//http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_soql_select_agg_functions_field_types.htm
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Invalid Query: '+soql+'\n\n'+String.valueof(ex)));
		}
		return recs;	
	}

}
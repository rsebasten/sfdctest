/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: LayoutReport
********************************************************************************/
public with sharing class ctrlLayoutReport {
	
	private string									mSObjectType;	 
	private string						  			mRTypeId;		
	private transient Metadata.describeLayout		mlayout;
	private transient Metadata.RecordTypeMapping	mrtmapping;
	private transient Util.Describe				 	mDescribe;
	private transient API.FileProperties			mlayoutFileProps;

	public ctrlLayoutReport() {
		sObjectType=ApexPages.currentPage().getParameters().get('so');
		rtypeId=ApexPages.currentPage().getParameters().get('rt');
		system.debug(this.items.size());
	}
	
	
	public string LayoutName {
		get {
				string rtn=null;
				//try via metadata API
			if (layoutFileProps!=null && layoutFileProps.fullname!=null)
				rtn=mlayoutFileProps.fullname;
			else {
				try {
					//try via metadata__c records
					rtn=[Select fullname__c from Metadata__c where ForceId__c=:rtypeMapping.layoutId][0].fullName__c;	
                } catch(Exception ex) {}
			}
			
			if (rtn!=null) {	
				Integer dash=rtn.indexOf('-');
				if (dash!=null && dash>0)
					rtn=rtn.substring(dash+1);
				}
			return rtn;
		}
	}
	
	public API.FileProperties layoutFileProps {
		get {
			if (mlayoutFileProps==null) {
					try {
					MAP<Id,API.FileProperties> mfp = API.listMetadataMapById(mSObjectType,'Layout');
					mlayoutFileProps=mfp.get(rtypeMapping.layoutId);
					} catch(exception ex){}
			}
				return mlayoutFileProps;	
		}
	}
	
		public string rTypeId	 {
			get{ return Util.isBlank(mRTypeId) ? null : mRTypeId; }
			set{
				mRTypeId=value;
			}
		}
		public string sObjectType {
			get{ return Util.isBlank(msObjectType) ? null : msObjectType; }
			set{ 
				if (mSObjectType!=value) {
					mSObjectType=value;
					mrTypeId=null;
					}
			}	  
		}

	private static final MAP<String,String> fieldColumns = new MAP<String,String> {
		'label'			 => 'label',
		'type'				  => 'type',
		'API Name'			  => 'name',
		'ReferenceTo'	   => 'ReferenceTo'
	};

	
	public Metadata.describeLayout layout {
		 GET {
			if (sObjectType!=null && rtypeId!=null)
				if (mlayout==null)
				mlayout = new Metadata.describeLayout(sObjectType, rtypeId);    
             return mlayout;
		 }
	}
	////////////////////////////////////////////////////////////////////////////////////////
	public Metadata.RecordTypeMapping rtypeMapping {
	 GET {
		if (layout!=null)
            if (mrtmapping==null)
                mrtmapping = layout.getRecordTypeMappings().get(rtypeId);   
         return mrtmapping;
	 }
	}
	
	
		public Util.Describe describe {
		 GET {
			if (sObjectType!=null)
				if (mDescribe==null)
					mDescribe = new Util.Describe(sObjectType);
			return mDescribe;
		 }
	}
	
	public LIST<LayoutResult> items {
		GET {
			LIST<LayoutResult> rtn = new LIST<LayoutResult>();
			if (layout!=null) {
				MAP<string,LIST<Metadata.layoutSection>> els = layout.EditLayoutSections;
				if (els.size()>0) {
					for( MetaData.LayoutSection s : els.values()[0])
						for (Metadata.LayoutItem i : s.items) {
							if (i.itemtype=='Field') {
								system.debug(i);
								LayoutResult  lr = new LayoutResult();
								lr.layout=i;
								if (rtypeMapping!=null && rtypeMapping.picklistsForRecordType!=null && rtypeMapping.picklistsForRecordType.containskey(i.name))
									lr.picklistmap=rtypeMapping.picklistsForRecordType.get(i.name);
                                lr.dfr = describe.fieldInfo(i.name);
								rtn.add(lr);
								
							}
						}		   
				}
			}
		return rtn;
		}
	}



	public void refresh() {
		mlayout=null;
		mrtmapping=null;
		mDescribe=null;
		mlayoutFileProps=null;
	}

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


	public LIST<SelectOption> recordTypes {
		GET {
			if (sObjectType!=null)
				return Util.createSelectOptions([Select Id, Name from RecordType where SObjectType=:sObjectType Order By Name]);
			else return null;
		}
	}


//*****************************************************************************************
// Inner classes
//*****************************************************************************************

		public class LayoutResult {
			public MetaData.LayoutItem					layout		{get; set;}
			public MAP<string,Metadata.picklistValues>	picklistmap	{get; set;}
			public Schema.DescribeFieldResult			dfr			{get; set;}

			public string picklistEntries{
				GET {
					string rtn='';
					if (picklistmap!=null) {
							LIST<string> sortedPK = new LIST<String>(picklistmap.KeySet());
							sortedPK.sort();
						for (string pk : sortedPK) {
							Metadata.picklistValues pv = picklistmap.get(pk);	
							if (pv!=null) {
								if (pv.defaultValue==true)
									rtn+='<b>'+pv.value+' (default)</b><br/>';
								else
									rtn+=pv.value+'<br/>';
							}
						}
					}
					//if (ApexPages.currentPage().getParameters().get('ctype')!=null)
					//	  rtn='"'+rtn.replace('<BR/>','\n')+'"';
					return rtn;
				}
			}
			public string ReferenceTo {
				GET {
					string rtn;
					List <Schema.sObjectType> refto = dfr.getReferenceTo();
					if (refto!=null && refto.size()>0) {
						if (refto.size()==1)
							rtn=string.valueOf(refto[0]);
						else
							rtn='polymorphic';
					}
				return rtn;
				}
			}
			public string getType() {
						string rtn=String.valueOf(dfr.getType());
				if (rtn=='REFERENCE') {
					rtn+='('+this.ReferenceTo+')';
				}
				else if (rtn=='STRING' || rtn=='TEXTAREA')
					rtn+='('+dfr.getLength()+')';
							else if (rtn=='PICKLIST') {
								if (dfr.isDependentPicklist())
						rtn+='(dependent)';
							}
							else if (rtn=='DOUBLE' || rtn=='INTEGER' || rtn=='CURRENCY'|| rtn=='PERCENT') {
								rtn+='('+String.valueOf(dfr.getPrecision())+','+String.valueOf(dfr.getScale())+')';
							}
				return rtn;
			}
		}


	
}
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  controller for page: MetadataERD
********************************************************************************/
public class ctrlMetadataERD {
	
	DotBuilder dotBuilder;
	string cacheDot;
	
	public ctrlMetadataERD() {
		dotBuilder=new DotBuilder();
	}
	
	public void init() {
		string sObjType = ApexPages.currentPage().getParameters().get('sotyp');
		if (sObjType!=null) {
			dotBuilder.sobjectType = sObjType;
			getRelations();
		}
	}
	
	public string sotype {
		get {	system.debug('getting:'+dotBuilder.sobjectType); return dotBuilder.sobjectType; 	}
		set { 	system.debug('setting:'+value); dotBuilder.sobjectType = value;	}
	}
	
	public void getRelations() {
		cacheDot=null;
		dotBuilder.refreshData();
	}


	public LIST<SelectOption> sObjects {
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
	
	public string dot {
		get {
			if (cacheDot==null) {
				cacheDot = dotBuilder.toDot();
				if ( cacheDot.length()>14333 ) //max: 16k base64 (16*1024)*(7/8))
					cacheDot = dotBuilder.toDot(false);
			}
			
			return cacheDot;
		}
	}
	
	public long dotSize {
		get { return (!Util.isBlank(dot))?dot.length():0; }
	}
}
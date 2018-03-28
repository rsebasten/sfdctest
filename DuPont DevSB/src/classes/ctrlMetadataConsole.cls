public class ctrlMetadataConsole {

	public string			selectedCategory		{get; set;}	
	public string			selectedSObject			{get; set;}	
	public DmlResults 		dmlResult 				{get; private set;}	
	public boolean 			jobInProcess 			{get; private set;}

		
	public ctrlMetadataConsole(){}
	
	public void init(){

		string id = ApexPages.currentPage().getParameters().get('id');
		string fn = ApexPages.currentPage().getParameters().get('fn');
		if (!util.isBlank(fn))
			selectedSObject = fn;
		else if (!util.isBlank(id))
			selectedSObject = [Select FullName__c from Metadata__c where id=:id].FullName__c;
		//Since some of the data gathered in this refresh is profile related this should be 
		// run with a consistant profile with full visibility.
		// Ex. profile differences RType<->Layout Relationship, object and field visiblity 
		
		string profileName=[Select Name from Profile where id=:UserInfo.getProfileId()].name;
		if (profileName!='System Administrator') 
			throw new MetadataException('Error: you must be a system administrator.');
		
	}
	
	public LIST<SelectOption> sObjects {
		GET {
			LIST<string> l = new LIST<string>();
			for ( Schema.Sobjecttype sty :  Schema.getGlobalDescribe().values()) {
				Schema.Describesobjectresult DSR = sty.getDescribe(); 
				//strips out some of backend objects _History Tables, etc...
				if (DSR.getKeyPrefix()!=null)
					l.add(String.valueOf(sty));
			}
			l.sort();
			return Util.createSelectOptions(l,true,' (All) ');
		}
	}
	
	public LIST<SelectOption> mtypeCategories {
		GET {
			LIST<string> l = new LIST<string> {'Security'};
			return Util.createSelectOptions(l,true,' (All) ');
		}
	}	
	
	
	public string otherTypes {
		GET {
			SET<string> s = Metadata.GENERAL_MTYPES;
			s.addAll(Metadata.GENERAL_SOBJECT_MTYPES);
			LIST<string> rtn=new LIST<string>(s);
			rtn.sort();
			return Util.joint(rtn,', ');
		}
	}

	//FYI,  This is already included in refreshOtherTypes(), used for quicker turnaround
	public void refreshSecurityTypes() {
		SET<string> SecurityMTypes = new SET<string> {'Profile', 'PermissionSet', 'Role','Group'};
		LIST<Metadata.ListMetadataInstruction> instr = new LIST<Metadata.ListMetadataInstruction>();
			for (string stdT : SecurityMTypes)
				instr.add(new Metadata.ListMetadataInstruction(stdT,null));		
		Database.executeBatch(new batchRefreshMetadataFileProperties(null,instr),1);		
	}
	
	public void refreshOtherTypes() {
		jobInProcess=true;
		if (selectedCategory=='Security')
			refreshSecurityTypes();
		else
			Database.executeBatch(new batchRefreshMetadataFileProperties(),1);		
	}
	
	
	//Refreshes Sobject/Fields/Picklists  (does not refresh the Sobject FullName or forceId)
	public void RefreshDatabase() {
		//TESII20110210 Getting heap space limits when not running in batch mode,
		//since sf upg to v21.0 (changing the run in API version had no effect)
		//Error in API.listMetadataCompact for all the fields

		//TESII20110210 if (Util.isBlank(selectedSObject)) {
			jobInProcess=true;
			Database.executeBatch(new batchRefreshMetadata(),1);
		//TESII20110210 	}
		//TESII20110210 else 
		//TESII20110210 	Database.executeBatch(new batchRefreshMetadata(),1);

	}

	
	public void RefreshLayout() {
		//added the Metadata Record Types and Layouts
		string sotype = selectedSObject;
		if (String.IsBlank(sotype))
			sotype=null;
		
		system.debug('selectedSObject:'+sotype);
		dmlResult = Metadata.RefreshSObjectLayout(sotype);
		jobInProcess=true;
		Database.executeBatch(new batchRefreshMetadataLayout(sotype),1);

	}

	public void RefreshLogic() {
		//layoutInProcess=true;
		jobInProcess=true;
		dmlResult = Metadata.RefreshLogic();
	}	
	

	
	public class MetadataException extends Exception {} 

}
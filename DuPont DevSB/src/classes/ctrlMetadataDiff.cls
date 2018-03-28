/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: 
********************************************************************************/
public with sharing class ctrlMetadataDiff {

	public string id 			{get;set;}  //Metadata record Id of class or trigger
	public string file1id		{get;set;}	//Attachment Id (code snapshot 1)
	public string file2id		{get;set;}	//Attachment Id (code snapshot 2)
	
	
	public transient string file1 {get; private set;}
	public transient string file2 {get; private set;}	
	
	public ctrlMetadataDiff() {
		file1='';
		file2='';
		id = ApexPages.currentPage().getParameters().get('id');
		file1id = ApexPages.currentPage().getParameters().get('f1');		
		file2id = ApexPages.currentPage().getParameters().get('f2');		
		
		if ( String.isBlank(file1id) || String.isBlank(file2id)) {
			LIST<Attachment> lst = [
					Select id from Attachment 
					where parentid =: id order by name desc LIMIT 2];	
			if (lst.size()==2) {
				file1id=lst[0].id;
				file2id=lst[1].id;
			}
		}
		
		if ( !(String.isBlank(file1id) || String.isBlank(file1id))) {
			diff();
		}
	}
		
		
	public Pagereference diff() {
		file1 = [Select Body from Attachment where id=:file1id].Body.toString(); 
		file2 = [Select Body from Attachment where id=:file2id].Body.toString(); 
		return null;
	}
	
	
	public LIST<SelectOption> versions {
		GET {
			return Util.createSelectOptions([
				Select Id, Name From Attachment 
				Where ParentId=:id order by name desc]);
		}
	}
	
	@RemoteAction
    public static string getFile(string id) {
			string rtn='';
			try {
				rtn=[Select Body from Attachment where id=:id].Body.toString(); 
			} catch(exception ex){}
			return rtn;
    }
    
	@RemoteAction
    public static LIST<string> getFiles(string f1, string f2) {
			LIST<string> rtn = new LIST<string>();
			//try {
				LIST<attachment> atts =[Select Body from Attachment where id=:f1 or id=:f2];
				if (atts.size()==2) {
					rtn.add(atts[0].Body.toString()); //.unescapeXml());
					rtn.add(atts[1].Body.toString()); //.unescapeXml());
				}
			//} catch(exception ex){}
			return rtn;
    }
    

}
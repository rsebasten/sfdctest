/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component: SubForm
********************************************************************************/

public class SubForm {
		
		public Lead 					newlead				{set; get;}
		public SiteField__c 			siteField			{set; get;}
		
		public string 					subformId			{set; get;}
		//public string 				isoLang				{set; get;}
		public string 					title				{set; get;}
		public string 					description			{set; get;}
		public string 					cssfile				{set; get;}
		public MAP<string,FormField> 	fields 				{set; get;}
		public siteObject__c 			siteObject			{set; get;}
		public string 					NewRecordtypeId		{set; get;}
		public string 					NewOwnerId			{set; get;}		
		
		
		public SubForm() 							 {  this(null,null,null); 		}	
		public SubForm(string objId) 				 {  this(objId,null,null); 		}
		public SubForm(string objId, string isoLang) {	this(objId,isoLang,null);	}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////		
		public SubForm(string objId, string isoLang, string title) {
			
			this.newlead		= new Lead();
			this.siteField		= new SiteField__c();
			this.fields 		= new MAP<string,FormField>();	
			this.subformId 		= (objId!=null) ? objId : SiteBuilder.DEFAULT_SUBFORM;
			//this.isoLang 		= (isoLang!=null) ? isoLang : 'en';
			
			this.siteObject = SiteBuilder.getSiteObjectAndItems(this.subformId, SiteBuilder.RTYPE_SO_SUBFORM, SiteBuilder.RTYPE_SOI_FORMFIELD, isoLang);
			if (siteObject==null ) {
				//get the default subform
				this.subformId = SiteBuilder.DEFAULT_SUBFORM;
				this.siteObject = SiteBuilder.getSiteObjectAndItems(this.subformId, SiteBuilder.RTYPE_SO_SUBFORM, SiteBuilder.RTYPE_SOI_FORMFIELD, isoLang);
			}
			
			if (siteObject!=null ) {
			
				this.title= (title!=null) ? title : siteObject.PublicName__c;
				this.description=siteObject.PublicDescription__c;
				this.NewRecordtypeId = siteObject.NewRecordtypeId__c;
				this.NewOwnerId = siteObject.NewRecordOwnerId__c;

				for (SiteObjectItem__c i : siteObject.Items__r) {
					
					if (i.FormField__c!=null) {
						string[] arr=i.FormField__c.tolowercase().split('\\.',-2);
						if (arr.size()==2) {
							FormField ff = new FormField();					
							ff.name = i.FormField__c;
							ff.sobjectType = arr[0];
							ff.fieldName = arr[1];
							ff.required = i.IsRequired__c;
							fields.put(i.FormField__c.tolowercase(),ff);
						}
					}
				} //next i
			}	
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////			
		
		public class FormField {
	
			public string			 	name		{set; get;}
			//public Schema.Sobjectfield	sof			{set; get;}
			public boolean 				required	{set; get;}
			public string 				sobjectType	{set; get;}
			public string 				fieldName	{set; get;}
	
		}

		public FormField salutation		 				{ get {  return	getfield('lead.salutation'); 			}}	
		public FormField firstName 						{ get {  return getfield('lead.firstname');				}}
		public FormField lastName 						{ get {  return	getfield('lead.lastname'); 				}}
		public FormField company  						{ get {  return	getfield('lead.company'); 				}}
		public FormField email 							{ get {  return	getfield('lead.email'); 				}}
		public FormField phone			 				{ get {  return	getfield('lead.phone'); 				}}
		public FormField street	 						{ get {  return	getfield('lead.street'); 				}}
		public FormField city	 						{ get {  return	getfield('lead.city'); 					}}
		public FormField state	 						{ get {  return	getfield('lead.state'); 				}}
		public FormField postalcode						{ get {  return	getfield('lead.postalcode'); 			}}		
		public FormField lead_country	 				{ get {  return	getfield('lead.lead_country__c'); 		}}
		public FormField site_country 					{ get {  return	getfield('sitefield__c.country__c'); 	}}
		public FormField site_role1		 				{ get {  return	getfield('sitefield__c.role1__c'); 		}}
		public FormField site_role2		 				{ get {  return	getfield('sitefield__c.role2__c'); 		}}
		public FormField site_role3		 				{ get {  return	getfield('sitefield__c.role3__c'); 		}}
		public FormField site_role4		 				{ get {  return	getfield('sitefield__c.role4__c'); 		}}
		public FormField site_role5		 				{ get {  return	getfield('sitefield__c.role5__c'); 		}}
		public FormField site_role6		 				{ get {  return	getfield('sitefield__c.role6__c'); 		}}		
		public FormField site_role7		 				{ get {  return	getfield('sitefield__c.role7__c'); 		}}
		public FormField site_role8		 				{ get {  return	getfield('sitefield__c.role8__c'); 		}}
		public FormField site_role9		 				{ get {  return	getfield('sitefield__c.role9__c'); 		}}
		public FormField site_role10	 				{ get {  return	getfield('sitefield__c.role10__c'); 	}}
		public FormField site_PrivacyInquiryType 		{ get {  return	getfield('sitefield__c.PrivacyInquiryType__c'); 	}}
		
		private FormField getfield(string nm) {
			nm=nm.toLowerCase();
			return this.fields.containsKey(nm) ? this.fields.get(nm) : null;
		}
					

		public Lead toLead() {
			
			if ( newLead.Company == null 	|| newLead.Company.length()==0	) 	newLead.Company = 'not provided';
			if ( newLead.LastName == null 	|| newLead.LastName.length()==0	) 	newLead.LastName = 'not provided';
			
			if ( newRecordTypeId		!= null)  			newLead.RecordTypeId = newRecordTypeId;
			if ( newOwnerId				!= null)  			newLead.OwnerId = newOwnerId;
			if (sitefield.Country__c 	!= null) 			newlead.Lead_Country__c=sitefield.Country__c;
			if (sitefield.Role1__c 		!= null)  			newlead.Role__c=sitefield.Role1__c;
			if (sitefield.Role2__c 		!= null)  			newlead.Role__c=sitefield.Role2__c;	
			if (sitefield.Role3__c 		!= null)  			newlead.Role__c=sitefield.Role3__c;	
			if (sitefield.Role4__c 		!= null)  			newlead.Role__c=sitefield.Role4__c;	
			if (sitefield.Role5__c 		!= null)  			newlead.Role__c=sitefield.Role5__c;	
			if (sitefield.Role6__c 		!= null)  			newlead.Role__c=sitefield.Role6__c;
			if (sitefield.Role7__c 		!= null)  			newlead.Role__c=sitefield.Role7__c;	
			if (sitefield.Role8__c 		!= null)  			newlead.Role__c=sitefield.Role8__c;	
			if (sitefield.Role9__c 		!= null)  			newlead.Role__c=sitefield.Role9__c;	
			if (sitefield.Role10__c 	!= null)  			newlead.Role__c=sitefield.Role10__c;
			if (sitefield.PrivacyInquiryType__c != null)  	newlead.Type__c='Privacy Inquiry: '+sitefield.PrivacyInquiryType__c;
			
			return newlead;
	}


		
	}	
///////////////////////////////////////////////////////////////////////////////////////////////////////////
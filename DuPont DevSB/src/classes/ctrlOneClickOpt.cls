/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: OneClickOpt
********************************************************************************/
public class ctrlOneClickOpt {
	
	//form details
	public boolean err  				{set; get;}
	public string errMsg  				{set; get;}
	public boolean showThankYou			{set; get;}
	public boolean showForm				{set; get;}
	public Subform frm  				{set; get;}

	//params
	public string email 				{set; get;}
	public string opt					{set; get;}
	public string listId 				{set; get;}
	public string centerId 				{set; get;}
	public string subformId				{set; get;}
	public string isoLang 				{set; get;}
	public string newLeadForm			{set; get;}
	public string HeaderFooter			{set; get;}
	public boolean noClick				{set; get;}
	
	public SubscriptionCenter.SubList soList			{set; get;}
						
	private string 							lastUpdatedLocation;
	private SiteObject__c 					center;

	//////////////////////////////////////////////////////////////////////////////////////
	public pageReference init() {
		
		err=false;
		showForm=false;
		showThankYou=false;
		
		email = ApexPages.currentPage().getParameters().get('em');
		centerId = ApexPages.currentPage().getParameters().get('cid');
		listId = ApexPages.currentPage().getParameters().get('lid');
		isoLang = ApexPages.currentPage().getParameters().get('l');
		lastUpdatedLocation = ApexPages.currentPage().getParameters().get('src');
		opt = ApexPages.currentPage().getParameters().get('opt');
		newLeadForm = ApexPages.currentPage().getParameters().get('nlf');
		HeaderFooter= ApexPages.currentPage().getParameters().get('hf');
		string noc=ApexPages.currentPage().getParameters().get('noc');
		
		if (listId!=null) {
			try {
			SiteObject__c so = SiteBuilder.getSiteObject(listId);
			SiteBuilder.translateSiteObjectAndItems(so,isolang);
			soList = new SubscriptionCenter.SubList(so);
			}
			catch(Exception ex) {}
		}
		
		if (listId==null || soList.listObject==null) {
			errMsg=Label.Site_InvalidSubscription;
			err=true;
		}
		
		//decode email if encoded
		if ( email!=null && (! email.contains('@'))) {
			email=System.Encodingutil.base64Decode(email).toString();
		}
		
		//set lang=en if not provided	
		if (isoLang==null) isoLang = 'en';
		
		//set default opt=in
		if ( opt==null) opt='in';
		
		//set noclick flag
		noclick=(noc!=null && noc=='1');
	
		///////////////////////////////////////////////////
		//Determine if a Subform is shown	
		///////////////////////////////////////////////////	
		if ( ( opt=='in' ) && 	//only show subform for Opt-ins
			 ( (email==null ) || 
			   ( newLeadForm!=null || centerId!=null ) 
			 )) 
			{ 	
				//SHOW FORM
				showForm=true;
				showThankYou=false;
				subformId=null;
				//determine which Subform to show	
				if (newLeadForm!=null) {
					subformId=newLeadForm;
				}
				else if (centerId!=null && subformId==null) {
					center = SiteBuilder.getSiteObject(centerId);
					if (center.Subform__c !=null)	
						subformId=center.Subform__c;
				}
				
				frm = new SubForm(subformId,isoLang);
				frm.title=null;	//dont show a subform title 
				if (email!=null) 
					frm.newlead.Email=email;
					
			}
		else {
			if (noclick) {
				showThankYou=true;
				showform=true;
				SaveList(listId,email,opt);
			}
		}
		
		return null;

	}
	//////////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************************
	EVENTS
*********************************************************************************************/
	//////////////////////////////////////////////////////////////////////////////////////	
	public string moreSubscriptionsUrl {
		get {
			pageReference pg = Page.subcenters;
			string rtn  = 'http://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl()+'?';
			if (isoLang!=null) 				rtn += '&l='+isoLang;
			if (email!=null) 				rtn += '&em='+SubscriptionCenter.hash(email);
			if (lastUpdatedLocation!=null) 	rtn += '&src='+lastUpdatedLocation;
			if (headerfooter!=null) 		rtn += '&hf='+headerfooter;
			return rtn;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////	
	
	public PageReference Save() {
		
		
		////////////////////////////////////////////////////
		// Add New Lead
		///////////////////////////////////////////////////
		if (frm!=null) {
			
			Lead newLead = frm.toLead();
			newLead.Origin_Channel_Type__c='Website';
			newLead.Origin_Name__c='Listid: '+listId;
			newLead.Origin_Tracking_Code__c=lastUpdatedLocation;

			//Override Owner/Recortype if populated at center
			if (center!=null && 
				(   center.NewRecordOwnerId__c !=null || 
					center.NewRecordTypeId__c  !=null
				)) {
					newLead.RecordTypeId = center.NewRecordTypeId__c;
					newLead.OwnerId = center.NewRecordTypeId__c;	
				}
					
			//TESII_20091111 Trigger assignmentRule	(floris)
			Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            newLead.setOptions(dmo);
            //END TESII_20091111
			
			upsert newLead;
			email=newLead.email;
		}

		
		////////////////////////////////////////////////////
		// Save The Opt
		///////////////////////////////////////////////////
		SaveList(listId,email,opt);
		
		////////////////////////////////////////////////////
		// ReturnUrl handler
		///////////////////////////////////////////////////
		if (center!=null && center.returnUrl__c!=null) {
			string url = SubscriptionCenter.mergefieldUrl(center.returnUrl__c, email, isoLang, lastUpdatedLocation);
			PageReference p = new PageReference(url);
			p.setRedirect(true);
			return p;
		}
	
	showForm=false;
	showThankYou=true;	
	return null;	
	}


//////////////////////////////////////////////////////////////////////////////////////
private void SaveList(string listId, string email, string opt) {
		
	//List and Site_Object_Values for email
	LIST<SiteObject__c> sos = new LIST<SiteObject__c>([
			SELECT Id, ExternalId__c,
				( 	Select Value__c, LastUpdatedLocation__c, Id, ExternalId__c, Email__c 
					From Site_Object_Values__r
					where email__c=:email LIMIT 1
				)
			FROM SiteObject__c 
			WHERE id=:listId
			LIMIT 1
			]);
			system.debug('-----SaveList::listid----->:'+listId);	
			system.debug('-----SaveList::email----->:'+email);			
			system.debug('-----SaveList::SOV----->:'+sos);			
			if (sos!=null && sos.size()!=0 && opt!=null && email!=null) {
				SiteObject__c so=sos[0];
				
				SiteObjectValue__c sov;
				if (so.Site_Object_Values__r==null || so.Site_Object_Values__r.size()<1) {
					//create a new sov entry
					sov = new SiteObjectValue__c(name='', 
						SiteObject__c	= so.id, 
						ExternalId__c	= so.ExternalId__c+email,
						email__c = email, value__c=SubscriptionCenter.OPT_OUT );
				}
				else
					sov=so.Site_Object_Values__r[0];
				
				if (opt.toLowercase()=='in') 		sov.value__c=SubscriptionCenter.OPT_IN;
				else if (opt.toLowercase()=='out') 	sov.value__c=SubscriptionCenter.OPT_OUT;
				
				if (lastUpdatedLocation!=null) sov.lastUpdatedLocation__c=lastUpdatedLocation; 
				
				system.debug('-----SaveList::SOV----->:'+sov);	
				upsert sov ExternalId__c;

		}
	}


////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////

public static testMethod void test_ctrlOneClickOpt() {
    SubscriptionCenter.TESTMODE=true;
    string subformId = Sitebuilder.testAddSubForm();
    string CenterId = SubscriptionCenter.testAddSubCenter('Center1');
    
    Lead lead1 = new Lead(lastname='test', Company='test', email='tester1@tester.com');
    insert lead1;
    
    SubscriptionCenter.SubCenter center = new SubscriptionCenter.SubCenter(CenterId);
    system.debug('--------------center----------------->'+center );
    Test.startTest();
    PageReference pageRef = Page.OneClickOpt;
    Test.setCurrentPage(pageRef);
    ctrlOneClickOpt controller = new ctrlOneClickOpt();
    
    SubscriptionCenter.SubList lst = center.getItems()[0];
    string sid=lst.globalCampaignId+lead1.email;
    //SubscriptionCenter.CreateCampaignMemberStatusforLists(new LIST<campaign> { new Campaign(id=lst.globalCampaignId.substring(15))});
    
    //test OC Opt-In
    ApexPages.currentPage().getParameters().put('lid', lst.listObject.id);
    ApexPages.currentPage().getParameters().put('em', lead1.email);
    ApexPages.currentPage().getParameters().put('noc', '1');
    controller.init();
    system.debug('-----------sid---------------->'+sid);
    system.debug([Select value__c from SiteObjectValue__c where ExternalId__c=:sid]);
    //system.assertEquals([Select value__c from SiteObjectValue__c where ExternalId__c=:sid][0].value__c, SubscriptionCenter.OPT_IN);
        
    
    //test OC Opt-Out
    ApexPages.currentPage().getParameters().put('lid', lst.listObject.id);
    ApexPages.currentPage().getParameters().put('em', SubscriptionCenter.hash(lead1.email));
    ApexPages.currentPage().getParameters().put('opt', 'out');
    controller.init();
    //system.assertEquals([Select value__c from SiteObjectValue__c where ExternalId__c=:sid][0].value__c, SubscriptionCenter.OPT_OUT);
      
    //test center derived form Opt-In
    ApexPages.currentPage().getParameters().put('opt', 'in');
    ApexPages.currentPage().getParameters().put('l', 'fr');
    ApexPages.currentPage().getParameters().put('src', 'center');
    controller.init();
    controller.Save();
    //system.assertEquals([Select value__c from SiteObjectValue__c where ExternalId__c=:sid][0].value__c, SubscriptionCenter.OPT_IN);
    
    
    //test new lead form Opt-In
    ApexPages.currentPage().getParameters().put('opt', 'in');
    ApexPages.currentPage().getParameters().put('src', 'testMethod2');
    ApexPages.currentPage().getParameters().put('nlf', subformId);
    controller.init();
    controller.Save();


    Test.stopTest();
  
    }

	
}
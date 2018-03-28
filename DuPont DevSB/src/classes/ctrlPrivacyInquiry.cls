/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: PrivacyInquiry
********************************************************************************/
public class ctrlPrivacyInquiry {

	public string email 				{set; get;}		//em
	public string centerId 				{set; get;}		//cid
	public string isoLang 				{set; get;}		//l
	public string newLeadForm			{set; get;}		//nlf
	public string HeaderFooter			{set; get;}		//hf
	
	public boolean err  				{set; get;}
	public string errMsg  				{set; get;}
	public boolean showThankYou			{set; get;}
	public boolean showForm				{set; get;}
	public Subform frm	 				{set; get;}
		
	private string 			lastUpdatedLocation;		//src
	

	//////////////////////////////////////////////////////////////////////////////////////
	public pageReference init() {
				
		err=false;
		showForm=true;
		
		email = ApexPages.currentPage().getParameters().get('em');
		centerId = ApexPages.currentPage().getParameters().get('cid');
		isoLang = ApexPages.currentPage().getParameters().get('l');
		lastUpdatedLocation = ApexPages.currentPage().getParameters().get('src');
		newLeadForm = ApexPages.currentPage().getParameters().get('nlf');
		HeaderFooter= ApexPages.currentPage().getParameters().get('hf');			
		
		//decode email if encoded
		if ( email!=null && (! email.contains('@'))) {
			email=System.Encodingutil.base64Decode(email).toString();
		}
		//set lang=en if not provided	
		if (isoLang==null) isoLang = 'en';
			
		if ( newLeadForm==null ) {
			if (centerId!=null) {
				//Use the center subform as the my profile form
				SiteObject__c si = SiteBuilder.getSiteObject(centerId);
				if (si!=null)
					newLeadForm=si.subform__c;
			}
		}
		frm = new SubForm(newLeadForm,isoLang);
		//frm.title=Label.Site_UpdateProfile;
		//frm.description=Label.Site_UpdateProfileDesc;
		return null;
	}
	//////////////////////////////////////////////////////////////////////////////////////



/*******************************************************************************************
	EVENTS
*********************************************************************************************/
//////////////////////////////////////////////////////////////////////////////////////
	public PageReference Save() {
		

		Lead newlead = frm.toLead();
	
		//validatelead...
		if ( newLead.Type__c==null ) newLead.Type__c='Privacy Inquiry Request';
		newLead.Origin_Channel_Type__c='Website';
		newLead.Origin_Name__c='CenterId: '+centerId;
		newLead.Origin_Tracking_Code__c=lastUpdatedLocation;

			
		//check email matches
		if (email!=null) {
			if (newLead.email.tolowercase() != email) {
				newLead.Email.addError(Label.Site_EmailDoesNotMatch);
				//err=1;
				return null;
			}
		}
			
		system.debug('----new Lead--->'+newLead);
		
		try {
			
			//TESII_20091111 Trigger assignmentRule	(floris)
			Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            newLead.setOptions(dmo);
            //END TESII_20091111

			insert newLead;
		}
		catch (exception ex) {
			errMsg=ex.getMessage();
			err=true;
			return null;
		}

		showForm=false;
		showThankYou=true;
	
		return null;	
	}



	////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////

public static testMethod void test_ctrlPrivacyInquiry1() {
		SubscriptionCenter.TESTMODE=true;
		string subformId = Sitebuilder.testAddSubForm();
		string CenterId = SubscriptionCenter.testAddSubCenter('Center1');

		Test.startTest();
		PageReference pageRef = Page.MyProfile;
		Test.setCurrentPage(pageRef);
		
		ctrlPrivacyInquiry controller = new ctrlPrivacyInquiry();
		controller.init();
		controller.save();
		
		ApexPages.currentPage().getParameters().put('em', SubscriptionCenter.hash('tester@3ddd.com'));
		ApexPages.currentPage().getParameters().put('cid', CenterId);
		controller.init();
		controller.frm.newlead.Email='tester@3ddd.com';
		controller.save();
		
		ApexPages.currentPage().getParameters().put('nlf',subformId );
		controller.init();

		Test.stopTest();
	
    }   
	


}
/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component: SitePageBody
********************************************************************************/
public class ctrlSitePageBody {

	public static final string SCRIPT_WITH_ATTACHMENT = 'SiteScript with Attachment'; 
	
	public SiteScript script  					{get; set; }
	public boolean 	showScript					{get; private set; }
	public boolean	includeAttachment			{get; set; }
	public string	siteObjectReturnUrl			{get; set; }
	public reCAPTCHA ctrlCAPTCHA				{get; set; }
	public string	 CAPTCHA_Msg				{get; private set; }	
	
	public Pagebase base {
		SET {	
				if (script==null) init();
		}
		GET {
			return PageBase.getInstance();
		}
	}

	public PageReference init() {
		//SOID : SiteObject__c Id that represent the makeup of the page
		//If MemberPortal try to get SOID via portalId, otherwise get via Id 
		string SOID;
		if ( base.memberInfo!=null && base.memberInfo.portalId!=null)
			SOID= base.memberInfo.portalId;
		else
			SOID=ApexPages.currentPage().getParameters().get('id');
			
		SiteObject__c SiteObj = getSiteObject(SOID);

		if (SiteObj!=null) {
			
			if (SiteObj.CAPTCHA__c) this.ctrlCAPTCHA = new reCAPTCHA();
			
			if (SiteObj.campaign__c!=null && SiteObj.recordTypeId==MemberPortal.RTYPE_SO_MEMBERPORTAL) {
				//using Member Portal...make sure they are Authorized
				MemberPortal.Profile profile = base.getValidProfile(SiteObj.publicname__c);
				if (profile==null) {
					siteObjectReturnUrl='/apex/Unauthorized';
					return Page.Unauthorized;
				}
					
			}
			includeAttachment = (SiteObj.Type__c==SCRIPT_WITH_ATTACHMENT );
			siteObjectReturnUrl=SiteObj.ReturnUrl__c;		
			string scriptid=SiteObj.sitescript__c;
			
			if (scriptid!=null) {
				string headerid=ApexPages.currentPage().getParameters().get('sh');
				script = new SiteScript(scriptid, headerid);
				showScript=true;
				system.debug(script);
				return null;
			}
			else if (siteObjectReturnUrl!=null) {
				return new PageReference(siteObjectReturnUrl);
			}
			else
				return Page.UnderConstruction;
		}
		else {
			return Page.UnderConstruction;
		 }
	}

	public PageReference Save() {
		
		/*
		if (ctrlCAPTCHA!=null) {
			ctrlCAPTCHA.verify();
			if (!ctrlCAPTCHA.correctResponse) {
				system.debug('CAPTCHA:failed');
				return ctrlCAPTCHA.reset();
			}
		*/
		
		if (script!=null) {
			if (script.validate()) {
				if (ctrlCAPTCHA!=null) {
					CAPTCHA_Msg='';
					ctrlCAPTCHA.verify();
					if (!ctrlCAPTCHA.correctResponse) {
						CAPTCHA_Msg='CAPTCHA_INVALID';
						system.debug('CAPTCHA:failed');
						ctrlCAPTCHA.reset();
						return null;
					}
				}
				script.save();
				showScript=false;
			}
			else {
				system.debug('script.validate():failed');
				if (ctrlCAPTCHA!=null) ctrlCAPTCHA.reset();
			}
				
		}
		return null;
	}
	
	public string returnUrl {
		GET { if (script!=null)
				return (script.returnPageReference()!=null) ? script.returnPageReference().getUrl() : null;
			  else
			  	return siteObjectReturnUrl;
				
		}
	}
	
	public PageReference redirect() {
			if (siteObjectReturnUrl==null)
				return Page.UnderConstruction;
			PageReference p = new PageReference(siteObjectReturnUrl);	
			p.getParameters().putAll(ApexPages.currentPage().getParameters());
			p.setRedirect(false);
			return p;
	}
	
/*******************************************************************************
Helper methods
*******************************************************************************/
	//Consider moving to SiteBuilder Class	
	private static SiteObject__c getSiteObject(string soId) {
		SiteObject__c rtn;
		string soPrefix = SiteObject__c.sObjectType.getDescribe().getKeyPrefix();
		try {
			rtn= [Select PublicName__c, sitescript__c, type__c, recordTypeid, campaign__c, 
					ReturnUrl__c, CAPTCHA__c
					from SiteObject__c 
					where id=:soId AND IsPublic__c=true
					];
		}	
		catch (exception ex) {}
		return rtn;
	}

	//Determines if the page request is from Sites or Internal
	private static boolean isInternalRequest {
			GET {
				string loc=ApexPages.CurrentPage().getHeaders().get('Host');
				return loc.contains('visual.force.com');
			}	
	}
	

/*******************************************************************************
Test methods
*******************************************************************************/


}
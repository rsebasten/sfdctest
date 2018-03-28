/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component: memberPortal

TES20131002: added method getToken() and properties: portalid,memberEmail,urlEncode for use with
	MemberPortalToken VF component
********************************************************************************/
public class ctrlMemberPortal {
	public string 		ErrMsg			{set; get;}
	
	//memberportalToken component attributes
	public string		portalid			{get; set;} //SiteObject id or SiteObject external Id
	public string		memberEmail			{get; set;}	
	public boolean		urlEncode			{get; set;}
	
	
	public MemberPortal.Key member {
		GET  {
			return PageBase.getInstance().memberInfo;
		}
	}

	public ctrlMemberPortal() {
		urlEncode=true;
		PageBase pb = PageBase.getInstance();
		pb.addEvent('ctrlMemberPortal().constructor().Apexpages.currentPage():'+String.valueOf(Apexpages.currentPage()));
		pb.addEvent('memberPortal_init().Apexpages.currentPage():'+String.valueOf(Apexpages.currentPage()));
		//pb.addListner(new PageListner());
	}
	public ctrlMemberPortal(ctrlPageBase controller) {
		PageBase pb = PageBase.getInstance();
		pb.addEvent('ctrlMemberPortal().constructor(ctrlPageBase controller)');
		//pb.addListner(new PageListner());
	}
	

	public PageReference MemberPortal_OnLoad() {
		if (member!=null && member.isValid && member.portal.url!=null)
			return redirect();
		else
			ErrMsg='Access Denied or Application no longer available.';
		return null;
	}


	public string getToken() {
		string token = MemberPortal.createToken(portalid,memberEmail);
		return (urlEncode) ? EncodingUtil.urlEncode(token,'UTF-8') : token;
	}

/*
	//DEMO listner
	class PageListner implements PageBase.IPageListner {
		
		public PageReference onLoad() {
			//return MemberPortal_OnLoad();
			return null;
		}
 	}	
 */
 
	public static PageReference redirect() {
			try { 
				PageReference p = new PageReference(PageBase.getInstance().memberInfo.portal.url);
				p.getParameters().putAll(ApexPages.currentPage().getParameters());
				p.setRedirect(false);
				return p;
			}
			catch(Exception ex){}
			return null;
	}


}
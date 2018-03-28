/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder, Vinayak Vijayakumar
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com, Vinayak.Vijayakumar@usa.dupont.com
Description:  Controller for page: SFARAddPortalUser
 ********************************************************************************/ 
/********************************************************************************
<IM-20121017>
Email : Ibtesamuddin.Mohammed@dupont.com
Date : 2012/10/17
Description : * Added 3 level hierarhy Site Object(Portal)--Org group(Role)--OrgGroup Metadata(Settings)
 * Portal is mapped to Contact RecordType, defined in RecordType Settings
 ********************************************************************************/

/********************************************************************************
<SL-20140411>
Email : sai-sravanthhi.lakkimsetty@bra.dupont.com
Date : 2014/04/11
Description : Modified the existing process to accomodate multiple Site Objects for a single Contact Record Type and hence make the Portal a drop down instead of a Read Only text
 * Portal is mapped to Contact RecordType, defined in RecordType Settings
 ********************************************************************************/
public without sharing class ctrlSFARAddPortalUser {

	public static final string SFAR_PORTAL_RTYPE       = Rtype.getIdByDevName('SFDC_Access_Request__c','SFAR_Create_Portal_User');
	public static final string SITEOBJ_PORTAL_RTYPE     = Rtype.getIdByDevName('SiteObject__c','Portal');
	public static final string SITEOBJ_PORTAL_ITEM_RTYPE     = Rtype.getIdByDevName('OrgGroup__c','Portal_Access_Grouping');
	public Boolean flag; 
	public string portal_SiteObjId {get; set;}
	public string portal_SiteObjItemId {get; set;}
	public string contactId {get; set;}
	public Portal_Wrap portal;
	public LIST<SFAR_Log> sfarlogs;
	public String accountName {get; set;}
	public String contactName {get; set;}
	public String PreferedLang {get;set;}
	public String email1 {get;set;}
	public String contactCountry1 {get;set;}
	public string accessRole  {get; set;}
	public SiteObject__c portal_SiteObj;   
	public User PortalUser;
	public LIST<SFAR_Log> requestLog;
	public String portalName{get; set;}
	public LIST<SelectOption> portals{get; set;}
	public LIST<SelectOption> portalItems;
	public String baseURL;
	public boolean portalfound{get; set;}
	public boolean portalsettingsfound;
	public RecordTypeSettings__c rtSettings{get; set;}
	public String getBaseURL(){
		return URL.getSalesforceBaseUrl().toExternalForm();
	}
	//constructor
	public ctrlSFARAddPortalUser() {
		portalfound=false;
		portalsettingsfound=false;
		contactId=ApexPages.currentPage().getParameters().get('cid');
		List<Contact> con= [select Name,Account.Name,Email,Contact_Country__c,Prefered_Language__c,RecordTypeid from Contact where id = :contactId Limit 1];
		if(con.size()!=0){
			contactName=con.get(0).Name;
			email1=con.get(0).Email; 
			contactCountry1=con.get(0).Contact_Country__c;
			PreferedLang =con.get(0).Prefered_Language__c;
			accountName=con.get(0).Account.Name;
			rtSettings = Rtype.getSettingsById(con.get(0).RecordTypeid);
			system.debug('rtSettings are '+rtSettings+ con.get(0).RecordTypeid+' rectypeid');
			if(rtSettings==null || rtSettings.Portal__c==null){
				portalfound=false;
			}
			else{
				//portal_SiteObjId = rtSettings.Portal__c;
				//SL-20140411 - Start of Change to modify the Portal list from single text to a drop down
				String[] portal_SiteObjIdArray =rtSettings.Portal__c.split(';');
				List<SiteObject__c> sobj =  [Select id, Name from SiteObject__c where recordtypeid=:SITEOBJ_PORTAL_RTYPE And IsActive__c=true AND id IN :portal_SiteObjIdArray];                                   
				if(sobj.size()==0) portalfound=false;
				else{
					portalName =  sobj.get(0).Name;
					portals=new List<SelectOption>();
					portals.add(new SelectOption('',' --None-- '));
					for(SiteObject__c siteObj :sobj){
						portals.add(New SelectOption(siteObj.Id,siteObj.Name));
					}
					portalfound=true;
					//List<OrgGroup__c> siteObjectList=[Select id, Name from OrgGroup__c where SiteObject__c=:portal_SiteObjId AND recordtypeid=:SITEOBJ_PORTAL_ITEM_RTYPE];
					//if(siteObjectList.size()==0)  {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Access Settings Defined for this portal')); portalsettingsfound=false;} else portalsettingsfound = true;
					//SL-20140411 - End of Change
				}
			}        
			flag=false;
			if(!portalfound) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Portals assosciated with this Contact Type'));
		}
	}
	//Constructor with Parameter
	public ctrlSFARAddPortalUser(ApexPages.StandardController controller) {
		flag=false;
		contactId=controller.getId();
	}
	public class SFAR_Log {
		public Id Id{get; set;}
		public string name{get; set;}
		public string profile{get; set;}
		public string stage{get; set;}
		public string status{get; set;}
		public string KeyUser{get; set;}
		public  User userDetail;

		public SFAR_Log(SFDC_Access_Request__c sfar){
			id=sfar.id;
			name=sfar.name; 
			profile=sfar.profile__c;
			stage=sfar.stage__c;
			status=sfar.status__c;
			userDetail=[select Name from User where Id =:sfar.Key_User__c limit 1];
			KeyUser=userDetail.Name;
		}
	}

	public Boolean getFlag(){
		return flag;
	}

	public Portal_Wrap getPortal() {
		Portal_Wrap pw = getPortal_SiteObj();
		if(flag==true){ flag=false; return null;} 
		return (getPortal_SiteObj()!=null) ? pw : null;
	}

	public class Portal_Wrap {
		public Id Id   {get; set;}
		public string name{get; set;}
		public string profile{get; set;}
		public string role{get; set;}
		public string license{get; set;}
		public string owningBusiness{get; set;}
		public string accountApprover{get; set;}
		public string keyUser{get; set;}
		public string description{get; set;}
		public string url{get; set;}     
		public string viewingGroup{get; set;}     
		public string portalType{get; set;}     
		public string permissionSet{get; set;}
		public Id accountApproverId{get;set;}
		public Id keyUserId{get;set;} 
		public Id accessSettingId{get;set;}
		public String program{get; set;}         

		public Portal_Wrap(SiteObject__c p){
			id=p.id;
			name=p.name;    
			profile=p.Profile__c;
			license=p.License_Type__c;
			owningBusiness=p.Owning_Business__c;
			keyUser=p.key_user__r.Name;
			accountApprover=p.Access_Approver__r.Name;
			description     =p.Description__c;
			viewingGroup=p.Group__c;
			url=p.url__c;
			portalType=p.Type__c;
			accountApproverId=p.Access_Approver__c;
			keyUserId=p.key_User__c;
		}
		public Portal_Wrap(SiteObject__c p,OrgGroup__c pi){
			profile = '';
			viewingGroup = '';
			permissionSet = '';
			List<String> groupNameList = new List<String>();
			List<String> permissionSetNameList = new List<String>();
			id=p.id;
			name=p.name;
			program = p.Program__c;    
			license=p.License_Type__c;
			owningBusiness=p.Owning_Business__c;
			keyUser=p.key_user__r.Name;
			accountApprover=p.Access_Approver__r.Name;
			description     =p.Description__c;
			url = p.url__c;
			portalType = p.Type__c;
			accountApproverId=p.Access_Approver__c;
			keyUserId=p.key_User__c;
			accessSettingId=pi.Id;  
			role=pi.Portal_Role__c;

			for(OrgGroupMetadata__c ogm :  [select id,name,Related_Metadata__r.Name,Metadata_Type__c,Related_Metadata__c,Related_Metadata__r.Label__c from OrgGroupMetadata__c where OrgGroup__c=:pi.id]){
				if(ogm.Metadata_Type__c == 'Profile')
					profile = ogm.Related_Metadata__r.Label__c;
				if(ogm.Metadata_Type__c == 'Group')
					groupNameList.add(ogm.Related_Metadata__r.Name);
				if(ogm.Metadata_Type__c == 'PermissionSet')
					permissionSetNameList.add(ogm.Related_Metadata__r.Name);
			}

			List<Group> groupList = [select id,Developername,Name from group where Developername IN : groupNameList ];
			List<permissionSet> permissionSetList=[select id,Name,Label from PermissionSet where Name IN : permissionSetNameList];

			for(Integer i=0;i<groupList.size();i++){
				viewingGroup += groupList.get(i).Name +' \r\n';
			}
			for(PermissionSet ps :permissionSetList)
				permissionSet += ps.Label +'; ';   
		}
	}

	public User getPortalUser() {
		LIST<User> rtn = new LIST<User>([Select Id, Profile.Name from User where ContactId=:contactId]);
		if (rtn.size()>0)
			return rtn[0];
		else
			return null;
	}

	public LIST<SFAR_Log> getRequestLog(){   
		if (sfarlogs==null || sfarlogs.size()==0) {
			sfarlogs = new LIST<SFAR_Log>();
			for( SFDC_Access_Request__c sfar : [Select id, Name, Stage__c, Status__c,Portal_Contact__c, profile__c, user__c,Key_User__c from  SFDC_Access_Request__c where recordtypeId=:SFAR_PORTAL_RTYPE AND Portal_Contact__c=:contactId]) {
				sfarlogs.add(new SFAR_Log(sfar));
			}
		}    
		return sfarlogs;
	}

	public LIST<SelectOption> getPortalItems() {
		//if(rtsettings!=null) portal_SiteObjId = rtSettings.Portal__c;
		system.debug('Portal Settings'+portalsettingsfound);
		List<SelectOption> portalList = new List<SelectOption>();
		portalList.add(new SelectOption('',' --None-- '));
		for(OrgGroup__c portal : [Select id, PortalAccessGrouping__c,Name from OrgGroup__c where SiteObject__r.id=:portal_SiteObjId Order by PortalAccessGrouping__c]){
			portalList.add(New SelectOption(portal.id ,portal.PortalAccessGrouping__c));
		}
		system.debug(portalList+' portalList');
		return portalList;
	}

	//SL-20140411 - Add new method to render the access settings panel in the Page based on the availability
	Public Boolean getportalsettingsfound(){
		Boolean SettingsFound;
		if(portal_SiteObjId == '' || portal_SiteObjId==null ){
			SettingsFound = false;
		}
		else{
			List<OrgGroup__c> siteObjectList=[Select id, Name from OrgGroup__c where SiteObject__c=:portal_SiteObjId AND recordtypeid=:SITEOBJ_PORTAL_ITEM_RTYPE];
			if(siteObjectList.size()==0)  {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Access Settings Defined for this portal'));SettingsFound = false;} else {SettingsFound = true;}
		}
		return SettingsFound;
	}

	public Portal_Wrap getPortal_SiteObj(){
		System.debug('inside getPortal'+portal);
		if (portal==null){ 
			try {
				SiteObject__c portalMaster = [ Select Id, OwnerId, Key_User__r.Name, Key_User__c,Owner.Name, Name, Url__c, Owning_Business__c, 
				                               Access_Approver__c, Access_Approver__r.Name, License_Type__c, Description__c, Type__c,Program__c
				                               From SiteObject__c
				                               where id =:portal_SiteObjId ];
				OrgGroup__c portalItem = [select id,Name,Portal_Role__c from OrgGroup__c where id = :portal_SiteObjItemId];
				portal=new Portal_Wrap(portalMaster,portalItem);          
			}
			catch(Exception ex){}
		}
		return portal;
	}

	public boolean AllowCreate() {
		//todo validate via active requests
		return true;
	}
	/////////////////////////////////////////////////////////////////////
	// Methods
	/////////////////////////////////////////////////////////////////////

	public void portalOnSelect() {
		portal_SiteObjItemId=null;//SL-20140411
		portal=null;
	}
	public void portalItemOnSelect() {
		portal=null;
	}
	/*
  public void deleteSFAR() {
    String delId= ApexPages.CurrentPage().getParameters().get('delId');
    //System.debug('1st outside *** '+delId);
    if (!Util.isBlank(delId)) {
      SFDC_Access_Request__c sfar = [Select Id, status__c from SFDC_Access_Request__c where id=:delId];
      if (sfar.status__c.tolowercase()=='new'){
        delete sfar;                     
      }
    }
    sfarlogs=null;
    delId=null;
    portal_SiteObjId=null;
    portal_SiteObjItemId=null;
    portal=null;
    flag=true;
  }
	 */
	public pageReference createSFAR() {
		if(email1==null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please go back to the Contact and fill in Email field to Create a SFAR Request'));
			return new PageReference('/apex/SFARAddPortalUser');
		}
		else{
			Id currentUserId1 = userinfo.getUserId();
			Portal_Wrap portal = this.getPortal_SiteObj();
			SFDC_Access_Request__c sfar = new SFDC_Access_Request__c(
					License_Type__c=portal.License,
					RecordTypeId=SFAR_PORTAL_RTYPE,
					Profile__c=portal.Profile,
					Portal_Contact__c=contactId,
					Owning_Business__c=portal.OwningBusiness,
					Groups__c=portal.viewingGroup,
					Key_User__c=portal.keyUserId,
					Site_Object__c=portal.Id,
					role__c=portal.Role,
					Description__c=portal.Description,
					Access_Approver__c=portal.accountApproverId,
					Access_Requester__c=currentUserId1,
					OwnerId=portal.keyUserId,
					User_Country__c=contactCountry1,
					Language__c =PreferedLang,
					Email_Address__c=email1,
					//Permission_Sets__c=portal.permissionSet,
					Program__c = portal.program,
					Permission_Set_Assignment__c = portal.permissionSet,
					Access_Request_History__c = getSFARAccessLog(portal.Role,portal.Profile,portal.viewingGroup,portal.permissionSet)
					);
			insert sfar;
			System.debug('the sfar is '+sfar);
			portal_SiteObjId=null;
			portal_SiteObjItemId=null;
			portal=null;
			sfarlogs=null;
			//roles=null;
			flag=true;
			return new PageReference('/apex/SFARAddPortalUser');
		}
	}
	public String getSFARAccessLog(String Role,String Profile,String Groupp,String PermissionSets){
		String Log = '------------------- Access Requested By \" '+UserInfo.getName()+' \" , TimeStamp(GMT) : '+System.Now()+' -------------------\n\n ';
		if(Role!=null)
			Log = Log+ ' Role : '+Role+'\n\n';
		if(Profile!=null)
			Log = Log+ ' Profile : '+Profile+'\n\n';
		if(Groupp!=null)
			log = Log+' Public Groups : '+'\n'+Groupp+'\n';
		if(PermissionSets.length()!=0){
			Log = Log+ ' Permission Sets : '+'\n';
			String[] ps = PermissionSets.Split(';');
			for(String permissionSet : ps) Log = Log+permissionSet+'\n';
		}
		Log = Log +'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
					return Log;
	}
}
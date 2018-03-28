@isTest
public class ctrlSFARAddPortalUser_UT{
public static TestMethod void testMethods(){
    final string SFAR_PORTAL_RTYPE       = Rtype.getIdByDevName('SFDC_Access_Request__c','SFAR_Create_Portal_User');
    final string SITEOBJ_PORTAL_RTYPE     = Rtype.getIdByDevName('SiteObject__c','Portal');
    final string SITEOBJ_PORTAL_ITEM_RTYPE     = Rtype.getIdByDevName('OrgGroup__c','Portal_Access_Grouping');
  
    GeoValidation.DisableGeoValidationOverride=True;
    Profile p = [select id from profile where Name='System Administrator' limit 1];
    UserRole r= [Select id from UserRole where Name='PS CRM' limit 1];
 //[05102017] Merge&Spin: Corrected API Names of record type at line No 12,13   
    Id METADATA_RTYPE = Rtype.getIdByDevName('Metadata__c','GeneralAsset');
    Id CONTACT_RTYPE = Rtype.getIdByDevName('Contact','BI_NA_Contact');
    User thisUser=new User(LastName='XYZ',UserRoleId=r.Id,ProfileId=p.Id,Alias='ibtesam',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='Ibtesamuddin.Mohammed.test21@usa.dupont.com.test512', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
    insert thisUser;
    System.runAs(thisUser){
      Account Acc1 = new Account(name='test Account1', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123');
      insert new Account[]{Acc1}; 
      Contact con1 = new Contact(LastNameLocal='test Contact1',lastname='test',recordTypeid = CONTACT_RTYPE, AccountId =Acc1.Id,Status__c='Under Review');
      Contact con2 = new Contact(LastNameLocal='test Contact12',lastname='test2', AccountId =Acc1.Id,Status__c='Under Review');
      insert new Contact[] {con1,con2};
      Profile p1 = [select id,UserLicenseid from profile where usertype = 'PowerPartner' limit 1];
      User user2=new User(LastName='XYZ',ProfileId=p1.Id,Alias='sam12',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='Ibtesamuddin.Mohammed.test@usa.dupont.com.test1122', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America',contactId=con1.Id);
      User user1=new User(LastName='XYZ',ProfileId=p.Id,Alias='sam123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='Ibtesamuddin.Mohammed.test@usa.dupont.com.test5212', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
      insert user1;
      insert user2;
   //[01022017] Merge&Spin: Replaced Hard coding of record type Id
      string SFAR_Create_Portal_User_RType = RType.getIdByDevname('SFDC_Access_Request__c','SFAR_Create_Portal_User');   
      SFDC_Access_Request__c sfar1=new SFDC_Access_Request__c(key_user__c=user2.Id,Owning_Business__c='Performance Coatings',User_Access_Type__c='Portal',Program__c='CPC-LA',Type__c='Create new User',Subtype__c='New User Account',Status__c='New',RecordTypeId=SFAR_Create_Portal_User_RType );
      SFDC_Access_Request__c sfar2=new SFDC_Access_Request__c(key_user__c=user1.Id,Owning_Business__c='Performance Coatings',User_Access_Type__c='Portal',Program__c='CPC-LA',Type__c='Create new User',Subtype__c='New User Account',Status__c='New',RecordTypeId=SFAR_Create_Portal_User_RType );
      insert new SFDC_Access_Request__c[]{sfar1,sfar2};          
      SiteObject__c siteObj = new SiteObject__c(Name='testPortal',Owning_Business__c='Performance Coatings',License_Type__c='Gold Partner',Owning_Organization__c='DPC-Industrial-Coating Solutions',Program__c='DPC ICS',Type__c='Partner Portal',IsActive__c=true,RecordTypeId=SITEOBJ_PORTAL_RTYPE,key_user__c=user2.Id,Access_Approver__c=user2.Id);
      insert siteObj;
      OrgGroup__c org = new OrgGroup__c(PortalAccessGrouping__c='Test',RecordTypeId=SITEOBJ_PORTAL_ITEM_RTYPE,SiteObject__c=siteObj.id,Portal_Role__c='User');
      insert org ;
      OrgGroup__c org2 = new OrgGroup__c(PortalAccessGrouping__c='Test1',RecordTypeId=SITEOBJ_PORTAL_ITEM_RTYPE,SiteObject__c=siteObj.id);
      insert org2 ;
      PermissionSet ps = new PermissionSet(Label='testLabel',Name='Testname');
      insert ps;
      Group grp = new Group(Name='testLabel',DeveloperName='Testname');
      insert grp;
      Metadata__c meta1 = new Metadata__c(Type__c='Profile',Label__c='testLabel',FullName__c='TestFullName1',Name='Testname',RecordTypeId=METADATA_RTYPE);
      Metadata__c meta2 = new Metadata__c(Type__c='PermissionSet',Label__c='testLabel',FullName__c='TestFullName2',Name='Testname',RecordTypeId=METADATA_RTYPE);
      Metadata__c meta3 = new Metadata__c(Type__c='Group',Label__c='testLabel',FullName__c='TestFullName3',Name='Testname',RecordTypeId=METADATA_RTYPE);
      Metadata__c meta4 = new Metadata__c(Type__c='PermissionSet',Label__c='testLabel',FullName__c='TestFullName4',Name='Testname',RecordTypeId=METADATA_RTYPE);
      Metadata__c meta5 = new Metadata__c(Type__c='Group',Label__c='testLabel',FullName__c='TestFullName5',Name='Testname',RecordTypeId=METADATA_RTYPE);
      Metadata__c[] mdList = new Metadata__c[]{meta1,meta2,meta3,meta4,meta5};
      insert mdList;
      List<OrgGroupMetadata__c> orgGroupMList = new List<OrgGroupMetadata__c>();
      OrgGroupMetadata__c ogm1 = new OrgGroupMetadata__c(Metadata_Type__c='Profile',Related_Metadata__c=meta1.id,OrgGroup__c=org.id);
      OrgGroupMetadata__c ogm2 = new OrgGroupMetadata__c(Metadata_Type__c='PermissionSet',Related_Metadata__c=meta2.id,OrgGroup__c=org.id);
      OrgGroupMetadata__c ogm3 = new OrgGroupMetadata__c(Metadata_Type__c='Group',Related_Metadata__c=meta3.id,OrgGroup__c=org.id);
      OrgGroupMetadata__c ogm4 = new OrgGroupMetadata__c(Metadata_Type__c='PermissionSet',Related_Metadata__c=meta4.id,OrgGroup__c=org.id);
      OrgGroupMetadata__c ogm5 = new OrgGroupMetadata__c(Metadata_Type__c='Group',Related_Metadata__c=meta5.id,OrgGroup__c=org.id);
      OrgGroupMetadata__c[] ogmList = new OrgGroupMetadata__c[]{ogm1,ogm2,ogm3,ogm4,ogm5};
      insert ogmList;
      RecordTypeSettings__c rtSettings = new RecordTypeSettings__c(FullName__c='Contact.TestContact',Portal__c=siteObj.id,Name='TestRtSettings');
      insert rtSettings;
      system.debug(rtSettings.FullName__c+' Full name matches'+ rtSettings.id);

      Test.startTest();

      PageReference pageRef = Page.SFARAddPortalUser;
      Test.setCurrentPage(pageRef);
      ApexPages.Standardcontroller as1 = new ApexPages.Standardcontroller(con1);
      ApexPages.currentPage().getParameters().put('cid',con1.id);
      ctrlSFARAddPortalUser controller = new ctrlSFARAddPortalUser(as1);
      ctrlSFARAddPortalUser.SFAR_Log s2= new ctrlSFARAddPortalUser.SFAR_Log(sfar2);
      ctrlSFARAddPortalUser.Portal_wrap pw2 = new ctrlSFARAddPortalUser.Portal_Wrap(siteObj,org);
      controller.getBaseUrl();
      controller.flag=true;
      controller.portal=pw2;
      controller.portal_SiteObjId=siteObj.Id;
      controller.portal_SiteObjItemId=org.Id;
      controller.getPortal();
      controller.getPortalItems();
      controller.createSFAR();
      controller.flag=false;
      controller.getFlag();
      controller.AllowCreate();
      controller.getRequestLog();
      controller.portalOnSelect();
      controller.portalItemOnSelect();
      controller.getPortalUser();
      controller.flag=false;
      controller.getPortal();
      con1.Email='Ibtesamuddin_M@infosys.com';
      update con1;
      controller = new ctrlSFARAddPortalUser();
      ApexPages.currentPage().getParameters().put('cid',con1.id);
      controller = new ctrlSFARAddPortalUser(as1);
      controller.email1=con1.Email;
      controller.portal_SiteObjId=siteObj.Id;
      controller.portal_SiteObjItemId=org.Id;
      controller.portal=pw2;
      controller.createSFAR();
      controller.getRequestLog();
      ctrlSFARAddPortalUser.SFAR_Log s1= new ctrlSFARAddPortalUser.SFAR_Log(sfar1);
      ctrlSFARAddPortalUser.Portal_wrap pw = new ctrlSFARAddPortalUser.Portal_Wrap(siteObj);
      ApexPages.Standardcontroller as2 = new ApexPages.Standardcontroller(con2);
      ApexPages.currentPage().getParameters().put('cid',con2.id);
      controller = new ctrlSFARAddPortalUser();
      controller.getPortalUser();
      controller.portal = NULL;
      controller.portal_SiteObjId='13123213123';
      controller.getPortal_SiteObj();
      Test.StopTest();
    }
  } 
}
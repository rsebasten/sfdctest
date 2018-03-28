/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Tests for MemberPortal
********************************************************************************/
@isTest
private class MemberPortal_UT {


public static Account testAccount { 	GET { return new Account(name='TestCo: ', country__c='United States'); }}
public static Contact testContact { 	GET { return new Contact(lastname='TestCo: ', email='tester@test.com'); }}
public static Campaign testCampaign {	GET { return new Campaign(name='TestCampaign '); }}
////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////


	public static testMethod void test_MemberPortal() {
		
		geovalidation.DisableGeoValidationOverride=true;
		Account a = testAccount;
		insert a;
		Contact c = testContact;
		c.accountid=a.id;
		insert c;
		Campaign camp = testCampaign;
		insert camp;
		insert new CampaignMember(campaignid=camp.id, ContactId=c.id);
		
		SiteObject__c so = new SiteObject__c(Name='Test MP', PublicName__c='Test MP', RecordTypeId=MemberPortal.RTYPE_SO_MEMBERPORTAL,
			 IsPublic__c=true, campaign__c=camp.id, ReturnUrl__c='/apex/sitePage');
		insert so;
		
		string testkey=MemberPortal.createKey(so.id,a.id,c.id);
		system.debug('testkey:'+testkey);
		MemberPortal.Key k = new MemberPortal.Key(testkey);
	
		system.debug('----IS VALID---->'+k.isValid);
		
		System.assertEquals(false, k.isValidFor('no such MP')); 	// should fail
		System.assertEquals(true, k.isValidFor('TEST MP'));  		// case insensitive
		
		system.debug('----portalId---->'+k.portalId);
		system.debug('----contactId---->'+k.contactId);
		system.debug('----accountId---->'+k.accountId);
		system.debug('----memberId---->'+k.memberId);
		system.debug('----status---->'+k.status);
		system.debug('----memberStatus---->'+k.memberStatus);
		system.debug('----campaignId---->'+k.campaignId);
		system.debug('----portal.id---->'+k.portal.id);
		system.debug('----portal.name---->'+k.portal.name);
		system.debug('----portal.url---->'+k.portal.url);
		system.debug('----portal.campaignId---->'+k.portal.campaignId);
		system.debug('----portal.pageType---->'+k.portal.pageType);
		
		MemberPortal.Profile p = k.Profile;
		system.debug('----p.contactId---->'+p.contactId);
		system.debug('----p.accountId---->'+p.accountId);
		system.debug('----p.accountName---->'+p.accountName);
		system.debug('----p.lastName---->'+p.lastName);
		system.debug('----p.firstName---->'+p.firstName);
		system.debug('----p.Country---->'+p.Country);
		system.debug('----p.email---->'+p.email);
		
		//TRY again with invalid key
		k = new MemberPortal.Key('a1qQ00000000XXX001Q0000002sRoj003Q0000003XXX');
		system.debug(k);
		system.debug('----portalId---->'+k.portalId);
		system.debug('----contactId---->'+k.contactId);
		system.debug('----accountId---->'+k.accountId);
		system.debug('----memberId---->'+k.memberId);
		system.debug('----status---->'+k.status);
		system.debug('----memberStatus---->'+k.memberStatus);
		system.debug('----campaignId---->'+k.campaignId);
		system.debug('----portal--->'+k.portal);

		p = k.Profile;
		system.debug('----p.contactId---->'+p.contactId);
		system.debug('----p.accountId---->'+p.accountId);
		system.debug('----p.accountName---->'+p.accountName);
		system.debug('----p.lastName---->'+p.lastName);
		system.debug('----p.firstName---->'+p.firstName);
		system.debug('----p.Country---->'+p.Country);
		system.debug('----p.email---->'+p.email);
	}



	public static testMethod void test_MemberPortalusingToken() {
		
		Account a = testAccount;
		insert a;
		Contact c = testContact;
		c.accountid=a.id;
		insert c;
		Lead l = new Lead(lastname='Tester', firstname='Tom', email='tester@test.com', company='testCo');
		insert l;
		
		Campaign camp = testCampaign;
		insert camp;
		CampaignMember cm1 = new CampaignMember(campaignid=camp.id, ContactId=c.id);  
		insert cm1;
		CampaignMember cm2 = new CampaignMember(campaignid=camp.id, LeadId=l.id); 
		insert cm2;
				
		SiteObject__c so = new SiteObject__c(Name='Test MP', PublicName__c='Test MP', RecordTypeId=MemberPortal.RTYPE_SO_MEMBERPORTAL,
			 IsPublic__c=true, campaign__c=camp.id, ReturnUrl__c='/apex/sitePage', ExternalId__c='TESII_MP');
		insert so;
		
		
		Test.startTest(); 
		string token1=MemberPortal.createToken('TESII_MP','tester@test.com');
		string token2=MemberPortal.createToken(so.id,'tester@test.com');
		
		MemberPortal.Key k1 = new MemberPortal.Key(token1);
		MemberPortal.Key k2 = new MemberPortal.Key(token2);	
		
		system.debug(k1);
		system.debug(k2);
		//TEST: receive contact over lead and retrieve portal via External ID
		system.assertEquals(k1.contactid, c.id);
		//TEST: receive contact over lead and retrieve portal via id
		system.assertEquals(k2.contactid, c.id);	

		delete cm1;		
		k1 = new MemberPortal.Key(token1);
		k2 = new MemberPortal.Key(token2);
		//TEST: contact is now deleted should retrieve lead
		system.assertEquals(k1.leadid, l.id);
		system.assertEquals(k2.contactid, null);
		
		//should return Member status ('Send')
		string token = MemberPortal.getUserToken('TESII_MP', 'tester@test.com');
		system.debug(memberPortal.getUserAccess(token));
		    
        ctrlMemberPortal ctrl = new ctrlMemberPortal();
        ctrl.portalId='TESII_MP';
    	ctrl.memberEmail='tester@test.com';
    	system.debug(ctrl.getToken());
    	ctrl.urlEncode=false;
    	system.debug(ctrl.getToken());
    	system.debug(ctrl.MemberPortal_OnLoad()); 
    	system.debug(ctrl.member);
    	system.debug(ctrlMemberPortal.redirect());
        Test.stopTest();
		
 
	}
}
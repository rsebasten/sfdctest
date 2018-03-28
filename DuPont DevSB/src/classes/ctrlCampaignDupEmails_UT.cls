/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Test for Controller: ctrlCampaignDupEmails
********************************************************************************/
@isTest
public with sharing class ctrlCampaignDupEmails_UT {


    public static testMethod void test1() {
        Campaign  campA = new Campaign(name='ParentA'); 
        Campaign  campB = new Campaign(name='ParentB');
        insert new Campaign[]{campA,campB}; 
        Campaign  campA1 = new Campaign(name='ChildA1', parentid=campA.id);    
        Campaign  campA2 = new Campaign(name='ChildA2', parentid=campA.id);        
        insert new Campaign[]{campA1,campA2};
        
        Account a = new Account(name='test', Country__c='United States');
        insert a;
        Contact contact1 = new Contact(lastname='test1', email='test@test.com', Account=a);
        Contact contact2 = new Contact(lastname='test2', email='test@test.com', Account=a);
        Contact contact3 = new Contact(lastname='test3', email='test3@test.com', Account=a);
        insert new Contact[]{contact1, contact2, contact3}; 
        
        CampaignMember member1 = new CampaignMember(CampaignId=campA1.id, Contactid=contact1.id );
        CampaignMember member2 = new CampaignMember(CampaignId=campA1.id, Contactid=contact2.id );
        CampaignMember member3 = new CampaignMember(CampaignId=campA1.id, Contactid=contact3.id );
        CampaignMember member4 = new CampaignMember(CampaignId=campB.id, Contactid=contact1.id );
        CampaignMember member5 = new CampaignMember(CampaignId=campB.id, Contactid=contact2.id );
        CampaignMember member6 = new CampaignMember(CampaignId=campB.id, Contactid=contact3.id );
        insert new CampaignMember[]{member1, member2, member3, member4, member5, member6}; 
    
        Test.startTest();
        PageReference pageRef = Page.CampaignDupEmails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', campA1.id);        
        ctrlCampaignDupEmails ctrl = new ctrlCampaignDupEmails();
 
        system.debug(ctrl.getDuplicateMembers());
        system.debug(ctrl.toXSL());
        system.debug(ctrl.back());
        system.assertEquals(2,ctrl.getDuplicateMembers().size());
        
        //test a camp with no parent
        ApexPages.currentPage().getParameters().put('id', campB.id);  
        ctrl = new ctrlCampaignDupEmails();
        system.debug(ctrl.getDuplicateMembers());
        
        
        Test.stopTest();
    }  
    
 
}
@isTest
private class SubscriptionCenter_UT {
    public static string testAddSubCenter(string name) {
        SubscriptionCenter.TESTMODE=true;
        string subformId = SiteBuilder.testAddSubform();
        Campaign  ListA = new Campaign(name=name+'.ListA', recordTypeid=SubscriptionCenter.RTYPE_CAMP_SUBLIST, publicname__c=name+'.ListA');   
        Campaign  ListB = new Campaign(name=name+'.ListB', recordTypeid=SubscriptionCenter.RTYPE_CAMP_SUBLIST, publicname__c=name+'.ListB');   
        //insert new Campaign[]{ListA,ListB};
        List<Campaign> camps=new List<Campaign>();
        camps.add(ListA);
        camps.add(ListB);
        insert camps;
        SiteObject__c Center1 = new SiteObject__c(name=name, type__c='Subscription Center', recordTypeid=SiteBuilder.RTYPE_SO_CENTER, 
                                                  publicname__c=name, returnUrl__c='www.3ddd.com', subform__c=subformId);   
        //insert Center1;
        //SiteObject__c Center2 = new SiteObject__c(name=name+'test', type__c='Subscription List', recordTypeid=SiteBuilder.RTYPE_SO_LIST, 
        //                                          publicname__c=name+'test',Campaign__c=camps[0].Id,
        //                                          ExternalId__c=UserInfo.getOrganizationId()+camps[0].Id);   
        






        LIST<SiteObject__c> sites = new LIST<SiteObject__c>();
        sites.add(Center1);
        //sites.add(Center2);
        insert sites;
        
        LIST<SiteObject__c> soLists = new LIST<SiteObject__c>([


            Select Id from SiteObject__c 
            //where Campaign__c in ( :ListA.id, :ListB.id )
            where Campaign__c IN: camps 
            ]);
        
        for (SiteObject__c sol : soLists) {
            insert new SiteObjectItem__c(SiteObject__c=Center1.id, ChildSiteObject__c=sol.id, recordtypeid=SiteBuilder.RTYPE_SOI_CENTERITEM);
            
        }
        return Center1.Id;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
    private static testMethod void test_SubscriptionCenter() {

        SubscriptionCenter.TESTMODE=true;
        string CenterId = SubscriptionCenter_UT.testAddSubCenter('Center1');
        SubscriptionCenter.SubCenter center = new SubscriptionCenter.SubCenter(CenterId);
        SubscriptionCenter.SubList lst = center.getItems()[0];
        string email = 'subscriptioncentertester@3ddd.com';
        string sid=lst.globalCampaignId+email;
        System.debug('@#debuggetItems'+center.getItems());
        //OPT-IN  tester to all lists
        for (SubscriptionCenter.SubList l : center.getItems() )
            l.checked=true; 
        center.save(email, 'test_SubscriptionCenter1');
        system.debug(center.isDirty);
        system.debug(center.numChecked);
        system.debug(center.getItem(lst.id));
        string campid=lst.globalCampaignId.substring(15);
        
        
        //Add tester as Contact and add to lst Campaign as status = member-transactional
        Account a = new Account(name='test', Country__c='United States');
        insert a;
        Contact contact1 = new Contact(lastname='test', email=email, Account=a, Contact_Country__c='United States');
        insert contact1;
        CampaignMember member = new CampaignMember(campaignid=campid, status=SubscriptionCenter.MEMBER_TRANS, Contactid=contact1.id );
        insert member;
        system.debug('------member----->'+member);
        system.debug([Select value__c, LastUpdatedLocation__c, ExternalId__c from SiteObjectValue__c where ExternalId__c=:sid]);        
        
        
        //requery the centers and try to opt out of all lists....
        center = new SubscriptionCenter.SubCenter(CenterId);
        for (SubscriptionCenter.SubList l : center.getItems() )
            l.checked=false;    
        center.save(email,'test_SubscriptionCenter2');
        system.debug([Select value__c, LastUpdatedLocation__c, ExternalId__c from SiteObjectValue__c where LastUpdatedLocation__c like 'test_SubscriptionCenter%']);
        //system.assertEquals([Select value__c from SiteObjectValue__c where ExternalId__c=:sid][0].value__c, MEMBER_TRANS);
            
        //delete the campaign...
        try {   
        delete new Campaign(id=campid);
        }
        catch(Exception ex) {}
        
        
        system.debug(SubscriptionCenter.crlfToBR('this\nthat'));
        system.debug(SubscriptionCenter.mergefieldUrl('{!email}{!lang}{!src}', null, null, null));
        system.debug(SubscriptionCenter.hash('hashthis'));











        
    }
////////////////////////////////////////////////////////////////////////////////////
}
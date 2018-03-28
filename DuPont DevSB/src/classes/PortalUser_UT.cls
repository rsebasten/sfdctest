@isTest
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Tests form PortalUser.cls
********************************************************************************/
private class PortalUser_UT {

    static TestMethod void test_PortalUser(){

        //commented for dps
        //Profile p  = [select id from Profile where UserLicense.Name like '%Customer Portal%' limit 1];
        Profile p  = [select id from Profile where UserLicense.Name like '%Partner Community%' limit 1];

        //Update to fix test class failure related to portal account owner
        Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
        UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];
        
        User owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsreeee',isActive = true,username='a@testingq1.com');
        insert owner;
        
        Account a = new Account();
        Contact con = new Contact();
        
        System.runAs(owner) {

            a =new Account(name='TestCo', country__c='UNITED STATES', OwnerId = owner.Id);
            insert a;
            con =new Contact(accountid=a.id, firstname='Tom', lastname='Tester', email='tester@test.com', OwnerId = owner.Id);
            insert con;
        }
        Profile p1 = [select id from profile where usertype = 'PowerPartner' limit 1];
        User user1=new User( contactId=con.Id, LastName='TESTER', ProfileId=p.Id,Alias='custP',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='test@test.com' ,UserName='test_portalUserDPS@test.com', EPass_ID__c='NA0000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
        insert user1;
            
        Test.startTest();
        System.runAs(user1){
            system.assertEquals(a.id, PortalUser.getInstance().accountId);
            system.assertEquals(con.id, PortalUser.getInstance().contactId);
            system.assertEquals(con.firstname, PortalUser.getInstance().firstname);
            system.assertEquals(con.lastname, PortalUser.getInstance().lastname);
            system.assertEquals(con.email, PortalUser.getInstance().email);
            system.assertEquals('TestCo', PortalUser.getInstance().accountName);   
            system.assertEquals('UNITED STATES', PortalUser.getInstance().Country);   
            system.debug(PortalUser.getAccount());    
            system.debug(PortalUser.getContact());      
        }
        Test.stopTest();
    }   
       
     
    static TestMethod void test_PortalUserAsStdUser() { //run as non-portal user
            system.assertEquals(null, PortalUser.getInstance().accountId);
            system.assertEquals(null, PortalUser.getInstance().contactId);
            system.assertEquals(null, PortalUser.getInstance().firstname);
            system.assertEquals(null, PortalUser.getInstance().lastname);
            system.assertEquals(null, PortalUser.getInstance().email);
            system.assertEquals(null, PortalUser.getInstance().accountName);   
            system.assertEquals(null, PortalUser.getInstance().Country);   
            system.debug(PortalUser.getAccount());    
            system.debug(PortalUser.getContact());            
        } 
     
    static TestMethod void test_PortalUserAsMemberPortal(){    
        
        Account a =new Account(name='MPTestCo', country__c='UNITED STATES');
        insert a;
        Contact con =new Contact(accountid=a.id, firstname='TomMP', lastname='MPTester', email='mptester@test.com');
        insert con;
        Campaign camp = new Campaign(name='Test MemberPortal Campaign ');
        insert camp;
        insert new CampaignMember(campaignid=camp.id, ContactId=con.id);
        
        SiteObject__c so = new SiteObject__c(Name='Test MP', PublicName__c='Test MP',
             RecordTypeId=MemberPortal.RTYPE_SO_MEMBERPORTAL,
             IsPublic__c=true, campaign__c=camp.id, ReturnUrl__c='apex/somepage');
        insert so;
        
        string mpKey = MemberPortal.createKey(so.id,a.id,con.id);
        
        LIST<User> users = [select Id from User where UserType='Guest' And IsActive=true LIMIT 1];
        if (users.size()>0) {
            System.runAs(users[0]) {
            
                System.currentPageReference().getParameters().put('key', mpKey);
        
                system.debug(Pagebase.getInstance().memberKey);
                system.debug(Pagebase.getInstance().memberInfo.Profile);                
                
                /*system.assertEquals(a.id, PortalUser.getInstance().accountId);
                system.assertEquals(con.id, PortalUser.getInstance().contactId);
                system.assertEquals(con.firstname, PortalUser.getInstance().firstname);
                system.assertEquals(con.lastname, PortalUser.getInstance().lastname);
                system.assertEquals(con.email, PortalUser.getInstance().email);
                system.assertEquals(a.Name, PortalUser.getInstance().accountName);   
                system.assertEquals(a.country__c, PortalUser.getInstance().Country);   
                */
                system.debug(PortalUser.getAccount());    
                system.debug(PortalUser.getContact());          
            }
        }
    }
}
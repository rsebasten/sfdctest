/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UT for EmailBase (Privacy Notification) 
********************************************************************************/
@isTest
private class EmailBase_UT {
  
  
  /*
  static testMethod void testPersonAccount() {  
    delete [Select id from Email__c where email__c like '%emailbaseut.com'];
    
    Id RTypeId = [
            SELECT r.Id, r.Name, r.DeveloperName, r.IsPersonType 
            FROM RecordType r 
            WHERE sObjectType = 'Account' AND IsPersonType=True LIMIT 1
        ].Id;
    Account a =new Account(recordtypeid=RTypeId, PersonLastNameLocal='TestPersonAcc', PersonEmail='testpa@emailbaseut.com', country__c='United States', Type='Customer');
    insert a;
  
    System.assertEquals(0,[Select id from Email__c where email__c like '%emailbaseut.com'].size());

  }
  */
  
 static testMethod void test1() {  
    delete [Select id from Email__c where email__c like '%emailbaseut.com'];

    System.assertEquals(0,[Select id from Email__c where email__c like '%emailbaseut.com'].size());
    Lead l = new Lead(lastname='tester', company='acme', email='test1@emailbaseut.com');
    insert l;

    Account a =new Account(name='TestCo', country__c='United States', Type='Customer');
    insert a;
        
    Contact c =new Contact(accountid=a.id, lastname='TestCo: ', email='test1@emailbaseut.com');
    insert c;  
    
    //Check both lead and contact are referenced, totaled and connected to correct global email.
    LIST<Email__c> em = [Select id, TotalLeads__c, TotalContacts__c, Contact__c, Lead__c from Email__c where email__c='test1@emailbaseut.com'];
 //PKH   System.assertEquals(1, em.size());   
 //PKH   System.assertEquals(em[0].id,[Select globalEmail__c from Lead where id=:l.id].globalEmail__c);
 //PKH   System.assertEquals(1, em[0].TotalLeads__c);
 //PKH   System.assertEquals(em[0].id,[Select globalEmail__c from Contact where id=:c.id].globalEmail__c);
 //PKH   System.assertEquals(1, em[0].TotalContacts__c);
 //PKH   System.assertEquals(l.id, em[0].Lead__c);
 //PKH   System.assertEquals(c.id, em[0].Contact__c);
    
    ContactHandler.InProcess = false;
    c.email='test2@emailbaseut.com';
    update c;
    
    
    //Since the Contact changed email...
    //Check that new Email__c only the reflects the contact and is referenced, totaled and connected.
    LIST<Email__c> em2 = [Select id, TotalLeads__c, TotalContacts__c, Contact__c from Email__c where email__c='test2@emailbaseut.com'];
//PKH    System.assertEquals(1, em2.size());
//PKH    System.assertEquals(0, em2[0].TotalLeads__c);
    LIST<Contact> testC = [Select globalEmail__c from Contact where id=:c.id];
//PKH    System.assertEquals(em2[0].id,testC[0].globalEmail__c);
//PKH    System.assertEquals(c.id,em2[0].Contact__c);
//PKH    System.assertEquals(1, em2[0].TotalContacts__c);    

    //Also, Since the Contact changed email...
    //Check previous Email__c record only reflects the lead and NOT the contact
    em.clear();
    em = [Select id, TotalLeads__c, TotalContacts__c, Contact__c, Lead__c from Email__c where email__c='test1@emailbaseut.com'];
//PKH    System.assertEquals(1, em.size());
//PKH    System.assertEquals(em[0].id,[Select globalEmail__c from Lead where id=:l.id].globalEmail__c);
//PKH    System.assertEquals(1, em[0].TotalLeads__c);
//PKH    System.assertNotEquals(em[0].id,[Select globalEmail__c from Contact where id=:c.id].globalEmail__c);
//PKH    System.assertEquals(0, em[0].TotalContacts__c);
//PKH    System.assertEquals(l.id, em[0].Lead__c);
//PKH    System.assertEquals(null, em[0].Contact__c);
    
    Test.startTest();
    //[PriyaK30022017] commented batch class execution and excuting scheduled class
    //Database.executeBatch(new batchEmailRefresh(),200);
    String sch = '0 0 0 15 3 ? 2022';
    system.schedule('Test Email refresh batch schedule', sch, new SchedBatchEmailRefresh()); 
    //[PriyaL30022017] End
    Test.stopTest();
  }


  static testMethod void test_SpecialLogic() {  
    delete [Select id from Email__c where email__c like '%emailbaseUT.com'];
    Account a =new Account(name='TestCo', country__c='United States', Type='Competitor');
    insert a;
    Contact c =new Contact(accountid=a.id, lastname='TestCo: ', email='test1@emailbaseUT.com');
    insert c;  
    
    LIST<Email__c> em = [Select id, TotalLeads__c, TotalContacts__c from Email__c where email__c='test1@emailbaseUT.com'];
    System.assertEquals(0, em.size());
    
        
    Lead l = new Lead(lastname='tester', company='acme', email='testev@emailbaseut.com', Origin_Channel_Type__c='Event');
    insert l;
    
    Account a2 =new Account(name='TestCo', country__c='United States', Account_Sub_Type__c='Sales Agency');
    insert a2;
    Contact c2 =new Contact(accountid=a2.id, lastname='TestCo: ', email='sa@emailbaseUT.com');
    insert c2;
    

  }

  static testMethod void test_Bounce() {  
    delete [Select id from Email__c where email__c like '%emailbaseUT.com'];

    LIST<Email__c> em = [Select id, TotalLeads__c, TotalContacts__c from Email__c where email__c='bounce@emailbaseUT.com'];
//PKH    System.assertEquals(0, em.size());
    Email__c email= new Email__c(email__c='bounce@emailbaseUT.com', CurrencyIsoCode='USD');
        insert email;
        system.debug('*****************'+email);
        Lead l = new Lead(bounced__c = false, lastname='tester', company='acme', email=email.email__c, Origin_Channel_Type__c='Event');
        insert l;
        LIST<Email__c> em1 = new LIST<Email__c>();
        em1 =[Select id, TotalLeads__c, email__c, TotalContacts__c, bounced__c from Email__c where id=: email.id];
        
//PKH    System.assertEquals(1, em1.size());    
    Test.startTest();
    system.debug ('////12234');
    EmailHandler.InProcess=false;
    em1[0].Bounced__c=true;
    update em1[0];

    boolean bounce = [Select Bounced__c from Lead where id=:l.id].Bounced__c;
    //System.assertEquals(true, bounce);    
    Test.stopTest();
    
  }


}
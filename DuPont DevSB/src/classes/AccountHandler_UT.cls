/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit test for AccountHandler
********************************************************************************/
@isTest(seealldata=false)
private class AccountHandler_UT {

    static testMethod void testAccountGeoValidation() {
    geoValidation.validateInTestMode=true;
    
    //KT: create GeneralSettings__c
    GeneralSettings__c gs = new GeneralSettings__c(
        SetupOwnerId = UserInfo.getOrganizationId(),
        Green_Threshold__c = 15,
        NH_Innovation_Dashboard_Admin_EPass__c = 'AW1234',
        NH_Sales_Dashboard_Admin_EPass__c = 'AW1234',
        NH_SAFI_Dashboard_Admin_User__c = 'Thomas Ahlinder',
        Pod__c = 'na35',
        TSR_Global_Average_Rate__c = 120.20,
        Yellow_Threshold__c = 30
    );
    insert gs;
         
    Account[] accs = new List<Account> { 
        new Account(name='testacc',BillingCountry='IT', BillingState='del Veneto'),
        new Account(name='testacc',Country__c='IT'),
        new Account(name='testacc',Country__c='IT', ShippingState='Umbria'),
        new Account(name='testacc',Country__c='IT', BillingState='Trentino-Alto Adige'),
        new Account(name='testacc',ShippingCountry='IT', ShippingState='Tuscany'),
        new Account(name='testacc',ShippingCountry='IT'),
        new Account(name='testacc',BillingCountry='US', BillingState='DE',ShippingCountry='IT', ShippingState='Puglia'),
        new Account(name='testacc',BillingCountry='CA', BillingState='British Columbia',ShippingCountry='CA', ShippingState='British Columbia')

        };
    try {
        Database.insert(accs,false);
    } catch(Exception ex){
        Boolean expectedExceptionThrown =  ex.getMessage().contains('country') ? true : false;
        System.AssertEquals(expectedExceptionThrown, true);
    }

   Account del =new Account();
   del.name='name1';
   del.Country__c='IT';
    // del.recordtypeId=Account_COB_RTYPE ;
   //  del.Do_Not_Delete__c = true;
    
    try {
        insert del;
        delete del;  
    } catch(Exception ex){
        Boolean expectedExceptionThrown =  ex.getMessage().contains('country') ? true : false;
        System.AssertEquals(expectedExceptionThrown, true);
    }
        
        try { 
            AccountHandler.hasTriggerExecuted = false; 
            insert new Account(name='testacc'); 
        }catch (exception e) {}
        try { 
            AccountHandler.hasTriggerExecuted = false; 
            insert new Account(name='testacc', ShippingCountry='XXXXXX'); 
        }catch (exception e) {}
    

    SET<Id> ids = new SET<Id>();
    for ( Account a : accs ) 
        ids.add(a.id);
        
    for ( Account a : [Select country__c from Account where id in:ids]) {
        system.debug('---NEW COUNTRY--->'+a.country__c);
        }
    }


    static testMethod void test_CompanyMailingAddress() {
        
        Id accRtId = Rtype.getIdByDevName('Account', 'ERP_Account');
        Id conRtId = Rtype.getIdByDevName('Contact', 'OneDuPont');
        string fname='Account.AGCP_CPC_LA_Moderate_Person';
        RecordTypeSettings__c rts;
        RecordTypeSettings__c[] rtss = [Select Id from RecordTypeSettings__c where fullname__c=:fname LIMIT 1] ;
        if (rtss.size()==0) {
            rts = new RecordTypeSettings__c(name='TEST');
            rts.fullname__c=fname;
            rts.CompanyMailingAddress__c='ship=0&rtype='+conRtId;
            insert rts;
            }
        else {
            rts=rtss[0];
            rts.CompanyMailingAddress__c='ship=0&rtype='+conRtId;
            update rts;
        }
        
        Account acc = new Account(name='ACME', Country__c='United States', BillingState='DE', ShippingState='MD', recordTypeId=accRtId);
        insert acc;
        
        //Contact cms = [Select Id, MailingState FROM Contact where accountId=:acc.id];
        //system.assertEquals('DE',cms.MailingState);
        
        //now change the recordTypeSetting__c to use shipping.
        rts.CompanyMailingAddress__c='ship=1&rtype='+conRtId;
        update rts;
        
        
        //this should do nothing as an existing Company Mailing address is already created.
        AccountHandler.hasTriggerExecuted = false;  
        update acc;
        Contact[] cons = [Select Id, MailingState FROM Contact where accountId=:acc.id];
        //system.assertEquals(cons.size(), 1);    
        //system.assertEquals('DE',cons[0].MailingState);     
        
        //this should now add a new Company Mailing address reflecting the Shipping
        AccountHandler.hasTriggerExecuted = false;  
        TriggerHandlerBase.cacheAllRTypes.clear(); //stop the caching of the recordType settings for UT
        delete cons;
        update acc;
        cons = [Select Id, MailingState FROM Contact where accountId=:acc.id];
        //system.assertEquals(cons.size(), 1);    
        //system.assertEquals('MD',cons[0].MailingState); 

    }
    
}
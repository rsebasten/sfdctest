@isTest(SeeAllData=True)
private class lookupFieldTest_UT{

 static testMethod void lookupFieldTestMeth(){
 Test.startTest();
 
 Account acc = new Account(name='TestCo: ', country__c='United States'); 
    insert acc;
    UtilRT.RT rt = UtilRT.getRT('Opportunity', 'DPT_AP');
        Opportunity opp = new Opportunity (RecordTypeId=rt.Id, account = acc, name='test', stagename='target', closeDate=Date.Today(), CurrencyIsoCode='USD');
    insert opp;
        opportunity_products__c oprod = new opportunity_products__c(opportunity__c=opp.Id);
        
           insert oprod;
        system.currentPageReference().getParameters().put('Id',null);
        
        ApexPAges.StandardController sc = new ApexPages.StandardController(oprod);
         lookupFieldTest lp =  new lookupFieldTest(sc);
         lp.getlookupFieldTest();
       Test.stopTest();
        
       
 }
 }
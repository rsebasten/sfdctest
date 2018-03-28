/*******************************************************************************
Author: Martin Ryder
Email: martin.ryder@doextra.com
Description:  DPP Deep clone test class
//<MR20160614> remove generated schedules before cloning old ones
//********************************************************************************/
@isTest
public class ctrlOpportunityDeepClone_UT {
    static testMethod void test_ctrlOpportunityDeepClone() {
        Account a = new account (name='Test', ShippingCountry='US');
        insert a;
        //Opportunity o = new opportunity (AccountId=a.id, name='Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty', stagename='Prospect', closeDate=Date.today(), Amount=1, Estimated_Max_Effort_hours__c=20, Type='Defense',Contract_Duration__c=2);
        Opportunity o = new opportunity (AccountId=a.id, name='Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty Onehundredandtwenty', stagename='Prospect', closeDate=Date.today(), Amount=1, Type='Defense',Contract_Duration__c=2);
        insert o;
        
        OpportunityTeamMember OTM = new OpportunityTeamMember(OpportunityId=o.Id, UserId=userinfo.getuserId(), TeamMemberRole='Finance');
        insert OTM;
        
        Opportunity_Company__c newOC = new Opportunity_Company__c(Opportunity__c=o.Id, Company__c =a.Id);
        insert newOC;
        
        Product2 prod2 = new Product2(name='prod2', description='here is a long short', CanUseRevenueSchedule=true, CanUseQuantitySchedule=true, IsActive=true);        
        insert prod2;
        Opportunity_Products__c newOP = new Opportunity_Products__c (Opportunity__c=o.Id, ProductOfOpportunity__c =prod2.id, Quantity__c=1, Sales_Price__c=1);
        insert newOP;
        
        id pb = Test.getStandardPricebookId();
        pricebookentry pbe = new PricebookEntry( Pricebook2Id = pb, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true);
        insert pbe;
        OpportunityLineitem oli = new opportunityLineItem(opportunityId=o.Id, pricebookentryId=pbe.Id, quantity=2, TotalPrice=34);
        insert oli;
        //Krish: added startTest to avoid too many soql queries error
        Test.startTest();
        //<MR20160614> remove generated schedules before cloning old ones.
        system.debug('After Items');
        QuantitySchedulingController.oppDuration=5;
        list<opportunitylineitemschedule> testolis = [select id, quantity, ScheduleDate  from opportunitylineitemschedule where OpportunityLineItemId=:oli.id];
        system.debug(JSON.serializePretty(testolis));        
        opportunitylineitemschedule olis = new opportunitylineitemschedule(opportunitylineitemId=oli.Id, scheduledate=date.today(),quantity=1, type='Quantity');
        insert olis;

        //<MR20160614> remove generated schedules before cloning old ones.
        system.debug('After Items schedule');
        testolis = [select id, quantity, ScheduleDate  from opportunitylineitemschedule where OpportunityLineItemId=:oli.id];
        system.debug(JSON.serializePretty(testolis));

        PageReference pageRef = Page.OpportunityDeepClone;
        Test.setCurrentPage(pageRef);   
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        ctrlOpportunityDeepClone dc = new ctrlOpportunityDeepClone(sc);
        dc.deepclone();

        //<MR20160614> remove generated schedules before cloning old ones.
        system.debug('After Deep Clone');
        testolis = [select id, quantity, ScheduleDate  from opportunitylineitemschedule where OpportunityLineItemId=:oli.id];
        system.debug(JSON.serializePretty(testolis));

        
        o.name='Clone test';
        update o;
        
        sc = new ApexPages.StandardController(o);
        dc = new ctrlOpportunityDeepClone(sc);
        dc.deepclone();
        
        o.name='Clone(1) test';
        update o;
        //Krish: added startTest to avoid too many soql queries error
        Test.stopTest();
        sc = new ApexPages.StandardController(o);
        dc = new ctrlOpportunityDeepClone(sc);
        dc.deepclone();
        
        
        

    }


}
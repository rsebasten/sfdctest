/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit tests for trigLeadOnConvert

TES20120319 - UT for trigLeadOnConvert
********************************************************************************/
@isTest
private class LeadOnConvert_UT {

    static testMethod void test_LeadOnConvert() {
        Lead l = new Lead(lastname='testLead', company='test Company',Lead_Country__c='India',Region__c='Asia Pacific',Origin_Name__c='Brasil 800');
        insert l;
        Request__c r = new Request__c(Lead__c =l.Id, Status__c='Not Started');
        insert r;   
        SFDC_Script_Header__c sh = new SFDC_Script_Header__c(Lead__c =l.Id);
        insert sh;          
        //Future_Business_Development__c fbd = new Future_Business_Development__c(Related_Lead__c=l.Id);
        Future_Business_Development__c fbd = new Future_Business_Development__c();
        insert fbd;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(L.Id);
        lc.setConvertedStatus('End'); 
        lc.setDoNotCreateOpportunity(false);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.Assert(lcr.isSuccess());
        Lead convLead = [Select convertedContactId,convertedOpportunityId from Lead where Id=:l.id];
        System.AssertEquals([
            Select Contact__c from Request__c where Id=:r.id].Contact__c,
            convLead.convertedContactId);
        
        System.AssertEquals([
            Select Contact__c from SFDC_Script_Header__c where Id=:sh.id].Contact__c,
            convLead.convertedContactId);
        
        /*System.AssertEquals([
            Select Related_Opportunity__c from Future_Business_Development__c 
            where Id=:fbd.id].Related_Opportunity__c,convLead.convertedOpportunityId
            ); */
    }
    
}
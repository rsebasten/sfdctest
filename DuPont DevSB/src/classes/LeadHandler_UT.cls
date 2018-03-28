@isTest
private class LeadHandler_UT {
    static testMethod void leadTestMethod() {
        List<Lead> objLeadList = new List<Lead>();
        Campaign objCampaign = new Campaign(Name='Test');
        Insert objCampaign;
        objCampaign.Origin_Tracking_Code__c =objCampaign.Id;
        Update objCampaign;
        for(Integer i=0;i<25;i++){
            Lead objLead = new Lead(lastname='Test', Origin_Tracking_Code__c=objCampaign.Id, Company='Test Company');
            objLeadList.add(objLead);
        }
        Insert objLeadList;
    }
}
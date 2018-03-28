@isTest(seeAllData=true)
private class trigLeadGeoValidation_UT{

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
        
        Update([select Id from Lead where Id =:objLeadList[0].Id]);
    }
    static testMethod void leadTestMethod2() {
        List<Lead> objLeadList = new List<Lead>();
        Campaign objCampaign = new Campaign(Name='Test');
        Insert objCampaign;
        objCampaign.Origin_Tracking_Code__c =objCampaign.Id;
        Update objCampaign;
        for(Integer i=0;i<25;i++){
            Lead objLead = new Lead(lastname='Test', Origin_Tracking_Code__c=objCampaign.Id, Company='Test Company', Lead_Country__c ='USA',StateName__c = 'New York');
            objLeadList.add(objLead);
        }
        geoValidation gvld = new geoValidation();
        geoValidation.validateInTestMode = true;
        geoValidation.GeoValidationDisabled();
        Insert objLeadList;
        geoValidation gvld2 = new geoValidation();
        geoValidation.validateInTestMode = true;
        geoValidation.GeoValidationDisabled();
        Update([select Id from Lead where Id =:objLeadList[0].Id]);
    }
    
}
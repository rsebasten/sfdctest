@isTest
private class ctrlOppCompanyMassAdd_UT {
    public static testMethod void testOppCompanyMassAdd() {
        //[05102017] Merge&Spin: Added custom setting data to avoid test failure
        RecordTypeSettings__c RTSetting = new RecordTypeSettings__c();
        RTSetting.Name = 'Opportunity.DPT_AP';
        RTSetting.FullName__c = 'Opportunity_Company__c.DPP_Polymers';
        RTSetting.OppCompanyRole__c = 'abc&def';
        insert RTSetting;
        GeoValidation.DisableGeoValidationOverride=true;
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
        Opportunity opp = new Opportunity (account = acc, name='test', stagename='won', closedate=Date.TODAY(), recordTypeId = RType.getIdByDevName('Opportunity', 'DPT_AP') );
        insert opp;
        Test.startTest();
        PageReference pageRef = Page.OppCompanyMassAdd;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', opp.id);        
        ctrlOppCompanyMassAdd ctrl = new ctrlOppCompanyMassAdd();
        ctrl.getPickValues();
       //Will err
        ctrl.newRecords[0].Company__c=acc.id;
        ctrl.save();
        
        //Will not err
        ctrl.newRecords[0].Company_Role__c = 'OEM';
        ctrl.save();
        Test.stopTest();
    }  


}
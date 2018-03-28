@isTest
private class ctrlOrgCompare_UT {
    
    static testMethod void testOrgCompare() {

        Test.startTest();
        PageReference pageRef = Page.OrgCompare;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('debug', '1');  
        ctrlOrgCompare ctrl = new ctrlOrgCompare();
        ctrl.un='user';
        ctrl.pw='pw';
        ctrl.isSandbox=false;
        ctrl.Login();
        ctrl.Compare();
        ctrl.CompareWF();
   //[20170112] Merge&Spin: Added if condition to check  list size for greater than Zero     
        if(ctrl.compare.getResults().size()>0){
           ctrl.compare.getResults()[0].b.fullname='foo'; 
        }
        for (ctrlOrgCompare.FilePropCompareResult r : ctrl.compare.getResults()) {
            system.debug(r.getMatchType());
            system.debug(r.getName());
            system.debug(r.getType());
        }
        system.debug(ctrl.compare.getDiff());
        ctrl.compare.getBlocks();
        ctrl.BackToCustomObject();
        ctrl.getMetadataTypes();
        ctrl.getSObjectChildTypes();
        system.debug(ctrl.parentType);
        system.debug(ctrl.compare.total);
        system.debug(ctrl.compare.totalDiffs);
        ctrl.LogoutB();
        Test.stopTest();
    }  
    
}
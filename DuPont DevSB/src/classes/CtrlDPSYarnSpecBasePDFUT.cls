/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Tabrez Ansari
Email: tabrez.ansari@tcs.com
Description:  This class is used for unit testing of the ctrlDPSYarnSpecBasePDF controller.
Created Date: 9/27/2016
Version: 1.0
1.1		04-Jan-2017		Krishna Kamineni   		User is assigned with system value at line 22
********************************************************************************/

@isTest
private class CtrlDPSYarnSpecBasePDFUT{
    static testMethod void createSearchCriteriaTest(){
        
        
        utilKevlarTestData util = new utilKevlarTestData();
        
        User u = util.createPortalUser();
        try{
            insert u;
        }catch(Exception e){
            u=[SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        }
        DPSKevlarCustomSetting__c dps = util.createCustomSetting();
        insert dps;
        
        List<Yarn_Specification__c> yarnspec = util.createYarnSpecification();
        insert yarnspec;
        System.assertEquals(50,yarnspec.size());
        
        System.runAs(u){
            List<Search_Criteria__c> listSrchCrit = util.createSearchCriteria();
            insert listSrchCrit;
            System.assertEquals(50,listSrchCrit.size());        
        
            Test.startTest();
            Apexpages.StandardController StdController = new Apexpages.StandardController(listSrchCrit[0]);
            ApexPages.currentPage().getParameters().put('Id', listSrchCrit[0].Id);
            ctrlDPSYarnSpecBasePDF objctrlDPSYarnSpecBasePDF = new ctrlDPSYarnSpecBasePDF(StdController);
            
            System.debug('****'+ApexPages.currentPage().getParameters().put('id', listSrchCrit[0].Id));
            Test.stopTest();
        }
    }
}
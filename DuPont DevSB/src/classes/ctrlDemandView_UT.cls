/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com

Description: Test class to for controller class Demand View.

**********************************************************************************/

@isTest
public class ctrlDemandView_UT{
    
    
    static testMethod void test_ctrlDemandView() {
        
        Demand__c d = new Demand__c(name='test demand', duration__c=6, fieldset__c='Quantity', 
                                    postfieldset__c='QuantitywithActualQuantity', offset__c=-1, type__c='Production', information__c='both');
        insert d;
        DemandItem__c di1 = new DemandItem__c(name='Item 1', Group__c='Group A', Demand__c=d.id);
        DemandItem__c di2 = new DemandItem__c(name='Item 2', Group__c='Group A', Demand__c=d.id);
        DemandItem__c di3 = new DemandItem__c(name='Item 3', Group__c='Group A', Demand__c=d.id);
        DemandItem__c di4 = new DemandItem__c(name='Item 4', Group__c='Group B', Demand__c=d.id);
        DemandItem__c di5 = new DemandItem__c(name='Item 5', Group__c='Group B', Demand__c=d.id);
        insert new LIST<DemandItem__c> {di1,di2,di3,di4,di5};
            
            
            Test.startTest();
        PageReference pageRef = Page.DemandView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', d.id);
        
        ctrlDemandView ctrl = new ctrlDemandView();
        
        
        ctrl.ds.getGroups()[0].items[0].getSchedules()[0].quantity=2;
        
        ctrl.quicksave();
        ctrl.refresh();
        ctrl.save();
        
        ctrl = new ctrlDemandView();
        
        ctrl.cancel();
        ApexPages.currentPage().getParameters().put('retURL', '/'+d.id);  
        ctrlDemandView ctrl1 = new ctrlDemandView();
        
        
        ctrl1.ds.getGroups()[0].items[0].getSchedules()[0].quantity=2;
        
        ctrl1.quicksave();
        ctrl1.refresh();
        ctrl1.save();
        
        ctrl1 = new ctrlDemandView();
        
        ctrl1.cancel();        
        Test.stopTest();
    }  
}
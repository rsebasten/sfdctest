@isTest
private class ctrlDataAnalysis_UT {


  static testMethod void test1() {

        PageReference pageRef = Page.DataAnalysis;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('fname', 'Account.Type');      
        ApexPages.currentPage().getParameters().put('lim', '10');  
        ApexPages.currentPage().getParameters().put('gtype', 'recordtype');    
        ctrlDataAnalysis ctrl = new ctrlDataAnalysis();
        ctrl.analyze();  
        ctrl.getPieData();
        
        for (DataAnalysis.Record r : ctrl.results) {
            system.debug(r.fields);
        }
        ctrl.gtype='program';
        ctrl.analyze();
        
        
        ctrl.sobjectType='Account_Material__c'; 
        ctrl.sObjectType_onChange();
        ctrl.field='Product_Name__c';
        ctrl.gtype=null;
        ctrl.analyze();
        ctrl.gtype='program';
        ctrl.groupByFilter='%abc%';
        ctrl.analyze();
        ctrl.gtype='recordtype';
        ctrl.analyze();
        ctrl.customAnalyze();

    }  
    
}
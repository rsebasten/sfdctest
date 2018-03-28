/**
*
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.0
*
* Copyright © 2012 DuPont. All rights reserved. 
* Unit Test(s) for ctrlReasonWizard.cls
*/
 //[02152017] Merge&Spin: removed SeeAllData = true 
@istest
private class ctrlReasonWizard_UT {
    
   static testMethod void testReasonWizard() {
        //Add Opp
        GeoValidation.DisableGeoValidationOverride=true;
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
       Id recordTypeIdOpp= [select id, name from recordtype where name='BI Case' limit 1].id;
        Case cas = new Case (account = acc );
        insert cas;
        
        Reason__c r = new Reason__c(name='root');
        insert r;
        Reason__c l1 = new Reason__c(name='level 1', parent__c=r.id);
        insert l1;
        Reason__c l2a = new Reason__c(name='level 2a', parent__c=l1.id);
        Reason__c l2b = new Reason__c(name='level 2b', parent__c=l1.id);
        insert new Reason__c[]{l2a,l2b};
        
        Test.startTest();
        
        PageReference pageRef = Page.ReasonWizard;
        Test.setCurrentPage(pageRef);
        ctrlReasonWizard ctrl = new ctrlReasonWizard();
       ctrl.init();
       ApexPages.currentPage().getParameters().put('rtype',recordTypeIdOpp );  
       ctrl.init();
       ApexPages.currentPage().getParameters().put('rtype','temp' );  
       ctrl.init();
        
       ApexPages.currentPage().getParameters().put('scope', l1.id);  
        ApexPages.currentPage().getParameters().put('ancor', cas.id);            
       ctrl.init();
       ctrl.refresh();
       
        ctrl.event='click';
        ctrl.eventItem=l2a.id;
        ctrl.onEvent();
        
        ctrl.event='dblclick';
        ctrl.eventItem=l2a.id;
        ctrl.onEvent();   
            
       //system.debug(ctrl.SelectedObject);
       system.debug(ctrl.rootNode.getJSON());
       ctrl.Add();
       
        //test the tree view controller
       ctrlTreeView tv = new ctrlTreeView();
       tv.top=ctrl.rootNode;
       system.debug(tv.NodeAsLI);

           ctrl.errMsg='test';
       ctrl.id='test';
   
    
       Test.stopTest();
    }   
     static testMethod void testReasonWizard1() {
        //Add Opp
        GeoValidation.DisableGeoValidationOverride=true; 
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
          Id recordTypeIdOpp= [select id, name from recordtype where name='BI Case' limit 1].id;
        Case cas = new Case (account = acc );
        insert cas;
        
        Reason__c r = new Reason__c(name='root');
        insert r;
        Reason__c l1 = new Reason__c(name='level 1', parent__c=r.id);
        insert l1;
        Reason__c l2a = new Reason__c(name='level 2a', parent__c=l1.id);
        Reason__c l2b = new Reason__c(name='level 2b', parent__c=l1.id);
        insert new Reason__c[]{l2a,l2b};
        
        Test.startTest();
        
        PageReference pageRef = Page.ReasonWizard;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('scope', null);
        ApexPages.currentPage().getParameters().put('ancor', cas.id); 
         
        ApexPages.currentPage().getParameters().put('rtype', null);            
        ctrlReasonWizard ctrl = new ctrlReasonWizard();
       ctrl.init();
       ctrl.refresh();
       
        ctrl.event='click';
        ctrl.eventItem=l2a.id;
        ctrl.onEvent();
        
        ctrl.event='dblclick';
        ctrl.eventItem=l2a.id;
        ctrl.onEvent();   
            
       //system.debug(ctrl.SelectedObject);
       system.debug(ctrl.rootNode.getJSON());
       ctrl.Add();
       
        //test the tree view controller
       ctrlTreeView tv = new ctrlTreeView();
       tv.top=ctrl.rootNode;
       system.debug(tv.NodeAsLI);

       
    
       Test.stopTest();
    }   
}
/**
*
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.0
*
* Copyright © 2010 DuPont. All rights reserved. 
*
* Unit Test(s) for ctrlSegmentationWizard.cls and Node.cls
*/
 
@istest()
private class ctrlSegmentationWizard_UT {



   static testMethod void testSegmentationWizard() {
        //Add Opp
        GeoValidation.DisableGeoValidationOverride=true;
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
      Id recordTypeIdOpp= [select id, name from recordtype where developerName='DPT_AP' limit 1].id;
        Opportunity opp = new Opportunity (account = acc, name='test', stagename='won', closedate=Date.TODAY(), recordTypeId=recordTypeIdOpp );
        insert opp;
        
        Segmentation__c r = new Segmentation__c(name='root');
        insert r;
        Segmentation__c l1 = new Segmentation__c(name='level 1', parent__c=r.id);
        insert l1;
        Segmentation__c l2a = new Segmentation__c(name='level 2a', parent__c=l1.id);
        Segmentation__c l2b = new Segmentation__c(name='level 2b', parent__c=l1.id);
        insert new Segmentation__c[]{l2a,l2b};
        RecordTypeSettings__c rts = new RecordTypeSettings__c();
        rts.name = 'Opportunity.CPMOpportunityRecord';
        rts.FullName__c = 'Opportunity.CPMOpportunityRecord';
        insert rts;
        Test.startTest();
        
        PageReference pageRef = Page.SegmentationWizard;
        Test.setCurrentPage(pageRef);
       ctrlSegmentationWizard ctrl = new ctrlSegmentationWizard();
       ctrl.init();
       ApexPages.currentPage().getParameters().put('rtype',recordTypeIdOpp );  
       ctrl.init();
       ApexPages.currentPage().getParameters().put('rtype','temp' );  
       ctrl.init();
        
       ApexPages.currentPage().getParameters().put('scope', l1.id);  
        ApexPages.currentPage().getParameters().put('ancor', opp.id);            
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

        //INode/NodeBase Coverage
        INode n=ctrl.rootNode;
       
       ctrl.errMsg='test';
       ctrl.id='test';
    
       Test.stopTest();
    }   
    static testMethod void testSegmentationWizard1() {
        //Add Opp
        GeoValidation.DisableGeoValidationOverride=true;
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
        Opportunity opp = new Opportunity (account = acc, name='test', stagename='won', closedate=Date.TODAY() );
        insert opp;
        
        Segmentation__c r = new Segmentation__c(name='root');
        insert r;
        Segmentation__c l1 = new Segmentation__c(name='level 1', parent__c=r.id);
        insert l1;
        Segmentation__c l2a = new Segmentation__c(name='level 2a', parent__c=l1.id);
        Segmentation__c l2b = new Segmentation__c(name='level 2b', parent__c=l1.id);
        insert new Segmentation__c[]{l2a,l2b};
        
        Test.startTest();
        
        PageReference pageRef = Page.SegmentationWizard;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('scope', null);  
        ApexPages.currentPage().getParameters().put('ancor', opp.id);  
        ApexPages.currentPage().getParameters().put('rtype', null); 
        ctrlSegmentationWizard ctrl = new ctrlSegmentationWizard();
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

        //INode/NodeBase Coverage
        INode n=ctrl.rootNode;
       
    
       Test.stopTest();
    }   


      
}
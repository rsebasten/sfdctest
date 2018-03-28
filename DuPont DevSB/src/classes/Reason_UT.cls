@isTest
private class Reason_UT {


    // TESII_20110201:
    // Coverage: 
    //  Segmentation.cls 98%
    //  trigSegmentation.trigger 100%
    //  ctrlOverrideView 100%
    static testMethod void testReason() {

        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
        
        string rtId = RTYPE.getDefault('Case').getRecordTypeId();
        string rtFullname = 'Case.'+RTYPE.getRecordTypeById(rtId).DeveloperName;
        Case cas = new Case (recordtypeid=rtId, account = acc, Subject='test', Status='New', Origin='Phone' );
        insert cas;
        
        //Insert a STD (CORP) Tree
        Reason__c Cr = new Reason__c(name='CORProot', uniqueName__c='CorpTestNeverUsethisName');
        insert Cr;
        Reason__c Cl1 = new Reason__c(name='CORP level 1', parent__c=Cr.id);
        insert Cl1;
        
        //Insert a TEST Tree
        Reason__c r = new Reason__c(name='root', uniqueName__c='TestNeverUsethisName');
        insert r;
        Reason__c l1 = new Reason__c(name='level 1', parent__c=r.id, primaryReason__c=Cl1.id);
        insert l1;
        Reason__c l2a = new Reason__c(name='level 2a', parent__c=l1.id);
        Reason__c l2b = new Reason__c(name='level 2b', parent__c=l1.id);
        insert new Reason__c[]{l2a,l2b};
        Reason__c l3a = new Reason__c(name='level 3a', parent__c=l2b.id);
        insert l3a;
        Reason__c l4a = new Reason__c(name='level 4a', parent__c=l3a.id);
        insert l4a;
        
        RecordTypeSettings__c rts=new RecordTypeSettings__c(name='requiredtest',
            ReasonRoot__c='TestNeverUsethisName',
            fullname__c=rtFullname,
            ReasonIsRequired__c=true);
        upsert rts RecordTypeSettings__c.FullName__c;
        system.debug(rts);
        
            
        //IsRequired and null so redirect to SementationWizard
        Test.setCurrentPage(Page.overrideViewCase);
        ApexPages.Standardcontroller stdCntr = new ApexPages.Standardcontroller(cas);
        ctrlOverrideView ctrl = new ctrlOverrideView(stdCntr);
        system.debug(ctrl.init());
        
        
        stdCntr = null;
        ctrl=null;
        //IsRequired and NOT null, dont redir
        cas.primaryReason__c=l2b.id;
        update cas;
        stdCntr = new ApexPages.Standardcontroller(cas);
        ctrl = new ctrlOverrideView(stdCntr);
        system.debug(ctrl.init());
        
    }   
    
}
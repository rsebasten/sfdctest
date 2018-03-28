@isTest
private class Segmentation_UT {


	// TESII_20110201:
	// Coverage: 
	//	Segmentation.cls 98%
	//	trigSegmentation.trigger 100%
	//	ctrlOverrideView 100%
	static testMethod void testSegmentation() {

		Account acc = new Account(name='TestCo: ', country__c='United States'); 
		insert acc;
		
		string rtId = RTYPE.getDefault('Opportunity').getRecordTypeId();
		string rtFullname = 'Opportunity.'+RTYPE.getRecordTypeById(rtId).DeveloperName;
		Opportunity opp = new Opportunity (recordtypeid=rtId, account = acc, name='test', stagename='won', closedate=Date.TODAY() );
		insert opp;
		
		//Insert a STD (CORP) Tree
		Segmentation__c Cr = new Segmentation__c(name='CORProot', uniqueName__c='CorpTestNeverUsethisName');
		insert Cr;
		Segmentation__c Cl1 = new Segmentation__c(name='CORP level 1', parent__c=Cr.id);
		insert Cl1;
		
		//Insert a TEST Tree
		Segmentation__c r = new Segmentation__c(name='root', uniqueName__c='TestNeverUsethisName');
		insert r;
		Segmentation__c l1 = new Segmentation__c(name='level 1', parent__c=r.id, primarySegment__c=Cl1.id);
		insert l1;
		Segmentation__c l2a = new Segmentation__c(name='level 2a', parent__c=l1.id);
		Segmentation__c l2b = new Segmentation__c(name='level 2b', parent__c=l1.id);
		insert new Segmentation__c[]{l2a,l2b};
		Segmentation__c l3a = new Segmentation__c(name='level 3a', parent__c=l2b.id);
		insert l3a;
		Segmentation__c l4a = new Segmentation__c(name='level 4a', parent__c=l3a.id);
		insert l4a;
		
		RecordTypeSettings__c rts=new RecordTypeSettings__c(name='requiredtest',
			SegmentationRoot__c='TestNeverUsethisName',
			fullname__c=rtFullname,
			SegmentIsRequired__c=true);
		upsert rts RecordTypeSettings__c.FullName__c;
		system.debug(rts);
		
				
		//IsRequired and null so redirect to SementationWizard
		Test.setCurrentPage(Page.OverrideViewOpp);
		ApexPages.Standardcontroller stdCntr = new ApexPages.Standardcontroller(opp);
		ctrlOverrideView ctrl = new ctrlOverrideView(stdCntr);
		system.debug(ctrl.init());
		
		
		stdCntr = null;
		ctrl=null;
		//IsRequired and NOT null, dont redir
		opp.primarySegment__c=l2b.id;
		update opp;
		stdCntr = new ApexPages.Standardcontroller(opp);
		ctrl = new ctrlOverrideView(stdCntr);
		system.debug(ctrl.init());
		
	}	
	
}
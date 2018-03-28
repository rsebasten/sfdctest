/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UT for Controller: ctrlMetadataDiff
********************************************************************************/
@isTest
private class ctrlMetadataDiff_UT  {

   public static testMethod void testMetadataDiff() {
		
        Test.startTest();
        Metadata__c m = new Metadata__c(Name='TEST CLASS', fullname__c='test_class.cls');
        insert m;
		Attachment att1 = new Attachment(
			Name = 'att1.cls',
			Body = Blob.valueof('test Attachment old'),
			ContentType='txt/html',
			ParentId=m.id
		);
		insert att1;
		Attachment att2 = new Attachment(
			Name = 'att2.cls',
			Body = Blob.valueof('test Attachment new'),
			ContentType='txt/html',
			ParentId=m.id
		);
		insert att2;
		Test.stopTest();
		
        PageReference pageRef = Page.MetadataDiff;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', m.id);        
        ctrlMetadataDiff ctrl = new ctrlMetadataDiff();
       
       	system.assertEquals(ctrlMetadataDiff.getFile(ctrl.file1id),'test Attachment new');
		system.assertEquals(ctrlMetadataDiff.getFile(ctrl.file2id),'test Attachment old');
		system.debug(ctrlMetadataDiff.getFiles(ctrl.file1id,ctrl.file2id));
		system.debug(ctrl.diff());
		system.debug(ctrl.versions);
    }  
	
}
/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Test(s) for : ctrlBI_Locator
[01252017] Merge&Spin: Created mock response in MockHttpResponseGeneratorutil class to increase the code coverage successfully.
********************************************************************************/
@isTest
private class ctrlBI_Locator_UT {

	static testMethod void test_ctrlBI_Locator() {
	    test.startTest();
        ctrlBI_Locator ctr=new ctrlBI_Locator();
	    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorutil());
	    ctr.clearZip();
	    ctr.showZipError();
	    ctr.clearMessages();
	    ctr.showMessage('test');
	    
	    ctr.origin_zipcode='';
	    ctr.searchByZip();
	    
	    ctr.origin_zipcode='123';
	    ctr.searchByZip();
	    
	    ctr.origin_country='';
	    ctr.searchByZip();
	    
	    ctr.origin_zipcode='H2Y 1C6';
	    ctr.origin_country='CA';       
        ctr.searchByZip();        
	    String js=ctr.getTyvekSpecialists();
	    
	    ctr.origin_country='US';
	     js=ctr.getTyvekSpecialists();
	    
	    ctr.origin_zipcode='19805';
	    ctr.findLocations();
	    
	    ctr.origin_zipcode='xxxxxxxx';
	    ctr.origin_country='US';
	    ctr.searchByZip(); 
	    
	    ctr.origin_zipcode='xxxxxxxx';
	    ctr.origin_country='CA';
	    ctr.searchByZip();  
        test.stopTest();

	}
	
}
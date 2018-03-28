/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  ERPCustomerHandler Unit Test(s)
********************************************************************************/
@isTest
private class ERPCustomerHandler_UT {

	static testMethod void test_SyncAccounts() {

   		Test.startTest();
   		
   		OrgGroup__c p1 = new OrgGroup__c(Account_Rule__c='SOLD-TO');
   		OrgGroup__c p2 = new OrgGroup__c(Account_Rule__c='SOLD-TO;SHIP-TO');
		OrgGroup__c p3 = new OrgGroup__c(Account_Rule__c=null);
		insert new OrgGroup__c[]{p1,p2,p3};
		
		ERP_Customer__c c1 = new ERP_Customer__c(name='Cust 1', Account_Group__c='SOLD-TO', OrgGroup__c=p1.id);
		ERP_Customer__c c2 = new ERP_Customer__c(name='Cust 2', Account_Group__c='SHIP-TO', OrgGroup__c=p2.id);
		ERP_Customer__c c3 = new ERP_Customer__c(name='Cust 3', Account_Group__c='SOLD-TO', OrgGroup__c=p3.id);
		insert new ERP_Customer__c[]{c1,c2,c3};
		system.debug(c1);
		//try {
			Account ac1=[Select Id, ERP_Account_Name__c from Account where ERP_Customer__c=:c1.id];
			Account ac2=[Select Id, ERP_Account_Name__c from Account where ERP_Customer__c=:c2.id];
			system.debug(ac1);
			system.assertEquals('Cust 1',ac1.ERP_Account_Name__c);
			system.assertEquals('Cust 2',ac2.ERP_Account_Name__c);
			system.assertEquals(0,[Select Id, Name from Account where ERP_Customer__c=:c3.id].size());	
		//}catch(Exception ex) {}
	
		
        Test.stopTest();
       
    }  
	
}
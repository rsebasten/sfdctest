/*******************************************************************************
Copyright © 2014 Delaware Digital Design, Inc. All rights reserved. 
Copyright © 2014 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Test(s) for : CostTrackingHandler
********************************************************************************/
@isTest(SeeAllData=true)
private class CostTrackingHandler_UT {

	static testMethod void test_CostTrackingHandler() {
       
        
	    Case case1 = new Case(subject='Unit Test', Status='New');
	    insert case1;	
	    
	    //Test SUM() on Insert
		Cost_Tracking__c ct1 = new Cost_Tracking__c(ActualCost__c=10.00, Case__c=case1.id);
		Cost_Tracking__c ct2 = new Cost_Tracking__c(ActualCost__c=20.00, Case__c=case1.id);
		insert new Cost_Tracking__c[] {ct1,ct2};
		system.assertEquals(30.00,[Select TotalActualCost__c from case where id=:case1.id].TotalActualCost__c);
	   
	   //Test SUM() on Update
		CostTrackingHandler.triggerInProgress=false;
		ct2.ActualCost__c=25.00;
		update ct2;
		system.assertEquals(35.00,[Select TotalActualCost__c from case where id=:case1.id].TotalActualCost__c); 
	   
		//Test SUM() on Delete
		CostTrackingHandler.triggerInProgress=false;
		delete ct1;
		system.assertEquals(25.00,[Select TotalActualCost__c from case where id=:case1.id].TotalActualCost__c); 
	        
		//Test SUM() on Delete
		CostTrackingHandler.triggerInProgress=false;
		undelete ct1;
		system.assertEquals(35.00,[Select TotalActualCost__c from case where id=:case1.id].TotalActualCost__c); 
	               
	}
	
}
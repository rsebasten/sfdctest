/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UnitTest for utilRT 
********************************************************************************/
@isTest
private class utilRT_UT {

	static testMethod void test_utilRT() {

			Test.startTest();
			utilRT.RT rt = utilRT.getRT('Account','TestAccount');
			system.debug(utilRT.getMap());
			if (rt!=null) {
				rt.upsertSetting(new RecordTypeSettings__c(name='utilRT_UT', fullname__c='Account.TestAccount'));
				system.assertEquals('TestAccount',rt.devName);
				system.assertEquals(utilRT.getRTById(rt.id),rt);
				system.assertEquals('utilRT_UT',rt.getSettings().Name);
			
				utilRT.clearRTCache();
				utilRT.clearSettingsCache();
				utilRT.getRTById(rt.id);
				system.debug(utilRT.getMap());
				system.debug(utilRT.getSettingsNameMap());
				system.debug(rt.getInfo());
				rt.upsertSetting(new RecordTypeSettings__c(name='utilRT_UT', fullname__c='Account.TestAccount'));
				try {
					rt.upsertSetting(new RecordTypeSettings__c(name='utilRT_UT', fullname__c='Account.THROW_MISMATCH_EXCEPTION'));
				}catch(exception ex){}
			}
			Test.stopTest();
			
	}
	
}
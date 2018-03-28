/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  VFP extension used for getting recordTypeSettings via a recordtype
********************************************************************************/
public with sharing class ctrlRecordTypeSettings {

	public RecordTypeSettings__c recordTypeSettings {get; private set;}
    
    public ctrlRecordTypeSettings(ApexPages.StandardController stdController) {
    	recordTypeSettings = new RecordTypeSettings__c();
        try {
        	recordTypeSettings = Rtype.getSettingsById((string) stdController.getRecord().get('RecordTypeId'));
        }
        catch(Exception ex){}
    }

	//TES_20110202 Coverage: ctrlRecordTypeSettings 83%
	public static testMethod void test_ctrlRecordTypeSettings() {
	
		//	string rtId = RTYPE.getDefault('Account').getRecordTypeId();
		//	string rtFullname = 'Account.'+RTYPE.getRecordTypeById(rtId).DeveloperName;
		string rtFullname = 'Account.DPT_ES';
        String rtId = RType.getIdByDevName('Account','DPT_ES');
			//Update to fix test class failure related to portal account owner
	        Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
	        UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];

	        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
	        User owner = new User();

	        System.runAs (thisUser) {
	            owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',isActive = true,username='customerservice@customerservice.com');
	            insert owner;
	           
	        }
	        
	        Account acc = new Account();
	        
	        System.runAs(owner) {

				acc = new Account(name='TestCo: ', country__c='United States', recordtypeId=rtId); 
				insert acc;
			}
			
			RecordTypeSettings__c rts=new RecordTypeSettings__c(name='test',
				SegmentationRoot__c='TestNeverUsethisName',
				fullname__c=rtFullname,
				SegmentIsRequired__c=true);
			upsert rts RecordTypeSettings__c.FullName__c;
			
			ApexPages.Standardcontroller stdCntr = new ApexPages.Standardcontroller(acc);
			ctrlRecordTypeSettings ctrl = new ctrlRecordTypeSettings(stdCntr);
			system.assertEquals(rtFullname, ctrl.recordTypeSettings.FullName__c);
	}


}
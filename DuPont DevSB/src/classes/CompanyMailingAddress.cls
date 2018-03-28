/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Creates a company mailing address off of account 
********************************************************************************/
public with sharing class CompanyMailingAddress {
	public static string COMPANY_MAILING_ADDRESS_ROLE='Company Mailing Address';
	public static RType.SobjectRTypes contactRTypes = new RType.SobjectRTypes('Contact');
	
	public static void createCompanyMailingAddress(AccountHandler h) {

		//fitler based on RecordType Setting CompanyMailingAddress__c
		SET<Id> filteredAccs = new SET<Id>();
		for (string rtName : h.recordsByRT.keySet()) {
			try {
				if (h.rtSettings.get(rtName).CompanyMailingAddress__c!=null)
					filteredAccs.addAll(h.recordsByRT.get(rtName).KeySet());
			}catch(Exception ex){}
		}
		
		
		if (filteredAccs.size()>0) {
			
			//filter out existing accounts with Company Mailing Address
			if (trigger.isUpdate) {
				MAP<id,Account> mapWithCMA= new MAP<id,Account>([Select Id FROM Account
					WHERE Id in (Select AccountId from Contact 
						where Role__c=:COMPANY_MAILING_ADDRESS_ROLE
						AND AccountId in:filteredAccs)
				]);
				filteredAccs.removeAll(mapWithCMA.keySet());
			}
			
			LIST<Contact> contactsToInsert = new LIST<Contact>();
			for (id accId : filteredAccs) {
				try {
					Account a = (Account) h.records.get(accId);
					system.debug(h.rTypeIdToSetting(a.recordtypeId));
					Contact c = createCMA(a, h.rTypeIdToSetting(a.recordtypeId).CompanyMailingAddress__c);
					if (c!=null)
						contactsToInsert.add(c);
				}catch(Exception ex){}
			}
			
			if (contactsToInsert.size()>0) {
				database.insert(contactsToInsert, false);
			}
		}
	}
	
	
	private static Contact createCMA(Account acc, string setting) {
		try {
			Contact c = new Contact();
			MAP<string,string> vars = Util.mapUrlVars(setting);
			Geography.Address accAddr = new Geography.Address(acc,Util.stringToBoolean(vars.get('ship')));   //shipping
			c.AccountId		= acc.Id;
			c.LastName 		= acc.Name;
			if(!Util.isBlank(acc.Phone)) 	c.Phone=acc.Phone;
			if(!Util.isBlank(acc.Fax))		c.Fax=acc.Fax;
			c.OwnerId		= acc.OwnerId;
			c.Role__c		= COMPANY_MAILING_ADDRESS_ROLE;

			c.recordtypeId	= vars.get('rtype');
			accAddr.writeTo(c);
			return c;
		}catch(Exception ex){}
		return null;
	}
			
}
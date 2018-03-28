/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  trigger Handler for : trigUserHistory

Caveates:
 Needed to set the API to version 12.0 otherwise returns: MIXED_DML_OPERATION, DML operation on setup 
 object is not permitted after you have updated a non-setup object (or vice versa) on changes 
 to UserRoleId

 Changes to fields that startwith: UserPermissions... or UserPreferences... are not detected
 Ragesh Vellat: 28-Apr-2014 - Added 'Address' field to exclusion list as this new compound field in Spring '14 cannot be used in Apex.
 ********************************************************************************/
public class UserHistory {

	private static boolean UserHistoryInprocess = false;
	private static SET<string> EXCLUDE_FIELDS = new  SET<string>{
		'createddate','createdbyid','lastmodifiedbyid','lastmodifieddate','systemmodstamp','address'
	};
	private static SET<string> RefIds = new SET<string>();  


	public static void User_AfterUpdate(LIST<User> oldUsers, LIST<User> newUsers) {
		if (UserHistoryInprocess) return;
		UserHistoryInprocess=true;
		LIST<UserHistory__c> userHistory = new LIST<UserHistory__c>();      //regular UserHistory
		LIST<UserHistory__c> userHistoryRef = new LIST<UserHistory__c>();   //lookup UserHistory

		//get the fieldsToAudit
		MAP<string,Schema.Describefieldresult> fieldsToAudit = new MAP<string,Schema.Describefieldresult>();
		MAP<string,Schema.SObjectField> flds = Schema.SObjectType.User.fields.getMap();
		//Changes to fields that startwith: UserPermissions... or UserPreferences... are not detected
		//so lets save some script statements and remove from fieldsToAudit
		for (string fld : flds.keySet()) {
			if (! (EXCLUDE_FIELDS.contains(fld) || fld.startswith('userpermissions') || fld.startswith('userpreferences')) ) {
				Schema.Describefieldresult dsr=flds.get(fld).getDescribe();
				fieldsToAudit.put(dsr.getname(),dsr);
			}
		}

		//loop through the batch of Users 
		for(integer i=0; i<newUsers.size(); i++ ) {         
			if (oldUsers[i]!=newUsers[i] ) {
				//loop through each fieldToAudit
				for (string f : fieldsToAudit.keySet() ) {
					string n = String.valueOf(newUsers[i].get(f));
					string o = String.valueOf(oldUsers[i].get(f));
					system.debug('COMPARE '+f+': '+n+' <-> '+o);
					if (o!=n) {
						if (fieldsToAudit.get(f).Type == Schema.DisplayType.REFERENCE) {
							RefIds.add(n);
							RefIds.add(o);
							userHistoryRef.add(new UserHistory__c(name=f,User__c=newUsers[i].Id,oldValue__c=o,newValue__c=n));
						}
						else
							userHistory.add(new UserHistory__c(name=f,User__c=newUsers[i].Id,oldValue__c=o,newValue__c=n));
					}
				} //next field
			} 
		} //next User

		//Add reference Names and Update
		if (userHistory.size()>0)
			insert userHistory;

		if (RefIds.size()>0 && userHistoryRef.size()>0) {
			addReferenceNames(userHistoryRef);
			insert userHistoryRef;
		}
	}


	private static void addReferenceNames(LIST<UserHistory__c> history) {

		//Get the Lookups
		MAP<id,Profile> profiles;
		MAP<id,UserRole> roles;
		MAP<id,User> users;
		MAP<id,Group> groups;


		profiles = new MAP<id,Profile>([
		                                Select Id, Name from Profile where id in: RefIds
		                                ]);
		roles = new MAP<id,UserRole>([
		                              Select Id, Name from UserRole where id in: RefIds
		                              ]);
		groups = new MAP<id,Group>([
		                            Select Id, Name from Group where id in: RefIds
		                            ]);     
		users = new MAP<id,User>([
		                          Select Id, Name from User where id in: RefIds
		                          ]);     


		//Add the Names
		for ( UserHistory__c h : history ) {
			try {
				if (h.name=='ProfileId') {
					h.NewName__c= (profiles.containsKey(h.NewValue__c)) ? profiles.get(h.NewValue__c).name : null;
					h.OldName__c= (profiles.containsKey(h.OldValue__c)) ? profiles.get(h.OldValue__c).name : null;
				}
				else if (h.name=='UserRoleId'){
					h.NewName__c=(roles.containsKey(h.NewValue__c)) ? roles.get(h.NewValue__c).name : null;
					h.OldName__c=(roles.containsKey(h.OldValue__c)) ? roles.get(h.OldValue__c).name : null;
				}
				else if ( (h.NewValue__c != null && h.NewValue__c.startswith('005') && h.NewValue__c.length()==18) ||
						(h.OldValue__c != null && h.OldValue__c.startswith('005') && h.OldValue__c.length()==18) ) {
					h.NewName__c=(users.containsKey(h.NewValue__c)) ? users.get(h.NewValue__c).name : null;
					h.OldName__c=(users.containsKey(h.OldValue__c)) ? users.get(h.OldValue__c).name : null;
				}
				else if ( (h.NewValue__c != null && h.NewValue__c.startswith('00G') && h.NewValue__c.length()==18) ||
						(h.OldValue__c != null && h.OldValue__c.startswith('00G') && h.OldValue__c.length()==18) ) {
					h.NewName__c=(groups.containsKey(h.NewValue__c)) ? groups.get(h.NewValue__c).name : null;
					h.OldName__c=(groups.containsKey(h.OldValue__c)) ? groups.get(h.OldValue__c).name : null;
				}
			}
			catch(Exception ex) {}
		}
	}


	//User records cannot have reference fields other the hierarchial,  there for
	//its pretty easy to get the names 
	public static void User_AfterInsert(LIST<User> newUsers) {
		if (UserHistoryInprocess) return;
		LIST<UserHistory__c> userHistory = new LIST<UserHistory__c>();
		for(integer i=0; i<Trigger.size; i++ ) {    
			if (Trigger.isInsert) { 
				system.debug('Create: '+newUsers[i].name);
				userHistory.add(new UserHistory__c(
						name='created',
						User__c=newUsers[i].Id
						));
			}
		}
		insert userHistory;
	}   
}
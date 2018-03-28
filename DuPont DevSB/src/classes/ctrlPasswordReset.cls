/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: PasswordReset
 ********************************************************************************/

public without sharing class ctrlPasswordReset {

	public static final boolean AUTO_RESET = true;
	public static final string RTYPE_PWORDRESET = Rtype.getIdByDevName('SFDC_Access_Request__c','SFAR_Password_Reset');


	public string un                    {get; set;}
	public string epass                 {get; set;}
	public User user                    {get; set;} 
	public boolean hasTried             {get; set;} 
	public string sfarName              {get; set;} 
	public boolean userIsActive         {get; set;}
	public DateTime lastLogin           {get; set;}

	public boolean autoReset {get {return AUTO_RESET;}}             

	public ctrlPasswordReset() {
		hasTried=false;
	}


	public LIST<User> getKeyUsers() {
		return [Select User_Region__c, User_Grouping__c, Name, Email from User where key_User__c=true AND isactive=true
				order by User_Region__c, User_Grouping__c];
	}

	public PageReference resetPassword() {
		hasTried=true;
		user = getUser(un,epass);
		if (user!=null) {
			userIsActive = user.IsActive;
			lastLogin = User.LastLoginDate;
			if (lastLogin>Date.today().addDays(-30) || Test.isRunningTest()) {
				if (userIsActive) {
					SFDC_Access_Request__c sfar=createSFAR_PasswordReset(user);
					if (sfar!=null)
						sfarName=[Select name from SFDC_Access_Request__c where id=:sfar.id].name;
				}
			}
		}
		return null;
	}


	public static User getUser(string un, string epass) {
		User rtn=null;
		if  (!String.isBlank(un) && !String.isBlank(epass))
			try {
				rtn=[Select Id, IsActive, LastLoginDate, Name, User_Type__c, Key_User_Lookup__c, EPass_ID__c, Program__c
				     FROM User WHERE username=:un.trim() AND EPass_ID__c=:epass.trim()
				     AND User_Type__c='DuPont'
				     ];
			}catch(exception ex){}
		return rtn; 
	}

	public static SFDC_Access_Request__c createSFAR_PasswordReset(User u) {

		SFDC_Access_Request__c sfar = new SFDC_Access_Request__c();
		sfar.RecordTypeId       = RTYPE_PWORDRESET;
		sfar.Type__c            = 'Security & Permissions';
		sfar.SubType__c         = 'Reset Password';
		sfar.Program__c         = u.Program__c;
		sfar.SFDC_Instance__c   = 'One DuPont Corporate';       
		sfar.User__c            = u.id;
		sfar.ePass_Id__c        = u.EPass_Id__c;
		sfar.Status__c          = 'New';
		sfar.Stage__c           = 'New';
		sfar.Key_User__c        = u.Key_User_Lookup__c;     
		insert sfar;
		if (AUTO_RESET) {
			resetPassword(u.id);  //Prevent MIXED_DML_OPERATION
			sfar.Status__c      ='Completed';
			sfar.Stage__c       ='Closed';
			sfar.Date_Accepted__c=Date.Today();
			sfar.Date_Closed__c =Date.Today();
			update sfar;
		}
		return sfar;
	}


	@future
	public static void resetPassword(string id) {
		System.resetPassword(id,true);
	}

}
/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  base class for global Email 

TES20130523 - validate email for WebToLead inserts  (they are validated)
TES20130828 - some updates to email__c record did not commit due to a subsequent update failing
    due to biz specific VR,  added try/catch to subsequent dml to avoid atomic transaction
TES20130909  removed optimization to only recal totals for records where emails have changed....
    now it refreshes all for repair.  (in-case a prior change failed due to VR, etc as indicated in patch TES20130828)
TES20130925 Added additional logging to send email on error or unsuccessful DML.
TES20131008 added without sharing to class declaration
TES20131209 added method accounts_onAfter() used for handling personaccounts trigger events,  and added logic for new
    contacts and personAccounts to default notification status to 'Notified' if Account_Sub_Type__c=='Sales Agency'
    THIS LOGIC IS CURRENTLY COMMENTED OUT UNTIL BUSINESS (PHIBRED) IS READY
TES20140113 fix in email_onAfter() to only attempt to update leads where IsConverted = false 

 ********************************************************************************/
public without sharing class EmailBase {


	static boolean isEnabled {
		get {
			//return true; //for debugging in sanbox
			return ( Util.isProduction || Test.IsRunningTest() );
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Reflects changes in emails and re-total the old and the new
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	public static DMlResults leads_CalcTotals() {
		SET<string> emails = new SET<string>(); 
		if (Trigger.isUpdate) {
			for (integer i=0;trigger.size>i;i++) {
				string newEmail = (string)trigger.new[i].get('email');
				string oldEmail = (string)trigger.old[i].get('email');
				//TES20130909 if (newEmail!=oldEmail) {
				emails.add(newEmail);
				emails.add(oldEmail);
				//}
			}           
		}
		else {  
			LIST<Lead> leads;
			if (Trigger.isInsert || Trigger.isUnDelete) 
				leads = (LIST<Lead>) Trigger.new;
			if (Trigger.isDelete)           
				leads = (LIST<Lead>) Trigger.old;

			for (Lead l : leads) 
				emails.add(l.email);
		}
		emails.remove(null);
		return refreshTotalEmailMembers(emails);
	}



	//////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	public static void leads_onAfter() {


		if (isEnabled) {

			DMLResults unsuccessfuls = new DMLResults();
			string err='';

			MAP<Id,Lead> leadsInScope = new MAP<Id,Lead>([
			                                              Select id, email, globalemail__c, Preferred_Language__c, Lead_Country__c, Origin_Channel_Type__c
			                                              from Lead WHERE id in: Trigger.new and Lead.IsConverted=false]); //need to include records wo/ emails incase we need to clear globalemail__c

			if (leadsInScope.size()>0) {

				//Upsert Email object
				MAP<string,Email__c> emailsToUpsert = new MAP<string,Email__c>();
				for (Lead l : leadsInScope.values()) {
					if (l.email!=null) {
						//TES20130523
						if (Util.stringToEmail(l.email)==null) {
							l.Incorrect_Email__c=l.email;
							l.email=null;                       
						}
						else 
							emailsToUpsert.put(l.email,leadToGlobalEmail(l));
					}
				}

				//TES20130828
				//upsert emailsToUpsert.values()  Email__c.Email__c;
				unsuccessfuls.add(new DMLResults(database.upsert(emailsToUpsert.values(), Email__c.Email__c, false),emailsToUpsert.values()));

				//refresh globalemail__c to record
				for (Lead l : leadsInScope.values()) {
					if (l.email!=null) {
						if (emailsToUpsert.get(l.email)!=null)
							l.globalEmail__c=emailsToUpsert.get(l.email).id;
					}
					else
						l.globalEmail__c=null;
				}


				try {

					//TES20131114:  add DML Options to Leads
					for  (Lead l : leadsInScope.values()) {
						Database.DMLOptions dmlo = new Database.DMLOptions();
						//dmlo.EmailHeader.triggerAutoResponseEmail = true;
						//dmlo.AssignmentRuleHeader.UseDefaultRule=true;
						//dmlo.EmailHeader.triggerUserEmail = true; 
						l.setOptions(dmlo);
					}
					unsuccessfuls.add(new DMLResults(database.update(leadsInScope.values(), false),leadsInScope.values())); 
				} catch(exception ex) { err+=string.valueOf(ex);}

				try {
					leads_CalcTotals();
				} catch(exception ex) {err+=string.valueOf(ex);}
			}
			if (unsuccessfuls.results.size()>0 || err.length()>0)
				utilEmail.simpleEmail('abhinav.bhatnagar@dupont.com', 'EmailBase DMLResults',String.valueOf(unsuccessfuls.results)+'\n\n'+String.valueOf(err)); 
		}//enabled
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	public static void contacts_onAfter() {

		if (isEnabled) {
			DMLResults unsuccessfuls = new DMLResults();
			string err='';

			MAP<Id,Contact> contactsInScope = new MAP<Id,Contact>([
			                                                       Select Id, email, globalEmail__c, Contact_Country__c, Prefered_Language__c, Account.Country__c, Account.Account_Sub_Type__c 
			                                                       FROM Contact WHERE id in: Trigger.new AND
			                                                       Account.Type<>'Competitor' AND Account.Account_Sub_Type__c<>'Competitor']);

			if (contactsInScope.size()>0) {

				//Upsert Email object
				MAP<string,Email__c> emailsToUpsert = new MAP<string,Email__c>();
				for (Contact c : contactsInScope.values()) {
					if (c.email!=null) 
						emailsToUpsert.put(c.email,contactToGlobalEmail(c));
				}

				//TES20130828
				//upsert emailsToUpsert.values() Email__c.Email__c;
				unsuccessfuls.add(new DMLResults(database.upsert(emailsToUpsert.values(), Email__c.Email__c, false), emailsToUpsert.values()));


				//refresh globalemail__c to record  
				for (Contact c : contactsInScope.values()) {
					if (c.email!=null) {
						if (emailsToUpsert.get(c.email)!=null)
							c.globalEmail__c=emailsToUpsert.get(c.email).id;
					}
					else
						c.globalEmail__c=null;
				}

				//TES20130828
				try {
					unsuccessfuls.add(new DMLResults(database.update(contactsInScope.values(), false),contactsInScope.values())) ;
				} catch(exception ex) {err+=string.valueOf(ex);}

				try {
					unsuccessfuls.add(contacts_CalcTotals());
				} catch(exception ex) {err+=string.valueOf(ex);}
			}
			if (unsuccessfuls.results.size()>0 || err.length()>0)
				utilEmail.simpleEmail('abhinav.bhatnagar@dupont.com', 'EmailBase DMLResults',String.valueOf(unsuccessfuls.results)+'\n\n'+String.valueOf(err));
		}//enabled
	}



	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Reflects changes in emails and re-total the old and the new
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	private static DMlResults Contacts_calcTotals() {
		SET<string> emails = new SET<string>();
		if (Trigger.isUpdate) {
			for (integer i=0;trigger.size>i;i++) {
				string newEmail = (string)trigger.new[i].get('email');
				string oldEmail = (string)trigger.old[i].get('email');
				//TES20130909 if (newEmail!=oldEmail) {
				emails.add(newEmail);
				emails.add(oldEmail);
				//}
			}
		}
		else {  
			LIST<Contact> contacts;
			if (Trigger.isInsert || Trigger.isUnDelete) 
				contacts = (LIST<Contact>) Trigger.new;
			if (Trigger.isDelete)           
				contacts = (LIST<Contact>) Trigger.old;

			for (Contact c : contacts) 
				emails.add(c.email);
		}
		emails.remove(null);
		return refreshTotalEmailMembers(emails);        
	}



	public static void email_onAfter() {
		// the emails where bounce state has changed or an additional lead or contact with same email
		// was added,  this is done by checking if the totalLeads and totalContact fields were increasd
		if (Trigger.isUpdate)   {
			LIST<Email__c> newRecords = (LIST<Email__c>) Trigger.new;
			LIST<Email__c> oldRecords = (LIST<Email__c>) Trigger.old;
			// MAP: ( scope = map<email,hasBounced> )
			map<string,boolean> scope = new MAP<string,boolean>();  
			for (integer i=0; i<newRecords.size(); i++) {
				Email__c newRec = newRecords[i];
				Email__c oldRec = oldRecords[i];
				if (newRec.bounced__c!=oldRec.bounced__c  ||
						newRec.TotalLeads__c>oldRec.TotalLeads__c   ||
						newRec.TotalContacts__c>oldRec.TotalContacts__c
				)
					scope.put(newrecords[i].email__c,newRecords[i].bounced__c);
			}
			if (scope.size()>0) {
				//Update leads bounce state to match email__c record
				LIST<Lead> leadsToUpdate        =  [Select Id, email, bounced__c from Lead where email =: scope.keyset() and IsConverted = false];
				if (leadsToUpdate.size()>0) {
					for (Lead l : leadsToUpdate) {
						l.bounced__c=scope.get(l.email);
					}
					update leadsToUpdate;
				}

				LIST<Contact> contactsToUpdate  =  [Select Id, email, bounced__c from Contact where email =: scope.keyset()];
				if (contactsToUpdate.size()>0) {
					for (Contact c : contactsToUpdate) {
						c.bounced__c=scope.get(c.email);
					}
					update contactsToUpdate;
				}               
			}
		} 

	}


	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Helper Methods
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//refreshTotalEmailMembers:  refreshes the total contacts/leads and most recent lead/Contact
	public static DMlResults refreshTotalEmailMembers(SET<string> emails)   {
		system.debug('emails to refresh:'+emails);
		LIST<Email__c> ems = new LIST<Email__c>([
		                                         Select Id, TotalContacts__c, TotalLeads__c,Contact__c, Lead__c, 
		                                         (Select Id from Contacts__r order by lastModifiedDate desc), 
		                                         (Select Id from Leads__r where IsConverted = false order by lastModifiedDate desc)
		                                         FROM Email__c where email__c in: emails ]);
		for (Email__c e : ems) {
			system.debug(e.Contacts__r.size());
			system.debug(e.Leads__r.size());
			e.TotalContacts__c=e.Contacts__r.size();
			e.TotalLeads__c=e.Leads__r.size();

			//We may not want to clear this out!!!! as this can help determine the orgin source of changed emails
			if (e.Leads__r.size()>0)
				e.Lead__c=e.Leads__r[0].id;
			else
				e.Lead__c=null;
			if (e.Contacts__r.size()>0)
				e.Contact__c=e.Contacts__r[0].id;
			else
				e.Contact__c=null;
		}
		return new DMLresults(database.update(ems,false),ems);
	}


	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//'Not Notified' is defaulted for upserts as an insert and since all new contacts = 'Not Notified' do not populate Privacy_Notification__c
	private static Email__c contactToGlobalEmail(Contact c) {
		Email__c em = new Email__c(email__c=c.email);
		em.contact__c=c.id;
		if (c.Prefered_Language__c!=null)
			em.Preferred_Language__c=c.Prefered_Language__c;
		else if (c.Contact_Country__c != null)  
			em.Preferred_Language__c = mapCountryLang.get(c.Contact_Country__c.toUpperCase());
		else if (c.Account !=null && c.Account.Country__c != null)  
			em.Preferred_Language__c = mapCountryLang.get(c.Account.Country__c.toUpperCase());

		if (c.Account !=null && c.Account.Account_Sub_Type__c=='Sales Agency')
			em.Privacy_Notification__c='Notified';      
		return em;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//'Not Notified' is defaulted for upserts as an insert so only specify the notified explicitly  
	private static Email__c leadToGlobalEmail(Lead l) {
		Email__c em = new Email__c(email__c=l.email);
		em.Lead__c=l.id;
		if (l.Preferred_Language__c!=null)
			em.Preferred_Language__c=l.Preferred_Language__c;
		else if (l.Lead_Country__c != null) 
			em.Preferred_Language__c = mapCountryLang.get(l.Lead_Country__c.toUpperCase());

		string ctype=(l.Origin_Channel_Type__c!=null) ? l.Origin_Channel_Type__c.toLowercase() : '';
		if (ctype.startsWith('web') || ctype=='event')
			em.Privacy_Notification__c='Notified';
		return em;
	}







	//////////////////////////////////////////////////////////////////////////////////////////////////////////////  
	/*private static MAP<string,string> getEmailToIdMap(MAP<string,Email__c> emails) {
        MAP<string,string> rtn = new MAP<string,string>();
        for (Email__c em : emails.values())
            rtn.put(em.email__c, em.Id);
        return rtn;
    }
	 */



	public static final MAP<string,string> mapCountryLang = new MAP<string, string>{
		'AFGHANISTAN'=>'ARABIC',
		'ÅLAND ISLANDS'=>'SWEDISH',
		'ALBANIA'=>'ALBANIAN',
		'ALGERIA'=>'ARABIC',
		'AMERICAN SAMOA'=>'ENGLISH',
		//'ANDORRA'=>'-',
		'ANGOLA'=>'PORTUGUESE',
		'ANGUILLA'=>'ENGLISH',
		'ANTARCTICA'=>'FRENCH',
		'ANTIGUA AND BARBUDA'=>'ENGLISH',
		'ARGENTINA'=>'SPANISH',
		'ARMENIA'=>'ARMENIAN',
		'ARUBA'=>'DUTCH',
		'AUSTRALIA'=>'ENGLISH',
		'AUSTRIA'=>'GERMAN',
		'AZERBAIJAN'=>'AZERBAIJANI',
		'BAHAMAS'=>'ENGLISH',
		'BAHRAIN'=>'ARABIC',
		'BANGLADESH'=>'ENGLISH',
		'BARBADOS'=>'ENGLISH',
		'BELARUS'=>'BYELORUSSIAN',
		'BELGIUM'=>'DUTCH',
		'BELIZE'=>'ENGLISH',
		'BENIN'=>'FRENCH',
		'BERMUDA'=>'ENGLISH',
		//'BHUTAN'=>'-',
		'BOLIVIA'=>'SPANISH',
		'BOSNIA AND HERZEGOVINA'=>'CROATIAN',
		'BOTSWANA'=>'ENGLISH',
		'BOUVET ISLAND'=>'NORWEGIAN',
		'BRAZIL'=>'PORTUGUESE',
		'BRITISH INDIAN OCEAN TERRITORY'=>'ENGLISH',
		'BRUNEI DARUSSALAM'=>'MALAY',
		'BULGARIA'=>'BULGARIAN',
		'BURKINA FASO'=>'FRENCH',
		'BURUNDI'=>'FRENCH',
		//'CAMBODIA'=>'-',
		'CAMEROON'=>'ENGLISH',
		'CANADA'=>'ENGLISH',
		'CAPE VERDE'=>'PORTUGUESE',
		'CAYMAN ISLANDS'=>'ENGLISH',
		'CENTRAL AFRICAN REPUBLIC'=>'FRENCH',
		'CHAD'=>'ARABIC',
		'CHILE'=>'SPANISH',
		'CHINA'=>'CHINESE',
		'CHRISTMAS ISLAND'=>'ENGLISH',
		'COCOS (KEELING) ISLANDS'=>'ENGLISH',
		'COLOMBIA'=>'SPANISH',
		'COMOROS'=>'ARABIC',
		'CONGO'=>'FRENCH',
		'CONGO, THE DEMOCRATIC REPUBLIC OF THE'=>'FRENCH',
		'COOK ISLANDS'=>'ENGLISH',
		'COSTA RICA'=>'SPANISH',
		'CÔTE D\'IVOIRE'=>'FRENCH',
		'CROATIA'=>'CROATIAN',
		'CUBA'=>'SPANISH',
		'CYPRUS'=>'GREEK',
		'CZECH REPUBLIC'=>'CZECH',
		'DENMARK'=>'DANISH',
		'DJIBOUTI'=>'ARABIC',
		'DOMINICA'=>'ENGLISH',
		'DOMINICAN REPUBLIC'=>'SPANISH',
		'ECUADOR'=>'SPANISH',
		'EGYPT'=>'ARABIC',
		'EL SALVADOR'=>'SPANISH',
		'EQUATORIAL GUINEA'=>'FRENCH',
		'ERITREA'=>'ARABIC',
		'ESTONIA'=>'ESTONIAN',
		'ETHIOPIA'=>'ENGLISH',
		'FALKLAND ISLANDS (MALVINAS)'=>'ENGLISH',
		'FAROE ISLANDS'=>'DANISH',
		'FIJI'=>'ENGLISH',
		'FINLAND'=>'FINNISH',
		'FRANCE'=>'FRENCH',
		'FRENCH GUIANA'=>'FRENCH',
		'FRENCH POLYNESIA'=>'FRENCH',
		'FRENCH SOUTHERN TERRITORIES'=>'FRENCH',
		'GABON'=>'FRENCH',
		'GAMBIA'=>'ENGLISH',
		//'GEORGIA'=>'-',
		'GERMANY'=>'GERMAN',
		'GHANA'=>'ENGLISH',
		'GIBRALTAR'=>'ENGLISH',
		'GREECE'=>'GREEK',
		'GREENLAND'=>'DANISH',
		'GRENADA'=>'ENGLISH',
		'GUADELOUPE'=>'FRENCH',
		'GUAM'=>'ENGLISH',
		'GUATEMALA'=>'SPANISH',
		'GUINEA'=>'FRENCH',
		'GUINEA-BISSAU'=>'PORTUGUESE',
		'GUYANA'=>'ENGLISH',
		'HAITI'=>'FRENCH',
		'HEARD ISLAND AND MCDONALD ISLANDS'=>'ENGLISH',
		'HOLY SEE (VATICAN CITY STATE)'=>'ITALIAN',
		'HONDURAS'=>'SPANISH',
		'HONG KONG'=>'CHINESE',
		'HUNGARY'=>'HUNGARIAN',
		'ICELAND'=>'ICELANDIC',
		'INDIA'=>'ENGLISH',
		'INDONESIA'=>'INDONESIAN',
		'IRAN, ISLAMIC REPUBLIC OF'=>'PERSIAN',
		'IRAQ'=>'ARABIC',
		'IRELAND'=>'ENGLISH',
		'ISRAEL'=>'ARABIC',
		'ITALY'=>'ITALIAN',
		'JAMAICA'=>'ENGLISH',
		'JAPAN'=>'JAPANESE',
		'JORDAN'=>'ARABIC',
		'KAZAKHSTAN'=>'RUSSIAN',
		'KENYA'=>'ENGLISH',
		'KIRIBATI'=>'ENGLISH',
		'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF'=>'KOREAN',
		'KOREA, REPUBLIC OF'=>'KOREAN',
		'KUWAIT'=>'ARABIC',
		'KYRGYZSTAN'=>'RUSSIAN',
		'LAO PEOPLE\'S DEMOCRATIC REPUBLIC'=>'-',
		'LATVIA'=>'LATVIAN',
		'LEBANON'=>'ARABIC',
		'LESOTHO'=>'ENGLISH',
		'LIBERIA'=>'ENGLISH',
		'LIBYAN ARAB JAMAHIRIYA'=>'ARABIC',
		'LIECHTENSTEIN'=>'GERMAN',
		'LITHUANIA'=>'LITHUANIAN',
		'LUXEMBOURG'=>'FRENCH',
		'MACAO'=>'CHINESE',
		'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF'=>'MACEDONIAN',
		'MADAGASCAR'=>'FRENCH',
		'MALAWI'=>'ENGLISH',
		'MALAYSIA'=>'ENGLISH',
		'MALDIVES'=>'ARABIC',
		'MALI'=>'FRENCH',
		'MALTA'=>'ENGLISH',
		'MARSHALL ISLANDS'=>'ENGLISH',
		'MARTINIQUE'=>'FRENCH',
		'MAURITANIA'=>'ARABIC',
		'MAURITIUS'=>'ENGLISH',
		'MAYOTTE'=>'FRENCH',
		'MEXICO'=>'SPANISH',
		'MICRONESIA, FEDERATED STATES OF'=>'ENGLISH',
		'MOLDOVA, REPUBLIC OF'=>'ROMANIAN',
		'MONACO'=>'FRENCH',
		'MONGOLIA'=>'MONGOLIAN',
		'MONTENEGRO'=>'ALBANIAN',
		'MONTSERRAT'=>'ENGLISH',
		'MOROCCO'=>'ARABIC',
		'MOZAMBIQUE'=>'PORTUGUESE',
		'MYANMAR'=>'BURMESE',
		'NAMIBIA'=>'ENGLISH',
		'NAURU'=>'ENGLISH',
		//'NEPAL'=>'-',
		'NETHERLANDS'=>'DUTCH',
		'NETHERLANDS ANTILLES'=>'DUTCH',
		'NEW CALEDONIA'=>'FRENCH',
		'NEW ZEALAND'=>'ENGLISH',
		'NICARAGUA'=>'SPANISH',
		'NIGER'=>'ENGLISH',
		'NIGERIA'=>'ENGLISH',
		'NIUE'=>'ENGLISH',
		'NORFOLK ISLAND'=>'ENGLISH',
		'NORTHERN MARIANA ISLANDS'=>'ENGLISH',
		'NORWAY'=>'NORWEGIAN',
		'OMAN'=>'ARABIC',
		'PAKISTAN'=>'ENGLISH',
		'PALAU'=>'ENGLISH',
		'PALESTINIAN TERRITORY, OCCUPIED'=>'ARABIC',
		'PANAMA'=>'SPANISH',
		'PAPUA NEW GUINEA'=>'ENGLISH',
		'PARAGUAY'=>'SPANISH',
		'PERU'=>'SPANISH',
		'PHILIPPINES'=>'ENGLISH',
		'PITCAIRN'=>'ENGLISH',
		'POLAND'=>'POLISH',
		'PORTUGAL'=>'PORTUGUESE',
		'PUERTO RICO'=>'ENGLISH',
		'QATAR'=>'ARABIC',
		'RÉUNION'=>'FRENCH',
		'ROMANIA'=>'ROMANIAN',
		'RUSSIAN FEDERATION'=>'RUSSIAN',
		'RWANDA'=>'ENGLISH',
		'SAINT HELENA'=>'ENGLISH',
		'SAINT KITTS AND NEVIS'=>'ENGLISH',
		'SAINT LUCIA'=>'ENGLISH',
		'SAINT PIERRE AND MIQUELON'=>'FRENCH',
		'SAINT VINCENT AND THE GRENADINES'=>'ENGLISH',
		'SAMOA'=>'ENGLISH',
		'SAN MARINO'=>'ITALIAN',
		'SAO TOME AND PRINCIPE'=>'PORTUGUESE',
		'SAUDI ARABIA'=>'ARABIC',
		'SENEGAL'=>'FRENCH',
		'SERBIA'=>'SERBIAN',
		'SEYCHELLES'=>'FRENCH',
		'SIERRA LEONE'=>'ENGLISH',
		'SINGAPORE'=>'ENGLISH',
		'SLOVAKIA'=>'CZECH',
		'SLOVENIA'=>'SLOVENIAN',
		'SOLOMON ISLANDS'=>'ENGLISH',
		'SOMALIA'=>'ARABIC',
		'SOUTH AFRICA'=>'AFRIKAANS',
		'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS'=>'-',
		'SPAIN'=>'SPANISH',
		'SRI LANKA'=>'ENGLISH',
		'SUDAN'=>'ARABIC',
		'SURINAME'=>'DUTCH',
		'SVALBARD AND JAN MAYEN'=>'NORWEGIAN',
		'SWAZILAND'=>'ENGLISH',
		'SWEDEN'=>'SWEDISH',
		'SWITZERLAND'=>'FRENCH',
		'SYRIAN ARAB REPUBLIC'=>'ARABIC',
		'TAIWAN'=>'CHINESE (TRADITIONAL)',
		'TAJIKISTAN'=>'RUSSIAN',
		'TANZANIA, UNITED REPUBLIC OF'=>'ENGLISH',
		'THAILAND'=>'THAI|',
		'TIMOR-LESTE'=>'PORTUGUESE',
		'TOGO'=>'FRENCH',
		'TOKELAU'=>'ENGLISH',
		'TONGA'=>'ENGLISH',
		'TRINIDAD AND TOBAGO'=>'ENGLISH',
		'TUNISIA'=>'ARABIC',
		'TURKEY'=>'TURKISH',
		'TURKMENISTAN'=>'RUSSIAN',
		'TURKS AND CAICOS ISLANDS'=>'ENGLISH',
		'TUVALU'=>'ENGLISH',
		'UGANDA'=>'SWAHILI',
		//'UKRAINE'=>'-',
		'UNITED ARAB EMIRATES'=>'ARABIC',
		'UNITED KINGDOM'=>'ENGLISH',
		'UNITED STATES'=>'ENGLISH',
		'UNITED STATES MINOR OUTLYING ISLANDS'=>'ENGLISH',
		'URUGUAY'=>'SPANISH',
		//'UZBEKISTAN'=>'-',
		'VANUATU'=>'ENGLISH',
		'VENEZUELA'=>'SPANISH',
		'VIET NAM'=>'VIETNAMESE',
		'VIRGIN ISLAND, BRITISH'=>'ENGLISH',
		'VIRGIN ISLANDS, U.S.'=>'ENGLISH',
		'WALLIS AND FUTANA'=>'FRENCH',
		'WESTERN SAHARA'=>'SPANISH',
		'YEMEN'=>'ARABIC',
		'ZAMBIA'=>'ENGLISH',
		'ZIMBABWE'=>'ENGLISH',
		'ZZ - FIELD NOT USED'=>'ENGLISH'};


}

/*


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Person Account
    public static void accounts_onAfter() {

        if (isEnabled) {

            DMLResults unsuccessfuls = new DMLResults();
            string err='';

            //treat as a contact update if person account
            SET<id> personAccountIds = new SET<id>();
            for (integer i=0;trigger.size>i;i++) {
                Account acc = (Account)trigger.new[i];
                if (acc.IsPersonAccount==true && acc.PersonEmail!=null )
                    personAccountIds.add(acc.Id);
            }
            if (!personAccountIds.isEmpty()) {

                MAP<Id,Account> personAccountsInScope = new MAP<Id,Account>([
                    Select Id, personemail, recordtypeid, PersonContactId, globalEmail__pc, Contact_Country__pc, 
                        Prefered_Language__pc, Country__c, Account_Sub_Type__c
                    FROM Account WHERE Account.IsPersonAccount = true
                        AND Account.Id in: personAccountIds
                    ]);

                if (personAccountsInScope.size()>0) {

                    //Upsert Email object
                    MAP<string,Email__c> emailsToUpsert = new MAP<string,Email__c>();
                    for (Account c : personAccountsInScope.values()) {
                        if (c.personemail!=null) 
                            emailsToUpsert.put(c.personemail,personAccountsToGlobalEmail(c));
                    }
                    unsuccessfuls.add(new DMLResults(database.upsert(emailsToUpsert.values(), Email__c.Email__c, false), emailsToUpsert.values()));


                    //refresh globalemail__c to record  
                    for (Account c : personAccountsInScope.values()) {
                        if (c.personemail!=null) {
                            if (emailsToUpsert.get(c.personemail)!=null)
                                c.globalEmail__pc=emailsToUpsert.get(c.personemail).id;
                        }
                        else
                            c.globalEmail__pc=null;
                    }

                    try {
                        unsuccessfuls.add(new DMLResults(database.update(personAccountsInScope.values(), false),personAccountsInScope.values())) ;
                    } catch(exception ex) {err+=string.valueOf(ex);}

                    try {
                        unsuccessfuls.add(personAccount_CalcTotals(personAccountIds));
                    } catch(exception ex) {err+=string.valueOf(ex);}
                }
                if (unsuccessfuls.results.size()>0 || err.length()>0)
                    utilEmail.simpleEmail('abhinav.bhatnagar@dupont.com', 'EmailBase DMLResults',String.valueOf(unsuccessfuls.results)+'\n\n'+String.valueOf(err));
            }//isPersonAccount
        }//enabled

    }



    //////////////////////////////////////////////////////////////////////////////////////////////////////////////  
    public static DMlResults personAccount_CalcTotals(SET<Id> personAccountIds) {
        SET<string> emails = new SET<string>(); 
        if (Trigger.isUpdate) {
            for (Id id : personAccountIds) {
                string newEmail = (string)trigger.newMap.get(id).get('PersonEmail');
                string oldEmail = (string)trigger.oldMap.get(id).get('PersonEmail');
                    emails.add(newEmail);
                    emails.add(oldEmail);
            }
        }
        else {  
            if (Trigger.isInsert || Trigger.isUnDelete) {
                for (Id id : personAccountIds) {
                    string email = (string)trigger.newMap.get(id).get('PersonEmail');
                    emails.add(email);
                }
            }
            if (Trigger.isDelete) { 
                for (Id id : personAccountIds) {
                    string email = (string)trigger.oldMap.get(id).get('PersonEmail');
                    emails.add(email);
                }
            }
        }
        emails.remove(null);
        return refreshTotalEmailMembers(emails);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //'Not Notified' is defaulted for upserts as an insert and since all new contacts = 'Not Notified' do not populate Privacy_Notification__c
    private static Email__c personAccountsToGlobalEmail(Account pc) {
        Email__c em = new Email__c(email__c=pc.personemail);
        em.contact__c=pc.PersonContactId;
        if (pc.Prefered_Language__pc!=null)
            em.Preferred_Language__c=pc.Prefered_Language__pc;
        else if (pc.Contact_Country__pc != null)    
            em.Preferred_Language__c = mapCountryLang.get(pc.Contact_Country__pc.toUpperCase());
        else if (pc.Country__c != null) 
            em.Preferred_Language__c = mapCountryLang.get(pc.Country__c.toUpperCase()); 

        if (pc.Account_Sub_Type__c=='Sales Agency')
            em.Privacy_Notification__c='Notified';
        return em;
    }


 */
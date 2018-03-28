/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  General Class for handling Translation and Localization

TES20120510 - Optimized by allowing terms to be precached 
********************************************************************************/
public class Translation {
	
	public static final string RTYPE_SOI_TRANSLATION	= Rtype.getIdByDevName('SiteObjectItem__c','TranslationItem'); 
 	public static MAP<Id,SiteObject__c> siteObjectTranslations {get; private set;}
 	
 public Translation(SET<string> SiteObjectIds) {  
		siteObjectTranslations = new MAP<Id,SiteObject__c>([
			Select id, PublicName__c, PublicDescription__c, 
            	( Select  NameOverride__c, DescriptionOverride__c, language__c From Items__r 
            		Where recordtypeid =: RTYPE_SOI_TRANSLATION
            	)
            from SiteObject__c
            where Id in : SiteObjectIds
			]);
 	}
 
	public translationResult Translate(string siteObjectId, string isoLang) {
 		TranslationResult rtn = new TranslationResult();
 		SiteObject__c so=siteObjectTranslations.get(siteObjectId);
 		if (so!=null) {
 			rtn.isoCode 		='en';
			rtn.name			=so.PublicName__c;
			rtn.description		=so.PublicDescription__c;
			for (SiteObjectItem__c i : so.Items__r) {
				if (i.language__c == isoLang) {
					rtn.isoCode 	=isoLang;
					rtn.name		=i.NameOverride__c;
					rtn.description	=i.DescriptionOverride__c;
					break;
				}
			}
 		}
 		return rtn;
	}
	
	//TES20120510
	//TODO: Add group and lang fitlers for precache terms,  also another precache method for isolang
	//MAP<isolang,MAP<termName,trans>>
	public static MAP<string,MAP<string,string>> cacheTerms;
	public static void precacheTermsByGroup(string termGroup) {
			cacheTerms = new MAP<string,MAP<string,string>>();
			for (SiteObjectItem__c i : [
				Select SiteObject__r.ExternalId__c, DescriptionOverride__c, language__c
				From SiteObjectItem__c
				Where recordtypeid =: RTYPE_SOI_TRANSLATION ]
	           //TODO: Add group and lang fitlers for precache
	           ) {
				if (!Util.isBlank(i.DescriptionOverride__c) && !Util.isBlank(i.language__c)) {
					if (!cacheTerms.containsKey(i.language__c))
						cacheTerms.put(i.language__c,new MAP<string,string>());
					cacheTerms.get(i.language__c).put(i.SiteObject__r.ExternalId__c,i.DescriptionOverride__c);
	       		}
			}				
	}
	
	//updated to only use the terms in cache
	public static string TranslateTerm(string term, string isoCode) {
		string rtn;
		try {
			if (!Util.isBlank(term))
				rtn=cacheTerms.get(isoCode).get(scrubTerm(term));
		}catch(Exception ex) {}
		return (rtn!=null) ? rtn : term;
		//return TranslateTerms(new SET<string>{term},isoCode).values()[0];
	}
	
	/**
	returns: MAP<orig term,translated term>
	if term does not contain a translation translated term = orig term;
	**/
	public static MAP<string,string> TranslateTerms(SET<string> terms, string isoCode) {

		//get the externalids = scubbed term  = no special chars and whitespace = '_'
		SET<string> exids = new SET<string>();
		for (string term : terms) {
			string scrub = scrubTerm(term);
			if (scrub!=null)
				exids.add(scrub);
		}
		system.debug('ExternalIds:'+ exids);
		MAP<string,string> trans = new MAP<string,string>(); //MAP<externalids,translated term>
		if (!Util.isBlank(isoCode)) {
			for (SiteObjectItem__c i : [
				Select SiteObject__r.ExternalId__c, DescriptionOverride__c 
				From SiteObjectItem__c
				Where recordtypeid =: RTYPE_SOI_TRANSLATION
				AND language__c =: isoCode
	            AND SiteObject__r.ExternalId__c =: exids] ) 
			{	
				if (!Util.isBlank(i.DescriptionOverride__c))
	           		trans.put(i.SiteObject__r.ExternalId__c,i.DescriptionOverride__c);
	       }
		}
		
		MAP<string,string> rtn = new MAP<string,string>(); 
 		for (string term : terms) {
 			string st = scrubTerm(term);
 			string tt = (trans.containsKey(st)) ? trans.get(st) : term;
		 	rtn.put(term,tt);           
 		}
 		return rtn;
		
	}



	public static string scrubTerm(string term) {
		string rtn;
		if (term!=null)
			rtn=term.toUpperCase().replaceAll('\\s+','_').replaceAll('[^A-Z,a-z,0-9,_]','');
		return rtn;
	}

	public class TranslationResult {	
		public string isoCode 		{get; set; }
		public string name	 		{get; set; }
		public string description 	{get; set; }
		
	}
	
	
	
	
	
	//Caveat all sobjects must be of the same Sobjecttype...
	//public static LIST<sObject> TranslateSObject(LIST<sObject> sos, string isoLangs) 
	//public static LIST<sObject> TranslateSObject(LIST<sObject> sos, SET<string> isoLangs)
	//public static LIST<sObject> TranslateSObject(LIST<sObject> sos, SET<string> isoLangs)
	public static LIST<sObject> TranslateSObject(LIST<sObject> sos, SET<string> isoLangs, string sotype, string localizationType)
	 {
	 	Util.Describe descrLocalization = new Util.Describe(localizationType);
		LIST<sObject> rtn = sos;
		//if LIST
		//1.  get type of Object  (Product, Classification)
		
		
		//2.  determine if ObjectType+'Localization' object exists
		//3.  infer locaization object determine fields to be translated
		//4. Select All Locatization records where order of pref languages exists or one iso lang
		// need to determine M-D parent field..
	//locs=[Select Id ( Select Util.joint(descrLocalization.AccessibleFieldMap.keySet(), ',') FROM localizationType'
	// ' WHERE '+MDfield ' AND isolang__c in: isoLangs') from sotype ' WHERE  Id in : sos'];
		
		//for	(sobject so : sos) {
			//locs=
		//	for	(string fld : descrLocalization.AccessibleFieldMap.keySet()) 
			
		//}
		
		
		//5.  based on order of pref,  overwrite the parent objects name , desc, etc...
		return rtn;
		
	}
	
	
	
	
//*****************************************************************************************
// TEST Method(s)
//*****************************************************************************************
   public static testMethod void test_TranslateTerm() {

		SiteObject__c so = new SiteObject__c(ExternalId__c = 'NO_SUCH_WORD');
		insert so;
		
		SiteObjectItem__c soi1 = new SiteObjectItem__c(SiteObject__c=so.id, recordtypeId=RTYPE_SOI_TRANSLATION, DescriptionOverride__c = 'No Such Word - German', language__c='de');
		SiteObjectItem__c soi2 = new SiteObjectItem__c(SiteObject__c=so.id, recordtypeId=RTYPE_SOI_TRANSLATION, DescriptionOverride__c = 'No Such Word - French', language__c='fr');
		insert new SiteObjectItem__c[]{soi1,soi2};
		
        System.Test.startTest();
		precacheTermsByGroup(null);
		system.assertEquals('No Such Word - German', Translation.TranslateTerm('No Such Word','de'));
		system.assertEquals('No Such Word - French', Translation.TranslateTerm('No Such Word','fr'));
		//fall back to entered term when a translation does not exists
		system.assertEquals('No Such Word', Translation.TranslateTerm('No Such Word','xx'));
		TranslateTerms(new SET<string>{'No Such Word'}, 'de');
        System.Test.stopTest();
    }  
	
	
}
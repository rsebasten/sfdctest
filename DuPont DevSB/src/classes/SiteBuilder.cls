/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  helper class for custom Site objects retrival and translation
********************************************************************************/


public class SiteBuilder {
    	
	public static final string RTYPE_SO_CENTER					= Rtype.getIdByName('SiteObject__c','Subscription Center');
	public static final string RTYPE_SO_SUBFORM					= Rtype.getIdByName('SiteObject__c','SubForm');	
	public static final string RTYPE_SO_LIST					= Rtype.getIdByName('SiteObject__c','Subscriber List');
	public static final string RTYPE_SOI_CENTERITEM				= Rtype.getIdByName('SiteObjectItem__c','Center Item');
	public static final string RTYPE_SOI_FORMFIELD				= Rtype.getIdByName('SiteObjectItem__c','Form Field');
	public static final string RTYPE_SOI_TRANSLATION			= Rtype.getIdByName('SiteObjectItem__c','Translation Item'); 

	//public static final string DEFAULT_SUBFORM 					= 'a1qQ000000000pb'; //TEST5 
	 public static final string DEFAULT_SUBFORM 					= 'a1q300000004DOD'; //PROD
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    
    public static SiteObject__c getSiteObject(string ObjectId) {
        LIST<SiteObject__c> sos = [
            Select Id, Type__c, ReturnUrl__c, PublicName__c, PublicDescription__c, IsPublic__c, 
                Subform__c,  NewRecordOwnerId__c, NewRecordTypeId__c, ExternalId__c
            From SiteObject__c
            where id =: ObjectId
            LIMIT 1
            ];
        
        if (sos.size()>0 )
            return sos[0];
        else
            return null;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    public static SiteObject__c getSiteObjectAndItems(string siteObjectId, string ObjRType, string ItemRType, string isolang) {
            /////////////////////////////////////////////////////////////////////////////////////////
            //  Get the SiteObject And Items
            /////////////////////////////////////////////////////////////////////////////////////////
            LIST<SiteObject__c> sos = [
                Select Id, Type__c, ReturnUrl__c, PublicName__c, PublicDescription__c, IsPublic__c, 
                    Subform__c,  NewRecordOwnerId__c, NewRecordTypeId__c,
                    (   Select Id, IsRequired__c, order__c, Language__c, FormField__c, 
                            ChildSiteObject__c, ChildSiteObject__r.ExternalId__c, ChildSiteObject__r.PublicName__c, 
                            ChildSiteObject__r.PublicDescription__c
                        from Items__r   
                        where recordtypeid =: ItemRType 
                            AND (ChildSiteObject__c = null OR ChildSiteObject__r.IsPublic__c=true)
                        order by order__c
                    )
                From SiteObject__c
                where id =: siteObjectId AND recordtypeid =:ObjRType
                LIMIT 1
                ];
            
            if (sos.size()>0 ) {
                SiteObject__c siteObject=sos[0];    
                translateSiteObjectAndItems(siteObject,isolang);
                return siteObject;
            }
            else
                return null;
            
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public static void translateSiteObjectAndItems(SiteObject__c siteObject, string isolang) {

                MAP<id,SiteObject__c> mapSiteObjs = new MAP<id,SiteObject__c>();
                //add Parent Item
                mapSiteObjs.put(siteObject.id, siteObject);
                
                //add Child items (if any) 
                try {
	                for (SiteObjectItem__c soi : siteObject.Items__r ) {
	                    if (soi.ChildSiteObject__c != null)
	                        mapSiteObjs.put(soi.ChildSiteObject__c, soi.ChildSiteObject__r);
	                }
                }
                catch (exception ex) {
                	//TRAP  when siteObject.Items__r is not in the SOQL select 
                	// 	IF(siteObject.Items__r !=null) ... does not work for this.
                }
                
                if (mapSiteObjs.size()>0)
                    translateSiteObjects(mapSiteObjs, isolang);


    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public static void translateSiteObjects(MAP<id,SiteObject__c> mapSiteObjs, string isolang) {
                
                /////////////////////////////////////////////////////////////////////////////////////////
                //  Get the translations
                /////////////////////////////////////////////////////////////////////////////////////////           
                MAP<Id,SiteObjectItem__c> translation = new MAP<Id,SiteObjectItem__c>();
                for (SiteObjectItem__c soi : [
                        Select SiteObject__c, NameOverride__c, DescriptionOverride__c 
                        from SiteObjectItem__c
                        where ( SiteObject__c in : mapSiteObjs.keySet() )
                        AND recordtypeid =: RTYPE_SOI_TRANSLATION
                        AND language__c =:isolang
                        ]) 
                    translation.put(soi.SiteObject__c, soi);
                 
                 if (translation.size()>0) { 
                    system.debug('Translation: '+translation);
                
	                for ( SiteObject__c so : mapSiteObjs.values()) {
	                    if (so.id!=null && translation.containsKey(so.id)) {
	                    	SiteObjectItem__c soi_tran = translation.get(so.id);
	                    	if (soi_tran!=null) {
	                        	if (soi_tran.NameOverride__c      != null)        so.PublicName__c=soi_tran.NameOverride__c;
	                        	if (soi_tran.DescriptionOverride__c  != null)     so.PublicDescription__c=soi_tran.DescriptionOverride__c;
	                    	}
	                    }
	                }
                 }
        
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//	TEST SCripts and helpers

////////////////////////////////////////////////////////////////////////////////////////////////////

public static string testAddSubform() {
		SiteObject__c sf = new SiteObject__c(name='subform1', recordTypeid=RTYPE_SO_SUBFORM, publicname__c='subform1');	
		insert sf;
		LIST<SiteObjectItem__c> flds = new LIST<SiteObjectItem__c>();
		for (Schema.PicklistEntry plst : SiteObjectItem__c.FormField__c.getDescribe().getPicklistValues() )
			if (plst.IsActive()) 
				flds.add( new SiteObjectItem__c(SiteObject__c=sf.id, IsRequired__c=true, FormField__c=plst.getValue(), recordtypeid=RTYPE_SOI_FORMFIELD));
		insert flds;
		return sf.id;
}


////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////

	public static testMethod void test_SiteBuilder() {
		SubscriptionCenter.TESTMODE=true;
		string formid=testAddSubform();
		//add translation
		insert new SiteObjectItem__c(SiteObject__c=formid, language__c='fr', recordtypeid=RTYPE_SOI_TRANSLATION, NameOverride__c='dfdasfsdf', DescriptionOverride__c='dfdasfsdf');

		system.debug('---getSiteObjectAndItems:----->'+getSiteObjectAndItems(formid, RTYPE_SO_SUBFORM, RTYPE_SOI_FORMFIELD, 'fr'));
		system.debug('---getSiteObject:----->'+getSiteObject(formid));	
		system.debug('---getSiteObject:bogus----->'+getSiteObject('bog000000000011'));
		system.debug('---getSiteObjectAndItems:bogus----->'+getSiteObjectAndItems('bog000000000011',RTYPE_SO_SUBFORM, RTYPE_SOI_FORMFIELD, 'en'));
	}


}
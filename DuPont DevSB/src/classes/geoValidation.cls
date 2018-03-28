/**
*
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.0
*
* Copyright © 2010 DuPont. All rights reserved. 
*
* Main page for geoValidation
*
TES20100512 Moved Disable flag from List__c to Customsettings (GeneralSettings__c.Disable_GeoValidation__c)
TES20110118 use isRunningTest() (new in winter11) and static validateInTestMode to drive UT execution of geoValidation
    (previously needed to set the DisableGeoValidationOverride to true prior to execution to stop geoValidation,
        it is now it is disabled by default in testmode unless validateInTestMode=true)
TES20120221 fixed bug with auto disable in non-fullcopy sandboxes
TES20121019 : moved logic from trigAccountGeoValidation to here     
TES20130422 : moved logic from trigContactGeoValidation to here     
@Version 1.1
<Santhosh20160123> : Modified the static Country validation error message for capturing the Country value.
*/
 
public class geoValidation {
    
    //<Santhosh20160123> IS ID-00077732 : Modified the static Country validation error message for capturing the Country value.
    //public static final string ERR_INVALID_COUNTRY = 'The country entered is invalid. If you feel this country is valid and needs to be allowed please contact your administrator.';
    //<Santhosh20160123> : End
    public static final string ERR_NULL_COUNTRY = 'The Country is blank.  A valid country is required.';
    public static boolean DisableGeoValidationOverride = false;             //Used for Testmethods

    public static boolean validateInTestMode = false;   
   
    /////////////////////////////////////////////////////////////////////////////////////////////
    //  GeoValidationEnabled
    /////////////////////////////////////////////////////////////////////////////////////////////
        public static boolean GeoValidationDisabled() {
            if (DisableGeoValidationOverride) return true;  //old method for testmethods to ignore geovalidation
            //TESII_20110118 - use v20.0 System.Test.isRunningTest()
            if ((!validateInTestMode) && System.Test.isRunningTest() )  return true;
            else {
                GeneralSettings__c gs = GeneralSettings__c.getOrgDefaults();
                return (gs!=null) ? gs.Disable_GeoValidation__c : true;  //TESII_20120221: was false
            }
                /*
            List__c[] lst = [Select Code_1__c from List__c where name='DisableTrigger_GeoValidation'];
            if (lst.size()>0)
                return (lst[0].Code_1__c=='1');
            else 
                return true;
                */
      }
      //<Santhosh20160123> IS ID-00077732 : Modified the static Country validation error message for capturing the Country value.
      Public static string GetErrormessage(string strCountry){
          string strErrorMsg = '';
          strErrorMsg = 'The country entered is invalid. If you feel this country:'+strCountry+' is valid and needs to be allowed please contact your administrator.';
          return strErrorMsg ; 
      }
      //<Santhosh20160123> : End
    /////////////////////////////////////////////////////////////////////////////////////////////
    //  genID() generate a psudo id used for indexing account on Inserts since the ids 
    //        do not exist yet
    /////////////////////////////////////////////////////////////////////////////////////////////
        public static Id genID(integer i) {
            string s = '000000000000'+string.valueOf(i);
            return (ID) ('gen'+s.substring(s.length()-12));
      }


public static testMethod void testContactInsert() {
/*PKH    
    validateInTestMode=true;
        
    Contact[] contacts = new List<Contact> { 
        new Contact(lastname='testcontact',Contact_Country__c='US', MailingState='delaware'),
        new Contact(lastname='testcontact',MailingCountry='US')};
    insert contacts;
    
    try { insert new Contact(lastname='testcontact'); }
    catch (exception e) {}
    
    try { insert new Contact(lastname='testcontact', Contact_Country__c='sfldsjfklg'); }
    catch (exception e) {system.debug(e);}

    validateInTestMode=false;
    insert new Contact(lastname='testcontact', Contact_Country__c='XXXXXX');
*/    
    }
 

 public static testMethod void testLeadInsert() {
    validateInTestMode=true;
        
    Lead[] contacts = new List<Lead> { 
        new Lead(lastname='testcontact', company='testco', Lead_Country__c='US', State='delaware'),
        new Lead(lastname='testcontact', company='testco', Country='US')};
    insert contacts;
    
    List<Lead>newLeads = new List<Lead>();
    Lead lead1= new Lead(lastname='testcontact', company='testco', Lead_Country__c='US', State='delaware');
    newLeads.add(lead1);
    Lead lead2= new Lead(lastname='testcontact',company='testco');
    newLeads.add(lead2);
    Lead lead3= new Lead(lastname='testcontact', company='testco',Lead_Country__c='sfldsjfklg', Origin_Channel_Type__c='phone');
    newLeads.add(lead3);
    try { insert newLeads; }
    catch (exception e) {system.debug(e);}
    
    /*try { insert new Lead(lastname='testcontact', company='testco',Lead_Country__c='sfldsjfklg', Origin_Channel_Type__c='phone'); }
    catch (exception e) {system.debug(e);}

    try { insert new Lead(lastname='testcontact', company='testco',Lead_Country__c='sfldsjfklg', Origin_Channel_Type__c='website'); }
    catch (exception e) {system.debug(e);} */

    validateInTestMode=false;
    insert new Lead(lastname='testcontact',company='testco', Lead_Country__c='XXXXXX');
    }
   
    
    /*************************************************************************
    FUTURE USE: batch Geocoding
      finding:  
        - Mapquest will allow geocodeing up to 100 addresses per call
        - Can be used within a list view (suggest creating a batch operation VF page(s) to handle 
            the multiple batch operations, security and execution will also limits the button 
            footprint on the view to one. (bcc email/bcc fax/bulk geocode, etc..) 
        - will need to create a field for each address on the record to hold the geocoded address, pending approval
            suggest we also  have some logic to auto approve if response code is within an
            accurate range.  (suggested format for results=KML)
        - the new batch operations in v.16 can also be a viable option for background cleansing.
    
    public static void BatchGeoCodeAccounts(account[] accs) {
        MAP<id, account> mapBilling = new MAP<Id, account>();   //map of accounts with Billing Addresses 
        MAP<id, account> mapShipping = new MAP<Id, account>();  //map of accounts with Shipping Addresses   
        integer index=0;
        for (Account a : accs) {
            id accid = (a.id==null) ? GeoValidation.genID(index) : a.id;
            if (a.billingstate != null) mapBilling.put(accid,a);
            if (a.shippingstate != null) mapShipping.put(accid,a);
            index++;
        }
        //  Add the Billing and Shipping addresses to the GeoAddresses collection
        //  and resolve the country and state via the Geography table
        System.debug('----------SCRIPT STATEMENTS (indexing account: trigAccountGeoValidation)---------->'+Limits.getScriptStatements());
        Geography.GeoAddresses geoAddresses = new Geography.GeoAddresses();
        geoAddresses.addSObjectMap(mapBilling, false);  //add primary addresses
        geoAddresses.addSObjectMap(mapShipping, true);  //add secondary addresses
        geoProvider_MapQuest prov = new geoProvider_MapQuest();
        
        Geography.GeoCodeResults gcr=prov.batchGeocode(geoAddresses);
        system.debug('----------GCR-->'+gcr);
        if ( gcr.success ) {
            for ( Geography.GeoAddress ga : gcr.GeoAddresses.getMap().values() ) {
                system.debug('----------GeoAddress-->'+ga);
            }
        
        }
    }
    ********************************************************************************/




///////////////////////////////////////////////////////////////////////////////////////////////
//  static Methods
///////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
    
    
    //TES20121019 : moved logic from trigAccountGeoValidation
    //Fire on Before Insert/Update
    public static void geoValidateAccount() {
        
        if (!GeoValidationDisabled()) {
        /////////////////////////////////////////////////////////////////////////////////////////////
        //  STEP 1: Map accounts need for validation based on shipping and/or billing address
        /////////////////////////////////////////////////////////////////////////////////////////////
            // First determine if validation of billing and/or shipping address(s) are needed
            // The approach is uses MUCH less scripting statements then marshalling all the address
            // to/from a geoadress ORM.
            MAP<id, account> mapBilling = new MAP<Id, account>();   //map of accounts with Billing Addresses 
            MAP<id, account> mapShipping = new MAP<Id, account>();  //map of accounts with Shipping Addresses 
            Integer index;
            for(index=0; index<Trigger.size; index++ ) {
                Account a=(Account) Trigger.new[index];
                if ( Trigger.isUpdate ) {
                    Account old=(Account) Trigger.old[index];
                    if (    a.country__c==old.country__c  && a.billingstate==old.billingstate &&
                            a.shippingstate==old.shippingstate) 
                        continue;
                }
                
                id accid = (Trigger.isInsert) ? GeoValidation.genID(index) : a.id;
                if (a.billingstate != null) mapBilling.put(accid,a);
                if (a.shippingstate != null) mapShipping.put(accid,a);
                else if (a.billingstate == null) {
                    //No state,  lets make sure we have a country (required for accounts)
                    if ( a.country__c!=null || a.billingcountry!=null ) mapBilling.put(accid,a);
                    else if (a.shippingcountry!=null) mapShipping.put(accid,a);
                    else a.Country__c.AddError(geoValidation.ERR_NULL_COUNTRY);
                }
            } //next index
            
            if ( mapBilling.size()>0 || mapShipping.size()>0 ) {
            
                System.debug('----index-------->'+index);
                System.debug('----mapBilling.size()-------->'+mapBilling.size());
                System.debug('----mapShipping.size()-------->'+mapShipping.size());
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 2: marshall accounts to geoaddresses
                /////////////////////////////////////////////////////////////////////////////////////////////       
                //Add the Billing and Shipping addresses to the GeoAddresses collection
                System.debug('----------SCRIPT STATEMENTS (indexing account: trigAccountGeoValidation)---------->'+Limits.getScriptStatements());
                Geography.GeoAddresses geoAddresses = new Geography.GeoAddresses();
                geoAddresses.addSObjectMap(mapBilling, false);  //add primary addresses
                geoAddresses.addSObjectMap(mapShipping, true);  //add secondary addresses    
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 3: Lookup Country and State in Geography Object
                /////////////////////////////////////////////////////////////////////////////////////////////
                geoAddresses.getCountryStateInfos();
                System.debug('----------SCRIPT STATEMENTS---------->'+Limits.getScriptStatements());
                
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 4: Write the Geoaddresses Back to Account,  and Return error for Invalid addresses
                /////////////////////////////////////////////////////////////////////////////////////////////
                //Note:  The Maps to accounts in mapShipping and mapBilling is by reference so a change to 
                // the mapShipping account is also a change to the mapBilling account.  This allow the overlay
                // of updates to both shipping and billing addresses below via writeTo().
                
                integer s=0;
                integer b=0;
                for (Geography.GeoAddress ga : geoAddresses.getMap().values()) {
                    
                    if (ga.CountryInfo != null) {
                        //write back to acccount
                        if (ga.address.secondary) {
                            ga.writeTo(mapShipping.get(ga.key),ga.address.secondary);
                            s++;
                        }
                        else {
                            ga.writeTo(mapBilling.get(ga.key),ga.address.secondary);
                            b++;
                        }
                    }
                    else {
                        if (ga.address.secondary) 
                            //<Santhosh20160123> IS ID-00077732 : Modified the static Country validation error message for capturing the Country value.
                            mapShipping.get(ga.key).Country__c.AddError(geoValidation.GetErrormessage(mapShipping.get(ga.key).Country__c));
                        else
                            mapBilling.get(ga.key).Country__c.AddError(geoValidation.GetErrormessage(mapBilling.get(ga.key).Country__c));
                            //<Santhosh20160123> : End.

                    }
                } //next ga 
                System.debug('----------SCRIPT STATEMENTS---------->'+Limits.getScriptStatements());
             //Geography.ClearCache();
            System.debug('----Billing writeTo cnt-------->'+b);
            System.debug('----BShipping writeTo cnt-------->'+s);
            }
        }
    }// end geoValidateAccount()
    
    
    
    
    //TES20130422 : moved logic from trigContactGeoValidation
    //Fire on Before Insert/Update
    public static void geoValidateContact() {   
    
        if ( GeoValidationDisabled() ) {
        //trigger disabled
        system.debug('Trigger Disabled.');
    }
    else {
  
        /////////////////////////////////////////////////////////////////////////////////////////////
        //  STEP 1: Index accounts and marshall contacts to geoaddresses
        /////////////////////////////////////////////////////////////////////////////////////////////
            MAP<id, contact> mapContacts = new MAP<Id, contact>();   //map of accounts with mailing Addresses 
            for(Integer index=0; index<Trigger.size; index++ ) {
                Contact c=(Contact) Trigger.new[index];
                if ( Trigger.isInsert                                                       || 
                        c.contact_country__c    != ((Contact) Trigger.old[index]).contact_country__c    ||
                        c.mailingstate          != ((Contact) Trigger.old[index]).mailingstate  
                    )   {
                    id contactId = (Trigger.isInsert) ? GeoValidation.genID(index) : c.id;
                    if (c.MailingState != null) mapContacts.put(contactId,c);
                    else {
                        //No state,  lets make sure we have a country
                        if ( c.contact_country__c!=null || c.MailingCountry!=null ) 
                            mapContacts.put(contactId,c);
                        else {
                            //Do Nothing country not required for contacts
                            //a.Country__c.AddError(geoValidation.ERR_NULL_COUNTRY);
                        }
                    }
                }
            }
            
            if ( mapContacts.size()>0 ) {
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 2: marshall contacts to geoaddresses
                ///////////////////////////////////////////////////////////////////////////////////////////// 
                Geography.GeoAddresses geoAddresses = new Geography.GeoAddresses();
                geoAddresses.addSObjectMap(mapContacts, false);  //add primary addresses
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 3: Lookup Country and State in Geography Object
                /////////////////////////////////////////////////////////////////////////////////////////////
                geoAddresses.getCountryStateInfos();

                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 4: Write the Geoaddresses Back to the Contacts,  and Return error for invalid Country
                /////////////////////////////////////////////////////////////////////////////////////////////
                    for (Geography.GeoAddress ga : geoAddresses.getMap().values()) {
                        if (mapContacts.get(ga.key).Contact_Country__c!=null && ga.countryInfo==null)
                        //<Santhosh20160123> IS ID-00077732 : Modified the static Country validation error message for capturing the Country value.
                        mapContacts.get(ga.key).Contact_Country__c.AddError(geoValidation.GetErrormessage(mapContacts.get(ga.key).Contact_Country__c));
                        //<Santhosh20160123> : End
                        else
                            ga.writeTo(mapContacts.get(ga.key),ga.address.secondary);
                    } //next ga 
                
                //No longer clearing cache since trigger backend will run a batch of
                //200 twice, 100 each, the static vars will remain in scope for both calls,  
                //by clearing the cache it will make additional geocaching calls that cause 
                //'Too many query rows' gov limit error.
                //Geography.ClearCache();
            }
    } 
    // end geoValidateAccount()
}
    
}
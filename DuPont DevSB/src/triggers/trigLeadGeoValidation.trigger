/*******************************************************************************
(C)2008 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Validate and scrub Country and State/Providence 

********************************************************************************/
trigger trigLeadGeoValidation on Lead (before insert, before update)  {

    if ( GeoValidation.GeoValidationDisabled() ) {
        //trigger disabled
        system.debug('Trigger Disabled.');
    }
    else {
        /////////////////////////////////////////////////////////////////////////////////////////////
        //  STEP 1: Index accounts and cast contacts to geoaddresses
        /////////////////////////////////////////////////////////////////////////////////////////////
            MAP<id, Lead> mapLeads = new MAP<Id, Lead>();   //map of accounts with mailing Addresses 
            for(Integer index=0; index<Trigger.size; index++ ) {
                Lead l=Trigger.new[index];
                if ( Trigger.isInsert                                               || 
                        l.lead_country__c   != Trigger.old[index].lead_country__c   ||
                        l.state             != Trigger.old[index].state     
                    )   {
                    id LeadId = (Trigger.isInsert) ? GeoValidation.genID(index) : l.id;
                    if (l.State != null) 
                        mapLeads.put(LeadId,l);
                    else {
                        //No state,  lets make sure we have a country
                        if ( l.Lead_country__c!=null || l.Country!=null ) 
                            mapLeads.put(LeadId,l);
                        else {
                            //Do Nothing country not required for Leads
                            //l.Lead_country__c.AddError(geoValidation.ERR_NULL_COUNTRY);
                        }
                    }
                }
            }
            if ( mapLeads.size()>0 ) {
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 2: marshall leads to geoaddresses
                ///////////////////////////////////////////////////////////////////////////////////////////// 
                Geography.GeoAddresses geoAddresses = new Geography.GeoAddresses();
                geoAddresses.addSObjectMap(mapLeads, false);  //add primary addresses
                
                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 3: Lookup Country and State in Geography Object
                /////////////////////////////////////////////////////////////////////////////////////////////
                geoAddresses.getCountryStateInfos();

                /////////////////////////////////////////////////////////////////////////////////////////////
                //  STEP 4: Write the Geoaddresses Back to Lead,  and Return error for Invalid Country
                /////////////////////////////////////////////////////////////////////////////////////////////
                    for (Geography.GeoAddress ga : geoAddresses.getMap().values()) {
                        Lead l=mapLeads.get(ga.key);
                         if (ga.address.country != null && ga.CountryInfo == null) {
                            //Do not error when from Web2Lead and invalid country on Lead_Country__c
                            if ( l.Origin_Channel_Type__c!=null && l.Origin_Channel_Type__c.toLowerCase().startswith('website')) {
                                ga.writeTo(l,false);
                                l.Country=l.Lead_Country__c;
                                l.Lead_Country__c=null;
                            }
                            else{
                                    //<Santhosh20160123> IS ID-00077732 : Modified the static Country validation error message for capturing the Country value.
                                    l.Lead_Country__c.AddError(geoValidation.GetErrormessage(l.Lead_Country__c));
                                    //<Santhosh20160123> : End
                                }
                         }
                        else
                            ga.writeTo(l,ga.address.secondary);
                            
                    } //next ga 
                    
                //No longer clearing cache since trigger backend will run a batch of
                //200 twice, 100 each, the static vars will remain in scope for both calls,  
                //by clearing the cache it will make additional geocaching calls that cause 
                //'Too many query rows' gov limit error.
                //Geography.ClearCache();
            }
    } 

}  //End trigger

/*

V 1.0:

trigger trigLeadGeoValidation on Lead (before insert, before update) {

    for (Lead l : Trigger.new ) {   
        Geography.GeoAddress ga = new Geography.GeoAddress(l);
        if (ga.address.country != null) {
            ga.resolveCountry();
            if (ga.getCountryInfo() == null) 
                l.Lead_Country__c.AddError(Geography.ERR_INVALID_COUNTRY);
            else 
                ga.writeTo(l);
            }
        }

}

*/
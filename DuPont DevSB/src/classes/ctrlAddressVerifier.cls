/*******************************************************************************
(C)2008 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  controller for AddressVerifier
 ********************************************************************************/

public with sharing class ctrlAddressVerifier {

	//Private globals       
	private sObject Obj;                                                                    //Current Object        
	private Geography.GeoAddresses GeoAddresses;                    //Geocode Results
	private boolean onSave;                                                                 //SAVE callback
	private Geography.GeoAddress GeoAddress;                                //Selected Result and Address to save.

	//Public globals
	public Integer callnum {set;get;}                                               //used for debugging callback order
	public List<SelectOption> countryPicklist {set; get;}     //country drop down
	public String objectId {set;get;}                                               //Object Id (Lead,Account,Contact) to verfify
	public boolean useSecondaryAddress {set;get;}                   //use shipping for Account or other for contact
	public Geography.GeoAddress currAddress{set;get;}               //Address to geocode    
	public String searchError {set; get;}                                       //error to display to user.                                     
	public String selectedGeoAddress {set; get;}                        //Id of currently selected GeoAddresses (Geocode Results)
	public String AccuracyDesc {set; get;}                                  //description of Accuracy to show user

	//Debug info
	public boolean Debug {set; get;}                                                //show debug info
	public String geocodeProvider {set; get;}                               //name of geocode provide
	public String geocodeResponse {set; get;}                               //geocode response
	public String geocodeRequest {set; get;}                                //geocode request
	public String geocodeEndPoint {set; get;}                               //geocode endpoint
	public Long geocodeTime {set; get;}                                             //geocode response time (ms)


	////////////////////////////////////////////////////////////////////////////////////////////////  

	/********************************************************************************************   
//      PRIVATE METHODS
	 ********************************************************************************************/   
	////////////////////////////////////////////////////////////////////////////////////////////////  
	//  CAN Postalcodes returned via the Geocode Providers (google and mapquest) only return the 
	// First 3 chars.  this function will replace the postal code in the goeaddress to the search address if 
	// the first 3 chars match.
	private void FixPostalCodes() {
		for ( Geography.GeoAddress ga : GeoAddresses.getMap().values() ) {
			ga.address.PostalCode = Geography.Utility.scrubPostalCode(currAddress.address.PostalCode,ga.address.PostalCode,ga.address.Country);
		}
	}       

	////////////////////////////////////////////////////////////////////////////////////////////////       
	private void clearResults() {
		selectedGeoAddress=null;
		GeoAddresses=null;
		GeoAddress=null;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////        

	private List<SelectOption> getCountryPicklist() {
		countryPicklist = new List<SelectOption>();
		Geography.Countries gc = new Geography.Countries();
		//Convert to list for sorting
		List<String> cs = new List<String>(gc.getMap().keyset());
		cs.sort();
		countryPicklist.add(new SelectOption('', '--None--'));
		for (String c : cs)
			countryPicklist.add(new SelectOption(c.toUpperCase(), c));
		return countryPicklist;
	}       



	////////////////////////////////////////////////////////////////////////////////////////////////        

	/********************************************************************************************   
//      PUBLIC METHODS
	 ********************************************************************************************/   
	public string getObjectName() {
		return (string) obj.get('Name');
	}
	////////////////////////////////////////////////////////////////////////////////////////////////     

	public Geography.GeoAddress[] getGeoAddresses() {
		if (GeoAddresses == null) return null;
		else return GeoAddresses.getMap().values();
	} 
	////////////////////////////////////////////////////////////////////////////////////////////////  
	public Integer getResultCount() {
		if ( GeoAddresses == null ) return 0;
		else return GeoAddresses.size();
	}
	////////////////////////////////////////////////////////////////////////////////////////////////  
	public Geography.GeoAddress getGeoAddress()
	{       
		try {
			GeoAddress=GeoAddresses.getGeoAddress(Integer.valueOf(selectedGeoAddress));
			Geography.IGeocodeProvider gcp = (geocodeProvider==null) ? Geography.getProvider() : Geography.getProvider(geocodeProvider);
			try { AccuracyDesc=gcp.getAccuracyDesc(GeoAddress.Accuracy); }
			catch (Exception e){ AccuracyDesc=''; }
		}
		catch (Exception  e) {
			GeoAddress = new Geography.GeoAddress();
		}
		callnum++;
		system.Debug('getGeoAddress.selectedGeoAddress('+callnum+')---------------------------->'+selectedGeoAddress);
		system.Debug('getGeoAddress.GeoAddress('+callnum+')---------------------------->'+GeoAddress);
		return GeoAddress;
	}


	////////////////////////////////////////////////////////////////////////////////////////////////  
	public void     setGeoAddress(Geography.GeoAddress ga)
	{       
		if ( onSave )   GeoAddress=ga;
		callnum++;
		system.Debug('setGeoAddress.selectedGeoAddress('+callnum+')---------------------------->'+selectedGeoAddress);
		system.Debug('setGeoAddress.GeoAddress('+callnum+')---------------------------->'+GeoAddress);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////  

	//Used when Object has more then one  addresses,  this will allow users
	//to choose which one.
	public  List<SelectOption> getRadioAddress() {
		List<SelectOption> rtn = new List<SelectOption>();
		if ( objectId != null ) {
			if (objectId.startsWith('001')) {
				rtn.add(new SelectOption('false',Label.av_BillingAddress));
				rtn.add(new SelectOption('true',Label.av_ShippingAddress));
			}
			if (objectId.startsWith('003')) {
				rtn.add(new SelectOption('false','Mailing Address'));
				rtn.add(new SelectOption('true','Other Address'));
			}       
		}       
		return rtn;
	}

	/********************************************************************************************   
//      E V E N T S
	 ********************************************************************************************/
	public PageReference init() {


		//get Querystring params
		objectId = ApexPages.currentPage().getParameters().get('id');
		useSecondaryAddress = ( ApexPages.currentPage().getParameters().get('sec')== '1' ) ? true : false;
		debug = ( ApexPages.currentPage().getParameters().get('debug')== '1' ) ? true : false;
		geocodeProvider = ApexPages.currentPage().getParameters().get('prov');
		boolean autoVerify = (ApexPages.currentPage().getParameters().get('a')=='1') ? true : false;

		system.debug('------------init().ObjectId: '+objectId );
		callnum=0;
		onSave=false;

		Obj = Geography.Utility.getGeoDataById(objectId);
		currAddress = ( Obj != null ) ? new Geography.GeoAddress(Obj, useSecondaryAddress) : new Geography.GeoAddress();
		if (Obj == null) Obj = new Account();


		getCountryPicklist();

		if (autoVerify)  
			return Verify();
		else 
			return null;
	}  


	////////////////////////////////////////////////////////////////////////////////////////////////  
	public PageReference updateCurrentAddress() {
		currAddress = new Geography.GeoAddress(Obj,useSecondaryAddress);
		clearResults();
		return null;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////
	public PageReference Verify() {

		datetime st, et;
		searchError='';
		st=datetime.now();

		clearResults();

		//get results
		Geography.IGeocodeProvider gcp = (geocodeProvider==null) ? Geography.getProvider() : Geography.getProvider(geocodeProvider);    
		Geography.GeoCodeResults gcr = Geography.geocode(currAddress.address,gcp);

		et=datetime.now();
		geocodeTime=et.getTime()-st.getTime();

		if (debug) {
			try {
				geocodeProvider=gcp.getProviderName();
				geocodeRequest=gcp.getHttpRequest().getBody();
				geocodeEndPoint=gcp.getHttpRequest().getEndpoint();
				geocodeResponse=gcp.getHttpResponse().getBody();
			}
			catch(exception ex) {}
		}

		if ( gcr.success ) {
			GeoAddresses = gcr.GeoAddresses;
			system.Debug('GCR-->'+gcr);
			callnum++;
			system.Debug('Verify.GeoAddresses('+callnum+')------------------>'+GeoAddresses);
			if (GeoAddresses.size() == 0 )  {
				searchError='Error: Cannot Parse Result. ' + gcr.Message;
				GeoAddresses=null;
			}
			else {
				searchError=null;
				//Post process operations for all addresses
				//GeoAddresses.resolveCountryInfo();  //gets the country details+Region/Subregion
				//GeoAddresses.resolveCountyInfo();     //gets fips
				GeoAddresses.resolveAll();
				FixPostalCodes();                                       //chooses best zipcode (most granual between orig/new)

				if (GeoAddresses.size() == 1 )  {
					selectedGeoAddress='0';      
				}
				else {
					if (GeoAddresses.size() >= 10 ) 
						searchError='Warning:  The maximum of 10 results have been reached, you may need to refine you search.';
				}
			}
		}
		else
			searchError=gcr.message;        

		return null;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	public PageReference unselectGeoAddress() {
		selectedGeoAddress=null;
		return null;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////         
	public PageReference selectGeoAddress() {
		system.debug('invoking: Select');
		system.debug(selectedGeoAddress);
		GeoAddress=GeoAddresses.getGeoAddress(Integer.valueOf(selectedGeoAddress));
		Geography.IGeocodeProvider gcp = (geocodeProvider==null) ? Geography.getProvider() : Geography.getProvider(geocodeProvider);
		try { AccuracyDesc=gcp.getAccuracyDesc(GeoAddress.Accuracy); }
		catch (Exception e){ AccuracyDesc=''; }
		gcp=null;
		return null;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////   
	public PageReference Save() {

		onSave=true;
		system.debug(Obj);
		searchError='';
		PageReference page;

		try {
			GeoAddress.writeto(Obj,useSecondaryAddress);

			/*
                                THIS DOES NOT WORK (went back to using Ajax callback.)
                        //as of v.15 we can set the assignmentRuleHeader via APEX
                        //this illiminates the need for a Ajax callback.
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule=true;
                        Obj.setOptions(dmo);
                        system.debug(dmo);
			 */

			update Obj;

			/* (went back to using Ajax callback.)
                        page = new PageReference('/'+objectId );
                        page.setRedirect(true);
			 */
		}
		catch (exception ex) {
			page=null;
		}
		return null;

		//return page;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////// 

	public PageReference Done() {
		PageReference page = new PageReference('/'+objectId );
		page.setRedirect(true);
		return page;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////// 

/********************************************************************************************   
//      TEST METHODS
 ********************************************************************************************
    private static void testController(){
        ctrlAddressVerifier controller = new ctrlAddressVerifier();
        controller.init();
        controller.getObjectName();
        controller.getRadioAddress();                   //diff for each sobject type
        controller.updateCurrentAddress();              //gets the current address

        controller.getGeoAddresses(); 
        controller.getResultCount();
        controller.getGeoAddress();
        controller.Verify();

        controller.getGeoAddresses(); 
        controller.getResultCount();
        controller.setGeoAddress(controller.getGeoAddress());

        controller.selectedGeoAddress='0';
        controller.selectGeoAddress();
        controller.unselectGeoAddress();
        controller.selectedGeoAddress='0';
        controller.Save();
        controller.Done();
    }

    //////////////////////////////////////////////////////////////////////////////////////////////// 

    public static testMethod void testAddressVerifier_Account() {

        account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;

        Test.startTest();
        Geography.IS_TESTMETHOD = true;

        PageReference pageRef = Page.AddressVerifier;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(a.id));

        testController();

        Test.stopTest();
    }   
    //////////////////////////////////////////////////////////////////////////////////////////////// 

    public static testMethod void testAddressVerfier_Lead() {

        Lead l = new Lead(lastname='test', Company='test',Street='14 Main St',PostalCode='19711', Lead_Country__c='United States');
        insert l;

        Test.startTest();
        Geography.IS_TESTMETHOD = true;

        PageReference pageRef = Page.AddressVerifier;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(l.id));
        ApexPages.currentPage().getParameters().put('a', '1');
        testController();

        Test.stopTest();
    }   
    //////////////////////////////////////////////////////////////////////////////////////////////// 

    public static testMethod void testAddressVerfier_Contact() {
        //Geography.testMapCountriesCache();  //just get a subset of countries
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        Contact c = new Contact(lastname='test', Account=a,MailingStreet='14 Main St',MailingPostalCode='19711', Contact_Country__c='United States');
        insert c;

        Test.startTest();
        Geography.IS_TESTMETHOD = true;

        PageReference pageRef = Page.AddressVerifier;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(c.id));
        ApexPages.currentPage().getParameters().put('debug', '1');

        testController();

        Test.stopTest();
    }   
}
 */

/********************************************************* 
example API Call HttpRequest ... (could not get this to work..needs more testing)

public string Partner_Server_URL {set;get;} 


private void refreshTerritoryRule() {
        string str='<?xml version="1.0" encoding="utf=8"?>';
        str=+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:m0="urn:sobject.partner.soap.sforce.com">';
        str=+'<SOAP-ENV:Header><m:SessionHeader xmlns:m="urn:partner.soap.sforce.com"><m:sessionId>'+UserInfo.getSessionId()+'</m:sessionId></m:SessionHeader>';   
        str=+'<m:AssignmentRuleHeader xmlns:m="urn:partner.soap.sforce.com"><m:useDefaultRule>true</m:useDefaultRule></m:AssignmentRuleHeader>';                
        str=+'</SOAP-ENV:Header>';
        str=+'<SOAP-ENV:Body><m:update xmlns:m="urn:partner.soap.sforce.com"><m:sObjects><m0:type>Account</m0:type><m0:Id>'+objectId+'</m0:Id></m:sObjects></m:update></SOAP-ENV:Body>';
        str=+'</SOAP-ENV:Envelope>';


        HttpRequest req=new HttpRequest();
        req.setEndPoint(Partner_Server_URL);
        req.setHeader('Content-Type','text/xml');
        req.setBody(str);
        req.setMethod('POST');
        Http http=new Http();

        system.debug(str);
        //HttpResponse res=http.send(req);

        //System.debug(res.getBody());
}
 **/

/***    
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:m0="urn:sobject.partner.soap.sforce.com">
        <SOAP-ENV:Header>
                <m:SessionHeader xmlns:m="urn:partner.soap.sforce.com">
                        <m:sessionId>String</m:sessionId>
                </m:SessionHeader>
                <m:CallOptions xmlns:m="urn:partner.soap.sforce.com">
                        <m:client>String</m:client>
                        <m:defaultNamespace>String</m:defaultNamespace>
                </m:CallOptions>
                <m:AssignmentRuleHeader xmlns:m="urn:partner.soap.sforce.com">
                        <m:assignmentRuleId></m:assignmentRuleId>
                        <m:useDefaultRule>true</m:useDefaultRule>
                </m:AssignmentRuleHeader>
                <m:MruHeader xmlns:m="urn:partner.soap.sforce.com">
                        <m:updateMru>true</m:updateMru>
                </m:MruHeader>
                <m:DebuggingHeader xmlns:m="urn:partner.soap.sforce.com">
                        <m:debugLevel>None</m:debugLevel>
                </m:DebuggingHeader>
                <m:EmailHeader xmlns:m="urn:partner.soap.sforce.com">
                        <m:triggerAutoResponseEmail>true</m:triggerAutoResponseEmail>
                        <m:triggerOtherEmail>true</m:triggerOtherEmail>
                        <m:triggerUserEmail>true</m:triggerUserEmail>
                </m:EmailHeader>
        </SOAP-ENV:Header>
        <SOAP-ENV:Body>
                <m:update xmlns:m="urn:partner.soap.sforce.com">
                        <m:sObjects>
                                <m0:type>String</m0:type>
                                <m0:fieldsToNull>String</m0:fieldsToNull>
                                <m0:Id>aaaaaaaaaaaaaaaaaa</m0:Id>
                        </m:sObjects>
                </m:update>
        </SOAP-ENV:Body>
</SOAP-ENV:Envelope>              
 ***/
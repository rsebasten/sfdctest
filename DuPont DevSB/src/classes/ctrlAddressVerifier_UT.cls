/**
 * Merge&Spin - Removed (seealldata=true)
 * 
 * */
@isTest
private class ctrlAddressVerifier_UT {
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
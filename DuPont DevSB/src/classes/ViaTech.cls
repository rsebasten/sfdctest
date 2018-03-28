/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Core class for ViaTech

Contact: Suzette Wood <swood@viatechpub.com> 1(585) 344.8343 x237 
    http://www2.viatechpub.com/cgi-bin/jsmsecure?getOrderNumbers+startDate(2012-11-01)+endDate(2012-11-30)
    http://www2.viatechpub.com/cgi-bin/jsmsecure?getCXML+ORDER(1600759)

    TODOs:  Https/with Basic; LeadRtype, OptIn field, Subject Field, Phone, and Name/Company.

TES20130225 added Mapping: l.BU_Answer6__c = oreq.extrinsics.get('OrderEnteredBy'); 
TES20130603 BI-> 1DD migration (many mapping changes)
    see issue https://na13.salesforce.com/a02a000000JZG50 for details
TES20130812 If Country is null replace with 'United States'
TES20140220 add try catch to getOrderRequestIndex() to stop thowing an exception in 
    scheduled batch when there were no requests to process; increase callout timout to 2 min
 ********************************************************************************/
public with sharing class ViaTech {

	private static final string ADMIN_EMAIL         = 'abhinav.bhatnagar@dupont.com';//'thomas.snyder@usa.dupont.com'; //andrew.nass@dupont.com thomas.snyder@usa.dupont.com
	private static final string CRYPAUTH            = 'RHVwb250U3VyZmFjZXM6YzByaUBuWm9kMUBR';//DupontSurfaces:c0ri@nZod1@Q  
	private static final string ViaTech_BASEURL     = 'https://www2.viatechpub.com/cgi-bin/jsmsecure';
	public static final integer DAYS_OF_BACKLOG     = 20; //number of days to go back and pull the index
	public static final string CATALOG              = 'BI-NA ViaTech Samples';
	public static final integer TIMEOUT             = 120000;  //2m


	public  static string TEST_INDEX_PAYLOAD = '';
	public  static string TEST_ORDER_PAYLOAD = '';

	public static final string LEAD_RTYPE           = Rtype.getIdByDevName('Lead','Level_2_BI_NA');  
	public static final string REQUEST_RTYPE        = Rtype.getIdByDevName('Request__c','BI_NA_Sample_Request');
	public static final string REQUESTITEM_RTYPE    = Rtype.getIdByDevName('Request_Item__c','SalesAidRequestItem');    

	//REST: ViaTech_BASEURL?svc=getCXML&order=<filename>
	public static SET<string> getOrderRequestIndex() { return getOrderRequestIndex(null,null); }
	public static SET<string> getOrderRequestIndex(date startDT, date endDT) {
		SET<string> rtn = new SET<string>();
		if (endDT==null) endDT=Date.today().addDays(1);
		if (startDT==null) startDT=endDT.addDays(-DAYS_OF_BACKLOG);

		string endpoint=ViaTech_BASEURL+'?getOrderNumbers+startDate('+Util.DatetoXml(startDT)+')+endDate('+Util.DatetoXml(endDT)+')';
		HttpResponse resp = sendRequest(endpoint);
		dom.Xmlnode root;
		try {
			if ( Test.isRunningTest() ) {
				dom.Document xmldoc = new dom.Document();
				xmldoc.load(TEST_INDEX_PAYLOAD);
				root = xmldoc.getRootElement();
			}
			else
				root = resp.getBodyDocument().getRootElement();

			for (dom.Xmlnode file : root.getChildElements())
				if (file.getname()=='file')
					rtn.add(file.getText().replace('.XML',''));
			return stripExistingRequests(rtn);
		} catch(Exception ex) {
			return rtn;
		}
	}

	//REST: ViaTech_BASEURL?svc=getCXML&order=<filename>
	public static CXML.OrderRequest getOrderRequest(string filename) {
		string endpoint=ViaTech_BASEURL+'?getCXML+ORDER('+filename+')';
		CXML.OrderRequest oreq;
		HttpResponse resp;
		try {
			resp = sendRequest(endpoint);
			string payload;
			if ( Test.isRunningTest() )
				payload = TEST_ORDER_PAYLOAD;
			else
				payload=resp.getBody();

			oreq = new CXML.OrderRequest(payload);
			system.debug(oreq);
			saveOrderRequest(oreq);
		}
		catch (Exception ex) {
			string msg = String.format('Endpoint:\n\n{0}\n\nResponse:\n\n{1}\n\n\nException:\n\n{2}', new string[]{ endpoint,String.valueOf(resp),String.valueOf(ex) });
			simpleEmail(ADMIN_EMAIL , 'Error: In BI - ViaTech.getOrderRequest()', msg );
		}
		system.debug(oreq);
		return oreq;
	}


	/*
        public string name {set; get;}
        public string deliverTo {set; get;} 
        public string street {set; get;}
        public string city {set; get;}
        public string state {set; get;}
        public string postalCode {set; get;}
        public string country {set; get;}
        public string isoCountryCode {set; get;}

	 */  
	private static void saveOrderRequest(CXML.OrderRequest oreq) {


		string company = 'Not Provided';
		company=(String.isBlank(oreq.shipToAddress.name)) ? 'Not Provided' : oreq.shipToAddress.name;


		string firstname;
		string lastname = 'undefined';      
		if (!String.isBlank(oreq.extrinsics.get('LastName'))) {
			firstname   = oreq.extrinsics.get('FirstName');
			lastname    = oreq.extrinsics.get('LastName');
		}
		else {
			String[] names=oreq.shipToAddress.deliverTo.split(' ');
			if (names.size()>1) {
				firstname=names[0];
				lastname=(String.isBlank(names[1])) ? 'undefined' : names[1];
			}
			else
				lastname=(String.isBlank(oreq.shipToAddress.deliverTo)) ? 'undefined' : oreq.shipToAddress.deliverTo;

		}       

		Lead l = new Lead (
				firstname               = firstname,
				lastname                = lastname,
				company                 = company,
				RecordTypeId            = LEAD_RTYPE,
				Origin_Channel_Type__c  = 'Website',
				Status                  = 'Capture',
				Owning_Organization__c  = 'BI-Surf',
				Preferred_Language__c   = 'ENGLISH',
				Type__c                 = 'Product Sample'
				);


		oreq.shipToAddress.postalAddress.writeTo(l);

		if (oreq.extrinsics.get('OptIn')!=null)
			l.Opt_in__c             = (Util.stringToBoolean(oreq.extrinsics.get('OptIn'))); 
		if (oreq.extrinsics.get('Email')!=null)
			l.email                 = Util.stringToEmail(oreq.extrinsics.get('Email'));
		if (oreq.orderDate!=null)
			l.Description = oreq.orderDate.formatLong();            

		l.Lead_Country__c           = oreq.extrinsics.get('Country');
		if (!String.isBlank(l.Lead_Country__c))
			l.Lead_Country__c = 'United States';

		l.phone                     = oreq.extrinsics.get('Phone');
		l.Purchasing_Timing__c      = oreq.extrinsics.get('ProjectTiming');
		l.Market_Segment__c         = oreq.extrinsics.get('MarketSegment');
		l.Origin_Name__c            = oreq.extrinsics.get('CustomerType');
		l.Application_Type__c       = oreq.extrinsics.get('CustomerType');
		l.BI_Account_SubType__c     = oreq.extrinsics.get('CompanyType');
		l.Product_Comments__c       = oreq.extrinsics.get('Comments');
		l.S_P_Product__c            = oreq.extrinsics.get('Product');
		l.BU_Question1__c           = 'Would you like to be contacted about your project?';
		l.BU_Answer1__c             = oreq.extrinsics.get('ContactAboutProject');   
		l.BU_Question2__c           = 'Do you have a current project?';
		l.BU_Answer2__c             = oreq.extrinsics.get('ProjectStatus');
		l.BU_Question6__c           = 'Order Entered By';           
		l.BU_Answer6__c             = oreq.extrinsics.get('OrderEnteredBy');
		if (!String.isBlank(l.BU_Answer6__c))
			l.Origin_Channel_Type__c = 'Phone';

		if (oreq.extrinsics.get('CustomerType')=='commercial') {
			l.BU_Question3__c       = 'Project City/State';
			l.BU_Answer3__c         = oreq.extrinsics.get('ProjectCityState');  
			l.Subject__c            = oreq.extrinsics.get('ProjectName');   
			l.Product_Details__c    = oreq.extrinsics.get('ProjectDetails');
			l.BU_Question4__c       = 'Lead Architect/Project Manager';  
			l.BU_Answer4__c         = oreq.extrinsics.get('LeadArchitect');         
		}
		else {
			//Residential
			l.BU_Question4__c       = 'Type of Project';
			l.BU_Answer4__c         = oreq.extrinsics.get('ProjectType');
			l.company               = 'Not Provided';
		}

		try {
			string description = 'Order#: '+oreq.orderId+'\n';
			description+='Order Date: '+oreq.orderDate.formatLong()+'\n';
			description+='[Code] | [Description] | [Quantity]\n';
			for (CXML.Item i : oreq.items.values())
				description+=i.supplierPartID+' | '+i.description+' | '+i.quantity+'\n';        
			l.Description           = description;
		} catch(Exception ex){}

		//Set DMLOption to fire Assignment Rule
		Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule=true;
		l.setOptions(dmo);

		insert l;

		//Request
		Request__c r = new Request__c(Lead__c=l.id);
		r.Request_Shipping_Street__c=oreq.shipToAddress.Street;
		r.Request_Shipping_City__c=oreq.shipToAddress.City;
		r.Request_Shipping_State__c=oreq.shipToAddress.State;
		r.Request_Shipping_Postal_Code__c=oreq.shipToAddress.PostalCode;
		r.Request_Shipping_Country__c=oreq.shipToAddress.Country;
		r.Order_Nb__c=oreq.orderId;
		if (oreq.orderDate!=null)
			r.Issue_Date__c=oreq.orderDate.date();
		r.ExternalRequestId__c=oreq.items.values()[0].supplierPartAuxiliaryID;
		r.Stage__c='Completed';
		r.Status__c='Completed';
		r.recordtypeid=REQUEST_RTYPE;
		insert r;

		//Request Items
		MAP<string,string> cat=getCatalog();
		LIST<Request_Item__c> items = new LIST<Request_Item__c>();
		for (CXML.Item i : oreq.items.values()) {
			Request_Item__c reqitem = new Request_Item__c(Request__c=r.id);
			reqitem.Quantity__c = Util.stringToDecimal(i.Quantity);
			reqitem.Unit_of_Measure__c=i.unitOfMeasure;
			reqitem.recordtypeid=REQUESTITEM_RTYPE;
			string catitem = i.supplierPartID;
			system.debug('CatalogItem Code:'+catitem);
			if (cat.containsKey(catitem)) {
				reqitem.Catalog_Item__c=cat.get(catitem);
			}
			reqitem.Response__c=string.valueOf(i);
			reqitem.Stage__c='Completed';
			reqitem.Status__c='Completed';
			items.add(reqitem);
		}
		insert items;


	}


	public static HttpResponse sendRequest(string endPoint) {
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setTimeout(TIMEOUT);
		request.setHeader('Content-Type','application/xml; charset=utf-8');
		system.debug('header:Content-Type = '+request.getHeader('Content-Type'));
		request.setHeader('Authorization','Basic '+CRYPAUTH);
		//system.debug('header:Authorization = '+request.getHeader('Authorization'));
		request.setEndpoint(endPoint);

		system.debug('----OUTBOUND PAYLOAD---->'+request.getBody());
		Http http = new http();
		HttpResponse response;
		try {
			response = http.send(request);
			system.debug('----Response PAYLOAD---->'+response.getBody());
			if ( response.getStatusCode()!=200 ) {
				string msg = String.format('Request:\n\n{0}\n\n\n\nResponse:\n\n{1}\n\n\n', new string[]{ String.valueOf(request),String.valueOf(response)});
				simpleEmail(ADMIN_EMAIL , 'Error: '+response.getStatus()+' (BI - ViaTech.SendRequest)', msg );
			}
		}
		catch (exception ex) {
			system.debug('HTTP ERROR: '+ex);
			string msg='test';
			if ( !Test.isRunningTest() ) {
				msg = String.format('Request:\n\n{0}\n\n\n\nResponse:\n\n{1}\n\n\nException:\n\n{2}', new string[]{ String.valueOf(request),String.valueOf(response),String.valueOf(ex) });
				simpleEmail(ADMIN_EMAIL , 'Error: '+ex+' (BI - ViaTech.SendRequest)', msg );
			}
		}
		return response;
	} 

	private static LIST<Messaging.SendEmailResult> simpleEmail(string to ,string subject, string msg ) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		if  (to.indexOf(',')==-1)
			mail.setToAddresses(new String[] { to });
		else
			mail.setToAddresses(to.split(','));
		mail.setSubject(subject);
		mail.setPlainTextBody(msg);
		return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}   

	private static MAP<string,string> getCatalog() {
		MAP<string,string> rtn = new MAP<string,string>();
		for (Catalog_Item__c ci : [
		                           Select Id, Name, Catalog_Item_Name__c 
		                           from Catalog_Item__c 
		                           where Catalog__r.Name=:CATALOG ]) {
			rtn.put(ci.Name.toUpperCase(),ci.Id);
		}
		return rtn;
	}

	public static SET<string> stripExistingRequests(SET<string> feedIds) {
		SET<string> existingIds = new SET<string>();
		for (Request__c r : [Select ExternalRequestId__c FROM Request__c where ExternalRequestId__c in: feedIds ])
			existingIds.add(r.ExternalRequestId__c);
		system.debug(feedIds.size());
		system.debug(existingIds.size());
		feedIds.RemoveAll(existingIds);
		system.debug(feedIds.size());
		return feedIds;
	}


}
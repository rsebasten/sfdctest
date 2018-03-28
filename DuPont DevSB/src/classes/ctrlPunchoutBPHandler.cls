/***************************************************************************************
This controller is used to handle the Punchout BrowerPost  
***************************************************************************************/
public class ctrlPunchoutBPHandler {

    public string cxml{get; set;}
    public boolean showResponse {get; set;}
    public string headers {get; set;}

    public PageReference init() {
    	showResponse=false;
    	if ( ApexPages.currentPage().getParameters().get('cxml-urlencoded') != null ) {
        	cxml = ApexPages.currentPage().getParameters().get('cxml-urlencoded');
    	}
       else if ( ApexPages.currentPage().getParameters().get('cxml-base64') != null ) {
       		cxml = ApexPages.currentPage().getParameters().get('cxml-base64');
        	cxml = EncodingUtil.base64Decode(cxml).toString();

       }
		else {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Invalid POST parameter.  Must be cxml-urlencoded or cxml-base64.'));
			return null;
		}
        
    	//show debug screen
    	if (ApexPages.currentPage().getParameters().get('debug') != null) {
			MAP<string, string> hdrs = ApexPages.currentPage().getheaders();
        	for (string key : hdrs.keySet() )
           		 headers += key + ' : ' + hdrs.get(key) + '\n';
           		 showResponse=true;
			return null;
    	}
    	
    	
		try {
    		return parsePOOM();
		}
		catch (Exception ex) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Unexpected Error Parsing response.  exception:'+ex+' cxml:'+cxml));
			return null;
		}

    }
    
    
	public PageReference parsePOOM() {
		
		cXML.PunchOutOrderMessage poom;
		try {
			poom = new cXML.PunchOutOrderMessage(cxml);
			}
		catch (Exception ex) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Invalid PunchoutOrderMessage: '+cxml +'    Exception: '+ex));
			return null;
		}
		
		//Verify PunchoutOrderMessage
		if (poom == null) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Invalid PunchoutOrderMessage: '+cxml));
			return null;
		}
			
		//Verify buyercookie returned
		if (poom.buyercookie == null ) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Error Null Buyercookie.'));
			return null;
		}
		
		//Get the BuyerCookie object
		Punchout.BuyerCookie bcookie;
		try {
			bcookie=new Punchout.BuyerCookie(poom.buyercookie);
		}
		catch (exception e) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Invalid Buyercookie.'));
			return null;
		}
		
		//Get The service via BuyerCookie
		Punchout.IPunchoutService service = Punchout.getService(bcookie.service, bcookie.id);
		if 	(service==null) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Invalid punchout service type: '+bcookie.service));
			return null;
		}
		
		//if a 'Cancel' was issued return back to origination 
		if ( poom.operationAllowed=='create' || poom.getItems().size()==0) { 
			
			PageReference page;
			page = service.onCancel(poom);
			if (page == null)
				page = new PageReference('/'+bcookie.id );
   			page.setRedirect(true);
			return page;
		}		
		

		//Verify we got a least one item, 
		if (poom.getItems().size()==0 ) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Must have at least one product in cart'));
			return null;
		}
		
		
		//and a supplierPartAuxiliaryID
		else if (poom.getItems()[0].supplierPartAuxiliaryID == null) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'supplierPartAuxiliaryID required.'));
			return null;
		}


		try {
			return service.onBrowserPost(poom);
		}
		catch (exception ex) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Error: '+ex));
			return null;
		}
	}


	public static testMethod void testBPHandler() {
			Account acc = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
			insert acc;
			Request__c r = new Request__c(account__c=acc.id, type__c='colornet', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
			insert r;
			Equipment__c eq = new Equipment__c( account_name__c=acc.id);
    		insert eq;
    		
			Test.startTest();
			PageReference pageRef = Page.Punchout_BPHandler;
			Test.setCurrentPage(pageRef);
			
			//missing Buyercookie and base64
			string TEST_POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie></BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';			
			ApexPages.currentPage().getParameters().put('cxml-base64',EncodingUtil.base64Encode(Blob.valueof(TEST_POOM)));
			ctrlPunchoutBPHandler controller = new ctrlPunchoutBPHandler();
			controller.init();
			
			//good one
			ApexPages.currentPage().getParameters().clear();
			TEST_POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>'+UserInfo.getOrganizationId()+eq.id+'___colornet</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';			
			ApexPages.currentPage().getParameters().put('cxml-urlencoded',TEST_POOM);
			controller.init();

			//a cancel (no items)
			TEST_POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>'+UserInfo.getOrganizationId()+eq.id+'___colornet</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader></PunchOutOrderMessage></Message></cXML>';			
			ApexPages.currentPage().getParameters().put('cxml-urlencoded',TEST_POOM);
			controller.init();


			//Bad poom msg w/ debug
			TEST_POOM='garbage';			
			ApexPages.currentPage().getParameters().put('cxml-urlencoded',TEST_POOM);
			ApexPages.currentPage().getParameters().put('debug','1');
			controller.init();

			//invalid http Parameter
			ApexPages.currentPage().getParameters().clear();
			ApexPages.currentPage().getParameters().put('garbage',TEST_POOM);
			controller.init();
			
			Test.stopTest();
	    }

}
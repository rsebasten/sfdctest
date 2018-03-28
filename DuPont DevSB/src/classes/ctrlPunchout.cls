public class ctrlPunchout {
	
	public string iframeEndPoint       {set; get;} 
    private static string TEST_RESPONSE = null;

    public PageReference init() {
    
        Punchout.IPunchoutService 	poService;
        
        //get Id  (Request__c or Opportunity_Investment__c or Equiptment)
        string paramId = ApexPages.currentPage().getParameters().get('id');
		string serviceType = ApexPages.currentPage().getParameters().get('type');

		//Get the Punchout Service
		poService = PunchOut.getService(serviceType, paramId);
		
		//Trigger OnInit override
		PageReference pageref=poService.OnInit(ApexPages.currentPage().getParameters());
		if (pageref!=null) return pageref;
				
		//createPunchoutSetupRequest
		string outPayload = poService.getSetupRequest();
		string punchoutResponse=Punchout.sendRequest(outPayload,poService.getSetupRequestURL(),TEST_RESPONSE);
        
        
        //Handle response
        if (punchoutResponse !=null) {
            cXML.Response rep = new cXML.Response(punchoutResponse);
            if (rep.statusCode == '200')
                iframeEndPoint=rep.url;
            else {
				ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL, rep.statusText + ' (' + rep.statusCode + '): ' + rep.statusMessage));
            }
        }
        else
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Error in connection. (Null response)'));    
        return null;			
		}
			

    
/********************************************************************************************	
//	TEST METHODS
********************************************************************************************/

	public static testMethod void testBIP() {
		    TEST_RESPONSE=CXML.createMessage(new CXML.Response('200','OK', 'https://somewhere.com/app?token=123')); //'<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>OPPID</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';
			Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
			insert a;
			Request__c r = new Request__c(account__c=a.id, type__c='bip', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
			insert r;
			Test.startTest();
			PageReference pageRef = Page.Punchout_OMS;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', r.id);
			ApexPages.currentPage().getParameters().put('type', 'bip');
			ctrlPunchout controller = new ctrlPunchout();
			controller.init();
			Test.stopTest();
	    }   
  
  	public static testMethod void testColornet() {
		    TEST_RESPONSE=CXML.createMessage(new CXML.Response('200','OK', 'https://somewhere.com/app?token=123')); //'<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>OPPID</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';
			Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
			insert a;
			Request__c r = new Request__c(account__c=a.id, type__c='colornet', ExternalRequestId__c='123', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
			insert r;
			Test.startTest();
			PageReference pageRef = Page.Punchout_OMS;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', r.id);
			ApexPages.currentPage().getParameters().put('type', 'colornet');
			ctrlPunchout controller = new ctrlPunchout();
			controller.init();
			Test.stopTest();
	    }   
	    

}
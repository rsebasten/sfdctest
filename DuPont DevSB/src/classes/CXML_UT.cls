@isTest
private class CXML_UT {


/*********************************************************************************************
 Test Methods 
 ********************************************************************************************/
	public static testMethod void test_CXML() {
		
		CXML.headerentry heF=new CXML.headerentry('From','force.com', 'SFDC');
		CXML.headerentry heT=new CXML.headerentry('To','DupontCSC', 'OMS');
		CXML.headerentry heS=new CXML.headerentry('Sender','SFDC.User', 'thomas.snyder@usa.dupont.com','Pa$$W04D');
		
		CXML.Header hdr = new CXML.Header();
		hdr.getEntries().Add(heF);
		hdr.getEntries().Add(heT);
		hdr.getEntries().Add(heS);
		system.debug(CXML.createMessage(new CXML.SetupRequest('create', 'bcasdasndhaksd', 'http://test.com'),hdr));
		system.debug(CXML.createMessage(new CXML.SetupRequest('edit', 'bcasdasndhaksd', 'http://test.com','cartadasdhadha'),hdr));
		system.debug(CXML.createMessage(new CXML.SetupRequest('inspect', 'bcasdasndhaksd', 'http://test.com','cartadasdhadha'),hdr));
		
		//inspectXml
		CXML.SetupRequest sr=new CXML.SetupRequest('inspect', 'bcasdasndhaksd', 'http://test.com','cartadasdhadha');
		sr.extrinsics.put('Format','Xml');
		system.debug(CXML.createMessage(sr,hdr,true));

		//PunchOutOrderMessage via cxml
		string samplePOOM = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>OPPID</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';
		CXML.PunchOutOrderMessage poom1 = new CXML.PunchOutOrderMessage(samplePOOM);
		system.debug(poom1);
		
		//PunchOutOrderMessage from scratch
		CXML.PunchOutOrderMessage poom2 = new CXML.PunchOutOrderMessage('COOKIEABC123',10.00,'edit',poom1.getItemMap());
		system.debug(poom2);
		system.debug(CXML.createMessage(poom2,hdr,true));
		
		system.debug(new CXML.Header(samplePOOM));
		
		//parse via xmlElement
		utilXmlDom dom = new utilXmlDom(samplePOOM);  
		system.debug(new CXML.PunchOutOrderMessage(dom.root.getElementByTagName('PunchOutOrderMessage')));
		CXML.Header h = new CXML.Header(dom.root.getElementByTagName('Header'));
		system.debug(h);
		system.debug(h.getEntry('Sender').userAgent);
		
		//Responses
		string res = CXML.createMessage(new CXML.Response('200','OK'));
		system.debug(res);
		system.debug(new CXML.Response(res));
		string srres = CXML.createMessage(new CXML.Response('200','OK', 'https://somewhere.com/app?token=123'));
		system.debug(srres);
		system.debug(new CXML.Response(srres));
		system.debug(new CXML.Response(srres).toXml());
		
		//OrderRequest
		string sampleOrderRequest = '<?xml version="1.0"?><!DOCTYPE cXML SYSTEM "http://www.coriansamples.com/cXML.dtd"><cXML xml:lang="en-US" payloadID="933695135608.677295401@jlee" timestamp="2010-10-07T14:10:01"><Header><From><!-- The buying marketplace and member organization. --><Credential domain="CorianSamplesUserId" type="marketplace"><Identity>order@coriansamples.com</Identity></Credential></From><To><Credential domain="DUNS"><Identity>942888711</Identity></Credential></To><Sender><Credential domain="AribaNetworkUserId"><Identity>salesrunner@coriansamples.com</Identity><SharedSecret>abracadabra</SharedSecret></Credential><UserAgent>Sales Runner</UserAgent></Sender></Header><Request deploymentMode="test"><OrderRequest><OrderRequestHeader orderID="238531" orderDate="2010-09-28T06:07:44-08:00" type="new"><Total><Money currency="USD">0</Money></Total><ShipTo><Address><Name xml:lang="en">Craig Brimley</Name><PostalAddress name="default">	<DeliverTo>Craig Brimley</DeliverTo>	<Street>2 Rector St, 25th Floor</Street>	<City>New York</City>	<State>NY</State>	<PostalCode>10006</PostalCode>	<Country isoCountryCode="US">US	                             </Country></PostalAddress></Address></ShipTo><BillTo><Address><Name xml:lang="en">Craig Brimley</Name><PostalAddress name="default">	<Street>2 Rector St, 25th Floor</Street>	<City>New York</City>	<State>NY</State>	<PostalCode>10006</PostalCode>	<Country isoCountryCode="US">US	                             </Country></PostalAddress></Address></BillTo><Comments xml:lang="en-US"/><Extrinsic name="ContactPreference">NoPreference</Extrinsic><Extrinsic name="SampleOrderReason">Project</Extrinsic><Extrinsic name="HowSoonProjectStart">0-3 Months</Extrinsic><Extrinsic name="ProjectPhase">Bidding</Extrinsic><Extrinsic name="ContactAboutProject">YES</Extrinsic><Extrinsic name="ProjectType">HealthCare</Extrinsic><Extrinsic name="ReceiveUpdates"/><Extrinsic name="ProjectName">MGH Lobby</Extrinsic><Extrinsic name="CustomerType">commercial</Extrinsic></OrderRequestHeader><ItemOut quantity="1" lineNumber="1"><ItemID><SupplierPartID>Lava Rock</SupplierPartID><SupplierPartAuxiliaryID>54515</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">0</Money></UnitPrice><Description xml:lang="en">Lava Rock 4x4</Description><UnitOfMeasure>EA</UnitOfMeasure><Classification domain="UNSPSC">60104813</Classification><ManufacturerName>Dupont Corian</ManufacturerName></ItemDetail><SupplierID domain="DUNS">1234567890</SupplierID></ItemOut><ItemOut quantity="1" lineNumber="2"><ItemID><SupplierPartID>Night Sky</SupplierPartID><SupplierPartAuxiliaryID>54515</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">0</Money></UnitPrice><Description xml:lang="en">Night Sky 4x4</Description><UnitOfMeasure>EA</UnitOfMeasure><Classification domain="UNSPSC">60104813</Classification><ManufacturerName>Dupont Corian</ManufacturerName></ItemDetail><SupplierID domain="DUNS">1234567890</SupplierID></ItemOut></OrderRequest></Request></cXML>';
		CXML.OrderRequest oreq = new CXML.OrderRequest(sampleOrderRequest);
		system.debug(CXML.createMessage(oreq, hdr));
		
	}
	
}
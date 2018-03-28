/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * * Description: This class is providing the mock response
 * Change history (key updates):
 * 8th May, 2015 -> created the class
**/
global without sharing class ctrl_CSDisplayErrorCustOrders_MockIMPL implements HttpCalloutMock  {
    private static final String responseBody = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
    '  <soap:Body>'+
    '    <soap:Fault>'+
    '      <faultcode>soap:Client</faultcode>'+
    '      <faultstring xml:lang="en-US">IDP Rule &apos;Invalid WSDL Message&apos; aborted processing.'+
    '&lt;/urn:YGV_SFDC_ORDER_DETAILS&gt; does not close tag &lt;urn:YGV_SFDC_ORDER_DETAIS&gt;.</faultstring>'+
    '      <detail>'+
    '        <fs:Detail xmlns:fs="http://www.forumsystems.com/2004/04/soap-fault-detail">'+
    '          <fs:SystemName>FS-External-UAT</fs:SystemName>'+
    '          <fs:User></fs:User>'+
    '          <fs:Policy>WSDL-Dupont-E2E-cSAP-OrderDetail</fs:Policy>'+
    '          <fs:TaskList></fs:TaskList>'+
    '          <fs:Task></fs:Task>'+
    '        </fs:Detail>'+
    '      </detail>'+
    '    </soap:Fault>'+
    '  </soap:Body>'+
    '</soap:Envelope>';
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String CONTENTTYPEVAL = 'text/xml';
    private static final String ERROR = 'Internal Server Error';

     /**
     * @param req
     * @return 
     */ 
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        res.setHeader(CONTENTTYPE, CONTENTTYPEVAL);
        res.setBody(responseBody);
        res.setStatus(ERROR);
        res.setStatusCode(500);
        return res;
    } // END global HTTPResponse respond(HTTPRequest req)
} // END global class ctrl_CSDisplayBlankCustomerOrders_MockIMPL implements HttpCalloutMock
/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * Description: This class is providing the mock response
 * @author sanchit.dua
**/
global without sharing class ctrl_CSDisplayBlankCustOrders_MockIMPL implements HttpCalloutMock  {
    private static final String responseBody = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
        '   <Body>'+
        '       <YGV_SFDC_ORDER_DETAILS.Response'+
        '           xmlns="urn:sap-com:document:sap:rfc:functions">'+
        '           <T_RETURN xmlns=""></T_RETURN>'+
        '           <T_SO_HEADER xmlns=""></T_SO_HEADER>'+
        '           <T_SO_ITEM xmlns=""></T_SO_ITEM>'+
        '       </YGV_SFDC_ORDER_DETAILS.Response>'+
        '   </Body>'+
        '</Envelope>';
    
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String CONTENTTYPEVAL = 'text/xml';
    
    /**
     * @param req
     * @return 
     */ 
    global HTTPResponse respond(HTTPRequest req) {
    
        HttpResponse res = new HttpResponse();
        
        res.setHeader(CONTENTTYPE, CONTENTTYPEVAL);
        res.setBody(responseBody);
        res.setStatusCode(200);
        return res;
    } // END global HTTPResponse respond(HTTPRequest req)
} // END global class ctrl_CSDisplayBlankCustomerOrders_MockIMPL implements HttpCalloutMock
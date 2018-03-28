/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This class is providing the mock response
 * email sanchit.dua@accenture.com
 * Change history (key updates):
 * 8th May, 2015 -> created the class
**/
global without sharing class ctrl_CSDisplayBlankInvoices_MockIMPL implements HttpCalloutMock  {
    private static final String responseBody ='<?xml version="1.0" encoding="UTF-8"?>'+
        '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
        '   <Body>'+
        '       <sp_0:YGV_SFDC_INVOICE_DETAILS.Response'+
        '           xmlns:sp_0="urn:sap-com:document:sap:rfc:functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
        '           xsi:type="sp_0:YGV_SFDC_INVOICE_DETAILS.Response">'+
        '           <T_INV_HEADER xmlns=""></T_INV_HEADER>'+
        '           <T_INV_ITEM xmlns=""></T_INV_ITEM>'+
        '           <T_RETURN xmlns="">'+
        '               <item>'+
        '                   <TYPE>E</TYPE>'+
        '                   <NUMBER>000</NUMBER>'+
        '                   <MESSAGE>No Data found</MESSAGE>'+
        '                   <LOG_MSG_NO>000000</LOG_MSG_NO>'+
        '                   <ROW>0</ROW>'+
        '               </item>'+
        '           </T_RETURN>'+
        '       </sp_0:YGV_SFDC_INVOICE_DETAILS.Response>'+
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
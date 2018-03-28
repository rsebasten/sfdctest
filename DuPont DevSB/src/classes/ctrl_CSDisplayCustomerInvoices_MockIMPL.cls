/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This class is providing the mock response
 * Change history (key updates):
 * 7th May, 2015 -> created the class
**/
global without sharing class ctrl_CSDisplayCustomerInvoices_MockIMPL implements HttpCalloutMock  {
    private static final String responseBody = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
        '   <Body>'+
        '       <sp_0:YGV_SFDC_INVOICE_DETAILS.Response'+
        '           xmlns:sp_0="urn:sap-com:document:sap:rfc:functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
        '           xsi:type="sp_0:YGV_SFDC_INVOICE_DETAILS.Response">'+
        '           <T_INV_HEADER xmlns="">'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016198</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F2</INVOICE_TYPE>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-16</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016199</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F2</INVOICE_TYPE>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-16</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016200</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F2</INVOICE_TYPE>'+
        '                   <NET_VALUE>730.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-16</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513166</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F8</INVOICE_TYPE>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-28</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513167</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F8</INVOICE_TYPE>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-16</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513168</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F8</INVOICE_TYPE>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-20</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513169</INVOICE_NUMBER>'+
        '                   <INVOICE_TYPE>F8</INVOICE_TYPE>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <BILLING_DATE>2015-04-16</BILLING_DATE>'+
        '                   <INVOICE_CREATE_DATE>2015-04-16</INVOICE_CREATE_DATE>'+
        '                   <DOCUMENT_CURRENCY>EUR</DOCUMENT_CURRENCY>'+
        '               </item>'+
        '           </T_INV_HEADER>'+
        '           <T_INV_ITEM xmlns="">'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016198</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14315474</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A CW 1/2X51.25X144 12X1300X3658 TR'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>5.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419888</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251259</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA11161206</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016199</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14318801</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A WN 1/4X30X98 6X760X2490'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>1.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419889</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251260</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA1111125P</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016200</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D11803513</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A GW 1/2X30X144 12.0X760X3658'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>1.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>346.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419892</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251261</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA11141297</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7603016200</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000020</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D11805744</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A BN 1/2X30X144 12.0X760X3658'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>1.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>384.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419892</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000020</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251261</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000020</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA11141254</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513167</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14315474</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A CW 1/2X51.25X144 12X1300X3658 TR'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>5.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419888</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251259</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA11161206</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513169</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14318801</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A WN 1/4X30X98 6X760X2490'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>1.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419889</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251260</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA1111125P</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513168</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14318801</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A WN 1/4X30X98 6X760X2490'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>1.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>183.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419889</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251260</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA1111125P</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '               <item>'+
        '                   <INVOICE_NUMBER>7611513166</INVOICE_NUMBER>'+
        '                   <INVOICE_ITEM>000010</INVOICE_ITEM>'+
        '                   <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
        '                   <MATERIAL_CODE>D14315474</MATERIAL_CODE>'+
        '                   <MATERIAL_DESCRIPTION>C A CW 1/2X51.25X144 12X1300X3658 TR'+
        '                   </MATERIAL_DESCRIPTION>'+
        '                   <BILLED_QTY>5.000</BILLED_QTY>'+
        '                   <SALES_UNIT>EA</SALES_UNIT>'+
        '                   <NET_VALUE>3560.00</NET_VALUE>'+
        '                   <SALES_DOCUMENT>7502419888</SALES_DOCUMENT>'+
        '                   <SALES_DOCUMENT_ITEM>000010</SALES_DOCUMENT_ITEM>'+
        '                   <REFERENCE_DOCUMENT>7565251259</REFERENCE_DOCUMENT>'+
        '                   <REF_DOC_ITEM_NUMBER>000010</REF_DOC_ITEM_NUMBER>'+
        '                   <PRODUCT_HIERARCHY>A6S112AA11161206</PRODUCT_HIERARCHY>'+
        '                   <PLANT>VW82</PLANT>'+
        '                   <SHIPPING_POINT>MSV1</SHIPPING_POINT>'+
        '               </item>'+
        '           </T_INV_ITEM>'+
        '           <T_RETURN xmlns=""></T_RETURN>'+
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
    
}
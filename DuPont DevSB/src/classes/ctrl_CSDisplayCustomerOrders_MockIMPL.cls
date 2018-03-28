/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This class is providing the mock response
 * Change history (key updates):
 * 22nd April, 2015 -> created the class
**/
global without sharing class ctrl_CSDisplayCustomerOrders_MockIMPL implements HttpCalloutMock  {
    private static final String responseBody = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">'+
    '   <Body>'+
    '      <sp_0:Z_I00204_SO_DATA.Response xsi:type="sp_0:Z_I00204_SO_DATA.Response" xmlns:sp_0="urn:sap-+com:document:sap:rfc:functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    '         <T_RETURN xmlns=""/>'+
    '         <T_SO_HEADER xmlns="">'+
    '            <item>'+
    '               <SYSTEM>301</SYSTEM>'+
    '               <ORDER_NUMBER>0000001128</ORDER_NUMBER>'+
    '               <ORDER_TYPE>ZOR1</ORDER_TYPE>'+
    '               <ORDER_CREATE_DATE>2014-07-15</ORDER_CREATE_DATE>'+
    '               <SOLD_TO_CUSTOMER>0055314223</SOLD_TO_CUSTOMER>'+
    '               <REQ_DELIVERY_DATE>2014-07-10</REQ_DELIVERY_DATE>'+
    '               <NET_VALUE>100000.00</NET_VALUE>'+
    '               <DOC_CURRENCY>USD</DOC_CURRENCY>'+
    '               <CUSTOMER_PURCHASE_ORDER>test for shipment 8.</CUSTOMER_PURCHASE_ORDER>'+
    '               <SHIPPING_CONDITION>01</SHIPPING_CONDITION>'+
    '               <CREDIT_STATUS>Not performed</CREDIT_STATUS>'+
    '            </item>'+
    '            <item>'+
    '               <SYSTEM>301</SYSTEM>'+
    '               <ORDER_NUMBER>0000001131</ORDER_NUMBER>'+
    '               <ORDER_TYPE>ZOR1</ORDER_TYPE>'+
    '               <ORDER_CREATE_DATE>2014-07-15</ORDER_CREATE_DATE>'+
    '               <SOLD_TO_CUSTOMER>0055314223</SOLD_TO_CUSTOMER>'+
    '               <REQ_DELIVERY_DATE>2014-07-10</REQ_DELIVERY_DATE>'+
    '               <NET_VALUE>100000.00</NET_VALUE>'+
    '               <DOC_CURRENCY>USD</DOC_CURRENCY>'+
    '               <CUSTOMER_PURCHASE_ORDER>test for shipment 8.</CUSTOMER_PURCHASE_ORDER>'+
    '               <SHIPPING_CONDITION>01</SHIPPING_CONDITION>'+
    '               <CREDIT_STATUS>Not performed</CREDIT_STATUS>'+
    '            </item>'+
    '            <item>'+
    '               <SYSTEM>301</SYSTEM>'+
    '               <ORDER_NUMBER>0000002500</ORDER_NUMBER>'+
    '               <ORDER_TYPE>ZOR1</ORDER_TYPE>'+
    '               <ORDER_CREATE_DATE>2014-12-27</ORDER_CREATE_DATE>'+
    '               <SOLD_TO_CUSTOMER>0055314223</SOLD_TO_CUSTOMER>'+
    '               <REQ_DELIVERY_DATE>2014-10-09</REQ_DELIVERY_DATE>'+
    '               <NET_VALUE>400.00</NET_VALUE>'+
    '               <DOC_CURRENCY>USD</DOC_CURRENCY>'+
    '               <CUSTOMER_PURCHASE_ORDER>test</CUSTOMER_PURCHASE_ORDER>'+
    '               <SHIPPING_CONDITION>01</SHIPPING_CONDITION>'+
    '               <CREDIT_STATUS>Not performed</CREDIT_STATUS>'+
    '               <HEADER_USER_STATUS>SP3</HEADER_USER_STATUS>'+
    '               <HEADER_USER_STATUS_DESC>Minimum Order Value</HEADER_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <SYSTEM>301</SYSTEM>'+
    '               <ORDER_NUMBER>0000002657</ORDER_NUMBER>'+
    '               <ORDER_TYPE>ZOR1</ORDER_TYPE>'+
    '               <ORDER_CREATE_DATE>2015-01-13</ORDER_CREATE_DATE>'+
    '               <SOLD_TO_CUSTOMER>0055314223</SOLD_TO_CUSTOMER>'+
    '               <REQ_DELIVERY_DATE>2014-10-09</REQ_DELIVERY_DATE>'+
    '               <NET_VALUE>2600.00</NET_VALUE>'+
    '               <DOC_CURRENCY>USD</DOC_CURRENCY>'+
    '               <CUSTOMER_PURCHASE_ORDER>F00077-TEST2</CUSTOMER_PURCHASE_ORDER>'+
    '               <SHIPPING_CONDITION>01</SHIPPING_CONDITION>'+
    '               <CREDIT_STATUS>Not performed</CREDIT_STATUS>'+
    '            </item>'+
    '            <item>'+
    '               <SYSTEM>301</SYSTEM>'+
    '               <ORDER_NUMBER>0000002658</ORDER_NUMBER>'+
    '               <ORDER_TYPE>ZOR1</ORDER_TYPE>'+
    '               <ORDER_CREATE_DATE>2015-01-13</ORDER_CREATE_DATE>'+
    '               <SOLD_TO_CUSTOMER>0055314223</SOLD_TO_CUSTOMER>'+
    '               <REQ_DELIVERY_DATE>2014-10-09</REQ_DELIVERY_DATE>'+
    '               <NET_VALUE>2600.00</NET_VALUE>'+
    '               <DOC_CURRENCY>USD</DOC_CURRENCY>'+
    '               <CUSTOMER_PURCHASE_ORDER>F00077-TEST2a</CUSTOMER_PURCHASE_ORDER>'+
    '               <SHIPPING_CONDITION>01</SHIPPING_CONDITION>'+
    '               <CREDIT_STATUS>Not performed</CREDIT_STATUS>'+
    '            </item>'+
    '         </T_SO_HEADER>'+
    '         <T_SO_ITEM xmlns="">'+
    '            <item>'+
    '               <ORDER_NUMBER>0000001128</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B902</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>100000.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D13581203</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>SF RED PIGMENT FOR KEVLAR</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>000001</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000001131</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B902</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>100000.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D13581203</MATERIAL>'+
    '              <MATERIAL_DESCRIPTION>SF RED PIGMENT FOR KEVLAR</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>000001</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002500</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B9</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>400.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D14467078</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>TEST</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002500</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B9</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>400.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D14467078</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>TEST</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>OK</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Sales Order OK</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002500</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B9</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>400.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D14467078</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>TEST</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>SP2</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Minimum Item Quantity Policy</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002657</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '              <PRODUCT_HIERARCHY>B9</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>1000.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D14881027</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>VESPEL CR-6110    VDSK 360_26.0      FIN</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>EA</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>OK</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Sales Order OK</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002657</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000020</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B902</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>1600.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D13581203</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>SF RED PIGMENT FOR KEVLAR</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>1600.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>OK</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Sales Order OK</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002658</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000010</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B9</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>1000.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D14881027</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>VESPEL CR-6110    VDSK 360_26.0      FIN</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>100.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>EA</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>OK</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Sales Order OK</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '            <item>'+
    '               <ORDER_NUMBER>0000002658</ORDER_NUMBER>'+
    '               <ITEM_NUMBER>000020</ITEM_NUMBER>'+
    '               <ITEM_CATEGORY>TAN</ITEM_CATEGORY>'+
    '               <PRODUCT_HIERARCHY>B902</PRODUCT_HIERARCHY>'+
    '               <NET_VALUE>1600.00</NET_VALUE>'+
    '               <CURRENCY>USD</CURRENCY>'+
    '               <MATERIAL>D13581203</MATERIAL>'+
    '               <MATERIAL_DESCRIPTION>SF RED PIGMENT FOR KEVLAR</MATERIAL_DESCRIPTION>'+
    '               <ORDER_QUANTITY>1600.000</ORDER_QUANTITY>'+
    '               <SALES_UNIT>KG</SALES_UNIT>'+
    '               <ROUTE>US0006</ROUTE>'+
    '               <PLANT>USA7</PLANT>'+
    '               <SHIPPING_POINT>UA70</SHIPPING_POINT>'+
    '               <LINE_ITEM_USER_STATUS>OK</LINE_ITEM_USER_STATUS>'+
    '               <LINE_ITEM_USER_STATUS_DESC>Sales Order OK</LINE_ITEM_USER_STATUS_DESC>'+
    '            </item>'+
    '         </T_SO_ITEM>'+
    '      </sp_0:Z_I00204_SO_DATA.Response>'+
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
/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This is the controller class responsible for invoking SAP Orders
 * Change history (key updates):
 * 1st April, 2015 -> created the class
 
 * AA 08192015 - Moved Days to Label.
**/
global without sharing class ctrl_CSDisplayCustomerOrders extends utilCSIntegrationHelperClass {
    public transient String pastDate {get;set;}
    public transient String currDate {get;set;}
    private static final String HASH = '-';
    private static final String SLASH = '/';
    private static final String EXCEPTN = '<Exception>';
    private static final String INDEXPAGE = '#';
    private static final String INITIAL_VAL = '';
    private static final String EXCP = '<EXCP>';
    private static final String AUTHORIZATIONERROR = 'Insufficient Authorization';
    private static final String EXCPMESSAGE = '<div class="message errorM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
    '                               <h4>Error:</h4></span>'+
    '<EXCP>'+ // ex.getMessage()
    '<br></div>'+ 
    '               </td>'+
    '           </tr>'+
    '           <tr>'+
    '               <td></td>'+
    '               <td>'+
    '               </td>'+
    '           </tr>'+
    '       </tbody>'+
    '    </table>'+
    '</div><br/>';

    private static final String UNAUTHORISEDMESSAGE = '<div class="message errorM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
    '                               <h4>Error:</h4></span>'+
    'Insufficient Authorization'+ // ex.getMessage()
    '<br></div>'+ 
    '               </td>'+
    '           </tr>'+
    '           <tr>'+
    '               <td></td>'+
    '               <td>'+
    '               </td>'+
    '           </tr>'+
    '       </tbody>'+
    '    </table>'+
    '</div><br/>';

    private static final String ERROR = 'Error';
    private static final String SANDBOXORDERS = 'Sandbox_Orders';
    private static final String NOTDATAFOUNDFORINPUTS = '<div class="message infoM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="INFO" src="/s.gif" class="msgIcon" title="INFO">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span>'+
    '                               <h4></h4></span>No data could be found for your given inputs. Try placing different inputs.</br></div>'+
    '               </td>'+
    '           </tr>'+
    '           <tr>'+
    '               <td></td>'+
    '               <td>'+
    '               </td>'+
    '           </tr>'+
    '       </tbody>'+
    '    </table>'+
    '</div>';

    private static final String HTMLHEADER = '<div class="bPageBlock brandSecondaryBrd apexDefaultPageBlock secondaryPalette"><DIV class="pbBody">'+
    '        <TABLE class="list" border="0" cellSpacing="0" cellPadding="0">'+
    '            <COLGROUP span="14"></COLGROUP>'+
    '            <THEAD>'+
    '                <TR class="headerRow">'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV></DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Order Number</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Order Type</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Customer Purchase Order</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Order Create Date</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Requested Delivery Date</DIV>'+ // The header got modified as per @Date 18th May, 2015 from the header value "Promised Delivery Date"
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Net Value</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Document Currency</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Delivery Block</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Billing Block</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Credit Status</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Shipping Condition</DIV>'+
    '                    </TH>'+
    // Following got removed as per @Date 18th May, 2015
    //'                    <TH class="headerRow" scope="col">'+
    //'                        <DIV>System</DIV>'+
    //'                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Sold To Customer</DIV>'+
    '                    </TH>'+
    '                </TR>'+
    '            </THEAD>'+
    '            <TBODY>';

    private static final String URLPLACEHOLDER = '<URLPLACEHOLDER>';

    private static final List<String> PLACEHOLDERS = new List<String>{
        '<Order Number>', // 0 => ordHeader.orderNumber (from LEFTITEMS.get(5) replace with oli.orderNumber)
        '<Order Type>', // 1 => ordHeader.orderType
        '<Customer Purchase Order>', // 2 => ordHeader.customerPurchaseOrder
        '<Order Create Date>', // 3 => ordHeader.orderCreatedDate
        '<Requested Delivery Date>', // 4 => ordHeader.reqDeliveryDate
        '<Net Value>', // 5 => ordHeader.netValue (from LEFTITEMS.get(5) replace with oli.netValue)
        '<Document Currency>', // 6 => ordHeader.docCurrency
        '<Delivery Block Description>', // 7 => ordHeader.deliveryBlock
        '<Billing Block Description>', // 8 => ordHeader.billingBlock
        '<Credit Status Description>', // 9 => ordHeader.creditStatus
        '<Shipping Conditions>', // 10 => ordHeader.shippingCondition
        '<System>', // 11 => ordHeader.sys
        '<Sold To Customer>', // 12 => ordHeader.soldToCustomer
        '<Item Number>', // 13 => oli.itemNumber
        '<Item Category>', // 14 => oli.itemCategory
        '<Material>', // 15 => oli.material
        '<Material Description>', // 16 => oli.materialDesc
        '<Order Quantity>', // 17 => oli.orderQuantity
        '<Sales Unit>', // 18 => oli.salesUnit
        '<Plant>', // 19 => oli.plant
        '<Shipping Point>', // 20 => oli.shippingPoint
        '<Reason for rejection Description>' // 21 => oli.reasonForRejection
    };


    private static final List<String> LEFTELEMENTS = new List<String>{
        '<!-- Order DATA -->'+
        '<!-- the data that needs to be dynamically filled -->'+
        '<TR class="dataRow even first">'+
        '    <TD class="dataCell">'+
        '<img src="/resource/CS_Collapse" onclick="slideComponents(this);" />'+
        '<img src="/resource/CS_Expand" onclick="slideComponents(this);" style="display:none;" />'+
        '    </TD>'+
        '    <TD class="dataCell">', // 0
        '        <A id="order" onclick="showAlert();" href="<URLPLACEHOLDER>'+ // urlToPlace
        '" >', // 1
        '        <A id="order" href="<URLPLACEHOLDER>'+ // urlToPlace
        '" target="_blank">', // 2
        '            <!-- Order Number -->'+
        '            '+ PLACEHOLDERS.get(0)+ 
        '        </A> '+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '    <!-- Order Type -->'+
        '        '+PLACEHOLDERS.get(1)+
        '    </TD> '+
        '    <TD class="dataCell">'+
        '        <!-- Customer Purchase Order -->'+
        '                            '+PLACEHOLDERS.get(2)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Order Create Date -->'+
        '        '+PLACEHOLDERS.get(3)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Requested Delivery Date -->'+
        '        '+PLACEHOLDERS.get(4)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Net Value -->'+
        '        '+PLACEHOLDERS.get(5)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Document Currency -->'+
        '        '+PLACEHOLDERS.get(6)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Delivery Block Description -->'+
        ''+PLACEHOLDERS.get(7)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Billing Block Description -->'+
        ''+PLACEHOLDERS.get(8)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Credit Status Description -->'+
        '        '+PLACEHOLDERS.get(9)+
        '    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Shipping Conditions -->'+
        '        '+PLACEHOLDERS.get(10)+
        '    </TD>'+
        // Following got removed as per @Date 18th May, 2015
        //'    <TD class="dataCell">'+
        //'        <!-- System -->'+
        //'        '+PLACEHOLDERS.get(11)+
        //'    </TD>'+
        '    <TD class="dataCell">'+
        '        <!-- Sold To Customer -->'+
        '        '+PLACEHOLDERS.get(12)+
        '    </TD>'+
        '</TR>', // 3
        '<!-- Order Line Data -->'+
        '<TR class="dataRow odd">'+
        '    <TD class="dataCell" colSpan="12">'+
        '        <TABLE style="DISPLAY: none" class="list line_item" border="0" cellSpacing="0" cellPadding="0">'+
        '            <COLGROUP span="13"></COLGROUP>'+
        '            <THEAD>'+
        '                <TR class="headerRow">'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Order Number</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Item Number</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Item Category</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Material Code</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Material Description</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Order Quantity</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Sales Unit</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Item Net Value</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Plant</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Shipping Point</DIV>'+
        '                    </TH>'+
        '                    <TH class="headerRow" scope="col">'+
        '                        <DIV>Reason for rejection</DIV>'+
        '                    </TH>'+
        '                </TR>'+
        '            </THEAD>'+
        '            <TBODY>', // 4
        '                <TR class="dataRow">'+
        '                    <TD class="dataCell">'+
        '                        <!-- Order Number -->'+
        '                        '+PLACEHOLDERS.get(0)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Item Number -->'+
        '                        '+PLACEHOLDERS.get(13)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Item Category -->'+
        '                        '+PLACEHOLDERS.get(14)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Material -->'+
        '                        '+PLACEHOLDERS.get(15)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Material Description -->'+
        '                        '+PLACEHOLDERS.get(16)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Order Quantity -->'+
        '                        '+PLACEHOLDERS.get(17)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Sales Unit -->'+
        '                        '+PLACEHOLDERS.get(18)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Item Net Value -->'+
        '                        '+PLACEHOLDERS.get(5)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Plant -->'+
        '                        '+PLACEHOLDERS.get(19)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Shipping Point -->'+
        '                        '+PLACEHOLDERS.get(20)+
        '                    </TD>'+
        '                    <TD class="dataCell">'+
        '                        <!-- Reason for rejection Description -->'+
        ''+PLACEHOLDERS.get(21)+
        '                    </TD>'+
        '                </TR>', // 5
        '            </TBODY>'+
        '        </TABLE>'+
        '    </TD>'+
        '</TR>', // 6
        '</TBODY>'+
        '</TABLE>'+
        '</DIV>'+
        '     <DIV class="pbFooter secondaryPalette">'+
        '     <DIV class="bg"></DIV>'+
        '</DIV>' // 7
    };

    /**
     * Parameterized Constructor
     */
    global ctrl_CSDisplayCustomerOrders(ApexPages.StandardController controller){
        String temp = String.valueOf(Date.today().addDays(-Integer.ValueOf(System.Label.CS_Default_Date_Range_Diff))); // AA 08192015 - Moved Days to Label.
        pastDate = Integer.valueOf(temp.split(HASH)[1])+SLASH+Integer.valueOf(temp.split(HASH)[2])+SLASH+Integer.valueOf(temp.split(HASH)[0]);
        temp = String.valueOf(Date.today());
        currDate = Integer.valueOf(temp.split(HASH)[1])+SLASH+Integer.valueOf(temp.split(HASH)[2])+SLASH+Integer.valueOf(temp.split(HASH)[0]);
    } // END init(ApexPages.StandardController)

    /**
     * Remote Action Method
     * @param requestBody - The order javascript Object we get as a parameter CAST Iron like {"orderNo":"","customerPO":"","fromDate":"1/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}
     * @return - the HTML data made from the XML response received from Javascript
     */
    @RemoteAction
    global static String parseOrderXml(String requestBody){ // 
        String urlToPlace = INDEXPAGE;
        OrderRequest ord = new OrderRequest();
        try{
            ord = (OrderRequest) JSON.deserialize(requestBody, OrderRequest.class);       
            urlToPlace = utilCSIntegrationHelperClass.getUrlToPlace(ord.sourceCluster) == NULL ? INDEXPAGE : utilCSIntegrationHelperClass.getUrlToPlace(ord.sourceCluster);     
        }catch(Exception ex){
            // system.debug('There got an error deserializing the requestbody. Error: '+ex.getMessage());
            return EXCPMESSAGE.replace(EXCP, ex.getMessage());
        }
        String requestData = INITIAL_VAL;

        ord.sourceCluster = utilCSIntegrationHelperClass.getSAPBoxClients(ord.sourceCluster);
        if((requestData = utilCSIntegrationHelperClass.createRequestXmlPayload(ord)).contains(ERROR))
            return requestData;
        
        String responseBody = INITIAL_VAL;
        
        if((responseBody=utilCSIntegrationHelperClass.invokeSAPService(requestData, SANDBOXORDERS)).contains(EXCEPTN))
            return responseBody.replace(EXCEPTN, INITIAL_VAL);
        
        if(responseBody.contains(AUTHORIZATIONERROR))
            return UNAUTHORISEDMESSAGE;

        // For maintaining the OrderNumber corresponding to the Order Data
        XmlObjects xo = utilCSIntegrationHelperClass.createXmlObjects(responseBody, ord);
        if(xo.headerMap.isEmpty())
            return NOTDATAFOUNDFORINPUTS;
        Decimal a =Blob.valueOf(responseBody).size();
            
        Decimal d =  a/(1024*1024);// (Blob.valueOf(responseBody).size()/1024)/1024;
        // String htmlToReturn = '<div class="message infoM3" role="alert">'+
        // '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
        // '        <tbody>'+
        // '           <tr valign="top">'+
        // '               <td>'+
        // '                   <img alt="INFO" src="/s.gif" class="msgIcon" title="INFO">'+
        // '               </td>'+
        // '               <td class="messageCell"><div class="messageText"><span>'+
        // '                               <h4></h4></span>The size of response xml is: '+d.setScale(2)+'Mb.</br></div>'+
        // '               </td>'+
        // '           </tr>'+
        // '           <tr>'+
        // '               <td></td>'+
        // '               <td>'+
        // '               </td>'+
        // '           </tr>'+
        // '       </tbody>'+
        // '    </table>'+
        // '</div>';
        String htmlToReturn = HTMLHEADER;
        for(String orderNumber: xo.headerMap.keySet()){
            OrderHeader ordHeader = (OrderHeader) xo.headerMap.get(orderNumber);
            htmlToReturn = htmlToReturn + LEFTELEMENTS.get(0);
            // '        <A id="order" href="'+myLinks.Link__c.replaceAll('<Order Number>', orderNumber)+'" target="_blank">'+
            
            if(indexPage.equals(urlToPlace))
                htmlToReturn = htmlToReturn + LEFTELEMENTS.get(1).replace(URLPLACEHOLDER, urlToPlace).replace(PLACEHOLDERS.get(0), ordHeader.orderNumber);
            else
                htmlToReturn = htmlToReturn + LEFTELEMENTS.get(2).replace(URLPLACEHOLDER, urlToPlace).replace(PLACEHOLDERS.get(0), ordHeader.orderNumber);

            htmlToReturn = htmlToReturn +   LEFTELEMENTS.get(3).
                                            replace(PLACEHOLDERS.get(0), ordHeader.orderNumber).
                                            replace(PLACEHOLDERS.get(1), ordHeader.orderType).
                                            replace(PLACEHOLDERS.get(2), ordHeader.customerPurchaseOrder).
                                            replace(PLACEHOLDERS.get(3), ordHeader.orderCreatedDate).
                                            replace(PLACEHOLDERS.get(4), ordHeader.reqDeliveryDate).
                                            replace(PLACEHOLDERS.get(5), ordHeader.netValue).
                                            replace(PLACEHOLDERS.get(6), ordHeader.docCurrency).
                                            replace(PLACEHOLDERS.get(7), ordHeader.deliveryBlock).
                                            replace(PLACEHOLDERS.get(8), ordHeader.billingBlock).
                                            replace(PLACEHOLDERS.get(9), ordHeader.creditStatus).
                                            replace(PLACEHOLDERS.get(10), ordHeader.shippingCondition).
                                            // replace(PLACEHOLDERS.get(11), ordHeader.sys). // This got removed as per @Date 18th May, 2015
                                            replace(PLACEHOLDERS.get(12), ordHeader.soldToCustomer);


            if(xo.lineItemMap.containsKey(orderNumber)){ // ¯\_(ツ)_/¯ Extracting the Line Item Data
                htmlToReturn = htmlToReturn + LEFTELEMENTS.get(4);
                for(Object obj: xo.lineItemMap.get(orderNumber)){
                    OrderLineItem oli = (OrderLineItem) obj;
                    htmlToReturn = htmlToReturn + LEFTELEMENTS.get(5).replace(PLACEHOLDERS.get(0), oli.orderNumber).replace(PLACEHOLDERS.get(13), oli.itemNumber).replace(PLACEHOLDERS.get(14), oli.itemCategory).replace(PLACEHOLDERS.get(15), oli.material).replace(PLACEHOLDERS.get(16), oli.materialDesc).replace(PLACEHOLDERS.get(17), oli.orderQuantity).replace(PLACEHOLDERS.get(18), oli.salesUnit).replace(PLACEHOLDERS.get(19), oli.plant).replace(PLACEHOLDERS.get(20), oli.shippingPoint).replace(PLACEHOLDERS.get(21), oli.reasonForRejection).replace(PLACEHOLDERS.get(5), oli.netValue);
                } // END inner for
                htmlToReturn = htmlToReturn + LEFTELEMENTS.get(6);
            } // END if(lineItemMap.containsKey(orderNumber))
        } // END for

        htmlToReturn = htmlToReturn + LEFTELEMENTS.get(7) + LEFTELEMENTS.get(7);
        
        return htmlToReturn;
    } // END public void parseXml()
   
} // END public class CS_DisplayCustomerOrders
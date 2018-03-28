/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This is the controller class responsible for invoking SAP Invoices
 * Change history (key updates):
 * 1st April, 2015 -> created the class
 * 22nd June, 2015 -> Error Placeholders and Product Hierarchy column
 * AA 08192015 - Moved Days to Label.
**/
global without sharing class ctrl_CSDisplayCustomerInvoice extends utilCSIntegrationHelperClass {
    public transient String pastDate {get;set;}
    public transient String currDate {get;set;}
    private static final String EXCEPTN = '<Exception>';
    private static final String INDEXPAGE = '#';
    private static final String HASH = '-';
    private static final String SLASH = '/';
    private static final String INITIAL_VAL = '';
    private static final String INVOICE = 'Invoice';
    private static final String AUTHORIZATIONERROR = 'Insufficient Authorization';
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

    private static final String customLinkNotExist = '<div class="message errorM3" role="alert">'+
    '   <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '       <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell">'+
    '                   <div class="messageText">'+
    '                       <span style="color:#cc0000">'+
    '                           <h4>Error:</h4>'+
    '                       </span>'+
    '                       The link doesn\'t exist for the specified Invoice call. Please define it in CS_Links__c Custom Settings.<br/>'+
    '                   </div>'+
    '               </td>'+
    '           </tr>'+
    '           <tr>'+
    '               <td></td>'+
    '               <td></td>'+
    '           </tr>'+
    '       </tbody>'+
    '   </table>'+
    '</div>';

    
    private static final String CUSTOMERNONOTEXIST = '<div class="message errorM3" role="alert">'+
    '   <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '       <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell">'+
    '                   <div class="messageText">'+
    '                       <span style="color:#cc0000">'+
    '                           <h4>Error:</h4>'+
    '                       </span>The customer number is not mentioned in the Account Number field. Please specify it and try again.<br/>'+
    '                   </div>'+
    '               </td>'+
    '           </tr>'+
    '           <tr>'+
    '               <td></td>'+
    '               <td></td>'+
    '           </tr>'+
    '       </tbody>'+
    '   </table>'+
    '</div>';
    
    private static final String EXCPLACEHOLDER = '<exception>';
    
    private static final String EXCPMSG = '<div class="message errorM3" role="alert">'+
            '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
            '        <tbody>'+
            '           <tr valign="top">'+
            '               <td>'+
            '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
            '               </td>'+
            '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
            '                               <h4>Error:</h4></span><exception><br></div>'+
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
    private static final String NODATAFOUND = '<div class="message infoM3" role="alert">'+
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
    
    private static final String HTMLHEADER = '<div class="apexp">'+
        '  <div class="individualPalette">'+
        '    <div class="accountBlock">'+
        '      <div '+
        '        class="bPageBlock brandSecondaryBrd apexDefaultPageBlock secondaryPalette">'+
        '        <div class="pbBody">'+
        '          <table class="list" border="0"'+
        '            cellpadding="0" cellspacing="0">'+
        '            <colgroup span="12"></colgroup>'+
        '            <thead class="">'+
        '              <tr class="headerRow">'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>'+
        '                  </div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Invoice Number</div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Invoice Type</div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Billing Date</div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Net Value</div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Document Currency</div>'+
        '                </th>'+
        '                <th class="headerRow" scope="col" colspan="1">'+
        '                  <div>Invoice Create Date</div>'+
        '                </th>'+
        '              </tr>'+
        '            </thead>'+
        '            <tbody>';
    
    private static final String ERR = 'Error';
    private static final String SANDBOXINV = 'Sandbox_Invoices';
    private static final String LINEITEMHEADER = '<!-- Invoice Line Data -->'+
    '<TR class="dataRow odd">'+
    '    <TD class="dataCell" colSpan="12">'+
    '        <TABLE style="DISPLAY: none" class="list line_item" border="0" cellSpacing="0" cellPadding="0">'+
    '            <COLGROUP span="13"></COLGROUP>'+
    '            <THEAD>'+
    '                <TR class="headerRow">'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Invoice Number</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Invoice Item</DIV>'+
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
    '                        <DIV>Billed Qty</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Sales Unit</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Net Value</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Sales Document</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Sales Document Item</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Reference Document</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Ref Doc Item Number</DIV>'+
    '                    </TH>'+
    //  @Date Modified: 22nd June, 2015 
    //'                    <TH class="headerRow" scope="col">'+
    //'                        <DIV>Product Hierarchy</DIV>'+
    //'                    </TH>'+
    //  END @Date Modified: 22nd June, 2015 
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Plant</DIV>'+
    '                    </TH>'+
    '                    <TH class="headerRow" scope="col">'+
    '                        <DIV>Shipping Point</DIV>'+
    '                    </TH>'+
    '                </TR>'+
    '            </THEAD>'+
    '            <TBODY>';
    
    private static final String FOOTER = '</TBODY>'+
        '</TABLE>'+
        '</DIV>'+
        '     <DIV class="pbFooter secondaryPalette">'+
        '     <DIV class="bg"></DIV>'+
        '</DIV>';
        
    private static final String LINEITEMFOOTER = '</TBODY>'+
                '        </TABLE>'+
                '    </TD>'+
                '</TR>';
    
    private static final String INVLINKPLACEHOLDER = '<INVLINK>';
    private static final String INVNOPLACEHOLDER = '<Invoice Number>';
    private static final String INVTYPEPLACEHOLDER = '<INVTYPE>';
    private static final String BILLINGDTPLACEHOLDER = '<BILLINGDATE>';
    private static final String NETVALPLACEHOLDER = '<NETVALUE>';
    private static final String DOCCURPLACEHOLDER = '<DOCCURRENCY>';
    private static final String CREATEDTPLACEHOLDER = '<CREATEDATE>';
    private static final String INVNUMPLACEHOLDER= '<Invoice Number>';
    
    private static final String INVOICEDATAHTML = '<!-- Invoice DATA -->'+
    '<!-- the data that needs to be dynamically filled -->'+
    '<TR class="dataRow even first">'+
    '    <TD class="dataCell">'+
    '        <img src="/resource/CS_Collapse" onclick="slideComponents(this);" />'+
            '<img src="/resource/CS_Expand" onclick="slideComponents(this);" style="display:none;" />'+
    '    </TD>'+
    '    <TD class="dataCell">'+
    '        <INVLINK>'+ // '+myLinks.Link__c.replaceAll('<Invoice Number>', invoiceNumber)+' --> 
    '            <!-- Invoice Number -->'+
    '            <Invoice Number>'+ // iRequest.invoiceNumber+
    '        </A> '+
    ''+
    '    </TD>'+
    '    <TD class="dataCell">'+
    '    <!-- Invoice Type -->'+
    '        <INVTYPE>'+ // iRequest.invoiceType+
    '    </TD> '+
    '    <TD class="dataCell">'+
    '        <!-- Billing Date -->'+
    '                            <BILLINGDATE>'+// iRequest.billingDate+
    '    </TD>'+
    '    <TD class="dataCell">'+
    '        <!-- Net Value -->'+
    '        <NETVALUE>'+// iRequest.netValue+
    '    </TD>'+
    '    <TD class="dataCell">'+
    '        <!-- Document Currency -->'+
    '        <DOCCURRENCY>'+// iRequest.documentCurrency+
    '    </TD>'+
    '    <TD class="dataCell">'+
    '        <!-- Invoice Create Date -->'+
    '        <CREATEDATE>'+// iRequest.invoiceCreateDate+
    '    </TD>'+
    '</TR>';
    
    private static final String INVITEMPLACEHOLDER = '<INVOICEITEM>';
    private static final String INVITEMCATPLACEHOLDER = '<CATEGORY>';
    private static final String INVITEMMATPLACEHOLDER = '<MATERIALCODE>';
    private static final String INVITEMMDESCPLACEHOLDER = '<MATERIALDESC>';
    private static final String INVBILLQTYPLACEHOLDER = '<BILLEDQTY>';
    private static final String SALESUNITPLACEHOLDER = '<SALESUNIT>'; 
    private static final String SALESDOCPLACEHOLDER = '<SALESDOC>'; 
    private static final String SALESDOCITEMPLACEHOLDER = '<SALESDOCITEM>'; 
    private static final String REFDOCPLACEHOLDER = '<REFDOC>'; 
    private static final String REFDOCITEMPLACEHOLDER = '<REFDOCITEM>'; 
    private static final String PRODHIERARCHYPLACEHOLDER = '<PRODHIERARCHY>'; 
    private static final String PLANTPLACEHOLDER = '<PLANT>'; 
    private static final String SHIPPINGPLACEHOLDER = '<SHIPPING>'; 
    
    private static final String INVOICELINEDATAHTML = '                <TR class="dataRow">'+
      '                    <TD class="dataCell">'+
      '                        <!-- Invoice Number -->'+
      '                        <Invoice Number>'+// ili.invoiceNumber+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Invoice Item -->'+
      '                        <INVOICEITEM>'+// ili.invoiceItem+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Item Category -->'+
      '                        <CATEGORY>'+// ili.itemCategory+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Material Code -->'+
      '                        <MATERIALCODE>'+// ili.materialCode+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Material Description -->'+
      '                        <MATERIALDESC>'+// ili.materialDesc+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Billed Qty -->'+
      '                        <BILLEDQTY>'+// ili.billedQty+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Sales Unit -->'+
      '                        <SALESUNIT>'+// ili.salesUnit+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Net Value -->'+
      '                        <NETVALUE>'+// ili.netValue+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Sales Document -->'+
      '                        <SALESDOC>'+// ili.salesDocument+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Sales Document Item -->'+
      '                        <SALESDOCITEM>'+// ili.salesDocumentItem+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Reference Document -->'+
      '                        <REFDOC>'+// ili.referenceDocument+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Ref Doc Item Number -->'+
      '                        <REFDOCITEM>'+// ili.refDocItemNumber+
      '                    </TD>'+
      //  @Date Modified: 22nd June, 2015 
      //'                    <TD class="dataCell">'+
      //'                        <!-- Product Hierarchy-->'+
      //'                        <PRODHIERARCHY>'+// ili.productHierarchy+
      //'                    </TD>'+
      //  END @Date Modified: 22nd June, 2015 
      '                    <TD class="dataCell">'+
      '                        <!-- Plant -->'+
      '                        <PLANT>'+// ili.plant+
      '                    </TD>'+
      '                    <TD class="dataCell">'+
      '                        <!-- Shipping Point-->'+
      '                        <SHIPPING>'+// ili.shippingPoint+
      '                    </TD>'+
      '                </TR>';
    private static final String URLPLACEHOLDER = '<URLPLACEHOLDER>';
        private static final List<String> LEFTELEMENTS = new List<String>{
            '        <A id="order" onclick="showAlert();" href="<URLPLACEHOLDER>'+ // urlToPlace
            '" >', // 0

            '        <A id="order" href="<URLPLACEHOLDER>'+ // urlToPlace
            '" target="_blank">' // 1
        };



    /**
     * Parameterized Constructor
     */
    global ctrl_CSDisplayCustomerInvoice(ApexPages.StandardController controller) {
        String temp = String.valueOf(Date.today().addDays(-Integer.ValueOf(System.Label.CS_Default_Date_Range_Diff)));  // AA 08192015 - Moved Days to Label.
        pastDate = Integer.valueOf(temp.split(HASH)[1])+SLASH+Integer.valueOf(temp.split(HASH)[2])+SLASH+Integer.valueOf(temp.split(HASH)[0]);
        temp = String.valueOf(Date.today());
        currDate = Integer.valueOf(temp.split(HASH)[1])+SLASH+Integer.valueOf(temp.split(HASH)[2])+SLASH+Integer.valueOf(temp.split(HASH)[0]);
    } // END init(StandardController)
    
    /**
     * Remote Action Method
     * @param requestBody - The order javascript Object we get as a parameter CAST Iron like {"invoiceNo":"","fromDate":"1/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}
     * @return - the HTML data made from the XML response received from Javascript
     */
    @RemoteAction
    global static String parseInvoiceXml(String invoiceData){  
        String urlToPlace = INDEXPAGE;
        CS_Links__c myLinks = CS_Links__c.getInstance(INVOICE);
        // system.debug('the invoice reqeuest data: '+invoiceData);
        if(myLinks == null)
            return customLinkNotExist;
            
        InvoiceRequest inv = new InvoiceRequest();
        try{
            inv = (InvoiceRequest) JSON.deserialize(invoiceData, InvoiceRequest.class);
            
            if(inv.customerNumber == NULL || String.isBlank(inv.customerNumber))
                return CUSTOMERNONOTEXIST;
            urlToPlace = utilCSIntegrationHelperClass.getUrlToPlaceInv(inv.cluster) == NULL ? INDEXPAGE : utilCSIntegrationHelperClass.getUrlToPlaceInv(inv.cluster);     
        
        }catch(Exception ex){
            // system.debug('There got an error deserializing the requestbody. Error: '+ex.getMessage());
            return EXCPMSG.replace(EXCPLACEHOLDER, ex.getMessage());
        }
        String requestData = INITIAL_VAL;

        inv.cluster = utilCSIntegrationHelperClass.getSAPBoxClients(inv.cluster);
        System.debug('@#debug++'+inv+'@#@#'+ERR);
        if((requestData = utilCSIntegrationHelperClass.createRequestXmlPayload(inv)).contains(ERR))
            return requestData;
        
        String responseBody = INITIAL_VAL;
        
        if((responseBody=utilCSIntegrationHelperClass.invokeSAPService(requestData, SANDBOXINV)).contains(EXCEPTN))
            return responseBody.replace(EXCEPTN, INITIAL_VAL);

        if(responseBody.contains(AUTHORIZATIONERROR))
            return UNAUTHORISEDMESSAGE;

         // For maintaining the OrderNumber corresponding to the Order Data
        XmlObjects xo = utilCSIntegrationHelperClass.createXmlObjects(responseBody, inv);
        
        String htmlToReturn = INITIAL_VAL;

        // For maintaining the OrderNumber corresponding to the Order Data
       
        if(xo.headerMap.isEmpty())
            return NODATAFOUND;
            
        htmlToReturn = HTMLHEADER;
        
        for(String invoiceNumber: xo.headerMap.keySet()){
            InvoiceHeader iRequest = (InvoiceHeader)xo.headerMap.get(invoiceNumber);

            String anchorLink = INITIAL_VAL;

            if(INDEXPAGE.equals(urlToPlace))
                anchorLink = LEFTELEMENTS.get(0).replace(URLPLACEHOLDER, urlToPlace).replace(INVNUMPLACEHOLDER, iRequest.invoiceNumber);
            else
                anchorLink = LEFTELEMENTS.get(1).replace(URLPLACEHOLDER, urlToPlace).replace(INVNUMPLACEHOLDER, iRequest.invoiceNumber);

            htmlToReturn = htmlToReturn + INVOICEDATAHTML.replace(INVLINKPLACEHOLDER, anchorLink).
                                            replace(INVNOPLACEHOLDER, iRequest.invoiceNumber).
                                            replace(INVTYPEPLACEHOLDER, iRequest.invoiceType).
                                            replace(BILLINGDTPLACEHOLDER, iRequest.billingDate).
                                            replace(NETVALPLACEHOLDER, iRequest.netValue).
                                            replace(DOCCURPLACEHOLDER, iRequest.documentCurrency).
                                            replace(CREATEDTPLACEHOLDER, iRequest.invoiceCreateDate);
            if(xo.lineItemMap.containsKey(invoiceNumber)){ // ¯\_(ツ)_/¯ Extracting the Line Item Data
                htmlToReturn = htmlToReturn + LINEITEMHEADER;
                for(Object obj: xo.lineItemMap.get(invoiceNumber)){
                    InvoiceLineItem ili= (InvoiceLineItem)obj;
                    htmlToReturn = htmlToReturn + INVOICELINEDATAHTML.replace(INVNOPLACEHOLDER, ili.invoiceNumber).
                                                    replace(INVITEMPLACEHOLDER, ili.invoiceItem).
                                                    replace(INVITEMCATPLACEHOLDER, ili.itemCategory).
                                                    replace(INVITEMMATPLACEHOLDER, ili.materialCode).
                                                    replace(INVITEMMDESCPLACEHOLDER, ili.materialDesc).
                                                    replace(INVBILLQTYPLACEHOLDER, ili.billedQty).
                                                    replace(SALESUNITPLACEHOLDER, ili.salesUnit).
                                                    replace(SALESDOCPLACEHOLDER, ili.salesDocument).
                                                    replace(SALESDOCITEMPLACEHOLDER, ili.salesDocumentItem).
                                                    replace(REFDOCPLACEHOLDER, ili.referenceDocument).
                                                    replace(REFDOCITEMPLACEHOLDER, ili.refDocItemNumber).
                                                    //  @Date Modified: 22nd June, 2015 
                                                    //replace(PRODHIERARCHYPLACEHOLDER, ili.productHierarchy).
                                                    //  END @Date Modified: 22nd June, 2015 
                                                    replace(PLANTPLACEHOLDER, ili.plant).
                                                    replace(SHIPPINGPLACEHOLDER, ili.shippingPoint).replace(NETVALPLACEHOLDER, ili.netValue);
                } // END inner for
                htmlToReturn = htmlToReturn + LINEITEMFOOTER;
            } // END if(lineItemMap.containsKey(orderNumber))
        } // END for
        
        htmlToReturn = htmlToReturn + FOOTER;
        // system.debug('htmlToReturn is: '+htmlToReturn);
        return htmlToReturn;
    } // END global String parseInvoiceXml(String responseXml)
    
}
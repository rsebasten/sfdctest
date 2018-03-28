/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This is the parent class of Orders and Invoices controllers
 * Change history (key updates):
 * 6th May, 2015 -> created the class
 * AA 08192015 -- Added Timeout for callout.
 * AA 08192015  : Commented the code as per requirement. Validation for 180 days between removed.
**/
global with sharing virtual class utilCSIntegrationHelperClass {

    private static final String DOT = '.';
    private static final String INITIAL_VAL = '';
    private static final String HASH = '#';
    private static final String SLASH = '/';
    private static final String ENDDATEGREATER = '<div class="message errorM3" role="alert">'+
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
    '                       </span>\'To Date\' should be greater than or equal to \'From Date\'<br/>'+
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
    private static final String STRDATEGREATER = '<div class="message errorM3" role="alert">'+
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
    '                       Difference between \'To Date\' and \'From Date\' should not be greater than 180 days<br/>'+
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
    
    private static final String EPASSIDPLACEHOLDER = '<EPASSID>';
    private static final String ZERO = '0';
    private static final String EXCPMSG = '<EXCPMSG>';
    private static final String EXCPMESSAGE = '<div class="message errorM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
    '                               <h4>Error:</h4></span><EXCPMSG><br></div>'+ /////// TODOtodo ex.getMessage()
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
    private static final String WS_EXCPMESSAGE = '<div class="message errorM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
    '                               <h4><Exception>Error:</h4></span><EXCPMSG><br></div>'+ /////// TODOtodo ex.getMessage()
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
    private static final String EPASSNOTEXIST = '<div class="message errorM3" role="alert">'+
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
    '                       E-Pass ID doesn\'t exist for the current user.<br/>'+
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
    private static final String CUSTOMERNUMBERPLACEHOLDER = '<CUSTNUMBER>';
    private static final String CLUSTERPLACEHOLDER = '<CLUSTERPLACEHOLDER>';
    private static final String ORDERREQDATA = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">'+
    '   <soapenv:Header/>'+
    '   <soapenv:Body>'+
    '      <urn:YGV_SFDC_ORDER_DETAILS>'+
    '         <!--Optional:-->'+
    '         <SAP_HOST_NAME xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'+
    '         <!--Optional:-->'+
    '         <CLUSTER>'+CLUSTERPLACEHOLDER+'</CLUSTER>'+ // CB1510
    '         <CUSTOMER_NUMBER>'+
    '<CUSTNUMBER>'+ // +ord.customerNumber+
    '</CUSTOMER_NUMBER>'+ 
    '         <!--Optional:-->';
    
    private static final String BLANKCUSTOMERPO = '<CUSTOMER_PO xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';
    private static final String CUSTOMERPOPLACEHOLDER = '<CUSTPO>';
    private static final String WITHCUSTOMERPO = '<CUSTOMER_PO><CUSTPO></CUSTOMER_PO>';
    
    private static final String BLANKORDERNUMBER = '<ORDER_NUMBER xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';
    private static final String ORDERNOPLACEHOLDER = '<ORDERNOPLACEHOLDER>';
    private static final String WITHORDERNUMBER = '<ORDER_NUMBER><ORDERNOPLACEHOLDER></ORDER_NUMBER>';
    
    private static final String DISTCHANNEL='<DISTCHANNEL>';
    private static final String DIVCODE = '<DIVCODE>';
    private static final String STRDATEPLACEHOLDER = '<STRDATEPLACEHOLDER>';
    private static final String SALESORGPLACEHOLDER = '<SALESORGPLACEHOLDER>';
    private static final String ENDDATEPLACEHOLDER = '<ENDDATEPLACEHOLDER>';
    
    private static final String ORDERENVELOP = '<DISTRIBUTION_CHANNEL><DISTCHANNEL></DISTRIBUTION_CHANNEL>'+ // +ord.distributionChannel+
    '         <DIVISION><DIVCODE></DIVISION>'+ // divisionCode
    '         <DOCUMENT_TYPE xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'+
    '         <FROMDATE><STRDATEPLACEHOLDER></FROMDATE>'+ // startDate
    '         <SALES_ORG><SALESORGPLACEHOLDER></SALES_ORG>'+ // ord.salesOrg
    '         <TODATE><ENDDATEPLACEHOLDER></TODATE>'+ // endDt
    '         <USER_ID>'+EPASSIDPLACEHOLDER+'</USER_ID>'+ // OR3668
    '      </urn:YGV_SFDC_ORDER_DETAILS>'+
    '   </soapenv:Body>'+
    '</soapenv:Envelope>';
    
    
    private static final String INVOICEREQDATA = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sapcom:document:sap:rfc:functions">'+
    '   <soapenv:Header/>'+
    '   <soapenv:Body>'+
    '      <urn:YGV_SFDC_INVOICE_DETAILS>'+
    '         <SAP_HOST_NAME xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'+
    '         <CLUSTER>'+CLUSTERPLACEHOLDER+'</CLUSTER>'+
    '         <CUSTOMER_NUMBER><CUSTNUMBER></CUSTOMER_NUMBER>'+ // inv.customerNumber
    '         <DISTRIBUTION_CHANNEL><DISTCHANNEL></DISTRIBUTION_CHANNEL>'+ // inv.distributionChannel
    '         <DIVISION><DIVCODE></DIVISION>'+ // div
    '         <FROMDATE><STRDATEPLACEHOLDER></FROMDATE>'; // startDate
    private static final String BLANKINVOICENUMBER = '<INVOICE_NUMBER xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';
    private static final String INVOICENOPLACEHOLDER = '<INVOICENOPLACEHOLDER>';
    private static final String WITHINVOICENUMBER = '<INVOICE_NUMBER><INVOICENOPLACEHOLDER></INVOICE_NUMBER>';
    
    private static final String INVOICEENVELOP = '<INVOICE_TYPE xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'+
    '         <SALES_ORG><SALESORGPLACEHOLDER></SALES_ORG>'+ // inv.salesOrg
    '         <TODATE><ENDDATEPLACEHOLDER></TODATE>'+ // endDt
    '         <USER_ID>'+EPASSIDPLACEHOLDER+'</USER_ID>'+ // OR3668
    '      </urn:YGV_SFDC_INVOICE_DETAILS>'+
    '   </soapenv:Body>'+
    '</soapenv:Envelope>';
    
    private static final String ENDPOINTNOTEXIST = '<div class="message errorM3" role="alert">'+
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
    '                       End point doesn\'t exist for the specified Order call. Please define it in CS_Settings__c object.<br/>'+
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

    private static final String RESPONSESTATUSCODE = '<RESPONSESTATUSCODE>';
    private static final String RESPONSEBODYPLACEHOLDER = '<RESPONSEBODYPLACEHOLDER>';
    private static final String ERRCASTIRON = '<div class="message errorM3" role="alert">'+
    '    <table class="messageTable" style="padding:0px;margin:0px;" border="0" cellpadding="0" cellspacing="0">'+
    '        <tbody>'+
    '           <tr valign="top">'+
    '               <td>'+
    '                   <img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR">'+
    '               </td>'+
    '               <td class="messageCell"><div class="messageText"><span style="color:#cc0000">'+
    '                               <h4>Error:</h4></span>'+'There got some problem making the webservice request to Cast Iron. Status Code: <RESPONSESTATUSCODE>. <RESPONSEBODYPLACEHOLDER><br></div>'+
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
    private static final String POST = 'POST';
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String CONTENTTYPEVAL = 'text/xml';
    private static final List<String> headers = new List<String>{'T_SO_HEADER', // 0
        'ORDER_NUMBER', // 1
        'SYSTEM', // 2
        'ORDER_TYPE', // 3
        'ORDER_CREATE_DATE', // 4
        'SOLD_TO_CUSTOMER', // 5
        'REQ_DELIVERY_DATE', // 6
        'NET_VALUE', // 7
        'DOC_CURRENCY', // 8
        'DELIVERY_BLOCK', // 9
        'BILLING_BLOCK', // 10
        'CUSTOMER_PURCHASE_ORDER', // 11
        'SHIPPING_CONDITION', // 12
        'CREDIT_STATUS', // 13
        'HEADER_USER_STATUS', // 14
        'HEADER_USER_STATUS_DESC', // 15
        'T_SO_ITEM', // 16
        'ITEM_NUMBER', // 17
        'ITEM_CATEGORY', // 18
        'PRODUCT_HIERARCHY', // 19
        'CURRENCY', // 20
        'MATERIAL', // 21
        'MATERIAL_DESCRIPTION', // 22
        'ORDER_QUANTITY', // 23
        'SALES_UNIT', // 24
        'ROUTE', // 25
        'PLANT', // 26
        'SHIPPING_POINT', // 27
        'REASON_FOR_REJECTION', // 28
        'LINE_ITEM_USER_STATUS', // 29
        'LINE_ITEM_USER_STATUS_DESC', // 30
        'T_INV_HEADER', // 31
        'INVOICE_NUMBER', // 32
        'INVOICE_TYPE', // 33
        'BILLING_DATE', // 34
        'INVOICE_CREATE_DATE', // 35
        'DOCUMENT_CURRENCY', // 36
        'T_INV_ITEM', // 37
        'INVOICE_ITEM', // 38
        'MATERIAL_CODE', // 39
        'BILLED_QTY', // 40
        'SALES_DOCUMENT', // 41
        'SALES_DOCUMENT_ITEM', // 42
        'REFERENCE_DOCUMENT', // 43
        'REF_DOC_ITEM_NUMBER' // 44
    }; 

    private static final Map<String, String> sourceClusterUrlMap = new Map<String, String>{
        'CP1' => 'https://sapsso.lvs.dupont.com/CsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>',
        'GP1' => 'https://sapsso.lvs.dupont.com/LaunchWinTxnR3G?TCode=VA03&VBAK-VBELN=<Order Number>',
        'TP1' => 'https://sapsso.lvs.dupont.com/TsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>',
        'WP1' => 'https://sapsso.lvs.dupont.com/WsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>',
        // Following links are valid until QA, to be removed before deployment to production as the following links relate to QA environment (recommendation from Onshore over daily sync call at 4pm on 25th May, 2015)
        'CB1' => 'https://sapssoqa.lvs.dupont.com/CsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>',
        'GB2' => 'https://sapssoqa.lvs.dupont.com/LaunchWinTxnR3G?TCode=VA03&VBAK-VBELN=<Order Number>',
        'TB1' => 'https://sapssoqa.lvs.dupont.com/TsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>', 
        'WB1' => 'https://sapssoqa.lvs.dupont.com/WsystemLaunch?TCode=VA03&VBAK-VBELN=<Order Number>'
    };

    /**
     * @author sanchit.dua
     * @param cluster - The cluster value being fetched from the current Account Record's source cluster field value.
     * @return - The url to be placed
     */
    public static String getUrlToPlace(String cluster){
        String returnVal = INITIAL_VAL;
        returnVal = sourceClusterUrlMap.get(cluster);
        return returnVal;        
    } // END public static String getUrlToPlace(String cluster)

    private static final Map<String, String> sourceClusterUrlMapInv = new Map<String, String>{
        'CP1' => 'https://sapsso.lvs.dupont.com/CsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        'GP1' => 'https://sapsso.lvs.dupont.com/LaunchWinTxnR3G?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        'TP1' => 'https://sapsso.lvs.dupont.com/TsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        'WP1' => 'https://sapsso.lvs.dupont.com/WsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        // Following links are valid until QA, to be removed before deployment to production as the following links relate to QA environment (recommendation from Onshore over daily sync call at 4pm on 25th May, 2015)
        'CB1' => 'https://sapssoqa.lvs.dupont.com/CsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        'GB2' => 'https://sapssoqa.lvs.dupont.com/LaunchWinTxnR3G?TCode=VF03&VBRK-VBELN=<Invoice Number>',
        'TB1' => 'https://sapssoqa.lvs.dupont.com/TsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>', 
        'WB1' => 'https://sapssoqa.lvs.dupont.com/WsystemLaunch?TCode=VF03&VBRK-VBELN=<Invoice Number>'
    };

    
    public static String getUrlToPlaceInv(String cluster){
        String returnVal = INITIAL_VAL;
        returnVal = sourceClusterUrlMapInv.get(cluster);
        return returnVal;        
    } // END public static String getUrlToPlace(String cluster)
    /**
     * @author sanchit.dua
     * @param cluster - The cluster value being fetched from the current Account Record's source cluster field value.
     * @return - The combined SAPBOX and Client Code.
     */
    public static String getSAPBoxClients(String cluster){
        String returnVal = INITIAL_VAL;
        for( CS_SAPBoxClients__c sapBoxClient: CS_SAPBoxClients__c.getall().values() ){
            if(sapBoxClient.Name.equalsIgnoreCase(cluster)){
                returnVal = ( sapBoxClient.Name + sapBoxClient.CS_ClientCode__c ).substringBefore( DOT );
                break;
            }
        }

        return returnVal;        
    } // END public static String getSAPBoxClients(String cluster)

    /**
     * @author sanchit.dua
     * @param inputRequest - The deserialised object obtained from JSON either OrderRequest or InvoiceRequest
     * @return - the XML Payload / ERROR so formed is returned
     */
    public static String createRequestXmlPayload(Object inputRequest){
    
        String returnVal = INITIAL_VAL;
        // String urlToPlace = HASH;
        OrderRequest ord = NULL;
        InvoiceRequest inv = NULL;
        if(inputRequest instanceOf OrderRequest)
            ord = (OrderRequest) inputRequest;
        else
            inv = (InvoiceRequest) inputRequest;
        
        Date strDate = NULL;
        Date endDate = NULL;
        if(inputRequest instanceOf OrderRequest){
            strDate = Date.newInstance(Integer.valueOf(ord.fromDate.split(SLASH)[2]), Integer.valueOf(ord.fromDate.split(SLASH)[0]), Integer.valueOf(ord.fromDate.split(SLASH)[1]));
            endDate = Date.newInstance(Integer.valueOf(ord.toDate.split(SLASH)[2]), Integer.valueOf(ord.toDate.split(SLASH)[0]), Integer.valueOf(ord.toDate.split(SLASH)[1]));
        }else{
            strDate = Date.newInstance(Integer.valueOf(inv.fromDate.split(SLASH)[2]), Integer.valueOf(inv.fromDate.split(SLASH)[0]), Integer.valueOf(inv.fromDate.split(SLASH)[1]));
            endDate = Date.newInstance(Integer.valueOf(inv.toDate.split(SLASH)[2]), Integer.valueOf(inv.toDate.split(SLASH)[0]), Integer.valueOf(inv.toDate.split(SLASH)[1]));
        }
        if(endDate<strDate)
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, '\'To Date\' should be greater than or equal to \'From Date\''));
            return ENDDATEGREATER;
        
           
        /* AA : Commented the code as per requirement. Validation for 180 days between removed.
        if(strDate.daysBetween(endDate) > 180)
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Difference between \'To Date\' and \'From Date\' should not be greater than 90 days'));
            return STRDATEGREATER;
        */
        
        String startDate = INITIAL_VAL;
        String endDt = INITIAL_VAL;
        
        String strDay = INITIAL_VAL;
        String strMonth = INITIAL_VAL;
        
        String endDay = INITIAL_VAL;
        String endMonth = INITIAL_VAL;
        
        if(String.valueOf(strDate.day()).length() == 1)
            strDay = ZERO+strDate.day();
        else
            strDay = String.valueOf(strDate.day());
        
        if(String.valueOf(strDate.month()).length() == 1)
            strMonth = ZERO+strDate.month();
        else
            strMonth = String.valueOf(strDate.month());
        
        if(String.valueOf(endDate.day()).length() == 1)
            endDay = ZERO+endDate.day();
        else
            endDay = String.valueOf(endDate.day());
        
        if(String.valueOf(endDate.month()).length() == 1)
            endMonth = ZERO+endDate.month();
        else
            endMonth = String.valueOf(endDate.month());
        
        startDate = String.valueOf(strDate.year())+strMonth+strDay; // <!-- YYYYMMDD -->
        endDt = String.valueOf(endDate.year())+endMonth+endDay;
        String userID = INITIAL_VAL;
        String requestData = INITIAL_VAL;
        Integer lmt = Limits.getLimitQueryRows();
        try{
             userID = [SELECT id, EPass_ID__c FROM User WHERE id =: UserInfo.getUserId() LIMIT: lmt][0].EPass_ID__c;
        }catch(Exception ex) {
            return EXCPMESSAGE.replace(EXCPMSG, ex.getMessage());
        }
        if(String.isEmpty(userID))
            return EPASSNOTEXIST;
        try{
            if(inputRequest instanceOf OrderRequest){
                requestData = ORDERREQDATA.replace(CUSTOMERNUMBERPLACEHOLDER, ord.customerNumber).replace(CLUSTERPLACEHOLDER, ord.sourceCluster);
                String divisionCode = ord.division;
                
                if(divisionCode.length()==1)
                    divisionCode = ZERO+ord.division;
                String customerPOData = INITIAL_VAL;
                if(String.isEmpty(ord.customerPO.trim()))
                    requestData = requestData+BLANKCUSTOMERPO;
                else
                    requestData = requestData+WITHCUSTOMERPO.replace(CUSTOMERPOPLACEHOLDER, ord.customerPO.trim());
                
                if(String.isEmpty(ord.orderNo.trim()))
                    requestData = requestData + BLANKORDERNUMBER;
                else
                     requestData = requestData + WITHORDERNUMBER.replace(ORDERNOPLACEHOLDER, ord.orderNo.trim());
                
                returnVal = requestData + ORDERENVELOP.replace(DISTCHANNEL, ord.distributionChannel).replace(DIVCODE, divisionCode).replace(STRDATEPLACEHOLDER, startDate).replace(SALESORGPLACEHOLDER, ord.salesOrg).replace(ENDDATEPLACEHOLDER, endDt).replace(EPASSIDPLACEHOLDER, userID);
            } else{
                String div = inv.division.length() == 1 ? ZERO+inv.division : inv.division;
                requestData = INVOICEREQDATA.replace(CUSTOMERNUMBERPLACEHOLDER, inv.customerNumber).replace(DISTCHANNEL, inv.distributionChannel).replace(STRDATEPLACEHOLDER, startDate).replace(DIVCODE, div).replace(CLUSTERPLACEHOLDER, inv.cluster);
                
                if(String.isEmpty(inv.invoiceNo))
                    requestData = requestData+BLANKINVOICENUMBER;
                else 
                    requestData = requestData+WITHINVOICENUMBER.replace(INVOICENOPLACEHOLDER, inv.invoiceNo);
                
                returnVal = requestData + INVOICEENVELOP.replace(SALESORGPLACEHOLDER, inv.salesOrg).replace(ENDDATEPLACEHOLDER, endDt).replace(EPASSIDPLACEHOLDER, userID);
            }
        }catch(Exception ex){
            // system.debug('There got an error manipulating data in requestbody. Error: '+ex.getMessage());
            return EXCPMESSAGE.replace(EXCPMSG, ex.getMessage());
        }
        return returnVal;
    
    } // END ublic static String createRequestXmlPayload(Object inputRequest)

    /**
     * @author sanchit.dua
     * @param requestData - The request data or Xml Request Payload is passed
     * @param customSettingVal - The custom settings named CS_Settings__c is invoked for the value passed here either from Sandbox_Orders or Sandbox_Invoices
     * @return - The response body / ERROR is returned 
     */
    public static String invokeSAPService(String requestData, String customSettingVal){
    
        String returnVal = INITIAL_VAL;
        try{
            CS_Settings__c mySettings = CS_Settings__c.getInstance(customSettingVal);
            if(mySettings == null)
                return ENDPOINTNOTEXIST;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(POST);
            request.setHeader(CONTENTTYPE, CONTENTTYPEVAL);
            request.setBody(requestData);
            //system.debug('requestData set is: '+requestData);
            request.setendPoint(mySettings.end_point__c);
             // AA 08142015 -- Added Timeout for callout. 
            
            request.setTimeout(Integer.ValueOf(System.Label.CS_Integration_Timeout)); 
            HTTPResponse res = null; // new HttpResponse();
            res = http.send(request);
            if(!(res.getStatusCode() >= 200 && res.getStatusCode() < 300))
                return ERRCASTIRON.replace(RESPONSESTATUSCODE, String.valueOf(res.getStatusCode())).replace(RESPONSEBODYPLACEHOLDER, res.getBody());
            
            //Helpful debug messages
            // System.debug('STATUS:'+res.getStatus());
            // System.debug('STATUS_CODE:'+res.getStatusCode());
            // system.debug('body: '+res.getBody());
            returnVal = res.getBody();            
        } catch(System.CalloutException ex) {
            //Exception handling goes here....
            //system.debug('There got an error sending the request to Cast Iron. Error: '+ex.getMessage());
            return WS_EXCPMESSAGE.replace(EXCPMSG, ex.getMessage());
        }     
        return returnVal;    
    } // END public static String invokeSAPService(String requestData, String customSettingVal)

    
    /**
     * @author sanchit.dua
     * @param responseBody - The response Body
     * @param requestObject - The deserialised object obtained from JSON either OrderRequest or InvoiceRequest
     * @return XmlObjects reference is returned containing the generic maps named headerMap and lineItemMap
     */
    public static XmlObjects createXmlObjects(String responseBody, Object requestObject){
        XmlObjects returnVal = new XmlObjects();
        try{
            OrderRequest ord = null;
            InvoiceRequest inv = null;
            
            if(requestObject instanceOf OrderRequest)
                ord = (OrderRequest) requestObject;
            else
                inv = (InvoiceRequest) requestObject;
                
            Dom.Document doc = new Dom.Document();
            doc.load(responsebody);
            Dom.XMLNode rootElement = doc.getRootElement();        
            // getting the content of body => sp_0:Z_I00204_SO_DATA.Response
            
            for(Dom.XmlNode childelement: rootElement.getChildElements()[0].getChildElements()[0].getChildElements()){ // Body
                if(childelement.getChildElements() != null){
                    if(requestObject instanceOf OrderRequest){
                        if(childelement.getName().equals(headers.get(0))){ // 'T_SO_HEADER'
                            String orderNumber = INITIAL_VAL;
                            OrderHeader oh = new OrderHeader();
                            boolean proceedFurther = true;
                            for(Dom.XmlNode subchildelement: childelement.getChildElements()){ // Parsing the <Item>
                                if(!proceedFurther)
                                    proceedFurther = true;
                                    // continue;
                                
                                for(Dom.XmlNode subsubchildelement: subchildelement.getChildElements()){
                                      if(subsubchildelement.getName().equals(headers.get(1))){ // ORDER_NUMBER
                                          orderNumber = subsubchildelement.getText();      
                                          oh.orderNumber = orderNumber;  
                                          if(!String.isEmpty(ord.orderNo)){
                                              if(!orderNumber.equals(ord.orderNo.trim()))
                                                  proceedFurther = false;                                          
                                          }                                             
                                      } // END if(subsubchildelement.getName().equals('ORDER_NUMBER'))
                                      if(subsubchildelement.getName().equals(headers.get(2))) // 'SYSTEM'
                                          oh.sys = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(3))) // 'ORDER_TYPE'
                                          oh.orderType = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(4))) // 'ORDER_CREATE_DATE'
                                          oh.orderCreatedDate = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(5))) // 'SOLD_TO_CUSTOMER'
                                          oh.soldToCustomer = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(6))) // 'REQ_DELIVERY_DATE'
                                          oh.reqDeliveryDate = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(7))) // 'NET_VALUE'
                                          oh.netValue = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(8))) // 'DOC_CURRENCY'
                                          oh.docCurrency = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(9))) // 'DELIVERY_BLOCK'
                                          oh.deliveryBlock = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(10))) // 'BILLING_BLOCK'
                                          oh.billingBlock = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(11))) // 'CUSTOMER_PURCHASE_ORDER'
                                          oh.customerPurchaseOrder = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(12))) // 'SHIPPING_CONDITION'
                                          oh.shippingCondition = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(13))) // 'CREDIT_STATUS'
                                          oh.creditStatus = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(14))) // 'HEADER_USER_STATUS'
                                          oh.headerUserStatus = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(15))) // 'HEADER_USER_STATUS_DESC'
                                          oh.headerUserStatusDesc = subsubchildelement.getText();
                                } // END inner-most for
                                if(proceedFurther )
                                    returnVal.headerMap.put(orderNumber, oh);                            
                                oh = new OrderHeader();
                            } // END for                    
                        } // END if(childelement.getName().equals('T_SO_HEADER'))
                        
                        if(childelement.getName().equals(headers.get(16))){ // 'T_SO_ITEM'
                            OrderLineItem  oli = new OrderLineItem();
                            String orderNumber = INITIAL_VAL;
                            boolean proceedFurther = true;
                            
                            for(Dom.XmlNode subchildelement: childelement.getChildElements()){ // Parsing the <Item>
                                if(!proceedFurther)
                                    proceedFurther = true;
                                    // continue;
                                
                                for(Dom.XmlNode subsubchildelement: subchildelement.getChildElements()){
                                      if(subsubchildelement.getName().equals(headers.get(1))){ // 'ORDER_NUMBER'
                                          orderNumber = subsubchildelement.getText();      
                                          oli.orderNumber = orderNumber;    
                                          if(!String.isEmpty(ord.orderNo)){
                                              if(!orderNumber.equals(ord.orderNo.trim()))
                                                  proceedFurther = false;
                                          }            
                                      } // END if(subsubchildelement.getName().equals('ORDER_NUMBER'))
                                      if(subsubchildelement.getName().equals(headers.get(17))) // 'ITEM_NUMBER'
                                          oli.itemNumber = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(18))) // 'ITEM_CATEGORY'
                                          oli.itemCategory = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(19))) // 'PRODUCT_HIERARCHY'
                                          oli.productHierarchy = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(7))) // 'NET_VALUE'
                                          oli.netValue = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(20))) // 'CURRENCY'
                                          oli.curr = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(21))) // 'MATERIAL'
                                          oli.material = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(22))) // 'MATERIAL_DESCRIPTION'
                                          oli.materialDesc = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(23))) // 'ORDER_QUANTITY'
                                          oli.orderQuantity = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(24))) // 'SALES_UNIT'
                                          oli.salesUnit = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(25))) // 'ROUTE'
                                          oli.route = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(26))) // 'PLANT'
                                          oli.plant = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(27))) // 'SHIPPING_POINT'
                                          oli.shippingPoint = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(28))) // 'REASON_FOR_REJECTION'
                                          oli.reasonForRejection = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(29))) // 'LINE_ITEM_USER_STATUS'
                                          oli.lineItemUserStatus = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(30))) // 'LINE_ITEM_USER_STATUS_DESC'
                                          oli.lineItemUserStatusDesc = subsubchildelement.getText();
                                } // END inner-most for
                                if(proceedFurther){
                                    if(returnVal.lineItemMap.get(orderNumber) == null)
                                        returnVal.lineItemMap.put(orderNumber, new List<OrderLineItem>{oli});
                                    else{
                                        List<Object> oliList = returnVal.lineItemMap.get(orderNumber);
                                        oliList.add(oli);
                                        returnVal.lineItemMap.put(orderNumber, oliList);
                                    }
                                } // END if(proceedFurther)
                                oli = new OrderLineItem();
                            } // END for
                        } // END if(childelement.getName().equals('T_SO_ITEM'))
                    
                    } // END if(requestObject instanceOf OrderRequest)   
                    else{
                        if(childelement.getName().equals(headers.get(31))){ // 'T_INV_HEADER'
                            String invoiceNumber = INITIAL_VAL;
                            InvoiceHeader ih = new InvoiceHeader();
                            boolean proceedFurther = true;
                            // system.debug('the number of Item elements are: '+childelement.getChildElements().size());
                            for(Dom.XmlNode subchildelement: childelement.getChildElements()){ // Parsing the <Item>
                                if(!proceedFurther)
                                    proceedFurther = true;
                                    
                                for(Dom.XmlNode subsubchildelement: subchildelement.getChildElements()){
                                      if(subsubchildelement.getName().equals(headers.get(32))){ // 'INVOICE_NUMBER'
                                          invoiceNumber = subsubchildelement.getText();      
                                          ih.invoiceNumber = invoiceNumber;  
                                          if(!String.isEmpty(inv.invoiceNo)){ // TODO Invoice number to be got from the deserialized InvoiceRequest object
                                              if(!invoiceNumber.equals(inv.invoiceNo))
                                                  proceedFurther = false;
                                          }                                           
                                      } // END if(subsubchildelement.getName().equals('INVOICE_NUMBER'))
                                      if(subsubchildelement.getName().equals(headers.get(33))) // 'INVOICE_TYPE'
                                          ih.invoiceType = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(7))) // 'NET_VALUE'
                                          ih.netValue = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(34))) // 'BILLING_DATE'
                                          ih.billingDate = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(35))) // 'INVOICE_CREATE_DATE'
                                          ih.invoiceCreateDate = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(36))) // 'DOCUMENT_CURRENCY'
                                          ih.documentCurrency = subsubchildelement.getText();                              
                                } // END inner-most for
                                if(proceedFurther )
                                    returnVal.headerMap.put(invoiceNumber, ih);                            
                                ih = new InvoiceHeader();
                            } // END for                    
                        } // END if(childelement.getName().equals('T_INV_HEADER'))
                        
                        if(childelement.getName().equals(headers.get(37))){ // 'T_INV_ITEM'
                            InvoiceLineItem  ili = new InvoiceLineItem();
                            String invoiceNumber = INITIAL_VAL;
                            boolean proceedFurther = true;
                            
                            for(Dom.XmlNode subchildelement: childelement.getChildElements()){ // Parsing the <Item>
                                if(!proceedFurther)
                                    proceedFurther = true;
                                    
                                for(Dom.XmlNode subsubchildelement: subchildelement.getChildElements()){
                                    // invoiceNumber, invoiceItem, itemCategory, materialCode, materialDesc, billedQty, salesUnit, netValue, salesDocument, salesDocumentItem, referenceDocument, refDocItemNumber, productHierarchy, plant, shippingPoint;
                
                                      if(subsubchildelement.getName().equals(headers.get(32))){ // 'INVOICE_NUMBER'
                                          invoiceNumber = subsubchildelement.getText();      
                                          ili.invoiceNumber = invoiceNumber;  
                                            
                                          if(!String.isEmpty(inv.invoiceNo)){ // TODO: to be compared by InvoiceRequest deserialized object
                                              if(!invoiceNumber.equals(inv.invoiceNo))
                                                  proceedFurther = false;
                                          }          
                                      } // END if(subsubchildelement.getName().equals('INVOICE_NUMBER'))
                                      if(subsubchildelement.getName().equals(headers.get(38))) // 'INVOICE_ITEM'
                                          ili.invoiceItem = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(18))) // 'ITEM_CATEGORY'
                                          ili.itemCategory = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(39))) // 'MATERIAL_CODE'
                                          ili.materialCode = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(22))) // 'MATERIAL_DESCRIPTION'
                                          ili.materialDesc = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(40))) // 'BILLED_QTY'
                                          ili.billedQty = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(24))) // 'SALES_UNIT'
                                          ili.salesUnit = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(7))) // 'NET_VALUE'
                                          ili.netValue = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(41))) // 'SALES_DOCUMENT'
                                          ili.salesDocument = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(42))) // 'SALES_DOCUMENT_ITEM'
                                          ili.salesDocumentItem = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(43))) // 'REFERENCE_DOCUMENT'
                                          ili.referenceDocument = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(44))) // 'REF_DOC_ITEM_NUMBER'
                                          ili.refDocItemNumber = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(19))) // 'PRODUCT_HIERARCHY'
                                          ili.productHierarchy = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(26))) // 'PLANT'
                                          ili.plant = subsubchildelement.getText();
                                      if(subsubchildelement.getName().equals(headers.get(27))) // 'SHIPPING_POINT'
                                          ili.shippingPoint = subsubchildelement.getText();
                                } // END inner-most for
                                if(proceedFurther){
                                    if(returnVal.lineItemMap.get(invoiceNumber) == null)
                                        returnVal.lineItemMap.put(invoiceNumber, new List<InvoiceLineItem>{ili});
                                    else{
                                        List<Object> iliList = returnVal.lineItemMap.get(invoiceNumber);
                                        iliList.add(ili);
                                        returnVal.lineItemMap.put(invoiceNumber, iliList);
                                    }
                                } // END if(proceedFurther)
                                ili = new InvoiceLineItem();
                            } // END for
                        } // END if(childelement.getName().equals('T_INV_ITEM'))
                    } // END else             
                } // END if(childelement.getChildElements() != null)            
            } // END for
            return returnVal;
        }catch(Exception ex){
            returnVal.exceptionMessage = EXCPMESSAGE.replace(EXCPMSG, ex.getMessage());
            return returnVal;
        }
        
    } // END public static XmlObjects createXmlObjects(String responseBody, Object requestObject)


    /**
     * @author sanchit.dua
     *
     */
    public without sharing class OrderRequest{
    
        public String orderNo, customerPO, fromDate, toDate, distributionChannel, division, salesOrg, customerNumber, sourceCluster;
        
        /**
         * Default Constructor
         */
        public OrderRequest(){
            this.orderNo = INITIAL_VAL;
            this.customerPO = INITIAL_VAL;
            this.fromDate = INITIAL_VAL;
            this.toDate = INITIAL_VAL;
            this.distributionChannel = INITIAL_VAL;
            this.division = INITIAL_VAL;
            this.salesOrg = INITIAL_VAL;
            customerNumber = INITIAL_VAL;
            sourceCluster = INITIAL_VAL;
        } // END init()
    
    } // END public class OrderRequest

    /**
     * @author sanchit.dua
     *
     */
    public without sharing class InvoiceRequest{
    
        public String customerNumber, distributionChannel, division, fromDate, salesOrg, toDate, invoiceNo, cluster;

        /**
         * Default Constructor
         */
        public InvoiceRequest() {
            customerNumber = INITIAL_VAL;
            distributionChannel = INITIAL_VAL;
            division = INITIAL_VAL;
            fromDate = INITIAL_VAL;
            salesOrg = INITIAL_VAL;
            toDate = INITIAL_VAL;
            cluster = INITIAL_VAL;
            invoiceNo = INITIAL_VAL;
        } // END init()
    } // END public class InvoiceRequest
    
    /**
     * @author sanchit.dua
     *
     */
    public without sharing class OrderHeader{
        public String sys, orderNumber, orderType, orderCreatedDate, soldToCustomer, reqDeliveryDate, netValue, docCurrency, deliveryBlock, billingBlock, customerPurchaseOrder, shippingCondition, creditStatus, headerUserStatus, headerUserStatusDesc;
        
        /**
         * Default Constructor
         */
        public OrderHeader() {
            this.sys = INITIAL_VAL;
            this.orderNumber = INITIAL_VAL;
            this.orderType = INITIAL_VAL;
            this.orderCreatedDate = INITIAL_VAL;
            this.soldToCustomer = INITIAL_VAL;
            this.reqDeliveryDate = INITIAL_VAL;
            this.netValue = INITIAL_VAL;
            this.docCurrency = INITIAL_VAL;
            this.deliveryBlock = INITIAL_VAL;
            this.billingBlock = INITIAL_VAL;
            this.customerPurchaseOrder = INITIAL_VAL;
            this.shippingCondition = INITIAL_VAL;
            this.creditStatus = INITIAL_VAL;
            this.headerUserStatus = INITIAL_VAL;
            this.headerUserStatusDesc = INITIAL_VAL;
        } // END init()

    } // END public class OrderHeader

    /**
     * @author sanchit.dua
     *
     */
    public without sharing class OrderLineItem{
        public String orderNumber, itemNumber, itemCategory, productHierarchy, netValue, curr, material, materialDesc, orderQuantity, salesUnit, route, plant, shippingPoint, reasonForRejection, lineItemUserStatus, lineItemUserStatusDesc;

        /**
         * Default Constructor
         */
        public OrderLineItem() {
            this.orderNumber = INITIAL_VAL;
            this.itemNumber = INITIAL_VAL;
            this.itemCategory = INITIAL_VAL;
            this.productHierarchy = INITIAL_VAL;
            this.netValue = INITIAL_VAL;
            this.curr = INITIAL_VAL;
            this.material = INITIAL_VAL;
            this.materialDesc = INITIAL_VAL;
            this.orderQuantity = INITIAL_VAL;
            this.salesUnit = INITIAL_VAL;
            this.route = INITIAL_VAL;
            this.plant = INITIAL_VAL;
            this.shippingPoint = INITIAL_VAL;
            this.reasonForRejection = INITIAL_VAL;
            this.lineItemUserStatus = INITIAL_VAL;
            this.lineItemUserStatusDesc = INITIAL_VAL;
        } // END init()
        
    } // END public class OrderLineItem
    
    /**
     * @author sanchit.dua
     *
     */
    public without sharing class XmlObjects {
        public Map<String, Object> headerMap;
        public Map<String, List<Object>> lineItemMap;
        public String exceptionMessage;
        /**
         * Default Constructor 
         */
        public XmlObjects(){
             headerMap = new Map<String, Object>();
             lineItemMap = new Map<String, List<Object>>();
             exceptionMessage = INITIAL_VAL;
        } // END init()       
    } // END public class XmlObjects
    
    
    /**
     * @author sanchit.dua
     *
     */
    public without sharing class InvoiceHeader{
        
        public String invoiceNumber, invoiceType, billingDate, netValue, documentCurrency, invoiceCreateDate;
        
        /**
         * Default Constructor 
         */
        public InvoiceHeader() {
            invoiceNumber = INITIAL_VAL;
            invoiceType = INITIAL_VAL;
            billingDate = INITIAL_VAL;
            netValue = INITIAL_VAL;
            documentCurrency = INITIAL_VAL;
            invoiceCreateDate = INITIAL_VAL;
        } // END init()
    } // END public class InvoiceHeader

    /**
     * @author sanchit.dua
     *
     */
    public without sharing class InvoiceLineItem{
        
        public String invoiceNumber, invoiceItem, itemCategory, materialCode, materialDesc, billedQty, salesUnit, netValue, salesDocument, salesDocumentItem, referenceDocument, refDocItemNumber, productHierarchy, plant, shippingPoint;
        
        /**
         * Default Constructor
         */
        public InvoiceLineItem() {
            invoiceNumber = INITIAL_VAL;
            invoiceItem = INITIAL_VAL;
            itemCategory = INITIAL_VAL;
            materialCode = INITIAL_VAL;
            materialDesc = INITIAL_VAL;
            billedQty = INITIAL_VAL;
            salesUnit = INITIAL_VAL;
            netValue = INITIAL_VAL;
            salesDocument = INITIAL_VAL;
            salesDocumentItem = INITIAL_VAL;
            referenceDocument = INITIAL_VAL;
            refDocItemNumber = INITIAL_VAL;
            productHierarchy = INITIAL_VAL;
            plant = INITIAL_VAL;
            shippingPoint = INITIAL_VAL;
        } // END init()
    } // END public class InvoiceLineItem
    
} // END global with sharing virtual class util_CSIntegrationHelperClass
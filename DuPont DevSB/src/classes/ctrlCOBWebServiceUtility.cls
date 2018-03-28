/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Ankur Madaan
Email: Ankur_Madaan@infosys.com
Description:  Controller will be called To fetch the details of Customer From SAP System in real Time basis.
Changes : Alvin_Johnson@infosys.com 
          <Alvin20151014> Have updated the webservice production and sandbox passwords  
          <Bharagvi 20161013> Password is changed to hit the webservice  IS ID-00075611
 ********************************************************************************/ 

public with sharing class ctrlCOBWebServiceUtility {

    public static string invokesfdcWebService(String onboarding) {
        //<Alvin20150623> changed onboarding to string for extend scenario.Did corresponding change in line 30
        if(onboarding != null && onboarding != ''){
            Integer mod = 0;
            String responseXML = '';
            try {   
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint('https://pg3.pioneer.com/sfdc_E2E/Customer_SAP/service/GVCustomerGetDetail');
                //req.setEndpoint('https://pg3.pioneer.com/sfdc_E2E/Customer_SAP/service/GVCustomerGetDetail');
                req.setHeader('Content-Type', 'text/xml'); 
                //For Production...
                req.setHeader('SOAPAction', 'https://pg3.pioneer.com/sfdc_E2E/Customer_SAP/service/GVCustomerGetDetail');
                //req.setHeader('SOAPAction', 'https://pg3tx.pioneer.com:443/sfdc_E2E/Customer_SAP/service/GVCustomerGetDetail');
                //req.setHeader('SOAPAction', 'https://pg3.pioneer.com/sfdc_E2E/Customer_SAP/service/GVCustomerGetDetail');
                String username = 'ddsfdcci';
                //<Alvin20151014> Have updated the production and sandbox passwords
                //String password = '576tGFgtr%$%r9';  //For QA
                 //For PD...
                 String password = ')a9Y:kyan!dJ?6tD';  //<Bharagvi 20161013> changed the password
                
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                ERP_Customer__c dataReq=[Select id, Name, Customer_code__c, Source_Cluster__c, Distribution_Channel_Code__c , Division_Code__c, Sales_Org_Code__c from ERP_Customer__c Where Id =:onboarding];
                //Customer_Data_Request__c dataReq =[Select id, Name,Customer__r.Customer_code__c,Customer__r.Source_Cluster__c,Customer__r.Distribution_Channel_Code__c    ,Customer__r.Division_Code__c,Customer__r.Sales_Org_Code__c from Customer_Data_Request__c Where Id =:onboarding.Customer__C];
                string clust = '';
                string disCha = '';
                string Custnum = '';
                String Divison = '';
                String SalesOrg = '';

                if(dataReq != null){
                    if(dataReq.Customer_code__c !=null && dataReq.Customer_code__c !='')
                        Custnum='00'+dataReq.Customer_code__c;
                    if(dataReq.Distribution_Channel_Code__c  !=null && dataReq.Distribution_Channel_Code__c !='')
                        disCha=dataReq.Distribution_Channel_Code__c;
                    if(dataReq.Division_Code__c !=null && dataReq.Division_Code__c !=''){
                        Divison=dataReq.Division_Code__c;
                        if(Divison.length()==1)
                            Divison='0'+Divison;
                    }
                    if(dataReq.Sales_Org_Code__c !=null && dataReq.Sales_Org_Code__c !='')
                        SalesOrg=dataReq.Sales_Org_Code__c;
                    if(dataReq.Source_Cluster__c !=null && dataReq.Source_Cluster__c !='')
                        clust=dataReq.Source_Cluster__c;

                    String soapRequestXml = '<?xml version="1.0" encoding="utf-8"?>'
                        +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gvc="http://soap.sforce.com/schemas/class/GVCustomerGetDetail">'
                        +'<soapenv:Header/>'                  
                        +'<soapenv:Body>'
                        +'<gvc:Y_GVCUSTOMER_GETDETAIL>'
                        +'<gvc:Input>'
                        +'<gvc:SAP_INSTANCE>'+clust+'</gvc:SAP_INSTANCE>'
                        +'<gvc:PI_CUSTOMER>'+Custnum+'</gvc:PI_CUSTOMER>'
                        +'<gvc:PI_DIST_CH>'+disCha+'</gvc:PI_DIST_CH>'
                        +'<gvc:PI_DIVISION>'+Divison+'</gvc:PI_DIVISION>'
                        +'<gvc:PI_SALES_ORG>'+SalesOrg+'</gvc:PI_SALES_ORG>'
                        +'</gvc:Input>'
                        +'</gvc:Y_GVCUSTOMER_GETDETAIL>'
                        +'</soapenv:Body>'
                        +'</soapenv:Envelope>';
                    System.debug ('The request xml is ------------------- '+soapRequestXml);
                    req.setBody(soapRequestXml);
                    req.setTimeout(120000); // timeout in milliseconds     
                    Http http = new Http();
                   
                    HttpResponse res = http.send(req);
                    System.debug('Web Services Response:---------------- '+res.getBody());
                    responseXML = res.getBody();
                    Integer code = res.getStatusCode();
                    system.debug('Status Code: ---- '+code );
                    mod = code/100;         
                    if (mod == 2) {
                        return res.getBody();
                    }
                    else if (mod != 2){
                        Dom.Document doc = new Dom.Document();
                        doc.load(responseXML);
                        Dom.XMLNode env= doc.getRootElement();              
                        Dom.XMLNode businessExceptionNode = env.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('Fault', 'http://schemas.xmlsoap.org/soap/envelope/');
                        if(businessExceptionNode!=null){
                            String ErrorMessage=businessExceptionNode.getChildElement('faultstring','').getText();
                            String ErrorCode=businessExceptionNode.getChildElement('faultcode','').getText();
                            return ErrorMessage; 
                        }
                    }
                          
                }  
            } catch ( CalloutException ce ){
                return 'Unable to process the request.'; 
            } catch ( Exception e ){
                return 'Unable to process the request.'; 
            }       
        }
        return null;    }
}
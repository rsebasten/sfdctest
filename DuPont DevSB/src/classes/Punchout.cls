/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Punchout main class

Modifications:
    TES20090903     Send Contract status details
    TES20100722     Extrapolated unit tests to Punchout_UT
    TES20100928     JanW: "put in place a check that the Result must equal Gain, Save or Upgrade before they are able 
                    to click the Send to Customer Service (or Submit to Order - coming) button within OMS"
    TES20100323     add Results: Demo, Goodwill, Change of DuPont Distributor to TES20100928
    TES20120723     updated getBIPUrl() to use the Util.IsProduction to determine correct Url.
    RB20141117      Rajiv Kumar Bhatter
    Description:    Removing the variable refinisherAmount , and removing the If condition where this variable was used.
                    This variable was being assigned to the Refinisher_Payment__c field, so we removed this line. Removed the field Refinisher_Payment__c
                    from the Select query as well.
    NC20141125      Nishant Chopra
    Description:    Adding a test exception class so that it can be thrown.
                    Adding a public method in order to call a private method
********************************************************************************/
public class Punchout {

    public static boolean ISTESTING = false;
    public static final string PUNCHOUT_REQUEST_RTYPEID = (string) Request__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('BI-NA Sample Request').recordTypeId;    //'012R00000000Gxe';
    
///////////////////////////////////////////////////////////////////////////////////   
//  The buyercookie for these requests is broken into three fields
    public class BuyerCookie {
        public string orgId  {set; get;}
        public string id        {set; get;}
        public string service   {set; get;}
        public BuyerCookie() {}
        public BuyerCookie(string buyercookie) {
            //try {
                this.orgId=buyercookie.substring(0,18);
                this.id=buyercookie.substring(18,36);
                this.id=this.id.replace('_',''); //sometimes the id is represented by 15 chars not 18
                
                if (buyercookie.lastindexof('_')!=-1)
                    service=buyercookie.substring(buyercookie.lastindexof('_')+1).toLowerCase();
            //}
            //catch (exception e) {
                
            //}
        }
    }
/////////////////////////////////////////////////////////////////////////////////////////////////// 
    
    
    public interface IPunchoutService {
        //string getPunchoutSite();
        PageReference onInit(MAP<string,string> params);
        string getSetupRequest();
        string getSetupRequestURL();
        PageReference onBrowserPost(cXML.PunchOutOrderMessage poom);
        PageReference onCancel(cXML.PunchOutOrderMessage poom);
    }
    
    public static Punchout.IPunchoutService getService(string serviceType, string refid) {
        serviceType = serviceType.toLowercase();
        if    (serviceType=='bip')          return new Punchout_BIP(refid);
        else if (serviceType=='colornet')      return new Punchout_Colornet(refid); 
        else 
            return null;
        }
        
  /////////////////////////////////////////////////////////////////////////////////////////////////// 


/********************************************************************************************************
    OMSProduct
********************************************************************************************************/

public class OMSProduct {
    public string quantity {set; get;}
    public string unitPrice {set; get;}
    public string description {set; get;}
    public string supplierPartID {set; get;} 
    public string unitOfMeasure {set; get;}
    public string distributorAmount {set; get;}
    public string distributorQty {set; get;}
    public string distributorShip {set; get;}
    //RB20141117 Removed the variable refinisherAmount 
    public string dupontAmount {set; get;}
    public string dupontQty {set; get;}
    public string dupontShip {set; get;}    
    public string requestedDeliveryDate {set; get;}
    
    public OMSProduct(cxml.Item i) {
        this.supplierPartID=i.supplierPartID;
        this.unitOfMeasure=i.unitOfMeasure;
        this.description=i.description;
        this.unitPrice=i.unitPrice;
        if (i.extrinsics.containskey('DupontQty'))            this.dupontQty = i.extrinsics.get('DupontQty');
        if (i.extrinsics.containskey('DupontAmount'))          this.dupontAmount = DecimaltoCurrency( Decimal.valueof(i.extrinsics.get('DupontAmount')));
        if (i.extrinsics.containskey('DupontShip'))          this.dupontShip = i.extrinsics.get('DupontShip');   
        if (i.extrinsics.containskey('DistributorQty'))      this.distributorQty = i.extrinsics.get('DistributorQty');
        //RB20141117 Removed the variable RefinisherAmount from the IF condition
        if (i.extrinsics.containskey('DistributorAmount'))    this.distributorAmount = DecimaltoCurrency( Decimal.valueof(i.extrinsics.get('DistributorAmount')));  
        if (i.extrinsics.containskey('DistributorShip'))        this.distributorShip = i.extrinsics.get('DistributorShip');
        if (i.extrinsics.containskey('RequestedDeliveryDate'))  this.requestedDeliveryDate = i.extrinsics.get('RequestedDeliveryDate');
    }
}


/********************************************************************************************************
    Punchout_Colornet
*******************************************************************************************************/
public class Punchout_Colornet implements Punchout.IPunchoutService {
    
    private string OMS_PUNCHOUT_URL = getBIPUrl()+'/colornet/sts/OMSBIPEndPoint/colornet';
    private string parentId;
    private Request__c request;

    public Punchout_Colornet(string aParentId) {
            //if (aParentId == null) THROW ERR
            parentId = aParentId;
        }
    
    
    public virtual PageReference OnInit(MAP<string,string> params) {
        return null;
        }

    public virtual string getSetupRequestURL() { return OMS_PUNCHOUT_URL; }
        
    public virtual string getSetupRequest() {
            Equipment__c equipment;
            string accountid;
            string operation='create';
            string cartid=null;
                        
            // new request on Equipment
            if ( parentId.startswith(Equipment__c.sObjectType.getDescribe().getKeyPrefix()) ) {
                //equipment = [SELECT Support_ID__c, Account_Name__c FROM Equipment__c where Id=:parentId];
                equipment = [SELECT Account_Name__c FROM Equipment__c where Id=:parentId];
                accountid = equipment.Account_Name__c;
                operation='create';
                cartid=null;
            
            }
            // existing request  
            else if ( parentId.startswith(Request__c.sObjectType.getDescribe().getKeyPrefix()) ) {
                request=Punchout.getRequestInfo(parentId);
                if (request != null) {
                    cartid=request.ExternalRequestId__c;
                    accountid=request.account__c;
                    //equipment=request.equipment__r;
                    operation=getOperationByRequest(request);   
                }
                else {
                    //thow error
                }
            }
            //ERROR: Unsupported Id
            else {
                //thow error
            }
 
        ///////////////////////////////////////////////////////////////////////////////////
        //Construct PunchoutSetupRequest payload and send
        ///////////////////////////////////////////////////////////////////////////////////
        string browserPostUrl = Punchout.getBrowserPostUrl(Page.Punchout_BPHandler);
        cxml.SetupRequest setupReq = new cxml.SetupRequest(operation,UserInfo.getOrganizationId()+parentid+'___colornet',browserPostUrl,cartid);
        
        setupReq.extrinsics.put('request.type__c','colornet');
        if (cartid != null) setupReq.extrinsics.put('cart.id',cartid); 
        //if (equipment!=null) setupReq.extrinsics.put('equipment.support_id__c',equipment.Support_ID__c); 
        
        getExtrinsicsByAccountId(setupReq,accountid);
        return cxml.createMessage(setupReq, OMS_CreateCxmlHeader());
    }
    
    public virtual PageReference onBrowserPost(cXML.PunchOutOrderMessage poom) {
        Request__c request = ProcessRequest(poom);
        if ( request== null) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'onBrowserPost: Unable to determine Request.'));
            return null;
        }
        upsert request;
        
        PageReference page = new PageReference('/'+this.parentid );
        page.setRedirect(true);
        return page;
    }
    public virtual PageReference OnCancel(cXML.PunchOutOrderMessage poom) {return null;}    
}


/********************************************************************************************************
    Punchout_BIP
*******************************************************************************************************/
public class Punchout_BIP implements Punchout.IPunchoutService {
    
    private string OMS_PUNCHOUT_URL = getBIPUrl()+'/colornet/sts/OMSBIPEndPoint/bip';
    private string parentId;
    private Request__c request;
    private Opportunity_Investment__c oppInv;
    
    
    public Punchout_BIP(string aParentId) {
            parentId = aParentId;
        }
    
    public virtual PageReference OnInit(MAP<string,string> params) {
        ID RTYPE_OI_PRODUCTS=Opportunity_Investment__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Recurring Rebate Allowance').recordTypeId;    
            
        //if (params.get('type') != bip) throw error
        
        string paramId = params.get('id');

        ///////////////////////////////////////////////////////////////////////////////////
        //BIP request Handler from Opportunity
        //lookup/create product Opportunity_Investment and redirect back with Opportunity_Investment Id
        ///////////////////////////////////////////////////////////////////////////////////      
        if ( paramId.startswith(Opportunity.sObjectType.getDescribe().getKeyPrefix()) ) {
             //only a single Opportunity_Investment__c of RTYPE:Product can be created on the Opportunity
             Id redirectId;
             Opportunity_Investment__c[] oiobj = [SELECT id FROM Opportunity_Investment__c WHERE Opportunity__c=:paramId AND RecordTypeId=: RTYPE_OI_PRODUCTS LIMIT 1];
             if (oiobj != null && oiobj.size()>0)
                redirectId=oiobj[0].id;
             else {
                Opportunity_Investment__c oi = new Opportunity_Investment__c(name='Products', Opportunity__c=paramId, RecordTypeId=RTYPE_OI_PRODUCTS);
                insert oi;
                redirectId=oi.id;
             }
            PageReference p = Page.Punchout_OMS;
            p.getParameters().put('id', String.valueOf(redirectId));
            p.getParameters().put('type', 'bip');
            p.setRedirect(true);
            return p;
        }   
        return null;
    }
    
    public virtual string getSetupRequestURL() { return OMS_PUNCHOUT_URL; }
    public virtual string getSetupRequest() {
        string accountid;
        string operation='create';
        string cartid=null;
        
        // existing request  
        if ( parentId.startswith(Request__c.sObjectType.getDescribe().getKeyPrefix()) ) {
            request=Punchout.getRequestInfo(parentId);
        }
        else if ( parentId.startswith(Opportunity_Investment__c.sObjectType.getDescribe().getKeyPrefix()) ) {
            //only a single request can be created on the Opportunity_Investment
            //so first check to see if a request already exists
            /*Request__c[] reqobj = [SELECT id FROM Request__c WHERE Opportunity_Investment__c=:parentId LIMIT 1];
            if (reqobj != null && reqobj.size()>0) {
                parentId=reqobj[0].id;
                request=Punchout.getRequestInfo(parentId);
            }
            else {*/
                oppInv = [
                    //SELECT Id, Opportunity__r.AccountId, Opportunity__r.Id, Opportunity__r.Result__c,
                    SELECT Id, Opportunity__r.AccountId, Opportunity__r.Id,
                    //SELECT Id, Opportunity__r.AccountId, Opportunity__r.Id, Opportunity__r.Sales_Program__c, Opportunity__r.Result__c,
                    Opportunity__r.Approval_Status__c, opportunity__r.ship_support_checklist__c, opportunity__r.contract_required__c
                    FROM Opportunity_Investment__c WHERE Id=:parentId
                    ];
                accountid = oppInv.Opportunity__r.AccountId;
                operation='create';
            //}           
        }
        else {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'getSetupRequest(): Invalid Parent: '+parentId));
        }    

        if (request != null ) {
            cartid=request.ExternalRequestId__c;
            accountid=request.account__c;
            //oppInv=request.Opportunity_Investment__r;
            operation=getOperationByRequest(request);   
        }
 
        if (OppInv!=null && OppInv.opportunity__r !=null) {
            if ( OppInv.opportunity__r.Approval_Status__c=='Approved' || OppInv.opportunity__r.Approval_Status__c =='Submitted' )
                operation='inspect';
        }
        
        ///////////////////////////////////////////////////////////////////////////////////
        //Construct PunchoutSetupRequest payload and send
        ///////////////////////////////////////////////////////////////////////////////////
        string browserPostUrl = Punchout.getBrowserPostUrl(Page.Punchout_BPHandler);
        cxml.SetupRequest setupReq = new cxml.SetupRequest(operation,UserInfo.getOrganizationId()+parentid+'___bip',browserPostUrl,cartid);
        
        setupReq.extrinsics.put('request.type__c','bip');
        if (cartid != null) setupReq.extrinsics.put('cart.id',cartid); 
        if (OppInv!=null && OppInv.opportunity__r !=null) {
            if (OppInv.opportunity__r.Id != null) setupReq.extrinsics.put('opportunity.id',OppInv.opportunity__r.Id); 
            if (OppInv.opportunity__r.Id != null) setupReq.extrinsics.put('opportunity.url','https://'+Util.POD+'.salesforce.com/'+OppInv.opportunity__r.Id); 
            //if (OppInv.opportunity__r.sales_program__c != null) setupReq.extrinsics.put('opportunity.sales_program__c',OppInv.opportunity__r.sales_program__c); 
            if (OppInv.opportunity__r.Approval_Status__c != null) setupReq.extrinsics.put('opportunity.approval_status__c',OppInv.Opportunity__r.Approval_Status__c);
            //if (OppInv.Opportunity__r.PO_Number__c != null) setupReq.extrinsics.put('opportunity.po_number__c',OppInv.Opportunity__r.PO_Number__c);
            string lastapprover=getLastApprover(OppInv.opportunity__r.id);
            if (lastapprover != null) setupReq.extrinsics.put('opportunity.final_approver',lastapprover);   
            

            //TES20090903 Send Contract status details
            if (OppInv.opportunity__r.ship_support_checklist__c != null) setupReq.extrinsics.put('opportunity.ship_support_checklist__c',OppInv.Opportunity__r.ship_support_checklist__c);        
            if (OppInv.opportunity__r.contract_required__c != null) setupReq.extrinsics.put('opportunity.contract_required__c',OppInv.Opportunity__r.contract_required__c); 
            string contractstatus=getLastApprover(OppInv.opportunity__r.id);
            if (contractstatus != null) setupReq.extrinsics.put('contract.status',contractstatus);  

            //TES20100928 and TES20100323  added new Biz logic see below:
            // JanW: put in place a check that the Result must equal Gain, Save or Upgrade before they are able to click the
            // "Send to Customer Service (or Submit to Order - coming) button" within OMS
            // IreneM: Right now, when SF sends  <Extrinsic name="opportunity.approval_status__c">Approved</Extrinsic> the 'Send to Customer Service' button appears.
            SET<string> absoluteResults = new SET<string> {'Gain', 'Save','Upgrade', 'Demo', 'Goodwill', 'Change of DuPont Distributor'};
            /*KRISH to Commentout Opportunity.Result__c
            if (OppInv.opportunity__r.Approval_Status__c=='Approved' &&
                (! absoluteResults.contains(OppInv.opportunity__r.result__c))
                ) {
                    setupReq.extrinsics.put('opportunity.approval_status__c','Approved - Awaiting Result');
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.Warning,'To submit the order in OMS,  The Opportunity Result must be a "Change of DuPont Distributor", "Demo", "Gain", "Goodwill", "Save" or "Upgrade".  Please click on the Cancel button to return to the Opportunity and Close it.  Then click the OMS button to Send to Customer Service.'));
                }*/
            //END TES20100928 and TES20100323
        }

        
        
        getExtrinsicsByAccountId(setupReq,accountid);
        return cxml.createMessage(setupReq, OMS_CreateCxmlHeader());
    }

    public virtual PageReference onBrowserPost(cXML.PunchOutOrderMessage poom) {
        string returnId = this.parentid; 
        Request__c request = ProcessRequest(poom);
        
        if ( request== null) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'onBrowserPost: Unable to determine Request.'));
            return null;
        }
        upsert request;
        
        //KRISH commented to remove reference Request__c.Opportunity_Investment__c
        /*if ( request.Opportunity_Investment__r != null) {
            Opportunity_Investment__c oi = request.Opportunity_Investment__r;
            
            //Update the values for DupontAmount and DistributorAmount
            oi.DuPont_Payment__c=SumItems(poom.getItems(),'DupontAmount');  
            oi.Distributor_Payment__c=SumItems(poom.getItems(),'DistributorAmount');
            //RB20141117 The value RefinisherAmount was getting assigned to the field Refinisher_Payment__c .
            try { 
                update oi;
            }
            catch (Exception ex) {
                //PageReference page = new PageReference('/'+request.Opportunity_Investment__c );
                PageReference page = new PageReference( );
                page.setRedirect(false);
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,
                'Error updating Opportunity Investment for Products: '+ex.getMessage()));
                return null;
            }
            
            
            //Set the Return URL to the Opp (BIP)
            if (request.Opportunity_Investment__r.Opportunity__c!=null) {
                returnId=request.Opportunity_Investment__r.Opportunity__c;  
                //requestedDeliveryDate=poom.getItems()[0].extrinsics.get('someitem');
                //update new Opportunity(id=returnId, someoppfield=requestedDeliveryDate);
            }

        }*/
        
        
        PageReference page = new PageReference('/'+returnId );
        page.setRedirect(true);
        return page;
    }
    
    
    public virtual PageReference OnCancel(cXML.PunchOutOrderMessage poom) {
        //Get the BuyerCookie object
        Request__c request = GetRequestByCookie(new Punchout.BuyerCookie(poom.buyercookie));
        /*if ( request!=null && request.Opportunity_Investment__r.Opportunity__c != null )
                return new PageReference('/'+request.Opportunity_Investment__r.Opportunity__c );
        else
            return null;*/
        return null;
    }   
    
    /*
    public Cxml.PunchOutOrderMessage RetrieveBIPInfo(Request__c request) {
        Cxml.PunchOutOrderMessage poom;
        string browserPostUrl = PunchOut.getBrowserPostUrl(Page.Punchout_BPHandler);
        cxml.SetupRequest setupReq = new cxml.SetupRequest('inspect',UserInfo.getOrganizationId()+request.id,browserPostUrl,request.ExternalRequestId__c);
        setupReq.extrinsics.put('operation','RetrieveBIPInfo');
        setupReq.extrinsics.put('cart.id',request.ExternalRequestId__c); 
        string resp = Punchout.sendRequest(cxml.createMessage(setupReq, OMS_CreateCxmlHeader()), OMS_PUNCHOUT_URL);
        try {
            poom = new Cxml.PunchOutOrderMessage(resp);
        }
        catch (Exception ex) {
            system.debug('Error parsing POOM: ' + resp + '  Exception: '+ ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Unexpected OMS Exception:'+ex+' cxml:response:'+resp));
            return null;
        }
        return poom;
    }
    */
    
}


/********************************************************************************************************
    HELPER Methods
*******************************************************************************************************/


   ///////////////////////////////////////////////////////////////////////////////////////////////////   
    //TODO: pass username and get password from encrypted or hidden field in List__c
    private static string getOperationByRequest(Request__c request) {
        if (request!=null && request.ExternalRequestId__c != null) {
            if (request.Stage__c != 'Capture') 
                return 'inspect';   
            else
                return 'edit';
        }
        return 'create' ;
    }


   ///////////////////////////////////////////////////////////////////////////////////////////////////   
    //TODO: pass username and get password from encrypted or hidden field in List__c
    public static cxml.Header OMS_CreateCxmlHeader() {
        cxml.Header hdr = new cxml.Header();
        hdr.getEntries().add(new cxml.headerentry('From','force.com', 'SFDC'));
        hdr.getEntries().add(new cxml.headerentry('To','DupontCSC', 'OMS'));
        hdr.getEntries().add(new cxml.headerentry('Sender',UserInfo.getOrganizationId()+'@force.com', UserInfo.getUserName().replace('.dmx','.test'),'Pa$$W04D'));
        return hdr;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////   
    
    private static void getExtrinsicsByAccountId(cxml.SetupRequest req, Id accountId ) {

        try {
            Schema.DescribeSObjectResult dsrAccount = Account.SObjectType.getDescribe();
            Account acc = [
                Select a.Id, a.Name, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCity, a.Phone, a.Country__c, a.fax, a.ERP_Company_Code__c, a.ERP_Customer_Sold_To__c,
                        a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCity,
                        d.id, d.ERP_Company_Code__c, d.ShippingState, d.ShippingPostalCode, d.ShippingCity, d.ERP_Customer_Sold_To__c,
                        (Select c.email, c.phone, c.fax from Contacts c where recordType.DeveloperName='RefJEDICompanyMailingAddress' LIMIT 1)
                From Account a, a.Distributor__r d
                where id=: accountId
                ];
                
            //Add Account fields    
            for (string fld : dsrAccount.fields.getMap().keyset() ) {
                try {
                    string val = String.valueOf(acc.get(fld));
                    if ( val != null) {
                        //if (fld=='id') 
                        //  req.extrinsics.put('account.'+fld,'0013000000LyWoIAAV');  //PROD ID
                        //else 
                            req.extrinsics.put('account.'+fld,val);
                    }
                }
                catch( Exception ex ) {}
            }
            
            //START TESII_20091028
            //copy billing to shipping extrinsics if ShippingState null
            if (acc.ShippingState == null )
                {
                req.extrinsics.put('account.shippingstreet',acc.BillingStreet);
                req.extrinsics.put('account.shippingpostalcode',acc.BillingPostalCode);
                req.extrinsics.put('account.shippingstate',acc.BillingState);
                req.extrinsics.put('account.shippingcity',acc.BillingCity);
                }
            //END TESII_20091028
            

    
            //Add Distributor Fields
           if (acc.distributor__c == null || acc.distributor__r.ERP_Customer_Sold_To__c == null) {
                req.extrinsics.put('distributor.id',acc.id);
                req.extrinsics.put('distributor.erp_company_code__c',acc.erp_company_code__c);
                req.extrinsics.put('distributor.erp_customer_sold_to__c',acc.ERP_Customer_Sold_To__c);
                if (acc.ShippingState != null ) {
                    req.extrinsics.put('distributor.shippingstate',acc.ShippingState);
                    req.extrinsics.put('distributor.shippingcity',acc.ShippingCity);
                }
                else {
                    req.extrinsics.put('distributor.shippingstate',acc.BillingState);
                    req.extrinsics.put('distributor.shippingcity',acc.BillingCity);
                }

           }
            else {
                req.extrinsics.put('distributor.id',acc.distributor__r.id);
                req.extrinsics.put('distributor.erp_company_code__c',acc.distributor__r.erp_company_code__c);
                req.extrinsics.put('distributor.shippingstate',acc.distributor__r.ShippingState);
                req.extrinsics.put('distributor.shippingcity',acc.distributor__r.ShippingCity);
                req.extrinsics.put('distributor.erp_customer_sold_to__c',acc.distributor__r.ERP_Customer_Sold_To__c);
            }
            
            //Add contact fields
            if (acc.Contacts!=null && acc.Contacts.size()>0) {
                if (acc.Contacts[0].email != null)  req.extrinsics.put('contact.email',acc.Contacts[0].email);
                //if (acc.Contacts[0].phone != null)    req.extrinsics.put('contact.phone',acc.Contacts[0].phone);
                //if (acc.Contacts[0].fax != null)  req.extrinsics.put('contact.fax',acc.Contacts[0].fax);
            }
        }
        catch (exception e) {}
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////   
    private static Request__c getRequestInfo(string requestId) {
        Request__c request = [  SELECT Id, ExternalRequestId__c, Stage__c, Status__c, Account__c, Type__c
             //Equipment__c, Equipment__r.Support_Id__c 
             //Opportunity_Investment__c,  Opportunity_Investment__r.Opportunity__r.Id, Opportunity_Investment__r.Opportunity__r.Result__c,
             //Opportunity_Investment__r.Opportunity__r.Sales_Program__c, Opportunity_Investment__r.Opportunity__r.Approval_Status__c,
             //Opportunity_Investment__r.opportunity__r.ship_support_checklist__c, Opportunity_Investment__r.opportunity__r.contract_required__c
            FROM Request__c
            WHERE id=: requestId
            ];
        return request;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static string getBrowserPostUrl(System.PageReference pageref) {
            return 'https://'+ApexPages.CurrentPage().getHeaders().get('Host')+pageref.getURL();
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static string sendRequest(string req, string url ) { return sendRequest(req, url, null); }
    public static string sendRequest(string req, string url, string testResponse) {
        system.debug('==========PUNCHOUT REQUEST==============='+req);
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');
        request.setEndpoint(url);
        request.setBody(req);
        request.setTimeout(60000);
        Http http = new http();
        string response = (testResponse==null) ? http.send(request).getBody() : testResponse;
        system.debug('==========PUNCHOUT RESPONSE==============='+response);
        return response;
    }
    
    
    
///////////////////////////////////////////////////////////////////////////////////  
    private static Request__c ProcessRequest(cXML.PunchOutOrderMessage poom) {
        
        BuyerCookie bcookie = new BuyerCookie(poom.buyercookie);
        Request__c request = GetRequestByCookie(bcookie);   
        
        if ( request != null) {
    
            if (request.ExternalRequestId__c == null) {
                    request.ExternalRequestId__c=poom.getItems()[0].supplierPartAuxiliaryID;
            }
            else {
                if (request.ExternalRequestId__c != poom.getItems()[0].supplierPartAuxiliaryID ) {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'ExternalRequestId__c conflict.'));
                    return null;
                }          
            }      
                
            if (request.Stage__c != 'submitted') {
                if (poom.operationAllowed=='inspect')
                    request.Stage__c='submitted';
            }
        }
        return request;
            
    }
  ///////////////////////////////////////////////////////////////////////////////////  
    private static Request__c GetRequestByCookie(BuyerCookie buyercookie) {
        
            Request__c request;

            string parentId=buyercookie.id;
            
            ///////////////////////////////////////////////////////////////////////////////////
            //Existing Request
            ///////////////////////////////////////////////////////////////////////////////////
            if ( parentId.startswith(Request__c.sObjectType.getDescribe().getKeyPrefix()) ) {
                try {
                //RB20141117 Removing the field Refinisher_Payment__c from the Select query     
                request = [ Select Id, ExternalRequestId__c, Stage__c, Type__c
                            //Opportunity_Investment__r.DuPont_Payment__c, Opportunity_Investment__r.Distributor_Payment__c, 
                            //Opportunity_Investment__r.Opportunity__c
                            FROM Request__c 
                            Where Id=:parentId
                        ];
                }
                catch (exception ex)    {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.FATAL,'Request no longer exists: '+parentId));
                    return null;
                }
            }
            
            ///////////////////////////////////////////////////////////////////////////////////
            //New Colornet Request Handler
            //Colornet Request are created from Equipment
            //multiple request can be created for one piece of Equipment
            ///////////////////////////////////////////////////////////////////////////////////
            else if ( parentId.startswith(Equipment__c.sObjectType.getDescribe().getKeyPrefix()) ) {
                id accountid = [SELECT Account_Name__c FROM Equipment__c where Id=:parentId].Account_Name__c;
                //request = new Request__c(Equipment__c=parentId, Type__c='ColorNet', Stage__c='Capture', Status__c='In Progress', 
                request = new Request__c(Type__c='ColorNet', Stage__c='Capture', Status__c='In Progress', 
                    Account__c=accountid, RecordTypeId=PUNCHOUT_REQUEST_RTYPEID );
            }

            
            ///////////////////////////////////////////////////////////////////////////////////
            //BIP request Handler
            //BIP Request are created from Opportunity_Investment
            ///////////////////////////////////////////////////////////////////////////////////
            else if ( parentId.startswith(Opportunity_Investment__c.sObjectType.getDescribe().getKeyPrefix()) ) {
                Opportunity_Investment__c OppInv = [SELECT Id, Opportunity__r.AccountId FROM Opportunity_Investment__c WHERE Id=:parentId];
                
                //request = new Request__c(Opportunity_Investment__r=OppInv, Opportunity_Investment__c=OppInv.id,  Type__c='BIP', Stage__c='Capture', Status__c='In Progress', 
                request = new Request__c(Type__c='BIP', Stage__c='Capture', Status__c='In Progress', 
                    Account__c=OppInv.Opportunity__r.AccountId, RecordTypeId=PUNCHOUT_REQUEST_RTYPEID );
            }

        return request;
        
    }
    
///////////////////////////////////////////////////////////////////////////////////
    private static decimal SumItems(LIST<cxml.Item> items, string extrinsicName ) {
        decimal sum=0;
        for (cxml.Item i : items) {
            if (i.extrinsics.containsKey(extrinsicName)) {
                sum+=decimal.valueOf(i.extrinsics.get(extrinsicName));
            }
        }
        return sum;
    }
/////////////////////////////////////////////////////////////////////////////////// 
    private static string getLastApprover(string OppId) {
        
        ProcessInstanceStep[] pis = new List<ProcessInstanceStep>([
            Select Actor.name From ProcessInstanceStep
                 where ProcessInstance.TargetObjectId=:OppId  and ProcessInstance.Status='Approved'
                 order by CreatedDate desc LIMIT 1
            ]);
        
        if (pis.size()>0)
            return pis[0].Actor.name;
        else
            return null;
    }
 
  ///////////////////////////////////////////////////////////////////////////////////   
    private static string c(string OppId) {
        
        List<Contract> c = new List<Contract>([
            Select Status From Contract
                 where Opportunity__c=:OppId  and Status='Activated'
                 order by CreatedDate desc LIMIT 1
            ]);
        
        if (c.size()>0)
            return c[0].Status;
        else
            return null;
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////
// getOMSProducts:
//  returns null if successful otherwise error msg
//  request with (id and ExternalRequestId__c), 
//////////////////////////////////////////////////////////////////////////////////////////////

    public static string getOMSProducts(Request__c req, LIST<OMSProduct> prods) {
        string samplePOOM = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="3ddd"><Identity>support@3ddd.com</Identity></Credential><UserAgent>PunchOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>OPPID</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">15000.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="10"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">500.00</Money></UnitPrice><Description xml:lang="en">Test Product 1</Description><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1a</Classification><Classification domain="CLASS2">classification 2a</Classification></ItemDetail></ItemIn><ItemIn quantity="4"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">2500.00</Money></UnitPrice><Description xml:lang="en">Test Product 2</Description><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1b</Classification><Classification domain="CLASS2">classification 2b</Classification></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';
        
        Punchout.IPunchoutService svc = Punchout.getService('BIP', req.id);
        string browserPostUrl = PunchOut.getBrowserPostUrl(Page.Punchout_BPHandler);

        cxml.SetupRequest setupReq = new cxml.SetupRequest('inspect',UserInfo.getOrganizationId()+req.id+'___bip',browserPostUrl,req.ExternalRequestId__c);
        setupReq.extrinsics.put('operation','RetrieveBIPInfo');
        setupReq.extrinsics.put('cart.id',req.ExternalRequestId__c); 
        string resp;
        if (ISTESTING)
            resp=samplePOOM;
        else
            resp = Punchout.sendRequest(cxml.createMessage(setupReq, Punchout.OMS_CreateCxmlHeader()), svc.getSetupRequestURL());   
        
        Cxml.PunchOutOrderMessage poom;
        try {
            poom = new Cxml.PunchOutOrderMessage(resp);
        }
        catch (exception ex) {
            try {
                Cxml.Response r = new Cxml.Response(resp);
                return r.statusMessage;
            }
            catch (exception ex2) {
                return 'Bad response: '+ex+' '+ex2+'response: '+resp;
            }
            
        }
        
        prods.clear();
        for (cxml.Item i : poom.getItems()) {
             prods.add(new OMSProduct(i));
        }
        return null;
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////
/////NC20141125
/////Adding the TestException class so that it can be thrown
   public with sharing class TestException extends Exception {
 
    }
//////////////////////////////////////////////////////////////////////////////////////////////
/////NC20141125
/////Adding a public method in order to call a private method in our test class

    public string test_c(string OppId){
         //This method can only be called from a test method.
         //  This method allows calling a private method from test code to allow for faster test performance.
 
          if (!test.isRunningTest()){
         // throw new TestException('This method can only be called from a test.');
          }
 
          return c(OppId);
 
          }

    
//////////////////////////////////////////////////////////////////////////////////////////////
/////NC20141125
/////Adding a public method inorder to call a private method in our test class
  

    public string test_DecimaltoCurrency(Decimal val){
         //This method can only be called from a test method.
         //  This method allows calling a private method from test code to allow for faster test performance.
 
          if (!test.isRunningTest()){
         // throw new TestException('This method can only be called from a test.');
          }
 
          return DecimaltoCurrency(val);
 
          }


//////////////////////////////////////////////////////////////////////////////////////////////
    private static string DecimaltoCurrency(Decimal val) {
        if (val==0) return '0.00';
        string str = val.divide(1,2,RoundingMode.HALF_UP).format()+'00';
        integer dec = str.lastindexOf('.');
        system.debug('-------DecimaltoCurrency: -str/dec/len------------->'+str + '/'+dec+'/'+str.length());
        if (dec==-1 ) return str.substring(0,str.length()-2)+'.00';
        //else if (dec==str.length()-1) return str+'0';
        else return str.substring(0,dec+3);
    }
 
    //PROD---> private string OMS_PUNCHOUT_URL = 'https://dpcoms.dupont.com/';
    //DEV--->  private string OMS_PUNCHOUT_URL = 'https://omsqa.dupont.com/';
    //ist ok to default to PROD since  SFDC usernames are postfixed with the sandbox name, and  
    // are not granted access in PROD OMS
    private static string getBIPUrl() {
       //RB20141117      
        try {
            //if (Util.isProduction)
            //return 'https://dpcoms.dupont.com';
      
        }
        catch (exception ex) {}
           return 'https://omsqa.dupont.com';
    }


   
}
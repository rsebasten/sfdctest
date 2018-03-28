/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com
Description:  Controller for RequestWizard
 *****************************************************************************
//PS 20140424 - Changing the Exception Request Status to Approved if approval is not required.
 *****************************************************************************

TODO:  make it also work for DPT_NomexLabelOrderRequest page

redirection Options:
    -ver
        1 = save request as with status = 'not started' are open in edit with status defaulting to 'In Process'.
        2 = open new window showing requests before save.
        version 2 options:
        - rtype     : (string) RecordType to get settings  (Lead or Contact RTYPEID)
        - fldset    : (string) fieldset of fields to show in biz specific section on request.
        - approve   : (boolean) fire off approval process (default: 1 (0: only chg to approval Rtype))
        - geo       : (boolean) turn on geovalidation on the address. (future)
        - sosl      : (boolean) use sosl for search 
        - oorg      : (string) request__c.Owning_Organization__c
        - caseid    : (string) request__c.case__c
        - oppid     : (string) request__c.RelatedOpportunity__c
        - status    : initial status to set requests, default 'In Process';
        - rRT       : (string) destination Request RecortType
        - riRT      : (string) destination Request Item RecortType      

 ********************************************************************************/
public with sharing class ctrlRequestWizard {



    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Declaring variables
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 

      

    public Cart                 cart                            {get;set;}
    public String               catalogId                       {get;set;}  //'All' or specific Catalog Id  
    public List<searchResult>   searchResults                   {get;set;} 
    public Request__c           req                             {get;set;}
    public string               stage                           {get;set;}  //{ 'select', 'confirm' } !!!not to be confused with request.stage

    //params (settings)
    public MAP<string,string>   params                  {get;set;}
    public integer      version                         {get;set;}  // {1 or 2 (default)}
    public string       rtypeid                         {get;set;}  //(string) RecordType to get settings  (Lead or Contact RTYPEID)
    public string       req_fldset                      {get;set;}  //fieldset of fields to show in confirmation section on request.
    public boolean      fireApproval                    {get;set;}  //fire off approval process
    public boolean      geoValidate                     {get;set;}  //turn on geovalidation on the address.
    public boolean      useSosl                         {get;set;}  //Use SOSL for searching catalog items otherwise uses like on keyf ields
    public string       destReqRT                       {get;set;}  //Destination Request Recordtype Id
    public string       destReqItmRT                    {get;set;}  //Destination RequestItem Recordtype Id



    public static final string DEFAULT_STATUS   =   'In Progress';
    //<PS 20140424> Added a static string to hold value of the Exception Request Status field.  
    public static final string APPROVED_STATUS  =   'Approved';
    public static final Id SARI_CAPTURE_RTYPE   =   utilRT.getRT('Request_Item__c','SalesAidItemCapture').Id;
    public static final Id SAR_CAPTURE_RTYPE    =   utilRT.getRT('Request__c','SalesAidCapture').Id;
    public static final Id SAR_APPROVAL_RTYPE   =   utilRT.getRT('Request__c','Sales_Aid_In_Approval').Id;

    public String SearchString {get;set;}
    public string eventAction                                   {get;set;}
    public string eventid                                       {get;set;}
    public ctrlRequestWizard(){


    }


    public void initParams() {
        params = new MAP<string,string>();
        rtypeId         = System.currentPageReference().getParameters().get('rtype');
        system.debug('# 78 rtypeId: '+rtypeId);
        RecordTypeSettings__c rts = (utilRT.getRTById(rtypeId)!=null) ? utilRT.getRTById(rtypeId).getSettings() : null; 
        system.debug('# 80 rts: '+rts);
        if (rts!=null && rts.get('SAR__c')!=null )
            params = Util.mapUrlVars((string)rts.get('SAR__c'));
        params.PutAll(System.currentPageReference().getParameters()); //url params trump rtype setings


        version = (params.get('ver')!=null)         ?  Util.stringToInteger(params.get('ver')) : 2;
        //if (version==2)
        fireApproval    = (params.get('approve')!=null)     ? Util.stringToBoolean(params.get('approve')) : true;   
        geoValidate     = (params.get('geo')!=null)         ? Util.stringToBoolean(params.get('geo')) : false;  
        useSosl         = (params.get('sosl')!=null)        ? Util.stringToBoolean(params.get('sosl')) : true;  
        destReqRT       = (params.get('rRT')!=null)         ? params.get('rRT')     : SAR_CAPTURE_RTYPE;
        destReqItmRT    = (params.get('riRT')!=null)        ? params.get('riRT')    : SARI_CAPTURE_RTYPE;
        req_fldset      = (params.get('fldset')!=null)      ? params.get('fldset')  : 'SAR_Main';
        system.debug(params);
        //TODO add validation for params
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //SelectOption for Available Catalogs
    ///////////////////////////////////////////////////////////////////////////////////////////////////////  

    public static Schema.FieldSet cacheFieldSet; 
    public Schema.FieldSet confirmFieldset {
        GET {
            if (cacheFieldSet==null) {
                cacheFieldSet = Schema.SObjectType.Request__c.fieldSets.getMap().get(req_fldset);
                if (cacheFieldSet==null)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Fieldset.'));

            }
            return cacheFieldSet;
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //SelectOption for Available Catalogs
    ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    public List<SelectOption> getCatalogSelectOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption('ALL','<All>'));
        for(Catalog__c c : [select Id, Name from Catalog__c where Active__c = TRUE] ){
            options.add( new SelectOption(c.Id,c.Name));
        }
        return options;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Initialization
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public void init(){
        stage='select';
        string id = ApexPages.currentPage().getParameters().get('id');
        initParams();
        req = initRequest(id);  
        cart=new Cart(req);
        cart.itemRT=destReqItmRT;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Populates Catalog Items into Search Result
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public void refreshSearchResults(){

        searchResults = new List<searchResult>();
        LIST<Catalog_Item__c> catalogItems = new LIST<Catalog_Item__c>();
        if (String.isBlank(catalogid))
            catalogid='ALL';

        //No search term... show whole catalog
        //<--DB20150608 Added Catalog__r.Catalog_Owning_Org__c field to query inorder to fetch org Name e.g. IB,BI etc -->
        if (String.isBlank(this.SearchString)) {
            if (this.catalogId!='ALL') {
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c, SizeOptions__c,Catalog__r.Catalog_Owning_Org__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active' AND ( Catalog__c = : catalogid)
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ];      
            }
            else {
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c, SizeOptions__c,Catalog__r.Catalog_Owning_Org__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active'
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ]; 
            }       
        }
        else if (useSosl==true) {

            //SOSL requires at least 2 chars
            if (this.SearchString.length()==1) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Search Term must more than 1 character or blank for All'));
                searchResults=null;
                return;
            }

            //SOSL Query
            String strContains = this.SearchString+'*';
            LIST<Catalog_Item__c> soslResults; 

            if (this.catalogId =='ALL')
                soslResults = [ FIND :strContains IN ALL FIELDS 
                                RETURNING Catalog_Item__c (Id, Name WHERE Item_Status__c='Active' AND Catalog__r.Active__c=true LIMIT 200)
            LIMIT 200][0];
            else
                soslResults = [ FIND :strContains IN ALL FIELDS 
                                RETURNING Catalog_Item__c (Id, Name WHERE Item_Status__c='Active' AND Catalog__r.Active__c=true AND Catalog__c =:catalogid LIMIT 200)
            LIMIT 200][0];

            catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                            Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c, SizeOptions__c,Catalog__r.Catalog_Owning_Org__c//Added 20150522
                            FROM Catalog_Item__c WHERE Id in: soslResults];

        }
        else {
            //SOQL Query
            //<--DB20150608 Added Catalog__r.Catalog_Owning_Org__c field to query inorder to fetch org Name e.g. IB,BI etc -->
            String strlike = '%'+this.SearchString+'%';
            if (this.catalogId == 'ALL'){             
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c, SizeOptions__c,Catalog__r.Catalog_Owning_Org__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active' AND Catalog__r.Active__c=true
                                AND (Name Like :strlike OR Catalog_Item_Name__c Like :strlike OR Reference_Keywords__c Like :strlike) 
                //AND Id NOT IN :cart.mapItems.keySet()
                ORDER BY Catalog_Item_Name__c LIMIT 200 ];
            }               
            else if (catalogid != NULL){
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c, SizeOptions__c,Catalog__r.Catalog_Owning_Org__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active' AND ( Catalog__c = : catalogid)
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ];   
            } 
        }                
        for(Catalog_Item__c ci : catalogItems){
            searchResult sr = new searchResult(ci);              
            //NOMEX
            //if(qual!=null){                  
            //  sr.indx=(qual.id+qual.Reference_Id__c+sr.catalogItem.id).trim();
            //}
            this.searchResults.Add(sr);
        }            

        if (searchResults.size() == 0 ){                
            searchResults=null;
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Add the items selected to selected Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////    
   /* public PageReference Add_onClick() 
    {  
        try{
            for(searchResult sr : searchResults)
            {
                if(sr.quantity!=null && sr.quantity>0) 
                {
                  //<Coding Started : <DB20150608 Added this code to check  catalog item name for IB and other owning org.
                  //For IB if we are adding multiple catalog of  different supplier it will throw error..
                  //For other catalog it will add items into the cart
                 if(cart.items.size()>0)
                  {
                      for(CartItem cis: cart.items)
                       {
                       if(sr.quantity!=null && sr.quantity>0)
                       {
                       //<DB20150608> If business is other than IB add items to cart 
                       if(!cis.catalogItem.Catalog__r.Catalog_Owning_Org__c.startswith('IB'))
                       {
                       
                       CartItem ci = cart.add(sr);
                       sr.quantity=null;
                       
                       }
                       else
                       {
                       //<DB20150608> If business is than IB then add items from same supplier to the cart 
              
                              
                              if(cis.catalogItem.Catalog__r.Fulfillment_Supplier__c== sr.catalogItem.Catalog__r.Fulfillment_Supplier__c )
                               {
                                 
                                 CartItem ci = cart.add(sr);
                                 sr.quantity=null;
                               }
                                
                                else
                                {
                                
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Error! Sample requests may only be shipped from one supplier. Please select products from the same supplier'));
                                sr.quantity=null;
                                return null;
                                }
                       
                       }
                    
 
                       }
                       
                    }           
                 }

              else
                {
                    system.debug('item got added for the 1 st time when cart is empty i.e. cart size is'+cart.items.size());
                    CartItem ci = cart.add(sr);
                    sr.quantity=null;

                }
                //<Coding ended: <DB20150608 Added this code to check  catalog item name for IB and other owning org.
          }
                
        }
                        
                //CartItem ci = cart.add(sr);
               //sr.quantity=null;
            }       
        
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please select items before adding to cart',ex.getMessage()));
        }
        return null;   
    }
    */
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Add the items selected to selected Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////    
    public PageReference Add_onClick() 
    {  
        try{
            for(searchResult sr : searchResults)
            {
                if(sr.quantity!=null && sr.quantity>0) 
                {
                  //<Coding Started : <DB20150608 Added this code to check  catalog item name for IB and other owning org.
                  //For IB if we are adding multiple catalog of  different supplier it will throw error..
                  //For other catalog it will add items into the cart
                 if(cart.items.size()>0)
                  {
                      for(CartItem cis: cart.items)
                       {
                       if(sr.quantity!=null && sr.quantity>0)
                       {
                       //<DB20150608> If business is other than IB add items to cart 
                       //if organization name is not same throw an error
                       if(cis.catalogItem.Catalog__r.Catalog_Owning_Org__c!=sr.catalogItem.Catalog__r.Catalog_Owning_Org__c)
                       {
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Error! Please select products from the same Business!'));
                       sr.quantity=null;
                       return null;
                       }
                       
                       if(!cis.catalogItem.Catalog__r.Catalog_Owning_Org__c.startswith('IB'))
                       {
                    
                       CartItem ci = cart.add(sr);
                       sr.quantity=null;
                     
                       
                       }
                      
                       else
                       {
                       //<DB20150608> If business is than IB then add items from same supplier to the cart 
              
                              
                              if(cis.catalogItem.Catalog__r.Fulfillment_Supplier__c== sr.catalogItem.Catalog__r.Fulfillment_Supplier__c && cis.catalogItem.Catalog__r.Catalog_Owning_Org__c.startswith('IB'))

                               {
                               
                                 
                                 CartItem ci = cart.add(sr);
                                 sr.quantity=null;
                               
                               }
                                
                                else
                                {
                                
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Error! Sample requests may only be shipped from one supplier. Please select products from the same supplier'));
                                sr.quantity=null;
                                return null;
                                }
                       
                       }
                    
 
                       }
                       
                    }           
                 }

              else
                {
                    
                    CartItem ci = cart.add(sr);
                    sr.quantity=null;

                }
                //<Coding ended: <DB20150608 Added this code to check  catalog item name for IB and other owning org.
          }
                
        }
                        
                //CartItem ci = cart.add(sr);
               //sr.quantity=null;
            }       
        
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please select items before adding to cart',ex.getMessage()));
        }
        return null;   
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Remove Items from the selected Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public void deleteItem() {    
        cart.remove(eventid);        
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Action upon hit on Search Button
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public PageReference Search_onClick(){        
        refreshSearchResults();      
        return null;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference onCheckout(){
        if (version==1) {
            PageReference pageRef = new PageReference('/' + req.id+'/e?retURL=%2F'+req.id);
            //KT [11072017]: To remove Request_Field_Ids__c reference
            //Request_Field_Ids__c rf= Request_Field_Ids__c.getValues('Status__c');
            //String idIs = '';
            //if (rf <> null) {
            //    idIs = rf.Id__c;
            //    pageRef.getParameters().put(idIs,'In Progress');
            //}
            //pageRef.getParameters().put('00N30000001V5W9','In Progress');
            
            return PageRef;
        }
        stage='confirm';
        return null;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference refresh(){
        return null;
    }   
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public PageReference onBackToSelect(){
        stage='select';
        return null;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public PageReference onConfirm(){       
     try {  
        cart.saveRequest(fireApproval);
        //PageReference pageRef = new PageReference('/' + req.id);
        PageReference pageRef = new PageReference('/' + req.id + '/e?retURL='+req.id);
        return PageRef;
        }
    catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'This request has been cancelled. Address Fields are mandatory on Request. The Account OR contact person you selcted on the sample is missing a complete address, phone number or both. Please return to the Account or Contact, update this information and resubmit your request.  ',ex.getMessage()));
        }
        return null; 
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public class SearchResult {   
        public double           quantity        {get;set;}
        public string           indx            {get;set;}  
        public Catalog_Item__c  catalogItem     {get;set;}
        public SearchResult(Catalog_Item__c ci) {
            catalogItem = ci;
            indx=ci.id;
        } 

        public LIST<SelectOption> sizeOptions {
            get {
                LIST<SelectOption> rtn = new LIST<SelectOption>();
                try {
                    if (catalogItem.SizeOptions__c!=null) {
                        string sopt=catalogItem.SizeOptions__c.replaceAll('\\r','');
                        LIST<string> lst = sopt.split('\\n',-2);
                        rtn = Util.createSelectOptions(lst);
                    }
                } catch(exception ex){}
                return rtn;
            }
        }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public without sharing class Cart {
        public Request__c req   {get; set;} 
        public Map<string,cartitem> mapItems {get;set;}
        public string itemRT    {get; set;} 
        public Cart(Request__c request) {
            req = request;
            mapItems = new Map<string,cartitem>();
            itemRT=SARI_CAPTURE_RTYPE;
        }


        public integer size {
            get { return mapItems.size(); }

        }
        public List<CartItem> items {
            GET{
                //sorted
                List<CartItem> rtn = new List<CartItem>();
                List<String> aList = new List<String>();
                aList.addAll(mapItems.keySet());   
                aList.sort();
                for(String a :aList){
                    rtn.add(mapItems.get(a)) ;
                } 
                return rtn; 
            }
        }

        public cartitem add(SearchResult sr) {
            cartitem ci = new cartitem(sr, this);                                 
            ci.requestItem.Catalog_Item__r=sr.catalogItem;
            ci.requestItem.Quantity__c = sr.quantity;
            ci.requestItem.RecordTypeId=itemRT;         
            mapItems.put(ci.indx, ci);
            return ci;          
        }

        public void remove(string indx) {
            mapItems.remove(indx);          
        }

        //returns Request.Id
        public string saveRequest(boolean afireApproval) {
            //TODO: try/catch   

            if (requiresApproval) {
                req.recordtypeid=SAR_APPROVAL_RTYPE;    
            }

            insert req;

            List<Request_Item__c > ris = new List<Request_Item__c >();                  
            for(CartItem ci : mapItems.values()){
                ci.requestItem.Unit_of_Measure__c=ci.requestItem.Catalog_Item__r.Unit_of_Measure__c;
                ci.requestItem.Request__c=req.id;
                ci.requestItem.Catalog_Item__c = ci.requestItem.catalog_Item__r.Id;
                ci.requestItem.Related_Qualification__c=ci.requestItem.Related_Qualification__r.Id;
                ris.add(ci.requestItem);
            }
            insert ris;

            //<PS 20140424> Code to change Exception Request Status to 'Approved' if request does not require approval.  
            if (!requiresApproval) {  
                req.Exception_Request_Status__c = APPROVED_STATUS;  
                update req;  
            }

            //do this step last
            if (req.id!=null && requiresApproval && afireApproval) {
                Approval.ProcessSubmitRequest appr = new Approval.ProcessSubmitRequest();
                appr.setComments('Submitted for approval using RequestWizard.');
                appr.setObjectId(req.id);
                if (! System.Test.isRunningTest())
                    Approval.ProcessResult result = Approval.process(appr);
            }   


            return req.id;
        }

        public boolean requiresApproval {
            get {
                for(CartItem ci : mapItems.values())
                    if (ci.requiresApproval) return true;
                return false;
            }
        } 

    } //class: Cart

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public class CartItem extends Validatable{   
        public Cart parent                  {get;set;} 
        public String indx                  {get;set;}    
        public Request_Item__c requestItem  {get;set;}
        public Catalog_Item__c catalogItem  {get;set;}
        public Qualification__c qualItem    {get;set;}


        public CartItem(SearchResult sr, Cart p) {
            this(sr.catalogItem, p);
        }
        public CartItem(Catalog_Item__c ci, Cart p) {
            parent = p;
            indx=Util.createGuid();  
            catalogItem = ci;
            requestItem = new Request_Item__c(RecordTypeid=SARI_CAPTURE_RTYPE,Stage__c=parent.req.Stage__c,Status__c=parent.req.Status__c, Special_Handling__c=ci.Special_Handling__c);

            if (requiresApproval)
                this.addValidationMessage('This item requires approval.','WARN');
            if (overLimit && catalogItem.Quantity_Limit_Max_Action__c=='Approval')
                this.addValidationMessage('This item exceeds the recommended limit.','WARN');
        }

        public boolean requiresApproval {
            get { return (overLimit && catalogItem.Quantity_Limit_Max_Action__c=='Approval'); }
        }   

        public boolean overLimit {
            get { return  (requestItem!=null && requestItem.quantity__c>catalogItem.Quantity_Limit_Max__c); }
        }


        public LIST<SelectOption> sizeOptions {
            get {
                LIST<SelectOption> rtn = new LIST<SelectOption>();
                try {
                    if (catalogItem.SizeOptions__c!=null) {
                        string sopt=catalogItem.SizeOptions__c.replaceAll('\\r','');
                        LIST<string> lst = sopt.split('\\n',-2);
                        rtn = Util.createSelectOptions(lst);
                    }
                } catch(exception ex){}
                return rtn;
            }
        }       

    } //class: CartItem
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 

    public Request__c initRequest(string id ) {
        Request__c rtn; 
        if (id.startsWith('00Q')) {
            //a lead
            Lead lead = [select name,Company,City,PostalCode,State,Street,Lead_Country__c from Lead where id=:id limit 1];

            rtn = new Request__c(Lead__c=lead.id,Send_to_Contact__c=lead.name,Send_to_Company__c=lead.Company,
                    RecordTypeid=destReqRT,Request_Shipping_City__c=lead.city,
                    Request_Shipping_Country__c=lead.Lead_Country__c,Request_Shipping_Postal_Code__c=lead.postalcode,
                    Request_Shipping_State__c=lead.state,Request_Shipping_Street__c=lead.street);                   
        }   
        else if (id.startsWith('003')) {
            //a contact;
            //<--SM20141213-->
            Contact con = [select id,name,mailingcity,mailingpostalcode,mailingcountry,mailingstate,mailingstreet,phone,
                           acc.id, acc.name, acc.shippingcity,acc.shippingpostalcode,acc.shippingstate,acc.shippingstreet,acc.shippingcountry,acc.phone from Contact, Contact.Account acc where id=:id limit 1];

            if(con.MailingStreet == NULL){
                Account acc = con.account;                
                rtn = new Request__c(Account__c=con.AccountID,Contact__c=con.id,Send_to_Contact__c=con.Name,Send_to_Company__c=con.Account.Name,
                        RecordTypeid=destReqRT,Request_Shipping_City__c=acc.shippingcity,
                        Request_Shipping_Country__c=acc.shippingcountry,Request_Shipping_Postal_Code__c=acc.shippingpostalcode,
                        Request_Shipping_State__c=acc.shippingstate,Request_Shipping_Street__c=acc.shippingstreet,Phone__c=acc.phone);                                  
            }
            else{                   
                rtn = new Request__c(Account__c =con.AccountID,Contact__c=con.id,Send_to_Contact__c=con.Name,Send_to_Company__c=con.Account.Name,
                        RecordTypeid=destReqRT,Request_Shipping_City__c=con.mailingcity,
                        Request_Shipping_Country__c=con.mailingcountry,Request_Shipping_Postal_Code__c=con.mailingpostalcode,
                        Request_Shipping_State__c=con.mailingstate,Request_Shipping_Street__c=con.mailingstreet,Phone__c=con.phone);                                  
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Invalid Id.  Must be a lead or contact.'));
            stage='err';
            return null;
        }

        string initStatus = ApexPages.currentPage().getParameters().get('status');  
        rtn.Stage__c='Capture';
        rtn.Status__c = (initStatus!=null) ? initStatus : DEFAULT_STATUS;
        rtn.Related_Opportunity__c=ApexPages.currentPage().getParameters().get('oppid');
        rtn.Case__c=ApexPages.currentPage().getParameters().get('caseid');
        rtn.Owning_Organization__c=ApexPages.currentPage().getParameters().get('oorg'); 
        return rtn; 

    }

    /*
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
//  Nomex specific Code
/////////////////////////////////////////////////////////////////////////////////////////////////////// 


    public Qualification__c         qual                            {get;set;}    //Nomex
    public List<Qualification__c>   activegarmentcerts              {get;set;}      
    public SET<String> verifySet=new SET<String>();  

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Initialization for Nomex
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public void initNomex(){

        string qualid = System.currentPagereference().getParameters().get('qualid'); 
        string id=PortalUser.getInstance().contactid;

        req = initRequest(id); 

        qual= [select Name,Reference_Id__c,Construction__c,Colour__c,Colour_Comments__c,Colour_Reference__c from Qualification__c where id =:qualid];


        activegarmentcerts = [select Name,Id, SubType__c, Reference_Id__c, CreatedDate, Colour_Comments__c, status__c,
                              Colour__c, Colour_Reference__c, Stage__c, Start_Date__c, End_Date__c, finish__c, Weight__c,
                              Qualification_Program__r.name, Certification_Result__c,Brand__r.name, Construction__c,
                              Account_Name__r.Name, Owner__r.Name from Qualification__c where (Qualification_Program__r.name!='Nomex® Garment - Certification Request' AND Account_Name__c=:PortalUser.getInstance().accountid AND Stage__c='Active' AND Status__c='Approved' AND SubType__c='Garment') ORDER BY Qualification_Program__r.name,Construction__c];
    }   


    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void deleteNomexItem() {
        //<---AG v2.0 START--->
        /////////included the logic to populate the activegarmentcerts with the corresponding Qualification when the user clicks on 'Remove' action. 
        Integer count=0;                
        String removeQual=ApexPages.currentPage().getParameters().get('removedQualId');
        if(verifySet.contains(removeQual)==false){
            verifySet.add(removeQual);
            count++;            
        }                       
        List<Qualification__c> removedQual=[SELECT Name,Id, SubType__c, Reference_Id__c, CreatedDate, Colour_Comments__c, status__c,
                                            Colour__c, Colour_Reference__c, Stage__c, Start_Date__c, End_Date__c, finish__c, Weight__c,
                                            Qualification_Program__r.name, Certification_Result__c,Brand__r.name, Construction__c,
                                            Account_Name__r.Name, Owner__r.Name from Qualification__c where Name=:removeQual];

        if(count>0){            
            activegarmentcerts.addAll(removedQual);
            this.sortActiveCertGarments(activegarmentcerts);      
        } 
        /////////<---AG v2.0 END--->         
        cart.remove(eventid);     
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public void refreshNomexSearchResults() {
        if(qual!=NULL){
            for(integer i=0;i<activegarmentcerts.size();i++) {
                if(activegarmentcerts.get(i).Id==qual.id)
                    activegarmentcerts.remove(i);
            }
            try {
                catalogId = [select Qualification_Program__r.Related_Catalog__c, Qualification_Program__c from Qualification__c where id =:qual.id LIMIT 1][0].Qualification_Program__r.Related_Catalog__c;              
            } catch(Exception ex){}
        }       
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Sorting the List Based on field API Name
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //<---AG v2.0 START--->
    public void sortActiveCertGarments(List<Qualification__c> listQual){
        List<String> listQualName=new List<String>();
        for(Integer i=0;i<listQual.size();i++){
            listQualName.add(listQual.get(i).Name);
        }
        List<Qualification__c> listSortedQual=[SELECT Name,Id, SubType__c, Reference_Id__c, CreatedDate, Colour_Comments__c, status__c,
                                               Colour__c, Colour_Reference__c, Stage__c, Start_Date__c, End_Date__c, finish__c, Weight__c,
                                               Qualification_Program__r.name, Certification_Result__c,Brand__r.name, Construction__c,
                                               Account_Name__r.Name, Owner__r.Name FROM Qualification__c where Name =: listQualName ORDER BY Qualification_Program__r.name,Construction__c];
        listQual.clear();
        listQual.addAll(listSortedQual);   
    }
    //<---AG v2.0 END--->     
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
     */


}
/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder,Ankit Gupta
Email: thomas.snyder@usa.dupont.com,ankit.gupta@usa.dupont.com
Description:  Controller for NewRequest,DPT_NomexLabelOrderRequest page
 ********************************************************************************/
/*
===============================================================================================================================================================*
  <Ver> <Initials>     <Date>     <Email ID>                     <Modification description>
--------------------------------------------------------------------------------------------------------------------------------------------------------------- 
   1.0  AnkitGupta   2012-10-15  Ankit Gupta<Ankit_Gupta51@infosys.com>    Initial code  
   2.0  Ankit Gupta  2012-12-03  Ankit Gupta<Ankit_Gupta51@infosys.com>    Changes made after deployment to Production are prefixed with <AG v2.0 START> & <AG v2.0 END>
   3.0  Sravanthi L  2013-07-11  sai-sravanthhi.lakkimsetty@bra.dupont.com Changed the Order to sort the Qualifications by means of Reference Id- tag SL0130711
   4.0  F Medioni    2017-10-04  fmedioni@salesforce.com                   Add catalog field to the request
===============================================================================================================================================================

 */
public with sharing class ctrlNewRequest{
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Declaring variables
    /////////////////////////////////////////////////////////////////////////////////////////////////////// 
    public Qualification__c theQual{get;set;}    
    public List<searchResult> searchResults;          
    public String catalogid;
    public Contact con;
    public Account acc;
    public Lead lead;
    public Id qualid;
    public Id conid;
    public Id leadid;
    public Id reqid;
    public List<Qualification__c> activegarmentcerts{get;set;}
    public Map<String,cartitem> Cart = new Map<String,cartitem>();    
    public static final Id REQ_ITEM_SALES_AID_ITEM_CAPTURE_RTYPE= Rtype.getIdByDevName('Request_Item__c','SalesAidItemCapture');
    public static final Id REQ_SALES_AID_IN_Approval_RTYPE=Rtype.getIdByDevName('Request__c','Sales_Aid_In_Approval');
    public String SearchString {get;set;}
    public String catalog{get;set;}
    public String selecteditemid{get;set;}   
    public SET<String> verifySet=new SET<String>();    
    public cartitem[] getCart() {
        return this.Cart.values();
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
        if(ApexPages.currentPage().getParameters().get('conid') != NULL){
            conid= ApexPages.currentPage().getParameters().get('conid');
            con = [select name,Account.Name,AccountID,mailingcity,mailingpostalcode,mailingcountry,mailingstate,mailingstreet from Contact where id=:conid limit 1];
            acc = [select shippingcity,shippingpostalcode,shippingstate,shippingstreet,shippingcountry from Account where id =:con.Accountid limit 1];
        }
        if(ApexPages.currentPage().getParameters().get('leadid') != NULL){
            leadid= ApexPages.currentPage().getParameters().get('leadid');
            lead = [select name,City,PostalCode,State,Street,Lead_Country__c from Lead where id=:leadid limit 1];
        }     
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Initialization for Nomex
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    public void initNomex(){
        activegarmentcerts = [select Name,Id, SubType__c, Reference_Id__c, CreatedDate, Colour_Comments__c, status__c,
                              Colour__c, Colour_Reference__c, Stage__c, Start_Date__c, End_Date__c, finish__c, Weight__c,
                              Qualification_Program__r.name, Certification_Result__c,Brand__r.name, Construction__c,
                              Account_Name__r.Name, Owner__r.Name from Qualification__c where (Qualification_Program__r.name!='Nomex® Garment - Certification Request' AND Account_Name__c=:PortalUser.getInstance().accountid AND Stage__c='Active' AND Status__c='Approved' AND SubType__c='Garment') ORDER BY Reference_Id__c];//SL0130711
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Populates Catalog Items into Search Result
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public List<searchResult> getSearchResults(){
        if(ApexPages.currentPage().getParameters().get('qualid') != NULL){              
            qualid = System.currentPagereference().getParameters().get('qualid'); 
            for(integer i=0;i<activegarmentcerts.size();i++){
                if(activegarmentcerts.get(i).Id==qualid)
                    activegarmentcerts.remove(i);
            }
            theQual= [select Name,Reference_Id__c,Construction__c,Colour__c,Colour_Comments__c,Colour_Reference__c from Qualification__c where id =:qualid];
            catalogid = [select Qualification_Program__r.Related_Catalog__c, Qualification_Program__c from Qualification__c where id =:qualid LIMIT 1][0].Qualification_Program__r.Related_Catalog__c; 
            System.debug('Print Catalog' +catalogid);
            System.debug('Print Catalog' +[select Qualification_Program__r.Related_Catalog__c, Qualification_Program__c from Qualification__c where id =:qualid LIMIT 1]); 
           
      }            
        if (searchResults != null){
            this.searchResults.clear(); 
        }
        else            
            searchResults = new List<searchResult>();
            Catalog_Item__c[] catalogItems;
            String strlike = '%'+this.SearchString+'%';
            if (this.catalog == 'ALL'){             
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active' 
                                AND (Name Like :strlike OR Catalog_Item_Name__c Like :strlike OR Reference_Keywords__c Like :strlike) 
                                AND Id NOT IN :Cart.keySet()
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ];
            }               
            else if (catalogid != NULL || this.catalog == NULL){
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c
                                FROM Catalog_Item__c WHERE Item_Status__c='Active' AND ( Catalog__c = : catalogid)
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ];   
            }                 
            else if(this.catalog != NULL && this.catalog != 'ALL'){             
                catalogItems = [Select Id, Name,Material__c,Material__r.Name,Material__r.Description_rtf__c,Catalog_Item_Name__c, Unit_of_Measure__c, Catalog_Item_Type__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c,
                                Quantity_Limit_Max_Action__c,Item_Status__c, Catalog__c, Catalog__r.Name,Catalog__r.Fulfillment_Supplier__c, Catalog__r.Fulfillment_Supplier__r.Name, Special_Handling__c
                                FROM Catalog_Item__c where (Item_Status__c='Active' AND Catalog__c=:this.catalog ) AND (Name Like :strlike OR Catalog_Item_Name__c Like :strlike)             
                                ORDER BY Catalog_Item_Name__c LIMIT 200 ];              
            }

            for(Catalog_Item__c ci : catalogItems){
                searchResult sr = new searchResult();
                sr.catalogItem = ci;                
                if(theQual!=null){                  
                    sr.unqindx=(theQual.id+theQual.Reference_Id__c+sr.catalogItem.id).trim();
                }
                else if(theQual==null){               
                    sr.unqindx=ci.id;
                }
                this.searchResults.Add(sr);
            }            

            if (searchResults.size() == 0 ){                
                searchResults=null;
            }
            return this.searchResults;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Add the items selected to selected Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////    
    public PageReference Add_onClick() {  
        try{
            for(searchResult sr : searchResults){
                if(sr.quantity != null && sr.quantity>0){
                    if(sr.catalogItem.Quantity_Limit_Max__c!= NULL && (sr.quantity <=sr.catalogItem.Quantity_Limit_Max__c || sr.catalogitem.quantity_limit_max_action__c=='Warning' ) || (sr.catalogItem.Quantity_Limit_Max__c == NULL)){
                        cartitem ci = new cartitem();                   
                        ci.catalogitem=sr.catalogitem;                 
                        ci.requestItem.Catalog_Item__r=sr.catalogItem;
                        ci.requestItem.Quantity__c = sr.quantity;
                        ci.indx=sr.unqindx;
                        if(theQual!= NULL)
                            ci.requestItem.Related_Qualification__r=theQual;                
                        Cart.put(ci.indx,ci);
                    }   
                    else if(sr.catalogItem.Quantity_Limit_Max__c != NULL && sr.quantity>sr.catalogItem.Quantity_Limit_Max__c){
                        if(sr.catalogItem.Quantity_Limit_Max_Action__c=='Error'){                   
                            ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Error:You Cannot enter quantity greater than MAX LIMIT');
                            ApexPages.addMessage(Msg);
                            break; 
                        }                     
                    }
                }                                                               
            }
        }
        catch(Exception ex){
            PageReference pr;
            if(PortalUser.getInstance().contactid!= NULL){
                pr = System.Page.DPT_NomexLabelOrderRequest;
            }
            else{
                pr = System.Page.NewRequest;
            } 
            pr.getParameters().put('Please select items before adding to cart ',ex.getMessage());
            return pr;
        }
        searchResults.clear();
        return null;   
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Getting Sorted Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    public List<CartItem> sortedCart {
        GET{
            List<CartItem> rtn = new List<CartItem>();
            List<String> aList = new List<String>();
            aList.addAll(Cart.keySet());   
            aList.sort();
            for(String a :aList){
                rtn.add(Cart.get(a)) ;
            } 
            return rtn; 
        }
    }   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Remove Items from the selected Cart
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public void deleteItem() {
        Integer index;
        Integer i=0;
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
        if(ApexPages.currentPage().getParameters().get('cartid')!=null){
            selecteditemid = ApexPages.currentPage().getParameters().get('cartid');         
            for (CartItem ci : sortedCart){             
                if(Cart.get(selecteditemid)==ci){                   
                    index=i;
                }
                else{
                    i++;
                }
            }       
            sortedCart.remove(index);
            Cart.remove(selecteditemid.trim());            
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
                                               Account_Name__r.Name, Owner__r.Name FROM Qualification__c where Name =: listQualName ORDER BY Reference_Id__c];//SL0130711
        listQual.clear();
        listQual.addAll(listSortedQual);   
    }
    //<---AG v2.0 END--->        
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Action upon hit on Search Button
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public PageReference Search_onClick(){        
        List<searchResult> s = getSearchResults();      
        return null;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //Action Method : Save the Selected Items to Request and Request Items 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////   
    public PageReference onSave(){      
        List<Request_Item__c > ri = new List<Request_Item__c >();
        Request__c req;
        try{
            System.debug('carts'+Cart.size()+'testconta'+conid+'testportal'+PortalUser.getInstance().contactid);
            if(Cart.size()>0) {
                System.debug('testcart'+Cart.keySet());
            }
            if(Cart.size()>0 && PortalUser.getInstance().contactid!= NULL ){       
                req = new Request__c(Account__c =PortalUser.getInstance().accountid,Send_to_Contact__c=PortalUser.getInstance().firstName+' '+PortalUser.getInstance().lastName,Send_to_Company__c=PortalUser.getInstance().accountName,Comments__c='Please be sure to modify below shipping details in case material should be sent to a different location.'+'\n'+'Thanks to use the space below for any instructions or comments.',
                        Contact__c=PortalUser.getInstance().contactid, /*Phone__c=PortalUser.getInstance().Phone,*/ Sample_Request_Catalog__c = catalogid, // FM 20171005: Added Sample_Request_Catalog__c field //
                        RecordTypeid=REQ_SALES_AID_IN_Approval_RTYPE,Product_Details__c='DPT Nomex Labels',Stage__c='Capture',Status__c='Not Started',Request_Shipping_City__c=PortalUser.getInstance().mailingCity,
                        Request_Shipping_Country__c=PortalUser.getInstance().mailingCountry,Request_Shipping_Postal_Code__c=PortalUser.getInstance().mailingPostalCode,Request_Reason__c='Customer Request',
                        Request_Shipping_State__c=PortalUser.getInstance().mailingState,Request_Shipping_Street__c=PortalUser.getInstance().mailingStreet);                   
            }
            else if(Cart.size()>0 && PortalUser.getInstance().contactid== NULL && conid!=null ){
                if(con.MailingCity == NULL || con.MailingCountry == NULL){                  
                    req = new Request__c(Account__c =con.AccountID,Contact__c=conid,Send_to_Contact__c=con.Name,Send_to_Company__c=con.Account.Name,
                            RecordTypeid=REQ_SALES_AID_IN_APPROVAL_RTYPE,Stage__c='Capture',Status__c='Not Started',Request_Shipping_City__c=acc.shippingcity,
                            Request_Shipping_Country__c=acc.shippingcountry,Request_Shipping_Postal_Code__c=acc.shippingpostalcode,
                            Request_Shipping_State__c=acc.shippingstate,Request_Shipping_Street__c=acc.shippingstreet);                                  
                }
                else{                   
                    req = new Request__c(Account__c =con.AccountID,Contact__c=conid,Send_to_Contact__c=con.Name,Send_to_Company__c=con.Account.Name,
                            RecordTypeid=REQ_SALES_AID_IN_Approval_RTYPE,Stage__c='Capture',Status__c='Not Started',Request_Shipping_City__c=con.mailingcity,
                            Request_Shipping_Country__c=con.mailingcountry,Request_Shipping_Postal_Code__c=con.mailingpostalcode,
                            Request_Shipping_State__c=con.mailingstate,Request_Shipping_Street__c=con.mailingstreet);                                  
                }
            }
            else if(Cart.size()>0 && PortalUser.getInstance().contactid== NULL && leadid!=null ){               
                req = new Request__c(Lead__c=leadid,Send_to_Contact__c=lead.name,
                        RecordTypeid=REQ_SALES_AID_IN_Approval_RTYPE,Stage__c='Capture',Status__c='Not Started',Request_Shipping_City__c=lead.city,
                        Request_Shipping_Country__c=lead.Lead_Country__c,Request_Shipping_Postal_Code__c=lead.postalcode,
                        Request_Shipping_State__c=lead.state,Request_Shipping_Street__c=lead.street);                   
            }
            insert req;         
            for(cartitem ci : Cart.values()){
                ci.requestItem.Unit_of_Measure__c=ci.requestItem.Catalog_Item__r.Unit_of_Measure__c;
                ci.requestItem.Request__c=req.id;
                ci.requestItem.Catalog_Item__c = ci.requestItem.catalog_Item__r.Id;
                ci.requestItem.Related_Qualification__c=ci.requestItem.Related_Qualification__r.Id;
                ri.add(ci.requestItem);
            }
            insert ri;  
            reqid = req.id; 
        }
        catch(Exception ex){
            System.debug('Exception:' +ex);
            PageReference pr;
            if(PortalUser.getInstance().contactid!= NULL){
                pr = System.Page.DPT_NomexLabelOrderRequest;
            }
            else{
                pr = System.Page.NewRequest;
            } 
            pr.getParameters().put('Please add items to Selected Cart before submitting',ex.getMessage());
            return pr;
        }       
        
        //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
        Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('Request_Status');     
        
        PageReference pageRef = new PageReference('/' + reqid+'/e?retURL=%2F'+reqid);
        pageRef.getParameters().put(objectFieldID.Field_ID__c,'In Progress');
        return PageRef;
    }
    ////////////////////////////////////////////////////////////////////////////
    //Helper Class
    // TES20121001
    ////////////////////////////////////////////////////////////////////////////
    public class SearchResult {   
        public double quantity              {get;set;}
        public string unqindx               {get;set;}  
        public Catalog_Item__c catalogItem; 
        public Catalog_Item__c getcatalogItem(){return this.catalogItem;}
        public SearchResult() {
            catalogItem = new Catalog_Item__c();
        }  
    }
    public class CartItem {   
        public String indx                  {get;set;}    
        public Request_Item__c requestItem  {get;set;}
        public Catalog_Item__c catalogItem ;
        public void setcatalogItem(Catalog_Item__c value) { this.catalogItem=value;}        
        public Catalog_Item__c getcatalogItem() { return this.catalogItem;}
        public Qualification__c qualItem = new Qualification__c ();        
        public Qualification__c getqualItem() { return this.qualItem;}        
        public CartItem() {                 
            requestItem = new Request_Item__c(RecordTypeid=REQ_ITEM_SALES_AID_ITEM_CAPTURE_RTYPE,Stage__c='Capture',Status__c='Not Started');
        }       
    } 
}
/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Nishant Chopra
Email: nishant_chopra01@infosys.com
Description:  Controller for page: COBCDRLineItemNew, COBCDRLineItemLinkContact, COBCDRLineItemPartner
Change History : <Nishanth.H 20151001> Added Local Version Functionality as part of R02 Enhancement - Req 15
               : <Alvin20150906> Added for R02 enhancement to remove picklist values - Req 9
               : <Santhosh20161006> Added code to fix the issue : IS ID-00075244.
 ********************************************************************************/ 

public class ctrlCOBCustomerDataRequestLineItemNew{
//public string test1{get;set;}
    public Customer_Data_Request_Line_Item__c CustDataReqLineItem{get; set;}
    public list<Customer_Data_Request_Line_Item__c> CustDataReqLineItemList{get; set;}
    public List<Customer_Data_Request__c> OnboardingReq{get; set;}
    public Customer_Data_Request__c custOnboardingReq{get; set;}
    public list<Contact> contactlist = new list<Contact>();
    public transient List<Contact> contacts{get; set;} 
    public List<contactWrapper> accountContacts{get;set;}
    public string copyAddress{get; set;}
    public Id custID{get; set;}
    public Id accountId{get;set;}
    public Id selectedcontact{get;set;}
    public Contact contact{get;set;}
    public boolean displayPopUpFlag{get; set;}
    public Contact contactNew{get; set;}
    public boolean locked{get;set;}
    public boolean flaga{get;set;}
    public boolean flag{get;set;}

    public id cdrlineid;
    public List<SelectOption> RegionOptions{get;set;}
    public List<SelectOption> localRegionOptions{get;set;}
    public List<SelectOption> accgroup{get;set;}
    public Id selectedRecordTypeId;
    public String RecordTypeName{get;set;}
    public String ParentRecordTypeName{get;set;}
    public Boolean display{get;set;}
    public Boolean dispLang{get;set;}
    Public Integer Count;
    public String fieldDeliveryPlant;
    public String fieldRegionPostal;
    public String fieldLocalRegionPostalCode;
    public boolean showEditErrorPage{get;set;}
    public boolean showNewErrorPage{get;set;}
    public Boolean showErrorPage{get;set;}

    public string CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Create new bill to, ship to, payer').getRecordTypeId();    
    public static string LINKCONTACT_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Link Contact').getRecordTypeId();
    public static string LINKEXISTINGPARTNER_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Link Existing Partner Function').getRecordTypeId();
    public static string CREATENEWPARTNERFUNCTION_CDRLI_RTYPE = Schema.SObjectType.Customer_Data_Request_Line_Item__c.getRecordTypeInfosByName().get('Create new partner function').getRecordTypeId();
    public static string MISCELLANEOUS_CDR_RTYPE = Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('Miscellaneous customer data request').getRecordTypeId();
    public static string customerOnboardingContactRecorType= Rtype.getIdByDevName('Contact','Customer_Onboarding_External_Contact');   
    public static string NEWCUSTOMERCREATION_CDR_RTYPE = Schema.SObjectType.Customer_Data_Request__c.getRecordTypeInfosByName().get('New Customer Creation').getRecordTypeId();
    
    //<Santhosh20161006> Added code to fix the issue : IS ID-00075244.
    private integer Contactstablecounter=0;  
    private  integer Contacts_total_size=0;
    private integer Contacts_list_size=10; //sets the page size or number of rows for Contacts Table  
    //<Santhosh20161006> End.
    /**
     * Name: ctrlCOBCustomerDataRequestLineItemNew
     * Params: None
     * Description: Constructor of the class.  
     */

    public ctrlCOBCustomerDataRequestLineItemNew(){
        custOnboardingReq= new Customer_Data_Request__c();
        OnboardingReq= new List<Customer_Data_Request__c>();
        CustDataReqLineItemList= new list<Customer_Data_Request_Line_Item__c>();
        CustDataReqLineItem = new Customer_Data_Request_Line_Item__c();
        accountContacts= new list<contactWrapper> ();
        contactNew= new Contact();
        accgroup = new List<SelectOption>();

        selectedRecordTypeId =ApexPages.currentPage().getParameters().get('RecordTypeId');
        dispLang = false;
        flaga= false;
        flag=true;
        displayPopUpFlag= false;
        display = true;
        showEditErrorPage=false; 
        if(ApexPages.currentPage().getParameters().get('action') == 'edit')
        {
            custID= ApexPages.currentPage().getParameters().get('Id');
            CustDataReqLineItem = [select id,Name,Account_Group__c,City__c,Comments__c,Company_Code__c,Company_Name__c,Copy_Sold_To_Address__c,
                                   Country__c,Customer_Contact_Function__c,Customer_Data_Request__c,Customer_Name__c,Customer_Name_2__c,Customer_Name_3__c,
                                   Customer_Name_4__c,Customer_Number__c,Distribution_Channel__c,District__c,Division__c,Email_Address__c,ERP_Relationship_User__c,
                                   External_Id__c,House_Supplement__c,Incoterms_Part_1__c,Fax_Number__c,Incoterms_Part_2__c,Local_Language_City__c,
                                   Local_Language_Country__c,Local_Language_District__c,Local_Language_House_Supplement__c,Local_Language_Office_House_Number__c,
                                   Local_Language_Postal_Code__c,Local_Language_Region__c,Local_Language_State_Province__c,Local_Language_Street__c,
                                   Local_Language_Street2__c,Local_Language_Street3__c,Local_Language_Street4__c,Local_Language_Street5__c,Local_Version__c,
                                   Name1__c,Name2__c,Name3__c,Name4__c,Office_House_Number__c,On_By_Indicator__c,P_O_Box__c,P_O_Box_City__c,Partner_Contact__c,
                                   Partner_Function__c,Partner_Number__c,Postal_Code__c,Region__c,Sales_Organization__c,Shipping_Conditions__c,Ship_to_Delivery_Plant__c,
                                   Ship_to_Sales_Office__c,State_Province__c,Street__c,Street2__c,Street3__c,Street4__c,Street5__c,Telephone__c,Local_language_Customer_Name_1__c,
                                   Local_language_Customer_Name_2__c,Local_language_Customer_Name_3__c,Local_language_Customer_Name_4__c,Local_Language_Search_Terms__c,
                                   Local_Language_Data_Line__c,Local_Language_Telebox__c from Customer_Data_Request_Line_Item__c where id = :custID];

            custID = CustDataReqLineItem.Customer_Data_Request__c;
            flag=true;
            displayShipTo();
            if (selectedRecordTypeId ==LINKCONTACT_CDRLI_RTYPE )
                selectedcontact=CustDataReqLineItem.Partner_Contact__c;

        }
        else{
            custID= ApexPages.currentPage().getParameters().get('lkid');
            flag=false;

        }
        OnboardingReq=[select id,RecordTypeId,Name,Account__c,Account__r.Id,Account_Group__c,Customer_Name__c,Customer_Name_2__c,Customer_Name_3__c,Customer_Name_4__c,
                       Company_Code__c,Customer_Number__c,Customer__r.Customer_Code__c,Sales_Organization__c,Customer__c,House_Supplement__c,Sold_To_House_Supplement__c,
                       Distribution_Channel__c,Division__c,Sold_to_Office_House_Number__c,Sold_to_Street__c,Sold_to_City__c,Sold_to_Country__c,
                       Sold_to_State_Province__c,Sold_to_Region__c,Sold_to_District__c,Sold_to_Postal_Code__c,
                       P_O_Box__c,P_O_Box_City__c,Existing_Office_House_Number__c,Existing_Street__c,Existing_Street2__c,Existing_Street3__c,Existing_Street4__c,
                       Existing_Street5__c,Existing_City__c,Existing_Country__c,Record_Locked__c,Sold_to_Street2__c,Sold_to_Street3__c,Sold_to_Street4__c,Sold_to_Street5__c,
                       Existing_State_Province__c,Existing_Region__c,Existing_District__c,Existing_Postal_Code__c,Request_Status__c,Local_Customer_Name_1__c,Local_Customer_Name_2__c,Local_Customer_Name_3__c,
                       Local_Language_Postal_Code__c,Local_Customer_Name_4__c,Local_language_Search_Terms__c,Local_Language_Office_House_Number__c,Local_Language_House_Supplement__c,
                       Local_Language_Street__c,Local_Language_City__c,Local_Language_State_Province__c,Local_Language_Country__c,Local_Language_Region__c,Local_Language_District__c
                       from Customer_Data_Request__c where id=:custID]; //<Nishanth.H 20151001> Added Local Version Functionality as part of R02 Enhancement - Req 15
    
        if(OnboardingReq !=null && OnboardingReq.size()>0){  
            custOnboardingReq=OnboardingReq[0];

        }
        getRecTypeName();
        getParentRecTypeName();
        CustDataReqLineItem.recordtypeId= selectedRecordTypeId ; // <Alvin20150906> Added for R02 enhancement to remove picklist values - Req 9
        recordLockValidation();
        newrecordLockValidation();
        newLineItemCreationValidation();
        fetchRegionValues();
        getdisplayLangDetails();
        fetchLocalLangValues();   
        copyAddress='';   
        accgroup.add(new selectOption('Z002 (Ship-to party)','Z002 (Ship-to party)'));
        accgroup.add(new selectOption('Z003 ( Pay-to party )','Z003 ( Pay-to party )'));
        accgroup.add(new selectOption('Z004 (Bill-to party)','Z004 (Bill-to party)'));
        //<Santhosh20161006> Added code to fix the issue : IS ID-00075244.
        if(selectedRecordTypeId ==LINKCONTACT_CDRLI_RTYPE)
        PopulateContact(); 
        //<Santhosh20161006> End.
        
    }

    /**
     * Name: displayShipTo
     * Params: None
     * Description: Method to assign display as false depending on Account Group
     */ 

    public void displayShipTo(){
        display = true;
        if (CustDataReqLineItem.Account_Group__c != 'Z002 (Ship-to party)'){
            display = false;
        }
    }

    /**
     * Name: cancel
     * Params: PageReference
     * Description: Method to redirect page on click of cancel
     */     
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/'+custID); 
        pageRef.setRedirect(true);
        return pageRef ;    
    }   

    /**
     * Name: getRecTypeName
     * Params: String
     * Description: Method to get Record type of LineItem
     */ 

    public String getRecTypeName(){
        if(selectedRecordTypeId != null){

            RecordTypeName = [Select Id,Name from RecordType where SobjectType='Customer_Data_Request_Line_Item__c' and IsActive=true and Id=:selectedRecordTypeId ].Name;
        }
        return RecordTypeName;
    }

    /**
     * Name: getParentRecTypeName
     * Params: String
     * Description: Method to get Parent Record type
     */ 

    Public String getParentRecTypeName(){
        ParentRecordTypeName= [Select Id,Name from RecordType where SobjectType='Customer_Data_Request__c' and IsActive=true and id=:custOnboardingReq.RecordTypeId].Name;

        return ParentRecordTypeName;
    }

    /**
     * Name: prepopulate
     * Params: none
     * Description: Method to copy Sold to address to Line Item address
     */ 

    public void prepopulate(){

        if(copyAddress == 'true' && selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE && custOnboardingReq.RecordTypeId == NEWCUSTOMERCREATION_CDR_RTYPE){
            count=1;
            CustDataReqLineItem.Office_House_Number__c=custOnboardingReq.Sold_to_Office_House_Number__c;
            CustDataReqLineItem.House_Supplement__c= custOnboardingReq.Sold_To_House_Supplement__c;
            CustDataReqLineItem.Street__c=custOnboardingReq.Sold_to_Street__c;                       
            CustDataReqLineItem.City__c=custOnboardingReq.Sold_to_City__c;
            CustDataReqLineItem.State_Province__c=custOnboardingReq.Sold_to_State_Province__c; //<Nishanth.H 20151001> Added Local Version Functionality as part of R02 Enhancement - Req 15
            CustDataReqLineItem.Country__c=custOnboardingReq.Sold_to_Country__c;

            CustDataReqLineItem.Region__c=custOnboardingReq.Sold_to_Region__c;
            CustDataReqLineItem.District__c=custOnboardingReq.Sold_to_District__c;
            CustDataReqLineItem.Postal_Code__c=custOnboardingReq.Sold_to_Postal_Code__c;
            CustDataReqLineItem.P_O_Box__c=custOnboardingReq.P_O_Box__c;
            CustDataReqLineItem.P_O_Box_City__c=custOnboardingReq.P_O_Box_City__c;
           // fetchRegionValues();
           // <Nishanth.H 20151001> Added Local Version Functionality as part of R02 Enhancement - Req 15
            RegionOptions.clear();
           if(custOnboardingReq.Sold_to_State_Province__c != null && custOnboardingReq.Sold_to_State_Province__c != ''){
            RegionOptions.add(new selectoption(custOnboardingReq.Sold_to_State_Province__c,custOnboardingReq.Sold_to_State_Province__c));
            }
            CustDataReqLineItem.State_Province__c=custOnboardingReq.Sold_to_State_Province__c;
           
           // fetchRegionValues();

        }
        //Getters and Setters

        if(copyAddress == 'true' && selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE && custOnboardingReq.RecordTypeId != NEWCUSTOMERCREATION_CDR_RTYPE){
            count=1;
            List<ERP_Customer__c> erpList;
            List<Account> accList;       
            if(custOnboardingReq.Account__c <> null){
                accList=[Select ERP_Customer__c from Account where Id =: custOnboardingReq.Account__c];
                if(!accList.isEmpty()){
                    erpList  = [SELECT RecordType.DeveloperName,Street__c,PO_Box__c,City__c,Zip_Postal_Code__c,
                                Customer_General_Data__r.Street__c,Customer_General_Data__r.PO_Box__c,Customer_General_Data__r.Country_Code__c,
                                Customer_General_Data__r.Country__c,Customer_General_Data__r.City__c,Customer_General_Data__r.Zip_Postal_Code__c,Customer_General_Data__r.State_Province__c,Customer_General_Data__r.State__c from ERP_Customer__c 
                                WHERE Id =: accList[0].ERP_Customer__c];

                }    
                if(!erpList.isEmpty()){
                    if(erpList[0].RecordType.DeveloperName == 'ERP_Customer_Extended_Data'){
                        CustDataReqLineItem.Street__c = erpList[0].Customer_General_Data__r.Street__c;
                        CustDataReqLineItem.City__c=erpList[0].Customer_General_Data__r.City__c;
                        CustDataReqLineItem.Postal_Code__c=erpList[0].Customer_General_Data__r.Zip_Postal_Code__c;
                        CustDataReqLineItem.P_O_Box__c=erpList[0].Customer_General_Data__r.PO_Box__c;
                        CustDataReqLineItem.Country__c=erpList[0].Customer_General_Data__r.Country_Code__c + ' ' + '-'+' ' +erpList[0].Customer_General_Data__r.Country__c ;
                        fetchRegionValues();
                        CustDataReqLineItem.State_Province__c=erpList[0].Customer_General_Data__r.State_Province__c + ' ' + '-'+' ' +erpList[0].Customer_General_Data__r.State__c ;
                    }
                } 
            }
        }
        if(copyAddress == 'false' && count==1 && selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE)
        {
            count=0;
            CustDataReqLineItem.Office_House_Number__c= '';
            CustDataReqLineItem.Street__c='';
            CustDataReqLineItem.House_Supplement__c='';            
            CustDataReqLineItem.City__c='';
            RegionOptions.clear();
            RegionOptions.add(new SelectOption('None', 'None'));
            CustDataReqLineItem.Region__c='';
            CustDataReqLineItem.District__c='';
            CustDataReqLineItem.Postal_Code__c='';
            CustDataReqLineItem.P_O_Box__c='';
            CustDataReqLineItem.P_O_Box_City__c='';
            CustDataReqLineItem.Country__c ='';
        }
    }

    /**
     * Name: fetchRegionValues
     * Params: None
     * Description: Method to Fetch Region Values Whenever the Country is changed.
     */
    public void fetchRegionValues(){
        if(Apexpages.currentPage().getParameters().get('sixthParam')+''!='null')
            CustDataReqLineItem .Country__c= Apexpages.currentPage().getParameters().get('sixthParam')+'';

        List<COB_Region__c> RegionValues =  new List<COB_Region__c>();
        RegionValues = COB_Region__c.getAll().Values();
        RegionValues.Sort();
        RegionOptions= new List<SelectOption>();
        RegionOptions.add(new SelectOption('None', 'None'));

        if(CustDataReqLineItem .Country__c!='' && CustDataReqLineItem .Country__c!=null){
            for (COB_Region__c a : RegionValues)
            {
                if(a.Country__c==CustDataReqLineItem.Country__c.Substring(0,2))
                    RegionOptions.add(new SelectOption(a.Region__c, a.Region__c));
            }

        }
    } 


    /**
     * Name: fetchLocalLangValues
     * Params: None
     * Description: Method to Fetch Region Values in Local Language section Whenever Country is changed.
     */ 
    public void fetchLocalLangValues(){
        if(Apexpages.currentPage().getParameters().get('fourthParam')+''!='null')
            CustDataReqLineItem .Local_Language_Country__c= Apexpages.currentPage().getParameters().get('fourthParam')+'';
        List<COB_Region__c> RegionValues =  new List<COB_Region__c>();
        RegionValues = COB_Region__c.getAll().Values();
        RegionValues.Sort();
        localRegionOptions= new List<SelectOption>();
        localRegionOptions.add(new SelectOption('', 'None')); //<Alvin20150906> Added for R02 enhancement to remove picklist values - Req 9

        if(CustDataReqLineItem.Local_Version__c != null||CustDataReqLineItem.Local_Version__c != ''){
            if(CustDataReqLineItem.Local_Language_Country__c!=null &&  CustDataReqLineItem.Local_Language_Country__c!=''){

                for (COB_Region__c a : RegionValues)
                {

                    if(a.Country__c==CustDataReqLineItem.Local_Language_Country__c.Substring(0,2))
                        localRegionOptions.add(new SelectOption(a.Region__c, a.Region__c));
                }

               if(ApexPages.currentPage().getParameters().get('id')==null)                
                  CustDataReqLineItem.Local_Language_State_Province__c=CustDataReqLineItem.State_Province__c;


            }
        } 
    }    

    /**
     * Name: checkLocalLanguage
     * Params: None
     * Description: Method will be called when Local Language in page is not empty and details are copied.
     */ 
   //  <Nishanth.H 20151001> Added Local Version Functionality as part of R02 Enhancement - Req 15 - updated the if-else condition
    public void checkLocalLanguage(){

        if(Apexpages.currentPage().getParameters().get('thirdParam')+''!='null')
            CustDataReqLineItem.Local_Version__c = Apexpages.currentPage().getParameters().get('thirdParam')+'';
            
        if(!(CustDataReqLineItem.Local_Version__c==null || CustDataReqLineItem.Local_Version__c=='')){
            dispLang = true;
            CustDataReqLineItem.Local_language_Customer_Name_1__c = custOnboardingReq.Local_Customer_Name_1__c;
            CustDataReqLineItem.Local_Language_Customer_Name_2__c =custOnboardingReq.Local_Customer_Name_2__c;
            CustDataReqLineItem.Local_Language_Customer_Name_3__c = custOnboardingReq.Local_Customer_Name_3__c;
            CustDataReqLineItem.Local_Language_Customer_Name_4__c = custOnboardingReq.Local_Customer_Name_4__c;
            CustDataReqLineItem.Local_Language_Search_Terms__c = custOnboardingReq.Local_language_Search_Terms__c;
            CustDataReqLineItem.Local_Language_Office_House_Number__c = custOnboardingReq.Local_Language_Office_House_Number__c;
            CustDataReqLineItem.Local_Language_House_Supplement__c = custOnboardingReq.Local_Language_House_Supplement__c;
            CustDataReqLineItem.Local_Language_Street__c = custOnboardingReq.Local_Language_Street__c;
            CustDataReqLineItem.Local_Language_City__c = custOnboardingReq.Local_Language_City__c;
            CustDataReqLineItem.Local_Language_State_Province__c = custOnboardingReq.Local_Language_State_Province__c;
            localRegionOptions.clear();
            if(custOnboardingReq.Local_Language_State_Province__c != null && custOnboardingReq.Local_Language_State_Province__c != ''){ 
            localRegionOptions.add(new selectoption(custOnboardingReq.Local_Language_State_Province__c,custOnboardingReq.Local_Language_State_Province__c));
            }
            CustDataReqLineItem.Local_Language_Country__c = custOnboardingReq.Local_Language_Country__c;
            CustDataReqLineItem.Local_Language_Region__c = custOnboardingReq.Local_Language_Region__c;
            CustDataReqLineItem.Local_Language_District__c = custOnboardingReq.Local_Language_District__c;
            CustDataReqLineItem.Local_Language_Postal_Code__c = custOnboardingReq.Local_Language_Postal_Code__c;


        }
        else{
            dispLang = false;
            CustDataReqLineItem.Local_language_Customer_Name_1__c = '';
            CustDataReqLineItem.Local_Language_Customer_Name_2__c = '';
            CustDataReqLineItem.Local_Language_Customer_Name_3__c = '';
            CustDataReqLineItem.Local_Language_Customer_Name_4__c = '';
            CustDataReqLineItem.Local_Language_Search_Terms__c = '';
            CustDataReqLineItem.Local_Language_Office_House_Number__c = '';
            CustDataReqLineItem.Local_Language_House_Supplement__c = '';
            CustDataReqLineItem.Local_Language_Street__c = '';
            CustDataReqLineItem.Local_Language_City__c = '';
            CustDataReqLineItem.Local_Language_State_Province__c = '';
            CustDataReqLineItem.Local_Language_Country__c = '';
            CustDataReqLineItem.Local_Language_Region__c = '';
            CustDataReqLineItem.Local_Language_District__c = '';
            CustDataReqLineItem.Local_Language_Postal_Code__c = '';
        }
    }

    /**
     * Name: fetchLocalRegionValues
     * Params: None
     * Description: Method to Fetch local  Region Values WhenEver the local Country is changed.
     */ 

    public void fetchLocalRegionValues(){
        if(Apexpages.currentPage().getParameters().get('fourthParam')+''!='null')
            CustDataReqLineItem.Local_Language_Country__c= Apexpages.currentPage().getParameters().get('fourthParam')+'';
        List<COB_Region__c> LocalRegionValues =  new List<COB_Region__c>();
        LocalRegionValues = COB_Region__c.getAll().Values();
        LocalRegionValues.Sort();
        LocalRegionOptions= new List<SelectOption>();
        LocalRegionOptions.add(new SelectOption('', 'None')); //<Alvin20150906> Added for R02 enhancement to remove picklist values - Req 9
        if(CustDataReqLineItem.Local_Language_Country__c!='' && CustDataReqLineItem.Local_Language_Country__c!=null){
            for (COB_Region__c a : LocalRegionValues)
            {
                if(a.Country__c==CustDataReqLineItem.Local_Language_Country__c.Substring(0,2))
                    LocalRegionOptions.add(new SelectOption(a.Region__c, a.Region__c));
            }
        }

    }

    /**
     * Name: getdisplayLangDetails
     * Params: None
     * Description: Method to render Local language panel and to populate default values based on record type
     */
    // <Nishanth.H 20151001> Added Local Version Functionality  as part of R02 Enhancement - Req 15 - included selectedRecordTypeId == CREATENEWPARTNERFUNCTION_CDRLI_RTYPE
    public Void getdisplayLangDetails(){
        if((CustDataReqLineItem.Local_Version__c == null||CustDataReqLineItem.Local_Version__c == '') && (selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE || selectedRecordTypeId == CREATENEWPARTNERFUNCTION_CDRLI_RTYPE)){
            dispLang =  false;
            CustDataReqLineItem.Local_Language_Country__c ='';
            CustDataReqLineItem.Local_Language_Region__c ='';
            CustDataReqLineItem.Local_Language_State_Province__c='';
            CustDataReqLineItem.Local_Language_Postal_Code__c='';
            CustDataReqLineItem.Local_Language_Office_House_Number__c='';
            CustDataReqLineItem.Local_Language_House_Supplement__c='';
            CustDataReqLineItem.Local_Language_Street__c='';
            CustDataReqLineItem.Local_Language_Street2__c='';
            CustDataReqLineItem.Local_Language_Street3__c='';
            CustDataReqLineItem.Local_Language_Street4__c='';
            CustDataReqLineItem.Local_Language_Street5__c='';
            CustDataReqLineItem.Local_Language_City__c='';
            CustDataReqLineItem.Local_Language_District__c='';

        }
        else if((CustDataReqLineItem.Local_Version__c != null && CustDataReqLineItem.Local_Version__c != '') && (selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE || selectedRecordTypeId == CREATENEWPARTNERFUNCTION_CDRLI_RTYPE)){
            dispLang =  true;

        }
    }

    /**
     * Name: newrecordLockValidation
     * Params: None
     * Description: Method for new record lock validation
     */    
    public void newrecordLockValidation(){
        if(ApexPages.currentPage().getParameters().get('id')==null){
            if(custOnboardingReq.Record_Locked__c == true)
            {

                showNewErrorPage=true;

            }
            else {

                showNewErrorPage=false;
            }
        }
    }

    /**
     * Name: recordLockValidation
     * Params: None
     * Description: Method for record lock validation
     */  
    public void recordLockValidation(){
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            if(custOnboardingReq.Record_Locked__c == true)
            {
                showEditErrorPage=true;

            }
            else {
                showEditErrorPage=false;

            }
        }
    }

    /**
     * Name: newLineItemCreationValidation
     * Params: None
     * Description: Method for new Line Item creation validation
     */  
    public void newLineItemCreationValidation(){
        if(custOnboardingReq.RecordTypeId == MISCELLANEOUS_CDR_RTYPE )
            showErrorPage=true;
        else 
            showErrorPage=false;

    }
    /**
     * Name: Done
     * Params: None
     * Description: Method to return to Customer Data Request record when Account Group of the Request does not match the Request item selected.
     */ 
    public PageReference Done(){
        return new PageReference('/'+custOnboardingReq.Id);
    }

    /**
     * Name: goBack
     * Params: None
     * Description: Method to return to Customer Data Request Line Item record when trying to edit a Line Item record for which CDR record is locked.
     */ 
    public PageReference goBack(){
        return new PageReference('/'+CustDataReqLineItem.Id);
    }

    /**
     * Name: SaveAddress
     * Params: None
     * Description: Method will be called on when request line item has to be Saved.
     */ 
    Public PageReference SaveAddress(){
        if(OnboardingReq.isempty() == false){
            if(ApexPages.currentPage().getParameters().get('action') != 'edit')
            {
                CustDataReqLineItem.Customer_Data_Request__c=OnboardingReq[0].Id;
            }
            CustDataReqLineItem.Sales_Organization__c        = OnboardingReq[0].Sales_Organization__c;
            CustDataReqLineItem.Distribution_Channel__c      = OnboardingReq[0].Distribution_Channel__c;
            CustDataReqLineItem.Division__c  = OnboardingReq[0].Division__c;
            CustDataReqLineItem.Company_Code__c  = OnboardingReq[0].Company_Code__c;
            CustDataReqLineItem.Customer_Name__c = OnboardingReq[0].Customer_Name__c;
            CustDataReqLineItem.Customer_Name_2__c = OnboardingReq[0].Customer_Name_2__c; 
            CustDataReqLineItem.Customer_Name_3__c = OnboardingReq[0].Customer_Name_3__c; 
            CustDataReqLineItem.Customer_Name_4__c = OnboardingReq[0].Customer_Name_4__c; 
            CustDataReqLineItem.RecordTypeId =selectedRecordTypeId ;

            fieldLocalRegionPostalCode ='Local Language State/Province';
        }   
        if(selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE){

            fieldDeliveryPlant = 'Delivery Plant';
            fieldRegionPostal = 'State/Province ';
        }
        if(((selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE) &&
                (CustDataReqLineItem.Country__c== null ||CustDataReqLineItem.Street__c == null ||CustDataReqLineItem.City__c == null || CustDataReqLineItem.Postal_Code__c== null ))){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Fill in all mandatory fields'); ApexPages.addMessage(myMsg);  return null;
        }

        else if(((selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE) 
                && CustDataReqLineItem.Country__c=='CN - China' && CustDataReqLineItem.State_Province__c == 'None'))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, fieldRegionPostal +' is mandatory if country is China'); ApexPages.addMessage(myMsg);  return null;
        }





        if(CustDataReqLineItem.Local_Version__c != null && CustDataReqLineItem.Local_Version__c != ''){
            if((selectedRecordTypeId == CREATENEWBILLTOSHIPTOPAYTO_CDRLI_RTYPE))
                if((CustDataReqLineItem.Local_Language_Country__c== null ||CustDataReqLineItem.Local_Language_City__c == null ||CustDataReqLineItem.Local_Language_Street__c == null||CustDataReqLineItem.Local_Language_Postal_Code__c == null))
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Fill all mandatory fields in Local Language Address Information Section');
                    ApexPages.addMessage(myMsg); 
                    return null;
                }
                else if(CustDataReqLineItem.Local_Language_Country__c=='CN - China' && CustDataReqLineItem.Local_Language_State_Province__c == 'None'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, fieldLocalRegionPostalCode + ' is mandatory');
                    ApexPages.addMessage(myMsg); 
                    return null;
                }

        }       

        try{
            upsert this.CustDataReqLineItem;}
        catch(exception e){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Only One Payer Request Line Item can be added to a Customer Data Request'));
            return null;

        }
        PageReference pr = new PageReference('/'+CustDataReqLineItem.Id);
        pr.setRedirect(true);
        return pr;
    }     



    /****************** Link Contact ***************************/   
    /**
     * Name: populateContact
     * Params: None
     * Description: Method for populating contact
     */   
    public void populateContact(){
        accountContacts=new List<contactWrapper>();
        contacts=new List<Contact>();   
        accountId=custOnboardingReq.Account__r.Id;
        //<Santhosh20161006> Added code to fix the issue : IS ID-00075244.
        list<contact> lstAllContacts=[Select id, name, Email, Phone, MobilePhone, Fax, Department, Role__c from contact where Account.ID =:accountId ORDER BY name];
        contacts=[Select id, name, Email, Phone, MobilePhone, Fax, Department, Role__c from contact where Account.ID =:accountId ORDER BY name limit:Contacts_list_size OFFSET: contactstablecounter];
        Contacts_total_size = lstAllContacts.size();
        lstAllContacts.clear();
        //<Santhosh20161006> End.
        for(Contact con :contacts){
            contactWrapper conwrap = new contactWrapper(false,con.Id,con.Name,con.email,con.phone,con.department,con.Role__c);
            accountContacts.add(conwrap); if (ApexPages.currentPage().getParameters().get('action') == 'edit'&& con.id==CustDataReqLineItem.Partner_Contact__c){ selectedcontact = CustDataReqLineItem.Partner_Contact__c; conwrap.ischeck=true; customerLinkage();
            }

        }
        //} 
    }
    
    /**
     * Name: clearContactList
     * Params: None
     * Description: Method to clear list of contacts
     */    
    public void clearContactList(){
        for(contactWrapper cw:accountContacts){
            if(selectedcontact!=cw.Id){
                cw.ischeck=false;
            }

        }
    }

    /**
     * Name: customerLinkage
     * Params: None
     * Description: Method for linkage of contacts
     */
    public void customerLinkage(){
        if(selectedRecordTypeId == LINKCONTACT_CDRLI_RTYPE){
            if(selectedcontact <> NULL ){
                contact=[Select id, Name ,FirstName , LastName, email, phone, fax, department, Role__c from contact where id=:  selectedcontact];
                flaga=true;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select a contact to be linked'));          
            }
        }
    }
    /**
     * Name: saveContact
     * Params: None
     * Description: Method for saving a contact
     */
    public void saveContact(){
        try{
            contactNew.recordTypeId=customerOnboardingContactRecorType;
            if(OnboardingReq.isempty() == false){

                contactNew.AccountId=OnboardingReq[0].Account__c;
            }
            insert contactNew;
            populateContact();
            displayPopUpFlag=false;
        }catch(Exception e){
            system.debug('=====Exception======='+e);
        }  
    }

    /**
     * Name: saveContactnew
     * Params: None
     * Description: Method for saving a new contact
     */    
    public PageReference saveContactnew(){

        if(OnboardingReq.isempty() == false){
            if(ApexPages.currentPage().getParameters().get('action') != 'edit')
            {CustDataReqLineItem.Customer_Data_Request__c=OnboardingReq[0].Id;}
            CustDataReqLineItem.Sales_Organization__c = OnboardingReq[0].Sales_Organization__c;
            CustDataReqLineItem.Distribution_Channel__c = OnboardingReq[0].Distribution_Channel__c; 
            CustDataReqLineItem.Division__c  = OnboardingReq[0].Division__c; 
            CustDataReqLineItem.Company_Code__c  = OnboardingReq[0].Company_Code__c;
            CustDataReqLineItem.RecordTypeId =selectedRecordTypeId ;
            CustDataReqLineItem.Customer_Name__c = OnboardingReq[0].Customer_Name__c;
            CustDataReqLineItem.Customer_Name_2__c = OnboardingReq[0].Customer_Name_2__c; 
            CustDataReqLineItem.Customer_Name_3__c = OnboardingReq[0].Customer_Name_3__c; 
            CustDataReqLineItem.Customer_Name_4__c = OnboardingReq[0].Customer_Name_4__c; 
        } 
        customerLinkage();

        contactlist = [select id,name,Phone,Email,Fax from Contact where  id=:  selectedcontact];


        if(CustDataReqLineItem.Customer_Contact_Function__c == NULL && flaga == true){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer Contact Function is required'));  return null;
        }

        if(contactlist.isempty() == false){ 
            CustDataReqLineItem.Partner_Contact__c = contactlist[0].id;        

            upsert this.CustDataReqLineItem;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Atleast one contact should be selected'));
            return null;
        }    
        PageReference pr = new PageReference('/'+CustDataReqLineItem.Id);
        pr.setRedirect(true);
        return pr;
    }


    /**
     * Name: cancelnew
     * Params: None
     * Description: Method for redirecting page on click of cancel
     */
    public PageReference cancelnew(){
        PageReference pageRef = new PageReference('/'+custID); 
        pageRef.setRedirect(true);
        return pageRef ;    
    }

    /**
     * Name: newContactCreation
     * Params: None
     * Description: Method for new contact creation
     */
    public void newContactCreation(){
        displayPopUpFlag=true;

    }

    /**
     * Name: cancelContact
     * Params: None
     * Description: Method to redirect page on click of cancel in contact creation
     */
    public void cancelContact(){
        contactNew=new contact();
        displayPopUpFlag=false;

    }
    
    //<Santhosh20161006> Added code for pagination to fix the issue : IS ID-00075244.
    public PageReference Previous() {   
        contactstablecounter -= Contacts_list_size; 
        populateContact();
        return null;
    } 
    
    public Boolean getDisablePrevious() {   
            
        if (contactstablecounter>0) 
            return false; 
        else return true;  
    }   

    public Boolean getDisableNext() {   
                  
        if (contactstablecounter + Contacts_list_size < Contacts_total_size) 
            return false;
        else return true;  
    }       


    public PageReference Next() { 
        contactstablecounter += Contacts_list_size; 
        populateContact();
        return null;
    }
    public Integer getContacts_total_size() {          // this will return total Contacts size
        return Contacts_total_size;    
    } 
    public Integer getPageNumber() {                      // will return the current page number
        return contactstablecounter/Contacts_list_size + 1;    
    }  
    public Integer getTotalPages() {                        // will return total pages in table
        if (math.mod(Contacts_list_size, Contacts_list_size) > 0) {          
            return Contacts_total_size/Contacts_list_size + 1;       
        }
        else {          
            return (Contacts_total_size/Contacts_list_size);       
        } 
    }
    //<Santhosh20161006> End.
    
    public class contactWrapper{
        public boolean ischeck{get; set;}public string Id{get; set;} public string name{get; set;}
        public string email{get; set;} public string phone{get; set;} public string department{get; set;} public string role{get; set;}
        public contactWrapper(Boolean ischeck,String Id, String name, string email, string phone, String department, String role){
            this.Id=Id; this.ischeck=ischeck; this.name=name;
            this.email=email; this.phone=phone; this.department=department; this.role=role; }
    }
    

}
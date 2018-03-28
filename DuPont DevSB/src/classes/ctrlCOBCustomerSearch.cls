/*******************************************************************************
Copyright Â© 2014 DuPont. All rights reserved. 
Author: Alvin Johnson
Email: alvin_johnson@infosys.com
Description:  Class for performing duplicate customer check in COB

Change log: <RS06092016> Rohit saini IS ID-00069327 Adding option for miscellaneous requests

 ********************************************************************************/
Public without sharing class ctrlCOBCustomerSearch{
    public static final string Account_COB_RTYPE = Rtype.getIdByDevName('Account','Customer_On_boarding_Account');
    public static final string ERP_Customer_Extended_Rtype= Rtype.getIdByDevName('ERP_Customer__c','ERP_Customer_Extended_Data');
    public static final string ERP_Customer_General_Rtype= Rtype.getIdByDevName('ERP_Customer__c','ERP_Customer_General_Data');
    public static final string CST_Account_Rtype= Rtype.getIdByDevName('Account','CS_ERPCustomer');
    public static final string CST_Case_Number_CS_InternalRequest_Rtype = Rtype.getIdByDevName('Case','CS_InternalRequest');
    public static final string CST_Case_Number_CS_Order_Rtype = Rtype.getIdByDevName('Case','CS_Order');
    public static final string CST_Case_Number_CS_ServiceRequest_Rtype = Rtype.getIdByDevName('Case','CS_ServiceRequest');
    public static final string NewCustomerCreation_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
    public static final string MISCELLANEOUS_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request');
    Public String CustName{get;set;}
    Public String VAT{get;set;}
    Public String taxCode{get;set;}
    Public String Country{get;set;}
    Public String CustCode{get;set;}
    Public String AccountGrp{get;set;}
    Public String PostalCode{get;set;}
    Public String RegNo{get;set;}

    Public String CustName1{get;set;}
    Public String VAT1{get;set;}
    Public String taxCode1{get;set;}
    Public String Country1{get;set;}
    Public String CustCode1{get;set;}
    Public String AccountGrp1{get;set;}
    Public String PostalCode1{get;set;}
    Public String RegNo1{get;set;}

    Public String CustName2{get;set;}
    Public String VAT2{get;set;}
    Public String taxCode2{get;set;}
    Public String Country2{get;set;}
    Public String CustCode2{get;set;}
    Public String AccountGrp2{get;set;}
    Public String PostalCode2{get;set;}
    Public String RegNo2{get;set;}

    Public String CustName3{get;set;}
    Public String VAT3{get;set;}
    Public String taxCode3{get;set;}
    Public String CustCode3{get;set;}
    Public String PostalCode3{get;set;}
    Public String RegNo3{get;set;}
    Public String CustomerSearchType{get;set;}
    Public boolean IsCriteriaAvailable{get; set;}
    Public Boolean IsListRender{get;set;}
    Public Boolean IsListRender2{get;set;}
    Public Boolean IsListRender3{get;set;}
    Public Boolean IsAccountSearch{get;set;}

    Public boolean singleAccount{get;set;}
    Public List<CustomerWrapperClass> CustomerWrapperList {get;set;}
    Public List<CustomerWrapperClass> CustomerWrapperList1 {get;set;}
    Public List<CustomerWrapperClass> CustomerWrapperList2 {get;set;}
    Public List<CustomerWrapperClass> CustomerWrapperList3 {get;set;}
    Public List<AccountWrapperClass> AccountWrapperList {get;set;}
    Public List<AccountWrapperClass> CustomerRelatedAccountWrapperList {get;set;}
    private integer customertablecounter=0;
    private integer customertablecounter2=0;  //keeps track of the offset for Customer Table  
    private integer customertablecounter3=0;    
    private integer Customer_list_size=10; //sets the page size or number of rows for Customer Table       
    public integer Customer_total_size;
    public integer Customer_total_size2; //used to show user the total size of the list for Customer Table  
    public integer Customer_total_size3;
    private integer RelatedAccountcounter=0;  //keeps track of the offset for Related Account Table    
    private integer RelatedAccount_list_size=5; //sets the page size or number of rows for Related Accounts Table     
    public integer RelatedAccount_total_size; //used to show user the total size of the list for Related Accounts Table   
    private integer GenericAccounttablecounter=0;  //keeps track of the offset for Generic Accounts Table    
    private integer GenericAccount_list_size=5; //sets the page size or number of rows for Generic Accounts Table     
    public integer GenericAccount_total_size; //used to show user the total size of the list for Generic Accounts Table     
    Public String  TypeOfTable{get;set;}
    Public Boolean IsCustomerRelatedAccountListRender{get;set;}
    Public Boolean IsGenericAccountListRender{get;set;}
    Public Boolean IsProceedAvailble{get;set;}
    Public Boolean IsNewAccountOptionAvailble{get;set;}
    Public boolean IsExtendedSearch{get; set;}
    Public boolean isMiscellaneousSearch{get; set;}
    Public boolean isExtendNewSearch{get; set;}
    Public String currentSelectionAccountId{get;set;}
    Public String currentSelectionCustomerId{get;set;}
    Public String currentSelectionCustomerId2{get;set;}
    Public String currentSelectionCustomerId3{get;set;}
    Public String currentSelectionCustomerName{get;set;}
    Public String currentSelectionCustomerName2{get;set;}
    Public String currentSelectionCustomerName3{get;set;}
    Public String currentSelectionCustomerAccountGroup{get;set;}
    public string accountSearchCustomer{get; set;}
    public string accountLinkId{get; set;}
    public boolean isAccountLink{get; set;}
    public List<Account> AccountList;
    public ERP_Customer__c ec{get;set;}
    Public boolean downloadPopUpFlag{get;set;}

    Public String ExistingERPCustomer{get;set;}
    Public Boolean isGenericAccountSearchExecute{get;set;}
    Public Boolean isCustomerSearchExecute{get;set;}
    Public Boolean isCustomerExtendedSearchExecute{get;set;}
    Public Boolean IsSearchCustomersAvailable {get;set;}
    Public Boolean singleCustomerFlag{get;set;}
    public List<ERP_Relationship__c> erpRelationList{get; set;}
    public boolean redirectAccountDirectly{get; set;}
    public ERP_Customer_Localization__c erpLoc{get; set;}
    public ERP_Customer_Localization__c erpLoc1{get; set;}
    public map<string, List<ERP_Customer_Localization__c>> erpMap{get; set;} 
    Public String search;
    Public Id caseId;

    public string localLanguage{get;set;}

    public String getSearch()
    {
        return search;
    }
    public void setSearch(String s)
    {
        if(s!=null)
        {
            this.search = s;

        }
    }
    public List<SelectOption> getLanguages()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        options.add(new SelectOption('Cyrillic', 'Cyrillic'));
        options.add(new SelectOption('Katakana', 'Katakana'));
        options.add(new SelectOption('Chinese trad.', 'Chinese trad.'));
        options.add(new SelectOption('Kanji', 'Kanji'));
        options.add(new SelectOption('Hangul', 'Hangul'));
        options.add(new SelectOption('Greek', 'Greek'));
        options.add(new SelectOption('Chinese', 'Chinese'));
        options.add(new SelectOption('Hebrew', 'Hebrew'));
        options.add(new SelectOption('Arabic', 'Arabic'));
        options.add(new SelectOption('Ukrainian_Cyril', 'Ukrainian_Cyril'));
        options.add(new SelectOption('Thai', 'Thai'));
        return options;

    }
    Public String identifyCST{get;set;}
    Public String caseNumberinfo{get;set;}
    public Customer_Data_Request__c cdr{get;set;}
    public Boolean selectSelected;

    public ctrlCOBCustomerSearch(){
        IsCriteriaAvailable=false;
        IsExtendedSearch=false;
        isMiscellaneousSearch=false;
        IsListRender = false;
        IsListRender2 = false;
        IsListRender3 = false;
        IsAccountSearch=false;
        isExtendNewSearch=false;
        singleAccount=false;
        singleCustomerFlag=false;
        IsCustomerRelatedAccountListRender=false;
        IsGenericAccountListRender=false;
        IsProceedAvailble=false;
        IsNewAccountOptionAvailble=false;
        isGenericAccountSearchExecute = true;
        isCustomerSearchExecute=true;
        isCustomerExtendedSearchExecute=true;
        IsSearchCustomersAvailable = false;

        downloadPopUpFlag = false;
        redirectAccountDirectly=false;
        accountLinkId = '';
        isAccountLink = false;

        cdr = new Customer_Data_Request__c();
        erpRelationList= new List<ERP_Relationship__c>();
        erpLoc = new ERP_Customer_Localization__c();
        erpLoc1 = new ERP_Customer_Localization__c();
        ec= new ERP_Customer__c();
        caseId=apexpages.currentpage().getparameters().get('id');
        system.debug('Id::'+caseId);

    }


    /**
     * Name: currentUserProfile
     * Params: String
     * Description: Method to get profile of Current user.
     */ 
    //<Alvin20150619>Added so that system admin can see all accounts
    public String currentUserProfile(){
        Id ProfileId = UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:ProfileId].Name;
        return profileName;
    }
    
  

    /**
     * Name: TypeofSearchProceed
     * Params: None
     * Description: To check if the user is CST or not. 
     */

    Public void TypeofSearchProceed(){
        IsSearchCustomersAvailable = true;
        selectSelected=true;
        IsCriteriaAvailable=true;
        CustName1 = '';
        VAT1 = '';
        taxCode1 = '';
        Country1 = '';
        CustCode1='';
        AccountGrp1='None';
        PostalCode1='';
        RegNo1='';

        CustName2 = '';
        VAT2 = '';
        taxCode2 = '';
        Country2 = '';
        CustCode2='';
        AccountGrp2='';
        PostalCode2='';
        RegNo2='';

        CustName3 = '';
        VAT3 = '';
        taxCode3 = '';
        CustCode3='';
        PostalCode3='';
        RegNo3='';
        localLanguage='--None--';
        IsExtendedSearch=false;
        isMiscellaneousSearch=false;
        IsListRender = false;
        IsListRender2 = false;
        IsListRender3 = false;
        IsAccountSearch=false;
        isExtendNewSearch=false;
        singleAccount=false;
        singleCustomerFlag=false;
        IsCustomerRelatedAccountListRender=false;
        IsGenericAccountListRender=false;
        IsProceedAvailble=false;
        IsNewAccountOptionAvailble=false;
        redirectAccountDirectly=false;
        isExtendNewSearch =  false; 
        IsListRender3 = false;
        IsExtendedSearch = false;
        currentSelectionAccountId=null;
        currentSelectionCustomerId=null;
        currentSelectionCustomerName=null;
        currentSelectionCustomerId3=null;
        currentSelectionCustomerId2 = null;
        CustName='';
        IsNewAccountOptionAvailble=false;
        identifyCST ='Non CST Customer';
        if(search==null )
        {
            selectSelected=false;

        }
        if(selectSelected==false){
            IsCriteriaAvailable=false;

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a search to Proceed'));

        }     
        else   if((identifyCST=='CST Customer') && ( string.valueOf(cdr.Case_Number__c) == null || string.valueOf(cdr.Case_Number__c)=='')){
            IsCriteriaAvailable=false;

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter Case Number');
            ApexPages.addMessage(msg);
        } 
        else if(  (string.valueOf(cdr.Case_Number__c) != null && string.valueOf(cdr.Case_Number__c)!='') ){
            List<Case> caseCheck = new List<Case>();
            caseCheck = [select id, CaseNumber from Case where id=: cdr.Case_Number__c and (recordTypeId=:CST_Case_Number_CS_InternalRequest_Rtype or recordTypeId =: CST_Case_Number_CS_Order_Rtype or recordTypeId =: CST_Case_Number_CS_ServiceRequest_Rtype)  limit 1];
            if(caseCheck.size() ==0){
                identifyCST ='Non CST Customer';

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Case Number is not valid'));
            }
            else if(caseCheck.size() >0){
                identifyCST='CST Customer';
            }
        }


    }

    /**
     * Name: findMatchCustomers
     * Params: None
     * Description: To search customers based on the criteria. 
     */
    public void findMatchCustomers(){
    
        if(search=='Duplicate Search'){
            CustName = CustName3 ;
            VAT = VAT3 ;
            taxCode = taxCode3 ;
            CustCode=CustCode3;
            PostalCode=PostalCode3;
            RegNo=RegNo3;
            Country = null;
            AccountGrp=null;

        }
        else{
            CustName = CustName1 ;
            VAT = VAT1 ;
            taxCode = taxCode1 ;
            Country = Country1 ;
            CustCode=CustCode1;
            AccountGrp=AccountGrp1;
            PostalCode=PostalCode1;
            RegNo=RegNo1;

        }
        erpMap  = new map<string, List<ERP_Customer_Localization__c>>();
        IsAccountSearch=false;
        IsListRender2=false;
        IsListRender3=false;
        IsCustomerRelatedAccountListRender=false;
        IsGenericAccountListRender=false;
        IsProceedAvailble = false;
        singleAccount=false;
        IsExtendedSearch=false;
        isExtendNewSearch=false;
        IsNewAccountOptionAvailble=false;
        currentSelectionAccountId=null;
        currentSelectionCustomerId=null;
        currentSelectionCustomerName=null;
       if(isCustomerSearchExecute==true){
            customertablecounter=0;
        } 

        RelatedAccountcounter=0;
        GenericAccounttablecounter=0;

        CustomerWrapperList1 = new List<CustomerWrapperClass>();


        if((CustName==null || CustName=='' ) && (PostalCode==null || PostalCode=='') && (RegNo==null || RegNo=='') && (VAT == null || VAT == '') && (taxCode==null || taxCode=='') && (CustCode==null || CustCode=='') && (Country ==null || Country =='') && (AccountGrp==null || AccountGrp=='') ){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Error_Customer_Entry_Criteria));
                
        }
        else{
            
            CustomerSearchType='first';
            if(customerQuery()!=null){
                IsAccountSearch=true;
                CustomerWrapperList1=customerQuery();
            }
            else{
                if(search == 'Duplicate Search')   {
                    IsAccountSearch=true;

                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Customers available for search criteria, search Accounts'));
                }  
                else{
                    IsAccountSearch=false;

                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Customers available for search criteria'));
                }       


            }
            if(identifyCST=='CST Customer' && search == 'Duplicate Search'){
                IsAccountSearch=false;
                IsProceedAvailble=true;
            }

        }
    }        

    /**
     * Name: customerQuery
     * Params: List
     * Description: Method will query customers based on type of search and search parameters and returns as wrapper. 
     */
    public List<CustomerWrapperClass> customerQuery(){
        CustomerWrapperList = new List<CustomerWrapperClass>();

        List<string> erpLocalCustName = new List<string>();
        String CustomerQuery;
        String accountGroup;
        List<ERP_Customer__c> CustomerList = new List <ERP_Customer__c>();
        List<ERP_Customer__c> TotalCustomerList = new List <ERP_Customer__c>();
        erpMap  = new map<string, List<ERP_Customer_Localization__c>>();

        if(localLanguage == '' || localLanguage=='--None--'){
            CustomerQuery ='Select Id, Name,VAT_Number__c,External_ERP_ID__c,Tax_Code__c,Account_Group__c,Customer_General_Data__c,Customer_Code__c,Sales_Org_Code__c,Street__c,City__c,State__c,Country__c,ZIP_Postal_Code__c,Customer_business_license_Reg_number__c,RecordType.Name,Legal_Entity_Code__c,Source_Cluster__c,Distribution_Channel__c,Division__c,Customer_Status__c from ERP_Customer__c where Id!= null';
        }
        //<Alvin20150609> Added for search in local language
        else if(localLanguage != '' && localLanguage!=null  && localLanguage!='--None--'){
            if(CustName!=null && CustName!=''){
                String CustName1 = '%'+' '+CustName.trim()+' '+'%';
                String CustName2 = '%'+' '+CustName.trim();
                String CustName3 = CustName.trim()+' '+'%';
                String CustName4 = '%'+CustName.trim()+'%';
                for(ERP_Customer_Localization__c elocal : [select id,ERP_Customer__c from ERP_Customer_Localization__c where fLocal_Language__c Like : localLanguage and (Customer_Name__c Like : CustName1 or Customer_Name__c Like : CustName2 or Customer_Name__c Like : CustName3 or Customer_Name__c Like : CustName4 or Customer_Name__c Like : CustName)]){
                    erpLocalCustName.add(elocal.ERP_Customer__c);
                }

                CustomerQuery = 'Select Id, Name,VAT_Number__c,External_ERP_ID__c,Tax_Code__c,Account_Group__c,Customer_General_Data__c,Customer_Code__c,Sales_Org_Code__c,Street__c,City__c,State__c,Country__c,ZIP_Postal_Code__c,Customer_business_license_Reg_number__c,RecordType.Name,Legal_Entity_Code__c,Source_Cluster__c,Distribution_Channel__c,Division__c,Customer_Status__c from ERP_Customer__c where (Id in : erpLocalCustName or Customer_General_Data__c in : erpLocalCustName)';
            }
        }
        if(search=='Duplicate Search')
            CustomerQuery+= '';
        else if(search== 'Modify Search' && IsListRender2== false)   
            CustomerQuery+= ' and recordTypeId =: ERP_Customer_Extended_Rtype';
        else if(search== 'Modify Search' && IsListRender2== true) {
            String acc = 'Z001 ( Sold-to party )';
            accountGroup= '%Sold%';

            CustomerQuery+= ' and Id IN (SELECT ERP_Customer__c FROM ERP_Relationship__c where Related_ERP_Customer__c=: currentSelectionCustomerId) and Account_Group__c LIKE: accountGroup';  

        }
        else if(search == 'Extend a Customer' && IsListRender3== false){
            accountGroup= '%Sold%';
            CustomerQuery+= ' and Account_Group__c Like : accountGroup';
        }
        else if(search == 'Extend a Customer' && IsListRender3== true) {
            accountGroup= '%Sold%';
            CustomerQuery+= ' and recordTypeId =: ERP_Customer_General_Rtype and (NOT Account_Group__c LIKE :accountGroup) ';
        }


        if(!(search== 'Modify Search' && IsListRender2== true)){
            if((localLanguage == '' || localLanguage=='--None--') && CustName!=null && CustName!=''){
                String CustName1 = '%'+' '+CustName+' '+'%';
                String CustName2 = '%'+' '+CustName;
                String CustName3 = CustName+' '+'%';
                String CustName4 = '%'+CustName+'%';
                CustomerQuery=CustomerQuery+' and (Name like :CustName1 Or Name like :CustName2 Or Name like :CustName3 Or Name=:CustName Or  Name like :CustName4)';
            }

            if(PostalCode!=null && PostalCode!=''){
                CustomerQuery=CustomerQuery+' and ZIP_Postal_Code__c=:PostalCode';
            }

            if(RegNo!=null && RegNo!=''){
                CustomerQuery=CustomerQuery+' and Customer_business_license_Reg_number__c=:RegNo';
            }

            if(VAT !=null && VAT !=''){
                CustomerQuery=CustomerQuery+' and VAT_Number__c=:VAT';
            }

            if(taxCode!=null && taxCode!=''){
                CustomerQuery=CustomerQuery+' and Tax_Code__c=:taxCode';
            }

            if(CustCode!=null && CustCode!=''){
                CustomerQuery=CustomerQuery+' and Customer_Code__c=:CustCode';
            }
            if(AccountGrp!=null && AccountGrp!='' && AccountGrp!='None' ){
                CustomerQuery=CustomerQuery+' and Account_Group__c=:AccountGrp';
            }

            if(Country !=null && Country !=''){
                CustomerQuery=CustomerQuery+' and Country__c=:Country';
            }

        }
        String DupGenCustQuesry =CustomerQuery+' order by Name Limit 5000';
        CustomerQuery=CustomerQuery+' order by Name';


        if(CustomerSearchType=='first'){
            TotalCustomerList = database.query(DupGenCustQuesry );
            Customer_total_size = TotalCustomerList.size();
            CustomerQuery=CustomerQuery+' limit :Customer_list_size offset :customertablecounter';
        }
        else if(CustomerSearchType=='second'){
            TotalCustomerList = database.query(DupGenCustQuesry );
            Customer_total_size2 = TotalCustomerList.size();
            CustomerQuery=CustomerQuery+' limit :Customer_list_size offset :customertablecounter2';
        }
        else if(CustomerSearchType=='third'){
            TotalCustomerList = database.query(DupGenCustQuesry );
            Customer_total_size3 = TotalCustomerList.size();
            CustomerQuery=CustomerQuery+' limit :Customer_list_size offset :customertablecounter3';
        }
        CustomerList = database.query(CustomerQuery);


        if(TotalCustomerList.size()==0 && IsListRender2!= true && IsListRender3!=true ){

            IsListRender = false;
            IsAccountSearch=true;
            return null;
        }
        else{
            if(localLanguage != '' && localLanguage!=null  && localLanguage!='--None--'){
                List<String> erpCustomerIdList = new List<String>();
                for(ERP_Customer__c  s : CustomerList ){
                    if(s.recordtypeId == ERP_Customer_General_Rtype)
                        erpCustomerIdList.add(string.valueOf(s.Id));
                    if(s.recordtypeId == ERP_Customer_Extended_Rtype)
                        erpCustomerIdList.add(string.valueOf(s.Customer_General_Data__c));

                }
                List<ERP_Customer_Localization__c> erpList = new List<ERP_Customer_Localization__c>();
                erpList= [select Id, City__c, Country__c, Customer_Name__c, ERP_Customer__c, External_ERP_ID__c,fLocal_Language__c, Language__c, PO_Box__c, State__c, Street__c, ZIP_Postal_Code__c from ERP_Customer_Localization__c where fLocal_Language__c = : localLanguage and ERP_Customer__c in : erpCustomerIdList Limit : 50000 ];
                for(ERP_Customer_Localization__c eList : erpList){
                    String key = eList.ERP_Customer__c + eList.fLocal_Language__c;
                    if(erpMap.containsKey(key))
                        erpMap.get(key).add(eList);
                    else{
                        List<ERP_Customer_Localization__c> erList = new List<ERP_Customer_Localization__c>();
                        erList.add(eList);
                        erpMap.put(key,erList);

                    }

                }

                for(ERP_Customer__c erpc :CustomerList ){
                    String s;
                    if(erpc.recordtypeId == ERP_Customer_General_Rtype)
                        s = erpc.Id+localLanguage;
                    if(erpc.recordtypeId == ERP_Customer_Extended_Rtype)
                        s = erpc.Customer_General_Data__c +localLanguage;
                    List<ERP_Customer_Localization__c> eList = new List<ERP_Customer_Localization__c>();
                    eList=erpMap.get(s);

                    if(eList!= null){
                        for(ERP_Customer_Localization__c el : eList){
                            CustomerWrapperClass wc = new CustomerWrapperClass(erpc.Id,erpc.Name,el.Customer_Name__c,erpc.VAT_Number__c,erpc.Tax_Code__c,erpc.Account_Group__c,erpc.Customer_Code__c,erpc.Sales_Org_Code__c,false,el.City__c,el.State__c,el.Country__c,el.ZIP_Postal_Code__c,el.Street__c,erpc.Source_Cluster__c,erpc.Legal_Entity_Code__c,erpc.Distribution_Channel__c,erpc.Division__c,false,erpc.Customer_Status__c, erpc.External_ERP_ID__c);
                            if(search != 'Extend a Customer' || IsExtendedSearch ==true){
                                CustomerWrapperList.add(wc);
                            }

                            else{
                                if(erpc.recordTypeId==ERP_Customer_General_Rtype || (erpc.recordTypeId == ERP_Customer_Extended_Rtype && erpc.Account_Group__c.contains('Z001'))){
                                    CustomerWrapperList.add(wc);
                                }
                            }
                            break;
                        }   
                    }
                    else{

                        CustomerWrapperClass wc = new CustomerWrapperClass(erpc.Id,erpc.Name,'',erpc.VAT_Number__c,erpc.Tax_Code__c,erpc.Account_Group__c,erpc.Customer_Code__c,erpc.Sales_Org_Code__c,false,erpc.City__c,erpc.State__c,erpc.Country__c,erpc.ZIP_Postal_Code__c,erpc.Street__c,erpc.Source_Cluster__c,erpc.Legal_Entity_Code__c,erpc.Distribution_Channel__c,erpc.Division__c,false,erpc.Customer_Status__c, erpc.External_ERP_ID__c);
                        if(search != 'Extend a Customer' || IsExtendedSearch ==true){
                            CustomerWrapperList.add(wc);
                        }

                        else{
                            if(erpc.recordTypeId==ERP_Customer_General_Rtype || (erpc.recordTypeId == ERP_Customer_Extended_Rtype && erpc.Account_Group__c.contains('Z001'))){
                                CustomerWrapperList.add(wc);
                            }
                        }
                    } 


                } 
            } 
            else{
                for(ERP_Customer__c erpc :CustomerList ){
                    CustomerWrapperClass wc = new CustomerWrapperClass(erpc.Id,erpc.Name,'',erpc.VAT_Number__c,erpc.Tax_Code__c,erpc.Account_Group__c,erpc.Customer_Code__c,erpc.Sales_Org_Code__c,false,erpc.City__c,erpc.State__c,erpc.Country__c,erpc.ZIP_Postal_Code__c,erpc.Street__c,erpc.Source_Cluster__c,erpc.Legal_Entity_Code__c,erpc.Distribution_Channel__c,erpc.Division__c,false,erpc.Customer_Status__c,erpc.External_ERP_ID__c);
                    if(search != 'Extend a Customer' || IsExtendedSearch ==true){
                        CustomerWrapperList.add(wc);
                    }

                    else{
                        if(erpc.recordTypeId==ERP_Customer_General_Rtype || (erpc.recordTypeId == ERP_Customer_Extended_Rtype && erpc.Account_Group__c.contains('Z001'))){
                            CustomerWrapperList.add(wc);
                        }
                    }
                }  
            }
            IsListRender = true;

        }
        return CustomerWrapperList;
    }


    /**
     * Name: AccountSearch
     * Params: None
     * Description: To search related accounts. 
     */


    Public Pagereference AccountSearch(){
        system.debug('Accountsearch 77777' );

        if(isGenericAccountSearchExecute==true){
            IsAccountSearch = true;
            IsCustomerRelatedAccountListRender=false;
            IsGenericAccountListRender=false;
            IsProceedAvailble = false;
            IsNewAccountOptionAvailble=false;
            RelatedAccountcounter=0;
            GenericAccounttablecounter=0;
        }  
        Boolean IsCustomerCheckDone;
        CustomerWrapperClass Cust;
        redirectAccountDirectly =false;
        AccountWrapperClass awc1;

 system.debug('Accountsearch 77777---1' );
        IsListRender3=false;
        IsCustomerRelatedAccountListRender=false;
        IsGenericAccountListRender=false;
        IsProceedAvailble = false;
        IsExtendedSearch=false;
        isExtendNewSearch=false;
        IsNewAccountOptionAvailble=false;
        List<Account> customerRelatedAccountList=new List<Account>();
        List<Account> relatedAccountListWithoutShare=new List<Account>();
        CustomerRelatedAccountWrapperList  = new List<AccountWrapperClass>();


        if(search != 'Duplicate Search'){       
            if((Search=='Modify Search' || search == 'Extend a Customer') && IsListRender== true && IsListRender2 == false){
                for(CustomerWrapperClass wc :CustomerWrapperList1){
                    if(wc.isChecked==true){
                        IsCustomerCheckDone=true;
                        Cust=wc;
                    }
                }
                if(IsCustomerCheckDone==null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a customer to Proceed'));
                }
            }
            else if(Search=='Modify Search' && IsListRender== true && IsListRender2 == true){
                for(CustomerWrapperClass wc :CustomerWrapperList2){
                    if(wc.isChecked==true){
                        IsCustomerCheckDone=true;
                        Cust=wc;
                    }
                }
                if(IsCustomerCheckDone==null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a Sold to customer to Proceed'));
                }       
            }

            if(IsCustomerCheckDone==true){
                ERP_Customer__c erpCustCheck = new ERP_Customer__c();
                erpCustCheck = [select id, recordTypeId from ERP_Customer__c where Id =: Cust.Id];
                if(search == 'Extend a Customer' && erpCustCheck.recordTypeId == ERP_Customer_General_Rtype){
                    isExtendNewSearch=false;
                    IsNewAccountOptionAvailble=true;
                    IsProceedAvailble=true;
                    IsListRender3=false;
                    IsExtendedSearch=false;
                    GenericAccountSearch();

                }

                else{


                    if(identifyCST== 'CST Customer'){
                        relatedAccountListWithoutShare = [Select Id,Name, UserRecordAccess.HasReadAccess, VAT_Number__c,Region__c,Owning_Organization__c,Country__c,ERP_Customer__r.Name,Type,Company_Code__c,RecordTypeId,OwnerId,SBU__c,External_Account_ID__c from Account where ERP_Customer__c=:Cust.Id AND recordTypeId=:CST_Account_Rtype order by Name limit :RelatedAccount_list_size offset :RelatedAccountcounter];

                    }
                    else{
                        relatedAccountListWithoutShare = [Select Id,Name, UserRecordAccess.HasReadAccess, VAT_Number__c,Region__c,Owning_Organization__c,Country__c,ERP_Customer__r.Name,Type,Company_Code__c,RecordTypeId,OwnerId,SBU__c,External_Account_ID__c from Account where ERP_Customer__c=:Cust.Id AND recordTypeId !=:CST_Account_Rtype order by Name limit :RelatedAccount_list_size offset :RelatedAccountcounter];

                    }
                    customerRelatedAccountList=AccountShareList(relatedAccountListWithoutShare);//<Alvin20150608> Added for account share 
                    RelatedAccount_total_size=customerRelatedAccountList.size();
                    // If Related accounts are available
                    if(RelatedAccount_total_size ==1 && identifyCST== 'CST Customer' && search != 'Extend a Customer'){
                        redirectAccountDirectly = true;
                        currentSelectionAccountId = customerRelatedAccountList[0].Id;
                        return openDownloadPopUpFlag();
                    }
                    else if(RelatedAccount_total_size ==1  && search == 'Modify Search' &&  identifyCST=='Non CST Customer'){
                        redirectAccountDirectly = true;
                        currentSelectionAccountId = customerRelatedAccountList[0].Id;
                        return openDownloadPopUpFlag();

                    } 

                    if(RelatedAccount_total_size !=0){
                        for(Account a:customerRelatedAccountList ){
                            awc1 = new AccountWrapperClass(a.Id,a.Name,a.VAT_Number__c,a.Region__c,a.Country__c,a.Company_Code__c,a.Type,false,a.ERP_Customer__r.Name,a.Owning_Organization__c,a.RecordTypeId,a.OwnerId,a.SBU__c,a.External_Account_ID__c);
                            CustomerRelatedAccountWrapperList.add(awc1);
                        }
                        IsCustomerRelatedAccountListRender=true;
                        IsProceedAvailble = true;
                        IsNewAccountOptionAvailble=true;
                    }

                    // If Related accounts are not available
                    else{
                        IsCustomerRelatedAccountListRender=false;
                        IsNewAccountOptionAvailble=true;

                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Related Accounts exist for selected Customer.'));
                        if(search == 'Modify Search' || search== 'Extend a Customer')
                            GenericAccountSearch();
                    }
                    if(search == 'Extend a Customer' && erpCustCheck.recordTypeId == ERP_Customer_Extended_Rtype && RelatedAccount_total_size >0){
                        isExtendNewSearch=true;
                        IsNewAccountOptionAvailble=false;
                        IsProceedAvailble=false;


                    }   

                }
            }   

        }

        if((isGenericAccountSearchExecute==true) && (search=='Duplicate Search'))
            GenericAccountSearch();
        return null;
    }    
   
    /**
     * Name: extendsearch
     * Params: None
     * Description: display the section to enter second search criteria for extend search. 
     */
   
    public void extendsearch(){
        CustName2 = '';
        VAT2 = '';
        taxCode2 = '';
        Country2 = '';
        CustCode2='';
        AccountGrp2='None';
        PostalCode2='';
        RegNo2='';

        IsListRender3=false;
        boolean accountListFlag =false;
        if(IsCustomerRelatedAccountListRender==true && IsGenericAccountListRender==false  && currentSelectionAccountId==null ){
            for(AccountWrapperClass acc : CustomerRelatedAccountWrapperList){
                if(acc.isChecked == true){
                    accountListFlag=true;
                    currentSelectionAccountId=acc.Id;
                }
            }
        }
        else if(IsGenericAccountListRender==true){
            for(AccountWrapperClass acc : AccountWrapperList){
                if(acc.isChecked == true){
                    accountListFlag=true;
                    currentSelectionAccountId=acc.Id;
                }
            }
        }
        if(accountListFlag==false && identifyCST == 'Non CST Customer' && currentSelectionAccountId==null){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an Account'));
        }
        else{
            IsExtendedSearch =true;
        }

    }
 // <RS06092016> Rohit saini IS ID-00069327 Adding option for miscellaneous requests

    public PageReference  MiscellaneousReq(){
        if(search  == 'Miscellaneous request' && isMiscellaneousSearch==true){
                PageReference pageRef= new PageReference('/apex/COBMiscellaneousRequest?Account=null&AccountLink=null&Case='+caseId +'&Clone=null&ERPCustomer=null&Id=null&RecordTypeId='+MISCELLANEOUS_COB_RTYPE+'&Search=null');
                 system.debug('pageRef::'+pageRef);
                 pageref.setredirect(true);
                return pageRef;                                         
         }    
         else 
             return null;   
             
        } 
     
    /**
     * Name: populateCustomer
     * Params: None
     * Description: To populate the table with customers that match second search criteria in extend. 
     */
    public void populateCustomer(){

        IsListRender2=false;
        CustName = CustName2 ;
        VAT = VAT2 ;
        taxCode = taxCode2 ;
        Country = Country2 ;
        CustCode=CustCode2;
        AccountGrp=AccountGrp2;
        PostalCode=PostalCode2;
        RegNo=RegNo2;

        CustomerWrapperList3 = new List<CustomerWrapperClass>();
        if((CustName2==null || CustName2=='' ) && (PostalCode2==null || PostalCode2=='') && (RegNo2==null || RegNo2=='') && (VAT2 == null || VAT2 == '') && (taxCode2==null || taxCode2=='') && (CustCode2==null || CustCode2=='')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Error_Customer_Entry_Criteria));
        }
        else{
            IsListRender3=true;
            CustomerSearchType='third';
            if(isCustomerExtendedSearchExecute==true){
                customertablecounter3=0;
            }
            if(customerQuery() != null){
                CustomerWrapperList3 = customerQuery();
            }

            if(CustomerWrapperList3.size()==0){

                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No Customer available for selected');
                ApexPages.addMessage(msg);
                IsListRender3=false;
            }

        }
    }

    /**
     * Name: GenericAccountSearch
     * Params: None
     * Description: To search Generic accounts. 
     */
    Public void GenericAccountSearch(){
        if(search=='Duplicate Search'){
            CustName = CustName3 ;
            VAT = VAT3 ;
            taxCode = taxCode3 ;
            CustCode=CustCode3;
            PostalCode=PostalCode3;
            RegNo=RegNo3;
            Country = null;
            AccountGrp=null;

        }
        else{
            CustName = CustName1 ;
            VAT = VAT1 ;
            taxCode = taxCode1 ;
            Country = Country1 ;
            CustCode=CustCode1;
            AccountGrp=AccountGrp1;
            PostalCode=PostalCode1;
            RegNo=RegNo1;

        }
        List<Account> generalAccountList=new List<Account>();
        List<Account> generalTotalAccountList=new List<Account>();
        AccountWrapperList = new  List<AccountWrapperClass>();
        Boolean OrIndicator = false;
        AccountWrapperClass awc;
        String accountQuery='Select Id,Name,UserRecordAccess.HasReadAccess,VAT_Number__c,Region__c,Country__c,External_Account_ID__c,ERP_Customer__r.Name,Owning_Organization__c,Type,Company_Code__c,Shipping_Tax_Code_1__c,Shipping_Tax_Code_3__c,Billing_Tax_Code_1__c,Billing_Tax_Code_3__c,RecordTypeId,OwnerId,SBU__c,Product__c from Account where ERP_Customer__c = null';
        system.debug('AccountQuery='+accountQuery);
        if((CustName==null || CustName=='' ) && (VAT == null || VAT == '') && (taxCode==null || taxCode=='') && (CustCode==null || CustCode=='') && (Country==null || Country=='')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Error_Account_Entry_Criteria));
            IsGenericAccountListRender=false;
        }
        else{
            if(identifyCST== 'Non CST Customer') {  
                if(search=='Extend a Customer')
                    accountQuery += ' and recordtypeId !=: CST_Account_Rtype  ';
                if(search=='Modify Search')
                    accountQuery += ' and recordtypeId !=: CST_Account_Rtype  ';
                if(search=='Duplicate Search')
                    accountQuery += ' and recordtypeId !=: CST_Account_Rtype  ';
                
            }          
            else if(identifyCST== 'CST Customer'){
                if(search=='Extend a Customer')
                    accountQuery += ' and recordtypeId =: CST_Account_Rtype  ';
                if(search=='Modify Search')
                    accountQuery += ' and recordtypeId =: CST_Account_Rtype  ';

                if(search=='Duplicate Search')
                    accountQuery += ' and recordtypeId =: CST_Account_Rtype  ';
            }
            
            if(CustName!=null && CustName!=''){
                String CustName1 = '%'+' '+CustName.trim()+' '+'%';
                String CustName2 = '%'+' '+CustName.trim();
                String CustName3 = CustName.trim()+' '+'%';
                String CustName4 = '%'+CustName.trim()+'%';
                if(currentSelectionCustomerName == null || currentSelectionCustomerName == ''){
                    accountQuery=accountQuery+' AND (Name like :CustName4 Or Name like :CustName2 Or Name like :CustName3 Or Name=:CustName  Or Name like :CustName1)';
                }  
                else{
                    String CustName5 = currentSelectionCustomerName.trim();
                    system.debug('currentSelectionCustomerName='+CustName5);
                    accountQuery=accountQuery+' AND (Name like :CustName4 Or Name like :CustName2 Or Name like :CustName3 Or Name=:CustName  Or Name like :CustName1 or Name like : CustName5)';
                }        
                system.debug('Customer Name='+CustName+' '+CustName1+' '+CustName2+' '+' '+CustName3 +' '+CustName4);
                system.debug('AccountQuery='+accountQuery);
            }
            // <Alvin 21072015> added for search based on customer selected
            if((currentSelectionCustomerName != null && currentSelectionCustomerName != '')&& (CustName==null || CustName=='')){
                    String CustName5 = currentSelectionCustomerName.trim();
                    system.debug('currentSelectionCustomerName='+CustName5);
                    accountQuery=accountQuery+ ' AND Name like :CustName5';
            }
            
            system.debug('AccountQuery='+accountQuery);
            if(VAT !=null && VAT !=''){

                accountQuery=accountQuery+' AND';
                accountQuery=accountQuery+' VAT_Number__c=:VAT';

            }
           // <Alvin 21072015>
            if(CustCode!=null && CustCode!='' && search=='Duplicate Search'){

                accountQuery=accountQuery+' AND';
                accountQuery=accountQuery+' ERP_Customer__r.Customer_Code__c =:CustCode';

            }

            if(Country!=null && Country!=''){

                accountQuery=accountQuery+' AND';
                accountQuery=accountQuery+' Country__c=:Country';

            }

            if(taxCode!=null && taxCode!=''){

                accountQuery=accountQuery+' AND';
                accountQuery=accountQuery+' (Shipping_Tax_Code_1__c=:taxCode Or Shipping_Tax_Code_3__c=:taxCode Or Billing_Tax_Code_1__c=:taxCode Or Billing_Tax_Code_3__c=:taxCode)';

            }

            String GenQuery= accountQuery+' limit 5000';           
            system.debug('AccountQueryFinal='+accountQuery);
            system.debug('AccountQueryFinalOutput='+database.query(GenQuery));
            generalTotalAccountList= AccountShareList(database.query(GenQuery));//<Alvin20150608> Added for account share 
            system.debug('generalTotalAccountList='+generalTotalAccountList);
            GenericAccount_total_size = generalTotalAccountList.size();
            List<string> accoundIds = new List<String>();
            for(Account acc : generalTotalAccountList){
                accoundIds.add(string.valueof(acc.Id));
            }
            accountQuery = accountQuery+' and id in : accoundIds order by Name limit :GenericAccount_list_size offset :GenericAccounttablecounter';
            generalAccountList = database.query(accountQuery);

            // If Generic Accounts are available for Criteria entered

            if(generalTotalAccountList.size()!=0){
                for(Account a1:generalAccountList){
                    awc = new AccountWrapperClass(a1.Id,a1.Name,a1.VAT_Number__c,a1.Region__c,a1.Country__c,a1.Company_Code__c,a1.Type,false,a1.ERP_Customer__r.Name,a1.Owning_Organization__c,a1.RecordTypeId,a1.OwnerId,a1.SBU__c,a1.External_Account_ID__c);
                    AccountWrapperList.add(awc);
                }
                IsGenericAccountListRender=true;
                IsProceedAvailble = true;
                IsNewAccountOptionAvailble=true;
                if(search=='Extend a Customer' && ec.recordTypeId != ERP_Customer_General_Rtype){
                    isExtendNewSearch=true;
                    IsProceedAvailble=false;
                }
            }

            // If Generic Accounts are not available for Criteria entered

            else{
                IsGenericAccountListRender=false;
                IsNewAccountOptionAvailble=true;
                if(identifyCST== 'CST Customer' && generalTotalAccountList.size()==0 && ec.recordTypeId == ERP_Customer_General_Rtype && search=='Extend a Customer'){
                    isExtendNewSearch=false;
                    IsProceedAvailble=true;
                }
                if(identifyCST== 'CST Customer' && generalTotalAccountList.size()==0 && ec.recordTypeId != ERP_Customer_General_Rtype && search=='Extend a Customer' ){
                    isExtendNewSearch=true;
                    IsProceedAvailble=false;
                }

                else{
                    isExtendNewSearch=false;
                }

                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No generic accounts available');
                ApexPages.addMessage(msg);


            }

        }
        isGenericAccountSearchExecute = false;
    }


    /**
     * Name: ClearAccountList
     * Params: None
     * Description: To uncheck an account when another one is checked. 
     */
    Public void ClearAccountList(){
        for(AccountWrapperClass a:AccountWrapperList ){
            if(currentSelectionAccountId!=a.Id){
                a.isChecked=false;
            }
        }
        for(AccountWrapperClass a1: CustomerRelatedAccountWrapperList){
            if(currentSelectionAccountId!=a1.Id){
                a1.isChecked=false;
            }
        }
    }


    /**
     * Name: ClearCustomerList
     * Params: None
     * Description: To uncheck a customer when another one is checked. 
     */
    Public void ClearCustomerList(){
        AccountWrapperList = new  List<AccountWrapperClass>();

        CustomerRelatedAccountWrapperList = new  List<AccountWrapperClass>();
        List<Account> accWithoutShare = new List<Account>();
        List<Account> acc = new List<Account>();
        IsCustomerRelatedAccountListRender = false;
        IsGenericAccountListRender= false;
        IsAccountSearch = true;
        IsExtendedSearch=false;
        IsProceedAvailble = false;
        IsListRender2=false;
        singleAccount=false;
        singleCustomerFlag=false;
        isExtendNewSearch=false;
        currentSelectionCustomerName2=null;
        currentSelectionAccountId =null;
        IsNewAccountOptionAvailble=false;
        CustomerWrapperList2 = new List<CustomerWrapperClass>();

        ec=[select id, recordTypeId, Name from ERP_Customer__c where id=:currentSelectionCustomerId];
        IsListRender3=false;
        for(CustomerWrapperClass w:CustomerWrapperList1){
            if(currentSelectionCustomerId!=w.Id){
                w.isChecked=false;
            }
        }

        if(search=='Modify Search' &&  !currentSelectionCustomerAccountGroup.contains('Z001')){
            CustomerSearchType='second';
            IsListRender2=true;
            if(customerQuery()!= null){
                CustomerWrapperList2=customerQuery();
                if(!currentSelectionCustomerAccountGroup.contains('Z001') && CustomerWrapperList2.size()==1){
                    IsListRender2=false;
                    singleCustomerFlag=true;
                    currentSelectionCustomerId2=CustomerWrapperList2[0].Id;

                    if(identifyCST== 'CST Customer'){
                        accWithoutShare =[select id, name from Account where ERP_Customer__r.Id =:CustomerWrapperList2[0].Id and recordTypeId =:CST_Account_Rtype];
                    }
                    else{
                        accWithoutShare =[select id, name from Account where ERP_Customer__r.Id =:CustomerWrapperList2[0].Id and recordTypeId !=:CST_Account_Rtype];    
                    } 
                    acc= AccountShareList(accWithoutShare);        //<Alvin20150608> Added for account share         
                    if(acc.size()==1){
                        singleAccount=true; 
                        redirectAccountDirectly =true;
                        IsAccountSearch=false;
                        currentSelectionAccountId =acc[0].Id;       
                    }
                    else{
                        singleAccount=false;
                    }
                }
                else if(!currentSelectionCustomerAccountGroup.contains('Z001') && CustomerWrapperList2.size() > 1){
                    IsListRender2=true;
                }

                else if(!currentSelectionCustomerAccountGroup.contains('Z001') && CustomerWrapperList2.size() == 0){

                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No Sold-To customer available for selected');
                    ApexPages.addMessage(msg);
                    IsListRender2=false;
                    IsAccountSearch =false;
                }
            }
        }
        else if(search == 'Extend a Customer' && ec.recordTypeId == ERP_Customer_General_Rtype && identifyCST== 'CST Customer' ){
            IsProceedAvailble =true;
            IsAccountSearch = false;
        }
        else if(search == 'Extend a Customer' && ec.recordTypeId == ERP_Customer_Extended_Rtype && identifyCST== 'CST Customer' ){
            isExtendNewSearch=true;
            IsAccountSearch = false;
        }
        else if(search == 'Extend a Customer' && ec.recordTypeId == ERP_Customer_General_Rtype && identifyCST=='Non CST Customer' ){
            IsListRender3=false;
            IsExtendedSearch=false;
            isExtendNewSearch=false;

        }
        else if(search == 'Extend a Customer' && ec.recordTypeId == ERP_Customer_Extended_Rtype  && identifyCST=='Non CST Customer'){
            Integer RelatedAccount_total_size ;

            accWithoutShare=[Select Id,Name,VAT_Number__c,Region__c,Owning_Organization__c,Country__c,ERP_Customer__r.Name,Type,Company_Code__c,RecordTypeId,OwnerId,SBU__c,External_Account_ID__c from Account where ERP_Customer__c=:currentSelectionCustomerId  AND recordTypeId !=:CST_Account_Rtype];
            acc= AccountShareList(accWithoutShare); //<Alvin20150608> Added for account share 
            RelatedAccount_total_size = acc.size();

            if(RelatedAccount_total_size ==1){
                currentSelectionAccountId =acc[0].Id;  
                IsCustomerRelatedAccountListRender=false;
                IsAccountSearch=false;
                isExtendNewSearch=true;
                IsExtendedSearch=true;
            }
        }

    }


    /**
     * Name: ClearCustomerList2
     * Params: None
     * Description: To uncheck a customer when another one is checked in second table. 
     */
    public void ClearCustomerList2(){
        AccountWrapperList = new  List<AccountWrapperClass>();
        CustomerRelatedAccountWrapperList = new  List<AccountWrapperClass>();
        IsCustomerRelatedAccountListRender = false;
        IsGenericAccountListRender= false;
        IsAccountSearch = true;
        IsProceedAvailble = false;
        IsNewAccountOptionAvailble=false;
        if(IsListRender2==true){
            for(CustomerWrapperClass w:CustomerWrapperList2){
                if(currentSelectionCustomerId2!=w.Id){
                    w.isChecked=false;
                }
            }
        }
        if(IsListRender3==true){

            for(CustomerWrapperClass w:CustomerWrapperList3){

                if(currentSelectionCustomerId3 !=w.Id){
                    w.isChecked=false;
                }
            }
        }
    }


    /**
     * Name: redirectLink
     * Params: None
     * Description: To redirect to recordtype selection page and passing required parameters. 
     */
    Public PageReference redirectLink(){
        
        if(currentSelectionAccountId!=null){

            PageReference pageRef = new PageReference('/apex/COBDataReqNewEdit');

            if(currentSelectionAccountId!=null){
                pageRef.getParameters().put('Account',  + currentSelectionAccountId);

            }
            else{
                pageRef.getParameters().put('Account', + 'null');

            }
            if(isAccountLink == true){
                pageRef.getParameters().put('AccountLink', accountLinkId);
            }
            else{
                pageRef.getParameters().put('AccountLink', 'null');
            }

            if(search=='Modify Search'){
                pageRef.getParameters().put('Search', 'Modify');
                if(identifyCST=='CST Customer')
                    pageRef.getParameters().put('Case', cdr.Case_Number__c);  
                else pageRef.getParameters().put('Case', 'null');



                pageRef.getParameters().put('ERPCustomer', + currentSelectionCustomerId);




            }

            else if(search=='Extend a Customer' && IsListRender3==true){
                pageRef.getParameters().put('Search', 'Extend');
                pageRef.getParameters().put('ERPCustomer', + currentSelectionCustomerId3);
            }
            else if(search=='Extend a Customer' && IsListRender3==false){
                pageRef.getParameters().put('Search', 'Extend');
                pageRef.getParameters().put('ERPCustomer', + currentSelectionCustomerId);
            }
            else if(search == 'Duplicate Search' && identifyCST=='CST Customer'){
                pageRef.getParameters().put('ERPCustomer', 'null');
                pageRef.getParameters().put('Search', 'Duplicate');
                pageRef.getParameters().put('Case', cdr.Case_Number__c);                    
            }  
            else if(search == 'Duplicate Search' && identifyCST=='Non CST Customer'){
                pageRef.getParameters().put('ERPCustomer', 'null');
                pageRef.getParameters().put('Search', 'Duplicate');
                pageRef.getParameters().put('Case', 'null');                    
            }               


            String custId=pageRef.getParameters().get('ERPCustomer');

            return pageRef;


        }
        else if(search == 'Duplicate Search' && identifyCST=='CST Customer' && currentSelectionAccountId==null){
            PageReference pageRef = new PageReference('/apex/COBDataReqNewEdit');
            if(isAccountLink == true){
                pageRef.getParameters().put('AccountLink', accountLinkId);
            }
            else{
                pageRef.getParameters().put('AccountLink', 'null');
            }
            pageRef.getParameters().put('ERPCustomer', 'null');
            pageRef.getParameters().put('Account', 'null');
            pageRef.getParameters().put('Search', 'Duplicate');
            pageRef.getParameters().put('Case', cdr.Case_Number__c);
            return pageRef;
        }
        else if(search=='Extend a Customer' && identifyCST=='CST Customer' &&  currentSelectionAccountId==null){
            PageReference pageRef = new PageReference('/apex/COBDataReqNewEdit');
            if(IsListRender3==true)
                pageRef.getParameters().put('ERPCustomer', currentSelectionCustomerId3);
            else
                pageRef.getParameters().put('ERPCustomer', currentSelectionCustomerId);
            if(isAccountLink == true){
                pageRef.getParameters().put('AccountLink', accountLinkId);
            }
            else{
                pageRef.getParameters().put('AccountLink', 'null');
            }
            pageRef.getParameters().put('Account', 'null');
            pageRef.getParameters().put('Search', 'Extend');
            pageRef.getParameters().put('Case', cdr.Case_Number__c);
            return pageRef;
        } 
        else{

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Error_Select_Account));
            return null;
        }
    }


    /**
     * Name: redirectLink
     * Params: None
     * Description: To redirect to recordtype selection page and passing required parameters. 
     */    

    public PageReference Previous() { //user clicked previous button   
        isCustomerSearchExecute=false;
        isCustomerExtendedSearchExecute=false;
        if(TypeOfTable == 'Customer'){
            customertablecounter -= Customer_list_size; 
            findMatchCustomers();
        }
        else if(TypeOfTable == 'GenericAccount'){
            GenericAccounttablecounter-= GenericAccount_list_size; 
            GenericAccountSearch();
        }
        else if(TypeOfTable == 'RelatedAccount'){
            RelatedAccountcounter-= RelatedAccount_list_size; 
            AccountSearch();
        }
        else if(TypeOfTable == 'CustomerExtendSearch'){
            customertablecounter3-= Customer_list_size; 
            populateCustomer();
        }
        return null;
    } 



    public PageReference Next() { //user clicked next button
        isCustomerSearchExecute=false;
        isCustomerExtendedSearchExecute=false;
        if(TypeOfTable == 'Customer'){
            customertablecounter += Customer_list_size;
            findMatchCustomers();
        }
        else if(TypeOfTable == 'GenericAccount'){
            GenericAccounttablecounter+= GenericAccount_list_size; 
            GenericAccountSearch();
        }
        else if(TypeOfTable == 'RelatedAccount'){
            RelatedAccountcounter+= RelatedAccount_list_size; 
            AccountSearch();
        }
        else if(TypeOfTable == 'CustomerExtendSearch'){

            customertablecounter3+= Customer_list_size; 
            populateCustomer();
        }
        return null;
    }

    public PageReference end() { //user clicked end  
        isCustomerSearchExecute=false;
        if(TypeOfTable == 'Customer'){  
            customertablecounter = Customer_total_size - math.mod(Customer_total_size, Customer_list_size); 
        }
        else if(TypeOfTable == 'GenericAccount'){
            GenericAccounttablecounter = GenericAccount_list_size- math.mod(GenericAccount_total_size, GenericAccount_list_size); 
        } 
        else if(TypeOfTable == 'RelatedAccount'){
            RelatedAccountcounter = RelatedAccount_list_size- math.mod(RelatedAccount_total_size, RelatedAccount_list_size); 
        }   
        else if(TypeOfTable == 'CustomerExtendSearch'){
            customertablecounter3 = Customer_total_size3- math.mod(Customer_total_size3, Customer_list_size); 
        }
        return null;    
    }    

    public Boolean getDisablePrevious() {        //this will disable the previous and beginning buttons     
        if (customertablecounter>0) 
            return false; 
        else return true;  
    }   

    public Boolean getDisableNext() {             //this will disable the next and end buttons    
        if (customertablecounter + Customer_list_size < Customer_total_size) 
            return false;
        else return true;  
    }      

    public Boolean getDisableCustExtendPrevious() {        //this will disable the previous and beginning buttons     
        if (customertablecounter3>0) 
            return false; 
        else return true;  
    }   

    public Boolean getDisableCustExtendNext() {         //this will disable the next and end buttons    
        if (customertablecounter3 + Customer_list_size < Customer_total_size3) 
            return false;
        else return true;  
    }  

    public Integer getCustomer_total_size() {          // this will return total customer size
        return Customer_total_size;    
    }   
    public Integer getCustomer_total_size3() {          // this will return total customer size for second search
        return Customer_total_size3;    
    } 

    public Integer getPageNumber() {                      // will return the current page number
        return customertablecounter/Customer_list_size + 1;    
    }    
    public Integer getPageNumberExtend() {                 // will return the current page number for extended search
        return customertablecounter3/Customer_list_size + 1;    
    }
    public Integer getTotalPages() {                        // will return total pages in table
        if (math.mod(Customer_total_size, Customer_list_size) > 0) {          
            return Customer_total_size/Customer_list_size + 1;       
        }
        else {          
            return (Customer_total_size/Customer_list_size);       
        } 
    }
    public Integer getTotalPagesExtend() {                  // will return total pages in table in extended search
        if (math.mod(Customer_total_size3, Customer_list_size) > 0) {          
            return Customer_total_size3/Customer_list_size + 1;       
        }
        else {          
            return (Customer_total_size3/Customer_list_size);       
        } 
    }

    public Boolean getDisableGenericAccountPrevious() {        //this will disable the previous and beginning buttons for the Generic Account table     
        if (GenericAccounttablecounter>0) 
            return false; 
        else return true;  
    }   

    public Boolean getDisableGenericAccountNext() {             //this will disable the next and end buttons for the Generic Account table  
        if (GenericAccounttablecounter + GenericAccount_list_size < GenericAccount_total_size) 
            return false;
        else return true;  
    } 

    public Boolean getDisableRelatedAccountPrevious() {        //this will disable the previous and beginning buttons for the Related Account table     
        if (RelatedAccountcounter>0) 
            return false; 
        else return true;  
    }   

    public Boolean getDisableRelatedAccountNext() {             //this will disable the next and end buttons  for the Related Account table      
        if (RelatedAccountcounter + RelatedAccount_list_size < RelatedAccount_total_size) 
            return false;
        else return true;  
    }  

    public Integer getRelatedAccount_total_size() {              // this will return the total size of related accounts
        return RelatedAccount_total_size;    
    } 

    public Integer getGenericAccount_total_size() {              // this will return the total size of generic accounts
        return GenericAccount_total_size;    
    }   

    public Integer getGenericAccountPageNumber() {                // this will return the current generic account page number.
        return GenericAccounttablecounter/GenericAccount_list_size + 1;    
    }  

    public Integer getRelatedAccountPageNumber() {                 // this will return the current related account page number.
        return RelatedAccountcounter/RelatedAccount_list_size+ 1;    
    }     

    public Integer getGenericAccountTotalPages() {                   // this will return the total number of pages in generic account table
        if (math.mod(GenericAccount_total_size, GenericAccount_list_size) > 0) {          
            return GenericAccount_total_size/GenericAccount_list_size+ 1;       
        }
        else {          
            return (GenericAccount_total_size/GenericAccount_list_size);       
        } 
    }  

    public Integer getRelatedAccountTotalPages() {                    // this will return the total number of pages in related account table
        if (math.mod(RelatedAccount_total_size, RelatedAccount_list_size) > 0) {          
            return RelatedAccount_total_size/RelatedAccount_list_size+ 1;       
        }
        else {          
            return (RelatedAccount_total_size/RelatedAccount_list_size);       
        } 
    } 
    
     


    /**
     * Name: onChangeSearch
     * Params: None
     * Description: To initialize everything when the search is changed.  
     */ 
    Public void onChangeSearch(){
        CustName1 = '';
        VAT1 = '';
        taxCode1 = '';
        Country1 = '';
        CustCode1='';
        AccountGrp1='None';
        PostalCode1='';
        RegNo1='';

        CustName2 = '';
        VAT2 = '';
        taxCode2 = '';
        Country2 = '';
        CustCode2='';
        AccountGrp2='';
        PostalCode2='';
        RegNo2='';

        CustName3 = '';
        VAT3 = '';
        taxCode3 = '';
        CustCode3='';
        PostalCode3='';
        RegNo3='';
        IsSearchCustomersAvailable  = false;
        IslistRender = false;
        IslistRender2 = false;
        IslistRender3 = false;
        IsCustomerRelatedAccountListRender = false;
        IsGenericAccountListRender= false;
        IsProceedAvailble= false;
        IsNewAccountOptionAvailble = false;
        IsCriteriaAvailable=false;
        IsAccountSearch = false;
        IsExtendedSearch =false;
        isExtendNewSearch=false;
        localLanguage='--None--';
        identifyCST=null;
        cdr.Case_Number__c=null;
        CustName='';
        if(search!=null && search  == 'Miscellaneous request'){
           isMiscellaneousSearch=true;
        }else{
            isMiscellaneousSearch=false;            
        }
    }
    /**
     * Name: AccountShareList
     * Params: String,String
     * Description: To get accounts user have access to.  
     */
    //<Alvin20150608> Added to get account using accountshare
    public List<Account> AccountShareList(List<Account> accList){
        List<Id> accIds = new List<Id>();
        List<UserRecordAccess> accountShareId = new List<UserRecordAccess>();
        List<Account> accountList = new List<Account>();
        Set<Account> accListSet = new Set<Account>();
        //List<string> accShareList = new List<string>();//<Alvin20150708> commented as not needed
        if(currentUserProfile() == 'System Administrator'){ //<Alvin20150619>Added so that system admin can see all accounts
            return accList;
        }
        for(Account acc : accList){
            accIds.add(Id.valueof(acc.Id));
        }
        //<Alvin20150708> commented as not needed
      /*  accShareList.add(UserInfo.getUserId());
        for(GroupMember gr : [SELECT GroupId,UserOrGroupId from GroupMember where UserOrGroupId =: UserInfo.getUserId()]){
            accShareList.add(string.valueof(gr.GroupId));
        }
        */
        system.debug('Accountsbeforeshare='+accIds);
        system.debug('Accountsizebeforeshare='+accIds.size());
        accountShareClass accshareClass = new accountShareClass();
        accountList=accshareClass.sharedAccount(accIds);
        return accountList;
    }  
    
     /**
     * Name: accountShareClass
     * Params: 
     * Description: To get accounts user have access to.  
     */
    //<Alvin20150708> Added to get account using accountshare
    public with sharing class accountShareClass{
        public List<account> sharedAccount(List<Id> accIds){
            List<Account> accountList = new List<Account>();
            Set<Account> accListSet = new Set<Account>();
            system.debug('Accountsbeforeshare='+accIds);
            system.debug('Accountsizebeforeshare='+accIds.size());
            accountList = [Select Id,Name,UserRecordAccess.HasReadAccess,VAT_Number__c,Region__c,Country__c,External_Account_ID__c,ERP_Customer__r.Name,Owning_Organization__c,Type,Company_Code__c,Shipping_Tax_Code_1__c,Shipping_Tax_Code_3__c,Billing_Tax_Code_1__c,Billing_Tax_Code_3__c,RecordTypeId,OwnerId,SBU__c,Product__c from Account where id in : accIds];
            system.debug('Accountsaftershare='+accountList);
            system.debug('Accountsizeaftershare='+accountList.size());
            for(Account acc1 : accountList){
                system.debug('CurrentAccountsaftershare='+acc1);
                system.debug('CurrentAccountAccessaftershare='+acc1.UserRecordAccess.HasReadAccess);
                if(acc1.UserRecordAccess.HasReadAccess == true){
                    system.debug('CurrentAccountsaftershare='+acc1);                    
                    accListSet.add(acc1);
                }
            }
            system.debug('AccountSetaftershare='+accListSet);
            system.debug('AccountSetsizeaftershare='+accListSet.size());
            accountList = new List<Account>();
            for(Account acc2  : accListSet){
                accountList.add(acc2);
            }
            system.debug('AccountsListaftershare='+accountList);
            system.debug('AccountListsizeaftershare='+accountList.size());
            return accountList;
        }
        
    }
    /**
     * Name: CheckCustomerAccess
     * Params: String,String
     * Description: To check if user has access to customer selected.  
     */
    Public boolean CheckCustomerAccess(String custRecID, String Custname){
        if(custRecID != null && custRecID !='' && custRecID != 'null'){
            List<UserRecordAccess > custShareList = new List<UserRecordAccess >();

            Id custId = Id.valueOf(custRecID);
            custShareList =[SELECT RecordId FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: custId  AND HasReadAccess =: true];
            if(custShareList.size()==0){

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to Customer '+Custname+' selected. Please contact your administrator'));
                return false;
            }
            else return true;
        }
        return true;
    }



    /**
     * Name: openDownloadPopUpFlag
     * Params: None
     * Description: Method to check user access and to call redirect method.
     */
    public PageReference openDownloadPopUpFlag() {        
        AccountList = new List<Account>();
        List<ERP_Customer__c> erp = new List<ERP_Customer__c>();

        if(currentSelectionAccountId==null && !(search == 'Duplicate Search' && identifyCST=='CST Customer') && !(search == 'Extend a Customer' && identifyCST=='CST Customer' )){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Error_Select_Account));
            return null;
        }
        if(currentSelectionCustomerId!=null && currentSelectionCustomerId!='' && CheckCustomerAccess(currentSelectionCustomerId,currentSelectionCustomerName )==false){
            return null;
        }
        if(currentSelectionCustomerId2!=null && currentSelectionCustomerId2!='' && CheckCustomerAccess(currentSelectionCustomerId2,currentSelectionCustomerName2)==false){
            return null;
        }
        if(currentSelectionCustomerId3!=null && currentSelectionCustomerId3!='' && CheckCustomerAccess(currentSelectionCustomerId3,currentSelectionCustomerName3)==false){
            return null;
        }
        if(search == 'Duplicate Search' && identifyCST=='CST Customer' && currentSelectionAccountId==null){
            return redirectlink();
        }
        else if(currentSelectionAccountId!=null){
            AccountList = [Select Id, Name, ERP_Customer__c,Owning_Organization__c,SBU__c,ERP_Customer__r.Name, recordtypeId from Account where Id=:currentSelectionAccountId ];

            erp=[select id, name, recordtypeId, Account_Group__c from ERP_Customer__c where id=: currentSelectionCustomerId];
            if(search == 'Modify Search' &&  identifyCST=='Non CST Customer' && redirectAccountDirectly == true){
                return redirectlink();
            }
            else if(currentSelectionCustomerId!=null && erp[0].recordtypeId== ERP_Customer_Extended_Rtype && erp[0].Account_Group__c.contains('Z001')){

                if(AccountList.get(0).ERP_Customer__c==null){

                    isAccountLink = true;
                    accountLinkId =  currentSelectionCustomerId;
                    return  redirectlink();

                }

                return redirectlink();
            }
            else if(currentSelectionCustomerId2!=null){

                erp=[select id, name, recordtypeId, Account_Group__c from ERP_Customer__c where id=: currentSelectionCustomerId2];

                if(AccountList.get(0).ERP_Customer__c==null && erp[0].recordtypeId== ERP_Customer_Extended_Rtype && erp[0].Account_Group__c.contains('Z001') ){

                    isAccountLink = true;
                    accountLinkId =  currentSelectionCustomerId2;
                    return  redirectlink();

                }
            } 
            else{
                return redirectlink();
            }          

        }


        return redirectlink();

    }




    /**
     * Name: CustomerWrapperClass
     * Params: None
     * Description: Wrapper class for Customer 
     */



    public class CustomerWrapperClass{        
        Public Id Id{get;set;}
        Public String Name{get;set;}
        Public String LocalName{get;set;} //<Alvin20150608>
        Public String VATNumber{get;set;}
        Public String TaxCode{get;set;}  
        Public String AccountGroup{get;set;}
        Public String CustomerCode{get;set;} 
        Public String SalesOrgCode{get;set;}
        Public String CustomerStatus{get;set;}    
        Public Boolean isChecked{get;set;}
        Public String City{get;set;}
        Public String State{get;set;}
        Public String Country{get;set;}
        Public String Street{get;set;}
        Public String PCode{get;set;}
        Public String erpCluster{get;set;}
        Public String companyCode{get;set;}
        Public String distributionChannel{get;set;}
        Public String erpDivision{get;set;}
        public boolean ifSoldToCust{get;set;}
        Public String ExternalAccountID{get;set;}

        Public CustomerWrapperClass(Id d,String n, String ln, String VATnm,String TCode,String AGRoup,String Ccode,String SOrg,Boolean s,String ci,String st,String co,String PoCode,String Str,String Clust,String CompCode,String DistChannel, String Div,Boolean IfSoldToCust,String custStatus, String ExtAccID){
            this.Id=d;
            this.erpCluster=Clust;
            this.Name=n;
            this.LocalName = ln;//<Alvin20150608>
            this.companyCode=CompCode;
            this.distributionChannel=DistChannel;
            this.erpDivision=Div;
            this.VATNumber=VATnm;
            this.TaxCode=TCode;
            this.AccountGroup=AGRoup;
            this.CustomerCode=Ccode;
            this.SalesOrgCode=SOrg;
            this.CustomerStatus=custStatus;            
            this.isChecked=s;
            this.Street=Str;
            this.PCode=PoCode;
            this.City=ci;
            this.State=st;
            this.Country=co;
            this.ifSoldToCust = ifSoldToCust;
            this.ExternalAccountID = ExtAccID;
        }
    }

    /**
     * Name: CustomerWrapperClass
     * Params: None
     * Description: Wrapper class for Accounts
     */

    public class AccountWrapperClass{        
        Public Id Id{get;set;}
        Public String Name{get;set;}
        Public String VATNumber{get;set;}
        Public String GeoRegion{get;set;}
        Public String owningOrganization{get;set;}
        Public String accountSBU{get;set;}
        Public String recType{get;set;}
        Public String Country{get;set;}  
        Public String ERPCompanyCode{get;set;}
        Public String Type{get;set;}   
        Public Boolean isChecked{get;set;}
        Public String ERPCustName{get;set;} 
        Public String ExternalAccountID{get;set;} 
        public String RecordTypeName{get;set;}
        public String AccountOwnerName{get;set;}
        public String AccOwnerName{get;set;}


        Public AccountWrapperClass(Id d,String n,String VATnm,String geoReg,String Contry,String ERPCode,String Typ,Boolean s,String ERPCName,String owningOrg,Id rctype, Id accOwner, String accSBU,String ExtAccID){
            RecordTypeName = [Select Name from RecordType where Id=:rctype].Name;
            AccountOwnerName=[Select Name from User where Id=:accOwner].Name;

            this.Id=d;
            this.Name=n;
            this.VATNumber=VATnm;
            this.GeoRegion=geoReg;
            this.Country=Contry;
            this.accountSBU=accSBU;
            this.ERPCompanyCode=ERPCode;
            this.owningOrganization=owningOrg;
            this.AccOwnerName=AccountOwnerName;
            this.recType=RecordTypeName;
            this.Type=Typ;
            this.isChecked=s;
            this.ERPCustName=ERPCName;
            this.ExternalAccountID=ExtAccID;

        }
    }
}
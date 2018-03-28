/*******************************************************************************
    Copyright © 2015 DuPont. All rights reserved. 
    Author: Nishant Chopra, Alvin Johnson
    Email: nishant_chopra01@infosys.com, alvin_johnson@infosys.com
    Description:  Controller for page: COBNewCustomerCreation,COBModifyExistingCustomer,COBExtendExistingCustomer, COBPartnerLink,COBMiscellaneousRequest
    Change History : Alvin Johnson (alvin_johnson@infosys.com) Added code for R02 Enhancement  
                     <Alvin 20150903>
                     <Alvin 20150824> 
                    :<Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')
                    : <Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules 
                    : <Alvin20151001> Added for making Estimated Average Monthly Purchases and Estimated Number of Orders per Month mandatory, req 32
                    : <Nishant20151012> Adding Local Version Functionality for Extend Existing as part of R02 Enhancement
                    : <Tarun20151001> Enhancement Duplicate Check during exteding customer
                    : <Santhosh 20151127> Added validation for new field tax number 5  for china.
                    : <Santhosh 20160419> modified condition for Tax code1 validation for Thailand requests(IS ID-00067840)
                    : <Gerard20160524> changed the error description
                    : <Santhosh20160613> Added condition to bypass validation when the request is sent for rework
                    : <BA15062016> Added Iscreditapproved condition to skip the credit if it is previously approved
                    : <Santhosh 20160706> Added new country checks (IS ID-00070867)
                    : <Bhargavi20160714> Validation to Restrict the digits when exceeds the  limit as Part of issue IS ID-00070646
                    : <Ankit20160719 01:14 AM IST> changed typecasting of Telex number from "String to Integer" to "String to Long" as a part of issue IS ID-00071801
                    : <Bhargavi 20160919> Added new country Check (IS ID-00072470)
                    : <Bhargavi 20161110> Bypasses Destination Credit Approval for all the countries (IS ID-00076243)
 ********************************************************************************/ 

public class ctrlCOBCustomerDataRequest {

    public static final string Miscellaneous_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request'); 
    public static final string Partner_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
    public static final string NewCustomerCreation_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation'); 
    public static final string ExtendExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Extend_Existing_Customer'); 
    public static final string ModifyExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');     
    public static final string CST_Case_Number_CS_InternalRequest_Rtype = Rtype.getIdByDevName('Case','CS_InternalRequest');
    public static final string CST_Case_Number_CS_Order_Rtype = Rtype.getIdByDevName('Case','CS_Order');
    public static final string CST_Case_Number_CS_ServiceRequest_Rtype = Rtype.getIdByDevName('Case','CS_ServiceRequest');
    public static final string Notification_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Notification_Rules');
    //public static final string SBU_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','SBU_Rules');//<Alvin 20150903> commented as part of Le1310 enhancement to fetch company code and SBU based on Sales Org Code
    //public static final string SellingCompanyCode_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Selling_Company_Code_Rules');//<Alvin 20150903> commented as part of Le1310 enhancement to fetch company code and SBU based on Sales Org Code
    public static final string CompanyCodeSBU_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Sales_Org_Code_Rules'); //<Alvin 20150903> added as part of Le1310 enhancement to fetch company code and SBU based on Sales Org Code
    public static final string CompanyCodeCountry_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Country_Selling_Company_Code_Rules'); //<Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules 
    public Map<String,ID> queueMap; 
    public List<SelectOption> RegionOptions{get;set;}
    public List<SelectOption> LocalRegionOptions{get;set;}
    public String ProfileName{get;set;} 
    public Boolean PageAccess {get;set;}
    public Customer_Data_Request__c OnboardingReq{get;set;}
    public Boolean displayMainPage{get;set;}
    public Id ReqId;
    public string radioSelected{get; set;}
    public Boolean IsClone=false;
    public Boolean openLocalLanguagePanel{get;set;}
    public Boolean openOtherGroupKey{get;set;}
    public Boolean openPODtimeframe {get;set;}
    public Boolean showErrorPage{get;set;}
    public Boolean showNewCustomerErrorPage{get;set;}
    public Static Id CurrentUserId{get;set;}
    public String RecordTypeName{get;set;}
    public String IsSaveOrSubmit{get;set;}
    public string CDRCountry{get;set;}  //<Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules

    public Boolean isEdit{get;set;}
    public string accountid{get;set;}
    public boolean RecordLocked{get;set;}
    public Boolean IsError=false;
    public boolean showEditErrorPage{get;set;}
    public boolean showAccountErrorPage{get;set;}
    public transient static map<Id,String> mapGrpIdNGrpName = new map<Id,String>();
    public transient static map<id,set<String>> mapUserIdNGrpName = new map<id,set<String>>();
    Map <String,String> currentURLParameters = new Map<String,String>();
    public set<String> lst_GrpName;
    public Boolean Ishide{get;set;}
    public Boolean IsLeverageCSRRender{get;set;}    
    public String responseXML;
    public SelectOption[] selectedNotifyUsers{get;set;}

    public SelectOption[] selectedUsers {get;set;}
    public List<Case> caseCheck{get; set;}
    public List<SelectOption> GroupKeyOptions {get; set;}
    public string SBUCode{get; set;}
    public string SubBusinessCode{get; set;}
    public string MiscIntent{get; set;}
    public boolean flagIntent{get; set;}
    public List<SelectOption> ProposedCredOptions {get; set;}
    public List<SelectOption> SBUOptions {get; set;}
    public List<SelectOption> SellingCompanyOptions {get; set;}
    public List<SelectOption> propCreLimCurCode{get;set;}
    public List<SelectOption> TaxCategoryOptions {get; set;}
    public List<SelectOption> SalesOrgOptions{get; set;}
    public List<SelectOption> SubBusinessOptions{get; set;}
    public String sellingCompanyCode {get; set;} 
    public boolean flagPropNonPayTerm{get;set;}
    public boolean flagProRiskCat{get;set;}
    public boolean leveragechkFlag{get;set;}
    public Boolean isRequiredSoldtoOffice{get;set;}
    public Boolean isRequireddataline{get;set;}
    public Boolean isRequiredteletex{get;set;}
    public Boolean isRequiredtelebox{get;set;}
    public Boolean isProposedLimitCurrency{get;set;}
    public boolean isCreditValidation{get; set;}
    Account requestorAccount = new Account();
    public map<string,string> fieldmodifiedmap = new map<string,string>();
    public List<string> usernamelist = new List<string>();
    public list<User> userlist = new list<User>();
    list<string> emailchk = new list<string>();
    public map<String , Decimal> MapCreditTermNLimit = new map<String , Decimal>();
    
    public list<User> userlistnew = new list<User>();
    public list<CDR_Notification__c> DupontMarketingUsers = new list<CDR_Notification__c>();
    public list<CDR_Notification__c> DupontMarketingUsersUnselected = new list<CDR_Notification__c>();
    public List<SelectOption> NotifyUsers{get; set;}
    
    // Start of BA15062016 to make credit fileds read only if it already approved
    public String mode{get; set;}  

    
    public void modeSet()
    {

       if(OnboardingReq.IsCreditApproved__c==false)
       {
           mode='edit';

        }
        else
        {
           mode='readOnly';
        }

    }
    //End of BA15062016
    
    public List<SelectOption> gettaxValues() {
        List<selectOption> options = new List<selectOption>();
        system.debug('CDRCountry value ='+CDRCountry);
        options.add(new selectOption('','--None--'));
      
      if(CDRCountry == 'TH - Thailand'){ //<Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
            options.add(new selectOption('R - TH- Exempt Domest.Cust.','R -TH- Exempt Domest.Cust.'));
            options.add(new selectOption('S - TH- Sample Order','S - TH- Sample Order'));
            options.add(new selectOption('T - TH- Taxable Customer','T - TH- Taxable Customer'));
            options.add(new selectOption('U - TH- Exempt Export Cust.','U - TH- Exempt Export Cust.'));
            options.add(new selectOption('V - TH- Cust.w/Bonded Wa/Hse','V - TH- Cust.w/Bonded Wa/Hse'));
            options.add(new selectOption('W - TH- Ex-Wharf Domestic','W - TH- Ex-Wharf Domestic'));
            options.add(new selectOption('X - TH- 0 Rate - Intra Group','X - TH- 0 Rate - Intra Group'));
            /*options.add(new selectOption('Thailand-ZTH1-R(0- No Tax)','Thailand-ZTH1-R(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-S(0- No Tax)','Thailand-ZTH1-S(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-T(0- No Tax)','Thailand-ZTH1-T(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-U(0- No Tax)','Thailand-ZTH1-U(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-V(0- No Tax)','Thailand-ZTH1-V(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-W(0- No Tax)','Thailand-ZTH1-W(0- No Tax))'));
                options.add(new selectOption('Thailand-ZTH1-X(0- No Tax)','Thailand-ZTH1-X(0- No Tax))'));*/
        }   
        // <Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')
        // <Alvin20150929> commented below line and added new line for R02 enhancement to replace selling company codes with business Rules
        // else if (CDRCountry == '0078 - ELECT. MATLS DUP DONGGUAN' || sellingCompanyCode == '0218 - DuPont Trading Shanghai' || sellingCompanyCode == '0701 - DUP AGRIC CHEM LTD' || sellingCompanyCode == '1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.' || sellingCompanyCode == '1132 - DuPont(China) RD and Mgmt' || sellingCompanyCode == '1142 - DUP SURFCE GUANGZHOU'  || sellingCompanyCode == '1210 - DUP (SHENZHEN) INDUS' || sellingCompanyCode == '2791 - Du Pont China Holding Co.' || sellingCompanyCode == '1310 - DuPont Apollo (Shenzhen)' ){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
        else if (CDRCountry == 'CN - China'){
            options.add(new selectOption('China(CNY)- ZA01=1 & ZCC1=1','China(CNY)- ZA01=1 & ZCC1=1'));
            options.add(new selectOption('China(USD-DPP)- ZA01=1 & ZCC1=2','China(USD-DPP)- ZA01=1 & ZCC1=2'));
            options.add(new selectOption('China(USD-Others)- ZA01=1 & ZCC1=0','China(USD-Others)- ZA01=1 & ZCC1=0'));
        }
        else if (CDRCountry == 'HK - Hong Kong' ){ //<Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
            options.add(new selectOption('Hong Kong - ZA01=1 & ZCH1=1','Hong Kong - ZA01=1 & ZCH1=1'));
        }
        return options;
    }

    /**
     * Name: ctrlCustomerOnboardingRequest
     * Params: None
     * Description: Constructor of the class.  
     */


    public ctrlCOBCustomerDataRequest(){
        leveragechkFlag=false;
        openLocalLanguagePanel=false;
        openOtherGroupKey = false;
        openPODtimeframe = false;
        showEditErrorPage=false;
        showAccountErrorPage = false;
        flagProRiskCat=false;
        flagPropNonPayTerm=false;
        showErrorPage = false;
        isEdit= false;
        RecordLocked=false;
        Ishide=false;
        flagIntent=false;
        isRequireddataline=false;
        isRequiredteletex=false;
        isRequiredtelebox=false;
        isRequiredSoldtoOffice=false;
        isProposedLimitCurrency=false;
        isCreditValidation = false;
        displayMainPage = true;
        showNewCustomerErrorPage=false;
        CurrentUserId = userInfo.getUserId();
        ProfileName = currentUserProfile();
        ERP_Customer__c erp = new ERP_Customer__c();

        currentURLParameters  = ApexPages.currentPage().getParameters();
        selectedNotifyUsers = new List<SelectOption>();
        OnboardingReq = new Customer_Data_Request__c();
        mapGrpIdNGrpName = new map<Id,String>();
        mapUserIdNGrpName = new map<id,set<String>>();
        caseCheck = new List<Case>();
        accountid=currentURLParameters.get('Account');
        OnboardingReq.RecordTypeId = currentURLParameters.get('RecordTypeId');
        system.debug('currentURLParameters::'+currentURLParameters);
        fetchQueueMap();
        queryPublicGroup();
        fetchRecordTypeName();
        populateRequestorInformation();
        OnboardingReq.SF_Region__c ='Asia Pacific';
        
      
        //Fetch Account Details....
        if(currentURLParameters.get('Account') != 'null'){
            requestorAccount=fetchAccountDetails(currentURLParameters.get('Account'));
            if(requestorAccount !=null){
                onboardingReq.Account__c=requestorAccount.Id;
                if(currentURLParameters.get('AccountLink')!='null' && currentURLParameters.get('AccountLink')!='' && (requestorAccount.ERP_Customer__c == '' || requestorAccount.ERP_Customer__c == null))
                    requestorAccount.ERP_Customer__c = currentURLParameters.get('AccountLink');

                populateAccountInformation(requestorAccount.Id); // To populate the Account information
                sellingCompanyCode=OnboardingReq.Company_Code__c;
                SBUCode=OnboardingReq.SBU__c;
                fetchSellingCompanyDependents();
                fetchSBUDependents(); 

            }
        }
        OnboardingReq.Request_status__c= 'Draft/Data Gathering';
        OnboardingReq.Request_Initiator__c = 'CSR Initiated';
       

        if(currentURLParameters.get('ERPCustomer')!='null' && currentURLParameters.get('ERPCustomer')!='')
            OnboardingReq.Customer__c=ApexPages.currentPage().getParameters().get('ERPCustomer');

        else if ((currentURLParameters.get('ERPCustomer')=='null' || currentURLParameters.get('ERPCustomer') =='') && requestorAccount.ERP_Customer__c!= null)
            OnboardingReq.Customer__c = requestorAccount.ERP_Customer__c;
        //<Alvin20150619> for extending ship to/ bill to, Customer should be sold to
        if(currentURLParameters.get('Search') == 'Extend' && fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c != 'Z001 ( Sold-to party )')
            OnboardingReq.Customer__c = requestorAccount.ERP_Customer__c;

        FormRenderValidation();

        if(currentURLParameters.get('Case') != 'null' && currentURLParameters.get('Case') !=''){
            String CaseId=currentURLParameters.get('Case');
            system.debug('caseID::'+caseId);
            caseCheck = [select id, CaseNumber from Case where id=: CaseId and (recordTypeId=:CST_Case_Number_CS_InternalRequest_Rtype or recordTypeId =: CST_Case_Number_CS_Order_Rtype or recordTypeId =: CST_Case_Number_CS_ServiceRequest_Rtype)  limit 1];
            if(caseCheck.size()>0){
                OnboardingReq.Case_Number__c=CaseId;
            }
            system.debug('caseID::'+OnboardingReq.Case_Number__c);
            
        }

        // Description: To throw error for request without account
        if(currentURLParameters.get('Account') == 'null'  && currentURLParameters.get('Id')=='null' && (currentURLParameters.get('RecordTypeId')!= Miscellaneous_COB_RTYPE && !((currentURLParameters.get('RecordTypeId')== NewCustomerCreation_COB_RTYPE || currentURLParameters.get('RecordTypeId')== ExtendExisting_COB_RTYPE) && currentURLParameters.get('Case') != 'null' )) ){
            showAccountErrorPage = true;
            displayMainPage = false;
            showEditErrorPage = false;
            showErrorPage = false;
            showNewCustomerErrorPage=false;
        }

        //Description: To create CDR without account for new customer creation, extended and miscellaneous.
        if(currentURLParameters.get('Account') == 'null' && (currentURLParameters.get('RecordTypeId')== Miscellaneous_COB_RTYPE ||  ((currentURLParameters.get('RecordTypeId')== NewCustomerCreation_COB_RTYPE || currentURLParameters.get('RecordTypeId')== ExtendExisting_COB_RTYPE) && currentURLParameters.get('Case') != 'null' ) ) && currentURLParameters.get('Id')=='null'  )
        {
            displayMainPage = true;
            if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE ))&& OnboardingReq.Customer__c!=null){
                //<Alvin20150623> changed onboarding to string for extend scenario.
                if(currentURLParameters.get('Search') == 'Extend' && fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c != 'Z001 ( Sold-to party )')
                    responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(currentURLParameters.get('ERPCustomer'));
                else responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(OnboardingReq.Customer__c); 
                if(responseXML !=null && responseXML !='') parseWebserviceResponse(responseXML );
                populateExistingCustomerInformation();
            }

        }

        //Description: New CDR creation with Account
        if(currentURLParameters.get('Id')=='null' && currentURLParameters.get('Clone')=='null' && currentURLParameters.get('Account')!='null' ){
            displayMainPage = true;
            if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) &&(String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE ))&& OnboardingReq.Customer__c!=null){
                //<Alvin20150623> changed onboarding to string for extend scenario.
                if(currentURLParameters.get('Search') == 'Extend' && fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c != 'Z001 ( Sold-to party )')
                    responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(currentURLParameters.get('ERPCustomer'));
                else responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(OnboardingReq.Customer__c); 
                if(responseXML !=null && responseXML !='') parseWebserviceResponse(responseXML );  

            }
            populateExistingCustomerInformation();
            populateAccountInformation(requestorAccount.Id);

            IsClone = false;
            if(OnboardingReq.Account__c != null && (OnboardingReq.RecordTypeId== Miscellaneous_COB_RTYPE || OnboardingReq.RecordTypeId== Partner_COB_RTYPE )){
                if(requestorAccount !=null){
                    if(requestorAccount.ERP_Customer__c != null ){
                        ERP_Customer__c erpDetails = fetchCustomerInformation(requestorAccount.ERP_Customer__c);
                        if(erpDetails!= null && erpDetails.Country__c!=null && (erpDetails.Country__c.contains('China') || erpDetails.Country__c.contains('Hong Kong') ||erpDetails.Country__c.contains('Thailand'))){
                            leveragechkFlag=true;  }else{ leveragechkFlag=false;
                            }
                    } 
                }
            }
        }
        // Updation of Existing Request
        if(currentURLParameters.get('Id')!='null' && currentURLParameters.get('Clone')=='null' ){
            displayMainPage = true;
            showAccountErrorPage=false;
            ReqId = currentURLParameters.get('Id');
            IsClone = false;
            OnboardingReq = getRequestInformation(ReqId);
            if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) &&(String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE ))&& OnboardingReq.Customer__c!=null){
                //<Alvin20150623> changed onboarding to string for extend scenario.
                if(currentURLParameters.get('Search') == 'Extend' && fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c != 'Z001 ( Sold-to party )')
                    responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(currentURLParameters.get('ERPCustomer'));
                else responseXML = ctrlCOBWebServiceUtility.invokesfdcWebService(OnboardingReq.Customer__c); 
                if(responseXML !=null && responseXML !='') parseWebserviceResponse(responseXML );  

            }
            OnboardingReq = getRequestInformation(ReqId);  //to  populate the existing information of the Request
            accountid=OnboardingReq.account__c;
            isEdit= true;
            sellingCompanyCode=OnboardingReq.Company_Code__c;
            SBUCode=OnboardingReq.SBU__c;
            fetchSellingCompanyDependents();
            fetchSBUDependents(); 
            selectedNotifyUsers = selectedNotificationUsers();
            if(selectedNotifyUsers ==null)
                selectedNotifyUsers = new List<SelectOption>();
                if(OnboardingReq.Record_Locked__c==false){
                    if(onboardingReq.Account__c !=null && (OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE || OnboardingReq.RecordTypeId == Partner_COB_RTYPE || OnboardingReq.RecordTypeId == Miscellaneous_COB_RTYPE) && onboardingReq.Customer__c != null ){
                        populateAccountInformation(OnboardingReq.account__c);
                    }   
                    if((String.ValueOf(OnboardingReq.RecordTypeId) == NewCustomerCreation_COB_RTYPE) ){
                        RegionOptions= new List<SelectOption>();
                        if(OnboardingReq.Sold_to_State_Province__c != null && OnboardingReq.Sold_to_State_Province__c !='')
                            RegionOptions.add(new SelectOption(OnboardingReq.Sold_to_State_Province__c, OnboardingReq.Sold_to_State_Province__c));
                    }
                    checkOtherGroupKey();


                }else{
                    displayMainPage=false; showErrorPage=false; showNewCustomerErrorPage=false; showEditErrorPage=true; showAccountErrorPage = false;
                }
                if(OnboardingReq.Leveraged_CSR__c == true && OnboardingReq.Assigned_to_Leverage_CSR__c == true){
                    List<UserRecordAccess> custShareList = new List<UserRecordAccess>();
                    custShareList =[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :currentURLParameters.get('Id')];
                    if((custShareList.size()!=0 && custShareList.get(0).HasEditAccess == false)){
                        displayMainPage=false; showErrorPage=false; showNewCustomerErrorPage=false; showEditErrorPage=true; showAccountErrorPage = false;
                    } 
                }
                FormRenderValidation();

                if(OnboardingReq.Account__c != null && (OnboardingReq.RecordTypeId== Miscellaneous_COB_RTYPE || OnboardingReq.RecordTypeId== Partner_COB_RTYPE )){
                    if(requestorAccount !=null){
                        if(fetchAccountDetails(OnboardingReq.account__c).ERP_Customer__c != null ){
                            ERP_Customer__c erpDetails = fetchCustomerInformation(fetchAccountDetails(OnboardingReq.account__c).ERP_Customer__c);
                            if(erpDetails!= null && erpDetails.Country__c!=null && (erpDetails.Country__c.contains('China') || erpDetails.Country__c.contains('Hong Kong') ||erpDetails.Country__c.contains('Thailand'))){
                                leveragechkFlag=true;
                            }
                            else{
                                leveragechkFlag=false;
                            }
                        } 
                    }
                }
        }

        if(OnboardingReq.Request_Status__c == 'Request Completed in SAP' || OnboardingReq.Request_Status__c =='Request Sent for Re-Work'){ Ishide = true;
        }
        //For rendering Leverage CSR Checkbox For Extend customer RecordType 
        if(OnboardingReq.Sold_to_Country__c =='CN - China' || OnboardingReq.Sold_to_Country__c =='TW - Taiwan' || OnboardingReq.Sold_to_Country__c =='HK - Hong Kong'){ IsLeverageCSRRender=true;
        }


    }  

    /**
     * Name: selectedNotificationUsers
     * Params: List
     * Description: Selecting users for which notifications has to be sent.  
     */

    public List<SelectOption> selectedNotificationUsers(){
        List<SelectOption> Options = new List<SelectOption>();

        List<CDR_Notification__c> CDRNotificationList = [select id, User__c from CDR_Notification__c where Customer_Data_Request__c =: OnboardingReq.Id];
        if(CDRNotificationList.size() > 0){
            for(CDR_Notification__c cdr : CDRNotificationList){ usernamelist.add(cdr.User__c); 
            }
            userlistnew = [select id,name,email from User where Id in : usernamelist];
            if(userlistnew.size()>0){
                for(User u: userlistnew) { Options.add(new SelectOption(u.Id,u.name)); }
                return options;
            }  
        }
        return null;
    }



    public PageReference NotifyUsersAvailable() {
        selectedNotificationUsers();
        if(SubBusinessCode==null || SubBusinessCode =='')
            SubBusinessCode = OnboardingReq.Sub_Business__c;
        NotifyUsers = new List<SelectOption>();
        if(ApexPages.currentPage().getParameters().get('Id')=='null'){
            selectedNotifyUsers = new List<SelectOption>();
            if(sellingCompanyCode <> NULL && SubBusinessCode <> NULL){ 
                List<Business_Rules__c> businesslist = [SELECT id,name,Recepient_Name__c,Recepient_Name__r.Id,Selling_Company_Code__c,Sub_Business__c,Notification_Recepient_Name__c FROM Business_Rules__c where Selling_Company_Code__c = : sellingCompanyCode AND Sub_Business__c = : SubBusinessCode AND recordtypeId = : Notification_Rule_Rtype]; 
                for (Business_Rules__c br : businesslist) { 
                    if(br.Recepient_Name__c <> NULL && br.Notification_Recepient_Name__c <> NULL){
                        NotifyUsers.add(new SelectOption(br.Recepient_Name__r.Id,br.Notification_Recepient_Name__c));
                    }  
                }
                return null;
            }else{
                NotifyUsers.add(new SelectOption('None','None'));
                return null;
            }
        }else{
            list<string> userrecepientemaillist = new list<string>();

            for( User  us: userlistnew){
                userrecepientemaillist.add(us.Id);
            }

            if(sellingCompanyCode <> NULL && SubBusinessCode <> NULL){
                List<Business_Rules__c> businesslist = [SELECT id,name,Recepient_Name__c,Recepient_Name__r.Id,Selling_Company_Code__c,Sub_Business__c,Notification_Recepient_Name__c FROM Business_Rules__c where Selling_Company_Code__c = : sellingCompanyCode AND Sub_Business__c = : SubBusinessCode AND recordtypeId = : Notification_Rule_Rtype AND Recepient_Name__c NOT IN :userrecepientemaillist]; 
                for (Business_Rules__c br : businesslist) {
                    if(br.Recepient_Name__c <> NULL && br.Notification_Recepient_Name__c <> NULL){
                        NotifyUsers.add(new SelectOption(br.Recepient_Name__r.Id,br.Notification_Recepient_Name__c));
                    } 
                }

                return null; 
            }
        }
        return null;     
    }  

    /**
     * Name: fetchSellingCompanyDependents
     * Params: None
     * Description: Method to populate values of dependent Picklist based on Selling Company Code.
     */ 
    public void fetchSellingCompanyDependents(){


        ProposedCredOptions = new List<SelectOption>();
        SBUOptions = new List<SelectOption>();
        propCreLimCurCode= new list<SelectOption>();
        TaxCategoryOptions = new List<SelectOption>();
        if(sellingCompanyCode != null && sellingCompanyCode!=''){
            List<Selling_Company_Code_Dependency__c> sellingcompanydependentlist = new List<Selling_Company_Code_Dependency__c>();
            sellingcompanydependentlist = [SELECT SBU__c,Sales_Org_Code__c,Sub_Business__c, Proposed_Credit_Limit_Currency_Code__c, Proposed_Cred_rep_grp__c, Tax_Category__c, Selling_Company_Code__c FROM Selling_Company_Code_Dependency__c WHERE Selling_Company_Code__c = :sellingCompanyCode]   ;
            Set<string>SBUSet = new set<string>();
            ProposedCredOptions.clear();
            SBUOptions.clear();
            TaxCategoryOptions.clear(); 
            propCreLimCurCode.clear();
            if (sellingcompanydependentlist.size()>0){
                ProposedCredOptions.add(new SelectOption('','--None--'));
                SBUOptions.add(new SelectOption('','--None--'));
                TaxCategoryOptions.add(new SelectOption('','--None--'));
                propCreLimCurCode.add(new SelectOption('','--None--'));
                for (Selling_Company_Code_Dependency__c s : sellingcompanydependentlist ){
                    if (s.Proposed_Cred_rep_grp__c != Null && s.Proposed_Cred_rep_grp__c != ''){
                        ProposedCredOptions.add(new SelectOption(s.Proposed_Cred_rep_grp__c, s.Proposed_Cred_rep_grp__c));
                    }
                    if (s.Tax_Category__c != Null && s.Tax_Category__c != ''){
                        TaxCategoryOptions.add(new SelectOption(s.Tax_Category__c, s.Tax_Category__c));
                    }
                    if(s.Proposed_Credit_Limit_Currency_Code__c !=null && s.Proposed_Credit_Limit_Currency_Code__c !=''){
                        propCreLimCurCode.add(new SelectOption(s.Proposed_Credit_Limit_Currency_Code__c, s.Proposed_Credit_Limit_Currency_Code__c));
                    }
                    if(s.SBU__c !=null && s.SBU__c !='' && !(SBUSet.contains(s.SBU__c))){
                        SBUSet.add(s.SBU__c);
                        SBUOptions.add(new SelectOption(s.SBU__c, s.SBU__c));
                    }
                }  
                fetchSBUDependents();  
            }  
            //<Alvin20150929> Added for R02 enhancement to replace selling company codes with business Rules    
            List<Business_Rules__c> busCompanyRules = new List<Business_Rules__c>();
            busCompanyRules = [select id, CDR_Sold_to_Country__c from Business_Rules__c where recordTypeId = : CompanyCodeCountry_Rule_Rtype and Selling_Company_Code__c = : sellingCompanyCode];
          try{
            CDRCountry = busCompanyRules[0].CDR_Sold_to_Country__c; 
            }
             catch(exception e)
        {
        }      
            system.debug('CDRCountry value ='+CDRCountry);
            if(CDRCountry=='IN - India'){
                OnboardingReq.Tax_Classification__c = '';   
            }
            if(CDRCountry=='AU - Australia' || CDRCountry=='NZ - New Zealand' || CDRCountry=='SG - Singapore' || CDRCountry=='MY - Malaysia' || CDRCountry=='PH - Philippines' || CDRCountry=='VN - Vietnam'){  // <Bhargavi 20160919> added SG,MY,PH & VN conditions
                OnboardingReq.Tax_Classification__c = '';   
            }
            
            //<Alvin20150929> end
        }



    } 

    /**
     * Name: fetchSBUDependents
     * Params: None
     * Description: Method to populate values of SBU based on Selling Company Code.
     */     

    public void fetchSBUDependents(){
        if(SBUCode != null && SBUCode!=''){
            SalesOrgOptions=new List<SelectOption>();
            SubBusinessOptions= new List<SelectOption>();
            GroupKeyOptions=new List<SelectOption>();
            SalesOrgOptions.clear();
            SubBusinessOptions.clear();
            GroupKeyOptions.clear();
            List<Selling_Company_Code_Dependency__c> SBUDependentList = new List<Selling_Company_Code_Dependency__c>();
            SBUDependentList = [SELECT SBU__c,Sales_Org_Code__c,Group_key__c,Sub_Business__c, Customer_Currency__c, Proposed_Credit_Limit_Currency_Code__c, Proposed_Cred_rep_grp__c, Tax_Category__c, Selling_Company_Code__c FROM Selling_Company_Code_Dependency__c WHERE Selling_Company_Code__c = :sellingCompanyCode and SBU__c=: SBUCode];
            if(SBUDependentList.size()>0){
                Set<string>SalesOrgSet = new set<string>();
                Set<string>SubBusinessSet = new set<string>();
                Set<string>GroupKeySet = new set<string>();
                SalesOrgOptions=new List<SelectOption>();
                SubBusinessOptions= new List<SelectOption>();
                GroupKeyOptions=new List<SelectOption>();
                SalesOrgOptions.clear();
                SubBusinessOptions.clear();
                GroupKeyOptions.clear();

                SubBusinessOptions.add(new SelectOption('','--None--'));
                GroupKeyOptions.add(new SelectOption('','--None--'));
                for(Selling_Company_Code_Dependency__c s : SBUDependentList){
                    if(s.Sales_Org_Code__c !=null && s.Sales_Org_Code__c !='' && !(SalesOrgSet.contains(s.Sales_Org_Code__c))){
                        SalesOrgSet.add(s.Sales_Org_Code__c);
                        SalesOrgOptions.add(new SelectOption(s.Sales_Org_Code__c, s.Sales_Org_Code__c));
                    }
                    if(s.Sub_Business__c !=null && s.Sub_Business__c !='' && !(SubBusinessSet.contains(s.Sub_Business__c))){
                        SubBusinessSet.add(s.Sub_Business__c);
                        SubBusinessOptions.add(new SelectOption(s.Sub_Business__c, s.Sub_Business__c));
                    }
                    if(s.Group_key__c !=null && s.Group_key__c !='' && !(GroupKeySet.contains(s.Group_key__c))){
                        GroupKeySet.add(s.Group_key__c);
                        GroupKeyOptions.add(new SelectOption(s.Group_key__c, s.Group_key__c));
                    }
                }
                if(GroupKeyOptions.size()==2){
                    GroupKeyOptions.Remove(0);
                }
                if(SubBusinessOptions.size()==2){
                    SubBusinessOptions.Remove(0);
                    SubBusinessCode=SubBusinessOptions[0].getValue();
                }
            }
        }
        NotifyUsersAvailable();
    }
    /**
     * Name: checkOtherGroupKey
     * Params: None
     * Description: Method to Check Group Key.
     */ 
    public void checkOtherGroupKey(){
        if(Apexpages.currentPage().getParameters().get('fifthParam')+''!='null')
            OnboardingReq.Group_Key__c= Apexpages.currentPage().getParameters().get('fifthParam')+'';
        if(OnboardingReq.Group_Key__c == 'Other')
            openOtherGroupKey = true;
        else{
            openOtherGroupKey = false;
        }
    }

    /**
     * Name: redirectLink
     * Params: None
     * Description: Method will be called on Save/ SaveAndSubmit from the page.
     */ 
    public PageReference redirectLink(){
        return SaveAndSubmit();
    }

    /**
     * Name: populateCurrency
     * Params: None
     * Description: Method will be called to convert the Proposed credit limit currency in Dollars.
     */ 
    public void populateCurrency(){
        if(OnboardingReq !=null){
            Decimal proposedCredEstimated=0.0;
            if(OnboardingReq.Proposed_Credit_Limit__c !='' && OnboardingReq.Proposed_Credit_Limit__c !=null && OnboardingReq.Account_Group__c !='Z002 ( Ship-to party )'){
                if(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c !='' && OnboardingReq.Proposed_Credit_Limit_Currency_Code__c !=null){
                    String CurrencyCode =OnboardingReq.Proposed_Credit_Limit_Currency_Code__c.subString(0,3);
                    CurrencyType curType =[Select Id,ConversionRate,IsoCode,IsActive From CurrencyType Where IsoCode =:CurrencyCode and IsActive =true];
                    try {
                        if(curType !=null){
                            Decimal proposedCred = Decimal.valueof(OnboardingReq.Proposed_Credit_Limit__c);
                            if (proposedCred != 0){
                                proposedCredEstimated = proposedCred.Divide(curType.ConversionRate,2,System.RoundingMode.UP); 

                                OnboardingReq.Proposed_Credit_Limit_Est__c = String.ValueOf(proposedCredEstimated);
                            }
                            else {
                                OnboardingReq.Proposed_Credit_Limit_Est__c = String.ValueOf(proposedCredEstimated);
                            }
                        }
                    }  
                    Catch(exception e){
                        this.IsError = true;
                        OnboardingReq.Proposed_Credit_Limit__c.addError('Proposed Credit Limit Can contain Only numbers which should be Greater then Zero.');
                    }
                }
            }
        }
    }

    /**
     * Name: notification
     * Params: Boolean
     * Description: Method will be called for CDR Notification
     */ 


    public boolean notification(){
        if(selectedNotifyUsers !=null){
            List<String> userNameList = new List<String>();
            List<User> UserList = new List<User>();
            for(SelectOption Str : selectedNotifyUsers) {
                userNameList.add(Str.getValue());
            }
            Set<Id> CDRNotificationSet = new Set<Id>();
            Set<Id> UserListSet = new Set<Id>();
            UserList = [select id, name from User where Id in : userNameList];
            for(User u : UserList){
                UserListSet.add(u.Id);
            }
            List<CDR_Notification__c> CDRNotificationList = [select id, User__c from CDR_Notification__c where Customer_Data_Request__c =: OnboardingReq.Id];
            for(CDR_Notification__c cdr : CDRNotificationList){
                CDRNotificationSet.add(cdr.User__c);
            }
            for(User u : UserList){
                if(!CDRNotificationSet.contains(u.Id)){
                    CDR_Notification__c cdr = new CDR_Notification__c();
                    cdr.User__c = u.id;
                    cdr.Customer_Data_Request__c = OnboardingReq.Id;
                    DupontMarketingUsers.add(cdr);
                }
            }
            for(CDR_Notification__c cd : CDRNotificationList){
                if(!UserListSet.contains(cd.User__c)){
                    CDR_Notification__c cdr = new CDR_Notification__c();
                    cdr.Id=cd.Id;

                    DupontMarketingUsersUnselected.add(cdr);
                }
            }
            if(DupontMarketingUsers.size()>0|| DupontMarketingUsersUnselected.size()>0  ){
                return true;    
            }
            else{
                return false;
            }
        }else return false;
    } 

    /**
     * Name: SaveAndSubmit
     * Params: PageReference
     * Description: Method will be called to save or submit a CDR request
     */ 

    public PageReference SaveAndSubmit(){
        set<id> cdRecordIds = new set<id>();
        //<Alvin20151001> added to make MapCreditTermNLimit global for making Estimated Average Monthly Purchases and Estimated Number of Orders per Month mandatory
        MapCreditTermNLimit = new map<String , Decimal>();
        for(Business_Rules__c br : [select id, CDR_Proposed_Credit_Term_Type__c,CDR_Delegation_Limit__c FROM Business_Rules__c WHERE CDR_Proposed_Credit_Term_Type__c != null AND CDR_Proposed_Credit_Term_Type__c != '' AND CDR_Delegation_Limit__c != null]){
            MapCreditTermNLimit.put(br.CDR_Proposed_Credit_Term_Type__c, br.CDR_Delegation_Limit__c);
        }
        IsError = false;
        populateCurrency();
        //<Tarun20151001> Enhancement Duplicate Check during exteding customer-interchange the order
        
        RequiredValidations(); 
        Validations();
               
        if(IsSaveOrSubmit=='Save'){ //Normal Save of a record

            if(IsClone ==false && ReqId==null){ //New record creation
                if(IsError==false){
                    try{
                        OnboardingReq.Last_Modified_Time__c =system.now();

                        if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE )&& (String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE)))
                        {fieldmodified();
                        validateFieldModified();}
                        if(creditValidationModify() == true)
                            insert OnboardingReq ;
                        else return null;
                        if(currentURLParameters.get('AccountLink')!='null' && currentURLParameters.get('AccountLink')!='' && requestorAccount!= null)
                            update requestorAccount;
                    }
                    catch(exception e){
                        ApexPages.addmessages(e);
                        return null;
                    }
                    if(notification() == true){
                        try{
                            if(DupontMarketingUsers.size()>0)
                                upsert DupontMarketingUsers;
                            if(DupontMarketingUsersUnselected.size()>0)   
                                delete DupontMarketingUsersUnselected;
                        }
                        catch(exception e){
                            ApexPages.addmessages(e);
                            return null;
                        }
                    }
                    return new PageReference('/'+OnboardingReq.Id);
                }else
                    return null;
            }
            else if(IsClone==false && ReqId!=null){ //Updating an existing record
                if(IsError==false){
                    try{
                        if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE )&& (String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE)))
                        {   
                            fieldmodified();
                            validateFieldModified();
                            if(creditValidationModify() == true)
                                update OnboardingReq;
                            else return null;
                        }else{
                            update OnboardingReq;
                        }
                    }
                    catch(exception e){
                        ApexPages.addmessages(e);
                        return null;
                    }
                    if(notification() == true){
                        try{
                            if(DupontMarketingUsers.size()>0)
                                upsert DupontMarketingUsers;
                            if(DupontMarketingUsersUnselected.size()>0) 
                                delete DupontMarketingUsersUnselected;
                        }
                        catch(exception e){
                            ApexPages.addmessages(e);
                            return null;
                        }
                    }
                    return new PageReference('/'+OnboardingReq.Id);
                }else {

                    return null;
                }
            }else return null;

        }
        else if(IsSaveOrSubmit=='Submit'){ // Submitting a record that will subject it to Status and Owner Change

            OnboardingReq.Request_Submitted__c=true;
            if(IsClone ==false && ReqId==null){ //New record creation
                if(IsError==false ){
                    if( RelatedlistItemsValidation()==false){
                        return null;
                    }
                    try{


                        if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE )&& (String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE)))
                        {
                            fieldmodified();
                            validateFieldModified();}
                            if(creditValidationModify() == true){
                            RequestFlow();
                            insert OnboardingReq ;
                        }
                        else return null;
                        if(currentURLParameters.get('AccountLink')!='null' && currentURLParameters.get('AccountLink')!='' && requestorAccount!= null)
                            update requestorAccount;
                    }
                    catch(exception e){
                        ApexPages.addmessages(e);
                        return null;
                    }
                    if(notification() == true){
                        try{
                            if(DupontMarketingUsers.size()>0)
                                upsert DupontMarketingUsers;
                            if(DupontMarketingUsersUnselected.size()>0)
                                delete DupontMarketingUsersUnselected;
                            cdRecordIds.add(OnboardingReq.Id);

                            SendEmailforNotification.Notifiyusers(cdRecordIds);
                        }
                        catch(exception e){
                            ApexPages.addmessages(e);
                            return null;
                        }
                    }
                    return new PageReference('/apex/COBCSRSubmitMessagePage');   
                }
                else
                    return null;
            }else if(IsClone==false && ReqId!=null){ //Updating an existing record
                if(IsError==false){
                    if( RelatedlistItemsValidation()==false){
                        return null;
                    }
                    try{

                        if(((String.ValueOf(OnboardingReq.RecordTypeId) != NewCustomerCreation_COB_RTYPE ) && (String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE )&& (String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE)))
                        {
                            fieldmodified();
                            validateFieldModified();
                            
                            if(creditValidationModify() == true){
                                RequestFlow();
                                update OnboardingReq;
                            }
                            else return null;
                        }else{
                            RequestFlow();
                            update OnboardingReq;
                        }
                    }
                    catch(exception e){
                        ApexPages.addmessages(e);
                        return null;
                    }
                    if(notification() == true){
                        try{
                            if(DupontMarketingUsers.size()>0)
                                upsert DupontMarketingUsers;
                            if(DupontMarketingUsersUnselected.size()>0)
                                delete DupontMarketingUsersUnselected;

                            cdRecordIds.add(OnboardingReq.Id);                            
                            SendEmailforNotification.Notifiyusers(cdRecordIds);
                        }
                        catch(exception e){
                            ApexPages.addmessages(e);
                            return null;
                        }
                    }
                    return new PageReference('/apex/COBCSRSubmitMessagePage');
                }
                else return null;
            }else return null;
        }else return null;  
    }
    /**
     * Name: creditValidationModify
     * Params: None
     * Description: Method to check credit section in Modify Existing.
     */  

    public boolean creditValidationModify(){
        boolean creditError = true;
        //<Alvin20150617> show error message when no field is changed for extend
        if(OnboardingReq.recordTypeId == ModifyExisting_COB_RTYPE  && !fieldmodifiedmap.isEmpty() && !OnboardingReq.Fields_Modified_2__c.contains(';')  && !OnboardingReq.Fields_Modified_1__c.contains(';')){
            creditError = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please change at least one field.'));
        }
        if(OnboardingReq.recordTypeId == ModifyExisting_COB_RTYPE && OnboardingReq.Fields_Modified_2__c !=null){
        
            if(OnboardingReq.Request_Status__c !='Request Completed in SAP') //<Santhosh20160613> added if condition
            {                               
                                
                if(OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Terms of Payment') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit Currency Code')){
                    isCreditValidation = true;
                    OnboardingReq.Credit_Approval_Required__c = true;
                    if(OnboardingReq.Proposed_Terms_of_Payment__c == null || OnboardingReq.Proposed_Terms_of_Payment__c == ''){
                        creditError = false;
                        OnboardingReq.Proposed_Terms_of_Payment__c.addError('Proposed Terms of Payment should be filled');
                    }
                    if(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c == null || OnboardingReq.Proposed_Credit_Limit_Currency_Code__c == ''){
                        creditError = false;
                        OnboardingReq.Proposed_Credit_Limit_Currency_Code__c.addError('Proposed Credit Limit Currency Code should be filled');
                    }
                    if(OnboardingReq.Proposed_Credit_Limit__c == null || OnboardingReq.Proposed_Credit_Limit__c == ''){
                        creditError = false;
                        OnboardingReq.Proposed_Credit_Limit__c.addError('Proposed Credit Limit should be filled');
                    }
                    //<Alvin20151001> Commented for making Estimated Average Monthly Purchases and Estimated Number of Orders per Month mandatory only if going to credit, req 32 R02 enhancement
                    /*
                    if(OnboardingReq.Estimated_Average_Monthly_Purchases__c == null){
                        creditError = false;
                        OnboardingReq.Estimated_Average_Monthly_Purchases__c.addError('Estimated Average Monthly Purchases should be filled');
                    }
                    if(OnboardingReq.Estimated_Number_of_Orders_per_Month__c == null){
                        creditError = false;
                        OnboardingReq.Estimated_Number_of_Orders_per_Month__c.addError('Estimated Number of Orders per Month should be filled');
                    }*/
                    if(!(getPicklistValues('Customer_Data_Request__c','Proposed_Terms_of_Payment__c').contains(OnboardingReq.Proposed_Terms_of_Payment__c)) && OnboardingReq.Proposed_Terms_of_Payment__c != null && OnboardingReq.Proposed_Terms_of_Payment__c != ''){
    
                        creditError = false;
                        OnboardingReq.Proposed_Terms_of_Payment__c.addError('Invalid Proposed Terms of Payment. Please select correct one');
                    }    
    
                }
                if(OnboardingReq.Fields_Modified_2__c.contains('Proposed Terms of Payment') && (OnboardingReq.Proposed_Terms_of_Payment__c!=null && OnboardingReq.Proposed_Terms_of_Payment__c!='' && OnboardingReq.Proposed_Terms_of_Payment__c!='--None--') && (OnboardingReq.Proposed_Credit_Term_Type__c== null || OnboardingReq.Proposed_Credit_Term_Type__c== '' || OnboardingReq.Proposed_Credit_Term_Type__c== '--None--') ){
                    creditError = false;
                    OnboardingReq.Proposed_Credit_Term_Type__c.addError('Proposed Credit Term Type is mandatory when Proposed Terms of Payment is filled.');
                }

             }
            }
            //<Nishant20150618> show error message when for invalid terms of payment
            //<Nishant20150623> taken customer account group under considertation as well
            if(OnboardingReq.recordTypeId == ExtendExisting_COB_RTYPE){
                if(OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Terms of Payment') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit Currency Code') || OnboardingReq.Extended_Account_Group__c==null || OnboardingReq.Extended_Account_Group__c==''){
                    //isCreditValidation = true;
                    OnboardingReq.Credit_Approval_Required__c = true;
                    if(!(getPicklistValues('Customer_Data_Request__c','Proposed_Terms_of_Payment__c').contains(OnboardingReq.Proposed_Terms_of_Payment__c)) && OnboardingReq.Proposed_Terms_of_Payment__c != null && OnboardingReq.Proposed_Terms_of_Payment__c != ''){
    
                        creditError = false;
                        OnboardingReq.Proposed_Terms_of_Payment__c.addError('Invalid Proposed Terms of Payment. Please select correct one');
                    }
                }
        }
        return creditError;
    }   

    /**
     * Name: getPicklistValues
     * Params: None
     * Description: Method to get picklist values by passing object and field API name
     */ 
    public set<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        Set<String> lstPickvals=new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        return lstPickvals;
    }

    /**
     * Name: currentUserProfile
     * Params: String
     * Description: Method to get profile of Current user.
     */ 
    public String currentUserProfile(){
        Id ProfileId = UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:ProfileId].Name;
        return profileName;
    }

    /**
     * Name: queryPublicGroup
     * Params: None
     * Description: To Query All the Public Groups.  
     */  
    public void queryPublicGroup(){
        mapGrpIdNGrpName = new map<Id,String>();
        mapUserIdNGrpName = new map<id,set<String>>();
        CurrentUserId = userInfo.getUserId();
        List<Id> lst_Member = new List<Id>();
        for(GroupMember g : [Select UserOrGroupId, Id, GroupId From GroupMember  where UserOrGroupId =:CurrentUserId]){
            lst_Member.add(g.GroupId);
        }

        if(!Test.isRunningTest()){ 
            for(Group grp : [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where g.Id in :lst_Member]){
                mapGrpIdNGrpName.put(grp.Id,grp.Name);
            }
        }
        else {
            for(Group grp : [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where g.Id in :lst_Member Limit 100]){
                mapGrpIdNGrpName.put(grp.Id,grp.Name);
            }
        }
        if(mapGrpIdNGrpName.size()>0){
            for(GroupMember grpmem : [Select UserOrGroupId, Id, GroupId From GroupMember  where UserOrGroupId =:CurrentUserId]){
                if(mapUserIdNGrpName.containsKey(grpmem.UserOrGroupId))
                    mapUserIdNGrpName.get(grpmem.UserOrGroupId).add(mapGrpIdNGrpName.get(grpmem.GroupId));
                else
                    mapUserIdNGrpName.put(grpmem.UserOrGroupId,new set<String>{mapGrpIdNGrpName.get(grpmem.GroupId)});
            }
            if(mapUserIdNGrpName.size()>0 && mapUserIdNGrpName.get(CurrentUserId) !=null){
                lst_GrpName=mapUserIdNGrpName.get(CurrentUserId);
            }
            if(lst_GrpName.size()>0)
                PageAccess= true;
        }

    }

    /**
     * Name: fetchQueueMap
     * Params: None
     * Description: Method to fetch all the queues and create a map.
     */
    public void fetchQueueMap(){
        QueueMap = new Map <String,Id>();
        list<Group> QueueList = [select Id,Name from Group Where Type = 'Queue'];
        for(Group q:QueueList){
            QueueMap.put(q.Name,q.Id);
        }       
    }

    /**
     * Name: populateRequestorInformation
     * Params: None
     * Description: Method to populate requestor information.
     */
    public void populateRequestorInformation(){
        User RequestorUser = new User();
        RequestorUser = [Select Id, Name, Phone,Email from User where Id=:CurrentUserId ];
        OnboardingReq.Requestor_Name__c=RequestorUser.Id;
        OnboardingReq.Requestor_phone_number__c=RequestorUser.Phone;
        OnboardingReq.Requestor_Email__c=RequestorUser.Email;
    }
    /**
     * Name: populateAccountInformation 
     * Params: acctId: Account Related to Customer_Data_Request__c
     * Description: Method will be called On Page Load to copy Accountr details in Request.
     */ 

    public void populateAccountInformation(Id acctId){


        if(requestorAccount !=null && ((OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE || OnboardingReq.RecordTypeId == Partner_COB_RTYPE || OnboardingReq.RecordTypeId == Miscellaneous_COB_RTYPE) || (OnboardingReq.RecordTypeId == ExtendExisting_COB_RTYPE && OnboardingReq.Extended_Account_Group__c!='' && OnboardingReq.Extended_Account_Group__c!= null)) && onboardingReq.Customer__c != null ){
            ERP_Customer__c erpCustomer = new ERP_Customer__c();
            erpCustomer = fetchCustomerInformation(onboardingReq.Customer__c);            
            //<Alvin 20150903> Commented below line for Le1310 ehnacement to fetch company code and SBU directly from Sales org Code
            // List<Business_Rules__c> busSBURules = new List<Business_Rules__c>();
            List<Business_Rules__c> busSellingCompanyRules = new List<Business_Rules__c>();
            Set<String> divisionList = new Set<String>();
            Set<String> distChannelList = new Set<String>();

            if(erpCustomer.Sales_Org_Code__c.length()==4){

                //<Alvin 20150903> Commented for Le1310 ehnacement to fetch company code and SBU directly from Sales org Code
                /* String SellingCompanyString = erpCustomer.Sales_Org_Code__c.subString(2,4);
                String SBUString = erpCustomer.Sales_Org_Code__c.subString(0,2);
                busSBURules = [select id, Name , SBU_Code__c, SBU_Description__c from Business_Rules__c where SBU_Code__c = :SBUString AND recordTypeId = :SBU_Rule_Rtype];
                 */
                //<Alvin 20150903> updated below code for Le1310 ehnacement to fetch company code and SBU directly from Sales org Code
                busSellingCompanyRules = [select id, Name , Selling_Company_Code__c, Selling_Company_Code_Number__c,SBU_Code__c, SBU_Description__c from Business_Rules__c where Sales_Org_Code__c = :erpCustomer.Sales_Org_Code__c AND recordTypeId = : CompanyCodeSBU_Rule_Rtype];

                
                //<Santhosh 20151011> updated the below condition for picking selling company code value.
                if(busSellingCompanyRules.size()!=0 && busSellingCompanyRules.size()>= 1){                                   
                    OnboardingReq.Company_Code__c = busSellingCompanyRules[0].Selling_Company_Code__c;

                }
                sellingCompanyCode = OnboardingReq.Company_Code__c;
                fetchSellingCompanyDependents();
                SBUOptions = new List<SelectOption>();
                SBUOptions.clear();
                if(busSellingCompanyRules.size() > 0){

                    SBUOptions.add(new SelectOption('','--None--'));
                    for(Business_Rules__c rules : busSellingCompanyRules){
                        SBUOptions.add(new SelectOption(rules.SBU_Description__c, rules.SBU_Description__c));
                    }
                    if(busSellingCompanyRules.size()==2){
                        OnboardingReq.SBU__c = busSellingCompanyRules[1].SBU_Description__c;
                    }
                }
                //<Alvin 20150903> End

            }

            OnboardingReq.Sales_Organization__c = erpCustomer.Sales_Org_Code__c;
            OnboardingReq.Account_Group__c = erpCustomer.Account_Group__c;
            SBUCode=OnboardingReq.SBU__c;

            fetchSBUDependents();

            divisionList = getPicklistValues('Customer_Data_Request__c','Division__c');
            if(erpCustomer.Division_Code__c != null && erpCustomer.Division_Code__c!=''){
                for(String str : divisionList){

                    if(str.startsWith(erpCustomer.Division_Code__c))
                        OnboardingReq.Division__c = str;
                }
            }
            distChannelList = getPicklistValues('Customer_Data_Request__c','Distribution_Channel__c');
            if(erpCustomer.Distribution_Channel_Code__c != null && erpCustomer.Distribution_Channel_Code__c!=''){
                for(String str : distChannelList ){
                    if(str.startsWith(erpCustomer.Distribution_Channel_Code__c))
                        OnboardingReq.Distribution_Channel__c = str;
                }
            }

            //<Nishant20150612> show error message when company code and SBU is null
            //To validate supported Sales Org Code
            if((OnboardingReq.Company_Code__c == null)  || SBUOptions ==null || SBUOptions.size()<=1 ){
                system.debug('Testing invalid company code validation');
                this.IsError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Sales Org on this customer data request is not supported. Please cancel the request'));
            }
        }
        else if(requestorAccount !=null && OnboardingReq.RecordTypeId != ModifyExisting_COB_RTYPE && OnboardingReq.RecordTypeId != Partner_COB_RTYPE && OnboardingReq.RecordTypeId != Miscellaneous_COB_RTYPE){

            OnboardingReq.Company_Code__c = requestorAccount.Company_Code__c;
            OnboardingReq.SBU__c = requestorAccount.SBU__c;
            OnboardingReq.Sales_Organization__c = requestorAccount.Sales_Organization_Name__c;
            if(OnboardingReq.RecordTypeId != ExtendExisting_COB_RTYPE)
                OnboardingReq.Customer_Name__c = requestorAccount.Name;
            OnboardingReq.Group_Key__c = requestorAccount.Group_key__c;
            OnboardingReq.Sub_Business__c = requestorAccount.Sub_Business__c;
            sellingCompanyCode=OnboardingReq.Company_Code__c;
            SBUCode=OnboardingReq.SBU__c;
        }

    }

    /**
     * Name: fetchRecordTypeName
     * Params: None
     * Description: Method to fetch RecordType Names.
     */ 

    public void fetchRecordTypeName(){
        if(OnboardingReq.RecordTypeId != null){
            RecordTypeName = [Select Id,Name from RecordType where SobjectType='Customer_Data_Request__c' and IsActive=true and Id=:OnboardingReq.RecordTypeId].Name;
        }
    }

    public PageReference Done(){
        return new PageReference('/apex/COBCustomerSearch');
    }

    public Account fetchAccountDetails(Id accId){

        requestorAccount=[Select Id,Region__c, Company_Code__c, Name,Sales_Organization_Name__c, SBU__c,ERP_Customer__r.Id, Sub_Business__c, Group_key__c,ERP_Customer__c,ERP_Account_Code__c from account where ID=:accId];
        return requestorAccount;
    }

    /**
     * Name: FormRenderValidation
     * Params: 
     * Description: Method to validate the form whenever it is rendered.
     */ 
    public void FormRenderValidation(){

        if(requestorAccount !=null && currentURLParameters.get('Id')=='null' ){
            if(OnboardingReq.RecordTypeId !=Miscellaneous_COB_RTYPE && currentURLParameters.get('Search')!='Extend' && OnboardingReq.RecordTypeId != NewCustomerCreation_COB_RTYPE && requestorAccount.ERP_Customer__c==null){
                showErrorPage = true;
                displayMainPage=false;
                showNewCustomerErrorPage=false;
            }else if(OnboardingReq.RecordTypeId ==NewCustomerCreation_COB_RTYPE && currentURLParameters.get('Case') == 'null' &&( requestorAccount.ERP_Customer__c !=null || (requestorAccount.ERP_Account_Code__c !=null && requestorAccount.ERP_Account_Code__c !=''))){
                showErrorPage = false;
                displayMainPage=false;
                showNewCustomerErrorPage=true;
            }
            else if(OnboardingReq.RecordTypeId ==Miscellaneous_COB_RTYPE && onboardingReq.Account__c!= null && OnboardingReq.Customer__c== null){
                showErrorPage = false;
                displayMainPage=false;
                showNewCustomerErrorPage=true;
            }
            else{
                displayMainPage = true;
                showErrorPage = false;
                showNewCustomerErrorPage=false;
            }
        }
    }  

    /**
     * Name: Cancel
     * Params: None
     * Description: Method will be called when request is cancelled from the page.
     */ 
    public PageReference Cancel(){
        If(ReqId!=null){
            return new PageReference ('/' + ReqId);
        }
        else {
            return new PageReference ('/apex/COBCustomerSearch' );
        }

    }

    /**
     * Name:getItems
     * Params: None
     * Description: Used to find the Intent of Miscellaneous request
     */

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        if (OnboardingReq.Account__c != null){
            options.add(new SelectOption('','--None--'));
            options.add(new SelectOption('Block','Block'));
            options.add(new SelectOption('Unblock','Unblock'));
            options.add(new SelectOption('Others','Others'));           
        }
        else{
            options.add(new SelectOption('','--None--'));
            options.add(new SelectOption('Mass load - finance data','Mass load - finance data'));
            options.add(new SelectOption('Mass load - non finance data','Mass load - non finance data'));
            options.add(new SelectOption('Others','Others'));
        }
        return options;
    }
    /**
     * Name:requireCreditApproval
     * Params: None
     * Description: Used to render Credit_Approval_Required__c based on Intent of Miscellaneous request
     */

    public void requireCreditApproval(){
        if(MiscIntent=='Block' || MiscIntent=='Unblock' || MiscIntent=='Mass load - finance data'){
            flagIntent=true;
            OnboardingReq.Credit_Approval_Required__c=true;
        }
        else if(MiscIntent=='Others'){
            flagIntent=true;
            OnboardingReq.Credit_Approval_Required__c=false;
        }
        else{
            flagIntent=false; 
            OnboardingReq.Credit_Approval_Required__c=false; 
        }    
    }


    /**
     * Name: RedirectCancelAndClose
     * Params: None
     * Description: Method will be called on when request has to be cancelled and closed.
     */ 
    public Pagereference RedirectCancelAndClose(){
        if(IsClone==false && ReqId!=null){
            PageReference pg = new Pagereference('/apex/SubCustomerOnboardingRequest?RecordTypeId='+OnboardingReq.RecordTypeId+'&Id='+ReqId+'&Clone=null&Account=null&ERPCustomer=null&Case=null');
            pg.setredirect(true);
            return pg; 
        }
        return null;
    }

    /**
     * Name: CancelAndClose
     * Params: None
     * Description: Method will be called on when request has to be cancelled and closed.
     */ 
    public Pagereference CancelAndClose(){
        PageReference pg;
        //<Santhosh 20160706> added 'DuPont CDR Users - ANZ' group condition
        //<Bhargavi 20160919> added 'DuPont CDR Users - ASEAN' group condition
        if((lst_GrpName.contains('DuPont CDR Users - Thailand') || lst_GrpName.contains('DuPont CDR Users - India') || lst_GrpName.contains('DuPont CDR Users - ANZ') || lst_GrpName.contains('Dupont CDR Users - ASEAN') || lst_GrpName.contains('DuPont CDR Users - Hong Kong') || lst_GrpName.contains('DuPont CDR Users - China')
                ||lst_GrpName.contains('DPP Customer Service Reps') || lst_GrpName.contains('DPT Customer Service Reps')  || lst_GrpName.contains('DCP Customer Service Reps')
                || lst_GrpName.contains('P&IP Customer Service Reps')  || lst_GrpName.contains('DSS Customer Service Reps') || lst_GrpName.contains('BI Customer Service Reps')
                || lst_GrpName.contains('N&H Customer Service Reps') || lst_GrpName.contains('DEC Customer Service Reps') || lst_GrpName.contains('IB Customer Service Reps')
                || lst_GrpName.contains('Customer On-boarding Levrg CSR - India') || lst_GrpName.contains('Customer On-boarding Levrg CSR - China') || lst_GrpName.contains('Customer On-boarding Levrg CSR – Thailand')))
        {
            OnboardingReq.Last_Modified_Time__c =system.now();
            if(OnboardingReq.Last_Modified_Time__c !=null){
                OnboardingReq.Record_Locked__c=true;
                OnboardingReq.Request_Status__c='Closed';
                OnboardingReq.Send_To_Utility__c=true;
                // Added as part of test class fix - KK
                OnboardingReq.Local_Language_Office_House_Number__c = '.';
                OnboardingReq.Local_Language_State_Province__c = '.';
                              
             System.debug(LoggingLevel.ERROR,'@#debug11'+OnboardingReq);   
                update OnboardingReq;
             System.debug(LoggingLevel.ERROR,'@#debug'+OnboardingReq);
                pg= new PageReference('/'+OnboardingReq.Id);
            }
            else{
                If(ReqId!=null){
                    return new PageReference ('/' + ReqId);
                }
                else {
                    return new PageReference ('/apex/COBCustomerSearch' );
                }
            }
        }
        return pg ; 
    }

    /**
     * Name: getRequestInformation
     * Params: reqId: Customer_Data_Request__c Id to fetch all the details of the record
     * Description: Method to get details of the record based on the parameter passed.
     */
    public Customer_Data_Request__c getRequestInformation(Id reqId){
        Customer_Data_Request__c req = new Customer_Data_Request__c();
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Customer_Data_Request__c.fields.getMap();
        String querySearch= '';
        String query;

        for(String s :fldObjMap.KeySet()){
            querySearch = querySearch + s + ',';
        }
        querySearch = querySearch.removeEnd(',');
        query = 'Select '+  querySearch + ',RecordType.Name,CreatedBy.Id,Account__r.Id from Customer_Data_Request__c where Id=\''+reqId+'\'';
        req=database.query(query);
        system.debug('existing record data'+query+'&&&&&'+req);
        return req;
    }
    /**
     * Name: fetchCustomerInformation
     * Params: reqId: Customer_Data_Request__c Id to fetch all the details of the record.
     * Description: Method to fetch ERP customer associated to Custoimer Data Request.
     */
    public ERP_Customer__c fetchCustomerInformation(Id CustId){
        ERP_Customer__c cust = new ERP_customer__c();
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ERP_customer__c.fields.getMap();
        String custQuerySearch= '';
        String custQuery;
        for(String s :fldObjMap.KeySet()){
            custQuerySearch= custQuerySearch+ s + ',';
        }
        custQuerySearch= custQuerySearch.removeEnd(',');
        custQuery = 'Select '+  custQuerySearch+ ',RecordType.Name from ERP_Customer__c  where Id=\''+CustId+'\'';
        cust=database.query(custQuery);
        return cust;
    }

    /**
     * Name: parseWebserviceResponse
     * Params: String ResponseXML
     * Description: To Parse the Response that we get from SAP to prepolulate the customer information in the request.  
     */ 
    public void parseWebserviceResponse(String ResponseXML){
        if(ResponseXML !=null && ResponseXML !=''){
            Dom.Document responseDoc = new Dom.Document();
            if (ResponseXML.contains('Unable to process the request')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'The SAP Server was unable to process the request. Please check with your administrator.'));
            }
            else{
                try {
                    responseDoc.load(ResponseXML);
                    dom.XmlNode xroot = responseDoc.getrootelement() ;
                    dom.XmlNode child = xroot.getChildElement( 'Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('Y_GVCUSTOMER_GETDETAIL.Response', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail').getChildElement('Response','http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    // ******* Parent node for AddressData ******** //
                    dom.XmlNode addressDataNode = child.getChildElement( 'PE_ADDRESSDATA', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] addressDataChilds = addressDataNode.getChildElements();                    
                    if (addressDataChilds.size()>0 ){
                        getAddressDataFields(addressDataChilds);
                    }

                    // ******* Parent node for COMPANYDATA  ******// 
                    dom.XmlNode companyDataNode = child.getChildElement( 'PE_COMPANYDATA', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] companyDataChilds = companyDataNode.getChildElements();  
                    if (companyDataChilds.size()>0 ){
                        getCompanyDataFields(companyDataChilds);
                    } 

                    // ******* Parent node for PERSONALDATA  ******// 
                    dom.XmlNode personaldataNode = child.getChildElement( 'PE_PERSONALDATA', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] personaldataChilds = personaldataNode.getChildElements();        
                    if (personaldataChilds.size()>0 ){
                        getPersonalDataFields(personaldataChilds);
                    } 

                    // ******* Parent node for SALESDATA  ******// 
                    dom.XmlNode salesDataNode = child.getChildElement( 'PE_SALESDATA', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] salesDataChilds = salesDataNode.getChildElements(); 
                    if (salesDataChilds.size()>0 ){
                        getSalesDataFields(salesDataChilds);
                    } 

                    // ****** Parent node for CreditData  ******//
                    dom.XmlNode creditDataNode = child.getChildElement( 'PE_CONTROLDETAILS', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] creditDataChilds = creditDataNode.getChildElements(); 
                    if (creditDataChilds.size()>0 ){
                        getCreditDataFields(creditDataChilds);
                    }

                    // ******* Parent node for TAXGROUPINGS  ******// 
                    dom.XmlNode taxGroupingsNode = child.getChildElement( 'PE_TAXGROUPINGS', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] taxGroupingsChilds = taxGroupingsNode.getChildElements(); 
                    if (taxGroupingsChilds.size()>0 ){
                        getTaxGroupingsFields(taxGroupingsChilds);
                    } 
                    // ******* Parent node for DunningData  ****** // 
                    dom.XmlNode DunningDataNode = child.getChildElement( 'PE_DUNNINGDATA', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                    dom.XmlNode [] DunningDataChilds = DunningDataNode.getChildElements(); 
                    if (taxGroupingsChilds.size()>0 ){
                        getDunningDataFields(DunningDataChilds);
                    } 

                    // ******* Parent node for ERROR_CODE  ******// 
                    dom.XmlNode errorCodeNode = child.getChildElement( 'ERROR_CODE', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');

                    // ******* Parent node for ERROR_DESC   ******// 
                    dom.XmlNode errorDescriptionNode = child.getChildElement( 'ERROR_DESC', 'http://soap.sforce.com/schemas/class/GVCustomerGetDetail');
                }catch(System.XMLException e){ // Invalid XML
                    //return null;
                }  
            }       
        }
        //return null;
    }   

    /**
     * Name: getDunningDataFields 
     * Params: dom.XmlNode[] DunningDataChilds 
     * Description: Method to parse the filds of the CreditData node in the response xml.  
     */     

    public void getDunningDataFields ( dom.XmlNode[] DunningDataChilds ){      

        try {  
            for(Dom.XmlNode addchilds: DunningDataChilds) {   
                if(addchilds.getname() != null) {
                    if (addchilds.getname() == 'BUSAB')  {

                        OnboardingReq.Dunning_Clerk_Code__c= addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Dunning_Clerk_Code__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'MAHNA')  {
                        if(addchilds.getname() != null && addchilds.gettext() != '') 
                            OnboardingReq.Dunning_Procedure__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Dunning_Procedure__c'),String.valueOf(addchilds.gettext()));    
                    }  
                }
            }   
        }catch (exception e) {
            System.debug('Something went wrong in the CreditDataChilds ----- ');
        }  
    }



    /**
     * Name: getCreditDataFields 
     * Params: dom.XmlNode[] CreditDataChilds 
     * Description: Method to parse the filds of the CreditData node in the response xml.  
     */     

    public void getCreditDataFields ( dom.XmlNode[] creditDataChilds ){      

        try {  

            for(Dom.XmlNode addchilds: creditDataChilds) {   
                if(addchilds.getname() != null) {
                    if (addchilds.getname() == 'KLIMK')  {                    
                        OnboardingReq.Proposed_Credit_Limit__c= addchilds.gettext();
                        OnboardingReq.Existing_Approved_Credit_Limit__c= Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Proposed_Credit_Limit__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'CTLPC')  {

                        OnboardingReq.Proposed_Risk_Category__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Risk_Category__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'SBGRP')  {

                        OnboardingReq.Proposed_Cred_rep_grp__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Cred_rep_grp__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'KRAUS')  {

                        OnboardingReq.Proposed_Credit_Information_Number__c = Decimal.ValueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Proposed_Credit_Information_Number__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'GRUPP')  {

                        OnboardingReq.Proposed_Customer_Credit_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Customer_Credit_Group__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'SBDAT')  {

                        if(addchilds.gettext() != '0000-00-00') {
                            Date TempDate= Date.ValueOf(addchilds.gettext());
                            if(TempDate.year() > 4000){
                                TempDate = Date.newInstance(4000, 12, 31);
                                OnboardingReq.Proposed_Reference_Date__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Proposed_Reference_Date__c'),'4000-12-31');
                            }
                            else{
                                OnboardingReq.Proposed_Reference_Date__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Proposed_Reference_Date__c'),String.valueOf(addchilds.gettext()));
                            }
                        }
                        else{
                            fieldmodifiedmap.put(string.valueof('Proposed_Reference_Date__c'),String.valueOf(addchilds.gettext()));    
                        }
                    }
                    else if (addchilds.getname() == 'DBPAY')  {

                        OnboardingReq.Proposed_Payment_Index__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Proposed_Payment_Index__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'DBRTG')  {

                        OnboardingReq.Proposed_Rating__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Rating__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'DBWAE')  {

                        OnboardingReq.Existing_Appr_Credit_Lmt_Currency_Code__c = addchilds.gettext();
                        OnboardingReq.Proposed_Credit_Limit_Currency_Code__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Credit_Limit_Currency_Code__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'REVDB')  {
                        if(addchilds.gettext() != '0000-00-00'){ 
                            Date TempDate= Date.ValueOf(addchilds.gettext());
                            if(TempDate.year() > 4000){
                                TempDate = Date.newInstance(4000, 12, 31);
                                OnboardingReq.Last_External_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Last_External_Review__c'),'4000-12-31');
                            }
                            else{
                                OnboardingReq.Last_External_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Last_External_Review__c'),String.valueOf(addchilds.gettext()));
                            }
                        }
                        else{
                            fieldmodifiedmap.put(string.valueof('Last_External_Review__c'),String.valueOf(addchilds.gettext())); 
                        }                   
                    }
                    else if (addchilds.getname() == 'DTREV')  {
                        if(addchilds.gettext() != '0000-00-00')
                        {                    
                            Date TempDate= Date.ValueOf(addchilds.gettext());
                            if(TempDate.year() > 4000){
                                TempDate = Date.newInstance(4000, 12, 31);
                                OnboardingReq.Last_Internal_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Last_Internal_Review__c'),'4000-12-31');
                            }
                            else{
                                OnboardingReq.Last_Internal_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Last_Internal_Review__c'),String.valueOf(addchilds.gettext()));
                            }

                        }
                        else{
                            fieldmodifiedmap.put(string.valueof('Last_Internal_Review__c'),String.valueOf(addchilds.gettext()));    
                        }
                    }
                    else if (addchilds.getname() == 'NXTRV')  {
                        if(addchilds.gettext() != '0000-00-00'){ 
                            Date TempDate= Date.ValueOf(addchilds.gettext());
                            if(TempDate.year() > 4000){
                                TempDate = Date.newInstance(4000, 12, 31);
                                OnboardingReq.Next_Internal_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Next_Internal_Review__c'),'4000-12-31');
                            }
                            else{
                                OnboardingReq.Next_Internal_Review__c = Date.ValueOf(TempDate);
                                fieldmodifiedmap.put(string.valueof('Next_Internal_Review__c'),String.valueOf(addchilds.gettext()));
                            }

                        }
                        else{
                            fieldmodifiedmap.put(string.valueof('Next_Internal_Review__c'),String.valueOf(addchilds.gettext()));    
                        }
                    }
                    //<Alvin20150612> Added additional fields to field modified
                    fieldmodifiedmap.put('Business_Strategic__c', '');
                    fieldmodifiedmap.put('Geocode__c', '');
                    fieldmodifiedmap.put('Unloading_Point__c', '');
                    fieldmodifiedmap.put('Business_Category__c', '');
                    fieldmodifiedmap.put('Ownership_Type__c', '');
                    fieldmodifiedmap.put('Business_Partner_ID_Grouping__c', '');
                    fieldmodifiedmap.put('Jurisdiction_Code__c', '');
                    fieldmodifiedmap.put('Registration_Number__c', '');
                    fieldmodifiedmap.put('Ultimate_Consign_Type_attribute__c', '');
                    fieldmodifiedmap.put('Argentina_Withholding_Tax__c', '');
                    fieldmodifiedmap.put('CFOP__c', '');
                    fieldmodifiedmap.put('Preferred_Bank_Name__c', '');
                    fieldmodifiedmap.put('Alternative_Preferred_Bank_Name__c', '');
                    fieldmodifiedmap.put('Estimated_Average_Monthly_Purchases__c', '');
                    fieldmodifiedmap.put('Estimated_Number_of_Orders_per_Month__c', '');
                    fieldmodifiedmap.put('Proposed_Customer_Group__c', '');
                    fieldmodifiedmap.put('Customer_Currency__c', '');
                }
            }
        }catch (exception e) {
            System.debug('Something went wrong in the CreditDataChilds ----- ');
        }  
    }

    /**
     * Name: getAddressDataFields 
     * Params: dom.XmlNode[] AddressDataChilds 
     * Description: Method to parse the filds of the AddressData node in the response xml.  
     */     

    public void getAddressDataFields ( dom.XmlNode[] AddressDataChilds ){      

        try {
            system.debug('address data childs'+AddressDataChilds);
            for(Dom.XmlNode addchilds: AddressDataChilds) {

                if(addchilds.getname() != null) {
                    system.debug('child get name'+addchilds.getname() + 'get text' + addchilds.gettext()+';');
                    if (addchilds.getname() == 'NAME1')  {

                        OnboardingReq.Customer_Name__c= addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Name__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'NAME2')  {

                        OnboardingReq.Customer_Name_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Name_2__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'NAME3')  {

                        OnboardingReq.Customer_Name_3__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Name_3__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'NAME4')  {

                        OnboardingReq.Customer_Name_4__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Name_4__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'CITY1')  {

                        OnboardingReq.Sold_to_City__c = addchilds.gettext();
                        OnboardingReq.Existing_City__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_City__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'CITY2')  {

                        OnboardingReq.Sold_to_District__c = addchilds.gettext();
                        OnboardingReq.Existing_District__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_District__c'),String.valueOf(addchilds.gettext()));    
                    }

                    else if (addchilds.getname() == 'PO_BOX')  {

                        OnboardingReq.P_O_Box__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('P_O_Box__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'HOUSE_NUM1')  {

                        OnboardingReq.Existing_Office_House_Number__c = addchilds.gettext();
                        OnboardingReq.Sold_To_Office_House_Number__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_To_Office_House_Number__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'HOUSE_NUM2')  {
                        OnboardingReq.House_Supplement__c = addchilds.gettext();
                        OnboardingReq.Sold_To_House_Supplement__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_To_House_Supplement__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'REGION')  {

                        OnboardingReq.Existing_State_Province__c = addchilds.gettext();
                        OnboardingReq.Sold_to_State_Province__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_State_Province__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'SORT1')  {

                        OnboardingReq.Search_Term__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Search_Term__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'TEL_NUMBER')  {

                        OnboardingReq.Existing_Telephone__c = addchilds.gettext();
                        OnboardingReq.Sold_to_Telephone__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_Telephone__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'FAX_NUMBER')  {

                        OnboardingReq.Existing_Fax_Number__c = addchilds.gettext();
                        OnboardingReq.Sold_to_Fax_Number__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_Fax_Number__c'),String.valueOf(addchilds.gettext()));    
                    }  

                    else if (addchilds.getname() == 'EXTENSION2')  {

                        OnboardingReq.Telebox__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Telebox__c'),String.valueOf(addchilds.gettext()));    
                    }  

                    else if (addchilds.getname() == 'URI_SRCH')  {

                        OnboardingReq.Website__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Website__c'),String.valueOf(addchilds.gettext()));    

                    } 
                    else if (addchilds.getname() == 'COUNTRY')  {

                        OnboardingReq.Existing_Country__c = addchilds.gettext();
                        OnboardingReq.Sold_to_Country__c = addchilds.gettext();

                        fieldmodifiedmap.put(string.valueof('Sold_to_Country__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'STRAS')  {

                        OnboardingReq.Sold_to_Street__c = addchilds.gettext();
                        OnboardingReq.Existing_Street__c = addchilds.gettext();

                        fieldmodifiedmap.put(string.valueof('Sold_to_Street__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'POST_CODE1')  {

                        OnboardingReq.Existing_Postal_Code__c = addchilds.gettext();
                        OnboardingReq.Sold_to_Postal_Code__c = addchilds.gettext();

                        fieldmodifiedmap.put(string.valueof('Sold_to_Postal_Code__c'),String.valueOf(addchilds.gettext()));    

                    }

                    else if (addchilds.getname() == 'PO_BOX_LOC')  {

                        OnboardingReq.P_O_Box_City__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('P_O_Box_City__c'),String.valueOf(addchilds.gettext()));    

                    }

                    else if (addchilds.getname() == 'LCL_LANGU')  {

                        OnboardingReq.Local_Language_Country__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_Country__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_NAME1')  {

                        OnboardingReq.Local_Customer_Name_1__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Customer_Name_1__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_NAME2')  {

                        OnboardingReq.Local_Customer_Name_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Customer_Name_2__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_NAME3')  {

                        OnboardingReq.Local_Customer_Name_3__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Customer_Name_3__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if(addchilds.getname() == 'LCL_NAME4')  {

                        OnboardingReq.Local_Customer_Name_4__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Customer_Name_4__c'),String.valueOf(addchilds.gettext()));    
                    }
                    else if (addchilds.getname() == 'LCL_EXTENSION1')  {

                        OnboardingReq.Local_language_Data_line__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_language_Data_line__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_CITY2')  {

                        OnboardingReq.Local_Language_city__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_city__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_HOUSE_NUM1')  {

                        OnboardingReq.Local_Language_Office_House_Number__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_Office_House_Number__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_POST_CODE1')  {

                        OnboardingReq.Local_Language_Postal_Code__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_Postal_Code__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_REGION')  {

                        OnboardingReq.Local_Language_Region__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_Region__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_SORT1')  {

                        OnboardingReq.Local_language_Search_Terms__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_language_Search_Terms__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'EXTENSION1')  {

                        OnboardingReq.Data_line__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Data_line__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'LCL_STREET')  {

                        OnboardingReq.Local_Language_Street__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_Street__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_EXTENSION2')  {

                        OnboardingReq.Local_language_Telebox__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_language_Telebox__c'),String.valueOf(addchilds.gettext()));    

                    }
                    else if (addchilds.getname() == 'LCL_CITY1')  {

                        OnboardingReq.Local_Language_City__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Local_Language_City__c'),String.valueOf(addchilds.gettext()));    

                    }
                }

            }
        } catch (exception e) {
            System.debug('Something went wrong in the AddressDataChilds ----- ');
        }   
    }


    /**
     * Name: getCompanyDataFields 
     * Params: dom.XmlNode[] companyDataChilds 
     * Description: Method to parse the filds of the companyData node in the response xml.  
     */     

    public void getCompanyDataFields ( dom.XmlNode[] companyDataChilds ){      

        try {  
            for(Dom.XmlNode addchilds: companyDataChilds) {   
                if(addchilds.getname() != null) {
                    system.debug('child get name'+addchilds.getname() + 'get text' + addchilds.gettext()+';');
                    if (addchilds.getname() == 'BUKRS')  {
                        OnboardingReq.Existing_Company_Code__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Existing_Company_Code__c'),String.valueOf(addchilds.gettext()));    
                    }  
                    else if (addchilds.getname() == 'ZUAWA')  {

                        OnboardingReq.Sort_key__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sort_key__c'),String.valueOf(addchilds.gettext()));  
                    }  
                    else if (addchilds.getname() == 'BUSAB')  {

                        OnboardingReq.Accounting_Clerk__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Accounting_Clerk__c'),String.valueOf(addchilds.gettext()));  
                    }  
                    else if (addchilds.getname() == 'AKONT')  {

                        OnboardingReq.Reconciliation_account__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Reconciliation_account__c'),String.valueOf(addchilds.gettext()));  
                    }  
                    else if (addchilds.getname() == 'KNRZE')  {

                        OnboardingReq.Head_office__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Head_office__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'ZWELS')  {

                        OnboardingReq.Payment_Method__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Payment_Method__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'VZSKZ')  {

                        OnboardingReq.Interest_indicator__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Interest_indicator__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'ZINRT')  {

                        OnboardingReq.Interest_Cycle__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Interest_Cycle__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'EIKTO')  {

                        OnboardingReq.Account_at_customer__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Account_at_customer__c'),String.valueOf(addchilds.gettext()));  
                    }                                                

                    else if (addchilds.getname() == 'KVERM')  {

                        OnboardingReq.Account_Memo__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Account_Memo__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'FDGRV')  {

                        OnboardingReq.Approved_Cash_Management_Group__c = addchilds.gettext();
                        OnboardingReq.Proposed_Cash_Management_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Cash_Management_Group__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'XAUSZ')  {

                        OnboardingReq.Bank_Statement__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Bank_Statement__c'),String.valueOf(addchilds.gettext()));  
                    }  
                    else if (addchilds.getname() == 'LOCKB')  {

                        OnboardingReq.Lockbox__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Lockbox__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'XEDIP')  {

                        OnboardingReq.Payment_advice_by_EDI__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Payment_advice_by_EDI__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'GUZTE')  {

                        OnboardingReq.Approved_Credit_Term_Type__c = addchilds.gettext();
                        OnboardingReq.Proposed_Credit_Term_Type__c = addchilds.gettext();
                        OnboardingReq.Existing_Approved_Credit_Term_Type__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Credit_Term_Type__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'GRICD')  {

                        OnboardingReq.Activity_Code__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Activity_Code__c'),String.valueOf(addchilds.gettext()));  
                    }
                    else if (addchilds.getname() == 'GRIDT')  {

                        OnboardingReq.Distribution_Type__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Distribution_Type__c'),String.valueOf(addchilds.gettext()));  
                    }
                }
            }
        } catch (exception e){
            System.debug ('Something went wrong in the companyDataChilds ------');
        }
    } 

    /**
     * Name: getPersonalDataFields 
     * Params: dom.XmlNode[] personalDataChilds 
     * Description: Method to parse the filds of the PersonalData node in the response xml.  
     */     

    public void getPersonalDataFields ( dom.XmlNode[] personalDataChilds ){      

        try {  
            for(Dom.XmlNode addchilds: personalDataChilds) {   
                if(addchilds.getname() != null) {
                    system.debug('child get name'+addchilds.getname() + 'get text' + addchilds.gettext()+';');
                    if (addchilds.getname() == 'BAHNE')  {

                        OnboardingReq.Express_Station__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Express_Station__c'),String.valueOf(addchilds.gettext()));   
                    }  

                    else if (addchilds.getname() == 'BAHNS')  {

                        OnboardingReq.Train_Station__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Train_Station__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'BBBNR')  {
                        OnboardingReq.Location_No_1__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Location_No_1__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'BRSCH')  {

                        OnboardingReq.Industry__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Industry__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'BUBKZ')  {

                        OnboardingReq.Check_Digit__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Check_Digit__c'),String.valueOf(addchilds.gettext()));   
                    }

                    else if (addchilds.getname() == 'FISKN')  {

                        OnboardingReq.Fiscal_address__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Fiscal_address__c'),String.valueOf(addchilds.gettext()));   
                    }

                    else if (addchilds.getname() == 'KUKLA')  {

                        OnboardingReq.Customer_Segment__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Segment__c'),String.valueOf(addchilds.gettext()));   
                    }                                                
                    else if (addchilds.getname() == 'LIFNR')  {

                        OnboardingReq.Vendor__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Vendor__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'SPRAS')  {
                        OnboardingReq.Customer_language__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_language__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'STCD1')  {

                        OnboardingReq.Tax_Code_1__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Tax_Code_1__c'),String.valueOf(addchilds.gettext()));   
                    }  
                   
                    
                    else if (addchilds.getname() == 'STCD2')  {

                        OnboardingReq.Tax_Code_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Tax_Code_2__c'),String.valueOf(addchilds.gettext()));   
                    }   
                    else if (addchilds.getname() == 'STKZA')  {

                        OnboardingReq.Equalization_Tax__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Equalization_Tax__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'STKZU')  {

                        OnboardingReq.Sales_Purchase_Tax__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Sales_Purchase_Tax__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'STCEG')  {

                        OnboardingReq.Vat_Number__c = addchilds.gettext(); 
                        fieldmodifiedmap.put(string.valueof('Vat_Number__c'),String.valueOf(addchilds.gettext()));                          
                    }  
                    else if (addchilds.getname() == 'VBUND')  {

                        OnboardingReq.Trading_Partner__c = addchilds.gettext(); 
                        fieldmodifiedmap.put(string.valueof('Trading_Partner__c'),String.valueOf(addchilds.gettext()));                          
                    } 
                    else if (addchilds.getname() == 'KATR5')  {

                        OnboardingReq.Customer_Type__c = addchilds.gettext(); 
                        fieldmodifiedmap.put(string.valueof('Customer_Type__c'),String.valueOf(addchilds.gettext()));                           
                    }
                    else if (addchilds.getname() == 'STKZN')  {

                        OnboardingReq.Natural_Person__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Natural_Person__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'FITYP')  {

                        OnboardingReq.Tax_Category__c = addchilds.gettext();  
                        fieldmodifiedmap.put(string.valueof('Tax_Category__c'),String.valueOf(addchilds.gettext()));                        
                    }
                    else if (addchilds.getname() == 'STCDT')  {

                        OnboardingReq.Tax_Number_Category__c = addchilds.gettext(); 
                        fieldmodifiedmap.put(string.valueof('Tax_Number_Category__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'STCD3')  {

                        OnboardingReq.Tax_Code_3__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Tax_Code_3__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'STCD4')  {

                        OnboardingReq.Tax_Code_4__c = addchilds.gettext();  
                        fieldmodifiedmap.put(string.valueof('Tax_Code_4__c'),String.valueOf(addchilds.gettext()));   
                    }

                    else if (addchilds.getname() == 'STCD5')  {     
                        //<Santhosh20151127> Added for tax code 5 new field for china.      
                        OnboardingReq.Tax_number_5__c = addchilds.gettext();        
                        fieldmodifiedmap.put(string.valueof('Tax_number_5__c'),String.valueOf(addchilds.gettext()));        
                    } 

                    else if (addchilds.getname() == 'J_1KFTBUS')  {

                        OnboardingReq.Business_Type__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Business_Type__c'),String.valueOf(addchilds.gettext()));   
                    }  


                    else if (addchilds.getname() == 'TEL_NUMBER')  {

                        OnboardingReq.Sold_to_Telephone__c = addchilds.gettext();
                        OnboardingReq.Existing_Telephone__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sold_to_Telephone__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'TTX_NUMBER')  {

                        OnboardingReq.Teletex_Number__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Teletex_Number__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'TLX_NUMBER')  {

                        OnboardingReq.Telex_Number__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Telex_Number__c'),String.valueOf(addchilds.gettext()));   
                    }     
                    else if (addchilds.getname() == 'KTOKD')  {

                        OnboardingReq.Account_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Account_Group__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'BBSNR')  {

                        OnboardingReq.Location_No_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Location_No_2__c'),String.valueOf(addchilds.gettext()));   
                    }
                }
            }
        } catch (exception e){
            System.debug ('Something went wrong in the personalDataChilds ------');
        }
    } 


    /**
     * Name: getSalesDataFields 
     * Params: dom.XmlNode[] salesDataChilds 
     * Description: Method to parse the filds of the SalesData node in the response xml.  
     */   

    public void getSalesDataFields ( dom.XmlNode[] salesDataChilds ){      

        try {  
            for(Dom.XmlNode addchilds: salesDataChilds) {  
                if(addchilds.getname() != null){    
                    system.debug('child get name'+addchilds.getname() + 'get text' + addchilds.gettext()+';');
                    if (addchilds.getname() == 'VKORG')  {

                        OnboardingReq.Existing_Sales_Organization__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Existing_Sales_Organization__c'),String.valueOf(addchilds.gettext()));   
                    }  

                    else if (addchilds.getname() == 'BEGRU')  {

                        OnboardingReq.Authorization_group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Authorization_Group__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'VERSG')  {

                        OnboardingReq.Customer_Statistics_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Statistics_Group__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KALKS')  {

                        OnboardingReq.Customer_Price_Procedure__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Price_Procedure__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'BZIRK')  {

                        OnboardingReq.Sales_District__c = addchilds.gettext();
                        OnboardingReq.Existing_Sales_district__c =addchilds.getText();
                        fieldmodifiedmap.put(string.valueof('Sales_District__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KONDA')  {

                        OnboardingReq.Price_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Price_Group__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'AWAHR')  {

                        OnboardingReq.Order_Probability__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Order_Probability__c'),String.valueOf(addchilds.gettext()));    

                    }  
                    else if (addchilds.getname() == 'ANTLF')  {

                        OnboardingReq.Maximum_Partial_Deliveries__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Maximum_Partial_Deliveries__c'),String.valueOf(addchilds.gettext())); 
                    }
                    else if (addchilds.getname() == 'AUTLF')  {
                        OnboardingReq.Complete_Delivery_Required_by_Law__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Complete_Delivery_Required_by_Law__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KZTLF')  {

                        OnboardingReq.Partial_Delivery_per_Item__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Partial_Delivery_per_Item__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KZAZU')  {

                        OnboardingReq.Order_Combination__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Order_Combination__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'LPRIO')  {

                        OnboardingReq.Delivery_priority__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Delivery_priority__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'VSBED')  {

                        OnboardingReq.Default_Shipping_Conditions__c = addchilds.gettext();
                        OnboardingReq.Existing_Shipping_Conditions__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Default_Shipping_Conditions__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'MRNKZ')  {

                        OnboardingReq.Subs_Invoice_Processing__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Subs_Invoice_Processing__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'PERFK')  {

                        OnboardingReq.Invoicing_Dates__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Invoicing_Dates__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'PERRL')  {

                        OnboardingReq.Invoicing_List_Dates__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Invoicing_List_Dates__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KLABC')  {

                        OnboardingReq.ABC_Class__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('ABC_Class__c'),String.valueOf(addchilds.gettext()));   
                    }   
                    else if (addchilds.getname() == 'KTGRD')  {

                        OnboardingReq.Account_Assignment_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Account_Assignment_Group__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZTERM')  {


                        OnboardingReq.Approved_Terms_of_Payment__c = addchilds.gettext();
                        OnboardingReq.Existing_Approved_Terms_of_Payment__c = addchilds.gettext();
                        OnboardingReq.Proposed_Terms_of_Payment__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Proposed_Terms_of_Payment__c'),String.valueOf(addchilds.gettext()));     
                    }
                    else if (addchilds.getname() == 'VWERK')  {

                        OnboardingReq.Delivery_plant__c = addchilds.gettext();
                        OnboardingReq.Existing_Delivery_Plant__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Delivery_plant__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'VKGRP')  {

                        OnboardingReq.Sales_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sales_Group__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'VSORT')  {

                        OnboardingReq.Item_Proposal__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Item_Proposal__c'),String.valueOf(addchilds.gettext()));   
                    }   
                    else if (addchilds.getname() == 'BOKRE')  {

                        OnboardingReq.Rebates__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Rebates__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KURST')  {

                        OnboardingReq.Exchange_Rate_type__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Exchange_Rate_type__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'PRFRE')  {

                        OnboardingReq.Price_Determination__c = Boolean.valueof(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Price_Determination__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KABSS')  {

                        OnboardingReq.Payment_Guarantee_Procedure__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Payment_Guarantee_Procedure__c'),String.valueOf(addchilds.gettext()));   
                    }                   
                    else if (addchilds.getname() == 'KKBER')  {

                        OnboardingReq.Credit_Control_Area__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Credit_Control_Area__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'RDOFF')  {

                        OnboardingReq.Switch_Off_Rounding__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Switch_Off_Rounding__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'AGREL')  {

                        OnboardingReq.Relevant_for_Agency_Business__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Relevant_for_Agency_Business__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'MEGRU')  {

                        OnboardingReq.Units_Group__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Units_Group__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'UEBTO')  {

                        OnboardingReq.Overdelivery_Tolerance__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Overdelivery_Tolerance__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'UNTTO')  {

                        OnboardingReq.Underdelivery_Tolerance__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Underdelivery_Tolerance__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'UEBTK')  {

                        OnboardingReq.Unlimited_Tolerance__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Unlimited_Tolerance__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'PVKSM')  {

                        OnboardingReq.Product_Proposal_for_Customer_Procedure__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Product_Proposal_for_Customer_Procedure__c'),String.valueOf(addchilds.gettext()));   
                    }  
                    else if (addchilds.getname() == 'PODKZ')  {

                        OnboardingReq.Relevant_for_POD__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Relevant_for_POD__c'),String.valueOf(addchilds.gettext()));   
                    }   
                    else if (addchilds.getname() == 'PODTG')  {

                        OnboardingReq.POD_Timeframe__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('POD_Timeframe__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZZSLOC')  {

                        OnboardingReq.Receiving_Storage_Location__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Receiving_Storage_Location__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZZ00ORGBOL')  {

                        OnboardingReq.Number_of_Org_Bills_of_Lading__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Number_of_Org_Bills_of_Lading__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZZ00CPYBOL')  {

                        OnboardingReq.Number_of_Copies_of_Bills_of_Lading__c = Decimal.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Number_of_Copies_of_Bills_of_Lading__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZZ00CPBKMSG')  {

                        OnboardingReq.Copy_of_Booking_Message__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Copy_of_Booking_Message__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'ZZDUTYIND')  { 
                        OnboardingReq.Duty_Indicator__c = Boolean.valueOf(addchilds.gettext());
                        fieldmodifiedmap.put(string.valueof('Duty_Indicator__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else  if (addchilds.getname() == 'ZZONBYDATE')  {

                        OnboardingReq.Data_Type_on_Delivery__c = addchilds.gettext(); // TO be checked
                        fieldmodifiedmap.put(string.valueof('Data_Type_on_Delivery__c'),String.valueOf(addchilds.gettext()));           
                    }

                    else if (addchilds.getname() == 'SHIPPING_INSTR')  {

                        OnboardingReq.Shipping_Instruction__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Shipping_Instruction__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'WAREHOUSE_INSTR')  {

                        OnboardingReq.Warehouse_instruction__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Warehouse_instruction__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'INCO1')  {

                        OnboardingReq.Existing_Incoterms_1__c = addchilds.gettext();
                        OnboardingReq.Default_Incoterms_1__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Default_Incoterms_1__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'INCO2')  {

                        OnboardingReq.Default_Incoterms_2__c = addchilds.gettext();
                        OnboardingReq.Existing_Incoterms_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Default_Incoterms_2__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KVGR1')  {

                        OnboardingReq.Customer_group_1__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_group_1__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KVGR2')  {

                        OnboardingReq.Customer_Group_2__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Group_2__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KVGR3')  {

                        OnboardingReq.Customer_Group_3__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_Group_3__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KVGR4')  {

                        OnboardingReq.Customer_group_4__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_group_4__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'KVGR5')  {

                        OnboardingReq.Customer_group_5__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Customer_group_5__c'),String.valueOf(addchilds.gettext()));   
                    }
                    else if (addchilds.getname() == 'PLTYP')  {

                        OnboardingReq.Price_List_Type__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Price_List_Type__c'),String.valueOf(addchilds.gettext()));   
                    }

                    else if (addchilds.getname() == 'VKBUR')  {

                        OnboardingReq.Sales_Office__c = addchilds.gettext();
                        fieldmodifiedmap.put(string.valueof('Sales_Office__c'),String.valueOf(addchilds.gettext()));   
                    }

                }
            }
        } catch (exception e){
            System.debug ('Something went wrong in the salesDataChilds ------');
        }
    }             



    /**
     * Name: getTaxGroupingsFields 
     * Params: dom.XmlNode[] taxGroupingsChilds 
     * Description: Method to parse the filds of the TaxGroupings node in the response xml.  
     */     

    public void getTaxGroupingsFields ( dom.XmlNode[] taxGroupingsChilds ){      

        try {  
            for(Dom.XmlNode addchilds: taxGroupingsChilds) {   

                if (addchilds.getname() == 'TAXGR')  {
                    if(addchilds.getname() != null) 
                        OnboardingReq.Argentina_Tax_Categories__c = addchilds.gettext();
                }  

            }
        } catch (exception e){
            System.debug ('Something went wrong in the taxGroupingsChilds ------');
        }
    } 



    /**
     * Name: populateExistingCustomerInformation
     * Params: None
     * Description: Method will be called On Page Load to copy ERP Customer details in Request.
     */
    public void populateExistingCustomerInformation(){
        ERP_Customer__c extCust = new ERP_customer__c();
        ERP_Customer__c genCust = new ERP_customer__c();

        if(String.valueOf(OnboardingReq.Customer__c) != null && String.valueOf(OnboardingReq.Customer__c) != ''){

            extCust  = fetchCustomerInformation(OnboardingReq.Customer__c);
            if(String.ValueOf(OnboardingReq.RecordTypeId) != Miscellaneous_COB_RTYPE ||(String.ValueOf(OnboardingReq.RecordTypeId) != Partner_COB_RTYPE) ){
                OnboardingReq.Account_Group__c=extCust.Account_Group__c;
            }
            if(String.ValueOf(OnboardingReq.RecordTypeId)!= Miscellaneous_COB_RTYPE && String.ValueOf(OnboardingReq.RecordTypeId)!= NewCustomerCreation_COB_RTYPE){
                if(OnboardingReq.RecordTypeId != ModifyExisting_COB_RTYPE && OnboardingReq.RecordTypeId != ExtendExisting_COB_RTYPE){
                    if(extCust.Name!=null)OnboardingReq.Customer_Name__c = extCust.Name;
                }
                if(OnboardingReq.RecordTypeId != ExtendExisting_COB_RTYPE){  //<Alvin20150623> changed onboarding to string for extend scenario.
                    if(extCust.Customer_Name_2__c!=null)OnboardingReq.Customer_Name_2__c = extCust.Customer_Name_2__c;
                    if(extCust.PO_Box__c!=null)OnboardingReq.P_O_Box__c = extCust.PO_Box__c;
                    if(extCust.Street__c!=null)OnboardingReq.Existing_Street__c = extCust.Street__c;
                    if(extCust.City__c!=null)OnboardingReq.Existing_City__c = extCust.City__c;
                    if(extCust.ZIP_Postal_Code__c!=null)OnboardingReq.Existing_Postal_Code__c = extCust.ZIP_Postal_Code__c;
                    if(extCust.State_Province__c!=null && genCust.State__c!=null )OnboardingReq.Existing_State_Province__c = extCust.State_Province__c+' - '+genCust.State__c;
                    if(extCust.Country_Code__c!=null && extCust.Country__c!=null)OnboardingReq.Existing_Country__c = extCust.Country_Code__c+' - '+extCust.Country__c;
                    if(extCust.Incoterms_1_Code__c!=null && extCust.Incoterms_1__c!=null )OnboardingReq.Existing_Incoterms_1__c = extCust.Incoterms_1_Code__c+' - '+extCust.Incoterms_1__c;
                    if(extCust.Incoterms_2__c!=null)OnboardingReq.Existing_Incoterms_2__c = extCust.Incoterms_2__c;
                    if(extCust.DUNS_Number__c!=null)
                        OnboardingReq.DUNS_Number__c = String.ValueOf(extCust.DUNS_Number__c);
                    if(extCust.Terms_of_Payment__c!=null)OnboardingReq.Existing_Approved_Terms_of_Payment__c = extCust.Terms_of_Payment__c;
                    if(extCust.Sales_Org_Code__c!=null && extCust.Sales_Org__c!=null)OnboardingReq.Existing_Sales_Organization__c = extCust.Sales_Org_Code__c+' - '+extCust.Sales_Org__c;
                }
                if(OnboardingReq.Account_Group__c =='Z001 ( Sold-to party )'){
                    OnboardingReq.Sold_To_Customer_Number__c = extCust.Customer_Code__c;
                    OnboardingReq.Existing_Appr_Credit_Lmt_Currency_Code__c = extCust.Currency_Code__c;
                    OnboardingReq.Customer_Number__c = extCust.Customer_Code__c;
                }
                else{
                    genCust = fetchCustomerInformation(requestorAccount.ERP_Customer__c);
                    OnboardingReq.Sold_To_Customer_Number__c = genCust.Customer_Code__c;
                    OnboardingReq.Customer_Number__c = extCust.Customer_Code__c;
                }
                //<Alvin20150618> For extend ship to / bill to customer number and customer account group should be populated
                if(currentURLParameters.get('Search') == 'Extend' && fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c != 'Z001 ( Sold-to party )'){
                    OnboardingReq.Extended_Account_Group__c=fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Account_Group__c;
                    OnboardingReq.Customer_Number__c = fetchCustomerInformation(id.valueOf(currentURLParameters.get('ERPCustomer'))).Customer_Code__c;
                }
                if(OnboardingReq.RecordTypeId == ExtendExisting_COB_RTYPE){//<Nishant20150807>Copying concatenated Existing Country to Sold To Country  
                    if(extCust.Country_Code__c!=null && extCust.Country__c!=null)OnboardingReq.Existing_Country__c = extCust.Country_Code__c+' - '+extCust.Country__c;
                    OnboardingReq.Sold_to_Country__c = OnboardingReq.Existing_Country__c;
                }
            }  
        }
    }

    /**
     * Name: checkPOD
     * Params: None
     * Description: Method is called when Relevant_for_POD__c is clicked
     */

    public void checkPOD(){
        if(String.ValueOF(OnboardingReq.RecordTypeId)== NewCustomerCreation_COB_RTYPE && Apexpages.currentPage().getParameters().get('EighthParam')+''!='null' && Apexpages.currentPage().getParameters().get('EighthParam')+''=='1'){
            if(OnboardingReq.Relevant_for_POD__c==false){
                OnboardingReq.Relevant_for_POD__c = True;
            }
            else if(OnboardingReq.Relevant_for_POD__c = True){
                OnboardingReq.Relevant_for_POD__c = false;
            }
        }

        if(OnboardingReq.Relevant_for_POD__c== True){
            openPODtimeframe = true;
        }
        else{
            openPODtimeframe = false;
        }
    }


    /**
     * Name: Validations
     * Params: None
     * Description: Method to validate Request before Saving and submitting.
     */ 
    public void Validations(){
        String Division;
        String DistributionChannel;
        String GeneralERPCustomer = 'ERP Customer - General Data';
        List<ERP_Customer__c>GeneralCustList = new List<ERP_Customer__c>();

        List<ERP_Customer__c>ExtendedCustList = new List<ERP_Customer__c>();
        String ExtendedERPCustomer = 'ERP Customer - Extended Data';
        if(OnboardingReq.Division__c <> NULL && OnboardingReq.Division__c <> ''){
            Division =OnboardingReq.Division__c.substring(0,2);
        }
        if(OnboardingReq.Distribution_Channel__c <> NULL && OnboardingReq.Distribution_Channel__c <> ''){
            DistributionChannel =OnboardingReq.Distribution_Channel__c.substring(0,2) ;
        }
        if(String.ValueOF(OnboardingReq.RecordTypeId)==NewCustomerCreation_COB_RTYPE && IsClone ==false && ReqId==null ){
            //Validation 1
            GeneralCustList = [Select Id,Name,Street__c,City__c,RecordType.Name from ERP_Customer__c where RecordType.Name=:GeneralERPCustomer and  Name=:OnboardingReq.Customer_Name__c and Street__c=:OnboardingReq.Sold_to_Street__c and City__c=:OnboardingReq.Sold_to_City__c and Customer_Status__c!= : 'MFD'];

            if(GeneralCustList.size()!=0){
                this.IsError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create this request as this Customer already exists in the System. Please Check again'));

            }
            ExtendedCustList = [Select Id,Name,Street__c,City__c,RecordType.Name from ERP_Customer__c where RecordType.Name=:ExtendedERPCustomer and  Name=:OnboardingReq.Customer_Name__c and  Sales_Org_Code__c =:OnboardingReq.Sales_Organization__c and Account_Group__c=:OnboardingReq.Account_Group__c and Division_Code__c=:Division and Distribution_Channel_Code__c=:DistributionChannel and Customer_Status__c!= : 'MFD'];
            if(ExtendedCustList.size()!=0){
                this.IsError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create this customer as ERP customer with same data already Exists.'));

            }
        }
        
        //Validation 2   //<Santhosh 20160706> added 'DuPont CDR Users - ANZ' group condition
                        //<Bhargavi 20160919> added 'DuPont CDR Users - ASEAN' group condition
        if(IsSaveOrSubmit == 'Submit' && OnboardingReq.Existance_Verified__c==false  && (lst_GrpName.contains('DuPont CDR Users - Thailand') || lst_GrpName.contains('DuPont CDR Users - India') || lst_GrpName.contains('DuPont CDR Users - ANZ') || lst_GrpName.contains('Dupont CDR Users - ASEAN') || lst_GrpName.contains('DuPont CDR Users - Hong Kong')
                ||lst_GrpName.contains('DPP Customer Service Reps') || lst_GrpName.contains('DPT Customer Service Reps')  || lst_GrpName.contains('DCP Customer Service Reps')
                || lst_GrpName.contains('P&IP Customer Service Reps')  || lst_GrpName.contains('DSS Customer Service Reps') || lst_GrpName.contains('BI Customer Service Reps')
                || lst_GrpName.contains('N&H Customer Service Reps') || lst_GrpName.contains('DEC Customer Service Reps') || lst_GrpName.contains('IB Customer Service Reps')
                || lst_GrpName.contains('Customer On-boarding Levrg CSR - China') || lst_GrpName.contains('DuPont CDR Users - China')|| (ProfileName == 'System Administrator'))
                && String.ValueOF(OnboardingReq.RecordTypeId)==NewCustomerCreation_COB_RTYPE){
            if((OnboardingReq.Leveraged_CSR__c == false && OnboardingReq.Assigned_to_Leverage_CSR__c == false) || (OnboardingReq.Leveraged_CSR__c == true && OnboardingReq.Assigned_to_Leverage_CSR__c == true)){
                this.IsError = true;
                OnboardingReq.Existance_Verified__c.addError('Please perform an existence check before request submission.');
            }
        }
        //Validation 3....
        //for LocalLg_House_State_Mandatory
        // <Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')
        // <Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && 
                (CDRCountry=='CN - China') && 
                OnboardingReq.Local_Version__c == '--None--' &&
                (OnboardingReq.Local_Language_Office_House_Number__c =='' || OnboardingReq.Local_Language_Office_House_Number__c == null))//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
        {
            this.IsError = true;
            OnboardingReq.Local_Language_Office_House_Number__c.addError('Local Language House/office is mandatory');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Local Language House/office is mandatory'));
        }
        //Code for Non_Standard_Terms_is_Mandatory
        if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE || (OnboardingReq.RecordTypeId == ExtendExisting_COB_RTYPE && OnboardingReq.Extended_Account_Group__c!='' && OnboardingReq.Extended_Account_Group__c!=null && !OnboardingReq.Extended_Account_Group__c.contains('Z002') && !OnboardingReq.Extended_Account_Group__c.contains('Z004')) || OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE)&& 
                OnboardingReq.Proposed_Terms_of_Payment__c == 'Other' && 
                (OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c == '' || OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c == null) )

        {    this.IsError = true;
        OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c.addError('Non Standard Terms of Payment is Mandatory when Terms of Payment is selected as Other');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Non Standard Terms of Payment is Mandatory when Terms of Payment is selected as Other'));
        }
        //Code for Postal_Code_and_Region_Mandatory_China
        //<Nishant20150615> state/province mandatory for china
        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Sold_to_Country__c=='CN - China' &&
                (OnboardingReq.Sold_to_State_Province__c =='' ||OnboardingReq.Sold_to_State_Province__c ==null))

        {    this.IsError = true;
        OnboardingReq.Sold_to_State_Province__c.addError('You must enter a value');

        }
        //<Tarun20151001> Enhancement Duplicate Check during exteding customer
        if(String.ValueOF(OnboardingReq.RecordTypeId)==ExtendExisting_COB_RTYPE) {
           ERP_Customer__c custName;
            if(OnboardingReq.Extended_Account_Group__c==null){                        
                custName=[Select id, Name From ERP_Customer__c where id=:OnboardingReq.Customer__c];
            }
            else if(currentURLParameters.get('Id')=='null'){
                custname=[Select name From ERP_Customer__c where id=:currentURLParameters.get('ERPCustomer')];
            }  
            if(custname != null){
                ExtendedCustList = [Select Id,Name,Street__c,City__c,RecordType.Name from ERP_Customer__c where RecordType.Name=:ExtendedERPCustomer and  Sales_Org_Code__c =:OnboardingReq.Sales_Organization__c and Division_Code__c=:Division and Distribution_Channel_Code__c=:DistributionChannel and Customer_General_Data__c=:custname.id];
                if(ExtendedCustList.size()!=0){
                    this.IsError = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot extend this customer as ERP customer is already extended in requested sales Org'));   //<Gerard20160524> changed the error description
                }
            }   
        }
        //<Tarun20151001> End

    }

    /**
     * Name: RequiredValidations
     * Params: None
     * Description: 
     */ 
    public Void RequiredValidations(){
        isRequireddataline=false;
        isRequiredteletex=false;
        isRequiredtelebox=false;
        isRequiredSoldtoOffice=false;
        isProposedLimitCurrency=false;

        if(OnboardingReq.Proposed_Terms_of_Payment__c !='CIA-Payment in Advance'){
            if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE || (OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE &&(OnboardingReq.Account_Group__c !='Z002 ( Ship-to party )') && (OnboardingReq.Proposed_Credit_Limit__c !=null && OnboardingReq.Proposed_Credit_Limit__c !=''))|| (OnboardingReq.RecordTypeId == ExtendExisting_COB_RTYPE && OnboardingReq.Extended_Account_Group__c!='' && OnboardingReq.Extended_Account_Group__c!=null && !OnboardingReq.Extended_Account_Group__c.contains('Z002') && !OnboardingReq.Extended_Account_Group__c.contains('Z004'))){
                try{
                    Decimal ProposedCreditLimit = Decimal.valueOf(OnboardingReq.Proposed_Credit_Limit__c);
                    if(ProposedCreditLimit<=0){
                        this.IsError = true;
                        OnboardingReq.Proposed_Credit_Limit__c.addError('Proposed Credit Limit Can contain Only numbers which should be Greater then Zero');
                    }
                }
                Catch(Exception e){
                    this.IsError = true;
                    OnboardingReq.Proposed_Credit_Limit__c.addError('Proposed Credit Limit Can contain Only numbers which should be Greater then Zero ');
                }
            }
        }
        // <Nishanth.H 15092015> Added for R02 enhancement-Updating selling company code value('1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.')
        // <Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Sold_to_Country__c=='CN - China' && OnboardingReq.Customer_Currency__c =='CNY - Chinese Renminbi' && (CDRCountry=='CN - China') && OnboardingReq.Invoice_Type__c=='VAT' &&(OnboardingReq.Data_line__c==''||OnboardingReq.Data_line__c==null) ){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
            this.IsError = true;
            isRequireddataline = true;
            OnboardingReq.Data_line__c.addError('Data Line is mandatory for the selected Country.');
        }  
        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Sold_to_Country__c=='CN - China' && OnboardingReq.Customer_Currency__c =='CNY - Chinese Renminbi' && (CDRCountry=='CN - China') && OnboardingReq.Invoice_Type__c=='VAT' &&(OnboardingReq.Telebox__c==''||OnboardingReq.Telebox__c==null)){ //<Alvin20150824> Added 1310 selling company code for enhancement LE1310
            this.IsError = true;
            isRequiredteletex = true;
            OnboardingReq.Telebox__c.addError('Telebox Number is mandatory for the selected Country.');
        } 


        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Sold_to_Country__c=='CN - China' && OnboardingReq.Customer_Currency__c =='CNY - Chinese Renminbi' && (CDRCountry=='CN - China') && OnboardingReq.Invoice_Type__c=='VAT'  && (OnboardingReq.Teletex_Number__c==''||OnboardingReq.Teletex_Number__c==null)){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
            this.IsError = true;
            isRequiredtelebox = true;
            OnboardingReq.Teletex_Number__c.addError('Teletex number is mandatory for the selected Country.');
        }

    //<Santhosh20160419> modified condition for Tax code1 for Thailand-(IS ID-00067840)    
    //<Bhargavi 20160919> made tax code 1 , registration numbers,sol_to_email and Sold_to_telephone mandatory for ASEAN Countries
        if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Request_Status__c !='Request Completed in SAP') && (OnboardingReq.Sold_to_Country__c=='TH - Thailand' || 
                (OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte')||
                (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA')|| 
                (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines') ||
                (OnboardingReq.Sold_to_Country__c=='VN - Vietnam' && OnboardingReq.Company_Code__c=='0514 - DuPont Vietnam Ltd.') )  && 
                (OnboardingReq.Tax_code_1__c==''||OnboardingReq.Tax_code_1__c==null)){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310      
            this.IsError = true;        
            OnboardingReq.Tax_code_1__c.addError('Tax Code 1 is mandatory for the selected Country.');      
        }
        
    if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Request_Status__c !='Request Completed in SAP') && ((OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte')||
                (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA')|| 
                (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines') ||
                (OnboardingReq.Sold_to_Country__c=='VN - Vietnam' && OnboardingReq.Company_Code__c=='0514 - DuPont Vietnam Ltd.') )  && 
                (OnboardingReq.Registration_number__c==''||OnboardingReq.Registration_number__c==null)){
            this.IsError = true;        
            OnboardingReq.Registration_number__c.addError('Registration number is mandatory for the selected Country.');      
        } 
        if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE  && OnboardingReq.Request_Status__c !='Request Completed in SAP') && ((OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte')||
                (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA')|| 
                (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines') ||
                (OnboardingReq.Sold_to_Country__c=='VN - Vietnam' && OnboardingReq.Company_Code__c=='0514 - DuPont Vietnam Ltd.') ) &&
                (OnboardingReq.Sold_to_Telephone__c==''||OnboardingReq.Sold_to_Telephone__c==null)){
            this.IsError = true;        
            OnboardingReq.Sold_to_Telephone__c.addError('Sold_to_Telephone__c number is mandatory for the selected Country.');      
        }
       

        if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Request_Status__c !='Request Completed in SAP') && ((OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte')||
                (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA')|| 
                (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines') ||
                (OnboardingReq.Sold_to_Country__c=='VN - Vietnam' && OnboardingReq.Company_Code__c=='0514 - DuPont Vietnam Ltd.') )  &&
                 (OnboardingReq.Sold_to_e_mail__c==''||OnboardingReq.Sold_to_e_mail__c==null)){
            this.IsError = true;   
                 
            OnboardingReq.Sold_to_e_mail__c.addError('Sold_to_e_mail__c number is mandatory for the selected Country.');      
        }
        if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Request_Status__c !='Request Completed in SAP') && ((OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte')||
                (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA')|| 
                (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines') ||
                (OnboardingReq.Sold_to_Country__c=='VN - Vietnam' && OnboardingReq.Company_Code__c=='0514 - DuPont Vietnam Ltd.') )  && 
                (OnboardingReq.Customer_Contact_Name__c==''||OnboardingReq.Customer_Contact_Name__c==null)){
            this.IsError = true;        
            OnboardingReq.Customer_Contact_Name__c.addError('Customer Contact Name is mandatory for the selected Country.');      
        } 
        
        

        //<Santhosh20151127> Added validation for new field tax number 5  for china.
                  else if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && ((OnboardingReq.Sold_to_Country__c=='CN - China' && OnboardingReq.Customer_Currency__c =='CNY - Chinese Renminbi' && (OnboardingReq.Company_Code__c=='0078 - ELECT. MATLS DUP DONGGUAN' || OnboardingReq.Company_Code__c=='0218 - DuPont Trading Shanghai' || OnboardingReq.Company_Code__c=='0701 - DUP AGRIC CHEM LTD' || OnboardingReq.Company_Code__c=='1131 - Du Pont China Holding Co.' || OnboardingReq.Company_Code__c=='1132 - DuPont(China) RD and Mgmt' || OnboardingReq.Company_Code__c=='1142 - DUP SURFCE GUANGZHOU' || OnboardingReq.Company_Code__c=='1210 - DUP (SHENZHEN) INDUS' || OnboardingReq.Company_Code__c=='2791 - Du Pont China Holding Co.' || OnboardingReq.Company_Code__c=='1310 - DuPont Apollo (Shenzhen)') && OnboardingReq.Invoice_Type__c=='VAT'))  && (OnboardingReq.Tax_number_5__c==''||OnboardingReq.Tax_number_5__c==null)){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
            this.IsError = true;
            OnboardingReq.Tax_number_5__c.addError('Tax number 5 is mandatory for the selected Country.');
        }

        if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE && OnboardingReq.Sold_to_Country__c=='CN - China' && (OnboardingReq.Customer_Currency__c =='CNY - Chinese Renminbi' ||(OnboardingReq.Customer_Currency__c =='USD - American Dollar' && OnboardingReq.Account_Group__c=='Z004 ( Bill-to party )')) && (CDRCountry=='CN - China') && (OnboardingReq.Invoice_Type__c=='VAT'||OnboardingReq.Invoice_Type__c=='Non-VAT')  && (OnboardingReq.Local_Version__c==''||OnboardingReq.Local_Version__c==null)){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
            this.IsError = true;
            OnboardingReq.Local_Version__c.addError('Local Version is mandatory for the selected Country.');
        }

        if(OnboardingReq.RecordTypeId == Miscellaneous_COB_RTYPE &&(OnboardingReq.Miscellaneous_Type_Intent__c==''|| OnboardingReq.Miscellaneous_Type_Intent__c=='--None--')){
            this.IsError = true;
            OnboardingReq.Miscellaneous_Type_Intent__c.addError('You must select a value');
        }

        if(OnboardingReq.Telex_Number__c!=null && string.valueOf(OnboardingReq.Telex_Number__c)!='' && ((OnboardingReq.Sold_to_Country__c=='CN - China'))){

            try {

               system.debug('Telex value is**'+OnboardingReq.Telex_Number__c);      
                OnboardingReq.Telex_Number__c = OnboardingReq.Telex_Number__c.replaceAll('-', '');
                system.debug('after epecial char removal&&'+OnboardingReq.Telex_Number__c);    
                Long TeletexCheck = Long.valueOf(OnboardingReq.Telex_Number__c);  // : <Ankit20160719 01:14 AM IST> changed typecasting of Telex number from "String to Integer" to "String to Long" as a part of issue IS ID-00071801 Code Coverage: 82% <AK 20160719 11:40 PM IST>
                

            }
            Catch (exception e) {
                system.debug('exception is***'+e);
                this.IsError = true;
                isRequiredtelebox = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Telex Number should contain only numbers'));
                OnboardingReq.Telex_Number__c.addError('Telex Number should contain only numbers');
            }
        }
        //<Alvin20151001> Added if condition for making Estimated Average Monthly Purchases and Estimated Number of Orders per Month mandatory
        
         
       if((OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE || (OnboardingReq.Credit_Approval_Required__c == true && OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE) || (OnboardingReq.RecordTypeId == ExtendExisting_COB_RTYPE && ((OnboardingReq.Extended_Account_Group__c == '' || OnboardingReq.Extended_Account_Group__c == null) ||(OnboardingReq.Extended_Account_Group__c != '' && OnboardingReq.Extended_Account_Group__c != null && (!OnboardingReq.Extended_Account_Group__c.contains('Z004') && !OnboardingReq.Extended_Account_Group__c.contains('Z002')))))) && !((OnboardingReq.Proposed_Credit_Term_Type__c=='Cash In Advance')||((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c) < MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) && (OnboardingReq.Preferred_Bank_Name__c!='Other' && OnboardingReq.Preferred_Bank_Name__c!=null))){
 
            if(string.valueof(OnboardingReq.Estimated_Average_Monthly_Purchases__c) == '' || OnboardingReq.Estimated_Average_Monthly_Purchases__c == null){
                this.IsError = true;
                OnboardingReq.Estimated_Average_Monthly_Purchases__c.addError('Estimated Average Monthly Purchases is mandatory');
            }
            if(string.valueof(OnboardingReq.Estimated_Number_of_Orders_per_Month__c) == '' || OnboardingReq.Estimated_Number_of_Orders_per_Month__c == null){
                this.IsError = true;
                OnboardingReq.Estimated_Number_of_Orders_per_Month__c.addError('Estimated Number of Orders per Month is mandatory');
            }
        }
        
       //Start of  <Bhargavi20160714>
       if(OnboardingReq.RecordTypeId == NewCustomerCreation_COB_RTYPE ||  OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE) {
        System.debug('sybstrig cust name$$');
            if(String.valueof(OnboardingReq.Customer_Name__c)!= null && (OnboardingReq.Customer_Name__c).length()>35 ){
                this.IsError = true;
                OnboardingReq.Customer_Name__c.addError('Customer Name should not be more than 35 Characters');
            }
            if(String.valueof(OnboardingReq.Customer_Name_2__c)!= null && (OnboardingReq.Customer_Name_2__c).length()>35 ){
                this.IsError = true;
                OnboardingReq.Customer_Name_2__c.addError('Customer Name2 should not be more than 35 Characters');
            }
            if(String.valueof(OnboardingReq.Customer_Name_3__c)!= null && (OnboardingReq.Customer_Name_3__c).length()>35 ){
                this.IsError = true;
                OnboardingReq.Customer_Name_3__c.addError('Customer Name3 should not be more than 35 Characters');
            }
            if(String.valueof(OnboardingReq.Customer_Name_4__c)!= null  && (OnboardingReq.Customer_Name_4__c).length()>35 ){
                
                this.IsError = true;
                system.debug('inside customer4  '+ OnboardingReq.Customer_Name_4__c);
                OnboardingReq.Customer_Name_4__c.addError('Customer Name4 should not be more than 35 Characters');
            }
           // Start of <Bhargavi 20160919>
           if (OnboardingReq.Sold_to_Country__c=='SG - Singapore' && OnboardingReq.Company_Code__c=='3874 - Du Pont Co. (Singapore) Pte' && String.valueof(OnboardingReq.Sold_to_Postal_Code__c )!=null  && (OnboardingReq.Sold_to_Postal_Code__c).length()!=6 )
           {
                this.IsError = true;
                OnboardingReq.Sold_to_Postal_Code__c.addError('Sold-to Postal Code should be 6 Digits for Singapore Country');
           }
            if (OnboardingReq.Sold_to_Country__c=='MY - Malaysia' && OnboardingReq.Company_Code__c=='3940 - DUP MALAYSIA' &&String.valueof(OnboardingReq.Sold_to_Postal_Code__c )!=null && (OnboardingReq.Sold_to_Postal_Code__c).length()!=5 )
           {
                this.IsError = true;
                OnboardingReq.Sold_to_Postal_Code__c.addError('Sold-to Postal Code should be 5 Digits for Malaysia Country');
           }
            if (OnboardingReq.Sold_to_Country__c=='PH - Philippines' && OnboardingReq.Company_Code__c=='3945 - DUFE Philippines' && String.valueof(OnboardingReq.Sold_to_Postal_Code__c )!=null && (OnboardingReq.Sold_to_Postal_Code__c).length()!=4 )
           {
                this.IsError = true;
                OnboardingReq.Sold_to_Postal_Code__c.addError('Sold-to Postal Code should be 4 Digits for Philippines Country');
           }
            //End of <Bhargavi 20160919>
            if(openLocalLanguagePanel==true && OnboardingReq.Local_Version__c.contains('Chinese')) {
                if (String.valueof(OnboardingReq.Local_Customer_Name_1__c)!=null  && (OnboardingReq.Local_Customer_Name_1__c).length()>17){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_1__c.addError('Local Customer Name should not be more than 17 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_2__c)!=null && (OnboardingReq.Local_Customer_Name_2__c).length()>17){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_2__c.addError('Local Customer Name 2 should not be more than 17 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_3__c)!=null  && (OnboardingReq.Local_Customer_Name_3__c).length()>17){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_3__c.addError('Local Customer Name 3 should not be more than 17 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_4__c)!=null && (OnboardingReq.Local_Customer_Name_4__c).length()>17){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_4__c.addError('Local Customer Name 4 should not be more than 17 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Language_Street__c)!=null && (OnboardingReq.Local_Language_Street__c).length()>17){
                    this.IsError = true;
                    OnboardingReq.Local_Language_Street__c.addError('Local Language Street should not be more than 17 Characters for Chinese Local version');
                }
                
            }
            if(openLocalLanguagePanel==true && !OnboardingReq.Local_Version__c.contains('Chinese')){
        
                if (String.valueof(OnboardingReq.Local_Customer_Name_1__c)!=null  && (OnboardingReq.Local_Customer_Name_1__c).length()>35){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_1__c.addError('Local Customer Name should not be more than 35 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_2__c)!=null && (OnboardingReq.Local_Customer_Name_2__c).length()>35){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_2__c.addError('Local Customer Name 2 should not be more than 35 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_3__c)!=null  && (OnboardingReq.Local_Customer_Name_3__c).length()>35){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_3__c.addError('Local Customer Name 3 should not be more than 35 Characters for Chinese Local version');
                }
                if (String.valueof(OnboardingReq.Local_Customer_Name_4__c)!=null  && (OnboardingReq.Local_Customer_Name_4__c).length()>35){
                    this.IsError = true;
                    OnboardingReq.Local_Customer_Name_4__c.addError('Local Customer Name 4 should not be more than 35 Characters for Chinese Local version');
                }
            }
        }  
        //End of <Bhargavi20160714>            
    }       
    /**
     * Name: RelatedlistItemsValidation
     * Params: None
     * Description: Method to validate Request Line Items before Saving and submitting.
     */ 

    public boolean RelatedlistItemsValidation(){
        //For Contact Related List Items.....
        list<Attachment> Lst_Attachments= new List<Attachment>();
        list<Customer_Data_Request_Line_Item__c> lst_DataLineItem = new List<Customer_Data_Request_Line_Item__c>();
        if(OnboardingReq.Id ==null && String.ValueOf(OnboardingReq.RecordTypeId) == Partner_COB_RTYPE ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Add one Customer Data Request line Item before Submitting the Request.'));
            return false;
        }
        else if(OnboardingReq.Id ==null && String.ValueOf(OnboardingReq.RecordTypeId) == Miscellaneous_COB_RTYPE && (OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - finance data' || OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - non finance data')){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Add atleast one Attachments Submitting the Request.'));
            return false;

        }

        else if(OnboardingReq.Id !=null){
            if(String.ValueOf(OnboardingReq.RecordTypeId) == Partner_COB_RTYPE){
                lst_DataLineItem = [Select Id,Name from Customer_Data_Request_Line_Item__c Where Customer_Data_Request__c = : OnboardingReq.Id];
                if(lst_DataLineItem.size()==0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Add one Customer Data Request line Item before Submitting the Request.'));
                    return false;
                }
            }
            if(String.ValueOf(OnboardingReq.RecordTypeId) == Miscellaneous_COB_RTYPE && (OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - finance data' || OnboardingReq.Miscellaneous_Type_Intent__c=='Mass load - non finance data')){

                Lst_Attachments = [SELECT name FROM Attachment WHERE ParentID =:OnboardingReq.Id ];
                if(Lst_Attachments.size()==0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Add atleast one Attachments Submitting the Request.'));
                    return false;
                }

            }

        }
        return true;

    }


  /**
     * Name: checkLocalLanguage
     * Params: None
     * Description: Method will be called when Local Language in page is not empty and details are copied.
     */ 
    public void checkLocalLanguage(){

        if(Apexpages.currentPage().getParameters().get('firstParam')+''!='null')
            OnboardingReq.Sold_to_Region__c= Apexpages.currentPage().getParameters().get('firstParam')+'';
        if(Apexpages.currentPage().getParameters().get('secondParam')+''!='null')
            OnboardingReq.Sold_To_Country__c= Apexpages.currentPage().getParameters().get('secondParam')+'';
        if(Apexpages.currentPage().getParameters().get('thirdParam')+''!='null')
            OnboardingReq.Local_Version__c = Apexpages.currentPage().getParameters().get('thirdParam')+'';
        if(Apexpages.currentPage().getParameters().get('fourthParam')+''!='null')
            OnboardingReq.Sold_to_State_Province__c = Apexpages.currentPage().getParameters().get('fourthParam')+'';
        //<Nishant 20151012>Adding Local Version Functionality for Extend Existing as part of R02 Enhancement
        if(!(OnboardingReq.Local_Version__c==null || OnboardingReq.Local_Version__c=='') && (String.ValueOf(OnboardingReq.RecordTypeId) == ModifyExisting_COB_RTYPE || String.ValueOf(OnboardingReq.RecordTypeId) == NewCustomerCreation_COB_RTYPE || String.ValueOf(OnboardingReq.RecordTypeId) == ExtendExisting_COB_RTYPE)){
            openLocalLanguagePanel = true;

            OnboardingReq.Local_Language_State_Province__c=OnboardingReq.Sold_to_State_Province__c;
            OnboardingReq.Local_Language_Country__c=OnboardingReq.Sold_To_Country__c;
            OnboardingReq.Local_Language_Region__c=OnboardingReq.Sold_to_Region__c;
              
            fetchLocalRegionValues();
        }
        
        
        else{
            openLocalLanguagePanel = false;
            if(String.ValueOf(OnboardingReq.RecordTypeId) != ModifyExisting_COB_RTYPE && String.ValueOf(OnboardingReq.RecordTypeId) != ExtendExisting_COB_RTYPE){ //<Alvin20150615> 
                OnboardingReq.Local_Customer_Name_1__c='';
                OnboardingReq.Local_Language_Office_House_Number__c='';
                OnboardingReq.Local_Customer_Name_2__c='';
                OnboardingReq.Local_Language_House_Supplement__c='';
                OnboardingReq.Local_Customer_Name_3__c='';
                OnboardingReq.Local_Language_Street__c='';
                OnboardingReq.Local_Customer_Name_4__c='';
                OnboardingReq.Local_Language_City__c='';
                OnboardingReq.Local_language_Search_Terms__c='';
                OnboardingReq.Local_Language_Country__c='';
                OnboardingReq.Local_Language_State_Province__c='';
                OnboardingReq.Local_Language_Region__c='';
                OnboardingReq.Local_Language_District__c='';
            }
        }
    } 

    /**
     * Name: fetchRegionValues
     * Params: None
     * Description: Method to Fetch Region Values WhenEver the Country is changed.
     */ 
    public void fetchRegionValues(){
        if(Apexpages.currentPage().getParameters().get('sixthParam')+''!='null')
            OnboardingReq.Sold_to_Country__c= Apexpages.currentPage().getParameters().get('sixthParam')+'';
        List<COB_Region__c> RegionValues =  new List<COB_Region__c>();
        RegionValues = COB_Region__c.getAll().Values();
        RegionValues.Sort();
        RegionOptions= new List<SelectOption>();
        RegionOptions.add(new SelectOption('', 'None'));
        if(OnboardingReq.Sold_to_Country__c!='' && OnboardingReq.Sold_to_Country__c!=null){
            for (COB_Region__c a : RegionValues)
            {
                if(a.Country__c==OnboardingReq.Sold_to_Country__c.Substring(0,2))
                    RegionOptions.add(new SelectOption(a.Region__c, a.Region__c));

            }
        }system.debug('Region Options'+RegionOptions);
        system.debug('Sold to state'+OnboardingReq.Sold_to_State_Province__c);   
    }

    /**
     * Name: fetchLocalRegionValues
     * Params: None
     * Description: Method to Fetch local  Region Values WhenEver the local Country is changed.
     */ 

    public void fetchLocalRegionValues(){
        if(Apexpages.currentPage().getParameters().get('seventhParam')+''!='null')
            OnboardingReq.Local_Language_Country__c= Apexpages.currentPage().getParameters().get('seventhParam')+'';
        List<COB_Region__c> LocalRegionValues =  new List<COB_Region__c>();
        LocalRegionValues = COB_Region__c.getAll().Values();
        LocalRegionValues.Sort();
        LocalRegionOptions= new List<SelectOption>();
        LocalRegionOptions.add(new SelectOption('', 'None'));
        if(OnboardingReq.Local_Language_Country__c!='' && OnboardingReq.Local_Language_Country__c!=null){
            for (COB_Region__c a : LocalRegionValues)
            {
                if(a.Country__c==OnboardingReq.Local_Language_Country__c.Substring(0,2))
                    LocalRegionOptions.add(new SelectOption(a.Region__c, a.Region__c));
            }
        }
    }

    /**
     * Name: PrepopulateCreditLimit
     * Params: None
     * Description: Method to populate default credit limit.
     */
    public void PrepopulateCreditLimit(){
        flagProRiskCat=false;
        flagPropNonPayTerm=false;
        If(OnboardingReq.Proposed_Terms_of_Payment__c=='CIA-Payment in Advance'){
            OnboardingReq.Proposed_Credit_limit__c = '111';
        }else if(OnboardingReq.Proposed_Terms_of_Payment__c=='Others'){
            OnboardingReq.Proposed_Credit_limit__c = '0';
            flagPropNonPayTerm=true;
        }
        else{
            OnboardingReq.Proposed_Credit_limit__c = '0';
        }

        If(OnboardingReq.Proposed_Terms_of_Payment__c=='CIA-Payment in Advance' || OnboardingReq.Proposed_Terms_of_Payment__c=='L001-Letter of Credit at Sight')
        flagProRiskCat=true;
    }

    /**
     * Name: fetchCountryCode
     * Params: None
     * Description: Method to Fetch Country code when recordType is not New Customer Creation.
     */ 
    public String fetchCountryCode(){
        List <ERP_Relationship__c> soldToRelationship = new List<ERP_Relationship__c>();
        if(OnboardingReq.Account_Group__c.contains('Z001')){
            if(String.ValueOf(OnboardingReq.RecordTypeId)!=NewCustomerCreation_COB_RTYPE)
                OnboardingReq.Sold_to_Country__c = OnboardingReq.Existing_Country__c;
            return OnboardingReq.Sold_to_Country__c;
        }
        else{
            soldToRelationship= [Select ERP_Customer__r.Country_Code__c,ERP_Customer__r.Country__c,Related_ERP_Customer__c,ERP_Customer__r.Account_Group__c from ERP_Relationship__c where Related_ERP_Customer__c=:OnboardingReq.Customer__c and ERP_Customer__r.Account_Group__c like 'Z001%' ];
            if(soldToRelationship.size()!=0){
                if(String.ValueOf(OnboardingReq.RecordTypeId)!=NewCustomerCreation_COB_RTYPE)
                    OnboardingReq.Sold_to_Country__c = soldToRelationship.get(0).ERP_Customer__r.Country_Code__c + ' - '+soldToRelationship.get(0).ERP_Customer__r.Country__c ;
                return soldToRelationship.get(0).ERP_Customer__r.Country_Code__c;
            }
            else return null;
        }
    }      
    /**
     * Name: RequestFlow
     * Params: none
     * Description: Method to Assign Owner and Lock the record when ever it is Submitted.
     */ 
    public void RequestFlow(){

        string selcompcode;
        //<Alvin20151001> commented and made MapCreditTermNLimit public outside method for making Estimated Average Monthly Purchases and Estimated Number of Orders per Month mandatory
        /*map<String , Decimal> MapCreditTermNLimit = new map<String , Decimal>();
        for(Business_Rules__c br : [select id, CDR_Proposed_Credit_Term_Type__c,CDR_Delegation_Limit__c FROM Business_Rules__c WHERE CDR_Proposed_Credit_Term_Type__c != null AND CDR_Proposed_Credit_Term_Type__c != '' AND CDR_Delegation_Limit__c != null]){
            MapCreditTermNLimit.put(br.CDR_Proposed_Credit_Term_Type__c, br.CDR_Delegation_Limit__c);
        }*/
        if(CDRCountry == 'IN - India'){//<Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
            selcompcode = 'IN';
        }
        else if(CDRCountry == 'HK - Hong Kong'){//<Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
            selcompcode = 'HK';
        }
        //<Alvin20150929> commented for R02 enhancement to replace selling company codes with business Rules
        //else if((sellingCompanyCode == '0078 - ELECT. MATLS DUP DONGGUAN') || (sellingCompanyCode == '0218 - DuPont Trading Shanghai') || (sellingCompanyCode == '0701 - DUP AGRIC CHEM LTD') ||
        //        (sellingCompanyCode == '1131 - DuPont (Shanghai) Sourcing Center Company, Ltd.') || (sellingCompanyCode == '1132 - DuPont(China) RD and Mgmt') || (sellingCompanyCode == '1142 - DUP SURFCE GUANGZHOU') ||
        //        (sellingCompanyCode == '1210 - DUP (SHENZHEN) INDUS') || (sellingCompanyCode == '2791 - Du Pont China Holding Co.'  || sellingCompanyCode =='1310 - DuPont Apollo (Shenzhen)')){//<Alvin20150824> Added 1310 selling company code for enhancement LE1310
        else if(CDRCountry == 'CN - China'){    
            selcompcode = 'CN';
        }
        else if(CDRCountry == 'TH - Thailand'){//<Alvin20150929> updated for R02 enhancement to replace selling company codes with business Rules
            selcompcode = 'TH';
        }
        
       //  Start of <Santhosh 20160706>
        else if(CDRCountry == 'AU - Australia'){
            selcompcode = 'AU';
        }
        else if(CDRCountry == 'NZ - New zealand'){
            selcompcode = 'NZ';
        }
        //End of <Santhosh 20160706>
        // Start of <Bhargavi 20160919>
        else if(CDRCountry == 'SG - Singapore'){
            selcompcode = 'SG';
        }
        else if(CDRCountry == 'MY - Malaysia'){
            selcompcode = 'MY';
        }
        else if(CDRCountry == 'PH - Philippines'){
            selcompcode = 'PH';
        }
        else if(CDRCountry == 'VN - Vietnam'){
            selcompcode = 'VN';
        }
        //End of <Bhargavi 20160919>
        OnboardingReq.Last_Modified_Time__c =system.now();
        
        
        if(lst_GrpName.size()>0 && MapCreditTermNLimit.size()>0){   //<Santhosh 20160706> added 'DuPont CDR Users - ANZ' group condition //<Bhargavi 20160919> added 'DuPont CDR Users - ASEAN' group condition
            if((lst_GrpName.contains('DuPont CDR Users - Thailand') || lst_GrpName.contains('DuPont CDR Users - India') || lst_GrpName.contains('DuPont CDR Users - ANZ') || lst_GrpName.contains('Dupont CDR Users - ASEAN') || lst_GrpName.contains('DuPont CDR Users - Hong Kong')
                    ||lst_GrpName.contains('DPP Customer Service Reps') || lst_GrpName.contains('DPT Customer Service Reps')  || lst_GrpName.contains('DCP Customer Service Reps')
                    || lst_GrpName.contains('P&IP Customer Service Reps')  || lst_GrpName.contains('DSS Customer Service Reps') || lst_GrpName.contains('BI Customer Service Reps')
                    || lst_GrpName.contains('N&H Customer Service Reps') || lst_GrpName.contains('DEC Customer Service Reps') || lst_GrpName.contains('IB Customer Service Reps')
                    || lst_GrpName.contains('Customer On-boarding Levrg CSR - China') || lst_GrpName.contains('DuPont CDR Users - China')))
            {
                if(OnboardingReq.Leveraged_CSR__c == true && OnboardingReq.Assigned_to_Leverage_CSR__c == false && OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                    system.debug('status***1');
                    OnboardingReq.Ownerid= QueueMap.get('Customer On-boarding Levrg CSR-China Que');
                    OnboardingReq.Request_Status__c= 'Draft/Data Gathering';
                    OnboardingReq.Send_To_Utility__c=false;
                    OnboardingReq.Sent_To_Utility__c=false;
                    OnboardingReq.Assigned_to_Leverage_CSR__c = true;
                }else if(OnboardingReq.Account_Group__c == 'Z002 ( Ship-to party )' && OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                    OnboardingReq.Assigned_to_Leverage_CSR__c = false;
                    OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                    OnboardingReq.Credit_Approval_Required__c = false;
                    OnboardingReq.Send_To_Utility__c=true;
                    OnboardingReq.Record_Locked__c=true;
                    OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                    OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                    onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                    OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
                }
                else{
                    system.debug('Testing the Lev flow---1');
                    OnboardingReq.Assigned_to_Leverage_CSR__c = false;
                    if(String.ValueOf(OnboardingReq.RecordTypeId) == NewCustomerCreation_COB_RTYPE ) {
                        OnboardingReq.Send_To_Utility__c=true;
                        OnboardingReq.Sent_To_Utility__c=false;
                        OnboardingReq.Record_Locked__c=true;

                        if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                            if((OnboardingReq.Proposed_Credit_Term_Type__c=='Cash In Advance')||((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c) < MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c!='Other' && OnboardingReq.Preferred_Bank_Name__c!=null)))
                            {
                                OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                                OnboardingReq.Credit_Approval_Required__c = false;
                                OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                                OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
                            }
                            else if(OnboardingReq.Sold_to_Country__c.Substring(0,2) != selcompcode && ((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit' || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)')) && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))){
                               /* Start of <Bhargavi 20161110> Commented to by pass Destination Credit for all countries
                                //Start of BA15062016
                                if (OnboardingReq.isCreditApproved__c == true) {
                                            system.debug('insideif $$$$ 1 ');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                    } 
                                    //Start of <Santhosh 20160706> // <Bhargavi 20160919>
                                    else if(selcompcode =='AU' || selcompcode =='NZ' || selcompcode == 'SG' || selcompcode == 'MY' || selcompcode == 'PH' || selcompcode == 'VN')
                                    {
                                        OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                        OnboardingReq.Credit_Approval_Required__c = true;
                                    }  //End of <Santhosh 20160706> // <Bhargavi 20160919>
                                    else {
                                        system.debug('insideif $$$$ 2');
                                        OnboardingReq.Credit_Approval_Required__c = true;
                                        OnboardingReq.Request_Status__c='Awaiting Destination Credit Approval';
                                     } 
                                     
                                     //End of BA15062016
                                       

                                if(OnboardingReq.Sold_to_Country__c.Substring(0,2) !='IN' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='TH'&& OnboardingReq.Sold_to_Country__c.Substring(0,2) !='CN' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='HK' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='AU' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='NZ'
                                      &&  OnboardingReq.Sold_to_Country__c.Substring(0,2) !='SG' && OnboardingReq.Sold_to_Country__c.Substring(0,2) !='MY' &&OnboardingReq.Sold_to_Country__c.Substring(0,2) !='PH' &&OnboardingReq.Sold_to_Country__c.Substring(0,2) !='VN' )  ////<Santhosh 20160706> added 'AU' and 'NZ' condition // <Bhargavi 20160919> added SG,MY,PH & VN conditions
                                { */ 
                                //End of <Bhargavi 20161110>
                                    //Start of BA15062016
                                    if (OnboardingReq.isCreditApproved__c == true) {
                                    system.debug('insideif $$$$ 3');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                    } 
                                    else {  //End of BA15062016
                                    system.debug('insideif $$$$ 4');
                                    OnboardingReq.Credit_Approval_Required__c = true;
                                    OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                    OnboardingReq.Destination_Credit_Comments__c='There is no Destination Credit Analyst available for' + OnboardingReq.Sold_to_Country__c + 'Country and hence request has by-passed destination credit analysis.';
                                    }  // BA15062016
                               // }
                            }
                            else if(((((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c=='Other' || OnboardingReq.Preferred_Bank_Name__c==null)) || ((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) || (OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)'))) || (OnboardingReq.Proposed_Terms_of_Payment__c=='Other' && OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null) || (((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))))
                            {
                                //Start of BA15062016
                                if (OnboardingReq.isCreditApproved__c == true) {
                                system.debug('insideif $$$$ 5 ');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                } 
                                else { //End of BA15062016
                                system.debug('insideif $$$$ 6');
                                OnboardingReq.Credit_Approval_Required__c = true;
                                OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                } // BA15062016
                            } 
                        }else{
                            OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                            OnboardingReq.Sent_To_Utility__c=false;
                            OnboardingReq.Send_To_Utility__c=true;
                            OnboardingReq.Record_Locked__c=true;
                        }
                    }else if((String.ValueOf(OnboardingReq.RecordTypeId) == Miscellaneous_COB_RTYPE) ||(String.ValueOf(OnboardingReq.RecordTypeId) == Partner_COB_RTYPE)) {
                        OnboardingReq.Send_To_Utility__c=true;
                        OnboardingReq.Sent_To_Utility__c=false;
                        OnboardingReq.Record_Locked__c=true;
                        if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){
                            if(OnboardingReq.Credit_Approval_Required__c == true){
                                OnboardingReq.Request_Status__c ='Awaiting Credit Approval';
                            }else{
                            system.debug('insideif $$$$ 7');
                                OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                OnboardingReq.Credit_Approval_Required__c = false;
                                OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';            
                            }
                        }else{
                            OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                            OnboardingReq.Sent_To_Utility__c=false;
                            OnboardingReq.Send_To_Utility__c=true;
                            OnboardingReq.Record_Locked__c=true;
                        }
                    }else
                    {   
                        String CountryCode = fetchCountryCode();
                        if(CountryCode != null)
                        {
                            CountryCode=CountryCode.substring(0,2);
                            OnboardingReq.Send_To_Utility__c=true;
                            OnboardingReq.Sent_To_Utility__c=false;
                            OnboardingReq.Record_Locked__c=true;
                            system.debug('CountryCode'+ CountryCode);
                            system.debug('selcompcode'+ selcompcode);
                            if(OnboardingReq.Request_Status__c !='Request Completed in SAP'){

                                if(((String.ValueOf(OnboardingReq.RecordTypeId) == ModifyExisting_COB_RTYPE || String.ValueOf(OnboardingReq.RecordTypeId) == ExtendExisting_COB_RTYPE) & OnboardingReq.Credit_Approval_Required__c == false))
                                {
                                    OnboardingReq.Request_Status__c = 'Awaiting Data Analyst (DMS Team) Approval';
                                    OnboardingReq.Credit_Approval_Required__c = false;
                                    OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                    OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                }
                                else{
                                    system.debug('Testing the Lev flow---2');
                                    if((OnboardingReq.Proposed_Credit_Term_Type__c=='Cash In Advance')||((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c!='Other' && OnboardingReq.Preferred_Bank_Name__c!=null))){
                                        system.debug('Testing the Lev flow---3');
                                        OnboardingReq.Request_Status__c='Awaiting Data Analyst (DMS Team) Approval';
                                        OnboardingReq.Credit_Approval_Required__c = false;
                                        OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                        OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                        onboardingReq.Data_Analyst_Comments__c='This request has pre-approved terms of payment and hence has by-passed the credit approval';
                                        OnboardingReq=CopyProposedToApprovedCredit(OnboardingReq);
                                    }
                                    else if((CountryCode != selcompcode && ((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit' || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)')) && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c))))){
                                        // Start of  <Bhargavi 20161110> Commneted the code to by pass Destination Credit Approval
                                        /*{
                                         //Start of BA15062016
                                         
                                            if (OnboardingReq.isCreditApproved__c == true) {
                                            
                                            system.debug('insideif $$$$ 8');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                            } 
                                            //Start of <Santhosh 20160706> // <Bhargavi 20160919>
                                            else if(selcompcode =='AU' || selcompcode =='NZ' || selcompcode == 'SG' || selcompcode == 'MY' || selcompcode == 'PH' || selcompcode == 'VN')
                                            {
                                                OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                                OnboardingReq.Credit_Approval_Required__c = true;
                                           }  //End of <Santhosh 20160706>  // <Bhargavi 20160919>
                                            else { //End of BA15062016
                                            system.debug('insideif $$$$ 9');
                                            OnboardingReq.Credit_Approval_Required__c = true;
                                            OnboardingReq.Request_Status__c='Awaiting Destination Credit Approval';
                                            }  //BA15062016
                                        } 
                                        if((CountryCode !='CN') && (CountryCode !='TH') && (CountryCode !='HK')&& (CountryCode !='IN') && (CountryCode !='AU') && (CountryCode !='NZ'
                                                    && (CountryCode !='SG') && (CountryCode !='MY')&& (CountryCode !='PH') && (CountryCode !='VN')  ) ) //<Santhosh 20160706> added 'AU' and 'NZ' condition // <Bhargavi 20160919> added SG,MY,PH & VN conditions
                                        { */ 
                                        // End of <Bhargavi 20161110>
                                            //Start of BA15062016
                                            if (OnboardingReq.isCreditApproved__c == true) {
                                            system.debug('insideif $$$$ 10');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                            } 
                                            else { //End of BA15062016
                                            system.debug('insideif $$$$ 12');
                                            OnboardingReq.Credit_Approval_Required__c = true;
                                            OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                            OnboardingReq.Destination_Credit_Comments__c='There is no Destination Credit Analyst available for' + OnboardingReq.Sold_to_Country__c + 'Country and hence request has by-passed destination credit analysis.';
                                            } //BA15062016
                                        //}
                                    } 
                                    else if(((((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c) && (OnboardingReq.Preferred_Bank_Name__c=='Other' || OnboardingReq.Preferred_Bank_Name__c==null)) || ((OnboardingReq.Proposed_Credit_Term_Type__c=='Letter Of Credit') && Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)>= MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)) || (OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') || (OnboardingReq.Proposed_Credit_Term_Type__c=='DA (Delivery On Acceptance) or DP (Delivery on Payment)'))) || (OnboardingReq.Proposed_Terms_of_Payment__c=='Other' && OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null) || (((OnboardingReq.Proposed_Credit_Term_Type__c=='Open Credit') && (Decimal.ValueOf(OnboardingReq.Proposed_Credit_Limit_Est__c)< MapCreditTermNLimit.get(OnboardingReq.Proposed_Credit_Term_Type__c)))))
                                    {
                                        //Start of BA15062016
                                        if (OnboardingReq.isCreditApproved__c == true) {
                                        system.debug('insideif $$$$ 13');
                                            OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                            OnboardingReq.Credit_Approval_Required__c = false;
                                            OnboardingReq.Send_To_Utility__c=true;
                                            OnboardingReq.Record_Locked__c=true;
                                        } 
                                        else { //End of BA15062016
                                        system.debug('insideif $$$$ 14');
                                        system.debug('testing for lvr csr flow');
                                        OnboardingReq.Credit_Approval_Required__c = true;
                                        OnboardingReq.Request_Status__c='Awaiting Credit Approval';
                                        } //BA15062016
                                    }  
                                    else if((String.ValueOf(OnboardingReq.RecordTypeId) == ModifyExisting_COB_RTYPE & OnboardingReq.Credit_Approval_Required__c == false) && OnboardingReq.Request_Status__c =='Draft/Data Gathering'){
                                        OnboardingReq.Record_Locked__c=true;
                                        system.debug('insideif $$$$ 15');
                                        OnboardingReq.Send_To_Utility__c = true;
                                        OnboardingReq.Destination_Credit_Comments__c='This Request has by-passed the Destination Credit Approval.';
                                        OnboardingReq.Country_Credit_Comments__c='This Request has by-passed the Country Credit Approval.';
                                        OnboardingReq.Request_Status__c ='Awaiting Data Analyst (DMS Team) Approval';
                                        OnboardingReq.Credit_Approval_Required__c = false;
                                    }                   

                                }
                            }
                            else{
                                OnboardingReq.Request_Status__c='Request Sent for Re-Work';
                                OnboardingReq.Sent_To_Utility__c=false;
                                OnboardingReq.Send_To_Utility__c=true;
                                OnboardingReq.Record_Locked__c=true;
                            }   


                        }   
                    }
                }
            } 
        }         
    }

    /**
     * Name: CopyProposedToApprovedCredit
     * Params: OnboardingReq: Customer_Data_Request__c Id.
     * Description: Method to Copy Proposed Data To Approved Data.
     */ 
    public Customer_Data_Request__c CopyProposedToApprovedCredit(Customer_Data_Request__c OnboardingReq){

        if(OnboardingReq.Proposed_Cash_Management_Group__c!=null)OnboardingReq.Approved_Cash_Management_Group__c = OnboardingReq.Proposed_Cash_Management_Group__c;
        if(OnboardingReq.Proposed_Cred_rep_grp__c!=null)OnboardingReq.Approved_Cred_rep_grp__c = OnboardingReq.Proposed_Cred_rep_grp__c;
        if(OnboardingReq.Proposed_credit_information_number__c!=null)OnboardingReq.Approved_credit_information_number__c = OnboardingReq.Proposed_credit_information_number__c;
        if(OnboardingReq.Proposed_Credit_Limit__c!=null)OnboardingReq.Approved_Credit_Limit__c = OnboardingReq.Proposed_Credit_Limit__c;
        if(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c!=null)OnboardingReq.Approved_Credit_Limit_Currency_Code__c = OnboardingReq.Proposed_Credit_Limit_Currency_Code__c;
        if(OnboardingReq.Proposed_Credit_Term_Type__c!=null)OnboardingReq.Approved_Credit_Term_Type__c = OnboardingReq.Proposed_Credit_Term_Type__c;
        if(OnboardingReq.Proposed_Customer_credit_group__c!=null)OnboardingReq.Approved_Customer_credit_group__c = OnboardingReq.Proposed_Customer_credit_group__c;
        if(OnboardingReq.Proposed_Customer_Group__c!=null)OnboardingReq.Approved_Customer_Group__c = OnboardingReq.Proposed_Customer_Group__c;
        if(OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c!=null)OnboardingReq.Approved_Non_Standard_Terms_of_Payment__c = OnboardingReq.Proposed_Non_Standard_Terms_of_Payment__c;
        if(OnboardingReq.Proposed_Payment_Index__c!=null)OnboardingReq.Approved_Payment_Index__c = OnboardingReq.Proposed_Payment_Index__c;
        if(OnboardingReq.Proposed_Rating__c!=null)OnboardingReq.Approved_Rating__c = OnboardingReq.Proposed_Rating__c;
        if(OnboardingReq.Proposed_Reference_date__c!=null)OnboardingReq.Approved_Reference_date__c = OnboardingReq.Proposed_Reference_date__c;
        if(OnboardingReq.Proposed_Risk_Category__c!=null)OnboardingReq.Approved_Risk_Category__c = OnboardingReq.Proposed_Risk_Category__c;
        if(OnboardingReq.Proposed_Terms_of_Payment__c!=null)OnboardingReq.Approved_Terms_of_Payment__c = OnboardingReq.Proposed_Terms_of_Payment__c;
        if(OnboardingReq.Estimated_Number_of_Orders_per_Month__c!=null)OnboardingReq.Approved_Number_of_Orders_per_Month__c = OnboardingReq.Estimated_Number_of_Orders_per_Month__c;
        if(OnboardingReq.Estimated_Average_Monthly_Purchases__c!=null)OnboardingReq.Approved_Average_Monthly_Purchases__c = OnboardingReq.Estimated_Average_Monthly_Purchases__c;
        return OnboardingReq;
    }



    /**************************** Integration Field Modified Code ************************************/
    public void fieldmodified(){

        OnboardingReq.Fields_Modified_1__c = ' ';
        OnboardingReq.Fields_Modified_2__c = ' ';

        for(string s: fieldmodifiedmap.keyset()){
            system.debug('fieldmodifiedmap key = ' + s + 'value = '+fieldmodifiedmap.get(s));
            if(string.valueof('Customer_Name__c') == s){
                if((fieldmodifiedmap.get('Customer_Name__c') !=''&& string.valueof(OnboardingReq.Customer_Name__c) !=null) ||(fieldmodifiedmap.get('Customer_Name__c') !=''|| string.valueof(OnboardingReq.Customer_Name__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Name__c) <> fieldmodifiedmap.get('Customer_Name__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Name';
                    }
                }
            }

            else if(string.valueof('Customer_Name_2__c') == s){
                if((fieldmodifiedmap.get('Customer_Name_2__c') !=''&& string.valueof(OnboardingReq.Customer_Name_2__c) !=null) ||(fieldmodifiedmap.get('Customer_Name_2__c') !=''|| string.valueof(OnboardingReq.Customer_Name_2__c) !=null) ){
                    system.debug('checking DMS extract - customer name2 --1');
                    if((string.valueof(OnboardingReq.Customer_Name_2__c) <> fieldmodifiedmap.get('Customer_Name_2__c'))){ 
                        system.debug('checking DMS extract - customer name2 --2');
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Name 2';
                    }
                }
            }
            else if(string.valueof('Customer_Name_3__c') == s){
                if((fieldmodifiedmap.get('Customer_Name_3__c') !=''&& string.valueof(OnboardingReq.Customer_Name_3__c) !=null) ||(fieldmodifiedmap.get('Customer_Name_3__c') !=''|| string.valueof(OnboardingReq.Customer_Name_3__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Name_3__c) <> fieldmodifiedmap.get('Customer_Name_3__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Name 3';
                    }
                }
            }
            else if(string.valueof('Customer_Name_4__c') == s){
                if((fieldmodifiedmap.get('Customer_Name_4__c') !=''&& string.valueof(OnboardingReq.Customer_Name_4__c) !=null) ||(fieldmodifiedmap.get('Customer_Name_4__c') !=''|| string.valueof(OnboardingReq.Customer_Name_4__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Name_4__c) <> fieldmodifiedmap.get('Customer_Name_4__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Name 4';
                    }
                }
            }
            else if(string.valueof('Sold_to_City__c') == s){
                if((fieldmodifiedmap.get('Sold_to_City__c') !=''&& string.valueof(OnboardingReq.Sold_to_City__c) !=null) ||(fieldmodifiedmap.get('Sold_to_City__c') !=''|| string.valueof(OnboardingReq.Sold_to_City__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_City__c) <> fieldmodifiedmap.get('Sold_to_City__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to City';
                    }
                }
            }

            else if(string.valueof('Sold_to_District__c') == s){
                if((fieldmodifiedmap.get('Sold_to_District__c') !=''&& string.valueof(OnboardingReq.Sold_to_District__c) !=null) ||(fieldmodifiedmap.get('Sold_to_District__c') !=''|| string.valueof(OnboardingReq.Sold_to_District__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_District__c) <> fieldmodifiedmap.get('Sold_to_District__c').trim())){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to District';
                    }
                }
            }
            else if(string.valueof('P_O_Box__c') == s){
                if((fieldmodifiedmap.get('P_O_Box__c') !=''&& string.valueof(OnboardingReq.P_O_Box__c) !=null) ||(fieldmodifiedmap.get('P_O_Box__c') !=''|| string.valueof(OnboardingReq.P_O_Box__c) !=null) ){
                    if((string.valueof(OnboardingReq.P_O_Box__c) <> fieldmodifiedmap.get('P_O_Box__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'P.O.Box';
                    }
                }
            }
            else if(string.valueof('Sold_To_Office_House_Number__c') == s){
                if((fieldmodifiedmap.get('Sold_To_Office_House_Number__c') !=''&& string.valueof(OnboardingReq.Sold_To_Office_House_Number__c) !=null) ||(fieldmodifiedmap.get('Sold_To_Office_House_Number__c') !=''|| string.valueof(OnboardingReq.Sold_To_Office_House_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_To_Office_House_Number__c) <> fieldmodifiedmap.get('Sold_To_Office_House_Number__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold To Office/House Number';
                    }
                }
            }

            else if(string.valueof('Sold_to_Street__c') == s){
                if((fieldmodifiedmap.get('Sold_to_Street__c') !=''&& string.valueof(OnboardingReq.Sold_to_Street__c) !=null) ||(fieldmodifiedmap.get('Sold_to_Street__c') !=''|| string.valueof(OnboardingReq.Sold_to_Street__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_Street__c) <> fieldmodifiedmap.get('Sold_to_Street__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to Street';
                    }
                }
            }
            else if(string.valueof('Sold_To_House_Supplement__c') == s){
                if((fieldmodifiedmap.get('Sold_To_House_Supplement__c') !=''&& string.valueof(OnboardingReq.Sold_To_House_Supplement__c) !=null) ||(fieldmodifiedmap.get('Sold_To_House_Supplement__c') !=''|| string.valueof(OnboardingReq.Sold_To_House_Supplement__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_To_House_Supplement__c) <> fieldmodifiedmap.get('Sold_To_House_Supplement__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-To House Supplement';
                    }
                }
            }
            else if(string.valueof('Sold_to_State_Province__c') == s){
                if((fieldmodifiedmap.get('Sold_to_State_Province__c') !=''&& string.valueof(OnboardingReq.Sold_to_State_Province__c) !=null) ||(fieldmodifiedmap.get('Sold_to_State_Province__c') !=''|| string.valueof(OnboardingReq.Sold_to_State_Province__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_State_Province__c) <> fieldmodifiedmap.get('Sold_to_State_Province__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to State/Province';
                    }
                }
            }
            else if(string.valueof('Sold_to_Telephone__c') == s){
                if((fieldmodifiedmap.get('Sold_to_Telephone__c') !=''&& string.valueof(OnboardingReq.Sold_to_Telephone__c) !=null) ||(fieldmodifiedmap.get('Sold_to_Telephone__c') !=''|| string.valueof(OnboardingReq.Sold_to_Telephone__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_Telephone__c) <> fieldmodifiedmap.get('Sold_to_Telephone__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to Telephone';
                    }
                }
            }
            else if(string.valueof('Sold_to_Fax_Number__c') == s){
                if((fieldmodifiedmap.get('Sold_to_Fax_Number__c') !=''&& string.valueof(OnboardingReq.Sold_to_Fax_Number__c) !=null) ||(fieldmodifiedmap.get('Sold_to_Fax_Number__c') !=''|| string.valueof(OnboardingReq.Sold_to_Fax_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_Fax_Number__c) <> fieldmodifiedmap.get('Sold_to_Fax_Number__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to Fax Number';
                    }
                }
            }
            else if(string.valueof('Telebox__c') == s){
                if((fieldmodifiedmap.get('Telebox__c') !=''&& string.valueof(OnboardingReq.Telebox__c) !=null) ||(fieldmodifiedmap.get('Telebox__c') !=''|| string.valueof(OnboardingReq.Telebox__c) !=null) ){
                    if((string.valueof(OnboardingReq.Telebox__c) <> fieldmodifiedmap.get('Telebox__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Telebox';
                    }
                }
            }
            else if(string.valueof('Website__c') == s){
                if((fieldmodifiedmap.get('Website__c') !=''&& string.valueof(OnboardingReq.Website__c) !=null) ||(fieldmodifiedmap.get('Website__c') !=''|| string.valueof(OnboardingReq.Website__c) !=null) ){
                    system.debug('checking DMS extract - website --1');
                    if((string.valueof(OnboardingReq.Website__c) <> fieldmodifiedmap.get('Website__c'))){ 
                        system.debug('checking DMS extract - website --2');
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Website';
                    }
                }
            }
            else if(string.valueof('Sold_to_Country__c') == s){

                if((fieldmodifiedmap.get('Sold_to_Country__c') !=''&& string.valueof(OnboardingReq.Sold_to_Country__c) !=null) ||(fieldmodifiedmap.get('Sold_to_Country__c') !=''|| string.valueof(OnboardingReq.Sold_to_Country__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_Country__c) <> fieldmodifiedmap.get('Sold_to_Country__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to Country';
                    }
                }
            }
            else if(string.valueof('Sold_to_Postal_Code__c') == s){
                if((fieldmodifiedmap.get('Sold_to_Postal_Code__c') !=''&& string.valueof(OnboardingReq.Sold_to_Postal_Code__c) !=null) ||(fieldmodifiedmap.get('Sold_to_Postal_Code__c') !=''|| string.valueof(OnboardingReq.Sold_to_Postal_Code__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sold_to_Postal_Code__c) <> fieldmodifiedmap.get('Sold_to_Postal_Code__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sold-to Postal Code';
                    }
                }
            }
            else if(string.valueof('Local_Language_Country__c') == s){

                if((fieldmodifiedmap.get('Local_Language_Country__c') !=''&& string.valueof(OnboardingReq.Local_Language_Country__c) !=null) ||(fieldmodifiedmap.get('Local_Language_Country__c') !=''|| string.valueof(OnboardingReq.Local_Language_Country__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_Country__c) <> fieldmodifiedmap.get('Local_Language_Country__c'))){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Local Language Country';
                    }
                }
            }
            else if(string.valueof('Local_Customer_Name_1__c') == s){
                if((fieldmodifiedmap.get('Local_Customer_Name_1__c') !=''&& string.valueof(OnboardingReq.Local_Customer_Name_1__c) !=null) ||(fieldmodifiedmap.get('Local_Customer_Name_1__c') !=''|| string.valueof(OnboardingReq.Local_Customer_Name_1__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Customer_Name_1__c) <> fieldmodifiedmap.get('Local_Customer_Name_1__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Customer Name 1';
                    }
                }
            }
            else if(string.valueof('Local_Customer_Name_2__c') == s){
                if((fieldmodifiedmap.get('Local_Customer_Name_2__c') !=''&& string.valueof(OnboardingReq.Local_Customer_Name_2__c) !=null) ||(fieldmodifiedmap.get('Local_Customer_Name_2__c') !=''|| string.valueof(OnboardingReq.Local_Customer_Name_2__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Customer_Name_2__c) <> fieldmodifiedmap.get('Local_Customer_Name_2__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Customer Name 2';
                    }
                }
            }
            else if(string.valueof('Local_Customer_Name_3__c') == s){
                if((fieldmodifiedmap.get('Local_Customer_Name_3__c') !=''&& string.valueof(OnboardingReq.Local_Customer_Name_3__c) !=null) ||(fieldmodifiedmap.get('Local_Customer_Name_3__c') !=''|| string.valueof(OnboardingReq.Local_Customer_Name_3__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Customer_Name_3__c) <> fieldmodifiedmap.get('Local_Customer_Name_3__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Customer Name 3';
                    }
                }
            }
            else if(string.valueof('Local_Customer_Name_4__c') == s){
                if((fieldmodifiedmap.get('Local_Customer_Name_4__c') !=''&& string.valueof(OnboardingReq.Local_Customer_Name_4__c) !=null) ||(fieldmodifiedmap.get('Local_Customer_Name_4__c') !=''|| string.valueof(OnboardingReq.Local_Customer_Name_4__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Customer_Name_4__c) <> fieldmodifiedmap.get('Local_Customer_Name_4__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Customer Name 4';
                    }
                }
            }
            else if(string.valueof('Local_language_Data_line__c') == s){
                if((fieldmodifiedmap.get('Local_language_Data_line__c') !=''&& string.valueof(OnboardingReq.Local_language_Data_line__c) !=null) ||(fieldmodifiedmap.get('Local_language_Data_line__c') !=''|| string.valueof(OnboardingReq.Local_language_Data_line__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_language_Data_line__c) <> fieldmodifiedmap.get('Local_language_Data_line__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Data Line';
                    }
                }
            }
            else if(string.valueof('Local_Language_city__c') == s){
                if((fieldmodifiedmap.get('Local_Language_city__c') !=''&& string.valueof(OnboardingReq.Local_Language_city__c) !=null) ||(fieldmodifiedmap.get('Local_Language_city__c') !=''|| string.valueof(OnboardingReq.Local_Language_city__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_city__c) <> fieldmodifiedmap.get('Local_Language_city__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language City';
                    }
                }
            }
            else if(string.valueof('Local_Language_Office_House_Number__c') == s){
                if((fieldmodifiedmap.get('Local_Language_Office_House_Number__c') !=''&& string.valueof(OnboardingReq.Local_Language_Office_House_Number__c) !=null) ||(fieldmodifiedmap.get('Local_Language_Office_House_Number__c') !=''|| string.valueof(OnboardingReq.Local_Language_Office_House_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_Office_House_Number__c) <> fieldmodifiedmap.get('Local_Language_Office_House_Number__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Office/House Number';
                    }
                }
            }
            else if(string.valueof('Local_Language_Postal_Code__c') == s){
                if((fieldmodifiedmap.get('Local_Language_Postal_Code__c') !=''&& string.valueof(OnboardingReq.Local_Language_Postal_Code__c) !=null) ||(fieldmodifiedmap.get('Local_Language_Postal_Code__c') !=''|| string.valueof(OnboardingReq.Local_Language_Postal_Code__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_Postal_Code__c) <> fieldmodifiedmap.get('Local_Language_Postal_Code__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Postal Code';
                    }
                }
            }
            else if(string.valueof('Local_Language_Region__c') == s){

                if((fieldmodifiedmap.get('Local_Language_Region__c') !=''&& string.valueof(OnboardingReq.Local_Language_Region__c) !=null) ||(fieldmodifiedmap.get('Local_Language_Region__c') !=''|| string.valueof(OnboardingReq.Local_Language_Region__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_Region__c) <> fieldmodifiedmap.get('Local_Language_Region__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Region';
                    }
                }
            }
            else if(string.valueof('Local_language_Search_Terms__c') == s){
                if((fieldmodifiedmap.get('Local_language_Search_Terms__c') !=''&& string.valueof(OnboardingReq.Local_language_Search_Terms__c) !=null) ||(fieldmodifiedmap.get('Local_language_Search_Terms__c') !=''|| string.valueof(OnboardingReq.Local_language_Search_Terms__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_language_Search_Terms__c) <> fieldmodifiedmap.get('Local_language_Search_Terms__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local language Search Terms';
                    }
                }
            }
            else if(string.valueof('Local_Language_Street__c') == s){
                if((fieldmodifiedmap.get('Local_Language_Street__c') !=''&& string.valueof(OnboardingReq.Local_Language_Street__c) !=null) ||(fieldmodifiedmap.get('Local_Language_Street__c') !=''|| string.valueof(OnboardingReq.Local_Language_Street__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_Street__c) <> fieldmodifiedmap.get('Local_Language_Street__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language Street';
                    }
                }
            }
            else if(string.valueof('Local_Language_City__c') == s){
                if((fieldmodifiedmap.get('Local_Language_City__c') !=''&& string.valueof(OnboardingReq.Local_Language_City__c) !=null) ||(fieldmodifiedmap.get('Local_Language_City__c') !=''|| string.valueof(OnboardingReq.Local_Language_City__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_Language_City__c) <> fieldmodifiedmap.get('Local_Language_City__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local Language City';
                    }
                }
            }

            else if(string.valueof('Local_language_Telebox__c') == s){
                if((fieldmodifiedmap.get('Local_language_Telebox__c') !=''&& string.valueof(OnboardingReq.Local_language_Telebox__c) !=null) ||(fieldmodifiedmap.get('Local_language_Telebox__c') !=''|| string.valueof(OnboardingReq.Local_language_Telebox__c) !=null) ){
                    if((string.valueof(OnboardingReq.Local_language_Telebox__c) <> fieldmodifiedmap.get('Local_language_Telebox__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Local language Telebox';
                    }
                }
            }
            else if(string.valueof('Sort_key__c') == s){
                if((fieldmodifiedmap.get('Sort_key__c') !=''&& string.valueof(OnboardingReq.Sort_key__c) !=null) ||(fieldmodifiedmap.get('Sort_key__c') !=''|| string.valueof(OnboardingReq.Sort_key__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sort_key__c) <> fieldmodifiedmap.get('Sort_key__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sort Key';
                    }
                }
            }
            else if(string.valueof('Accounting_Clerk__c') == s){
                if((fieldmodifiedmap.get('Accounting_Clerk__c') !=''&& string.valueof(OnboardingReq.Accounting_Clerk__c) !=null) ||(fieldmodifiedmap.get('Accounting_Clerk__c') !=''|| string.valueof(OnboardingReq.Accounting_Clerk__c) !=null) ){
                    if((string.valueof(OnboardingReq.Accounting_Clerk__c) <> fieldmodifiedmap.get('Accounting_Clerk__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Accounting Clerk';
                    }
                }
            }
            else if(string.valueof('Reconciliation_account__c') == s){
                if((fieldmodifiedmap.get('Reconciliation_account__c') !=''&& string.valueof(OnboardingReq.Reconciliation_account__c) !=null) ||(fieldmodifiedmap.get('Reconciliation_account__c') !=''|| string.valueof(OnboardingReq.Reconciliation_account__c) !=null) ){
                    if((string.valueof(OnboardingReq.Reconciliation_account__c) <> fieldmodifiedmap.get('Reconciliation_account__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Reconciliation Account';
                    }
                }
            }
            else if(string.valueof('Head_office__c') == s){
                if((fieldmodifiedmap.get('Head_office__c') !=''&& string.valueof(OnboardingReq.Head_office__c) !=null) ||(fieldmodifiedmap.get('Head_office__c') !=''|| string.valueof(OnboardingReq.Head_office__c) !=null) ){
                    if((string.valueof(OnboardingReq.Head_office__c) <> fieldmodifiedmap.get('Head_office__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Head Office';
                    }
                }
            }
            else if(string.valueof('Payment_Method__c') == s){
                if((fieldmodifiedmap.get('Payment_Method__c') !=''&& string.valueof(OnboardingReq.Payment_Method__c) !=null) ||(fieldmodifiedmap.get('Payment_Method__c') !=''|| string.valueof(OnboardingReq.Payment_Method__c) !=null) ){
                    if((string.valueof(OnboardingReq.Payment_Method__c) <> fieldmodifiedmap.get('Payment_Method__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Payment Method';
                    }
                }
            }
            else if(string.valueof('Interest_indicator__c') == s){
                if((fieldmodifiedmap.get('Interest_indicator__c') !=''&& string.valueof(OnboardingReq.Interest_indicator__c) !=null) ||(fieldmodifiedmap.get('Interest_indicator__c') !=''|| string.valueof(OnboardingReq.Interest_indicator__c) !=null) ){
                    if((string.valueof(OnboardingReq.Interest_indicator__c) <> fieldmodifiedmap.get('Interest_indicator__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Interest Indicator';
                    }
                }
            }
            else if(string.valueof('Interest_Cycle__c') == s){
                if((fieldmodifiedmap.get('Interest_Cycle__c') !=''&& string.valueof(OnboardingReq.Interest_Cycle__c) !=null) ||(fieldmodifiedmap.get('Interest_Cycle__c') !=''|| string.valueof(OnboardingReq.Interest_Cycle__c) !=null) ){
                    if((string.valueof(OnboardingReq.Interest_Cycle__c) <> fieldmodifiedmap.get('Interest_Cycle__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Interest Cycle';
                    }
                }
            }
            else if(string.valueof('Account_at_customer__c') == s){
                if((fieldmodifiedmap.get('Account_at_customer__c') !=''&& string.valueof(OnboardingReq.Account_at_customer__c) !=null) ||(fieldmodifiedmap.get('Account_at_customer__c') !=''|| string.valueof(OnboardingReq.Account_at_customer__c) !=null) ){
                    if((string.valueof(OnboardingReq.Account_at_customer__c) <> fieldmodifiedmap.get('Account_at_customer__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Account at Customer';
                    }
                }
            }
            else if(string.valueof('Account_Memo__c') == s){
                if((fieldmodifiedmap.get('Account_Memo__c') !=''&& string.valueof(OnboardingReq.Account_Memo__c) !=null) ||(fieldmodifiedmap.get('Account_Memo__c') !=''|| string.valueof(OnboardingReq.Account_Memo__c) !=null) ){
                    if((string.valueof(OnboardingReq.Account_Memo__c) <> fieldmodifiedmap.get('Account_Memo__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Account Memo';
                    }
                }
            }
            else if(string.valueof('Proposed_Cash_Management_Group__c') == s){
                if((fieldmodifiedmap.get('Proposed_Cash_Management_Group__c') !=''&& string.valueof(OnboardingReq.Proposed_Cash_Management_Group__c) !=null) ||(fieldmodifiedmap.get('Proposed_Cash_Management_Group__c') !=''|| string.valueof(OnboardingReq.Proposed_Cash_Management_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Cash_Management_Group__c) <> fieldmodifiedmap.get('Proposed_Cash_Management_Group__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Proposed Cash Management Group';
                    }
                }
            }
            else if(string.valueof('Bank_Statement__c') == s){
                if((fieldmodifiedmap.get('Bank_Statement__c') !=''&& string.valueof(OnboardingReq.Bank_Statement__c) !=null) ||(fieldmodifiedmap.get('Bank_Statement__c') !=''|| string.valueof(OnboardingReq.Bank_Statement__c) !=null) ){
                    if((string.valueof(OnboardingReq.Bank_Statement__c) <> fieldmodifiedmap.get('Bank_Statement__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Bank Statement';
                    }
                }
            }
            else if(string.valueof('Lockbox__c') == s){
                if((fieldmodifiedmap.get('Lockbox__c') !=''&& string.valueof(OnboardingReq.Lockbox__c) !=null) ||(fieldmodifiedmap.get('Lockbox__c') !=''|| string.valueof(OnboardingReq.Lockbox__c) !=null) ){
                    if((string.valueof(OnboardingReq.Lockbox__c) <> fieldmodifiedmap.get('Lockbox__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Lockbox';
                    }
                }
            }
            else if(string.valueof('Payment_advice_by_EDI__c') == s){
                if((fieldmodifiedmap.get('Payment_advice_by_EDI__c') !=''&& string.valueof(OnboardingReq.Payment_advice_by_EDI__c) !=null) ||(fieldmodifiedmap.get('Payment_advice_by_EDI__c') !=''|| string.valueof(OnboardingReq.Payment_advice_by_EDI__c) !=null) ){
                    if((string.valueof(OnboardingReq.Payment_advice_by_EDI__c) <> fieldmodifiedmap.get('Payment_advice_by_EDI__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Payment advice by EDI';
                    }
                }
            }
            else if(string.valueof('Proposed_Credit_Term_Type__c') == s){
                if(OnboardingReq.Proposed_Credit_Term_Type__c != null && OnboardingReq.Proposed_Credit_Term_Type__c != '__'){
                    if((fieldmodifiedmap.get('Proposed_Credit_Term_Type__c') !=''&& string.valueof(OnboardingReq.Proposed_Credit_Term_Type__c) !=null) ||(fieldmodifiedmap.get('Proposed_Credit_Term_Type__c') !=''|| string.valueof(OnboardingReq.Proposed_Credit_Term_Type__c) !=null) ){
                        if((string.valueof(OnboardingReq.Proposed_Credit_Term_Type__c) <> fieldmodifiedmap.get('Proposed_Credit_Term_Type__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Credit Term Type';
                        }
                    }
                }
            }
            else if(string.valueof('Activity_Code__c') == s){
                if((fieldmodifiedmap.get('Activity_Code__c') !=''&& string.valueof(OnboardingReq.Activity_Code__c) !=null) ||(fieldmodifiedmap.get('Activity_Code__c') !=''|| string.valueof(OnboardingReq.Activity_Code__c) !=null) ){
                    if((string.valueof(OnboardingReq.Activity_Code__c) <> fieldmodifiedmap.get('Activity_Code__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Activity Code';
                    }
                }
            }
            else if(string.valueof('Distribution_Type__c') == s){
                if((fieldmodifiedmap.get('Distribution_Type__c') !=''&& string.valueof(OnboardingReq.Distribution_Type__c) !=null) ||(fieldmodifiedmap.get('Distribution_Type__c') !=''|| string.valueof(OnboardingReq.Distribution_Type__c) !=null) ){
                    if((string.valueof(OnboardingReq.Distribution_Type__c) <> fieldmodifiedmap.get('Distribution_Type__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Distribution Type';
                    }
                }
            }
            else if(string.valueof('Express_Station__c') == s){
                if((fieldmodifiedmap.get('Express_Station__c') !=''&& string.valueof(OnboardingReq.Express_Station__c) !=null) ||(fieldmodifiedmap.get('Express_Station__c') !=''|| string.valueof(OnboardingReq.Express_Station__c) !=null) ){
                    if((string.valueof(OnboardingReq.Express_Station__c) <> fieldmodifiedmap.get('Express_Station__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Express Station';
                    }
                }
            }
            else if(string.valueof('Train_Station__c') == s){
                if((fieldmodifiedmap.get('Train_Station__c') !=''&& string.valueof(OnboardingReq.Train_Station__c) !=null) ||(fieldmodifiedmap.get('Train_Station__c') !=''|| string.valueof(OnboardingReq.Train_Station__c) !=null) ){
                    if((string.valueof(OnboardingReq.Train_Station__c) <> fieldmodifiedmap.get('Train_Station__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Train Station';
                    }
                }
            }
            else if(string.valueof('Location_No_1__c') == s){
                if((fieldmodifiedmap.get('Location_No_1__c') !=''&& string.valueof(OnboardingReq.Location_No_1__c) !=null) ||(fieldmodifiedmap.get('Location_No_1__c') !=''|| string.valueof(OnboardingReq.Location_No_1__c) !=null) ){
                    if((string.valueof(OnboardingReq.Location_No_1__c) <> fieldmodifiedmap.get('Location_No_1__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Location No. 1';
                    }
                }
            }
            else if(string.valueof('Industry__c') == s){
                if((fieldmodifiedmap.get('Industry__c') !=''&& string.valueof(OnboardingReq.Industry__c) !=null) ||(fieldmodifiedmap.get('Industry__c') !=''|| string.valueof(OnboardingReq.Industry__c) !=null) ){
                    if((string.valueof(OnboardingReq.Industry__c) <> fieldmodifiedmap.get('Industry__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Industry';
                    }
                }
            }
            else if(string.valueof('Check_Digit__c') == s){
                if((fieldmodifiedmap.get('Check_Digit__c') !=''&& string.valueof(OnboardingReq.Check_Digit__c) !=null) ||(fieldmodifiedmap.get('Check_Digit__c') !=''|| string.valueof(OnboardingReq.Check_Digit__c) !=null) ){
                    if((string.valueof(OnboardingReq.Check_Digit__c) <> fieldmodifiedmap.get('Check_Digit__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Check Digit';
                    }
                }
            }
            else if(string.valueof('Data_line__c') == s){
                if((fieldmodifiedmap.get('Data_line__c') !=''&& string.valueof(OnboardingReq.Data_line__c) !=null) ||(fieldmodifiedmap.get('Data_line__c') !=''|| string.valueof(OnboardingReq.Data_line__c) !=null) ){
                    if((string.valueof(OnboardingReq.Data_line__c) <> fieldmodifiedmap.get('Data_line__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Data line';
                    }
                }
            }
            else if(string.valueof('Fiscal_address__c') == s){
                if((fieldmodifiedmap.get('Fiscal_address__c') !=''&& string.valueof(OnboardingReq.Fiscal_address__c) !=null) ||(fieldmodifiedmap.get('Fiscal_address__c') !=''|| string.valueof(OnboardingReq.Fiscal_address__c) !=null) ){
                    if((string.valueof(OnboardingReq.Fiscal_address__c) <> fieldmodifiedmap.get('Fiscal_address__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Fiscal address';
                    }
                }
            }   

            else if(string.valueof('Customer_Segment__c') == s){
                if((fieldmodifiedmap.get('Customer_Segment__c') !=''&& string.valueof(OnboardingReq.Customer_Segment__c) !=null) ||(fieldmodifiedmap.get('Customer_Segment__c') !=''|| string.valueof(OnboardingReq.Customer_Segment__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Segment__c) <> fieldmodifiedmap.get('Customer_Segment__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Segment';
                    }
                }
            }   
            else if(string.valueof('Vendor__c') == s){
                if((fieldmodifiedmap.get('Vendor__c') !=''&& string.valueof(OnboardingReq.Vendor__c) !=null) ||(fieldmodifiedmap.get('Vendor__c') !=''|| string.valueof(OnboardingReq.Vendor__c) !=null) ){
                    if((string.valueof(OnboardingReq.Vendor__c) <> fieldmodifiedmap.get('Vendor__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Vendor';
                    }
                }
            }
            else if(string.valueof('Customer_language__c') == s){
                if((fieldmodifiedmap.get('Customer_language__c') !=''&& string.valueof(OnboardingReq.Customer_language__c) !=null) ||(fieldmodifiedmap.get('Customer_language__c') !=''|| string.valueof(OnboardingReq.Customer_language__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_language__c) <> fieldmodifiedmap.get('Customer_language__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer language';
                    }
                }
            }
            else if(string.valueof('Tax_Code_1__c') == s){
                if((fieldmodifiedmap.get('Tax_Code_1__c') !=''&& string.valueof(OnboardingReq.Tax_Code_1__c) !=null) ||(fieldmodifiedmap.get('Tax_Code_1__c') !=''|| string.valueof(OnboardingReq.Tax_Code_1__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Code_1__c) <> fieldmodifiedmap.get('Tax_Code_1__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Tax Code 1';
                    }
                }
            }
            else if(string.valueof('Tax_Code_2__c') == s){
                if((fieldmodifiedmap.get('Tax_Code_2__c') !=''&& string.valueof(OnboardingReq.Tax_Code_2__c) !=null) ||(fieldmodifiedmap.get('Tax_Code_2__c') !=''|| string.valueof(OnboardingReq.Tax_Code_2__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Code_2__c) <> fieldmodifiedmap.get('Tax_Code_2__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Tax Code 2';
                    }
                }
            }
            else if(string.valueof('Equalization_Tax__c') == s){
                if((fieldmodifiedmap.get('Equalization_Tax__c') !=''&& string.valueof(OnboardingReq.Equalization_Tax__c) !=null) ||(fieldmodifiedmap.get('Equalization_Tax__c') !=''|| string.valueof(OnboardingReq.Equalization_Tax__c) !=null) ){
                    if((string.valueof(OnboardingReq.Equalization_Tax__c) <> fieldmodifiedmap.get('Equalization_Tax__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Equalization Tax';
                    }
                }
            }
            else if(string.valueof('Sales_Purchase_Tax__c') == s){
                if((fieldmodifiedmap.get('Sales_Purchase_Tax__c') !=''&& string.valueof(OnboardingReq.Sales_Purchase_Tax__c) !=null) ||(fieldmodifiedmap.get('Sales_Purchase_Tax__c') !=''|| string.valueof(OnboardingReq.Sales_Purchase_Tax__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sales_Purchase_Tax__c) <> fieldmodifiedmap.get('Sales_Purchase_Tax__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Sales/Purchase Tax';
                    }
                }
            }
            else if(string.valueof('Vat_Number__c') == s){
                if((fieldmodifiedmap.get('Vat_Number__c') !=''&& string.valueof(OnboardingReq.Vat_Number__c) !=null) ||(fieldmodifiedmap.get('Vat_Number__c') !=''|| string.valueof(OnboardingReq.Vat_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Vat_Number__c) <> fieldmodifiedmap.get('Vat_Number__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Vat Reg. No';
                    }
                }
            }
            else if(string.valueof('Trading_Partner__c') == s){
                if((fieldmodifiedmap.get('Trading_Partner__c') !=''&& string.valueof(OnboardingReq.Trading_Partner__c) !=null) ||(fieldmodifiedmap.get('Trading_Partner__c') !=''|| string.valueof(OnboardingReq.Trading_Partner__c) !=null) ){
                    if((string.valueof(OnboardingReq.Trading_Partner__c) <> fieldmodifiedmap.get('Trading_Partner__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' +'Trading Partner';
                    }
                }
            }
            else if(string.valueof('Customer_Type__c') == s){
                if((fieldmodifiedmap.get('Customer_Type__c') !=''&& string.valueof(OnboardingReq.Customer_Type__c) !=null) ||(fieldmodifiedmap.get('Customer_Type__c') !=''|| string.valueof(OnboardingReq.Customer_Type__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Type__c) <> fieldmodifiedmap.get('Customer_Type__c'))){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Type';
                    }
                }
            }
            else if(string.valueof('Natural_Person__c') == s){
                system.debug('Natural_Person__c = ' +OnboardingReq.Natural_Person__c);
                if((fieldmodifiedmap.get('Natural_Person__c') !=''&& string.valueof(OnboardingReq.Natural_Person__c) !=null) ||(fieldmodifiedmap.get('Natural_Person__c') !=''|| string.valueof(OnboardingReq.Natural_Person__c) !=null) ){
                    if((string.valueof(OnboardingReq.Natural_Person__c) <> fieldmodifiedmap.get('Natural_Person__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Natural Person';
                    }
                }
            }
            else if(string.valueof('Tax_Category__c') == s){
                if((fieldmodifiedmap.get('Tax_Category__c') !=''&& string.valueof(OnboardingReq.Tax_Category__c) !=null) ||(fieldmodifiedmap.get('Tax_Category__c') !=''|| string.valueof(OnboardingReq.Tax_Category__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Category__c) <> fieldmodifiedmap.get('Tax_Category__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Tax Category';
                    }
                }
            }
            else if(string.valueof('Tax_Number_Category__c') == s){
                if((fieldmodifiedmap.get('Tax_Number_Category__c') !=''&& string.valueof(OnboardingReq.Tax_Number_Category__c) !=null) ||(fieldmodifiedmap.get('Tax_Number_Category__c') !=''|| string.valueof(OnboardingReq.Tax_Number_Category__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Number_Category__c) <> fieldmodifiedmap.get('Tax_Number_Category__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Tax Number Category';
                    }
                }
            }
            else if(string.valueof('Tax_Code_3__c') == s){
                if((fieldmodifiedmap.get('Tax_Code_3__c') !=''&& string.valueof(OnboardingReq.Tax_Code_3__c) !=null) ||(fieldmodifiedmap.get('Tax_Code_3__c') !=''|| string.valueof(OnboardingReq.Tax_Code_3__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Code_3__c) <> fieldmodifiedmap.get('Tax_Code_3__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Tax Code 3';
                    }
                }
            }
            else if(string.valueof('Tax_Code_4__c') == s){
                if((fieldmodifiedmap.get('Tax_Code_4__c') !=''&& string.valueof(OnboardingReq.Tax_Code_4__c) !=null) ||(fieldmodifiedmap.get('Tax_Code_4__c') !=''|| string.valueof(OnboardingReq.Tax_Code_4__c) !=null) ){
                    if((string.valueof(OnboardingReq.Tax_Code_4__c) <> fieldmodifiedmap.get('Tax_Code_4__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Tax Code 4';
                    }
                }
            }
            else if(string.valueof('Business_Type__c') == s){
                if((fieldmodifiedmap.get('Business_Type__c') !=''&& string.valueof(OnboardingReq.Business_Type__c) !=null) ||(fieldmodifiedmap.get('Business_Type__c') !=''|| string.valueof(OnboardingReq.Business_Type__c) !=null) ){
                    if((string.valueof(OnboardingReq.Business_Type__c) <> fieldmodifiedmap.get('Business_Type__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Business Type';
                    }
                }
            }
            else if(string.valueof('Teletex_Number__c') == s){
                if((fieldmodifiedmap.get('Teletex_Number__c') !=''&& string.valueof(OnboardingReq.Teletex_Number__c) !=null) ||(fieldmodifiedmap.get('Teletex_Number__c') !=''|| string.valueof(OnboardingReq.Teletex_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Teletex_Number__c) <> fieldmodifiedmap.get('Teletex_Number__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Teletex Number';
                    }
                }
            }
            else if(string.valueof('Telex_Number__c') == s){
                if((fieldmodifiedmap.get('Telex_Number__c') !=''&& string.valueof(OnboardingReq.Telex_Number__c) !=null) ||(fieldmodifiedmap.get('Telex_Number__c') !=''|| string.valueof(OnboardingReq.Telex_Number__c) !=null) ){
                    if((string.valueof(OnboardingReq.Telex_Number__c) <> fieldmodifiedmap.get('Telex_Number__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Telex Number';
                    }
                }
            }
            else if(string.valueof('Location_No_2__c') == s){
                if((fieldmodifiedmap.get('Location_No_2__c') !=''&& string.valueof(OnboardingReq.Location_No_2__c) !=null) ||(fieldmodifiedmap.get('Location_No_2__c') !=''|| string.valueof(OnboardingReq.Location_No_2__c) !=null) ){
                    if((string.valueof(OnboardingReq.Location_No_2__c) <> fieldmodifiedmap.get('Location_No_2__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Location No. 2';
                    }
                }
            }
            else if(string.valueof('Authorization_Group__c') == s){
                if((fieldmodifiedmap.get('Authorization_Group__c') !=''&& string.valueof(OnboardingReq.Authorization_Group__c) !=null) ||(fieldmodifiedmap.get('Authorization_Group__c') !=''|| string.valueof(OnboardingReq.Authorization_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Authorization_Group__c) <> fieldmodifiedmap.get('Authorization_Group__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Authorization Group';
                    }
                }
            }
            else if(string.valueof('Customer_Statistics_Group__c') == s){
                if((fieldmodifiedmap.get('Customer_Statistics_Group__c') !=''&& string.valueof(OnboardingReq.Customer_Statistics_Group__c) !=null) ||(fieldmodifiedmap.get('Customer_Statistics_Group__c') !=''|| string.valueof(OnboardingReq.Customer_Statistics_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Statistics_Group__c) <> fieldmodifiedmap.get('Customer_Statistics_Group__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Statistics Group';
                    }
                }
            }
            else if(string.valueof('Customer_Price_Procedure__c') == s){
                if((fieldmodifiedmap.get('Customer_Price_Procedure__c') !=''&& string.valueof(OnboardingReq.Customer_Price_Procedure__c) !=null) ||(fieldmodifiedmap.get('Customer_Price_Procedure__c') !=''|| string.valueof(OnboardingReq.Customer_Price_Procedure__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Price_Procedure__c) <> fieldmodifiedmap.get('Customer_Price_Procedure__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Customer Price Procedure';
                    }
                }
            }
            else if(string.valueof('Sales_District__c') == s){
                if((fieldmodifiedmap.get('Sales_District__c') !=''&& string.valueof(OnboardingReq.Sales_District__c) !=null) ||(fieldmodifiedmap.get('Sales_District__c') !=''|| string.valueof(OnboardingReq.Sales_District__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sales_District__c) <> fieldmodifiedmap.get('Sales_District__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Sales District';
                    }
                }
            }
            else if(string.valueof('Price_Group__c') == s){
                if((fieldmodifiedmap.get('Price_Group__c') !=''&& string.valueof(OnboardingReq.Price_Group__c) !=null) ||(fieldmodifiedmap.get('Price_Group__c') !=''|| string.valueof(OnboardingReq.Price_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Price_Group__c) <> fieldmodifiedmap.get('Price_Group__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Price Group';
                    }
                }
            }
            else if(string.valueof('Order_Probability__c') == s){
                system.debug('Order_Probability__c = ' + OnboardingReq.Complete_Delivery_Required_by_Law__c);
                if((fieldmodifiedmap.get('Order_Probability__c') !=''&& string.valueof(OnboardingReq.Order_Probability__c) !=null) ||(fieldmodifiedmap.get('Order_Probability__c') !=''|| string.valueof(OnboardingReq.Order_Probability__c) !=null) ){
                    if((OnboardingReq.Order_Probability__c <> decimal.valueOf(fieldmodifiedmap.get('Order_Probability__c')))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Order Probability';
                    }
                }
            }
            else if(string.valueof('Maximum_Partial_Deliveries__c') == s){
                if((fieldmodifiedmap.get('Maximum_Partial_Deliveries__c') !=''&& string.valueof(OnboardingReq.Maximum_Partial_Deliveries__c) !=null) ||(fieldmodifiedmap.get('Maximum_Partial_Deliveries__c') !=''|| string.valueof(OnboardingReq.Maximum_Partial_Deliveries__c) !=null) ){
                    if((OnboardingReq.Maximum_Partial_Deliveries__c <> decimal.valueOf(fieldmodifiedmap.get('Maximum_Partial_Deliveries__c')))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Maximum Partial Deliveries';
                    }
                }
            }
            else if(string.valueof('Complete_Delivery_Required_by_Law__c') == s){
                system.debug('Complete_Delivery_Required_by_Law__c = ' + OnboardingReq.Complete_Delivery_Required_by_Law__c);
                if((fieldmodifiedmap.get('Complete_Delivery_Required_by_Law__c') !=''&& string.valueof(OnboardingReq.Complete_Delivery_Required_by_Law__c) !=null) ||(fieldmodifiedmap.get('Complete_Delivery_Required_by_Law__c') !=''|| string.valueof(OnboardingReq.Complete_Delivery_Required_by_Law__c) !=null) ){
                    if((string.valueof(OnboardingReq.Complete_Delivery_Required_by_Law__c) <> fieldmodifiedmap.get('Complete_Delivery_Required_by_Law__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Complete Delivery Required by Law';
                    }
                }
            }
            else if(string.valueof('Partial_Delivery_per_Item__c') == s){
                if((fieldmodifiedmap.get('Partial_Delivery_per_Item__c') !=''&& string.valueof(OnboardingReq.Partial_Delivery_per_Item__c) !=null) ||(fieldmodifiedmap.get('Partial_Delivery_per_Item__c') !=''|| string.valueof(OnboardingReq.Partial_Delivery_per_Item__c) !=null) ){
                    if((string.valueof(OnboardingReq.Partial_Delivery_per_Item__c) <> fieldmodifiedmap.get('Partial_Delivery_per_Item__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Partial Delivery per Item';
                    }
                }
            }
            else if(string.valueof('Order_Combination__c') == s){
                if((fieldmodifiedmap.get('Order_Combination__c') !=''&& string.valueof(OnboardingReq.Order_Combination__c) !=null) ||(fieldmodifiedmap.get('Order_Combination__c') !=''|| string.valueof(OnboardingReq.Order_Combination__c) !=null) ){
                    if((string.valueof(OnboardingReq.Order_Combination__c) <> fieldmodifiedmap.get('Order_Combination__c'))){ OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Order Combination';
                    }
                }
            }           
            else if(string.valueof('Delivery_priority__c') == s){
                if((fieldmodifiedmap.get('Delivery_priority__c') !=''&& string.valueof(OnboardingReq.Delivery_priority__c) !=null) ||(fieldmodifiedmap.get('Delivery_priority__c') !=''|| string.valueof(OnboardingReq.Delivery_priority__c) !=null) ){
                    if((string.valueof(OnboardingReq.Delivery_priority__c) <> fieldmodifiedmap.get('Delivery_priority__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Delivery Priority';
                    }
                }
            }
            else if(string.valueof('Default_Shipping_Conditions__c') == s){
                if((fieldmodifiedmap.get('Default_Shipping_Conditions__c') !=''&& string.valueof(OnboardingReq.Default_Shipping_Conditions__c) !=null) ||(fieldmodifiedmap.get('Default_Shipping_Conditions__c') !=''|| string.valueof(OnboardingReq.Default_Shipping_Conditions__c) !=null) ){
                    if((string.valueof(OnboardingReq.Default_Shipping_Conditions__c) <> fieldmodifiedmap.get('Default_Shipping_Conditions__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Shipping Conditions';
                    }
                }
            }
            else if(string.valueof('Subs_Invoice_Processing__c') == s){
                system.debug('Subs_Invoice_Processing__c = ' + OnboardingReq.Complete_Delivery_Required_by_Law__c);
                if((fieldmodifiedmap.get('Subs_Invoice_Processing__c') !=''&& string.valueof(OnboardingReq.Subs_Invoice_Processing__c) !=null) ||(fieldmodifiedmap.get('Subs_Invoice_Processing__c') !=''|| string.valueof(OnboardingReq.Subs_Invoice_Processing__c) !=null) ){
                    if((string.valueof(OnboardingReq.Subs_Invoice_Processing__c) <> fieldmodifiedmap.get('Subs_Invoice_Processing__c'))){  OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Subs. Invoice Processing';
                    }
                }
            }
            else if(string.valueof('Invoicing_Dates__c') == s){
                if((fieldmodifiedmap.get('Invoicing_Dates__c') !=''&& string.valueof(OnboardingReq.Invoicing_Dates__c) !=null) ||(fieldmodifiedmap.get('Invoicing_Dates__c') !=''|| string.valueof(OnboardingReq.Invoicing_Dates__c) !=null) ){
                    if((string.valueof(OnboardingReq.Invoicing_Dates__c) <> fieldmodifiedmap.get('Invoicing_Dates__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Invoicing Dates';
                    }
                }
            }
            else if(string.valueof('Invoicing_List_Dates__c') == s){
                if((fieldmodifiedmap.get('Invoicing_List_Dates__c') !=''&& string.valueof(OnboardingReq.Invoicing_List_Dates__c) !=null) ||(fieldmodifiedmap.get('Invoicing_List_Dates__c') !=''|| string.valueof(OnboardingReq.Invoicing_List_Dates__c) !=null) ){
                    if((string.valueof(OnboardingReq.Invoicing_List_Dates__c) <> fieldmodifiedmap.get('Invoicing_List_Dates__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Invoicing List Dates';
                    }
                }
            }
            else if(string.valueof('ABC_Class__c') == s){
                if((fieldmodifiedmap.get('ABC_Class__c') !=''&& string.valueof(OnboardingReq.ABC_Class__c) !=null) ||(fieldmodifiedmap.get('ABC_Class__c') !=''|| string.valueof(OnboardingReq.ABC_Class__c) !=null) ){
                    if((string.valueof(OnboardingReq.ABC_Class__c) <> fieldmodifiedmap.get('ABC_Class__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'ABC Class';
                    }
                }
            }
            else if(string.valueof('Account_Assignment_Group__c') == s){
                if((fieldmodifiedmap.get('Account_Assignment_Group__c') !=''&& string.valueof(OnboardingReq.Account_Assignment_Group__c) !=null) ||(fieldmodifiedmap.get('Account_Assignment_Group__c') !=''|| string.valueof(OnboardingReq.Account_Assignment_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Account_Assignment_Group__c) <> fieldmodifiedmap.get('Account_Assignment_Group__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Account Assignment Group';
                    }
                }
            }
            else if(string.valueof('Proposed_Terms_of_Payment__c') == s){
                if((fieldmodifiedmap.get('Proposed_Terms_of_Payment__c') !=''&& string.valueof(OnboardingReq.Proposed_Terms_of_Payment__c) !=null) ||(fieldmodifiedmap.get('Proposed_Terms_of_Payment__c') !=''|| string.valueof(OnboardingReq.Proposed_Terms_of_Payment__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Terms_of_Payment__c) <> fieldmodifiedmap.get('Proposed_Terms_of_Payment__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Terms of Payment';
                    }
                }
            }
            else if(string.valueof('Delivery_plant__c') == s){
                if((fieldmodifiedmap.get('Delivery_plant__c') !=''&& string.valueof(OnboardingReq.Delivery_plant__c) !=null) ||(fieldmodifiedmap.get('Delivery_plant__c') !=''|| string.valueof(OnboardingReq.Delivery_plant__c) !=null) ){
                    if((string.valueof(OnboardingReq.Delivery_plant__c) <> fieldmodifiedmap.get('Delivery_plant__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Delivery Plant';
                    }
                }
            }
            else if(string.valueof('Number_of_Org_Bills_of_Lading__c') == s){
                if((fieldmodifiedmap.get('Number_of_Org_Bills_of_Lading__c') !=''&& string.valueof(OnboardingReq.Number_of_Org_Bills_of_Lading__c) !=null) ||(fieldmodifiedmap.get('Number_of_Org_Bills_of_Lading__c') !=''|| string.valueof(OnboardingReq.Number_of_Org_Bills_of_Lading__c) !=null) ){
                    if((OnboardingReq.Number_of_Org_Bills_of_Lading__c <> decimal.valueOf(fieldmodifiedmap.get('Number_of_Org_Bills_of_Lading__c'))) && (string.valueof(OnboardingReq.Number_of_Org_Bills_of_Lading__c) <> '0' && fieldmodifiedmap.get('Number_of_Org_Bills_of_Lading__c') <> '0')){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Number of Org Bills of Lading';
                    }
                }
            }
            else if(string.valueof('Number_of_Copies_of_Bills_of_Lading__c') == s){
                if((string.valueof(OnboardingReq.Number_of_Copies_of_Bills_of_Lading__c) <> fieldmodifiedmap.get('Number_of_Copies_of_Bills_of_Lading__c')) && (string.valueof(OnboardingReq.Number_of_Copies_of_Bills_of_Lading__c) <> '0' && fieldmodifiedmap.get('Number_of_Copies_of_Bills_of_Lading__c') <> '0')){
                    if((OnboardingReq.Number_of_Copies_of_Bills_of_Lading__c <> decimal.valueOf(fieldmodifiedmap.get('Number_of_Copies_of_Bills_of_Lading__c'))) ){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Number of Copies of Bills of Lading';
                    }
                }
            }
            else if(string.valueof('Sales_Group__c') == s){
                if((fieldmodifiedmap.get('Sales_Group__c') !=''&& string.valueof(OnboardingReq.Sales_Group__c) !=null) ||(fieldmodifiedmap.get('Sales_Group__c') !=''|| string.valueof(OnboardingReq.Sales_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sales_Group__c) <> fieldmodifiedmap.get('Sales_Group__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Sales Group';
                    }
                }
            }
            else if(string.valueof('Item_Proposal__c') == s){
                if((fieldmodifiedmap.get('Item_Proposal__c') !=''&& string.valueof(OnboardingReq.Item_Proposal__c) !=null) ||(fieldmodifiedmap.get('Item_Proposal__c') !=''|| string.valueof(OnboardingReq.Item_Proposal__c) !=null) ){
                    if((string.valueof(OnboardingReq.Item_Proposal__c) <> fieldmodifiedmap.get('Item_Proposal__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Item Proposal';
                    }
                }
            }
            else if(string.valueof('Rebates__c') == s){
                system.debug('Rebates__c = ' + OnboardingReq.Complete_Delivery_Required_by_Law__c);
                if((fieldmodifiedmap.get('Rebates__c') !=''&& string.valueof(OnboardingReq.Rebates__c) !=null) ||(fieldmodifiedmap.get('Rebates__c') !=''|| string.valueof(OnboardingReq.Rebates__c) !=null) ){
                    if((string.valueof(OnboardingReq.Rebates__c) <> fieldmodifiedmap.get('Rebates__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Rebates';
                    }
                }
            }
            else if(string.valueof('Exchange_Rate_type__c') == s){
                if((fieldmodifiedmap.get('Exchange_Rate_type__c') !=''&& string.valueof(OnboardingReq.Exchange_Rate_type__c) !=null) ||(fieldmodifiedmap.get('Exchange_Rate_type__c') !=''|| string.valueof(OnboardingReq.Exchange_Rate_type__c) !=null) ){
                    if((string.valueof(OnboardingReq.Exchange_Rate_type__c) <> fieldmodifiedmap.get('Exchange_Rate_type__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Exchange Rate type';
                    }
                }
            }
            else if(string.valueof('Price_Determination__c') == s){
                system.debug('Price_Determination__c = ' + OnboardingReq.Complete_Delivery_Required_by_Law__c);
                if((fieldmodifiedmap.get('Price_Determination__c') !=''&& string.valueof(OnboardingReq.Price_Determination__c) !=null) ||(fieldmodifiedmap.get('Price_Determination__c') !=''|| string.valueof(OnboardingReq.Price_Determination__c) !=null) ){
                    if((string.valueof(OnboardingReq.Price_Determination__c) <> fieldmodifiedmap.get('Price_Determination__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Price Determination';
                    }
                }
            }
            else if(string.valueof('Payment_Guarantee_Procedure__c') == s){
                if((fieldmodifiedmap.get('Payment_Guarantee_Procedure__c') !=''&& string.valueof(OnboardingReq.Payment_Guarantee_Procedure__c) !=null) ||(fieldmodifiedmap.get('Payment_Guarantee_Procedure__c') !=''|| string.valueof(OnboardingReq.Payment_Guarantee_Procedure__c) !=null) ){
                    if((string.valueof(OnboardingReq.Payment_Guarantee_Procedure__c) <> fieldmodifiedmap.get('Payment_Guarantee_Procedure__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Payment Guarantee Procedure';
                    }
                }
            }
            else if(string.valueof('Credit_Control_Area__c') == s){
                if((fieldmodifiedmap.get('Credit_Control_Area__c') !=''&& string.valueof(OnboardingReq.Credit_Control_Area__c) !=null) ||(fieldmodifiedmap.get('Credit_Control_Area__c') !=''|| string.valueof(OnboardingReq.Credit_Control_Area__c) !=null) ){
                    if((string.valueof(OnboardingReq.Credit_Control_Area__c) <> fieldmodifiedmap.get('Credit_Control_Area__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Credit Control Area';
                    }
                }
            }
            else if(string.valueof('Switch_Off_Rounding__c') == s){
                if((fieldmodifiedmap.get('Switch_Off_Rounding__c') !=''&& string.valueof(OnboardingReq.Switch_Off_Rounding__c) !=null) ||(fieldmodifiedmap.get('Switch_Off_Rounding__c') !=''|| string.valueof(OnboardingReq.Switch_Off_Rounding__c) !=null) ){
                    if((string.valueof(OnboardingReq.Switch_Off_Rounding__c) <> fieldmodifiedmap.get('Switch_Off_Rounding__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Switch Off Rounding';
                    }
                }
            }
            else if(string.valueof('Relevant_for_Agency_Business__c') == s){
                if((fieldmodifiedmap.get('Relevant_for_Agency_Business__c') !=''&& string.valueof(OnboardingReq.Relevant_for_Agency_Business__c) !=null) ||(fieldmodifiedmap.get('Relevant_for_Agency_Business__c') !=''|| string.valueof(OnboardingReq.Relevant_for_Agency_Business__c) !=null) ){
                    if((string.valueof(OnboardingReq.Relevant_for_Agency_Business__c) <> fieldmodifiedmap.get('Relevant_for_Agency_Business__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Relevant for Agency Business';
                    }
                }
            }
            else if(string.valueof('Units_Group__c') == s){
                if((fieldmodifiedmap.get('Units_Group__c') !=''&& string.valueof(OnboardingReq.Units_Group__c) !=null) ||(fieldmodifiedmap.get('Units_Group__c') !=''|| string.valueof(OnboardingReq.Units_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Units_Group__c) <> fieldmodifiedmap.get('Units_Group__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Units Group';
                    }
                }
            }
            else if(string.valueof('Overdelivery_Tolerance__c') == s){
                if((fieldmodifiedmap.get('Overdelivery_Tolerance__c') !=''&& string.valueof(OnboardingReq.Overdelivery_Tolerance__c) !=null) ||(fieldmodifiedmap.get('Overdelivery_Tolerance__c') !=''|| string.valueof(OnboardingReq.Overdelivery_Tolerance__c) !=null) ){
                    if((OnboardingReq.Overdelivery_Tolerance__c <> decimal.valueOf(fieldmodifiedmap.get('Overdelivery_Tolerance__c')))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Overdelivery Tolerance';
                    }
                }
            }
            else if(string.valueof('Underdelivery_Tolerance__c') == s){
                if((fieldmodifiedmap.get('Underdelivery_Tolerance__c') !=''&& string.valueof(OnboardingReq.Underdelivery_Tolerance__c) !=null) ||(fieldmodifiedmap.get('Underdelivery_Tolerance__c') !=''|| string.valueof(OnboardingReq.Underdelivery_Tolerance__c) !=null) ){
                    if((OnboardingReq.Underdelivery_Tolerance__c <> decimal.valueOf(fieldmodifiedmap.get('Underdelivery_Tolerance__c')))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Underdelivery Tolerance';
                    }
                }
            }
            else if(string.valueof('Unlimited_Tolerance__c') == s){
                if((fieldmodifiedmap.get('Unlimited_Tolerance__c') !=''&& string.valueof(OnboardingReq.Unlimited_Tolerance__c) !=null) ||(fieldmodifiedmap.get('Unlimited_Tolerance__c') !=''|| string.valueof(OnboardingReq.Unlimited_Tolerance__c) !=null) ){
                    if((String.valueof(OnboardingReq.Unlimited_Tolerance__c) <> fieldmodifiedmap.get('Unlimited_Tolerance__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Unlimited Tolerance';
                    }
                }
            }
            else if(string.valueof('Product_Proposal_for_Customer_Procedure__c') == s){
                if((fieldmodifiedmap.get('Product_Proposal_for_Customer_Procedure__c') !=''&& string.valueof(OnboardingReq.Product_Proposal_for_Customer_Procedure__c) !=null) ||(fieldmodifiedmap.get('Product_Proposal_for_Customer_Procedure__c') !=''|| string.valueof(OnboardingReq.Product_Proposal_for_Customer_Procedure__c) !=null) ){
                    if((string.valueof(OnboardingReq.Product_Proposal_for_Customer_Procedure__c) <> fieldmodifiedmap.get('Product_Proposal_for_Customer_Procedure__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Product Proposal for Customer Procedure';
                    }
                }
            }
            else if(string.valueof('Relevant_for_POD__c') == s){
                if((fieldmodifiedmap.get('Relevant_for_POD__c') !=''&& string.valueof(OnboardingReq.Relevant_for_POD__c) !=null) ||(fieldmodifiedmap.get('Relevant_for_POD__c') !=''|| string.valueof(OnboardingReq.Relevant_for_POD__c) !=null) ){
                    if((String.valueof(OnboardingReq.Relevant_for_POD__c) <> fieldmodifiedmap.get('Relevant_for_POD__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Relevant for POD';
                    }
                }
            }
            else if(string.valueof('POD_Timeframe__c') == s){
                if((fieldmodifiedmap.get('POD_Timeframe__c') !=''&& string.valueof(OnboardingReq.POD_Timeframe__c) !=null) ||(fieldmodifiedmap.get('POD_Timeframe__c') !=''|| string.valueof(OnboardingReq.POD_Timeframe__c) !=null) ){
                    if((string.valueof(OnboardingReq.POD_Timeframe__c) <> fieldmodifiedmap.get('POD_Timeframe__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'POD Timeframe';
                    }
                }
            }
            else if(string.valueof('Receiving_Storage_Location__c') == s){
                if((fieldmodifiedmap.get('Receiving_Storage_Location__c') !=''&& string.valueof(OnboardingReq.Receiving_Storage_Location__c) !=null) ||(fieldmodifiedmap.get('Receiving_Storage_Location__c') !=''|| string.valueof(OnboardingReq.Receiving_Storage_Location__c) !=null) ){
                    if((string.valueof(OnboardingReq.Receiving_Storage_Location__c) <> fieldmodifiedmap.get('Receiving_Storage_Location__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Receiving Storage Location';
                    }
                }
            }
            else if(string.valueof('Copy_of_Booking_Message__c') == s){
                if((fieldmodifiedmap.get('Copy_of_Booking_Message__c') !=''&& string.valueof(OnboardingReq.Copy_of_Booking_Message__c) !=null) ||(fieldmodifiedmap.get('Copy_of_Booking_Message__c') !=''|| string.valueof(OnboardingReq.Copy_of_Booking_Message__c) !=null) ){
                    if((string.valueof(OnboardingReq.Copy_of_Booking_Message__c) <> fieldmodifiedmap.get('Copy_of_Booking_Message__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Copy of Booking Message';
                    }
                }
            }
            else if(string.valueof('Duty_Indicator__c') == s){
                if((fieldmodifiedmap.get('Duty_Indicator__c') !=''&& string.valueof(OnboardingReq.Duty_Indicator__c) !=null) ||(fieldmodifiedmap.get('Duty_Indicator__c') !=''|| string.valueof(OnboardingReq.Duty_Indicator__c) !=null) ){
                    if((string.valueof(OnboardingReq.Duty_Indicator__c) <> fieldmodifiedmap.get('Duty_Indicator__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Duty Indicator';
                    }
                }
            }
            else if(string.valueof('Data_Type_on_Delivery__c') == s){
                if((fieldmodifiedmap.get('Data_Type_on_Delivery__c') !=''&& string.valueof(OnboardingReq.Data_Type_on_Delivery__c) !=null) ||(fieldmodifiedmap.get('Data_Type_on_Delivery__c') !=''|| string.valueof(OnboardingReq.Data_Type_on_Delivery__c) !=null) ){
                    if((string.valueof(OnboardingReq.Data_Type_on_Delivery__c) <> fieldmodifiedmap.get('Data_Type_on_Delivery__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Data Type on Delivery';
                    }
                }
            }
            else if(string.valueof('Shipping_Instruction__c') == s){
                if((fieldmodifiedmap.get('Shipping_Instruction__c') !=''&& string.valueof(OnboardingReq.Shipping_Instruction__c) !=null) ||(fieldmodifiedmap.get('Shipping_Instruction__c') !=''|| string.valueof(OnboardingReq.Shipping_Instruction__c) !=null) ){
                    if((string.valueof(OnboardingReq.Shipping_Instruction__c) <> fieldmodifiedmap.get('Shipping_Instruction__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Shipping Instruction';
                    }
                }
            }
            else if(string.valueof('Warehouse_instruction__c') == s){
                if((fieldmodifiedmap.get('Warehouse_instruction__c') !=''&& string.valueof(OnboardingReq.Warehouse_instruction__c) !=null) ||(fieldmodifiedmap.get('Warehouse_instruction__c') !=''|| string.valueof(OnboardingReq.Warehouse_instruction__c) !=null) ){
                    if((string.valueof(OnboardingReq.Warehouse_instruction__c) <> fieldmodifiedmap.get('Warehouse_instruction__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Warehouse Instruction';
                    }
                }
            }
            else if(string.valueof('Default_Incoterms_1__c') == s){
                if((fieldmodifiedmap.get('Default_Incoterms_1__c') !=''&& string.valueof(OnboardingReq.Default_Incoterms_1__c) !=null) ||(fieldmodifiedmap.get('Default_Incoterms_1__c') !=''|| string.valueof(OnboardingReq.Default_Incoterms_1__c) !=null) ){
                    if((string.valueof(OnboardingReq.Default_Incoterms_1__c) <> fieldmodifiedmap.get('Default_Incoterms_1__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Incoterms 1';
                    }
                }
            }

            else if(string.valueof('Default_Incoterms_2__c') == s){
                if((fieldmodifiedmap.get('Default_Incoterms_2__c') !=''&& string.valueof(OnboardingReq.Default_Incoterms_2__c) !=null) ||(fieldmodifiedmap.get('Default_Incoterms_2__c') !=''|| string.valueof(OnboardingReq.Default_Incoterms_2__c) !=null) ){
                    if((string.valueof(OnboardingReq.Default_Incoterms_2__c) <> fieldmodifiedmap.get('Default_Incoterms_2__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Incoterms 2';
                    }
                }
            }
            else if(string.valueof('Argentina_Tax_Categories__c') == s){
                if((fieldmodifiedmap.get('Argentina_Tax_Categories__c') !=''&& string.valueof(OnboardingReq.Argentina_Tax_Categories__c) !=null) ||(fieldmodifiedmap.get('Argentina_Tax_Categories__c') !=''|| string.valueof(OnboardingReq.Argentina_Tax_Categories__c) !=null) ){
                    if((string.valueof(OnboardingReq.Argentina_Tax_Categories__c) <> fieldmodifiedmap.get('Argentina_Tax_Categories__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Argentina Tax Categories';
                    }
                }
            }
            else if(string.valueof('Customer_group_1__c') == s){
                if((fieldmodifiedmap.get('Customer_group_1__c') !=''&& string.valueof(OnboardingReq.Customer_group_1__c) !=null) ||(fieldmodifiedmap.get('Customer_group_1__c') !=''|| string.valueof(OnboardingReq.Customer_group_1__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_group_1__c) <> fieldmodifiedmap.get('Customer_group_1__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer Group 1';
                    }
                }
            }
            else if(string.valueof('Customer_Group_2__c') == s){
                if((fieldmodifiedmap.get('Customer_Group_2__c') !=''&& string.valueof(OnboardingReq.Customer_Group_2__c) !=null) ||(fieldmodifiedmap.get('Customer_Group_2__c') !=''|| string.valueof(OnboardingReq.Customer_Group_2__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Group_2__c) <> fieldmodifiedmap.get('Customer_Group_2__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer Group 2';
                    }
                }
            }
            else if(string.valueof('Customer_Group_3__c') == s){
                if((fieldmodifiedmap.get('Customer_Group_3__c') !=''&& string.valueof(OnboardingReq.Customer_Group_3__c) !=null) ||(fieldmodifiedmap.get('Customer_Group_3__c') !=''|| string.valueof(OnboardingReq.Customer_Group_3__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_Group_3__c) <> fieldmodifiedmap.get('Customer_Group_3__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer Group 3';
                    }
                }
            }
            else if(string.valueof('Customer_group_4__c') == s){
                if((fieldmodifiedmap.get('Customer_group_4__c') !=''&& string.valueof(OnboardingReq.Customer_group_4__c) !=null) ||(fieldmodifiedmap.get('Customer_group_4__c') !=''|| string.valueof(OnboardingReq.Customer_group_4__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_group_4__c) <> fieldmodifiedmap.get('Customer_group_4__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer Group 4';
                    }
                }
            }
            else if(string.valueof('Customer_group_5__c') == s){
                if((fieldmodifiedmap.get('Customer_group_5__c') !=''&& string.valueof(OnboardingReq.Customer_group_5__c) !=null) ||(fieldmodifiedmap.get('Customer_group_5__c') !=''|| string.valueof(OnboardingReq.Customer_group_5__c) !=null) ){
                    if((string.valueof(OnboardingReq.Customer_group_5__c) <> fieldmodifiedmap.get('Customer_group_5__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Customer Group 5';
                    }
                }
            }
            else if(string.valueof('Price_List_Type__c') == s){
                if((fieldmodifiedmap.get('Price_List_Type__c') !=''&& string.valueof(OnboardingReq.Price_List_Type__c) !=null) ||(fieldmodifiedmap.get('Price_List_Type__c') !=''|| string.valueof(OnboardingReq.Price_List_Type__c) !=null) ){
                    if((string.valueof(OnboardingReq.Price_List_Type__c) <> fieldmodifiedmap.get('Price_List_Type__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Price List Type';
                    }
                }
            }   
            else if(string.valueof('Search_Term__c') == s){
                if((fieldmodifiedmap.get('Search_Term__c') !=''&& string.valueof(OnboardingReq.Search_Term__c) !=null) ||(fieldmodifiedmap.get('Search_Term__c') !=''|| string.valueof(OnboardingReq.Search_Term__c) !=null) ){
                    if((string.valueof(OnboardingReq.Search_Term__c) <> fieldmodifiedmap.get('Search_Term__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Search Term 1/2';
                    }
                }
            }
            else if(string.valueof('Sales_Office__c') == s){
                if((fieldmodifiedmap.get('Sales_Office__c') !=''&& string.valueof(OnboardingReq.Sales_Office__c) !=null) ||(fieldmodifiedmap.get('Sales_Office__c') !=''|| string.valueof(OnboardingReq.Sales_Office__c) !=null) ){
                    if((string.valueof(OnboardingReq.Sales_Office__c) <> fieldmodifiedmap.get('Sales_Office__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Sales Office';
                    }
                }
            }

            else if(string.valueof('P_O_Box_City__c') == s){
                if((fieldmodifiedmap.get('P_O_Box_City__c') !=''&& string.valueof(OnboardingReq.P_O_Box_City__c) !=null) ||(fieldmodifiedmap.get('P_O_Box_City__c') !=''|| string.valueof(OnboardingReq.P_O_Box_City__c) !=null) ){
                    if((string.valueof(OnboardingReq.P_O_Box_City__c) <> fieldmodifiedmap.get('P_O_Box_City__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'P.O.Box City';
                    }
                }
            }
            /***********************************************************************************************************/   
            else if(string.valueof('Dunning_Procedure__c') == s){
                if((fieldmodifiedmap.get('Dunning_Procedure__c') !=''&& string.valueof(OnboardingReq.Dunning_Procedure__c) !=null) ||(fieldmodifiedmap.get('Dunning_Procedure__c') !=''|| string.valueof(OnboardingReq.Dunning_Procedure__c) !=null) ){
                    if((string.valueof(OnboardingReq.Dunning_Procedure__c) <> fieldmodifiedmap.get('Dunning_Procedure__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Dunning Procedure';
                    }
                }
            }

            else if(string.valueof('Dunning_Clerk_Code__c') == s){
                if((fieldmodifiedmap.get('Dunning_Clerk_Code__c') !=''&& string.valueof(OnboardingReq.Dunning_Clerk_Code__c) !=null) ||(fieldmodifiedmap.get('Dunning_Clerk_Code__c') !=''|| string.valueof(OnboardingReq.Dunning_Clerk_Code__c) !=null) ){
                    if((string.valueof(OnboardingReq.Dunning_Clerk_Code__c) <> fieldmodifiedmap.get('Dunning_Clerk_Code__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Dunning Clerk Code';
                    }
                }
            }
            else if(string.valueof('Proposed_Credit_Limit__c') == s){
                if((fieldmodifiedmap.get('Proposed_Credit_Limit__c') !=''&& string.valueof(OnboardingReq.Proposed_Credit_Limit__c) !=null) ||(fieldmodifiedmap.get('Proposed_Credit_Limit__c') !=''|| string.valueof(OnboardingReq.Proposed_Credit_Limit__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Credit_Limit__c) <> string.valueOf(fieldmodifiedmap.get('Proposed_Credit_Limit__c')))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Credit Limit';
                    }
                }
            }

            else if(string.valueof('Proposed_Risk_Category__c') == s){
                if(OnboardingReq.Proposed_Risk_Category__c != null && OnboardingReq.Proposed_Risk_Category__c != '__'){
                    if((fieldmodifiedmap.get('Proposed_Risk_Category__c') !=''&& string.valueof(OnboardingReq.Proposed_Risk_Category__c) !=null) ||(fieldmodifiedmap.get('Proposed_Risk_Category__c') !=''|| string.valueof(OnboardingReq.Proposed_Risk_Category__c) !=null) ){
                        if((string.valueof(OnboardingReq.Proposed_Risk_Category__c) <> fieldmodifiedmap.get('Proposed_Risk_Category__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Risk Category';
                        }
                    }
                }
            }
            else if(string.valueof('Proposed_Cred_rep_grp__c') == s){
                if(OnboardingReq.Proposed_Cred_rep_grp__c != null){
                    if((fieldmodifiedmap.get('Proposed_Cred_rep_grp__c') !=''&& string.valueof(OnboardingReq.Proposed_Cred_rep_grp__c) !=null) ||(fieldmodifiedmap.get('Proposed_Cred_rep_grp__c') !=''|| string.valueof(OnboardingReq.Proposed_Cred_rep_grp__c) !=null) ){
                        if((string.valueof(OnboardingReq.Proposed_Cred_rep_grp__c) <> fieldmodifiedmap.get('Proposed_Cred_rep_grp__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Cred.rep.grp';
                        }
                    }
                }
            }
            else if(string.valueof('Proposed_Credit_Information_Number__c') == s){
                if((fieldmodifiedmap.get('Proposed_Credit_Information_Number__c') !=''&& string.valueof(OnboardingReq.Proposed_Credit_Information_Number__c) !=null) ||(fieldmodifiedmap.get('Proposed_Credit_Information_Number__c') !=''|| string.valueof(OnboardingReq.Proposed_Credit_Information_Number__c) !=null) ){
                    if((OnboardingReq.Proposed_Credit_Information_Number__c <> decimal.valueOf(fieldmodifiedmap.get('Proposed_Credit_Information_Number__c')))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Credit Information Number';
                    }
                }
            }
            else if(string.valueof('Proposed_Customer_Credit_Group__c') == s){
                if((fieldmodifiedmap.get('Proposed_Customer_Credit_Group__c') !=''&& string.valueof(OnboardingReq.Proposed_Customer_Credit_Group__c) !=null) ||(fieldmodifiedmap.get('Proposed_Customer_Credit_Group__c') !=''|| string.valueof(OnboardingReq.Proposed_Customer_Credit_Group__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Customer_Credit_Group__c) <> fieldmodifiedmap.get('Proposed_Customer_Credit_Group__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Customer Credit Group';
                    }
                }
            }

            else if(string.valueof('Proposed_Reference_Date__c') == s){

                if((fieldmodifiedmap.get('Proposed_Reference_Date__c') !='0000-00-00' && string.valueof(OnboardingReq.Proposed_Reference_Date__c) !=null) ||(fieldmodifiedmap.get('Proposed_Reference_Date__c') !='0000-00-00' || string.valueof(OnboardingReq.Proposed_Reference_Date__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Reference_Date__c) <> fieldmodifiedmap.get('Proposed_Reference_Date__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Reference Date';
                    }
                }
            }

            else if(string.valueof('Proposed_Payment_Index__c') == s){
                if((fieldmodifiedmap.get('Proposed_Payment_Index__c') !=''&& string.valueof(OnboardingReq.Proposed_Payment_Index__c) !=null) ||(fieldmodifiedmap.get('Proposed_Payment_Index__c') !=''|| string.valueof(OnboardingReq.Proposed_Payment_Index__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Payment_Index__c) <> fieldmodifiedmap.get('Proposed_Payment_Index__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Payment Index';
                    }
                }
            }

            else if(string.valueof('Proposed_Rating__c') == s){
                if((fieldmodifiedmap.get('Proposed_Rating__c') !=''&& string.valueof(OnboardingReq.Proposed_Rating__c) !=null) ||(fieldmodifiedmap.get('Proposed_Rating__c') !=''|| string.valueof(OnboardingReq.Proposed_Rating__c) !=null) ){
                    if((string.valueof(OnboardingReq.Proposed_Rating__c) <> fieldmodifiedmap.get('Proposed_Rating__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Rating';
                    }
                }
            }

            else if(string.valueof('Proposed_Credit_Limit_Currency_Code__c') == s){

                if((fieldmodifiedmap.get('Proposed_Credit_Limit_Currency_Code__c') !=''&& string.valueof(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c) !=null) ||(fieldmodifiedmap.get('Proposed_Credit_Limit_Currency_Code__c') !=''|| string.valueof(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c) !=null) ){

                    if((string.valueof(OnboardingReq.Proposed_Credit_Limit_Currency_Code__c) <> fieldmodifiedmap.get('Proposed_Credit_Limit_Currency_Code__c'))){ 
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Proposed Credit Limit Currency Code';
                    }
                }
            }

            else if(string.valueof('Last_External_Review__c') == s){
                if((fieldmodifiedmap.get('Last_External_Review__c') !='0000-00-00'&& string.valueof(OnboardingReq.Last_External_Review__c) !=null) ||(fieldmodifiedmap.get('Last_External_Review__c') !='0000-00-00'|| string.valueof(OnboardingReq.Last_External_Review__c) !=null) ){
                    if((string.valueof(OnboardingReq.Last_External_Review__c) <> fieldmodifiedmap.get('Last_External_Review__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Last External Review';
                    }
                }
            }

            else if(string.valueof('Last_Internal_Review__c') == s){
                if((fieldmodifiedmap.get('Last_Internal_Review__c') !='0000-00-00'&& string.valueof(OnboardingReq.Last_Internal_Review__c) !=null) ||(fieldmodifiedmap.get('Last_Internal_Review__c') !='0000-00-00'|| string.valueof(OnboardingReq.Last_Internal_Review__c) !=null) ){
                    if((string.valueof(OnboardingReq.Last_Internal_Review__c) <> fieldmodifiedmap.get('Last_Internal_Review__c'))){ OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Last Internal Review';
                    }   
                }
            }
            //<Alvin20150612> Added additional fields to field modified
            //<Alvin20150612> <----- End----->
            else if(string.valueof('Business_Strategic__c') == s){
                if(string.valueof(OnboardingReq.Business_Strategic__c) !=null){
                    if(string.valueof(OnboardingReq.Business_Strategic__c) <> fieldmodifiedmap.get('Business_Strategic__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Business Strategic';
                    }
                }
            }
            else if(string.valueof('Geocode__c') == s){
                if(string.valueof(OnboardingReq.Geocode__c) !=null){
                    if(string.valueof(OnboardingReq.Geocode__c) <> fieldmodifiedmap.get('Geocode__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Geo-Code';
                    }
                }
            }
            else if(string.valueof('Unloading_Point__c') == s){
                if(string.valueof(OnboardingReq.Unloading_Point__c) !=null){
                    if(string.valueof(OnboardingReq.Unloading_Point__c) <> fieldmodifiedmap.get('Unloading_Point__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Unloading point';
                    }
                }
            }
            else if(string.valueof('Business_Category__c') == s){
                if(string.valueof(OnboardingReq.Business_Category__c) !=null){
                    if(string.valueof(OnboardingReq.Business_Category__c) <> fieldmodifiedmap.get('Business_Category__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Business category';
                    }
                }
            }
            else if(string.valueof('Ownership_Type__c') == s){
                if(string.valueof(OnboardingReq.Ownership_Type__c) !=null){
                    if(string.valueof(OnboardingReq.Ownership_Type__c) <> fieldmodifiedmap.get('Ownership_Type__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Ownership Type';
                    }
                }
            }
            else if(string.valueof('Business_Partner_ID_Grouping__c') == s){
                if(string.valueof(OnboardingReq.Business_Partner_ID_Grouping__c) !=null){
                    if(string.valueof(OnboardingReq.Business_Partner_ID_Grouping__c) <> fieldmodifiedmap.get('Business_Partner_ID_Grouping__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Business Partner ID/Grouping';
                    }
                }
            }
            else if(string.valueof('Jurisdiction_Code__c') == s){

                if(string.valueof(OnboardingReq.Jurisdiction_Code__c) !=null){
                    if(string.valueof(OnboardingReq.Jurisdiction_Code__c) <> fieldmodifiedmap.get('Jurisdiction_Code__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Jurisdiction Code';
                    }
                }
            }
            else if(string.valueof('Registration_Number__c') == s){
                if(string.valueof(OnboardingReq.Registration_Number__c) !=null){
                    if(string.valueof(OnboardingReq.Registration_Number__c) <> fieldmodifiedmap.get('Registration_Number__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Registration number';
                    }
                }
            }
            else if(string.valueof('Ultimate_Consign_Type_attribute__c') == s){
                if(string.valueof(OnboardingReq.Ultimate_Consign_Type_attribute__c) !=null){
                    if(string.valueof(OnboardingReq.Ultimate_Consign_Type_attribute__c) <> fieldmodifiedmap.get('Ultimate_Consign_Type_attribute__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Ultimate consign type (attribute 5)';
                    }
                }
            }
            else if(string.valueof('Argentina_Withholding_Tax__c') == s){
                if(string.valueof(OnboardingReq.Argentina_Withholding_Tax__c) !=null){
                    if(string.valueof(OnboardingReq.Argentina_Withholding_Tax__c) <> fieldmodifiedmap.get('Argentina_Withholding_Tax__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'Argentina Withholding Tax';
                    }
                }
            }
            else if(string.valueof('CFOP__c') == s){
                if(string.valueof(OnboardingReq.CFOP__c) !=null){
                    if(string.valueof(OnboardingReq.CFOP__c) <> fieldmodifiedmap.get('CFOP__c')){
                        OnboardingReq.Fields_Modified_2__c = OnboardingReq.Fields_Modified_2__c + ';' + 'CFOP';
                    }
                }
            }
            else if(string.valueof('Preferred_Bank_Name__c') == s){
                if(string.valueof(OnboardingReq.Preferred_Bank_Name__c) !=null){
                    if(string.valueof(OnboardingReq.Preferred_Bank_Name__c) <> fieldmodifiedmap.get('Preferred_Bank_Name__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Preferred Bank Name';
                    }
                }
            }
            else if(string.valueof('Alternative_Preferred_Bank_Name__c') == s){
                if(string.valueof(OnboardingReq.Alternative_Preferred_Bank_Name__c) !=null){
                    if(string.valueof(OnboardingReq.Alternative_Preferred_Bank_Name__c) <> fieldmodifiedmap.get('Alternative_Preferred_Bank_Name__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Alternative Preferred Bank Name';
                    }
                }
            }
            else if(string.valueof('Estimated_Average_Monthly_Purchases__c') == s){
                if(string.valueof(OnboardingReq.Estimated_Average_Monthly_Purchases__c) !=null){
                    if(string.valueof(OnboardingReq.Estimated_Average_Monthly_Purchases__c) <> fieldmodifiedmap.get('Estimated_Average_Monthly_Purchases__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Estimated Average Monthly Purchases';
                    }
                }
            }
            else if(string.valueof('Estimated_Number_of_Orders_per_Month__c') == s){
                if(string.valueof(OnboardingReq.Estimated_Number_of_Orders_per_Month__c) !=null){
                    if(string.valueof(OnboardingReq.Estimated_Number_of_Orders_per_Month__c) <> fieldmodifiedmap.get('Estimated_Number_of_Orders_per_Month__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Estimated Number of Orders per Month';
                    }
                }
            }
            else if(string.valueof('Proposed_Customer_Group__c') == s){
                if(string.valueof(OnboardingReq.Proposed_Customer_Group__c) !=null){
                    if(string.valueof(OnboardingReq.Proposed_Customer_Group__c) <> fieldmodifiedmap.get('Proposed_Customer_Group__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Proposed Customer Group';
                    }
                }
            }
            else if(string.valueof('Customer_Currency__c') == s){
                if(string.valueof(OnboardingReq.Customer_Currency__c) !=null){
                    if(string.valueof(OnboardingReq.Customer_Currency__c) <> fieldmodifiedmap.get('Customer_Currency__c')){
                        OnboardingReq.Fields_Modified_1__c = OnboardingReq.Fields_Modified_1__c + ';' + 'Billing Currency';
                    }
                }
            }
            //<Alvin20150612> <----- End----->
        }
    }
    /***********************************************************************************************************/  

    /**
     * Name: validateFieldModified
     * Params: None
     * Description: Method to validate Request before Saving and submitting.
     */ 
    public void validateFieldModified(){    
        if(OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Terms of Payment') || OnboardingReq.Fields_Modified_2__c.contains('Proposed Credit Limit Currency Code')){
            if(OnboardingReq.RecordTypeId == ModifyExisting_COB_RTYPE && (OnboardingReq.Proposed_Credit_Limit__c !=null || OnboardingReq.Proposed_Credit_Limit_Est__c !=null || OnboardingReq.Preferred_Bank_Name__c !=null || OnboardingReq.Proposed_Credit_Term_Type__c !=null) && (OnboardingReq.Account_Group__c != 'Z001 ( Sold-to party )' && OnboardingReq.Account_Group__c != 'Z003 ( Pay-to party )')){
                this.IsError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Modify Credit Data for the selected Account Group'));
            }
        }   
    }
}
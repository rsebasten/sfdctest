/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name :ctrlBIeWarrantyInput
//Author :Manasa.R,Ankit Gupta<ankit.gupta@usa.duPont.com>
//Description: This class verifies the Warranty code and also saves the user and dealer details. 
//************************************<MG-20120725>***************************************************//
//Email :Manasa.Gupta@ind.dupont.com
//Date :2012/07/25
//Description : Added new methods to make the class more leverable when new countries are added.
//AGUPTA 2012-15-Oct - Added new method getListBrand_SPAIN() to fetch the brands list for SPAIN Country
//SL 2012-11-05 - Added new methods to fetch the brands list for Hungary,France and Denmark
//SL 2012-02-19 - Added new method to fetch the brands list for Germany
//SL20130326 Added new methods for NetherLands and Belgium brands
//SL20130408 - Added new method for Russia
//AGUPTA 20130602-Removed all methods getListBrand_UK() etc for individual countries.Added method getListBrand()
//AGUPTA 20130602- Added two new methods SearchColor() and getColorRecs() for corian color images
//AGUPTA 20130902 - Added three utility methods in wrapper class fetchData to query entitlement contacts based on the warranty code and sellerId
//AGUPTA 20130902 - Added new method verifyMontelli() and inner class ctrleRegistrationMontelli
//SHIVALI20150416 - Commented Code for checking terms and conditions and added a condition to check the privacycheck and add the contact to another campaign 
//ROHITSAINI20160329-Made function getEntitlementRecs parameterized and query based on only provided entitlement code 
///////////////////////////////////////////////////////////////////////////////////////////////////////////

public virtual with sharing class ctrlBIeWarrantyInput{
    
    /*This variable gives the record type for the entitlemnt*/
    public static Final Id ENTRECTYPEID = Rtype.getIdByDevName('Entitlement','BI_EMEA_Entitlement');
    public static String langValue;
    public Static String webOrigin;  
    public SiteField__c sitefields{set;get;}
    public ctrleRegistrationMontelli ctrlobj{set;get;} 
    public String sellerId{get;set;}                 
    /* Other field is set to false in begining*/
    public ctrlBIeWarrantyInput() {       
        sitefields =new SiteField__c();
        sitefields.recordTypeId=RType.getRecordTypeByDevName('SiteField__c','BI_EMEA_Warranty').Id;                                
        booOther=false;
        custDetails=new userAccount();        
        System.LoggingLevel level = LoggingLevel.DEBUG;        
    }
    
    // <MG-20120725> Added
    /*Get the customsetting name and lang from URL*/
    public Static String getwebOrigin() {
        webOrigin=System.currentPageReference().getParameters().get('webOrigin');
        return webOrigin;
    }
    public Static void setwebOrigin(String wbOrigin){
        webOrigin=wbOrigin;
    }
    public Static String getlangValue() {
        langValue=System.currentPageReference().getParameters().get('lang');
        return langValue;
    }
    public Static void setlangValue(String lanValue){
        langValue=lanValue;
    }
    public String getInfoLink() {
        fetchData infoLink = new fetchData();         
        return infoLink.getCustSettings().Info_link__c;
    }
     public String TermNConditionsLink() {
        fetchData infoLink = new fetchData();         
        return infoLink.getCustSettings().termsConditions_link__c;
    }
    public String HomePageLink() {
        fetchData infoLink = new fetchData();         
        return infoLink.getCustSettings().homePage_link__c;
    }
    ////////////////////////////////////////////////////////////
    /*Error msg displayed when required*/  
    public String getFetchedData() { 
        errorString=System.currentPageReference().getParameters().get('errorString');
        return errorString;
    }
    /* This method is used to display any info or error msg on the visualforce page*/
    public static void displayMessage(String level,String msg){
        ApexPages.Message requiredField;
        if(level.equalsIgnoreCase('INFO')){
            requiredField=new ApexPages.Message(ApexPages.Severity.INFO,msg);
        }else if(level.equalsIgnoreCase('FATAL')){
            requiredField=new ApexPages.Message(ApexPages.Severity.FATAL,msg);
        }
        ApexPages.addMessage(requiredField); 
    } 
    ////////////////// WRAPPER CLASS ///////////////////////
    /* Inner class for all the data base queried*/
    private without sharing class fetchData{
         String relatedMaterialId;
        /* This method gives the list of the entilement records of a particular record type*/        
        public List<Entitlement> getEntitlementRecs(String strEntitlementCode){//Rohit saini 20160329 issue IS ID-00067415 added parameter Entitlement Code
            List<Entitlement> entitlementList = new List<Entitlement>();
            entitlementList = [Select Entitlement_Code__c,Status,ServiceContract.StartDate From Entitlement where RecordTypeId=:ENTRECTYPEID and Entitlement_Code__c=:strEntitlementCode ];//Rohit saini 20160329 issue IS ID-00067415 added filter of Entitlement_Code__c in query
            return entitlementList;
        }
        /* This methods get the detials of the record for the required entitlement */
        public Entitlement getEntRecDetails(String strEntitlementCode){            
            Entitlement entitle = new Entitlement();
            if(strEntitlementCode!=null){
             entitle = [Select id,accountid,Related_Account__c,StartDate,EndDate,Description__c,Other_Comments__c,ServiceContract.Material__r.Id,Recommendation_Type__c  
                              from Entitlement where Entitlement_Code__c=:strEntitlementCode AND RecordTypeId=:ENTRECTYPEID];
            this.relatedMaterialId =  entitle.ServiceContract.Material__r.Id; 
            }
            return entitle;
        }
        // <MG-20120725> Modified ::: to read the custsettiong name from URL  
        /* This method get the custom setting records */
        public eWarrantyMapping__c getCustSettings(){
            eWarrantyMapping__c custSettingList = [Select Account_Currency__c,Application_2__c,Owning_Organization__c,Product_2__c,Subtype__c,
                                                   Type__c,RecordType_Account__c,RecordType_Contact__c,Optional_CampaignID__c,
                                                   Campaign_Id__c,Entitlement_Type__c,Qualification_Program_ID__c,Info_link__c,termsConditions_link__c,homePage_link__c from eWarrantyMapping__c where  name =:ctrlBIeWarrantyInput.getwebOrigin()];
            return custSettingList;
        }
        ///////////////////////////////////////////////////////////////////////////
        /* This method gets the recordtypes */
        public Id getRecordType(String sObj, String devName){
            Id recType = Rtype.getIdByDevName(sObj,devName);
            return recType;
        } 
        /* This method fetches all the dealer records and converts it into an option list*/
         public List<SelectOption> dealerAccRecords(String dName) {
            /* To get the dealer records */
            List<Qualification__c> accList= new List<Qualification__c>();
            // <MG-20120725> Modified :::: Method calling for getting the custom settings values       
            ID qualificationProgram =getCustSettings().Qualification_Program_ID__c;            
            /*convert the qualification list into options and return */
            //<RK 20140221> <START TAG> Modified
            if(dName!=null)
            accList =  [Select Qua.Account_Name__r.id,Qua.Account_Name__r.name,Qua.Account_Name__r.BillingStreet, Qua.Account_Name__r.BillingState, 
                        Qua.Account_Name__r.BillingPostalCode, Qua.Account_Name__r.BillingCountry, Qua.Account_Name__r.BillingCity from Qualification__c 
                        qua where qua.Qualification_Program__r.id=:qualificationProgram AND Qua.Account_Name__r.name LIKE : dName AND Qua.Account_Name__r.Account_Stage__c<>'Inactive' ORDER BY Qua.Account_Name__r.name LIMIT 1000];
            //<RK 2014022> <END TAG>  Modified
            List<SelectOption> options = new List<SelectOption>();
            for(Qualification__c acc : accList){
             options.add(new SelectOption((acc.Account_Name__r.id),(acc.Account_Name__r.name+','+acc.Account_Name__r.BillingStreet+','+acc.Account_Name__r.BillingCity))); 
            }
            return options;
        }
        /*This method returns the details of the dealer selected*/
        public Account dealerDetails(String dealerAccount){
            Account dealerAccId=new Account();
            if(dealerAccount!=null)
            dealerAccId=[select Id,name,BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity,Country__c  from Account where id=:dealerAccount];
            return dealerAccId;
        } 
        
        /***************************************************************************
         /query the material object records relevant to the Corian Colors
        /***************************************************************************/
          
         public List<Material__c> colorRecords(String entitlmntCode) {
            /* To get the dealer records */
            List<Material__c> matLocList= new List<Material__c>();
            // <MG-20120725> Modified :::: Method calling for getting the custom settings values            
            String webOriginColor = getwebOrigin();
            if(entitlmntCode!=null)
            matLocList =  [Select Id,Name,Product_Url__c from Material__c m where m.Parent_Material__r.id = : 
                            [SELECT name,ServiceContract.Material__r.id from entitlement where Entitlement_Code__c=:String.valueof(entitlmntCode)].ServiceContract.Material__r.id
                            AND m.Material_Type__c='Color' ORDER By Name ASC];
            return matLocList; 
        }    
        public Material__c colorDetails(String colorItem){            
            Material__c colorItemId=new Material__c();
            if(colorItem!=null) 
            colorItemId=[select Id,Name,Product_Url__c from Material__c where id=:colorItem];
            return colorItemId;
        }
       /**************************************************************************************************** 
        THREE METHODS(LINE:160-185) ADDED BY AG<ankit.gupta@usa.dupont.com> FOR eREGISTRATION MONTELLI RUSSIA
       /****************************************************************************************************/
       
       //<AGUPTA 20130902>QUERY THE ENTITLEMENT CONTACTS FOR THE ENTERED WARRANTY CODE      
       public List<EntitlementContact> getEntitlmntContactRecs(String code){
           List<EntitlementContact> entContctList=new List<EntitlementContact>();
           try{
           if(code!=null)
           entContctList=[SELECT id,Name,ContactId,EntitlementId from EntitlementContact where EntitlementId=:
              [SELECT id from Entitlement where entitlement_code__c =: code].Id];
              }
           catch(Exception e){System.debug('No Entitlement Contact Available');}
         return entContctList;
       } 
       
       //<AGUPTA 20130902>CACHE ALL THE CONTACTS FOR CONSTRUCTIONEMEA RECORDTYPE WITH MIGRATION DB ID NOT NULL
       public List<Contact> getContactRecs(){
           List<Contact> contactList=new List<Contact>(); 
           contactList=[Select id,Name,Migration_DB_Id__c From Contact where RecordTypeId=:Rtype.getIdByDevName('Contact','ConstructionEMEA') AND migration_DB_Id__c!=: NULL];
           return contactList;
       }
       
       //<AGUPTA 20130902>QUERY THE CONTACT FOR THE ENTERED SELLERID 
        public Contact getRelatedContact(String slrId){
           Contact c=new Contact(); 
           try{
           if(slrId!=null)
           c=[Select id,Name,Migration_DB_Id__c From Contact where RecordTypeId=:Rtype.getIdByDevName('Contact','ConstructionEMEA') AND migration_DB_Id__c=: slrId];
           }
           catch(Exception e){System.debug(e.getMessage());}
         return c;
        } 
       }  
       public with sharing class fetchColorData{        
            public String url{get;set;}
            public String Name{get;set;}
            public String Id{get;set;}       
       }
     
      ////<AGUPTA 20130902> CALL THIS METHOD FROM VF PAGE FOR FABRICATOR eREGISTRTAION MONTELLI RUSSIA 
       public PageReference verifyMontelli(){     
         ctrlobj= new ctrleRegistrationMontelli();  
         ctrlobj.entitlementCode=entitlementCode;         
         ctrlobj.sellerId=sellerId;           
         return ctrlobj.verifyWarrantyCode(ctrlobj.entitlementCode,ctrlobj.sellerId);
       }                
       ////<AG 20130902>End of changes
            
        /*wrapper class for updating */  
    private without sharing class userAccount{
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String postalAddr{get;set;}
        public String zipCode{get;set;}
        public String province{get;set;}
        public String city{get;set;}
        public String country{get;set;}
        public String email{get;set;}
        public String telephone{get;set;}
        public boolean privateCheck{get;set;}
        public String kitchenBrand{get;set;}
        public String kitchenBrandOther{get;set;}
        public Date endDate{get;set;}
        public String kitchenBrandName{get;set;}
        public String selCorianColor{get;set;}
        
        fetchData detailsPageDBQuery = new fetchData();
        // <MG-20120725> Modified :::: Method calling for getting the custom settings values            
        eWarrantyMapping__c custSettingList=detailsPageDBQuery.getCustSettings();           
        Id accRecType = detailsPageDBQuery.getRecordType('Account',custSettingList.RecordType_Account__c);
        Id conRecType = detailsPageDBQuery.getRecordType('Contact',custSettingList.RecordType_Contact__c);
        
        public void insertCustomerDetails(userAccount custDetails,String entitlementCode, Date dop, Id dealerId, String dealeraddr,Id colorItem,SiteField__c sitefld){
            Entitlement entitle;
            /*adding the user as an account*/ 
            try{
                Account acc_new = new Account(Name=custDetails.lastName,BillingStreet=custDetails.postalAddr,BillingPostalCode=custDetails.zipCode,BillingState=custDetails.province,BillingCity=custDetails.city,
                                              BillingCountry=custDetails.country,CurrencyIsoCode=custSettingList.Account_Currency__c,Application_2__c=custSettingList.Application_2__c,
                                              Phone=telephone,Owning_Organization__c=custSettingList.Owning_Organization__c,RecordTypeId=accRecType,
                                              Product_2__c=custSettingList.Product_2__c,Account_Sub_Type__c=custSettingList.Subtype__c,Type=custSettingList.Type__c,
                                              Country__c=country);
                insert acc_new;
                /*adding the user as a contact*/
                Contact con_new = new Contact(AccountId=acc_new.id,RecordTypeId=conRecType, FirstName=custDetails.firstName,LastName=custDetails.lastName,
                                              MailingStreet=custDetails.postalAddr,MailingPostalCode=custDetails.zipCode,MailingState=custDetails.city,Contact_Country__c=custDetails.country,
                                              Email=custDetails.email,Phone=custDetails.telephone);
                insert con_new; 
                 /* adding the contact to campaign*/
                LIST<campaignMember> members = new LIST<campaignMember>();
                //members.add(new campaignmember(campaignid=custSettingList.Campaign_Id__c,status='Member-Opt-In', ContactId=con_new.id, LastUpdatedLocation__c='Website'));
                members.add(new campaignmember(campaignid=custSettingList.Campaign_Id__c,status='Member-Opt-In', ContactId=con_new.id));                       
                //SHIVALI20150416 : START  
                if(custDetails.privateCheck==true){
                 //members.add(new campaignmember(campaignid=custSettingList.Optional_CampaignID__c,status='Member-Opt-In', ContactId=con_new.id, LastUpdatedLocation__c='Website'));                       
                 members.add(new campaignmember(campaignid=custSettingList.Optional_CampaignID__c,status='Member-Opt-In', ContactId=con_new.id));                       
                }
                //SHIVALI20150416 : END
                                     
                if(members.size() > 0){
                 insert members;
                }  
                /*update the entitlement*/                
                entitle = detailsPageDBQuery.getEntRecDetails(entitlementCode);
               /* updating dealer details*/
               if(dealerId <> null){
                entitle.Related_Account__c = dealerId;
               } else if (dealeraddr != null){
                entitle.Description__c=dealeraddr;
               }
               /*updating start and end date ,type, brand,color*/
               entitle.StartDate=dop;
               custDetails.endDate=dop.addYears(10);
               entitle.EndDate=custDetails.endDate;                                   
               entitle.Type=custSettingList.Entitlement_Type__c;
               if(colorItem!=null){
                   entitle.Material__c=colorItem;
                   custDetails.selCorianColor=[SELECT name from Material__c where Id=:colorItem].Name;
               }
               system.debug('###################'+Label.outLabel_brandOther);
               if(!custDetails.kitchenBrand.equalsIgnoreCase(Label.outLabel_brandOther)){
                   custDetails.kitchenBrandName =[SELECT name from Brand__c where Id=:custDetails.kitchenBrand].Name;  
               }
               system.debug('################### newwwwwww value'+Label.outLabel_brandOther);                             
               if(custDetails.kitchenBrand.equalsIgnoreCase(Label.outLabel_brandOther)){
                custDetails.kitchenBrandName = custDetails.kitchenBrand;    
                entitle.Other_Comments__c=custDetails.kitchenBrandOther;
                entitle.Brand__c='Other';
               }else{                
                entitle.Brand_Name__c=custDetails.kitchenBrand;
               }
               entitle.Primary_Contact__c=con_new.id;
               entitle.Reason_Question1__c=Label.Reason_Question1;
               entitle.Product_Question1__c=Label.Product_Question1;
               entitle.Service_Question1__c=Label.Service_Question1;               
               entitle.Reason_Answer1__c= String.valueof(sitefld.Purchase_Reason__c);
               entitle.Product_Answer1__c=String.valueof(sitefld.Product_Satisfaction__c);
               entitle.Service_Answer1__c=String.valueof(sitefld.Service_Satisfaction__c);                             
               update entitle;
               
              /*adding the contact to entitlement record*/
               LIST<EntitlementContact> entitleContact = new LIST<EntitlementContact>();
               entitleContact.add(new EntitlementContact (EntitlementId=entitle.id,ContactId=con_new.id,CurrencyIsoCode=custSettingList.Account_Currency__c));               
               insert entitleContact;                      
            }catch(DmlException dmlExp){  
                throw dmlExp;                    
            }catch(Exception exp){
                ctrlBIeWarrantyInput.displayMessage('FATAL',Label.Exception_On_Page);                
            }
        }
                
    }
    //////////////////////////////////////////////////////
     /*reset the form*/       
    public virtual PageReference reset(String errorString) {
        PageReference resetPage = Page.BI_eWarrantyInputPage;
        resetPage.getParameters().put('lang',getlangValue());
        // <MG-20120725> Modified :::: Added new parameter "webOrigin" while navigating .   
        resetPage.getParameters().put('webOrigin',getwebOrigin());
        resetPage.getParameters().put('errorString',errorString);
        resetPage.setRedirect(true);
        return resetPage;
    }
    /* Declaring the required variables*/
    public String entitlementCode{get;set;}   
    public Date dateofPurchase{get;set;}
    public String errorString{get;set;}   
    public String sDoP;
    ApexPages.Message requiredField;
    /* 
     *Page : BI_eWarrantyInputPage
     *This method validates the entered warranty code and date of purchase
     *On successful validation navigates to details page
     *In case of any error, displays corressponding error msg
     */
    public PageReference verifyWarrantyCode(){
        ApexPages.Message requiredField;
        String flag;
        Date todayDate = date.today();
        fetchData entRecs = new fetchData();
        try{
            /*Verifying entitlementode and date of purchase*/
            List<Entitlement> entitlementList = new List<Entitlement>();
            if(entitlementCode.length()!=0 && dateofPurchase<>null){
                sDoP = String.valueof(dateofPurchase);
                entitlementList = entRecs.getEntitlementRecs(entitlementCode);//Rohit saini 20160329 issue IS ID-00067415 Made function call paramaterized
                for(Entitlement ent: entitlementList){
                    /*check if entitlement code is present */
                    if(ent.Entitlement_Code__c.equals(entitlementCode)){
                        /*check if entitlement Inactive(not resgistered)*/
                        if(ent.Status.equalsIgnoreCase('Inactive')){
                            /*check if date of purchase is not greater then today's date */
                            if(dateofPurchase <= todayDate ) {
                                /*  check if date of purchse is not before produced date */
                                if(dateofPurchase >= ent.ServiceContract.StartDate){
                                    flag = 'true';                                 
                                    break;
                                }else{
                                    flag = 'false_dop_b4produced'; 
                                    break;
                                }
                            }else{
                                flag = 'false_dop_future'; 
                                break;
                            }                                                     
                        }else{
                            flag = 'registered'; 
                            break;
                        }
                    }else{
                        flag = 'false_warCode';
                    }
                }//Rohit saini 20160329 issue IS ID-00067415 start
                if(entitlementList.size()==0){
                    flag = 'false_warCode';
                }//Rohit saini issue IS ID-00067415 end
            }else{              
                flag = 'null_entry';
            }
            
            if(flag.equals('true')){
                PageReference eWarrantyDetailsPage = Page.BI_eWarrantyDetailsPage; 
                eWarrantyDetailsPage.getParameters().put('warrantyCode',entitlementCode);
                eWarrantyDetailsPage.getParameters().put('sDoP',sDoP);
                eWarrantyDetailsPage.getParameters().put('lang',getlangValue());
                // <MG-20120725> Modified :::: Added new parameter "webOrigin" while navigating to next page.     
                eWarrantyDetailsPage.getParameters().put('webOrigin',getwebOrigin());
                eWarrantyDetailsPage.setRedirect(false);
                System.debug(logginglevel.DEBUG,'Controller::::crtleWarrantuInput::::Method::::getFrabicator::::URL passed:'+eWarrantyDetailsPage);
                return eWarrantyDetailsPage;
            } else if(flag.equals('null_entry')){
                PageReference retPage = reset(Label.Null_Entry);
                return retPage;               
            }else if(flag.equals('false_warCode')){ 
                PageReference retPage = reset(Label.Incorrect_Warranty_Code);
                return retPage;
            }else if(flag.equals('registered')){
                PageReference retPage = reset(Label.Registerd_WarrantyCode);
                return retPage;
            }else if(flag.equals('false_dop_future')){
                PageReference retPage = reset(Label.Invalid_DateOfPurchase);
                return retPage;                
            }else if (flag.equals('false_dop_b4produced')){
                PageReference retPage = reset(Label.Invalid_DateOfPurchase_beforeProduced);
                return retPage;
            } else{
                PageReference retPage = reset(Label.Error_on_Page);
                return retPage;               
            }
            return null;
        }catch(Exception ex){
            PageReference retPage = reset(Label.Exception_On_Page);
            return retPage;
        }
    }   
    /*Adding the user and dealer details*/   
    public userAccount custDetails {get;set;}
    public String strEntitlementCode;
    public String strDoP;
    static Schema.DescribeFieldResult accCountry = Account.Country__c.getDescribe();
    static List<Schema.PicklistEntry> listCountry = accCountry.getPicklistValues();
    //static Schema.DescribeFieldResult kitBrand = Entitlement.Brand__c.getDescribe();
    //static List<Schema.PicklistEntry> listKitBrand= kitBrand.getPicklistValues();    
    public String dealerInfo{get;set;}
    public Account dealerAccId{get;set;}
    public String selectedDealerAddr{get;set;}    
    public boolean termsCheck{get;set;}
    public Date dtofPurchase{get;set;} 
    public Material__c colorItemId{get;set;}
    public String brandName;
    public Id brandId{get;set;}
    
    /*to get the list of country*/
    public List<SelectOption> getListCountry(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.picklist_None,Label.picklist_None));
        for(Integer i = 0;i < listCountry.size();i++ ){
            options.add(new SelectOption(listCountry[i].getValue(),listCountry[i].getLabel()));
        }
        return options;
    }
    /********************************************************************************
    /*Replacing the harcoded values to get the list of brand using the Brand object*/    
    /********************************************************************************/   
      
    public List<SelectOption> getListBrand(){
        List<SelectOption> options = new List<SelectOption>();
        List<Brand__c> brandList = new List<Brand__c>();
        brandList =  getBrandRecs();
        System.debug('THE BRAND VALUES ARE %%%%%%% '+brandList);
        for(Brand__c brand:brandList){
            options.add(new SelectOption(brand.Id,brand.Name));
        }
            options.add(new SelectOption(Label.outLabel_brandOther,Label.outLabel_brandOther));
        return options;
    }
    
    public List<Brand__c> getBrandRecs(){
        String webOri=getwebOrigin();
        List<Brand__c> brandList = new List<Brand__c>([select Id,Name from Brand__c where Owning_Organization__c='BI-Surf' ORDER BY Name ASC]);
        return brandList;
    }
    /**********************************************************************************
    /End of changes
    ***********************************************************************************/
    /*if brand selected is other then an text field is displayed*/
    public boolean booOther{get;set;}
    public void brandOther(){
        if(custDetails.kitchenBrand.equalsIgnoreCase(Label.outLabel_brandOther)){
            booOther=true;
        }else{
            booOther=false;
        }
    }
    /*get entitlement and date of purchase from the Url*/
    public String getstrEntitlementCode() {
        String URL = System.currentPageReference().getURL();
        strEntitlementCode=System.currentPageReference().getParameters().get('warrantyCode');
        return strEntitlementCode;
    }
    public void setstrEntitlementCode(String strEntitlementCode){
        this.strEntitlementCode=strEntitlementCode;
    }
    public String getstrDoP() {
        strDoP=System.currentPageReference().getParameters().get('sDoP');
        return strDoP;
    }
    public void setstrDoP(String strDoP){
        this.strDoP=strDoP;
    }
    /*
    *Page : BIEMEAewarrantydetailspage
    * On succesfull validation of warranty code
    * User, dealer details are updated 
    */
    public PageReference addDetails(){
        entitlementCode=strEntitlementCode;
        ApexPages.Message requiredField;
        ApexPages.Message requiredField1;    
        Date todayDate = date.today(); 
        Entitlement entitle; 
        try{                          
            dtofPurchase=Date.valueOf(strDoP);  
            if (custDetails.firstName.length()==0 || custDetails.lastName.length()==0 || custDetails.email.length()==0|| custDetails.postalAddr.length()==0 || custDetails.zipCode.length() ==0
             || custDetails.city.length()==0 || custDetails.telephone.length() ==0 || custDetails.kitchenBrand.equalsIgnoreCase(Label.picklist_None)|| custDetails.country.equalsIgnoreCase(Label.picklist_None)){ 
                 displayMessage('FATAL',Label.Null_Entry);
                 return null;
            }else{                                                                   
                /*To validate whether telephone is number*/
               Integer intTelephone = Util.stringToInteger(custDetails.telephone.trim());
                if(intTelephone == 0 || intTelephone == null){
                    displayMessage('FATAL',Label.Invalid_Telephone);
                    return null;                            
                }                
                System.debug('dealerInfo is '+dealerInfo);
                /*check for dealer detials*/                    
                if(dealerAccId == null && dealerInfo == null){
                    displayMessage('FATAL',Label.Null_Dealer);
                    return null;
                } 
                /* check for brand-other text field*/                   
                if(custDetails.kitchenBrand.equalsIgnoreCase(Label.outLabel_brandOther)){
                    if(custDetails.kitchenBrandOther.length()==0){
                        displayMessage('FATAL',Label.Null_Brand);
                        return null;
                    }
                } 
                //SHIVALI20150416 : START                               
                /* check for terms and conditions checkbox*/ 
              /*  if(termsCheck==false){
                    displayMessage('FATAL',Label.check_terms);
                    return null;
                }*/
                //SHIVALI20150416 : END
                custDetails.endDate=dtofPurchase.addYears(10);               
                userAccount updateCustomerDetails = new userAccount(); 
                if(dealerAccId <> null){
                    updateCustomerDetails.insertCustomerDetails(custDetails,strEntitlementCode,dtofPurchase,dealerAccId.Id,null,colorItem,this.sitefields);
                } else if (dealerInfo <> null){
                    updateCustomerDetails.insertCustomerDetails(custDetails,strEntitlementCode,dtofPurchase,null,dealerInfo,colorItem,this.sitefields);
                }
               /* navigating to thank you page */ 
               PageReference BIEMEAeWarrantyThanksPage;  
               BIEMEAeWarrantyThanksPage = Page.BI_eWarrantyThanksPage;  
               BIEMEAeWarrantyThanksPage.getParameters().put('lang',getlangValue());
               // <MG-20120725> Added :::: passing the weborigin parameter to thanks page.
               BIEMEAeWarrantyThanksPage.getParameters().put('webOrigin',getwebOrigin());
               BIEMEAeWarrantyThanksPage.setRedirect(false);                 
               return BIEMEAeWarrantyThanksPage;                              
            }
        }catch(DmlException dmlExp){         
            if(dmlExp.getDmlType(0) == statuscode.INVALID_EMAIL_ADDRESS){
                
            }else{
                displayMessage('FATAL',Label.Exception_On_Page);
            }
            return null;
        }catch(NullPointerException nullExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(SerializationException serialExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(SObjectException sObjectExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(TypeException typeExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(VisualforceException vfExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(QueryException queryExp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(Exception exp){
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }
    }    
    /* this to find/add a dealer*/
    public String dealerName{get;set;}
    public String selectedDealerName{get;set;}
    public List<Qualification__c> accList= new List<Qualification__c>();
    public String dealerAccount{get;set;}    
    public String radioStatus{get;set;}    
    public boolean displayPopup {get; set;}
    public boolean displayPopupColor {get; set;}  
    public String outPanel{get; set;}
    public List<SelectOption> dealerAccList{get;set;}
    /*this to find a color*/
    public String colorName{get;set;}
    public String selectedColorName{get;set;}
    public Id selectedColorId{get;set;}
    public List<Material__c> matLocList= new List<Material__c>();
    public String colorItem{get;set;}
    public List<Material__c> colorList{get;set;}    
    public List<fetchColorData> fetColorList{get;set;}
    
    /*display dealer popup*/
    public void showPopup() {
        outPanel = 'no';
        completeDealerName=null;
        dealerPostalAddr=null;
        dealerInfo=null;
        dealerAccount=null;
        dealerAccId=null;
        selectedDealerAddr=null;
        dealerAddr=null;
        displayPopup = true;
        radioStatus=null;        
        dealerName=null;
    }
    /*display color popup*/
    public void showPopupColor() {   
        outPanel = 'no';    
        radioStatus=null;        
        displayPopupColor=true;
        searchColor();    
    }
    
    /*close dealer popup*/
    public void closePopup() {  
        outPanel = 'yes';
        displayPopup = false;
        radioStatus=null;
        displayPopupColor=false;       
    }  
    /*to render the add dealer block*/ 
     public void renderAddDealer(){
        dealerName=null;
        dealerAccount=null;
        dealerAccId=null;            
        radioStatus='yes';      
    }  
   /* to search a dealer*/
    public void searchDealer(){
        try{            
            dealerAccount=null;
            accList=null;
            String dName = '%'+dealerName+'%';            
            fetchData getDealerRec = new fetchData();  
            /*query the qualifications for the list of dealer account.
             * condtions:Qualification_Program should not be null */ 
            dealerAccList=getDealerRec.dealerAccRecords(dName);  
            if(dealerAccList.size()!=0){
                radioStatus='no';
            }else{
                radioStatus='yes';
            }
        }catch(SerializationException serialExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(SObjectException sObjectExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(QueryException queryExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(Exception exp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }
    }    
    /* get the details of the dealer account selected*/
     public PageReference dealerRecs() {
        try{                      
            outPanel = 'yes';  
            fetchData getDealerDetails = new fetchData();                          
            dealerAccId=getDealerDetails.dealerDetails(dealerAccount);
            selectedDealerName=dealerAccId.name;
            selectedDealerAddr=dealerAccId.BillingStreet+','+dealerAccId.BillingStreet+','+dealerAccId.BillingCity+'\t'+dealerAccId.BillingPostalCode+','+dealerAccId.BillingState+','+dealerAccId.Country__c ;
            closePopup();
            return null;
        }catch(QueryException queryExp){
            displayPopup = false;
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(Exception exp){
            displayPopup = false;
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }
    }    
    /*to add a dealer */
    public String completeDealerName{get;set;}
    public String dealerPostalAddr{get;set;}
    public String dealerZipCode{get;set;}
    public String dealerProvince{get;set;}
    public String dealerCity{get;set;}
    public String dealerCountry{get;set;}
    public String dealerAddr{get;set;}
    public String tempMsg{get;set;}
    public ApexPages.Message myMsg{get;set;}     
    public void addDealer(){
        if(dealerCity==null || completeDealerName==null){ 
            outPanel = 'no';          
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Kindly enter the mandatory fields');                       
        }
        else{
            outPanel = 'yes';
            dealerAddr = dealerPostalAddr+','+dealerCity+'\t'+dealerZipCode+','+dealerProvince+','+dealerCountry;
            dealerInfo = completeDealerName+','+dealerAddr;
           }
    }

    /**********************************************************************
    /The first method invoked when the users clicks on Search Color button
    / to display the various colors of Corian.    
    /**********************************************************************/
     public void searchColor(){
     
        try{                  
            fetchData getColorRec = new fetchData();  
            /*query the qualifications for the list of dealer account.
             * condtions:Qualification_Program should not be null */            
            colorList=getColorRec.colorRecords(System.currentpagereference().getparameters().get('warrantyCode'));            
            fetColorList=new List<fetchColorData>();
            for(Material__c matSec : colorList){
              fetchColorData fd=new fetchColorData();
                fd.Id=matSec.Id;
                fd.Name=matSec.Name;
                fd.url=matSec.Product_Url__c;
              fetColorList.add(fd);                
            }
                  
            System.debug('The sixe of colorList is ******* '+colorList.size());
        }catch(SerializationException serialExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(SObjectException sObjectExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(QueryException queryExp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }catch(Exception exp){
            displayMessage('FATAL',Label.Exception_On_Page);
        }
    }
    public PageReference colorRecs() {
    displayPopupColor=false;
    String temStr;
    temStr = System.currentPageReference().getParameters().get('firstParam');
     System.debug('THE VALUE OF THE COLOR ITEM IS ******* '+colorItem);    
     System.debug('THE VALUE OF THE COLOR ITEM IS asdzdasdfs ******* '+temStr);    
        try{
            outPanel = 'yes';  
            fetchData getColorDetails = new fetchData();                                
            colorItemId=getColorDetails.colorDetails(colorItem);
            System.debug('THE VALUE OF THE COLOR ITEM ID IS ******* '+colorItemId);
            selectedColorName=colorItemId.name;
            selectedColorId=colorItemId.Id;
            System.debug('THE VALUE OF THE COLOR ITEM ID IS ******* '+selectedColorName);
            //selectedDealerAddr=dealerAccId.BillingStreet+','+dealerAccId.BillingStreet+','+dealerAccId.BillingCity+'\t'+dealerAccId.BillingPostalCode+','+dealerAccId.BillingState+','+dealerAccId.Country__c ;
            closePopup();
            return null;
        }catch(QueryException queryExp){
            displayPopup = false;
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }catch(Exception exp){
            displayPopup = false;
            displayMessage('FATAL',Label.Exception_On_Page);
            return null;
        }
    }
    
    //////////////////////////////////////////////////////////////////
    ///<AG 20130902>ADDED NEW INNER CLASS ctrleRegistrationMontelli
    //////////////////////////////////////////////////////////////////
    public class ctrleRegistrationMontelli extends ctrlBIeWarrantyInput{
        public String sellerId{set;get;}
        public String entitlementCode{get;set;}  
              
        /////////<AG 20130902> VALIDATES ALL THE POSSIBLE CASES FOR THE REGISTRATION 
        public PageReference verifyWarrantyCode(String entitlementCode,String SellerId){       
         List<EntitlementContact> entContctList=new List<EntitlementContact>();
         ApexPages.Message requiredField;
         String flag;        
         fetchData entRecs = new fetchData();
         if(entRecs.getEntitlmntContactRecs(entitlementCode).size()!=0){
             entContctList=entRecs.getEntitlmntContactRecs(entitlementCode);          
         }
          try{        
              List<Entitlement> entitlementList = new List<Entitlement>();
              List<Contact> contactList = new List<Contact>();
              Contact c=new Contact();
              //VERIFY IF ALL ENTERED VALUES FOR NOT NULL 
              if(entitlementCode.length()==0 || SellerId.length()==0){
                  flag='null_entry';
              }
              //CHECK FOR INCORRECT ENTITLEMENT WARRANTY CODE
              if(flag!='null_entry'){                 
                 entitlementList = entRecs.getEntitlementRecs(entitlementCode);//Rohit saini 20160329 issue IS ID-00067415 made function call parameterized
                 for(Entitlement ent:entitlementList){
                     flag=null;
                     if(ent.entitlement_code__c ==entitlementCode){
                         flag=null;
                         break;
                     }
                     if(ent.entitlement_code__c !=entitlementCode){
                        flag='false_warCode';
                     }
             } 
             //Rohit saini 20160329 issue IS ID-00067415 start
             if(entitlementList.size()==0){
                 flag='false_warCode';
             } //Rohit saini end        
               if(flag!='false_warCode'){
                 contactList=entRecs.getContactRecs();           
                //CHECK FOR INCORRECT SELLERID OR NOTREGISTERED SELLERID 
                for(Contact cn:contactList){
                  flag=null;
                  if(cn.Migration_DB_Id__c == SellerId){
                   flag=null;   
                   break;
                  }
                  if(cn.Migration_DB_Id__c!=SellerId){
                    flag='notRegisteredUser';
                  }           
               }
              }
               //CHECK FOR ALREADY REGISTERED SELLERID FOR THE ENTERED WARRANTY CODE.
               if(flag!='notRegisteredUser' &&  flag!='null_entry' && entContctList.size()!=0 ){             
                  for(EntitlementContact e:entContctList){ 
                    for(Contact cn:contactList){
                    flag=null;
                      if(e.ContactId == cn.Id){                    
                       if(cn.Migration_DB_Id__c!=null){                                         
                         flag='User_Already_Registered';
                         break;
                       }                                              
                     } 
                   }
                 }
              }  
          
           if(flag!='notRegisteredUser' && flag!='User_Already_Registered' && flag!='false_warCode' && flag!='null_entry'){           
             c=entRecs.getRelatedContact(SellerId);           
             for(Entitlement ent: entitlementList){                         
               //CHECK IF ENTITLEMENT WARRANTY CODE IS PRESENT
               if(ent.Entitlement_Code__c.equals(entitlementCode)){            
                     //CREATE A NEW ENTITLEMENT CONTACT FOR THE WARRANTY CODE                                         
                     EntitlementContact entCntct = new EntitlementContact();
                       entCntct.ContactId=c.id;
                       entCntct.EntitlementId=ent.id;                                         
                       try{insert entCntct;
                          flag='registered';
                          break;}  
                       catch(Exception e){flag='User_Already_Registered';}                                                                                        
               }
             } 
           }           
         }           
         if(flag.equals('null_entry')){
            PageReference retPage = reset(Label.Null_Entry);
            return retPage;               
         }else if(flag.equals('false_warCode')){ 
             PageReference retPage = reset(Label.Incorrect_Warranty_Code);
             return retPage;
         }else if(flag.equals('registered')){
             PageReference retPage = reset(Label.msg_successful_register);
             return retPage;
         }else if(flag.equals('notRegisteredUser')){
             PageReference retPage = reset(Label.msg_Seller_Id_not_Present);
             return retPage;
         }else if(flag.equals('User_Already_Registered')){
             PageReference retPage = reset(Label.Registerd_WarrantyCode);
             return retPage;
         }else{
             PageReference retPage = reset(Label.Error_on_Page);
             return retPage;       
             }
          return null;            
        }catch(Exception ex){
            PageReference retPage = reset(String.valueof(ex));
            return retPage;
        }
        return null;
        }
       /////////<AG 20130902>OVERRIDES THE PARENT METHOD TO RESET THE PAGE 
       public override PageReference reset(String errorString) {       
        PageReference resetPage = Page.BI_EMEA_eRegistration_Montelli;
        resetPage.getParameters().put('lang',getlangValue());          
        resetPage.getParameters().put('webOrigin',getwebOrigin());
        resetPage.getParameters().put('errorString',errorString);
        resetPage.setRedirect(true);
        return resetPage;
        }
     }
}
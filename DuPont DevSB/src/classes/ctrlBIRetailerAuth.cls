/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBIRetailerAuth
//Author :Jharna Sinha<Jharna_Sinha@infosys.com>
//Description: This class is getting used in BI_AuthorizationForm VF Page
//This class allows retailer to update their information in Salesforce and also choose products available with them
//<JS-20150302>- Changes made for a new multi-select picklist for selecting products
//<AK-20171211>- Value of the strings "Corian and Zodiaq" were changed to new custom lables created according to the new products names(changed by Business) <CodeCoverage- 85 %>
/************************************<JS-20141226>***************************************************/

//Merge&Spin : Removed Hardcoded id - public static Final Id cmpgnId='701a0000000aFL9'
/****************************************************************************************************/
    global class ctrlBIRetailerAuth {
    
    private static Final Id registrationRecordTypeId=Rtype.getIdByDevName('Qualification__c','BI_Retailer_Authorization');
    public static Final Id CONRECTYPEID = Rtype.getIdByDevName('Contact','BI_NA_Contact');
    public static Final Id ACCMATRECTYPEID = Rtype.getIdByDevName('Account_Material__c','Account_Material');
    public static final Id ProdRecId = Rtype.getIdByDevName('Material__c','Product');
    public final String mtrval='BI Authorization';
    public SiteScript script {get; set;}   
    public siteScript script2 {get; set;}
    public string searchProduct                {get;set;}
    public Qualification__c qual               {get;set;}
    private static Final Id contactRecordTypeId=Rtype.getIdByDevName('Contact','BI_NA_Contact');
    public list<Material__c> Materialvalue;
    public SelectOption[] SelectedMaterials    {get;set;}  
    public SelectOption[] AllMaterials         {get;set;}
    public Boolean noProduct {get;set;}
    public static final string locator= 'BI-Surf Retailer Locator';
    public static final string program= 'Authorized Retailer';
    public boolean flag=false;
    /*<JS-20150302>:Variables for 2nd multi-select picklist*/
    public SelectOption[] SelectedProducts     {get;set;}  
    public SelectOption[] AllProducts          {get;set;}
    public list<material__c> productvalue;
    // <AK-20171211>- Value of the strings "Corian and Zodiaq" were changed to new custom lables created according to the new products names(changed by Business) <CodeCoverage- 85 %>
    public static final String corian =Label.DPS_AuthorizedRetailProcess_Product1;
    public static final String zodiaq =Label.DPS_AuthorizedRetailProcess_Product2;
    
    
    public ctrlBIRetailerAuth() {
    SelectedMaterials = new List<SelectOption>();
     AllMaterials= new List<SelectOption>();
     AllProducts= new List<SelectOption>();
     SelectedProducts = new List<SelectOption>();
     Materialvalue = new list<Material__c>([SELECT name FROM material__C WHERE Parent_Material__r.Name=:mtrval limit 500]);
     
     /*<JS-20150302>:Initialization of Multi-Select picklist for product selection */
     productvalue =new list<material__c>([SELECT id,name from material__c where (name=:corian or name=:zodiaq) and RecordType.id=:ProdRecId]);
     
    for (integer i=0;i<productvalue.size();i++){
        AllProducts.add(new SelectOption(productvalue [i].name, productvalue [i].name));
    }  
    Set<String> newSet=new Set<String>();
    String[] newtempSelected=new List<String>();
     if(SelectedProducts.size()!=0){
         
         for (integer j=0;j<SelectedProducts.size();j++){ 
                 newtempSelected.add(SelectedProducts[j].getvalue());
            }
         }
         if(newtempSelected.size()>0){
         newSet.addAll(newtempSelected);
         }
    }   
//////////////////////////////////
 
    public void init() {
    if(Test.isRunningTest()){ 
          script = new SiteScript(script.scriptid); 
          script2 = new SiteScript(script2.scriptid); 
        }   
        else   {     
      script = new SiteScript([SELECT Id from SFDC_Script__c where Name =:'BI_Retailer_Authorization'].Id);       
      script2 = new SiteScript([SELECT id from SFDC_Script__c where name =:'BI_Retailer_Authorization_Colour_Section'].id);
    }  
    }  
//////////////////////////////////////  
/*Function Description
    Name: save
    Return Type: PageReference 
    Description: This method takes values from the 
    form and save them on account, contact and 
    creates new account material records
*/
////////////////////////////////////

   public PageReference save() {
      try{
         
        if(script.validate()){ 
      /*<JS-20150302>: Selection of atleast one product made mandatory*/  
       if(SelectedProducts.size()==0){
         apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Please select atleast one product from the available products');
         apexpages.addmessage(msg);
         return null;
         } 
         else{
/////////////Update Account Informantion////////////
            Account account = [SELECT id, name,fax,website,phone, ShippingStreet,shippingCity,shippingState,shippingPostalCode,Country__c,locators__c,Mb_of_Marketing_Program__c from account where id=:ApexPages.currentPage().getParameters().get('aid')];
            account.fax=script.getQuestion('myFax').answer;
            account.website=script.getQuestion('myWebsite').answer;
            account.id=script.getQuestion('relatedAccount').answer;
            account.Phone=script.getQuestion('otherPhone').answer;
            account.ShippingStreet= script.getQuestion('myStreetName').answer;
            account.ShippingCity= script.getQuestion('myCityName').answer;
            account.ShippingState= script.getQuestion('myStateName').answer;
            account.ShippingPostalCode= script.getQuestion('myZipCode').answer;
            account.ShippingCountry= script.getQuestion('myCountryName').answer;
            account.locators__c=locator;
 /*<JS-20150302>:added code to add 'Authorized retailer' to field 'Mb_of_Markerting_Program' if it not added*/            
            if(account.Mb_of_Marketing_Program__c!=null){
            String[] tmpString = account.Mb_of_Marketing_Program__c.split(';');
            system.debug('tmpString:' +tmpString);
            for(String s: tmpString ){
            if (s=='Authorized Retailer'){
            flag=true;
            break;
            }
            }
            if(flag==false)
            account.Mb_of_Marketing_Program__c=account.Mb_of_Marketing_Program__c + ';' + program;
            }
            else
            account.Mb_of_Marketing_Program__c=program;
            update account;
                        
////////////update Contact Information//////////////                     
            Contact contact= new Contact();
            contact.id=script.getQuestion('RelatedContact').answer;
            contact.RecordTypeId=CONRECTYPEID;  
            contact.status__c='Active'; 
            contact.Accountid = script.getQuestion('relatedAccount').answer; 
            contact.email = script.getQuestion('myContactEmail').answer;     
            contact.Phone= script.getQuestion('otherPhone').answer;
            contact.MailingStreet= script.getQuestion('myStreetName').answer;
            contact.MailingCity= script.getQuestion('myCityName').answer;
            contact.MailingState= script.getQuestion('myStateName').answer;
            contact.MailingPostalCode= script.getQuestion('myZipCode').answer;
            contact.MailingCountry= script.getQuestion('myCountryName').answer;
            contact.Fax=script.getQuestion('myFax').answer;
            contact.Comments__c=script.getQuestion('myComments').answer;
            if(script.getQuestion('myOptin').answer.equalsIgnoreCase('true')){
                contact.Opt_In__c=true; 
               // Merge&Spin Start - Removed Hardcoded id - public static Final Id cmpgnId='701a0000000aFL9' 
                List<Campaign> campaignList = [select id, name, recordtype.developername from Campaign where recordtype.developername =:'Subscriber_List' and name=:'BI Opt-In Master List' order by createdDate asc limit 1];
                if(!campaignList.isEmpty()){
                    list<CampaignMember> newCampaignMembersExpCamp = [SELECT id from CampaignMember where CampaignMember.ContactId=: contact.Id AND CampaignMember.Campaignid=:campaignList[0].id];
                    delete newCampaignMembersExpCamp;
                    CampaignMember cm= New CampaignMember(CampaignId=campaignList[0].id, ContactId= contact.Id , Status='Member-Opt-In');
                    newCampaignMembersExpCamp.add(cm);
                    insert cm;
                }  
               // // Merge&Spin End
            }
            else{
                contact.Opt_In__c=false; 
            } 
            update contact; 
                       
/////////// Changes made to create Account Material records//////////
           //list<Account_Material__c> accountMaterialItems = [SELECT id, name from Account_Material__c where Account_Material__c.Account_Name__c =:account.id];
           if(SelectedMaterials.size()!=0){
           
           list<Account_Material__c> accMat= new list<Account_Material__c>();
             for (SelectOption option : SelectedMaterials) {
              Account_Material__c accountMaterial = new Account_Material__c();
              accountMaterial.RecordTypeId=ACCMATRECTYPEID; 
              accountMaterial.Account_Name__c = account.id;
              accountMaterial.Line_Description__c = 'product present with retailer';
              Material__c material = [SELECT id, name from Material__c where Name =:option.getvalue() LIMIT 1];
              accountMaterial.Product_Name__c = material.id;
             //insert accountMaterial;
             accMat.add(accountmaterial);
             }
             insert accMat;
            }
      /*<JS-20150302>: Create new Account-Material records from the products selected*/   
         
         if(SelectedProducts.size()!=0){
         list<Account_Material__c> accountMaterialItems = [SELECT id, name from Account_Material__c where (Product_Name__r.name=:corian or name=:zodiaq) and Account_Material__c.Account_Name__c =:account.id];
           delete accountMaterialItems ;
         list<Account_Material__c> accMat= new list<Account_Material__c>();
             for (SelectOption option : SelectedProducts) {
              Account_Material__c accountMaterial = new Account_Material__c();
              accountMaterial.RecordTypeId=ACCMATRECTYPEID; 
              accountMaterial.Account_Name__c = account.id;
              accountMaterial.Line_Description__c = 'key product present with retailer';
              material__c prod = [SELECT id, name from material__c where Name =:option.getvalue() LIMIT 1];
              accountMaterial.Product_Name__c = prod.id;
             //insert accountMaterial;
             accMat.add(accountmaterial);
             }
             insert accMat;
            }
            }
           script.save();
           return script.returnPageReference(); 
      } 
          
      }
      catch(Exception e){
          System.debug(e.getMessage());
      } 
     return null; 
 }
 
/////////////////Product Search////////////////////////
/* 
    Function Description
    Name : searchProductValue
    Return Type : void 
    Description : This method searches the Product and displays it to the user 
    */
public void searchProductValue(){     
     noProduct=false;
     Allmaterials.clear();
     string search='%'+searchproduct+'%';
     system.debug('the search is '+search);
     Materialvalue = [select name from material__C where Parent_Material__r.Name=:mtrval and name like :search LIMIT 300];
     integer totalSize=materialvalue.size();
     system.debug('the selected materail is----------- '+ SelectedMaterials.size() );
     Set<String> tSet=new Set<String>();
     if(SelectedMaterials.size()!=0){
         String[] tempSelected=new List<String>();
         for (integer i=0;i<SelectedMaterials.size();i++){ 
             if(SelectedMaterials[i].getvalue().toLowerCase().contains(searchProduct.toLowerCase())){
                 tempSelected.add(SelectedMaterials[i].getvalue());
            }
         }
         if(tempselected.size()>0){
         tSet.addAll(tempSelected);}
       }
     
     for (integer i=0;(i<totalSize && allMaterials.size()<300);i++){ 
     if(tSet.size()>0){
         if(Materialvalue[i].name.toLowerCase().contains(searchproduct.toLowerCase())  && !tSet.contains((Materialvalue[i].name)))
             AllMaterials.add(new SelectOption(Materialvalue [i].name, Materialvalue [i].name));
        }
     else{
         if(Materialvalue [i].name.toLowerCase().contains(searchproduct.toLowerCase()))
         AllMaterials.add(new SelectOption(Materialvalue [i].name, Materialvalue [i].name));}   
        }
     if(AllMaterials.size()==0){ 
         noProduct=true;
        }
    }   
////////////////////////////////////
             
////////////////////////////////////
/*
    Function Description
    Name :productAnswer
    Return Type: string 
    Description: This method stores the Products selected in the Product answer field
*/
public string productAnswer(){    
     String message;
     String message2;    
     try{
       if(SelectedMaterials.size()!=0){
         Boolean first = true;
         message ='';
         for ( SelectOption so : SelectedMaterials) {
             if (!first) {
                message += '; ';
                }
             message += so.getvalue();
             first = false;
            }
         return message ;
       }
     else{
         return message ;}
         }
     Catch(Exception Ex){
     return message;
     }
   } 
   /*<JS-20150302>: Products Multi-Select Picklist*/
   public string productAnswer2(){
   String message;
     String message2;    
     try{     
     if(SelectedProducts.size()!=0){
         Boolean first = true;
         message2 ='';
         for ( SelectOption so : SelectedProducts) {
             if (!first) {
                message2 += '; ';
                }
             message2 += so.getvalue();
             first = false;
            }
         return message2 ;
        }
     else{
         return message2 ;}
     }
     Catch(Exception Ex){
     return message;
     }
  }
          
 
 }
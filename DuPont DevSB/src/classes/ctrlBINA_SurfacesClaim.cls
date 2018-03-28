/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_SurfacesClaim
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_SurfaceClaim VF Page
//This class allows user to chose Products and creates a Case.
//************************************<MG-20140827>***************************************************//
public class ctrlBINA_SurfacesClaim{
    public string currentEntitlementid                          {get;set;}
    public String conid                                         {get;set;}
    public case c                                               {get;set;}
    public Entitlement entit                                    {get;set;}
    public Contact con                                          {get;set;}
    public SelectOption[] SelectedMaterials                     {get;set;}  
    public SelectOption[] AllMaterials                          {get;set;}
    public Date d                                               {get;set;}
    private ApexPages.StandardController controller ;
    public static Final Id ConrectypeId=Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
    
public ctrlBINA_SurfacesClaim(ApexPages.StandardController controller) {
      
    this.controller=controller;
    currentEntitlementid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('def_entitlement_id'));
    c=(Case)controller.getRecord();
    c.recordtypeid=ConrectypeId;
    system.debug('the current account id is '+CurrentEntitlementid);
    entit=([select id,name,product_answer1__c,Registration_Number__c,StartDate,AccountId,account.name,primary_contact__c from Entitlement where id=:currentEntitlementid]);
    con=([Select id,name,email,MobilePhone,Phone,mailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry from Contact where id=:entit.primary_contact__c]);
    /*Date dT = entit.Startdate;
    entit.Startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    c.Installation_date__C=date.newinstance(dT.year(), dT.month(), dT.day());*/
    c.Installation_Date__c=entit.StartDate;
    SelectedMaterials = new List<SelectOption>();
    AllMaterials= new List<SelectOption>();
    if(entit.product_answer1__c!=null){
        String[] Product=entit.product_answer1__c.split('\\;');
        for(integer i=0 ;i<product.size();i++ ){ 
            AllMaterials.add(new SelectOption(Product[i], Product[i]));
            system.debug('The value is========='+product[i]);
         }    
     }
 }
    //////////////////////////////////////////
    /* Function Description
    Name :save
    Return Type: PageReference
    Description: This is a custom Save method to save the values entered in the Case Page
    
    */
    
    
public PageReference save(){
    try{
    if(ProductAnswer()!=null){
        Account acc = [SELECT id,BI_Account_SubType__c FROM Account WHERE id=:entit.AccountId];
        c.RecordTypeId=ConrectypeId;
        c.Product_Selected__C=productAnswer();
        c.entitlementid=entit.id;
        c.AccountId=entit.AccountId;
        c.Account_SubType__c=acc.BI_Account_SubType__c;
        c.Date_Entered__c=date.today();
       // c.Case_Shipping_Address__c=con.mailingStreet+','+'\n'+con.MailingCity+','+con.MailingState+'  '+con.MailingPostalCode+'\n'+con.MailingCountry;
        insert c;
        PageReference pr=new PageReference('/'+c.id);
        return pr;
        }
        else{
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
       return null;
   }
       }
     Catch(Exception ex){
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
     return null;
    }
   
}

   //////////////////////////////////////////////
   /* Function Description
    Name :cancel
    Return Type: PageReference
    Description: This is a custom cancel button method where the user lands to the detail page of the Entitlement 
    */
      
public PageReference cancel(){
    PageReference p =new PageReference('/'+ApexPages.currentPage().getParameters().get('def_entitlement_id'));
    return p;
    }
 
     ////////////////////////////////////
    /*Function Description
    Name :productAnswer
    Return Type: String
    Description: This method stores the Products selectedMaterial Selectoption list in the Product Answer field
    
    */
    
public String productAnswer(){    
     String message;    
     
     try{
     
     if(SelectedMaterials.size()!=0){
       Boolean first = true;
       message ='';
       for ( SelectOption so : SelectedMaterials) {
          if (!first) {
             message += ';';
            }
          message += so.getvalue();
          first = false;
        }
      return message ;
     }
     else
       return message ;
    }
    Catch(Exception e){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No product selected in selected Material'));
    return message ;
    }
  }
}
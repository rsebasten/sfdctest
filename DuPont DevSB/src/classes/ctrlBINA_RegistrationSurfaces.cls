/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_RegistrationSurfaces
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_SurfacesRegistration VF Page
//This class allows user to chose Products and Saves the Entitlement and Contact created. 
// <AK20150119> Modified the Phone numbervalidation from 10 digits to "10-15" digits also modified the error message.
//************************************<MG-20140827>***************************************************//

public class ctrlBINA_RegistrationSurfaces
{
     public string searchProduct                {get;set;}
     private string accountId;
      private String contactID;
     public Entitlement entit                   {get;set;}
     public Contact con                         {get;set;}
     public Contact con1                        {get; set;}
     public Account acc                         {get;set;}
     public boolean installationType1           {get;set;}
     public boolean installationType2           {get;set;}
     private static Final Id registrationRecordTypeId=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
     private static Final Id contactRecordTypeId=Rtype.getIdByDevName('Contact','BI_NA_Contact');
     list<Material__c> Materialvalue;
     public SelectOption[] SelectedMaterials    {get;set;}  
     public SelectOption[] AllMaterials         {get;set;}
     public Boolean noProduct {get;set;}
     public Boolean builder{get;set;}
     public boolean entedit                     {get; set;}
     public boolean entnew                     {get; set;}
     public String conemail                     {get; set;}
     public String retUrl                       {get; set;}
     public boolean accRender                   {get; set;}
     public boolean conRender                   {get; set;}
     public String conPhone                     {get; set;}
     private string entitlementId;
     
public ctrlBINA_RegistrationSurfaces(ApexPages.StandardController controller){
                
     entitlementId= ApexPages.currentPage().getParameters().get('id'); 
     retUrl=ApexPages.currentPage().getParameters().get('retUrl');
     SelectedMaterials = new List<SelectOption>();
     AllMaterials= new List<SelectOption>();
     Materialvalue = new list<Material__c>([SELECT name FROM material__C WHERE Parent_Material__r.Name=:'BI NA Surfaces Warranty' limit 500]);       
     
     if(entitlementId==null){
        entitlementNew();
        entnew=true;
        entedit=false;
        }
        else{
        accRender=false;
        conRender=false;
        entedit=true;
        entnew=false;
        entitlementEdit();
        }   
     
    }
   ///////////////////////////////////////////
/*Function Description
    Name: entitlementEdit
    Return Type: Void
    Description: This method is used to configure the Page for 
    Entitlement edit
*/

public void entitlementEdit(){
    string Id= ApexPages.currentPage().getParameters().get('id');
    entit=[select accountID, Registration_Number__c,name, primary_contact__c,Installation_Type__c,StartDate,product_answer1__c,status from entitlement where id =: id];
    acc= ([select id,name,BI_Account_SubType__c from account where id =:entit.accountID]);
    con1=([select id,FirstName, LastName,Email,MailingStreet,Phone,MailingCity,MobilePhone,MailingPostalCode,MailingCountry,MailingState from contact where id =:entit.primary_contact__c]); 
    String[] product=entit.product_answer1__c.split('\\;');
    for(Integer i=0; i<product.size();i++){
             SelectedMaterials.add(new selectoption(product[i],product[i]));
            }
    Set<String> tSet=new Set<String>();
    tSet.addAll(product);
    for(Integer i=0; i<Materialvalue.size();i++){ 
         if(!tSet.contains(Materialvalue[i].name))
             AllMaterials.add(new SelectOption(Materialvalue[i].name, Materialvalue[i].Name));
         }
} 

///////////////////////////////////////////
/*Function Description
    Name: entitlementNew
    Return Type: Void
    Description: This method is used to configure the Page for 
    Entitlement Creation from Contact and Account
*/
public void entitlementNew(){
     
     string accid= ApexPages.currentPage().getParameters().get('def_account_id');
     acc= ([select id,name,BI_Account_SubType__c from account where id =:accid]);
     contactID=ApexPages.currentPage().getParameters().get('def_contact_id');
     if(contactID!=null){
     con1=([select id,FirstName, LastName,Email,MailingStreet,Phone,MailingCity,MobilePhone,MailingPostalCode,MailingCountry,MailingState from contact where id =:contactID]); 
     accRender=false;
     conRender=true;
     entedit=false;
     }
     else{
     accRender=true;
     conRender=false;
     entedit=false;
     }
     con = new contact();
     entit = new Entitlement();
     entit.RecordTypeId=RegistrationRecordTypeId;
     con.recordtypeid=contactRecordTypeId;
     
     AllMaterials= new List<SelectOption>();
     Materialvalue = new list<Material__c>([SELECT name FROM material__C WHERE Parent_Material__r.Name=:'BI NA Surfaces Warranty' limit 500]);
     for( Integer i=0;i<Materialvalue.size();i++){ 
         AllMaterials.add(new SelectOption(Materialvalue[i].name, Materialvalue[i].Name));
        }

}                    
///////////////////////////////////////////
/*Function Description
    Name :renderAccountLabel
    Return Type: Void
Description: This method rerender the panel for accountselection*/
public void renderAccountLabel(){
builder=true;
}
///////////////////////////////////////////
/*Function Description
    Name :searchProductValue
    Return Type: Void
Description: This method searches the Product and displays it to the user*/
public void searchProductValue(){  
     
     noProduct=false;
     Allmaterials.clear();
     string search='%'+searchproduct+'%';
     system.debug('the search is '+search);
     Materialvalue = [select name from material__C where Parent_Material__r.Name=:'BI NA Surfaces Warranty' and name like :search LIMIT 300];
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
   
    //////////////////////////////////////////
    /* 
    Function Description
    Name :SaveEnt
    Return Type: Pagereference 
    Description:This is a custom Save method where error messages are displayed and record is saved if no error is found*/
public Pagereference SaveEnt(){
     PageReference pr;
     
     if(entitlementId!=NULL)
     pr=updateEnt();
     else
     pr=saveNewEnt();
     
     return pr;
    }   
    
    
 ////////////////////////////////////////////
    /* 
    Function Description
    Name : updateEnt
    Return Type :page Reference
    Description : This function is used to update product and Account entitlement 
    */
public pageReference updateEnt(){   
     integer flag=1;
     try
     {
     if( entit.Installation_Type__c== null){   
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all mandatory fields (*)'));
        }
     
     if(productAnswer()==null){      
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
        }
    if(flag==1){
    entit.product_answer1__c=productAnswer();
    update entit;
   PageReference pageref=new PageReference('/'+entit.id);
    return pageref;
    }
    else
    return null;
    }
    catch(Exception e){
    return null;
    }
    
}  

 ////////////////////////////////////////////
    /* 
    Function Description
    Name : saveNewEnt
    Return Type :page Reference
    Description : This function is used to save new entitlement from contact and Account
    */
public pageReference saveNewEnt(){
     Integer flag=1;
     Integer flag1=1;
     try{
     if(contactID == NULL) {
     String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
     Pattern MyPattern = Pattern.compile(emailRegex);
     Matcher MyMatcher = MyPattern.matcher(conemail);
     con.Contact_Country__c=entit.Registration_Country1__c;
     con.MailingCountry=con.Contact_Country__c;
     con.Role__c='Consumer';
     
     con.MailingState=entit.Registration_State_Province__c;

     if(con.FirstName == null || con.lastName == null || con.MailingStreet== null || conemail == null  || con.Phone == null || con.MailingCity == null
            || con.MailingState == null  || con.MailingPostalCode == null  || con.MailingCountry== null  || entit.Installation_Type__c== null){   
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all mandatory fields (*)'));
        }
     if(productAnswer()==null){      
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
        }
     if ((!MyMatcher.matches() )&& (flag !=0) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter valid Email in the Email Address')); 
            flag1=0;
        }
     if(flag==1){    
         if((con.Phone.ReplaceAll('[^0-9]','')).length()<10 || (con.Phone.ReplaceAll('[^0-9]','')).length()>15){    //<AK20150119>
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 10-15 digits in Phone number'));    //<AK20150119>
             flag1=0;       
            }
         if((conPhone.ReplaceAll('[^0-9]','')).length()!=10 && conPhone.length()>0 ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 10 digits in Mobile number'));
             flag1=0;       
            }
         if((con.MailingCountry=='CANADA'&& con.MailingPostalCode.length()!=6)||(con.MailingCountry=='UNITED STATES'&& con.MailingPostalCode.length()!=5)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 6 digit Zip/Postal Code for Canada and 5 digit Zip/Postal Code for United States'));
             flag1=0;        
            }
        }
        }
     if(flag==1 && flag1==1){
         if(contactID == NULL){
         con.MobilePhone=conPhone;
         con.accountid=acc.id;
         con.Email=conemail;
         insert con;
         entit.primary_contact__c=con.id;
         entit.name=con.firstname+' '+con.lastname;
         }
         else
         {
         entit.name=con1.firstname+' '+con1.lastname;
         entit.primary_contact__c=con1.id;
         system.debug('The value is:------'+entit.id);
         }
         
         entit.product_answer1__c=productAnswer();
         entit.RecordTypeId=RegistrationRecordTypeId;
         entit.accountid=acc.id;
         insert entit;
         PageReference pr=new PageReference('/'+entit.id);
         return pr;
        }
    else
         return null;
     }
     Catch(Exception E){
     return null;
     }
  }   
   
    ////////////////////////////////////
    /*
    Function Description
    Name :productAnswer
    Return Type: string 
    Description: This method stores the Products selected in the Product Answer field*/
public string productAnswer(){    
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
     Catch(Exception Ex){
     return message;
     }
  }
          
  //////////////////////////////////////////////
  /*
  Function Description
    Name :cancel
    Return Type: PageReference
  Decription: This is a custom cancel button method where the user lands to the detail page of the Entitlement*/
public Pagereference cancel(){
     PageReference pr1=new PageReference(retUrl);
     return pr1;

    } 

public List<SelectOption> getAlloption(){
     List<SelectOption> options = new List<SelectOption>();
     options.add(new SelectOption('United States','UNITED STATES'));
     options.add(new SelectOption('Canada','CANADA'));
     return options;
    }
}
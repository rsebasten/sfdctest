/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesCreateClaim
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_EnvelopesClaim VF Page
//This class allows user to create a New Case record
//************************************<MG-20140827>***************************************************//

public class ctrlBINA_EnvelopesCreateClaim {

    public Case cas {get; set; }
    public String currentEntitlementId;
    public Entitlement entit {get; set; }
    public Entitlement entitGet {get;set;}
    public String retURL    { get; set; }
    public String saveNewURL { get; set; }
    public String selectedRecordType;
    private ApexPages.StandardController controller ;
    public static final Id BINAClaimAdmin=RType.getIdByDevName('Case','BI_NA_Envelopes_Case');
    public static final Id BINACase_MaterialRecordType=RType.getIdByDevName('Case_Material__C','Case_Material');
    public string ent_SiteAddress {get;set;}
    public String casemail        {get; set;}
    public String conPostal       {get; set;}
    public String productSelected {get; set;}

//////////////////////////////////////////
    /* Function Description
    Name :init
    Return Type: void 
    Description:This function is written for the intialization of variable and for passing argument to the vf page
    */    
    
public void init(){
    currentEntitlementId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('def_entitlement_id'));
    entit=([SELECT id,name,Application_Type__c,product_answer1__c,registration_address__c,Registration_Postal_Code__c,recordtypeid,Registration_Country1__c,Registration_State_Province__c,Registration_City__c FROM Entitlement WHERE id=:currentEntitlementId]);
    ent_SiteAddress= entit.registration_address__c+' ,'+'\n'+entit.Registration_City__c+','+entit.Registration_State_Province__c+' ,'+'\n'+entit.Registration_Country1__c+'\n'+'Zip/PostalCode -'+entit.Registration_Postal_Code__c;
    entitGet = new entitlement();
    entitGet.recordtypeid= entit.recordtypeid;
    // String[] prodSelected=entit.product_answer1__c.split('\\;');
    productSelected='';
    for(integer i=0; i<(entit.product_answer1__c.split('\\;')).size();++i){
     if((math.mod(i, 3)) !=0 ||i==0){
     productSelected +=entit.product_answer1__c.split('\\;')[i];
     if((entit.product_answer1__c.split('\\;')).size()!=i+1)
     productSelected+=', ';
     }
     else
     productSelected +=entit.product_answer1__c.split('\\;')[i]+'\n';
     }
    // productSelected.replace();
   }
   
public ctrlBINA_EnvelopesCreateClaim(ApexPages.StandardController controller) {    
    this.controller=controller;
    cas=(Case)controller.getRecord();
    cas=new Case();
    cas.EntitlementID=currentEntitlementId;
    cas.recordtypeid=BINAClaimAdmin;
   }
   //////////////////////////////////////////////
   /* Function Description
    Name :Cancel
    Return Type: PageReference
    Description: This is a custom cancel button method where the user lands to the detail page of the Entitlement 
    */  
    
public PageReference cancel(){
     PageReference p =new PageReference('/'+ApexPages.currentPage().getParameters().get('def_entitlement_id'));
     return p;
    }
   //////////////////////////////////////////
    /* Function Description
    Name :Savelist
    Return Type: PageReference
    Description: This is a custom Save method to save the values entered in the Case Page 
    */   
    
public PageReference Savelist(){
    integer flag=1;
    integer flag1=1;
    try{
    cas.Application_Type__c=entit.Application_Type__c;
    cas.Country__c=entitGet.Registration_Country1__c;
    cas.State__c=entitGet.Registration_State_Province__c;
    cas.Product_Selected__c=entit.product_answer1__c;
    String[] product=entit.product_answer1__c.split('\\;');
    System.debug('The products are'+product);
    LIST<Case_Material__c> cs= new LIST<Case_Material__c>();
    LIST<Material__c> m= new LIST<Material__c>([SELECT id,name FROM Material__c WHERE  Owning_Org__c='BI' and Owning_Business__C='Building Innovations'  and Parent_Material__r.name!='BI NA Surfaces Warranty'] );
    LIST<ID> nm=new LIST<ID>();
    for(Material__c m1:m){
        for(integer i=0;i<product.size();i++){
         if(m1.name==product[i]){
                 nm.add(m1.id);
                }
            }
        }
    If(cas.Submitted_By_First_Name_Last_Name__c==null  || casemail==null || cas.Case_Shipping_Address__c==null  || cas.Description==null || cas.Problem_Description__c==null){
        flag=0;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all mandatory fields (*)'));
        }
     if((!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', casemail)) && flag !=0 )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter valid Email in Customer Email Address')); 
            flag1=0;
        }
     if((cas.Alt_Phone__c.ReplaceAll('[^0-9]','')).length()!=10){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 10 digits in Customer Phone number'));
             flag1=0;       
            }
      if(((cas.Country__c=='CANADA'&& conPostal.length()!=6)||(cas.Country__c=='UNITED STATES'&& conPostal.length()!=5))&&(conPostal.length()!=0)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 6 digit Zip/Postal Code for Canada and 5 digit Zip/Postal Code for United States'));
             flag1=0;        
            }
        if(flag==1 && flag1==1){
    cas.entitlementId=currentEntitlementId;
    cas.Date_Entered__c=date.today();
    cas.code__c=conPostal;
    cas.Alt_Contact_Email__c=casemail;
    insert cas;   
    for(  Integer i=0; i<nm.size();i++){ 
        case_material__c cm= new case_material__c (Case__c=cas.id,Material__c=nm.get(i),recordtypeid=BINACase_MaterialRecordType);
        cs.add(cm);
    }
    
    insert cs;
    
    PageReference record=new PageReference ('/'+cas.id);
    record.setRedirect(true);
    return record;
    }
   
   else
     return null;
   }
   Catch(Exception e){
   return null;   
    }
  }
   
}
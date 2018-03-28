/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesRegistration
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_EnvelopesRegistration VF Page
//This class allows user to create a New Entitlement record

// AK20150203 Modified the class on 3rd feb 2015 to make the field "Date of Substantial Completion" as optional on the page.
//************************************<MG-20140827>***************************************************//
public class ctrlBINA_EnvelopesRegistration{
   
    public SiteScript script1 { get; set; }
    public SiteScript script2 { get; set; }
    public SiteScript script3 { get; set; }
    public SiteScript script4 { get; set; }
    public SiteScript script5 { get; set; }
    public SiteScript script6 { get; set; }
    public Entitlement entit { get; set; }
    public SelectOption[] SelectedMaterials { get; set; }  
    public SelectOption[] AllMaterials { get; set; }
    public Account accName { get; set; }
    public String rType{ get; set; }
    public Boolean checkBox1{ get; set; }
    public Boolean checkBox2{ get; set; }
    public Boolean renderedCheckbox{ get; set; }
    public Boolean multiProductRendered{ get; set; }
    public Boolean singleProductRendered{ get; set; }
    public Boolean script1Rendered{ get; set; }
    public Boolean script2Rendered{ get; set; }
    public Boolean script3Rendered{ get; set; }
    public Boolean script4Rendered{ get; set; }
    public Boolean script5Rendered{ get; set; }
    public boolean script6Rendered{ get; set; }
    public boolean skuRendered{get;set;}
    public boolean wrbRendered{get;set;}
    public boolean checkBoxRendered{get;set;}
    public LIST<Entitlement__c> ec{get; set;}
    private String currentAccountId;
    private String retURL;
    private ApexPages.StandardController controller ;
    
    /* Record Type */
    private static Id PRODUCTlABOUR_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    private static Id PRODUCTFLUID_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
    private static Id PRODUCT_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
    
    
   //////////////////////////////////////////
    /* Function Description
    Name :initScript
    Return Type: void 
    Description: This is method written to get the results from script
    */
    
public void initScript(){
     
     LIST <SFDC_Questions__c> question; 
     question=new LIST <SFDC_Questions__c>([ SELECT name, DefaultAnswer__c from SFDC_Questions__c where Group__c='BINA TYVEK']);
     for (Integer i=0;i<question.size();i++){  
           if(question[i].name!='RegistrationId'){
                 question[i].DefaultAnswer__c ='';
            }
     }
     update question;
     script1= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Project Information'].id);
     script2= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Certified Installer Information'].Id);
     script3= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Related Contact Information'].Id);
     script4= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Estimated Product Exposure Time(in Days)'].Id);
     script5= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Project Information - Product Only'].Id);
     script6= new SiteScript([SELECT Id from SFDC_Script__c where Name =:'Warranty Dates'].Id);
   }
   
 //////////////////////////////////////////
    /* Function Description
    Name :booleanValueInit
    Return Type: void 
    Description: This function is written for the intialization of variable and for passing argument to the vf page
    */
    
public void booleanValueInit(){  
    
    if (rType == PRODUCTlABOUR_REG_RTYPE) {  
         script1Rendered=true;
         script3Rendered=true;
         script4Rendered=true;
         script6Rendered=true;
         script5Rendered=false;
         script2Rendered=false;
         multiProductRendered=true;
         singleProductRendered=false;
         checkBoxRendered=true;
         skuRendered=true;
         wrbRendered=true;
        }
    else if(rType == PRODUCTFLUID_REG_RTYPE){
         script1Rendered=true;
         script2Rendered=true;
         script3Rendered=true;
         script4Rendered=true;
         script5Rendered=false;
         script6Rendered=false;
         multiProductRendered=true;
         singleProductRendered=false;
         skuRendered=true;
         wrbRendered=false;
         checkBoxRendered=true;
                  
        }
     else{ 
         script1Rendered=false;
         script2Rendered=false;
         script4Rendered=true;
         script5Rendered=true;
         script3Rendered=true;
         multiProductRendered=false;
         singleProductRendered=true;
         skuRendered=false;
         wrbRendered=false;
         checkBoxRendered=false;
                  
        }
  }
    
//////////////////////////////////////////
    /* Function Description
    Name :init
    Return Type: void 
    Description: This is method re-directs the user to the corresponding page on select of a particular record type.
    */
    
public void init(){      
     try{
     String ent;
     currentAccountId=ApexPages.currentPage().getParameters().get('def_account_id');
     accName=([select name from account where id=:currentAccountId]);
     retURL = ApexPages.currentPage().getParameters().get('retURL');
     rType = ApexPages.currentPage().getParameters().get('RecordType');
     ent = ApexPages.currentPage().getParameters().get('ent');
     if(rType == PRODUCTlABOUR_REG_RTYPE)
         entit.Type='Warranty - Product & Labor';
     else if (rType == PRODUCTFLUID_REG_RTYPE)
         entit.Type='Warranty - Product Only - Fluid Applied';
     else
         entit.Type='Warranty - Product Only';
         
         entit.recordTypeId=rType ;
         }
         catch(Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Account Found'));
         }
    }
    
/* Constructor of the controller

*/  
  
public ctrlBINA_EnvelopesRegistration(ApexPages.StandardController controller) {
     
     this.controller = controller;
     entit= (Entitlement)controller.getRecord(); 
     SelectedMaterials = new List<SelectOption>();
     AllMaterials= new List<SelectOption>();
     init();
     booleanValueInit();
    
    }
      
   //////////////////////////////////////////
    /* Function Description
    Name :saveEnt
    Return Type: PageReference
    Description: This is a custom Save method to save the Entitlement
    */       
    
public PageReference saveEnt(){
    
     entit.accountId=currentAccountId;
     Integer flag=1;
     try{
     if(checkBox1==false || checkBox2==false && rtype!=PRODUCT_RTYPE ){ 
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide confirmation for both items and then click Save'));
        }
     if(entit.Registration_City__c==NULL || entit.Registration_Postal_Code__c==NULL || entit.Name==NULL || entit.Registration_Address__c==NULL || entit.Registration_Country1__c==NULL || entit.Registration_Postal_Code__c==NULL || entit.Application__c==NULL || entit.Application_Type__c==NULL || entit.startdate==NULL){   
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all mandatory fields (*)'));
        }
      if((entit.Registration_Country1__c=='CANADA'&& entit.Registration_Postal_Code__c.length()!=6)||(entit.Registration_Country1__c=='UNITED STATES'&& entit.Registration_Postal_Code__c.length()!=5)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter 6 digit Zip/Postal Code for Canada and 5 digit Zip/Postal Code for United States'));
             flag=0;        
            }
      if(entit.Lot_Nb__c!=NULL){  
         Pattern isnumbers = Pattern.Compile('^[0-9]+$');
         Matcher skuMatch = isnumbers.matcher(entit.Lot_Nb__c);
         if(!skuMatch .Matches()){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter numeric value for Lot #'));
             flag=0; 
              }
       }
      
     if(flag==1){ 
         PageReference record;
         IF(entit.StartDate.MONTH()==2 && entit.StartDate.day()==29)
         entit.enddate=date.newInstance(entit.StartDate.YEAR()+10,3,1);
         else
         entit.enddate=date.newInstance(entit.StartDate.year()+10,entit.StartDate.month(),entit.StartDate.day());
        
             if (rType == PRODUCTlABOUR_REG_RTYPE){
             Integer wrap=0;
             Integer flash=0;
             Integer counter=0;
             ec=[SELECT Products__c,Accessories__c,category__C FROM Entitlement__c WHERE Application__c=:entit.Application__c and record_Type__c=:'Product & Labor'];
                     
             for( Integer i=0; i<SelectedMaterials.size();i++){ 
                     for( Entitlement__C e : ec){ 
                         if(SelectedMaterials[i].getvalue().equalsIgnoreCase(e.products__c)&& e.category__C=='Wrap')
                             ++wrap;
                            
                         if(SelectedMaterials[i].getvalue().equalsIgnoreCase(e.products__c)&& e.category__C=='Flash')
                             ++flash;
                        }
                }
                if(wrap==0 && flash==0 && entit.WRB_Only__c == false){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Wrap and one Flash product'));
                     return NULL;
                   
                }
                if(wrap==0){ 
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Wrap product'));
                     return NULL;
                }
                if(flash==0 && entit.WRB_Only__c == false){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Flash product'));
                     return NULL;
                }
                entit.product_answer1__c=productAnswer();
            }
         if(rType == PRODUCTFLUID_REG_RTYPE){
                entit.product_answer1__c=productAnswer(); 
             }         
         if(entit.product_answer1__c==Null || entit.product_answer1__c==''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
             return NULL;
            }
         record=validationScript();
         if(record!=NULL){
             record.setRedirect(true);
             return record;
            }
         else{
              return NULL;
           }
    }

     else 
           return NULL;
    }
    catch(Exception e){
    return Null;
    }
        
 }
   
//////////////////////////////////////////
    /* Function Description
    Name :Cancel
    Return Type: PageReference
    Description: on click it will redirect to thre respective Account id
    */
public PageReference cancel(){
   try{
    PageReference accPage;
    accPage= new Pagereference(retURL);
         return accPage;
        }
        catch(Exception e){
        return Null;
        }


}   
       
   //////////////////////////////////////////
    /* Function Description
    Name :productAnswer
    Return Type: String
    Description: Selected Materials is being copied into one String
    */    
     
public string productAnswer(){

     String message;                                  
     Boolean first = true;
     try{   
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
     catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select alteast one product')); 
         return null;
        }
     }

 //////////////////////////////////////////
    /* Function Description
    Name :productSelection
    Return Type: void
    Description: Products Which have to be added in the all material List
    */   
public void productSelection(){   
     AllMaterials.clear();
     SelectedMaterials.clear();
     if (rType == PRODUCTlABOUR_REG_RTYPE) {  
         if(entit.Application__c != NULL ){   
             ec=[SELECT Products__c,Accessories__c,category__C FROM Entitlement__c WHERE Application__c=:entit.Application__c and WRB_Only__c=:entit.WRB_Only__c and record_Type__C=:'Product & Labor'order by Products__c];
             for( Entitlement__C e : ec){ 
                 AllMaterials.add(new SelectOption(e.Products__c, e.Products__c)); 
                 if(e.Accessories__c!=NULL)
                 SelectedMaterials.add( new SelectOption(e.Accessories__c, e.Accessories__c,true));
                }
           }
         else{
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a value in Application to see the Available Materials'));
          }  
        }
     else if(rType == PRODUCTFLUID_REG_RTYPE){
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Fluid Applied Product Only' order by Products__c];
         for( Entitlement__C e : ec){ 
             AllMaterials.add(new SelectOption(e.Products__c, e.Products__c));     
            }
        }
     else{ 
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Product Only' AND Application__c=:entit.Application__c order by Products__c];
         for( Entitlement__C e : ec){ 
             AllMaterials.add(new SelectOption(e.Products__c, e.Products__c));
            }
        }
    }
/* 


*/
//////////////////////////////////////////
    /* Function Description
    Name :validationScript
    Return Type: pagereference 
    Description: Function is written to validate the script and save the record 
    */  
public pagereference validationScript(){
    try
    {
     if (rType == PRODUCTlABOUR_REG_RTYPE) {  
         if (script1.validate()&&script3.validate()&& script4.validate()) {           
         String[] dts = String.ValueOf(script6.getQuestion('Date of Substantial Completion').answer).split('/');         
         Date myDate;    //AK20150203
         if(dts.size()>1)    //AK20150203
         { 
         myDate= Date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
         }    //AK20150203
         String[] dts1 = String.ValueOf(script6.getQuestion('Date of Pre-Installation Meeting').answer).split('/');         
         Date myDate1 = Date.newinstance(Integer.valueOf(dts1[2]), Integer.valueOf(dts1[0]), Integer.valueOf(dts1[1]));
         DateTime d1= system.today();
         //String d2= d1.format('MM/dd/yyyy');
         if(myDate1> d1)
         {
         
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Pre-Installation Meeting cannot be greater than Today'));
                 return NULL;
              }
         if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if(myDate>d1)
         {
         
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Substantial Completion cannot be greater than Todays'));
                 return NULL;
              } 
              
          //AK20150203 if((myDate!=NULL && myDate >= myDate1 && myDate >= entit.startdate)){    
                 insert entit;
                 script1.getQuestion('id').answer=entit.id; 
                 script3.getQuestion('id').answer=entit.id;
                 script4.getQuestion('id').answer=entit.id;
                 script6.getQuestion('id').answer=entit.id;
                 script1.Save();
                 script3.Save();
                 script4.Save();
                 script6.Save();
           //AK20150203    }    
          
           /* AK20150203  else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Substantial Completion should be greater than Date of Pre-Installation Meeting and Date of Product Purchased'));
                 return NULL;
                }         AK20150203 */
             
            }      
        }
     else if(rType == PRODUCTFLUID_REG_RTYPE){
     if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if (script1.validate()&& script2.validate()&& script3.validate()&& script4.validate()) {
             insert entit;
             script1.getQuestion('id').answer=entit.id; 
             script2.getQuestion('id').answer=entit.id;
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script1.Save();
             script2.Save();
             script3.Save();
             script4.Save();
            }      
        }
     else { 
         if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if (script3.validate()&& script4.validate()&& script5.validate()) {
             insert entit;
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script5.getQuestion('id').answer=entit.id;
             script3.Save();
             script4.Save();
             script5.Save();
            }      
        }
    }
     Catch(Exception e)
     {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error in script Validation'+e);
        ApexPages.addMessage(myMsg);
         return Null;
     }
    if(entit.id != NULL){
         Pagereference rec = new Pagereference('/'+entit.id);
         return rec;
        }
    else{
         return NULL;
        }
    }
}
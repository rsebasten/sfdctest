/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopeRegClone
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in BI_NA_EnvelopesRegClone VF Page
//This class allows user to clone and Save a Entitlement
//NS20160330 Date of Substantial Completion shhould be optional while performing cloning opreation
//<SK20171208> Modified the controller to add two new record types(BI_NA_Env_Product_Only_Fluid_Applied_WB, BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS )
//<SA20180111>Added the Logic for Edit functionality to fetch the information saved in Script Header and show the information when someone clicks on edit button on Entitlement record
//<SA20180111>replace insert with upsert so that it will update the existing record when someone edit and save the existing record
//************************************<MG-20140827>***************************************************//
public class ctrlBINA_EnvelopeRegClone{
   
    public SiteScript script1                                   { get; set; }
    public SiteScript script2                                   { get; set; }
    public SiteScript script3                                   { get; set; }
    public SiteScript script4                                   { get; set; }
    public SiteScript script5                                   { get; set; }
    public SiteScript script6                                   { get; set; }
    public Entitlement entit                                    { get; set; }
    public SelectOption[] SelectedMaterials                     { get; set; }  
    public SelectOption[] AllMaterials                          { get; set; }
    private String entitlementId;                                
    private String rType;                                         
    public Boolean checkBox1                                    { get; set; }
    public Boolean checkBox2                                    { get; set; }
    public Boolean checkBox3                                    { get; set; }
    public Boolean renderedCheckbox                             { get; set; }
    public Boolean multiProductRendered                         { get; set; }
    public Boolean singleProductRendered                        { get; set; }
    public Boolean script1Rendered                              { get; set; }
    public Boolean script2Rendered                              { get; set; }
    public Boolean script2Rendered_WB                           { get;set;  }
    public Boolean script3Rendered                              { get; set; }
    public Boolean script4Rendered                              { get; set; }
    public Boolean script5Rendered                              { get; set; }
    public Boolean script6Rendered                              { get; set; }
    public boolean skuRendered{get;set;}
    public boolean wrbRendered{get;set;}
    public boolean checkBoxRendered                              {get;set;}
    public boolean checkBox3Rendered                             {get;set;}
    private Integer counter ;
    Private Entitlement entit1 ;  //<SA20180111>created a new Variable to set the newly created Entitlement record id
    public boolean editRender                                   { get; set; }
    private Date inputDate{get; set;}
    public list<Entitlement__c> ec                              { get; set; }
    private ApexPages.StandardController controller ;
    //<SK20171208> Added two new record types
    private static Id PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS');
    private static Id PRODUCT_ONLY_FLUID_WB_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied_WB');
     //<SK20171208> ----End
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
     try{
     counter=0;
     entitlementId=ApexPages.currentPage().getParameters().get('id');
         
     LIST <SFDC_Script_Header__c> scriptheaderid= new LIST <SFDC_Script_Header__c>([SELECT Id from SFDC_Script_Header__c where Entitlement__r.id =:entitlementId ]);
     for(SFDC_Script_Header__c sh : scriptheaderid)
         initalScriptDefault( sh,counter);
     }
     Catch(Exception Ex)
     {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no script with present to initialize!!'));
     } 
    }
    
public PageReference redirectToPage(){  
     try
     {
     PageReference returnURL;
     Entitlementid=ApexPages.currentPage().getParameters().get('id');
     system.debug('The Entitlement id is'+entitlementId);
     returnURL = new PageReference('/apex/BI_NA_EnvelopesRegClone');
     returnURL.getParameters().put('id',entitlementId);
     returnURL.getParameters().put('nooverride', '1');
     returnURL.setRedirect(true);
     initScript();
     return returnURL;
     }
     catch(Exception e)
     {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The return page is NULL! no such Page Found'));
     return null;
     }
    }
//////////////////////////////////////////
    /* Function Description
    Name :booleanValueInit
    Return Type: void 
    Description: This function is written for the intialization of variable and for passing argument to the vf page
    */
    

public void booleanValueInit(){  
    
     renderedCheckbox=false;
     if (rType == PRODUCTlABOUR_REG_RTYPE) {
         //DB20150814 coding Start 
        // if(ApexPages.currentPage().getParameters().get('mode')!='Edit'){
         script1Rendered=true;
         script3Rendered=true;
         script4Rendered=true;
         script6Rendered=true;
         script5Rendered=false;
         script2Rendered=false;
         script2Rendered_WB=false;
       //  }
       //DB20150814 coding End
                
         multiProductRendered=true;
         singleProductRendered=false;
         checkBox3Rendered=false;
         checkBoxRendered=true;
         skuRendered=true;
         wrbRendered=true;
        }
     else if(rType == PRODUCTFLUID_REG_RTYPE){
         //DB20150814 coding Start
        // if(ApexPages.currentPage().getParameters().get('mode')!='Edit'){
         script1Rendered=true;
         script2Rendered=true;
         script2Rendered_WB=false;
         script3Rendered=true;
         script4Rendered=true;
         script5Rendered=false;
         script6Rendered=false;
        // }
        //DB20150814 coding End
         multiProductRendered=true;
         singleProductRendered=false;
         skuRendered=true;
         checkBoxRendered=true;
         checkBox3Rendered=false;
         wrbRendered=false;
        }
    //<SK20171208>--Start Added definition to this method
    else if(rType == PRODUCT_ONLY_FLUID_WB_REG_RTYPE){
         script1Rendered=true;
         script2Rendered=false;
         script2Rendered_WB=true;
         script3Rendered=true;
         script4Rendered=true;
         script5Rendered=false;
         script6Rendered=false;
         multiProductRendered=true;
         singleProductRendered=false;
         skuRendered=true;
         wrbRendered=false;
         checkBoxRendered=true;
        checkBox3Rendered=false;
        
    }
    
     else if(rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE){
         script1Rendered=true;
         script2Rendered=true;
         script2Rendered_WB=false;
         script3Rendered=true;
         script4Rendered=true;
         script5Rendered=false;
         script6Rendered=false;
         multiProductRendered=true;
         singleProductRendered=false;
         skuRendered=true;
         wrbRendered=false;
         checkBoxRendered=true;
         checkBox3Rendered=true;
        }
    //<SK20171208>--End
     else{ 
    //DB20150814 coding Start
    // if(ApexPages.currentPage().getParameters().get('mode')!='Edit'){
         script1Rendered=false;
         script2Rendered=false;
         script2Rendered_WB=false;
         script4Rendered=true;
         script5Rendered=true;
         script3Rendered=true;
        // }
      //DB20150814 coding End
         multiProductRendered=false;
         singleProductRendered=true;
         skuRendered=false;
         checkBoxRendered=false;
         wrbRendered=false;
         checkBox3Rendered=false;
        }
         
    }


    /* Function Description
    Name :init
    Return Type: void 
    Description: This is method re-directs the user to the corresponding page on select of a particular record type.
    */
      
public void init(){
    
    //<SA20180111> Added the Logic for edit functionality 
	List<String> scriptNameList = new List<String>{'Project Information','Project Information WB+','Project Information WB+ w/EIFS', 'Certified Installer Information','Certified Installer Information WB', 'Related Contact Information','Project Information - Product Only','Estimated Product Exposure Time(in Days)','Warranty Dates'};
	Map<String, String> mapScriptNameId = new Map<String, String>();
	Map<String, String> mapScriptNameHeader = new Map<String, String>();    
    for(SFDC_Script__c sc: [Select id, Name from SFDC_Script__c where Name IN: scriptNameList])
	{
  		mapScriptNameId.put(sc.Name , sc.Id);
	}
    for(SFDC_Script_Header__c scHeader : [Select Id, name, Script__c,Script__r.name from SFDC_Script_Header__c where Entitlement__c =:entitlementId and Script__c IN :mapScriptNameId.values()]){
        mapScriptNameHeader.put(scHeader.Script__r.name, scHeader.Id);
    }
    
    
    if(rType == PRODUCT_ONLY_FLUID_WB_REG_RTYPE){
        
      
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
            if(mapScriptNameHeader.containsKey('Project Information WB+')){
               script1= new SiteScript(mapScriptNameId.get('Project Information WB+'),mapScriptNameHeader.get('Project Information WB+') );
            }
        }
        else{
            script1= new SiteScript(mapScriptNameId.get('Project Information WB+'));
        }
        
   
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
             if(mapScriptNameHeader.containsKey('Certified Installer Information WB')){
               script2= new SiteScript(mapScriptNameId.get('Certified Installer Information WB'),mapScriptNameHeader.get('Certified Installer Information WB') );
            }
       
        }else{
             script2= new SiteScript(mapScriptNameId.get('Certified Installer Information WB'));
        }
        
    }
    
    else if (rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE){
     
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
            if(mapScriptNameHeader.containsKey('Project Information WB+ w/EIFS')){
              script1= new SiteScript(mapScriptNameId.get('Project Information WB+ w/EIFS'),mapScriptNameHeader.get('Project Information WB+ w/EIFS') );
            }
        }
        else{
            script1= new SiteScript(mapScriptNameId.get('Project Information WB+ w/EIFS'));
        }
        
       
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
             if(mapScriptNameHeader.containsKey('Certified Installer Information')){
               script2= new SiteScript(mapScriptNameId.get('Certified Installer Information'),mapScriptNameHeader.get('Certified Installer Information') );
            }
       
        }else{
             script2= new SiteScript(mapScriptNameId.get('Certified Installer Information'));
        }
              
     }

 
     
    else{
     
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
       if(mapScriptNameHeader.containsKey('Project Information')){
             script1= new SiteScript(mapScriptNameId.get('Project Information'),mapScriptNameHeader.get('Project Information'));
            }
        }else{
            script1= new SiteScript(mapScriptNameId.get('Project Information'));
        }
        
      
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
       if(mapScriptNameHeader.containsKey('Certified Installer Information')){
             script2= new SiteScript(mapScriptNameId.get('Certified Installer Information'),mapScriptNameHeader.get('Certified Installer Information'));
            }
        }else{
            script2= new SiteScript(mapScriptNameId.get('Certified Installer Information'));
        }
        
        
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
       if(mapScriptNameHeader.containsKey('Project Information - Product Only')){
             script5= new SiteScript(mapScriptNameId.get('Project Information - Product Only'),mapScriptNameHeader.get('Project Information - Product Only') );
            }
        }else{
            script5= new SiteScript(mapScriptNameId.get('Project Information - Product Only'));
        }
        
        
    }
    
    
    if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
   if(mapScriptNameHeader.containsKey('Related Contact Information')){
            script3= new SiteScript(mapScriptNameId.get('Related Contact Information'),mapScriptNameHeader.get('Related Contact Information'));
            }
        }else{
            script3= new SiteScript(mapScriptNameId.get('Related Contact Information'));
        }
        
        
         if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
        if(mapScriptNameHeader.containsKey('Estimated Product Exposure Time(in Days)')){
               script4= new SiteScript(mapScriptNameId.get('Estimated Product Exposure Time(in Days)'),mapScriptNameHeader.get('Estimated Product Exposure Time(in Days)'));
            }
        }else{
            script4= new SiteScript(mapScriptNameId.get('Estimated Product Exposure Time(in Days)'));
        }
        
        
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
        if(mapScriptNameHeader.containsKey('Warranty Dates')){
                script6= new SiteScript(mapScriptNameId.get('Warranty Dates'),mapScriptNameHeader.get('Warranty Dates'));
            }
        }else{
            script6= new SiteScript(mapScriptNameId.get('Warranty Dates'));
        }
   // <SA20180111>---<End>
      
    }
public void dataInitial(){
     
     entit1 = ([select 
                name,
                recordtypeid,
                Registration_Address__c,
                type,
                stage__c,
                Registration_City__c,
                Application__c,
                Registration_State_Province__c,
                Registration_Postal_Code__c,
                Accountid,
                Registration_Country1__c,
                Application_Type__c,
                startdate,
                WRB_Only__c,
                Lot_Nb__c,
                Building_Type__c,
                product_answer1__c
                from entitlement where id=:entitlementId]);
                              
     entit.Registration_Address__c=entit1.Registration_Address__c;
     entit.type=entit1.type;
     entit.Registration_Country1__c=entit1.Registration_Country1__c;
     entit.Registration_City__c=entit1.Registration_City__c;
     entit.Application__c=entit1.Application__c;
     entit.Application_Type__c=entit1.Application_Type__c;
     entit.Registration_State_Province__c=entit1.Registration_State_Province__c;
     entit.recordtypeid=entit1.recordtypeid;
     entit.Registration_Postal_Code__c=entit1.Registration_Postal_Code__c;
     entit.Accountid=entit1.Accountid;
     entit.startdate=entit1.startdate;
     entit.Lot_Nb__c=entit1.Lot_Nb__c;
     entit.Building_Type__c=entit1.Building_Type__c;
     entit.product_answer1__c=entit1.product_answer1__c;
     entit.WRB_Only__c=entit1.WRB_Only__c;
     
     if(ApexPages.currentPage().getParameters().get('mode')=='Edit'){
     entit.name=entit1.name;
     entit.stage__c=entit1.stage__c;
     entit.Id=entitlementId;//<SA20180111>
         
     }
                      
    }
 public void initalProduct(){
  
     String[] product=entit.product_answer1__c.split('\\;');
     if (rType == PRODUCTlABOUR_REG_RTYPE){
         system.debug('the application is'+entit.Application__c);
         ec=[SELECT Products__c,Accessories__c,category__C FROM Entitlement__c WHERE Application__c=:entit.Application__c and WRB_Only__c=:entit.WRB_Only__c and record_Type__c=:'Product & Labor' order by Products__C];
         for(Integer i=0; i<product.size();i++){
             SelectedMaterials.add(new selectoption(product[i],product[i]));
            }
         Set<String> tSet=new Set<String>();
         tSet.addAll(product);
         for(Integer i=0; i<ec.size();i++){ 
             if(!tSet.contains(ec[i].Products__c))
                AllMaterials.add(new SelectOption(ec[i].Products__c, ec[i].Products__c));
                }
            }
     else if(rType == PRODUCTFLUID_REG_RTYPE){
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Fluid Applied Product Only' order by Products__C];
         for(Integer i=0; i<product.size();i++){
             SelectedMaterials.add(new selectoption(product[i],product[i]));
            }
         Set<String> tSet=new Set<String>();
         tSet.addAll(product);
         for(Integer i=0; i<ec.size();i++){ 
             if(!tSet.contains(ec[i].Products__c))
                AllMaterials.add(new SelectOption(ec[i].Products__c, ec[i].Products__c));
                }
        }
     
     //<SK20171208>--<Start> Added the condition to this method to select the materials 
     else if(rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE ||rType == PRODUCT_ONLY_FLUID_WB_REG_RTYPE ){
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Product Only WB+' AND Application__c=:entit.Application__c order by Products__C];
         for(Integer i=0; i<product.size();i++){
             SelectedMaterials.add(new selectoption(product[i],product[i]));
            }
         Set<String> tSet=new Set<String>();
         tSet.addAll(product);
         for(Integer i=0; i<ec.size();i++){ 
             if(!tSet.contains(ec[i].Products__c))
                AllMaterials.add(new SelectOption(ec[i].Products__c, ec[i].Products__c));
                }
        }
     //<SK20171208>--<End>
     
     
    else{   
         AllMaterials.add(new SelectOption(Product[0], Product[0]));
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Product Only' AND Application__c=:entit.Application__c order by Products__C];
         for( Entitlement__C e : ec){ 
             if(e.products__C!=product[0])
                 AllMaterials.add(new SelectOption(e.Products__c, e.Products__c));
            }       
        }
    
    }
 
public ctrlBINA_EnvelopeRegClone(ApexPages.StandardController controller) {
    
     this.controller = controller;
     entit= new Entitlement(); 
     SelectedMaterials = new List<SelectOption>();
     AllMaterials= new List<SelectOption>();
     entitlementId=ApexPages.currentPage().getParameters().get('id');
     dataInitial();
     rType=entit.recordtypeid;
	 init();
     booleanValueInit();
     initalProduct();  
    }
    
    
    
    //////////////////////////////////////////
    /* Function Description
    Name :saveEnt
    Return Type: PageReference
    Description: This is a custom Save method to save the Entitlement
    */     
public PageReference saveEnt(){
  
  Integer flag=1;
  //Date dt=date.valueOf(entit.startdate);
  //entit.startdate=dt;
  try{
     if(checkBox1==false || checkBox2==false || checkbox3==false && rtype!=PRODUCT_RTYPE ){ 
         flag=0;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide confirmation for all items and then click Save'));
        }
     if(entit.Registration_City__c==NULL || entit.Registration_Postal_Code__c==NULL || entit.Name==NULL || entit.Registration_Address__c==NULL || entit.Registration_Country1__c==NULL || entit.Registration_Postal_Code__c==NULL || entit.Application__c==NULL || entit.startdate==NULL || entit.Application_Type__c==NULL){   
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
         //<SK20171208>--<Start> Added the definition to this method to throw validation error if the product is not selected 
         if(rType == PRODUCTFLUID_REG_RTYPE|| rType ==PRODUCT_ONLY_FLUID_WB_REG_RTYPE||rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE){
                entit.product_answer1__c=productAnswer(); 
             }         
         if(entit.product_answer1__c==Null || entit.product_answer1__c==''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one product'));
             return NULL;
            }
       //  if(ApexPages.currentPage().getParameters().get('mode')!='')//rr
         record=validationScript();
         
        /* else{
             entit.id=entit1.id;
             update entit; 
             record=new pageReference('/'+entit.id);
         } */
         
         if(record!=NULL){
             record.setRedirect(true);
             return record;
            }
         else{
              return NULL;
           }
        }
           return NULL;
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
        }
     catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please enter all mandatory fields');
             ApexPages.addMessage(myMsg); 
        }
     return message ;
    }

public void productValidation(){   

     AllMaterials.clear();
     SelectedMaterials.clear();
     if (rType == PRODUCTlABOUR_REG_RTYPE) {  
         if(entit.Application__c != NULL ){
         ec=[SELECT Products__c,Accessories__c,category__C FROM Entitlement__c WHERE Application__c=:entit.Application__c and WRB_Only__c=:entit.WRB_Only__c and record_Type__C=:'Product & Labor'order by Products__c];
         system.debug('------ list of entitlement--'+ec);
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
      //<SK20171208>--Start Added validation  for two new record types
    else if (rType == PRODUCT_ONLY_FLUID_WB_REG_RTYPE || rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE) {  
         if(entit.Application__c != NULL ){   
             ec=[SELECT Products__c,category__C FROM Entitlement__c WHERE Application__c=:entit.Application__c and record_Type__C=:'Product Only WB+'order by Products__c];
             for( Entitlement__C e : ec){ 
                 AllMaterials.add(new SelectOption(e.Products__c, e.Products__c)); 
                 }
           }
         else{
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a value in Application to see the Available Materials'));
          }  
        }
    //<SK20171208>--End
    
     else{ 
     
         
         ec=[SELECT Products__c FROM Entitlement__c WHERE record_Type__C=:'Product Only' AND Application__c=:entit.Application__c order by Products__c];
         for( Entitlement__C e : ec){ 
             AllMaterials.add(new SelectOption(e.Products__c, e.Products__c));
            }
        }
     
    }
    
//////////////////////////////////////////
    /* Function Description
    Name :validationScript
    Return Type: pagereference 
    Description: Function is written to validate the script and save the record 
    */ 
    
public PageReference ValidationScript(){
    
     if (rType == PRODUCTlABOUR_REG_RTYPE) {  
         if (script1.validate()&&script6.validate()&&script3.validate()&& script4.validate()) {
         String[] dts = String.ValueOf(script6.getQuestion('Date of Substantial Completion').answer).split('/');
        //String[] dts = String.ValueOf(script6.getQuestion('Date of Substantial Completion').answer)!=null ? String.ValueOf(script6.getQuestion('Date of Substantial Completion').answer).split('/'):new list<string>{null,null};         
        Date myDate;        //NS20160330
        if(dts.size()>1)   //NS20160330
        { 
        myDate= Date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
        }    //NS20160330
        //Date myDate = Date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
         string[] dts1 = String.ValueOf(script6.getQuestion('Date of Pre-Installation Meeting').answer).split('/');         
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
         if(myDate > d1)
         {
         
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Substantial Completion cannot be greater than Today'));
                 return NULL;
              } 
         //NS20160330if((myDate >= myDate1 && myDate >= entit.startdate)){
         
             upsert entit; //<SA20180111>
             script1.getQuestion('id').answer=entit.id; 
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script6.getQuestion('id').answer=entit.id;
             script1.Save();
             script3.Save();
             script4.Save();
             script6.Save();
            //NS20160330 }
             /* else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Substantial Completion should be greater than Date of Pre-Installation Meeting and Date of Product Purchase'));
                 return null;
                } */
            } 
         //<SA20180111> Added the else condition to throw validation error--<Start>
         else{
                return null;
            }
         //<End>
        }
     else if(rType == PRODUCTFLUID_REG_RTYPE){
      if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if (script1.validate()&& script2.validate()&& script3.validate()&& script4.validate()) {
             upsert entit; //<SA20180111>
             script1.getQuestion('id').answer=entit.id; 
             script2.getQuestion('id').answer=entit.id;
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script1.Save();
             script2.Save();
             script3.Save();
             script4.Save();
            }      
         //<SA20180111> Added the else condition to throw validation error--<Start>
         else{
                return null;
            } 
         //<End>
        }
    //<SK20171208>--<Start> Added the condition for this method to validate all information before saving entitlement 
    
     else if(rType == PRODUCT_ONLY_FLUID_WB_REG_RTYPE|| rType == PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE ){
     if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if (script1.validate()&& script2.validate()&& script3.validate()&& script4.validate()) {
             upsert entit; //<SA20180111>
             script1.getQuestion('id').answer=entit.id; 
             script2.getQuestion('id').answer=entit.id;
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script1.Save();
             script2.Save();
             script3.Save();
             script4.Save();
            }
        //<SA20180111> Added the else condition to throw validation error--<Start>
            else{
                return null;
            } 
         //<End>
        }
     //<SK20171208>---<End>
    
    
     else { 
          if(entit.startdate>system.today())
         {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date of Product Purchased cannot be greater than Today'));
                 return NULL;
         }
         if (script3.validate()&& script4.validate()&& script5.validate()) {
             upsert entit; //<SA20180111>
             script3.getQuestion('id').answer=entit.id;
             script4.getQuestion('id').answer=entit.id;
             script5.getQuestion('id').answer=entit.id;
             script3.Save();
             script4.Save();
             script5.Save();
            }
          //<SA20180111> Added the else condition to throw validation error--<Start>
         else{
                return null;
            } 
         //<End>
        }
    
    /*Catch(Exception e) {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter all mandatory fields');
         ApexPages.addMessage(myMsg);
        }
    */
     if(entit.id != null){
        PageReference  rec= new Pagereference('/'+entit.id);
        return rec;
        }
     else{
         return null;
        }
    }
    
public void initalScriptDefault( SFDC_Script_Header__c sh, Integer counter){

     LIST <SFDC_Script_Result__c> result;
     LIST <SFDC_Questions__c> question;                   
     result=new list <SFDC_Script_Result__c>([ SELECT id, Answer__c FROM SFDC_Script_Result__c WHERE Script_Result__r.id=:sh.id ORDER BY QuestionId__r.name]);
     question=new list <SFDC_Questions__c>([ SELECT name, DefaultAnswer__c from SFDC_Questions__c where id in (SELECT questionid__c FROM SFDC_Script_Result__c WHERE Script_Result__r.id =:sh.id) ORDER BY name]);
     for (Integer i=0;i<question.size();i++){  
         if(counter ==0){ 
             if(question[i].name!='RegistrationId'){
                question[i].DefaultAnswer__c =result[i].Answer__c;
               }
            }   
     }
     update question;

    } 

}
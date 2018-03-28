/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Pranitha S
Email: Pranitha_S@infosys.com
Description:  Controller for page BPDCase to display initial list of fields for entering a case
  Ver      Date        Author               Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.1   14-Apr-15  Isha Taneja   Added checkbox to enable/disable the sample creation section as well as added sample result insertion.
<IT 20150414>
* 1.2   12-May-15  Isha Taneja   Added Date Opened field on the Case creation page with default value as today.
<IT 20150512>
* 1.3    22-May-15  Anup kumar   Made "Brand" and "SBU" as Mandatory fields, also added the field "facts of the case" in updation.
<AK20150522>
*1.5     14-Jul-16  <Bhargavi 20160714> Made Crop/Phase Status' Filed not visible and uncheck the 'Click checkbox to enter samplle details' 
                    for other than Crop protection Users as Part of issue IS ID-00070805
 *****************************************************************************/
 
public with sharing class ctrlBPDCase{

public static Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
 public Case createCase {get;set;}
 public Case_Details__c createCaseDetail {get;set;}
 public Case_Details__c initialCaseDetail {get;set;}
 public Trademark_Abuse_Sample__c createSample{get;set;}
 public Trademark_Abuse_Sample__c initialSample{get;set;}
 public Trademark_Abuse_Sample_Analysis__c initialSampleResult{get;set;}
 public String recordType {get;set;}
 public String userSBU{get;set;}
 public Boolean permissions{get;set;}
 public SelectOption[] SelectedMaterials { get; set; }  
 public SelectOption[] AllMaterials { get; set; }
 public SelectOption[] finalSBUs{ get; set; }
 public Set<SelectOption> AllSBUs{ get; set; }  
 public SelectOption[] SelectedSBUs { get; set; }  
 public transient LIST<BPD_Sample_Settings__c> brand{get; set;}
 public LIST<BPD_Sample_Settings__c> brand1{get; set;}
 public string searchBrand {get;set;}
 public Boolean noBrand{get;set;}
 public Boolean flagVar{get;set;}
 
 public Boolean flagSample{get; set;}
  public Boolean flagSample1{get; set;}
 
 public Set<String> selectedSBUList;
 List<String> brands;
 public User u{get;set;} 
 public Set<String> storebrand;
 list<string> oldValues;
 
  public ctrlBPDCase() {
  brandsse =  new List<string>();
  oldValues =  new List<string>();
  flagvar=false;   // <Bhargavi 20160714> made value as flase corporate users
  flagSample=true;
  flagSample1=true;

  initialCaseDetail = new Case_Details__c ();
  initialCaseDetail = new Case_Details__c ();
//<!--<IT 20150512> Added Date Opened -->
  initialCaseDetail.Date_opened__c = Date.Today();
  initialCaseDetail.RecordTypeId = CaseDetailsRecordType;
  storebrand= new Set<String>();
  initialSample = new Trademark_Abuse_Sample__c();
  initialSampleResult = new Trademark_Abuse_Sample_Analysis__c();
  SelectedMaterials = new List<SelectOption>();
  AllMaterials= new List<SelectOption>();
  SelectedSBUs = new List<SelectOption>();
  finalSBUs = new List<SelectOption>();
  AllSBUs = new Set<SelectOption>();
  createCase = new Case();
  recordType = System.currentPageReference().getParameters().get('rtype');
  createCase.RecordTypeId = recordType;
  u=[Select id,UserOwningSBUOrg__c from User where id = :Userinfo.getUserId()];
    for(BPD_Sample_Settings__c se:[Select Owning_Org__c from BPD_Sample_Settings__c where Owning_Org__c!=null order by Owning_Org__c ASC]){
    if(!(u.UserOwningSBUOrg__c == 'Crop Protection' && se.Owning_Org__c == 'Crop Protection') )
    AllSBUs.add(new SelectOption(se.Owning_Org__c, se.Owning_Org__c));
    }
    List<SelectOption> sortedSbuList = new List<SelectOption>(AllSBUs);
    sortedSbuList.sort();
    finalSBUs.addAll(sortedSbuList);
    if(u.UserOwningSBUOrg__c == 'Crop Protection'){
    SelectedSBUs.add(new SelectOption('Crop Protection','Crop Protection'));
    AllSBUs.remove(new SelectOption('Crop Protection','Crop Protection')); 
    List<BPD_Sample_Settings__c > cropBrands = [Select Name from BPD_Sample_Settings__c where Owning_Org__c ='Crop Protection'];
    for(BPD_Sample_Settings__c cropBrand : cropBrands ){                             
    AllMaterials.add(new SelectOption(cropBrand.Name, cropBrand.Name)); 
    }
    initialCaseDetail.Crop_Phase_Status__c = 'Incident';
    flagVar=true;
     }
     // Start of <Bhargavi 20160714>
    else {
     //flagVar=false; 
     flagSample=false;
         
    }
    //End of <Bhargavi 20160714>
     
 }
     


//<!--<IT 20150512> Added Date Opened-->  
  public PageReference doSave(){  
  /* Start changes <AK20150522> Made Brand and SBU as Mandatory fields*/
  if((SelectedSBUs == null || SelectedSBUs.size()==0) || (SelectedMaterials== null || SelectedMaterials.size()==0)){
ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select an SBU and also a corresponding Brand')); 
        return null;
    }
  /* Changes Over */
//  <Bhargavi 20160714> added u.UserOwningSBUOrg__c == 'Crop Protection' condition
    else if(initialCaseDetail.Facts_of_the_Case__c == null || initialCaseDetail.Target_Country__c == null || initialCaseDetail.Infringement_Type__c == null || String.isEmpty(initialCaseDetail.Company__c) ||
   initialCaseDetail.Record_Origination__c == null || initialCaseDetail.Date_Opened__c == null || (flagVar==true && u.UserOwningSBUOrg__c == 'Crop Protection' && flagSample1==true &&(String.isEmpty(initialSample.Country__c) 
   || initialSample.Identification_Date__c == null || String.isEmpty(initialSample.Active_Ingredients__c) || String.isEmpty(initialSampleResult.Lab_Name__c) )) ){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please enter information in the mandatory fields')); 
          return null;
        }
  else {
   if(permissions == false && userSBU != createCase.Owning_SBU__c ){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'You cannot create a Case for any other SBU')); 
          return null;
        }
        else{
   createCase.Submitted_By_First_Name_Last_Name__c= UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
   createCase.RecordTypeId =Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
 
   insert createCase;

//<!--<IT 20150512> Added Date Opened-->  
   createCaseDetail = [SELECT Id
   FROM Case_Details__c WHERE Related_Case__c =:createCase.id limit 1];
   createCaseDetail.Type_of_Record__c = initialCaseDetail.Type_of_Record__c ;
   createCaseDetail.Date_Opened__c = initialCaseDetail.Date_Opened__c ;
   createCaseDetail.Record_Origination__c = initialCaseDetail.Record_Origination__c ;
   createCaseDetail.How_Trademark_is_Used__c = initialCaseDetail.How_Trademark_is_Used__c ;
   createCaseDetail.Infringement_Type__c = initialCaseDetail.Infringement_Type__c ;
   createCaseDetail.Infringing_Product_Description__c = initialCaseDetail.Infringing_Product_Description__c ;
   createCaseDetail.Company__c= initialCaseDetail.Company__c;
   createCaseDetail.Procedural_Status__c = initialCaseDetail.Procedural_Status__c ;
   createCaseDetail.Owning_SBU__c=BrandAnswer(SelectedSBUs);
   createCaseDetail.Brand__c=BrandAnswer(SelectedMaterials);
   createCaseDetail.Address__c=initialCaseDetail.Address__c;
   createCaseDetail.City__c=initialCaseDetail.City__c;
   createCaseDetail.State__c=initialCaseDetail.State__c;
   createCaseDetail.Zip_Postal_Code__c=initialCaseDetail.Zip_Postal_Code__c;
   createCaseDetail.Target_Country__c=initialCaseDetail.Target_Country__c;
   createCaseDetail.Crop_Phase_Status__c = initialCaseDetail.Crop_Phase_Status__c;
   createCaseDetail.Facts_of_the_Case__c=initialCaseDetail.Facts_of_the_Case__c; // <AK20150522>
   update createCaseDetail;
   
   if(u.UserOwningSBUOrg__c == 'Crop Protection'){
   flagVar=true;
   initialSample.RecordTypeId=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
   initialSample.Case__c=createCase.id;
   if(flagSample1==true){
   insert initialSample;}
    }
//<*--- <IT 20150414> Sample result creation--*>   

   if(u.UserOwningSBUOrg__c == 'Crop Protection'){
   flagVar=true;
   initialSampleResult.Trademark_Abuse_Sample__c=initialSample.id;
   if(flagSample1==true){
   insert initialSampleResult;}
    }
   
      PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' +createCase.id);
    return PageRef;
    }
  }
 } 
  public PageReference doCancel(){  
   Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    PageReference pageRef = new PageReference('/' + result.getKeyPrefix()+ '/o');
    pageRef.setRedirect(true);
    return pageRef;
  }
   
  public void brandselect(){
  selectedSBUList = new Set<String>();
  AllMaterials.clear();
  for ( SelectOption so : SelectedSBUs) {
  selectedSBUList.add(so.getvalue());
  }
  if(selectedSBUList.size()>0){
      brand=[Select Name,Abbreviation__c,Distinguisher_Field__c from BPD_Sample_Settings__c where Owning_Org__c IN  :selectedSBUList order by Name];
    for(BPD_Sample_Settings__c se : brand){                             
    AllMaterials.add(new SelectOption(se.Name, se.Name)); 
    }
    for(integer i=0;i<SelectedMaterials.Size();i++)
      {
      BPD_Sample_Settings__c owningOrg = [Select Owning_Org__c  from BPD_Sample_Settings__c where name  =:SelectedMaterials[i].getValue() order by Owning_Org__c limit 1];
      if(!selectedSBUList.contains(owningOrg.Owning_Org__c)){
      List<BPD_Sample_Settings__c > alllBrands = [Select name from BPD_Sample_Settings__c where Owning_Org__c =:owningOrg.Owning_Org__c order by Name];
      for(BPD_Sample_Settings__c brandName : alllBrands  ){
      if(SelectedMaterials[i].getValue() == brandName.name ){
      SelectedMaterials.remove(i);
      }  
     }          
    }
   }
  }
   else {
   SelectedMaterials.clear();
   AllMaterials.clear();
   }
  for(integer i=0; i<SelectedMaterials.size(); i++){
  for(Integer j=0; j<AllMaterials.size(); j++){
  IF(SelectedMaterials[i].getvalue()==AllMaterials[j].getvalue()){
      AllMaterials.remove(j);
   }
  } 
 }
}
  
  

  
 public string BrandAnswer(SelectOption[] listName){

     String message;                                  
     Boolean first = true;
         message ='';
         for ( SelectOption so : listName) {
             if (!first) {
                message += ';';
                }
             message += so.getvalue();
             first = false;
            }
            return message ;
        }
        
        
 public void SearchBrandvalue(){
 noBrand=false;
 AllMaterials.clear();
 string search='%'+searchBrand+'%';
  brand=[Select Name from BPD_Sample_Settings__c where Owning_Org__c IN :selectedSBUList and Name like :search order by Name];
        Integer totalsize = brand.size();
        Set<String> tSet=new Set<String>();
        if(SelectedMaterials.size()!=0){
         String[] tempSelected=new List<String>();
         for (integer i=0;i<SelectedMaterials.size();i++){ 
             if(SelectedMaterials[i].getvalue().toLowerCase().contains(searchBrand.toLowerCase())){
                 tempSelected.add(SelectedMaterials[i].getvalue());
            }
         }
         if(tempselected.size()>0){
         tSet.addAll(tempSelected);}
      }
       for (integer i=0;i<brand.size();i++){
         if(!tSet.contains((Brand[i].name)))
             AllMaterials.add(new SelectOption(brand[i].name, brand[i].name));
        }
        
     if(AllMaterials.size()==0){ 
         noBrand=true;
        }
        }
        
        /*-------------------------------*/
 public List<string> brandsSe{get;set;}
 public List<string> SelectedMaterial{get;set;}
 
 public void selectBrands(){
try{
  List<String> selectedSBUList = new List<String>();
  if(brandsSe != null){
      for(string s:brandsSe){
       oldValues.add(s);
     }
  }
  AllMaterials.clear();
  for ( SelectOption so : SelectedSBUs) {
  selectedSBUList.add(so.getvalue());
  }
  if(brandsSe !=null){
      brand=[Select Name,Abbreviation__c,Distinguisher_Field__c from BPD_Sample_Settings__c where Owning_Org__c IN  :oldValues order by Name];
    for(BPD_Sample_Settings__c se : brand){                             
    AllMaterials.add(new SelectOption(se.Name, se.Name));
    }
   }
   else{
   AllMaterials.clear();
   }
}catch(Exception e){
    system.debug(e.getLinenumber());
}
  }
  
//<*--- <IT 20150414> Checkbox Code--*> 
  
public pageReference chkBox(){
   if(flagSample==true ){
   flagSample1=true;
   }
  else {
  flagSample1=false;
   }
  
  system.debug('---inside checkboxz method--hcbox-flagsample111---'+flagSample1);
  return null;
  
  }
}
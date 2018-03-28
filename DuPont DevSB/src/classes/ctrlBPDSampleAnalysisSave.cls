/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for page BPDSampleAnalysisSave to save the Sample Analysis record
 *****************************************************************************/
 
public with sharing class ctrlBPDSampleAnalysisSave{
  public Trademark_Abuse_Sample_Analysis__c  initialSample {get;set;}
  public String sampleId{get;set;}
  public SelectOption[] SelectedMaterials { get; set; }
  public SelectOption[] SelectedMaterialsCompound{get;set;}
  public SelectOption[] AllMaterials { get; set; }
  public SelectOption[] AllMaterialsCompound { get; set; }
  public Business_Partner__c bp{get;set;}
  public LIST<Business_Partner__c> activeForbrand{get; set;}
  public LIST<Business_Partner__c> compound{get; set;}
  public string searchActiveForBrand {get;set;}
  public String searchCompound{get;set;}
  public Attachment attach = new Attachment();
  public List<Attachment> allAttachments{get;set;}
  public String fileName{get;set;}
  public Blob bl{get;set;} 
  

public ctrlBPDSampleAnalysisSave(ApexPages.StandardController stdController) {
 initialSample = new Trademark_Abuse_Sample_Analysis__c  (); 
 SelectedMaterials = new List<SelectOption>();
 SelectedMaterialsCompound = new List<SelectOption>();
 AllMaterials= new List<SelectOption>();
 AllMaterialsCompound = new List<SelectOption>();
 sampleId = System.currentPageReference().getParameters().get('sampleId');
 activeForBrand=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives'];    
    for(Business_Partner__c se:activeForBrand){
    AllMaterials.add(new SelectOption(se.Name, se.Name));
    
    }
  compound=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives'];    
    for(Business_Partner__c se:compound){
    AllMaterialsCompound.add(new SelectOption(se.Name, se.Name));
    
    } 
     
}

  
  public PageReference doSave(){
   if(initialSample.Lab_Name__c == null){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter information in the mandatory fields')); 
          return null;
        }
  
  else {
  if(sampleId!=null){
  initialSample.Trademark_Abuse_Sample__c=sampleId;
  initialSample.Active_for_Brand_found_in_HPLC1__c= BrandAnswer();
  initialSample.Compounds_found_in_FTIR__c= CompoundAnswer();
  insert initialSample;
  }
  if(bl !=null) {
        attach.OwnerId = UserInfo.getUserId();
        attach.ParentId = initialSample.id;
        attach.Name =initialSample.id+'-'+fileName;
        attach.Body = bl;
         try {
           insert attach;    
 } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            
        } 
        }
     PageReference pageRef = new PageReference( '/' +initialsample.id); 
        return PageRef;
     } 
  }
  
public PageReference doCancel(){   
  PageReference pageRef = new PageReference( '/' +sampleId); 
  pageRef.setRedirect(true);
        return PageRef;
 }
  
 
public string BrandAnswer(){

     String message;                                  
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
        
public string CompoundAnswer(){

     String message;                                  
     Boolean first = true;
     message ='';
      for ( SelectOption so : SelectedMaterialsCompound) {
        if (!first) {
             message += ';';
                }
             message += so.getvalue();
             first = false;
            }
             return message ;
        }        
   
   public void SearchActiveForBrandvalue(){
  
    AllMaterials.clear();
    string search='%'+searchActiveForBrand+'%';
    activeForBrand=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives' and Name like :search];
        Integer totalsize = activeForBrand.size();
        Set<String> tSet=new Set<String>();
        if(SelectedMaterials.size()!=0){
         String[] tempSelected=new List<String>();
         for (integer i=0;i<SelectedMaterials.size();i++){ 
             if(SelectedMaterials[i].getvalue().toLowerCase().contains(searchActiveForBrand.toLowerCase())){
                 tempSelected.add(SelectedMaterials[i].getvalue());
                 
            }
         }
         if(tempselected.size()>0){
         tSet.addAll(tempSelected);}
         
      }
       for (integer i=0;i<activeForBrand.size();i++){
         if(!tSet.contains((activeForBrand[i].Name)))
             AllMaterials.add(new SelectOption(activeForBrand[i].Name, activeForBrand[i].Name));
        }
        
           }
        
      public void SearchCompoundValue(){
    
    AllMaterialsCompound.clear();
     string search='%'+searchCompound+'%';
    compound=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives' and Name like :search];
        Integer totalsize = compound.size();
        Set<String> tSet=new Set<String>();
        if(SelectedMaterialsCompound.size()!=0){
        
         String[] tempSelected=new List<String>();
         for (integer i=0;i<SelectedMaterialsCompound.size();i++){ 
             if(SelectedMaterialsCompound[i].getvalue().toLowerCase().contains(searchCompound.toLowerCase())){
                 tempSelected.add(SelectedMaterialsCompound[i].getvalue());
               
            }
         }
         if(tempselected.size()>0){
         tSet.addAll(tempSelected);}
               }
       for (integer i=0;i<compound.size();i++){
         if(!tSet.contains((compound[i].Name)))
             AllMaterialsCompound.add(new SelectOption(compound[i].Name, compound[i].Name));
        }
        
           }
}
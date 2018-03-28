/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for BPDSampleAnalysisEdit 
* Ver   Date        Author               Modification
* 1.1   18-Mar-15   Isha Taneja        Added the fields Similar_to_previous_cases__c, Identical_to_Previous_Cases__c
<IT 20150318>                           on the edit functionality.
 *****************************************************************************/
 
public with sharing class ctrlBPDSampleAnalysisEdit{
  public Trademark_Abuse_Sample_Analysis__c initialSample{get;set;}
  public String sampleId{get;set;}
  public SelectOption[] SelectedMaterials { get; set; }
  public SelectOption[] SelectedMaterialsCompound{get;set;}
  public SelectOption[] AllMaterials { get; set; }
  public SelectOption[] AllMaterialsCompound { get; set; }
  public LIST<Business_Partner__c> activeForbrand{get; set;}
  public LIST<Business_Partner__c> compound{get; set;}
  public string searchActiveForBrand {get;set;}
  public String searchCompound{get;set;}
  public integer size {get;set;}
  public List<Attachment> allAttachments{get;set;}
  public List<Attachment> attachmentIdList{get;set;}
  public Attachment attach = new Attachment();
  public String fileName{get;set;}
  public Blob bl{get;set;} 
  public String imageURL{get; set;}
  public Document doc{get;set;}  
  

public ctrlBPDSampleAnalysisEdit(ApexPages.StandardController controller){
 SelectedMaterials = new List<SelectOption>();
 AllMaterials= new List<SelectOption>();
 SelectedMaterialsCompound= new List<SelectOption>();
 AllMaterialsCompound = new List<SelectOption>();
 attachmentIdList = new List<Attachment>();
 initialSample= new Trademark_Abuse_Sample_Analysis__c();
/*<IT 20150318>*/        

sampleId = System.currentPageReference().getParameters().get('id');
if(sampleId!=null){
initialSample=[Select id,Lab_Type__c,Lab_Name__c,Date_Received__c,Analysis_type__c,Date_Completed__c,
 Appearance__c,A_I__c,Assay__c,Quality_of_Packaging__c,Toxic_Solvents_Detected__c,
 Known_Impurities__c,Quality_of_Formulation__c,Any_Other_Impurities__c,Impurity_Profile__c,
 FTIR_Conclusion_about_Formulation__c,Unkown_Impurities__c,FTIR_Conclusion_about_A_I__c,Similar_to_previous_cases__c,Identical_to_Previous_Cases__c,
 S_U_Contaminants__c,Comments_on_Formulation_Ingredients__c,Overall_Conclusion__c,Summary__c,Active_for_Brand_found_in_HPLC1__c,
 Compounds_found_in_FTIR__c,Trademark_Abuse_Sample__c from Trademark_Abuse_Sample_Analysis__c where id=:sampleId];

imageURL='/servlet/servlet.FileDownload?file=';
 doc=[select name from Document where Name='BPDAttachmentImage'];
         imageURL=imageURL+doc.id;
         
 allAttachments=[SELECT Id,name FROM Attachment where ParentId=:sampleId];
  for(Attachment singleAttachment:allAttachments){
          attachmentIdList.add(singleAttachment);
         }


}
//<KV20160129>
activeForBrand=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives' order by Name];    
    for(Business_Partner__c se:activeForBrand){
    AllMaterials.add(new SelectOption(se.Name, se.Name));
      }
//<KV20160129>
compound=[Select id,Name,Partner_Country__c,Partner_Region__c,Program__c,Status__c,Type__c,Subtype__c from Business_Partner__c where RecordType.Name='CPC Actives'order by Name];    
    for(Business_Partner__c se:compound){
    AllMaterialsCompound.add(new SelectOption(se.Name, se.Name));
     } 
    if(initialSample.Active_for_Brand_found_in_HPLC1__c!=null){
    String[] Active_Sample=initialSample.Active_for_Brand_found_in_HPLC1__c.split('\\;');
    
    if(Active_Sample!=null){
    for(integer j=0 ;j<Active_Sample.size();j++ ){
     SelectedMaterials.add(new SelectOption(Active_Sample[j], Active_Sample[j]+'        ',true));
        }
    }
    }
    
    if(initialSample.Compounds_found_in_FTIR__c!=null){
    String[] Compound_Sample=initialSample.Compounds_found_in_FTIR__c.split('\\;');
    
    if(Compound_Sample!=null){
    for(integer j=0 ;j<Compound_Sample.size();j++ ){
      SelectedMaterialsCompound.add(new SelectOption(Compound_Sample[j], Compound_Sample[j]+'        ',true));
          
    }
    }
    }
}

public pageReference doSave(){
 if(initialSample.Lab_Name__c == null){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter information in the mandatory fields')); 
          return null;
        }
  else {
  initialSample.Active_for_Brand_found_in_HPLC1__c= BrandAnswer();
  initialSample.Compounds_found_in_FTIR__c= CompoundAnswer();
   if(bl !=null) {
        attach.OwnerId = UserInfo.getUserId();
        attach.ParentId = sampleId;
        attach.Name = initialSample.id+'-'+fileName;
        attach.Body = bl;
         try {
           insert attach;    
 } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            
        } 
        }
        
  update initialSample;
   PageReference pageRef = new PageReference( '/' +initialsample.id); 
        return PageRef;
  }
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
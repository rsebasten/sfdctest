/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Rajiv Kumar Bhatter
Email: Rajiv_Bhatter@infosys.com
Description:  Controller for page BPDBrandEdit for editing Brand and SBU values on 
Case Detail record
 *****************************************************************************/
public with sharing class ctrlBPDBrandEdit{

public SelectOption[] SelectedMaterials { get; set; }  
public SelectOption[] AllMaterials { get; set; }
public LIST<BPD_Sample_Settings__c> brand{get; set;}
public LIST<BPD_Sample_Settings__c> sbuList{get; set;}
public string searchBrand {get;set;}
public Boolean noBrand{get;set;}
public Case_Details__c currentCaseDetail {get;set;}
public string counter{get;set;}
public integer size {get;set;}
private String retURL {get;set;}
public SelectOption[] SelectedSBUs { get; set; }
public Set<SelectOption> AllSBUs{ get; set; }
public SelectOption[] finalSBUs{ get; set; }
public List<SelectOption> SBUs{ get; set; }    
public Set<String> selectedSBUList;
      
    public ctrlBPDBrandEdit(ApexPages.StandardController controller){
     selectedSBUList = new Set<String>();
     AllMaterials= new List<SelectOption>();
     finalSBUs = new List<SelectOption>();
     AllSBUs = new Set<SelectOption>();
    SBUs = new List<SelectOption>();
     SelectedMaterials = new List<SelectOption>();
     SelectedSBUs = new List<SelectOption>();

     
     retURL= System.currentPageReference().getParameters().get('id');
     AllSBUs.clear();
     currentCaseDetail  = [SELECT Id,brand__c,Owning_SBU__c from Case_Details__c where Related_Case__c=:retURL limit 1];
     if(!String.isEmpty(currentCaseDetail.Owning_SBU__c)){
     String[] brand_split=currentCaseDetail.brand__c.split('\\;');
     String[] SBU_split=currentCaseDetail.Owning_SBU__c.split('\\;');
         for(integer j=0 ;j<brand_split.size();j++ ){
      SelectedMaterials.add(new SelectOption(brand_split[j], brand_split[j]+'',true));
      }
          for(integer i=0 ;i<SBU_split.size();i++ ){
      SelectedSBUs.add(new SelectOption(SBU_split[i], SBU_split[i]+'',true));
      }
     }
      if(SelectedSBUs.size()>0){
   for ( SelectOption so : SelectedSBUs) {
     selectedSBUList.add(so.getvalue());
    }
    brand=[Select Name from BPD_Sample_Settings__c where Owning_Org__c IN  :selectedSBUList order by Name];
    for(BPD_Sample_Settings__c se:brand){
    AllMaterials.add(new SelectOption(se.Name, se.Name));
    }
    }
    sbuList=[Select Owning_Org__c from BPD_Sample_Settings__c where Owning_Org__c!=null order by Owning_Org__c ];
    sbuList.sort();
     for(BPD_Sample_Settings__c se:sbuList){
     if(selectedSBUList.size()>0){
     if(!selectedSBUList.contains(se.Owning_Org__c))
     AllSBUs.add(new SelectOption(se.Owning_Org__c, se.Owning_Org__c));
    }
    else{
    AllSBUs.add(new SelectOption(se.Owning_Org__c, se.Owning_Org__c));
    SBUs.addAll(AllSBUs);
    SBUs.sort();
    }
    }
    finalSBUs.addAll(AllSBUs);
    SBUs.addAll(AllSBUs);
    SBUs.sort();
 }
    
public void brandselect(){
  AllMaterials.clear();
  selectedSBUList = new Set<String>();
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
      BPD_Sample_Settings__c owningOrg = [Select Owning_Org__c  from BPD_Sample_Settings__c where name  =:SelectedMaterials[i].getValue() order by Owning_Org__c limit 1 ];
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
       
 public Pagereference SaveBrand(){
 String message;
 String message1;  
 Boolean first = true;                                
         message = '';
         message1='';
         for ( SelectOption so : SelectedMaterials) {
          if (!first) {
                message += ';';
                }
             message += so.getvalue();
             first = false;
            }
      Boolean second = true;
            for ( SelectOption so : SelectedSBUs) {
          if (!second) {
                message1 += ';';
                }
             message1 += so.getvalue();
             second = false;
            }
     currentCaseDetail.brand__c=message;
     currentCaseDetail.owning_sbu__c=message1;
     update currentCaseDetail;
 Pagereference back;
  back= new PageReference('/'+retURL);
  return back;
        
 }
  
}
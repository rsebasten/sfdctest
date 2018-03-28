/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for BPDSampleEdit
 *****************************************************************************/

public with sharing class ctrlBPDSampleEdit{
 
public String sampleId{get;set;}
public Trademark_Abuse_Sample__c sample{get;set;}

public ctrlBPDSampleEdit(ApexPages.StandardController stdController){
   sampleId= System.currentPageReference().getParameters().get('id');
   sample=[select id,Batch_Number__c,Identification_Date__c,Sample_Reason__c,Active_Ingredients__c,
   Dealer__c,Value_Chain_Identified__c,Country__c,Internal_Sample_Collector2__c,External_Sample_Collector__c,Sample_Comments__c,
   Label_Name__c,Label_Manufacturer__c,Active_Ingredients_Per_Label__c,Label_Manufacturer_Country__c,Formulation__c,Formulation_Abbr__c,City_Village__c,Address__c,District_province__c,
   Zip_Postal_Code__c,First_Active__c,Second_Active__c,Third_Active__c,Product_Quantity_Collected__c,Product_Collection_Method__c,
   Product_Quantity_Collected_Unit__c,Total_Product_Quantity_Identified__c,Total_Product_Quantity_Identified_Unit__c,
   Total_Product_Price_Actual__c,Total_Product_Price_Currency__c,Total_Product_Price_USD__c,Product_Quality_Aspects__c,
   Package_Type__c,Product_Pack_Size__c,Product_Pack_Size_Unit__c,Price_per_Unit_Actual__c,Price_Per_Unit_Currency__c,
   Price_per_Unit_USD__c,Package_Quality_Aspects__c,Sample_Archived_Date__c,Sample_Dispatched_Date__c,Case__c
   from Trademark_Abuse_Sample__c where id=:sampleId];
  
 }
 
 public PageReference doSave(){
     update sample;
    PageReference pageRef = new PageReference( '/' +sample.id); 
        return PageRef;
  }
  
  }
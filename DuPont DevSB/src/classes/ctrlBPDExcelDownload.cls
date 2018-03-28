/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for BPDExcelDownload
** ============================================================================= 
* Ver     Date        Author               Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.1   18-Mar-15   Isha Taneja         Added the field Sample_Name__c to the query 
<IT 20150318>                           as this field is mapped to the Order number.
 *****************************************************************************/

public with sharing class ctrlBPDExcelDownload {

    
    public Case cas{get;set;}
    public Case_Details__c caseDetails{get;set;}
    Public Trademark_Abuse_Sample__c caseSamples {get;set;}
    public Trademark_Abuse_Sample_Analysis__c sampleAnalysis{get;set;}
    public User user{get;set;}
    public String sampleId{get;set;}
    public Business_Partner__c bp{get;set;}
    public String labName{get;set;}
    public String form{get;set;}
 
public ctrlBPDExcelDownload(ApexPages.StandardController controller) {
  
     sampleId=System.currentPageReference().getParameters().get('id');
      
     if(sampleId != NULL){
     sampleAnalysis = [select Id,Lab_Name__c,Analysis_type__c,Trademark_Abuse_Sample__c from Trademark_Abuse_Sample_Analysis__c where id=:sampleId];
    
  // bp = [Select id,name from Business_Partner__c where RecordType.Name='CPC Sample Analysis Laboratories' and id=:sampleAnalysis.Lab_Name__c]; -- KK record type deactivated
     bp = [Select id,name from Business_Partner__c where id=:sampleAnalysis.Lab_Name__c];

     labName = bp.name;
/*<IT 20150318>*/        
     caseSamples = [Select Id,Sample_Name__c,Sample_Reason__c,External_Sample_Collector__c,Product_Quantity_Collected_Unit__c,
     Product_Quantity_Collected__c,Formulation_Abbr__c,Formulation__c,Label_Name__c,
     Internal_Sample_Collector2__c,Case__c,Product_Collection_Method__c
     From Trademark_Abuse_Sample__c where id=:sampleAnalysis.Trademark_Abuse_Sample__c];
     
     form=caseSamples.Formulation__c +'% '+caseSamples.Formulation_Abbr__c;
     
     if(caseSamples.Internal_Sample_Collector2__c!=null)
     user=[select Name,Phone,Email from User where id=:caseSamples.Internal_Sample_Collector2__c];
    
     cas = [select id,CreatedDate,CaseNumber from Case where id=:caseSamples.Case__c];
        
     caseDetails = [Select id,Individual_Name__c,Phone__c,Company__c,
     Address__c,Zip_Postal_Code__c,City__c,Target_Country__c from Case_Details__c where Related_Case__c=:cas.id limit 1];
    
       }
   }
  
}
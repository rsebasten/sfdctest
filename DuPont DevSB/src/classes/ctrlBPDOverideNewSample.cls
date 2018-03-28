/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for BPDOverideNewSample
Modifications:  <TJ20151124> Added Case ID and Case Number to the URL in case of 
                creating the record through Case Detail Related List
 *****************************************************************************/

public with sharing class ctrlBPDOverideNewSample{

    public static Final string brandSample=RType.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
    public static Final string cropSample=RType.getIdByDevName('Trademark_Abuse_Sample__c','Crop_Sample');
    public static Trademark_Abuse_Sample__c sampleRecord;
    public String caseId{get;set;}
    public string retURL ;
    public string selectedRecordType ;
       
    
 public ctrlBPDOverideNewSample(ApexPages.StandardController controller) {

    sampleRecord=(Trademark_Abuse_Sample__c)controller.getRecord();
     system.debug('--->'+sampleRecord.getSobjectType().getDescribe());
    retURL = ApexPages.currentPage().getParameters().get('retURL');
     system.debug('parameters---------->'+ ApexPages.currentPage().getParameters());
     String trademarkid = ApexPages.currentPage().getParameters().get('id');
     system.debug('=====>>'+ trademarkid);
   //  Trademark_Abuse_Sample__c tm = [select id, name,Case__c from Trademark_Abuse_Sample__c where id=:trademarkid];
     
     //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
     Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('Sample/Trap Purchase_Case');     
     
     //<TJ20151124> Added Case ID and Case Number to the URL in case of creating the record through Case Detail Related List     
     if(ApexPages.currentPage().getParameters().get(objectFieldID.Field_ID__c+'_lkid')==null && sampleRecord.Trademark_Abuse_Case_Details__c!=null){
         Case_Details__c cd=[SELECT Related_Case__r.id,Related_Case__r.CaseNumber from Case_Details__c where id=:sampleRecord.Trademark_Abuse_Case_Details__c];         
         ApexPages.currentPage().getParameters().put(objectFieldID.Field_ID__c+'_lkid',cd.Related_Case__r.id);         
         ApexPages.currentPage().getParameters().put(objectFieldID.Field_ID__c,cd.Related_Case__r.CaseNumber);        
     }
     //<TJ20151124> END
     caseId= ApexPages.currentPage().getParameters().get(objectFieldID.Field_ID__c+'_lkid');     
        if(controller.getRecord().get('RecordTypeId')  == null){      
        for(RecordTypeInfo r: controller.getRecord().getSobjectType().getDescribe().getRecordTypeInfos()){
           if(r.isAvailable()){
           selectedRecordType  = String.valueof(r.getRecordtypeId());
           break;
           }
        } 
    }
    else{
      selectedRecordType  = String.valueof(controller.getRecord().get('RecordTypeId'));  
    }
       
    
   }
    
public PageReference redirectToPage() {
   PageReference returnURL;   
   if(selectedRecordType == brandSample){
     returnURL=defaultFields.onOverrideNew(sampleRecord);       
        }         
     else if(selectedRecordType == cropSample){ 
         returnURL = new PageReference('/apex/BPDSampleSave?rtype='+selectedRecordType+'&caseid='+caseId);
                    }
    return returnURL;
      
}
   
public PageReference cancel(){
    PageReference returnURL = new PageReference(retURL);
    return returnURL ;
}

public PageReference retPage(){
        
        Schema.DescribeSObjectResult result =Trademark_Abuse_Sample__c.SObjectType.getDescribe();
        PageReference returnPr;
         returnPR = new PageReference('/setup/ui/recordtypeselect.jsp');
         return returnPR;
                
    }
}
/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for page BPDSampleDocAttach to attach the documents to the sample
 *****************************************************************************/
 
public with sharing class ctrlBPDSampleDocAttach{
public Trademark_Abuse_Sample__c sample{get;set;}
public String sampleId{get;set;}

public Attachment S = new Attachment();
public Attachment PA = new Attachment();
public Attachment TA = new Attachment();

public String fileName{get;set;}
public String PAFileName{get;set;}
public String TAFileName{get;set;}

public Blob bl{get;set;}
public Blob PAbl{get;set;}
public Blob TAbl{get;set;}

public List<Attachment> allAttachments{get;set;}
public List<Attachment> attachmentIdList{get;set;}
public List<Attachment> PAIdList{get;set;}
public List<Attachment> TAIdList{get;set;}
public String imageURL{get; set;}
public Document doc{get;set;}  
public Boolean flagvar{get;set;}

public ctrlBPDSampleDocAttach(ApexPages.StandardController stdController){
flagvar = false;

attachmentIdList = new List<Attachment>();
PAIdList = new List<Attachment>();
TAIdList = new List<Attachment>();

imageURL='/servlet/servlet.FileDownload?file=';
 doc=[select name from Document where Name='BPDAttachmentImage'];
         imageURL=imageURL+doc.id;

sampleId = System.currentPageReference().getParameters().get('id');

if(sampleId != NULL){
         sample = [SELECT ID,Sample_Comments__c,Sample_Conclusion__c,Sample_Technical_Analysis__c,Sample_Packaging_Analysis__c  FROM Trademark_Abuse_Sample__c WHERE id=:sampleId];
         allAttachments=[SELECT Id,name FROM Attachment where ParentId=:sampleId];
         for(Attachment singleAttachment:allAttachments){
         if(singleAttachment.name.startsWith('S-')){
         attachmentIdList.add(singleAttachment);
         }
         else if(singleAttachment.name.startsWith('PA-')){
         PAIdList.add(singleAttachment);
         }
         else if(singleAttachment.name.startsWith('TA-')){
         TAIdList.add(singleAttachment);
         }
         
         }
      }
      
}      
public PageReference savingCase(){
 
 if(bl !=null) {
        S.OwnerId = UserInfo.getUserId();
        S.ParentId = sample.Id;
        S.Name = 'S-'+fileName;
        S.Body = bl;
        try {
           insert S;    
 } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            
        } 
        }
      
      if(PAbl !=null) {
        PA.OwnerId = UserInfo.getUserId();
        PA.ParentId = sample.Id;
        PA.Name = 'PA-'+PAFileName;
        PA.Body = PAbl;
        try {
           insert PA;    
 } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            
        } 
        }
  
        if(TAbl !=null) {
        TA.OwnerId = UserInfo.getUserId();
        TA.ParentId = sample.Id;
        TA.Name = 'TA-'+TAFileName;
        TA.Body = TAbl;
        try {
           insert TA;    
 } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            
        } 
        }
        
update sample;
flagvar = true;
return null;     
      }
      }
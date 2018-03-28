/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Kavya Kunam
Email: kavya_kunam@infosys.com
Description:  Controller for BPDSampleSave
 *****************************************************************************/

public with sharing class ctrlBPDSampleSave{
public String recordType {get;set;}
public String casId{get;set;}
public Trademark_Abuse_Sample__c sample{get;set;}

public ctrlBPDSampleSave(ApexPages.StandardController stdController){
 sample= new Trademark_Abuse_Sample__c();
  recordType = System.currentPageReference().getParameters().get('rtype');
 casId= System.currentPageReference().getParameters().get('caseId');
 sample.RecordTypeId = recordType;
 }
 
 public PageReference doSave(){
  
  sample.Case__c=casId;
  // KK Updated to since Rtype is deactivated
  sample.RecordTypeId=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
  insert sample;
  
  PageReference pageRef = new PageReference( '/' +sample.id); 
        return PageRef;
  }
  
  public PageReference doCancel(){  
  PageReference pageRef = new PageReference( '/' +casId); 
  pageRef.setRedirect(true);
        return PageRef;
 }
 }
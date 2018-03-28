/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder,Vinayak Vijayakumar
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com, Vinayak.Vijayakumar@usa.dupont.com
Description:  Trigger Handler for SiteContent__c
*******************************************************************************/
public with sharing class SiteContentHandler extends TriggerHandlerBase {
  
  public static MAP<id,Site_Content__c> oldSC {GET { return (MAP<id,Site_Content__c>) Trigger.oldMap; } }
  public static MAP<id,Site_Content__c> newSC {GET { return (MAP<id,Site_Content__c>) Trigger.newMap; } }

  MAP<string,LIST<Site_Content__c>> activeSiteContent;


  public override void bulkBefore() {
    if (Trigger.isUpdate || Trigger.isInsert) {
      activeSiteContent=getActiveSiteContent();
    }
  }
  
  public override void andFinally() {
    if (Trigger.isInsert || Trigger.isUpdate) {
        activeSiteContent=getActiveSiteContent();
        validateDMX();
        validateSEO();
    }
  }
    
    private void validateDMX(){
        fetchNews('News','DMX online',6);
        validateSequenceNumbers('DMX_SMP_Overview','DMX online',1, label.DMX_SMP_Active_Record);
        validateSequenceNumbers('DMX_SMP_Stages','DMX online',5, label.DMX_Stage_Seq_Number);
        validateSequenceNumbers('DMX_SMP_Steps','DMX online',5, label.DMX_Step_Seq_Number);
    }
    
    /* Method used to drive all the validations for SEO */
    private void validateSEO(){
        fetchNews('News','Sales Excellence',6);
        validateSequenceNumbers('SEO_SSP_Overview','Sales Excellence',3,label.DMX_Stage_Seq_Number,'About Sales Excellence');
        validateSequenceNumbers('SEO_SSP_Overview','Sales Excellence',5, label.DMX_Stage_Seq_Number,'SSP Overview');
        validateSequenceNumbers('COE_Detail','Sales Excellence',3,label.DMX_Stage_Seq_Number,'COE Detail');
        validateSequenceNumbers('COE_Detail','Sales Excellence',1, label.SEO_Competency_Assessment_Error,'Innovator Success');
        validateSequenceNumbers('Course','Sales Excellence',1,label.SEO_Course_Summary_Error,null);  
    }

  ////////////////////////////////////////////////////////////////////////////////////
  // Refactored News  (INSERT && UPDATE)
  ////////////////////////////////////////////////////////////////////////////////////   
  /* Generic Method to Validate the conditions for News Record Type */
  private void validateNews(List<Site_Content__c> checkList,List<Site_Content__c> activeList,integer max) {
    
     for (Site_Content__c sc : checkList) { // News Record Type
            if(sc.Application__c=='DMX online')
                validateImage(sc,label.DMX_imageid_and_image);  
      //validate Row Number
            for(Site_Content__c s:activeList) { 
                //if  (s.id<>sc.id && s.Row_Number__c == sc.Row_Number__c && s.Column_Number__c==sc.Column_Number__c && sc.status__c=='Active')
                if  (s.id<>sc.id && s.Row_Number__c == sc.Row_Number__c && sc.status__c=='Active')            
                    sc.addError(label.DMX_row_column_combination+s.Name);                                                                                            
            }   
                     
           if (Trigger.isInsert) {      
            //validate Actives        
                if (activeList.size()>max && sc.Status__c=='Active')                                                                                                                                                                                      
                    sc.addError(label.DMX_News_5_Active_Records);                                                                   
            } 
            
         if (Trigger.isUpdate) {      
            //validate Actives        
            if (activeList.size()> max && oldSC.get(sc.id).status__c<>newSC.get(sc.id).status__c && sc.status__c=='Active')                                                                                                                                                                                           
                sc.addError(label.DMX_News_5_Active_Records);                                                                   
        }            
    }   //next so
  } // News     
     /* Get the working set based on Application */      
    private static LIST<Site_Content__c> filterByApp(List<Site_Content__c> activeList,String app) {
        LIST<Site_Content__c> appList = new LIST<Site_Content__c>();
        for (Site_Content__c sc : activeList) {  //will need to add Sales Ex to application list
            if (sc.Application__c==app)
                appList.add(sc);
        }
        return appList;
    }
   /* Get the working set based on Application and Type Options*/     
   private static LIST<Site_Content__c> filterByType(List<Site_Content__c> activeList,String appType) {
        LIST<Site_Content__c> appTypeList = new LIST<Site_Content__c>();
        for (Site_Content__c sc : activeList) {  //will need to add Sales Ex to application list
            if(sc.type__c==appType)
                    appTypeList.add(sc);
        }
        return appTypeList;
    }

    private void fetchNews(string rtype,String app,integer max) {
        LIST<Site_Content__c> checkList     = (LIST<Site_Content__c>) this.getRecordsByRT(rtype).values();
        LIST<Site_Content__c> activeList    = activeSiteContent.containsKey(rtype) ? activeSiteContent.get(rtype) : new LIST<Site_Content__c>();            
        if (app!=null) {
            checkList=filterByApp(checkList,app);
            activeList=filterByApp(activeList,app);
            }       
        if (checkList.size()>0 && activeList.size() >0)
            validateNews(checkList,activeList,max);
  }
    
    private void validateSequenceNumbers(string rtype,String app, integer max, string msg){
        validateSequenceNumbers(rtype,app,max,msg,null);
    }
    private void validateSequenceNumbers(string rtype,String app, integer max, string msg,String appType) {
        LIST<Site_Content__c> checkList     = (LIST<Site_Content__c>) this.getRecordsByRT(rtype).values();
        LIST<Site_Content__c> activeList    = activeSiteContent.containsKey(rtype) ? activeSiteContent.get(rtype) : new LIST<Site_Content__c>();            
        System.debug('enter validate');
        if (app!=null) {
            checkList=filterByApp(checkList,app);
            activeList=filterByApp(activeList,app);
            System.debug('enter validate1'+checkList);
            System.debug('enter validate2'+activeList);
            }
        if (appType!=null) {
            checkList=filterByType(checkList,appType);
            activeList=filterByType(activeList,appType);
            System.debug('enter validate3'+checkList);
            System.debug('enter validate4'+activeList);
            }       
        if (checkList.size()>0 && activeList.size() >0)
            validateActiveSequenceNumbers(checkList,activeList,max,msg);
  }
    

  
  ////////////////////////////////////////////////////////////////////////////////////
  // static helper methods
  ////////////////////////////////////////////////////////////////////////////////////   
  
  
  /* Helper method to fetch all the Active Site Content Records*/
  private static MAP<string,LIST<Site_Content__c>> getActiveSiteContent() {
      MAP<string,LIST<Site_Content__c>> rtn = new MAP<string,LIST<Site_Content__c>>();
      for (Site_Content__c sc : [
          //SELECT id,Row_Number__c,type__c,Application__C,imageid__c, image__C,Column_Number__c,Name,RecordType.developerName,seq_number__c,parent__c
          SELECT id,Row_Number__c,type__c,Application__C,imageid__c,Name,RecordType.developerName,parent__c  
          FROM Site_Content__c WHERE status__c ='Active']) {  //will need to add Sales Ex to application list
        if (!rtn.containsKey(sc.RecordType.developerName))
          rtn.put(sc.RecordType.developerName,new LIST<Site_Content__c>());
        rtn.get(sc.RecordType.developerName).add(sc);
      }
     return rtn;
    }
    
    /* Validating the image and ImageId for DMX Application */
  ////////////////////////////////////////////////////////////////////////////////////      
   private static void validateImage(Site_Content__c sc, string msg) {
          String str = null;
           /*if ( sc.image__c != null)                  
               str = sc.image__c;*/
           if (str == null)
               str = '';
          if(sc.ImageId__c  != null  &&  str.length() > 5)  
                sc.addError(msg);
  }  
////////////////////////////////////////////////////////////////////////////////////      
     
  //Method used to Validate the sequence numbers, exceeded active number of records for different types of record types
  private static void validateActiveSequenceNumbers(LIST<Site_Content__c> newRecords, LIST<Site_Content__c> activeRecords, integer max, string msg) {   
    //KRISH commented to remove reference to Seq_Number__c
    /*for (Site_Content__c sc : newRecords) {  
        if(sc.status__c == 'Active') {
                System.debug('sc sequence number '+sc.seq_number__c);
            if(sc.seq_number__c<=0 || sc.seq_number__c>max)
                    sc.addError(label.DMX_Seq_Number);
            else {
                //check for dups
                if (activeRecords!=null && activeRecords.size()>0) {
                    for (site_content__c a1 :  activeRecords) {
                        if (sc.Status__c=='Active' && sc.parent__c==a1.parent__c && sc.seq_number__c==a1.seq_number__c && (sc.id!=null && sc.id!=a1.id) )
                            sc.addError(msg+sc.seq_number__c);
                    } 
                } 
            }
        } 
    } */
 }   
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlOverideNewCase
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in OverideCaseNew VF Page
//This class allows user to create a New Case record
//************************************<MG-20140827>***************************************************//
public with sharing class ctrlOverideNewCase{

    public static Final string BICASE=RType.getIdByDevName('Case','BI_Case');
    public static Final string BINAClaimAdmin_Envlop=RType.getIdByDevName('Case','BI_NA_Envelopes_Case');
    public static Final string BINAClaimAdmin_Surface=Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
    public static Final string PRODUCTANDLABOUT_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    public static Final string PRODUCTONLY_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
    public static Final string PRODUCTFLUIDAPPLIED_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
    public static Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
    public static Final string EMEAEntitlement=Rtype.getIdByDevName('Entitlement','BI_EMEA_Entitlement');
    public static Final string BrandProtectionLegalCase=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
    public static case caserecord;
    public string retURL ;
    public string selectedRecordType ;
    public string ent ;
    public Boolean backBut {get;set;}
    public Boolean cancelBut {get;set;}
    private Entitlement entit;
    private string currentEntitlementId;
    
 public ctrlOverideNewCase(ApexPages.StandardController controller) {
    caserecord=(Case)controller.getRecord();
    currentEntitlementId=ApexPages.currentPage().getParameters().get('def_entitlement_id');
    retURL = ApexPages.currentPage().getParameters().get('retURL');
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
    ent = ApexPages.currentPage().getParameters().get('ent');
    
    
   }
//////////////////////////////////////////
    /* Function Description
    Name :redirectToPage
    Return Type: PageReference  
    Description:This function is written to check if the user selects the correct Record Type
    */    
public PageReference redirectToPage() {
   PageReference returnURL;
   integer counter=0;   
   try{
   
   if (selectedRecordType == BINAClaimAdmin_Envlop ) {    
       if(currentEntitlementId!=null)
       {
           entit= [SELECT id,recordTypeId,status FROM Entitlement WHERE Id=:ApexPages.currentPage().getParameters().get('def_entitlement_id')]; 
           if(entit.status=='Active'){     
               if (entit.recordTypeId == PRODUCTANDLABOUT_COB_RTYPE ||(entit.recordTypeId ==PRODUCTFLUIDAPPLIED_COB_RTYPE)||(entit.recordTypeId ==PRODUCTONLY_COB_RTYPE) ) {  
               returnURL = new PageReference('/apex/BI_NA_EnvelopesClaim'); 
               counter=1;
               }
               else{
               backBut =true;
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select RecordType for Surface'));
               return null;
                  }
              }  
          else{
               cancelBut=true;
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Entitlement is Inactive, so cannot create a case on it!!'));
               return null;
          } 
        }
        else{
            cancelBut=false;
            backBut =false;
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create case from Entitlement!!'));
            return null;
        }
    }
  else if(selectedRecordType ==BINAClaimAdmin_Surface){ 
        if(currentEntitlementId!=null)
           {
           entit= [SELECT id,recordTypeId,status FROM Entitlement WHERE Id=:ApexPages.currentPage().getParameters().get('def_entitlement_id')]; 
           if(entit.status=='Active'){
               if(entit.recordTypeId ==SurfaceEntitlement.substring(0,15)){
                   returnURL = new PageReference('/apex/BI_NA_SurfacesClaim'); 
                   counter=1;      }  
           
         else{
            backBut =true;
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select RecordType for Envelopes'));
            return null; 
            }
         }
         else{
               cancelBut=true;
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Entitlement is Inactive, so cannot create a case on it!!'));
               return null;
              } 
         }
         else{
             cancelBut=false;
             backBut =false;
             apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create case from Entitlement!!'));
             return null;
             }
        }
    else if(selectedRecordType == BICASE && currentEntitlementId!=null){
            entit= [SELECT id,recordTypeId,status FROM Entitlement WHERE Id=:ApexPages.currentPage().getParameters().get('def_entitlement_id')];
            if((entit.recordTypeId == SurfaceEntitlement)|| (entit.recordTypeId == PRODUCTANDLABOUT_COB_RTYPE) ||(entit.recordTypeId ==PRODUCTFLUIDAPPLIED_COB_RTYPE)||(entit.recordTypeId ==PRODUCTONLY_COB_RTYPE)){
             if(entit.status=='Active'){     
               if (entit.recordTypeId == PRODUCTANDLABOUT_COB_RTYPE ||(entit.recordTypeId ==PRODUCTFLUIDAPPLIED_COB_RTYPE)||(entit.recordTypeId ==PRODUCTONLY_COB_RTYPE) ) {  
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select RecordType for Envelopes'));
               backBut =true;
               return null;
               }
             else {
               backBut =true;
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select RecordType for Surface'));
               return null;
                  }
               
               }
                
          else{
               cancelBut=true;
               apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Entitlement is Inactive, so cannot create a case on it!!'));
               return null;
              } 
            }
            else{
            returnURL=defaultFields.onOverrideNew(caserecord);       
            counter=0;
            }
           }
         
                     
            
            else if(selectedRecordType == BrandProtectionLegalCase){ 
                   returnURL = new PageReference('/apex/BPDCase?rtype='+selectedRecordType); 
           }
         
         
         
         
    else{       
       returnURL=defaultFields.onOverrideNew(caserecord);       
       counter=0;
            }
         
    system.debug('the counter is'+ counter);
    if(counter==1){
    returnURL.getParameters().put('retURL', retURL);
    returnURL.getParameters().put('RecordType', selectedRecordType );
    returnURL.getParameters().put('ent', ent);
    returnURL.getParameters().put('def_entitlement_id', currentEntitlementId);
    returnURL.getParameters().put('nooverride', '1');
    returnURL.setRedirect(true);
    }
     return returnURL;
    }
    Catch(Exception Ex){
    return null;
    }
    
}
  //////////////////////////////////////////////
   /* Function Description
    Name :Cancel
    Return Type: PageReference
    Description: This is a custom cancel button method where the user lands to the detail page of the Entitlement 
    */  
public PageReference cancel(){
    PageReference returnURL = new PageReference(retURL);
    return returnURL ;
}
//////////////////////////////////////////
    /* Function Description
    Name :retPage
    Return Type: PageReference 
    Description:This function is written to redirect the user to the Record Type
    selection page.
    */ 
public PageReference retPage(){
        try{
        Schema.DescribeSObjectResult result =Case.SObjectType.getDescribe();
        PageReference returnPr;
        PageReference returnPage = new PageReference('/'+result.getKeyPrefix()+'/o');
        PageReference save_new_page = new PageReference('/'+result.getKeyPrefix()+'/e');
        save_new_page.getParameters().put('retURL', '/'+result.getKeyPrefix()+'/o');  
        returnPR = new PageReference('/setup/ui/recordtypeselect.jsp');
        String objId=   ApexPages.currentPage().getParameters().get('def_account_id');
        String objEnt=   ApexPages.currentPage().getParameters().get('def_entitlement_id');
        returnPR.getParameters().put('ent', 'Case');
        returnPR.getParameters().put('def_account_id', objId);
        returnPR.getParameters().put('def_entitlement_id', objEnt);
        returnPR.getParameters().put('save_new_url', save_new_page.getURL());
        returnPR.getParameters().put('retURL', returnPage.getURL());  
        return returnPR;
        }
        catch(Exception Ex){
        return Null;
        }
    }
}
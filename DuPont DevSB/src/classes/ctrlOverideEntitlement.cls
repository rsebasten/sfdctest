/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlOverideEntitlement
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is getting used in OverideEntitlementNew VF Page
//This class allows user to create a New Case record
//<SK20170412> Modified the controller to add two new record types 
//************************************<MG-20140827>***************************************************//
public class ctrlOverideEntitlement{

    public static Final string BITYVEK_RTYPE = Rtype.getIdByDevName('Account','BI_Tyvek');
    public static Final string BISURFACE_RTYPE= Rtype.getIdByDevName('Account','BI_Surfaces');
    public static Final string PRODUCTANDLABOUT_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    public static Final string PRODUCTONLY_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
   // <SK20170412>--Start
    public static Final string PRODUCTFLUIDAPPLIED_WB_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied_WB');
    public static Final string PRODUCTFLUIDAPPLIED_WB_EIFS_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS');
    //<SK20170412>--End
    public static Final string PRODUCTFLUIDAPPLIED_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
    public static Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
    public static Final string BIEMEAEntitlement=Rtype.getIdByDevName('Entitlement','BI_EMEA_Entitlement');
    public static Entitlement em;
    public string CurrentAccountid;
    public string retURL ;
    public string ent ;
    public string ContactID ;
    public string selectedRecordType ;
    public Boolean errorDisplay {get;set;}
        
    
public ctrlOverideEntitlement(ApexPages.StandardController controller) {
    em=(Entitlement)controller.getRecord();
    CurrentAccountid=ApexPages.currentPage().getParameters().get('def_account_id');
    retURL = ApexPages.currentPage().getParameters().get('retURL');
 
     if(controller.getRecord().get('RecordTypeId')  == null){      
        for(RecordTypeInfo r: controller.getRecord().getSobjectType().getDescribe().getRecordTypeInfos()){
           if(r.isAvailable()){
           selectedRecordType  = String.valueof(r.getRecordtypeId()).substring(0,15);
           system.debug('Selected ecord Type'+selectedRecordType);
           break;
           }
        } 
    }
    else{
      selectedRecordType  = String.valueof(controller.getRecord().get('RecordTypeId')).substring(0,15);  
    }
    
    ent = ApexPages.currentPage().getParameters().get('ent');
    //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
    Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('Entitlement_Primary_Contact');     
        if(objectFieldID != null){
            contactID=ApexPages.currentPage().getParameters().get(objectFieldID.Field_ID__c+'_lkid'); 
        }
    }
    
    
  //////////////////////////////////////////
    /* Function Description
    Name :redirect
    Return Type: PageReference 
    Description:This function is written to check if the user selects the correct Record Type
    for the corresponding Account
    */    
public PageReference redirect() {

     PageReference returnURL;
     integer counter=0;
  
     try{     
    
         if (selectedRecordType == PRODUCTANDLABOUT_COB_RTYPE.substring(0,15)||(selectedRecordType == PRODUCTFLUIDAPPLIED_WB_EIFS_COB_RTYPE.substring(0,15))||(selectedRecordType == PRODUCTFLUIDAPPLIED_WB_COB_RTYPE.substring(0,15))||(selectedRecordType ==PRODUCTFLUIDAPPLIED_COB_RTYPE.substring(0,15))||(selectedRecordType ==PRODUCTONLY_COB_RTYPE.substring(0,15))) {  
          if((ApexPages.currentPage().getParameters().get('def_account_id'))!=null){   
                Account acc= [SELECT id,recordTypeId FROM Account where id =:CurrentAccountid ];
                
              //Added the condition for newly added record types<SK20170412>--Start 
            if((acc.recordTypeId==BITYVEK_RTYPE.substring(0,15))&&((selectedRecordType== PRODUCTFLUIDAPPLIED_WB_COB_RTYPE.substring(0,15))||(SelectedRecordType== PRODUCTFLUIDAPPLIED_WB_EIFS_COB_RTYPE.substring(0,15)))){
                returnURL = new PageReference('/apex/BINA_EnvelopesRegistration_WB');
                counter=1;
                 }
              
              else if(acc.recordTypeId==BITYVEK_RTYPE.substring(0,15)){
                returnURL = new PageReference('/apex/BI_NA_EnvelopesRegistration'); 
                counter=1;
                  }
              //<SK20170412>--End
                else{
                errorDisplay=true;
                apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the appropriate RecordType for Surfaces'));
                return null;
                }
           }
           else{
            errorDisplay =false;
            if(contactID != null){
            errorDisplay=true;
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the appropriate RecordType for Surfaces')); 
            return null;
            }
            else{
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create Entitlement from Account'));   
            return null;
            }
            } 
           }    
         else if(selectedRecordType==SurfaceEntitlement.substring(0,15)){
             Account acc;
             Contact con;
             if(CurrentAccountid!=null || contactID!=null){ 
                if(CurrentAccountid != NULL){
                  acc= [SELECT id,recordTypeId FROM Account where id =:CurrentAccountid ];
                   }
                else{
                  con= [SELECT id,accountID FROM contact where id =:contactID];
                  acc= [SELECT id,recordTypeId FROM Account where id =:con.AccountID];
                  currentAccountID=acc.id;
                }
                if(acc.recordTypeId==BISURFACE_RTYPE.substring(0,15)){
                   
                    returnURL = new PageReference('/apex/BI_NA_SurfacesRegistration'); 
                    counter=1;
                 }
                 else{
                      errorDisplay=true;
                      apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the appropriate RecordType for Envelopes'));
                      return null;
                  }
            }
            else{  
                    errorDisplay =false;
                   apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create Entitlement from Account or Related Contact'));   
                   return null;
            } 
        }
     else{       
         returnURL=defaultFields.onOverrideNew(em);      
         counter=0;      
         }
         
     if(counter==1){
         returnURL.getParameters().put('RecordType', selectedRecordType);
         returnURL.getParameters().put('ent', ent);
         returnURL.getParameters().put('def_account_id', CurrentAccountid);
         if(contactID!=null){ 
         returnURL.getParameters().put('def_contact_id', contactID);
         }
         returnURL.getParameters().put('retURL', retURL );
         returnURL.getParameters().put('nooverride', '1');
         returnURL.setRedirect(true);
         return returnURL;
     }
     else
         return returnURL;
    }
    catch(Exception e){
    return null;
    }
}    
//////////////////////////////////////////
    /* Function Description
    Name :redirect
    Return Type: PageReference 
    Description:This function is written to redirect the user to the Record Type
    selection page.
    */ 
public PageReference retPage(){
        try{
        Schema.DescribeSObjectResult result =Entitlement.SObjectType.getDescribe();
        PageReference returnPR;
        PageReference returnPage = new PageReference('/'+result.getKeyPrefix()+'/o');
        PageReference save_new_page = new PageReference('/'+result.getKeyPrefix()+'/e');
        save_new_page.getParameters().put('retURL', '/'+result.getKeyPrefix()+'/o');  
        returnPR = new PageReference('/setup/ui/recordtypeselect.jsp');
        String objId=   ApexPages.currentPage().getParameters().get('def_account_id');
        returnPR.getParameters().put('ent', 'Entitlement');
        returnPR.getParameters().put('def_account_id', objId);
        if(contactID !=null){ 
         returnPR.getParameters().put('CF00N30000008RYbR_lkid', contactID);
         }
        returnPR.getParameters().put('save_new_url', save_new_page.getURL());
        returnPR.getParameters().put('retURL', returnPage.getURL());  
        return returnPR;
        }
        catch(Exception ex){
         return null;
        }
    }

}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlOverideEntitlementEdit
//Description: This class is used for creating entitlements.
//<JS-20150521>- Changes made for allowing only Warranty Admins to modify the completed Entitlements.
//<SK20170612> Added two new Record Types(BI_NA_Env_Product_Only_Fluid_Applied_WB, BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS )
/************************************<JS-20150521>***************************************************/

public with sharing class ctrlOverideEntitlementEdit {

public static Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
private static string PRODUCTlABOUR_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
private static string PRODUCTFLUID_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
private static string PRODUCT_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
    //<SK20170612>--Start
private static String PRODUCT_ONLY_FLUID_WB_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied_WB');
private static String PRODUCTlABOUR_WB_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS');
//<SK20170612>--End
private string CurrentEntitlementID;
private string retURL ;
public static Entitlement em;

/*<JS-20150521>: Only Warranty Admins can modify the completed Entitlements*/  
List<Group> PGList=[select id,name from group where name='BI-NA Envelopes Warranty Admins' limit 1];
public ID grpId=PGList[0].id;
public Id currentUsrId=UserInfo.getUserId();
List<GroupMember> groupMembers = [Select UserOrGroupId From GroupMember Where GroupId=:grpId];
Set<Id> userOrGroupIds = new Set<Id>();



public ctrlOverideEntitlementEdit(ApexPages.StandardController controller) {

      CurrentEntitlementID=ApexPages.currentPage().getParameters().get('id');
      
      em=(Entitlement)controller.getRecord();
   
    }
    
public PageReference redirect() {

    try{
      PageReference returnURL;
      
      for (GroupMember member : groupMembers) {
    userOrGroupIds.add(member.UserOrGroupId);
}
      
      Entitlement ent= ([select id, recordtypeid,Stage__c from Entitlement where id =:currentEntitlementID]);
      
      if(SurfaceEntitlement.substring(0,15) == ent.recordtypeid){ 
      retURL = ApexPages.currentPage().getParameters().get('retURL');
      returnURL = new PageReference('/apex/BI_NA_SurfacesRegistration'); 
      returnURL.getParameters().put('id', CurrentEntitlementID);
      returnURL.getParameters().put('retURL', retURL );
      returnURL.getParameters().put('nooverride', '1');
      returnURL.setRedirect(true);
      
      }
        //<SK20170612> Added two new record types
      else if (ent.recordtypeid == PRODUCTlABOUR_REG_RTYPE.substring(0,15)||(ent.recordtypeid==PRODUCTFLUID_REG_RTYPE.substring(0,15))||(ent.recordtypeid==PRODUCT_ONLY_FLUID_WB_REG_RTYPE.substring(0,15))||(ent.recordtypeid==PRODUCTlABOUR_WB_REG_RTYPE.substring(0,15))||(ent.recordtypeid==PRODUCT_RTYPE.substring(0,15))) {
/*<JS-20150521>: Only Warranty Admins can modify the completed Entitlements*/          
      if((userOrGroupIds.contains(currentUsrId) && ent.Stage__c=='Registration Complete') || ent.Stage__c=='Registration In-Progress' || ent.Stage__c=='Registration In Progress'){
      
      returnURL = new PageReference('/apex/BI_NA_EnvelopesRegClone'); 
      returnURL.getParameters().put('id', CurrentEntitlementID);
      returnURL.getParameters().put('mode', 'Edit');
      returnURL.getParameters().put('nooverride', '1');
      returnURL.setRedirect(true);
      }
      else{
      returnURL=new pageReference('/apex/Unauthorized');
      }
      }
      else {
      returnURL=defaultFields.onOverrideNew(em);     
      }
     return returnURL;
    }
    catch(Exception e)
    {
     return null;
    }
    }
}
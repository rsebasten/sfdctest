/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Trigger handler for CP Contact
Event:          After Update : 
                Updating contact metadata on lead

<AS20161020>
Modified By: Arjun Sharma
Modification Date: 20-Oct-2016
Modification: Legacy Lead ID is created on basic of combination of CP Project's Dodge Report Number, Dodge Company's Dodge Company Id,
              Dodge Role Type's RoleTypeID and Dodge contact's contact id and update metadata on basic of Legacy Lead ID

<AS20161101>
Modification: Remove duplicate lead records from the list.
<AS20161109>
Modification: Create exception record to log data and technical issue.

<AS20170428>
Modification: we had removed the map and modified the logic to update the lead with help of dodge contact id(ConstructionPts__ContactID__c).
*************************************************************************************************/

public class BI_CPContactHandler extends TriggerHandlerBase {
    /******start*****/
    //<AS20170428>
    /*
    Set<ID> cpProjectId = new Set<ID>();
    Set<ID> cpDodgeCompanyId = new Set<ID>();
    Set<ID> cpDodgeContactId = new Set<ID>();
    Set<ID> cpDodgeRoleTypeId = new Set<ID>();
    Set<String>leadConcatIdSet = new Set<String>();
    Map<ID,ConstructionPts__CP_Project__c> cpProjectMap = new Map <ID,ConstructionPts__CP_Project__c>();
    Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap = new Map<ID,ConstructionPts__CP_Company__c>();
    Map<ID,ConstructionPts__CP_Contact__c> cpContactMap = new Map<ID,ConstructionPts__CP_Contact__c>();
    Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap = new Map<ID,ConstructionPts__CP_Role_Type__c>();
    Map<String,Lead> legacyIdLeadMap = new Map<String,Lead>();
    List<ConstructionPts__CP_Roles__c> cpRoleList = new List<ConstructionPts__CP_Roles__c>();
    */
    /******end*****/
    List<Lead> leadUpsert = new List<Lead>();
    List<Lead> leadUpdateList = new List<Lead>();
    String concatId = '';
    Schema.SObjectField externalIdField = null;
    Set<Lead> leadSet = new Set<Lead>();
    List<Lead> leadUpsertList = new List<Lead>();
    static final String appName = 'CPSF';
    static final String objectName = 'LeadMetaData';    
    
    /******start*****/
    //<AS20170428>
    Set<String> setDodgeContactId = new Set<String>();
    Map<String,ConstructionPts__CP_Contact__c> cpKeyContactMap = new Map<String,ConstructionPts__CP_Contact__c>();
    /******end*****/
    //update contact metadata on lead
    public void onAfterUpdateCPContact(List<ConstructionPts__CP_Contact__c> cpContactList){
        try{
            list<string> LstLeadId = new list<string>(); 
            externalIdField = Lead.Fields.Legacy_Lead_ID__c;
            for(ConstructionPts__CP_Contact__c cpContact:cpContactList){
                if(cpContact.Name != null && cpContact.Name != ''){
                    setDodgeContactId.add(String.valueOf(Integer.valueOf(cpContact.ConstructionPts__ContactID__c)));
                    cpKeyContactMap.put(String.valueOf(Integer.valueOf(cpContact.ConstructionPts__ContactID__c)), cpContact);
                }
            }
            /*******start******/
            /*
            for(ConstructionPts__CP_Contact__c cpContact:cpContactList){
                if(cpContact.Name != null && cpContact.Name != ''){
                    cpDodgeContactId.add(cpContact.id);
                }
            }
            
            if(cpDodgeContactId != null && cpDodgeContactId.size()>0){
                cpRoleList = [SELECT id,Name,ConstructionPts__CP_Project__c,ConstructionPts__CP_Company__c,ConstructionPts__CP_Role_Type__c,ConstructionPts__CP_Contact__c
                                                             FROM ConstructionPts__CP_Roles__c where ConstructionPts__CP_Contact__c IN:cpDodgeContactId];    
            }
            /*******end******/
            
            //<AS20161020> Start
            /*if(cpRoleList != null && cpRoleList.size()>0){
                for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                    if(cpRole.Name != null && cpRole.Name != ''){
                        leadConcatIdSet.add(label.CPSF+String.valueOf(cpRole.Name));
                    }
                }    
            }*/
            
            
            //<AS20170428> start
            /*
            if(cpRoleList != null && cpRoleList.size()>0){
                for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                    if(cpRole.ConstructionPts__CP_Project__c != null){
                        cpProjectId.add(cpRole.ConstructionPts__CP_Project__c);
                    }
                    if(cpRole.ConstructionPts__CP_Company__c != null){
                        cpDodgeCompanyId.add(cpRole.ConstructionPts__CP_Company__c);
                    }
                    if(cpRole.ConstructionPts__CP_Role_Type__c != null){
                        cpDodgeRoleTypeId.add(cpRole.ConstructionPts__CP_Role_Type__c);
                    }  
                }    
            }
            
            cpProjectMap = BI_CPUtil.createCPProjectMap(cpProjectId);
            cpCompanyMap = BI_CPUtil.createCPCompanyMap(cpDodgeCompanyId);
            cpContactMap = BI_CPUtil.createCPContactMap(cpDodgeContactId);
            cpRoleTypeMap = BI_CPUtil.createCPRoleTypeMap(cpDodgeRoleTypeId);
            leadConcatIdSet = BI_CPUtil.createleadConcatIdSet(cpRoleList,cpProjectMap,cpCompanyMap,cpRoleTypeMap,cpContactMap);
            //<AS20161020> End
            
            if(leadConcatIdSet != null && leadConcatIdSet.size()>0){
                leadUpdateList = [Select id,Name,lastName,firstName,phone,email,Name_ID__c,External_Initiative__c,
                                  Company_Role__c,Title,Legacy_Lead_ID__c,Company,Street,City,State,PostalCode,Country,Lead_Country__c,County__c,
                                  Status,Owning_Organization__c,Owning_SBU__c,Type__c,Origin_Channel_Type__c,OwnerId,RecordTypeId 
                                  from Lead where Legacy_Lead_ID__c IN:leadConcatIdSet];
            }
            */
            //<AS20170428> end
            
            /*******start******/
            //<AS20170428>
            if(setDodgeContactId != null && setDodgeContactId.size()>0){
                leadUpdateList = [Select id,Name,lastName,firstName,phone,email,Name_ID__c,External_Initiative__c,
                                  Company_Role__c,Title,Legacy_Lead_ID__c,Company,Street,City,State,PostalCode,Country,Lead_Country__c,County__c,
                                  Status,Owning_Organization__c,Owning_SBU__c,Type__c,Origin_Channel_Type__c,OwnerId,RecordTypeId 
                                  from Lead where Legacy_Lead_ID__c like 'CPSF_%' and Name_ID__c IN:setDodgeContactId];
                System.debug(Logginglevel.ERROR,'Lead update list size Contact #####'+leadUpdateList.size());
            }
            /*******end******/
            
            /*******start******/
            //<AS20170428>
            /*            
            if(leadUpdateList != null && leadUpdateList.size()>0){
                
                for(Lead lobj : leadUpdateList){
                    if(lobj.Legacy_Lead_ID__c != null && lobj.Legacy_Lead_ID__c != ''){
                        legacyIdLeadMap.put(lobj.Legacy_Lead_ID__c,lobj);
                    }
                }
                
                for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                    if(cpRole.ConstructionPts__CP_Project__c != null && 
                       cpRole.ConstructionPts__CP_Company__c != null && 
                       cpRole.ConstructionPts__CP_Role_Type__c != null){
                        //<AS20161020> Start
                        //concatId = label.CPSF+String.valueOf(cpRole.Name);
                        if(cpRole.ConstructionPts__CP_Contact__c != null){
                            concatId=Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c+'^'+String.valueOf(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__ContactID__c);
                        }else{
                            concatId=Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c;
                        }
                        //<AS20161020> End
                        if(legacyIdLeadMap.get(concatId) != null && 
                           cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name != null && 
                           cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name != ''){
                            LstLeadId.add(concatId);
                            leadUpsert.add(updateLeadContact(cpRole,cpContactMap,legacyIdLeadMap.get(concatId)));
                        }   
                    }
                }
            }
            */
            /*******end******/
            if(leadUpdateList != null && leadUpdateList.size()>0){
                
                for(Lead lobj : leadUpdateList){
                    if(lobj !=null && String.isNotBlank(lobj.Name_ID__c)){
                        LstLeadId.add(lobj.Legacy_Lead_ID__c);
                        Lead tempLead = updateLeadContact(lobj,cpKeyContactMap.get(lobj.Name_ID__c));
                        if(tempLead != null){
                            leadUpsert.add(tempLead);
                        }
                    }
                }
            }
            
            if(leadUpsert != null && leadUpsert.size()>0){
                //<AS20161101> Start
                for(Lead lObj : leadUpsert){
                    if(leadSet.add(lObj)){
                        leadUpsertList.add(lObj);
                    }
                }
                List<Database.UpsertResult> urList = database.upsert(leadUpsertList, externalIdField, false);
                //List<Database.UpsertResult> urList = database.upsert(leadUpsert, externalIdField, false);
                //<AS20161101> End
                ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstLeadId,urList,objectName,appName);//<AS20161109>
            }
        }catch(Exception e){
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,objectName,appName);//<AS20161109>
        }
   }
    
/*************************************************************************************************
Function description
Name:           updateLeadContact
Return type:    Lead
Description:    Method used to map fields value of CP Contact to Lead
*************************************************************************************************/
    /*******start******/
    //<AS20170428>
    /*
    public Lead updateLeadContact(ConstructionPts__CP_Roles__c cpRole,Map<ID,
                                  ConstructionPts__CP_Contact__c> cpContactMap,
                                  Lead oldLead){
        Lead leadObject = new Lead();
        String contactExt = '';
        leadObject=oldLead;
        if(BI_CPUtil.leadName(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name).size()>1){
            leadObject.firstName = BI_CPUtil.leadName(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name)[0];
            leadObject.lastName = BI_CPUtil.leadName(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name)[1];    
        }else{
            leadObject.firstName = '';
            leadObject.lastName = BI_CPUtil.leadName(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).Name)[0];     
        }
        if(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_extension__c != null){
            contactExt=' X'+cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_extension__c; 
        }
        if(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_email__c == null){
            leadObject.Alternate_Privacy_Notification__c = Label.CIC_Lead_Alternate_Privacy_Notification;
        }else{
            leadObject.Alternate_Privacy_Notification__c = '';
        }
        leadObject.phone = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_phone__c+contactExt;
        leadObject.email = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_email__c;
        leadObject.Name_ID__c = String.valueOf(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__ContactID__c);
        leadObject.Title = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_title__c;
        return leadObject;
    }*/
    
    public Lead updateLeadContact(Lead oldLead,ConstructionPts__CP_Contact__c dodgeContact){
        Lead leadObject = new Lead();
        String contactExt = '';
        String firstName = '';
        String lastName = '';
        
        if(BI_CPUtil.leadName(dodgeContact.Name).size()>1){
            firstName = BI_CPUtil.leadName(dodgeContact.Name)[0];
            lastName = BI_CPUtil.leadName(dodgeContact.Name)[1];    
        }else{
            firstName = '';
            lastName = BI_CPUtil.leadName(dodgeContact.Name)[0];     
        }
        
        if(oldLead.firstName !=  firstName || oldLead.lastName != lastName ||  
            (dodgeContact.ConstructionPts__Contact_extension__c != null && oldLead.phone != dodgeContact.ConstructionPts__Contact_phone__c+' X'+dodgeContact.ConstructionPts__Contact_extension__c) ||
            (dodgeContact.ConstructionPts__Contact_extension__c == null && oldLead.phone != dodgeContact.ConstructionPts__Contact_phone__c) ||
            oldLead.email != dodgeContact.ConstructionPts__Contact_email__c  || 
            oldLead.Name_ID__c != String.valueOf(Integer.valueof(dodgeContact.ConstructionPts__ContactID__c)) ||
            oldLead.Title != dodgeContact.ConstructionPts__Contact_title__c
        ){
            leadObject=oldLead;
            leadObject.firstName = firstName;
            leadObject.lastName = lastName;    
            
            if(dodgeContact.ConstructionPts__Contact_extension__c != null){
                contactExt=' X'+dodgeContact.ConstructionPts__Contact_extension__c; 
            }
            if(dodgeContact.ConstructionPts__Contact_email__c == null){
                leadObject.Alternate_Privacy_Notification__c = Label.CIC_Lead_Alternate_Privacy_Notification;
            }else{
                leadObject.Alternate_Privacy_Notification__c = '';
            }
            leadObject.phone = dodgeContact.ConstructionPts__Contact_phone__c+contactExt;
            leadObject.email = dodgeContact.ConstructionPts__Contact_email__c;
            leadObject.Name_ID__c = String.valueOf(Integer.valueof(dodgeContact.ConstructionPts__ContactID__c));
            leadObject.Title = dodgeContact.ConstructionPts__Contact_title__c;
        }
        
        return leadObject;
    }
    /*******end******/
}
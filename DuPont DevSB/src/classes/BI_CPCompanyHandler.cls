/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Trigger handler for CP Contact
Event:          After Update : 
                Updating company metadata on lead

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
Modification: we had removed the map and modified the logic to update the lead with help of dodge company key(ConstructionPts__Company_key__c).
*************************************************************************************************/

public class BI_CPCompanyHandler extends TriggerHandlerBase {
    /******start*****/
    //<AS20170428>
    /*
    Set<ID> cpProjectId = new Set<ID>();
    Set<ID> cpDodgeCompanyId = new Set<ID>();
    Set<ID> cpDodgeContactId = new Set<ID>();
    Set<ID> cpDodgeRoleTypeId = new Set<ID>();
    Set<String> leadConcatIdSet = new Set<String>();
    Map<ID,ConstructionPts__CP_Project__c> cpProjectMap = new Map <ID,ConstructionPts__CP_Project__c>();
    Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap = new Map<ID,ConstructionPts__CP_Company__c>();
    Map<ID,ConstructionPts__CP_Contact__c> cpContactMap = new Map<ID,ConstructionPts__CP_Contact__c>();
    Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap = new Map<ID,ConstructionPts__CP_Role_Type__c>();
    List<ConstructionPts__CP_Roles__c> cpRoleList = new List<ConstructionPts__CP_Roles__c>();
    Map<String,Lead> legacyIdLeadMap = new Map<String,Lead>();
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
    Set<String> setDodgeCompanyKey = new Set<String>();
    Map<String,ConstructionPts__CP_Company__c> cpKeyCompanyMap = new Map<String,ConstructionPts__CP_Company__c>();
    /******end*****/
    //update company metadata on lead
    public void onAfterUpdateCPCompany(List<ConstructionPts__CP_Company__c> cpCompanyList){
        try{
            list<string> LstLeadId = new list<string>(); 
            externalIdField = Lead.Fields.Legacy_Lead_ID__c;
            for(ConstructionPts__CP_Company__c cpCompany:cpCompanyList){
                if(cpCompany != null){
                    setDodgeCompanyKey.add(cpCompany.ConstructionPts__Company_key__c);
                    cpKeyCompanyMap.put(cpCompany.ConstructionPts__Company_key__c, cpCompany);
                }
            }
            /******start*****/
            //<AS20170428>
            /*
            for(ConstructionPts__CP_Company__c cpCompany:cpCompanyList){
                if(cpCompany != null){
                    cpDodgeCompanyId.add(cpCompany.id);
                }
            }
            if(cpDodgeCompanyId != null && cpDodgeCompanyId.size()>0){
                cpRoleList = [SELECT id,Name,ConstructionPts__CP_Project__c,ConstructionPts__CP_Company__c,ConstructionPts__CP_Role_Type__c,ConstructionPts__CP_Contact__c 
                                                             FROM ConstructionPts__CP_Roles__c where ConstructionPts__CP_Company__c IN:cpDodgeCompanyId];  
            }
            //<AS20161020> Start
            /*if(cpRoleList != null && cpRoleList.size()>0){
                for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                    if(cpRole.Name != null && cpRole.Name != ''){
                        leadConcatIdSet.add(label.CPSF+String.valueOf(cpRole.Name));
                    }
                }   
            }*/
            
            /*
            if(cpRoleList != null && cpRoleList.size()>0){
                for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                    if(cpRole.ConstructionPts__CP_Project__c != null){
                        cpProjectId.add(cpRole.ConstructionPts__CP_Project__c);
                    }
                    if(cpRole.ConstructionPts__CP_Role_Type__c != null){
                        cpDodgeRoleTypeId.add(cpRole.ConstructionPts__CP_Role_Type__c);
                    }
                    if(cpRole.ConstructionPts__CP_Contact__c != null){
                        cpDodgeContactId.add(cpRole.ConstructionPts__CP_Contact__c);
                    } 
                }    
            }
            
            cpProjectMap = BI_CPUtil.createCPProjectMap(cpProjectId);
            cpCompanyMap = BI_CPUtil.createCPCompanyMap(cpDodgeCompanyId);
            cpContactMap = BI_CPUtil.createCPContactMap(cpDodgeContactId);
            cpRoleTypeMap = BI_CPUtil.createCPRoleTypeMap(cpDodgeRoleTypeId);
                   
            leadConcatIdSet = BI_CPUtil.createleadConcatIdSet(cpRoleList,cpProjectMap,cpCompanyMap,cpRoleTypeMap,cpContactMap);
            */
            //<AS20161020> End
            /*********Start**********/
            //if(leadConcatIdSet != null && leadConcatIdSet.size()>0){
            if(setDodgeCompanyKey !=null && setDodgeCompanyKey.size()>0){
                leadUpdateList = [Select id,Name,lastName,firstName,phone,email,Name_ID__c,External_Initiative__c,
                                  Company_Role__c,Title,Legacy_Lead_ID__c,Company,Street,City,State,PostalCode,Country,Lead_Country__c,County__c,
                                  Dodge_Company_Id__c,Status,Owning_Organization__c,Owning_SBU__c,Type__c,Origin_Channel_Type__c,OwnerId,RecordTypeId 
                                  from Lead where Legacy_Lead_ID__c like 'CPSF_%' and Dodge_Company_Id__c IN:setDodgeCompanyKey];
                System.debug(Logginglevel.ERROR,'Lead update list size Company #####'+leadUpdateList.size());
            }
           // }     
                    
            /*if(leadUpdateList != null && leadUpdateList.size()>0){
                
                for(Lead lobj : leadUpdateList){
                    if(lobj.Legacy_Lead_ID__c != null && lobj.Legacy_Lead_ID__c != ''){
                        legacyIdLeadMap.put(lobj.Legacy_Lead_ID__c,lobj);
                    }
                }
                Integer StartTime2 = Datetime.now().millisecond();
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
                        }//<AS20161020> End
                        if(legacyIdLeadMap.get(concatId) != null){
                            LstLeadId.add(concatId);
                            leadUpsert.add(updateLeadCompany(cpRole,cpCompanyMap,legacyIdLeadMap.get(concatId)));
                        }
                    }
                }
                Integer EndTime2 = Datetime.now().millisecond(); 
            System.debug('ForLoopleadUpdateIDtimeTaken#####'+(StartTime2-EndTime2));
            }*/
            /******end*****/
            /******start*****/
            //<AS20170428>
            if(leadUpdateList != null && leadUpdateList.size()>0){
                
                for(Lead lobj : leadUpdateList){
                    if(lobj !=null && String.isNotBlank(lobj.Dodge_Company_Id__c)){
                        LstLeadId.add(lobj.Legacy_Lead_ID__c);
                        Lead tempLead = updateLeadCompany(lobj,cpKeyCompanyMap.get(lobj.Dodge_Company_Id__c));
                        if(tempLead != null){
                            leadUpsert.add(tempLead);
                        }
                    }
                    //leadUpsert.add(updateLeadCompany(cpRole,cpCompanyMap,legacyIdLeadMap.get(concatId)));
                }
            }
            /******end*****/
            
            
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
Name:           updateLeadCompany
Return type:    Lead
Description:    Method used to map field values of CP Company to Lead
*************************************************************************************************/
    /******start*****/
    //<AS20170428>
    /*
    public Lead updateLeadCompany(ConstructionPts__CP_Roles__c cpRole,
                                  Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap,
                                  Lead oldLead){
        Lead leadObject = new Lead();
        leadObject=oldlead;
        leadObject.Company = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).Name;
        leadObject.Street = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Address__c;
        leadObject.City = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__City__c;
        leadObject.State = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__State__c;
        leadObject.PostalCode = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Zipcode__c;
        leadObject.Country = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Country__c;
        leadObject.Lead_Country__c = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Country__c;
        leadObject.County__c = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__County__c; 
        return leadObject;  
    }*/
    
    public Lead updateLeadCompany(Lead objLead,ConstructionPts__CP_Company__c company){
        Lead leadObject = new Lead();
        if(objLead.Company != company.Name || objLead.Street != company.ConstructionPts__Address__c ||
            objLead.City != company.ConstructionPts__City__c || objLead.State != company.ConstructionPts__State__c ||
            objLead.PostalCode != company.ConstructionPts__Zipcode__c ||
            objLead.Country != company.ConstructionPts__Country__c ||
            objLead.Lead_Country__c != company.ConstructionPts__Country__c ||
            objLead.County__c != company.ConstructionPts__County__c
        ){
            leadObject=objLead;
            leadObject.Company = company.Name;
            leadObject.Street = company.ConstructionPts__Address__c;
            leadObject.City = company.ConstructionPts__City__c;
            leadObject.State = company.ConstructionPts__State__c;
            leadObject.PostalCode = company.ConstructionPts__Zipcode__c;
            leadObject.Country = company.ConstructionPts__Country__c;
            leadObject.Lead_Country__c = company.ConstructionPts__Country__c;
            leadObject.County__c = company.ConstructionPts__County__c; 
        }        
        return leadObject;
    } 
    /******end*****/
}
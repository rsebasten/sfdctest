/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Trigger handler for CP Roles
Event:          After Insert : 
                Create new Lead based on newly inserted Dodge Roles,
                After Update : 
                Update Lead based on updated Dodge Roles,
                by combination of CP Project's Dodge Report Number, Dodge Company's Dodge Company Id
                and Dodge Role Type's RoleTypeID which is related to Legacy Lead ID of Lead

<AS20161017>
Modified By: Arjun Sharma
Modification Date: 17-Oct-2016
Modification: To avoid the SOQL query 101, map owner direct with its ID.

<AS20161020>
Modification: Legacy Lead ID is created on basic of combination of CP Project's Dodge Report Number, Dodge Company's Dodge Company Id,
              Dodge Role Type's RoleTypeID and Dodge contact's contact id and new field mapping of Alternate Privacy Notification
<AS20161109>
Modification: Create exception record to log data and technical issue.

<AS20170203>
Modification:Done the changes to resolve duplicate Lead ExternalId IS ID-00079082

<AS20170428>
Modification: Added new field in lead

<VL20171030>
Modified By: Vijay Laxmi
Modification Date: 30-Oct-2017
Modification: Duplicate Lead Management regarding project # CRM-2017-10-4383  


*************************************************************************************************/

public class BI_CPRoleHandler extends TriggerHandlerBase {
   //<VL20171030> start
   List<wrapper> listwrap = new List<wrapper>();
   Map<String, EI_Lead__c> mapJunction_EI_Lead = new Map<String, EI_Lead__c>(); 
   List<EI_Lead__c> listJunction_Ext_Lead_Obj = new List<EI_Lead__c>(); 
   //<VL20171030> End
    
    
    List<Lead> leadUpsert = new List<Lead>();
    String reportFormatted = '';    
    Set<ID>cpProjectId = new Set<ID>();
    Set<ID>cpDodgeCompanyId = new Set<ID>();
    Set<ID>cpDodgeContactId = new Set<ID>();
    Set<ID>cpDodgeRoleTypeId = new Set<ID>();
    Set<String>cpProjectReportNo = new Set<String>();
    Map<ID,ConstructionPts__CP_Project__c> cpProjectMap = new Map <ID,ConstructionPts__CP_Project__c>();
    Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap = new Map<ID,ConstructionPts__CP_Company__c>();
    Map<ID,ConstructionPts__CP_Contact__c> cpContactMap = new Map<ID,ConstructionPts__CP_Contact__c>();
    Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap = new Map<ID,ConstructionPts__CP_Role_Type__c>();
    Map<ID,ID> projectIdtoExtInitIdMap = new Map<ID,ID>();
    
    String concatId='';
    //Map the all record type of Lead
    Map<String,RecordType> mapExternalInitiativeRT = RType.getDevNameMapBySObjectType('Lead');
    // fetch the record type id for BI-All of Lead
    String leadRtypeId = mapExternalInitiativeRT.containsKey('BI_All')?mapExternalInitiativeRT.get('BI_All').Id:null;//<AS20161020> record type change to BI_All
    //String owner = Label.External_Initiative_Owner_Name;//<AS20161017>
    Schema.SObjectField externalIdField = null;
    static final String appName = 'CPSF';
    static final String objectName = 'Lead';
    //<AS20170203><Start>
    Lead tempLead = new Lead();
    Map<String,Lead> mapLeadUpsert = new Map<String,Lead>();
    //<AS20170203><End>
    //Create/update new Lead after insertion and update of CP Role
    public void onAfterInsertUpdateCPRole(List<ConstructionPts__CP_Roles__c> cpRoleList){
        list<string> LstLeadId = new list<string>(); 
        externalIdField = Lead.Fields.Legacy_Lead_ID__c;
        //Create set of id of lookup fields
        for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
            if(cpRole.ConstructionPts__CP_Project__c != null){
                cpProjectId.add(cpRole.ConstructionPts__CP_Project__c);
            }
            if(cpRole.ConstructionPts__CP_Company__c != null){
                cpDodgeCompanyId.add(cpRole.ConstructionPts__CP_Company__c);
            }
            if(cpRole.ConstructionPts__CP_Contact__c != null){
                cpDodgeContactId.add(cpRole.ConstructionPts__CP_Contact__c);
            }
            if(cpRole.ConstructionPts__CP_Role_Type__c != null){
                cpDodgeRoleTypeId.add(cpRole.ConstructionPts__CP_Role_Type__c);
            }  
        }
        
        //Create the map of lookup fields
        cpProjectMap = BI_CPUtil.createCPProjectMap(cpProjectId);
        cpCompanyMap = BI_CPUtil.createCPCompanyMap(cpDodgeCompanyId);
        cpContactMap = BI_CPUtil.createCPContactMap(cpDodgeContactId);
        cpRoleTypeMap = BI_CPUtil.createCPRoleTypeMap(cpDodgeRoleTypeId);
        projectIdtoExtInitIdMap = createProjectIdtoExtInitIdMap(cpRoleList);
        
        if(cpRoleList != null && leadRtypeId != null){
            for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
                if(cpRole.ConstructionPts__CP_Project__c != null && 
                   cpRole.ConstructionPts__CP_Company__c != null && 
                   cpRole.ConstructionPts__CP_Role_Type__c != null && 
                   projectIdtoExtInitIdMap.get(cpRole.ConstructionPts__CP_Project__c) != null){
                    LstLeadId.add(Label.CPSF+String.valueOf(cpRole.Name));
                     //<AS20170203><Start>
                    tempLead = createLead(cpRole,cpProjectMap,cpCompanyMap,cpRoleTypeMap,cpContactMap,projectIdtoExtInitIdMap);
                       mapLeadUpsert.put(tempLead.Legacy_Lead_ID__c, tempLead);
                   // leadUpsert.add(createLead(cpRole,cpProjectMap,cpCompanyMap,cpRoleTypeMap,cpContactMap,projectIdtoExtInitIdMap));
                }
            }
            leadUpsert.addAll(mapLeadUpsert.values());
            //<AS20170203><End>
        }
        
        try{
            if(leadUpsert != null && leadUpsert.size()>0){
              List<Database.UpsertResult> urList = database.upsert(leadUpsert, externalIdField, false);
                ExceptionHandlingClass_CIC_CP.MthdFetchErrors (LstLeadId,urList,objectName,appName);//<AS20161109>
          
          }
        }catch(Exception e){
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,objectName,appName);//<AS20161109>
        }


    //<VL20171030> start
    map<String,id> mapLegacyLeadId_LeadObjRecordid = new map<String,id>();
    map<id,id>  mapExtInt_ObjRecordid_Lead_ObjRecordid = new map<id,id>(); 
    List<String>   Lead_Legacyid = new List<String>();
        if(leadUpsert!=null && leadUpsert.size()>0)
        {
               for(Lead legacyid :leadUpsert)
            {
                Lead_Legacyid.add(legacyid.Legacy_Lead_ID__c);
            } 
        }
        
        List<Lead>  insertedLead =[select id,Legacy_Lead_ID__c from Lead where Legacy_Lead_ID__c in :Lead_Legacyid];   
        if(insertedLead!=null && insertedLead.size()>0)
        {
            for(Lead leadObj : insertedLead)
            {
                mapLegacyLeadId_LeadObjRecordid.put(leadObj.Legacy_Lead_ID__c,leadObj.id);
            }  
        }
        if(listwrap!=null && listwrap.size()>0)
        {
            for(wrapper wrap : listwrap)
            {
         EI_Lead__c ei_Lead = new EI_Lead__c();
                 if(mapLegacyLeadId_LeadObjRecordid.containskey(wrap.LeadID))
                {
                     ei_Lead.External_Initiative__c=wrap.EIID;
                    ei_Lead.Lead__c=mapLegacyLeadId_LeadObjRecordid.get(wrap.LeadID);
                    ei_Lead.EIidLeadid__c=wrap.EiLead_ExternalID;
                    listJunction_Ext_Lead_Obj.add(ei_Lead);  
                     mapJunction_EI_Lead.put(ei_Lead.EIidLeadid__c,ei_Lead); 
                }
            }
        }
        
      if(mapJunction_EI_Lead.values()!= null && mapJunction_EI_Lead.values().size()>0)
      {
        Schema.SObjectField External_EIiDLeadiD = EI_Lead__c.Fields.EIidLeadid__c;
        List<Database.UpsertResult> JunctionEIlead_Upsert_Records = Database.upsert(mapJunction_EI_Lead.values(), External_EIiDLeadiD, false);
      }   
    }
    //<VL20171030> End
/*************************************************************************************************
Function description 
Name:           createLead
Return type:    Lead
Description:    Method used to map fields value of CP Role to Lead
*************************************************************************************************/
    
    public Lead createLead(ConstructionPts__CP_Roles__c cpRole,Map<ID,ConstructionPts__CP_Project__c> cpProjectMap,
                           Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap,Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap,
                           Map<ID,ConstructionPts__CP_Contact__c> cpContactMap,Map<ID,ID> projectIdtoExtInitIdMap){
        Lead leadObject = new Lead();                  
        String contactExt = '';
        //<VL20171030> start
        String leagacy='';
         //<VL20171030> End                      
        if(cpRole.ConstructionPts__CP_Contact__c == null){
            leadObject.lastName=Label.Lead_Default_Name;
            leadObject.firstName='';
            leadObject.phone='';
            leadObject.email='';
            leadObject.Name_ID__c='';
            leadObject.Title='';
            leadObject.Alternate_Privacy_Notification__c = Label.CIC_Lead_Alternate_Privacy_Notification;//<AS20161020>
           //<VL20171030> start
            //leadObject.Legacy_Lead_ID__c = Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c;//<AS20161020>
            leagacy = Label.CPSF+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c;//<AS20161020>
            //<VL20171030> End
        }else{
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
            //<AS20161020> Start
            if(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_email__c == null){
                leadObject.Alternate_Privacy_Notification__c = Label.CIC_Lead_Alternate_Privacy_Notification;
            }else{
                leadObject.Alternate_Privacy_Notification__c = '';
            }
            //<AS20161020> End
            leadObject.phone = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_phone__c+contactExt;
            leadObject.email = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_email__c;
            leadObject.Name_ID__c = String.valueOf(Integer.valueof((cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c)).ConstructionPts__ContactID__c));
            leadObject.Title = cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__Contact_title__c;
            //<VL20171030> start
            //leadObject.Legacy_Lead_ID__c = Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c+'^'+String.valueOf(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__ContactID__c);//<AS20161020>
            leagacy = Label.CPSF+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c+'^'+String.valueOf(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__ContactID__c);
            //<VL20171030> End
            
        }
        //<VL20171030> Start Removing Lead Mapping with External Initiative
        //leadObject.External_Initiative__c = projectIdtoExtInitIdMap.get(cpRole.ConstructionPts__CP_Project__c);
        //<VL20171030> End
        leadObject.Company_Role__c = cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).Name;
        //leadObject.Legacy_Lead_ID__c = Label.CPSF+cpRole.Name;//<AS20161020>
        leadObject.Company = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).Name;
        leadObject.Street = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Address__c;
        leadObject.City = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__City__c;
        leadObject.State = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__State__c;
        leadObject.PostalCode = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Zipcode__c;
        leadObject.Country = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Country__c;
        leadObject.Lead_Country__c = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Country__c;
        leadObject.County__c = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__County__c;                 
        leadObject.Status = Label.Lead_Status;
        leadObject.Owning_Organization__c = Label.External_Initiative_Owning_Organization;
        leadObject.Owning_SBU__c = Label.Lead_Owning_SBU;
        leadObject.Type__c = Label.Lead_Type;
        leadObject.Origin_Channel_Type__c = Label.Lead_Origin_Channel_Type;
        leadObject.RecordTypeId = leadRtypeId;
        //<AS20170428> added new field 'Dodge_Company_Id__c'
        leadObject.Dodge_Company_Id__c = cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c; 
        //<VL20171030> Start Mapping Lead and External Initiative in wrapper list
        leadObject.Legacy_Lead_ID__c = leagacy;
        String External_EIidLeadID = cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+leagacy;
            wrapper wrapData = new wrapper(projectIdtoExtInitIdMap.get(cpRole.ConstructionPts__CP_Project__c),leadObject.Legacy_Lead_ID__c,External_EIidLeadID);
            listwrap.add(wrapData);
        //<VL20171030> End
        return leadObject;        
    }

/*************************************************************************************************
Function description 
Name:           createProjectIdtoExtInitIdMap
Return type:    Map
Description:    Mapping External Initiative to CP Project
*************************************************************************************************/
    
    public Map<ID,ID> createProjectIdtoExtInitIdMap(List<ConstructionPts__CP_Roles__c> cpRoleList){
        Map<ID,ID> projectIdtoExtInitIdMap = new Map<ID,ID>();
        List<External_Initiative__c> extInitList = new List <External_Initiative__c>();
        Map<String,ID> cpProjectReportMap = new Map<String,ID>();
        Map<String,ID> extInitIdMap = new Map<String,ID>();
        
        if(!cpProjectMap.isEmpty() && cpProjectMap.size()>0){
            for(ConstructionPts__CP_Project__c cpProject : cpProjectMap.values()){
                if(cpProject != null){
                    reportFormatted=BI_CPUtil.mhcFormatted(cpProject.ConstructionPts__Report_Number__c);
                    cpProjectReportNo.add(reportFormatted);
                    cpProjectReportMap.put(reportFormatted,cpProject.Id);
                }
            }
        }
        
        extInitList = [Select id,Name,External_ID__c from External_Initiative__c where External_ID__c in:cpProjectReportNo];
            
        if(extInitList != null && extInitList.size()>0){
            for(External_Initiative__c extInit : extInitList){
                extInitIdMap.put(extInit.External_ID__c,extInit.Id);
            }
        }
            
        //Creating the map of CP project Id with External Initiative Id 
        if(!cpProjectReportMap.isEmpty() && !extInitIdMap.isEmpty()){
            for(String projectReport : cpProjectReportMap.keySet()){
                if(extInitIdMap.get(projectReport) != null){
                    projectIdtoExtInitIdMap.put(cpProjectReportMap.get(projectReport),extInitIdMap.get(projectReport));
                }
            }
        }
        
        return projectIdtoExtInitIdMap;
    }
    //<VL20171030> start Creating a instance of a wrapper class to upsert the data in Junction Object EI-Lead 
    
    public class wrapper
    {
        Id EIID;
        String LeadID;
        String EiLead_ExternalID;
        
        public wrapper( String Eiid, String Leadid, String EiLeadid)
        {
            this.EIID=Eiid;
            this.LeadID=Leadid;
            this.EiLead_ExternalID=EiLeadid;
        }
        
    }
    //<VL20171030> End

}
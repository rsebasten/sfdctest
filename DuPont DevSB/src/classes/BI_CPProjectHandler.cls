/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Trigger handler for CP Project
Event:          After Insert : 
                Create new External Initiative based on newly inserted CP Project,
                After Update : 
                Update External Initiative based on updated CP Project,
                by Dodge Report Number which is related to External Id of External Initiative

<AS20161015>
Modified By: Arjun Sharma
Modification Date: 15-Oct-2016
Modification: Added field mapping of Specification L1 and Data ovarage field for stage, Segment L2 and Specification L1

<AS20161017>
Modification: To avoid the SOQL query 101, map owner direct with its ID.
<AS20161109>
Modification: Create exception record to log data and technical issue.
*************************************************************************************************/

public class BI_CPProjectHandler extends TriggerHandlerBase {
    List<External_Initiative__c> extInitUpsert = new List<External_Initiative__c>();
    //Map the all record type of External Initiative
    Map<String,RecordType> mapExternalInitiativeRT = RType.getDevNameMapBySObjectType('External_Initiative__c');
    // fetch the record type id for BI NA External Initiative of External Initiative
    String extInitRtypeId = mapExternalInitiativeRT.containsKey('BI_NA_External_Initiative')?mapExternalInitiativeRT.get('BI_NA_External_Initiative').Id:null;
    //String owner = Label.External_Initiative_Owner_Name;//<AS20161017>
	Schema.SObjectField externalIdField = null;
    static final String appName = 'CPSF';
    static final String objectName = 'External_Initiative';
    
    //Create/Update External Initiative after insertion or update of CP Project    
    public void onAfterInsertUpdateCPProject(List<ConstructionPts__CP_Project__c> cpProjectList){
        try{
            list<string> LstExternalId = new list<string>(); 
            externalIdField = External_Initiative__c.Fields.External_ID__c;
            String errString = '';
            String errStringTxt = '';
            if(extInitRtypeId != null && cpProjectList != null){
                for(ConstructionPts__CP_Project__c cpProject : cpProjectList){
                    External_Initiative__c objEI = new External_Initiative__c(); 
                    objEI = createExtInit(cpProject);
                    if(objEI != null){
                        extInitUpsert.add(objEI);
                        LstExternalId.add(Label.CPSF+cpProject.ConstructionPts__Report_Number__c);
                    }
                }
            }
       
            if(extInitUpsert != null && extInitUpsert.size()>0){
            	List<Database.UpsertResult> urList = database.upsert(extInitUpsert, externalIdField, false);
				ExceptionHandlingClass_CIC_CP.MthdFetchErrors(LstExternalId,urList,objectName,appName);//<AS20161109>
        	}
       }catch(Exception e){
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,objectName,appName);//<AS20161109>
       }
    }
    
/*************************************************************************************************
Function description 
Name:           createExtInit
Return type:    External_Initiative__c
Description:    Method used to map the value of CP Project to External Initiative
*************************************************************************************************/

    public External_Initiative__c createExtInit(ConstructionPts__CP_Project__c objCPProject){
        String formattedReportNo = BI_CPUtil.mhcFormatted(objCPProject.ConstructionPts__Report_Number__c);
        Integer extVersion = null;
        String projectType = '';
        String projectStage = '';
        String specAlerts = '';
        String overage = '';
        if(objCPProject.ConstructionPts__Report_Version__c != null){
            extVersion = Integer.valueof(objCPProject.ConstructionPts__Report_Version__c.trim());
        }
        
        if(objCPProject.ConstructionPts__Stage255__c != null){
            String eiStage = objCPProject.ConstructionPts__Stage255__c;
            if(eiStage.indexOf(',')>-1){
                projectStage = eiStage.substring(0,eiStage.indexOf(','));
                overage = 'Stage: '+eiStage.substring(eiStage.indexOf(',')+1)+';';//<AS20161015>
            }else{
                projectStage = eiStage;
            }            
        }
        
        if(objCPProject.ConstructionPts__Project_Type__c != null){
        	if(objCPProject.ConstructionPts__Project_Type__c.length()>255){
        		projectType = objCPProject.ConstructionPts__Project_Type__c.substring(0,255);
                Integer index = projectType.lastIndexOf(',');//<AS20161015> Start
                if(index > -1){
                    projectType = projectType.substring(0,index);
                    overage = overage+' SegmentL2: '+objCPProject.ConstructionPts__Project_Type__c.substring(index+1)+';';
                }
        	}else{
            	projectType = objCPProject.ConstructionPts__Project_Type__c;
        	}    
        }
        
        if(objCPProject.ConstructionPts__Spec_Alerts__c != null){
        	if(objCPProject.ConstructionPts__Spec_Alerts__c.length()>255){
        		specAlerts = objCPProject.ConstructionPts__Spec_Alerts__c.substring(0,255);
                Integer index = specAlerts.lastIndexOf(' ');
                if(index > -1){
                    specAlerts = specAlerts.substring(0,index);
                    overage = overage+' SpecificationL1: '+objCPProject.ConstructionPts__Spec_Alerts__c.substring(index+1)+';';
                }
        	}else{
            	specAlerts = objCPProject.ConstructionPts__Spec_Alerts__c;
        	}    
        }//<AS20161015> End
        
		External_Initiative__c extInit = new External_Initiative__c(Name=objCPProject.Name,Owning_Organization__c=Label.External_Initiative_Owning_Organization,Type__c=Label.External_Initiative_Type,
											 Bid_Due_Date__c=objCPProject.ConstructionPts__Bid_Date__c,City__c=objCPProject.ConstructionPts__City__c,
                                             Country__c=objCPProject.ConstructionPts__Country__c,County__c=objCPProject.ConstructionPts__County__c,
                                             Street__c=objCPProject.ConstructionPts__Address__c,Data_Source__c=Label.External_Initiative_Data_Source,
                                             Description__c=objCPProject.ConstructionPts__Features_Info__c,External_ID__c=formattedReportNo,
                                             External_Search_Name__c =objCPProject.ConstructionPts__Search_Names__c,
                                             External_URL__c=objCPProject.ConstructionPts__Project_Report_URL__c,External_Version__c=extVersion,
                                             Floors_Above_Ground__c=objCPProject.ConstructionPts__Stories_above__c,Floors_Below_Ground__c=objCPProject.ConstructionPts__Stories_below__c,
                                             Initiative_Size__c=BI_CPUtil.initiativeSize(objCPProject.ConstructionPts__Total_Sq_Ft__c),Last_Import_Date__c=objCPProject.LastModifiedDate.date(),
                                             Segment_L1__c=objCPProject.ConstructionPts__Market_Segment_Name__c,Segment_L2__c=projectType,
                                             Segment_L3__c=objCPProject.ConstructionPts__Type_Of_Work__c,Segment_L4__c=objCPProject.ConstructionPts__Ownership__c,
                                             Specification_L1__c=specAlerts,Data_Overage__c=overage,//<AS20161015>
                                             Specification_L2__c=objCPProject.ConstructionPts__Structural__c,Stage__c=projectStage,
                                             State__c=objCPProject.ConstructionPts__State__c,UOM__c=BI_CPUtil.uom(objCPProject.ConstructionPts__Total_Sq_Ft__c),
                                             Value__c=objCPProject.ConstructionPts__Value__c,PostalCode__c=objCPProject.ConstructionPts__Zipcode__c,
                                             Project_Status__c=objCPProject.ConstructionPts__Status__c,RecordTypeId=extInitRtypeId);
        return extInit;
    }
}
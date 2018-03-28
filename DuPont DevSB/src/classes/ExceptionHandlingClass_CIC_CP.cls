/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/10/2016
Description:    Exception Handling Class for CP Project and CIC Project

<VL20161109>
Modified By: Vijay Laxmi
Modification Date: 09-Nov-2016
Modification: Modified all the  Exception_Handling methods and created the new methods to crete exception records
*************************************************************************************************/
//Start <VL20161109>
public Class ExceptionHandlingClass_CIC_CP
{
    
    static string RTYPE_dpsException = Rtype.getIdByDevName('DPS_BI_Integration_Error_Handling__c','DPS Exception Handling');
    static List<DPS_BI_Integration_Error_Handling__c> lstDPSException = new List<DPS_BI_Integration_Error_Handling__c>();
       	
    static Map<String,ID> mapCpProjectReportNumberAndId = new Map<String,ID>();
	static Map<String,ID> mapCpRoleNameAndId = new Map<String,ID>();
	public static final String strEIName = 'External_Initiative';
	public static final String strLeadName = 'Lead';
    public static final String strLeadUpdate = 'LeadMetaData';
    public static final String strAppName = 'CIC';
	public static final String strStatus = 'Open';
	public static final String strErrorTypeData = 'Data';
	public static final String strErrorTypeTechnical = 'Technical';
    public static final String delimiter = '^';
	static Schema.SObjectField externalIdField = null;
    
    //Method is used to handle data exception for CIC/CPSF
    public static void MthdFetchErrors (List<string> recordIdList, List<Database.UpsertResult> lstUpsertResult, String objectName, String appName)
    {
        String errorout_Records = null;
        List<String> lstRecordId = new List<String>();
		List<String> lstRoleId = new List<String>();
        Map<String,DPS_BI_Integration_Error_Handling__c> existingDPSExceptionMap = new Map<String,DPS_BI_Integration_Error_Handling__c>();
        externalIdField = DPS_BI_Integration_Error_Handling__c.Fields.External_ID__c;
        List<DPS_BI_Integration_Error_Handling__c> existingDPSException = [Select id, Name,External_Id__c, RecordTypeId, Error_Type__c, Error_Description__c, Project_Name__c, Status__c from DPS_BI_Integration_Error_Handling__c where Status__c != 'Completed' and External_Id__c IN :recordIdList];
        
        
        if(existingDPSException != null && existingDPSException.size()>0){
            for(DPS_BI_Integration_Error_Handling__c dpsException : existingDPSException){
                existingDPSExceptionMap.put(dpsException.External_Id__c, dpsException);
            }
        }
                
        if(recordIdList != null && lstUpsertResult!=null && recordIdList.size() == lstUpsertResult.size())
        {  
            if(strAppName != appName){
                if(objectName == strEIName){
                    for(Integer i=0;i<lstUpsertResult.size();i++)
                    { 
                        if (!lstUpsertResult.get(i).isSuccess())
                        {
                            lstRecordId.add(recordIdList[i].substringAfter('_'));
                        }
                    }
                    
                    for(ConstructionPts__CP_Project__c cpProject :[
                                                            Select Id,Name,ConstructionPts__Report_Number__c 
                                                            from ConstructionPts__CP_Project__c 
                                                            where ConstructionPts__Report_Number__c IN : lstRecordId
                                                           ]){
                        mapCpProjectReportNumberAndId.put(cpProject.ConstructionPts__Report_Number__c,cpProject.id);
                    }
                }else if (objectName == strLeadName){
                    for(Integer i=0;i<lstUpsertResult.size();i++)
                    { 
                        if (!lstUpsertResult.get(i).isSuccess())
                        {
                            lstRoleId.add(recordIdList[i].substringAfter('_'));
                        }
                    }
                    for(ConstructionPts__CP_Roles__c cpRole :[
                                                            Select Id,Name 
                                                            from ConstructionPts__CP_Roles__c 
                                                            where Name IN : lstRoleId
                                                           ]){                                    
                        mapCpRoleNameAndId.put(cpRole.Name,cpRole.id);
                    }
                }
            }
			
			for(Integer i=0;i<lstUpsertResult.size();i++)
            {   
                // Fetch all the records which are not success
                if (!lstUpsertResult.get(i).isSuccess())
                {
                    Database.Error error = lstUpsertResult.get(i).getErrors().get(0);
                    String error_Reason = error.getMessage();
                    
                    errorout_Records = objectName+':'+recordIdList[i]+delimiter+error_Reason+'_'+Datetime.now().format('dd-MM-yyyy');
								
                    if(existingDPSExceptionMap.get(recordIdList[i]) != null){
                        
                        if(existingDPSExceptionMap.get(recordIdList[i]).Error_Description__c.length()<800){
                            existingDPSExceptionMap.get(recordIdList[i]).Error_Description__c = existingDPSExceptionMap.get(recordIdList[i]).Error_Description__c+'\r\n'+errorout_Records;
                        }
                        lstDPSException.add(existingDPSExceptionMap.get(recordIdList[i]));
                    }else{
                        lstDPSException.add(createdpsException(appName,objectName,recordIdList[i],errorout_Records, mapCpProjectReportNumberAndId, mapCpRoleNameAndId));
                    }
                }
            }
			
			
			
            if(lstDPSException != null && lstDPSException.size()>0){
				database.upsert(lstDPSException, externalIdField, false);
            }
        }
    }
    
    //Method is used to handle technical exception for CIC/CPSF
    public static DPS_BI_Integration_Error_Handling__c createdpsException(String appName, String Object1,string recordId, string errorout_Record,Map<String,ID> mapReportNumberAndId,Map<String,ID> mapRoleNameAndId)
    {  	
        DPS_BI_Integration_Error_Handling__c dpsException = new DPS_BI_Integration_Error_Handling__c();
        dpsException.Error_Description__c = errorout_Record;
		dpsException.RecordTypeId=RTYPE_dpsException;
        dpsException.Project_Name__c=appName;
        dpsException.Status__c=strStatus;
        dpsException.External_ID__c=recordId;
		dpsException.Error_Type__c=strErrorTypeData;
		if(mapReportNumberAndId != null){
			dpsException.CP_Project__c = mapReportNumberAndId.get(recordId.substringAfter('_'));
		}
        if(mapRoleNameAndId != null){
			dpsException.Dodge_Roles__c = mapRoleNameAndId.get(recordId.substringAfter('_'));
		}
        return dpsException;
    }
    
    // Method to create dpsException for CP Project/CIC where exception happened in catch with Description
    public static void autoCreatedpsException(exception StrException,String Object1,String appName)
    {  
        DPS_BI_Integration_Error_Handling__c dpsException = new DPS_BI_Integration_Error_Handling__c();
        dpsException.RecordTypeId=RTYPE_dpsException;
        dpsException.Error_Description__c = MthdConvertExceptiontoString(StrException,Object1);
        dpsException.Project_Name__c=appName;
        dpsException.Status__c=strStatus;
		dpsException.Error_Type__c=strErrorTypeTechnical;
        insert dpsException;
    }
     // Method to create dpsException for CIC Project where InitialLoad xml failed 
    public static void autoCreatedpsException_xml(exception StrException,String errortype,String xml_Link,String appName )
    {  
        DPS_BI_Integration_Error_Handling__c dpsException = new DPS_BI_Integration_Error_Handling__c();
        dpsException.RecordTypeId=RTYPE_dpsException;
        dpsException.Error_Description__c =StrException+'\r\n'+ errortype +'\r\n'+ xml_Link;
        dpsException.Project_Name__c=appName;
        dpsException.Status__c=strStatus;
		dpsException.Error_Type__c=strErrorTypeTechnical;
        insert dpsException;
    }
    // Method to create dpsException for CIC Project where  schedule job xml fail 
    public static void autoCreatedpsException_SchJob_xml(String StrException,String errortype,String xml_Link,String appName )
    {  
        DPS_BI_Integration_Error_Handling__c dpsException = new DPS_BI_Integration_Error_Handling__c();
        dpsException.RecordTypeId=RTYPE_dpsException;
        dpsException.Error_Description__c =StrException+'\r\n'+ errortype +'\r\n'+ xml_Link;
        dpsException.Project_Name__c=appName;
        dpsException.Status__c=strStatus;
		dpsException.Error_Type__c=strErrorTypeTechnical;
        insert dpsException;
    }
    
    
    //Method to fetch Catch Exception with below deatils
    public static String MthdConvertExceptiontoString (Exception e , String Object1) 
    {
        String result = null;
        if (e <> NULL)
        result = Object1 +':'+e.getCause() + delimiter + e.getLineNumber() + delimiter + e.getMessage() + delimiter + e.getTypeName(); 
        return result;
    }
   
}
//End <VL20161109>
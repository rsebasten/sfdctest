/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Util class for CP for Salesforce

<AS20161020>
Modified By: Arjun Sharma
Modification Date: 20-Oct-2016
Modification: Added method to create a set of unique Legacy Lead Id

<AS20170428>
Modified By: Arjun Sharma
Modification Date: 28-Apr-2017
Modification: Remove the unnecessary fields from query, commentted unused method and added boolean variable "CPSF_leadTrigPass" to bypass the trigger
*************************************************************************************************/

public class BI_CPUtil {
    
/*************************************************************************************************
Function description 
Name:           mhcFormatted
Return type:    String
Description:    Method used to format Dodge Report Number
Source Data:    BI_CPProjectHandler, BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/
//<AS20170428>Start
    public static boolean CPSF_leadTrigPass=false;
//<AS20170428>End
    public static String mhcFormatted(String str){
        return 'MHC_'+str;
    }

/*************************************************************************************************
Function description 
Name:           uom
Return type:    String
Description:    Method used to get unit of measurement from text
Source Data:    BI_CPProjectHandler
*************************************************************************************************/    
    public static String uom(String str){
        String squareFootNMeter = 'Square Foot';
        if(str != null){
            if(str.containsIgnoreCase('Meter')){
            squareFootNMeter = 'Square Meter';
            }else{
            squareFootNMeter = 'Square Foot';
            }
        }
        return squareFootNMeter;
    }

/*************************************************************************************************
Function description 
Name:           leadName
Return type:    String[]
Description:    Split lead name into first and last name
Source Data:    BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/ 
    
    public static String[] leadName (String name){
        String [] str = new List<String>();
        if(name != null && name != ''){
            try{
                Integer i = name.lastIndexOf(' ');
                if(i>0){
                    str.add(name.substring(0,i));
                    str.add(name.substring(i+1));    
                }else{
                    str.add(name.substring(0)); 
                }
            }catch(Exception e){
            }
        }
        return str;
    }
    
/*************************************************************************************************
Function description 
Name:           initiativeSize
Return type:    Integer
Description:    Method used to get number value from text
Source Data:    BI_CPProjectHandler
*************************************************************************************************/      
    public static Double initiativeSize(String str){
        String s='';
        Double num=null;
        if(str != null){
            try{
                s = str.substring(0,str.indexOf(' '));
                num = Double.valueof(s);
            }catch(Exception e){   
            }
        }        
        return num;
    }

/*************************************************************************************************
Function description 
Name:           createCPCompanyMap
Return type:    Map
Description:    Mapped dodge company by its Id
Source Data:    BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/
    
    public static Map<ID,ConstructionPts__CP_Company__c> createCPCompanyMap(set<ID> setCPCompanyId){
        Map<ID,ConstructionPts__CP_Company__c> cpDodgeCompanyMap = new Map<ID,ConstructionPts__CP_Company__c>([SELECT ConstructionPts__CompanyID__c,ConstructionPts__Company_key__c,
                                                                                                               ConstructionPts__Country__c,ConstructionPts__County__c,ConstructionPts__Email__c,
                                                                                                               ConstructionPts__Address__c,ConstructionPts__City__c,ConstructionPts__State__c,ConstructionPts__Zipcode__c,
                                                                                                               id,Name
                                                                                                               FROM ConstructionPts__CP_Company__c Where ID in:setCPCompanyId]);//<AS20170428>
        return cpDodgeCompanyMap;
    }

/*************************************************************************************************
Function description 
Name:           createCPRoleTypeMap
Return type:    Map
Description:    Map dodge role type by its Id
Source Data:    BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/
    
    public static Map<ID,ConstructionPts__CP_Role_Type__c> createCPRoleTypeMap(set<ID> setCPRoleTypeId){
        Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap = new Map<ID,ConstructionPts__CP_Role_Type__c>([SELECT Id,Name,ConstructionPts__RoleTypeID__c 
                                                                                                              FROM ConstructionPts__CP_Role_Type__c Where ID in:setCPRoleTypeId]);//<AS20170428>
        return cpRoleTypeMap;
    }

/*************************************************************************************************
Function description 
Name:           createCPContactMap
Return type:    Map
Description:    Map dodge contact by its Id
Source Data:    BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/

    public static Map<ID,ConstructionPts__CP_Contact__c> createCPContactMap(set<ID> setCPContactId){
        Map<ID,ConstructionPts__CP_Contact__c> cpContactMap = new Map<ID,ConstructionPts__CP_Contact__c>([SELECT ConstructionPts__ContactID__c,
                                                                                                          ConstructionPts__Contact_email__c,ConstructionPts__Contact_extension__c,
                                                                                                          ConstructionPts__Contact_phone__c,ConstructionPts__Contact_title__c,
                                                                                                          Id,Name
                                                                                                          FROM ConstructionPts__CP_Contact__c Where ID in:setCPContactId]);//<AS20170428>
        return cpContactMap;
    }

/*************************************************************************************************
Function description 
Name:           createCPProjectMap
Return type:    Map
Description:    Map cp project by its Id
Source Data:    BI_CPRoleHandler, BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/
    
    public static Map<ID,ConstructionPts__CP_Project__c> createCPProjectMap(set<ID> setCPProjectId){
        Map <ID,ConstructionPts__CP_Project__c> cpProjectMap = new Map <ID,ConstructionPts__CP_Project__c>([SELECT id,ConstructionPts__Report_Number__c
                                                                                                            FROM ConstructionPts__CP_Project__c where ID in:setCPProjectId]);//<AS20170428>
        return cpProjectMap;
    }
//<AS20161020> Start    
/*************************************************************************************************
Function description 
Name:           createleadConcatIdSet
Return type:    Map
Description:    Create a set of unique Id
Source Data:    BI_CPContactHandler and BI_CPCompanyHandler
*************************************************************************************************/
    //<AS20170428> start
    /*
    public static Set<String> createleadConcatIdSet(List<ConstructionPts__CP_Roles__c> cpRoleList,Map<ID,ConstructionPts__CP_Project__c> cpProjectMap,
                          Map<ID,ConstructionPts__CP_Company__c> cpCompanyMap,Map<ID,ConstructionPts__CP_Role_Type__c> cpRoleTypeMap,Map<ID,ConstructionPts__CP_Contact__c> cpContactMap){
        //Create set of lead Concat Id
        Set<String> leadConcatIdSet = new Set<String>();
        String concatId='';
        for(ConstructionPts__CP_Roles__c cpRole : cpRoleList){
            if(cpRole.ConstructionPts__CP_Project__c != null && 
               cpRole.ConstructionPts__CP_Company__c != null && 
               cpRole.ConstructionPts__CP_Role_Type__c != null){
                   if(cpRole.ConstructionPts__CP_Contact__c != null){
                       concatId=Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c+'^'+String.valueOf(cpContactMap.get(cpRole.ConstructionPts__CP_Contact__c).ConstructionPts__ContactID__c);
                       leadConcatIdSet.add(concatId);
                   }else{
                       concatId=Label.CPSF+cpProjectMap.get(cpRole.ConstructionPts__CP_Project__c).ConstructionPts__Report_Number__c+'^'+cpCompanyMap.get(cpRole.ConstructionPts__CP_Company__c).ConstructionPts__Company_key__c+'^'+cpRoleTypeMap.get(cpRole.ConstructionPts__CP_Role_Type__c).ConstructionPts__RoleTypeID__c;
                       leadConcatIdSet.add(concatId);
                   }
            }  
        }
        return leadConcatIdSet;
    }   //<AS20161020> End
    *///<AS20170428> end
}
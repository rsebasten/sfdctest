public class ANTLogManager{
    
   
/*
String Log = '[sf:deploy] 1.  objects/Issue__c.object (Issue__c.PQR_Category__c) -- Error: This custom field is referenced elsewhere in salesforce.com. : Apex Class - TestUpdateIssuefieldAfterTaskCreation.';
*/           
    public static String findMetaData(String Log){
        Log = Log.subString(0,Log.indexOf(ANTLogUtil.REFERENCED)).trim();
        String MetaDataName = Log.subString(Log.indexOf(ANTlogUtil.OPEN_BRACKET)+1, Log.indexOf(ANTLogUtil.CLOSE_BRACKET) );
        String MetaDataType = Log.subString(Log.indexOf(ANTLogUtil.ERROR_STRING) + ANTLogUtil.ERROR_LENGTH, Log.length()).trim();
        MetaDataType= MetaDataType.replaceAll( '\\s+', '');
        MetaDataType = ANTLogUtil.METADATA_TYPE_MAP.get(MetaDataType.toUpperCase());
        return MetaDataType + MetaDataName;
    }    
       
    public static Set<String> findDependentMetaDatas(String FullLogMsg){
        Set<String> DependentMetaDataSet = new Set<String>();
        for(String Log : getDependencyMsgSet(FullLogMsg)){
            DependentMetaDataSet.add(findDependentMetaData(Log));    
        }
        return DependentMetaDataSet;
    }
    
    private static Set<String> getDependencyMsgSet(String Log){
        Set<String> DependencyMsgSet = new Set<String>();
        String ErrorPortion = log.subString(log.indexOf('Error:')+6, log.length()).trim();
        List<String> ErrorList = ErrorPortion.split('This ');
        for(String s : ErrorList){
            if(!String.isBlank(s.trim())){
               DependencyMsgSet.add(s.trim()); 
            }
        }
        return DependencyMsgSet;
    }
    
    private static String findDependentMetaData(String Log){
        Log = Log.subString(Log.indexOf(ANTLogUtil.REFERENCED) + ANTLogUtil.REFERENCED_LENGTH, Log.length()-1);
        String DependentMetaDataName =Log.subString(Log.indexOf(' - ') + 2 , Log.length()).trim();
        String DependentMetaDataType =Log.subString(0,Log.indexOf(' - ')).trim();
        DependentMetaDataType= DependentMetaDataType.replaceAll( '\\s+', '');
        DependentMetaDataType = ANTLogUtil.METADATA_TYPE_MAP.get(DependentMetaDataType.toUpperCase());
        return DependentMetaDataType + DependentMetaDataName;
    }    
    
    public static Map<String, OneDuPontMetaData__c> getMetaDataObjectMap(List<ANTLogWrapper> ANTLogWrprList){
        Map<String, OneDuPontMetaData__c> MetaDataObjectMap = new Map<String,OneDuPontMetaData__c>();
        Set<String> MetaDataNames = getAllMetaDataNamesSet(ANTLogWrprList);
        List<OneDuPontMetaData__c> MetaDataList = [SELECT ID, MetaDataName__c , External_ID__c FROM OneDuPontMetaData__c WHERE External_ID__c =: MetaDataNames];    
        for(OneDuPontMetaData__c md : MetaDataList){
           MetaDataObjectMap.put(md.MetaDataName__c, md); 
        }    
        return MetaDataObjectMap;
    }
    
    private static Set<String> getAllMetaDataNamesSet(List<ANTLogWrapper> ANTLogWrprList){
        Set<String> AllMetaDataNamesSet = new Set<String>();
        for(ANTLogWrapper ATLWrpr : ANTLogWrprList){
            AllMetaDataNamesSet.add(ATLWrpr.MetaDataName);
            AllMetaDataNamesSet.addAll(ATLWrpr.DependentMetaDataNameSet);
        }
        return AllMetaDataNamesSet;
    }
    
    
    public static List<Remediation_Metadata_Dependency__c> createRemediationMetadataDependencyRecords(List<ANTLogWrapper> ANTLogWrprList, Map<String, OneDuPontMetaData__c> MetaDataObjectMap){
        List<Remediation_Metadata_Dependency__c> RemMDList = new List<Remediation_Metadata_Dependency__c>();
        
        for(ANTLogWrapper alw : ANTLogWrprList){
            OneDuPontMetaData__c MetaDataObj = MetaDataObjectMap.get(alw.MetaDataName);
            alw.ProcessingLog = '#1-> MetaData Name :'+alw.MetaDataName;
            if(MetaDataObj != null){
                alw.ProcessingLog = alw.ProcessingLog +'\n#2-> MetaData ID :'+MetaDataObj.Id;
                for(String depMdName : alw.DependentMetaDataNameSet){
                    OneDuPontMetaData__c DepMetaDataObj = MetaDataObjectMap.get(depMdName);
                    alw.ProcessingLog = alw.ProcessingLog +'\n#3-> Dependent MetaData Name :'+depMdName;
                    if(DepMetaDataObj != null){
                        alw.ProcessingLog = alw.ProcessingLog +'\n#4-> Dependent MetaData ID :'+DepMetaDataObj.Id;
                        Remediation_Metadata_Dependency__c rmd = new Remediation_Metadata_Dependency__c();
                        rmd.ANT_Log__c = alw.LogId;
                        rmd.MetaData__c = MetaDataObj.Id;
                        rmd.Dependent_Metadata__c = DepMetaDataObj.Id;
                        rmd.External_ID__c = MetaDataObj.Id +'~'+ DepMetaDataObj.Id;
                        setTargetOrg(rmd,alw.TargetOrg);
                        RemMDList.add(rmd);
                        alw.ProcessingStatus = 'Success';
                    }else{
                        alw.ProcessingStatus = 'Error';
                    }   
                }
            }else{
                alw.ProcessingStatus = 'Error';
            }
        }
        
        return RemMDList;
    }
    
    
    private static void setTargetOrg(Remediation_Metadata_Dependency__c rmd, String TargetOrg){
        if('AgCo'.equalsIgnoreCase(TargetOrg)){
            rmd.AgCo__c = TRUE;
        }else if('DPS'.equalsIgnoreCase(TargetOrg)){
            rmd.DPS__c = TRUE;
        }else if('DSS'.equalsIgnoreCase(TargetOrg)){
            rmd.DSS__c = TRUE;
        }else if('EC'.equalsIgnoreCase(TargetOrg)){
            rmd.EC__c = TRUE;
        }else if('IB'.equalsIgnoreCase(TargetOrg)){
            rmd.IB__c = TRUE;
        }else if('MatCo'.equalsIgnoreCase(TargetOrg)){
            rmd.MatCo__c = TRUE;
        }else if('NH'.equalsIgnoreCase(TargetOrg)){
            rmd.NH__c = TRUE;
        }
    }

}
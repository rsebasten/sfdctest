public class destructiveChangesCtrl{

   public String destructiveChangesXML{get;set;}
   public string OrgName{get;set;}
   public string AddWhereClause{get;set;}
   public Boolean SkipDependent{get;set;}
   
   private final string nextline = '\n';
   
   public void clearXML(){
       destructiveChangesXML = '';
   }
   
   public void createXML(){
       if(!String.isBlank(OrgName)) {
           String packageTypeElements = CreatePackageTypes();
           if(!String.isBlank(packageTypeElements)){
               destructiveChangesXML = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>' + nextline;
               destructiveChangesXML = destructiveChangesXML + '<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">' +nextline;
               destructiveChangesXML = destructiveChangesXML + packageTypeElements;
               destructiveChangesXML = destructiveChangesXML + nextline + '<version>39.0</version>'+nextline;
               destructiveChangesXML = destructiveChangesXML + '</Package>';
           }else{
               destructiveChangesXML = '';
           }
           System.debug(destructiveChangesXML);
       }
   }
   
   private String CreatePackageTypes(){
       
       String PackageTypes = '';
       
       Map<String,List<String>> MetaDataMap = createMetaDataMap();
       
       for(String metaDataType : MetaDataMap.keySet()){
           
           List<String> MetaDataList = MetaDataMap.get(metaDataType);
           String Members = '';
           
           for(String metadataName : MetaDataList){
             String Member = '<members>'+metadataName+'</members>' + nextline;
             Members = Members+Member;  
       }
           
           String PackageType = nextline + '<types>' + nextline;
           PackageType = PackageType + Members;
           PackageType = PackageType + '<name>'+ metaDataType +'</name>' + nextline;
           PackageType = PackageType + '</types>'+nextline;
           PackageTypes = PackageTypes + PackageType;
       }
            
       return PackageTypes;
   }
   
   private Map<String,List<String>> createMetaDataMap(){
       
       Map<String,List<String>> MetaDataMap = new Map<String,List<String>>();  
       
       try{
      
       String SelectField = 'SELECT ID, AgCo_CRM_Dependencies__c, EC_CRM_Dependencies__c, MS_CRM_Dependencies__c, NH_CRM_Dependencies__c, PS_CRM_Dependencies__c, SS_CRM_Dependencies__c, IB_CRM_Dependencies__c, MetaDataName__c, MetaDataType__c, MetaDataType__r.Name, MetaDataType__r.Skip_Destructive_XML__c FROM OneDuPontMetaData__c ';
       String OrgOrgclause = 'WHERE ' + OrgName +'= \'Delete\'';
       
       String finalQuery = SelectField + OrgOrgclause;
       if(!String.isBlank(AddWhereClause)){
           finalQuery = finalQuery +' AND ( '+  AddWhereClause + ' )';
       }
       
       List<OneDuPontMetaData__c> metaDataList = Database.Query(finalQuery);
       
       for(OneDuPontMetaData__c md : metaDataList){
           if(md.MetaDataType__r.Skip_Destructive_XML__c != TRUE){
           
               if(checkDependentFieldValue(md) == FALSE){
           
                   String metaDataTypeName = md.MetaDataType__r.Name; 
                   String metaDataFullName = md.MetaDataName__c;
                   String metaDataName = metaDataFullName.substring(metaDataTypeName.length()+1,metaDataFullName.length());
           
                   List<String> tempMetaDataList = MetaDataMap.get(metaDataTypeName);
           
                   if(tempMetaDataList != null){
                       tempMetaDataList.add(metaDataName);
                       MetaDataMap.put(metaDataTypeName,tempMetaDataList);
                   }else{
                      tempMetaDataList = new List<String>();
                      tempMetaDataList.add(metaDataName);
                      MetaDataMap.put(metaDataTypeName,tempMetaDataList);
                   }
               }
           }
           
       }
       
       }catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
       }
       return MetaDataMap;
   }
   
    private Boolean checkDependentFieldValue(OneDuPontMetaData__c md){
        Boolean returnValue = FALSE;
        /*
        if( ( 'AgCo_CRM_Metadata_Remediation__c'.equals(OrgName) && !String.isBlank(md.AgCo_CRM_Dependencies__c)  )  ||
            ( 'MS_CRM_Metadata_Remediation__c'.equals(OrgName)   && !String.isBlank(md.MS_CRM_Dependencies__c)    )  ||
            ( 'PS_CRM_Remediation__c'.equals(OrgName)            && !String.isBlank(md.PS_CRM_Dependencies__c)    )  ||
            ( 'SS_CRM_Metadata_Remediation__c'.equals(OrgName)   && !String.isBlank(md.SS_CRM_Dependencies__c)    )  ||
            ( 'IB_CRM_Metadata_Remediation__c'.equals(OrgName)   && !String.isBlank(md.IB_CRM_Dependencies__c)    )  ||
            ( 'NH_CRM_Metadata_Remediation__c'.equals(OrgName)   && !String.isBlank(md.NH_CRM_Dependencies__c)    )  ||
            ( 'EC_CRM_Metadata_Remediation__c'.equals(OrgName)   && !String.isBlank(md.EC_CRM_Dependencies__c)    )  ){
                
            returnValue = TRUE;  
        }*/
        if(SkipDependent){
            if('AgCo_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.AgCo_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('MS_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.MS_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('PS_CRM_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.PS_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('SS_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.SS_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('IB_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.IB_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('NH_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.NH_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }else if('EC_CRM_Metadata_Remediation__c'.equals(OrgName)){
                if(!String.isBlank(md.EC_CRM_Dependencies__c)){
                  returnValue = TRUE;  
                }
            }
        }
        return returnValue;
    }

    public List<SelectOption> getTargetOrgs() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('AgCo_CRM_Metadata_Remediation__c','AgCo CRM'));
        options.add(new SelectOption('MS_CRM_Metadata_Remediation__c','MatCo CRM'));
        options.add(new SelectOption('PS_CRM_Remediation__c','DPS CRM'));
        options.add(new SelectOption('SS_CRM_Metadata_Remediation__c','DSS CRM'));
        options.add(new SelectOption('IB_CRM_Metadata_Remediation__c','IB CRM'));
        options.add(new SelectOption('NH_CRM_Metadata_Remediation__c','N&H CRM'));
        options.add(new SelectOption('EC_CRM_Metadata_Remediation__c','E&C CRM'));
        options.add(new SelectOption('FMC_CRM_Metadata_Remediation__c','FMC CRM'));
        
        return options;
    }
   
   

}
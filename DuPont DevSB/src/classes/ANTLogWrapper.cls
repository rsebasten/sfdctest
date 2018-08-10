public class ANTLogWrapper{
    
    public ID LogId{get;set;}
    public ANT_Log__c ANTLog{get;set;}
    public String TargetOrg{get;set;}
    public String MetaDataName{get;set;}
    public Set<String> DependentMetaDataNameSet{get;set;}
    public String ProcessingLog{get;set;}
    public String ProcessingStatus{get;set;}
    
    public ANTLogWrapper(ANT_Log__c al){
        this.ANTLog = al;
        this.LogId = al.Id;
        this.TargetOrg = al.Target_Org__c;
        this.MetaDataName = ANTLogManager.findMetaData(al.Log__c);
        this.DependentMetaDataNameSet = ANTLogManager.findDependentMetaDatas(al.Log__c);    
    }
}
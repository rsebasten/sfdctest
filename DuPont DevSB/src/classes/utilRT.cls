/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  RecordType Helper class  (RType 2.0)  This class is to superceed existing
    methods available on the RType class 
     // Merge&Spin- Removed Harcoded Ids
    TES20131015:  changed getRTById(string id) to getRTById(Id id) to allow for 15 char ids.
********************************************************************************/
public with sharing class utilRT {
    //Merge&Spin- Updated to remove the hardcoded id by custom label as a part of merge and spin.
    public static final Id MASTERTYPE = System.Label.MasterRecordTypeId;
    
    static MAP<string,RT>                                   mapRT;                  //MAP<rt.id,RecordType>
    static MAP<string,string>                               mapFullName;            //MAP<fullname(lcase),rt.id>
    static MAP<string,string>                               mapSettingsName;        //MAP<rt.id,datasetname>
    static MAP<string,Map<Id, Schema.RecordTypeInfo>>       mapRTInfos;             //MAP<soType,Map<rt.id, Schema.RecordTypeInfo>>

    public static RT getRTById(Id id) {
        if (mapRT==null)
            loadRecordTypes();
        RT rtn = mapRT.get(Id);
        return (rtn!=null) ? rtn : null; //consider returning master when isTest
    }
    public static RT getRT(string soType, string devName) { return  getRT(sotype+'.'+devName); }
    public static RT getRT(string fullName) {
        if (mapFullName==null)
            loadRecordTypes();
        return  mapRT.get(mapFullName.get(fullName.toLowercase()));
    }
    
    public static MAP<string,RT> getMap() {
        return mapRT;
    }
    public static MAP<string,string> getSettingsNameMap() {
        if (mapSettingsName==null)
            loadSettingsName();
        return mapSettingsName;
    }
    //Clear cache calls used for UT
    public static void clearSettingsCache() {
        mapSettingsName=null;
    }
    public static void clearRTCache() {
        mapRT=null;
        mapFullName=null;
    }
    
    public static Map<id, Schema.RecordTypeInfo> getRTInfos(string soType) {
            if  (mapRTInfos!=null && mapRTInfos.containskey(soType.toLowercase()) )
                return mapRTInfos.get(soType.toLowercase());
            else {
                Schema.Sobjecttype  typ = Schema.getGlobalDescribe().get(soType);
                if (typ!=null) {
                    if (mapRTInfos==null)
                        mapRTInfos = new MAP<string,Map<Id, Schema.RecordTypeInfo>>();
                    Map<Id, Schema.RecordTypeInfo> infos  = typ.getDescribe().getRecordTypeInfosByID();
                    mapRTInfos.put(soType.toLowercase(), infos);
                    return infos;
                }
                else 
                    return null;
            }
        }
    
    
    
    /////////////////////////////////////////////////////////////////////////////
    // Class RT (extended RecortType)
    /////////////////////////////////////////////////////////////////////////////   
    public class RT  {
        public string id            { get { return record.id;} }
        public string name          { get { return record.name;} }
        public string devName       { get { return record.developerName;} }
        public string sobjectType   { get { return record.sobjectType;} }
        public string fullname      { get { return record.sobjectType+'.'+record.developerName;} }
        public RecordType record {get; private set;}

        public RT(Id id) {
            try {
                this.record = [ SELECT Id, SobjectType, Name, DeveloperName, IsActive
                 FROM RecordType WHERE Id=:id ];
            } 
            catch(Exception ex) {
                this.record=new RecordType();
            }
        }

        public RT(RecordType rt) {
            this.record=rt; 
        }
        
        public RecordTypeSettings__c getSettings() {
            if (mapSettingsName==null)
                loadSettingsName();
            string setname=mapSettingsName.get(record.id);
            if (!string.isBlank(setname))
                return RecordTypeSettings__c.getInstance(setname);
            else
                return null;
        }
        
        public Schema.RecordTypeInfo getInfo() {
            Schema.RecordTypeInfo rtn;
            try {
                rtn=getRTInfos(this.sobjectType).get(this.id);
            }catch(Exception ex){}
            return rtn; 
        }   

                
        
        public RecordTypeSettings__c upsertSetting(RecordTypeSettings__c rts) {
            RecordTypeSettings__c orig=this.getSettings();
            system.debug(orig);
            if (orig==null) {
                rts.fullname__c=this.fullname;
                insert rts;
            }
            else if (rts.fullName__c!=null && rts.fullName__c.tolowerCase()!=this.fullname.tolowerCase())
                throw new utilRTException('FULLNAME_MISMATCH'); 
            else {
                rts.id=orig.id;
                rts.name=orig.name;
                update rts;
            }
            mapSettingsName.put(id,rts.name);
            return this.getSettings();              
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // Helper Methods
    /////////////////////////////////////////////////////////////////////////////
    private static void loadRecordTypes() {
        mapFullName = new MAP<string,string>();
        mapRT       = new MAP<string,RT>();
        for (RecordType rt : [ SELECT Id, SobjectType, Name, DeveloperName 
             FROM RecordType WHERE IsActive=true]){
                mapRT.put(rt.id,new RT(rt));
                mapFullName.put((rt.sobjecttype+'.'+rt.developername).toLowerCase(),rt.id);
        }   
        mapFullName.remove(null);
    }
    
    private static void loadSettingsName() {
        mapSettingsName = new MAP<string,string>();
        for (RecordTypeSettings__c rts : RecordTypeSettings__c.getAll().values()) {
            string rtid = (rts.fullname__c!=null) ? mapFullName.get(rts.fullname__c.toLowercase()) : null;
            if (rtid!=null)
                mapSettingsName.put(rtid,rts.name);
        }
        mapSettingsName.remove(null);
    }   
    
    
public class utilRTException extends Exception {}
 


    
}
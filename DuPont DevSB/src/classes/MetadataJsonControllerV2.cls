public with sharing class MetadataJsonControllerV2 {
    
    public List<String> objectNames {get;set;}
    public String objs {get;set;}
    public List<id> DocumentIds {get;set;}
    public List<Contact> cont {get;set;}
    private Map<String, Map<String,boolean>> objectEIDFields;
        
    public MetadataJsonControllerV2(){
        objectNames = new List<String>();
        objectNames.add('Account');
        objectNames.add('AccountContactRole');
        objectNames.add('AccountShare');
        objectNames.add('AccountTeamMember');
        objectNames.add('Campaign');
        objectNames.add('CampaignMember');
        objectNames.add('Case');
        objectNames.add('CaseTeamMember');
        objectNames.add('Contact');
        objectNames.add('EmailMessage');
        objectNames.add('EmailMessageRelation');
        objectNames.add('EventRelation');
        objectNames.add('Lead');
        objectNames.add('Opportunity');
        objectNames.add('OpportunityContactRole');
        objectNames.add('OpportunityLineItem');
        objectNames.add('OpportunityLineItemSchedule');
        objectNames.add('OpportunityTeamMember');
        objectNames.add('Partner');
        objectNames.add('Solution');
        objectNames.add('Activity');
        objectNames.add('User');
        objectNames.add('Product2');
        documentIds = new List<Id>();
        objectEIDFields = new Map<String, Map<String,boolean>>();
        
        cont = new List<Contact>();
        cont.addAll([SELECT Id FROM Contact WHERE Name = 'SFDC JSON' Limit 1]);
    }
    
    public void addObject(){
        if(objs.contains(',')){
            List<String> subObjs = objs.split(',');
            for(String str: subObjs){
                if(str != null && str != '')
                    objectNames.add(str.trim());   
            }
        }else{
            if(objs != null && objs != '')
                    objectNames.add(objs.trim());
        }
        objs = '';
    }
    
    public Map<String, Schema.SObjectType> getObjectsDRMap(){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectType> gd2 = new Map<String, Schema.SObjectType>();
        for(String st: gd.keyset()){
            Schema.DescribeSobjectResult odr = gd.get(st).getDescribe();
            if(!st.containsIgnoreCase('__kav') && !st.containsIgnoreCase('__kv') && !st.containsIgnoreCase('__mdt') && odr.isQueryable()){
                if(odr.isCustom()){
                    gd2.put(st,gd.get(st));
                }else{
                    for(String name: objectNames){
                        if(st.containsIgnoreCase(name) && name.containsIgnoreCase(st)){
                            gd2.put(st,gd.get(st));
                            break;
                        }
                    }
                }
            }
        }
        return gd2;
    }
    public Map<String, List<Schema.DescribeFieldResult>> getObjectFieldsMap(){
        
        Map<String, List<Schema.DescribeFieldResult>> objectFields = new Map<String,List<Schema.DescribeFieldResult>>();
        Map<String, Schema.SObjectType> gd = getObjectsDRMap();
        for(String st: gd.keySet()){
            Schema.DescribeSobjectResult odr = gd.get(st).getDescribe();
            String objName = odr.getName();
            objectFields.put(objName,new List<Schema.DescribeFieldResult>());
            objectEIDFields.put(objName,new Map<String,boolean> ());
            Map<String, Schema.SObjectField> fields = odr.fields.getMap();
            for(Schema.SObjectField sf: fields.values()){
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                objectFields.get(objName).add(dfr);
                if(dfr.isExternalID()){
                    objectEIDFields.get(objName).put(dfr.getName(),dfr.isUnique());
                }
            }
        }
        gd.clear();
        return objectFields;
    }
    public void getJson(){
        Map<String, List<Schema.DescribeFieldResult>> objectFieldMap = getObjectFieldsMap();
        
        if(cont.size()==0){
            contact cn = new contact();
            cn.FirstName = 'SFDC';
            cn.LastName = 'JSON';
            insert cn;
            cont.add(cn);
        }
        
        String timenow = '';
        timenow += system.now();
        timenow = timenow.replace(' ', 'T');
        timenow += '.000000Z';
        
        String json = '';
        json += '{';
            json += '"mappings":[';
            for(String obj: objectFieldMap.keySet()){
                json += '{';
                    json += '"config":{';
                    json += '"access":"read_write",';
                    json += '"sf_max_daily_api_calls":30000,';
                    json += '"sf_polling_seconds":600,';
                    json += '"sf_notify_enabled":false,';
                    
                    json += '"indexes":{';
                        Map<String,boolean> fldMap = objectEIDFields.get(obj);
                    
                        for(String fld: fldMap.keyset()){
                            json += '"'+fld+'":{"unique":';
                            if(fldMap.get(fld))
                                json += 'true';
                            else
                                json += 'false';
                            json += '},';
                        }
                        
                        json += '"Id":{"unique":true},';
                        
                        if(!obj.containsIgnoreCase('__mdt') && !obj.containsIgnoreCase('AccountShare'))
                            json += '"SystemModstamp":{"unique":false},';
                        
                        if(!obj.containsIgnoreCase('EmailMessageRelation'))
                            json += '"LastModifiedDate":{"unique":false}';
                        
                        json = json.removeEnd(',');
                    
                    json += '},';
                   
                    json += '"fields":{';
                        for(Schema.DescribeFieldResult fld: objectFieldMap.get(obj)){
                            if(!fld.isCalculated()){
                                String fieldName = '';
                                String type = string.valueOf(fld.getType());
                                
                                if(type == 'REFERENCE'){
                                    
                                    fieldName += fld.getName();
                                    
                                    if(fieldName.endsWithIgnoreCase('Id'))
                                        fieldName = fieldName.removeEnd('Id');
                                    if(fieldName.endsWithIgnoreCase('__c')){
                                        fieldName = fieldName.removeEnd('__c');
                                        fieldName += '__r';
                                    }
                                    
                                    fieldName += '__Legacy_One_Dupont_SFID__c';
                                    
                                    if(fld.getName().containsIgnoreCase('RecordTypeId'))
                                        fieldName = '';
                                }
                                json += '"'+fld.getName()+'":{},';
                                if(fieldName != '')
                                    json += '"'+fieldName+'":{},';
                            }
                        }
                        json = json.removeEnd(',');
                        
                        json += '}';
                    
                    json += '},';
                    
                    json += '"object_name":"'+obj+'"';
                json += '},';
            }
            json = json.removeEnd(',');
            json += '],';
            json += '"version":1,';
            json += '"connection": {';
                json += '"app_name":"dupont-data-migration",';
                json += '"organization_id":"'+Userinfo.getOrganizationId()+'",';
                json += '"exported_at":"'+timenow.removeEnd('z')+'+00:00'+'"';
            json += '}';
        json += '}';
        
        Attachment jsonFile = new Attachment();
        jsonFile.Name = 'JsonMetadataFile'+DocumentIds.size()+'.json';
        jsonFile.Body = Blob.valueOf(json);
        jsonFile.ContentType = 'application/json';
        jsonFile.ParentId = cont[0].Id;
        insert jsonFile;
        DocumentIds.add(jsonFile.Id);
    }
    
    public boolean getUrlPresent(){
        return (DocumentIds.size() > 0);
    }
}
/*****************************************************************************
Author: Rohit saini
Email: rohitkumar.saini@tcs.com
Description:  class to send AccountMaterials in GDL periodic activity

********************************************************************************/

@RestResource(urlMapping='/GetAccountMaterials/*')
global with sharing class GDLGetAccountMaterials{
    //wrapper class starts
    public class Wrapper{
        public List<cls_records> records;
    }
    public class cls_records{
        public String accMatId;
    }
    //wrapper class ends
    
    @HttpGet   
    global static String GetAccountMaterialIds() {
        RestRequest req = RestContext.request;
        List<Account_Material__c> accMaterials2=new List<Account_Material__c>();
        string type=req.params.get('type');
        
        try{
            if(type=='Surfaces'){
                 string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='AcctMatrlids_Surf' order by createdDate ]){
                    if(setting.Setting_Name__c=='AcctMatrlids_Surf'){
                        query+=setting.Value__c+' ';
                    }
                }
                system.debug('query::'+query);
                accMaterials2=database.query(query);

            }else{
                string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='AcctMatrlids_Tyvek' order by createdDate ]){
                    if(setting.Setting_Name__c=='AcctMatrlids_Tyvek'){
                        query+=setting.Value__c+' ';
                    }
                }
                system.debug('query::'+query);
                accMaterials2=database.query(query);
                           
            }
         
            system.debug(LoggingLevel.ERROR, 'accList size : ' + accMaterials2.size());    
            
                JsonGenerator gen=JSON.createGenerator(true);
                gen.writeStartObject();//json starts
                gen.writeFieldName('records');
                gen.writeStartArray();//record array starts
                for(Account_Material__c a : accMaterials2){
                        gen.writeStartObject();
                        gen.writeStringField('accMatId',a.id);
                        gen.writeEndObject();
                }
                
            gen.writeEndArray();//record array ends
            gen.writeEndObject();//json ends 
            
            String prettyJson=gen.getAsString();
            return prettyJson;
        }
        catch(Exception e){
            system.debug(LoggingLevel.ERROR, 'Error : ' + e.getMessage());
            return e.getMessage();
        }
    }
    
    
    @HttpPost   
    global static String GDLGetAccountMaterials() {
        List<Account_Material__c> accMaterials=new List<Account_Material__c>();
        RestRequest req = RestContext.request;
        try{
            system.debug(LoggingLevel.ERROR,'req.requestBody : ' + req.requestBody.toString());
          Wrapper wrap = (Wrapper) JSON.deserialize(req.requestBody.toString(), Wrapper.class);
             Set<String> accMatIds=new Set<String>();
            if(wrap.records.size()>0){
                system.debug('$$$ wrap.records.size()>0');
                for(cls_records cr : wrap.records){
                    accMatIds.add(cr.accMatId);
                }
               string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='GetAcctMatrls' order by createdDate ]){
                    if(setting.Setting_Name__c=='GetAcctMatrls'){
                        query+=setting.Value__c+' ';
                    }
                }
                system.debug('query::'+query);
                accMaterials=database.query(query);
            }
            JsonGenerator gen=JSON.createGenerator(true);
            gen.writeStartObject();//json starts
                gen.writeFieldName('records');
                gen.writeStartArray();//record array starts
                    for(Account_Material__c a : accMaterials){
                        if(String.isNotBlank(a.Product_Name__c) && String.isNotBlank(a.Product_Name__r.name)){
                            gen.writeStartObject();
                            gen.writeStringField('id',a.id);
                            gen.writeStringField('accID',a.Account_Name__c);
                            gen.writeStringField('matId',a.Product_Name__c);
                           
                            System.debug(LoggingLevel.Error, 'prod Name::'+a.Product_Name__r.name);
                            if(a.Product_Name__r.name.containsAny('\"')){
                             String temp=a.Product_Name__r.name.replace('\"','DBLEQUOTE');
                          
                                System.debug(LoggingLevel.Error, 'prod Name::'+temp);
                            
                                gen.writeStringField('matName',temp);
                            }else{
                               gen.writeStringField('matName',a.Product_Name__r.name);
                           }    
                        gen.writeEndObject();
                        }
                     }
                gen.writeEndArray();//record array ends
            gen.writeEndObject();//json ends 
            
            String prettyJson=gen.getAsString();
            system.debug(LoggingLevel.Error, 'prettyJson : ' + prettyJson);
            return prettyJson;
        }
        catch(Exception e){
            system.debug('Error : ' + e.getMessage());
            return e.getMessage();
        }    
    }
}
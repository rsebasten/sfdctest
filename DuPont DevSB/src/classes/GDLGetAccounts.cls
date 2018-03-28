/*****************************************************************************
Author: Rohit saini
Email: rohitkumar.saini@tcs.com
Description:  class to send Accounts in GDL periodic activity

********************************************************************************/

@RestResource(urlMapping='/GetAccounts/*')
global class GDLGetAccounts{
  
    //wrapper class starts
    public class Wrapper{
        public List<cls_records> records;
    }
    public class cls_records{
        public String accId;
    }
    //wrapper class ends

    @HttpGet   
    global static String GetAccountIds() {
        List<Account> accList_NA=new List<Account>();
        List<Contact> accList_EMEA=new List<Contact>();

        RestRequest req = RestContext.request;
        string type=req.params.get('type');
        system.debug(LoggingLevel.Error, 'type::'+type);
        try{
                JsonGenerator gen=JSON.createGenerator(true);
                gen.writeStartObject();//json starts
                gen.writeFieldName('records');
                gen.writeStartArray();//record array starts

            if(type=='NA'){
                string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='GetAccountIdsNA' order by createdDate ]){
                    if(setting.Setting_Name__c=='GetAccountIdsNA'){
                        query+=setting.Value__c+' ';
                    }
                }
                system.debug('query::'+query);
                accList_NA=database.query(query);
                system.debug(LoggingLevel.Error, 'accList size : ' + accList_NA.size());
                for(Account a : accList_NA){
                        gen.writeStartObject();
                        gen.writeStringField('accId',a.id);
                        gen.writeEndObject();
                    }
                
            }else{
                string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='GetAccountIdsEMEA' order by createdDate ]){
                    if(setting.Setting_Name__c=='GetAccountIdsEMEA'){
                        query+=setting.Value__c+' ';
                    }
                }
                system.debug('query::'+query);
                accList_EMEA=database.query(query);
                
               system.debug(LoggingLevel.Error, 'accList size : ' + accList_EMEA.size());    
             Map<string, string> accountIdToContactId=new Map<string, string>();
                for(Contact c:accList_EMEA){
                    accountIdToContactId.put(c.Accountid, c.id);
                }
           List<string> contactIds_EMEA=accountIdToContactId.values();
            system.debug(LoggingLevel.Error, 'contactIds_EMEA size : ' + contactIds_EMEA.size());    
                for(string contactId : contactIds_EMEA){
                        gen.writeStartObject();
                        gen.writeStringField('accId',contactId);
                        gen.writeEndObject();
                    }
            }       
                    
            gen.writeEndArray();//record array ends
            gen.writeEndObject();//json ends 
            
            String prettyJson=gen.getAsString();
            return prettyJson;
        }
        catch(Exception e){
            system.debug('Error : ' + e.getMessage());
            return e.getMessage();
        }
    }
    
    
    @HttpPost   
    global static String getAccounts() {
        List<Account> accList_NA=new List<Account>();
        List<Contact> accList_EMEA=new List<Contact>();

        Map<String,Integer> accntRatingMap=new Map<String,Integer>{
            'Platinum'=>3,
            'A-Hot'=>3,
             'B'=>2,
            'null'=>0
        };
        RestRequest req = RestContext.request;
        try{
            system.debug(LoggingLevel.ERROR,'req.requestBody : ' + req.requestBody.toString());
          Wrapper wrap = (Wrapper) JSON.deserialize(req.requestBody.toString(), Wrapper.class);
            if(wrap.records.size()>0){
                system.debug('$$$ wrap.records.size()>0');
             Set<String> accIds=new Set<String>();
                for(cls_records cr : wrap.records){
                    accIds.add(cr.accId);
                }
                
                string query='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='GetAccountsNA' order by createdDate ]){
                    if(setting.Setting_Name__c=='GetAccountsNA'){
                        query+=setting.Value__c+' ';
                    }
                }
                query=query+'where id in :accIds';
                system.debug('query::'+query);
                accList_NA=database.query(query);

                 string query_EMEA='';
                for(GDLActivityAutomation__c setting: [select id, Setting_Name__c, Value__c from GDLActivityAutomation__c where Setting_Name__c='GetAccountsEMEA' order by createdDate ]){
                    if(setting.Setting_Name__c=='GetAccountsEMEA'){
                        query_EMEA+=setting.Value__c+' ';
                    }
                }
                query_EMEA=query_EMEA+'where id in :accIds';
                system.debug('query::'+query_EMEA);
                accList_EMEA=database.query(query_EMEA);
                
            }
            system.debug('accList size : ' + accList_EMEA.size());
            system.debug('accList size : ' + accList_NA.size());

            JsonGenerator gen=JSON.createGenerator(true);
            gen.writeStartObject();//json starts
                gen.writeFieldName('records');
                gen.writeStartArray();//record array starts
                    for(Account a : accList_NA){
                        gen.writeStartObject();
                            gen.writeStringField('accId',a.id);
                            gen.writeStringField('name',a.Name);
                            gen.writeStringField('owningOrganization',getProcessedString(a.Owning_Organization__c));
                            gen.writeStringField('type',getProcessedString(a.Type));
                            gen.writeStringField('biSubType',getProcessedString(a.BI_Account_SubType__c));
                            gen.writeNumberField('shipLatitude', (a.ShippingLatitude__c<>null ? a.ShippingLatitude__c :0 ));
                            gen.writeNumberField('shipLongitude',(a.ShippingLongitude__c<>null ? a.ShippingLongitude__c : 0));
                            gen.writeStringField('shipFIS',getProcessedString(a.ShippingFIPS__c));
                            gen.writeStringField('shipAccuracy',getProcessedString(a.ShippingAddressAccuracy__c));
                            if(!String.isBlank(a.ShippingStreet)){
                                if(a.ShippingStreet.containsAny('\"')){
                                     String temp=a.ShippingStreet.replace('\"','DBLEQUOTE');
                                    gen.writeStringField('shipStreet',temp);
                                }
                                else
                                {
                                     gen.writeStringField('shipStreet',a.ShippingStreet); 
                                }
                            }
                            else{
                                gen.writeStringField('shipStreet','');
                            }
                            gen.writeStringField('shipCity',getProcessedString(a.ShippingCity));
                            gen.writeStringField('shipCountry',getProcessedString(a.Country__c));
                            gen.writeStringField('shipState',getProcessedString(a.ShippingState));
                            gen.writeStringField('zip',getProcessedString(a.ShippingPostalCode));
                            if(!String.isBlank(a.Rating)){
                                if(accntRatingMap.containsKey(a.Rating)){
                                    gen.writeNumberField('rating',accntRatingMap.get(a.Rating));
                                }
                                else{
                                    gen.writeNumberField('rating',0);
                                }
                            }
                            else{
                                gen.writeNumberField('rating',0);
                            }
                            gen.writeStringField('fax',getProcessedString(a.Fax));
                            gen.writeStringField('phone',getProcessedString(a.Phone));
                            gen.writeStringField('Website','');
                            gen.writeStringField('Email','');
                        gen.writeEndObject();
                    }
                    
                    for(Contact a : accList_EMEA){
                        gen.writeStartObject();
                            gen.writeStringField('accId',a.Accountid);
                            gen.writeStringField('name',a.Account.Name);
                            gen.writeStringField('owningOrganization',getProcessedString(a.Account.Owning_Organization__c));
                            gen.writeStringField('type',getProcessedString(a.Account.Type));
                            gen.writeStringField('biSubType',getProcessedString(a.Account.BI_Account_SubType__c));
                            gen.writeNumberField('shipLatitude',(a.Account.BillingLatitude__c<>null ? a.Account.BillingLatitude__c : 0));
                            gen.writeNumberField('shipLongitude',(a.Account.BillingLongitude__c<>null ? a.Account.BillingLongitude__c : 0));
                            gen.writeStringField('shipFIS',getProcessedString(a.Account.BillingFIPS__c));
                            gen.writeStringField('shipAccuracy',getProcessedString(a.Account.BillingAddressAccuracy__c));
                            if(!String.isBlank(a.MailingStreet)){
                                if(a.MailingStreet.containsAny('\"')){
                                    String temp=a.MailingStreet.replace('\"','');
                                     gen.writeStringField('shipStreet',temp);
                                }
                                else{
                                 gen.writeStringField('shipStreet',a.MailingStreet); 
                                }
                            }
                            else{
                                gen.writeStringField('shipStreet','');
                            }
                            gen.writeStringField('shipCity',getProcessedString(a.MailingCity));
                            gen.writeStringField('shipCountry',getProcessedString(a.Account.Country__c));
                            gen.writeStringField('shipState',getProcessedString(a.MailingState));
                            gen.writeStringField('zip',getProcessedString(a.MailingPostalCode));
                            gen.writeStringField('Email',getProcessedString(a.Email));
                            gen.writeStringField('fax',getProcessedString(a.Account.Fax));
                            gen.writeStringField('phone',getProcessedString(a.Account.Phone));
                            gen.writeStringField('Website',getProcessedString(a.Account.Website));
                            gen.writeNumberField('rating',0);
                        gen.writeEndObject();
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
    
    public static string getProcessedString(string str){
        return (string.isNotBlank(str)?str:'');
    }
}
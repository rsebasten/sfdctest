/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class will send the SAP&HAP mapping for the selected solution package
 ********************************************************************************/

@RestResource(urlMapping='/PopulateBAM/*')
global class CtrlPopulateBAMService {
	//wrapper class
    public class PopulateBamWrapper{
        public String bacConfigurationID;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson='';
        List<Body_Armor_Solution__c> sapSolListDB=new List<Body_Armor_Solution__c>();
        Map<String,List<String>> sapToHapSolIdMap=new Map<String,List<String>>();
        
        try{
           	PopulateBamWrapper tWrap = (PopulateBamWrapper) JSON.deserialize(req.requestBody.toString(), PopulateBamWrapper.class);
            sapSolListDB=[select Id,Related_To_BAM_HAP_1__c,Related_To_BAM_HAP_2__c,Related_To_BAM_HAP_3__c,IsSelectedBAM__c
                         from Body_Armor_Solution__c where BA_Configuration__c=:tWrap.bacConfigurationID AND 
                         RecordType.DeveloperName='SAP_Solution' AND IsSelectedBAM__c=true];
            for(Body_Armor_Solution__c b : sapSolListDB){
                List<String> temp=new List<String>();
                if(b.Related_To_BAM_HAP_1__c<>null){
                    temp.add(b.Related_To_BAM_HAP_1__c);
                }
                if(b.Related_To_BAM_HAP_2__c<>null){
                    temp.add(b.Related_To_BAM_HAP_2__c);
                }
                if(b.Related_To_BAM_HAP_3__c<>null){
                    temp.add(b.Related_To_BAM_HAP_3__c);
                }
                sapToHapSolIdMap.put(b.Id, temp);
            }
            
            JsonGenerator gen=JSON.createGenerator(true);
            gen.writeStartObject();//json starts
                	gen.writeStringField('bacConfigurationID', tWrap.bacConfigurationID);
                    gen.writeFieldName('solutions');
                    	gen.writeStartArray();//solution array starts
                           for(String key : sapToHapSolIdMap.keySet()){
                               for(String value : sapToHapSolIdMap.get(key)){
                                    gen.writeStartObject();
                                        gen.writeStringField('sapSolutionID', key);
                                        gen.writeStringField('hapSolutionID', value);	
                                    gen.writeEndObject();
                               } 
                            }
                    	gen.writeEndArray();//solution array ends
            gen.writeEndObject();//json ends
            system.debug('prettyJson : ' + prettyJson);
        	prettyJson=gen.getAsString();
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),prettyJson,'200', null, null, null,null);         
        }
        catch(Exception e){
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),null,null, e.getMessage(),null, '203',null);
        }
    }
}
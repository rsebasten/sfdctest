/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns all SAP solutions for selected campaign.
 ********************************************************************************/


@RestResource(urlMapping='/PopulateSAPSolution/*')
global class CtrlPopulateSAPSolutionService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    Set<Id> setBASId = new Set<Id>();
    List<Body_Armor_Solution__c> resultSAP ;
    Map<String,Decimal> basMap = new Map<String, Decimal>();
    String prettyJson = '';
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());
        Wrapper bsWrap = (Wrapper) JSON.deserialize(req.requestBody.toString(), Wrapper.class); 
        
        List<Body_Armor_Solution__c> sapSolList=[SELECT id, active__c,Body_Armor_Solution_ID_iOS__c,name,BA_Configuration__c,SAP_weight_of_XXL_size__c,
                                                 SAP_weight_of_XL_size__c,SAP_weight_of_L_size__c,SAP_weight_of_M_size__c,
                                                 SAP_weight_of_XS_size__c,SAP_weight_of_S_size__c,SAP_Thickness__c,Comments__c,
                                                 Areal_Density__c,LastModifiedDate,(select id, name,SAP_Material__c,SAP_Material__r.Material_Type__c,
                                                 Number_of_Layers__c,Material_used__c,GSM__c,Comments__c from Materials_Type__r),
                                                 (select id,name from Attachments)
                                                 from Body_Armor_Solution__c WHERE BA_Configuration__c=:bsWrap.bacConfigurationID 
                                                 and recordType.name = 'SAP Solution' and active__c = true limit 1000];
        
        System.debug('sapSolList'+sapSolList.size());
        
        if(sapSolList.size()>0)
        {
                          
                JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();//json starts
                            gen.writeStringField('bacConfigurationID',sapSolList[0].BA_Configuration__c);
                            gen.writeStringField('basRecordType','SAP Solution');
                                gen.writeFieldName('solutions');
                                    gen.writeStartArray();//solution array starts
                                        for(Body_Armor_Solution__c sapSol :sapSolList)
                                        {
                                            gen.writeStartObject();
                                                if(!String.isBlank(sapSol.name))
                                                {
                                                    gen.writeStringField('name',sapSol.name);
                                                }
                                                else
                                                {
                                                    gen.writeStringField('name','');
                                                }
                                                if(!String.isBlank(sapSol.Body_Armor_Solution_ID_iOS__c))
                                                {
                                                    gen.writeStringField('iosBASolutionID',sapSol.Body_Armor_Solution_ID_iOS__c);
                                                }
                                                else
                                                {
                                                    gen.writeStringField('iosBASolutionID','');
                                                }
                                                gen.writeBooleanField('active',sapSol.active__c);
                                                if(sapSol.Areal_Density__c <> null)
                                                {
                                                    gen.writeNumberField('arealDensity',sapSol.Areal_Density__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('arealDensity',0);
                                                }
                                                if(sapSol.SAP_Thickness__c <> null)
                                                {
                                                    gen.writeNumberField('sapThickness',sapSol.SAP_Thickness__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('sapThickness',0);
                                                }
                                                if(!String.isBlank(sapSol.Comments__c))
                                                {
                                                    gen.writeStringField('solutionComment',sapSol.Comments__c);
                                                }
                                                else
                                                {
                                                    gen.writeStringField('solutionComment','');
                                                }
                                                gen.writeStringField('baSolutionID',sapSol.id);
                                                gen.writeDateTimeField('lastSync',sapSol.lastmodifieddate);
                                                
                                                gen.writeFieldName('weight');
                                                    gen.writeStartArray();//weight array starts
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XS');
                                                            if(sapSol.SAP_weight_of_XS_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_XS_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'S');
                                                            if(sapSol.SAP_weight_of_S_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_S_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'M');
                                                            if(sapSol.SAP_weight_of_M_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_M_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'L');
                                                            if(sapSol.SAP_weight_of_L_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_L_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XL');
                                                            if(sapSol.SAP_weight_of_XL_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_XL_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XXL');
                                                            if(sapSol.SAP_weight_of_XXL_size__c<>null){
                                                                gen.writeNumberField('value', sapSol.SAP_weight_of_XXL_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                    gen.writeEndArray();//weight array ends
                                                    
                                                    gen.writeFieldName('materials');
                                                    gen.writeStartArray();//materials array starts
                                                        for(Material_Type__c  mat: sapSol.Materials_Type__r)
                                                        {
                                                            gen.writeStartObject();
                                                                if(!String.isBlank(mat.name))
                                                                {
                                                                    gen.writeStringField('materialName',mat.name);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('materialName','');
                                                                }
                                                                
                                                                if(!String.isBlank(mat.SAP_Material__r.Material_Type__c))
                                                                {
                                                                    gen.writeStringField('materialType', mat.SAP_Material__r.Material_Type__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('materialType', 'SAP');
                                                                }
                                                           if(!String.isBlank(mat.Number_of_Layers__c))
                                                                    {
                                                                        gen.writeStringField('noOfLayers',mat.Number_of_Layers__c);
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeStringField('noOfLayers','');
                                                                    }
                                                                if(mat.GSM__c <> null)
                                                                {
                                                                    gen.writeNumberField('gsm',mat.GSM__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('gsm',0);
                                                                }
                                                                if(!String.isBlank(mat.Comments__c))
                                                                {
                                                                    gen.writeStringField('comment',mat.Comments__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('comment','');
                                                                }
                                                                
                                                                if(!String.isBlank(mat.SAP_Material__c))
                                                                {
                                                                    gen.writeStringField('materialID',mat.SAP_Material__c);
                                                                    gen.writeStringField('recordID',mat.SAP_Material__c);//for custom partner material logic
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('materialID','');
                                                                    gen.writeStringField('recordID',mat.Id);//for custom partner material logic
                                                                }
                                                                if(!String.isBlank(mat.Material_used__c))
                                                                {
                                                                    gen.writeStringField('materialOrigin',mat.Material_used__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('materialOrigin','');
                                                                }
                                              
                                                            gen.writeEndObject();
                                                        }
                                                    gen.writeEndArray();//materials array ends 
                                            
                                                gen.writeFieldName('attachments');
                                                    gen.writeStartArray();//attachment array starts
                                                        for(Attachment at : sapSol.Attachments){
                                                            gen.writeStartObject();
                                                                gen.writeStringField('fileId', at.Id);
                                                                gen.writeStringField('fileName', at.Name);
                                                            gen.writeEndObject();
                                                        }
                                                    gen.writeEndArray();//attachment array ends
                                            gen.writeEndObject();
                                        }
                                    gen.writeEndArray();//solution array ends
                        gen.writeEndObject();//json ends  
                        
                 prettyJson = gen.GetAsString();   
        }
        system.debug('@@@@@prettyJson' + prettyJson); 
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('514'),'514',prettyJson,  null, 'No Error',null);
     }
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!', null, null,null, '203', null);
    }
}

    public Class Wrapper{
        public String bacConfigurationID;
    }
}
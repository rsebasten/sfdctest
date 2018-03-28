/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns values for inserted for HAP Solution .
 ********************************************************************************/


@RestResource(urlMapping='/PopulateHAPSolution/*')
global class CtrlPopulateHAPSolutionService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    Set<Id> setBASId = new Set<Id>();
    Map<String,Decimal> basMap = new Map<String, Decimal>();
    String prettyJson = '';
    List<String> plateTypes = new List<String>{'Front Plate','Back Plate', 'Side Plate'};
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());
        Wrapper bsWrap = (Wrapper) JSON.deserialize(req.requestBody.toString(), Wrapper.class); 
        List<Body_Armor_Solution__c> hapSolList=  [SELECT id, active__c,Body_Armor_Solution_ID_iOS__c,name,BA_Configuration__c,
                                                   Comments__c,Backing_Material_FP__r.name,Backing_Material_BP__r.name,
                                                   Backing_Material_SP__r.name,Material_Master_FP__r.name,Material_Master_BP__r.name,
                                                   Material_Master_SP__r.name,Material_Master_BP__c,BP_areal_density__c,
                                                   BP_tile_Thickness__c,Backing_Material_BP__c,Backing_layers_BP__c,BP_BM_Areal_Density__c,
                                                   BP_Weight__c,BP_Plate_Solution_Thickness__c,BP_Comment__c,Material_Master_FP__c,
                                                   FP_areal_density__c,FP_tile_Thickness__c,Backing_Material_FP__c,Backing_layers_FP__c,
                                                   FP_BM_Areal_Density__c,FP_Weight__c,FP_Plate_Solution_Thickness__c,FP_Comment__c,
                                                   Material_Master_SP__c,SP_areal_density__c,SP_tile_Thickness__c,Backing_Material_SP__c,
                                                   Backing_layers_SP__c,SP_BM_Areal_Density__c,SP_Weight__c,SP_Plate_Solution_Thickness__c,
                                                   SP_Comment__c,Total_weight_of_XS_size__c ,Total_weight_of_S_size__c ,Total_weight_of_M_size__c ,
                                                   Total_weight_of_L_size__c ,Total_weight_of_XL_size__c ,Total_weight_of_XXL_size__c ,
                                                   No_Of_Layers_SP__c,No_Of_Layers_FP__c,No_Of_Layers_BP__c,LastModifiedDate,
                                                   CustomGSM_BM_BP__c,CustomGSM_BM_FP__c,CustomGSM_BM_SP__c,CustomGSM_BP__c,
                                                   CustomGSM_FP__c,CustomGSM_SP__c,(select id,name from Attachments)
                                                   from Body_Armor_Solution__c WHERE BA_Configuration__c=:bsWrap.bacConfigurationID and recordType.name = 'HAP Solution' and active__c = true limit 1000];
        if(hapSolList.size()>0)
        {          
                 JSONGenerator gen = JSON.createGenerator(true);
                        gen.writeStartObject();//json starts
                            gen.writeStringField('bacConfigurationID',hapSolList[0].BA_Configuration__c);
                            gen.writeStringField('basRecordType','HAP Solution');
                                gen.writeFieldName('solutions');
                                    gen.writeStartArray();//solution array starts
                                        for(Body_Armor_Solution__c hapSol :hapSolList)
                                        {
                                            gen.writeStartObject();
                                            if(!String.isBlank(hapSol.name))
                                            {
                                                gen.writeStringField('name',hapSol.name);
                                            }
                                            else
                                            {
                                                gen.writeStringField('name','');
                                            }
                                            
                                            gen.writeBooleanField('active',hapSol.active__c);
                                            if(!String.isBlank(hapSol.Comments__c))
                                            {
                                                gen.writeStringField('solutionComment',hapSol.Comments__c);
                                            }
                                            else
                                            {
                                                gen.writeStringField('solutionComment','');
                                            }
                                            
                                            if(hapSol.lastmodifieddate <> null)
                                            {
                                                gen.writeDateTimeField('lastSync',hapSol.lastmodifieddate);
                                            }
                                            else
                                            {
                                                gen.writeDateTimeField('lastSync',null);
                                            }
                                            gen.writeStringField('baSolutionID',hapSol.id);
                                            gen.writeStringField('iosBASolutionID',hapSol.Body_Armor_Solution_ID_iOS__c);
                                            gen.writeFieldName('records');
                                            gen.writeStartArray();//records array starts
                                                for(String plate : plateTypes)
                                                {
                                                    if(plate.equalsIgnoreCase('Front Plate'))
                                                    {
                                                        gen.writeStartObject();
                                                            gen.writeStringField('hapType', plate);
                                                                if(hapSol.Material_Master_FP__c != null)
                                                                {
                                                                    gen.writeStringField('material',hapSol.Material_Master_FP__r.name);
                                                                    gen.writeStringField('materialID',hapSol.Material_Master_FP__c);
                                                                }
                                                                if(hapSol.No_Of_Layers_FP__c<>null){
                                                                    gen.writeNumberField('noOfLayers',hapSol.No_Of_Layers_FP__c);
                                                                }
                                                                else{
                                                                   gen.writeNumberField('noOfLayers',0); 
                                                                }
                                                                if(hapSol.FP_areal_density__c <> null)
                                                                {
                                                                    gen.writeNumberField('arealDensity',hapSol.FP_areal_density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('arealDensity',0);
                                                                }
                                                                if(hapSol.FP_tile_Thickness__c <> null)
                                                                {
                                                                    gen.writeNumberField('tileThickness',hapSol.FP_tile_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('tileThickness',0);
                                                                }
                                                                if(hapSol.Backing_Material_FP__c !=null)
                                                                {
                                                                    gen.writeStringField('backingMaterial',hapSol.Backing_Material_FP__r.name);
                                                                    gen.writeStringField('bmMaterialID',hapSol.Backing_Material_FP__c);
                                                                }
                                                                
                                                                if(hapSol.Backing_layers_FP__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',hapSol.Backing_layers_FP__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',0);
                                                                }
                                                                if(hapSol.FP_BM_Areal_Density__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',hapSol.FP_BM_Areal_Density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',0);
                                                                }
                                                                if(hapSol.FP_Weight__c !=null)
                                                                {
                                                                    gen.writeNumberField('weight',hapSol.FP_Weight__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('weight',0);
                                                                }
                                                                
                                                                if( hapSol.FP_Plate_Solution_Thickness__c !=null)
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',hapSol.FP_Plate_Solution_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',0);
                                                                }
                                                                if(!String.isBlank(hapSol.FP_Comment__c))
                                                                {
                                                                    gen.writeStringField('comments',hapSol.FP_Comment__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('comments','');
                                                                }
                                                            if(hapSol.CustomGSM_FP__c<>null){
                                                                gen.writeNumberField('materialInputGSM', hapSol.CustomGSM_FP__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('materialInputGSM', 0);
                                                            }
                                                            if(hapSol.CustomGSM_BM_FP__c<>null){
                                                                gen.writeNumberField('bmInputGSM', hapSol.CustomGSM_BM_FP__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('bmInputGSM', 0);
                                                            }
                                                            gen.writeEndObject();
                                                    }
                                                    if(plate.equalsIgnoreCase('Back Plate'))
                                                    {
                                                        gen.writeStartObject();
                                                            gen.writeStringField('hapType', plate);
                                                                if(hapSol.Material_Master_BP__c !=null)
                                                                {
                                                                    gen.writeStringField('material',hapSol.Material_Master_BP__r.name);
                                                                    gen.writeStringField('materialID',hapSol.Material_Master_BP__c);
                                                                }
                                                                if(hapSol.No_Of_Layers_BP__c<>null){
                                                                    gen.writeNumberField('noOfLayers',hapSol.No_Of_Layers_BP__c);
                                                                }
                                                                else{
                                                                   gen.writeNumberField('noOfLayers',0); 
                                                                }
                                                                if(hapSol.BP_areal_density__c <> null)
                                                                {
                                                                    gen.writeNumberField('arealDensity',hapSol.BP_areal_density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('arealDensity',0);
                                                                }
                                                                if(hapSol.BP_tile_Thickness__c <> null)
                                                                {
                                                                    gen.writeNumberField('tileThickness',hapSol.BP_tile_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('tileThickness',0);
                                                                }
                                                                if(hapSol.Backing_Material_BP__c !=null)
                                                                {
                                                                    gen.writeStringField('backingMaterial',hapSol.Backing_Material_BP__r.name);
                                                                    gen.writeStringField('bmMaterialID',hapSol.Backing_Material_BP__c);
                                                                }
                                                                
                                                                if(hapSol.Backing_layers_BP__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',hapSol.Backing_layers_BP__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',0);
                                                                }
                                                                if(hapSol.BP_BM_Areal_Density__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',hapSol.BP_BM_Areal_Density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',0);
                                                                }
                                                                if(hapSol.BP_Weight__c !=null)
                                                                {
                                                                    gen.writeNumberField('weight',hapSol.BP_Weight__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('weight',0);
                                                                }
                                                                
                                                                if( hapSol.BP_Plate_Solution_Thickness__c !=null)
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',hapSol.BP_Plate_Solution_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',0);
                                                                }
                                                                if(!String.isBlank(hapSol.BP_Comment__c))
                                                                {
                                                                    gen.writeStringField('comments',hapSol.BP_Comment__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('comments','');
                                                                }
                                                        		if(hapSol.CustomGSM_BP__c<>null){
                                                                    gen.writeNumberField('materialInputGSM', hapSol.CustomGSM_BP__c);
                                                                }
                                                                else{
                                                                    gen.writeNumberField('materialInputGSM', 0);
                                                                }
                                                                if(hapSol.CustomGSM_BM_BP__c<>null){
                                                                    gen.writeNumberField('bmInputGSM', hapSol.CustomGSM_BM_BP__c);
                                                                }
                                                                else{
                                                                    gen.writeNumberField('bmInputGSM', 0);
                                                                }
                                                            gen.writeEndObject();
                                                    }
                                                    if(plate.equalsIgnoreCase('Side Plate'))
                                                    {
                                                        gen.writeStartObject();
                                                            gen.writeStringField('hapType', plate);
                                                                if(hapSol.Material_Master_SP__c != null)
                                                                {
                                                                    gen.writeStringField('material',hapSol.Material_Master_SP__r.name);
                                                                    gen.writeStringField('materialID',hapSol.Material_Master_SP__c);
                                                                }
                                                                if(hapSol.No_Of_Layers_FP__c<>null){
                                                                    gen.writeNumberField('noOfLayers',hapSol.No_Of_Layers_FP__c);
                                                                }
                                                                else{
                                                                   gen.writeNumberField('noOfLayers',0); 
                                                                }
                                                                if(hapSol.SP_areal_density__c <> null)
                                                                {
                                                                    gen.writeNumberField('arealDensity',hapSol.SP_areal_density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('arealDensity',0);
                                                                }
                                                                if(hapSol.SP_tile_Thickness__c <> null)
                                                                {
                                                                    gen.writeNumberField('tileThickness',hapSol.SP_tile_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('tileThickness',0);
                                                                }
                                                                if(hapSol.Backing_Material_SP__c !=null)
                                                                {
                                                                    gen.writeStringField('backingMaterial',hapSol.Backing_Material_SP__r.name);
                                                                    gen.writeStringField('bmMaterialID',hapSol.Backing_Material_SP__c);
                                                                }
                                                                
                                                                if(hapSol.Backing_layers_SP__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',hapSol.Backing_layers_SP__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmNoOfLayers',0);
                                                                }
                                                                if(hapSol.SP_BM_Areal_Density__c !=null)
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',hapSol.SP_BM_Areal_Density__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('bmArealDensity',0);
                                                                }
                                                                if(hapSol.SP_Weight__c !=null)
                                                                {
                                                                    gen.writeNumberField('weight',hapSol.SP_Weight__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('weight',0);
                                                                }
                                                                
                                                                if( hapSol.SP_Plate_Solution_Thickness__c !=null)
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',hapSol.SP_Plate_Solution_Thickness__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeNumberField('plateSolutionThickness',0);
                                                                }
                                                                if(!String.isBlank(hapSol.SP_Comment__c))
                                                                {
                                                                    gen.writeStringField('comments',hapSol.SP_Comment__c);
                                                                }
                                                                else
                                                                {
                                                                    gen.writeStringField('comments','');
                                                                }
                                                        		if(hapSol.CustomGSM_SP__c<>null){
                                                                    gen.writeNumberField('materialInputGSM', hapSol.CustomGSM_SP__c);
                                                                }
                                                                else{
                                                                    gen.writeNumberField('materialInputGSM', 0);
                                                                }
                                                                if(hapSol.CustomGSM_BM_SP__c<>null){
                                                                    gen.writeNumberField('bmInputGSM', hapSol.CustomGSM_BM_SP__c);
                                                                }
                                                                else{
                                                                    gen.writeNumberField('bmInputGSM', 0);
                                                                }
                                                            gen.writeEndObject();
                                                    }
                                                }
                                            gen.writeEndArray();//records array ends
                                                gen.writeFieldName('weight');
                                                    gen.writeStartArray();//weight array starts
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XS');
                                                            if(hapSol.Total_weight_of_XS_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_XS_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'S');
                                                            if(hapSol.Total_weight_of_S_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_S_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'M');
                                                            if(hapSol.Total_weight_of_M_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_M_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'L');
                                                            if(hapSol.Total_weight_of_L_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_L_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XL');
                                                            if(hapSol.Total_weight_of_XL_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_XL_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                        gen.writeStartObject();
                                                            gen.writeStringField('size', 'XXL');
                                                            if(hapSol.Total_weight_of_XXL_size__c<>null){
                                                                gen.writeNumberField('value', hapSol.Total_weight_of_XXL_size__c);
                                                            }
                                                            else{
                                                                gen.writeNumberField('value', 0);
                                                            }
                                                        gen.writeEndObject();
                                                    gen.writeEndArray();//weight array ends
                                                    gen.writeFieldName('attachments');
                                                        gen.writeStartArray();//attachment array starts
                                                            for(Attachment at : hapSol.Attachments){
                                                                gen.writeStartObject();
                                                                    gen.writeStringField('fileId', at.Id);
                                                                    gen.writeStringField('fileName', at.Name);
                                                                gen.writeEndObject();
                                                            }
                                                        gen.writeEndArray();//attachment array ends
                                            gen.writeEndObject();
                                        }
                                    gen.writeEndArray();//solution array ends
                        gen.writeEndObject(); //json ends              
                            
                 prettyJson = gen.GetAsString();      
        }
        system.debug('@@@@@prettyJson' + prettyJson); 
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('514'),'514',prettyJson,  null, 'No Error',null);
     }
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!', null, null,null, '203', null);
    }
}
    //wrapper class
    public Class Wrapper{
        public String bacConfigurationID;
      
    }
}
/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class insert the record in BA Solution object for HAP Solution record type with selected values of 
                fields.
 ********************************************************************************************/
@RestResource(urlMapping='/HAPSolution/*')
global class CtrlHAPSolutionService {
    
    //wrapper classes
    global class HapRequestWrapper{
        public String bacConfigurationID;   
        public String basRecordType;    
        public String name; 
        public boolean active;
        public String iosBASolutionID;
        public String solutionComment;  
        public String baSolutionID; 
        public DateTime lastSync; 
        public List<cls_records> records;
        public List<cls_weight> weight;
    }
    global class cls_records {
        public String hapType;  
        public String material; 
        public String materialID; 
        public Decimal noOfLayers;
        public Decimal arealDensity;    
        public Decimal tileThickness;   
        public String backingMaterial;  
        public String bmMaterialID; 
        public Decimal bmNoOfLayers;  
        public Decimal bmArealDensity;  
        public Decimal weight;  
        public Decimal plateSolutionThickness;   
        public String comments;
        //for custom GSM
        public Decimal materialInputGSM;
        public Decimal bmInputGSM;
    }
    global class cls_weight {
        public String size; 
        public Decimal value;       
    }
    
    
    global static List<Body_Armor_Solution__c> createUpdateBAS(HapRequestWrapper wrap,Id rtId){
            List<Body_Armor_Solution__c> temp=new List<Body_Armor_Solution__c>();
            Body_Armor_Solution__c bas;
            if(!String.isBlank(wrap.baSolutionID)){
                 bas= new Body_Armor_Solution__c(Id=wrap.baSolutionID);
            }
            else{
                bas = new Body_Armor_Solution__c();     
                bas.recordTypeId = rtId;
                bas.BA_Configuration__c = wrap.bacConfigurationID;
            }
            bas.Active__c = wrap.active;
            bas.name = wrap.name;
            bas.Comments__c = wrap.solutionComment;
            bas.Body_Armor_Solution_ID_iOS__c=wrap.iosBASolutionID;
            for(cls_records clr : wrap.records){
                        if(clr.hapType.equalsIgnoreCase('Back Plate')){
                            bas.Material_Master_BP__c=clr.materialID;
                            bas.BP_areal_density__c=clr.arealDensity;
                            bas.BP_tile_Thickness__c=clr.tileThickness;
                            bas.Backing_Material_BP__c=clr.bmMaterialID;
                            bas.No_Of_Layers_BP__c=clr.noOfLayers;
                            bas.Backing_layers_BP__c=clr.bmNoOfLayers;
                            bas.BP_BM_Areal_Density__c=clr.bmArealDensity;
                            bas.BP_Weight__c=clr.weight;
                            bas.BP_Plate_Solution_Thickness__c=clr.plateSolutionThickness;
                            bas.BP_Comment__c=clr.comments;
                            bas.CustomGSM_BM_BP__c=clr.bmInputGSM;
                            bas.CustomGSM_BP__c=clr.materialInputGSM;
                        }
                        else if(clr.hapType.equalsIgnoreCase('Front Plate')){
                            bas.Material_Master_FP__c=clr.materialID;
                            bas.FP_areal_density__c=clr.arealDensity;
                            bas.FP_tile_Thickness__c=clr.tileThickness;
                            bas.Backing_Material_FP__c=clr.bmMaterialID;
                            bas.No_Of_Layers_FP__c=clr.noOfLayers;
                            bas.Backing_layers_FP__c=clr.bmNoOfLayers;
                            bas.FP_BM_Areal_Density__c=clr.bmArealDensity;
                            bas.FP_Weight__c=clr.weight;
                            bas.FP_Plate_Solution_Thickness__c=clr.plateSolutionThickness;
                            bas.FP_Comment__c=clr.comments;
                            bas.CustomGSM_BM_FP__c=clr.bmInputGSM;
                            bas.CustomGSM_FP__c=clr.materialInputGSM;
                        }
                        else if(clr.hapType.equalsIgnoreCase('Side Plate')){
                            bas.Material_Master_SP__c=clr.materialID;
                            bas.SP_areal_density__c=clr.arealDensity;
                            bas.SP_tile_Thickness__c=clr.tileThickness;
                            bas.No_Of_Layers_SP__c=clr.noOfLayers;
                            bas.Backing_Material_SP__c=clr.bmMaterialID;
                            bas.Backing_layers_SP__c=clr.bmNoOfLayers;
                            bas.SP_BM_Areal_Density__c=clr.bmArealDensity;
                            bas.SP_Weight__c=clr.weight;
                            bas.SP_Plate_Solution_Thickness__c=clr.plateSolutionThickness;
                            bas.SP_Comment__c=clr.comments;
                            bas.CustomGSM_BM_SP__c=clr.bmInputGSM;
                            bas.CustomGSM_SP__c=clr.materialInputGSM;
                        }
                    }
                    for(cls_weight clw : wrap.weight){
                        system.debug('---weight--'+clw.value);
                        if(clw.size == 'XS'){
                            bas.Total_weight_of_XS_size__c = clw.value;
                        }           
                        else if(clw.size == 'S'){
                            bas.Total_weight_of_S_size__c = clw.value;
                        }           
                        else if(clw.size == 'M'){
                            bas.Total_weight_of_M_size__c = clw.value;
                        }            
                        else if(clw.size == 'L'){
                            bas.Total_weight_of_L_size__c = clw.value;
                        }            
                        else if(clw.size == 'XL'){
                            bas.Total_weight_of_XL_size__c = clw.value;
                        }           
                        else if(clw.size == 'XXL'){
                            bas.Total_weight_of_XXL_size__c = clw.value;
                        }
                    }
                    temp.add(bas);
                    system.debug('---temp--'+temp);
                    return temp;
    }
    
    
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson ='';
        
        try
        {
            system.debug('req.requestBody : ' + req.requestBody.toString());
            List<HapRequestWrapper> tWrap = (List<HapRequestWrapper>) JSON.deserialize(req.requestBody.toString(), List<HapRequestWrapper>.class);
            List<Body_Armor_Solution__c> hapBASolutions = new List<Body_Armor_Solution__c>();
            List<Body_Armor_Solution__c> hapUpsertBASolutions = new List<Body_Armor_Solution__c>();
            Map<Id, Body_Armor_Solution__c> hapBASolutionMap = new Map<Id, Body_Armor_Solution__c>();
            List<Solution_Pricing__c> spListToDelete=new List<Solution_Pricing__c>();
            
            RecordType rt=[SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Body_Armor_Solution__c' 
                           AND IsActive = TRUE AND developerName='HAP_Solution']; 
            if(!String.isBlank(tWrap[0].baSolutionID) && (tWrap[0].lastSync <> null)){
                hapBASolutions=[select id,lastmodifieddate,(Select id from Solution_Packages1__r) from Body_Armor_Solution__c where Id=:tWrap[0].baSolutionID];
            }
            for(Body_Armor_Solution__c bs : hapBASolutions){
                hapBASolutionMap.put(bs.Id, bs); 
                spListToDelete.addAll(bs.Solution_Packages1__r);
            }
            system.debug('spListToDelete size : ' + spListToDelete.size());
            if(spListToDelete.size()>0){
                //delete the pricing record when any change to parent solution is done once the pricing has been started
                delete spListToDelete; 
            }
            for(HapRequestWrapper wrap : tWrap){   
                //new HAP solution
                if(String.isBlank(wrap.baSolutionID)){
                    system.debug('---insert solution'+ wrap.baSolutionID);
                    hapUpsertBASolutions=createUpdateBAS(wrap,rt.Id);
                }                
                //update existing HAP
                else if(!String.isBlank(wrap.baSolutionID) && (wrap.lastSync <> null)){
                    if(hapBASolutionMap.containsKey(wrap.baSolutionID) && wrap.lastSync > hapBASolutionMap.get(wrap.baSolutionID).lastmodifieddate){
                        system.debug('-------update solution---');
                        hapUpsertBASolutions=createUpdateBAS(wrap,rt.Id);
                    }
                    else if(wrap.lastSync < hapBASolutionMap.get(wrap.baSolutionID).lastmodifieddate){
                        system.debug('-------data updated---'+ wrap.lastSync+ '----lastmodifieddate->'+ hapBASolutionMap.get(wrap.baSolutionID).lastmodifieddate);
                        prettyJson='Data is already updated.';
                    }
                }
            }
            if(hapUpsertBASolutions.size()>0){
                upsert hapUpsertBASolutions Id;
            }
            
            List<Body_Armor_Solution__c> finalBAS=new List<Body_Armor_Solution__c>([select id,name,Body_Armor_Solution_ID_iOS__c,lastmodifieddate from Body_Armor_Solution__c where Id IN:hapUpsertBASolutions]);
            if(hapUpsertBASolutions.size()>0){
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                    gen.writeStringField('bacConfigurationID',tWrap[0].bacConfigurationID);
                    gen.writeStringField('baSolutionID',finalBAS[0].Id);
                    gen.writeStringField('basRecordType',tWrap[0].basRecordType);
                    gen.writeStringField('name',finalBAS[0].Name);
                    gen.writeDateTimeField('lastSync',finalBAS[0].lastmodifieddate);
                    gen.writeStringField('iosBASolutionID',finalBAS[0].Body_Armor_Solution_ID_iOS__c);
                gen.writeEndObject();
            
                prettyJson=gen.getAsString();
            }
            system.debug('@@@@@prettyJson' + prettyJson); 
            if(!String.isBlank(tWrap[0].baSolutionID)){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('537'),'537', prettyJson, null, '200','null');         
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('538'),'538', prettyJson, null, '200','null');         
            }
            
        }
        catch(Exception e){
           System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert or Update failed!',null, null, null, '203');
        }
    }
       
}
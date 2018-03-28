/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class insert the record in BA Solution Pricing object for SAP Solution record type with selected values of 
                fields.
 ********************************************************************************************/

@RestResource(urlMapping='/SAPSolutionPricing/*')
global class CtrlSAPSolutionPricingService {
    
    //wrapper classes start
    global class SapSolutionPricingWrapper{
        public String bacConfigurationID;
        public Boolean active;   
        public String baSolutionID; 
        public String baSolutionPricingID;
        public String iosBASolutionPricingID;
        public String name;
        public Decimal costOfOuterCarrier;  
        public Decimal costOfPouches;   
        public String costComment;  
        public Decimal sapMaterialWastage;  
        public String wastageComment;   
        public Decimal bamMargin;   
        //public String marginComment;  
        public DateTime lastSync;   
        public List<cls_materials> materials;
        public List<cls_totalPrice> totalPrice;
    }
    class cls_materials {
        public String materialID;
        public String recordID;
        public String materialName; 
        public Decimal materialPrice;
        public Decimal unitPrice;
    }
    class cls_totalPrice {
        public String size; 
        public Decimal cost;    
    }
    //wrapper classes end
    
    global static List<Solution_Pricing__c> createUpdateSAPPricing(SapSolutionPricingWrapper wrap,Id rtId){
        List<Solution_Pricing__c> temp=new List<Solution_Pricing__c>();
        Solution_Pricing__c sp;
        if(!String.isBlank(wrap.baSolutionPricingID)){
            sp= new Solution_Pricing__c(Id=wrap.baSolutionPricingID);
        }
        else{
            sp = new Solution_Pricing__c();     
            sp.BA_Configuration__c = wrap.bacConfigurationID;
            sp.RecordTypeId=rtId;
            sp.Solution_package_id_iOS__c=wrap.iosBASolutionPricingID;
        }
        sp.Name=wrap.name;
        sp.active__c = wrap.active;
        sp.Select_SAP_Solution__c=wrap.baSolutionID;
        sp.Cost_Of_Outer_Carrier__c=wrap.costOfOuterCarrier;
        sp.Cost_Of_SAP_Pouches__c=wrap.costOfPouches;
        sp.SAP_Material_Wastage__c=wrap.sapMaterialWastage;
        sp.BAM_Margin__c=wrap.bamMargin;
        sp.Cost_Comment__c=wrap.costComment;
        //sp.Material_Wastage_Comment__c=wrap.wastageComment;
        for(cls_totalPrice ctp : wrap.totalPrice){
            if(ctp.size == 'XS'){
                sp.Total_cost_of_Body_Armour_for_size_XS__c = ctp.cost;
            }           
            else if(ctp.size == 'S'){
                sp.Total_cost_of_Body_Armour_for_size_S__c = ctp.cost;
            }           
            else if(ctp.size == 'M'){
                sp.Total_cost_of_Body_Armour_for_size_M__c = ctp.cost;
            }            
            else if(ctp.size == 'L'){
                sp.Total_cost_of_Body_Armour_for_size_L__c = ctp.cost;
            }            
            else if(ctp.size == 'XL'){
                sp.Total_cost_of_Body_Armour_for_size_XL__c = ctp.cost;
            }           
            else if(ctp.size == 'XXL'){
                sp.Total_cost_of_Body_Armour_for_size_XXL__c = ctp.cost;
            }
        }
        temp.add(sp);
        return temp;  
    }
    
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        String prettyJson ='';
        Set<id> materialIds=new set<id>();
        Set<String> blankMaterialId = new Set<String>();
        Solution_Pricing__c sapBASolutionPricing = new Solution_Pricing__c();
        List<Solution_Pricing__c> sapUpsertBASolutionPricing = new List<Solution_Pricing__c>();
        List<Material_Type__c> materialTypeList=new List<Material_Type__c>();
        Map<String,Material_Type__c> materialIdToTypeMap=new Map<String,Material_Type__c>();
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RecordType rt=[select id from RecordType where SObjectType='Solution_Pricing__c' AND 
                       developerName='SAP_Solution_Pricing'];
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            List<SapSolutionPricingWrapper> tWrap = (List<SapSolutionPricingWrapper>) JSON.deserialize(req.requestBody.toString(), List<SapSolutionPricingWrapper>.class);
            
            if(!String.isBlank(tWrap[0].baSolutionPricingID) && (tWrap[0].lastSync <> null)){
                sapBASolutionPricing=[select LastModifiedDate from Solution_Pricing__c where BA_Configuration__c=:tWrap[0].bacConfigurationID
                                        AND Id=:tWrap[0].baSolutionPricingID];
            }            
            //new SAP solution pricing
            if(String.isBlank(tWrap[0].baSolutionPricingID)){
                sapUpsertBASolutionPricing=createUpdateSAPPricing(tWrap[0],rt.Id);
            }
            //update existing SAP solution pricing
            else if(!String.isBlank(tWrap[0].baSolutionPricingID) && (tWrap[0].lastSync <> null)){
                system.debug('-------update solution---');
                if(tWrap[0].lastSync > sapBASolutionPricing.LastModifiedDate){
                    sapUpsertBASolutionPricing=createUpdateSAPPricing(tWrap[0],rt.Id);
                }
                else{
                     prettyJson='Data is already updated.';
                }
            }
            if(sapUpsertBASolutionPricing.size()>0){
                upsert sapUpsertBASolutionPricing Id;
            }
            for(cls_materials cm : tWrap[0].materials){
                  if(!String.isBlank(cm.materialID)){// this check is to ensure partner custom material type is not added and it is queried in line 134
                    materialIds.add(cm.materialID);
                }
                else if(String.isBlank(cm.materialID) && !String.isBlank(cm.recordID)){//means custom partner material
                    blankMaterialId.add(cm.materialID);
                }    
            }
            //SAP_Material__c=null means that custom partner material type which has no material master is also queried
            if(materialIds.size()>0 || blankMaterialId.size()>0){
                for(Material_Type__c mt : [select id,Name,Material_Price_SAP__c,SAP_Material__c,Price_UOM__c from Material_Type__c where (SAP_Material__c IN: materialIds OR SAP_Material__c=null)
                                                AND Body_Armor_SAP_Solution__c=:tWrap[0].baSolutionID]){
                    
                    if(String.isBlank(mt.SAP_Material__c)){//means custom partner material type
                        String key=mt.SAP_Material__c+'/'+mt.Id;
                        materialIdToTypeMap.put(key,mt);
                    }
                    else{
                        materialIdToTypeMap.put(mt.SAP_Material__c,mt);                                                                 
                    }
                }
            }
            system.debug('materialIdToTypeMap : ' + materialIdToTypeMap);
            for(cls_materials cm : tWrap[0].materials){
                if(!String.isBlank(cm.materialID) && materialIdToTypeMap.containsKey(cm.materialID)){
                    Material_Type__c mt=materialIdToTypeMap.get(cm.materialID);
                    mt.Material_Price_SAP__c=cm.materialPrice;
                    mt.Price_UOM__c=cm.unitPrice;
                    materialTypeList.add(mt);
                }
                else if(String.isBlank(cm.materialID) && !String.isBlank(cm.recordID)){  //updating custom partner material type
                    String key='null/'+cm.recordID;
                    Material_Type__c mt=materialIdToTypeMap.get(key);
                    system.debug('entered custom partner : ' + mt);
                    mt.Material_Price_SAP__c=cm.materialPrice;
                    mt.Price_UOM__c=cm.unitPrice;
                    materialTypeList.add(mt);
                }
            }
            if(materialTypeList.size()>0){
                system.debug('materialTypeList :' + materialTypeList); 
                update materialTypeList;
            }
            List<Solution_Pricing__c> finalSP=new List<Solution_Pricing__c>([select id,lastmodifieddate from Solution_Pricing__c where Id IN: sapUpsertBASolutionPricing]);
            JSONGenerator gen = JSON.createGenerator(true);
            if(sapUpsertBASolutionPricing.size()>0){
                gen.writeStartObject();
                    gen.writeStringField('bacConfigurationID',tWrap[0].bacConfigurationID);
                    gen.writeStringField('baSolutionID',tWrap[0].baSolutionID);
                    gen.writeStringField('baSolutionPricingID',finalSP[0].Id);
                    gen.writeDateTimeField('lastSync',finalSP[0].lastmodifieddate);
                gen.writeEndObject();
                prettyJson=gen.getAsString();
            }
            system.debug('prettyJson : ' + prettyJson);
            if(String.isBlank(tWrap[0].baSolutionPricingID)){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('533'),'533', prettyJson, null, '200','null');         
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('534'),'534', prettyJson, null, '200','null');         
            }
        }
        catch(Exception e){
           System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert or Update failed!',null, null, null, '203');
        }
    }    
}
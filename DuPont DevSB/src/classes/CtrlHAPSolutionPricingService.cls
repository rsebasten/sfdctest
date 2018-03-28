/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class insert the record in BA Solution Pricing object for HAP Solution record type with selected values of 
                fields.
 ********************************************************************************************/

@RestResource(urlMapping='/HAPSolutionPricing/*')
global class CtrlHAPSolutionPricingService {
    
    //wrapper classes start
    global class HapSolutionPricingWrapper{
        public String bacConfigurationID;   
        public String baSolutionID; 
        public String baSolutionPricingID;
        public String iosBASolutionPricingID;
        public String name; 
        public Boolean active;
        public Decimal costOfOuterCarrier;  
        public Decimal costOfPouches;   
        public String costComment;  
        public Decimal hapMaterialWastage;  
        public String wastageComment;   
        public Decimal bamMargin;   
        public DateTime lastSync;   
        public List<cls_materials> materials;
        public List<cls_totalPrice> totalPrice;
    }
    class cls_materials {
        public String hapType;  
        public String materialName; 
        public String materialID;   
        public Decimal materialPrice;   
        public String backingMaterial;  
        public String bmMaterialID;
        public Decimal backingMaterialPrice;    
        public Decimal priceForBackingLayer;
        public Decimal miscPrice;
    }
    class cls_totalPrice {
        public String size; 
        public Decimal cost;    
    }
    //wrapper classes end
    
    global static List<Solution_Pricing__c> createUpdateHAPPricing(HapSolutionPricingWrapper wrap,Id rtId){
        List<Solution_Pricing__c> temp=new List<Solution_Pricing__c>();
        Solution_Pricing__c hp;
        if(!String.isBlank(wrap.baSolutionPricingID)){
            hp= new Solution_Pricing__c(Id=wrap.baSolutionPricingID);
        }
        else{
            hp = new Solution_Pricing__c();     
            hp.BA_Configuration__c = wrap.bacConfigurationID;
            hp.RecordTypeId=rtId;
            hp.Solution_package_id_iOS__c=wrap.iosBASolutionPricingID;
        }
        hp.Name=wrap.name;
        hp.active__c = wrap.active;
        hp.Select_HAP_Solution__c=wrap.baSolutionID;
        hp.Cost_Of_Outer_Carrier__c=wrap.costOfOuterCarrier;
        hp.Cost_Of_SAP_Pouches__c=wrap.costOfPouches;
        hp.HAP_Material_Wastage__c=wrap.hapMaterialWastage;
        hp.BAM_Margin__c=wrap.bamMargin;
        hp.Cost_Comment__c=wrap.costComment;
        //hp.Material_Wastage_Comment__c=wrap.wastageComment;
        for(cls_totalPrice ctp : wrap.totalPrice){
            if(ctp.size == 'XS'){
                hp.Total_cost_of_Body_Armour_for_size_XS__c = ctp.cost;
            }           
            else if(ctp.size == 'S'){
                hp.Total_cost_of_Body_Armour_for_size_S__c = ctp.cost;
            }           
            else if(ctp.size == 'M'){
                hp.Total_cost_of_Body_Armour_for_size_M__c = ctp.cost;
            }            
            else if(ctp.size == 'L'){
                hp.Total_cost_of_Body_Armour_for_size_L__c = ctp.cost;
            }            
            else if(ctp.size == 'XL'){
                hp.Total_cost_of_Body_Armour_for_size_XL__c = ctp.cost;
            }           
            else if(ctp.size == 'XXL'){
                hp.Total_cost_of_Body_Armour_for_size_XXL__c = ctp.cost;
            }
        }
        temp.add(hp);
        return temp;  
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        String prettyJson ='';
        Set<id> materialIds=new set<id>();
        Solution_Pricing__c hapBASolutionPricing = new Solution_Pricing__c();
        List<Solution_Pricing__c> hapUpsertBASolutionPricing = new List<Solution_Pricing__c>();
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RecordType rt=[select id from RecordType where SObjectType='Solution_Pricing__c' AND 
                       developerName='HAP_Solution_Pricing'];
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            List<HapSolutionPricingWrapper> tWrap = (List<HapSolutionPricingWrapper>) JSON.deserialize(req.requestBody.toString(), List<HapSolutionPricingWrapper>.class);            
            if(!String.isBlank(tWrap[0].baSolutionPricingID) && tWrap[0].lastSync <> null){
                hapBASolutionPricing=[select LastModifiedDate from Solution_Pricing__c where BA_Configuration__c=:tWrap[0].bacConfigurationID
                                        AND Id=:tWrap[0].baSolutionPricingID];
            }            
            //new HAP solution pricing
            if(String.isBlank(tWrap[0].baSolutionPricingID)){
                hapUpsertBASolutionPricing=createUpdateHAPPricing(tWrap[0],rt.Id);
            }
            //update existing HAP solution pricing
            else if(!String.isBlank(tWrap[0].baSolutionPricingID) && tWrap[0].lastSync <> null){
                system.debug('-------update solution---');
                if(tWrap[0].lastSync > hapBASolutionPricing.LastModifiedDate){
                    hapUpsertBASolutionPricing=createUpdateHAPPricing(tWrap[0],rt.Id);
                }
                else{
                     prettyJson='Data is already updated.';
                }
            }
            if(hapUpsertBASolutionPricing.size()>0){
                upsert hapUpsertBASolutionPricing Id;
            }
            
            Body_Armor_Solution__c bas=new Body_Armor_Solution__c(Id=tWrap[0].baSolutionID);
            for(cls_materials cm : tWrap[0].materials){
                if(cm.hapType.equalsIgnoreCase('Front Plate')){
                    bas.Material_Master_FP__c=cm.materialID;
                    bas.FP_Material_Price__c=cm.materialPrice;
                    bas.Backing_Material_FP__c=cm.bmMaterialID;
                    bas.FP_backing_material_price__c=cm.backingMaterialPrice;
                    bas.BackingLayerPrice_FP__c=cm.priceForBackingLayer;
                    bas.FP_miscellaneous_price__c=cm.miscPrice;
                }
                else if(cm.hapType.equalsIgnoreCase('Back Plate')){
                    bas.Material_Master_BP__c=cm.materialID;
                    bas.BP_Material_Price__c=cm.materialPrice;
                    bas.Backing_Material_BP__c=cm.bmMaterialID;
                    bas.BP_backing_material_price__c=cm.backingMaterialPrice;
                    bas.BackingLayerPrice_BP__c=cm.priceForBackingLayer;
                    bas.BP_miscellaneous_price__c=cm.miscPrice;
                }
                else if(cm.hapType.equalsIgnoreCase('Side Plate')){
                    bas.Material_Master_SP__c=cm.materialID;
                    bas.SP_Material_Price__c=cm.materialPrice;
                    bas.Backing_Material_SP__c=cm.bmMaterialID;
                    bas.SP_backing_material_price__c=cm.backingMaterialPrice;
                    bas.BackingLayerPrice_SP__c=cm.priceForBackingLayer;
                    bas.SP_miscellaneous_price__c=cm.miscPrice;
                }
            }
            if(bas<>null){
                update bas;
            }
            List<Solution_Pricing__c> finalHP=new List<Solution_Pricing__c>([select id,lastmodifieddate from Solution_Pricing__c where Id IN: hapUpsertBASolutionPricing]);
            JSONGenerator gen = JSON.createGenerator(true);
            if(hapUpsertBASolutionPricing.size()>0){
                gen.writeStartObject();
                    gen.writeStringField('bacConfigurationID',tWrap[0].bacConfigurationID);
                    gen.writeStringField('baSolutionID',tWrap[0].baSolutionID);
                    gen.writeStringField('baSolutionPricingID',finalHP[0].Id);
                    gen.writeDateTimeField('lastSync',finalHP[0].lastmodifieddate);
                gen.writeEndObject();
                prettyJson=gen.getAsString();
            }
            system.debug('prettyJson : ' + prettyJson);
            if(String.isBlank(tWrap[0].baSolutionPricingID)){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('539'),'539', prettyJson, null, '200','null');         
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('540'),'540', prettyJson, null, '200','null');         
            }
        }
        catch(Exception e){
           System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert or Update failed!',null, null, null, '203');
        }
    }    
}
/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns HAP Solution pricings for selected BA solutions
 ********************************************************************************************/

@RestResource(urlMapping='/PopulateHAPSolutionPricing/*')
global class CtrlPopulateHAPSolutionPricingService {
    global class PopulateHAPPricingWrapper{
        public String bacConfigurationID;
        public List<String> baSolutionID;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson = '';
        List<Solution_Pricing__c> hapPricingList=new List<Solution_Pricing__c>();
        List<Body_Armor_Solution__c> basList=new List<Body_Armor_Solution__c>();
        Map<Id,Solution_Pricing__c> solutionIdToSPMap=new Map<Id,Solution_Pricing__c>();
        Map<Id,Body_Armor_Solution__c> IdToBASMap=new Map<Id,Body_Armor_Solution__c>();
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            PopulateHAPPricingWrapper wrap = (PopulateHAPPricingWrapper) JSON.deserialize(req.requestBody.toString(), PopulateHAPPricingWrapper.class);
        
            hapPricingList=[select id,name,Cost_Of_Outer_Carrier__c,Cost_Of_SAP_Pouches__c,HAP_Material_Wastage__c,Cost_Comment__c,
                           //BAM_Margin__c,BA_Configuration__c,Solution_package_id_iOS__c,Material_Wastage_Comment__c,Select_HAP_Solution__c,
                           BAM_Margin__c,BA_Configuration__c,Solution_package_id_iOS__c,Select_HAP_Solution__c,
                           Select_HAP_Solution__r.Body_Armor_Solution_ID_iOS__c,Total_cost_of_Body_Armour_for_size_XS__c,Total_cost_of_Body_Armour_for_size_S__c,Total_cost_of_Body_Armour_for_size_L__c,Total_cost_of_Body_Armour_for_size_XL__c,
                           Total_cost_of_Body_Armour_for_size_XXL__c,Total_cost_of_Body_Armour_for_size_M__c
                           from Solution_Pricing__c where BA_Configuration__c=:wrap.bacConfigurationID AND 
                           Select_HAP_Solution__c IN: wrap.baSolutionID AND Active__c=true];
            for(Solution_Pricing__c sp : hapPricingList){
               solutionIdToSPMap.put(sp.Select_HAP_Solution__c, sp);
            }
            basList=[select id,name,Material_Master_FP__c,Material_Master_FP__r.Name,FP_Material_Price__c,Backing_Material_FP__c,Backing_Material_FP__r.Name,FP_backing_material_price__c,BackingLayerPrice_FP__c,FP_miscellaneous_price__c,
                    Material_Master_SP__c,Material_Master_SP__r.Name,SP_Material_Price__c,Backing_Material_SP__c,Backing_Material_SP__r.Name,SP_backing_material_price__c,BackingLayerPrice_SP__c,SP_miscellaneous_price__c,
                    Material_Master_BP__c,Material_Master_BP__r.Name,BP_Material_Price__c,Backing_Material_BP__c,Backing_Material_BP__r.Name,BP_backing_material_price__c,BackingLayerPrice_BP__c,BP_miscellaneous_price__c
                    from Body_Armor_Solution__c where ID IN: wrap.baSolutionID AND BA_Configuration__c=:wrap.bacConfigurationID
                    AND Active__c=true];
            for(Body_Armor_Solution__c bs : basList){
                IdToBASMap.put(bs.Id, bs);
            }
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();//json starts
                gen.writeStringField('bacConfigurationID', wrap.bacConfigurationID);
                gen.writeFieldName('records');
                    gen.writeStartArray();//record array starts
                        for(Id key : IdToBASMap.keySet()){
                            if(solutionIdToSPMap.containsKey(key)){
                                Solution_Pricing__c sp=solutionIdToSPMap.get(key);
                                Body_Armor_Solution__c bas=IdToBASMap.get(key);
                                gen.writeStartObject();
                                    gen.writeStringField('baSolutionID', key);
                                    gen.writeStringField('iosBASolutionID',sp.Select_HAP_Solution__r.Body_Armor_Solution_ID_iOS__c);
                                    gen.writeStringField('baSolutionPricingID',sp.id);
                                    gen.writeStringField('name',sp.name);
                                    gen.writeStringField('iosBASolutionPricingID', sp.Solution_package_id_iOS__c);
                                    if(sp.Cost_Of_Outer_Carrier__c<>null){
                                        gen.writeNumberField('costOfOuterCarrier', sp.Cost_Of_Outer_Carrier__c);
                                    }
                                    else{
                                        gen.writeNumberField('costOfOuterCarrier', 0);
                                    }
                                    if(sp.Cost_Of_SAP_Pouches__c<>null){
                                        gen.writeNumberField('costOfPouches', sp.Cost_Of_SAP_Pouches__c);
                                    }
                                    else{
                                        gen.writeNumberField('costOfPouches', 0);
                                    }
                                    if(sp.Cost_Comment__c<>null){
                                        gen.writeStringField('costComment', sp.Cost_Comment__c);
                                    }
                                    else{
                                        gen.writeStringField('costComment', '');
                                    }
                                    if(sp.HAP_Material_Wastage__c<>null){
                                        gen.writeNumberField('hapMaterialWastage', sp.HAP_Material_Wastage__c);
                                    }
                                    else{
                                        gen.writeNumberField('hapMaterialWastage', 0);
                                    }
                                    /*if(sp.Material_Wastage_Comment__c<>null){
                                        gen.writeStringField('wastageComment', sp.Material_Wastage_Comment__c);
                                    }
                                    else{*/
                                        gen.writeStringField('wastageComment', '');
                                    //}
                                    if(sp.BAM_Margin__c<>null){
                                        gen.writeNumberField('bamMargin', sp.BAM_Margin__c);
                                    }
                                    else{
                                        gen.writeNumberField('bamMargin', 0);
                                    }
                                    gen.writeFieldName('materials');
                                        gen.writeStartArray();//materials array starts
                                            gen.writeStartObject();//back plate object starts
                                                gen.writeStringField('hapType', 'Back Plate');
                                                if(!String.isBlank(bas.Material_Master_BP__r.Name)){
                                                    gen.writeStringField('materialName',bas.Material_Master_BP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('materialName','');
                                                }
                                                if(!String.isBlank(bas.Material_Master_BP__c)){
                                                    gen.writeStringField('materialID',bas.Material_Master_BP__c);
                                                }
                                                else{
                                                    gen.writeStringField('materialID','');
                                                }
                                                
                                                if(bas.BP_Material_Price__c<>null){
                                                    gen.writeNumberField('materialPrice', bas.BP_Material_Price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('materialPrice', 0);
                                                }
                                                if(!String.isBlank(bas.Backing_Material_BP__r.Name)){
                                                    gen.writeStringField('backingMaterial',bas.Backing_Material_BP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('backingMaterial','');
                                                }
                                                if(!String.isBlank(bas.Backing_Material_BP__c)){
                                                    gen.writeStringField('bmMaterialID',bas.Backing_Material_BP__c);
                                                }
                                                else{
                                                    gen.writeStringField('bmMaterialID','');
                                                }
                                                
                                                if(bas.BP_backing_material_price__c<>null){
                                                    gen.writeNumberField('backingMaterialPrice', bas.BP_backing_material_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('backingMaterialPrice', 0);
                                                }
                                                if(bas.BackingLayerPrice_BP__c<>null){
                                                    gen.writeNumberField('priceForBackingLayer', bas.BackingLayerPrice_BP__c);
                                                }
                                                else{
                                                    gen.writeNumberField('priceForBackingLayer', 0);
                                                }
                                                if(bas.BP_miscellaneous_price__c<>null){
                                                    gen.writeNumberField('miscPrice', bas.BP_miscellaneous_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('miscPrice', 0);
                                                }
                                            gen.writeEndObject();//back plate object ends
                                            gen.writeStartObject();//side plate object starts
                                                gen.writeStringField('hapType', 'Side Plate');
                                                if(!String.isBlank(bas.Material_Master_SP__r.Name)){
                                                    gen.writeStringField('materialName',bas.Material_Master_SP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('materialName','');
                                                }
                                                if(!String.isBlank(bas.Material_Master_SP__c)){
                                                    gen.writeStringField('materialID',bas.Material_Master_SP__c);
                                                }
                                                else{
                                                    gen.writeStringField('materialID','');
                                                }
                                                if(bas.SP_Material_Price__c<>null){
                                                    gen.writeNumberField('materialPrice', bas.SP_Material_Price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('materialPrice', 0);
                                                }
                                                if(!String.isBlank(bas.Backing_Material_SP__r.Name)){
                                                    gen.writeStringField('backingMaterial',bas.Backing_Material_SP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('backingMaterial','');
                                                }
                                                if(!String.isBlank(bas.Backing_Material_SP__c)){
                                                    gen.writeStringField('bmMaterialID',bas.Backing_Material_SP__c);
                                                }
                                                else{
                                                    gen.writeStringField('bmMaterialID','');
                                                }
                                                if(bas.SP_backing_material_price__c<>null){
                                                    gen.writeNumberField('backingMaterialPrice', bas.SP_backing_material_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('backingMaterialPrice', 0);
                                                }
                                                if(bas.BackingLayerPrice_SP__c<>null){
                                                    gen.writeNumberField('priceForBackingLayer', bas.BackingLayerPrice_SP__c);
                                                }
                                                else{
                                                    gen.writeNumberField('priceForBackingLayer', 0);
                                                }
                                                if(bas.SP_miscellaneous_price__c<>null){
                                                    gen.writeNumberField('miscPrice', bas.SP_miscellaneous_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('miscPrice', 0);
                                                }
                                            gen.writeEndObject();//side plate object ends
                                            gen.writeStartObject();//front plate object starts
                                                gen.writeStringField('hapType', 'Front Plate');
                                                if(!String.isBlank(bas.Material_Master_FP__r.Name)){
                                                    gen.writeStringField('materialName',bas.Material_Master_FP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('materialName','');
                                                }
                                                if(!String.isBlank(bas.Material_Master_FP__c)){
                                                    gen.writeStringField('materialID',bas.Material_Master_FP__c);
                                                }
                                                else{
                                                    gen.writeStringField('materialID','');
                                                }
                                                if(bas.FP_Material_Price__c<>null){
                                                    gen.writeNumberField('materialPrice', bas.FP_Material_Price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('materialPrice', 0);
                                                }
                                                if(!String.isBlank(bas.Backing_Material_FP__r.Name)){
                                                    gen.writeStringField('backingMaterial',bas.Backing_Material_FP__r.Name);
                                                }
                                                else{
                                                    gen.writeStringField('backingMaterial','');
                                                }
                                                if(!String.isBlank(bas.Backing_Material_FP__c)){
                                                    gen.writeStringField('bmMaterialID',bas.Backing_Material_FP__c);
                                                }
                                                else{
                                                    gen.writeStringField('bmMaterialID','');
                                                }
                                                if(bas.FP_backing_material_price__c<>null){
                                                    gen.writeNumberField('backingMaterialPrice', bas.FP_backing_material_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('backingMaterialPrice', 0);
                                                }
                                                if(bas.BackingLayerPrice_FP__c<>null){
                                                    gen.writeNumberField('priceForBackingLayer', bas.BackingLayerPrice_FP__c);
                                                }
                                                else{
                                                    gen.writeNumberField('priceForBackingLayer', 0);
                                                }
                                                if(bas.FP_miscellaneous_price__c<>null){
                                                    gen.writeNumberField('miscPrice', bas.FP_miscellaneous_price__c);
                                                }
                                                else{
                                                    gen.writeNumberField('miscPrice', 0);
                                                }
                                            gen.writeEndObject();//front plate object ends
                                        gen.writeEndArray();//materials array ends
                                    gen.writeFieldName('totalPrice');
                                        gen.writeStartArray();//totalPrice array starts
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'XS');
                                                if(sp.Total_cost_of_Body_Armour_for_size_XS__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_XS__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'S');
                                                if(sp.Total_cost_of_Body_Armour_for_size_S__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_S__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'XL');
                                                if(sp.Total_cost_of_Body_Armour_for_size_XL__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_XL__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'XXL');
                                                if(sp.Total_cost_of_Body_Armour_for_size_XXL__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_XXL__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'L');
                                                if(sp.Total_cost_of_Body_Armour_for_size_L__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_L__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                            gen.writeStartObject();
                                                gen.writeStringField('size', 'M');
                                                if(sp.Total_cost_of_Body_Armour_for_size_M__c<>null){
                                                    gen.writeNumberField('cost', sp.Total_cost_of_Body_Armour_for_size_M__c);
                                                }
                                                else{
                                                    gen.writeNumberField('cost', 0);
                                                }
                                            gen.writeEndObject();
                                        gen.writeEndArray();//totalPrice array ends 
                                gen.writeEndObject();
                            }
                        }
                    gen.writeEndArray();//record array ends
            gen.writeEndObject();//json ends
            
            prettyJson=gen.getAsString(); 
            system.debug('@@@@@prettyJson' + prettyJson); 
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('535'),'535',prettyJson,null,'No Error',null);
        }
        catch(Exception e){
           System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
        }
    }
}
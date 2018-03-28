/*******************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns values to populate SAP Solution Pricing
********************************************************************************/


@RestResource(urlMapping='/PopulateSAPSolutionPricing/*')
global class CtrlPopulateSAPSolutionPricingService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    Set<Id> sapSolIdList = new Set<Id>();
    Map<String,Decimal> spMap = new Map<String, Decimal>();
    Map<Id,List<Material_Type__c>> sapMat = new Map<Id,List<Material_Type__c>>();
    String prettyJson = '';
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());
        Wrapper bsWrap = (Wrapper) JSON.deserialize(req.requestBody.toString(), Wrapper.class); 
        
        for(String key : bsWrap.baSolutionID){
            sapSolIdList.add(key);
        }
        
         system.debug('=========='+sapSolIdList);
        List<Material_Type__c> matTypeList = [select id,Name,Material_used__c,SAP_Material__c,SAP_Material__r.name,Price_UOM__c,Number_of_Layers__c,Material_Price_SAP__c,
                                              Body_Armor_SAP_Solution__c from Material_Type__c where Body_Armor_SAP_Solution__c in : (sapSolIdList)];
        
        system.debug('=========='+matTypeList);
        if(matTypeList.size()>0)
        {
               for(Material_Type__c mt : matTypeList)
                {
                    List<Material_Type__c> temp;
                    if(sapMat.containsKey(mt.Body_Armor_SAP_Solution__c)){
                        temp=sapMat.get(mt.Body_Armor_SAP_Solution__c);
                    }
                    else{
                        temp=new List<Material_Type__c>();
                    }
                    temp.add(mt);
                    sapMat.put(mt.Body_Armor_SAP_Solution__c,temp);
                } 
        }
        
        List<Solution_Pricing__c> sapSolPriceList=  [SELECT id, Active__c,Name,BA_Configuration__c,Select_SAP_Solution__c,Select_SAP_Solution__r.Body_Armor_Solution_ID_iOS__c,Cost_Of_Outer_Carrier__c,Cost_Of_SAP_Pouches__c,
                                                     SAP_Material_Wastage__c,BAM_Margin__c,Cost_Comment__c,Material_Wastage_Comment__c,Total_cost_of_Body_Armour_for_size_XS__c,
                                                     Total_cost_of_Body_Armour_for_size_S__c,Total_cost_of_Body_Armour_for_size_M__c,Total_cost_of_Body_Armour_for_size_L__c,
                                                     Total_cost_of_Body_Armour_for_size_XL__c,Total_cost_of_Body_Armour_for_size_XXL__c,Solution_package_id_iOS__c, LastModifiedDate 
                                                     from Solution_Pricing__c WHERE BA_Configuration__c=:bsWrap.bacConfigurationID and recordType.name = 'SAP Solution Pricing' and 
                                                     Select_SAP_Solution__c IN: sapSolIdList AND active__c = true limit 1000];
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();//json starts
            gen.writeStringField('bacConfigurationID',bsWrap.bacConfigurationID);
            gen.writeStringField('spRecordType','SAP Solution');
            gen.writeFieldName('records');
                gen.writeStartArray();//records array starts
                
        if(sapSolPriceList.size()>0){
            for(Solution_Pricing__c sp :sapSolPriceList ){
                if(sp.Total_cost_of_Body_Armour_for_size_XS__c != null){
                    spMap.put('XS',sp.Total_cost_of_Body_Armour_for_size_XS__c);
                }
                if(sp.Total_cost_of_Body_Armour_for_size_S__c != null){
                    spMap.put('S',sp.Total_cost_of_Body_Armour_for_size_S__c);
                }
                if(sp.Total_cost_of_Body_Armour_for_size_M__c != null){
                    spMap.put('M',sp.Total_cost_of_Body_Armour_for_size_M__c);
                }
                if(sp.Total_cost_of_Body_Armour_for_size_L__c != null){
                    spMap.put('L',sp.Total_cost_of_Body_Armour_for_size_L__c);
                }
                if(sp.Total_cost_of_Body_Armour_for_size_XL__c != null){
                    spMap.put('XL',sp.Total_cost_of_Body_Armour_for_size_XL__c);
                }
                if(sp.Total_cost_of_Body_Armour_for_size_XXL__c != null){
                    spMap.put('XXL',sp.Total_cost_of_Body_Armour_for_size_XXL__c);
                }
                
                                            gen.writeStartObject();//pricing object starts
                                                gen.writeStringField('baSolutionID',sp.Select_SAP_Solution__c);
                								gen.writeStringField('iosBASolutionID',sp.Select_SAP_Solution__r.Body_Armor_Solution_ID_iOS__c);
                                                gen.writeStringField('name',sp.Name);
                                                gen.writeBooleanField('active', sp.Active__c);
                                                gen.writeStringField('iosBASolutionPricingID',sp.Solution_package_id_iOS__c);
                                                gen.writeStringField('baSolutionPricingID',sp.Id);
                                                gen.writeNumberField('costOfOuterCarrier',sp.Cost_Of_Outer_Carrier__c);
                                                gen.writeNumberField('costOfPouches',sp.Cost_Of_SAP_Pouches__c);
                                                if(!String.isBlank(sp.Cost_Comment__c)){
                                                    gen.writeStringField('costComment',sp.Cost_Comment__c);
                                                }
                                                else{
                                                    gen.writeStringField('costComment','');
                                                }
                                                if(sp.SAP_Material_Wastage__c<>null){
                                                    gen.writeNumberField('sapMaterialWastage',sp.SAP_Material_Wastage__c);
                                                }
                                                else{
                                                    gen.writeNumberField('sapMaterialWastage',0);
                                                }
                                                if(!String.isBlank(sp.Material_Wastage_Comment__c)){
                                                    gen.writeStringField('wastageComment',sp.Material_Wastage_Comment__c);
                                                }
                                                else{
                                                    gen.writeStringField('wastageComment','');
                                                } 
                                                if(sp.BAM_Margin__c<>null){
                                                    gen.writeNumberField('bamMargin',sp.BAM_Margin__c);
                                                }
                                                else{
                                                    gen.writeNumberField('bamMargin',0);
                                                }
                                                gen.writeDateTimeField('lastSync',sp.LastModifiedDate);
                                                    
                                                    gen.writeFieldName('materials');
                                                    gen.writeStartArray();//materials array starts
                                                        if(sapMat.containsKey(sp.Select_SAP_Solution__c))
                                                        {
                                                            for(Material_Type__c mt : sapMat.get(sp.Select_SAP_Solution__c))
                                                            {
                                                                gen.writeStartObject();
                                                                    if(!String.isBlank(mt.SAP_Material__c))
                                                                    {
                                                                        gen.writeStringField('materialID',mt.SAP_Material__c);
                                                                        gen.writeStringField('recordID',mt.SAP_Material__c);//for custom partner material logic
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeStringField('materialID','');
                                                                        gen.writeStringField('recordID',mt.Id);//for custom partner material logic
                                                                    }
                                                                    
                                                                    if(!String.isBlank(mt.Number_of_Layers__c))
                                                                    {
                                                                        gen.writeStringField('noOfLayers',mt.Number_of_Layers__c);
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeStringField('noOfLayers','');
                                                                    }
                                                                    if(!String.isBlank(mt.SAP_Material__r.name))
                                                                    {
                                                                        gen.writeStringField('materialName',mt.SAP_Material__r.name);
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeStringField('materialName',mt.Name);//for custom partner material logic
                                                                    }
                                                                    if(mt.Price_UOM__c <> null)
                                                                    {
                                                                        gen.writeNumberField('unitPrice',mt.Price_UOM__c);
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeNumberField('unitPrice',0);
                                                                    }
                                                                    if(mt.Material_Price_SAP__c <> null)
                                                                    {
                                                                        gen.writeNumberField('materialPrice',mt.Material_Price_SAP__c);
                                                                    }
                                                                    else
                                                                    {
                                                                        gen.writeNumberField('materialPrice',0);
                                                                    }
                                                                gen.writeEndObject();   
                                                            }
                                                        }
                                                    gen.writeEndArray();//materials array ends
                                                    gen.writeFieldName('totalPrice');
                                                        gen.writeStartArray();//total price array starts
                                                            for(String size: spMap.keyset())
                                                            {
                                                                if(spMap.containsKey(size))
                                                                {
                                                                    gen.writeStartObject();
                                                                        gen.writeStringField('size',size);
                                                                        gen.writeNumberField('cost', spMap.get(size));
                                                                    gen.writeEndObject();
                                                                }
                                                            
                                                            }
                                                        gen.writeEndArray();//total price array ends
                                            gen.writeEndObject();//pricing object ends                  
            }                              
        } 
        gen.writeEndArray();//records array ends
        gen.writeEndObject();//json ends
        prettyJson = gen.getAsString(); 
        system.debug('@@@@@prettyJson' + prettyJson); 
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('536'),'536',prettyJson,  null, 'No Error',null);
     
     }
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!', null, null,null, '203', null);
    }
}

    public Class Wrapper
    {
        public String bacConfigurationID;
        public List<String> baSolutionID; 
    }

}
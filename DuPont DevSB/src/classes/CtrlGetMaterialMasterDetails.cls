/*******************************************************************************
(C)2015
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns the all Material Details.
 ********************************************************************************/

@RestResource(urlMapping = '/MaterialMaster/*')
global class CtrlGetMaterialMasterDetails{

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
    	CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    	RestRequest req = RestContext.request;
    	String materialJson = '';
      	Integer count=1;
      	Map<String, List <Material_Master__c>> materialTypeMap = new Map<String, List <Material_Master__c>>(); 
          
    	try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            List<Material_Master__c> materialList = [select id,Name,Areal_Density__c,Material_Type__c,Material_Quality__c,Price_in_Euro__c,Price__c,Volume_Density__c,Material_Orign__c,Thickness__c,GSM__c from Material_Master__c limit 1000];
            
            for(Material_Master__c mat : materialList){
                if(String.isBlank(mat.Material_Quality__c)){
                   mat.Material_Quality__c = 'blankValue';
                }
                List<Material_Master__c> tempMaterial;
                if(materialTypeMap.containsKey(mat.Material_Quality__c)){
                    tempMaterial=materialTypeMap.get(mat.Material_Quality__c);
                }
                else{
                    tempMaterial=new List<Material_Master__c>();
                }
                tempMaterial.add(mat);
                materialTypeMap.put(mat.Material_Quality__c,tempMaterial);
            }
            materialList.clear();
            for(String mQ : materialTypeMap.keyset()){
                if(!mQ.equalsIgnoreCase('Yarns') && !mQ.equalsIgnoreCase('Fabric') && !mQ.equalsIgnoreCase('Structure'))
                {
                    materialList.addAll(materialTypeMap.get(mQ));
                }
            }    
            materialList.addAll(materialTypeMap.get('Yarns'));
            materialList.addAll(materialTypeMap.get('Fabric'));
            materialList.addAll(materialTypeMap.get('Structure'));
            
            if(!materialList.isEmpty()){
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject(); // json starts here
                        gen.writeFieldName('materials');
                            gen.writeStartObject();
                                gen.writeFieldName('records');
                                    gen.writeStartArray();
                                        for(Material_Master__c matDetails : materialList)
                                        {
                                            gen.writeStartObject();
                                                gen.writeStringField('materialID',matDetails.id);
                                                gen.writeStringField('materialName',matDetails.name);
                                                if(!String.isBlank(matDetails.Material_Type__c))
                                                {
                                                    gen.writeStringField('materialType',matDetails.Material_Type__c);
                                                }
                                                else
                                                {
                                                    gen.writeStringField('materialType','');
                                                }
                                                if(!String.isBlank(matDetails.Material_Quality__c) && !(matDetails.Material_Quality__c.equalsIgnoreCase('blankValue')))
                                                {
                                                    gen.writeStringField('materialQuality',matDetails.Material_Quality__c);
                                                 
                                                }
                                                else
                                                {
                                                    gen.writeStringField('materialQuality','');
                                                }
                                                if(!String.isBlank(matDetails.Material_Orign__c))
                                                {
                                                    gen.writeStringField('materialOrigin',matDetails.Material_Orign__c);
                                                }
                                                else
                                                {
                                                    gen.writeStringField('materialOrigin','');
                                                }
                                                if(matDetails.Areal_Density__c !=null)
                                                {
                                                    gen.writeNumberField('arealDensity',matDetails.Areal_Density__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('arealDensity',0);
                                                }
                                                if(matDetails.Thickness__c!=null)
                                                {
                                                    gen.writeNumberField('thickness',matDetails.Thickness__c);
                                                }
                                                
                                                else
                                                {
                                                    gen.writeNumberField('thickness',0);
                                                }
                                                
                                                if(matDetails.GSM__c!=null)
                                                {
                                                    gen.writeNumberField('gsm',matDetails.GSM__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('gsm',0);
                                                }
                                                
                                                if(matDetails.Volume_Density__c!=null)
                                                {
                                                    gen.writeNumberField('volumeDensity',matDetails.Volume_Density__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('volumeDensity',0);
                                                }
                                                
                                                if(matDetails.Price__c!=null)
                                                {
                                                    gen.writeNumberField('priceInUSD',matDetails.Price__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('priceInUSD',0);
                                                } 
                                            
                                                if(matDetails.Price_in_Euro__c!=null)
                                                {
                                                    gen.writeNumberField('priceInEuro',matDetails.Price_in_Euro__c);
                                                }
                                                else
                                                {
                                                    gen.writeNumberField('priceInEuro',0);
                                                }
                                            // adding sequence based on material quality
                                            if(!String.isBlank(matDetails.Material_Quality__c)){
                                                system.debug('material quality -->' + matDetails.Material_Quality__c + '--material type--'+matDetails.Material_Type__c);
                                                    if((matDetails.Material_Type__c.equalsIgnoreCase('SAP')) && matDetails.Material_Quality__c.equalsIgnoreCase('Yarns') ){
                                                         gen.writeNumberField('sequence',count++);
                                                        
                                                    }
                                                    else if((matDetails.Material_Type__c.equalsIgnoreCase('SAP')) && matDetails.Material_Quality__c.equalsIgnoreCase('Fabric') ){
                                                    
                                                        gen.writeNumberField('sequence',count++);
                                                    }
                                                    else if((matDetails.Material_Type__c.equalsIgnoreCase('SAP')) && matDetails.Material_Quality__c.equalsIgnoreCase('Structure') ){
                                                    
                                                        gen.writeNumberField('sequence',count++);
                                                    }
                                            } 
                                            gen.writeEndObject();
                                        }
                                    gen.writeEndArray();
                            gen.writeEndObject();
                    gen.writeEndObject();
        
                materialJson = gen.getAsString();   
                system.debug('@@@@@materialJson  : ' + materialJson );
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('515'),'515', materialJson,null, 'No Error',null);
			}
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('201'),null,null, 'Data not found!', null, '201',null);
            }
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null,null, '203',null);
        }
    }
}
/*********************************************************************************************
(C)2015
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class insert the record in BA Solution object for SAP Solution record type with selected values of 
                fields.
 ********************************************************************************************/

@RestResource(urlMapping='/SAPSolution/*')
global class CtrlSAPSolutionService{

public class Wrapper
{
     public String baSolutionID;
     public String bacConfigurationID;
     public String name;
     public String basRecordType;
     public Boolean active;
     public String iosBASolutionID;
     public Decimal sapThickness;
     public Decimal arealDensity;  
     public DateTime lastSync;
     public List<Cls_weight> weight;
     public String solutionComment;
     public List<MaterialsTypeWrapper> materials;
 

    public Wrapper(List<MaterialsTypeWrapper> materials, List<Cls_weight> weight)
    {        

        this.materials = materials;
        this.weight = weight;
    }
    
}
public class MaterialsTypeWrapper
{
     public String materialName;
     public String noOfLayers;
     public Decimal gsm;
     public String comment;
     public String materialOrigin;
     public String materialID;
}


global class Cls_weight
{
    public String size;
    public Decimal value;
}


@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String rjson ='';
      Map<String, Id> mapRecordTypes = new Map<String, Id>();
    String soql ='SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = \'Body_Armor_Solution__c\' AND IsActive = TRUE';
    List<SObject> results;
    try {
        results = Database.query(soql);
    } catch (Exception ex) {
        results = new List<SObject>();
    }
    for (SObject rt : results) { 
            // This RecordType IS available to the running user,
            //      so add it to our map of RecordTypeIds by DeveloperName
            mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')),rt.Id);
    }
   try
   {
        system.debug('req.requestBody : ' + req.requestBody.toString());
        List<Wrapper> tWrap = (List<Wrapper>) JSON.deserialize(req.requestBody.toString(), List<Wrapper>.class);
        List<Body_Armor_Solution__c> sapSolList = new List<Body_Armor_Solution__c>();
        List<Material_Type__c> matTypeList = new List<Material_Type__c>();
        Set<Id> sapSolutionIdUpdate = new Set<Id>();
        Map<Id, Body_Armor_Solution__c> baSapmap1 = new Map<Id, Body_Armor_Solution__c>();
        List<Solution_Pricing__c> spListToDelete=new List<Solution_Pricing__c>();
        Boolean dataNotUpdated = false; 
        
        for(Wrapper wrap1 : tWrap)
        {
            if(!String.isBlank(wrap1.baSolutionID) /*&& (wrap1.lastSync != null)*/)
            {
                 sapSolutionIdUpdate.add(wrap1.baSolutionID) ;
            }
        } 
        if(sapSolutionIdUpdate.size()>0)
        {
            List<Body_Armor_Solution__c> sapSolutionUpdateList = [select id, active__c,name,SAP_weight_of_XXL_size__c,
                                                                 SAP_weight_of_XL_size__c,SAP_weight_of_L_size__c,
                                                                 SAP_weight_of_M_size__c,SAP_weight_of_XS_size__c,SAP_weight_of_S_size__c,SAP_Thickness__c,Comments__c,Areal_Density__c,LastModifiedDate, 
                                                                 (Select id from Solution_Packages__r)
                                                                  from body_armor_Solution__c where id in :sapSolutionIdUpdate Limit 1000];
            for(Body_Armor_Solution__c solutionIds : sapSolutionUpdateList)
            {
                baSapmap1.put(solutionIds.Id,solutionIds);
                spListToDelete.addAll(solutionIds.Solution_Packages__r);
            }  
        }
        system.debug('spListToDelete size : ' + spListToDelete.size());
       if(spListToDelete.size()>0){
           //delete the pricing record when any change to parent solution is done once the pricing has been started
           delete spListToDelete; 
       }
       
        for(Wrapper wrap1 : tWrap)
        {
            if(String.isBlank(wrap1.baSolutionID))
            {
        			system.debug('------>inside blank solutionID---'+wrap1.baSolutionID);
                    Body_Armor_Solution__c bas = new Body_Armor_Solution__c();
                    bas.Active__c = wrap1.active;
                    bas.name = wrap1.name;
                    bas.Body_Armor_Solution_ID_iOS__c=wrap1.iosBASolutionID;
                    bas.BA_Configuration__c = wrap1.bacConfigurationID;
                  //  bas.Body_Armor_Solution_ID_iOS__c = wrap1.iosId;
                    if(wrap1.basRecordType == 'SAP Solution')
                    {
                        bas.recordTypeId = mapRecordTypes.get('SAP_Solution');
                            bas.SAP_Thickness__c = wrap1.sapThickness;
                            bas.Areal_Density__c = wrap1.arealDensity;
                            bas.Comments__c = wrap1.solutionComment;
                            
                                for(Cls_weight sapDetail : wrap1.weight)
                                {
                                    if(sapDetail.size == 'XS')
                                    {
                                        bas.SAP_weight_of_XS_size__c = sapDetail.value;
                                    }
                                    else if(sapDetail.size == 'S')
                                    {
                                        bas.SAP_weight_of_S_size__c = sapDetail.value;
                                    }
                                    else if(sapDetail.size == 'M')
                                    {
                                        bas.SAP_weight_of_M_size__c = sapDetail.value;
                                    }
                                    else if(sapDetail.size == 'L')
                                    {
                                        bas.SAP_weight_of_L_size__c = sapDetail.value;
                                    }
                                    else if(sapDetail.size == 'XL')
                                    {                   
                                        bas.SAP_weight_of_XL_size__c = sapDetail.value;
                                    }
                                    else if(sapDetail.size == 'XXL')
                                    {
                                        bas.SAP_weight_of_XXL_size__c = sapDetail.value;
                                    }
                                }
                                sapSolList.add(bas);

                    }
                }  
                else if(!String.isBlank(wrap1.baSolutionID) && (wrap1.lastSync != null))
                {
                    if(baSapmap1.containsKey(wrap1.baSolutionID) && !baSapmap1.isEmpty() && wrap1.lastSync > baSapmap1.get(wrap1.baSolutionID).lastmodifieddate)
                    {
                        system.debug('-------create solution---');
                           dataNotUpdated = true;
                            Body_Armor_Solution__c bas = baSapmap1.get(wrap1.baSolutionID);
                                
                            bas.Active__c = wrap1.active;
                            bas.name = wrap1.name;
                            bas.SAP_Thickness__c = wrap1.sapThickness;
                            bas.Areal_Density__c = wrap1.arealDensity;
                            bas.Comments__c = wrap1.solutionComment;
                            
                            for(Cls_weight sapDetail : wrap1.weight)
                                        {
                                            if(sapDetail.size == 'XS')
                                            {
                                                bas.SAP_weight_of_XS_size__c = sapDetail.value;
                                            }
                                            else if(sapDetail.size == 'S')
                                            {
                                                bas.SAP_weight_of_S_size__c = sapDetail.value;
                                            }
                                            else if(sapDetail.size == 'M')
                                            {
                                                bas.SAP_weight_of_M_size__c = sapDetail.value;
                                            }
                                            else if(sapDetail.size == 'L')
                                            {
                                                bas.SAP_weight_of_L_size__c = sapDetail.value;
                                            }
                                            else if(sapDetail.size == 'XL')
                                            {                   
                                                bas.SAP_weight_of_XL_size__c = sapDetail.value;
                                            }
                                            else if(sapDetail.size == 'XXL')
                                            {
                                                bas.SAP_weight_of_XXL_size__c = sapDetail.value;
                                            }
                                        }
                                sapSolList.add(bas);
                    }
                    else if(!baSapmap1.isEmpty() && (wrap1.lastSync < baSapmap1.get(wrap1.baSolutionID).lastmodifieddate || wrap1.lastSync == baSapmap1.get(wrap1.baSolutionID).lastmodifieddate ))
                    {
                        system.debug('====== inside else =====');
                        rjson = 'data is already updated!';
                    
                    }           
                }
                
            
        }    
        // Code for insertion or updation of sap solution.
         List<Id> sapSolId = new List<Id>();
            if(sapSolList.size()>0)
            {
                upsert sapSolList Id;
                
                 for(Body_Armor_Solution__c sapMat: [select id, name, Body_Armor_Solution_ID_iOS__c from Body_Armor_Solution__c where id in :(sapSolList)])
                {
                   sapSolId.add(sapMat.id);
                }
            }
            
            if(sapSolutionIdUpdate.size()>0 && dataNotUpdated)
            {
                List<Material_Type__c> matList = [select id, name from Material_Type__c where Body_Armor_SAP_Solution__c in : (sapSolutionIdUpdate)];
                if(matList.size()>0)
                {
                    database.delete(matList);
                }
            }
                
            List<Material_Master__c> newMaterialList = new List<Material_Master__c>();
            for(Wrapper wrap1 : tWrap)
            {
                if(wrap1.materials.size()>0)
                {
                        for(MaterialsTypeWrapper sapMaterial : wrap1.materials)
                        {
                            if(String.isBlank(sapMaterial.materialID) && !sapMaterial.materialOrigin.equalsIgnoreCase('Partner'))
                                {
                                    Material_Master__c matMaster = new Material_Master__c ();
                                    matMaster.name = sapMaterial.materialName;
                                    matMaster.Material_Orign__c = sapMaterial.materialOrigin;
                                    matMaster.Material_Type__c='SAP';
                                    matMaster.GSM__c=sapMaterial.gsm;
                                    newMaterialList.add(matMaster);
                                }
                        }
                }   
            }
            Map<String,Id> newMaterialMap = new Map<String,Id>();
            Set<Id> matIds = new Set<Id>();
            if(newMaterialList.size()>0)
            {
                database.insert(newMaterialList);

                for(Material_Master__c mm :newMaterialList )
                {
                    system.debug('------inside material master');
                    newMaterialMap.put(mm.name,mm.id);
                    matIds.add(mm.id);
                    
                    system.debug('------inside material master map---'+newMaterialMap);
                }
            }
            
            for(Wrapper wrap1 : tWrap)
            {
                if(wrap1.materials.size()>0)
                {
                        for(MaterialsTypeWrapper sapMaterial : wrap1.materials)
                        {
                            
                                Material_Type__c materialTypes = new Material_Type__c();
                            
                                materialTypes.Name = sapMaterial.materialName; 
                                materialTypes.Number_of_Layers__c = sapMaterial.noOfLayers;
                                materialTypes.GSM__c = sapMaterial.gsm;
                                materialTypes.Material_used__c = sapMaterial.materialOrigin;
                                materialTypes.Comments__c = sapMaterial.comment;
                                if(sapSolId.size()>0)
                                {
                                materialTypes.Body_Armor_SAP_Solution__c = sapSolId[0];
                                }
                                
                                if(!String.isBlank(sapMaterial.materialID))
                                {
                                materialTypes.SAP_Material__c = sapMaterial.materialID;
                                }
                                else if(String.isBlank(sapMaterial.materialID) && newMaterialMap.containsKey(sapMaterial.materialName))
                                {
                                    materialTypes.SAP_Material__c = newMaterialMap.get(sapMaterial.materialName);
                                }
                                matTypeList.add(materialTypes);
                                
                        }
                }
            }
            List<Material_Master__c> materialData = new List<Material_Master__c>();
            
            if(matTypeList.size()>0)
            {
                system.debug('========== '+matTypeList);
                database.insert(matTypeList);
                
             }   
                materialData = [select id, name, Areal_Density__c,Blacklist_Country__c,GSM__c,Material_ID__c,Material_Orign__c,Material_Type__c,Price__c,Thickness__c,Volume_Density__c from Material_Master__c where id in : (matIds) limit 1000];
           
            if(sapSolList.size()>0){
                List<Body_Armor_Solution__c> baSolList=[select id,name,(select id,name,SAP_Material__c,Number_of_Layers__c,
                                                        GSM__c,Material_used__c,Comments__c,Areal_Density__c,Price_UOM__c,
                                                        Thickness__c from Materials_Type__r),Comments__c,Areal_Density__c,
                                                        BA_Configuration__c,LastModifiedDate,Body_Armor_Solution_ID_iOS__c from body_armor_Solution__c 
                                                        where id in :sapSolId Limit 1000];
                if(baSolList.size()>0)
                {
                    system.debug('----------baSolList---'+baSolList);
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                        //if(!String.isBlank(baSolList[0].BA_Configuration__c))
                        gen.writeStringField('bacConfigurationID',baSolList[0].BA_Configuration__c);
                        gen.writeStringField('baSolutionID',baSolList[0].Id); 
                        gen.writeStringField('basRecordType','SAP Solution');
                        gen.writeStringField('name',baSolList[0].Name);
                        gen.writeStringField('iosBASolutionID',baSolList[0].Body_Armor_Solution_ID_iOS__c);
                        if(!String.isBlank(baSolList[0].Comments__c))
                        {
                            gen.writeStringField('solutionComments',baSolList[0].Comments__c);
                        }
                        else{
                            gen.writeStringField('solutionComments','');
                        }
                        gen.writeDateTimeField('lastSync', baSolList[0].LastModifiedDate);
                        
                        if(materialData.size()>0)
                        {
                            gen.writeFieldName('material');
                            gen.writeStartArray();
                                for(Material_Master__c mt : materialData)
                                {
                                        gen.writeStartObject();
                                            if(!String.isBlank(mt.id))
                                            {
                                            gen.writeStringField('materialID',mt.id);
                                            }
                                            else
                                            {
                                                gen.writeStringField('materialID','');
                                            }
                                            if(!String.isBlank(mt.Material_Type__c))
                                            {
                                                gen.writeStringField('materialType',mt.Material_Type__c);
                                            }
                                            else
                                            {
                                                gen.writeStringField('materialType','SAP');
                                            }
                                            if(!String.isBlank(mt.Material_Orign__c))
                                            {
                                                gen.writeStringField('materialOrigin',mt.Material_Orign__c);
                                            }
                                            else
                                            {
                                                gen.writeStringField('materialOrigin','');
                                            }
                                            
                                            if(!String.isBlank(mt.name))
                                            {
                                                gen.writeStringField('materialName',mt.name);
                                            }
                                            else
                                            {
                                                gen.writeStringField('materialName','');
                                            }
                                                                                  
                                            if(mt.Areal_Density__c<>null)
                                            {
                                                gen.writeNumberField('arealDensity',mt.Areal_Density__c);
                                            }
                                            else
                                            {
                                                gen.writeNumberField('arealDensity',0);
                                            }
                                        if(mt.GSM__c<>null)
                                            {
                                                gen.writeNumberField('gsm',mt.GSM__c);
                                            }
                                            else
                                            {
                                                gen.writeNumberField('gsm',0);
                                            }
                                            if(mt.Price__c <>null)
                                            {
                                                gen.writeNumberField('price',mt.Price__c);
                                            }
                                            else
                                            {
                                                gen.writeNumberField('price', 0);
                                            }
                                            if(mt.Volume_Density__c <> null)
                                            {
                                                gen.writeNumberField('volumeDensity',mt.Volume_Density__c);
                                            }
                                            else
                                            {
                                                gen.writeNumberField('volumeDensity',0);
                                            }
                                            if(mt.Thickness__c <> null)
                                            {
                                                gen.writeNumberField('thickness',mt.Thickness__c);
                                            }
                                            else
                                            {
                                                gen.writeNumberField('thickness', 0);
                                            }
                                        gen.writeEndObject();
    
                                }
                        
                            gen.writeEndArray();  
                        }
                    gen.writeEndObject();   
                    rjson = gen.getAsString();
                }
           }
           system.debug('@@@@@rjson' + rjson); 
           if(!String.isBlank(tWrap[0].baSolutionID)){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('528'),'528', rjson, null, '200','null');         
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('529'),'529', rjson, null, '200','null');         
            } 
          
    }
         catch(Exception e)
         {
            System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert or Update failed!',null, null, null, '203');
        }
  }
}
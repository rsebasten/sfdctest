/*********************************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class insert the record in Functional design requirements object with selected values of fields.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields and wrapper structure           6/30/2016 
 ********************************************************************************************/

@RestResource(urlMapping = '/FDR/*')
global class CtrlFDRequirementService{

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Id> mapRecordTypes = new Map<String, Id>();
        String soql ='SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = \'Functional_Design_Requirement__c\' AND IsActive = TRUE';
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
        try{ 
            system.debug('req.requestBody : ' + req.requestBody.toString());  
            List<FDRWrapper> fdrWrap = (List<FDRWrapper>) JSON.deserialize(req.requestBody.toString(), List<FDRWrapper>.class);
            List<Functional_Design_Requirement__c> newFDR = new List<Functional_Design_Requirement__c>();
			
            for(FDRWrapper f : fdrWrap){
				Functional_Design_Requirement__c fdr = new Functional_Design_Requirement__c();
                fdr.name= f.name;
                fdr.Active__c= f.Active;
                fdr.BA_Configuration__c = f.bacConfigurationID;
                if(f.fdrRecordType == 'Body Armor Functional Design'){
                  /* PS1060931 - start */  
                    fdr.recordTypeId = mapRecordTypes.get('Body_Armor_Functional_Design');
                    fdr.Back_plate__c = f.backPlate;
                    fdr.Front_plate__c = f.frontPlate;
                    fdr.Side_plate__c = f.sidePlate;
                    fdr.Plate_Pockets__c = f.platePockets;
                    fdr.Color__c = f.color;
                    fdr.Shoulder__c = f.shoulder;
                    fdr.Neck_and_Collar__c = f.neckAndCollar;
                    fdr.Pouches__c = f.pouches;
                    fdr.Quick_Release__c = f.quickRelease;
                    fdr.Groin__c = f.groin;
                    fdr.Groin_Shape__c = f.groinShape;
                    fdr.Molle_System__c = f.molleSystem;
					
                    if(!f.selectedSizes.isEmpty()){
                      
                        for(cls_selectedSize selected : f.selectedSizes){
                            if(selected.size == 'XS'){
                               fdr.XS_Size__c = selected.value; 
                            }
                            else if(selected.size == 'S'){
                                fdr.S_Size__c = selected.value;
                            }
                            else if(selected.size == 'M'){
                                fdr.M_Size__c = selected.value;
                            }
                            else if(selected.size == 'L'){
                                fdr.L_Size__c = selected.value;
                            }
                            else if(selected.size == 'XL'){
                                fdr.XL_Size__c = selected.value;
                            }
                            else{
                                fdr.XXL_Size__c = selected.value;
                            }
                            
                        }
                    }
                   
					for(cls_dimension dim : f.dimension){
						if(dim.name == 'XS'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_XS_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_XS_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_XS_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_XS_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_XS_size_E__c=val.value;
														}
													}
											}
						if(dim.name == 'S'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_S_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_S_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_S_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_S_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_S_size_E__c=val.value;
														}
													}
											}
						if(dim.name == 'M'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_M_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_M_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_M_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_M_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_M_size_E__c=val.value;
														}
													}
											}
						if(dim.name == 'L'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_L_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_L_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_L_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_L_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_L_size_E__c=val.value;
														}
													}
											}
						if(dim.name == 'XL'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_XL_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_XL_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_XL_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_XL_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_XL_size_E__c=val.value;
														}
													}
											}
						if(dim.name == 'XXL'){
							for(cls_value val : dim.value){
														if(val.name=='A'){
															fdr.Dimension_of_XXL_size_A__c=val.value;
														}
														else if(val.name=='B'){
															fdr.Dimension_of_XXL_size_B__c=val.value;
														}
														else if(val.name=='C'){
															fdr.Dimension_of_XXL_size_C__c=val.value;
														}
														else if(val.name=='D'){
															fdr.Dimension_of_XXL_size_D__c=val.value;
														}
														else if(val.name=='E'){
															fdr.Dimension_of_XXL_size_E__c=val.value;
														}
													}
											}
					}
                     /* PS1060931 - new fields*/
					for(cls_surfaceAreaOfBodyArmor sa : f.surfaceAreaOfBodyArmor){
						if(sa.name == 'XS'){
							fdr.torsoSurfaceArea_XS__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_XS__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_XS__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_XS__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_XS__c = sa.totalSurfaceArea;
						}
						if(sa.name == 'S'){
							fdr.torsoSurfaceArea_S__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_S__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_S__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_S__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_S__c = sa.totalSurfaceArea;
						}
						if(sa.name == 'M'){
							fdr.torsoSurfaceArea_M__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_M__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_M__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_M__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_M__c = sa.totalSurfaceArea;
						}
						if(sa.name == 'L'){
							fdr.torsoSurfaceArea_L__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_L__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_L__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_L__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_L__c = sa.totalSurfaceArea;
						}
						if(sa.name == 'XL'){
							fdr.torsoSurfaceArea_XL__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_XL__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_XL__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_XL__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_XL__c = sa.totalSurfaceArea;
						}
						if(sa.name == 'XXL'){
							fdr.torsoSurfaceArea_XXL__c = sa.torsoSurfaceArea;
							fdr.groinSurfaceArea_XXL__c = sa.groinSurfaceArea;
							fdr.shoulderLRSurfaceArea_XXL__c = sa.shoulderLRSurfaceArea;
							fdr.neckCollarSurfaceArea_XXL__c = sa.neckCollarSurfaceArea;
							fdr.Surface_Area_of_Body_Armour_XXL__c = sa.totalSurfaceArea;
						}
                   	}
					for(cls_surfacearea sa : f.surfaceAreaOfPounch){
                                        system.debug('!!!!!!!!!!! surface area : ' + sa.name);
                                                if(sa.name=='XS'){
                                                    fdr.Surface_Area_of_SAP_Pouch_XS__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='S'){
                                                    fdr.Surface_Area_of_SAP_Pouch_S__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='L'){
                                                    fdr.Surface_Area_of_SAP_Pouch_L__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='M'){
                                                    fdr.Surface_Area_of_SAP_Pouch_M__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XL'){
                                                    fdr.Surface_Area_of_SAP_Pouch_XL__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XXL'){
                                                    fdr.Surface_Area_of_SAP_Pouch_XXL__c=sa.surfaceArea;
                                                }
                                    }
                 
                }
                 /* PS1060931 - end*/
                if(f.fdrRecordType == 'HAP Functional Design'){
                    //parsing the requestBody
                            fdr.recordTypeId = mapRecordTypes.get('HAP_Functional_Design');
                            for(cls_records rec : f.records){
                                if(rec.hapType.equalsIgnoreCase('Front Plate')){
                                    fdr.Keep_FP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                    fdr.Plate_Design_of_front_plate__c=rec.plateDesign;
                                    fdr.Thickness_Limit_of_front_plate__c=rec.thicknessLimit;
                                    for(cls_surfacearea sa : rec.surfacearea){
                                                if(sa.name=='XS'){
                                                    fdr.Surface_Area_FP_size_XS__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='S'){
                                                    fdr.Surface_Area_FP_size_S__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='L'){
                                                    fdr.Surface_Area_FP_size_L__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='M'){
                                                    fdr.Surface_Area_FP_size_M__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XL'){
                                                    fdr.Surface_Area_FP_size_XL__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XXL'){
                                                    fdr.Surface_Area_FP_size_XXL__c=sa.surfaceArea;
                                                }
                                    }
                                    for(cls_dimension dim : rec.dimension){
                                        system.debug('@@@@@@@ dim size : ' + dim.name);
                                        if(dim.name=='XS'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_xs_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_xs_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_xs_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_xs_size_D__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='S'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_s_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_s_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_s_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_s_size_D__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='M'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_M_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_M_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_M_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_M_size_D__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='L'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_L_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_L_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_L_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_L_size_D__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_XL_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_XL_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_XL_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_XL_size_D__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XXL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A'){
                                                    fdr.Dimension_of_FP_for_XXL_size_A__c=val.value;
                                                }
                                                else if(val.name=='B'){
                                                    fdr.Dimension_of_FP_for_XXL_size_B__c=val.value;
                                                }
                                                else if(val.name=='C'){
                                                    fdr.Dimension_of_FP_for_XXL_size_C__c=val.value;
                                                }
                                                else if(val.name=='D'){
                                                    fdr.Dimension_of_FP_for_XXL_size_D__c=val.value;
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                if(rec.hapType.equalsIgnoreCase('Back Plate')){
                                    fdr.Keep_BP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                    fdr.Plate_Design_of_BP__c=rec.plateDesign;
                                    fdr.Thickness_Limit_of_BP__c=rec.thicknessLimit;
                                    for(cls_dimension dim : rec.dimension){
                                        system.debug('@@@@@@@ dim size : ' + dim.name);
                                        if(dim.name=='XS'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_xs_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_xs_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_xs_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_xs_size_H__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='S'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_s_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_s_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_s_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_s_size_H__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='M'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_M_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_M_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_M_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_M_size_H__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='L'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_L_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_L_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_L_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_L_size_H__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XL_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XL_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XL_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XL_size_H__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XXL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XXL_size_E__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XXL_size_F__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XXL_size_G__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_BP_for_XXL_size_H__c=val.value;
                                                }
                                            }
                                        }
                                    }
                                    for(cls_surfacearea sa : rec.surfaceArea){
                                        system.debug('!!!!!!!!!!! surface area : ' + sa.name);
                                                if(sa.name=='XS'){
                                                    fdr.Surface_Area_BP_size_XS__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='S'){
                                                    fdr.Surface_Area_BP_size_S__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='L'){
                                                    fdr.Surface_Area_BP_size_L__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='M'){
                                                    fdr.Surface_Area_BP_size_M__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XL'){
                                                    fdr.Surface_Area_BP_size_XL__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XXL'){
                                                    fdr.Surface_Area_BP_size_XXL__c=sa.surfaceArea;
                                                }
                                    }
                                }
                                if(rec.hapType.equalsIgnoreCase('Side Plate')){
                                    fdr.Keep_SP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                    fdr.Plate_Design_of_SP__c=rec.plateDesign;
                                    fdr.Thickness_Limit_of_SP__c=rec.thicknessLimit;
                                    for(cls_dimension dim : rec.dimension){
                                        system.debug('@@@@@@@ dim size : ' + dim.name);
                                        if(dim.name=='XS'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_xs_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_xs_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_xs_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_xs_size_L__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='S'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_s_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_s_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_s_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_s_size_L__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='M'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_M_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_M_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_M_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_M_size_L__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='L'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_L_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_L_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_L_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_L_size_L__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XL_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XL_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XL_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XL_size_L__c=val.value;
                                                }
                                            }
                                        }
                                        if(dim.name=='XXL'){
                                            for(cls_value val : dim.value){
                                                if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XXL_size_I__c=val.value;
                                                }
                                                else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XXL_size_J__c=val.value;
                                                }
                                                else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XXL_size_K__c=val.value;
                                                }
                                                else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                    fdr.Dimension_of_SP_for_XXL_size_L__c=val.value;
                                                }
                                            }
                                        }
                                    }
                                    for(cls_surfacearea sa : rec.surfaceArea){
                                        system.debug('!!!!!!!!!!! surface area : ' + sa.name);
                                                if(sa.name=='XS'){
                                                    fdr.Surface_Area_SP_size_XS__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='S'){
                                                    fdr.Surface_Area_SP_size_S__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='L'){
                                                    fdr.Surface_Area_SP_size_L__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='M'){
                                                    fdr.Surface_Area_SP_size_M__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XL'){
                                                    fdr.Surface_Area_SP_size_XL__c=sa.surfaceArea;
                                                }
                                                else if(sa.name=='XXL'){
                                                    fdr.Surface_Area_SP_size_XXL__c=sa.surfaceArea;
                                                }
                                    }
                                }
                            }
                }
                if(f.fdrRecordType =='Other Requirement'){
                    fdr.recordTypeId = mapRecordTypes.get('Other_Requirement');
                    fdr.Flammability_Protection_Needed__c = f.flammabilityProtection;
                    fdr.Flammability_Tests__c = f.flammabilityStandard;
                    if(f.flammabilityStandard.equalsIgnoreCase('Other')){
                        fdr.Flammability_Standard_Other_Comment__c = f.flammabilityStandardOtherComment;   
                    }
                    fdr.Comment_Flammability__c = f.flammabilityComment;
                    fdr.Panel_Flexibility__c =  f.standardizedPanel;
                    fdr.Panel_Flexibility_Reference__c = f.panelFlexibilityReference;
                    if(f.panelFlexibilityReference.equalsIgnoreCase('Other')){
                        fdr.Panel_Flexibility_Reference_OtherComment__c= f.panelFlexibilityOtherComment;   
                    }
                    fdr.Comment_Flexibility__c = f.panelComment;
                    fdr.Third_party_test_certificate_required__c = f.requireThirdPartyCertification;
                    if(f.standardName.size()>0){
                       fdr.StandardName__c = String.valueOf(f.standardName); 
                    }
                    else{
                        fdr.StandardName__c=null;
                    } 
                    fdr.Comment_Lab_test__c = f.standardComment;
                    if(f.testLaboratory.size()>0){
                       fdr.Third_party_testing_standards__c = String.valueOf(f.testLaboratory); 
                    }
                    else{
                        fdr.Third_party_testing_standards__c=null;
                    }
                    fdr.Test_Lab_Comment__c=f.testLabComment;                
                    for(Other_Weight otherWt :f.weight){
                        if(otherWt.size == 'XS')
                        {
                            fdr.Outer_carrier_weight_XS__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_XS__c = otherWt.sapPouch; 
                        }
                        
                        if(otherWt.size == 'S')
                        {
                            fdr.Outer_carrier_weight_S__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_S__c = otherWt.sapPouch;
                             
                        }
                        
                        if(otherWt.size == 'M')
                        {
                            fdr.Outer_carrier_weight_M__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_M__c = otherWt.sapPouch;
                             
                        }
                        
                        if(otherWt.size == 'L')
                        {
                            fdr.Outer_carrier_weight_L__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_L__c = otherWt.sapPouch;
                             
                        }
                        
                        if(otherWt.size == 'XL')
                        {
                            fdr.Outer_carrier_weight_XL__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_XL__c = otherWt.sapPouch;
                             
                        }
                        
                        if(otherWt.size == 'XXL')
                        {
                            fdr.Outer_carrier_weight_XXL__c = otherWt.outerCarrier;
                            fdr.SAP_pouch_weight_XXL__c = otherWt.sapPouch;
                             
                        }
                    }
                    for(Other_WeightLimit wtLimit : f.weightLimit)
                    {
                            if(wtLimit.size == 'XS')
                            {
                                fdr.Weight_limit_SAP_XS__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_XS__c = wtLimit.hap;
                            }
                            if(wtLimit.size == 'S')
                            {
                                fdr.Weight_limit_SAP_S__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_S__c = wtLimit.hap;
                            }
                            if(wtLimit.size == 'M')
                            {
                                fdr.Weight_limit_SAP_M__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_M__c = wtLimit.hap;
                            }
                            if(wtLimit.size == 'L')
                            {
                                fdr.Weight_limit_SAP_L__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_L__c = wtLimit.hap;
                            }
                            if(wtLimit.size == 'XL')
                            {
                                fdr.Weight_limit_SAP_XL__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_XL__c = wtLimit.hap;
                            }
                            if(wtLimit.size == 'XXL')
                            {
                                fdr.Weight_limit_SAP_XXL__c = wtLimit.sap;
                                fdr.Weight_limit_HAP_XXL__c = wtLimit.hap;
                            }               
                    }
                    
                    for(Other_TotalWeightLimit totalWt : f.totalWeightLimit)
                    {
                            if(totalWt.size == 'XS')
                            {
                                fdr.Total_weight_body_armor_XS__c = totalWt.weightLimit ;
                            }
                            
                            if(totalWt.size == 'S')
                            {
                                fdr.Total_weight_body_armor_S__c = totalWt.weightLimit ;
                            }
                            if(totalWt.size == 'M')
                            {
                                fdr.Total_weight_body_armor_M__c = totalWt.weightLimit ;
                            }
                            if(totalWt.size == 'L')
                            {
                                fdr.Total_weight_body_armor_L__c = totalWt.weightLimit ;
                            }
                            if(totalWt.size == 'XL')
                            {
                                fdr.Total_weight_body_armor_XL__c = totalWt.weightLimit ;
                            }
                            if(totalWt.size == 'XXL')
                            {
                                fdr.Total_weight_body_armor_XXL__c = totalWt.weightLimit ;
                            }
                    } 
              }
            newFDR.add(fdr);
        }
            if(newFDR.size()>0){
                database.insert(newFDR); 
            }
            List<Functional_Design_Requirement__c> finalFDR=new List<Functional_Design_Requirement__c>([select id,lastmodifieddate,BA_Configuration__c from Functional_Design_Requirement__c where Id IN:newFDR]);
            JSONGenerator gen = JSON.createGenerator(true);
            if(newFDR.size()>0){
                    gen.writeStartObject();
                        gen.writeStringField('bacConfigurationID',fdrWrap[0].bacConfigurationID);
                        if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('Body Armor Functional Design')){
                            gen.writeStringField('sapID',finalFDR[0].Id);
                        }
                        else if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('HAP Functional Design')){
                            gen.writeStringField('hapID',finalFDR[0].Id);
                        }
                        else if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('Other Requirement')){
                            gen.writeStringField('id',finalFDR[0].Id);
                        }
                        gen.writeStringField('fdrRecordType',fdrWrap[0].fdrRecordType);
                        gen.writeDateTimeField('lastSync',finalFDR[0].lastmodifieddate);
                    gen.writeEndObject();     
            }
            String prettyJson='';
            prettyJson=gen.getAsString();
            system.debug('prettyJson : ' + prettyJson); 
            if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('Body Armor Functional Design')){           
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('513'),'513', prettyJson, null, '200','null');         
            }
            else if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('HAP Functional Design')){         
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('512'),'512', prettyJson, null, '200','null');         
            }
            else {            
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('545'),'545', prettyJson, null, '200','null');         
            }
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());        
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert failed!',null, null, null, '203');     
        }   
    }
    //WRAPPER CLASS
    public class FDRWrapper{
	
		public String bacConfigurationID;   
        public String fdrRecordType;    
        public String name; 
        public boolean active;
		
		// Body Armor Design
		 /* PS1060931 - start*/
        public Boolean backPlate;
        public Boolean frontPlate;
        public Boolean sidePlate;
        public Boolean platePockets;
        public String color;
        public Boolean shoulder;
        public Boolean neckAndCollar;
        public Boolean pouches;
        public Boolean quickRelease;
        public Boolean groin;
        public String groinShape;
        public Boolean molleSystem;
		public List<cls_dimension> dimension;
		public List<cls_surfaceAreaOfBodyArmor> surfaceAreaOfBodyArmor;
		public List<cls_surfacearea> surfaceAreaOfPounch;
        public List<cls_selectedSize> selectedSizes;
         /* PS1060931 - end*/
        
		// for other requirements
        
        public boolean flammabilityProtection;
        public String flammabilityStandard;
        public String flammabilityComment;
        public String flammabilityStandardOtherComment;
        public Boolean standardizedPanel;
        public String panelFlexibilityReference;
        public String panelFlexibilityOtherComment;
        public String panelComment;
        public boolean requireThirdPartyCertification;
        public List<String> standardName;
        public String standardComment;
        public List<String> testLaboratory;
        public String testLabComment;
        public List<Other_Weight> weight;
        public List<Other_WeightLimit> weightLimit;
        public List<Other_TotalWeightLimit> totalWeightLimit;
		
  
		// for HAP	
        public List<cls_records> records;
        public FDRWrapper(List<cls_records> records, List<cls_surfaceAreaOfBodyArmor> surfaceAreaOfBodyArmor)
        {
			this.surfaceAreaOfBodyArmor = surfaceAreaOfBodyArmor;
            this.records = records;
        }
        
        public FDRWrapper(List<Other_Weight> weight,List<Other_WeightLimit> weightLimit,List<Other_TotalWeightLimit> totalWeightLimit)
        {
            this.weight = weight;
            this.weightLimit = weightLimit;
            this.totalWeightLimit = totalWeightLimit;
        } 
    }
    
    // surfaceArea of Body Armor
		
		public class cls_surfaceAreaOfBodyArmor{
		
		public String name;
		public Decimal torsoSurfaceArea;
		public Decimal shoulderLRSurfaceArea;
		public Decimal neckCollarSurfaceArea;
		public Decimal groinSurfaceArea;
		public Decimal totalSurfaceArea;
		
		}
     public class Other_Weight
        {
            public String size;
            public Decimal outerCarrier;
            public Decimal sapPouch;
            
            public Other_Weight(String size,Decimal OuterCarrier,Decimal sapPouch)
            {
                this.size = size;
                this.OuterCarrier = OuterCarrier;
                this.sapPouch = sapPouch;
            }
        
        }
        
        public class Other_WeightLimit
        {
            public String size;
            public Decimal sap;
            public Decimal hap;
            
            public Other_WeightLimit(String size,Decimal sap,Decimal hap)
            {
                this.size = size;
                this.sap = sap;
                this.hap = hap;
            }
        
        }
        public class Other_TotalWeightLimit
        {
            public String size;
            public Decimal weightLimit;
            
            public Other_TotalWeightLimit(String size,Decimal weightLimit)
            {
                this.size = size;
                this.weightLimit = weightLimit;
            }
        
        } 
    
    public class cls_records {
            public String hapType;  
            public Boolean keepDimensionsSameForAllTheSize; 
            public String plateDesign;  
            public Decimal thicknessLimit;  
            public List<cls_dimension> dimension;
            public List<cls_surfacearea> surfacearea;
        
            public cls_records(List<cls_dimension> dimension,List<cls_surfacearea> surfacearea)
            {
                this.dimension = dimension;
                this.surfacearea = surfacearea;
            }
        }
        public class cls_dimension {
            public String name; 
            public List<cls_value> value;
            
            public cls_dimension(List<cls_value> value)
            {
                this.value = value;
            }
        }
        public class cls_value {
            public String name;
            public Decimal value;   
        }
        public class cls_surfaceArea {
            public String name; 
            public Decimal surfaceArea;   
        }
    public class cls_selectedSize{
        public String size;
        public Boolean value;
        
    }
}
/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class will update the record in Function design object with selected values of fields.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields and wrapper structure           6/30/2016 
 ********************************************************************************************/
 

@RestResource(urlMapping = '/UpdateFDR/*')
global class CtrlUpdateFDRService{

    global class UpdateFDRWrapper{
        
        public String bacConfigurationID;   
        public String fdrRecordType;    
        public String name; 
        public boolean active;
        public DateTime lastSync;
        /* PS1060931 start */
        		// Body Armor Design
		public String id;
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
        /* PS1060931 end */
            //other requirement
            public boolean flammabilityProtection;
            public String flammabilityStandard;
            public String flammabilityComment;
            public Boolean standardizedPanel;
            public String panelFlexibilityReference;
            public String panelComment;
            public String  flammabilityStandardOtherComment;
            public String panelFlexibilityOtherComment;
            public boolean requireThirdPartyCertification;
            public List<String> standardName;
            public String standardComment;
            public List<String> testLaboratory;
            public String testLabComment;
            public List<Other_Weight> weight;
            public List<Other_WeightLimit> weightLimit;
            public List<Other_TotalWeightLimit> totalWeightLimit;
        
            //HAP
            public List<cls_records> records;
            public UpdateFDRWrapper(List<cls_records> records){
                this.records = records;
            }
            public UpdateFDRWrapper(List<Other_Weight> weight,List<Other_WeightLimit> weightLimit,
                                    List<Other_TotalWeightLimit> totalWeightLimit){
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
    	public class Other_Weight{
            public String size;
            public Decimal outerCarrier;
            public Decimal sapPouch;
            
            public Other_Weight(String size,Decimal OuterCarrier,Decimal sapPouch){
                this.size = size;
                this.OuterCarrier = OuterCarrier;
                this.sapPouch = sapPouch;
            }
        }
        public class Other_WeightLimit{
            public String size;
            public Decimal sap;
            public Decimal hap;
            
            public Other_WeightLimit(String size,Decimal sap,Decimal hap){
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
            public decimal value;   
        }
        public class cls_surfacearea {
            public String name; 
            public Decimal surfaceArea;   
        }  
        public class cls_selectedSize{
            public String size;
            public Boolean value;
        
    	}

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Boolean updateSuccess = false;
        String responseCode = null;
        List<String> result = new List<String>();
        
        try{ 
        	List<UpdateFDRWrapper> fdrWrap = (List<UpdateFDRWrapper>)JSON.deserialize(req.requestBody.toString(),List<UpdateFDRWrapper>.class);
            system.debug('req.requestBody : ' + req.requestBody.toString());        
            List<Id> fdrId = new List<Id>();
            List<Functional_Design_Requirement__c> upFDR = new List<Functional_Design_Requirement__c>();
            Map<Id, Functional_Design_Requirement__c> map1 = new Map<Id, Functional_Design_Requirement__c>();
            Map<string, Functional_Design_Requirement__c> recordTypeToFDRMap = new Map<string, Functional_Design_Requirement__c>();
            
            for(UpdateFDRWrapper fdrL : fdrWrap){
                fdrId.add(fdrL.Id);
            }
            List<Functional_Design_Requirement__c> fdrConfiguration1 = [Select id,name,RecordTypeId,Active__c,Back_plate__c,lastmodifieddate,Front_plate__c,Side_plate__c,Plate_Pockets__c,Color__c,
                                                                        Shoulder__c,Neck_and_Collar__c,Groin__c,Pouches__c,Quick_Release__c,Groin_Shape__c,Molle_System__c,Dimension_of_L_size_A__c,
                                                                        Dimension_of_L_size_B__c,Dimension_of_L_size_C__c,Dimension_of_L_size_D__c,Dimension_of_L_size_E__c,
                                                                        Dimension_of_M_Size_A__c,Dimension_of_M_Size_B__c,
                                                                        Dimension_of_M_Size_C__c,Dimension_of_M_Size_D__c,Dimension_of_M_Size_E__c,Dimension_of_S_size_A__c,Dimension_of_S_size_B__c,Dimension_of_S_size_C__c,Dimension_of_S_size_D__c,
                                                                        Dimension_of_S_size_E__c,Dimension_of_XL_size_A__c,
                                                                        Dimension_of_XL_size_B__c,Dimension_of_XL_size_C__c,Dimension_of_XL_size_D__c,Dimension_of_XL_size_E__c,Dimension_of_XS_size_A__c,Dimension_of_XS_size_B__c,Dimension_of_XS_size_C__c,
                                                                        Dimension_of_XS_size_D__c,Dimension_of_XS_size_E__c,Dimension_of_XXL_size_A__c,Dimension_of_XXL_size_B__c,Dimension_of_XXL_size_C__c,Dimension_of_XXL_size_D__c,Dimension_of_XXL_size_E__c,
                                                                        Surface_Area_of_Body_Armour_L__c,Surface_Area_of_Body_Armour_M__c,Surface_Area_of_Body_Armour_S__c,Surface_Area_of_Body_Armour_XL__c,
                                                                        Surface_Area_of_Body_Armour_XS__c,Surface_Area_of_Body_Armour_XXL__c,Surface_Area_of_SAP_Pouch_L__c,Surface_Area_of_SAP_Pouch_M__c,Surface_Area_of_SAP_Pouch_S__c,Surface_Area_of_SAP_Pouch_XL__c,Surface_Area_of_SAP_Pouch_XS__c,Surface_Area_of_SAP_Pouch_XXL__c,
                                                                        Dimension_of_BP_for_L_size_E__c,Dimension_of_BP_for_L_size_F__c,Dimension_of_BP_for_L_size_G__c,Dimension_of_BP_for_L_size_H__c,Dimension_of_BP_for_M_size_E__c,Dimension_of_BP_for_M_size_F__c,Dimension_of_BP_for_M_size_G__c,Dimension_of_BP_for_M_size_H__c,
                                                                        Dimension_of_BP_for_S_size_E__c,Dimension_of_BP_for_S_size_F__c,Dimension_of_BP_for_S_size_G__c,Dimension_of_BP_for_S_size_H__c,Dimension_of_BP_for_XL_size_E__c,
                                                                        Dimension_of_BP_for_XL_size_F__c,Dimension_of_BP_for_XL_size_G__c,Dimension_of_BP_for_XL_size_H__c,Dimension_of_BP_for_XS_size_E__c,Dimension_of_BP_for_XS_size_F__c,Dimension_of_BP_for_XS_size_G__c,Dimension_of_BP_for_XS_size_H__c,
                                                                        Dimension_of_BP_for_XXL_size_E__c,Dimension_of_BP_for_XXL_size_F__c,Dimension_of_BP_for_XXL_size_G__c,Dimension_of_BP_for_XXL_size_H__c,Dimension_of_FP_for_L_size_A__c,Dimension_of_FP_for_L_size_B__c,Dimension_of_FP_for_L_size_C__c,Dimension_of_FP_for_L_size_D__c,Dimension_of_FP_for_M_size_A__c,
                                                                        Dimension_of_FP_for_M_size_B__c,Dimension_of_FP_for_M_size_C__c,Dimension_of_FP_for_M_size_D__c,Dimension_of_FP_for_S_size_A__c,Dimension_of_FP_for_S_size_B__c,Dimension_of_FP_for_S_size_C__c,Dimension_of_FP_for_S_size_D__c,Dimension_of_FP_for_XL_size_A__c,Dimension_of_FP_for_XL_size_B__c,Dimension_of_FP_for_XL_size_C__c,Dimension_of_FP_for_XL_size_D__c,
                                                                        Dimension_of_FP_for_xs_size_A__c,Dimension_of_FP_for_xs_size_B__c,Dimension_of_FP_for_XS_size_C__c,Dimension_of_FP_for_XS_size_D__c,Dimension_of_FP_for_XXL_size_A__c,Dimension_of_FP_for_XXL_size_B__c,Dimension_of_FP_for_XXL_size_C__c,Dimension_of_FP_for_XXL_size_D__c,Dimension_of_SP_for_L_size_I__c,Dimension_of_SP_for_L_size_J__c,Dimension_of_SP_for_L_size_K__c,
                                                                        Dimension_of_SP_for_L_size_L__c,Dimension_of_SP_for_M_size_I__c,Dimension_of_SP_for_M_size_J__c,Dimension_of_SP_for_M_size_K__c,Dimension_of_SP_for_M_size_L__c,Dimension_of_SP_for_S_size_I__c,Dimension_of_SP_for_S_size_J__c,Dimension_of_SP_for_S_size_K__c,Dimension_of_SP_for_S_size_L__c,Dimension_of_SP_for_XL_size_I__c,Dimension_of_SP_for_XL_size_J__c,
                                                                        Dimension_of_SP_for_XL_size_K__c,Dimension_of_SP_for_XL_size_L__c,Dimension_of_SP_for_XS_size_I__c,Dimension_of_SP_for_XS_size_J__c,Dimension_of_SP_for_XS_size_K__c,Dimension_of_SP_for_XS_size_L__c,Dimension_of_SP_for_XXL_size_I__c,Dimension_of_SP_for_XXL_size_J__c,Dimension_of_SP_for_XXL_size_K__c,Dimension_of_SP_for_XXL_size_L__c,Keep_BP_dimensions_same_for_all_the_size__c,
                                                                        Keep_FP_dimensions_same_for_all_the_size__c,Keep_SP_dimensions_same_for_all_the_size__c,Surface_Area_BP_size_L__c,Surface_Area_BP_size_M__c,Surface_Area_BP_size_S__c,Surface_Area_BP_size_XL__c,Surface_Area_BP_size_XS__c,Surface_Area_BP_size_XXL__c,Surface_Area_FP_size_L__c,Surface_Area_FP_size_M__c,Surface_Area_FP_size_S__c,Surface_Area_FP_size_XL__c,Surface_Area_FP_size_XS__c,Surface_Area_FP_size_XXL__c,Surface_Area_SP_size_L__c,
                                                                        Surface_Area_SP_size_M__c,Surface_Area_SP_size_S__c,Surface_Area_SP_size_XL__c,Surface_Area_SP_size_XS__c,Surface_Area_SP_size_XXL__c,Plate_Design_of_BP__c,Plate_Design_of_front_plate__c,Plate_Design_of_SP__c,Thickness_Limit_of_BP__c,Thickness_Limit_of_front_plate__c,Thickness_Limit_of_SP__c,SAP_pouch_weight_L__c,SAP_pouch_weight_M__c,SAP_pouch_weight_S__c,SAP_pouch_weight_XL__c,SAP_pouch_weight_XS__c,SAP_pouch_weight_XXL__c,
                                                                        Total_weight_body_armor_L__c,Total_weight_body_armor_M__c,Total_weight_body_armor_S__c,Total_weight_body_armor_XL__c,Total_weight_body_armor_XS__c,Total_weight_body_armor_XXL__c,Weight_limit_HAP_L__c,Weight_limit_HAP_M__c,Weight_limit_HAP_S__c,Weight_limit_HAP_XL__c,Weight_limit_HAP_XS__c,Weight_limit_HAP_XXL__c,Weight_limit_SAP_L__c,Weight_limit_SAP_M__c,Weight_limit_SAP_S__c,Weight_limit_SAP_XL__c,Weight_limit_SAP_XS__c,Weight_limit_SAP_XXL__c,Flammability_Protection_Needed__c,
                                                                        Flammability_Protection_Standards__c,Outer_carrier_weight_L__c,Outer_carrier_weight_M__c,Outer_carrier_weight_S__c,Outer_carrier_weight_XL__c,Outer_carrier_weight_XS__c,Outer_carrier_weight_XXL__c,Comment_Flammability__c,Comment_Flexibility__c,Comment_Lab_test__c,Flammability_Tests__c,Flammability_Standard_Other_Comment__c,Panel_Flexibility_Reference_OtherComment__c 
                                                                        from Functional_Design_Requirement__c Where /*Id  in :(fdrId) Limit 1000*/ BA_Configuration__c=:fdrWrap[0].bacConfigurationID];
            
            for(Functional_Design_Requirement__c fdrConfig : fdrConfiguration1){
                map1.put(fdrConfig.Id,fdrConfig);
                recordTypeToFDRMap.put(fdrConfig.RecordTypeId,fdrConfig);
            }
            List<RecordType> rtList=[select id,developerName from RecordType where SObjectType='Functional_Design_Requirement__c'];
            Map<string,Id> rtNameToIdMap=new Map<string,Id>();
            for(RecordType rt : rtList){
                rtNameToIdMap.put(rt.developerName,rt.Id);
            }
            for(UpdateFDRWrapper f : fdrWrap){
                if(map1.containsKey(f.id) && !map1.isEmpty() &&  null !=f.lastSync && 
                   	f.lastSync > map1.get(f.id).LastModifiedDate){
                    if(f.fdrRecordType == 'Body Armor Functional Design'){
                        /* PS1060931 start */
                        Functional_Design_Requirement__c  fdr = map1.get(f.Id); 
                        fdr.Active__c= f.active;
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
                 			/* PS1060931 end */
                                       
                        //nullify the values for those plates which were deselected
                        Functional_Design_Requirement__c hapFDR=new Functional_Design_Requirement__c();
                        if(recordTypeToFDRMap.containsKey(rtNameToIdMap.get('HAP_Functional_Design'))){
                            hapFDR=recordTypeToFDRMap.get(rtNameToIdMap.get('HAP_Functional_Design'));
                            if(f.frontPlate==false){
                                hapFDR.Keep_FP_dimensions_same_for_all_the_size__c=false;
                                hapFDR.Plate_Design_of_front_plate__c='';
                                hapFDR.Thickness_Limit_of_front_plate__c=null;				
                                hapFDR.Dimension_of_FP_for_xs_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_xs_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_xs_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_xs_size_D__c=null;
                                hapFDR.Dimension_of_FP_for_s_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_s_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_s_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_s_size_D__c=null;
                                hapFDR.Dimension_of_FP_for_M_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_M_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_M_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_M_size_D__c=null;
                                hapFDR.Dimension_of_FP_for_L_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_L_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_L_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_L_size_D__c=null;
                                hapFDR.Dimension_of_FP_for_XL_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_XL_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_XL_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_XL_size_D__c=null;
                                hapFDR.Dimension_of_FP_for_XXL_size_A__c=null;				
                                hapFDR.Dimension_of_FP_for_XXL_size_B__c=null;				
                                hapFDR.Dimension_of_FP_for_XXL_size_C__c=null;	
                                hapFDR.Dimension_of_FP_for_XXL_size_D__c=null;
                                hapFDR.Surface_Area_FP_size_XS__c=null;
                                hapFDR.Surface_Area_FP_size_S__c=null;
                                hapFDR.Surface_Area_FP_size_M__c=null;
                                hapFDR.Surface_Area_FP_size_L__c=null;
                                hapFDR.Surface_Area_FP_size_XL__c=null;
                                hapFDR.Surface_Area_FP_size_XXL__c=null;
                            }
                        	if(f.sidePlate==false){
                                hapFDR.Keep_SP_dimensions_same_for_all_the_size__c=false;
                                hapFDR.Plate_Design_of_SP__c='';
                                hapFDR.Thickness_Limit_of_SP__c=null;						
                                hapFDR.Dimension_of_SP_for_xs_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_xs_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_xs_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_xs_size_L__c=null;
                                hapFDR.Dimension_of_SP_for_s_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_s_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_s_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_s_size_L__c=null;
                                hapFDR.Dimension_of_SP_for_M_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_M_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_M_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_M_size_L__c=null;
                                hapFDR.Dimension_of_SP_for_L_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_L_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_L_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_L_size_L__c=null;
                                hapFDR.Dimension_of_SP_for_XL_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_XL_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_XL_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_XL_size_L__c=null;
                                hapFDR.Dimension_of_SP_for_XXL_size_I__c=null;				
                                hapFDR.Dimension_of_SP_for_XXL_size_J__c=null;				
                                hapFDR.Dimension_of_SP_for_XXL_size_K__c=null;	
                                hapFDR.Dimension_of_SP_for_XXL_size_L__c=null;
                                hapFDR.Surface_Area_SP_size_XS__c=null;
                                hapFDR.Surface_Area_SP_size_S__c=null;
                                hapFDR.Surface_Area_SP_size_M__c=null;
                                hapFDR.Surface_Area_SP_size_L__c=null;
                                hapFDR.Surface_Area_SP_size_XL__c=null;
                                hapFDR.Surface_Area_SP_size_XXL__c=null;
                            }
                        	if(f.backPlate==false){
                                hapFDR.Keep_BP_dimensions_same_for_all_the_size__c=false;
                                hapFDR.Plate_Design_of_BP__c='';
                                hapFDR.Thickness_Limit_of_BP__c=null;						
                                hapFDR.Dimension_of_BP_for_xs_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_xs_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_xs_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_xs_size_H__c=null;
                                hapFDR.Dimension_of_BP_for_s_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_s_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_s_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_s_size_H__c=null;
                                hapFDR.Dimension_of_BP_for_M_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_M_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_M_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_M_size_H__c=null;
                                hapFDR.Dimension_of_BP_for_L_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_L_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_L_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_L_size_H__c=null;
                                hapFDR.Dimension_of_BP_for_XL_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_XL_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_XL_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_XL_size_H__c=null;
                                hapFDR.Dimension_of_BP_for_XXL_size_E__c=null;				
                                hapFDR.Dimension_of_BP_for_XXL_size_F__c=null;				
                                hapFDR.Dimension_of_BP_for_XXL_size_G__c=null;	
                                hapFDR.Dimension_of_BP_for_XXL_size_H__c=null;
                                hapFDR.Surface_Area_BP_size_XS__c=null;
                                hapFDR.Surface_Area_BP_size_S__c=null;
                                hapFDR.Surface_Area_BP_size_M__c=null;
                                hapFDR.Surface_Area_BP_size_L__c=null;
                                hapFDR.Surface_Area_BP_size_XL__c=null;
                                hapFDR.Surface_Area_BP_size_XXL__c=null;
                            }
                            upFDR.add(hapFDR);
                        }
                        upFDR.add(fdr);
                    }    
                    if(f.fdrRecordType == 'HAP Functional Design'){  
                       	Functional_Design_Requirement__c  fdr = map1.get(f.Id); 
                        fdr.name= f.name;
                        fdr.Active__c= f.Active;
                        for(cls_records rec : f.records){
                        	if(rec.hapType.equalsIgnoreCase('Front Plate')){
                                        fdr.Keep_FP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                        fdr.Plate_Design_of_front_plate__c=rec.plateDesign;
                                        fdr.Thickness_Limit_of_front_plate__c=rec.thicknessLimit;
                                        for(cls_dimension dim : rec.dimension){
                                            if(dim.name=='XS'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_xs_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_xs_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_xs_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_xs_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                            if(dim.name=='S'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_s_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_s_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_s_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_s_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                            if(dim.name=='M'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_M_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_M_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_M_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_M_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                            if(dim.name=='L'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_L_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_L_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_L_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_L_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                            if(dim.name=='XL'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XL_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XL_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XL_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XL_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                            if(dim.name=='XXL'){
                                                for(cls_value val : dim.value){
                                                    if(val.name=='A' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XXL_size_A__c=val.value;
                                                    }
                                                    else if(val.name=='B' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XXL_size_B__c=val.value;
                                                    }
                                                    else if(val.name=='C' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XXL_size_C__c=val.value;
                                                    }
                                                    else if(val.name=='D' && !String.isBlank(String.valueOf(val.value))){
                                                        fdr.Dimension_of_FP_for_XXL_size_D__c=val.value;
                                                    }
                                                }
                                            }
                                        }
                                        for(cls_surfacearea sa : rec.surfaceArea){            
                                                    if(sa.name=='XS' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_XS__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='S' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_S__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='L' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_L__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='M' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_M__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_XL__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XXL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_FP_size_XXL__c=sa.surfaceArea;
                                                    }
                                        }
                                    }
                            if(rec.hapType.equalsIgnoreCase('Back Plate')){
                                        fdr.Keep_BP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                        fdr.Plate_Design_of_BP__c=rec.plateDesign;
                                        fdr.Thickness_Limit_of_BP__c=rec.thicknessLimit;
                                        for(cls_dimension dim : rec.dimension){
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
                                        for(cls_surfacearea sa : rec.surfacearea){
                                                    if(sa.name=='XS' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_XS__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='S' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_S__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='L' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_L__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='M' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_M__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_XL__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XXL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_BP_size_XXL__c=sa.surfaceArea;
                                                    }
                                        }
                                    }
                            if(rec.hapType.equalsIgnoreCase('Side Plate')){
                                        fdr.Keep_SP_dimensions_same_for_all_the_size__c=rec.keepDimensionsSameForAllTheSize;
                                        fdr.Plate_Design_of_SP__c=rec.plateDesign;
                                        fdr.Thickness_Limit_of_SP__c=rec.thicknessLimit;
                                        for(cls_dimension dim : rec.dimension){
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
                                                    if(sa.name=='XS' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_XS__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='S' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_S__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='L' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_L__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='M' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_M__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_XL__c=sa.surfaceArea;
                                                    }
                                                    else if(sa.name=='XXL' && !String.isBlank(String.valueOf(sa.surfaceArea))){
                                                        fdr.Surface_Area_SP_size_XXL__c=sa.surfaceArea;
                                                    }
                                        }
                                    }
                        }
                        upFDR.add(fdr);
                    }
                   if(f.fdrRecordType =='Other Requirement'){
                        Functional_Design_Requirement__c  fdr = map1.get(f.Id); 
                        fdr.name= f.name;
                        fdr.Active__c= f.Active;
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
                        for(Other_Weight otherWt :f.weight)
                        {
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
                        
                        for(Other_WeightLimit wtLimit : f.weightLimit){
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
                        upFDR.add(fdr);
                    }
                   if(upFDR.size()>0){ 
                      database.update(upFDR);
                   }
                   result.add('Success');
                   updateSuccess = true;
                }           
                else{
                   result.add('The data is already updated!');
                   updateSuccess  = false;
                }   
          	}     
        	system.debug('UpdateFDR Result' + result);  
            if(updateSuccess){
                if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('Body Armor Functional Design')){
                    return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('518'),'518',null, null, '200');             
                }
                else if(fdrWrap[0].fdrRecordType.equalsIgnoreCase('HAP Functional Design')){
                    return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('517'),'517',null, null, '200');             
                }
                else {
                    return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('545'),'545',null, null, '200');             
                }
            }
            else{
                 return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('204'),null,null,null, null, 'No Error');          
            }
        } 
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Update failed!',null, null, null, '203');
        }   
    }
}
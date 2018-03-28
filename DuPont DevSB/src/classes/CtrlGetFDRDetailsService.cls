/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class insert the record in Function design object with selected values of fields.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields and json structure           6/30/2016 
 ********************************************************************************************/
@RestResource(urlMapping = '/GetFDR/*')
global class CtrlGetFDRDetailsService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass doPost(){    
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String pretty = '';
    String prettyHAP = '';
    String prettyOther = '';
    
   // String completeFDR = '';
    Map<String,Decimal> surfaceArea_BodyArmor = new Map<String,Decimal>();
    Map<String,Decimal> surfaceArea_BodyArmor_BP = new Map<String,Decimal>();
    Map<String,Decimal> surfaceArea_BodyArmor_SP = new Map<String,Decimal>();
    Map<String,Decimal> surfaceArea_SapPouch = new Map<String,Decimal>();     
    Map<String,String> hapPlates = new Map<String,String>(); 
    List<String> dimensions = new List<String>{'XS','S','M','L','XL','XXL'};

    Map<String,Decimal> dimensions_map = new Map<String,Decimal>();
    Map<String,Decimal> dimensions_map_BP = new Map<String,Decimal>();
    Map<String,Decimal> dimensions_map_SP = new Map<String,Decimal>();
    Map<String,Decimal> sapWeightLimit= new Map<String,Decimal>();
    Map<String,Decimal> hapWeightLimit= new Map<String,Decimal>();
    Map<String,Decimal> outerCarrier= new Map<String,Decimal>();
    Map<String,Decimal> sapPouch= new Map<String,Decimal>();
    Map<String,Decimal> totalWeightLimit= new Map<String,Decimal>();
    JSONGenerator gen = JSON.createGenerator(true);
    JSONGenerator genHAP = JSON.createGenerator(true);
    JSONGenerator genOther = JSON.createGenerator(true);
    try{   
        system.debug('req.requestBody : ' + req.requestBody.toString());      
        FDRDimensionsWrapper fdrWrap = (FDRDimensionsWrapper) JSON.deserialize(req.requestBody.toString(), FDRDimensionsWrapper.class);
        List<Functional_Design_Requirement__c> newFDR = new List<Functional_Design_Requirement__c>();
        Map<String, List<Sobject>> rejustRecordTypes = new Map<String, List<Sobject>>();
        List<Functional_Design_Requirement__c> result= new List<Functional_Design_Requirement__c>();
        system.debug('fdrWrap');
        
        // Body Armor Functional Design
        
        if(fdrWrap.fdrRecordType == 'Body Armor Functional Design'){
            /* PS1060931 new fields added in query */
        result = [SELECT Id, name,Active__c,BA_Configuration__c,Back_plate__c,Front_plate__c,Side_plate__c,Plate_Pockets__c,Color__c,Shoulder__c,Neck_and_Collar__c,Pouches__c,Quick_Release__c,Groin__c,Groin_Shape__c,Molle_System__c,Dimension_of_L_size_A__c,Dimension_of_L_size_B__c,Dimension_of_L_size_C__c,Dimension_of_L_size_D__c,Dimension_of_L_size_E__c,Dimension_of_M_Size_A__c,Dimension_of_M_Size_B__c,Dimension_of_M_Size_C__c,Dimension_of_M_Size_D__c,Dimension_of_M_Size_E__c,Dimension_of_S_size_A__c,Dimension_of_S_size_B__c,Dimension_of_S_size_C__c,Dimension_of_S_size_D__c,Dimension_of_S_size_E__c,Dimension_of_XL_size_A__c,Dimension_of_XL_size_B__c,Dimension_of_XL_size_C__c,Dimension_of_XL_size_D__c,Dimension_of_XL_size_E__c,Dimension_of_XS_size_A__c,Dimension_of_XS_size_B__c,Dimension_of_XS_size_C__c,Dimension_of_XS_size_D__c,Dimension_of_XS_size_E__c,Dimension_of_XXL_size_A__c,Dimension_of_XXL_size_B__c,Dimension_of_XXL_size_C__c,Dimension_of_XXL_size_D__c,Dimension_of_XXL_size_E__c,Surface_Area_of_Body_Armour_L__c,Surface_Area_of_Body_Armour_M__c,Surface_Area_of_Body_Armour_S__c,Surface_Area_of_Body_Armour_XL__c,Surface_Area_of_Body_Armour_XS__c,Surface_Area_of_Body_Armour_XXL__c,Surface_Area_of_SAP_Pouch_L__c,Surface_Area_of_SAP_Pouch_M__c,Surface_Area_of_SAP_Pouch_S__c,Surface_Area_of_SAP_Pouch_XL__c,Surface_Area_of_SAP_Pouch_XS__c,s_size__c,xs_size__c,M_Size__c,L_Size__c,XL_Size__c,XXl_Size__c,
Surface_Area_of_SAP_Pouch_XXL__c,torsoSurfaceArea_XS__c,torsoSurfaceArea_S__c,torsoSurfaceArea_M__c,torsoSurfaceArea_L__c,torsoSurfaceArea_XL__c,torsoSurfaceArea_XXL__c,
                  neckCollarSurfaceArea_XS__c,neckCollarSurfaceArea_S__c,neckCollarSurfaceArea_M__c,neckCollarSurfaceArea_L__c,neckCollarSurfaceArea_XL__c,neckCollarSurfaceArea_XXL__c,
                  shoulderLRSurfaceArea_XS__c,shoulderLRSurfaceArea_S__c, shoulderLRSurfaceArea_M__c,shoulderLRSurfaceArea_L__c,shoulderLRSurfaceArea_XL__c,shoulderLRSurfaceArea_XXL__c,
                  groinSurfaceArea_XS__c,groinSurfaceArea_S__c,groinSurfaceArea_M__c,groinSurfaceArea_L__c,groinSurfaceArea_XL__c,groinSurfaceArea_XXL__c FROM Functional_Design_Requirement__c Where  recordType.name =:fdrWrap.fdrRecordType AND BA_Configuration__c=:fdrWrap.bacConfigurationID
                 Order By CreatedDate DESC LIMIT 1]; 
          // rejustRecordTypes.put('SAP',result);
        
        for(Functional_Design_Requirement__c r : result)
        { 
            
        if(r.Dimension_of_XS_size_A__c != null)
            {
            dimensions_map.put('A-XS',r.Dimension_of_XS_size_A__c);
            }
            if(r.Dimension_of_XS_size_B__c != null)
            {
            dimensions_map.put('B-XS',r.Dimension_of_XS_size_B__c);
            }
            if(r.Dimension_of_XS_size_C__c != null)
            {
            dimensions_map.put('C-XS',r.Dimension_of_XS_size_C__c);
            }
            if(r.Dimension_of_XS_size_D__c != null)
            {
            dimensions_map.put('D-XS',r.Dimension_of_XS_size_D__c);
            }
            if(r.Dimension_of_XS_size_E__c != null)
            {
            dimensions_map.put('E-XS',r.Dimension_of_XS_size_E__c);           
            }
            if(r.Dimension_of_S_size_A__c != null)
            {
            dimensions_map.put('A-S',r.Dimension_of_S_size_A__c);
            }
            if(r.Dimension_of_S_size_B__c != null)
            {
            dimensions_map.put('B-S',r.Dimension_of_S_size_B__c);
            }
            if(r.Dimension_of_S_size_C__c != null)
            {
            dimensions_map.put('C-S',r.Dimension_of_S_size_C__c);
            }
            if(r.Dimension_of_S_size_D__c != null)
            {
            dimensions_map.put('D-S',r.Dimension_of_S_size_D__c);
            }
            if(r.Dimension_of_S_size_E__c != null)
            {
            dimensions_map.put('E-S',r.Dimension_of_S_size_E__c);           
            }
            if(r.Dimension_of_M_size_A__c != null)
            {
            dimensions_map.put('A-M',r.Dimension_of_M_size_A__c);
            }
            if(r.Dimension_of_M_size_B__c != null)
            {
            dimensions_map.put('B-M',r.Dimension_of_M_size_B__c);
            }
            if(r.Dimension_of_M_size_C__c != null)
            {
            dimensions_map.put('C-M',r.Dimension_of_M_size_C__c);
            }
            if(r.Dimension_of_M_size_D__c != null)
            {
            dimensions_map.put('D-M',r.Dimension_of_M_size_D__c);
            }
            if(r.Dimension_of_M_size_E__c != null)
            {
            dimensions_map.put('E-M',r.Dimension_of_M_size_E__c);           
            }
            if(r.Dimension_of_L_size_A__c != null)
            {
            dimensions_map.put('A-L',r.Dimension_of_L_size_A__c);
            }
            if(r.Dimension_of_L_size_B__c != null)
            {
            dimensions_map.put('B-L',r.Dimension_of_L_size_B__c);
            }
            if(r.Dimension_of_L_size_C__c != null)
            {
            dimensions_map.put('C-L',r.Dimension_of_L_size_C__c);
            }
            if(r.Dimension_of_L_size_D__c != null)
            {
            dimensions_map.put('D-L',r.Dimension_of_L_size_D__c);
            }
            if(r.Dimension_of_L_size_E__c != null)
            {
            dimensions_map.put('E-L',r.Dimension_of_L_size_E__c);           
            }
            if(r.Dimension_of_XL_size_A__c != null)
            {
            dimensions_map.put('A-XL',r.Dimension_of_XL_size_A__c);
            }
            if(r.Dimension_of_XL_size_B__c != null)
            {
            dimensions_map.put('B-XL',r.Dimension_of_XL_size_B__c);
            }
            if(r.Dimension_of_XL_size_C__c != null)
            {
            dimensions_map.put('C-XL',r.Dimension_of_XL_size_C__c);
            }
            if(r.Dimension_of_XL_size_D__c != null)
            {
            dimensions_map.put('D-XL',r.Dimension_of_XL_size_D__c);
            }
            if(r.Dimension_of_XL_size_E__c != null)
            {
            dimensions_map.put('E-XL',r.Dimension_of_XL_size_E__c);            
            }
            if(r.Dimension_of_XXL_size_A__c != null)
            {
            dimensions_map.put('A-XXL',r.Dimension_of_XXL_size_A__c);
            }
            if(r.Dimension_of_XXL_size_B__c != null)
            {
            dimensions_map.put('B-XXL',r.Dimension_of_XXL_size_B__c);
            }
            if(r.Dimension_of_XXL_size_C__c != null)
            {
            dimensions_map.put('C-XXL',r.Dimension_of_XXL_size_C__c);
            }
            if(r.Dimension_of_XXL_size_D__c != null)
            {
            dimensions_map.put('D-XXL',r.Dimension_of_XXL_size_D__c);
            }
            if(r.Dimension_of_XXL_size_E__c != null)
            {
            dimensions_map.put('E-XXL',r.Dimension_of_XXL_size_E__c);  
            }
            
           
            if(r.Surface_Area_of_SAP_Pouch_XS__c !=null)
            {
            surfaceArea_SapPouch.put('XS',r.Surface_Area_of_SAP_Pouch_XS__c);
            }
            if(r.Surface_Area_of_SAP_Pouch_S__c !=null)
            {
            surfaceArea_SapPouch.put('S',r.Surface_Area_of_SAP_Pouch_S__c);
            }
            if(r.Surface_Area_of_SAP_Pouch_M__c !=null)
            {
            surfaceArea_SapPouch.put('M',r.Surface_Area_of_SAP_Pouch_M__c);
            }
            if(r.Surface_Area_of_SAP_Pouch_L__c !=null)
            {
            surfaceArea_SapPouch.put('L',r.Surface_Area_of_SAP_Pouch_L__c);
            }
            if(r.Surface_Area_of_SAP_Pouch_XL__c !=null)
            {
            surfaceArea_SapPouch.put('XL',r.Surface_Area_of_SAP_Pouch_XL__c);
            }
            if(r.Surface_Area_of_SAP_Pouch_XXL__c !=null)
            {
            surfaceArea_SapPouch.put('XXL',r.Surface_Area_of_SAP_Pouch_XXL__c);
            }
            
        // ,,,,,
    
            
            
            gen.writeStartObject();  
            if( r.id !=null){
                gen.writeStringField('sapID', r.id);
                }
            if( r.BA_Configuration__c !=null){  
                gen.writeStringField('bacConfigurationID', r.BA_Configuration__c);            
                }
                
                gen.writeStringField('fdrRecordType', 'Body Armor Functional Design');
                
                if( r.name !=null){
                gen.writeStringField('name', r.name);           
                }
                if( r.Active__c !=null){
                gen.writeBooleanField('active', r.Active__c);
                }
            /* PS1060931 start */
                if( r.Back_plate__c !=null){
                gen.writeBooleanField('backPlate', r.Back_plate__c);
                }
                if( r.Front_plate__c !=null){
                gen.writeBooleanField('frontPlate', r.Front_plate__c);
                }
                if( r.Side_plate__c !=null){
                gen.writeBooleanField('sidePlate', r.Side_plate__c);
                }
                if( r.Plate_Pockets__c !=null){
                gen.writeBooleanField('platePockets', r.Plate_Pockets__c);
                }
                if( r.Color__c !=null){
                gen.writeStringField('color', r.Color__c);
                }
                if( r.Shoulder__c !=null){
                gen.writeBooleanField('shoulder', r.Shoulder__c);
                }
                if( r.Neck_and_Collar__c !=null){
                gen.writeBooleanField('neckAndCollar', r.Neck_and_Collar__c);
                }
                if( r.Pouches__c !=null){
                gen.writeBooleanField('pouches', r.Pouches__c);
                }
                if( r.Quick_Release__c !=null){
                gen.writeBooleanField('quickRelease', r.Quick_Release__c);
                }
                if( r.Groin__c !=null){
                gen.writeBooleanField('groin', r.Groin__c);
                }
                if( r.Groin_Shape__c !=null){
                gen.writeStringField('groinShape', r.Groin_Shape__c);
                }
                if( r.Molle_System__c !=null){
                gen.writeBooleanField('molleSystem', r.Molle_System__c);
                }
				
				gen.writeFieldName('selectedSizes');
					gen.writeStartArray();
						for(String dim : dimensions){
							gen.writeStartObject();
							if(dim == 'XS'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.xs_size__c);
							}
							else if(dim == 'S'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.s_size__c);
							}
							else if(dim == 'M'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.M_size__c);
							}
							else if(dim == 'L'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.L_size__c);
							}
							else if(dim == 'XL'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.XL_size__c);
							}
							else if(dim == 'XXL'){
							gen.writeStringField('size',dim);
							gen.writeBooleanField('value',r.XXL_size__c);
							}
							gen.writeEndObject();
						
						}
					gen.writeEndArray();
            /* PS1060931 - end */
                gen.writeFieldName('dimension');
                  gen.writeStartArray();
                        for(String s1 : dimensions){
                                    gen.writeStartObject();
                                        gen.writeStringField('name', s1);
                                        gen.writeFieldName('value');
                                            gen.writeStartArray(); 

                                                for(String s : dimensions_map.keySet()){ 
                                                    List<String> extract = s.split('-');
                                                    if(s1.equals(extract[1])){
                                                        //  List<String> extract = s.split('-');
                                                        system.debug('------'+extract[0]);
                                                        gen.writeStartObject();
                                                        gen.writeStringField('name', extract[0]);
                                                        if(dimensions_map.containsKey(s)){
                                                        gen.writeNumberField('value',dimensions_map.get(s) );
                                                        }
                                                        gen.writeEndObject();
                                                    }
                                                }
                                            gen.writeEndArray();
                                    gen.writeEndObject();
                        }
                    gen.writeEndArray();
                // surfaceAreaOfBodyArmor        
                    gen.writeFieldName('surfaceAreaOfBodyArmor');
                    gen.writeStartArray();
                        for(String size : dimensions){
                            if(size == 'XS'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'XS');
                                /* PS1060931 - start */
                                		if(r.torsoSurfaceArea_XS__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_XS__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_XS__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_XS__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_XS__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_XS__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_XS__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_XS__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_XS__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_XS__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                    gen.writeEndObject();
                            	}
                            	
                            if(size == 'S'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'S');
                                        if(r.torsoSurfaceArea_S__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_S__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_S__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_S__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_S__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_S__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_S__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_S__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_S__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_S__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                    gen.writeEndObject();
                            	}
                            if(size == 'M'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'M');
                                        if(r.torsoSurfaceArea_M__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_M__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_M__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_M__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_M__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_M__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_M__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_M__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_M__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_M__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                    gen.writeEndObject();
                            	}
                            if(size == 'L'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'L');
   										if(r.torsoSurfaceArea_L__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_L__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_L__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_L__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_L__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_L__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_L__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_L__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_L__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_L__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                    gen.writeEndObject();
                            	}
                            if(size == 'XL'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'XL');
                                		if(r.torsoSurfaceArea_XL__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_XL__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_XL__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_XL__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_XL__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_XL__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_XL__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_XL__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_XL__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_XL__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                    gen.writeEndObject();
                            	}
                            if(size == 'XXL'){
                                	gen.writeStartObject();
                                        gen.writeStringField('name', 'XXL');
                                        if(r.torsoSurfaceArea_XXL__c !=null){
                                        	gen.writeNumberField('torsoSurfaceArea',r.torsoSurfaceArea_XXL__c);
                                        }
                                		else{ 
                                        	gen.writeNumberField('torsoSurfaceArea',0); 
                                        }
                                		if(r.shoulderLRSurfaceArea_XXL__c !=null){ 
                                        	gen.writeNumberField('shoulderLRSurfaceArea',r.shoulderLRSurfaceArea_XXL__c);
                                    	}
                                		else{
                                        	gen.writeNumberField('shoulderLRSurfaceArea',0);
                                        }
                                		if(r.neckCollarSurfaceArea_XXL__c !=null){
                                        	gen.writeNumberField('neckCollarSurfaceArea',r.neckCollarSurfaceArea_XXL__c);
                                        }
                                		else{
                                            gen.writeNumberField('neckCollarSurfaceArea',0);
                                        }
                                        if(r.groinSurfaceArea_XXL__c !=null){
                                            gen.writeNumberField('groinSurfaceArea',r.groinSurfaceArea_XXL__c);
                                        }
                                        else{
                                            gen.writeNumberField('groinSurfaceArea',0);
                                        }
                                        if(r.Surface_Area_of_Body_Armour_XXL__c !=null){
                                            gen.writeNumberField('totalSurfaceArea',r.Surface_Area_of_Body_Armour_XXL__c);
                                        }
                                        else{
                                         	gen.writeNumberField('totalSurfaceArea',0);   
                                        }
                                /* PS1060931 - end */
                                    gen.writeEndObject();
                            	}
                          	}
                    gen.writeEndArray(); 
            // surfaceAreaOfSapPouch
                gen.writeFieldName('surfaceAreaOfSapPouch');
                gen.writeStartArray();
                for(String size : dimensions){
                gen.writeStartObject();
                    gen.writeStringField('name', size);
                    if(surfaceArea_SapPouch.containsKey(size)){
                    gen.writeNumberField('surfaceArea',surfaceArea_SapPouch.get(size));
                    }
                gen.writeEndObject();
                }
                gen.writeEndArray();                
            gen.writeEndObject();
            // Get the JSON string.
            pretty = gen.getAsString();
            system.debug('JSON test : ' + pretty);
            }         
        }
         if(fdrWrap.fdrRecordType == 'HAP Functional Design'){        
         result= [SELECT Id, name,Active__c,BA_Configuration__c,Back_plate__c,Front_plate__c,Side_plate__c,Plate_Pockets__c,Color__c,Shoulder__c,Neck_and_Collar__c,Pouches__c,Quick_Release__c,Groin__c,Groin_Shape__c,Molle_System__c, Dimension_of_BP_for_L_size_E__c,Dimension_of_BP_for_L_size_F__c,Dimension_of_BP_for_L_size_G__c,Dimension_of_BP_for_L_size_H__c,Dimension_of_BP_for_M_size_E__c,Dimension_of_BP_for_M_size_F__c,Dimension_of_BP_for_M_size_G__c,Dimension_of_BP_for_M_size_H__c,Dimension_of_BP_for_S_size_E__c,Dimension_of_BP_for_S_size_F__c,Dimension_of_BP_for_S_size_G__c,Dimension_of_BP_for_S_size_H__c,Dimension_of_BP_for_XL_size_E__c,Dimension_of_BP_for_XL_size_F__c,Dimension_of_BP_for_XL_size_G__c,Dimension_of_BP_for_XL_size_H__c,Dimension_of_BP_for_XS_size_E__c,Dimension_of_BP_for_XS_size_F__c,Dimension_of_BP_for_XS_size_G__c,Dimension_of_BP_for_XS_size_H__c,Dimension_of_BP_for_XXL_size_E__c,Dimension_of_BP_for_XXL_size_F__c,Dimension_of_BP_for_XXL_size_G__c,Dimension_of_BP_for_XXL_size_H__c,Dimension_of_FP_for_L_size_A__c,Dimension_of_FP_for_L_size_B__c,Dimension_of_FP_for_L_size_C__c,Dimension_of_FP_for_L_size_D__c,Dimension_of_FP_for_M_size_A__c,Dimension_of_FP_for_M_size_B__c,Dimension_of_FP_for_M_size_C__c,Dimension_of_FP_for_M_size_D__c,Dimension_of_FP_for_S_size_A__c,Dimension_of_FP_for_S_size_B__c,Dimension_of_FP_for_S_size_C__c,Dimension_of_FP_for_S_size_D__c,Dimension_of_FP_for_XL_size_A__c,Dimension_of_FP_for_XL_size_B__c,Dimension_of_FP_for_XL_size_C__c,Dimension_of_FP_for_XL_size_D__c,Dimension_of_FP_for_xs_size_A__c,Dimension_of_FP_for_xs_size_B__c,Dimension_of_FP_for_XS_size_C__c,Dimension_of_FP_for_XS_size_D__c,Dimension_of_FP_for_XXL_size_A__c,Dimension_of_FP_for_XXL_size_B__c,Dimension_of_FP_for_XXL_size_C__c,Dimension_of_FP_for_XXL_size_D__c,Dimension_of_SP_for_L_size_I__c,Dimension_of_SP_for_L_size_J__c,Dimension_of_SP_for_L_size_K__c,Dimension_of_SP_for_L_size_L__c,Dimension_of_SP_for_M_size_I__c,Dimension_of_SP_for_M_size_J__c,Dimension_of_SP_for_M_size_K__c,Dimension_of_SP_for_M_size_L__c,Dimension_of_SP_for_S_size_I__c,Dimension_of_SP_for_S_size_J__c,
                  Dimension_of_SP_for_S_size_K__c,Dimension_of_SP_for_S_size_L__c,Dimension_of_SP_for_XL_size_I__c,Dimension_of_SP_for_XL_size_J__c,Dimension_of_SP_for_XL_size_K__c,
                  Dimension_of_SP_for_XL_size_L__c,Dimension_of_SP_for_XS_size_I__c,Dimension_of_SP_for_XS_size_J__c,Dimension_of_SP_for_XS_size_K__c,Dimension_of_SP_for_XS_size_L__c,
                  Dimension_of_SP_for_XXL_size_I__c,Dimension_of_SP_for_XXL_size_J__c,Dimension_of_SP_for_XXL_size_K__c,Dimension_of_SP_for_XXL_size_L__c,
                  Keep_BP_dimensions_same_for_all_the_size__c,Keep_FP_dimensions_same_for_all_the_size__c,Keep_SP_dimensions_same_for_all_the_size__c,Surface_Area_BP_size_L__c,
                  Surface_Area_BP_size_M__c,Surface_Area_BP_size_S__c,Surface_Area_BP_size_XL__c,Surface_Area_BP_size_XS__c,Surface_Area_BP_size_XXL__c,Surface_Area_FP_size_L__c,
                  Surface_Area_FP_size_M__c,Surface_Area_FP_size_S__c,Surface_Area_FP_size_XL__c,Surface_Area_FP_size_XS__c,Surface_Area_FP_size_XXL__c,Surface_Area_SP_size_L__c,
                  Surface_Area_SP_size_M__c,Surface_Area_SP_size_S__c,Surface_Area_SP_size_XL__c,Surface_Area_SP_size_XS__c,Surface_Area_SP_size_XXL__c,Plate_Design_of_BP__c,
                  Plate_Design_of_front_plate__c,Plate_Design_of_SP__c,Thickness_Limit_of_BP__c,Thickness_Limit_of_front_plate__c,Thickness_Limit_of_SP__c  
                  FROM Functional_Design_Requirement__c Where  recordType.name =:fdrWrap.fdrRecordType AND BA_Configuration__c=:fdrWrap.bacConfigurationID
                 Order By CreatedDate DESC LIMIT 1]; 
         // rejustRecordTypes.put('HAP',result);
         
         List<Functional_Design_Requirement__c> bodyArmorRecordLinked = [select id,Back_plate__c,Front_plate__c,Side_plate__c from Functional_Design_Requirement__c  
                                                                         where recordType.name = 'Body Armor Functional Design' and  BA_Configuration__c=:fdrWrap.bacConfigurationID ];
        
        
        for(Functional_Design_Requirement__c r : result)
        {  
        
                genHAP.writeStartObject();  
                    genHAP.writeStringField('hapID', r.id);
                    genHAP.writeStringField('bacConfigurationID', r.BA_Configuration__c);            
                    genHAP.writeStringField('fdrRecordType', 'HAP Functional Design');
                    genHAP.writeStringField('name', r.name);           
                    genHAP.writeBooleanField('active', r.Active__c);
                genHAP.writeFieldName('records'); 
                // Start Array for all plates
                genHAP.writeStartArray();
                
                if(bodyArmorRecordLinked[0].Front_plate__c !=null && bodyArmorRecordLinked[0].Front_plate__c)
                {
        
                    if(r.Dimension_of_FP_for_XS_size_A__c !=null)
                    {
                    dimensions_map.put('A-XS',r.Dimension_of_FP_for_XS_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_XS_size_B__c !=null)
                    {
                    dimensions_map.put('B-XS',r.Dimension_of_FP_for_XS_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_XS_size_C__c !=null)
                    {
                    dimensions_map.put('C-XS',r.Dimension_of_FP_for_XS_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_XS_size_D__c !=null)
                    {
                    dimensions_map.put('D-XS',r.Dimension_of_FP_for_XS_size_D__c);   
                    }
                    if(r.Dimension_of_FP_for_S_size_A__c !=null)
                    {
                    dimensions_map.put('A-S',r.Dimension_of_FP_for_S_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_S_size_B__c !=null)
                    {
                    dimensions_map.put('B-S',r.Dimension_of_FP_for_S_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_S_size_C__c !=null)
                    {
                    dimensions_map.put('C-S',r.Dimension_of_FP_for_S_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_S_size_D__c !=null)
                    {
                    dimensions_map.put('D-S',r.Dimension_of_FP_for_S_size_D__c);  
                    }
                    if(r.Dimension_of_FP_for_M_size_A__c !=null)
                    {
                    dimensions_map.put('A-M',r.Dimension_of_FP_for_M_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_M_size_B__c !=null)
                    {
                    dimensions_map.put('B-M',r.Dimension_of_FP_for_M_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_M_size_C__c !=null)
                    {
                    dimensions_map.put('C-M',r.Dimension_of_FP_for_M_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_M_size_D__c !=null)
                    {
                    dimensions_map.put('D-M',r.Dimension_of_FP_for_M_size_D__c);   
                    }
                    if(r.Dimension_of_FP_for_L_size_A__c !=null)
                    {
                    dimensions_map.put('A-L',r.Dimension_of_FP_for_L_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_L_size_B__c !=null)
                    {
                    dimensions_map.put('B-L',r.Dimension_of_FP_for_L_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_L_size_C__c !=null)
                    {
                    dimensions_map.put('C-L',r.Dimension_of_FP_for_L_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_L_size_D__c !=null)
                    {
                    dimensions_map.put('D-L',r.Dimension_of_FP_for_L_size_D__c);   
                    }
                    if(r.Dimension_of_FP_for_XL_size_A__c !=null)
                    {
                    dimensions_map.put('A-XL',r.Dimension_of_FP_for_XL_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_XL_size_B__c !=null)
                    {
                    dimensions_map.put('B-XL',r.Dimension_of_FP_for_XL_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_XL_size_C__c !=null)
                    {
                    dimensions_map.put('C-XL',r.Dimension_of_FP_for_XL_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_XL_size_D__c !=null)
                    {
                    dimensions_map.put('D-XL',r.Dimension_of_FP_for_XL_size_D__c);    
                    }
                    if(r.Dimension_of_FP_for_XXL_size_A__c !=null)
                    {
                    dimensions_map.put('A-XXL',r.Dimension_of_FP_for_XXL_size_A__c);
                    }
                    if(r.Dimension_of_FP_for_XXL_size_B__c !=null)
                    {
                    dimensions_map.put('B-XXL',r.Dimension_of_FP_for_XXL_size_B__c);
                    }
                    if(r.Dimension_of_FP_for_XXL_size_C__c !=null)
                    {
                    dimensions_map.put('C-XXL',r.Dimension_of_FP_for_XXL_size_C__c);
                    }
                    if(r.Dimension_of_FP_for_XXL_size_D__c !=null)
                    {
                    dimensions_map.put('D-XXL',r.Dimension_of_FP_for_XXL_size_D__c);
                    }
                    
                    if(r.Surface_Area_FP_size_XS__c !=null)
                    {
                    surfaceArea_BodyArmor.put('XS',r.Surface_Area_FP_size_XS__c);
                    }
                    if(r.Surface_Area_FP_size_S__c !=null)
                    {
                    surfaceArea_BodyArmor.put('S',r.Surface_Area_FP_size_S__c);
                    }
                    if(r.Surface_Area_FP_size_M__c !=null)
                    {
                    surfaceArea_BodyArmor.put('M',r.Surface_Area_FP_size_M__c);
                    }
                    if(r.Surface_Area_FP_size_L__c !=null)
                    {
                    surfaceArea_BodyArmor.put('L',r.Surface_Area_FP_size_L__c);
                    }
                    if(r.Surface_Area_FP_size_XL__c !=null)
                    {
                    surfaceArea_BodyArmor.put('XL',r.Surface_Area_FP_size_XL__c);
                    }
                    if(r.Surface_Area_FP_size_XXL__c !=null)
                    {
                    surfaceArea_BodyArmor.put('XXL',r.Surface_Area_FP_size_XXL__c);
                    }
                
                    genHAP.writeStartObject();
                        genHAP.writeStringField('hapType', 'Front Plate');
                        
                        genHAP.writeBooleanField('keepDimensionsSameForAllTheSize', r.Keep_FP_dimensions_same_for_all_the_size__c);
                        
                        if(r.Plate_Design_of_front_plate__c !=null)
                        {
                            genHAP.writeStringField('plateDesign', r.Plate_Design_of_front_plate__c);
                        }
                        else{
                            genHAP.writeStringField('plateDesign', '');
                        }
                        if(r.Thickness_Limit_of_front_plate__c !=null)
                        {
                            genHAP.writeNumberField('thicknessLimit', r.Thickness_Limit_of_front_plate__c);  
                        }
                         else{
                            genHAP.writeStringField('thicknessLimit', '');
                        }
             
                    genHAP.writeFieldName('dimension');               
                        genHAP.writeStartArray();
                            for(String s1 : dimensions)
                            {
                                system.debug('#### s1 : ' + s1);
                                genHAP.writeStartObject();
                                    genHAP.writeStringField('name', s1);
                                    genHAP.writeFieldName('value');
                                        genHAP.writeStartArray(); // cphone = c.phone.substring(0, c.phone.indexOf('ext'));
                                            for(String s : dimensions_map.keySet())
                                            { 
                                                system.debug('#### sss : ' + s);
                                                List<String> extract = s.split('-');
                                                if(s1.equals(extract[1])){
                                          //    List<String> extract = s.split('-');
                                                system.debug('------'+extract[0]);
                                                    genHAP.writeStartObject();
                                                  genHAP.writeStringField('name', extract[0]);
                                                  if(dimensions_map.containsKey(s)){
                                                    genHAP.writeNumberField('value',dimensions_map.get(s) );
                                                  }
                                                    else{
                                                      genHAP.writeNumberField('value',0 );  
                                                    }
                                                    genHAP.writeEndObject();
                                                }
                                            }
                                        genHAP.writeEndArray();
                                genHAP.writeEndObject();
                            }
                        genHAP.writeEndArray(); 
             // surfaceAreaOfBodyArmor        
                genHAP.writeFieldName('surfaceArea');
                genHAP.writeStartArray();
                    if(dimensions.size()>0){
                    for(String size : dimensions){
                        genHAP.writeStartObject();
                            genHAP.writeStringField('name', size);
                            if(surfaceArea_BodyArmor.containsKey(size) && surfaceArea_BodyArmor.keyset().size()!=0){
                                genHAP.writeNumberField('surfaceArea',surfaceArea_BodyArmor.get(size));
                            }
                            else{
                                 genHAP.writeNumberField('surfaceArea',0 );  
                            }
                        genHAP.writeEndObject();
                        }
                    }
               genHAP.writeEndArray(); 
            genHAP.writeEndObject();
           // genHAP.writeEndArray();
        } 
            if(bodyArmorRecordLinked[0].Back_plate__c !=null && bodyArmorRecordLinked[0].Back_plate__c)
             {    //if(r.Back_plate__c)
                if(r.Dimension_of_BP_for_XS_size_E__c !=null){   
                dimensions_map_BP.put('A-XS',r.Dimension_of_BP_for_XS_size_E__c);
                }
                if(r.Dimension_of_BP_for_XS_size_F__c !=null)
                {
                dimensions_map_BP.put('B-XS',r.Dimension_of_BP_for_XS_size_F__c);
                }
                if(r.Dimension_of_BP_for_XS_size_G__c !=null)
                {
                dimensions_map_BP.put('C-XS',r.Dimension_of_BP_for_XS_size_G__c);
                }
                if(r.Dimension_of_BP_for_XS_size_H__c !=null)
                {
                dimensions_map_BP.put('D-XS',r.Dimension_of_BP_for_XS_size_H__c);   
                }
                if(r.Dimension_of_BP_for_S_size_E__c !=null)
                {
                dimensions_map_BP.put('A-S',r.Dimension_of_BP_for_S_size_E__c);
                }
                if(r.Dimension_of_BP_for_S_size_F__c != null)
                {
                dimensions_map_BP.put('B-S',r.Dimension_of_BP_for_S_size_F__c);
                }
                if(r.Dimension_of_BP_for_S_size_G__c !=null)
                {
                dimensions_map_BP.put('C-S',r.Dimension_of_BP_for_S_size_G__c);
                }
                if(r.Dimension_of_BP_for_S_size_H__c !=null)
                {
                dimensions_map_BP.put('D-S',r.Dimension_of_BP_for_S_size_H__c);  
                }
                if(r.Dimension_of_BP_for_M_size_E__c !=null)
                {
                dimensions_map_BP.put('A-M',r.Dimension_of_BP_for_M_size_E__c);
                }
                if(r.Dimension_of_BP_for_M_size_F__c !=null)
                {
                dimensions_map_BP.put('B-M',r.Dimension_of_BP_for_M_size_F__c);
                }
                if(r.Dimension_of_BP_for_M_size_G__c !=null)
                {
                dimensions_map_BP.put('C-M',r.Dimension_of_BP_for_M_size_G__c);
                }
                if(r.Dimension_of_BP_for_M_size_H__c !=null)
                {
                dimensions_map_BP.put('D-M',r.Dimension_of_BP_for_M_size_H__c);   
                }
                if(r.Dimension_of_BP_for_L_size_E__c !=null)
                {
                dimensions_map_BP.put('A-L',r.Dimension_of_BP_for_L_size_E__c);
                }
                if(r.Dimension_of_BP_for_L_size_F__c !=null)
                {
                dimensions_map_BP.put('B-L',r.Dimension_of_BP_for_L_size_F__c);
                }
                if(r.Dimension_of_BP_for_L_size_G__c !=null)
                {
                dimensions_map_BP.put('C-L',r.Dimension_of_BP_for_L_size_G__c);
                }
                if(r.Dimension_of_BP_for_L_size_H__c !=null)
                {
                dimensions_map_BP.put('D-L',r.Dimension_of_BP_for_L_size_H__c);   
                }
                if(r.Dimension_of_BP_for_XL_size_E__c !=null)
                {
                dimensions_map_BP.put('A-XL',r.Dimension_of_BP_for_XL_size_E__c);
                }
                if(r.Dimension_of_BP_for_XL_size_F__c !=null)
                {
                dimensions_map_BP.put('B-XL',r.Dimension_of_BP_for_XL_size_F__c);
                }
                if(r.Dimension_of_BP_for_XL_size_G__c !=null)
                {
                dimensions_map_BP.put('C-XL',r.Dimension_of_BP_for_XL_size_G__c);
                }
                if(r.Dimension_of_BP_for_XL_size_H__c !=null)
                {
                dimensions_map_BP.put('D-XL',r.Dimension_of_BP_for_XL_size_H__c);    
                }
                if(r.Dimension_of_BP_for_XXL_size_E__c !=null)
                {
                dimensions_map_BP.put('A-XXL',r.Dimension_of_BP_for_XXL_size_E__c);
                }
                if(r.Dimension_of_BP_for_XXL_size_F__c !=null)
                {
                dimensions_map_BP.put('B-XXL',r.Dimension_of_BP_for_XXL_size_F__c);
                }
                if(r.Dimension_of_BP_for_XXL_size_G__c !=null)
                {
                dimensions_map_BP.put('C-XXL',r.Dimension_of_BP_for_XXL_size_G__c);
                }
                if(r.Dimension_of_BP_for_XXL_size_H__c !=null)
                {
                dimensions_map_BP.put('D-XXL',r.Dimension_of_BP_for_XXL_size_H__c);
                }
                
                if(r.Surface_Area_BP_size_XS__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('XS',r.Surface_Area_BP_size_XS__c);
                }
                if(r.Surface_Area_BP_size_S__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('S',r.Surface_Area_BP_size_S__c);
                }
                if(r.Surface_Area_BP_size_M__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('M',r.Surface_Area_BP_size_M__c);
                }
                if(r.Surface_Area_BP_size_L__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('L',r.Surface_Area_BP_size_L__c);
                }
                if(r.Surface_Area_BP_size_XL__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('XL',r.Surface_Area_BP_size_XL__c);
                }
                if(r.Surface_Area_BP_size_XXL__c !=null)
                {
                surfaceArea_BodyArmor_BP.put('XXL',r.Surface_Area_BP_size_XXL__c);
                }
            
            //    JSONGenerator gen = JSON.createGenerator(true);
  
                   // genHAP.writeFieldName('records');
                       // genHAP.writeStartArray();
                            genHAP.writeStartObject();
                                genHAP.writeStringField('hapType', 'Back Plate');
                                if(r.Keep_BP_dimensions_same_for_all_the_size__c != null)
                                {
                                genHAP.writeBooleanField('keepDimensionsSameForAllTheSize', r.Keep_BP_dimensions_same_for_all_the_size__c);
                                }
                                if(r.Plate_Design_of_BP__c != null)
                                {
                                genHAP.writeStringField('plateDesign', r.Plate_Design_of_BP__c);
                                }
                                if(r.Thickness_Limit_of_BP__c != null)
                                {
                                genHAP.writeNumberField('thicknessLimit', r.Thickness_Limit_of_BP__c);  
                                }
                                    genHAP.writeFieldName('dimension');               
                                        genHAP.writeStartArray();
                                            for(String s1 : dimensions)
                                            {
                                                genHAP.writeStartObject();
                                                genHAP.writeStringField('name', s1);
                                                genHAP.writeFieldName('value');
                                                genHAP.writeStartArray(); // cphone = c.phone.substring(0, c.phone.indexOf('ext'));
                                                    for(String s : dimensions_map_BP.keySet())
                                                    { 
                                                    List<String> extract = s.split('-');
                                                        if(s1.equals(extract[1])){
                                                            //  List<String> extract = s.split('-');
                                                            system.debug('------'+extract[0]);
                                                            genHAP.writeStartObject();
                                                            genHAP.writeStringField('name', extract[0]);
                                                            if(dimensions_map_BP.containsKey(s)){
                                                            genHAP.writeNumberField('value',dimensions_map_BP.get(s) );
                                                            }
                                                            genHAP.writeEndObject();
                                                        }
                                                    }
                                                genHAP.writeEndArray();
                                        genHAP.writeEndObject();
                    
                                        }
                                        genHAP.writeEndArray(); 
                 // surfaceAreaOfBodyArmor        
                        genHAP.writeFieldName('surfaceArea');
                            genHAP.writeStartArray();
                                for(String sizeD : dimensions)
                                if(sizeD!=null && sizeD != ''){
                                {
                                    genHAP.writeStartObject();
                                    genHAP.writeStringField('name', sizeD);
                                    if(surfaceArea_BodyArmor_BP.containsKey(sizeD)){
                                    genHAP.writeNumberField('surfaceArea',surfaceArea_BodyArmor_BP.get(sizeD));
                                    }
                                    genHAP.writeEndObject();
                                }
                                }
                        
                            genHAP.writeEndArray(); 
                
           genHAP.writeEndObject();
           //genHAP.writeEndArray();
            }
            if(bodyArmorRecordLinked[0].Side_plate__c !=null && bodyArmorRecordLinked[0].Side_plate__c)
            {
                // if(r.Side_plate__c)  

                if( r.Dimension_of_SP_for_XS_size_I__c !=null)
                {
                dimensions_map_SP.put('A-XS',r.Dimension_of_SP_for_XS_size_I__c);
                }
                if( r.Dimension_of_SP_for_XS_size_J__c !=null)
                {
                dimensions_map_SP.put('B-XS',r.Dimension_of_SP_for_XS_size_J__c);
                }
                if( r.Dimension_of_SP_for_XS_size_K__c !=null)
                {
                dimensions_map_SP.put('C-XS',r.Dimension_of_SP_for_XS_size_K__c);
                }
                if( r.Dimension_of_SP_for_XS_size_L__c !=null)
                {
                dimensions_map_SP.put('D-XS',r.Dimension_of_SP_for_XS_size_L__c);   
                }
                if( r.Dimension_of_SP_for_S_size_I__c !=null)
                {
                dimensions_map_SP.put('A-S',r.Dimension_of_SP_for_S_size_I__c);
                }
                if( r.Dimension_of_SP_for_S_size_J__c !=null)
                {
                dimensions_map_SP.put('B-S',r.Dimension_of_SP_for_S_size_J__c);
                }
                if( r.Dimension_of_SP_for_S_size_K__c !=null)
                {
                dimensions_map_SP.put('C-S',r.Dimension_of_SP_for_S_size_K__c);
                }
                if( r.Dimension_of_SP_for_S_size_L__c !=null)
                {
                dimensions_map_SP.put('D-S',r.Dimension_of_SP_for_S_size_L__c);  
                }
                if( r.Dimension_of_SP_for_M_size_I__c !=null)
                {
                dimensions_map_SP.put('A-M',r.Dimension_of_SP_for_M_size_I__c);
                }
                if( r.Dimension_of_SP_for_M_size_J__c !=null)
                {
                dimensions_map_SP.put('B-M',r.Dimension_of_SP_for_M_size_J__c);
                }
                if( r.Dimension_of_SP_for_M_size_K__c !=null)
                {
                dimensions_map_SP.put('C-M',r.Dimension_of_SP_for_M_size_K__c);
                }
                if( r.Dimension_of_SP_for_M_size_L__c !=null)
                {
                dimensions_map_SP.put('D-M',r.Dimension_of_SP_for_M_size_L__c);   
                }
                if( r.Dimension_of_SP_for_L_size_I__c !=null)
                {
                dimensions_map_SP.put('A-L',r.Dimension_of_SP_for_L_size_I__c);
                }
                if( r.Dimension_of_SP_for_L_size_J__c !=null)
                {
                dimensions_map_SP.put('B-L',r.Dimension_of_SP_for_L_size_J__c);
                }
                if( r.Dimension_of_SP_for_L_size_K__c !=null)
                {
                dimensions_map_SP.put('C-L',r.Dimension_of_SP_for_L_size_K__c);
                }
                if( r.Dimension_of_SP_for_L_size_L__c !=null)
                {
                dimensions_map_SP.put('D-L',r.Dimension_of_SP_for_L_size_L__c);   
                }
                if( r.Dimension_of_SP_for_XL_size_I__c !=null)
                {
                dimensions_map_SP.put('A-XL',r.Dimension_of_SP_for_XL_size_I__c);
                }
                if( r.Dimension_of_SP_for_XL_size_J__c !=null)
                {
                dimensions_map_SP.put('B-XL',r.Dimension_of_SP_for_XL_size_J__c);
                }
                if( r.Dimension_of_SP_for_XL_size_K__c !=null)
                {
                dimensions_map_SP.put('C-XL',r.Dimension_of_SP_for_XL_size_K__c);
                }
                if( r.Dimension_of_SP_for_XL_size_L__c !=null)
                {
                dimensions_map_SP.put('D-XL',r.Dimension_of_SP_for_XL_size_L__c);    
                }
                if( r.Dimension_of_SP_for_XXL_size_I__c !=null)
                {
                dimensions_map_SP.put('A-XXL',r.Dimension_of_SP_for_XXL_size_I__c);
                }
                if( r.Dimension_of_SP_for_XXL_size_J__c !=null)
                {
                dimensions_map_SP.put('B-XXL',r.Dimension_of_SP_for_XXL_size_J__c);
                }
                if( r.Dimension_of_SP_for_XXL_size_K__c !=null)
                {
                dimensions_map_SP.put('C-XXL',r.Dimension_of_SP_for_XXL_size_K__c);
                }
                if( r.Dimension_of_SP_for_XXL_size_L__c !=null)
                {
                dimensions_map_SP.put('D-XXL',r.Dimension_of_SP_for_XXL_size_L__c);
                }
                
                if(r.Surface_Area_SP_size_XS__c != null)
                {
                surfaceArea_BodyArmor_SP.put('XS',r.Surface_Area_SP_size_XS__c);
                }
                if(r.Surface_Area_SP_size_S__c != null)
                {
                surfaceArea_BodyArmor_SP.put('S',r.Surface_Area_SP_size_S__c);
                }
                if(r.Surface_Area_SP_size_M__c != null)
                {
                surfaceArea_BodyArmor_SP.put('M',r.Surface_Area_SP_size_M__c);
                }
                if(r.Surface_Area_SP_size_L__c != null)
                {
                surfaceArea_BodyArmor_SP.put('L',r.Surface_Area_SP_size_L__c);
                }
                if(r.Surface_Area_SP_size_XL__c != null)
                {
                surfaceArea_BodyArmor_SP.put('XL',r.Surface_Area_SP_size_XL__c);
                }
                if(r.Surface_Area_SP_size_XXL__c != null)
                {
                surfaceArea_BodyArmor_SP.put('XXL',r.Surface_Area_SP_size_XXL__c);   
                }
               
                //genHAP.writeFieldName('records');
                //genHAP.writeStartArray();
                genHAP.writeStartObject();
                genHAP.writeStringField('hapType', 'Side Plate');
                if(r.Keep_SP_dimensions_same_for_all_the_size__c !=null)
                {
                genHAP.writeBooleanField('keepDimensionsSameForAllTheSize', r.Keep_SP_dimensions_same_for_all_the_size__c);
                }
                if(r.Plate_Design_of_SP__c !=null)
                {
                genHAP.writeStringField('plateDesign', r.Plate_Design_of_SP__c);
                }
                if(r.Thickness_Limit_of_SP__c !=null)
                {
                genHAP.writeNumberField('thicknessLimit', r.Thickness_Limit_of_SP__c);  
                }
                
                // genHAP.writeEndObject(); 
                genHAP.writeFieldName('dimension');               
                genHAP.writeStartArray();
                for(String s1 : dimensions){
                    genHAP.writeStartObject();
                        genHAP.writeStringField('name', s1);
                        genHAP.writeFieldName('value');
                            genHAP.writeStartArray(); // cphone = c.phone.substring(0, c.phone.indexOf('ext'));
                                for(String s : dimensions_map_SP.keySet()){ 
                                List<String> extract = s.split('-');
                                    if(s1.equals(extract[1])){
                                  //  List<String> extract = s.split('-');
                                    system.debug('------'+extract[0]);
                                    genHAP.writeStartObject();
                                        genHAP.writeStringField('name', extract[0]);
                                        if(dimensions_map_SP.containsKey(s)){
                                        genHAP.writeNumberField('value',dimensions_map_SP.get(s) );
                                        }
                                    genHAP.writeEndObject();
                                    }
                                }
                            genHAP.writeEndArray();
                    genHAP.writeEndObject();
                    
                }genHAP.writeEndArray(); 
                 // surfaceAreaOfBodyArmor        
                genHAP.writeFieldName('surfaceArea');
                    genHAP.writeStartArray();
                        for(String size : dimensions){
                            genHAP.writeStartObject();
                                genHAP.writeStringField('name', size);
                                if(surfaceArea_BodyArmor_SP.containsKey(size)){
                                genHAP.writeNumberField('surfaceArea',surfaceArea_BodyArmor_SP.get(size));
                                }
                                 system.debug('------'+size);
                            genHAP.writeEndObject();
                            }
                        
                genHAP.writeEndArray(); 
                
        genHAP.writeEndObject();       
        //genHAP.WriteEndArray();  
         }  
         
        // end Array of all plates
          genHAP.WriteEndArray();
        // Get the JSON string.
         prettyHAP = genHAP.getAsString();
        system.debug('JSON test for HAP : ' + prettyHAP);
        
         }
        
    }
    
       if(fdrWrap.fdrRecordType == 'Other Requirement'){
        system.debug('================='+ 'Other Requirement');
           system.debug('================='+ fdrWrap.bacConfigurationID);
        
        result= [SELECT Id,name,Active__c,BA_Configuration__c,Test_Lab_Comment__c,StandardName__c,SAP_pouch_weight_L__c,SAP_pouch_weight_M__c,SAP_pouch_weight_S__c,SAP_pouch_weight_XL__c,SAP_pouch_weight_XS__c,SAP_pouch_weight_XXL__c,Total_weight_body_armor_L__c,Total_weight_body_armor_M__c,Total_weight_body_armor_S__c,Total_weight_body_armor_XL__c,Total_weight_body_armor_XS__c,Total_weight_body_armor_XXL__c,Weight_limit_HAP_L__c,Weight_limit_HAP_M__c,Weight_limit_HAP_S__c,Weight_limit_HAP_XL__c,Weight_limit_HAP_XS__c,Weight_limit_HAP_XXL__c,Weight_limit_SAP_L__c,Weight_limit_SAP_M__c,Weight_limit_SAP_S__c,Weight_limit_SAP_XL__c,Weight_limit_SAP_XS__c,Weight_limit_SAP_XXL__c,Flammability_Protection_Needed__c,Flammability_Protection_Standards__c,Outer_carrier_weight_L__c,Outer_carrier_weight_M__c,Outer_carrier_weight_S__c,Outer_carrier_weight_XL__c,Outer_carrier_weight_XS__c,Outer_carrier_weight_XXL__c,Third_party_test_certificate_required__c,Comment_Flexibility__c,Panel_Flexibility__c,Comment_Flammability__c,Comment_Lab_test__c,Third_party_testing_standards__c,Panel_Flexibility_Reference__c,Flammability_Tests__c,Flammability_Standard_Other_Comment__c,Panel_Flexibility_Reference_OtherComment__c 
                 FROM Functional_Design_Requirement__c Where  recordType.name =:fdrWrap.fdrRecordType AND BA_Configuration__c=:fdrWrap.bacConfigurationID
                Order By CreatedDate DESC LIMIT 1]; 
         system.debug('result================='+ result);
          for(Functional_Design_Requirement__c r : result)
        { 
             system.debug('================='+ r.SAP_pouch_weight_L__c);
             //SAP_pouch_weight
            if(r.SAP_pouch_weight_L__c !=null)
            {
            sapPouch.put('XS',r.SAP_pouch_weight_L__c);
            }
            if(r.SAP_pouch_weight_S__c !=null)
            {
            sapPouch.put('S',r.SAP_pouch_weight_S__c);
            }
            if(r.SAP_pouch_weight_M__c !=null)
            {
            sapPouch.put('M',r.SAP_pouch_weight_M__c);
            }
            if(r.SAP_pouch_weight_L__c !=null)
            {
            sapPouch.put('L',r.SAP_pouch_weight_L__c);
            }
            if(r.SAP_pouch_weight_XL__c !=null)
            {
            sapPouch.put('XL',r.SAP_pouch_weight_XL__c);
            }
            if(r.SAP_pouch_weight_XXL__c !=null)
            {
            sapPouch.put('XXL',r.SAP_pouch_weight_XXL__c);
            }
        //Outer_carrier_weight
            if(r.Outer_carrier_weight_XS__c !=null)
            {
            outerCarrier.put('XS',r.Outer_carrier_weight_XS__c);
            }
            if(r.Outer_carrier_weight_S__c !=null)
            {
            outerCarrier.put('S',r.Outer_carrier_weight_S__c);
            }
            if(r.Outer_carrier_weight_M__c !=null)
            {
            outerCarrier.put('M',r.Outer_carrier_weight_M__c);
            }
            if(r.Outer_carrier_weight_L__c !=null)
            {
            outerCarrier.put('L',r.Outer_carrier_weight_L__c);
            }
            if(r.Outer_carrier_weight_XL__c !=null)
            {
            outerCarrier.put('XL',r.Outer_carrier_weight_XL__c);
            }
            if(r.Outer_carrier_weight_XXL__c !=null)
            {
            outerCarrier.put('XXL',r.Outer_carrier_weight_XXL__c);
            }

            //hapWeightLimit
            if(r.Weight_limit_HAP_XS__c !=null)
            {
            hapWeightLimit.put('XS',r.Weight_limit_HAP_XS__c);
            }
            if(r.Weight_limit_HAP_S__c !=null)
            {
            hapWeightLimit.put('S',r.Weight_limit_HAP_S__c);
            }
            if(r.Weight_limit_HAP_M__c !=null)
            {
            hapWeightLimit.put('M',r.Weight_limit_HAP_M__c);
            }
            if(r.Weight_limit_HAP_L__c !=null)
            {
            hapWeightLimit.put('L',r.Weight_limit_HAP_L__c);
            }
            if(r.Weight_limit_HAP_XL__c !=null)
            {
            hapWeightLimit.put('XL',r.Weight_limit_HAP_XL__c);
            }
            if(r.Weight_limit_HAP_XXL__c !=null)
            {
            hapWeightLimit.put('XXL',r.Weight_limit_HAP_XXL__c);
            }
            //sapWeightLimit
            if(r.Weight_limit_SAP_XS__c !=null)
            {
            sapWeightLimit.put('XS',r.Weight_limit_SAP_XS__c);
            }
            if(r.Weight_limit_SAP_S__c !=null)
            {
            sapWeightLimit.put('S',r.Weight_limit_SAP_S__c);
            }
            if(r.Weight_limit_SAP_M__c !=null)
            {
            sapWeightLimit.put('M',r.Weight_limit_SAP_M__c);
            }
            if(r.Weight_limit_SAP_L__c !=null)
            {
            sapWeightLimit.put('L',r.Weight_limit_SAP_L__c);
            }
            if(r.Weight_limit_SAP_XL__c !=null)
            {
            sapWeightLimit.put('XL',r.Weight_limit_SAP_XL__c);
            }
            if(r.Weight_limit_SAP_XXL__c !=null)
            {
            sapWeightLimit.put('XXL',r.Weight_limit_SAP_XXL__c);
            }
        //totalWeightLimit
            if(r.Total_weight_body_armor_XS__c !=null)
            {
            totalWeightLimit.put('XS',r.Total_weight_body_armor_XS__c);
            }
            if(r.Total_weight_body_armor_S__c !=null)
            {
            totalWeightLimit.put('S',r.Total_weight_body_armor_S__c);
            }
            if(r.Total_weight_body_armor_M__c !=null)
            {
            totalWeightLimit.put('M',r.Total_weight_body_armor_M__c);
            }
            if(r.Total_weight_body_armor_L__c !=null)
            {
            totalWeightLimit.put('L',r.Total_weight_body_armor_L__c);
            }
            if(r.Total_weight_body_armor_XL__c !=null)
            {
            totalWeightLimit.put('XL',r.Total_weight_body_armor_XL__c);
            }
            if(r.Total_weight_body_armor_XXL__c !=null)
            {
            totalWeightLimit.put('XXL',r.Total_weight_body_armor_XXL__c);
            }
        // ,,,,,
  
            
            
            genOther.writeStartObject();  
                genOther.writeStringField('id', r.id);
                genOther.writeStringField('bacConfigurationID', r.BA_Configuration__c);            
                genOther.writeStringField('fdrRecordType', 'Other Requirement');
                genOther.writeStringField('name', r.name);           
                genOther.writeBooleanField('active', r.Active__c);
                genOther.writeBooleanField('flammabilityProtection', r.Flammability_Protection_Needed__c);
                
                if(!String.isBlank(r.Flammability_Tests__c)){                                  
                       genOther.writeStringField('flammabilityStandard', r.Flammability_Tests__c);
                    }
                else{
                    genOther.writeStringField('flammabilityStandard', '');
                }
                if(!String.isBlank(r.Flammability_Standard_Other_Comment__c )){ 
                    genOther.writeStringField('flammabilityStandardOtherComment', r.Flammability_Standard_Other_Comment__c);
                }
                else{
                    genOther.writeStringField('flammabilityStandardOtherComment', '');
                }
                //test laboratory field is mapped to Third_party_testing_standards__c in SF
                if(!String.isBlank(r.Third_party_testing_standards__c)){
                   List<String> tempInt=new List<String>();
                    if(r.Third_party_testing_standards__c.contains(';')){
                        for(String s : r.Third_party_testing_standards__c.replace('[','').replace(']','').split(';')){
                            tempInt.add(s.trim());
                        }
                    }
                    else{
                       for(String s : r.Third_party_testing_standards__c.replace('(','').replace(')','').split(',')){
                            tempInt.add(s.trim());
                        } 
                    }
                    system.debug('tempInt : ' + tempInt);
                    genOther.writeObjectField('testLaboratory', tempInt);
                }
                else{
                    List<String> tempInt=new List<String>();
                    genOther.writeObjectField('testLaboratory', tempInt);
                }
                if(!String.isBlank(r.Test_Lab_Comment__c)){
                    genOther.writeStringField('testLabComment', r.Test_Lab_Comment__c);
                }
                else{
                    genOther.writeStringField('testLabComment', '');
                }
                
            
                // Third party lab name was earlier named as standard name. 
                // So still "standardName" key name is used and is mapped to standardName__c in SF
                if(!String.isBlank(r.StandardName__c)){
                   List<String> tempInt=new List<String>();
                    if(r.StandardName__c.contains(';')){
                        for(String s : r.StandardName__c.replace('[','').replace(']','').split(';')){
                            tempInt.add(s.trim());
                        }
                    }
                    else{
                       for(String s : r.StandardName__c.replace('(','').replace(')','').split(',')){
                            tempInt.add(s.trim());
                        } 
                    }
                    system.debug('tempInt : ' + tempInt);
                    genOther.writeObjectField('standardName', tempInt);
                }
                else{
                    List<String> tempInt=new List<String>();
                    genOther.writeObjectField('standardName', tempInt);
                }
                if(!String.isBlank(r.Comment_Lab_test__c )){ 
                    genOther.writeStringField('standardComment', r.Comment_Lab_test__c);
                }
                else{
                    genOther.writeStringField('standardComment', '');
                }
                if(!String.isBlank(r.Comment_Flammability__c )){ 
                    genOther.writeStringField('flammabilityComment', r.Comment_Flammability__c);
                }
                else{
                    genOther.writeStringField('flammabilityComment', '');
                }
                
                genOther.writeBooleanField('requireThirdPartyCertification', r.Third_party_test_certificate_required__c);
                
                if(!String.isBlank(r.Panel_Flexibility_Reference__c )){ 
                    genOther.writeStringField('panelFlexibilityReference', r.Panel_Flexibility_Reference__c);
                }
                else{
                   genOther.writeStringField('panelFlexibilityReference', ''); 
                }
                
                if(!String.isBlank(r.Panel_Flexibility_Reference_OtherComment__c )){
                    genOther.writeStringField('panelFlexibilityOtherComment', r.Panel_Flexibility_Reference_OtherComment__c);
                }
                else{
                    genOther.writeStringField('panelFlexibilityOtherComment', '');
                }
                genOther.writeBooleanField('standardizedPanel', r.Panel_Flexibility__c);
                
                if(!String.isBlank(r.Comment_Flexibility__c )){
                    genOther.writeStringField('panelComment', r.Comment_Flexibility__c);
                }
                else{
                    genOther.writeStringField('panelComment', '');
                }
                
                system.debug('JSON test : ' + r.Panel_Flexibility_Reference__c); 
                genOther.writeFieldName('records'); 
                    genOther.writeStartArray();
                        genOther.writeStartObject();                            
                 
                    // sapPouch and outerCarrier weight 
                    genOther.writeFieldName('weight');
                    genOther.writeStartArray();
                        if(dimensions.size()>0){
                        for(String size : dimensions){
                            genOther.writeStartObject();
                                genOther.writeStringField('size', size);
                                if(outerCarrier.containsKey(size) && outerCarrier.keyset().size()!=0){
                                    genOther.writeNumberField('outerCarrier',outerCarrier.get(size));
                                }
                                else{
                                   genOther.writeNumberField('outerCarrier',0); 
                                }
                                if(sapPouch.containsKey(size) && sapPouch.keyset().size()!=0){
                                    genOther.writeNumberField('sapPouch',sapPouch.get(size));
                                }
                                else{
                                   genOther.writeNumberField('sapPouch',0); 
                                }
                            genOther.writeEndObject();
                            }
                     }
                   genOther.writeEndArray(); 
              
                  //
                    genOther.writeFieldName('sapWeightLimit');
                    genOther.writeStartArray();
                        if(dimensions.size()>0){
                        for(String size : dimensions){
                            genOther.writeStartObject();
                                genOther.writeStringField('size', size);
                                if(hapWeightLimit.containsKey(size) && hapWeightLimit.keyset().size()!=0){
                                    genOther.writeNumberField('hap',hapWeightLimit.get(size));
                                    system.debug('JSON test : ' + hapWeightLimit.get(size)); 
                                }
                                else{
                                   genOther.writeNumberField('hap',0); 
                                }
                                if(sapWeightLimit.containsKey(size) && sapWeightLimit.keyset().size()!=0){
                                    genOther.writeNumberField('sap',sapWeightLimit.get(size));
                                }
                                else{
                                   genOther.writeNumberField('sap',0); 
                                }
                            genOther.writeEndObject();
                            }
                     }
                   genOther.writeEndArray();
                   
                   genOther.writeFieldName('totalWeightLimit');
                    genOther.writeStartArray();
                        if(dimensions.size()>0){
                        for(String size : dimensions){
                            genOther.writeStartObject();
                                genOther.writeStringField('size', size);
                                if(totalWeightLimit.containsKey(size) && totalWeightLimit.keyset().size()!=0){
                                    genOther.writeNumberField('weightLimit',totalWeightLimit.get(size));
                                }
                                else{
                                    genOther.writeNumberField('weightLimit',0); 
                                }
                            genOther.writeEndObject();
                            }
                     }
                   genOther.writeEndArray();
                   
                genOther.writeEndObject(); 
                
                prettyOther = genOther.getAsString();
                system.debug('JSON test : ' + prettyOther ); 
             
          }    
        
        } 
        if(fdrWrap.fdrRecordType == 'Body Armor Functional Design')
        {
            return new CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('521'),'521',pretty , null, 'No Error');
        }
        else if (fdrWrap.fdrRecordType == 'HAP Functional Design')
        {
            return new CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('521'),'521',prettyHAP , null, 'No Error');
        }
        else if (fdrWrap.fdrRecordType == 'Other Requirement')
        {
            return new CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('521'),'521',prettyOther , null, 'No Error');
        }
       else{
        return new CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass(h.dataNotSent, h.getMessage('201'),null,null, null,null,'201');
       }
    }   
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnGetFDRDetailsClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null,null,'203');
    }
}
global class FDRDimensionsWrapper{
    public String bacConfigurationID;  
    Public String fdrRecordType; 
    }
}
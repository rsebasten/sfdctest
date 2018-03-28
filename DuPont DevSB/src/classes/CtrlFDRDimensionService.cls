/*********************************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class insert the record in Function design object with selected values of fields.

Change History:                                                                  Date:  
1. PS 1060931 - Modified code to add new fields and wrapper structure           6/30/2016 
 ********************************************************************************************/
/* PS1060931 -changed service urlMapping */
@RestResource(urlMapping = '/DesignRequirementsData/*')
global class CtrlFDRDimensionService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnFDRDimensionsClass doPost(){
CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
     List<String> sapLL = new List<String>();
     List<String> sapUL = new List<String>();
     List<String> sapFactor = new List<String>();
     List<String> sapMiddleValue_M = new List<String>();
     
     List<String> hapBPLL = new List<String>();
     List<String> hapBPUL = new List<String>();
     List<String> hapBPFactor = new List<String>();
     List<String> hapBPMiddleValue_M = new List<String>();
     List<String> hapFPMiddleValue_M = new List<String>();
     List<String> hapSPMiddleValue_M = new List<String>();
     List<String> hapFPLL = new List<String>();
     List<String> hapFPUL = new List<String>();
     List<String> hapFPFactor = new List<String>();
     List<String> hapSPLL = new List<String>();
     List<String> hapSPUL = new List<String>();
     List<String> hapSPFactor = new List<String>();
     Map<String, String> mapsapLL = new Map<String, String>();
     Map<String, String> mapsapUL= new Map<String, String>();
     Map<String, String> mapsapFactor= new Map<String, String>();
     Map<String, String> mapsapMiddleValue_M= new Map<String, String>();
     Map<String, String> maphapBPMiddleValue_M= new Map<String, String>();
     Map<String, String> maphapFPMiddleValue_M= new Map<String, String>();
     Map<String, String> maphapSPMiddleValue_M= new Map<String, String>();
     Map<String, String> maphapBPUL= new Map<String, String>();
     Map<String, String> maphapFPUL= new Map<String, String>();
     Map<String, String> maphapSPUL= new Map<String, String>();
     Map<String, String> maphapBPFactor= new Map<String, String>();
     Map<String, String> maphapFPFactor= new Map<String, String>();
     Map<String, String> maphapSPFactor= new Map<String, String>();
     Map<String, String> maphapBPLL= new Map<String, String>();
     Map<String, String> maphapSPLL= new Map<String, String>();
     Map<String, String> maphapFPLL= new Map<String, String>();
     
     
     String sapLLJson = '';
     try{
        system.debug('req.requestBody : ' + req.requestBody.toString());  
         /* PS1060931 start*/
         // Kevlar 1.5 changes for adding custom setting
         
         // Outer Carrier Default Weight
         Map<String, Decimal> outerCarrierweightMap = new Map<String,Decimal>();
        List<Kevlar_Outer_Carrier_Weight__c> outerCarrierweighList = Kevlar_Outer_Carrier_Weight__c.getAll().values();
        for(Kevlar_Outer_Carrier_Weight__c carrier: outerCarrierweighList ){
         outerCarrierweightMap.put(carrier.name,carrier.weight__c);   
        }
        
        // SAP Pouch Default Weight
         Map<String, Decimal> sapPouchweightMap = new Map<String,Decimal>();
        List<Kevlar_SAP_Pouch_and_Others_Weight__c> sapPouchweighList = Kevlar_SAP_Pouch_and_Others_Weight__c.getAll().values();
        for(Kevlar_SAP_Pouch_and_Others_Weight__c carrier: sapPouchweighList ){
         sapPouchweightMap.put(carrier.name,carrier.weight__c);   
        }
          /* PS1060931 End*/
         
        Schema.DescribeFieldResult SAP_Lower_Limit = Functional_Design_Requirement__c.SAP_Lower_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> SL = SAP_Lower_Limit.getPicklistValues(); 
         for(Integer i=0;i<SL.size();i++)
        {
            //sapLL.add(SL[i].getvalue());   
            sapLL = SL[i].getvalue().split(':');
            mapsapLL.put(sapLL[0], sapLL[1]); 
        }         

        sapLLJson = JSON.serialize(sapLL);
        Schema.DescribeFieldResult SAP_Upper_Limit = Functional_Design_Requirement__c.SAP_Upper_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> SU = SAP_Upper_Limit.getPicklistValues(); 
        for(Integer i=0;i<SU.size();i++)
        {             
            sapUL= SU[i].getvalue().split(':');
            mapsapUL.put(sapUL[0], sapUL[1]);   
        } 
        
        Schema.DescribeFieldResult Factor_SAP = Functional_Design_Requirement__c.Factor_SAP__c.getDescribe();    
        List<Schema.PicklistEntry> FS = Factor_SAP.getPicklistValues();  
      
        for(Integer i=0;i<FS.size();i++)
        {
            sapFactor= FS[i].getvalue().split(':');
            mapsapFactor.put(sapFactor[0], sapFactor[1]);   
              
        }
        Schema.DescribeFieldResult MV_SAP = Functional_Design_Requirement__c.SAP_Middle_Value_M__c.getDescribe();    
        List<Schema.PicklistEntry> sapMV = MV_SAP.getPicklistValues();  
      
        for(Integer i=0;i<sapMV.size();i++)
        {
           
            sapMiddleValue_M= sapMV[i].getvalue().split(':');
            mapsapMiddleValue_M.put(sapMiddleValue_M[0], sapMiddleValue_M[1]);   
        }
          
        Schema.DescribeFieldResult MV_BPHAP = Functional_Design_Requirement__c.HAP_BP_Middle_Value_M__c.getDescribe();
        List<Schema.PicklistEntry> hapBpMV = MV_BPHAP.getPicklistValues();
        for(Integer i=0;i<hapBpMV.size();i++)
        {
           
            hapBPMiddleValue_M= hapBpMV[i].getvalue().split(':');
            maphapBPMiddleValue_M.put(hapBPMiddleValue_M[0], hapBPMiddleValue_M[1]);    
        }
        
        Schema.DescribeFieldResult MV_FPHAP = Functional_Design_Requirement__c.HAP_FP_Middle_Value_M__c.getDescribe();
        List<Schema.PicklistEntry> hapFpMV = MV_FPHAP.getPicklistValues();
        for(Integer i=0;i<hapFpMV.size();i++)
        {
            
            hapFPMiddleValue_M= hapFpMV[i].getvalue().split(':');
            maphapFPMiddleValue_M.put(hapFPMiddleValue_M[0], hapFPMiddleValue_M[1]);  
        }
        
        Schema.DescribeFieldResult MV_SPHAP = Functional_Design_Requirement__c.HAP_SP_Middle_Value_M__c.getDescribe();
        List<Schema.PicklistEntry> hapSpMV = MV_SPHAP.getPicklistValues();
        for(Integer i=0;i<hapSpMV.size();i++)
        {
              
             hapSPMiddleValue_M= hapSpMV[i].getvalue().split(':');
            maphapSPMiddleValue_M.put(hapSPMiddleValue_M[0], hapSPMiddleValue_M[1]);  
        }
        Schema.DescribeFieldResult HAP_BP_Upper_Limit= Functional_Design_Requirement__c.HAP_BP_Upper_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HBUL = HAP_BP_Upper_Limit.getPicklistValues(); 
        for(Integer i=0;i<HBUL.size();i++)
        {
            
             hapBPUL= HBUL[i].getvalue().split(':');
            maphapBPUL.put(hapBPUL[0], hapBPUL[1]);    
        }
        Schema.DescribeFieldResult HAP_FP_Upper_Limit= Functional_Design_Requirement__c.HAP_FP_Upper_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HFUL= HAP_FP_Upper_Limit.getPicklistValues(); 
        for(Integer i=0;i<HFUL.size();i++)
        {
          
               hapFPUL= HFUL[i].getvalue().split(':');
            maphapFPUL.put(hapFPUL[0], hapFPUL[1]);     
        }
        
        Schema.DescribeFieldResult HAP_SP_Upper_Limit= Functional_Design_Requirement__c.HAP_SP_Upper_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HSUL = HAP_SP_Upper_Limit.getPicklistValues();    
      
        for(Integer i=0;i<HSUL.size();i++)
        {
           
             hapSPUL= HSUL[i].getvalue().split(':');
            maphapSPUL.put(hapSPUL[0], hapSPUL[1]);        
        }
      
        Schema.DescribeFieldResult Factor_HAP_BP= Functional_Design_Requirement__c.Factor_HAP_BP__c.getDescribe();    
        List<Schema.PicklistEntry> FHB = Factor_HAP_BP.getPicklistValues();
        for(Integer i=0;i<FHB.size();i++)
        {
           
            hapBPFactor= FHB[i].getvalue().split(':');
            maphapBPFactor.put(hapBPFactor[0], hapBPFactor[1]);      
        }
        Schema.DescribeFieldResult Factor_HAP_FP= Functional_Design_Requirement__c.Factor_HAP_FP__c.getDescribe();    
        List<Schema.PicklistEntry> FHF = Factor_HAP_FP.getPicklistValues(); 
        for(Integer i=0;i<FHF.size();i++)
        {
           
            hapFPFactor= FHF[i].getvalue().split(':');
            maphapFPFactor.put(hapFPFactor[0], hapFPFactor[1]);        
        }
        Schema.DescribeFieldResult Factor_HAP_SP= Functional_Design_Requirement__c.Factor_HAP_SP__c.getDescribe();    
        List<Schema.PicklistEntry> FHS = Factor_HAP_SP.getPicklistValues(); 
        for(Integer i=0;i<FHS.size();i++)
        {
              
             hapSPFactor= FHS[i].getvalue().split(':');
            maphapSPFactor.put(hapSPFactor[0], hapSPFactor[1]);     
        }
            
        Schema.DescribeFieldResult LowerLimit_HAP_BP= Functional_Design_Requirement__c.HAP_BP_Lower_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HBPLL = LowerLimit_HAP_BP.getPicklistValues(); 
        for(Integer i=0;i<HBPLL.size();i++)
        {
           
             hapBPLL= HBPLL[i].getvalue().split(':');
            maphapBPLL.put(hapBPLL[0], hapBPLL[1]);  
        }
        
        Schema.DescribeFieldResult LowerLimit_HAP_SP= Functional_Design_Requirement__c.HAP_SP_Lower_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HSPLL = LowerLimit_HAP_SP.getPicklistValues(); 
        for(Integer i=0;i<HSPLL.size();i++)
        {
              
             hapSPLL= HSPLL[i].getvalue().split(':');
            maphapSPLL.put(hapSPLL[0], hapSPLL[1]); 
        }
        
        Schema.DescribeFieldResult LowerLimit_HAP_FP= Functional_Design_Requirement__c.HAP_FP_Lower_Limit_M__c.getDescribe();    
        List<Schema.PicklistEntry> HFPLL = LowerLimit_HAP_FP.getPicklistValues(); 
        for(Integer i=0;i<HFPLL.size();i++)
        {
            
             hapFPLL= HFPLL[i].getvalue().split(':');
            maphapFPLL.put(hapFPLL[0], hapFPLL[1]); 
        }
         /* PS1060931 - added two more arguments*/
        return new CtrlKevlarSvcHelper.ReturnFDRDimensionsClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('522'),'522',mapsapLL,mapsapUL, mapsapFactor,mapsapMiddleValue_M, maphapBPLL, maphapBPUL, maphapBPFactor,maphapBPMiddleValue_M,maphapFPLL, maphapFPUL,maphapFPFactor,maphapFPMiddleValue_M,maphapSPLL,maphapSPUL,maphapSPFactor,maphapSPMiddleValue_M,outerCarrierweightMap,sapPouchweightMap,null,'200');     
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnFDRDimensionsClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null, null, '203');
    }

}
}
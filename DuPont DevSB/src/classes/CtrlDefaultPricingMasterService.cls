/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class sends default values for BA solution pricing
 ********************************************************************************************/

@RestResource(urlMapping='/DefaultPricingMaster/*')
global class CtrlDefaultPricingMasterService {
    //wrapper class
    global class PricingMasterWrapper{
        public DateTime lastSync;
    }
    
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson ='';
        system.debug('req.requestBody.toString() : ' + req.requestBody.toString());
        try{
            PricingMasterWrapper tWrap = (PricingMasterWrapper) JSON.deserialize(req.requestBody.toString(), PricingMasterWrapper.class);
            List<KevlarDefaultPricingMaster__c> defaultPMList=KevlarDefaultPricingMaster__c.getAll().values();
            Boolean flag=true;
            JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                    //if(tWrap.lastsync<>null /*&& tWrap.lastsync<defaultPMList[0].LastModifiedDate*/){
                        for(KevlarDefaultPricingMaster__c kd : defaultPMList){
                            gen.writeNumberField('costOfOuterCarrierIn'+kd.Currency__c,kd.Cost_of_Outer_Carrier__c);
                            gen.writeNumberField('costOfSapPouchesIn'+kd.Currency__c,kd.Cost_of_SAP_pouches__c);    
                        }
                        gen.writeNumberField('sapMaterialWastage',defaultPMList[0].SAP_Material_Wastage__c);
                        gen.writeNumberField('hapMaterialWastage',defaultPMList[0].HAP_Material_Wastage__c);
                        gen.writeNumberField('bamMargin',defaultPMList[0].BAM_Margin__c);
                        gen.writeDateTimeField('lastSync',defaultPMList[0].lastmodifieddate);
                    //}
                gen.writeEndObject();
            
            prettyJson=gen.getAsString();
            system.debug('@@@@@prettyJson' + prettyJson); 
            //if(tWrap.lastsync<>null && tWrap.lastsync<defaultPMList[0].LastModifiedDate){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('531'),'531', prettyJson, null, '200','null');         
            /*}
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('532'),'532', prettyJson, null, '200','null');         
            }*/
        }
        catch(Exception e){
           System.debug('Error----------'+e.getMessage());
           return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
        } 
    }
}
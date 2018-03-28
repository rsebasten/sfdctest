/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class for Delete HAP/SAP Solution.
 ********************************************************************************/
@RestResource(urlMapping='/DeleteBAS/*')
global class CtrlDeleteBASService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnDeleteBASClass doPost(){
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;   
    JSONGenerator gen = JSON.createGenerator(true); 
    String prettyJSON = '';
    
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString());
        DeleteBASWrapper bWrap= (DeleteBASWrapper) JSON.deserialize(req.requestBody.toString(), DeleteBASWrapper.class);    
        List<Body_Armor_Solution__c> bas = [SELECT Id FROM Body_Armor_Solution__c  where BA_Configuration__c=:bWrap.bacConfigurationID 
                                            AND Id IN: bWrap.baSolutionID];
        //bas.Active__c= false;
        //database.update(bas);
        delete bas;
        
        gen.writeStartObject();//json starts
            gen.writeStringField('bacConfigurationID', bWrap.bacConfigurationID);                                 
        gen.writeEndObject();//json ends
          
        prettyJSON=gen.getAsString();
         system.debug('@@@@@prettyJSON : ' + prettyJSON);
        return new CtrlKevlarSvcHelper.ReturnDeleteBASClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('530'),'530',prettyJSON, null, 'No Error');
    }
     catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnDeleteBASClass(h.dataNotSent, h.getMessage('203'),'Delete operation failed!',null, null, null, '203');
    }
    
}

    public class DeleteBASWrapper{
        public String bacConfigurationID; 
        public List<String> baSolutionID;
    }
}
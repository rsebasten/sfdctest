@RestResource(urlMapping='/UpdateSourceOfIT/*')
global class CtrlUpdateSourceOfITService {
    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost(){
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String prettyJson = '';
        
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString());
            UpdateSourceOfITWrapper tWrap = (UpdateSourceOfITWrapper) JSON.deserialize(req.requestBody.toString(), UpdateSourceOfITWrapper.class);          
            
            BA_Configuration__c bac=new BA_Configuration__c(Id=tWrap.bacConfigurationID);
            if(tWrap.sourceOfIT.size()>0){
            //    system.debug('String.valueOf(tWrap.sourceOfIT)---'+String.valueOf(tWrap.sourceOfIT));
                bac.Source_of_IT__c=String.valueOf(tWrap.sourceOfIT);
            }
            else{
                bac.Source_of_IT__c=null;
            }
            update bac; 
            system.debug('prettyJson : ' + prettyJson);
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('542'),'542', prettyJson, null, null,'null');         
        }
        catch(Exception e){
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Update failed!',null,null,null, '203',null);
        }  
    }
    //wrapper class
    global class UpdateSourceOfITWrapper{
        public String bacConfigurationID;
        public List<String> sourceOfIT;
    }
}
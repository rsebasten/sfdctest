/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Sensitive country list values for BAC.
 ********************************************************************************/

@RestResource(urlMapping = '/Sensitive_Country/*')
global class CtrlSensitiveCountryListService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> sctrList = new List<String>();
    RestRequest req = RestContext.request;
    try{ 
        system.debug('req.requestBody : ' + req.requestBody.toString());   
        Schema.DescribeFieldResult scts = BA_Configuration__c.BAC_Sensitive_Country__c.getDescribe();    
        List<Schema.PicklistEntry> sc = scts.getPicklistValues();  
        
        for(Integer i=0;i<sc.size();i++)
        {
        sctrList.add(sc[i].getvalue());   
        }       
        if(!sctrList.isEmpty()){
            return new CtrlKevlarSvcHelper.ReturnDropDownClass (h.dataSent, h.getMessage('200'),h.getResponseMessage('505'),'505', sctrList, null, 'No Error');
        }
        else{
            return new CtrlKevlarSvcHelper.ReturnDropDownClass (h.dataNotSent, h.getMessage('201'), null,null, null, null, '201');
        }   
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
    }            
}
}
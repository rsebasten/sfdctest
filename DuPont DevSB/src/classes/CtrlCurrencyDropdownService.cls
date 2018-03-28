/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Currency dropdown values for BAC.
 ********************************************************************************/

@RestResource(urlMapping = '/Currency/*')
global class CtrlCurrencyDropdownService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> curList = new List<String>();
    RestRequest req = RestContext.request;
    try{ 
        system.debug('req.requestBody : ' + req.requestBody.toString()); 
        Schema.DescribeFieldResult currenc = BA_Configuration__c.CurrencyIsoCode.getDescribe();    
        List<Schema.PicklistEntry> cur = currenc.getPicklistValues();  
        
        for(Integer i=0;i<cur.size();i++)
        {
             curList.add(cur[i].getvalue());   
        }  
        system.debug('CurrencyDropdown Result: ' + curList);          
        if(!curList.isEmpty()){
           return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('506'),'506', curList, null, 'No Error');
        }
        else{
           return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
        }  
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
    } 
}
}
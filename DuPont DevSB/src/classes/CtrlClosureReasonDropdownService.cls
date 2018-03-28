/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Closure Reason dropdown values for BAC.
 ********************************************************************************/
@RestResource(urlMapping = '/CR/*')
global class CtrlClosureReasonDropdownService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> crList = new List<String>(); 
    RestRequest req = RestContext.request;   
    try{
        system.debug('req.requestBody : ' + req.requestBody.toString()); 
        Schema.DescribeFieldResult cr = BA_Configuration__c.Closure_Reason__c.getDescribe();    
        List<Schema.PicklistEntry> c = cr.getPicklistValues();        
        for(Integer i=0;i<c.size();i++)
            {
                 crList.add(c[i].getvalue());   
            } 
        system.debug('ClosureReasonDropdown Result : ' + crList);             
        if(!crList.isEmpty()){
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('504'),'504', crList, null, 'No Error');
        }
        else{
            return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
        }   
    }
    catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
    }           
}
}
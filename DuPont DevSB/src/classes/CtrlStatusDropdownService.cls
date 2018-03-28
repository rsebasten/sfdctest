/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the status dropdown values for BAC.
 ********************************************************************************/
@RestResource(urlMapping = '/Status/*')
global class CtrlStatusDropdownService{
 
@HttpPost
global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    List<String> strList = new List<String>();
    RestRequest req = RestContext.request;
    try{  
        system.debug('req.requestBody : ' + req.requestBody.toString()); 
        Schema.DescribeFieldResult sts = BA_Configuration__c.status__c.getDescribe();    
        List<Schema.PicklistEntry> s = sts.getPicklistValues();  
        
             for(Integer i=0;i<s.size();i++)
                {
                     strList.add(s[i].getvalue());   
                }   
             system.debug('StatusDropdown result : ' + strList);   
            if(!strList.isEmpty()){
                return new CtrlKevlarSvcHelper.ReturnDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('501'),'501',strList, null, 'No Error');
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
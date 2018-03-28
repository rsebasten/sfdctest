/*******************************************************************************
(C)2015
Author: pallavi sharma
Email: pallavi.sharma3@tcs.com
Description:  This class returns the my BAC/Campaign Progress dropdown.
 ********************************************************************************/
 
 @RestResource(urlMapping='/BACProgress/*')
 global class CtrlBACProgressDropdownService{
 
 @HttpPost
 global static CtrlKevlarSvcHelper.ReturnDropDownClass doPost()
 {
 
 CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
 RestRequest req = RestContext.request;
 try{
    system.debug('req.requestBody : ' + req.requestBody.toString()); 
    List<String> progressList = new List<String>();    
    Schema.DescribeFieldResult progress = BA_Configuration__c.BAC_Progress__c.getDescribe();    
    List<Schema.PicklistEntry> c = progress.getPicklistValues();
    for(Integer i=0;i<c.size();i++)
        {
             progressList.add(c[i].getvalue());   
        }  
    //system.debug('@@@@@BACProgressDropdown ' + progressList);      
    if(!progressList.isEmpty()){
        return new CtrlKevlarSvcHelper.ReturnDropDownClass (h.dataSent, h.getMessage('200'),h.getResponseMessage('507'),'507', progressList, null, 'No Error');
    }
    else{
        return new CtrlKevlarSvcHelper.ReturnDropDownClass (h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
    }        
 }
  catch(Exception e){
        System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
         return new CtrlKevlarSvcHelper.ReturnDropDownClass (h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null,null, '203');
    }
 }
 
 }
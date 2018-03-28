/**********************************************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the color dropdown values for BAC from Functional Design Requirement table.
 *********************************************************************************************************/
 
@RestResource(urlMapping = '/Color/*')
global class CtrlColorDropdownService{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnColorDropDownClass doPost() {
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
    RestRequest req = RestContext.request;
    try{ 
        system.debug('req.requestBody : ' + req.requestBody.toString());   
        List<Kevlar_Color_of_BA__c> colorList;
        Map<String, String> colorCodeMap = new Map<String, String>();
        colorList = [select name,Color__c, RGB_Code__c from Kevlar_Color_of_BA__c];
        for( Kevlar_Color_of_BA__c baColor :colorList)
            {
                colorCodeMap.put(baColor.Color__c,baColor.RGB_Code__c);
                
            }
       // system.debug('ColorDropdown Result: ' + colorCodeMap);                
        if(!colorCodeMap.isEmpty()){
            return new CtrlKevlarSvcHelper.ReturnColorDropDownClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('503'),'503',colorCodeMap, null, 'No Error');
        }
        else{
            return new CtrlKevlarSvcHelper.ReturnColorDropDownClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
        } 
    }
    catch(Exception e){
      //  System.debug('Error----------'+e.getMessage());
        //return e.getMessage();
        return new CtrlKevlarSvcHelper.ReturnColorDropDownClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
    } 
               
}
}
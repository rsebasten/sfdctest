/*******************************************************************************
(C)2015
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class returns the Team Members dropdown values for BAC.
 ********************************************************************************/

@RestResource(urlMapping = '/TMS/*')
global class CtrlTeamMemberDropdownService{

    @HttpPost
    global static CtrlKevlarSvcHelper.ReturnClass doPost() {
        CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
        RestRequest req = RestContext.request;
        try{
            system.debug('req.requestBody : ' + req.requestBody.toString()); 
            List<User> result = [Select id, name,FullPhotoUrl,smallPhotoURL,username,User_Country__c,/*User_Region__c,*/Kevlar_User_Region__c,
                                 Role_in_Kevlar__c,Sensitive_Destination_Kevlar__c,No_Restriction_Destination_Kevlar__c,Suspend_Team_Go_ahead_Destination_Kevla__c,
                                 Restrictive_Destination_Kevlar__c from User WHERE Work_for_Kevlar__c = true ORDER BY NAME];    
           
            system.debug('TeamMemberDropdown Result : ' + result); 
            if(!result.isEmpty()){
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('502'),'502',result, null, '200');
            }
            else{
                return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('201'),null,null, null, null, '201');
            } 
        }
        catch(Exception e){
            System.debug('Error----------'+e.getMessage());
            return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Data loading failed!',null, null, null, '203');
        }  
    }
}
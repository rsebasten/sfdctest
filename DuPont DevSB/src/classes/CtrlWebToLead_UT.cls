/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Test Class for ctrlWebToLead controller
********************************************************************************/

@isTest
public class CtrlWebToLead_UT {
    
    public static testMethod void testCtrlWebToLead(){
    ctrlWebToLead cwtl = new ctrlWebToLead();
    cwtl.init();
    String test='one:two:three';
     Id lead_id= '00Q4100000agPQL';
     String  c_id= '70141000000aaab';
    String testqs=cwtl.fieldsToQueryString(test);
    cwtl.insertLead();
    cwtl.checkCAPTCHA();
    cwtl.getReferer();
    cwtl.lookupSiteObject();
    cwtl.getBoolean('test');
    cwtl.addCampaign(lead_id, c_id);    
} 

}
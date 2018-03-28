/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger Handler for Account
********************************************************************************/
public class AccountHandler extends TriggerHandlerBase {
    
    static public boolean hasTriggerExecuted = false;  

    public override void bulkbefore() {
            if (Trigger.isInsert || Trigger.isUpdate) {
                geoValidation.geoValidateAccount(); 
                accountSBU.registerSBU(Trigger.new);        
        }
        
        //set customer segment for new NH Prospect accounts & test for overrides on update & set Sales Region and Sub Region.
        //NH_Account_Helper.ProspectSegmentAssignment(this);
        //if(Trigger.isUpdate){
        //    NH_Account_Helper.SegmentOverride(this);
        //}
        //NH_Account_Helper.AssignRegion(this);
    }
    
/*
    public override void bulkafter() {
        if (!hasTriggerExecuted) {
            hasTriggerExecuted = true;
            if (Trigger.isInsert || Trigger.isUpdate){
                CompanyMailingAddress.createCompanyMailingAddress(this);
                NH_Account_Helper.checkForAccessGroup(this, trigger.oldmap);
                if(trigger.isUpdate){
                    NH_Account_Helper.ProspectSegmentAssignmentChildren(this);
                }
            }
            
        }
    }
*/    

}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Neha Badala
Email: neha.badala@tcs.com
Description: This test class is used for unit testing the cls_AssignCampaignId class.
Created Date: 10/14/2016
Version: 1.0
1.1    03-Jan-2017    Krishna Kamineni    user is assigned to system user in line 20
********************************************************************************/
@isTest
private class cls_AssignCampaignId_UT
{
static testMethod void AssignCampaignIdTest()
    {
        utilKevlarTestData util = new utilKevlarTestData();
        User u = util.createPortalUser();
        try{
        	insert u;
        }catch(Exception e){
            u=[SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        }
        Campaign objCamp = util.createCampaign();
        insert objCamp; 
            
        Lead ObjLd = new Lead();
        
        System.runAs(u){
            test.StartTest();
            DPSKevlarCustomSetting__c dps = util.createCustomSetting();
            insert dps; 
            Lead objLead = util.createLead();
            insert objLead;
            ObjLd = objLead;
            cls_AssignCampaignId.assignCampId(objLead.Id);
            test.StopTest();
        }
        List<CampaignMember> cmLst = [Select name from CampaignMember WHERE CampaignId =: objCamp.id and LeadId =: ObjLd.id];
        system.assertEquals(1,cmLst.size()); 
    }   
}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Vijay LAxmi
Email: vijay.laxmi1@tcs.com
Description:  Unit test for batch_CpsfLeadCompanyIdUpdate 

***********************************************************/
@isTest(seealldata=false)
private class batch_CpsfLeadCompanyIdUpdate_UT
{
     static String leadRtypeId = Rtype.getIdByDevName('Lead','BI-All');
     
     static  Lead updateLead()
     {
        
        Lead lead1 = new Lead(Firstname='fName1',LastName=' lName1',company='aaa',Name_ID__c='1.0',Legacy_Lead_ID__c='CPSF_00-0001^TES00-0003^1^1',OwnerId=Label.External_Initiative_Owner_Name,RecordTypeId=leadRtypeId); 
       
        insert lead1; 
        lead1.Dodge_Company_Id__c ='TES00-0003';
        update lead1;
        return lead1;
    }
    
     public static testMethod void test_Unitcase1() 
    {
        batch_CpsfLeadCompanyIdUpdate_UT.updateLead();
        database.executebatch(new batch_CpsfLeadCompanyIdUpdate());
    }
    
     
        
    }
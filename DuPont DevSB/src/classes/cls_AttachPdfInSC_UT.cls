/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Neha Badala
Email: neha.badala@tcs.com
Description: This test class is used for unit testing of cls_AttachPdfInSC class.
Created Date: 10/14/2016
Version: 1.0
1.1 	03-Jan-2017		Krishna Kamineni		User is assigned with a system value
												in catchblock at line 21
********************************************************************************/

@isTest
private class cls_AttachPdfInSC_UT
{
    static testMethod void AttachPdfInSCTest()
    {
        utilKevlarTestData util = new utilKevlarTestData();         
        User u = util.createPortalUser();
        try{
        	insert u;
        }catch(Exception e){
            u=[SELECT Id 
               FROM User
               WHERE Id=:UserInfo.getUserId() LIMIT 1];
        }

        List<Search_Criteria__c> listSrchCrit = util.createSearchCriteria();
        insert listSrchCrit; 
                     
        System.runAs(u) {    
            test.StartTest();                                         
            cls_AttachPdfInSC.attachPdf(listSrchCrit[1].id);            
            test.StopTest();
        }
        List<Attachment> attachLst = [SELECT name FROM Attachment WHERE ParentId =: listSrchCrit[1].id ORDER BY CreatedDate desc LIMIT 1];           
        system.assertEquals(1,attachLst.size());                                     
    }   
}
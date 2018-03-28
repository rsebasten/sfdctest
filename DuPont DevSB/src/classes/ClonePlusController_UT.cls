/*******************************************************************************
Author: Alex Cottner
Author Email: acottner@sssworld.com
Description: Advanced clone page controller test case. 
//[06142017] Merge&Spin: Changed Test objects from DSS_CT_Proposal to Account and Opportunity
********************************************************************************/
@isTest
private class ClonePlusController_UT {
    static testMethod void myUnitTest() {
        
        
        // TO DO: implement unit test
        Account acc = generateTestProposal();
        
        PageReference pageRef = new PageReference('/apex/CloneRecord?id=' + acc.Id + '&childobjecttypes=Opportunity');
        Test.setCurrentPage(pageRef);
        
        ClonePlusController c = new ClonePlusController();
        c.initialiseObjectsForCloning();
        System.assertEquals('Test Account', c.objectName);
        System.assertEquals('Account', c.objectTypeName);
        
        PageReference newPage = c.doClone();
   //     DSS_CT_Proposal__c clonedProposal = [select Id, Name from DSS_CT_Proposal__c where Id != :proposal.Id limit 1];
   			Account ac =[Select id, Name from Account where id != :acc.id limit 1];
        System.assertEquals('/' + ac.Id, newPage.getUrl());
       // List<DSS_CT_Proposal_Item__c> clonedProposalDetails = [select Id from DSS_CT_Proposal_Item__c where Proposal__c = :clonedProposal.Id];
      List<Opportunity> oppList = [Select id from Opportunity where AccountId = :ac.id];
        System.assertEquals(1, oppList.size());
        //  System.assertEquals(3, clonedProposalDetails.Size());
        
    }
    
    static Account generateTestProposal() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = RType.getIdByDevName('Account','BI_Surfaces'); 
        acc.Country__c = 'UNITED STATES';
        acc.Industry = 'Other';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.id;
        opp.Name = 'Test Opportunity';
        opp.Industry__c = 'Solar';
        opp.Market_Segment__c = 'Acid';
        opp.CloseDate = Date.today();
        opp.StageName = 'Target';
        opp.Status__c = 'In Progress';
        insert opp;
        
        
        
        return acc;
    }
}
/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Test Class for ctrlOppSFDCToSFDCShowHeader test class

Merge&Spin - Removed (seeAllData=true)
********************************************************************************/
@isTest
public class ctrlOppSFDCToSFDCShowHeader_UT { 
    private static final String CONNECTIONNAME = 'Parksite Inc'; //Name of the SFDC TO SFDC Connection
    private static final String CONNECTIONSTATUS = 'Accepted'; //Status of the connection should be Accepted
    
    static testMethod void executeTest() {
        try{
            Test.startTest();
            //Account acc =  [select id from Account where Name ='Parksite (IL) Tyvek - HQ' AND country__C='UNITED STATES'];
            Account acc  = new Account();
            acc.Name = 'Parksite (IL) Tyvek - HQ';
            acc.country__C = 'UNITED STATES';
            insert acc;
            External_Initiative__c ei = new External_Initiative__c(name='BI NA Test EI 3', Segment_L2__c='Test', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            RecordType rt = [Select id from RecordType where name = 'BI-NA MHC Opportunity' LIMIT 1];
            
            Opportunity opp1     = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            insert opp1;
            
            ApexPages.StandardController sc = new ApexPages.standardController(opp1);             
            ctrlOppSFDCToSFDCShowHeader ctrlObj = new ctrlOppSFDCToSFDCShowHeader( sc); 
            
            System.assertEquals(false, ctrlObj.pnrcShowHeaderObj.isShared);
            
            List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>(
                [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = : CONNECTIONSTATUS and ConnectionName  = : CONNECTIONNAME LIMIT 1]
            );
            
            
            PartnerNetworkConnection pncObject =  connMap[0];//Get the Partner Network Connection 
            PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();            
            newrecord.ConnectionId = pncObject.Id;
            newrecord.LocalRecordId = opp1.id;  
            insert newrecord;
            ApexPages.currentPage().getParameters().put('id', opp1.id);    
            sc = new ApexPages.standardController(opp1);             
            ctrlObj = new ctrlOppSFDCToSFDCShowHeader(sc);
            
            System.assertEquals(true, ctrlObj.pnrcShowHeaderObj.isShared);
            
            
            Test.stopTest();
        }catch(Exception e){
            e.getStackTraceString();
        }
        
    }
    
    
    
}
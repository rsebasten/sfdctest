/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Test Class for ctrlOppSFDCToSFDC helper class

<AB20141111> updated End – Lost with End - Lost changed long hyphen with short hyphen
<AB20141111> updated End – Won with End - Won changed long hyphen with short hyphen
//<AB20160601> Overriding filter criteria if opportunity description contains word Override
********************************************************************************/
@isTest(seeAllData=true)
public class ctrlOppSFDCToSFDC_UT {
    static testMethod void createTestData() {
        try{
            Test.startTest();
            
            //createTestCustomSettings();
            
            Account acc =  [select id from Account where Name ='Parksite (IL) Tyvek - HQ' AND country__C='UNITED STATES'];//new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            //insert acc;
            External_Initiative__c ei = new External_Initiative__c(name='BI NA Test EI 3', Segment_L2__c='Test', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            RecordType rt = [Select id from RecordType where name = 'BI-NA MHC Opportunity' LIMIT 1];
            
            Opportunity opp1 	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp2	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite	7',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id, Description='OverRide');
            Opportunity opp3	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite	8',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp4	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite	9',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp5	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite	10',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            
            acc =  [select id from Account where Name ='Parksite (NE) Surfaces' LIMIT 1];//new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            //insert acc;
            ei = new External_Initiative__c(name='BI NA Test EI 4', Segment_L2__c='Clinic', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            rt = [Select id from RecordType where name = 'BI-NA Surfaces Dodge' LIMIT 1];
            
            Opportunity opp6 	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp7 	 = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id,description='Override');
            List<Opportunity> opps = new List<Opportunity>();
            
            opps.add(opp1);
            opps.add(opp2);
            opps.add(opp3);
            opps.add(opp4);
            opps.add(opp5);
            opps.add(opp6);
            opps.add(opp7);
            insert opps;
            
            ctrlOppSFDCToSFDC cos2s = new ctrloppSFDCToSFDC(opps,true);
            
            List<ID> oppExistingIds = new List<ID>();
            List<PartnerNetworkRecordConnection> existingRecords = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId  In  : opps LIMIT 1000];
            for(PartnerNetworkRecordConnection existingRecord : existingRecords){
                oppExistingIds.add(existingRecord.LocalRecordId);
            }
            
            update opps;
            
            batchOppSFDCToSFDC bosts = new batchOppSFDCToSFDC();
            
            Database.executeBatch(bosts,1000);
            Test.stopTest();
        }catch(Exception e){
            system.debug('--->>>Exception Occured '+e.getStackTraceString());
        }
    }
    
    static void  createTestCustomSettings(){
        
        list<BINASFDCToSFDC__C> lstBINASF2SF = new   list<BINASFDCToSFDC__C>();
        
        BINASFDCToSFDC__C  	AccountCS = new BINASFDCToSFDC__C();
        AccountCS.Name = 'Account';
        AccountCS.Value__c = 'Parksite (IL) Tyvek - HQ';
        lstBINASF2SF.add(AccountCS);
        
        BINASFDCToSFDC__C  	ApplicationTypeCS = new BINASFDCToSFDC__C();
        ApplicationTypeCS.Name = 'Application Type';
        ApplicationTypeCS.Value__c = 'CLT-Tyvek';
        lstBINASF2SF.add(ApplicationTypeCS);
        
        BINASFDCToSFDC__C  	CloseDateCS = new BINASFDCToSFDC__C();
        CloseDateCS.Name = 'Close Date';
        CloseDateCS.Value__c = '1/1/2013';
        lstBINASF2SF.add(CloseDateCS);
        
        BINASFDCToSFDC__C  	EISegmentL2AnimalPlantCS = new BINASFDCToSFDC__C();
        EISegmentL2AnimalPlantCS.Name = 'EI Segment L2 Animal/Plant';
        EISegmentL2AnimalPlantCS.Value__c = 'Animal/Plant';
        lstBINASF2SF.add(EISegmentL2AnimalPlantCS);
        
        BINASFDCToSFDC__C  	EISegmentL2BathBeachCS = new BINASFDCToSFDC__C();
        EISegmentL2BathBeachCS.Name = 'EI Segment L2 Bath/Beach';
        EISegmentL2BathBeachCS.Value__c = 'Bath/Beach';
        lstBINASF2SF.add(EISegmentL2BathBeachCS);
        
        BINASFDCToSFDC__C  	EISegmentL2BowlingCS = new BINASFDCToSFDC__C();
        EISegmentL2BowlingCS.Name = 'EI Segment L2 Bowling';
        EISegmentL2BowlingCS.Value__c = 'Bowling';
        lstBINASF2SF.add(EISegmentL2BowlingCS);
        
        BINASFDCToSFDC__C  	EISegmentL2CommunicationsCS = new BINASFDCToSFDC__C();
        EISegmentL2CommunicationsCS.Name = 'EI Segment L2 Communications';
        EISegmentL2CommunicationsCS.Value__c = 'Communications';
        lstBINASF2SF.add(EISegmentL2CommunicationsCS);
        
        BINASFDCToSFDC__C  	EISegmentL2CustomHouseCS = new BINASFDCToSFDC__C();
        EISegmentL2CustomHouseCS.Name = 'EI Segment L2 Custom House';
        EISegmentL2CustomHouseCS.Value__c = 'Custom House';
        lstBINASF2SF.add(EISegmentL2CustomHouseCS);
        
        BINASFDCToSFDC__C  	EISegmentL2FactoriesCS = new BINASFDCToSFDC__C();
        EISegmentL2FactoriesCS.Name = 'EI Segment L2 Factories';
        EISegmentL2FactoriesCS.Value__c = 'Factories';
        lstBINASF2SF.add(EISegmentL2FactoriesCS);
        
        BINASFDCToSFDC__C  	EISegmentL2FloodDamCS = new BINASFDCToSFDC__C();
        EISegmentL2FloodDamCS.Name = 'EI Segment L2 Flood Dam';
        EISegmentL2FloodDamCS.Value__c = 'Flood Dam';
        lstBINASF2SF.add(EISegmentL2FloodDamCS);
        
        BINASFDCToSFDC__C  	EISegmentL2OtherTerminalCS = new BINASFDCToSFDC__C();
        EISegmentL2OtherTerminalCS.Name = 'EI Segment L2 Other Terminal';
        EISegmentL2OtherTerminalCS.Value__c = 'Other Terminal';
        lstBINASF2SF.add(EISegmentL2OtherTerminalCS);
        
        BINASFDCToSFDC__C  	EISegmentL2ParksPlaygroundCS = new BINASFDCToSFDC__C();
        EISegmentL2ParksPlaygroundCS.Name = 'EI Segment L2 Parks/Playground';
        EISegmentL2ParksPlaygroundCS.Value__c = 'Parks/Playground ';
        lstBINASF2SF.add(EISegmentL2ParksPlaygroundCS);
        
        BINASFDCToSFDC__C  	EISegmentL2PrisonsCS = new BINASFDCToSFDC__C();
        EISegmentL2PrisonsCS.Name = 'EI Segment L2 Prisons';
        EISegmentL2PrisonsCS.Value__c = 'Prisons';
        lstBINASF2SF.add(EISegmentL2PrisonsCS);
        
        BINASFDCToSFDC__C  	EISegmentL2SpecHousesCS = new BINASFDCToSFDC__C();
        EISegmentL2SpecHousesCS.Name = 'EI Segment L2 Spec Houses';
        EISegmentL2SpecHousesCS.Value__c = 'Spec Houses';
        lstBINASF2SF.add(EISegmentL2SpecHousesCS);
        
        BINASFDCToSFDC__C  	EISegmentL2SpecialCS = new BINASFDCToSFDC__C();
        EISegmentL2SpecialCS.Name = 'EI Segment L2 Special';
        EISegmentL2SpecialCS.Value__c = 'Special';
        lstBINASF2SF.add(EISegmentL2SpecialCS);
        
        BINASFDCToSFDC__C  	EISegmentL2SwimPoolsCS = new BINASFDCToSFDC__C();
        EISegmentL2SwimPoolsCS.Name = 'EI Segment L2 Swim Pools';
        EISegmentL2SwimPoolsCS.Value__c = 'Swim Pools ';
        lstBINASF2SF.add(EISegmentL2SwimPoolsCS);
        
        BINASFDCToSFDC__C  	EISegmentL2WarehouseOtherCS = new BINASFDCToSFDC__C();
        EISegmentL2WarehouseOtherCS.Name = 'EI Segment L2 Warehouse Other';
        EISegmentL2WarehouseOtherCS.Value__c = 'Warehouse Other';
        lstBINASF2SF.add(EISegmentL2WarehouseOtherCS);
        
        BINASFDCToSFDC__C  	EISegmentL2WarehouseRefrigeratedCS = new BINASFDCToSFDC__C();
        EISegmentL2WarehouseRefrigeratedCS.Name = 'EI Segment L2 Warehouse Refrigerated';
        EISegmentL2WarehouseRefrigeratedCS.Value__c = 'Warehouse Refrigerated';
        lstBINASF2SF.add(EISegmentL2WarehouseRefrigeratedCS);
        
        BINASFDCToSFDC__C  	EISegmentL2WaterTreatmentCS = new BINASFDCToSFDC__C();
        EISegmentL2WaterTreatmentCS.Name = 'EI Segment L2 Water Treatment';
        EISegmentL2WaterTreatmentCS.Value__c = 'Water Treatment';
        lstBINASF2SF.add(EISegmentL2WaterTreatmentCS);
        
        BINASFDCToSFDC__C  	EISegmentL3BuildingAdditionsCS = new BINASFDCToSFDC__C();
        EISegmentL3BuildingAdditionsCS.Name = 'EI Segment L3 Building Additions';
        EISegmentL3BuildingAdditionsCS.Value__c = 'Building Additions';
        lstBINASF2SF.add(EISegmentL3BuildingAdditionsCS);
        
        BINASFDCToSFDC__C  	EISegmentL3NewConstructionCS = new BINASFDCToSFDC__C();
        EISegmentL3NewConstructionCS.Name = 'EI Segment L3 New Construction';
        EISegmentL3NewConstructionCS.Value__c = 'New Construction';
        lstBINASF2SF.add(EISegmentL3NewConstructionCS);
        
        BINASFDCToSFDC__C  	EIStageAbandonedCS = new BINASFDCToSFDC__C();
        EIStageAbandonedCS.Name = 'EI Stage Abandoned';
        EIStageAbandonedCS.Value__c = 'Pre-Planning';
        lstBINASF2SF.add(EIStageAbandonedCS);
        
        BINASFDCToSFDC__C  	EIStageDeferredCS = new BINASFDCToSFDC__C();
        EIStageDeferredCS.Name = 'EI Stage Deferred';
        EIStageDeferredCS.Value__c = 'Occupancy';
        lstBINASF2SF.add(EIStageDeferredCS);
        
        BINASFDCToSFDC__C  	EIStageOccupancyCS = new BINASFDCToSFDC__C();
        EIStageOccupancyCS.Name = 'EI Stage Occupancy';
        EIStageOccupancyCS.Value__c = 'Abandoned';
        lstBINASF2SF.add(EIStageOccupancyCS);
        
        BINASFDCToSFDC__C  	EIStagePrePlanningCS = new BINASFDCToSFDC__C();
        EIStagePrePlanningCS.Name = 'EI Stage Pre-Planning';
        EIStagePrePlanningCS.Value__c = 'Deferred';
        lstBINASF2SF.add(EIStagePrePlanningCS);
        
        BINASFDCToSFDC__C  	OpportunityRecordTypeCS = new BINASFDCToSFDC__C();
        OpportunityRecordTypeCS.Name = 'Opportunity Record Type';
        OpportunityRecordTypeCS.Value__c = 'BI-NA MHC Opportunity';
        lstBINASF2SF.add(OpportunityRecordTypeCS);
        
        BINASFDCToSFDC__C  	OpportunityStageEndLostCS = new BINASFDCToSFDC__C();
        OpportunityStageEndLostCS.Name = 'Opportunity Stage End Lost';
        OpportunityStageEndLostCS.Value__c = 'End - Lost';//<AB20141111> updated End – Lost with End - Lost changed long hyphen with short hyphen
        lstBINASF2SF.add(OpportunityStageEndLostCS);
        
        BINASFDCToSFDC__C  	OpportunityStageEndWonCS = new BINASFDCToSFDC__C();
        OpportunityStageEndWonCS.Name = 'Opportunity Stage End Won';
        OpportunityStageEndWonCS.Value__c = 'End - Won';//<AB20141111> updated End – Won with End - Won changed long hyphen with short hyphen
        lstBINASF2SF.add(OpportunityStageEndWonCS);
        
        BINASFDCToSFDC__C  	SendMailCS = new BINASFDCToSFDC__C();
        SendMailCS.Name = 'SendMail';
        SendMailCS.Value__c = 'TRUE';
        lstBINASF2SF.add(SendMailCS);
        
        BINASFDCToSFDC__C  	ValueCS = new BINASFDCToSFDC__C();
        ValueCS.Name = 'Value';
        ValueCS.Value__c = '2500000';
        lstBINASF2SF.add(ValueCS);
        
        
        
        insert lstBINASF2SF;
        
        
    }
    
}
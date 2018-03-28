@isTest
public class BatchOppSFDCToSFDCBatchable_UT {
    static testMethod void createTestData() {
            Test.startTest();
            
              Opp_ParkSite_Batch_Assertion__c dataSOQL = Opp_ParkSite_Batch_Assertion__c.getOrgDefaults();

              if (dataSOQL.Id <> null) {
                  dataSOQL.Parksite_Batch_Assertion__c = 'Auto';
                  update dataSOQL;
              }
              else{
                  dataSOQL.Parksite_Batch_Assertion__c = 'Auto';
                  dataSOQL.SetupOwnerId=UserInfo.getOrganizationId();
                  insert dataSOQL;
              }
            
            Account acc =  
            //[select id from Account where Name ='Parksite (IL) Tyvek - HQ' AND country__C='UNITED STATES'];
            new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            insert acc;
            External_Initiative__c ei = new External_Initiative__c(name='BI NA Test EI 3', Segment_L2__c='Test', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            RecordType rt = [Select id from RecordType where name = 'BI-NA MHC Opportunity' LIMIT 1];
            
            Opportunity opp1    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, product__c = 'Adhesive (1 layer)', Account=acc, Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp2   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  7',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, product__c = 'Adhesive (1 layer)', Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id, Description='OverRide');
            Opportunity opp3   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  8',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, product__c = 'Adhesive (1 layer)', Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp4   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  9',Parksite_Batch_Assertion__c ='Manual',AccountId=acc.id,product__c = 'Adhesive (1 layer)', Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp5   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  10',Parksite_Batch_Assertion__c ='Manual',AccountId=acc.id,product__c = 'Adhesive (1 layer)', Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            
            //acc =  [select id from Account where Name ='Parksite (NE) Surfaces' LIMIT 1];//new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            //insert acc;
            ei = new External_Initiative__c(name='BI NA Test EI 4', Segment_L2__c='Clinic', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            rt = [Select id from RecordType where name = 'BI-NA Surfaces Dodge' LIMIT 1];
            
            Opportunity opp6    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, product__c = 'Adhesive (1 layer)', Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp7    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, product__c = 'Adhesive (1 layer)', Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id,description='Override');
            List<Opportunity> opps = new List<Opportunity>();
            
            opps.add(opp1);
            opps.add(opp2);
            opps.add(opp3);
            opps.add(opp4);
            opps.add(opp5);
            opps.add(opp6);
            opps.add(opp7);
            insert opps;
            
            ctrlOppSFDCToSFDC cos2s = new ctrloppSFDCToSFDC(opps);
            
            List<ID> oppExistingIds = new List<ID>();
            List<PartnerNetworkRecordConnection> existingRecords = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId  In  : opps LIMIT 1000];
            for(PartnerNetworkRecordConnection existingRecord : existingRecords){
                oppExistingIds.add(existingRecord.LocalRecordId);
            }
            
            update opps;
            
            BatchOppSFDCToSFDCBatchable bosts = new BatchOppSFDCToSFDCBatchable();
            
            Database.executeBatch(bosts,1000);
            Test.stopTest();
    }
    
    static testMethod void createTestData2() {
            Test.startTest();
            
              Opp_ParkSite_Batch_Assertion__c dataSOQL = Opp_ParkSite_Batch_Assertion__c.getOrgDefaults();

              if (dataSOQL.Id <> null) {
                  dataSOQL.Parksite_Batch_Assertion__c = 'Manual';
                  update dataSOQL;
              }
              else{
                  dataSOQL.Parksite_Batch_Assertion__c = 'Manual';
                  dataSOQL.SetupOwnerId=UserInfo.getOrganizationId();
                  insert dataSOQL;
              }
            
            Account acc =  
            //[select id from Account where Name ='Parksite (IL) Tyvek - HQ' AND country__C='UNITED STATES'];
            new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            insert acc;
            External_Initiative__c ei = new External_Initiative__c(name='BI NA Test EI 3', Segment_L2__c='Test', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            RecordType rt = [Select id from RecordType where name = 'BI-NA MHC Opportunity' LIMIT 1];
            
            Opportunity opp1    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, Account=acc, Amount=25000000,Application_Type__c='CLT-Tyvek',product__c = 'Adhesive (1 layer)',stageName='Propose',closeDate=Date.newinstance(2014,9,30),   recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp2   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  7',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',product__c = 'Adhesive (1 layer)',stageName='Propose',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id, Description='OverRide');
            Opportunity opp3   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  8',Parksite_Batch_Assertion__c ='Auto',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',product__c = 'Adhesive (1 layer)',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp4   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  9',Parksite_Batch_Assertion__c ='Manual',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',product__c = 'Adhesive (1 layer)',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp5   = new Opportunity(name='BI-NA MHC Opportunity For Parksite  10',Parksite_Batch_Assertion__c ='Manual',AccountId=acc.id, Account=acc,Amount=25000000,Application_Type__c='CLT-Tyvek',stageName='Propose',product__c = 'Adhesive (1 layer)',closeDate=Date.newinstance(2014,9,30),  recordtypeid=rt.id, External_Initiative__c=ei.id);
            
            //acc =  [select id from Account where Name ='Parksite (NE) Surfaces' LIMIT 1];//new Account(Name ='Parksite (IL) Tyvek - HQ',country__C='US');
            //insert acc;
            ei = new External_Initiative__c(name='BI NA Test EI 4', Segment_L2__c='Clinic', Segment_L3__c='New Construction', Stage__c='Bidding',value__c=27800000);
            insert ei;
            rt = [Select id from RecordType where name = 'BI-NA Surfaces Dodge' LIMIT 1];
            
            Opportunity opp6    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30), product__c = 'Adhesive (1 layer)',recordtypeid=rt.id, External_Initiative__c=ei.id);
            Opportunity opp7    = new Opportunity(name='BI-NA MHC Opportunity For Parksite 6',AccountId=acc.id, Account=acc, Amount=20000000,Application_Type__c='CLT-Surfaces',stageName='Propose',closeDate=Date.newinstance(2014,9,30), product__c = 'Adhesive (1 layer)',  recordtypeid=rt.id, External_Initiative__c=ei.id,description='Override');
            List<Opportunity> opps = new List<Opportunity>();
            
            opps.add(opp1);
            opps.add(opp2);
            opps.add(opp3);
            opps.add(opp4);
            opps.add(opp5);
            opps.add(opp6);
            opps.add(opp7);
            insert opps;
            
            ctrlOppSFDCToSFDC cos2s = new ctrloppSFDCToSFDC(opps);
            
            List<ID> oppExistingIds = new List<ID>();
            List<PartnerNetworkRecordConnection> existingRecords = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId  In  : opps LIMIT 1000];
            for(PartnerNetworkRecordConnection existingRecord : existingRecords){
                oppExistingIds.add(existingRecord.LocalRecordId);
            }
            
            update opps;
            
            BatchOppSFDCToSFDCBatchable bosts = new BatchOppSFDCToSFDCBatchable();
            
            Database.executeBatch(bosts,1000);
            Test.stopTest();
    }
}
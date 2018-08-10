@isTest (SeeALLData=False)
public class SFDC_MetadataSync_Test {
    

     // Test Sync Method
    static testMethod void testNewSyncPositive(){
        
        //Create Org Credential
        copado__Org__c sourceOrg = new copado__Org__c();
        sourceOrg.name = 'TestDest';
        insert sourceOrg;
        
        // Create Copado Deploy
        copado__Deployment__c deploymentRecord = new copado__Deployment__c();
        deploymentRecord.copado__From_Org__c = sourceOrg.Id;
        insert deploymentRecord;
         
        // Create Copado Deploy Step
        copado__Step__c step1 = new copado__Step__c();
        step1.copado__Deployment__c = deploymentRecord.Id;
        step1.copado__Type__c='Metadata';
        insert step1;
        
        // Create Attachment related to Step
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.Body = BLOB.valueOf('[{"t":"CustomField","n":"WorkOrderLineItem.ServiceAppointmentCount","s":true},{"t":"CustomField","n":"WorkOrderLineItem.Priority","s":true},{"t":"CustomField","n":"WorkOrderLineItems.Priorities23423","s":true}]');
        att.ParentId = step1.id;
        insert att;
        
        // Create Sync for a BU
        Metadata_Sync__c sync1 = new Metadata_Sync__c();
        sync1.Copado_Deployment__c = deploymentRecord.id;
        sync1.Sync_Level__c = 'Production';
        sync1.Name = 'AgCo';
        sync1.Master_Org__c = false;
        insert sync1;
        
        Test.startTest();
        
        // Test the constructor for a BU 
        ApexPages.currentPage().getParameters().put('id',sync1.id);
        ApexPages.StandardController stdCont1 = new ApexPages.StandardController(sync1);
        SFDC_MetadataSync_Controller objController1 = new SFDC_MetadataSync_Controller(stdCont1);
	
        // Test the Sync
        objController1.syncLines();
        
         // Test the Cancel
        objController1.cancel();
        	
        
        Test.stopTest();
    }
    
     // Test Sync Method
    static testMethod void testBU1SyncPositive(){
        
        //Create Org Credential
        copado__Org__c sourceOrg = new copado__Org__c();
        sourceOrg.name = 'TestDest';
        insert sourceOrg;
        
        // Create Copado Deploy
        copado__Deployment__c deploymentRecord = new copado__Deployment__c();
        deploymentRecord.copado__From_Org__c = sourceOrg.Id;
        insert deploymentRecord;
         
        // Create Copado Deploy Step
        copado__Step__c step1 = new copado__Step__c();
        step1.copado__Deployment__c = deploymentRecord.Id;
        step1.copado__Type__c='Metadata';
        insert step1;
        
        // Create Attachment related to Step
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.Body = BLOB.valueOf('[{"t":"CustomField","n":"WorkOrderLineItem.ServiceAppointmentCount","s":true},{"t":"CustomField","n":"WorkOrderLineItem.Priority","s":true},{"t":"CustomField","n":"WorkOrderLineItems.Priorities23423","s":true}]');
        att.ParentId = step1.id;
        insert att;
        
        // Create Sync for a BU
        Metadata_Sync__c sync1 = new Metadata_Sync__c();
        sync1.Copado_Deployment__c = deploymentRecord.id;
        sync1.Sync_Level__c = 'Production';
        sync1.Name = 'NH';
        sync1.Master_Org__c = false;
        insert sync1;
        
        Test.startTest();
        
        // Test the Sync
        ApexPages.currentPage().getParameters().put('id',sync1.id);
        ApexPages.StandardController stdCont1 = new ApexPages.StandardController(sync1);
        SFDC_MetadataSync_Controller objController1 = new SFDC_MetadataSync_Controller(stdCont1);
        objController1.syncLines();
        
        Test.stopTest();
    }
    
     // Test Sync Method
    static testMethod void testBU2SyncPositive(){
        
        //Create Org Credential
        copado__Org__c sourceOrg = new copado__Org__c();
        sourceOrg.name = 'TestDest';
        insert sourceOrg;
        
        // Create Copado Deploy
        copado__Deployment__c deploymentRecord = new copado__Deployment__c();
        deploymentRecord.copado__From_Org__c = sourceOrg.Id;
        insert deploymentRecord;
         
        // Create Copado Deploy Step
        copado__Step__c step1 = new copado__Step__c();
        step1.copado__Deployment__c = deploymentRecord.Id;
        step1.copado__Type__c='Metadata';
        insert step1;
        
        // Create Attachment related to Step
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.Body = BLOB.valueOf('[{"t":"CustomField","n":"WorkOrderLineItem.ServiceAppointmentCount","s":true},{"t":"CustomField","n":"WorkOrderLineItem.Priority","s":true},{"t":"CustomField","n":"WorkOrderLineItems.Priorities23423","s":true}]');
        att.ParentId = step1.id;
        insert att;
        
        // Create Sync for a BU
        Metadata_Sync__c sync1 = new Metadata_Sync__c();
        sync1.Copado_Deployment__c = deploymentRecord.id;
        sync1.Sync_Level__c = 'Production';
        sync1.Name = 'EC';
        sync1.Master_Org__c = false;
        insert sync1;
        
        Test.startTest();
        
        // Test the Sync
        ApexPages.currentPage().getParameters().put('id',sync1.id);
        ApexPages.StandardController stdCont1 = new ApexPages.StandardController(sync1);
        SFDC_MetadataSync_Controller objController1 = new SFDC_MetadataSync_Controller(stdCont1);
        objController1.syncLines();
        
        Test.stopTest();
    }
    
     // Test Sync Method
    static testMethod void testBU3SyncPositive(){
        
        //Create Org Credential
        copado__Org__c sourceOrg = new copado__Org__c();
        sourceOrg.name = 'TestDest';
        insert sourceOrg;
        
        // Create Copado Deploy
        copado__Deployment__c deploymentRecord = new copado__Deployment__c();
        deploymentRecord.copado__From_Org__c = sourceOrg.Id;
        insert deploymentRecord;
         
        // Create Copado Deploy Step
        copado__Step__c step1 = new copado__Step__c();
        step1.copado__Deployment__c = deploymentRecord.Id;
        step1.copado__Type__c='Metadata';
        insert step1;
        
        // Create Attachment related to Step
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.Body = BLOB.valueOf('[{"t":"CustomField","n":"WorkOrderLineItem.ServiceAppointmentCount","s":true},{"t":"CustomField","n":"WorkOrderLineItem.Priority","s":true},{"t":"CustomField","n":"WorkOrderLineItems.Priorities23423","s":true}]');
        att.ParentId = step1.id;
        insert att;
        
        // Create Sync for a BU
        Metadata_Sync__c sync1 = new Metadata_Sync__c();
        sync1.Copado_Deployment__c = deploymentRecord.id;
        sync1.Sync_Level__c = 'Production';
        sync1.Name = 'DSS';
        sync1.Master_Org__c = false;
        insert sync1;
        
        Test.startTest();
        
        // Test the Sync
        ApexPages.currentPage().getParameters().put('id',sync1.id);
        ApexPages.StandardController stdCont1 = new ApexPages.StandardController(sync1);
        SFDC_MetadataSync_Controller objController1 = new SFDC_MetadataSync_Controller(stdCont1);
        objController1.syncLines();
        
        Test.stopTest();
    }
    
    // Test Batch Method 1
    static testMethod void testBatchMethod1(){
                
        OneDuPontMetadata__c md1 = new OneDuPontMetadata__c();
        md1.Destination_Org__c = 'DSS;AgCo;';
        md1.External_ID__c = 'CustomField.Test1';
        md1.MetaDataName__c = md1.External_Id__c;
        insert md1;
        OneDuPontMetadata__c md2 = new OneDuPontMetadata__c();
        md2.Destination_Org__c = 'DSS;';
        md2.External_ID__c = 'CustomField.Test2';
        md2.MetaDataName__c = md2.External_Id__c;
        insert md2;
        
        Set<String> keySet = new Set<String>();
        keySet.add(md1.External_ID__c);
        keySet.add(md2.External_ID__c);

        
        Test.startTest();
        
        SFDC_MetadataSyncBatchable a = new SFDC_MetadataSyncBatchable();
        a.batchMode = 1;
        a.Name = 'DSS'; 
        a.syncLevel = 'Production';
        a.jkeySet = keySet;
        Database.executeBatch(a,200);
        
        Test.stopTest();
    }
    
     // Test Batch Method 2
    static testMethod void testBatchMethod2(){
                
        OneDuPontMetadata__c md1 = new OneDuPontMetadata__c();
        md1.Destination_Org__c = 'DSS;AgCo;';
        md1.External_ID__c = 'CustomField.Test1';
        md1.MetaDataName__c = md1.External_Id__c;
        insert md1;
        OneDuPontMetadata__c md2 = new OneDuPontMetadata__c();
        md2.Destination_Org__c = 'DSS;';
        md2.External_ID__c = 'CustomField.Test2';
        md2.MetaDataName__c = md2.External_Id__c;
        insert md2;
        OneDuPontMetadata__c md3 = new OneDuPontMetadata__c();
        md3.Destination_Org__c = 'DSS;AgCo;';
        md3.External_ID__c = 'CustomField.Test3';
        md3.MetaDataName__c = md3.External_Id__c;
        insert md3;
        
        Set<String> keySet = new Set<String>();
        keySet.add(md1.External_ID__c);
        keySet.add(md2.External_ID__c);

        
        Test.startTest();
        
        SFDC_MetadataSyncBatchable a = new SFDC_MetadataSyncBatchable();
        a.batchMode = 2;
        a.Name = 'DSS'; 
        a.syncLevel = 'Production';
        a.jkeySet = keySet;
        Database.executeBatch(a,200);
        
        Test.stopTest();
        
        md3 = [SELECT Id,Destination_Org__c FROM OneDupontMetadata__c WHERE id=:md3.id LIMIT 1];
        System.AssertEquals(md3.Destination_Org__c,'AgCo');
    }
    
       // Test Batch Method 3
    static testMethod void testBatchMethod3(){
                
        OneDuPontMetadata__c md1 = new OneDuPontMetadata__c();
        md1.Destination_Org__c = 'DSS;AgCo;';
        md1.External_ID__c = 'CustomField.Test1';
        md1.MetaDataName__c = md1.External_Id__c;
        insert md1;
        OneDuPontMetadata__c md2 = new OneDuPontMetadata__c();
        md2.Destination_Org__c = 'DSS;';
        md2.External_ID__c = 'CustomField.Test2';
        md2.MetaDataName__c = md2.External_Id__c;
        insert md2;
        OneDuPontMetadata__c md3 = new OneDuPontMetadata__c();
        md3.Destination_Org__c = 'DSS;';
        md3.External_ID__c = 'CustomField.Test3';
        md3.MetaDataName__c = md3.External_Id__c;
        insert md3;
        
        Set<String> keySet = new Set<String>();
        keySet.add(md1.External_ID__c);
        keySet.add(md2.External_ID__c);

        
        Test.startTest();
        
        SFDC_MetadataSyncBatchable a = new SFDC_MetadataSyncBatchable();
        a.batchMode = 3;
        a.Name = 'DSS'; 
        a.syncLevel = 'Production';
        a.jkeySet = keySet;
        Database.executeBatch(a,200);
        
        Test.stopTest();
//        Integer count = [SELECT Count() FROM OneDupontMetadata__c WHERE id=:md3.id];
//        System.AssertEquals(0,count);
    }
}
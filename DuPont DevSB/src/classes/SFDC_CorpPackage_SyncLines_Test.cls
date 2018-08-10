@isTest (SeeALLData=True)
public class SFDC_CorpPackage_SyncLines_Test {
    
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
        insert step1;
        
        // Create Attachment related to Step
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.Body = BLOB.valueOf('[{"t":"CustomField","n":"WorkOrderLineItem.ServiceAppointmentCount","s":true},{"t":"CustomField","n":"WorkOrderLineItem.Priority","s":true}]');
        att.ParentId = step1.id;
        insert att;
        
        
        // Create Corporate Package
        Corporate_Package__c packageRecord = new Corporate_Package__c();
        packageRecord.Name = 'Test';
        packageRecord.Description__c = 'Test';
        packageRecord.Copado_Deployment__c = 'https://url..?id='+deploymentRecord.Id+'?oas=2323423432432';
        insert packageRecord;
        
        // Test the constructor
        ApexPages.currentPage().getParameters().put('id',packageRecord.id);
        ApexPages.StandardController stdCont = new ApexPages.StandardController(packageRecord);
        SFDC_CorpPackage_SyncLines_Controller objController = new SFDC_CorpPackage_SyncLines_Controller(stdCont);

        
        // Test the Sync
        objController.syncLines();
        
        // Test the Cancel
        objController.cancel();
        
    }
}
@isTest (SeeALLData=False)
public class ANTLogProcessing_Test{

  // Test Sync Method
    static testMethod void testDestructiveChangesCtrl(){
        Test.startTest();
        
        MetaDataTypeSF__c vlmdt = new MetaDataTypeSF__c();
        vlmdt.Name = 'ValidationRule';
        vlmdt.ExternalID__c = 'ValidationRule';
        insert vlmdt;

        MetaDataTypeSF__c cfmdt = new MetaDataTypeSF__c();
        cfmdt.Name = 'CustomField';
        cfmdt.ExternalID__c = 'CustomField';
        insert cfmdt;

        
        OneDuPontMetaData__c vlmd = new OneDuPontMetaData__c();
        vlmd.MetaDataName__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation';
        vlmd.External_Id__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation';
        vlmd.MetaDataType__c =vlmdt.Id;
        insert vlmd;
        
        OneDuPontMetaData__c cfmd = new OneDuPontMetaData__c();
        cfmd.MetaDataName__c = 'CustomField.Account.AGCP_AP_account_local_name__c';
        cfmd.External_Id__c  = 'CustomField.Account.AGCP_AP_account_local_name__c';
        cfmd.MetaDataType__c =cfmdt.Id;
        insert cfmd;
        
        ANT_Log__c al = new ANT_Log__c();
        al.Log__c = '[sf:deploy] 1.  objects/Account.object (Account.AGCP_AP_account_local_name__c) -- Error: This custom field is referenced elsewhere in salesforce.com. : Validation Rule - Account.AGCP_AP_account_local_name_validation.';
        al.Status__c = 'New';
        al.Target_Org__c = 'DPS';
        insert al;
        
        BatchProcessANTLogs bal = new BatchProcessANTLogs();
        Database.executeBatch(bal);
        
        Test.stopTest();
    }

}
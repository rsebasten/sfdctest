@isTest (SeeALLData=False)
public class destructiveChangesCtrl_Test{

  // Test Sync Method
    static testMethod void testDestructiveChangesCtrl(){
        Test.startTest();
        
        MetaDataTypeSF__c mdt = new MetaDataTypeSF__c();
        mdt.Name = 'ValidationRule';
        mdt.ExternalID__c = 'ValidationRule';
        insert mdt;
        
        OneDuPontMetaData__c md = new OneDuPontMetaData__c();
        md.MetaDataName__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation';
        md.External_Id__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation';
        md.Destination_Org__c = 'AgCo';
        md.Destination_Org_Prior_To_Remediation__c = 'AgCo';
        md.MetaDataType__c =mdt.Id;
        md.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        md.AgCo_CRM_Remediation_Reason_Note__c ='Inactive metadata';
        md.AgCo_CRM_Dependencies__c = 'IssueFound';
        md.AgCo_Remediation_Level__c = 'L2';
        insert md;
        
        OneDuPontMetaData__c md2 = new OneDuPontMetaData__c();
        md2.MetaDataName__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation2';
        md2.External_Id__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation2';
        md2.Destination_Org__c = 'AgCo';
        md2.Destination_Org_Prior_To_Remediation__c = 'AgCo';
        md2.MetaDataType__c =mdt.Id;
        md2.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        md2.AgCo_CRM_Remediation_Reason_Note__c ='Inactive metadata';
        md2.AgCo_Remediation_Level__c = 'L1';
        insert md2;       

        OneDuPontMetaData__c md3 = new OneDuPontMetaData__c();
        md3.MetaDataName__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation3';
        md3.External_Id__c = 'ValidationRule.Account.AGCP_AP_account_local_name_validation3';
        md3.Destination_Org__c = 'AgCo';
        md3.Destination_Org_Prior_To_Remediation__c = 'AgCo';
        md3.MetaDataType__c =mdt.Id;
        md3.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        md3.AgCo_CRM_Remediation_Reason_Note__c ='Inactive metadata';
        md3.AgCo_Remediation_Level__c = 'L1';
        insert md3;        
        
        
        destructiveChangesCtrl ctrl = new destructiveChangesCtrl();
        ctrl.OrgName = 'AgCo_CRM_Metadata_Remediation__c';
        ctrl.AddWhereClause = '';
        ctrl.SkipDependent = TRUE;
        ctrl.getTargetOrgs();
        ctrl.createXML();
        ctrl.clearXML();
        Test.stopTest();
    }

}
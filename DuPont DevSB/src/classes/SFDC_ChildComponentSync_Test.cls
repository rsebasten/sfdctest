@isTest (SeeALLData=False)
public class SFDC_ChildComponentSync_Test {

     // Test Sync Method
    static testMethod void testAllBUs(){
    
        createData();
        
        OneDuPontMetadata__c testRecord = [SELECT ID FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomObject.ParentObject'];
        OneDuPontMetadata__c childRecord;
        
        Test.startTest();
        
        // Test the constructor for a BU 
        ApexPages.currentPage().getParameters().put('id',testRecord.id);
        ApexPages.StandardController stdCont1 = new ApexPages.StandardController(testRecord);
        SFDC_ChildComponentSync_Controller objController1 = new SFDC_ChildComponentSync_Controller(stdCont1);
	
        // Test the Update Lines with no selection
        objController1.updateLines();
        
        // Test the update Lines with AgCo Selection
        objController1.buSelection = 'AgCo';
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.updateLines();      
        childRecord = [SELECT ID,AgCo_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.AgCo_Remediation_Level__c, 'L1');
        
      
        // Test the update Lines with EC Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'EC';
        objController1.updateLines();      
        childRecord = [SELECT ID,EC_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.EC_Remediation_Level__c, 'L1');
        
        // Test the update Lines with PS Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'PS';
        objController1.updateLines();      
        childRecord = [SELECT ID,PS_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.PS_Remediation_Level__c, 'L1');
        
        // Test the update Lines with SS Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'SS';
        objController1.updateLines();      
        childRecord = [SELECT ID,SS_Remediation_Levels__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.SS_Remediation_Levels__c, 'L1');
        
        // Test the update Lines with FMC Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'FMC';
        objController1.updateLines();      
        childRecord = [SELECT ID,FMC_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.FMC_Remediation_Level__c, 'L1');
        
        // Test the update Lines with IB Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'IB';
        objController1.updateLines();      
        childRecord = [SELECT ID,IB_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.IB_Remediation_Level__c, 'L1');
        
        // Test the update Lines with NH Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'NH';
        objController1.updateLines();      
        childRecord = [SELECT ID,NH_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.NH_Remediation_Level__c, 'L1');
         
        // Test the update Lines with MS Selection
        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
        objController1.buSelection = 'MS';
        objController1.updateLines();      
        childRecord = [SELECT ID,MS_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
        System.assertEquals(childRecord.MS_Remediation_Level__c, 'L1');
        
        
        // Set the Destination org to EC
//        childRecord = [SELECT ID,Destination_Org__c,MS_Remediation_Level__c,MS_CRM_Metadata_Remediation__c,MS_CRM_Remediation_Reason_Note__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
//		childRecord.Destination_Org__c = 'EC';
//        childRecord.MS_Remediation_Level__c = '';
//        childRecord.MS_CRM_Metadata_Remediation__c = '';
//        childRecord.MS_CRM_Remediation_Reason_Note__c = '';
//        update childRecord;
        
         // Test the update Lines with MS Selection but EC Destination org.  Should not update field
//        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
//        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
//        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
//        objController1.buSelection = 'MS';
//        objController1.updateLines();      
//        childRecord = [SELECT ID,MS_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
//        System.assertEquals(childRecord.MS_Remediation_Level__c, null);
        
       
        // Clear the Destination org 
//        childRecord = [SELECT ID,Destination_Org__c,MS_Remediation_Level__c,MS_CRM_Metadata_Remediation__c,MS_CRM_Remediation_Reason_Note__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
//		childRecord.Destination_Org__c = '';
//        childRecord.MS_Remediation_Level__c = '';
//        childRecord.MS_CRM_Metadata_Remediation__c = '';
//        childRecord.MS_CRM_Remediation_Reason_Note__c = '';
//        update childRecord;
        
         // Test the update Lines with MS Selection but no Destination org.  Should not update field
//        objController1.syncRecord.AgCo_Remediation_Level__c = 'L1';
//        objController1.syncRecord.AgCo_CRM_Remediation_Reason_Note__c = 'Test';
//        objController1.syncRecord.AgCo_CRM_Metadata_Remediation__c = 'Delete';
//        objController1.buSelection = 'MS';
//        objController1.updateLines();      
//        childRecord = [SELECT ID,MS_Remediation_Level__c FROM OneDuPontMetadata__c WHERE External_Id__c = 'CustomField.Field1'];
//        System.assertEquals(childRecord.MS_Remediation_Level__c, null);
        
         // Test the Cancel
        objController1.cancel();
        	
        
        Test.stopTest();
    }
    
    public static void createData()
    {
        MetaDataTypeSF__c objectType = new MetaDataTypeSF__c();
        objectType.Name = 'CustomObject';
        objectType.ExternalID__c = 'CustomObject';
        insert objectType;
        
        MetaDataTypeSF__c fieldType = new MetaDataTypeSF__c();
        fieldType.Name = 'CustomField';
        fieldType.ExternalID__c = 'CustomField';
        insert fieldType;
        
        OneDuPontMetaData__c parentRecord = new OneDuPontMetaData__c();
        parentRecord.External_ID__c = 'CustomObject.ParentObject';
        parentRecord.MetaDataName__c = 'CustomObject.ParentObject';
        parentRecord.MetaDataType__c = objectType.id;        
        insert parentRecord;
        
		OneDuPontMetaData__c childRecord1 = new OneDuPontMetaData__c();
        childRecord1.External_ID__c = 'CustomField.Field1';
        childRecord1.MetaDataName__c = 'CustomField.Field1';
        childRecord1.MetaDataType__c = fieldType.id;
        childRecord1.ParentMetaData__c = parentRecord.id;
        childRecord1.Destination_Org__c = 'AgCo;Remedy;MatCo;EC;DSS;DSS;DPS;NH;IB';
        insert childRecord1;        
    }
}
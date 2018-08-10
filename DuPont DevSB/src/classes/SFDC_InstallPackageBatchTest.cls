@isTest (SeeALLData=False)
public class SFDC_InstallPackageBatchTest {

    // Test Sync Method
    static testMethod void testInstalledPackageBatch(){
        
        MetadataTypeSF__c installType = new MetadataTypeSF__c();
        installType.ExternalID__c = 'InstalledPackage';
        installType.Name = 'InstalledPackage';
        insert installType;
        
        MetadataTypeSF__c fieldType = new MetadataTypeSF__c();
        fieldType.ExternalID__c = 'CustomField';
        fieldType.Name = 'CustomField';
        insert fieldType;
        
        OneDuPontMetadata__c packageRecord = new OneDuPontMetadata__c();
        packageRecord.MetaDataName__c = 'InstalledPackage.dsfs';
        packageRecord.MetaDataType__c = installType.id;
        packageRecord.External_ID__c = 'InstalledPackage.dsfs';
        insert packageRecord;
        
        OneDuPontMetadata__c fieldRecord = new OneDuPontMetadata__c();
        fieldRecord.MetaDataName__c = 'CustomField.dsfs__ABCDFIELD';
        fieldRecord.External_ID__c = 'CustomField.dsfs__ABCDFIELD';
        fieldRecord.MetaDataType__c = fieldType.id;
        insert fieldRecord;
        
        Test.startTest(); 
        
        SFDC_InstalledPackageBatch b = new SFDC_InstalledPackageBatch();
        Database.executeBatch(b, 200); 
        
        Test.stopTest();
    }
    
    // Test Sync Method
    static testMethod void testInstallPackageBatch(){
        
        MetadataTypeSF__c installType = new MetadataTypeSF__c();
        installType.ExternalID__c = 'CustomObject';
        installType.Name = 'CustomObject';
        insert installType;
        
        MetadataTypeSF__c fieldType = new MetadataTypeSF__c();
        fieldType.ExternalID__c = 'CustomField';
        fieldType.Name = 'CustomField';
        insert fieldType;
        
        OneDuPontMetadata__c packageRecord = new OneDuPontMetadata__c();
        packageRecord.MetaDataName__c = 'CustomObject.dsfs';
        packageRecord.MetaDataType__c = installType.id;
        packageRecord.External_ID__c = 'CustomObject.dsfs';
        insert packageRecord;
        
        OneDuPontMetadata__c fieldRecord = new OneDuPontMetadata__c();
        fieldRecord.MetaDataName__c = 'CustomObject.CustomField.dsfs__ABCDFIELD';
        fieldRecord.External_ID__c = 'CustomObject.CustomField.dsfs__ABCDFIELD';
        fieldRecord.MetaDataType__c = fieldType.id;
        insert fieldRecord;
        
        Test.startTest(); 
        
        SFDC_InstallPackageBatch b = new SFDC_InstallPackageBatch();
        Database.executeBatch(b, 200); 
        
        Test.stopTest();
    }
}
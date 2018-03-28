/*******************************************************************************
CopyrightÂ© 2016 DuPont. All rights reserved.
Author: Matt Peoples 
Email: mpeoples@mapanything.com
Description: Customization for Map Anything Batches
********************************************************************************/
/*
 * Modification log
 * ==================================================================================================
 * ver                         Date                  Author                              Modification                                                                           Timestamp       
 * ---                         ----                  --------------                      ------------                                                                       -------------------------       
 * 1.0                       2016-12-22              Rohit saini                   Modified the Class for removing seeAllData tag and create necessary data in test class       RS12222016      
*/


@isTest
private class MACreateShapeLayersBatchableTest 
{
    private static testMethod void PrimaryTestMethods() 
    {   //<RS12222016> Start
        MA_Color_Code__c m=new MA_Color_Code__c(name='#ae4ad2');
        insert m;
        //<RS12222016> end
        string RandomHexColor = MACustomLogic.RandomHexColor();
        MACustomLogic.DisplayLimitInformation();
        string CountryTwoCodeToThreeCode = MACustomLogic.CountryTwoCodeToThreeCode('US');
    }

    

    private static testMethod void testAccountBatchable() 
    {
        sma__MAFolder__c countyFolder = new sma__MAFolder__c(Name='County');
        insert countyFolder;

        sma__MAFolder__c accountFolder = new sma__MAFolder__c(Name='By Account', sma__ParentFolder__c=countyFolder.Id);
        insert accountFolder;

        sma__MATerritory__c delAccountTerr = new sma__MATerritory__c(Name='Test', Auto_Created__c=true, sma__Folder__c=accountFolder.Id);
        insert delAccountTerr;
        //<RS12222016> Start                                                                                                                                         
        RecordType rt = [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Account' AND Name = 'BI - Surfaces' limit 1];
        
        List<Account> lstAccount=new List<Account>();
        Account a=new Account(name='Parksite test', recordTypeId=rt.id, BI_Account_SubType__c= 'Distribution', Account_Stage__c = 'Active');
        lstAccount.add(a);
       Account a2=new Account(name='Parksite test2', recordTypeId=rt.id, BI_Account_SubType__c= 'Distribution', Account_Stage__c = 'Active');
        lstAccount.add(a2);
        
        insert lstAccount;
       
        Geography__c   geoNew5 = new Geography__c(Name='North America', Code__c='R_NORTH_AMERICA',Level__c=5,Code2__c='NORTH_AMERICA', Level_Name__c='County');
        insert geoNew5;

        Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('MHC Surfaces').getRecordTypeId();
        
        List<Geography_Mapping__c> lstGm=new List<Geography_Mapping__c>();
        Geography_Mapping__c gm=new Geography_Mapping__c( Account__c=a.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id);
        lstGm.add(gm);
        Geography_Mapping__c gm2=new Geography_Mapping__c( Account__c=a2.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id);
        lstGm.add(gm2);
        
        insert lstGm;
        //<RS12222016> end
        MACreateShapeLayersByAccountBatchable batch1 = new MACreateShapeLayersByAccountBatchable();
        Database.executeBatch(batch1);
    }
    
    private static testMethod void testUserBatchable() 
    {
        sma__MAFolder__c countyFolder = new sma__MAFolder__c(Name='County');
        insert countyFolder;
        
        sma__MAFolder__c userFolder = new sma__MAFolder__c(Name='By User', sma__ParentFolder__c=countyFolder.Id);
        insert userFolder;
        
        sma__MATerritory__c delUserTerr = new sma__MATerritory__c(Name='Test', Auto_Created__c=true, sma__Folder__c=userFolder.Id);
        insert delUserTerr;
        //<RS12222016> Start
        User u=[select id, name from user where profile.name='BI-NA Distributor Partner' and IsActive = true limit 1];
        
        List<Geography__c> lstGEO=new List<Geography__c>();
        Geography__c   geoNew5 = new Geography__c(Name='Division No. 4', Code__c='AB-4804',Level__c=5, Code2__c='4804', Level_Name__c='County');
        lstGEO.add(geoNew5); 
        Geography__c   geoNew6 = new Geography__c(Name='Choctaw', Code__c='84001023',Level__c=5, Code2__c='01023', Level_Name__c='County');
        lstGEO.add(geoNew6);
        
        insert lstGEO;
        

        Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('MHC Surfaces').getRecordTypeId();
        
        List<Geography_Mapping__c> lstGM=new List<Geography_Mapping__c>();
        
        Geography_Mapping__c gm=new Geography_Mapping__c( User__c=u.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id);
        lstGM.add(gm);
        Geography_Mapping__c gm2=new Geography_Mapping__c( User__c=u.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id);
        lstGM.add(gm2);
        
        Geography_Mapping__c gm3=new Geography_Mapping__c( User__c=u.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew6.id);
        lstGM.add(gm3);
        Geography_Mapping__c gm4=new Geography_Mapping__c( User__c=u.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew6.id);
        lstGM.add(gm4);
        
        insert  lstGM;       
        //<RS12222016> end
        MACreateShapeLayersByUserBatchable batch1 = new MACreateShapeLayersByUserBatchable();
        Database.executeBatch(batch1);
    }

    private static testMethod void testContactBatchable() 
    {
        sma__MAFolder__c stateFolder = new sma__MAFolder__c(Name='State');
        insert stateFolder;
        
        sma__MAFolder__c contactFolder = new sma__MAFolder__c(Name='By Contact', sma__ParentFolder__c=stateFolder.Id);
        insert contactFolder;
        
        sma__MATerritory__c delContactTerr = new sma__MATerritory__c(Name='Test', Auto_Created__c=true, sma__Folder__c=contactFolder.Id);
        insert delContactTerr;
        //<RS12222016> Start
        List<Account> lstAccount=new List<Account>();
        
         Account a=new Account(name='BI (Building Innovations)',  Status__c = 'Active');
         lstAccount.add(a);
        insert lstAccount;
        
        RecordType rt = [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'BI-NA Contact' limit 1];
        
        List<Contact> lstContacts=new List<Contact>();
        Contact c=new Contact(lastname='Parksite test', recordTypeId=rt.id, Status__c = 'Active', AccountId=a.id);
        lstContacts.add(c);
        Contact c2=new Contact(lastname='Parksite test2', recordTypeId=rt.id, Status__c = 'Active', AccountId=a.id);
        lstContacts.add(c2);
        
        insert lstContacts;
       
        List<Geography__c> lstGeo=new List<Geography__c>();
        Geography__c   geoNew5 = new Geography__c(Name='CA', Numeric_Code__c=6,  Code__c='US-CA',Level__c=4,Code2__c='CA', Level_Name__c='State');
        lstGeo.add(geoNew5);

        Geography__c   geoNew6 = new Geography__c(Name='Hamburg', Numeric_Code__c=3, Code__c='DE-HH',Level__c=4,Code2__c='HH', Level_Name__c='Province');
        lstGeo.add(geoNew6);
        
        insert lstGeo;
        
        Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('BI-NA Opportunity Owner 2').getRecordTypeId();
        List<Geography_Mapping__c> lstGM=new List<Geography_Mapping__c>();
        Geography_Mapping__c gm=new Geography_Mapping__c( Contact__c=c.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id, Owning_Organization__c='BI-Surf');
        lstGM.add(gm);
        Geography_Mapping__c gm2=new Geography_Mapping__c( Contact__c=c2.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id, Owning_Organization__c='BI-Surf');
        lstGM.add(gm2);
        Geography_Mapping__c gm3=new Geography_Mapping__c( Contact__c=c2.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew5.id, Owning_Organization__c='BI-Surf');
        lstGM.add(gm3);
        Geography_Mapping__c gm4=new Geography_Mapping__c( Contact__c=c2.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew6.id, Owning_Organization__c='BI-Surf');
        lstGM.add(gm4);
        Geography_Mapping__c gm5=new Geography_Mapping__c( Contact__c=c2.id, RecordTypeId=GeoMappingRecordTypeId, Geography__c=geoNew6.id, Owning_Organization__c='BI-Surf');
        lstGM.add(gm5);
        
        insert lstGM;
      
        //<RS12222016> end
        MACreateShapeLayersByContactBatchable batch1 = new MACreateShapeLayersByContactBatchable();
        Database.executeBatch(batch1);
    }
    
    private static testMethod void testAccountBatchPage() 
    {   
        ShapeLayerBatchPage b = new ShapeLayerBatchPage();
        b.RunAccountBatch();
    }

    private static testMethod void testUserBatchPage() 
    {   
        ShapeLayerBatchPage b = new ShapeLayerBatchPage();
        b.RunUserBatch();
    }
    
    private static testMethod void testContactBatchPage() 
    {   
        ShapeLayerBatchPage b = new ShapeLayerBatchPage();
        b.RunContactBatch();
    }   
}
/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: Test class for the class batchCSAccountDailySync
 * Change history (key updates):
 * 2nd March, 2015 -> created the class
**/
@isTest
public class batchCSAccountDailySync_UT{

    private static final String RECORDTYPEVAL = 'ERP Customer - Extended Data';
    private static final String RECORDTYPEVALGen = 'ERP Customer - General Data';
    private static final String TESTDATA = 'TEST';
    private static final String COUNTRYCODE = 'IN';
    private static final Integer COUNTER = 0;
    private static final String TESTPARTNERCODE = 'TEST';
    private static final String PARTNERCODEFUNCTION = 'YK';
    private static final String INITIAL_VAL = '';
    private static final String ZRPARTNERCODEFUNCTION = 'ZR';
    private static final String EXTID = 'ExternalTest1234';
    private static final String ERPRecordname = 'ERP Relationship - Person';
    private static final List<String> PLACEHOLDERS = new List<String>{
        'Standard User',
        'standt',
        'abc@xyz.com',
        'UTF-8', 
        'Customer Service',
        'en_US',
        'America/Los_Angeles',
        'abc46558732134656843@xyz.com',
        'Test User'
    };


    /**
     * Test Method 
     * @author varsha.singh
     */  
    private static testmethod void testFlow(){
        //Create Custom Setting Record to store Account Load Settings    
        
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        
        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        
        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        
        
        id RecTypeIdGen = recordTypeMap.get(RECORDTYPEVALGen);
        ERP_Customer__c erRecordGen= new ERP_Customer__c();
        erRecordGen.recordTypeid = RecTypeIdGen;
        erRecordGen.Name =  TESTDATA;   
        erRecordGen.External_ERP_ID__c = EXTID;  
        database.insert(erRecordGen);     
        
        ERP_Customer_Localization__c erpLoc= new ERP_Customer_Localization__c();
        erpLoc.ERP_Customer__c=erRecordGen.Id;
        erpLoc.External_ERP_ID__c = EXTID+(COUNTER+1)+'-C';
        database.insert(erpLoc);

        
        id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
        List<ERP_Customer__c> erpCustomers = new List<ERP_Customer__c>();
        ERP_Customer__c erRecord = new ERP_Customer__c();
        erRecord.recordTypeid          = RecTypeId;
        erRecord.Name                  = TESTDATA;
        erRecord.Customer_Name_2__c    = TESTDATA;
        erRecord.Customer_Code__c      = TESTDATA;
        erRecord.Account_Group_Code__c = TESTDATA;
        erRecord.Account_Group__c      = TESTDATA;  
        erRecord.ERP_Account__c        = TESTDATA;
        erRecord.PO_Box__c             = TESTDATA;
        erRecord.Street__c             = TESTDATA;
        erRecord.State__c              = TESTDATA;
        erRecord.State_Province__c     = TESTDATA;
        erRecord.Country__c            = TESTDATA;
        erRecord.Country_Code__c       = COUNTRYCODE;
        erRecord.ERP_YKPartnerCode__c  = NULL;
        erRecord.Deletion_Flag__c = false;
        erRecord.Customer_General_Data__c = erRecordGen.Id;
        erRecord.External_ERP_ID__c  = EXTID+(COUNTER+2);
        
        erpCustomers.add(erRecord);
        //database.insert(erRecord);
        ERP_Customer__c erRecord1 = new ERP_Customer__c();
        erRecord1.recordTypeid          = RecTypeId;
        erRecord1.Name                  = TESTDATA;
        erRecord1.Customer_Name_2__c    = TESTDATA;
        erRecord1.Customer_Code__c      = TESTDATA;
        erRecord1.Account_Group_Code__c = TESTDATA;
        erRecord1.Account_Group__c      = TESTDATA;  
        erRecord1.ERP_Account__c        = NULL;
        erRecord1.PO_Box__c             = TESTDATA;
        erRecord1.Street__c             = TESTDATA;
        erRecord1.State__c              = TESTDATA;
        erRecord1.State_Province__c     = TESTDATA;
        erRecord1.Country__c            = TESTDATA;
        erRecord1.Country_Code__c       = COUNTRYCODE;
        erRecord1.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord1.External_ERP_ID__c  = EXTID + (COUNTER +3);
        erRecord1.Customer_General_Data__c = erRecordGen.Id;
        erRecord1.Deletion_Flag__c= false;
        erRecord1.CreatedDate = System.Now();
        erpCustomers.add(erRecord1);
        
        //database.insert(erRecord1);
        database.insert(erpCustomers);

        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord1.Id;
        erpRel.Partner_Code__c=TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION;
        database.insert(erpRel);
        
        ERP_Relationship__c erpRel1= new ERP_Relationship__c();
        erpRel1.ERP_Customer__c=erRecord1.Id;
        erpRel1.Partner_Code__c=TESTPARTNERCODE;
        erpRel1.Partner_Function_Code__c= ZRPARTNERCODEFUNCTION;
        erpRel1.recordTypeid=[SELECT id from RecordType where Name =: ERPRecordname and SobjectType='ERP_Relationship__c'].Id;
        database.insert(erpRel1);
        
        Account acc= new Account();
        acc.name = TESTDATA;
        acc.ERP_Customer__c = erRecord.id;
        acc.External_ID__c =erRecord.External_ERP_ID__c;
        database.insert(acc);
        
        //Test
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountDailySync instance = new batchCSAccountDailySync();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    } 

    /**
     * Test Method 
     * @author sanchit.dua
     */
        private static testmethod void testFlow1(){
        //Test
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
    
        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        
        
        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
        id RecTypeIdGen = recordTypeMap.get(RECORDTYPEVALGen);
        ERP_Customer__c erRecordGen= new ERP_Customer__c();
        erRecordGen.recordTypeid = RecTypeIdGen;
        erRecordGen.Name =  TESTDATA;   
        erRecordGen.Deletion_Flag__c = false;
        erRecordGen.External_ERP_ID__c = EXTID;
        erRecordGen.Customer_Code__c = TESTDATA;  
        database.insert(erRecordGen);    
         
        List<ERP_Customer__c> erpCustomers = new List<ERP_Customer__c>();
        ERP_Customer__c erRecord = new ERP_Customer__c();
        erRecord.recordTypeid          = RecTypeId;
        erRecord.Name                  = TESTDATA;
        erRecord.Customer_Name_2__c    = TESTDATA;
        erRecord.Customer_Code__c      = TESTDATA;
        erRecord.Account_Group_Code__c = TESTDATA;
        erRecord.Account_Group__c      = TESTDATA;  
        erRecord.ERP_Account__c        = TESTDATA;
        erRecord.PO_Box__c             = TESTDATA;
        erRecord.Street__c             = TESTDATA;
        erRecord.Customer_General_Data__c = erRecordGen.Id;
        erRecord.State__c              = TESTDATA;
        erRecord.State_Province__c     = TESTDATA;
        erRecord.Country__c            = TESTDATA;
        erRecord.Country_Code__c       = COUNTRYCODE;
        erRecord.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord.Deletion_Flag__c=False;
        erRecord.External_ERP_ID__c  = EXTID + (COUNTER +5);
                erpCustomers.add(erRecord);
        //database.insert(erRecord);
        ERP_Customer__c erRecord1 = new ERP_Customer__c();
        erRecord1.recordTypeid          = RecTypeId;
        erRecord1.Name                  = TESTDATA;
        erRecord1.Customer_Name_2__c    = TESTDATA;
        erRecord1.Customer_Code__c      = TESTDATA;
        erRecord1.Account_Group_Code__c = TESTDATA;
        erRecord1.Account_Group__c      = TESTDATA;  
        erRecord1.ERP_Account__c        = NULL;
        erRecord1.PO_Box__c             = TESTDATA;
        erRecord1.Street__c             = TESTDATA;
        erRecord1.State__c              = TESTDATA;
        erRecord1.State_Province__c     = TESTDATA;
        erRecord1.Country__c            = TESTDATA;
        erRecord1.Country_Code__c       = COUNTRYCODE;
        erRecord1.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord1.External_ERP_ID__c  = EXTID + (COUNTER +4);
        erRecord1.Customer_General_Data__c = erRecordGen.Id;
        erRecord1.Deletion_Flag__c= false;
        erRecord1.CreatedDate = System.Now();
        erpCustomers.add(erRecord1);
        
        //database.insert(erRecord1);
        database.insert(erpCustomers);
        //database.insert(erRecord);
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord.Id;
        erpRel.Partner_Code__c= TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION ;
        database.insert(erpRel);
        Account acc= new Account();
        acc.name = TESTDATA;
        acc.ERP_Customer__c = erRecord.id;
        acc.External_ID__c =erRecord.External_ERP_ID__c;
        database.insert(acc);
        erRecord.name= TESTDATA;
        database.update(erRecord);

        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);
        utilCSAccountLoad utilData = new utilCSAccountLoad();
        utilCSBatchErrorLog  batchErrorLog  = new utilCSBatchErrorLog();
        Map<Id,ERP_Customer__c> erpCustomerToUpdate = new Map<Id,ERP_Customer__c>();
        Map<Id,ERP_Customer__c> erpGeneralToUpdate = new Map<Id,ERP_Customer__c>();
        for(ERP_Customer__c erpcust :erpCustomers){
            erpCustomerToUpdate.put(erpcust.id,erpcust);
        }
        boolean erroredOut =false;
        CS_Account_Load_Settings__c accountLoad;
        erpGeneralToUpdate.put(erRecordgen.id,erRecordGen);
        if( !CS_Account_Load_Settings__c.getall().isEmpty() )
           accountLoad = CS_Account_Load_Settings__c.getall().values()[0];  
        system.debug('___$$'+erpGeneralToUpdate);
        
        System.runAs(u){
            utilData.erpCust_AccountfieldsMapping(erpCustomerToUpdate, null, batchErrorLog, accountLoad.AccountOwnerUserName__c, erroredOut,erpGeneralToUpdate); 
        
            batchCSAccountDailySync instance = new batchCSAccountDailySync();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    }

    /**
     * Test Method 
     * @author sanchit.dua
     */
    private static testmethod void testFlow2(){
        //Test
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;

        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        
        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);

        ERP_Customer__c erRecord = new ERP_Customer__c();
        erRecord.recordTypeid          = RecTypeId;
        erRecord.Name                  = TESTDATA;
        erRecord.Customer_Name_2__c    = TESTDATA;
        erRecord.Customer_Code__c      = TESTDATA;
        erRecord.Account_Group_Code__c = TESTDATA;
        erRecord.Account_Group__c      = TESTDATA;  
        erRecord.ERP_Account__c        = NULL;
        erRecord.PO_Box__c             = TESTDATA;
        erRecord.Street__c             = TESTDATA;
        erRecord.State__c              = TESTDATA;
        erRecord.State_Province__c     = TESTDATA;
        erRecord.Country__c            = INITIAL_VAL;
        erRecord.Country_Code__c       = COUNTRYCODE;
        erRecord.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord.Deletion_Flag__c=False;
        erRecord.External_ERP_ID__c  = EXTID+(1001);
        database.insert(erRecord);
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord.Id;
        erpRel.Partner_Code__c= TESTDATA;
        erpRel.Partner_Function_Code__c=PARTNERCODEFUNCTION;
        database.insert(erpRel);

        List<ERP_Customer__c> erpCustomers = new List<ERP_Customer__c>();
        for(Integer i=0; i<10; i++)
            erpCustomers.add(
                new ERP_Customer__c(
                    recordTypeid = RecTypeId, 
                    Name = TESTDATA+i,
                    Customer_Name_2__c = TESTDATA+i,
                    Customer_Code__c = TESTDATA+i,
                    Account_Group_Code__c = TESTDATA,
                    Account_Group__c = TESTDATA,
                    ERP_Account__c = TESTDATA+i,
                    PO_Box__c = TESTDATA+i,
                    Street__c = TESTDATA+i,
                    State__c = TESTDATA+i,
                    State_Province__c = TESTDATA+i,
                    Country__c = TESTDATA+i,
                    Country_Code__c = COUNTRYCODE,
                    ERP_YKPartnerCode__c = TESTPARTNERCODE,
                    Deletion_Flag__c = false,
                    External_ERP_ID__c = EXTID+i
            ));
            for(Integer i=10; i<20; i++)
                erpCustomers.add(
                    new ERP_Customer__c(
                        recordTypeid = RecTypeId, 
                        Name = TESTDATA+i,
                        Customer_Name_2__c = TESTDATA+i,
                        Customer_Code__c = TESTDATA+i,
                        Account_Group_Code__c = TESTDATA,
                        Account_Group__c = TESTDATA,
                        ERP_Account__c = NULL,
                        PO_Box__c = TESTDATA+i,
                        Street__c = TESTDATA+i,
                        State__c = TESTDATA+i,
                        State_Province__c = TESTDATA+i,
                        Country__c = TESTDATA+i,
                        Country_Code__c = COUNTRYCODE,
                        ERP_YKPartnerCode__c = TESTPARTNERCODE,
                        Deletion_Flag__c = false,
                        External_ERP_ID__c = EXTID+i
                ));
        erpCustomers.add(
                new ERP_Customer__c(
                    recordTypeid = RecTypeId, 
                    Name = TESTDATA+663,
                    Customer_Name_2__c = TESTDATA+663,
                    Customer_Code__c = TESTDATA+663,
                    Account_Group_Code__c = TESTDATA,
                    Account_Group__c = TESTDATA,
                    PO_Box__c = TESTDATA+663,
                    Street__c = TESTDATA+663,
                    State__c = TESTDATA+663,
                    State_Province__c = TESTDATA+663,
                    Country__c = TESTDATA+663,
                    Country_Code__c = COUNTRYCODE,
                    ERP_YKPartnerCode__c = TESTPARTNERCODE,
                    Deletion_Flag__c = false,
                    External_ERP_ID__c = EXTID+(COUNTER+50)
            ));
        Database.upsert(erpCustomers, Schema.sObjectType.ERP_Customer__c.fields.External_ERP_ID__c.getSObjectField());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Integer i=0; i<10; i++)
            accountsToUpdate.add(new Account(
                name = TESTDATA+i,
                External_ID__c = erpCustomers.get(i).External_ERP_ID__c,
                ERP_Customer__c = erpCustomers.get(i).id
            )); 
        
        Database.upsert(accountsToUpdate, Schema.sObjectType.Account.fields.External_ID__c.getSObjectField());

        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountDailySync instance = new batchCSAccountDailySync();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    }
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testFlow3(){  // covering if(accountLoad == NULL)
        try{
            Test.startTest();
        
            Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
            User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
            EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
            LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
            TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

            System.runAs(u){
                batchCSAccountDailySync instance = new batchCSAccountDailySync();
                Database.executeBatch(instance);
            }

            Test.stopTest();
        }catch(Exception ex){}
    } // END testmethod private static void testFlow3()
    
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testFlow4(){  // covering if(partnerCodes.isEmpty())
        try{
            CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
            insert settingRecord;
            Test.startTest();
        
            Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
            User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
            EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
            LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
            TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

            System.runAs(u){
                batchCSAccountDailySync instance = new batchCSAccountDailySync();
                Database.executeBatch(instance);
            }

            Test.stopTest();       
        }catch(Exception ex){}
    } // END testmethod private static void testFlow4()
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testFlow5(){  // covering if(String.isEmpty(accountLoad.SendErrorNotificationTo__c))
        try{
            CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
            insert settingRecord;
            settingRecord.SendErrorNotificationTo__c = NULL;
            update settingRecord;
            CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
            insert csobj;
            Test.startTest();
        
            Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
            User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
            EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
            LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
            TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

            System.runAs(u){
                batchCSAccountDailySync instance = new batchCSAccountDailySync();
                Database.executeBatch(instance);
            }

            Test.stopTest();
        }catch(Exception ex){}      
    } // END testmethod private static void testFlow5()

    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testFlow6(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        Map<String, Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        Id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
        
        List<ERP_Customer__c> erpCustomers = new List<ERP_Customer__c>();
        for(Integer i=0; i<10; i++){
            if(i<=5)
                erpCustomers.add(
                    new ERP_Customer__c(
                        recordTypeid = RecTypeId, 
                        Name = TESTDATA,
                        Customer_Name_2__c = TESTDATA,
                        Customer_Code__c = TESTDATA,
                        Account_Group_Code__c = TESTDATA,
                        Account_Group__c = TESTDATA,
                        ERP_Account__c = TESTDATA,
                        PO_Box__c = TESTDATA,
                        Street__c = TESTDATA,
                        State__c = TESTDATA,
                        State_Province__c = TESTDATA,
                        Country__c = TESTDATA,
                        Country_Code__c = COUNTRYCODE,
                        ERP_YKPartnerCode__c = null,
                        Deletion_Flag__c = false,
                        Customer_Group_9__c= TESTDATA,
                        External_ERP_ID__c = EXTID+i
                ));
            else
                erpCustomers.add(
                        new ERP_Customer__c(
                            recordTypeid = RecTypeId, 
                            Name = TESTDATA,
                            Customer_Name_2__c = TESTDATA,
                            Customer_Code__c = TESTDATA,
                            Account_Group_Code__c = TESTDATA,
                            Account_Group__c = TESTDATA,
                            ERP_Account__c = TESTDATA,
                            PO_Box__c = TESTDATA,
                            Street__c = TESTDATA,
                            State__c = TESTDATA,
                            State_Province__c = TESTDATA,
                            Country__c = TESTDATA,
                            Country_Code__c = COUNTRYCODE,
                            ERP_YKPartnerCode__c = null,
                            Deletion_Flag__c = false,
                            External_ERP_ID__c = EXTID+i
                    ));
        }
        erpCustomers.add(
                new ERP_Customer__c(
                    recordTypeid = RecTypeId, 
                    Name = TESTDATA,
                    Customer_Name_2__c = TESTDATA,
                    Customer_Code__c = TESTDATA,
                    Account_Group_Code__c = TESTDATA,
                    Account_Group__c = TESTDATA,
                    PO_Box__c = TESTDATA,
                    Street__c = TESTDATA,
                    State__c = TESTDATA,
                    State_Province__c = TESTDATA,
                    Country__c = TESTDATA,
                    Country_Code__c = COUNTRYCODE,
                    ERP_YKPartnerCode__c = NULL,
                    Deletion_Flag__c = false,
                    External_ERP_ID__c = EXTID+(COUNTER+50)
            ));

        for(Integer i=10; i<20; i++)
                erpCustomers.add(
                    new ERP_Customer__c(
                        recordTypeid = RecTypeId, 
                        Name = TESTDATA,
                        Customer_Name_2__c = TESTDATA,
                        Customer_Code__c = TESTDATA,
                        Account_Group_Code__c = TESTDATA,
                        Account_Group__c = TESTDATA,
                        ERP_Account__c = TESTDATA,
                        PO_Box__c = TESTDATA,
                        Street__c = TESTDATA,
                        State__c = TESTDATA,
                        State_Province__c = TESTDATA,
                        Country__c = TESTDATA,
                        Country_Code__c = COUNTRYCODE,
                        ERP_YKPartnerCode__c = null,
                        Deletion_Flag__c = false,
                        Customer_Group_9__c= TESTDATA,
                        External_ERP_ID__c = EXTID+i
                ));

        Database.upsert(erpCustomers, Schema.sObjectType.ERP_Customer__c.fields.External_ERP_ID__c.getSObjectField());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Integer i=0; i<10; i++)
            accountsToUpdate.add(new Account(
                name = TESTDATA+i,
                External_ID__c = erpCustomers.get(i).External_ERP_ID__c,
                ERP_Customer__c = erpCustomers.get(i).id
            )); 
        
        Database.upsert(accountsToUpdate, Schema.sObjectType.Account.fields.External_ID__c.getSObjectField());
       
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountDailySync instance = new batchCSAccountDailySync();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    } // END testmethod private static void testFlow6()

    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testFlow7(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        Map<String, Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        Id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
        
        List<ERP_Customer__c> erpCustomers = new List<ERP_Customer__c>();
        for(Integer i=0; i<10; i++)
            erpCustomers.add(
                new ERP_Customer__c(
                    recordTypeid = RecTypeId, 
                    Name = TESTDATA,
                    Customer_Name_2__c = TESTDATA,
                    Customer_Code__c = TESTDATA,
                    Account_Group_Code__c = TESTDATA,
                    Account_Group__c = TESTDATA,
                    PO_Box__c = TESTDATA,
                    Street__c = TESTDATA,
                    State__c = TESTDATA,
                    State_Province__c = TESTDATA,
                    Country__c = TESTDATA,
                    Country_Code__c = COUNTRYCODE,
                    ERP_YKPartnerCode__c = null,
                    Deletion_Flag__c = False,
                    External_ERP_ID__c = EXTID+i
            ));
        
        Database.upsert(erpCustomers, Schema.sObjectType.ERP_Customer__c.fields.External_ERP_ID__c.getSObjectField());
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Integer i=0; i<10; i++)
            accountsToUpdate.add(new Account(
                name = TESTDATA+i,
                External_ID__c = erpCustomers.get(i).External_ERP_ID__c,
                ERP_Customer__c = erpCustomers.get(i).id
            )); 
        
        Database.upsert(accountsToUpdate, Schema.sObjectType.Account.fields.External_ID__c.getSObjectField());
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountDailySync instance = new batchCSAccountDailySync();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    } // END testmethod private static void testFlow7()
   
}
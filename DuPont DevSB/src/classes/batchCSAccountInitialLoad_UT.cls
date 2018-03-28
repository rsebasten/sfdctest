/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: Test class for the class batchCSAccountInitialLoad
 * Change history (key updates):
 * 2nd March, 2015 -> created the class
**/
@isTest
public class batchCSAccountInitialLoad_UT{

    private static final String RECORDTYPEVAL = 'ERP Customer - Extended Data';
    private static final String TESTDATA = 'TEST';
    private static final Integer COUNTER = 0;
    private static final String ERPRecordname = 'ERP Relationship - Person';
    private static final String TESTPARTNERCODE = '100';
    private static final String PARTNERCODEFUNCTION = 'YK';
    private static final String ZRPARTNERCODEFUNCTION = 'ZR';
    private static final String COUNTRYCODE = 'IN';
    private static final String INITIAL_VAL = '';
    private static final String TEST_GROUP = '<accountGroup>';
    private static final String TEST_RECORD = '<recordTypeName>';
    private static final String EXTID = 'TestExternal123';
    
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
     */  
   private static testmethod void testFlow(){
        //Create Custom Setting Record to store Account Load Settings    
        
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        
        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
        
        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
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
        erRecord.ERP_YKPartnerCode__c  = 'TEST';
        erRecord.Deletion_Flag__c = false;
        //erRecord.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +1);
        erRecord.External_ERP_ID__c = EXTID;
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
//        erRecord1.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +2);
        erRecord1.Deletion_Flag__c= false;
        erRecord1.External_ERP_ID__c =EXTID+(COUNTER+2);
        erRecord1.CreatedDate = System.Now();
        erpCustomers.add(erRecord1);
        //database.insert(erRecord1);
        database.insert(erpCustomers);
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord1.Id;
        erpRel.Partner_Code__c=TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION;
        database.insert(erpRel);
        /*
        ERP_Relationship__c erpRel1= new ERP_Relationship__c();
        erpRel1.ERP_Customer__c=erRecord1.Id;
        erpRel1.Partner_Code__c=TESTPARTNERCODE;
       // erpRel1.Partner_Function_Code__c= ZRPARTNERCODEFUNCTION;
       // erpRel1.recordTypeid=[SELECT id from RecordType where Name =: ERPRecordname and SobjectType='ERP_Relationship__c'].Id;
        database.insert(erpRel1);
        */
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
            batchCSAccountInitialLoad instance = new batchCSAccountInitialLoad();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    } 

    /**
     * Test Method 
     */  
    private static testmethod void testFlow1(){
        //Test
       
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;

        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;

        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        Id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
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
        erRecord.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord.Deletion_Flag__c = false;
        //erRecord.External_ERP_ID__c  = TESTDATA+(COUNTER+1);
        erRecord.External_ERP_ID__c =EXTID;
        database.insert(erRecord);
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c = erRecord.Id;
        erpRel.Partner_Code__c = TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION;
        database.insert(erpRel);
        Account acc = new Account();
        acc.Name = TESTDATA;
        acc.ERP_Customer__c = erRecord.id;
        acc.External_ID__c =erRecord.External_ERP_ID__c;
        database.insert(acc);
        erRecord.Name=TESTDATA;
        database.update(erRecord);
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountInitialLoad instance = new batchCSAccountInitialLoad();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    }

    /**
     * Test Method 
     */  
     private static testmethod void testFlow2(){
        //Test
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;

        // Create PartnerTypeSetting Record 
        CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
        insert csobj;
		Test.startTest();
        Map<String,Id> recordTypeMap = utilCSBatchAccountLoad_UT.createRecordTypeMap();
        id RecTypeId  = recordTypeMap.get(RECORDTYPEVAL);
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
//[01172017] Merge&Spin: Moved erRecord creation inside runAs as it was not accesible for user if outside and corrected values according to batch requirement.
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
        erRecord.ERP_YKPartnerCode__c  =  TESTDATA;
        erRecord.Deletion_Flag__c=false;
        //erRecord.External_ERP_ID__c  = TESTDATA+(COUNTER+1);
        erRecord.External_ERP_ID__c  = EXTID;
        insert erRecord;
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord.Id;
        erpRel.Partner_Code__c=TESTDATA;
        erpRel.Partner_Function_Code__c=PARTNERCODEFUNCTION;
        database.insert(erpRel);
            batchCSAccountInitialLoad instance = new batchCSAccountInitialLoad();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    }
    
    /**
     * Test Method 
     */  
    private static testmethod void testFlow3(){
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
        erRecord.External_ERP_ID__c =EXTID;
      //  erRecord.ERP_YKPartnerCode__c  = TESTPARTNERCODE+1;
        erRecord.Deletion_Flag__c=true;
        erRecord.External_ERP_ID__c  = TESTDATA+(COUNTER+1);
        database.insert(erRecord);
        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord.Id;
        erpRel.Partner_Code__c=TESTPARTNERCODE;
       // erpRel.Partner_Function_Code__c=ZRPARTNERCODEFUNCTION;
        database.insert(erpRel);
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0]]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            batchCSAccountInitialLoad instance = new batchCSAccountInitialLoad();
            Database.executeBatch(instance);
        }

        Test.stopTest();
    }

    /**
     * Test Method 
     */  
    testmethod private static void testFlow4(){  // covering if(accountLoad == NULL)
        try{
            Test.startTest();
            System.runAs(new User(id=UserInfo.getUserId())){
                Database.executeBatch(new batchCSAccountInitialLoad());
            }
            Test.stopTest();
        }catch(Exception ex){System.debug(ex.getMessage());}
    } // END testmethod private static void testFlow4()

    /**
     * Test Method 
     */  
    testmethod private static void testFlow5(){  // covering if(partnerCodes.isEmpty())
        try{
            CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
            insert settingRecord;
            Test.startTest();
            System.runAs(new User(id=UserInfo.getUserId())){
                Database.executeBatch(new batchCSAccountInitialLoad());
            }
            Test.stopTest();        
        }catch(Exception ex){}
    } // END testmethod private static void testFlow5()

    /**
     * Test Method */
      
    testmethod private static void testFlow6(){  // covering if(String.isEmpty(accountLoad.SendErrorNotificationTo__c))
        try{
            CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
            insert settingRecord;
            settingRecord.SendErrorNotificationTo__c = NULL;
            update settingRecord;
            CS_YKPartnerMapping__c csobj = utilCSBatchAccountLoad_UT.createPartnerTypeSettingRecord();
            insert csobj;
            Test.startTest();
            System.runAs(new User(id=UserInfo.getUserId())){
                Database.executeBatch(new batchCSAccountInitialLoad());
            }
            Test.stopTest();  
        }catch(Exception ex){System.debug(ex.getMessage());} 
    } // END testmethod private static void testFlow6()*/ 

}
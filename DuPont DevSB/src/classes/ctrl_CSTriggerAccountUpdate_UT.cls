/**
 * Description: Test class for the class ctrl_CSTriggerAccountUpdate
 * @author Sanchit Dua
 * email sanchit.dua@accenture.com
 * Change history (key updates):
 * 28th May, 2015 -> created the class
 */
 @isTest
private class ctrl_CSTriggerAccountUpdate_UT {

    private static final String RECORDTYPEVAL = 'ERP Customer - Extended Data';
    private static final String TESTDATA = 'TEST';
    private static final String COUNTRYCODE = 'IN';
    private static final Integer COUNTER = 0;
    private static final String TESTPARTNERCODE = '100';
    private static final String PARTNERCODEFUNCTION = 'YK';
    private static final String INITIAL_VAL = '';

    private static final String ERRORMSG = 'using the custom button with the right user Customer Service.';
    private static final String PRIVILEGES = 'Insufficient Privileges';
    private static final String SUCCESS = 'Account has been created/updated successfully';

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

    /*
     * Test Method
     */
    @isTest static void test_method_one() {
        // Implement test code
        ApexPages.StandardController sc = new ApexPages.standardController(new ERP_Customer__c());
        String result = '';
        String result2='';

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
        erRecord.ERP_YKPartnerCode__c  = NULL;
        erRecord.Deletion_Flag__c = true;
        erRecord.Customer_Group_9__c='Testijjng';

        erRecord.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +1);
        erpCustomers.add(erRecord);
        //database.insert(erRecord);
        ERP_Customer__c erRecord1 = new ERP_Customer__c();
        erRecord1.recordTypeid          = RecTypeId;
        erRecord1.Name                  = TESTDATA;
        erRecord1.Customer_Name_2__c    = TESTDATA;
        erRecord1.Customer_Code__c      = TESTDATA;
        erRecord1.Account_Group_Code__c = TESTDATA;
        erRecord1.Account_Group__c      = TESTDATA;  
        erRecord1.ERP_Account__c        = TESTDATA;
        erRecord1.PO_Box__c             = TESTDATA;
        erRecord1.Street__c             = TESTDATA;
        erRecord1.State__c              = TESTDATA;
        erRecord1.State_Province__c     = TESTDATA;
        erRecord1.Country__c            = TESTDATA;
        erRecord1.Country_Code__c       = COUNTRYCODE;
        erRecord1.ERP_YKPartnerCode__c  = NULL;
        erRecord1.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +2);
        erRecord1.Deletion_Flag__c= false;
        erRecord1.Customer_Group_9__c='Testijjng';
        //erRecord1.CreatedDate = System.Now();
        erpCustomers.add(erRecord1);
        
        //database.insert(erRecord1);
        database.insert(erpCustomers);

        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord1.Id;
        erpRel.Partner_Code__c=TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION;
        database.insert(erpRel);
        
        Account acc= new Account();
        acc.name = TESTDATA;
        acc.ERP_Customer__c = erRecord.id;
        acc.External_ID__c =erRecord.External_ERP_ID__c;
        
        database.insert(acc);


        Test.startTest();

        Profile p = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[4] LIMIT 1]; 
        User u = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[0], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);

        System.runAs(u){
            ctrl_CSTriggerAccountUpdate c = new ctrl_CSTriggerAccountUpdate(sc);
            result = ctrl_CSTriggerAccountUpdate.upsertAccount(erpCustomers[0].Id);
            result2 = ctrl_CSTriggerAccountUpdate.upsertAccount(erpCustomers[1].Id);
        }
        
        
       
        Test.stopTest();
        system.debug('thje result obtained is: '+result);
        //System.assert(result.contains(SUCCESS), SUCCESS);
        System.debug('_____'+result2);
    }
    
    /*
     * Test Method
     */
    @isTest static void test_method_two() {
        // Implement test code
        ApexPages.StandardController sc = new ApexPages.standardController(new ERP_Customer__c());
        String result = INITIAL_VAL;
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
        erRecord.ERP_YKPartnerCode__c  = NULL;
        erRecord.Deletion_Flag__c = false;
        erRecord.Customer_Group_9__c='Testijjng';
        erRecord.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +1);
        erpCustomers.add(erRecord);
        //database.insert(erRecord);
        ERP_Customer__c erRecord1 = new ERP_Customer__c();
        erRecord1.recordTypeid          = RecTypeId;
        erRecord1.Name                  = TESTDATA;
        erRecord1.Customer_Name_2__c    = TESTDATA;
        erRecord1.Customer_Code__c      = TESTDATA;
        erRecord1.Account_Group_Code__c = TESTDATA;
        erRecord1.Account_Group__c      = TESTDATA;  
        erRecord1.ERP_Account__c        = TESTDATA;
        erRecord1.PO_Box__c             = TESTDATA;
        erRecord1.Street__c             = TESTDATA;
        erRecord1.State__c              = TESTDATA;
        erRecord1.State_Province__c     = TESTDATA;
        erRecord1.Country__c            = TESTDATA;
        erRecord1.Country_Code__c       = COUNTRYCODE;
        erRecord1.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
        erRecord1.External_ERP_ID__c  = TESTPARTNERCODE + (COUNTER +2);
        erRecord1.Deletion_Flag__c= true;
        erRecord1.CreatedDate = System.Now();
        
        erpCustomers.add(erRecord1);
        
        //database.insert(erRecord1);
        database.insert(erpCustomers);

        ERP_Relationship__c erpRel= new ERP_Relationship__c();
        erpRel.ERP_Customer__c=erRecord1.Id;
        erpRel.Partner_Code__c=TESTPARTNERCODE;
        erpRel.Partner_Function_Code__c= PARTNERCODEFUNCTION;
        database.insert(erpRel);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name=:PLACEHOLDERS[0] LIMIT 1]; 
        User u2 = new User(Alias = PLACEHOLDERS[1], Email=PLACEHOLDERS[2], 
        EmailEncodingKey=PLACEHOLDERS[3], LastName=PLACEHOLDERS[4], LanguageLocaleKey=PLACEHOLDERS[5], 
        LocaleSidKey=PLACEHOLDERS[5], ProfileId = p2.Id, 
        TimeZoneSidKey=PLACEHOLDERS[6], UserName=PLACEHOLDERS[7]);
        Test.startTest();
        
        System.runAs(u2){
            ctrl_CSTriggerAccountUpdate c = new ctrl_CSTriggerAccountUpdate(sc);
            result = ctrl_CSTriggerAccountUpdate.upsertAccount(erpCustomers[0].Id);
            String result2 = ctrl_CSTriggerAccountUpdate.upsertAccount(erpCustomers[1].Id);
            
        }
        //system.debug('the result obtained in two is: '+result);
        Test.stopTest();
        System.assert(result.contains(PRIVILEGES), PRIVILEGES);
        
    }
    
}
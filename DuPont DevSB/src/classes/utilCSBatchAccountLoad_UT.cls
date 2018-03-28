/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: Test class for the class utilCSBatchAccountLoad
**/
public without sharing class utilCSBatchAccountLoad_UT{

    private static final String RECORDTYPEVAL = 'ERP Customer - Extended Data';
    private static final String TESTDATA = 'TEST';
    private static final String ERPCUSTOMER = 'ERP_Customer__c';
    private static final String TESTPARTNERCODE = '100';
    private static final String PARTNERCODEFUNCTION = 'YK';
    private static final String COUNTRYCODE = 'IN';
    private static final String INITIAL_VAL = '';
    private static final String BLANK_VAL = ' ';
    private static final String TESTEMAIL = 'abc46558732134656843@xyz.com';
    private static final Integer lmt = Limits.getLimitQueryRows();
        
    /*
    * Method to create a Map of Record Types
    * return Map of Record Type name with its Id
    */
    public static Map<String,Id> createRecordTypeMap(){
        Map<String,Id> mapRecordTypes = new Map<String,Id>(); 
        try{
            //Query for Record Types
            for(RecordType rt: [Select Name, Id From RecordType where sObjectType =: ERPCUSTOMER and isActive = true LIMIT: lmt])
                mapRecordTypes.put(rt.Name,rt.Id);
        }catch(Exception ex){}
        return mapRecordTypes;
    }

    /*
    Method to create a list of ERP_Customer__c Records
    Parameters : integer-Number of records to be created
                 String - Mane of Record Type
    Returns : List of ERP_Customer__c
    */
    public static List<ERP_Customer__c> createERPCustomerList(Integer i, String RecordTypeName){
        List<ERP_Customer__c> tempList = new List<ERP_Customer__c>();
        try{
            Id RecTypeId = createRecordTypeMap().get(RecordTypeName);
            for(Integer j = 0;j<i;j++ ){
                ERP_Customer__c erRecord = new ERP_Customer__c();
                    erRecord.recordTypeid          = RecTypeId;
                    erRecord.Name                  = TESTDATA+BLANK_VAL+j;
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
                    erRecord.Deletion_Flag__c=False;
                    //erRecord.CreatedDate = date.newInstance(2015, 4, 15);
                    erRecord.CreatedDate = System.Now();
                    tempList.add(erRecord);
            }
        }catch(Exception ex){}
        return tempList;
    }

    /*
    * Method to create an Account related to an ERP customer
    * Parameters : ERP_Customer__c : ERP Customer Record to be linked to Account
    * Returns : Account Object
    */
    public Static Account createAccountRelatedtoCustomer(ERP_Customer__c cust){
        Account acc= new Account();
        try{
            acc.name = TESTDATA;
            acc.ERP_Customer__c = cust.id;
        }catch(Exception ex){}
        return acc;
    }

    /*
    * Method to create a CS_Account_Load_Settings__c record
    * Parameters : none
    * Returns : Custom Setting 'CS_Account_Load_Settings__c' record
    */
    public static CS_Account_Load_Settings__c createAccountLoadSettingRecord(){
        CS_Account_Load_Settings__c alSetting = new CS_Account_Load_Settings__c();
        try{
            alSetting.name                = TESTDATA;
            alSetting.AccountGroup__c     = TESTDATA;    
            alSetting.AccountOwner__c       = TESTDATA;
            alSetting.RecordType_Name__c  = RECORDTYPEVAL;
            alSetting.SendErrorNotificationTo__c     = TESTEMAIL;
            alSetting.AccountOwnerUserName__c = TESTEMAIL;
        }catch(Exception ex){}
        return alSetting;
    }

    /*
    Method to create a CS_YKPartnerTypes__c record
    Parameters : none
    Returns : Custom Setting 'CS_YKPartnerTypes__c' record
    */
    public static CS_YKPartnerMapping__c createPartnerTypeSettingRecord(){
        CS_YKPartnerMapping__c partnerSetting  = new CS_YKPartnerMapping__c();
        try{
            partnerSetting.Name = TESTDATA;
            partnerSetting.Shared_Service_Center__c = TESTDATA;
        }catch(Exception ex){}
        return partnerSetting;
    }


    /*newly added */
    public static List<ERP_Customer__c> createERPCustomerList1(integer i,String RecordTypeName){
        List<ERP_Customer__c> tempList = new List<ERP_Customer__c>();
        try{
            Id RecTypeId = createRecordTypeMap().get(RecordTypeName);
            for(Integer j = 0;j<i;j++ ){
                ERP_Customer__c erRecord = new ERP_Customer__c();
                    erRecord.recordTypeid          = RecTypeId;
                    erRecord.Name                  = TESTDATA+BLANK_VAL+j;
                    erRecord.Customer_Name_2__c    = TESTDATA;
                    erRecord.Customer_Code__c      = TESTDATA+j;
                    erRecord.Account_Group_Code__c = TESTDATA;
                    erRecord.Account_Group__c      = TESTDATA;  
                    erRecord.ERP_Account__c        = NULL;
                    erRecord.PO_Box__c             = TESTDATA;
                    erRecord.Street__c             = TESTDATA;
                    erRecord.State__c              = TESTDATA;
                    erRecord.State_Province__c     = TESTDATA;
                    erRecord.Country__c            = TESTDATA;
                    erRecord.Country_Code__c       = COUNTRYCODE;
                    erRecord.ERP_YKPartnerCode__c  = TESTPARTNERCODE;
                    erRecord.External_ERP_ID__c  = TESTDATA+j;
                    erRecord.Deletion_Flag__c=False;
                   // erRecord.CreatedDate = date.newInstance(2015, 4, 15);
                    erRecord.CreatedDate = System.Now();
                    tempList.add(erRecord);
            }
        }catch(Exception ex){}
        return tempList;
    } 

}
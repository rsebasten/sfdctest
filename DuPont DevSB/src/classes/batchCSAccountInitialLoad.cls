/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Batch Process to do a Daily Load from ERP Customer into Account object. 

Change history (key updates):
@author sanchit.dua
email sanchit.dua@accenture.com
20th April, 2015 -> added line 61 to 80
20th April, 2015 -> 112 to 156
20th April, 2015 -> 164 to 168

28th October,2015-> Queried for fLanguage_General__c,fLanguage_Code_General__c,fSearch_Term_General__c fields with timestamp <SB20151028>

@ Abinand Aravazhi 
20th Jan, 2016 --> Changed logic to include General Account Creation 
               --> Changes Indicated with the Tag <AA01202016>

 ********************************************************************************/

/* This class will load the data from ERP Customers into Account object. */
global class batchCSAccountInitialLoad implements Database.Batchable<sObject>, Database.Stateful {
    global utilCSBatchErrorLog batchErrorLog;
    
    private static final string ERROR_MSG = ' .Trace: ';
    private static final String INITIAL_VAL = '';
    private Integer lmt = Limits.getLimitQueryRows();
    private static Set<String> partnerCodes = new Set<String>();
    private static CS_Account_Load_Settings__c accountLoad;
    global boolean erroredOut;
    private static final string ZRCode ='ZR';
    private static final string USER_ERROR = 'Error: the ERP Customers to be updated doensn\'t exist.';
    private static final string accountLoadNotExist = 'Custom Settings CS_Account_Load_Settings__c does not exist.';
    private static final string partnerCodesNotExist = 'Custom Settings CS_YKPartnerMapping__c does not exist.';
    private static final string toAddressNotExist = 'SendErrorNotificationTo__c field value of CS_Account_Load_Settings__c custom settings does not exist.';

    private static final String query = 'SELECT Name, Account_Group__c, Account_Group_Code__c,'+
    '        Language__c,Language_Code__c,fLanguage_General__c,fLanguage_Code_General__c, '+
    '        ERP_YKPartnerCode__c, Source_Cluster__c,RecordTypeid,ERP_Account__c,Customer_General_Data__c,'+
    '        Sales_Org_Code__c,Sales_Org__c, City__c, Country__c, '+
    '        Customer_Group_2__c,Distribution_Channel_Code__c,'+
    '        Distribution_Channel__c,Division_Code__c,Division__c, '+
    '        Customer_Group_2_Code__c, Customer_Group_9__c, '+
    '        Customer_Group_9_Code__c, Street__c, PO_Box__c, '+
    '        Customer_Code__c,Search_Term__c,fSearch_Term_General__c, External_ERP_ID__c , Deletion_Flag__c '+
    '        FROM ERP_Customer__c                                                   '+
    '        WHERE Account_Group__c = \'<accountGroup>\' AND Deletion_Flag__c = False '+
    '        AND (ERP_YKPartnerCode__c IN:partnerCodes)'+
    '        AND Recordtype.Name =\'<recordTypeName>\' limit ';
    
    private static final String accountGroupPlaceHolder = '<accountGroup>';
    private static final String rtPlaceHolder = '<recordTypeName>';
    private static final String ERPRECORDTYPENAME= 'ERP Relationship - Person';
    
    static {
        //partnerCodes = new Set<String>();
        if( !CS_Account_Load_Settings__c.getall().isEmpty() )
            accountLoad = CS_Account_Load_Settings__c.getall().values()[0];
        for(CS_YKPartnerMapping__c partner: CS_YKPartnerMapping__c.getall().values()) 
                partnerCodes.add(partner.Name);
        
    }
   
    
    /*Description :  This method is used for logging the errors. */
    public batchCSAccountInitialLoad(){
        batchErrorLog = new utilCSBatchErrorLog();
        erroredOut = false;
    }
    
    /* Start Method: To fetch the records to be processed */
    global Database.QueryLocator start(Database.BatchableContext BC){   
        System.LoggingLevel level = LoggingLevel.FINEST;
            if(accountLoad == NULL){
                System.debug(logginglevel.ERROR, Label.CS_ErrorMessage+accountLoadNotExist );
                erroredOut = true;
                throw new IntentionalException();
            }
            
            if(partnerCodes.isEmpty()){
                System.debug(logginglevel.ERROR, Label.CS_ErrorMessage+partnerCodesNotExist);
                erroredOut = true;
                throw new IntentionalException();
            }
            
            if(accountLoad.SendErrorNotificationTo__c == NULL){
                System.debug(logginglevel.ERROR, Label.CS_ErrorMessage+toAddressNotExist);
                erroredOut = true;
                throw new IntentionalException();
            } 
            Database.QueryLocator q = Database.getQueryLocator(query.replace(accountGroupPlaceHolder, accountLoad.AccountGroup__c).replace(rtPlaceHolder, accountLoad.RecordType_Name__c)+lmt );
            Database.QueryLocatorIterator it =  q.iterator();
            if(it.hasNext()){
            

                return q;}

            else{
            
                erroredOut = NULL;
                return q;
            }    
    } // END start()

    /*Execute Method: This method is used to create/update accounts from the ERP Customer records. */
    global void execute(Database.BatchableContext BC, List<sobject> scope) {
      
      
      
       if( erroredOut != NULL && !erroredOut ){
            Map<Id,ERP_Customer__c> erpCustomerMap = new Map<Id,ERP_Customer__c>();
        
            for(Sobject sobj: scope){
                ERP_Customer__c customer = (ERP_Customer__c) sobj;
                erpCustomerMap.put(customer.id, customer);
            }
            Map<Id,ERP_Customer__c> duplicateErpCustomerMap = new Map<Id, ERP_Customer__c>();

            for(Id customerId: erpCustomerMap.keySet())
                duplicateErpCustomerMap.put(customerId, erpCustomerMap.get(customerId));
                     

            utilCSAccountLoad data =  new utilCSAccountLoad();
            // AA01202016 - Calling the New function in Util Class.
            if(!(erroredOut=data.erpCust_AccountfieldsMapping(erpCustomerMap, null, batchErrorLog, accountLoad.AccountOwnerUserName__c, erroredOut,null))){
                List<ERP_Customer__c> erpCustToUpdate = new List<ERP_Customer__c>();
                for(ERP_Customer__c ec :duplicateErpCustomerMap.values()){
                    if(!batchErrorLog.erpIdWithMsg.isEmpty() || !batchErrorLog.erpIds.isEmpty()){
                        if(batchErrorLog.erpIdWithMsg.containsKey(ec.id) || batchErrorLog.erpIds.contains(ec.id)){
                            continue;
                        }
                    }
                    ec.ERP_Account__c = accountLoad.AccountOwner__c;
                    erpCustToUpdate.add(ec);
                }
                String errMessage = INITIAL_VAL ;
            } // END if
        } // END if      
    } // END execute()

    /* Finish Method: This method will catch the errors occured(if any) while records are created/updated. */
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob apexJobs = [SELECT Id,
                                 ApexClass.name
                                 FROM AsyncApexJob 
                                 WHERE Id =:BC.getJobId() limit :lmt];
        utilCSEmail.finishEmail(batchErrorLog, apexJobs.ApexClass.name, erroredOut);
      
    } // END finish()
    /**
     * Class responsible for providing custom exception
     * @author Sanchit Dua
     * email sanchit.dua@accenture.com
     */
    public without sharing class IntentionalException extends Exception {}
    
}
/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Batch Process to do a Daily Load from ERP Customer into Account object. 

Change history (key updates):
@author sanchit.dua
email sanchit.dua@accenture.com
20th April, 2015 -> changed all the logic and code.
 * 30th Jul, 2015 -> AA - Added Condition to prevent update of ERP Customer(AA 20150730).
 
* 28th October,2015-> SB- Queried for fLanguage_General__c,fLanguage_Code_General__c,fSearch_Term_General__c fields with timestamp <SB20151028>

@ Abinand Aravazhi 
20th Jan, 2016 --> Changed logic to include General Account Creation 
               --> Changes Indicated with the Tag <AA01202016>

 ********************************************************************************/
/* Description: This class will run daily to update the Accounts based on the ERP customers. */
global class batchCSAccountDailySync implements Database.batchable<sobject>, Database.Stateful {

    //variable being used in class.
    
    private static Set<String> partnerCodes = new Set<String>();
    private static final String INITIAL_VAL = '';
    private static final String ERPACCOUNTVAL = 'Customer Service';
    private static final String ERROR_MSG = ' .Trace:';
    private utilCSBatchErrorLog  batchErrorLog;
    private static CS_Account_Load_Settings__c accountLoad;
    global boolean erroredOut;
    private static final string USER_ERROR = 'Error: the ERP Customers to be updated doensn\'t exist.';
    private static final string accountLoadNotExist = 'Custom Settings CS_Account_Load_Settings__c does not exist.';
    private static final string partnerCodesNotExist = 'Custom Settings CS_YKPartnerMapping__c does not exist.';
    private static final string toAddressNotExist = 'SendErrorNotificationTo__c field value of CS_Account_Load_Settings__c custom settings does not exist.';
    private static final String ERPRECORDTYPENAME= 'ERP Relationship - Person';
    
    static {
        if( !CS_Account_Load_Settings__c.getall().isEmpty() )
            accountLoad = CS_Account_Load_Settings__c.getall().values()[0];  
        
        if(CS_YKPartnerMapping__c.getInstance() != null){
            for(CS_YKPartnerMapping__c partner: CS_YKPartnerMapping__c.getall().values()) 
                    partnerCodes.add(partner.Name);         
        }
    } 
    
    /*Description :  This method is used for logging the errors. */
    public batchCSAccountDailySync(){
        batchErrorLog = new utilCSBatchErrorLog();
        erroredOut = false;
    }

    /*Start Method: This will return filtered ERP Customer records that are to be loaded into Accounts based on these conditions- Account Group = Z001 (Sold-to party), Deletion Flag = False and CreatedDate/LastModifiedDate in last 1 day. */
    global Database.QueryLocator start(Database.BatchableContext BC){
        
       //System.LoggingLevel level = LoggingLevel.FINEST;
            
        if(accountLoad == NULL){
            erroredOut = true;
            throw new IntentionalException();
        }
        
        if(partnerCodes.isEmpty()){
            erroredOut = true;
            throw new IntentionalException();
        }
        
        if(accountLoad.SendErrorNotificationTo__c == NULL){
            erroredOut = true;
            throw new IntentionalException();
        } 
        
        Integer lmt = Limits.getLimitQueryRows();
        

        /* <SB20151028> --  Queried for fLanguage_General__c,fLanguage_Code_General__c,fSearch_Term_General__c fields */
        Database.QueryLocator q = Database.getQueryLocator([Select Id, RecordType.Name,Customer_General_Data__c,Name, Account_Group__c, ERP_Account__c, Account_Group_Code__c,Language__c,fLanguage_General__c,fLanguage_Code_General__c,
        Language_Code__c, ERP_YKPartnerCode__c, Source_Cluster__c,Sales_Org_Code__c,
        Sales_Org__c, City__c, Country__c, Customer_Group_2__c,Distribution_Channel_Code__c,
        Distribution_Channel__c,Division_Code__c,Division__c, Customer_Group_2_Code__c,
        Customer_Group_9__c, Customer_Group_9_Code__c, PO_Box__c, Street__c, Customer_Code__c, 
        Search_Term__c,fSearch_Term_General__c, External_ERP_ID__c, Deletion_Flag__c
        FROM ERP_Customer__c 
        WHERE Account_Group__c = :accountLoad.AccountGroup__c AND 
        (LastModifiedDate = LAST_N_DAYS:1 or CreatedDate = LAST_N_DAYS:1) AND
        (((Recordtype.Name =: accountLoad.RecordType_Name__c) AND (ERP_YKPartnerCode__c != NULL OR (ERP_YKPartnerCode__c = NULL AND ERP_Account__c =:accountLoad.AccountOwner__c)))
        OR (Recordtype.Name =: accountLoad.Record_Type_Name_General__c AND ERP_Account__c =:accountLoad.AccountOwner__c))
        limit :lmt]);
                         
        Database.QueryLocatorIterator it =  q.iterator();
        
        if(it.hasNext())
            return q;
        else{
            erroredOut=NULL;
            return q;
        }    
    } // END start
    

    /*Execute Method: This method includes the actual batch logic which is to do the mapping between ERP Customer and Accounts and then load them. */
    global void execute(Database.BatchableContext BC, List<ERP_Customer__c> erpCustomerList) {
        if( erroredOut != NULL && !erroredOut ){
            Map<Id,ERP_Customer__c> erpCustomerToInsert = new Map<Id,ERP_Customer__c>();
            Map<Id,ERP_Customer__c> erpCustomerToUpdate = new Map<Id,ERP_Customer__c>();
            Map<Id,ERP_Customer__c> erpGeneralToUpdate = new Map<Id,ERP_Customer__c>();

            for(ERP_Customer__c erpCustomer : erpCustomerList){
                if(erpCustomer.Recordtype.Name==accountLoad.Record_Type_Name_General__c){
                      erpGeneralToUpdate.put(erpCustomer.id,erpCustomer);
                }else{
                    if(erpCustomer.ERP_Account__c == null){
                        erpCustomerToInsert.put(erpCustomer.id,erpCustomer);
                    }
                    else{
                        erpCustomerToUpdate.put(erpCustomer.id,erpCustomer);   
                    }
                }
            }    


           
            // Following maps are made in order to maintain the deep cloning of the original insert map
            Map<Id,ERP_Customer__c> duplicateInsertErpCustomerMap = new Map<Id, ERP_Customer__c>();
            for(Id customerId: erpCustomerToInsert.keySet())
                duplicateInsertErpCustomerMap.put(customerId, erpCustomerToInsert.get(customerId));
            
            // Following maps are made in order to maintain the deep cloning of the original update map
            Map<Id,ERP_Customer__c> duplicateUpdateErpCustomerMap = new Map<Id, ERP_Customer__c>();
            for(Id customerId: erpCustomerToUpdate.keySet())
                duplicateUpdateErpCustomerMap.put(customerId, erpCustomerToUpdate.get(customerId));
            
            
            utilCSAccountLoad utilData = new utilCSAccountLoad();
            if(!erpCustomerToInsert.isEmpty())
                // AA01202016 - Calling updated function to Update General Account also.
                if(utilData.erpCust_AccountfieldsMapping(erpCustomerToInsert,null, batchErrorLog, accountLoad.AccountOwnerUserName__c, erroredOut,null)){  // <-- at this moment the account is not getting updated 
                    erroredOut = true;
                    return;
                }
            Integer lmt = Limits.getLimitQueryRows();

            List<account> existingAccount = new List<Account>();
            if(!erpCustomerToUpdate.values().isEmpty())
                existingAccount.addAll([Select Id, Name, ERP_Customer__c 
                                                               FROM Account 
                                                               WHERE ERP_Customer__c IN :erpCustomerToUpdate.values() LIMIT :lmt]);                                               
            Map<Id,Account> accsToUpdateMap = new Map<Id,Account>() ;

            for(Integer i=0;i<existingAccount.size();i++){
                accsToUpdateMap.put(existingAccount[i].ERP_Customer__c,existingAccount[i]);
            }

            if(!erpCustomerToUpdate.isEmpty()){
                // AA01202016 - Calling updated function to Update General Account also.
                utilData.erpCust_AccountfieldsMapping(erpCustomerToUpdate, accsToUpdateMap, batchErrorLog, accountLoad.AccountOwnerUserName__c, erroredOut,erpGeneralToUpdate); 
            }

            List<ERP_Customer__c> erpCustVal = new List<ERP_Customer__c>();
            for(ERP_Customer__c ec :duplicateUpdateErpCustomerMap.values()){
                // In case of any error happens while updating/inserting the Account records the existing ERP Customer records should not get update/inserted
                if(!batchErrorLog.erpIdWithMsg.isEmpty() || !batchErrorLog.erpIds.isEmpty()){
                    if(batchErrorLog.erpIdWithMsg.containsKey(ec.id) || batchErrorLog.erpIds.contains(ec.id)){
                        continue;
                    }
                }
                ec.ERP_Account__c = accountLoad.AccountOwner__c ;
                erpCustVal.add(ec);
            }
            
             for(ERP_Customer__c ec :duplicateInsertErpCustomerMap.values()){

                // In case of any error happens while updating/inserting the Account records the existing ERP Customer records should not get update/inserted
                if(!batchErrorLog.erpIdWithMsg.isEmpty() || !batchErrorLog.erpIds.isEmpty()){
                    if(batchErrorLog.erpIdWithMsg.containsKey(ec.id) || batchErrorLog.erpIds.contains(ec.id)){
                        continue;
                    }
                }
                /* AA 20150730 Added Code for preventing ERP Account updates. */
                if(ec.ERP_YKPartnerCode__c == NULL || !partnerCodes.contains(ec.ERP_YKPartnerCode__c) || ec.Deletion_Flag__c == true){
                      
                }else{
                ec.ERP_Account__c = accountLoad.AccountOwner__c ;
                erpCustVal.add(ec);
                }
            } 
        } // END if      
    } // END execute

    /*Finish Method: */
    global void finish(Database.BatchableContext BC) {
        Integer lmt = Limits.getLimitQueryRows();
        AsyncApexJob apexJobs = [SELECT Id,
                                 ApexClass.name
                              FROM AsyncApexJob 
                              WHERE Id =:BC.getJobId() limit :lmt];
        
            utilCSEmail.finishEmail(batchErrorLog, apexJobs.ApexClass.name, erroredOut);
        
    } // END finish
    
    /*
     * @author sanchit.dua
     */
    public without sharing class IntentionalException extends Exception {}
    
    
}
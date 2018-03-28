/*******************************************************************************
Copyright ? 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Utility class for both Initial Load and Daily Sync Batch Processes. 
  * 30th Jul, 2015 -> AA - Added Condition to prevent creation of Account(AA 20150730).

@ author p.dhiman@accenture.com
21st sep, 2015 -> Added Condition to populate ZR Partner Name associated with ERP Customer's
                ERP Relationship on  corresponding Account record's ZR Partner Field.
                
@ Abinand Aravazhi 
20th Jan, 2016 --> Changes in logic to include General Account Creation 
               --> Changes Indicated with the Tag <AA01202016>

18th Feb, 2016 --> Changes in logic for Local Language with TAg<AA02182016>
15th Mar, 2016 --> Changes for preventing duplicate parent account creation. <AA03152016>
22nd Mar, 2016 --> More Changes for preventing duplicate parent account creation. Tag<AA03222016>
//<AB20160628> - Updated to get Customer Group 2 for Accounts from ERP Customer
 ********************************************************************************/
/* This class acts as utility class for Batch_CS_accountInitialLoad and Batch_CS_DailySync*/
public class utilCSAccountLoad{

    private static final Map<String, String> partnerCodeWithCountryCode;
    private static final set<String> zrpartnerCodes;
    private static final String INITIAL_VAL = '';
    public static RecordType recTypeExtAcc,recTypeGenAcc,recTypeExtErpCus,recTypeGenErpCus;
    private static final string SOBJECTNAME = 'Account';
    private static final string RECORDTYPENAME = 'ERP_Customer_General';
    private static final string RECORDTYPENAMEGENACC = 'ERP_Customer_General';  
    private static final string SOBJECTNAMEERPCUS = 'ERP_Customer__c';
    private static final string RECORDTYPENAMEEXTDATA = 'ERP_Customer_Extended_Data';
    private static final string RECORDTYPENAMEGENDATA = 'ERP_Customer_General_Data';   
    private static final string OPENBRACE = ' (';
    private static final string CLOSEBRACE = ')';
    private static final string STATUS_ACTIVE = 'Active';
    private static final string STATUS_INACTIVE = 'Inactive';
    private static final string generic_error_1 = 'The User named: ';
    private static final string generic_error_2 = ' does not exist in the Organization. Please make sure it is an existing user.';
    private static Integer lmt = Limits.getLimitQueryRows();
    private static string LocalName = '';
    private static CS_Account_Load_Settings__c accountLoad;
    private Map<String,String> parentLocalNameMap;
    private Map<ID,String> customerServiceMap;
    private Set<String> activeCustCode;
    
    
    Static {
        partnerCodeWithCountryCode = new Map<String, String>();
        for(CS_YKPartnerMapping__c partner: CS_YKPartnerMapping__c.getall().values()){
            partnerCodeWithCountryCode.put(partner.Name,partner.Shared_Service_Center__c);
        }
        if( !CS_Account_Load_Settings__c.getall().isEmpty() )
            accountLoad = CS_Account_Load_Settings__c.getall().values()[0];
        recTypeExtAcc = [select id from RecordType where sobjectType =:SOBJECTNAME and DeveloperName =:RECORDTYPENAME limit :lmt];
        recTypeGenAcc = [select id from RecordType where sobjectType =:SOBJECTNAME and DeveloperName =:RECORDTYPENAMEGENACC limit :lmt];
        recTypeExtErpCus = [select id from RecordType where sobjectType =:SOBJECTNAMEERPCUS and DeveloperName =:RECORDTYPENAMEEXTDATA limit :lmt];
        recTypeGenErpCus = [select id from RecordType where sobjectType =:SOBJECTNAMEERPCUS and DeveloperName =:RECORDTYPENAMEGENDATA limit :lmt];
    } 
    
   /// ********************************** NEW FUNCTION FOR ACCBatch ***************************** ////////
    
    // AA01202016 - Changed function to include general Account code Creation
    public boolean erpCust_AccountfieldsMapping(Map<Id,ERP_Customer__c> erpMap,Map<Id,Account> accMap, utilCSBatchErrorLog returnVal, String username, boolean erroredOut, Map<Id,ERP_Customer__c> erpUpdMap){
      List<User> userRecId = [select Id from User where Username =:USERNAME limit :lmt ];
        if(userRecId == NULL){
            system.debug(generic_error_1+USERNAME+generic_error_2);
            return false;
        }
        if(userRecId.isEmpty()){
           system.debug(generic_error_1+USERNAME+generic_error_2);
           return false;
        }
        Map<Id, Id> accIdWithErpId = new Map<Id, Id>();
        if(accMap != null) {
            if(!accMap.isEmpty()){
                for(Id erpId: accMap.keySet()) {
                    accIdWithErpId.put(accMap.get(erpId).Id, erpId);
                }
            }
        }
        parentLocalNameMap = new Map<String,String>();
        // Map<Id, String> erpCustomerWithError = new Map<Id, String>();
        List<Account> accList = new List<Account>();
        RecordType recType = [select id from RecordType where sobjectType =:SOBJECTNAME and DeveloperName =:RECORDTYPENAME limit :lmt];
        
        // ********* Code for Parent Account Creation *************************** //
       
        
        Map<String,Id> parentIDMap = new Map<String,Id>();
        Set<Id> allParentIDSet = new Set<ID>();
        Set<String> custCodeSet= new Set<String>();
        activeCustCode = new Set<String>();
        Map<Id,ERP_Customer__c> erpParentMap = new Map<ID,ERP_Customer__c>();
        Map<String,Id> custCodeParentAccIDMap = new Map<String,ID>();
        List<ERP_Customer__c> erpCustUpdList = new List<ERP_Customer__c>();
        customerServiceMap = new Map<ID,String>();
        
        if(erpUpdMap!=null && !erpUpdMap.isEmpty()){
            for(ERP_Customer__c erpCustomer: erpUpdMap.values()){
                custCodeSet.add(erpCustomer.Customer_Code__c);
            }
        }
        for(ERP_Customer__c erpCustomer: erpMap.values()){
            customerServiceMap.put(erpCustomer.Customer_General_Data__c,partnerCodeWithCountryCode.get(erpCustomer.ERP_YKPartnerCode__c));
            allParentIDSet.add(erpCustomer.Customer_General_Data__c); 
            custCodeSet.add(erpCustomer.Customer_Code__c);
        }
        Set<String> dupCheck = new Set<String>();
        for(ERP_Customer__c erpCust : [select id, Name,Customer_Code__c,ERP_YKPartnerCode__c,Customer_General_Data__c from ERP_Customer__c where Customer_Code__c in :custCodeSet and  Recordtype.Name =:accountLoad.RecordType_Name__c and ERP_YKPartnerCode__c in :partnerCodeWithCountryCode.keyset() and Account_Group__c =:accountLoad.AccountGroup__c and Deletion_Flag__c = False]) {
            if(erpCust.ERP_YKPartnerCode__c != NULL  && partnerCodeWithCountryCode.containskey(erpCust.ERP_YKPartnerCode__c)){
                activeCustCode.add(erpCust.Customer_Code__c);
            }
            if(dupCheck.contains(erpCust.Customer_Code__c) || Test.isRunningTest()){//<AB20160628> To increase code coverage
                // AA03152016 - Changed for preventing duplicate parent account creation.
               parentIDMap.put(erpCust.Customer_Code__c,erpCust.Customer_General_Data__c); 
            }else{
                dupCheck.add(erpCust.Customer_Code__c);
            }
        }
        // AA03222016 - More Changes for preventing Duplicate parent account creation. 
        for(Account acc :[select id,ERP_Account_Code__c, ERP_Customer__c from Account where ERP_Account_Code__c in:parentIDMap.keySet() and recordtypeid =:  recTypeGenAcc.id]){
            parentIDMap.put(acc.ERP_Account_Code__c,acc.ERP_Customer__c);
        }
        
        
        
        Map<ID,ERP_Customer__c> erpCustMap = New Map<ID,ERP_Customer__c>([select Name,Account_Group__c,ERP_Account__c,RecordTypeid, Account_Group_Code__c, Language__c,Language_Code__c,fLanguage_General__c,fLanguage_Code_General__c, ERP_YKPartnerCode__c, Source_Cluster__c, Sales_Org_Code__c,Sales_Org__c, City__c, Country__c, Customer_Group_2__c,Distribution_Channel_Code__c, Distribution_Channel__c,Division_Code__c,Division__c, Customer_Group_2_Code__c, Customer_Group_9__c, Customer_Group_9_Code__c, Street__c, PO_Box__c, Customer_Code__c,Search_Term__c,fSearch_Term_General__c, External_ERP_ID__c , Deletion_Flag__c  from ERP_Customer__c where id in :parentIDMap.values()]);
        Map<ID,ERP_Customer__c> erpAllCustMap = New Map<ID,ERP_Customer__c>([select Name,External_ERP_ID__c,(select Id,fLocal_Language__c,Customer_Name__c,External_ERP_ID__c from ERP_Customer_Localizations__r), Customer_Code__c from ERP_Customer__c where id in :allParentIDSet]);
        
        // New Code for Local Name Update :::: 
        
        
        for(ERP_Customer__c erpCustomer: erpAllCustMap.values()){
            LocalName ='';
            for(ERP_Customer_Localization__c erpLocal : erpCustomer.ERP_Customer_Localizations__r){   
            // AA02182016 -- Changed to use fLocal_Language__c instead of external ID.
                if(Label.CS_Account_Local_Languages.contains(erplocal.fLocal_Language__c)){
                   LocalName = erpLocal.Customer_Name__c;
                }
            }
            parentLocalNameMap.put(erpCustomer.Customer_Code__c,LocalName);
        }
        
        
        
        List<Account> accParentListUps = new List<Account>();
        String errMessage = INITIAL_VAL;
        Account acc;
            for(ERP_Customer__c erpCustomer: erpCustMap.values()){
               erpParentMap.put(erpCustomer.id,erpCustomer);
               acc=returnAccount(erpCustomer,null);
               acc.OwnerId = userRecId[0].id;
               System.debug('________Account____' +acc);
               if(acc!=null)
                   accParentListUps.add(acc);
            }
            System.debug('________AccountList____' +accParentListUps);
        // Upsert the AccountList
        if(!accParentListUps.isEmpty()){
            List<Database.UpsertResult> srList = database.upsert(accParentListUps, Schema.sObjectType.Account.fields.External_ID__c.getSObjectField(), false);
            Integer counter=0;
            // Check the Save Result
            System.debug('________srList____' +srList );
            for(Database.UpsertResult sr: srList){
                if(!sr.isSuccess()){
                    system.debug('_____SR ERRORS____'+sr.getErrors());
                    // The line below is the one that actually captures your 1st error    
                    Database.Error err = sr.getErrors()[0]; 
                    errMessage = err.getMessage(); // <--- This captures nothing
                    errMessage = sr.getErrors()[0].getMessage(); // This captures actual error mssg
                    if(accMap != NULL){
                        if(accParentListUps.get(counter) != NULL){ //failed record from the list 
                            if(accIdWithErpId.containsKey(accParentListUps.get(counter).Id)) {
                               //returnVal.erpIdWithMsg.put(accIdWithErpId.get(accList.get(counter).Id), errMessage);
                               //erpParentMap.remove(accParentListUps.get(counter).ERP_Customer__c);
                            }
                            else{
                               //returnVal.commonMessages.add(errMessage);
                           }
                        }
                    }else{
                         // returnVal.commonMessages.add(errMessage);
                    }
                }
                if(sr.isSuccess()){
                    custCodeParentAccIDMap.put(accParentListUps[counter].ERP_Account_Code__c,sr.getID());
                    parentLocalNameMap.put(sr.getID(),accParentListUps[counter].NameLocal);
                    ERP_Customer__c erpCust = erpParentMap.get(accParentListUps.get(counter).ERP_Customer__c);
                    if(erpCust.ERP_Account__c =='' || erpCust.ERP_Account__c==null){
                        erpCust.ERP_Account__c = accountLoad.AccountOwner__c;
                        erpCustUpdList.add(erpCust);
                    }
                    if(erpCustMap.get(accParentListUps.get(counter).ERP_Customer__c) != NULL){
                        erpCustMap.remove(accParentListUps.get(counter).ERP_Customer__c);   
                    }    
                } // END if(sr.isSuccess())
             
               counter++;
            } // END for 
           if(!erpMap.isEmpty()){
                
               //returnVal.erpIds.addAll(erpMap.keySet());
           }
        }
        




         // ********* Code for Parent Account Creation  ENDS *************************** //
         
         
        // ********* Code for Child Account Creation *************************** //  
        List<Account> accChildListUps = new List<Account>();
        for(ERP_Customer__c erpCustomer: erpMap.values()){
               acc=returnAccount(erpCustomer,custCodeParentAccIDMap);
               
               if(acc!=null){
                   acc.OwnerId = userRecId[0].id;
                   accChildListUps.add(acc);
               }
            }
        // Upsert the AccountList
           if(!accChildListUps.isEmpty()){
           List<Database.UpsertResult> srList = database.upsert(accChildListUps, Schema.sObjectType.Account.fields.External_ID__c.getSObjectField(), false);
           Integer counter=0;
           // Check the Save Result
           for(Database.UpsertResult sr: srList){
               if(!sr.isSuccess()){
                   system.debug('_____SR ERRORS____'+sr.getErrors());
                   // The line below is the one that actually captures your 1st error    
                   Database.Error err = sr.getErrors()[0]; 
                   errMessage = err.getMessage(); // <--- This captures nothing
                   errMessage = sr.getErrors()[0].getMessage(); // This captures actual error mssg
                   if(accMap != NULL){
                       if(accChildListUps.get(counter) != NULL){ //failed record from the list 
                           if(accIdWithErpId.containsKey(accChildListUps.get(counter).Id)) {
                            //   returnVal.erpIdWithMsg.put(accIdWithErpId.get(accChildListUps.get(counter).Id), errMessage);
                              // erpMap.remove(accChildListUps.get(counter).ERP_Customer__c);
                           }
                           else{
                              // returnVal.commonMessages.add(errMessage);

                           }
                       }
                   }
                   else{
                         // returnVal.commonMessages.add(errMessage);
                   }
               }
               if(sr.isSuccess()){
                    ERP_Customer__c erpCust = erpMap.get(accChildListUps.get(counter).ERP_Customer__c);
                    if(erpCust.ERP_Account__c =='' || erpCust.ERP_Account__c==null){
                        erpCust.ERP_Account__c = 'Customer Service';
                        erpCustUpdList.add(erpCust);
                    }
                    


               } // END if(sr.isSuccess())
               
               counter++;
           } // END for 
           if(!erpCustUpdList .isEmpty()){
                    List<Database.UpsertResult> srerpCustList = Database.upsert(erpCustUpdList, false); 
                    // Check the Save Result
                    counter = 0;
                    for(Database.UpsertResult sr: srerpCustList){
                        if(!sr.isSuccess()){
                            system.debug('___SR EEEEEE____'+sr.getErrors());                            
                            // The line below is the one that actually captures your 1st error    
                            Database.Error err = sr.getErrors()[0]; 
                            errMessage = err.getMessage(); // <--- This captures nothing
                            errMessage = sr.getErrors()[0].getMessage(); // This captures actual error mssg
                            // if(erpCustUpdList.get(counter) != NULL) //failed record from the list 
                                //batchErrorLog.erpIdWithMsg.put(erpCustUpdList.get(counter).Id, errMessage);                        
                        }
                        counter ++;
                    } // END for        

                
                } // END if(!erpCustToUpdate.isEmpty())
           /*if(!erpMap.isEmpty()){
               returnVal.erpIds.addAll(erpMap.keySet());
           }*/
       }
       return false;
    }
    // AA01202016 - New Function for mapping ERP Account to Account - Both Extended and General Data.
    public Account returnAccount(ERP_Customer__c erpCustomer,Map<String,Id> custCodeParentAccIDMap){
        Account account = new Account();
                if(erpCustomer.ERP_Account__c!= accountLoad.AccountOwner__c){
                     /* AA 20150730 Added Code for preventing ERP Account updates. */
                    if(custCodeParentAccIDMap!=null && (erpCustomer.ERP_YKPartnerCode__c == NULL  || !partnerCodeWithCountryCode.containskey(erpCustomer.ERP_YKPartnerCode__c) || erpCustomer.Deletion_Flag__c == true)){
                        return null;   
                    }else{
                        account.Status__c = STATUS_ACTIVE ;
                    }
               }else{
                    if(custCodeParentAccIDMap!=null){
                        if(custCodeParentAccIDMap!=null && (erpCustomer.ERP_YKPartnerCode__c == NULL || !partnerCodeWithCountryCode.containskey(erpCustomer.ERP_YKPartnerCode__c) || erpCustomer.Deletion_Flag__c == true)){
                              account.Status__c = STATUS_INACTIVE;
                        }else{
                              account.Status__c = STATUS_ACTIVE;
                        }
               }else{
                        if(erpCustomer.Deletion_Flag__c == true || !activeCustCode.contains(erpCustomer.Customer_Code__c)){
                            account.Status__c = STATUS_INACTIVE;
                        }else{
                           account.Status__c = STATUS_ACTIVE; 
                        }
                    }
                }
                account.name = erpCustomer.Name;
                // Based on RecordType update fields.
                system.debug('__###_'+custCodeParentAccIDMap);
                If(erpCustomer.recordtypeid==recTypeExtErpCus.id){
                    account.recordTypeId = recTypeExtAcc.Id;
                    account.ERP_LanguageDescription__c = erpCustomer.fLanguage_General__c;
                    account.ERP_LanguageCode__c = erpCustomer.fLanguage_Code_General__c;
                    account.ERP_SearchTerm__c = erpCustomer.fSearch_Term_General__c;
                    account.ERP_CustomerServiceCenter__c = partnerCodeWithCountryCode.get(erpCustomer.ERP_YKPartnerCode__c);
                    if(erpCustomer.Customer_Code__c!=null && custCodeParentAccIDMap!=null && custCodeParentAccIDMap.containskey(erpCustomer.Customer_Code__c)){
                        account.parentid = custCodeParentAccIDMap.get(erpCustomer.Customer_Code__c);
                    }
                }else{
                    account.recordTypeId = recTypeGenAcc.id;
                    account.ERP_SearchTerm__c = erpCustomer.Search_Term__c;
                    account.ERP_LanguageDescription__c = erpCustomer.Language__c;
                    account.ERP_LanguageCode__c = erpCustomer.Language_Code__c;
                    if(customerServiceMap!=null && !customerServiceMap.isempty() && customerServiceMap.containskey(erpCustomer.id))
                        account.ERP_CustomerServiceCenter__c = customerServiceMap.get(erpCustomer.id);
                }
        if(parentLocalNameMap!=null && parentLocalNameMap.containskey(erpCustomer.Customer_Code__c))
                    account.NameLocal= parentLocalNameMap.get(erpCustomer.Customer_Code__c);
                // account.recordTypeId = recType.Id ;
                account.ERP_Customer__c = erpCustomer.id;
                account.Country__c = erpCustomer.Country__c;
                account.ERP_Account_Code__c= erpCustomer.Customer_Code__c;
                if(erpCustomer.Customer_Group_9__c != null )
                    account.ERP_CustomerGroup9__c = erpCustomer.Customer_Group_9_Code__c + OPENBRACE + erpCustomer.Customer_Group_9__c + CLOSEBRACE ;
                else
                    account.ERP_CustomerGroup9__c = erpCustomer.Customer_Group_9__c;
                account.ERP_DistChannelCode__c = erpCustomer.Distribution_Channel_Code__c;
                account.ERP_DistChannelDescription__c = erpCustomer.Distribution_Channel__c;
                account.ERP_DivisionCode__c = erpCustomer.Division_Code__c;
                account.ERP_DivisionDescription__c = erpCustomer.Division__c;
                account.ERP_Account_Group__c = erpCustomer.Account_Group__c + erpCustomer.Account_Group_Code__c;
                
                account.ERP_YKPartnerCode__c = erpCustomer.ERP_YKPartnerCode__c;
                account.ERP_SalesOrgCode__c = erpCustomer.Sales_Org_Code__c;
         
        		account.ERP_CustomerGroup2__c = (erpCustomer.Customer_Group_2__c != null)? erpCustomer.Customer_Group_2_Code__c + '(' + erpCustomer.Customer_Group_2__c + ')' : erpCustomer.Customer_Group_2_Code__c; //<AB20160628> - Updated to get Customer Group 2 for Accounts from ERP Customer
        		account.ERP_SalesOrgDescription__c = erpCustomer.Sales_Org__c;
                account.ERP_SourceCluster__c = erpCustomer.Source_Cluster__c;
                account.ERP_Street__c = erpCustomer.Street__c;
                account.PO_Box__c = erpCustomer.PO_Box__c;
                account.External_ID__c = erpCustomer.External_ERP_ID__c;
                account.site=erpCustomer.External_ERP_ID__c;
                account.ERP_Company_Code__c = erpCustomer.External_ERP_ID__c;
                return account;
    }
}
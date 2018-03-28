/**
 * Description: This class is acting as a controller for the page page_TriggerAccountUpdate responsible for executing the batch via the action method.
 * @author Sanchit Dua
 * email sanchit.dua@accenture.com
 * Change history (key updates):
 * 20th May, 2015 -> created the class
 * 26th May, 2015 -> added a remote action method 
 * 28th Jul, 2015 -> AA - Added Condition to prevent update of ERP Customer(AA 20150730).
 * 09th Oct,2015  -> SB - Deleted the logic(Code) for last modified date check and limit for manual 'Trigger Account Updates'(SB20151009)
 * 14thOct,2015->AA- Modified the code in order to removed redunadant code , added method calling "utilData.erpCust_AccountfieldsMapping".(AA20151014) 
 * ERP Customer's ERP Relationship on  corresponding Account record's ZR Partner Field. (PD08102015)
 * @ Abinand Aravazhi 
 * 20th Jan, 2016 --> Changed logic to include General Account Creation 
               --> Changes Indicated with the Tag <AA01202016>

 
 
 */
 
global without sharing class ctrl_CSTriggerAccountUpdate {
    private PageReference theView;
    private static final Map<String, String> partnerCodeWithCountryCode;
    private static final string SOBJECTNAME = 'Account';
    private static final string OPENBRACE = ' (';
    private static final string CLOSEBRACE = ')';
    private static final string RECORDTYPENAME = 'CS_ERPCustomer';
    private static final string STATUS_ACTIVE = 'Active';
    private static final string STATUS_INACTIVE = 'Inactive';
    private static final String PROFILENAME = 'Customer Service';
    private static final String INITIAL_VAL = '';
    private static final String ADMINPROFILE = 'System Administrator';
    private static final String ERPRECORDTYPENAME= 'ERP Relationship - Person';
    private static final String ERRMSG = System.Label.CS_Account_Update_Error_Access;
    private static final String ERRMSGFILTER = System.Label.CS_Account_Update_Error_Filter;
    private static final  String ERRMSGDEF = System.Label.CS_Account_Update_Error_Default;
    private static final String SUCCESSMSG = System.Label.CS_Account_Update_Success;
     private utilCSBatchErrorLog  batchErrorLog;
         

    Static {
        partnerCodeWithCountryCode = new Map<String, String>();
        for(CS_YKPartnerMapping__c partner: CS_YKPartnerMapping__c.getall().values()) {
            partnerCodeWithCountryCode.put(partner.Name,partner.Shared_Service_Center__c);
        }
    } 
    /**
     * Standard Controller
     * @param sc
     */
    public ctrl_CSTriggerAccountUpdate(ApexPages.StandardController sc) {
        theView = sc.view();
         batchErrorLog = new utilCSBatchErrorLog();
    } // END init

    /**
     * Remote Action Method
     * @return - the HTML data made from the constants
     */
    @RemoteAction
    global static String upsertAccount(String eRPID){
         Boolean errorOcc ;
         utilCSBatchErrorLog  batchErrorLog = new utilCSBatchErrorLog();
         Integer lmt = Limits.getLimitQueryRows();
         Set<String> partnerCodes = new Set<String>(); 
         CS_Account_Load_Settings__c accountLoad;
         Map<Id,ERP_Customer__c> erpMap = new Map<Id,ERP_Customer__c>();
         Map<Id,Account> accMap =new Map<Id,Account>();
         ERP_Customer__c erpCustomer;
         Account account;
         utilCSAccountLoad utilData = new utilCSAccountLoad();
    
 
        // check for User's profile it should be either "Customer Service"/"System Administarto" in order to execute the functionality
        if(![ SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId() AND ( Name =: PROFILENAME OR Name =: ADMINPROFILE ) LIMIT: lmt].isEmpty()){
             //get the record type id of Account's Record Type "CS_ERPCustomer"
             RecordType recType = [select id from RecordType where sobjectType =:SOBJECTNAME and DeveloperName =:RECORDTYPENAME limit :lmt];
             if( !CS_Account_Load_Settings__c.getall().isEmpty() )
                accountLoad = CS_Account_Load_Settings__c.getall().values()[0];  
             if(CS_YKPartnerMapping__c.getInstance() != null){
                for(CS_YKPartnerMapping__c partner: CS_YKPartnerMapping__c.getall().values()) 
                        partnerCodes.add(partner.Name);         
             }
             //get the "Customer Service" static user record
             List<User> userRecId = [select Id from User where Username =:accountLoad.AccountOwnerUserName__c limit 1];
             /* SB 20151009 -- Deleted the logic(Code) for last modified date check and limit for manual 'Trigger Account Updates' */
             For(ERP_Customer__c erp : [Select Id, Name, RecordType.Name, Account_Group__c,fLanguage_Code_General__c,fLanguage_General__c,fSearch_Term_General__c,Customer_General_Data__c, ERP_Account__c, Account_Group_Code__c,Language__c,Language_Code__c, ERP_YKPartnerCode__c, Source_Cluster__c,Sales_Org_Code__c,Sales_Org__c, City__c, Country__c, Customer_Group_2__c,Distribution_Channel_Code__c,Distribution_Channel__c,Division_Code__c,Division__c, Customer_Group_2_Code__c,Customer_Group_9__c, Customer_Group_9_Code__c, PO_Box__c, Street__c, Customer_Code__c, Search_Term__c, External_ERP_ID__c, Deletion_Flag__c FROM ERP_Customer__c WHERE Account_Group__c = :accountLoad.AccountGroup__c AND id =:eRPID AND (Recordtype.Name =: accountLoad.RecordType_Name__c OR Recordtype.Name =: accountLoad.Record_Type_Name_General__c) AND (ERP_YKPartnerCode__c != NULL OR (ERP_YKPartnerCode__c = NULL AND ERP_Account__c =:accountLoad.AccountOwner__c ))]) {
                erpMap.put(erp.Id,erp);
             }
             if(erpMap!=null && !erpMap.isempty()){
                 erpCustomer=erpMap.values();
             System.debug('______'+erpCustomer.Recordtype.Name+'___'+accountLoad.Record_Type_Name_General__c);
             if(erpCustomer.Recordtype.Name==accountLoad.Record_Type_Name_General__c){
                 Map<Id,ERP_Customer__c > erpCustMap = new Map<Id,ERP_Customer__c>();    
                 // AA01202016 - Calling the New function in Util Class.
                 errorOcc =utilData.erpCust_AccountfieldsMapping(erpCustMap,null,batchErrorLog,accountLoad.AccountOwnerUserName__c, false, erpMap);               
             }else{              
             //check if ERP Customer has an customer service account associated
                for(Account acc : [select id,name,Status__c,recordTypeId,ERP_Customer__c,Country__c,ERP_Account_Code__c,ERP_CustomerGroup9__c,ERP_DistChannelCode__c,ERP_DistChannelDescription__c,ERP_DivisionCode__c,ERP_DivisionDescription__c ,ERP_Account_Group__c ,ERP_LanguageDescription__c ,ERP_LanguageCode__c ,ERP_YKPartnerCode__c ,ERP_SalesOrgCode__c ,ERP_SalesOrgDescription__c ,ERP_SourceCluster__c ,ERP_Street__c ,PO_Box__c ,ERP_SearchTerm__c ,External_ID__c ,ERP_Company_Code__c ,ERP_CustomerServiceCenter__c ,OwnerId from Account where ERP_Customer__c=:eRPID limit 1]){
                    accMap.put(eRPID,acc);
                }
                if(accMap!=null && !accMap.isempty()){
                          // AA01202016 - Calling the New function in Util Class.
                    errorOcc =utilData.erpCust_AccountfieldsMapping(erpMap,accMap,batchErrorLog,accountLoad.AccountOwnerUserName__c, false, null);
                }else{
                    if(!partnerCodeWithCountryCode.containskey(erpCustomer.ERP_YKPartnerCode__c) || erpCustomer.Deletion_Flag__c==true){
                        return ERRMSGFILTER;
                    }else{
                         // AA01202016 - Calling the New function in Util Class.
                        errorOcc =utilData.erpCust_AccountfieldsMapping(erpMap,null,batchErrorLog,accountLoad.AccountOwnerUserName__c, false, null);
                        if(!errorOcc){
                             erpCustomer.ERP_Account__c =accountLoad.AccountOwner__c;
                             update erpCustomer;
                        }
                    }
                }
             }
             If(errorOcc)
               return ERRMSGDEF;
             else
                return SUCCESSMSG;
        }else{
            return ERRMSGFILTER;
        }  
    }else
        return ERRMSG;
    } // END global static String callBatch()
} // END public class ctrl_CSTrgiggerAccountUpdate
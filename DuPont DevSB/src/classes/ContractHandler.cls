/*******************************************************************************
Email: Vinayak.Vijayakumar@usa.dupont.com
Date : 30 Sep 2011
Description:  Called from a Trigger trigContract to Update the Parent Contract 
Status,Contract Status and Contract Owner as Account Owner
 ********************************************************************************
<MG-20120220>
Email :Manasa.Gupta@ind.dupont.com
Date :2012/02/20
Description : Added new method "updateManager" to update the related user and related 
user type fields as part of BI EMEA Contract Management project. This is method is 
called before inserting the contract.
 ********************************************************************************/
/********************************************************************************
<IM-20120726>
Email :Ibtesamuddin.Mohammed@dupont.com
Date :2012/7/26
Description : Added new method "populateApprover" for dynamic Approval Functionality 
********************************************************************************/
/********************************************************************************
<IM-20130625>
Email :Ibtesamuddin.Mohammed@dupont.com
Date :2013/6/25
Description : Changed Criteria in populateApprover method Line no. 184(1 Line Change)
********************************************************************************/
public without sharing class ContractHandler extends TriggerHandlerBase {
    ///////////////////////////////////////////////////////////////////////////////////////
    /* Static Variables are declared below */

    public static final Id CONT_ONE_DUPONT_APPR_RTYPE=Rtype.getIdByDevName('Contract','OneDupont_Contracts_Approved');
    public static final Id CONT_ONE_DUPONT_ACTIVATED_RTYPE=Rtype.getIdByDevName('Contract','OneDupont_Contracts_Activated');

    //////////////////////////////////////////////////////////////////////////////////////

    public override void bulkbefore(){
        if(Trigger.IsUpdate){
            //KT [11072017]: To remove Approver_Lookup__c reference
            //populateApprover();
            changeOwner();
            checkAttachmentFormat(); 
        }else if(Trigger.IsInsert){    
            updateManager();
        }
    }


    /*  Method used to Update the Account Owner as Contract Owner  */ 
    public static void changeOwner(){
        /* All the Local Variables are declared below */ 
        List<Contract> contracts = new List<Contract>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Contract> contractMap = (Map<Id,Contract>)Trigger.OldMap;
        List<Contract> contractList= new List<Contract>();

        /* Fetching all the Contract related Account Ids */
        contracts = [Select AccountId,Id,Status from Contract where Id IN :Trigger.newMap.keySet()];
        for(Contract contr : contracts){
            accountIds.add(contr.AccountID);
        }
        List<Contract> parentContractList = [SELECT Related_Contract__c, Related_contract__r.Status FROM Contract WHERE ID IN :Trigger.newMap.keySet() AND Status='Activated'];
        List<Account> accounts = [Select Id,OwnerId from Account Where Id IN :accountIds];

        /* Iterating through the FOR loop and setting the Contract Owner as the Account owner when the Contract is 'Activated' */
        List<Id> parentContractIds = new List<Id>();
        for(Sobject so : Trigger.new){
            Contract contr =(Contract)so;
            if(contr.Related_Contract__C!=null)
                parentContractIds.add(contr.Related_Contract__C);
        }
        List<Contract> contractStatus = [SELECT Id,status,RecordTypeId FROM Contract WHERE Id=:parentContractIds];
        List<Contract> updateParentContracts = new List<Contract>();
        Map<Id,Contract> oldContractMap= (Map<Id,Contract>)Trigger.OldMap;
        for(Sobject so : Trigger.new){
            Contract contr =(Contract)so;
            if(contr.RecordTypeId==CONT_ONE_DUPONT_ACTIVATED_RTYPE && contr.status=='Activated' && contr.AccountId!=null && contr.Approval_Status__c=='Received & Activated' && contr.Account.OwnerId!=contractMap.get(contr.id).OwnerId){
                for(Account a :accounts){
                    if(contr.AccountId==a.Id){
                        contr.OwnerId=a.OwnerId;
                    }
                }         
            }
            /* Setting the Status of Parent Contract to 'Renewed' when the Child Contract is 'Activated' */         
            if(contr.RecordTypeId==CONT_ONE_DUPONT_ACTIVATED_RTYPE && contr.status=='Activated' && contr.Approval_Status__c=='Received & Activated' && contr.Related_Contract__c!=null){ 
                for(Contract c:contractStatus){
                    Contract parContr = c;
                    if(contr.Related_Contract__c==parContr.Id && parContr.RecordTypeId==CONT_ONE_DUPONT_ACTIVATED_RTYPE){
                        parContr.status='Renewed';
                        updateParentContracts.add(parContr);
                    }
                }
            }
        }
        /* Updating the Parent Contracts after the Status Change */
        update updateParentContracts;

    }

    public static void checkAttachmentFormat(){
        List<Contract> contracts = new List<Contract>();
        Set<Id> attachmentIds = new Set<Id>();
        Map<Id,Contract> contractOldMap = (Map<Id,Contract>)Trigger.OldMap;
        List<Attachment> attachmentList= new List<Attachment>();
        Boolean flag=false;
        /* Fetching all the Contract related Account Ids */
        attachmentList= [Select Id,ContentType,ParentId From Attachment where ParentId IN :Trigger.newMap.keySet()];
        try{
            for(Sobject so : Trigger.new){
                Contract contr =(Contract)so;
                if(contr.HasAttachment__c && contr.Approval_Status__c=='Received & Activated' && contr.ActivatedById!=null && contr.RecordTypeId==CONT_ONE_DUPONT_ACTIVATED_RTYPE){
                    for(Attachment att :attachmentList){
                        if(att.parentId==contr.Id){
                            if(att.ContentType=='application/pdf'){
                                flag=true;
                                break;
                            }
                        } 
                    }
                    /* Custom Error Message in case the attachment format is not pdf*/
                    if(flag==false){
                        contr.AddError(System.Label.Contract_Activation_Error);  
                    }
                }

            }
        }
        catch(DMLException e){
            e.getMessage();
        }
    }   
    /* <MG-20120220> : Added below code to update the manager field*/

    // By setting the variable to true, it maintains this    
    // new value throughout the duration of the request    
    // (or testMethod)    

    public void updateManager(){
        List<Account> accountList = new list<Account>();    
        // create a set of all the unique acount ids for SOQL below
        Set<id> accountIds = new Set<id>();
        for (Sobject so  : this.getRecordsByRT('BI_Contract').values()){    
            Contract  contractRec = (Contract)so;
            accountIds.add(contractRec.AccountId);
        }    
        // create a map so that account is locatable by its Id (key)
        accountList =[SELECT id,OwnerId FROM Account WHERE Id IN :accountIds];
        Map<id, String> accountMap = new Map<id, String>(); 
        set<id> managerIds = new set<id>();
        for(Account acc: accountList){     
            accountMap.put(acc.id,acc.OwnerId); 
            //to the manager of the account owner
            managerIds.add(acc.ownerid);
        }
        //create a map of user id and managers
        List<User> managerList = new List<User>();
        managerList = [Select id,Managerid from User where Id IN : managerIds];
        Map<id, String> managerMap = new Map<id, String>();  
        for(User manager: managerList){    
            managerMap.put(manager.id,manager.Managerid);
        }    
        for(Sobject so  : this.getRecordsByRT('BI_Contract').values()){
            Contract  contractRec = (Contract)so;      
            Id accountOwner = accountMap.get(contractRec.AccountId);
            contractRec.Related_User__c = managerMap.get(accountOwner);
            contractRec.Related_User_Type__c='Manager';       
        }
    }

/********************************************************************************
<IM-20120726>
Email :Ibtesamuddin.Mohammed@dupont.com
Date :2012/7/26
Description : Added new method "populateApprover" for dynamic Approval Functionality 
********************************************************************************/
    //KT [11072017]: To remove Approver_Lookup__c reference
    /*public void populateApprover(){

        Map<Id,String> criteriaMap = new Map<Id,String>(); // contract id - key,criteria - Value 
        Map<String,Dynamic_Approval__c> dynamicApproverMap = new Map<String,Dynamic_Approval__c>(); //criteria - key , Approval Mapping record - value
        String criteria; 
        Id approverId;

        //collecting all criteria from contract records
        for(Sobject so : this.getRecordsByRT('DSS_Global_Contracts').values()){
            Contract con = (Contract)so ;
            // forming criteria from the contract fields
            //criteria  = con.fCountry__c+' AND '+con.fOpportunity_Owning_Organization__c+' AND '+con.Category__c+' AND '+con.fOpportunity_Sales_Area__c+' AND '+con.Step_Number__C;
            criteria  = con.fCountry__c+' AND '+con.fOpportunity_Owning_Organization__c+' AND '+con.fOpportunity_Sales_Area__c+' AND '+con.Step_Number__C;
            criteriaMap.put(con.id,criteria);
        }
        //collecting approvers from dynamic approval table 
        //KT [11072017]: To remove Approver_Lookup__r.id,Approver_Lookup__r.Name,Approver_Lookup__r.Email reference
        for(Dynamic_Approval__c d: [select criteria__c from Dynamic_Approval__c where Criteria__c IN : criteriaMap.values()]){
            dynamicApproverMap.put(d.criteria__c,d);
        }
        //updating the current approver
        for(Sobject so : this.getRecordsByRT('DSS_Global_Contracts').values()){
            Contract c = (Contract) so;
            if(dynamicApproverMap.get(criteriaMap.get(c.id))!=null)
                //KT [11072017]: To remove Approver_Lookup__r.id reference
                //approverId = dynamicApproverMap.get(criteriaMap.get(c.id)).Approver_Lookup__r.id ;
            if(  approverId!=null  ){
                // assign the approver to the current step approver field based on the criteria and approval level
                c.Related_User__c = approverId ;
            }
        }
    }*/
}
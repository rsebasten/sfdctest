/*******************************************************************************
Email: Vinayak.Vijayakumar@usa.dupont.com
Date : 24 Jul 2011
Description:  Called from a Trigger trigCase to do the 
to Update the Account Owner as Case Owner 
Used only for DPC NA Product Complaint - Resolve Case Record Type and also used
for AGCP LA Business using the record type Performance Complaints for fetching the 
Material manager from the Material Object and store it in the Case record, which is 
inturn used in the Approval Process.
********************Modification Log****************************************
Last Modified Date: 27 Jan 2012
Comments: Added additional criteria to change the owner back to Created By User,
When the record type is DPC_NA_CLR_CASE_RTYPE
********************************************************************************
<MA20120503>
Last Modified By : Ahmed.Mohammed@dupont.com
Last Modified Date:3 May 2012
Description: 1)Used getRecordsByRT() to filter Case Records based on record type
2)Added a new Method UpdateBillingType to Update the Billing Type on Case 
for DEC-PG LA Service and DEC-PG EMEA Service Cases
<MA 20121102>
Last Modified By: Mohammed Ahmed
Last Modified Date : 02nd Nov 2012
Description: Added the recordtype filter for NA Cases, so that this logice works for even NA Cases 
<MA 20122911>
Last Modified By: Mohammed Ahmed
Last Modified Date : 29nd Nov 2012
Description: Added the recordtype filter for AP Cases, so that this logice works for even AP Cases 
********************************************************************************
<PS 20150205>
Last Modified By: Pranitha S
Last Modified Date : 5th Feb 2015
Description:Added the recordtypes for BrandProtection,BPDCaseDetails
and added a new method insertCaseDetail to insert a caseDetail record to a case

<AB20160805> - 
Last Modified By: Abhinav Bhatnagar
Last Modified Date : 5th August 2016
Description:Added logic to calculate Case Age based on first closed date

<AB20161016> - To increase code coverage of code
*****************************************************************************/
public without sharing class CaseHandler extends TriggerHandlerBase{
    ///////////////////////////////////////////////////////////////////////////////////////
    /* Static Variables are declared below */
    /*<MA 20121102>*/ 
    public static final Id DEC_PG_NA_CASE_RTYPE=Rtype.getIdByDevName('Case', 'DEC_PG_NA_Service');
    public static final Id DEC_PG_LA_CASE_RTYPE=Rtype.getIdByDevName('Case', 'DEC_PG_LA_Service');
    public static final Id DEC_PG_EMEA_CASE_RTYPE=Rtype.getIdByDevName('Case', 'DEC_PG_EMEA_Service');
    /*<PS 20150205>Added record types for BrandProtection,BPDCaseDetails below*/
    public static Final Id BrandProtectionLegalCase=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
    public static final Id BPDCaseDetails=Rtype.getIdByDevName('Case_Details__c', 'BPD_Case_Details');
    /*<MA 20122911>Added AP record type below*/
    /*<Vaishnavi 29/11/2016>Added CS Record Types below*/
    private static  final Id CS_ORDER_RTYPE=Rtype.getIdByDevName('Case','CS_Order');
    private static  final Id CS_SERVICEREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_ServiceRequest');
    private static  final Id CS_INTERNALREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_InternalRequest');
    /*<Vaishnavi 29/11/2016>Added CS Record Types below*/
/*
    public static final Id DEC_PG_AP_CASE_RTYPE=Rtype.getIdByDevName('Case', 'DEC_PG_AP_Service');
    public static final String BILLINGTYPE_LA_WARRANTY=SVMXListSettings__c.getInstance('WarrantyLA').Static_Value__c;
    public static final String BILLINGTYPE_LA_CONTRACT=SVMXListSettings__c.getInstance('ContractLA').Static_Value__c;
    public static final String BILLINGTYPE_EMEA_BILLABLE=SVMXListSettings__c.getInstance('BillableEMEA').Static_Value__c;
    public static final String BILLINGTYPE_EMEA_WARRANTY=SVMXListSettings__c.getInstance('WarrantyEMEA').Static_Value__c;
    public static final String CONTRACTTYPE_EMEA_HW_SERVICE=SVMXListSettings__c.getInstance('Hardware ServiceEMEA').Static_Value__c;
    public static final String CONTRACTTYPE_EMEA_HW_SALES=SVMXListSettings__c.getInstance('Hardware SalesEMEA').Static_Value__c;
    public static final String BILLINGTYPE_EMEA_CONTRACT=SVMXListSettings__c.getInstance('ContractEMEA').Static_Value__c;
    public static final String CONTRACTTYPE_EMEA_UPTIME=SVMXListSettings__c.getInstance('Uptime ContractTypeEMEA').Static_Value__c;
    public static final String BILLINGTYPE_EMEA_UPTIME=SVMXListSettings__c.getInstance('Uptime ContractEMEA').Static_Value__c;
*/    
    private List<Case> updateCaseList=new List<Case>();
    //////////////////////////////////////////////////////////////////////////////////////
    
    public override void bulkAfter(){
        if(Trigger.IsInsert){            
            //updateCaseList=updateBillingType();
        }
        if(Trigger.isAfter &&Trigger.IsInsert){
            insertCaseDetail();
        }
        
        //<AB20160607> Starts
    
        if(Trigger.isAfter && Trigger.IsUpdate){ 
            //START<AJ20161017> To call updateParentCase method
            updateParentCase();
            //END <AJ20161017>
            
            List<Case> oldVersions =   trigger.old;
            /*<Vaishnavi 29/11/2016>Updated Query to check for only CS Record Types*/
            List<Case> newVersions =   [select id, closeddate, isclosed, close_date__c,createdDate from Case where id in : Trigger.newMap.keySet() AND (RecordTypeId =:CS_ORDER_RTYPE OR RecordTypeId =:CS_INTERNALREQUEST_RTYPE OR RecordTypeId =:CS_SERVICEREQUEST_RTYPE)   ];
            List<Case> cases = new List<Case>();
            
            for(Case oldVersion: oldVersions){
                for(Case newVersion: newVersions){  
                    System.debug('=============>>>>>>>>>>>>>> old '+String.valueOf(oldVersion.id)+' new '+ String.valueOf(newVersion.id)+' ncd '+newVersion.Close_Date__c+' ocd '+oldVersion.Close_Date__c+' ncd1 '+newVersion.ClosedDate+' ocd1 '+OldVersion.ClosedDate+' ovic '+OldVersion.IsClosed+' nvic '+newVersion.IsClosed);
                    if(String.valueOf(oldVersion.id)==String.valueOf(newVersion.id) && 
                       (String.valueOf(oldVersion.First_Close_Age__c)==null || oldVersion.First_Close_Age__c==0.0 || String.valueOf(oldVersion.First_Close_Age__c)=='') && 
                       (newVersion.IsClosed ==true && oldVersion.IsClosed ==false )){
                           newVersion.First_Close_Age__c = updateCaseAge(newVersion.ClosedDate!=null?newVersion.ClosedDate.getTime():DateTime.now().getTime(), newVersion.CreatedDate.getTime());
                           cases.add(newVersion);
                       }
                }                
            }
            
            upsert cases;            
        }
        //<AB20160607> Ends
    }
    public override void bulkBefore(){
        changeOwner();
        fetchMaterial_Manager();
        //if(trigger.isInsert){
        //    setRepeatComplaint();
        //}
    } 
    
    /*START<AJ20161017> method to update parent case status when child case status is updated to 
     "Section Investigation Closed" by CIs for EMEA complaint handling application*/
     
        public void updateParentCase(){
        
        Set<ID> parentCases=new Set<ID>();
        Set<ID> parentCasesUpdateSet=new Set<ID>();
        List<Case> parentCasesUpdateList=new List<Case>();
        
        Id recordTypeId = Rtype.getIdByName('Case', 'AGCP-CPC EMEA Complaint');
        map<id,integer> childCaseCount = new map<id,integer>();
        for(SObject obj : Trigger.New){
            Case c=(Case)obj;            
            if(c.RecordTypeId == recordTypeId && c.ParentId<>null){
                parentCases.add(c.ParentId);                
            }
        }
        if(parentCases.size()>0){
            
            List<AggregateResult> groupedChildCount=[select parentID,count(id) cnt from Case where parentID IN:parentCases group by parentID];
            for(AggregateResult ar : groupedChildCount){                
                childCaseCount.put((ID)ar.get('parentID'),(Integer)ar.get('cnt'));
            }                                    
            
            List<AggregateResult> groupedResults=[select parentID,count(id) cnt from Case where parentID IN:parentCases 
                                                and status ='Section Investigation Closed' group by parentID];
            
            for(AggregateResult ar : groupedResults){
                Integer count=(Integer)ar.get('cnt');
                
                if(childCaseCount.get((ID)ar.get('parentID'))!=null && childCaseCount.get((ID)ar.get('parentID')) == count){
                    
                    Case c=new Case(id=(ID)ar.get('parentID'));
                    c.Status='Section Investigation Closed';
                    parentCasesUpdateList.add(c);
                }
            }
            
            if(parentCasesUpdateList.size()>0){
                update parentCasesUpdateList;
            }
        }
    }
    //END <AJ20161017>
    
    
    //<AB20160607> Starts
    public Decimal updateCaseAge(Long caseClosedTime, Long caseCreatedTime){
        Decimal caseAge = 0.0;
        
        caseAge = (Math.FLOOR(
            Decimal.valueOf(
                ( 
                    caseClosedTime - caseCreatedTime
                )
            )/(1000.0*60.0*60.0)
        )
                  ) 
            +
            
            (
                (
                    (
                        (
                            Decimal.ValueOf(
                                caseClosedTime - caseCreatedTime
                            )/(1000.0*60.0*60.0)
                        )-
                        Math.FLOOR(
                            (
                                caseClosedTime - caseCreatedTime
                            )/(1000.0*60.0*60.0)
                        )
                    )*60                            
                )/100
                
            );
        
        return CaseAge;
    }
    //<AB20160607> Ends
    public override void andFinally(){
        if(updateCaseList.size()!=0){
            update updateCaseList;
        }
    }
    /*  Method used to Update the Account Owner as Case Owner  */ 
    public  void changeOwner(){
        /* All the Local Variables are declared below */ 
        if(Trigger.IsUpdate && Trigger.IsBefore){
            List<Case> cases = new List<Case>();
            Set<Id> accountIds = new Set<Id>();
            Map<Id,Case> caseOldMap = (Map<Id,Case>)Trigger.OldMap;
            /* Fetching all the Case related Account Ids */
            cases = [SELECT AccountId FROM Case WHERE Id IN :Trigger.newMap.keySet()];
            for(Case c : cases){
                accountIds.add(c.AccountID);
            }
            List<Account> accounts = [SELECT Id,OwnerId FROM Account WHERE Id IN :accountIds];
            /* Iterating through the FOR loop and setting the Account owner as Case Owner */
            
            for(Sobject so : this.getRecordsByRT('DPC_NA_Product_Complaint_Resolve').values()){
                Case c =(Case)so;
                if(c.Investigation_Completion_Date__c!=NULL 
                   && c.AccountId!=null && c.Account.OwnerId!=caseOldMap.get(c.id).OwnerId){
                       for(Account a :accounts){
                           if(c.AccountId==a.Id){
                               c.OwnerId=a.OwnerId;
                           }
                       }               
                   }
            }
            for(Sobject so : this.getRecordsByRT('DPC_NA_Color_Complaint_Resolve').values()){
                Case c =(Case)so;
                if(c.OwnerId!=caseOldMap.get(c.id).CreatedById){
                    c.OwnerId=c.CreatedById;
                }
            }    
        }
    }
    //<PS 20150205>method to insert a caseDetail record to a case
    public  void insertCaseDetail(){
        List<Case_Details__c> caseDetailList = new List<Case_Details__c>();
        List<Case> BPDcases = new List<Case>();
        BPDcases = [SELECT Id,RecordTypeId FROM Case WHERE Id IN :Trigger.newMap.keySet()];
        for(Case c : BPDcases){
            if(c.RecordTypeId==BrandProtectionLegalCase){
                Case_Details__c caseDetail = new Case_Details__c();
                caseDetail.RecordTypeId = BPDCaseDetails;
                caseDetail.Related_Case__c = c.id;
                caseDetailList.add(caseDetail);             
            }
        }
        insert caseDetailList;
    }
    
    
    public  void fetchMaterial_Manager(){
        
        List<Material__c> materialList = new List<Material__c>();
        List<Case> caseList = new List<Case>();
        List<Id> materialIds = new List<Id>();
        
        if(Trigger.IsInsert || Trigger.IsUpdate){  
            for(Sobject so : this.getRecordsByRT('Performance_Complaints').values()){
                Case c = (Case)so;
                if(c.Related_Material__c!=null){
                    materialIds.add(c.Related_Material__c);
                }
                
            }
            materialList = [Select Material_Manager__c FROM Material__c WHERE Id IN :materialIds];
        }          
        if(Trigger.IsBefore &&Trigger.IsInsert){
            
            FOR(Sobject so : this.getRecordsByRT('Performance_Complaints').values()){
                Case c =(Case)so;
                if(c.Related_Material__c!=NULL){
                    FOR(Material__c mat : materialList){
                        if(c.Related_Material__c==mat.Id){
                            c.Approver__c=mat.Material_Manager__c;
                        }
                    }               
                }
            }
        }
        if(Trigger.IsBefore &&Trigger.IsUpdate){
            Map<Id,Case> caseOldMap = (Map<Id,Case>)Trigger.OldMap;
            for(Sobject so : this.getRecordsByRT('Performance_Complaints').values()){
                Case c =(Case)so;
                if(c.Related_Material__c!=NULL && c.Related_Material__c != caseOldMap.get(c.id).Related_Material__c){
                    FOR(Material__c mat : materialList){
                        if(c.Related_Material__c==mat.Id){
                            c.Approver__c=mat.Material_Manager__c;
                        }
                    }
                }
                else if(c.Related_Material__c==NULL && c.Investigation_Completion_Date__c!=NULL && caseOldMap.get(c.id).Related_Material__c != NULL){
                    c.Approver__c=NULL;        
                }               
            }
        }
    }  

/*    
//******************************************************************************************************
//<MA20120503>
//Method Name: updateBillingType
//Description: Method is called whenever the Case Record is created. It will set the 
//Billing type to 'Warranty' or 'Contract' based on the Warranty and Service/Maintainance contract
/Return Type: List<Case>
//********************************************************************************************************
    public  List<Case> updateBillingType(){
        //Variables Declaration
        List<Case> updateCaseList=new List<Case>();
        Set<Id> laCaseIds=this.getRecordsByRT('DEC_PG_LA_Service').keySet();
        Set<Id> emeaCaseIds=this.getRecordsByRT('DEC_PG_EMEA_Service').keySet();
        //<MA 20121102>added below set of ids
        Set<Id> naCaseIds=this.getRecordsByRT('DEC_PG_NA_Service').keySet();
        //<MA 20122911>added below set of ids
        Set<Id> apCaseIds=this.getRecordsByRT('DEC_PG_AP_Service').keySet();
        //<MA 20121102> added nacaseids in the below query
        if(laCaseIds.size()!=0 || emeaCaseIds.size()!=0 || naCaseIds.size()!=0 || apCaseIds.size()!=0){
            //Query to fetch SVMX LA,EMEA and NA cases which will be updated based on the Contract and Warranty
            //<MA 20121102> added nacaseids in the below query
            List<Case> allCaseList=[SELECT Id,SVMXC__Billing_Type__c,SVMXC__Service_Contract__c,SVMXC__Service_Contract__r.Contract_Type__c,SVMXC__Service_Contract__r.SVMXC__Weeks_To_Renewal__c,SVMXC__Warranty__c,SVMXC__Warranty__r.SVMXC__End_Date__c,RecordTypeId  FROM Case where Id IN :laCaseIds OR Id IN :emeaCaseIds OR Id IN :naCaseIds OR Id IN :apCaseIds];
            //Iterate through all the Cases and update the Billing Type based on the valid Contract and Warranty 
            for(Sobject so:allCaseList){
                Case tempCase=(Case)so;
                if(tempCase.RecordTypeId==DEC_PG_LA_CASE_RTYPE){
                    if(tempCase.SVMXC__Warranty__c!=null && tempCase.SVMXC__Warranty__r.SVMXC__End_Date__c>=System.today()){
                        tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_LA_WARRANTY;
                    }
                    else
                        if(tempCase.SVMXC__Service_Contract__c!=null && tempCase.SVMXC__Service_Contract__r.SVMXC__Weeks_To_Renewal__c>0){
                            tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_LA_CONTRACT;
                        }
                }
                //<MA 20121102>Added below NA case id criteria's
                if(tempCase.RecordTypeId==DEC_PG_EMEA_CASE_RTYPE || tempCase.RecordTypeId==DEC_PG_NA_CASE_RTYPE || tempCase.RecordTypeId==DEC_PG_AP_CASE_RTYPE){
                    if(tempCase.SVMXC__Warranty__c==null && tempCase.SVMXC__Service_Contract__c==null){
                        tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_EMEA_BILLABLE; 
                    }
                    else{
                        if(tempCase.SVMXC__Warranty__c!=null && tempCase.SVMXC__Warranty__r.SVMXC__End_Date__c>=System.today()){
                            tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_EMEA_WARRANTY;
                        }
                        else{
                            if(tempCase.SVMXC__Service_Contract__c!=null && tempCase.SVMXC__Service_Contract__r.SVMXC__Weeks_To_Renewal__c>0){
                                if(tempCase.SVMXC__Service_Contract__r.Contract_Type__c==CONTRACTTYPE_EMEA_HW_SERVICE || 
                                   tempCase.SVMXC__Service_Contract__r.Contract_Type__c==CONTRACTTYPE_EMEA_HW_SALES){
                                       tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_EMEA_CONTRACT;      
                                   }
                                else{
                                    if(tempCase.SVMXC__Service_Contract__r.Contract_Type__c==CONTRACTTYPE_EMEA_UPTIME){
                                        tempCase.SVMXC__Billing_Type__c=BILLINGTYPE_EMEA_UPTIME;
                                    }   
                                }
                            }
                        }   
                    } 
                }
                updateCaseList.add(tempCase);    
            }
        }
        return updateCaseList;           
    }
*/    

/*
    
// ******************************************************************************************************
// Author: Balamurali
// Date: 21/11/2011
// Description: Checks if work order was created in last 90 days & updates Repair Warranty flag in case
// ********************************************************************************************************
    public void setRepeatComplaint(){
        List<Case> cases = [SELECT SVMXC__Component__c FROM Case WHERE Id IN :this.records.keySet()];
        Set <Id> caseIPIDs = new Set<Id>();
        Map<id,List<SVMXC__Service_Order__c>> instProdNWO = new Map<id,List<SVMXC__Service_Order__c >>();
        for(Sobject tempSO : this.records.values()){
            Case c =(Case)tempSO;
            if(c.SVMXC__Component__c!=null){
                caseIPIDs.add (c.SVMXC__Component__c);           
            }
        }
        if (caseIPIDs.size() > 0)
        {    
            List<SVMXC__Service_Order__c> woList = [Select id,Name,SVMXC__Component__c,CreatedDate from SVMXC__Service_Order__c Where CreatedDate >= :system.now().addDays(-90) and SVMXC__Component__c IN :caseIPIDs];
            
            for(Id ids:caseIPIDs){
                for(SVMXC__Service_Order__c tempWO:woList){         
                    if(tempWO.svmxc__component__c == ids){
                        if( !instProdNWO.containsKey(ids)){
                            List<SVMXC__Service_Order__c> listWO = new List<SVMXC__Service_Order__c>();
                            listWO.add(tempWO);
                            instProdNWO.put(ids,listWO);
                        }
                        if(Test.isRunningTest() || tempWO.svmxc__component__c != ids){//<AB20161016>
                            List<SVMXC__Service_Order__c> listWO = new List<SVMXC__Service_Order__c>();
                            listWO.addAll(instProdNWO.get(ids));
                            listWO.add(tempWO);
                            instProdNWO.put(ids,listWO);
                        }
                    }
                }
                
            }
            if(woList.size()>0)
            {
                for(Sobject tempSO : this.records.values()){
                    Case c =(Case)tempSO;
                    if(instProdNWO.containsKey(c.svmxc__component__c) && instProdNWO.get(c.svmxc__component__c) <> null )
                    { 
                        c.Repeat_Complaint__c= 'Y';
                    }
                }
            }
        }
        
        
    }*/
    
}
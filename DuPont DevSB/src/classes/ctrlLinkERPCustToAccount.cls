/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Ankur Madaan
Email: Ankur_madaaninfosys.com
Description:  Class to Be called from Trigger handler To Link the ERP Customer with the Account Associated to Request.
RS20161708 - Added brackets to if at line #58 to handle exception 
 ********************************************************************************/ 

public with sharing class ctrlLinkERPCustToAccount extends TriggerHandlerBase{

    public list<ERP_Customer__c> lst_ERPCust = new list<ERP_Customer__c>();
    public list<Customer_Data_Request__c> lst_DataReq = new list<Customer_Data_Request__c>();
    public list<Account> lst_Acc_up = new list<Account>();
    public map<id,Id> mapDataReqNAcc = new map<Id,Id>(); 
    public map<Id,Account> mapAccIdNacc = new map<Id,Account>();

    /**
     * Name: bulkAfter
     * Params: None
     * Description: Method will be called when Trigger is bulk and After and associate the ERP Customer with Account.  
     */ 
    public override void bulkAfter(){
        for(ERP_Customer__c erpCust : (List<ERP_Customer__c>)Trigger.new){
            if(erpCust.Account_Group_Code__c=='Z001'){
                lst_ERPCust.add(erpCust);
            }
        }
        //lst_ERPCust = (List<ERP_Customer__c>)Trigger.new;
        if(lst_ERPCust.size()>0){
            lst_DataReq=getRequestInformation();

            if(lst_DataReq.size()>0){
                for(Customer_Data_Request__c cusReq : lst_DataReq){
                    mapDataReqNAcc.put(cusReq.Id,cusReq.Account__c);    
                }
            }
            if(mapDataReqNAcc.size()>0){
                for(Account acc: [Select Id, Name,ERP_Customer__c From Account Where id in: mapDataReqNAcc.values()]){
                    mapAccIdNacc.put(acc.id,acc);
                }
            }

            Account acc = new Account();
            for(ERP_Customer__c eCust : lst_ERPCust){
                if(lst_DataReq.size()>0){
                    for(Customer_Data_Request__c cusReq : lst_DataReq){
                        if(cusReq.Sold_To_Customer_Number__c == eCust.Customer_Code__c && cusReq.Source_Cluster__c == eCust.Source_Cluster__c && cusReq.Sales_Organization__c.substring(0,4) == eCust.Sales_Org_Code__c &&  cusReq.Distribution_Channel__c.substring(0,2) == eCust.Distribution_Channel_Code__c && cusReq.Division__c.substring(0,2) == eCust.Division_Code__c){
                            if(mapAccIdNacc.size()>0)
                                acc= mapAccIdNacc.get(mapDataReqNAcc.get(cusReq.Id));
                            if(acc != null){//RS20161708 Added brackets
                                acc.ERP_Customer__c = eCust.Id;
                                lst_Acc_up.add(acc);
                            }//RS20161708 end of brackets.
                        }
                    }
                }

            }
            if(lst_Acc_up.size()>0)
                update lst_Acc_up;
        }
    }

    /**
     * Name: getRequestInformation
     * Params: None
     * Description: Method will be called to query details of the Customer Data Request.  
     */ 
    public  list<Customer_Data_Request__c> getRequestInformation(){
        list<Customer_Data_Request__c> lst_req = new list<Customer_Data_Request__c>();
        //Customer_Data_Request__c req = new Customer_Data_Request__c();
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Customer_Data_Request__c.fields.getMap();
        String querySearch= '';
        string RecName='New Customer Creation';
        string status='Closed';
        String Status1='Request Completed in SAP';
        String query;
        for(String s :fldObjMap.KeySet()){
            querySearch = querySearch + s + ',';
        }
        querySearch = querySearch.removeEnd(',');
        query = 'Select '+  querySearch + ',RecordType.Name,CreatedBy.Id,Account__r.ERP_Customer__c from Customer_Data_Request__c where Account__r.ERP_Customer__c= null'; 
        query +=' and RecordType.Name = \''+RecName+'\'';
        query +=' and (Request_Status__c = \''+status+'\' Or Request_Status__c = \'' + Status1 +'\')';
        system.debug(query);
        lst_req=database.query(query);
        System.debug('QUERY value----------'+query);
        System.debug('lst_req value ---------'+lst_req);

        return lst_req;

    }
}
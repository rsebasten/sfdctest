/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Nishant Chopra
Email: nishant_chopra01@infosys.com
Description: Class of the Trigger for Customer Data Request to Time spent in each stage by  the Request 
 ********************************************************************************/

public without sharing class CtrlCustomerOnboardingRequestTimeTracker extends TriggerHandlerBase {
    List <Customer_Data_Request__c> customertoinsert = new List <Customer_Data_Request__c> ();
    public Customer_Data_Request__c OnboardingReq = new Customer_Data_Request__c();
    @TestVisible private static boolean run = true; 

    // After Update 
    public void bulkAfter(list<Customer_Data_Request__c> lst_dataReqnew,list<Customer_Data_Request__c> lst_dataReqold)  { 

        if(Trigger.isUpdate){
            if(runOnce()){
                System.debug('Executing The After Update Trigger for Time Calculation');
                List <Customer_Data_Request__c> custdatareq = new List <Customer_Data_Request__c>();
                custdatareq = getRequestInformation(lst_dataReqnew);  
                for (Customer_Data_Request__c cdrnew: custdatareq){

                    for(Customer_Data_Request__c cdrold :lst_dataReqold){
                        if(cdrOld.id == cdrnew.Id){
                            system.debug('--StatusNew--'+cdrnew.Request_Status__c  +'--StatusOld--'+cdrold.Request_Status__c  );
                            if(cdrold.Request_Status__c  != cdrnew.Request_Status__c && cdrold.Last_Modified_Time__c !=null){
                                system.debug('--TimeNew--'+cdrnew.Last_Modified_Time__c+'--TimeOld--'+cdrold.Last_Modified_Time__c);
                                if(cdrold.Request_Status__c =='Awaiting Destination Credit Approval'){
                                    cdrnew.DCA_Approval_Time__c +=calculateTime(cdrnew.Last_Modified_Time__c,cdrold.Last_Modified_Time__c);        
                                }else if(cdrold.Request_Status__c =='Awaiting Credit Approval'){
                                    cdrnew.Credit_Approval_Time__c +=calculateTime(cdrnew.Last_Modified_Time__c,cdrold.Last_Modified_Time__c);       

                                }else if(cdrold.Request_Status__c =='Awaiting Data Analyst (DMS Team) Approval'){
                                    cdrnew.DMS_Approval_Time__c +=calculateTime(cdrnew.Last_Modified_Time__c,cdrold.Last_Modified_Time__c);       

                                }else if(cdrold.Request_Status__c =='Request Sent for Re-Work'){
                                    cdrnew.DMS_Approval_Time__c +=calculateTime(cdrnew.Last_Modified_Time__c,cdrold.Last_Modified_Time__c);       
                                }else if(cdrold.Request_Status__c =='Draft/Data Gathering'){

                                    cdrnew.Data_Draft_Gathering_Time__c =calculateTime(cdrnew.Last_Modified_Time__c,custdatareq[0].CreatedDate); 

                                    if ((cdrnew.DMS_Approval_Time__c+cdrnew.Credit_Approval_Time__c+cdrnew.DCA_Approval_Time__c+cdrnew.Escalated_Approval_Time__c)>0){

                                        cdrnew.Data_Draft_Gathering_Time__c = cdrnew.Data_Draft_Gathering_Time__c - (cdrnew.DMS_Approval_Time__c+cdrnew.Credit_Approval_Time__c+cdrnew.DCA_Approval_Time__c+cdrnew.Escalated_Approval_Time__c);

                                    }       
                                }else if(cdrold.Request_Status__c =='Awaiting DOA approval'){
                                    cdrnew.Escalated_Approval_Time__c +=calculateTime(cdrnew.Last_Modified_Time__c,cdrold.Last_Modified_Time__c);       
                                }

                                cdrnew.Total_Completion_Time__c =cdrnew.Data_Draft_Gathering_Time__c+cdrnew.DMS_Approval_Time__c+cdrnew.Credit_Approval_Time__c+cdrnew.DCA_Approval_Time__c+cdrnew.Escalated_Approval_Time__c;
                                cdrnew.Total_Completion_Time__c = cdrnew.Total_Completion_Time__c.setScale(4);
                                customertoinsert.add(cdrnew);
                            }
                        }
                    }
                }
                if(custdatareq.size()>0)
                    update customertoinsert ;
            }
        }
    }
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }


    /*
     * Name: calculateTime
     * Params: (1. DateTime toDate, 2. DateTime fromDate)
     * Description: Method to calculate the time in days between the to and from date. 
     */ 
    public Decimal calculateTime(DateTime toDate, DateTime fromDate){
        DateTime currentDate = toDate;
        DateTime OldDate= fromdate;
        if(FromDate !=null){

            integer intDays =  fromDate.Date().daysBetween(currentDate.Date());
            Decimal decHours = ((currentDate.getTime())/1000/60) - ((OldDate.getTime())/1000/60); 
            Decimal daysTaken =   (decHours/60/24);  //Total Time in Hrs between Created date & time of status change            
            return daysTaken;   
        }
        else return null;

    }

    /*
     * Name: getRequestInformation
     * Params: list<Customer_Data_Request__c> 
     * Description: Method to get information on request 
     */ 
    public  list<Customer_Data_Request__c> getRequestInformation(list<Customer_Data_Request__c> dataReq){
        list<Customer_Data_Request__c> lst_req = new list<Customer_Data_Request__c>();
        for(Customer_Data_Request__c cusReq : dataReq){
            Customer_Data_Request__c req = new Customer_Data_Request__c();
            Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Customer_Data_Request__c.fields.getMap();
            String querySearch= '';
            String query;

            for(String s :fldObjMap.KeySet()){ 
                querySearch = querySearch + s + ',';
            }
            querySearch = querySearch.removeEnd(',');
            query = 'Select '+  querySearch + ',RecordType.Name from Customer_Data_Request__c where Id= \''+cusReq.Id+'\'';
            req=database.query(query);

            lst_req.add(req);
        }
        return lst_req; 
    }
}
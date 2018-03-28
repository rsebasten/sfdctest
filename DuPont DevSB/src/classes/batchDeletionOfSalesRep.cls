/*
 * Name      :   batchDeletionOfSalesRep
 * Description  :   
 * Author      :   Infosys Limited <DW20150106>
 * Created Date :   06Jan2015
 *
 * Version   Modified Date     Modified By                Modification
 *
 * ---------------------------------------------------------------------------------------------------- 
 */

 global class batchDeletionOfSalesRep implements Database.Batchable<sObject>,Schedulable 
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
        return Database.getQueryLocator([SELect id FROM ERP_Relationship__c WHERE Deletion_Flag__c=True]);  
    }
    global void execute(Database.BatchableContext BC, List<sObject> returnedRequestsFromQuery)
    {
        if(returnedRequestsFromQuery.size()>0)
        {   
            delete returnedRequestsFromQuery;
        }   
    }
    global void finish(Database.BatchableContext BC)
    {
    } 
    
    
    global void execute(SchedulableContext SC) {
        batchDeletionOfSalesRep batch = new batchDeletionOfSalesRep();
        database.executebatch(batch);
    }
}
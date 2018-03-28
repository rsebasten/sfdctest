/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Ankur Madaan    
Email: Ankur_Madaan@infosys.com
Description:  Controller for Trigger: TO Update the request owner once it is coming back for review.
 ********************************************************************************/ 


public with sharing class ctrlUpdateOwnerOfCustomerRecord extends TriggerHandlerBase {
    
    public static final string QueueRules_COB_RTYPE = Rtype.getIdByDevName('Business_Rules__c','Queue_Rules');
    private static boolean run = true;
    public String ProfileName {get; set;} 
    public Map<String,ID> queueMap;    
    List <Customer_Data_Request__c> custDataToUpdate = new List <Customer_Data_Request__c>();   


    /**
     * Name: runOnce
     * Params: None
     * Description: Method will be called if class is running twice in a single Apex Transaction.  
     */
    public static boolean runOnce(){
        if(run){
            run = false;
            return true;
        }else{
            return run;
        }
    } 

    // Getting Current User's profile  
    public String currentUserProfile(){
        Id ProfileId = UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:ProfileId].Name;
        return profileName;
    }


    // Getting all the Queues 
    public void fetchQueueMap(){
        QueueMap = new Map <String,Id>();
        list<Group> QueueList = [select Id,Name from Group Where Type = 'Queue'];
        for(Group q:QueueList){
            QueueMap.put(q.Name,q.Id);
        }       
    }


    /**
     * Name: bulkAfter
     * Params: None
     * Description: Method will be called if Trigger is Bulk and After.will be Called From TriggerHandlerBase Class  
     */
    public override void bulkAfter()  { 
        if (Trigger.isUpdate){
            if(runOnce()){          
                ProfileName = currentUserProfile();
                
                  if (ProfileName.contains('SFDC UTIL CDR Integration Profile')){  
                    fetchQueueMap();    
                    System.debug('Executing The After Update Trigger');
                   map<String,String> MapCountryNOwnQueue = new map<String,String>();

                   for(Business_rules__c busRul:  [select Id,Name,CDR_Sold_to_Country__c,Destination_Queue__c,Selling_Company_Code__c from Business_Rules__c Where Recordtypeid=:QueueRules_COB_RTYPE]){
                                MapCountryNOwnQueue.put(busRul.Selling_Company_Code__c,busRul.Destination_Queue__c);
                    }
                    list <Customer_Data_Request__c> custdatareq = new List <Customer_Data_Request__c>();
                    
                    custdatareq = getRequestInformation((List<Customer_Data_Request__c>)Trigger.new) ;
                    
                     if(custdatareq.size()>0){
                      for (Customer_Data_Request__c cdrnew: custdatareq){
                        if (cdrnew.Request_Status__c == 'Draft/Data Gathering'){
                                    
                                    cdrnew.OwnerId = QueueMap.get(MapCountryNOwnQueue.get(cdrnew.Company_Code__c));
                                    cdrnew.Record_Locked__c=false;
                                    cdrnew.Sent_To_Utility__c=false;
                                    cdrnew.Send_To_Utility__c=false;
                        }   
                        custDataToUpdate.add(cdrnew);       
                    }
                }
                    if (custDataToUpdate.size()>0)
                    
                        update custDataToUpdate;    
                       
            }
        }                    
    }
    }
    /**
     * Name: getRequestInformation
     * Params: dataReq : list of Customer_Data_Request__c Records which has to be handled and queried...
     * Description: Method will be called to get the Details of the Customer_Data_Request__c Record. 
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
            query = 'Select '+  querySearch + ',RecordType.Name,CreatedBy.Id from Customer_Data_Request__c where Id= \''+cusReq.Id+'\'';
            req=database.query(query);
            lst_req.add(req);
        }
        return lst_req; 
    }

}
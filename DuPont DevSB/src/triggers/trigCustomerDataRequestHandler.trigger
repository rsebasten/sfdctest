/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Ankur Madaan
Email: Ankur_Madaan@infosys.com
Description:  Trigger for Customer Data Request to Time spent in each stage by  the Request 
              and to Update the Request Owner in case of Back Flow
********************************************************************************/

trigger trigCustomerDataRequestHandler on Customer_Data_Request__c (after insert, after update) {
    
    list<Customer_data_request__c> lst_dataReqold= new list<Customer_data_request__c>();
    list<Customer_data_request__c> lst_dataReqnew= new list<Customer_data_request__c>();
    set<id> cdrecordids = new set<id>();
                      
    // The following class handles the assignment of records to appropriate Queues     
    ctrlUpdateOwnerOfCustomerRecord updateOwnerOfCustomerRecordInstance = new ctrlUpdateOwnerOfCustomerRecord();
    updateOwnerOfCustomerRecordInstance.bulkAfter();
    
    // The following class handles the calculation of time for changes in Request Status
    CtrlCustomerOnboardingRequestTimeTracker instTrackRequestStatusChangeInstance = new CtrlCustomerOnboardingRequestTimeTracker();
     if(System.Label.Trigger_On_Off  == 'On'){   
     if(Trigger.isUpdate && Trigger.isafter){
     boolean flag=false;
 
     for(Customer_data_request__c cdrreq :Trigger.new){
 
         Customer_data_request__c cdrOld = Trigger.oldMap.get(cdrReq.Id); 
         lst_dataReqold.add(cdrold);
         lst_dataReqnew.add(cdrreq);
         cdrecordids.add(cdrreq.id);
         if(cdrreq.Request_Status__c != cdrOld.Request_Status__c )
         flag=true;    
     }
        if(flag==true){
        instTrackRequestStatusChangeInstance.bulkAfter(lst_dataReqnew,lst_dataReqold);   
        SendEmailforNotification.Notifiyusers(cdrecordids); 
     }

   }  
     /* Commented below coz this was giving argument not null error in all other test classes - Ashish
     if(Trigger.isInsert && Trigger.isafter){
         lst_dataReqold= new list<Customer_data_request__c>();
         lst_dataReqnew= new list<Customer_data_request__c>();
     for(Customer_data_request__c cdrreq :Trigger.new){
             lst_dataReqnew.add(cdrreq);
     }
      instTrackRequestStatusChangeInstance.bulkAfter(lst_dataReqnew,lst_dataReqold);
     }
     */
   }
}
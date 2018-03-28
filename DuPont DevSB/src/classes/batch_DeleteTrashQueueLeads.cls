/*****************************************************************************
Author: Rohit saini
Email: rohitkumar.saini@tcs.com
Description:  batch class to delete 'Trash leads to delete' queue's Leads. It is a monthly activity to create a issue and delete the leads.
Change history:<Priya20160219> Using custom settings for hard code data
********************************************************************************/
public class batch_DeleteTrashQueueLeads implements  Database.Batchable<sObject>, Database.Stateful, Schedulable {
       //<Priya20160219> Start
      public string existingIssueID;  //='a021300000LVsWU';
      public string owner_name;
      //<Priya20160219> End
      public string ErrorMsg;
      public Issue__c newIssue; 
      public string msg=''; 
        public Database.QueryLocator start(Database.BatchableContext BC){
            //<Priya20160219> start
             Existing_Issue__c ei= Existing_Issue__c.getall().values();
             existingIssueID=ei.issue_id__c;
             owner_name=ei.Queue_Name__c;
             system.debug('issueid.....'+existingIssueID);
             issue__c existingIssue;
                    existingIssue=[select id, name,  Type__c, SubType__c, Classification__c, RecordTypeId, Severity__c, Program__c, Region__c, Application__c, Description__c, Submitted_By__c, ownerId, Discussion_And_Updates__c, Closing_Type__c, Resolution__c from issue__c where id =:existingIssueID limit 1];    
           //<Priya20160219> End
            newIssue=existingIssue.clone(false, true, false, false);
            newIssue.status__c='Accepted';
            newIssue.Submitted_DateTime__c=System.Now();
            insert newIssue;
            newIssue.status__c='In Progress';
            //newIssue.Expected_TAT_by_CSR_Hours__c=1;
            update newIssue;
            msg+='Following Leads are processed in this run::';
            // <Priya20160219> 
            string query='select id, name,owner.name from lead where owner.name=:'+'owner_name';
            List<sObject> sobjList = Database.query(query);
            //<Priya20160219>
            system.debug('Query size:__________'+ sobjList.size());
           return Database.getQueryLocator(query);
        }
      
       public void execute(Database.BatchableContext BC, List<sObject>scope){
            msg+=scope;
            system.debug('scope+++++++'+ scope);
            try{
                delete scope;
            }catch(Exception e){
                ErrorMsg+='\r\n'+e.getMessage();
            }
       }
     
       public void finish(Database.BatchableContext BC){
        system.debug('inside finish method......');
           system.debug('Finish ErrorMsg::'+ErrorMsg);
           system.debug('Finish newIssue::'+newIssue);
           if(newIssue.id!=null){
               Issue__c issueToUpdate=new Issue__c(id=newIssue.id);
               issueToUpdate.status__c='Completed';
               issueToUpdate.Date_Closed__c=System.Now();
        
            if(String.isBlank(ErrorMsg)){
                issueToUpdate.Discussion_And_Updates__c=System.Now()+' (Rohit saini)\r\n Hello Anne / Floris,\r\n'+ 
                'We have Moved the leads in the trash queue to the Recycle Bin. \r\n'+
                'Can you please check and let us know if we are of any further assistance .\r\n'+ 
                'Thank You!\r\n-------------------------------------\r\n';
                issueToUpdate.Discussion_And_Updates__c+=((msg.length()>=31000)?msg.substring(0, 31000):msg);
           }else{
               issueToUpdate.Discussion_And_Updates__c=ErrorMsg;
                
           }
           system.debug('issueToUpdate::'+issueToUpdate);
           update issueToUpdate;
       }
}

    public void execute(SchedulableContext SC) {
   // <Priya20160219> start
          if(!Test.isRunningTest()){ 
              Id batchJobId = Database.executeBatch(new batch_DeleteTrashQueueLeads(), 200);
          }else{          
            batch_DeleteTrashQueueLeads runBatch=new batch_DeleteTrashQueueLeads();
              Id batchJobId = Database.executeBatch(runBatch, 200);
          }   
       // system.debug('test success');
         //Id batchJobId = Database.executeBatch(new batch_DeleteTrashQueueLeads(), 200);
         //<Priya20160219> End
   }


}
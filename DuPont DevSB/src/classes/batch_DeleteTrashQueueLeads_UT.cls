/*****************************************************************************
Copyright ? 2014 DuPont. All rights reserved. 
Description: Test class for the controller batch_DeleteTrashQueueLeads
Change history: <Rohit20160205>
                <Priya20160219> Removed see all data and provide required test data
********************************************************************************/

@istest
public class batch_DeleteTrashQueueLeads_UT {
    
    public static testmethod void  unittest(){
    
    // <Priya20160219> start 
     string existingIssueID;
     //[12302016] Merge&Spin: Removed Hard Coding of System Administrator Profile Id
     profile p = [Select id from profile where name='System Administrator' limit 1]; 
     User testuser1=new User(LastName='test1',Alias='ts',Email='test1@dupont.com',Username='test1@dupont.com.dcp',Profileid=p.id,IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
     insert testuser1;  
     Group g1 = new Group(Name='Trash - leads for delete', type='Queue');
            insert g1;
       System.runAs(new User(Id=UserInfo.getUserId()))
      {
       QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
           insert q1;
      }     
      //<Priya20160219> End
      Lead l=new Lead();
        l.FirstName = 'CRM Testing First';
        l.LastName = 'CRM Testing Last';
        l.Company = 'CRM Testing INCtest';
        l.description = 'Test descr';
        l.city = 'test';
        l.street = 'test';
        l.state = 'CA';
        l.country = 'United States';
        l.status = 'Qualified';
        l.email = 'test@testnetgear.com';
        l.website = 'www.testcrm.com';
      // Id queueId=[Select Id from Group where name='Trash - leads for delete'].id;
      // l.ownerId=queueId; 
       // <Priya20160219> line: 40 
       l.ownerId=g1.id; 
        insert l;
       
        // <Priya20160219> Start
        string msg='Following Leads are processed in this run::';
        
        
        Issue__c issue = new Issue__c();
        issue.Resolution__c= 'Have created test data overview records';
        issue.SFDC_Instance__c='One Dupont corporate';
        issue.Type__c='Data';
        issue.SubType__c='Transfer Records';
        issue.Classification__c= 'Routine'; 
        issue.Status__c='not started';
        issue.Date_Accepted__c=Date.Today();
        issue.Date_Closed__c =Date.Today();
        issue.Severity__c='Medium';
        issue.Region__c='All';
        issue.Application__c='CRM(Standard functionality)';
        issue.Name='Test issue';
        issue.Description__c='test';
        issue.Submitted_By__c=testuser1.Id;
        issue.Discussion_And_Updates__c=System.Now()+' (Rohit saini)\r\n Hello Anne / Floris,\r\n'+ 
                'We have Moved the leads in the trash queue to the Recycle Bin. \r\n'+
                'Can you please check and let us know if we are of any further assistance .\r\n'+ 
                'Thank You!\r\n-------------------------------------\r\n';
        issue.Submitted_DateTime__c=Date.Today();      
        insert issue;

        Existing_Issue__c ei= new Existing_Issue__c();
        ei.Name='existingissue';  
        ei.Issue_Id__c=issue .id;
        ei.Queue_Name__c=g1.name;
        insert ei;
       
        existingIssueID= ei.Issue_Id__c;
        issue__c existingIssue;
        existingIssue=[select id, name, SFDC_Instance__c, Type__c, SubType__c, Classification__c, RecordTypeId, Severity__c, Program__c, Region__c, Application__c, Description__c, Submitted_By__c, ownerId, Discussion_And_Updates__c, Closing_Type__c, Resolution__c from issue__c where id =:existingIssueID limit 1];    
        system.debug('existingIssue****'+existingIssue);
       // <Priya20160219>  End
        Test.starttest(); 
        batch_DeleteTrashQueueLeads runBatch = new batch_DeleteTrashQueueLeads();
        //<Priya20160219> 
        runbatch.newissue = existingIssue;
              
        String sch = '0 0 14 1 * ? *';
       //  <Rohit20160205> 
        String jobID = system.schedule('Delete Trash queue leads', sch, runBatch);
        Test.StopTest();
    }
}
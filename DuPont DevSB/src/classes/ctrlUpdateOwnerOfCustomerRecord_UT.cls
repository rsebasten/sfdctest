@isTest()
public class ctrlUpdateOwnerOfCustomerRecord_UT  {

   
 public static final string QueueRules_COB_RTYPE = Rtype.getIdByDevName('Business_Rules__c','Queue_Rules');

       
 public static testMethod void testMyController1() {
   test.startTest(); 
    Id p=[Select Id,Name from Profile where Name=:'SFDC UTIL CDR Integration Profile'].Id;
        User u= new User(Firstname='DupontIssueTestUser1',Alias='Dpnt1', Email='brundha_kumar@axaltacs.com', 
        User_Country__c='UNITED KINGDOM',profileid = p,
        Username='User1@dupont.com.Dev8', LastName='Hill',
        CommunityNickname='testingAxaltaCaseTeam2', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
       Group g1 = new Group(Name='queue', type='Queue');
            insert g1;
       QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Customer_Data_Request__c');
            insert q1;
   system.runas(u) {  
    ctrlUpdateOwnerOfCustomerRecord controller = new ctrlUpdateOwnerOfCustomerRecord();
   // Group g1 = new Group(Name='queue', type='Queue');
       //     insert g1;
           // QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Customer_Data_Request__c');
         //   insert q1;
    
     Business_Rules__c rules=new Business_Rules__c();   
     //Id custDataRecId1 = [Select Id, Name from RecordType where DeveloperName = 'Queue_Rules' limit 1].Id; 
     
       rules.Selling_Company_Code__c='0003 - E.I. DuPont India Private Limited';
       rules.Destination_Queue__c='queue';
       //rules.CDR_Credit_Limit_Lower__c=100;
       //rules.CDR_Credit_Limit_Upper__c=700;
       rules.RecordtypeId=QueueRules_COB_RTYPE ;
       insert rules;
       
     Customer_Data_Request__c req = new Customer_Data_Request__c();
    
        req.Requestor_Name__c = UserInfo.getUserId();
        req.Requestor_Email__c = 'sai_lakkimsetty@infosys.com';
        req.SF_Region__c ='Asia Pacific';
        req.Company_Code__c= '0003 - E.I. DuPont India Private Limited';
                              
        req.Group_Key__c ='6000000';
        req.Distribution_Channel__c = '10-Dupont Std';
        req.Account_Group__c='Z001(Sold-to Party)';
        req.Division__c = '01-Product Division 01';
        req.Customer_Name__c='Test Customer';
        req.Request_Status__c='Draft/Data Gathering';
        req.Sold_to_Street__c='Walters Street';
        req.Sold_to_City__c='New Jersey';
        req.Sold_to_Country__c='US-USA';
        req.Sold_to_e_mail__c='sam@gmail.com';
        req.Proposed_Terms_of_Payment__c='15 PROX';
        req.Proposed_Credit_Limit__c='102';
        req.Proposed_Credit_Limit_Currency_Code__c='USD-American Dollar';
        req.Default_Incoterms_2__c='Test Term';
        req.Estimated_Average_Monthly_Purchases__c=100;
        req.Estimated_Number_of_Orders_per_Month__c=20;
        req.Registration_number__c='458889';
        req.Sold_To_Office_House_Number__c = '124';
        req.Sold_to_State_Province__c ='Michigun';
        req.Record_Locked__c=false;
        req.Relevant_for_POD__c=false;
        req.OwnerId=u.Id;
        test.StopTest();
        insert req;
        
                   

    List <Customer_Data_Request__c> custDataToUpdate = new List <Customer_Data_Request__c>();  
    custDataToUpdate.add(req); 
    ctrlUpdateOwnerOfCustomerRecord.runOnce();
    controller.fetchQueueMap();
       
       
    
     }
    }
  }
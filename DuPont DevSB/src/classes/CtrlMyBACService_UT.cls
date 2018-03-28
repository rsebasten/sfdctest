@isTest
private class CtrlMyBACService_UT {
public static Kevlar_Response_Messages__c m1,m2,m3,m4;
public static List<Kevlar_Response_Messages__c> InsertList = new List<Kevlar_Response_Messages__c>();
public static Profile  p;
public static User user1,user2;
public static BA_Configuration__c dat1,dat2,dat3,dat4,dat5,dat6;
public static List<BA_Configuration__c> listBAC = new List<BA_Configuration__c>();
public static BAC_Team_Member__c tem,tem1;

static {
    m1 = testData_Kevlar_UT.getMessage1(); 
    InsertList.add(m1);       
    m4 = testData_Kevlar_UT.getMessage14();
    InsertList.add(m4);  
    m2 = testData_Kevlar_UT.getMessage2(); 
    InsertList.add(m2); 
    insert InsertList;  
     // Adding dummy value   
    p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     List<User> userList = new List<User>();
     user1 = new User();     
     user1.Username = 'testName1@abc.com';
     user1.LastName = 'name';
     user1.Alias = 'tn';
     user1.CommunityNickname = 'test';
     user1.TimeZoneSidKey = 'America/Chicago';
     user1.LocaleSidKey = 'en_US';
     user1.EmailEncodingKey = 'UTF-8';
     user1.ProfileId = p.id;
     user1.LanguageLocaleKey = 'en_US';
     user1.email = 'testName1@abc.com';
     user1.isActive = true;
     user1.Role_in_Kevlar__c = 'Admin';
     userList.add(user1);
      
     user2 = new User();
     user2.Username = 'testName2@abc.com';
     user2.LastName = 'name2';
     user2.Alias = 'tn2';
     user2.CommunityNickname = 'test2';
     user2.TimeZoneSidKey = 'America/Chicago';
     user2.LocaleSidKey = 'en_US';
     user2.EmailEncodingKey = 'UTF-8';
     user2.ProfileId = p.id;
     user2.LanguageLocaleKey = 'en_US';
     user2.email = 'testName2@abc.com';
     user1.Role_in_Kevlar__c = 'Admin';
     user2.isActive = true;
     userList.add(user2);
     insert userList;
     
     
     dat1=new BA_Configuration__c ();
     dat1.Name='abcd';
     dat1.Active__c= true;
     dat1.status__c='Tender in progress';
     dat1.BAC_Progress__c='New Campaigns';
     dat1.ownerid = user1.id;
     listBAC.add(dat1);    
     dat2=new BA_Configuration__c ();
     dat2.Name='abcd1';
     dat2.Active__c= true;
     dat2.ownerid = user2.id;
     dat2.status__c='Pre- Tender Solicitation';
     dat2.BAC_Progress__c='Requirements Commenced';
     listBAC.add(dat2); 
     dat3=new BA_Configuration__c ();
     dat3.Name='abcd';
     dat3.Active__c= true;
     dat3.status__c='Tender Bid Submissions';
     dat3.BAC_Progress__c='Specifications Generated';
     dat3.ownerid = user1.id;
     listBAC.add(dat3);
     dat4=new BA_Configuration__c ();
     dat4.Name='abcd';
     dat4.Active__c= true;
     dat4.status__c='Solutions Evaluation';
     dat4.BAC_Progress__c='Solutioning Started';
     dat4.ownerid = user1.id;
     listBAC.add(dat4); 
     dat5=new BA_Configuration__c ();
     dat5.Name='abcd';
     dat5.Active__c= true;
     dat5.status__c='Tender Contract Award';
     dat5.BAC_Progress__c='Pricing Completed';
     dat5.ownerid = user2.id;
     listBAC.add(dat5);  
     dat6=new BA_Configuration__c ();
     dat6.Name='abcd';
     dat6.Active__c= true;
     dat6.status__c='Campaign Closed';
     dat6.BAC_Progress__c='Commercials Generated';
     dat6.ownerid = user2.id;
     listBAC.add(dat6);      
     insert listBAC;
     
     tem= new BAC_Team_Member__c();
     tem.BA_Configuration__c = dat1.id;
     tem.name='TM1';
     tem.Team_Member_Name__c=user2.id;
     insert tem; 
     tem1= new BAC_Team_Member__c();
     tem1.BA_Configuration__c = dat1.id;
     tem1.name='TM2';
     tem1.Team_Member_Name__c=user1.id;
     insert tem1; 
     String JsonMsg='{"userId" :"'+user1.id+'"}';
}
static testMethod void testDoPost() { 
    
     String JsonMsg='{'+
    '"userId" : "'+user1.id+'"'+   
    '}';

     Test.startTest();
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
     req.requestURI = '/services/apexrest/MyBAC';  
     req.httpMethod = 'POST';
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;
     CtrlMyBACService testuserId=new CtrlMyBACService();  
     CtrlMyBACService.doPost();  
     Test.stopTest();

   } 
    
}
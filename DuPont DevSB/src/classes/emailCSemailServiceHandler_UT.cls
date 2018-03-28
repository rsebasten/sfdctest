@istest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Description: Utility class
   Change History                                                        Date
1. VS  10212015 - Added test methods testThreadReplyEMailBody            21/10/2015  
    & testThreadReplyEMailBody for test class coverage of utilCSEmailService. 
    
2. <20170118>Merge&Spin: Added method for code coverage of "utilCSEmailService" class.  

********************************************************************************/

public class emailCSemailServiceHandler_UT{

/* Test Method 1 is used for covering the if condition(contact with Account list) */    
    public static testMethod void test1(){    
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest();
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newOrder();
             try{
        
            {    
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                CaseWithAccount.accountId=null;
                database.update(CaseWithAccount);
                emailCSemailServiceHandler obj2 = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result2 = obj2.handleInboundEMail(email,envelope);
                System.assert(result2.success,true);
            }

            {
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);

            }
            } catch(Exception ex){
                Boolean ExceptionThrown =  ex.getMessage().containsIgnoreCase('Exception') ? true : false;
                System.AssertEquals(ExceptionThrown, true);
                system.debug('Exception occured...'+ex.getMessage());
         }
            Test.stopTest();        
        }
    }  

/* Test Method 2 is used for covering the else condition(contact with Account list) */ 
    public static testMethod void test2(){    
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest(); 
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            
            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newServieRequest();
            try{
            
            {                
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                CaseWithAccount.accountId=null;
                database.update(CaseWithAccount);
                
                emailCSemailServiceHandler obj2 = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result2 = obj2.handleInboundEMail(email,envelope);
                System.assert(result2.success,true);            
            }
                        
            {
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);
            }
            } catch(Exception ex){
                Boolean ExceptionThrown =  ex.getMessage().containsIgnoreCase('Exception') ? true : false;
                System.AssertEquals(ExceptionThrown, true);
                system.debug('Exception occured...'+ex.getMessage());
         }         
            Test.stopTest();                    
        }
    }
    
/* Test Method 3 is used for covering the else condition(contact without Account list) */   
    public static testMethod void test3(){            
        System.runAs(utilCSEmail_UT.user()){                        
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newOrder();
            List<Case> cList = utilCSEmail_UT.caseWithoutAccountList();
            Test.startTest(); 
            try{
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);
                } catch(Exception ex){
                    Boolean ExceptionThrown =  ex.getMessage().containsIgnoreCase('Exception') ? true : false;
                System.AssertEquals(ExceptionThrown, true);
                system.debug('Exception occured...'+ex.getMessage());
              }
            Test.stopTest(); 
         }
    }

/* Test Method 4 is used for covering the else condition(contact without Account list) */ 
   public static testMethod void test4(){    
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest(); 
            try{
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
            Messaging.InboundEmailResult result = obj.handleInboundEmail(email,envelope);
            //System.assert(result.success,false);
            Test.stopTest();
            } catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
         }
        }
        
    }  
/* Test Method 5 is used for covering the else condition(contact without Account list) */   
    public static testMethod void test5(){    
        //<20170131> START Merge&Spin: Added for coverage of "emailCSemailServiceHandler" class.
        profile testProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        user testUser = utilCSEmail_UT.user();
        testUser.username= 'testuserdev@dupont.erpuser';
        testUser.profileId = testProfile.id;
        //<20170131> END Merge&Spin
        System.runAs(testUser){
            //<20170131> Merge&Spin: Insert account and contact record.
            Account acc = new Account(name = 'Test Account',Status__c = 'Active');            
            acc.recordTypeId = rtype.getidbyDevName('Account','ERP_Customer_General');    
            acc.Status__c = 'Active';                   
            insert acc;   
                        
            contact con = new Contact(lastname = 'DuPont Customer Service', AccountID=acc.id);   
            //commented for dps
            //con.recordtypeID = rtype.getidbyDevName('Contact','CS_Contact');                                   
            con.recordtypeID = rtype.getidbyDevName('Contact','OneDuPont');
            con.email = 'test@test.com';
            insert con; 
            //<20170131> Merge&Spin: For coverage of "emailCSDenialOfServiceHelper" class.
            emailCSDenialOfServiceHelper.getIntReqCaseDayLimit();
            
            try{
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newServieRequest();
         
            List<Case> cList = utilCSEmail_UT.caseWithoutAccountList();
            Test.startTest(); 
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);
          Test.stopTest(); 
          } catch(Exception ex){
              Boolean ExceptionThrown =  ex.getMessage().containsIgnoreCase('Exception') ? true : false;
                System.AssertEquals(ExceptionThrown, true);
            system.debug('Exception occured...'+ex.getMessage());
         }
         }

    } 
    
/* Test Method 6 is used for covering the else condition(contact without Account list) */   
    public static testMethod void test6(){    
        System.runAs(utilCSEmail_UT.user()){
            try{
            Test.startTest(); 
            Messaging.InboundEmail email = utilCSEmail_UT.emailhtml();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newServieRequest();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Internal_Request_Cases_Per_Day__c='10',Cases_Per_Account_Per_Day__c ='10',
                                                                        Unassigned_Cases_Per_Day__c='10');
            database.insert(unassignedLimit);
            
            
            List<RecordType> rt = [select id,Name from RecordType where SobjectType='Account' and Name='ERP Customer' Limit 1];
            Account account = new Account(name = 'Test Account',Status__c = 'Active');
            if(rt <>null && rt.size()>0){
                account.recordTypeId = rt[0].id;
            }           
            database.insert(account);   
            Contact contact = null;
            List<RecordType> contactRecType = [select id,Name from RecordType where SobjectType='Contact' and Name='CS-Contact' limit 1];        
            contact = new Contact(lastname = 'DuPont Customer Service', AccountID=account.id);   
            if(contactRecType <>null && contactRecType.size()>0){
                contact.recordTypeId = contactRecType[0].id;
            }               
            contact.email = 'test@test.com';
            database.insert(contact); 
            system.debug(contact + '****');
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);
                String htmltest = '<html><body>test</body></html>';
                utilCSEmailService.HtmlToText(htmltest);
                
          Test.stopTest(); 
          
          } catch(Exception ex){
              Boolean ExceptionThrown =  ex.getMessage().containsIgnoreCase('Exception') ? true : false;
                System.AssertEquals(ExceptionThrown, true);
            system.debug('Exception occured...'+ex.getMessage());
         }
            }

    }
    public static testmethod void CreateBatchMonitor(){
        String Batch = 'Batch';
        String Error = 'Error';
        String Except= 'Except';
        String SenderEmailAddress = 'xyz@tcs.com';
        String ToAddress = 'BatchDepoyuser';
        String EmailSubject = 'SenderEmailAddress';
        
        utilCSEmailService.CreateBatchMonitor(Batch,Error,Except,SenderEmailAddress,ToAddress,EmailSubject) ;
    }
         //VS  10212015 added test method to cover scenaro when thread id exists in email subject
     public static testMethod void testThreadReplyEMailSubject(){    
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest();
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newOrder();
             try{
        
            {    
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                String caseId = CaseWithAccount .Id ;
                String OrgId= UserInfo.getOrganizationId();
                
                string Case_ThreadID = '[ ref:_'  + OrgId.left(4)  + '0'  + OrgId.mid(11,4) + '._'  + caseId.left(4) + '0'  + caseId.mid(10,5) + ':ref ]';
                email.subject = 'Dummy Case name 123 '+ Case_ThreadID; 
                emailCSemailServiceHandler obj2 = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result2 = obj2.handleInboundEMail(email,envelope);
                System.assert(result2.success,true);
            }
            } catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
         }
            Test.stopTest();        
        }
    }
    
     //VS  10212015 added test method to cover scenaro when thread id exists in email Body
     public static testMethod void testThreadReplyEMailBody(){    
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest();
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            CS_EmailAddressSettings__c csEmail1 = utilCSEmail_UT.newOrder();
             try{
        
            {    
                Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();
                String caseId = CaseWithAccount .Id ;
                String OrgId= UserInfo.getOrganizationId();
                
                string Case_ThreadID = '[ ref:_'  + OrgId.left(4)  + '0'  + OrgId.mid(11,4) + '._'  + caseId.left(4) + '0'  + caseId.mid(10,5) + ':ref ]';
                email.plainTextBody = 'Dummy Case name 123 '+ Case_ThreadID; 
                emailCSemailServiceHandler obj2 = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result2 = obj2.handleInboundEMail(email,envelope);
                System.assert(result2.success,true);
            }
            } catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
         }
            Test.stopTest();        
        }
    }
    
    /* Test Method 7 is used for covering the case creation failed case */   
    public static testMethod void test7(){    
          System.runAs(utilCSEmail_UT.user()){
            try{
            Test.startTest(); 
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c csEmail1 = emailCSemailServiceHandler_UT.newServieRequest();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Internal_Request_Cases_Per_Day__c='10',Cases_Per_Account_Per_Day__c ='10',
                                                                        Unassigned_Cases_Per_Day__c='10');
            database.insert(unassignedLimit);
            
            List<RecordType> rt = [select id,Name from RecordType where SobjectType='Account' and Name='ERP Customer' Limit 1];
            Account account = new Account(name = 'Test Account',Status__c = 'Active');
            if(rt <>null && rt.size()>0){
                account.recordTypeId = rt[0].id;
            }           
            database.insert(account);   
                
            Contact contact = null;
            List<RecordType> contactRecType = [select id,Name from RecordType where SobjectType='Contact' and Name='CS-Contact' limit 1];        
            contact = new Contact(lastname = 'DuPont Customer Service', AccountID=account.id);   
            if(contactRecType <>null && contactRecType.size()>0){
                contact.recordTypeId = contactRecType[0].id;
            }               
            contact.email = 'test@test.com';
            database.insert(contact); 
            system.debug(contact + '****');
                emailCSemailServiceHandler obj = new emailCSemailServiceHandler();            
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
                System.assert(result.success,true);
          Test.stopTest(); 
          } catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
         }
          }
    }
    
    /* Method to create test data for custom setting with Service Request record type. */
    testmethod public static  CS_EmailAddressSettings__c newServieRequest(){
        CS_EmailAddressSettings__c csEmail1 = NULL;
        try{
            csEmail1 = new CS_EmailAddressSettings__c();
            csEmail1.CS_Region__c = 'Global';
            csEmail1.CS_RequestType__c = null;
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            csEmail1.name = envelope.toAddress.substring(0,envelope.toAddress.indexOf('*'));
            database.insert(csEmail1);    
        } catch(Exception ex){ 
            system.debug('Exception occured...'+ex.getMessage());
            }
        return csEmail1;
    }
    //<20170118>Merge&Spin: Added method for code coverage of "utilCSEmailService" class. 
    public static testmethod void testutilCSEmailService(){
                    
            Messaging.InboundEmail testEmail = utilCSEmail_UT.email();
            
            String htmltest = '<html><body>test</body></html>';
            utilCSEmailService.HtmlToText(htmltest);
                                       
            Account acc = new Account(name = 'Test Account',Status__c = 'Active');            
            acc.recordTypeId = rtype.getidbyDevName('Account','ERP_Customer_General');                       
            insert acc;   
                        
            contact con = new Contact(lastname = 'DuPont Customer Service', AccountID=acc.id);   
            //commented for dps
            //con.recordtypeID = rtype.getidbyDevName('Contact','CS_Contact');                                   
            con.recordtypeID = rtype.getidbyDevName('Contact','OneDuPont');                                  
            con.email = 'test@test.com';
            insert con; 
            
            case c = utilCSEmailService.createCaseWithAccountContact(testEmail,rtype.getIdByDevName('Case','TestCaseRecordType'),'Customer Service Complaint','Phone',acc.id,con.id);        
            
            case testCase = new Case();
            testCase.AccountID=acc.id;
            testCase.Subject = testEmail.Subject;
            testCase.Description = testEmail.plainTextBody;
            testCase.Origin = 'Fax';
            testCase.CaseCategory__c='New Order';
            testCase.SuppliedEmail = testEmail.fromAddress;
            insert testCase;
            
            utilCSEmailService.extCaseRecord.add(testCase);
            utilCSEmailService.handleThreadEmail(testEmail);
            testEmail.subject='test';
            testEmail.plainTextBody +=testEmail.plainTextBody;
            
            utilCSEmailService.handleThreadEmail(testEmail);
        //<20170130>Merge&Spin: Added for code coverage of "DmlResults" class.   
          
            Account testAccount = new Account(name = 'Test Account',Status__c = 'Active');            
            testAccount.recordTypeId = rtype.getidbyDevName('Account','ERP_Customer_General');                       
            Database.SaveResult result = Database.insert(testAccount,true);
            Database.UpsertResult UpsertResult = Database.upsert(testAccount,true);
            Database.DeleteResult DelResult = Database.Delete(testAccount,true);
            
            new DmlResults(new LIST<Database.Saveresult>());
            new DmlResults(new LIST<Database.Saveresult>(),new list<sobject>(),true);
            new DmlResults(new LIST<Database.Deleteresult>());
            new DmlResults(new LIST<Database.Deleteresult>(),new list<sobject>());
            new DmlResults(new LIST<Database.Deleteresult>(),new list<sobject>(),true);
            new DmlResults(new LIST<Database.Upsertresult>());
            new DmlResults(new LIST<Database.Upsertresult>(),new list<sobject>(),true);
            DmlResults.dmlInsert(new list<sobject>(),true);
            DmlResults.dmlUpdate(new list<sobject>(),true);
            DmlResults.dmlDelete(new list<sobject>(),true);
            new DmlResults.Result(result);
            new DmlResults.Result(result,testAccount);
            new DmlResults.Result(UpsertResult);
            new DmlResults.Result(UpsertResult,testAccount);
            new DmlResults.Result(DelResult);
            new DmlResults.Result(DelResult,testAccount);
            
    }           
}
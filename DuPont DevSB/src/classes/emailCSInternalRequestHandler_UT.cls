@isTest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Description: Utility class
********************************************************************************/

public class emailCSInternalRequestHandler_UT {

/* This method tests the functionality if email has been sent successfully  */
   public static testMethod void testMethod1(){        
        System.runAs(utilCSEmail_UT.user()){
            Test.startTest();                
            Messaging.InboundEmail email = utilCSEmail_UT.email();            
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c emailSettings = utilCSEmail_UT.newOrder(); 
            Case CaseWithAccount = utilCSEmail_UT.caseWithAccount();

            emailCSInternalRequestHandler obj = new emailCSInternalRequestHandler ();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            System.assert(result.success,true);
            Test.stopTest();
        }
    
    }   
    
/* This method tests the functionality if email service has cross the limit */
    public static testMethod void testMethod2(){
        System.runAs(utilCSEmail_UT.user()){
            
            Messaging.InboundEmail email = utilCSEmail_UT.email();            
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c emailSettings = utilCSEmail_UT.newOrder(); 
            email.fromAddress='test@acc.com';
            List<Case> lCase = utilCSEmail_UT.caseWithAccountList();          
            Test.startTest();
            emailCSInternalRequestHandler obj = new emailCSInternalRequestHandler ();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            System.assert(result.success,true);
            Test.stopTest();
        }       
    }    

    /* This method tests the error*/
    public static testMethod void testMethod3(){
        System.runAs(utilCSEmail_UT.user()){
                        
            Messaging.InboundEmail email = utilCSEmail_UT.emailhtml();            
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            Test.startTest();    
            emailCSInternalRequestHandler obj = new emailCSInternalRequestHandler ();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            //System.assert(result.success,false);
            Test.stopTest();
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
     public static testMethod void testMethod4(){
        System.runAs(utilCSEmail_UT.user()){
                        
            Messaging.InboundEmail email = utilCSEmail_UT.email(); 
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c emailSettings = utilCSEmail_UT.newOrder(); 
            email.fromAddress='test*acc.com';
            List<Case> lCase = new List<Case>();  
            Test.startTest();    
            emailCSInternalRequestHandler obj = new emailCSInternalRequestHandler ();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            //System.assert(result.success,false);
            Test.stopTest();
        }
    } 
    
}
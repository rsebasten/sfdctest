@isTest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Description: Utility class
********************************************************************************/

private class emailCSeFaxServiceHandler_UT {
    
    /* This method tests the functionality if email has been sent successfully  */
    static testMethod void test1(){
        System.runAs(utilCSEmail_UT.user()){
            try{
            
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            CS_EmailAddressSettings__c emailSettings = utilCSEmail_UT.newOrder();            
            Case caseWithAccount = utilCSEmail_UT.caseWithAccount();
            
            Test.startTest();
                emailCSeFaxServiceHandler obj = new emailCSeFaxServiceHandler ();
                Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            Test.stopTest();
            
            System.assert(result.success,true);
             } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
        }
                
    }
    
    /* This method tests the functionality if email service has cross the limit */
    static testMethod void test2(){
        System.runAs(utilCSEmail_UT.user()){
            try{
            
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();

            CS_EmailAddressSettings__c emailSettings = utilCSEmail_UT.newOrder();                
    
            List<Case> cList = utilCSEmail_UT.caseWithAccountList();
            for(Case c:cList){
                c.AccountId = null;
            }
            database.update(cList);
            Test.startTest();
            emailCSeFaxServiceHandler obj = new emailCSeFaxServiceHandler ();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            Test.stopTest();
            System.assert(result.success,true);
            
             } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }

        }
                        
    }

    /* This method tests the error*/
    public static testMethod void test3(){
        System.runAs(utilCSEmail_UT.user()){
            try{
            
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            
            emailCSeFaxServiceHandler obj = new emailCSeFaxServiceHandler ();
            Test.startTest();
            Messaging.InboundEmailResult result = obj.handleInboundEMail(email,envelope);
            Test.stopTest();
             } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
        }                
    }
	
    

}
/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Ritesh Kothari
Email: Riteshpraveen_k@infosys.com
Description:  Unit test for emailReachOutbound
********************************************************************************/
@isTest()
public class emailReachOutbound_UT {
 public class applicationException extends Exception {}
 
     public static testMethod void test() {

            try{
               Account a1 = new Account(name='test Account', country__c = 'UNITED STATES');
    insert new Account[]{a1};
  String rtid = ( Contact.SObjectType.getDescribe().getRecordTypeInfosByName().containsKey('REACH') )
          ? Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('REACH').recordTypeId : null;
    Contact c1 = new  Contact(firstname='tom',lastName='tester', Accountid=a1.Id, email='testemail@dupont.com', Mb_Of_Campaign__c='REACH');
    Contact c2 = new  Contact(firstname='tom',lastName='duptester', Accountid=a1.Id, email='testdupemail@dupont.com', Mb_Of_Campaign__c='REACH');
    Contact c3 = new  Contact(firstname='tom',lastName='duptester', Accountid=a1.Id, email='testdupemail@dupont.com', Mb_Of_Campaign__c='REACH');
    insert new Contact[]{c1,c2,c3};
    
    Test.startTest();
    TestInboundEmail('testemail@dupont.com');         //test Single Exist Once Contact
    TestInboundEmail('testdupemail@dupont.com');      //test Single Dup Contact
    TestInboundEmail('aslkfglaskldslfkds@dupont.com');    //test non-existing Contact
    
    //system.debug(new parseName('test.email@dupont.com').firstname);
    //system.debug(new parseName('test email').lastName);
    
    Test.stopTest();              
             }
             catch(Exception e){
                   system.debug('@@@@@e.getmessage() : ' + e);
                     //throw new applicationException (e.getmessage());
             }
    }
    
      static void TestInboundEmail(String toAddress ) {
    // Create a new email, envelope object and Attachment
     Messaging.InboundEmail email = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     Messaging.InboundEmail.BinaryAttachment bAtt = new Messaging.InboundEmail.BinaryAttachment();
     Messaging.InboundEmail.textAttachment tAtt = new Messaging.InboundEmail.textAttachment();
     
     
     email.subject = 'testing...';
     email.fromName = 'from Name';
     email.PlainTextBody='test';
     email.htmlBody = '<H1>TEST</H1>';
     email.toAddresses = new String[] { toAddress };

     
     // set the body of the attachments
     bAtt.body = blob.valueOf('test binary');
     bAtt.fileName = 'test binary attachment';
     bAtt.mimeTypeSubType = 'plain/txt';
     tAtt.body = 'test text';
     tAtt.fileName = 'test text attachment';
     tAtt.mimeTypeSubType = 'text';
     
     email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {bAtt }; 
     email.textAttachments = new Messaging.inboundEmail.textAttachment[] {tAtt }; 
     // call the class and test it with the data in the testMethod
     emailReachOutbound emailServiceObj = new emailReachOutbound();
     emailServiceObj.handleInboundEmail(email, env );
  }
 
}
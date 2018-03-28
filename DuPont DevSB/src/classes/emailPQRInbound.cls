/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 * // 1/13/2017 - Merge&Spin - Added Application field value
 */
global class emailPQRInbound implements Messaging.InboundEmailHandler {

//use label not name????
public static final string ISSUE_RTYPEID = Issue__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Issues and Ideas').recordTypeId;


    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        handleInboundEmail(email);
        // Always set the result to true. No need to send an email back to the user 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = true;
        // Return the result for the Apex Email Service
        return result;
    }
    
 private void handleInboundEmail(Messaging.inboundEmail email)  {
        
        //Add Issue
        Issue__c iss = new Issue__c();
        if (email.plainTextBody != null) iss.Description__c = email.plainTextBody;
        if (email.subject != null)  {   if (email.subject.length()>80)
                                            iss.name = email.subject.substring(0,79);
                                        else 
                                            iss.name = email.subject;
        } else                          iss.name = 'No Subject';
        if (ISSUE_RTYPEID != null)  iss.recordTypeId = ISSUE_RTYPEID;
     // 1/13/2017 - Merge&Spin - Added Application field value
        iss.Application__c = 'CRM (Standard functionality)';
        //if (OwnerId != null)          xtIER.Contact__c = ContactId;//OwnerId = contacts[0].OwnerId    
        insert iss;
        
        EmailLib.AttachAttachments(iss.Id, email);
        EmailLib.AttachHtmlBody(iss.Id, email.htmlBody);    
        
 }

/*********************************************************************************************************  
**********************************************************************************************************/
    
  static testMethod void test1() {
    
    Test.startTest();
    EmailLib.CreateTestEmail(new emailPQRInbound(),'testPQR@dupont.com','long subject, long subject, long subject, long subject, long subject, long subject , long subject , long subject ');   
    EmailLib.CreateTestEmail(new emailPQRInbound(),'testPQR@dupont.com');   
    EmailLib.CreateTestEmail(new emailPQRInbound(),'testPQR@dupont.com',null); //no subject
    Test.stopTest();
    }
    


}
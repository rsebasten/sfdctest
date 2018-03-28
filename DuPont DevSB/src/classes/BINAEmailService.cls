/*SHIVALI20150119- This class implements the functionality of attaching the email attachment to the entitlement as well.
*/

global class BINAEmailService implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          system.debug('======='+email);
         if(email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
         system.debug('========file Name is'+email.binaryAttachments[0].filename);
         String str=((email.binaryAttachments[0].filename).split('Registration Details- ')[1]).split('.pdf')[0];
          system.debug('-------------'+str);
          Entitlement ent= new Entitlement();
          ent=[Select id,Registration_Number__c from Entitlement where Registration_Number__c=:str];
         // <DB20150702 start> Modified to keep the latest Attachment after sending email
          List<Attachment>myAttachments= [SELECT id from Attachment where parentid=:ent.id];
          //system.debug('Number of Attachments avilable is/are :'+myAttachments.size());
          //system.debug('Entitlement id linked is  :'+ent.id);
       if(myAttachments.size()>0)
          {
          delete myAttachments;
          }
         // <DB20150702 End> Modified to keep the latest Attachment after sending email
          for(integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
          Attachment attachment = new Attachment();
          attachment.ParentId=ent.Id;
        attachment.Name= email.binaryAttachments[i].filename;
        attachment.Body= email.binaryAttachments[i].body;
        insert attachment;
        }
        }
return result;
}
  }
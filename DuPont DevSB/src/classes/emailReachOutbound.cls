/*******************************************************************************
(C)2008 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  REACH BCC outbound from Exact Target. 

Modifications:


********************************************************************************/

global class emailReachOutbound implements Messaging.InboundEmailHandler {
 
     //public static final string OUTBOUND_RTYPEID = xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Outbound Email Result').recordTypeId;
 	 public static final string LEAD_RTYPEID =  Lead.SObjectType.getDescribe().getRecordTypeInfosByName().get('Level 2 REACH').recordTypeId;
 	  
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
 
 		//Process Email
		//handleReachOutboundEmail(email);

		// Always set the result to true. No need to send an email back to the user 
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	    result.success = true;
	    
		// Return the result for the Apex Email Service
	    return result;
	}
	
/*	
private void handleReachOutboundEmail(Messaging.inboundEmail email)  {
	
  Id ContactId;		//Id of Reach Contact
  Id LeadId;		//Id of new lead if Contact does not exists
  Id CampaignId;	//Id of Campaign if we can get this????
  
  String emailToSearch = email.toAddresses[0];
  //emailToSearch = 'leon.demo@dupont.com';
  //If (email.subject.startsWith('DEMO:')) {
//		emailToSearch = email.fromAddress.substring(5);
  //}
  // Try to lookup any contacts based on the email from address
  //try {
  		Contact[] contacts = [
  			SELECT Id, AccountId, OwnerId, Name, Email 
  			FROM Contact 
  			WHERE Mb_Of_Campaign__c includes ('REACH') AND Email = :emailToSearch 
  			//WHERE RecordType.Name='REACH' 
  			// WHERE Id in ( Select ContactId from CampaignMembers where Campaign.Owning_Org='REACH')
  			LIMIT 2];
  
  		if ( contacts.size() == 1 ) {
	  		//great! Got a single hit 
			ContactId = contacts[0].Id;  
  		}
		else if ( contacts.size() == 0)  {
			//no contact...create lead
			LeadId=createLead(email);
		}
			//more than one contact...create lead
		else {
			LeadId=createLead(email);
		}
		
		//Get REACH recordtype for Individual_Email_Result
		/*String rtid = ( xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().containsKey('Outbound Email Result') ) 
			  			? xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Outbound Email Result').recordTypeId : null;
		*/
		/*
		//Add xtma_Individual_Email_Result__c
		xtma_Individual_Email_Result__c xtIER = new xtma_Individual_Email_Result__c();
 		xtIER.Direction__c = 'Outbound';
		if (email.plainTextBody != null) xtIER.Body__c = showHeaders(email.headers)+email.plainTextBody;
        if (email.subject != null)	{	if 	(email.subject.length()>255) 
        									xtIER.Subject_Line__c = email.subject.substring(0,254);
        								else 
        									xtIER.Subject_Line__c = email.subject;
        								if (email.subject.length()>80)
        									xtIER.name = email.subject.substring(0,79);
        								else 
        									xtIER.name = email.subject;
        } else 							xtIER.name = 'No Subject';
        if (email.fromAddress != null) 	xtIER.From_Address__c = email.fromAddress;
        if (email.fromName != null) 	xtIER.From_Name__c = email.fromName;
        //if (CampaignId != null) 		xtIER.Campaign__c = CampaignId; //else CampaignId=701R00000004xEl
        if (LeadId != null) 			xtIER.Lead__c =  LeadId;
        if (ContactId != null) 			xtIER.Contact__c = ContactId;
        if (OUTBOUND_RTYPEID != null) 	xtIER.recordTypeId = OUTBOUND_RTYPEID;
		//if (OwnerId != null) 			xtIER.Contact__c = ContactId;//OwnerId = contacts[0].OwnerId    
		insert xtIER;


 		//adds all attachments to the Individual_Email_Result
 		AttachAttachments(xtIER.Id, email);
 		
		//if htmlBody then add as a html attachment
		if (email.htmlBody != null && email.htmlBody.length()>0 ) {
			Attachment a = new Attachment(ParentId = xtIER.Id, 
                                          Name = 'MessageBody.html', 
                                          Body = Blob.valueof(email.htmlBody),
                                          contentType = 'text/html');
			insert a;
		}

	 // } //end try
	  
	 //catch (QueryException e) {
	 // System.debug('Query Issue: ' + e);
	 //}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//Need to add Country field to lead for use with 		  
	  private string createLead(Messaging.inboundEmail email) {
				string lastname;
				lastname=email.toAddresses[0].substring(0,email.toAddresses[0].indexOf('@'));

	  		//Company name is domain...
			String co = email.toAddresses[0].substring(email.toAddresses[0].indexOf('@')+1,email.toAddresses[0].length());
			Lead l = new Lead(lastname=lastname, firstname='', RecordTypeId=LEAD_RTYPEID,
				email = email.fromAddress, Company=co);
			insert l;
			return l.id;
	  }
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
 	  private void AttachAttachments(string parentId, Messaging.inboundEmail email) {
			//Add Text Attachments
			if (email.textAttachments!=null && email.textAttachments.size() > 0) {
				
				for (integer i = 0 ; i < email.textAttachments.size() ; i++) {
					string contentType = (email.textAttachments[i].mimeTypeSubType.length()>0) ? email.textAttachments[i].mimeTypeSubType : null;
					insert new Attachment(ParentId = parentId, 
                          Name = email.textAttachments[i].filename, 
                          Body = Blob.valueOf(email.textAttachments[i].body),
                          contentType = ContentType);
				}
			}

	 		//Add Binary Attachments
			if (email.binaryAttachments!=null && email.binaryAttachments.size() > 0) {
				
				for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
					string contentType = (email.binaryAttachments[i].mimeTypeSubType.length()>0) ? email.binaryAttachments[i].mimeTypeSubType : null;
					insert new Attachment(ParentId = parentId, 
                          Name = email.binaryAttachments[i].filename, 
                          Body = email.binaryAttachments[i].body,
                          contentType = ContentType);
				}
			}
	  	
	  }
	  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	  
	  private string showHeaders(Messaging.InboundEmail.Header[] headers) {
	  	String rtn='';
	  	if (headers != null ) 
		  	for ( Messaging.InboundEmail.Header h : headers )
		  		rtn += h.name + ':' + h.value + '\n+++\n';
	  	return rtn;
	  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	

    
  static testMethod void test1() {
    
    
    Account a1 = new Account(name='test Account', country__c = 'UNITED STATES');
    insert new Account[]{a1};
	String rtid = ( Contact.SObjectType.getDescribe().getRecordTypeInfosByName().containsKey('REACH') )
	  			? Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('REACH').recordTypeId : null;
    Contact c1 = new  Contact(firstname='tom',lastName='tester', Accountid=a1.Id, email='testemail@dupont.com', Mb_Of_Campaign__c='REACH');
    Contact c2 = new  Contact(firstname='tom',lastName='duptester', Accountid=a1.Id, email='testdupemail@dupont.com', Mb_Of_Campaign__c='REACH');
    Contact c3 = new  Contact(firstname='tom',lastName='duptester', Accountid=a1.Id, email='testdupemail@dupont.com', Mb_Of_Campaign__c='REACH');
    insert new Contact[]{c1,c2,c3};
    
    Test.startTest();
	TestInboundEmail('testemail@dupont.com'); 				//test Single Exist Once Contact
    TestInboundEmail('testdupemail@dupont.com');			//test Single Dup Contact
    TestInboundEmail('aslkfglaskldslfkds@dupont.com');		//test non-existing Contact
    
    //system.debug(new parseName('test.email@dupont.com').firstname);
    //system.debug(new parseName('test email').lastName);
    
    Test.stopTest();
    }
    
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
    
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
	

*/


}
/*******************************************************************************
(C)2008 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Inbound email handler for emails sent to reach@dupont.com 

Modifications:

TES0811:  Use Mb_Of_Campaign__c instead of RecordType

********************************************************************************/


global class emailReachInbound implements Messaging.InboundEmailHandler {
 
    //public static final string INBOUND_RTYPEID = xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Inbound Email Result').recordTypeId;
	public static final string LEAD_RTYPEID =  Lead.SObjectType.getDescribe().getRecordTypeInfosByName().get('Level 2 REACH').recordTypeId;
 	public static final string LEAD_QUEUE =	[Select Id From Group where type='QUEUE'  and name= 'REACH Level 2 EMEA' ].Id; //Label.REACH_Inbound_Email_Queue
 
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
 		//Process Email
		//handleReachInboundEmail(email);
		// Always set the result to true. No need to send an email back to the user 
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	    result.success = true;
		// Return the result for the Apex Email Service
	    return result;
	}
/******************************************************************************
	
********************************************************************************/
/*	
private void handleReachInboundEmail(Messaging.inboundEmail email)  {
	
  Id ContactId;		//Id of Reach Contact
  Id LeadId;		//Id of new lead if Contact does not exists
  Id CampaignId;	//Id of Campaign if we can get this????
  
  String emailToSearch = email.fromAddress;
  //emailToSearch = 'leon.demo@dupont.com';
  //If (email.subject.startsWith('DEMO:')) {
//		emailToSearch = email.fromAddress.substring(5);
  //}
  // Try to lookup any contacts based on the email from address
  //try {
  		Contact[] contacts = [
  			SELECT Id, AccountId, OwnerId, Name, Email 
  			FROM Contact
  			WHERE Mb_Of_Campaign__c includes ('REACH') AND Email = :emailToSearch //AND Status__c = 'Active'
  			//TES0811 WHERE RecordType.Name='REACH' 
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
		/*
		String rtid = ( xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().containsKey('Inbound Email Result') ) 
			  			? xtma_Individual_Email_Result__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Inbound Email Result').recordTypeId : null;
		*/
		/*
		//Add xtma_Individual_Email_Result__c
		xtma_Individual_Email_Result__c xtIER = new xtma_Individual_Email_Result__c();
 		xtIER.Direction__c = 'Inbound';
		if (email.plainTextBody != null) xtIER.Body__c = email.plainTextBody;
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
        if (INBOUND_RTYPEID != null) 	xtIER.recordTypeId = INBOUND_RTYPEID;
		insert xtIER;


 		//adds all attachments to the Individual_Email_Result
 		EmailLib.AttachAttachments(xtIER.Id, email);
 		EmailLib.AttachHtmlBody(xtIER.Id, email.htmlBody);

	 // } //end try
	  
	 //catch (QueryException e) {
	 // System.debug('Query Issue: ' + e);
	 //}
}
/*********************************************************************************************************	
**********************************************************************************************************/
/*
		//Need to add Country field to lead for use with 		  
	  private string createLead(Messaging.inboundEmail email) {
				string firstname=null;
				string lastname=null;
				
				try {
					if ( email.fromname != null ) {
						string[] arr = email.fromName.split(' ',-2);
						if ( arr.size()>0 ) {
			  				firstname = arr[0];
			  				lastname  = arr[arr.size()-1];
						}
					}
				}
				catch(exception ex) {}

				if ( lastname == null)
					lastname=email.fromAddress.substring(0,email.fromAddress.indexOf('@'));

	  		//Company name is domain...
	  		String co='unknown';
	  		try {
				co = email.fromAddress.substring(email.fromAddress.indexOf('@')+1);
	  		}
	  		catch (exception e){}
			Lead l = new Lead(lastname=lastname, firstname=firstname, RecordTypeId=LEAD_RTYPEID,
				email = email.fromAddress, Company=co);
			if (LEAD_QUEUE != null)	l.OwnerId = LEAD_QUEUE;    
			insert l;
			return l.id;
	  }
 
/**************************************************************************************************************/  
  /*
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
	EmailLib.CreateTestEmail(new emailReachInbound(),'testemail@dupont.com'); 				//test Single Exist Once Contact
    EmailLib.CreateTestEmail(new emailReachInbound(),'testdupemail@dupont.com');				//test Single Dup Contact
    EmailLib.CreateTestEmail(new emailReachInbound(),'aslkfglaskldslfkds@dupont.com');		//test non-existing Contact
    Test.stopTest();
    }
    
/*********************************************************************************************************	
**********************************************************************************************************/  


}
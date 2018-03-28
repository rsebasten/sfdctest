/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Utility Class for email related tasks.
********************************************************************************/

public class utilEmail {

	public static void batchOnFinish(Id jobId, LIST<Database.SaveResult> unsuccessfuls)
		{
			batchOnFinish(jobId,unsuccessfuls,true);
		}
	
	
	public static void batchOnFinish(Id jobId, LIST<Database.SaveResult> unsuccessfuls, boolean OnlyErrors ) {
		batchOnFinish(jobId,new DMLresults(unsuccessfuls).results,OnlyErrors);
	}
	public static void batchOnFinish(Id jobId, DMLresults unsuccessfuls, boolean OnlyErrors ) {
		batchOnFinish(jobId,unsuccessfuls.results,OnlyErrors);
	}
	public static void batchOnFinish(Id jobId, LIST<DMLresults.Result> unsuccessfuls, boolean OnlyErrors ) {

		AsyncApexJob a = [  Select ApexClass.Name, Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
	                        From AsyncApexJob where Id =:jobId
	                        ];
	        
	        if (a.NumberOfErrors>0 || unsuccessfuls.size()>0 || (!OnlyErrors)) {
	        
		        // Send an email to the Apex job's submitter notifying of job completion.
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {a.CreatedBy.Email};
		        mail.setToAddresses(toAddresses);
		        mail.setSubject(a.ApexClass.Name+': ' + a.Status);
		        
		        string s = 'The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.\n\n';
			
				//Add unsuccessful SaveResults to message
				if (unsuccessfuls.size()>0) {
					s+='\n\nUnsuccessful DML Results\n\n';
					for(DMLresults.Result r : unsuccessfuls) {
						if(r.record!=null)
							s+='Record: '+String.valueOf(r.record)+'\n';	
						s+='Error: '+String.valueOf(r.errors)+'\n\n';
					}
				}		
				mail.setPlainTextBody(s);
		        
		        //Workaround to run test class coverage when deliverability is off
				if (!Test.isRunningTest()) 
		        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	        }
	        
		}
		
		public static void sendDMLResults(LIST<Database.UpsertResult> results ) {

			if ( results.size()>0 ) {
	        
		        // Send an email to the Apex job's submitter notifying of job completion.
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        string email = [Select email from User where id=:UserInfo.getUserId()].email;
		        String[] toAddresses = new String[] {email};
		        mail.setToAddresses(toAddresses);
		        mail.setSubject('DML Results');

				string s = 'DML Results\n\n';
				for(database.UpsertResult r : results)
					s+=String.valueOf(r)+'\n';

				mail.setPlainTextBody(s);

				//Workaround to run test class coverage when deliverability is off
				if (!Test.isRunningTest()) 
		        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	        }
	        
		}
	
	///////////////////////////////////////////////////////////////////////////////////////
	// to: comma diliminated list of emails
	// subject: subject
	// msg: body
	//////////////////////////////////////////////////////////////////////////////////////
	public static LIST<Messaging.SendEmailResult> simpleEmail(string to ,string subject, string msg ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if  (to.indexOf(',')==-1)
        	mail.setToAddresses(new String[] { to });
        else
        	mail.setToAddresses(to.split(','));
        mail.setSubject(subject);
        mail.setPlainTextBody(msg);
        //Workaround to run test class coverage when deliverability is off
		if (!Test.isRunningTest()) 
       		return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       	else 
       		return null;
    }   
    

	
		
}
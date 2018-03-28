/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: CampaignDupEmails

	This report will show all CONTACT members where the email exists more than once across
	a single campaign if no parent is specified or across all sibling campaign is a parent is specified.
	LEAD MEMBERS are not included.

	without sharing - the need for without share is used for visiblity to 
 		duplicate emails within sibling campaigns (in using parent campaign)
 
 	the following fields are exposed:
	Campaign.Name, Campaign.Owning_Org__c, Campaign.Owner.Name, 
	Contact.Name,  Contact.email, Contact.Owner.Name, Contact.Account.Name
********************************************************************************/
public without sharing class ctrlCampaignDupEmails {

	string id 												{set; get;} 
	public string 	contextType								{set; get;} 
	public Campaign camp									{set; get;} 
	
	public ctrlCampaignDupEmails() {
		//contextType=()'text/html';
		id = ApexPages.currentPage().getParameters().get('id');
	}
	
	public LIST<CampaignMember> getDuplicateMembers() {

			LIST<CampaignMember> rtn;
			Campaign camp = [Select Id, ParentId, (Select femail__c from CampaignMembers) from Campaign Where id=:id];
			
			if (camp.parentId!=null) {
				//get all the duplicates in across parent campaign
				SET<string> dupEmails=getDuplicateEmailsInCampaign(camp.parentId);
				
				//filter the results by showing only the emails in curr campaign.
				SET<string> emailsInCampaign = new SET<string>();
				for (CampaignMember m : camp.CampaignMembers) {
					if (m.femail__c!=null) 
						emailsInCampaign.add(m.femail__c);
				}
				dupEmails.retainAll(emailsInCampaign);
				rtn=getMembersByEmail(dupEmails, camp.parentId);
			}
				
			else {
				//no parent campaign,  check direct children.
				rtn=getMembersWithDupEmails(id);
			}
	
			return rtn;

	}
	
	public PageReference toXSL() {
		PageReference c = Page.CampaignDupEmails;
		c.getParameters().put('ctype','application/vnd.ms-excel');
		c.getParameters().put('id',id);
		return c;	
	}
	
	public PageReference back() {
		return new PageReference('/'+id);	
	}
	
	/////////////////////////////////////////////////////////////////////////////////
	//helper methods
	/////////////////////////////////////////////////////////////////////////////////
	
		public static SET<string> getDuplicateEmailsInCampaign(string campId) {
		SET<string> rtn = new SET<string>(); //SET<email>
		/*for (sobject so : [
				SELECT Contact.email, count(Id) cnt FROM CampaignMember
				WHERE (Campaign.ParentId=:campId  OR Campaign.Id=:campId)
					AND Status!='Opt-Out' 
					AND Contact.email<>NULL
				GROUP BY Contact.email
				HAVING count(Id)>1]) {
					system.debug(so);
					rtn.add(string.valueOf(((AggregateResult)so).get('Email')));
				}*/
		//RA20121112
		AggregateResult[] dupEmailsinCamp = [SELECT Contact.email, count(Id) cnt FROM CampaignMember
        	WHERE (Campaign.ParentId=:campId  OR Campaign.Id=:campId)
          	AND Status!='Opt-Out' 
          	AND Contact.email<>NULL
        	GROUP BY Contact.email
        	HAVING count(Id)>1];
			
			for (AggregateResult ar : dupEmailsinCamp){
			rtn.add(string.valueOf(ar.get('Email')));       
			}//RA20121112
		return rtn;
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static LIST<CampaignMember> getMembersByEmail(SET<string> emails, string filterCampaignId) {
			emails.remove('');
			emails.remove(null);
			return [Select Id, Campaign.Name, Campaign.Owning_Org__c, Campaign.Owner.Name, 
						Contact.Name,  Contact.email, Contact.Owner.Name, Contact.Account.Name
				from CampaignMember where (Campaign.ParentId=:filterCampaignId OR Campaign.Id=:filterCampaignId)
					AND Contact.email in :emails 
					AND Status!='Opt-Out' 
				ORDER BY Contact.email];
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static LIST<CampaignMember> getMembersWithDupEmails(string campId) {
		return getMembersByEmail(getDuplicateEmailsInCampaign(campId),campId);
	}	
	
}
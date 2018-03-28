/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Smita Kadian
Email: Smita.Kadian@usa.dupont.com
Date: 28 July 2011
Description: Class called from the trigger 'trigLeadContactMapping' to associate
			 incoming lead to a contact and set the flag.
********************************************************************************/
public without sharing class LeadContactMapping{
	public static final Id RecordTypeIdLead	=Rtype.getIdByDevName('Lead','Level 2 DPP EMEA');
	public static void Lead_OnBeforeInsert(List<Lead> leadsList){
		for(Lead l:leadsList){
			if(l.LeadSource=='Website' && l.RecordTypeId==RecordTypeIdLead && l.Lead_Queue__c=='DPP Level 2 EMEA'){
				//Variable Declaration
				String leadOrigin=l.Origin_Name__c;
				String leadEmail=l.Email;
				List<Lead_Contact_Mapping__c> leadContactList = new List<Lead_Contact_Mapping__c>();
				List<Contact> contactList=new List<Contact>();
				Set<Id> campContactSet=new Set<Id>();
				List<String> campIDList=new List<String>();
				List<Contact> campMembContactList=new List<Contact>();
				List<String> contactRecordTypeList=new List<String>();
				List<String> contactProgramList=new List<String>();
				List<String> contactRegionList=new List<String>();
				//Searching for lead origin name in custom setting object
				leadContactList = [select Contact_Geo_Region__c,Contact_Program__c,Campaign_Id__c,Contact_Record_Type__c,Lead_Origin_Name__c from Lead_Contact_Mapping__c where Lead_Origin_Name__c=:leadOrigin limit 1];
				if(leadContactList.size()!=0){
					String query='Select RecordType.Name,Program__c,Region__c,email from contact';
					String andWhere=' where ';
					//Splitting the comma seperated campaign Id text into list of strings
					if(leadContactList[0].Campaign_Id__c!=null){
						campIDList=leadContactList[0].Campaign_Id__c.trim().split(',');
						for(Integer i=0;i<campIDList.size();i++)campIDList[i]=campIDList[i].trim();
					}
					//Search for campaign members(Type:Contact)under the specified campaign ID with the same email id as that of the lead's
					campMembContactList=[select id from contact where email=:leadEmail and id IN (Select contactId from campaignMember where CampaignId IN :campIDList and contact.email=:leadEmail)];
					for(Contact con:campMembContactList)
					campContactSet.add(con.id);
					if(campMembContactList.size()==1){
						//if single contact found then assign it as the 'Related Contact' for the Lead and set the flag 'Related Contact Status'
						l.Related_Contact_Status__c='Completed-Single Contact';
						l.Related_Contact__c=campMembContactList[0].Id;
					}
					else if(campMembContactList.size()>1 || campMembContactList.size()==0 ){
						//In case of multiple contacts filter further on the corresponding fields for Contact in the custom setting
						if(leadContactList[0].Contact_Geo_Region__c!=null){
							contactRegionList=leadContactList[0].Contact_Geo_Region__c.trim().split(',');
							for(Integer i=0;i<contactRegionList.size();i++)contactRegionList[i]=contactRegionList[i].trim();
							query=query+andWhere+' Region__c IN  :contactRegionList  ';
							andWhere=' and ';
						}
						if(leadContactList[0].Contact_Program__c!=null){
							contactProgramList=leadContactList[0].Contact_Program__c.trim().split(',');
							for(Integer i=0;i<contactProgramList.size();i++)contactProgramList[i]=contactProgramList[i].trim();
							query=query+andWhere+' Program__c IN  :contactProgramList  ';
							andWhere=' and ';
						}
						if(leadContactList[0].Contact_Record_Type__c!=null){
							contactRecordTypeList=leadContactList[0].Contact_Record_Type__c.trim().split(',');
							for(Integer i=0;i<contactRecordTypeList.size();i++)contactRecordTypeList[i]=contactRecordTypeList[i].trim();
							query=query+andWhere+' RecordType.Name IN :contactRecordTypeList  ';
							andWhere=' and ';
						}
						if(campMembContactList.size()==0){
							//If no campaign members found, query the database irrespective of the campaign ID
							query=query+' and email=:leadEmail  limit 2  ';
							contactList=database.query(query);
						}
						else{
							contactList=database.query(query+' and email=:leadEmail and id IN :campContactSet  limit 2  ');
							if(contactList.size()==0){
								query=query+' and email=:leadEmail  limit 2  ';
								contactList=database.query(query);
							}
						}
						//Based on the no. of contacts found with same email id set the flag 'Related Contact Status' and field 'Related Contact'
						if(contactList.size()==1){
							l.Related_Contact_Status__c='Completed-Single Contact';
							l.Related_Contact__c=contactList[0].Id;
						}
						else if(contactList.size()>1 || contactList.size()==0){
							l.Related_Contact__c=null;
							l.Related_Contact_Status__c=null;
							if(contactList.size()>1)
								l.Related_Contact_Status__c='In Progress-Multiple Contacts';
							else if(contactList.size()==0)
								l.Related_Contact_Status__c='In Progress-No Contact';
						}
					}
				}
			}
		}
	}
}
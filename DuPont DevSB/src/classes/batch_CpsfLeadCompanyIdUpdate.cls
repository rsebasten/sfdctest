/*************************************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Description:    Updating Dodge_Company_Id__c field in Lead object for existing records of CPSF project one time activity


***************************************************************************************************/

global class batch_CpsfLeadCompanyIdUpdate implements Database.Batchable<sObject>
{

  public List<Lead> lstLead= new List<Lead>();  
  // Fetching all the existing Lead of CPSF project  
  global Database.QueryLocator start(Database.BatchableContext BC)
  {     
     string startQuery = 'SELECT id, Legacy_Lead_ID__c,Name,Dodge_Company_Id__c FROM Lead where Legacy_Lead_ID__c like \'CPSF_%\'';     
     return Database.getQueryLocator(startQuery);  
  }  

  global void execute(Database.BatchableContext BC, List<Lead> lstLead)
  {

    List<Lead> update_leadlst= new List<Lead>();  

    for(Lead lead1: lstLead)
    {
        // updating the Dodge_Company_Id__c field from Legacy_Lead_ID__c present in Lead
         if(lead1.Legacy_Lead_ID__c!=null)
            {
                String CompanyId = lead1.Legacy_Lead_ID__c.substringAfter('^');
                String CompanyId1 = CompanyId.substringBefore('^');
                lead1.Dodge_Company_Id__c=CompanyId1;
            }


          update_leadlst.add(lead1);
    }  
    if(update_leadlst.size()>0)
    {
        update update_leadlst;
    }
  }
    global void finish(Database.BatchableContext BC){}
}
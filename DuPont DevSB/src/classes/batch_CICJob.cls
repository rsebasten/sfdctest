/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/10/2016
Description:    Class to read xml file with batch size 1 and creating External Initiative and Lead records
                In finish method of batch_CICJob we are calling another batch "batch_CIC_EIUpdate" to update ExternalInitiavieParent  when Project Level is "Sub" on  External Initiative

***************************************************************************************************/
global class batch_CICJob implements Schedulable,Database.Batchable<sObject>,Database.AllowsCallouts  
{
    public static final Integer batchJobSize=1;
    public static final Integer EIbatchJobSize = Integer.valueOf(Label.CIC_Batch_Size);   
    // We are scheduling the batch with size one
    global void execute(SchedulableContext SC) 
    {
        Id batchJobId = Database.executeBatch(new batch_CICJob(), batchJobSize);
    }
    //We are fetching the CIC End Point URL from Custom MetaData Type
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
       // String query  = 'select  CIC_End_Point__c from Custom setting CIC_End_Points__c ';
       String query ='select CIC_End_Point__c from CIC_End_Points__c';
        return Database.getQueryLocator(query);   
    }
    // We are sending the URL with size 1 in class "cicRestClass" to parse the XML
    public void execute(Database.BatchableContext info, List<CIC_End_Points__c> urlValues)
    {        
        try
        {
            ctrlCIC_Parse.cic_related_Lead=true;
            CIC_End_Points__c urlvalue= urlValues[0];
            ctrlCIC_Parse cicRestClass=new ctrlCIC_Parse();
            cicRestClass.parseCICXML(urlvalue);
            CIC_End_Points__c CIC_End_Point = new CIC_End_Points__c();
			CIC_End_Point =[
							select CIC_End_Point__c,	Job_Time_Stamp__c 
							from CIC_End_Points__c 
							where CIC_End_Point__c=:urlvalue.CIC_End_Point__c limit 1
							];
			CIC_End_Point.Job_Time_Stamp__c=system.now();
			update CIC_End_Point;
        }
        catch(exception e)
		{         
			 ExceptionHandlingClass_CIC_CP.autoCreatedpsException_xml(e,'schedul_Job_Url','Failed_xml','CIC'); 
		}
    }
    // Calling another batch "batch_CIC_EIUpdate" to update ExternalInitiativeParent for Project Level "Sub" on External Initiative
    public void finish(Database.BatchableContext info) 
    {
        AsyncApexJob a = [Select Id, Status,CreatedDate   from AsyncApexJob where Id = :info.getJobId() limit 1]; 
        list<CIC_End_Points__c> lstCIC_End_Point = new list<CIC_End_Points__c>();
        lstCIC_End_Point =[
							select CIC_End_Point__c,Job_Time_Stamp__c 
							from CIC_End_Points__c 
							where (Job_Time_Stamp__c=null OR Job_Time_Stamp__c < :a.CreatedDate)
							];
 
        // Fetch all the xml which are not success
        String str = '';
        if(lstCIC_End_Point!=null  && lstCIC_End_Point.size()>0)
        {
        for(CIC_End_Points__c failedurl : lstCIC_End_Point)
            {   
               
				str = str+failedurl.CIC_End_Point__c+ '\r\n';
            }
        ExceptionHandlingClass_CIC_CP.autoCreatedpsException_SchJob_xml(str,'schedul_Job_Url','Failed_xml','CIC'); 
        }
        
        Database.executeBatch(new batch_CIC_EIUpdate(),EIbatchJobSize);
    }   
}
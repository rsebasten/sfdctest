/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Description:    Upsert new External Initiative in SFDC to update the status of project after reading xml for CIC Project 
                For Initial Load reading the xml file from Document by creating a folder name as CIC_Expire_Project
                For Daily basis fetching the URL from custom setting "DPS_CIC_Expire_Project_End_Point__c"   
Date:           12-Dec-2017

***************************************************************************************************/

global class Batch_CIC_ProjectExpire implements Database.Batchable<sObject>,Schedulable,Database.AllowsCallouts
{

    //If true will pass while executing batch class than system will fetch the xml file from Document else system will read xml file from CIC system

    String foldername='CIC_Expire_Project';    
    boolean Folder_Name;
    global Batch_CIC_ProjectExpire(boolean name)
    {
        Folder_Name = name;
    }
    global Batch_CIC_ProjectExpire()
    {
        Folder_Name = false;
    }
    global database.queryLocator start(Database.BatchableContext BC)
    {
        if(Folder_Name==false)
        {
     
            String query ='select id,CIC_Expire_Project_End_Point__c from DPS_CIC_Expire_Project_End_Point__c';
            return Database.getQueryLocator(query);
        }
           
        else
        {
         
            return Database.getQueryLocator([select id,name,body from document WHERE Folder.Name=:foldername]);
        }
    }
    // We are sending the URL with size 1 in class "ctrlCICExpireProject_Parse" to parse the XML
    public void execute(Database.BatchableContext info, List<sobject> urlList)
    {
         system.debug('>>>EXception>>>>>>> urlList'+urlList);
        // Initial Load code will execute and read the xml from Document Folder name 'CIC_Expire_Project'
        if(Folder_Name==true)
        {
            List<Document> docnameList= urlList;
            try
            {
                String docname= docnameList[0].body.toString();
                ctrlCICExpireProject_Parse.parseResponseDom(docname);
            }
            catch(exception e)
            {
                system.debug('>>>EXception>>>>>>>'+e);
                system.debug('>>>document name >>>>>>>'+docnameList[0].name);
                ExceptionHandlingClass_CIC_CP.autoCreatedpsException_xml(e,'Upload Via Documents',docnameList[0].name,'CIC');  
            }
        }else{
            // Daily scheduled batch code will execute and read the xml from Custom setting name 'DPS_CIC_Expire_Project_End_Point__c
            List<DPS_CIC_Expire_Project_End_Point__c> urlvalues= urlList;
            try
            {
                DPS_CIC_Expire_Project_End_Point__c urlvalue= urlValues[0];
                ctrlCICExpireProject_Parse cicExpireProjectRestClass=new ctrlCICExpireProject_Parse();
                cicExpireProjectRestClass.parseCICExpireXML(urlvalue);
                DPS_CIC_Expire_Project_End_Point__c CIC_Expire_Project_End_Point = new DPS_CIC_Expire_Project_End_Point__c();
                CIC_Expire_Project_End_Point =  [
                                                select CIC_Expire_Project_Job_Time_Stamp__c,  CIC_Expire_Project_End_Point__c
                                                from DPS_CIC_Expire_Project_End_Point__c
                                                where 
                                                CIC_Expire_Project_End_Point__c=:urlvalue.CIC_Expire_Project_End_Point__c limit 1
                                                ];
                CIC_Expire_Project_End_Point.CIC_Expire_Project_Job_Time_Stamp__c=system.now();
                // Updating the end point URL after successful execution of xml
                update CIC_Expire_Project_End_Point;
            }
            catch(exception e)
            {         
                ExceptionHandlingClass_CIC_CP.autoCreatedpsException_xml(e,'schedul_Job_Url','Failed_xml','CIC'); 
            }
        }  
    }

    public void finish(Database.BatchableContext info) 
    {
        if(Folder_Name==false)
        {
            AsyncApexJob a = [Select Id, Status,CreatedDate   from AsyncApexJob where Id = :info.getJobId() limit 1]; 
            list<DPS_CIC_Expire_Project_End_Point__c> lstCICExpireProject_End_Point = new list<DPS_CIC_Expire_Project_End_Point__c>();
            // Fetch all the xml which are not success
            lstCICExpireProject_End_Point = [
                                            select CIC_Expire_Project_Job_Time_Stamp__c,  CIC_Expire_Project_End_Point__c
                                            from DPS_CIC_Expire_Project_End_Point__c 
                                            where 
                                            (CIC_Expire_Project_Job_Time_Stamp__c=null OR CIC_Expire_Project_Job_Time_Stamp__c< :a.CreatedDate)
                                            ];
            String str = '';
            if(lstCICExpireProject_End_Point!=null  && lstCICExpireProject_End_Point.size()>0)
            {
                for(DPS_CIC_Expire_Project_End_Point__c failedurl : lstCICExpireProject_End_Point)
                {   
                    str = str+failedurl.CIC_Expire_Project_End_Point__c+ '\r\n';
                }
                ExceptionHandlingClass_CIC_CP.autoCreatedpsException_SchJob_xml(str,'schedul_Job_Url','Failed_xml','CIC-Expire-Project'); 
            }
         }   
    }   
    // We are scheduling the batch with size one
    global void execute(SchedulableContext SC) 
    {
        Id batchJobId = Database.executeBatch(new Batch_CIC_ProjectExpire(), 1);
    }
}
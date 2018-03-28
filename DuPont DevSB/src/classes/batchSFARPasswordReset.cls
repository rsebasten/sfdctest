/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Kokkiripalli Vaishnavi
Email: kokkiripalli.vaishnavi@tcs.com
Description:  Batch Apex for restting password once SFAR is created with record type SFAR Password Reset
V1.1 <SA20170714> : Modified the code to send email notification only in case of errors or exceptions occured during the batch process.
<Shubham20171411> : Modified logic to skip password requests for sandboxes from batch job execution.
<Shubham20171411> : Modified the code to process only 100 SFAR's during single batch, if the SFAR count is more than 100 batch is called again
 ********************************************************************************/
global class batchSFARPasswordReset implements Database.Batchable<sObject> , Database.Stateful// ,Schedulable 
{
    private final String Query;
     private integer CountofSFAR; //<Shubham20171411>Start
    // UserPasswordResetSettings__c is custom setting for all static details for deactivating user
    /*KV06222016*/ UserPasswordResetSettings__c uprs= UserPasswordResetSettings__c.getall().values();
    //<SA20170714>Start: Modified the code to send email notifications only whenever errors are occured. 
    private boolean notifyByMail= false;
    string errormsg = '';
    private map<Id,SFDC_Access_Request__c> mapSFARs = new map<Id,SFDC_Access_Request__c>();
    //<SA20170714>End
    
    ID SFARPasswordResetRecTypeId = RType.getIdByDevName('SFDC_Access_Request__c','SFAR - Password Reset');
    global batchSFARPasswordReset()
    {
        /*KV06222016*/UserPasswordResetSettings__c UserPasswordResetSettings= UserPasswordResetSettings__c.getValues('UserPassswordSettings');
        /*KV06222016*/ //Query='Select user__c,user__r.name,user__r.AccessType__c,Request_Details__c from sfdc_access_request__c where  Status__c = ' +'\'' +uprs.status__c+ '\'  AND (user__r.AccessType__c NOT IN ('+uprs.Access_Type__c+')) AND SFDC_Instance__c =' +'\'' +uprs.instance__c+ '\' AND recordTypeId =' +'\'' +SFARPasswordResetRecTypeId+ '\'';
        CountofSFAR=[Select Count() from sfdc_access_request__c where  Status__c =  :uprs.status__c AND (user__r.AccessType__c NOT IN (:uprs.Access_Type__c)) AND SFDC_Instance__c = :uprs.instance__c AND recordTypeId = :SFARPasswordResetRecTypeId  ]; //Shubham20171411
        Query='Select Id,Name,user__c,user__r.name,user__r.AccessType__c,Request_Details__c from sfdc_access_request__c where  Status__c = ' +'\'' +uprs.status__c+ '\'  AND (user__r.AccessType__c NOT IN ('+uprs.Access_Type__c+')) AND SFDC_Instance__c =' +'\'' +uprs.instance__c+ '\' AND recordTypeId =' +'\'' +SFARPasswordResetRecTypeId+ '\' Limit 100'; //Shubham20171411<End>
        system.debug('Query fomation&&&'+Query);
        System.debug('Count is'+CountofSFAR); //Shubham20171411
    }
   //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<sObject>scope)
    {
        LIST<SFDC_Access_Request__c> lstSFARs = new LIST<SFDC_Access_Request__c>();
        Set<Id> lstUserIds = new Set<Id>();
        system.debug('inside execute***');
        for(Sobject s : scope)
        {                      
            SFDC_Access_Request__c a = (SFDC_Access_Request__c)s;
            
            if(String.isEmpty(a.Request_Details__c) || String.isBlank(a.Request_Details__c)){
                lstSFARs.add(a);
                lstUserIds.add(a.User__c); 
            }
             //<Shubham20171411> : Start-> Modified logic to skip password requests for sandboxes from batch job execution.
            else{
                String strinstance = uprs.Instances_to_skip_Password_reset__c ; 
                List<string> lstInstances = String.isNotBlank(strinstance)? strinstance.split(','): new list<string>{strinstance};
                boolean isfound = false; 
                for(string instance : lstInstances){
                    if(a.Request_Details__c.containsignorecase(instance)){
                        isfound = true;  
                        break;              
                                            
                    } 
                }
                if(!isfound){
                        lstSFARs.add(a);
                        lstUserIds.add(a.User__c);
                                                
                    }
            }
            
            //<Shubham20171411> : End
        }       
        system.debug('SFAR size'+lstSFARs.size() );
        List<User> lstActiveUsers =[select Id,name from User where Id =: lstUserIds and isActive=true];
        Database.SaveResult[] results; //<SA20170714>

        if(!lstActiveUsers.isEmpty()){
            system.debug('User name^^^ '+lstActiveUsers[0].name);
            for(User us : lstActiveUsers){
                System.resetPassword(us.Id,true);
                system.debug('inside for user ***' +us.id );
            }                
        }
        
        
        
        for(SFDC_Access_Request__c updatesfars : lstSFARs)
        {
            system.debug('inside update ***' +updatesfars.User__r.Name);
            updatesfars.DiscussionAndUpdates__c = 'Password Reset completed for the User : '+updatesfars.User__r.Name;
            updatesfars.Date_Accepted__c = system.now();
            updatesfars.Date_Closed__c = system.Today();
            updatesfars.Status__c = 'Completed';
            mapSFARs.put(updatesfars.Id,updatesfars); //<SA20170714>
        }
        //<SA20170714> Start: Modified the code to send email notifications only whenever errors are occured.
        if(!lstSFARs.isEmpty()){
            //update lstSFARs;
            results = Database.Update(mapSFARs.values(), false);
             list<Id> successIds = new list<Id>();
             string strErrorStmt  ='';
             for (Integer i = 0; i < lstSFARs.size(); i++) {
                 Database.SaveResult s = results[i];
                 system.debug('DML result is&&&'+s);
                 SFDC_Access_Request__c orignRecord = lstSFARs[i];
                 if (!s.isSuccess()) {
                        strErrorStmt = ' and below are some failures :\n';
                        notifyByMail = true;
                        Database.Error error = s.getErrors().get(0);
                        errormsg+= orignRecord.name+' - '+error.getMessage()+'\n';
                                            
                  }
                 else{
                    successIds.add(s.getId());
                    }
                     
                 
                 
                 
              } 
              errormsg = 'Password reset batch processed '+successIds.size()+' SFARs Successfully'+strErrorStmt+errormsg;
        } 
        //<SA20170714> End
}
   // Finish Method
    global void finish(Database.BatchableContext BC)
    {
        //Send an email to the User after  batch completes
          //<Shubham20171411>Start:Added the below code to execute the batch,if the SFAR Count is greater than 100 
          if(CountofSFAR>100 && !(notifyByMail))
        {
            Database.executeBatch(new batchSFARPasswordReset());
        }
        //<Shubham20171411>End
        // <SA20170714> Start: Modified the code to send email notifications only whenever errors are occured.
        if(notifyByMail){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {uprs.Email_Recipient__c};
            mail.setToAddresses(toAddresses);
            mail.setSubject(uprs.instance__c+' - Batch SFAR Password Reset job is done');
            mail.setPlainTextBody(errormsg);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('inside mail***');
        }
        // <SA20170714> End
    }
    
    
}
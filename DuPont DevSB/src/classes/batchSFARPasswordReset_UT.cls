/*************************************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Kokkiripalli Vaishnavi
Email: kokkiripalli.vaishnavi@tcs.com
Description:  Test calss for batchSFARPasswordReset 
 ********************************************************************************/
@isTest 
public class batchSFARPasswordReset_UT {
static testMethod void testbatchSFARPasswordReset(){
//public static Profile p;
       // public static User user1,user2;  
      //  public static SFDC_Access_Request__c sfar,sfar2;
        // UserPasswordResetSettings__c is custom setting for all static details for deactivating user
          
     
            Profile   p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            user user1 = new User(   
            Username = 'testName1_corp@abc.com',
            LastName = 'name1',
            Alias = 'TCS COO',
            CommunityNickname = 'test1',
            TimeZoneSidKey = 'America/Chicago',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.id,
            LanguageLocaleKey = 'en_US',
            email = 'testName1@abc.com',
            isActive = true,
            AccessType__c = 'TEST');
            insert user1;
             
            user user2 = new User(); 
            user2.Username = 'testName2_corp@abc.com';
            user2.LastName = 'name2';
            user2.Alias = 'kvai';
            user2.CommunityNickname = 'test2';
            user2.TimeZoneSidKey = 'America/Chicago';
            user2.LocaleSidKey = 'en_US';
            user2.EmailEncodingKey = 'UTF-8';
            user2.ProfileId = p.id;
            user2.LanguageLocaleKey = 'en_US';
            user2.email = 'testName2@abc.com';
            user2.isActive = true;
            user2.AccessType__c = 'Dupont';
            insert user2;
    
                 /*KV06222016 START*/ 
                 // UserPasswordResetSettings__c is custom setting for all static details for deactivating user
                 UserPasswordResetSettings__c uprs = new UserPasswordResetSettings__c();
                 uprs.instance__c='CRM';
                 uprs.status__c='Not Started';  
                 uprs.Name='UserPasswordSettings';
           uprs.Email_Recipient__c = 'test123@email.com';
    /*SA20171012 START*/
     uprs.Instances_to_skip_Password_reset__c = 'QA';
    /*SA20171012 END*/
                 insert uprs; 
                 /*KV06222016 END*/
            String rdId1 = [Select Id From RecordType Where SobjectType = 'SFDC_Access_Request__c' and Name = 'SFAR - Password Reset'].Id;
           SFDC_Access_Request__c sfar = new SFDC_Access_Request__c();     
            List<SFDC_Access_Request__c> listSFAR = new List<SFDC_Access_Request__c>(); //<SA20170714>
            sfar.Ownerid = user2.id;
            sfar.Key_User__c = user2.id;
            sfar.User__c = user2.id;
            sfar.SFDC_Instance__c = 'CRM';
            sfar.Status__c = 'Not Started';
            sfar.Program__c = 'BI';
            sfar.RecordTypeId = rdId1;
            sfar.User_Access_Type__c = 'Test';            
            sfar.Type__c = 'Security & Permissions';
            sfar.Subtype__c = 'Reset Password';
            sfar.Request_Details__c ='Test';
            listSFAR.add(sfar); 
            
           SFDC_Access_Request__c sfar2 = new SFDC_Access_Request__c();       
            sfar2.Ownerid = user1.id;
            sfar2.Key_User__c = user1.id;
            sfar2.User__c = user1.id;
            sfar2.SFDC_Instance__c = 'CRM';
            sfar2.Status__c = 'Not Started';
            sfar2.Program__c = 'BI';
            sfar2.RecordTypeId = rdId1;
            sfar2.User_Access_Type__c = 'DuPont';            
            sfar2.Type__c = 'Security & Permissions';
            sfar2.Subtype__c = 'Reset Password';
            sfar2.Request_Details__c ='';
            listSFAR.add(sfar2);
            insert listSFAR; //<SA20170714>
        
                       
       
         Test.StartTest();
    batchSFARPasswordReset inst = new batchSFARPasswordReset();
   // Database.executeBatch(inst); 
        
        // <Shubham20171411>
       Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<sfdc_access_request__c> cont=[Select Id,Name,user__c,user__r.name,user__r.AccessType__c,Request_Details__c from sfdc_access_request__c where  Status__c =:uprs.status__c and user__r.AccessType__c NOT IN (:uprs.Access_Type__c) AND SFDC_Instance__c =:uprs.instance__c AND recordTypeId =:rdId1 limit 2 ];
        
        QL=inst.start(BC);
     // In main Class, one condition is send email notifications only whenever errors are occured. So we put Epass-Id below way to created error to cover that part of code.
        cont[0].EPass_ID__c='SAADAVFAVFWEQFUQWGFKKKVQWEJHFVKQWEJF21E32';
        
        inst.execute(BC,cont);
        inst.finish(BC);
      system.debug(sfar);
      system.runas(user1){
            //<Shubham20171411> End
             
        }       
        Test.stopTest();
        }
  

   }
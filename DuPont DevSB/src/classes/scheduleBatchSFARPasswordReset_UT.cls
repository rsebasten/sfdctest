/*************************************************************************************************
Copyright Â© 2016 DuPont. All rights reserved.
Author: Kokkiripalli Vaishnavi
Email: kokkiripalli.vaishnavi@tcs.com
Description: Test class for scheduling Batch Apex for SFAR Password Reset Class
 ********************************************************************************/
@isTest
public class scheduleBatchSFARPasswordReset_UT {
    static testMethod void testschedule() {    
        Test.StartTest();
        
        //KT [11072017]: To create custom setting UserPasswordResetSettings__c data
        UserPasswordResetSettings__c cs = new UserPasswordResetSettings__c(
            Name = 'UserPasswordSettings',
            Access_Type__c = '\'Static\',\'Integrator\'',
            Email_Recipient__c = 'dupontsfdc.crmsupport@tcs.com.test',
            instance__c = 'CRM',
         // Instances_to_skip_Password_reset__c = 'QA,UAT,Sandbox',
            status__c = 'Not Started'
        );
        insert cs;
        
        scheduleBatchSFARPasswordReset shcheduledClass = new scheduleBatchSFARPasswordReset();
        
        String sch = '0 0 0 15 3 ? 2022';
        system.schedule('Test batch schedule', sch, shcheduledClass); 
        Test.stopTest();
    }


}
/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UT for Controller: ctrlPasswordReset
********************************************************************************/
@isTest
private class ctrlPasswordReset_UT {

    static testMethod void test_ctrlPasswordReset() {
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole r= [Select id from UserRole where Name='PS CRM' limit 1];      
        User usr = new User(LastName='TESTER',key_User__c=true,UserRoleId=r.Id,ProfileId=p.Id,Alias='tt',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='test@test.com' ,UserName='UTPasswordReset@test.com', EPass_ID__c='NA0000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
        insert usr;
        system.debug('++usr++'+usr);
        system.debug('++r++'+r);
        System.runAs(usr){
        Test.startTest();
        PageReference pageRef = Page.PasswordReset;
        Test.setCurrentPage(pageRef); 
        ctrlPasswordReset ctrl = new ctrlPasswordReset();
        ctrl.getKeyUsers();
        ctrl.sfarName = 'test';
        ctrl.userIsActive = true;
        ctrl.lastLogin = system.today();
        //ctrl.autoReset =true;
        ctrlPasswordReset.createSFAR_PasswordReset(usr);
        ctrl.un='UT@test.com';
        ctrl.epass='NA0000';
        ctrl.resetPassword();
        Test.stopTest();
        }
    }  

}
/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  test class for
        trigUserAddHistory
        trigUserHistoryReadOnly
 TES20111206: bug fix to be sure UserRole.PortalType does not conflict with Profile.UserType for test data
********************************************************************************/
@isTest
private class UserHistory_UT {

    static testMethod void test_UserHistory() {
        LIST<Profile> profiles = [Select Id from Profile where UserType='Standard' LIMIT 2];
        LIST<UserRole> roles = [Select Id from UserRole where PortalType='none' LIMIT 2 ];
        User u1 = new User(firstname='tom', lastname='tester',username='tomtester2@qw3ddd.com',email='tomtester@3ddd.com',
            Alias='tester', EmailEncodingKey='UTF-8', TimeZoneSidKey='America/New_York', LanguageLocaleKey='en_US', ProfileId=profiles[0].id, LocaleSidKey='en_US',
            managerId=null, UserRoleId=roles[0].id
            );
        insert u1;
        
        User u2 = new User(firstname='manager', lastname='tester',username='managertester2@qw3ddd.com',email='managertester@3ddd.com',
            Alias='mtester', EmailEncodingKey='UTF-8', TimeZoneSidKey='America/New_York', LanguageLocaleKey='en_US', ProfileId=profiles[1].id, LocaleSidKey='en_US');
        insert u2;      
        
        u1.managerId=u2.id;
        u1.profileId=profiles[1].id;
        u1.UserRoleId=roles[1].id;
        update u1;
        
        u1.managerId=null;
        u1.profileId=profiles[1].id;
        u1.UserRoleId=null;
        update u1;
    
        
    LIST<UserHistory__c> hist = new LIST<UserHistory__c>([
        Select Name from UserHistory__c where User__c =: u1.id]);
                        
        //trigUserHistoryReadOnly test (expect failures)
        if (hist.size()>0) {
            try { update hist[0]; } catch(Exception ex) {}
            try { delete hist[0]; } catch(Exception ex) {}
            }
    }
    //<20170119>Merge&Spin: Added method for coverage of "trigUserHistoryReadOnly" trigger
    static testMethod void test_trigUserHistoryReadOnly(){
        LIST<UserHistory__c> userHistoryList = new LIST<UserHistory__c>();
        UserHistory__c userHistoryTest = new UserHistory__c(name='Test',user__c=userinfo.getuserid());
        userHistoryList.add(userHistoryTest);        
        if (userHistoryList.size()>0) {
            insert userHistoryList;
            try { update userHistoryList[0]; } 
            catch(Exception ex) {
                system.debug(ex.getMessage());
                Boolean expectedExceptionThrown = ex.getMessage().contains('User History cannot be modified or deleted') ? true : false; 
                System.assertEquals(expectedExceptionThrown, true);
            }                        
        }
    }
}
/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class tests the CtrlBAConfigTriggerHandler
 ********************************************************************************/
@isTest
private class CtrlBAConfigTriggerHandler_UT {
    public static Profile p;
    public static User user1,user2;
    public static BA_Configuration__c  bac;
    public static List<BA_Configuration__c> updateBacList= new List<BA_Configuration__c>();
    public static BA_Push_Notification_Log__c push;
    public static List<BAC_Team_Member__c> listBTM = new List<BAC_Team_Member__c>();
    public static BAC_Team_Member__c btm1;
    static testMethod void testDoPost() {
    
    p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    List<User> userList = new List<User>();
    user1 = new User();     
    user1.Username = 'testName1@abc.com';
    user1.LastName = 'name';
    user1.Alias = 'tn';
    user1.CommunityNickname = 'test';
    user1.TimeZoneSidKey = 'America/Chicago';
    user1.LocaleSidKey = 'en_US';
    user1.EmailEncodingKey = 'UTF-8';
    user1.ProfileId = p.id;
    user1.LanguageLocaleKey = 'en_US';
    user1.email = 'testName1@abc.com';
    user1.isActive = true;
    userList.add(user1);
    
    user2 = new User();
    user2.Username = 'testName2@abc.com';
    user2.LastName = 'name2';
    user2.Alias = 'tn2';
    user2.CommunityNickname = 'test2';
    user2.TimeZoneSidKey = 'America/Chicago';
    user2.LocaleSidKey = 'en_US';
    user2.EmailEncodingKey = 'UTF-8';
    user2.ProfileId = p.id;
    user2.LanguageLocaleKey = 'en_US';
    user2.email = 'testName2@abc.com';
    user2.isActive = true;
    
    userList.add(user2);
    insert userList;
    bac= new BA_Configuration__c();
    bac.name='test';     
    bac.Body_Armor_Configuration_ID__c='ABCD123456';
    bac.Active__c = true; 
    bac.Status__c = 'Tender in progress';
    bac.BAC_Progress__c = 'New Campaigns';
    bac.Sensitive_Destination_Committee_Approv__c = true;
    bac.ownerid = user1.id;
    insert bac;
    bac.Status__c = 'Tender Bid Submissions';
    bac.BAC_Progress__c = 'Specifications Generated';
    update bac;
    bac.Status__c = 'Solutions Evaluation';
    bac.BAC_Progress__c = 'Solutioning Started';
    update bac;
    bac.Status__c = 'Tender Contract Award';
    bac.BAC_Progress__c = 'Solutions Created';
    update bac;
    bac.Status__c = 'Campaign Closed';
    bac.BAC_Progress__c = 'Commercials Generated';
    update bac;
    
    push = new BA_Push_Notification_Log__c();
    push.BA_Configuration__c = bac.id;
    push.IsNotificationRead__c = true;
    push.Push_Notification_Receiver__c = user1.id;
    insert push;
    
    btm1 = new BAC_Team_Member__c();
    btm1.Active__c = true;
    btm1.BA_Configuration__c = bac.id;
    btm1.Team_Member_Name__c = user1.id;
    listBTM.add(btm1);
    BAC_Team_Member__c btm2 = new BAC_Team_Member__c();
    btm2.Active__c = true;
    btm2.BA_Configuration__c = bac.id;
    btm2.Team_Member_Name__c = user2.id;
    listBTM.add(btm2);    
    insert listBTM;       
    }
    
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData = true)  
private class ctrlCreateCase_UT {

Public static testMethod void ctrlCreateCaseMethod(){

List<User> UserList = new List<User>();
Profile p =[SELECT Id FROM Profile where name='DPT-IPP EMEA Value Chain Service Distributors' limit 1];
UserRole r=[SELECT Id FROM UserRole WHERE Name='PS CRM' limit 1]; 
Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
User SysUser= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES',EPass_ID__c='TestS',
        profileid = p1.id,UserRoleId=r.id,
        Username='User3@dupont.com.test4', LastName='user',
        CommunityNickname='TestingCommunity2', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
insert SysUser;  
System.RunAs(SysUser){    
Account a = new Account(Name='DPT-IPP Test Portal Account');
insert a;
Contact c = new Contact(AccountId=a.id,LastName='PortalUser');
insert c;


User PortalUser= new User(Firstname='Test',Alias='PUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES',EPass_ID__c='TestP',
        profileid = p.id,
        Username='User1@dupont.com.test4', LastName='PortalUser',
        CommunityNickname='TestingCommunity', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',contactId=c.id);
User InternalUser= new User(Firstname='Test',Alias='IUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES',EPass_ID__c='TestI',
        profileid = p1.id,UserRoleId=r.id,
        Username='User2@dupont.com.test4', LastName='PortalUser',
        CommunityNickname='TestingCommunity1', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        UserList.add(PortalUser);
        UserList.add(InternalUser);
        insert UserList;
        System.runAs(PortalUser){
        ctrlCreateCase crcase = new ctrlCreateCase();
        crcase.redirect();
        }
        System.runAs(InternalUser){
        ctrlCreateCase crcase1 = new ctrlCreateCase();
        crcase1.redirect();
        }
        }
}
}
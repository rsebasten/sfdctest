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
private class ctrlDPTIPPLogos_UT {

Public static testMethod void ctrlDPTIPPLogosMethood (){

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
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',contactId=c.id,User_Region__c='North America');

        insert PortalUser;
Group g= [Select Id,Name from Group where Type='regular' and Name='DPT-IPP NA Community Distributors'];
GroupMember gm = new GRoupMember(GroupId=g.id,UserOrGroupId=PortalUser.id);
insert gm;
    
        ctrlDPTIPPLogos c1= new ctrlDPTIPPLogos();
        c1.SelectedLogo = 'DPP_DuPontOvalLogo_Black_1';
        c1.Extension= 'JPG';
        c1.downloadLogo();
        
        System.runAs(PortalUser){
        ctrlDPTIPPLogos c2= new ctrlDPTIPPLogos();
        }
        
        Id RecordTypeId = [Select Id, Name from RecordType where RecordType.Name='Partner Qualification'].Id;
        Qualification__c q1= new Qualification__c(Account_Name__c =a.id,Type__c = 'Brand License',RecordTypeId=RecordTypeId,Owning_Org__c = 'DPP');
        insert q1;
        
        System.runAs(PortalUser){
        ctrlDPTIPPLogos c3= new ctrlDPTIPPLogos();
        c3.IsPortal=true;
        }
        
        q1.Owning_Org__c = 'DPT';
        q1.Program__c ='DPT-IPP';
        update q1;
        
        System.runAs(PortalUser){
        ctrlDPTIPPLogos c5= new ctrlDPTIPPLogos();
        c5.IsPortal=true;
        }
        
        q1.DuPont_Agreement_Verified__c = TRUE;
        q1.Qualification_Date__c=date.today();
        update q1;
        
        System.runAs(PortalUser){
        ctrlDPTIPPLogos c4= new ctrlDPTIPPLogos();
        c4.IsPortal=true;
        c4.directHomePage();
        c4.openDownloadPopUpFlag();
        c4.closeDownloadPopUpFlag();
        c4.SelectedLogo = 'DPP_DuPontOvalLogo_Black_1';
        c4.Extension= 'JPG';
        c4.downloadLogo();
        c4.SelectedLogo = 'Testing again';
        c4.downloadLogo();
        c4.showPopUp();
        c4.closePopup();
        c4.samePage();
        c4.logoExtensionNotAvailable();
        c4.getContentList();
        
        }
        c1.qualList = new List<Qualification__c>();
        c1.qualList.add(q1);
        c1.directMainPage();
}
}
Public static testMethod void ctrlDPTIPPLogosMethood1 (){

Profile p =[SELECT Id FROM Profile where name='DPT-IPP EMEA Value Chain Service Distributors' limit 1];
UserRole r=[SELECT Id FROM UserRole WHERE Name='PS CRM' limit 1]; 
Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
User SysUser= new User(Firstname='SystemDPTIP',Alias='SUser', Email='brundha_kumar@infosys.com', 
        User_Country__c='UNITED STATES',EPass_ID__c='DPTIPP',
        profileid = p1.id,UserRoleId=r.id,
        Username='UserDPTIP@dupont.com.test4', LastName='user',
        CommunityNickname='TestingCommunity2', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
insert SysUser;  

System.RunAs(SysUser){  
Account a = new Account(Name='DPT-IPP Test Portal Account1');
insert a;
Contact c = new Contact(AccountId=a.id,LastName='PortalUserDPTIPP');
insert c;


User PortalUser= new User(Firstname='DPTIPPTest1',Alias='PUser', Email='brundha_kumar@infosys.com', 
        User_Country__c='UNITED STATES',EPass_ID__c='TestD',
        profileid = p.id,
        Username='UserDPTIPEMEA@dupont.com.test4', LastName='PortalUser',
        CommunityNickname='TestingCommunity', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',contactId=c.id,User_Region__c='EMEA');

        insert PortalUser;
Group g= [Select Id,Name from Group where Type='regular' and Name='DPT-IPP EMEA Community Distributors'];
GroupMember gm = new GRoupMember(GroupId=g.id,UserOrGroupId=PortalUser.id);
insert gm;

System.RunAs(PortalUser){ 
    ctrlDPTIPPLogos c1= new ctrlDPTIPPLogos();
}

}
}
}
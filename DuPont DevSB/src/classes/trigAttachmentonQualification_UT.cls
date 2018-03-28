@isTest
private class trigAttachmentonQualification_UT
{
static testMethod void testAttachments()
{

        Profile profileId21=[select id from Profile where Name='System Administrator'];
        User u =new User(LastName='wwwroot Site Guest User',User_District__c='Admin',FirstName='Test CUPS',Alias='tUser1',ProfileId=profileId21.id,Email='test_batch1_1@xyz.com',Username='cupsadmin3_14321@test.com',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert u;

// GET USER FROM USER TABLE...
//User u = [select name, Id FROM user where name = 'wwwroot Site Guest User'LIMIT 1];

// RUN AS USER...
// RUN AS USER...
system.runAs(u)
{

// TEST ADDING A NEW ACCOUNT... 
Account acc = new Account(
name = 'MULTI APPROS', 
Type = 'Distributor',Account_Stage__c ='Active',
Program__c = 'AGCP-CPC',Country__c = 'INDIA',Owning_Organization__c = 'AGC-CPC' 
);
insert acc; 
system.debug('----->>> END ADDING ACCOUNT: ' + acc.name);


// READ ACCOUNT...
Account a = [select name, Id FROM account WHERE name = 'MULTI APPROS' LIMIT 1];
system.debug('----->>> END READING ACCOUNT: ' + a.name);

// TEST ADDING A NEW CONTACT...
Contact con = new Contact(AccountId = acc.id,lastname = 'test', 
firstname ='testdata1',
OwnerId = u.Id,Importance__c = 'Main'
);
insert con; 
system.debug('----->>> END INSERT CONTACT: ' + con.Id);

Initiative__c init = new Initiative__c (Name = 'Teflon® Extensions',Status_vs_Plan__c ='Green',Sponsor__c = con.Id,Priority__c='Medium',Stage__c='Active',Status__c='In Progress',Type__c='Management',SubType__c ='Reporting',Channel__c ='eMail',Start_Date__c = Date.today(), End_Date__c = Date.today()+5,Segment_Group__c='Construction',Geography__c = 'EMEA',Involved_Org__c='ABS',Objectives__c = 'test',Next_Steps__c='test',
Initiative_Group__c ='FLPR',Effort_Actual__c =100.00,Cost_Actual__c=100);
insert init;
system.debug('----->>> END INSERT Initiative: ' + init.Id);
//[01022017] - Merge&Spin: Replaced Hard coding of record type Id
string Fabric_Certification_RType = RType.getIdByDevName('Qualification__c','Fabric_Certification');
Qualification__c qual = new Qualification__c(Account_Name__c = a.Id,RecordTypeId = Fabric_Certification_RType, Related_Contact__c = con.Id , Start_Date__c = Date.today(), End_Date__c = Date.today()+7,Stage__c='Approving',Stage_Reason__c='Legal-Global',Qualification_Program__c = init.Id);
insert qual;



Attachment attach1=new Attachment(); 
attach1.Name='Unit Test Attachment';
attach1.OwnerId = u.id;
Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body1');
attach1.body=bodyBlob1;
attach1.parentId=qual.id;
insert attach1;



Attachment attach = [select OwnerId,ParentId from Attachment where parent.id=:qual.id ]; 
System.debug('############################'+attach.OwnerId);
System.debug('############################'+attach.ParentId);

Test.startTest(); 
update qual;  
Qualification__c qualification = [select id,Owner__c,Qualification_Documents__c from Qualification__c where Id =:attach.ParentId];
System.debug('The value of '+qualification.Qualification_Documents__c);
Test.stopTest();

} 


}
}
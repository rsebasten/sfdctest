@IsTest
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  Unit test for the trigger trigDPT_NomexundeleteAttachment

********************************************************************************/
private class trigAttachmentDelete_UT {
static testMethod void testDeleteAttachment (){
    
    //Update to fix test class failure related to portal account owner
    Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
    UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];
    
    User owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsreeee',isActive = true,username='a@testingq1.com');
    insert owner;
    
    Account accInd = new Account();
    Contact contact = new Contact();
    
    System.runAs(owner) {
        accInd = new account(name='individual',country__c = 'INDIA', OwnerId =owner.Id);
        insert accInd ;
        
        contact = new Contact(LastName = 'hello',FirstName = 'World',Email = 'a@dolby.com',AccountId =  accInd.Id,OwnerId =owner.Id);
        insert contact;
    }
    //commented for dps
    //Profile p  = [select id from Profile where UserLicense.Name like '%Customer Portal%' limit 1];
    Profile p  = [select id from Profile where UserLicense.Name like '%Partner Community%' limit 1];
    //To fix issue with AGCRM deployment self service user
    //User u = new User(alias = 'standt',AccessType__c = 'Portal',email='a@dolby.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing',languagelocalekey='en_US',localesidkey='en_US',IsPortalSelfRegistered = true,profileid = p.Id,ContactId = contact.id,timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsree',isActive = true,username='a@dolby.com');
    User u = new User(alias = 'standt',AccessType__c = 'Portal',email='a@dolby.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing',languagelocalekey='en_US',localesidkey='en_US',profileid = p.Id,ContactId = contact.id,timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsree',isActive = true,username='a@dolby.com');
    insert u;
    
    System.runAs(u) {
    Account acct = new Account(Name = 'Test Account6',Phone='1234567899',
                         BillingStreet = '123 any st', BillingCity = 'Cinn',
                       BillingState = 'NJ', BillingPostalCode = '08077');
            insert acct;
    //[01022017] Merge&Spin; Replaced Hard coding of record type Id        
    string Fabric_Certification_RType = RType.getIdByDevName('Qualification__c','Fabric_Certification');        
    Qualification__c qual1 = new Qualification__c(Account_Name__c = acct.Id,RecordTypeId = Fabric_Certification_RType, Start_Date__c = Date.today(), End_Date__c = Date.today()+7,Stage__c='Approving');
            insert qual1;
            
            
            Blob attachBody = Blob.valueOf('attachment body');
            Attachment attach = new Attachment(Name = 'TestAttachment', ParentId = qual1.Id, Body = attachBody);
            insert attach;
            
            // Verify that no error is thrown when the attachment is deleted
            Boolean errorThrown = false;
            try {
                delete attach;
            } catch (Exception e) {
                System.debug(e);
                errorThrown = true;
            }
            System.debug('Cannot delete attachments');
        }
    }
}
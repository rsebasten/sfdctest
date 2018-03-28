/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class processCaseEmail
***************************************************************************************/

@isTest()
public class processCaseEmail_UT {

static testMethod void test() {
    //Start: Updated for merge split to remove seeAllData from the test class.
    
    Final Id CaseRecordType=Rtype.getIdByDevName('Case','BI_Case');
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    
    UserRole ur = new UserRole(Name = 'PS CRM');
    insert ur;
        //UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        //User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        //insert user1;
    User user1 = TestUserUtil.createTestUser(ur.id,p1.id,'Test FirstName','Test LastName');
    insert user1;
        
        System.runas(user1){
        Test.startTest() ;
//PKH        Svmx_TestData_Util_UT.createCustomSettingData();
        Test.stopTest() ;  
        geoValidation.validateInTestMode=false;
        
    Messaging.InboundEmail email = new Messaging.InboundEmail() ;
    Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
    Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
    
    inAtt.body = blob.valueOf('test');
    inAtt.fileName = 'my attachment name';
    inAtt.mimeTypeSubType = 'plain/txt';
    email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
    
    Case c = new Case();
    c.description = 'description';
    c.subject = 'test';
    c.Priority='Low';
    c.RecordTypeId = CaseRecordType;
    c.OwnerId = UserInfo.getUserId();
    insert c;
    
    c=[select id,ownerId, CaseNumber from Case where id=:c.id];
    system.debug('aaaa'+c);
    
    email.subject = c.CaseNumber;
    env.fromAddress = 'user@acme.com';
    c.ownerId = UserInfo.getUserId();
            update c;     
    processCaseEmail p = new processCaseEmail();
    p.handleInboundEmail(email, env );
    }
    
}

}
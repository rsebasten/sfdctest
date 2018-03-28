@isTest
public class BINAEmailService_UT{

 static testMethod void testBINAEmailService() {
          Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        Final Id PRODUCTlABOUR_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    System.runAs(user1){
    test.starttest();
    Account acc= new Account(name='testacc');
    insert acc;
   Entitlement ent= new Entitlement();
   ent.Registration_Address__c='somnething';
    ent.Registration_City__c='Infosys';
    ent.Registration_State_Province__c='AK';
    ent.Registration_Postal_Code__c='5601';
    ent.Registration_Country1__c='United States';
    ent.RecordTypeId=PRODUCTlABOUR_REG_RTYPE;
    ent.Lot_Nb__c='abc';
    ent.startdate=date.newinstance(2016,02, 29);
    ent.WRB_Only__c=true;
    ent.Building_Type__c='Residential / Duplex';
    ent.Lot_Nb__c='12';
    ent.Registration_Postal_Code__c='56010';
    ent.Application__c='< 5 Stories';
   ent.name='rajiv';
   ent.AccountId=acc.Id;
   insert ent;
   system.debug('[[[[[[[]]]]]]]]]'+ent.id);
   system.debug('111111111111111'+ent.Lot_Nb__c);
   system.debug('[[[[[[[[[[[[[[[['+ent.Registration_Number__c);
//[06142017] Merge&Spin: Removed SeeAllData = true from top of the test class and hard coding of Registration Number in attachment PDF (Line No 35 & 51)
      String etRegistrationNumber = [Select Registration_Number__c from Entitlement where id =: ent.id limit 1].Registration_Number__c;
      Attachment att = new Attachment();
        att.ParentId=ent.Id;
        att.body=blob.valueOf('test');
        att.name='rajiv';
        insert att;
   
Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
   Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

   email.subject = 'test';
   env.fromAddress = 'user@acme.com';

   // set the body of the attachment
   inAtt.body = blob.valueOf('test');
   inAtt.fileName = 'Registration Details- '+etRegistrationNumber+'.pdf' ;
   system.debug('pppppppppppppppppp'+inAtt.fileName);
   inAtt.mimeTypeSubType = 'plain/txt';

   email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 

   // call the class and test it with the data in the testMethod
   BINAEmailService bina= new BINAEmailService ();
   bina.handleInboundEmail(email, env ); 

 test.stoptest();
 }
 }
 }
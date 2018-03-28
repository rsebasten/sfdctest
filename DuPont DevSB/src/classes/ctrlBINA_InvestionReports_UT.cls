/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_InvestionReports_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_InvestionReports
//************************************<MG-20140827>***************************************************//
@isTest(SeeAllData=true)
public class ctrlBINA_InvestionReports_UT{

 static testMethod void testctrlBINA_InvestionReports() {
    Final Id SITERECTYPEID = Rtype.getIdByDevName('SFDC_Script__c','SiteScript');
    Profile p=[SELECT id,name from Profile where Name=:'System Administrator' LIMIT 1];
    User user1=[SELECT id,name from User where IsActive=: true and ProfileId =: p.Id LIMIT 1];
     System.runAs(user1){

  SFDC_Script__c ss = new SFDC_Script__c(
    name='Project Information',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );

   insert ss;  
        
   SFDC_Questions__c Ques1=new SFDC_Questions__c(Name='RegistrationID',Script__c=ss.Id,Answer_Format__c='Checkbox',ShortName__c='id',DefaultAnswer__c='@param.var',
                     WriteToField__c='id',AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques2=new SFDC_Questions__c(Name='Sheathing Type',Script__c=ss.Id,Answer_Format__c='Checkbox',ShortName__c='Sheathing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques3=new SFDC_Questions__c(Name='Wall Cladding Type',Script__c=ss.Id,Answer_Format__c='Checkbox',ShortName__c='Wall Cladding Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true, IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques4=new SFDC_Questions__c(Name='Framing Type',Script__c=ss.Id,Answer_Format__c='Checkbox',ShortName__c='Framing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
     
   insert new LIST<SFDC_Questions__c> {Ques1,Ques2,Ques3,Ques4};
   
    SFDC_FollowOnQuestion__c fq1 = new SFDC_FollowOnQuestion__c(Script__c=ss.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq2 = new SFDC_FollowOnQuestion__c(Script__c=ss.id, Question__c=Ques2.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq3 = new SFDC_FollowOnQuestion__c(Script__c=ss.id, Question__c=Ques3.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq4 = new SFDC_FollowOnQuestion__c(Script__c=ss.id, Question__c=Ques4.id, QuestionOrder__c=4);
    insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4};
    
     
    SFDC_Answer__c an4 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Sheathing - Plywood', Questions__c=Ques2.id);
    SFDC_Answer__c an5 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Sheathing - OSB', Questions__c=Ques2.id);
    SFDC_Answer__c an6 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Sheathing - Exterior Insulation', Questions__c=Ques2.id);
    insert new LIST<SFDC_Answer__c> {an4,an5,an6};
    
    SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Wall Cladding - Brick Mason', Questions__c=Ques3.id);
    SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Wall Cladding - Stone Venn', Questions__c=Ques3.id);
    SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Wall Cladding - Stucco', Questions__c=Ques3.id);
    insert new LIST<SFDC_Answer__c> {an1,an2,an3};
    
    SFDC_Answer__c an7 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Framing - 2X4 Wood', Questions__c=Ques4.id);
    SFDC_Answer__c an8 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Framing - 2X6 Wood', Questions__c=Ques4.id);
    SFDC_Answer__c an9 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Framing - 2X8 Wood', Questions__c=Ques4.id);
    insert new LIST<SFDC_Answer__c> {an7,an8,an9}; 
    
    SiteScript scriptTest = new SiteScript(ss.id);
       system.debug('the Scriptnamed is.......'+scriptTest);       
        Account acc= new Account(name='testacc');
        insert acc;
        Contact con=new contact(Firstname='Sanjay', LastName='Nandi',Email='sanjay31nandi@infosys.com',MailingStreet='Abc',MailingCity='Abc',MobilePhone='0000000000',Phone='12345',MailingState='XYZ',MailingPostalCode='12345',MailingCountry='United States', AccountId=acc.id);
        insert con;
        Entitlement ent= new Entitlement(name='TestEntit',primary_contact__c=con.id, Accountid=acc.id);
        insert ent;
        DateTime dT = System.now();
        Case cas=new case(
            EntitlementId=ent.id,
            Submitted_By_First_Name_Last_Name__c='sanjay',
            Case_Shipping_Address__c='Abc',
            Alt_Phone__c='00000000',
            Problem_Description__c='Test',
            Description='test',
            Date_Entered__c=date.newinstance(dT.year(), dT.month(), dT.day()),
            status='new',  ownerId=user1.Id);
        insert cas;
       
        scriptTest.getQuestion('Wall Cladding Type').answer=an1.answer__c;
        scriptTest.getQuestion('Sheathing Type').answer=an1.answer__c;
        system.debug('this is sanjay');
        scriptTest.getQuestion('Framing Type').answer=an7.answer__c;
        scriptTest.getQuestion('id').answer=ent.id;
        scriptTest.save();
       

   
        ApexPages.currentPage().getParameters().put('id', cas.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(cas);
        ctrlBINA_InvestionReports c = new ctrlBINA_InvestionReports (sc);
        
      }
  }
}
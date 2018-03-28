/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_SurfacesClaim_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_SurfacesClaim 
//************************************<MG-20140827>***************************************************//
@isTest(SeeAllData=true)
private class ctrlBINA_SurfacesClaim_UT{
    static testMethod void testctrlBINA_SurfacesClaim_UT() {
        final Id CASERECORDTYPEID=Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
        final Id ENTITLEMENTRECORDTYPEID=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){   
        geoValidation.validateInTestMode=false;
        
        Account acc= new Account(name='testacc',BI_Account_SubType__c='Fabricating Retailer',OwnerId=user1.id);
        insert acc;
        Contact con=new contact(Firstname='Sanjay', LastName='Nandi',Email='sanjay31nandi@infosys.com',MailingStreet='Abc',MailingCity='Abc',MobilePhone='0000000000',Phone='12345',MailingState='XYZ',MailingPostalCode='12345',MailingCountry='United States', AccountId=acc.id);
        insert con;
        DateTime dT = System.now();
        
        Entitlement ent= new Entitlement(name='TestEntit',product_answer1__c='Product1;Product2;Product3',StartDate=date.newinstance(dT.year(), dT.month(), dT.day()),primary_contact__c=con.id, Accountid=acc.id);
        insert ent;
          case cas= new case();     
        ApexPages.currentPage().getParameters().put('def_entitlement_id', ent.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(cas);
        ctrlBINA_SurfacesClaim  c = new ctrlBINA_SurfacesClaim(sc);
        Test.startTest();
        c.save();
        c.selectedMaterials.add(new SelectOption('Product1', 'Product1'));
        c.selectedMaterials.add(new SelectOption('Product2', 'Product2'));
        c.save();
        c.cancel();
        
        
        Account acc1= new Account(name='testacc',OwnerId=user1.id);
        insert acc1;
        Contact con1=new contact(Firstname='Sanjay', LastName='Nandi',Email='sanjay31nandi@infosys.com',MailingStreet='Abc',MailingCity='Abc',MobilePhone='0000000000',Phone='12345',MailingState='XYZ',MailingPostalCode='12345',MailingCountry='United States', AccountId=acc1.id);
        insert con1;
        Entitlement ent1= new Entitlement(name='TestEntit',product_answer1__c='',StartDate=date.newinstance(dT.year(), dT.month(), dT.day()),primary_contact__c=con.id, Accountid=acc1.id);
        insert ent1;
        case cas1= new case();     
        ApexPages.currentPage().getParameters().put('def_entitlement_id', ent1.id);
        ApexPAges.StandardController sc1 = new ApexPages.StandardController(cas1);
        ctrlBINA_SurfacesClaim  c1 = new ctrlBINA_SurfacesClaim(sc1);
        
        c1.save();
        Test.stopTest();
        }
       }
      }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_SurfaceVFPanel_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_SurfaceVFPanel
//************************************<MG-20140827>***************************************************//
@isTest(SeeAllData=true)
private class ctrlBINA_SurfaceVFPanel_UT{
    static testMethod void testctrlBINA_SurfaceVFPanel_UT() {
/*PKH        
        final Id CASERECORDTYPEID=Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
        final Id ENTITLEMENTRECORDTYPEID=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){   
        geoValidation.validateInTestMode=true;
        
        Account acc= new Account(name='testacc',BillingCountry='CA', BillingState='British Columbia',ShippingCountry='United States', ShippingState='British Columbia');
        insert acc;
        Contact con=new contact(Firstname='Sanjay', LastName='Nandi',Email='sanjay31nandi@infosys.com',MailingStreet='Abc',MailingCity='Abc',MobilePhone='0000000000',Phone='12345',MailingState='XYZ',MailingPostalCode='12345',MailingCountry='United States', AccountId=acc.id);
        insert con;
        Entitlement ent= new Entitlement(name='TestEntit',primary_contact__c=con.id, Accountid=acc.id);
        insert ent;
        Case cas=new case(product_selected__c='Materail1;Material2',status='new', recordtypeid=CASERECORDTYPEID, ownerId=user1.Id, Entitlementid=ent.id);
        insert cas;
        case cas1 = [SELECT id,product_selected__c From case LIMIT 1];
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id', cas.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(cas1);
        ctrlBINA_SurfaceVFPanel c = new ctrlBINA_SurfaceVFPanel (sc);
        ApexPages.currentPage().getParameters().put('id', ent.id);
        ApexPAges.StandardController sc1 = new ApexPages.StandardController(ent);
        ctrlBINA_SurfaceVFPanel c1 = new ctrlBINA_SurfaceVFPanel (sc1);
        
        Test.stopTest();
      }  
*/        
     }
     
    }
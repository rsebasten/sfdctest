/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_CaseMaterialEmail _UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_CaseMaterialEmail 
//************************************<MG-20140827>***************************************************//
@isTest(SeeAllData=true)
private class ctrlBINA_CaseMaterialEmail_UT{
    static testMethod void testctrlBINA_CaseMaterialEmail_UT() {
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
        //KT [11072017]: To remove Distributor_Contact__c=con.id reference
        Account acc1= new Account(name='Distributor', Distributor__c=acc.id,OwnerId=user1.id);
        insert acc1;
        Contact con1=new contact(Firstname='Sanjay1', LastName='Nandi1',Email='sanjay31nandi@infosys.com',MailingStreet='Abc',MailingCity='Abc',MobilePhone='0000000000',Phone='12345',MailingState='XYZ',MailingPostalCode='12345',MailingCountry='United States', AccountId=acc1.id);
        insert con1;
        Entitlement ent= new Entitlement(name='TestEntit',primary_contact__c=con.id, Accountid=acc.id);
        insert ent;
        Case cas=new case(AccountId=acc1.id,contactId=con1.id,Alt_Contact_Email__c='sanjay31nandi@gmail.com',product_selected__c='Materail1;Material2',status='new', recordtypeid=CASERECORDTYPEID, ownerId=user1.Id, Entitlementid=ent.id);
        insert cas;
       // case cas1 = [SELECT id,product_selected__c From case LIMIT 1];
        
         
        ApexPages.currentPage().getParameters().put('id', cas.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(cas);
        ctrlBINA_CaseMaterialEmail  c = new ctrlBINA_CaseMaterialEmail (sc);
       Test.startTest();
        c.SendEmail();
        c.searchproduct='googl';
        c.shippingInformation='SANJAY NANDI';
        c.selectedConId=con1.id;
        c.searchProductValue();
        c.SendEmail();
        
        material__c m1=new Material__C(name='C A MA 1/2X30X144 12.0X760X3658',ERP_Profit_Center__c='BUILDING INNOVATIONS',ERP_Product_Family__c='CORIAN');
        insert m1;
        material__c m2=new Material__C(name='C A MA 1/2X30X72 12.0X760X1829',ERP_Profit_Center__c='BUILDING INNOVATIONS',ERP_Product_Family__c='CORIAN' );
        insert m2;
        material__c m3=new Material__C(name='C A MA 1/4X30X98 6X760X2490',ERP_Profit_Center__c='BUILDING INNOVATIONS',ERP_Product_Family__c='CORIAN' );
        insert m3;
        material__c m4=new Material__C(name='C B/S MA 2/PK',ERP_Profit_Center__c='BUILDING INNOVATIONS',ERP_Product_Family__c='CORIAN' );
        insert m4;
        c.searchproduct='ma';
        c.searchProductValue();
        c.SendEmail();
        c.searchproduct='ma';       
        c.selectedMaterials.add(new SelectOption(m2.name, m2.name));
        c.selectedMaterials.add(new SelectOption(m3.name, m3.name));
        c.searchProductValue();
        c.SendEmail();
        system.debug('the Product selected is '+c.ProductAnswer());
        system.debug('the Product selected is '+c.MaterialValue);
        Test.stopTest();
      }  
        
     }
    }
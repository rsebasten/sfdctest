/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_RegistrationSurfaces_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_RegistrationSurfaces
//************************************<MG-20140827>***************************************************//
@isTest
private class ctrlBINA_RegistrationSurfaces_UT{
        static testMethod void testctrlBINA_RegistrationSurfaces_UT() {
        Final string BISURFACE_RTYPE = Rtype.getIdByDevName('Account','BI_Surfaces');
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){   
        geoValidation.validateInTestMode=false;
        
        Account acc1= new Account(name='SanjayFabricator',BI_Account_SubType__c='Other Fabricator',recordtypeid=BISURFACE_RTYPE  );
        insert acc1;
        Account acc2= new Account(name='SanjayFabricator',BI_Account_SubType__c='Fabricator',recordtypeid=BISURFACE_RTYPE  );
        insert acc2;
        Account acc3= new Account(name='SanjayFabricator',BI_Account_SubType__c='Builder',recordtypeid=BISURFACE_RTYPE  );
        insert acc3;
        Account acc4= new Account(name='SanjayFabricator',BI_Account_SubType__c='Builder',recordtypeid=BISURFACE_RTYPE  );
        insert acc4;
        
        contact con1=new contact(Firstname='sanjay',lastName='Nandi',MailingStreet='abc',email='sanjay_nandi@infosys.com',MobilePhone='0000000000',Mailingcity='abc',Phone='0000000000',MailingPostalCode='123456',MailingCountry='CANADA',MailingState='AB', AccountID=acc4.id);
        insert con1;
        
        PageReference pageRef = Page.BI_NA_SurfacesRegistration;
        Test.setCurrentPage(pageRef); 
        material__c m1=new Material__C(name='BI NA Surfaces Warranty');
        insert m1;
        material__c m2=new Material__C(name='material1',Parent_Material__c=m1.id );
        insert m2;
        material__c m3=new Material__C(name='material2',Parent_Material__c=m1.id );
        insert m3;
        material__c m4=new Material__C(name='material3',Parent_Material__c=m1.id );
        insert m4;      
        
        Test.startTest();
        Entitlement ent= new Entitlement();
        ApexPages.currentPage().getParameters().put('retUrl','/'+acc1.id); 
        ApexPages.currentPage().getParameters().put('def_account_id',acc1.id);
        ApexPAges.StandardController controller = new ApexPages.StandardController(ent);
        ctrlBINA_RegistrationSurfaces c1 = new ctrlBINA_RegistrationSurfaces (controller);
        c1.searchProduct='ma';
        c1.searchProductValue();
        c1.cancel();
        c1.saveEnt();
        
        
        ApexPages.currentPage().getParameters().put('retUrl','/'+acc2.id);
        ApexPages.currentPage().getParameters().put('def_account_id',acc2.id);
        ctrlBINA_RegistrationSurfaces c2 = new ctrlBINA_RegistrationSurfaces (controller);
        c2.con.Firstname=null;
        c2.con.lastName='Nandi';
        c2.con.MailingStreet='abc';
        c2.conemail='sanjay_nandi@infosys_.com';
        c2.conPhone='000000';
        c2.con.Mailingcity='abc';
        c2.con.Phone='0000';
        c2.con.MailingPostalCode='123456578';
        c2.entit.Registration_Country1__c='CANADA';
        c2.entit.Registration_State_Province__c='AB';
        DateTime dT = System.now();
        c2.entit.StartDate=date.newinstance(dT.year(), dT.month(), dT.day());
        c2.searchProduct='sanja';
        c2.searchProductValue();
        c2.cancel();
        c2.entit.accountid=null;
        c2.saveEnt();
        
        
        
        ApexPages.currentPage().getParameters().put('def_account_id',acc3.id);
        ApexPages.currentPage().getParameters().put('retUrl','/'+acc3.id);
        ctrlBINA_RegistrationSurfaces c3 = new ctrlBINA_RegistrationSurfaces (controller);
                    
        c3.con.Firstname='sanjay';
        c3.con.lastName='Nandi';
        c3.con.MailingStreet='abc';
        c3.conemail='sanjay_nandi@infosys.com';
        c3.conPhone='0000000000';
        c3.con.Mailingcity='abc';
        c3.con.Phone='0000000000';
        c3.con.MailingPostalCode='123456';
        c3.entit.Registration_Country1__c='CANADA';
        c3.entit.Registration_State_Province__c='AB';
        c3.entit.StartDate=date.newinstance(dT.year(), dT.month(), dT.day());
        c3.entit.Installation_Type__c='New Construction';
        c3.selectedMaterials.add(new SelectOption(m2.name, m2.name));
        c3.selectedMaterials.add(new SelectOption(m3.name, m3.name));
        c3.searchProduct='ma';
        c3.searchProductValue(); 
        c3.saveEnt();
        c3.renderAccountLabel();
        c3.getAlloption();
        
        ApexPages.currentPage().getParameters().put('retUrl','/'+acc2.id);
        ApexPages.currentPage().getParameters().put('def_account_id',acc2.id);
        ctrlBINA_RegistrationSurfaces c4 = new ctrlBINA_RegistrationSurfaces (controller);
        c4.con.Firstname='sanjay';
        c4.con.lastName='Nandi';
        c4.con.MailingStreet='abc';
        c4.entit.accountid=acc2.id;
        c4.conemail='sanjay_nandi@infosys_.com';
        c4.conPhone='000000';
        c4.con.Mailingcity='abc';
        c4.con.Phone='0000';
        c4.con.MailingPostalCode='123456578';
        c4.entit.Registration_Country1__c='CANADA';
        c4.entit.Registration_State_Province__c='AB';
        c4.entit.StartDate=date.newinstance(dT.year(), dT.month(), dT.day());
        c4.searchProduct='sanja';
        c4.searchProductValue();
        c4.cancel();
        c4.selectedMaterials.add(new SelectOption(m2.name, m2.name));
        c4.selectedMaterials.add(new SelectOption(m3.name, m3.name));
        c4.saveEnt();
        
        ApexPages.currentPage().getParameters().put('retUrl','/'+acc4.id);
        ApexPages.currentPage().getParameters().put('def_account_id',acc4.id);
        ApexPages.currentPage().getParameters().put('def_contact_id',con1.id);
        ctrlBINA_RegistrationSurfaces c5 = new ctrlBINA_RegistrationSurfaces (controller); 
        c5.entit.accountid=acc4.id;
        c5.entit.StartDate=date.newinstance(dT.year(), dT.month(), dT.day());
        c5.searchProduct='sanja';
        c5.searchProductValue();
        c5.cancel();
        c5.saveEnt();
        c5.selectedMaterials.add(new SelectOption(m2.name, m2.name));
        c5.selectedMaterials.add(new SelectOption(m3.name, m3.name));
        c5.saveEnt();
        
        Contact con=new Contact();
        con.Firstname='Sanjay';
        con.lastName='Nandi';
        con.MailingStreet='abc';
        con.email='sanjay_nandi@infosys.com';
        con.Phone='000000';
        con.Mailingcity='abc';
        con.Phone='0000';
        con.MailingPostalCode='123456578';
        insert con;
        Entitlement ent1=new Entitlement();
        ent1.accountid=acc1.id;
       
        ent1.primary_contact__c=con.id;
        ent1.Name='Test';
        ent1.StartDate=date.newinstance(dT.year(), dT.month(), dT.day());
        ent1.Installation_Type__c='New Construction';
        ent1.Product_Answer1__c='Rajiv';
        insert ent1;
        
        ApexPages.currentPage().getParameters().put('id',ent1.id);
        ApexPAges.StandardController controller2 = new ApexPages.StandardController(ent1);
        ctrlBINA_RegistrationSurfaces c10 = new ctrlBINA_RegistrationSurfaces (controller2);
        c10.SaveEnt();
        
        Test.stopTest();
      }  
        
     }
    }
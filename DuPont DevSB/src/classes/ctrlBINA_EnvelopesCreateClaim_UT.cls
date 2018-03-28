/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesCreateClaim_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_EnvelopesCreateClaim
//************************************<MG-20140827>***************************************************//
@isTest(seealldata=true)
private class ctrlBINA_EnvelopesCreateClaim_UT{
        static testMethod void testctrlBINA_EnvelopesCreateClaim_UT() {
       
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        Final string BITYVEK_RTYPE = Rtype.getIdByDevName('Account','BI_Surfaces');
        insert user1;
        System.runas(user1){   
        geoValidation.validateInTestMode=false;
        
        Account acc= new Account(name='SanjayFabricator',BI_Account_SubType__c='Fabricator',recordtypeid=BITYVEK_RTYPE  );
        insert acc;
              
        Test.startTest();
         material__c m1=new Material__C(name='DuPont™ StraightFlash™',ProductList_Family__c='BI' );
        insert m1;
        material__c m2=new Material__C(name='Tyvek® CommercialWrap® D',ProductList_Family__c='BI' );
        insert m2;
        material__c m3=new Material__C(name='Tyvek® CommercialWrap®',ProductList_Family__c='BI' );
        insert m3;
        material__c m4=new Material__C(name='material3',ProductList_Family__c='BI' );
        insert m4;
        Entitlement ent= new Entitlement(AccountId=acc.id,name='sanjay',product_answer1__c=' Tyvek® CommercialWrap® D;DuPont™ StraightFlash™;Tyvek® CommercialWrap®',registration_address__c='testAddress');
        insert ent;
        ApexPages.currentPage().getParameters().put('def_entitlement_id',ent.id);
        Case cas= new Case();
        ApexPAges.StandardController controller = new ApexPages.StandardController(cas);
        ctrlBINA_EnvelopesCreateClaim c2 = new ctrlBINA_EnvelopesCreateClaim (controller);
        c2.savelist();
        c2.conPostal='00000';
        c2.cas.Submitted_By_First_Name_Last_Name__c='sanjay';
        c2.cas.Case_Shipping_Address__c='TestAddress'; 
        c2.cas.Country__c='CANADA';
        c2.savelist();
        c2.savelist();
        c2.cas.Alt_Phone__c='000000000';
        c2.init();
        c2.cancel();
        c2.casemail='sanjay_nandi@infosys..com';        
        c2.savelist();
        c2.casemail='sanjay_nandi@infosys.com';
        c2.cas.Description='Test Description';
        c2.savelist();
        
        Case cas1= new Case();
        ApexPAges.StandardController controller1 = new ApexPages.StandardController(cas1);
        ctrlBINA_EnvelopesCreateClaim c3 = new ctrlBINA_EnvelopesCreateClaim (controller1);
        c3.cas.Submitted_By_First_Name_Last_Name__c='sanjay';
        c3.cas.Case_Shipping_Address__c='TestAddress'; 
        c3.savelist();
        c3.cas.Problem_Description__c='problem Desc';
        c3.cas.Country__c='CANADA';
        c3.conPostal='000000';
        c3.cas.Alt_Phone__c='0000000000';
        c3.cas.Description='Test Description';
        c3.init();
        c3.cancel();
        c3.casemail='sanjay_nandi@infosys..com';        
        c3.savelist();
        c3.casemail='sanjay_nandi@infosys.com';
        c3.savelist();
        Test.stopTest();
       }      
     }
 }
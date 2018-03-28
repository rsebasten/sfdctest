/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlOverideEntitlement_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is Unit Test class for class ctrlOverideEntitlement
//***************************************************************************************//
@isTest(Seealldata=true)
private class ctrlOverideCase_UT{
        static testMethod void testctrlOverideCase_UT() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){
        
        Final string BISURFACEAcc_RTYPE= Rtype.getIdByDevName('Account','BI_Tyvek');
        Final string BITYVEKAcc_RTYPE = Rtype.getIdByDevName('Account','BI_Surfaces');
        Final string BISURFACE_RTYPE= Rtype.getIdByDevName('Case','BI_NA_Surfaces_Case');
        Final string BITYVEK_RTYPE = Rtype.getIdByDevName('Case','BI_NA_Envelopes_Case');
        Final string OTHERCASE = Rtype.getIdByDevName('Case','BI_Case');
        Final string PRODUCTANDLABOUT_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
        Final string PRODUCTONLY_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
        Final string PRODUCTFLUIDAPPLIED_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
        Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
        Final string OTHERENTIT=Rtype.getIdByDevName('Entitlement','BI_EMEA_Entitlement');
        geoValidation.validateInTestMode=false;
        
        Date d2=date.newinstance(2014, 10, 22);
        Date d3=date.newinstance(2014, 9, 22);
        Account accTyvek= new Account(name='SanjayTdfgdfvek',BI_Account_SubType__c='Fabricator',RecordtypeId=BISURFACEAcc_RTYPE);
        insert accTyvek;
        Account accSurf= new Account(name='sanjayfdgfdSurface',BI_Account_SubType__c='Fabricator',Recordtypeid=BITYVEKAcc_RTYPE);
        insert accSurf;
        Entitlement entTyvek= new Entitlement(name='SanjayTvek',RecordtypeId=PRODUCTANDLABOUT_COB_RTYPE,startdate=d2,AccountId=accTyvek.Id);
        insert entTyvek;
        Entitlement entSurf= new Entitlement(name='sanjaySurface',Recordtypeid=SurfaceEntitlement,startdate=d2,AccountId=accSurf.Id);
        insert entSurf;
        Entitlement entother= new Entitlement(name='sanjaySurface',Recordtypeid=OTHERENTIT,startdate=d2,AccountId=accSurf.Id);
        insert entother;
        Entitlement entTyvek1= new Entitlement(name='SanjayTvek',RecordtypeId=PRODUCTANDLABOUT_COB_RTYPE,startdate=d3,AccountId=accTyvek.Id);
        insert entTyvek1;
        Entitlement entSurf1= new Entitlement(name='sanjaySurface',Recordtypeid=SurfaceEntitlement,startdate=d3,AccountId=accSurf.Id);
        insert entSurf1;
        Entitlement entother1= new Entitlement(name='sanjaySurface',Recordtypeid=OTHERENTIT,startdate=d3,AccountId=accSurf.Id);
        insert entother1;
        Test.startTest();
        Case cas=new Case();
        
        ApexPAges.StandardController controller = new ApexPages.StandardController(cas);
        ctrlOverideNewCase c1 = new ctrlOverideNewCase (controller);
        cas.recordtypeid=BITYVEK_RTYPE;
        c1.retPage();
        c1.redirectToPage();
        
        ApexPAges.StandardController controller2 = new ApexPages.StandardController(cas);
        cas.recordtypeid=BITYVEK_RTYPE;
        ctrlOverideNewCase c2 = new ctrlOverideNewCase (controller2);
        c2.redirectToPage();
        
        ApexPAges.StandardController controller4 = new ApexPages.StandardController(cas);    
        cas.recordtypeid=BITYVEK_RTYPE; 
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf.id);
        ctrlOverideNewCase c4 = new ctrlOverideNewCase (controller4);
        c4.redirectToPage();
        
        ApexPAges.StandardController controller5 = new ApexPages.StandardController(cas);     
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf1.id);
        ctrlOverideNewCase c5 = new ctrlOverideNewCase (controller5);
        cas.recordtypeid=BITYVEK_RTYPE;
        c5.redirectToPage();
        
        ApexPAges.StandardController controller6= new ApexPages.StandardController(cas);  
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entTyvek1.id);   
        cas.recordtypeid=BITYVEK_RTYPE;
        ctrlOverideNewCase c6 = new ctrlOverideNewCase (controller6);
        c6.redirectToPage();
        
        ApexPAges.StandardController controller7= new ApexPages.StandardController(cas);     
        ApexPages.currentPage().getParameters().put('def_entitlement_id',NULL);
        cas.recordtypeid=BISURFACE_RTYPE;
        ctrlOverideNewCase c7 = new ctrlOverideNewCase (controller7);
        c7.redirectToPage();
       
        ApexPAges.StandardController controller8= new ApexPages.StandardController(cas);     
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf.id);
        cas.recordtypeid=BISURFACE_RTYPE;
        ctrlOverideNewCase c8 = new ctrlOverideNewCase (controller8);
        c8.redirectToPage();
        
        ApexPAges.StandardController controller9 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entTyvek1.id);
        cas.recordtypeid=BISURFACE_RTYPE;
        ctrlOverideNewCase c9 = new ctrlOverideNewCase (controller9);
        c9.redirectToPage();
        
        ApexPAges.StandardController controller10 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf1.id);
        cas.recordtypeid=BISURFACE_RTYPE;
        ctrlOverideNewCase c10 = new ctrlOverideNewCase (controller10);
        c10.redirectToPage();
        
        ApexPAges.StandardController controller11 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf.id);
        cas.recordtypeid=OTHERCASE;
        ctrlOverideNewCase c11 = new ctrlOverideNewCase (controller11);
        c11.redirectToPage();
        
        ApexPAges.StandardController controller12 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entSurf1.id);
        cas.recordtypeid=OTHERCASE;
        ctrlOverideNewCase c12 = new ctrlOverideNewCase (controller12);
        c12.redirectToPage();
        
        ApexPAges.StandardController controller13 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entTyvek1.id);
        cas.recordtypeid=OTHERCASE;
        ctrlOverideNewCase c13 = new ctrlOverideNewCase (controller13);
        c13.redirectToPage();
        
        ApexPAges.StandardController controller14 = new ApexPages.StandardController(cas);
        ApexPages.currentPage().getParameters().put('def_entitlement_id',entother1.id);
        cas.recordtypeid=OTHERCASE;
        ctrlOverideNewCase c14 = new ctrlOverideNewCase (controller14);
        c14.redirectToPage();
        
        Test.stopTest();
        
       
       }
    }
 }
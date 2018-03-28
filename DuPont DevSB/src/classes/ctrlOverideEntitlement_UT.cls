/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlOverideEntitlement_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This class is Unit Test class for class ctrlOverideEntitlement
//***************************************************************************************//
@isTest
private class ctrlOverideEntitlement_UT{
        static testMethod void testctrlOverideEntitlement_UT() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){
        //[20170103] Merge&Spin: Load test data for custom setting
        List<SObject> lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
        
        Final string OTHER_RTYPE = Rtype.getIdByDevName('Account','ERP_Account');
        Final string BITYVEK_RTYPE = Rtype.getIdByDevName('Account','BI_Tyvek');
        Final string BISURFACE_RTYPE= Rtype.getIdByDevName('Account','BI_Surfaces');
        Final string OTHERENTITLEMENT = Rtype.getIdByDevName('Entitlement','BI_EMEA_Entitlement');
        Final string PRODUCTANDLABOUT_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
        Final string PRODUCTONLY_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
        Final string PRODUCTFLUIDAPPLIED_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
            // <SA20171204> Added the test code for new record types 
        Final string PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS');
        Final string PRODUCT_ONLY_FLUID_WB_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied_WB');    
        Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
           
        geoValidation.validateInTestMode=false;
        Account accTyvek= new Account(name='SanjayTvek',BI_Account_SubType__c='Fabricator',RecordtypeId=BITYVEK_RTYPE, ownerid=user1.id );
        insert accTyvek;
        Account accSurf= new Account(name='sanjaySurface',BI_Account_SubType__c='Fabricator',Recordtypeid=BISURFACE_RTYPE, ownerid=user1.id);
        insert accSurf;
        Account accOther= new Account(name='sanjayOther',BI_Account_SubType__c='Fabricator',Recordtypeid=OTHER_RTYPE, ownerid=user1.id );
        insert accOther;
        Contact consurf=new Contact(lastname='sanjaycon',AccountId=accSurf.id);
        insert consurf;
        Test.startTest();
     
        Entitlement entit= new Entitlement();
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(entit);
        ctrlOverideEntitlement c1 = new ctrlOverideEntitlement (controller1);
        c1.retPage();
        c1.redirect();
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(entit);
        entit.recordtypeid=SurfaceEntitlement;
        ctrlOverideEntitlement c2 = new ctrlOverideEntitlement (controller2);
        c2.redirect(); 
        
        ApexPages.StandardController controller3 = new ApexPages.StandardController(entit);
        entit.recordtypeid=PRODUCTFLUIDAPPLIED_COB_RTYPE;
        ctrlOverideEntitlement c3 = new ctrlOverideEntitlement (controller3);
        c3.redirect();
        
        //[20170103] Merge&Spin: Map for retrieving field ID based on custom setting name
        map<string,string> fieldIdMap = new map<string,string>();
        for(sobject sobj:lstobjectFieldMapping)
        {
            Object_Field_ID_Mapping__c objectField = (Object_Field_ID_Mapping__c) sobj;
            fieldIdMap.put(objectField.name,objectField.field_id__c);
        }
              
        ApexPages.StandardController controller4 = new ApexPages.StandardController(entit);     
        //[20170103] Merge&Spin: Remove hardcoded ID for field.
        ApexPages.currentPage().getParameters().put(fieldIdMap.get('Entitlement_Primary_Contact')+'_lkid',consurf.id);
        entit.recordtypeid=PRODUCTFLUIDAPPLIED_COB_RTYPE ;
        ctrlOverideEntitlement c4 = new ctrlOverideEntitlement (controller4);
        c4.redirect();
        
        ApexPages.StandardController controller5 = new ApexPages.StandardController(entit);
        ApexPages.currentPage().getParameters().put('def_account_id',accSurf.id);
        entit.recordtypeid=PRODUCTFLUIDAPPLIED_COB_RTYPE ;
        ctrlOverideEntitlement c5 = new ctrlOverideEntitlement (controller5);
        c5.redirect();
        
        ApexPages.StandardController controller6 = new ApexPages.StandardController(entit);     
        ApexPages.currentPage().getParameters().put('def_account_id',accTyvek.id);
        entit.recordtypeid=PRODUCTFLUIDAPPLIED_COB_RTYPE ;
        ctrlOverideEntitlement c6 = new ctrlOverideEntitlement (controller6);
        c6.redirect();
            
            //<SA20171204> Added code to increase the code coverage
        ApexPages.StandardController controller10 = new ApexPages.StandardController(entit);     
        ApexPages.currentPage().getParameters().put('def_account_id',accTyvek.id);
        entit.recordtypeid = PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE ;
        ctrlOverideEntitlement c10 = new ctrlOverideEntitlement (controller10);
        c10.redirect();
            
           ApexPages.StandardController controller11 = new ApexPages.StandardController(entit);     
        ApexPages.currentPage().getParameters().put('def_account_id',accTyvek.id);
        entit.recordtypeid = PRODUCT_ONLY_FLUID_WB_REG_RTYPE ;
        ctrlOverideEntitlement c11 = new ctrlOverideEntitlement (controller11);
        c11.redirect();
            
            //<SA20171204>--End 
         
        Entitlement entit1= new Entitlement();  
        ApexPages.StandardController controller7 = new ApexPages.StandardController(entit1);     
        //[20170103] Merge&Spin: Remove hardcoded ID for field.
        ApexPages.currentPage().getParameters().put(fieldIdMap.get('Entitlement_Primary_Contact')+'_lkid',consurf.id);
        entit1.recordtypeid=SurfaceEntitlement;
        ctrlOverideEntitlement c7 = new ctrlOverideEntitlement (controller7);
        c7.redirect();
        
        ApexPages.StandardController controller8 = new ApexPages.StandardController(entit);     
        ApexPages.currentPage().getParameters().put('def_account_id',accSurf.id);
        entit.recordtypeid=SurfaceEntitlement;
        ctrlOverideEntitlement c8 = new ctrlOverideEntitlement (controller7);
        c8.redirect();  
        c8.retPage();
        
        ApexPages.StandardController controller9 = new ApexPages.StandardController(entit);     
        ApexPages.currentPage().getParameters().put('def_account_id',accTyvek.id);
        entit.recordtypeid=PRODUCTFLUIDAPPLIED_COB_RTYPE ;
        ctrlOverideEntitlement c9 = new ctrlOverideEntitlement (controller9);
        c9.redirect();
        
        
        Test.stopTest();
        
       
       }
    }
    }
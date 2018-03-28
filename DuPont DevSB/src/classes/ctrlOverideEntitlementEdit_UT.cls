@isTest
private class ctrlOverideEntitlementEdit_UT{
        static testMethod void testctrlOverideEntitlementEdit_UT() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='sanjay_nandi@infosys.com',UserName='sanjay@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){
        
        Final string BITYVEKAcc_RTYPE= Rtype.getIdByDevName('Account','BI_Tyvek');
        Final string BISURFACEAcc_RTYPE = Rtype.getIdByDevName('Account','BI_Surfaces');
        Final string PRODUCTANDLABOUT_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
        Final string PRODUCTONLY_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
        Final string PRODUCTFLUIDAPPLIED_COB_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
        Final string SurfaceEntitlement=Rtype.getIdByDevName('Entitlement','BI_NA_Surface_Entitlement');
        geoValidation.validateInTestMode=false;
        
        Account accTyvek= new Account(name='Rajiv',BI_Account_SubType__c='Fabricator',RecordtypeId=BITYVEKAcc_RTYPE);
        insert accTyvek;
        Account accSurf= new Account(name='Rajiv1',BI_Account_SubType__c='Fabricator',Recordtypeid=BISURFACEAcc_RTYPE);
        insert accSurf;
        Entitlement entTyvek1= new Entitlement(name='Rajiv',RecordtypeId=PRODUCTANDLABOUT_COB_RTYPE, stage__c='Registration In Progress',AccountId=accTyvek.Id);
        insert entTyvek1;
        Entitlement entSurf1= new Entitlement(name='Rajiv1',Recordtypeid=SurfaceEntitlement,AccountId=accSurf.Id);
        insert entSurf1;
        
        Test.startTest();
         
         ApexPages.StandardController controller2 = new ApexPages.StandardController(entTyvek1);
        ctrlOverideEntitlementEdit c3 = new ctrlOverideEntitlementEdit(controller2);
        c3.redirect();
         
        ApexPages.StandardController controller = new ApexPages.StandardController(entTyvek1);
        ApexPages.currentPage().getParameters().put('id',entTyvek1.id);
        ctrlOverideEntitlementEdit c1 = new ctrlOverideEntitlementEdit(controller);
        c1.redirect();
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(entSurf1);
        ApexPages.currentPage().getParameters().put('id',entSurf1.id);
        ctrlOverideEntitlementEdit c2 = new ctrlOverideEntitlementEdit(controller1);
        c2.redirect();
            
            
        
               
        Test.stopTest();
        
       
       }
    }
    }
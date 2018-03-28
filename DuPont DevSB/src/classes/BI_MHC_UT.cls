/**
Test method for classes - BI_MHC and External Initiative Handler
*/
@isTest
private class BI_MHC_UT {
    static User fallbackUser;
    //static final String DEFAULTCOUNTRY = 'US';
    /*<AB20130917> Starts*/
    static User fallbackUser2;
    public static RecordType geoRTSurfaces;
    /*<AB20130917> Ends*/
    static Account fallbackAccount;
    static void LoadTestData(){
        Profile profileId2=[select id from Profile where Name='System Administrator'];
        fallbackUser=new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='test_User3@infosys.com',Username='test_User3test@InfyDupont.com.test',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser;
        /*<AB20130917> Starts*/
        fallbackUser2=new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='test_User_BI_MHC@DuPont.com',Username='test_User_BI_MHC@DuPont.com',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser2;        
        /*<AB20130917> Ends*/
        fallbackAccount = new Account(name='FallBackAccount', country__c='United States');
        insert fallbackAccount;
        LIST<BI_NA_MHC_Settings__c> settings =new LIST<BI_NA_MHC_Settings__c>();
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='TYVEK',       FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='TYVEK',           OppAgentType__c='CLT_Tyvek',    OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',            GeoMapRecordType__c='MHC_Tyvek'));
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='FLUIDAPPLIED',FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='FLUIDAPPLIED',    OppAgentType__c='CLT_Fluid',    OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',    GeoMapRecordType__c='MHC_Fluid_Applied'));
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='SURFACES',    FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='SURFACES',        OppAgentType__c='CLT_Surfaces', OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',         GeoMapRecordType__c='MHC_Surfaces'));
        //settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='SURFACES',    FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='SURFACES',        OppAgentType__c='CLT_Surfaces', OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',         GeoMapRecordType__c='BI-NA Opportunity Owner 2'));
        upsert settings BI_NA_MHC_Settings__c.Name;
        
    }

    static List<External_Initiative__c> LoadProjects(){
        List<Geography_Mapping__c> listGeographyMapping = new List<Geography_Mapping__c>();
        List<Geography__c> listGeography1= new List<Geography__c>();
        try{
            LoadTestData();
            
        }Catch(Exception e){
            System.debug(e);
        }
        geoRTSurfaces = RType.getRecordTypeByDevName('Geography_Mapping__c', 'MHC_Surfaces');
        Geography__c geoNew5,geoNew2,geoNew3,geoNew4,geoNew1;
        
        geoNew5 = new Geography__c(Name='North America', Code__c='R_NORTH_AMERICA',Level__c=1.00,Code2__c='NORTH_AMERICA', Level_Name__c='Region');
        //insert geoNew5;
        listGeography1.add(geoNew5); 
        
        try{
            geoNew2 = new Geography__c(Name='United States', Code__c='SR_UNITED_STATES',Level__c=2.00,Code2__c='UNITED_STATES', Level_Name__c='Sub-Region',Parent__c=geoNew5.Id);
            //insert geoNew2; 
            listGeography1.add(geoNew2); 
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew3 = new Geography__c(Name='UNITED STATES', Code__c='US',Level__c=3.00,Code2__c='USA', Level_Name__c='Country',Parent__c=geoNew2.Id);
            // insert geoNew3;  
            listGeography1.add(geoNew3);
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew4 = new Geography__c(Name='Montana', Code__c='84030',Level__c=4.00,Code2__c='MT', Level_Name__c='State',Parent__c=geoNew3.Id);
            //insert geoNew4;  
            listGeography1.add(geoNew4);
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew1 = new Geography__c(Name='Jefferson', Code__c='84030043',Level__c=5.00,Code2__c='30043', Level_Name__c='County',Parent__c=geoNew4.Id);
            //insert geoNew1;  
            listGeography1.add(geoNew1);
            if(listGeography1.size()>0){
                insert listGeography1;}
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            Geography_Mapping__c geoCounty1 = new Geography_Mapping__c(Geography__c= geoNew1.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser.Id, Owning_Organization__c = 'BI', RecordType=geoRTSurfaces);
            //insert geoCounty1;
            listGeographyMapping.add(geoCounty1);}
        catch(Exception e){
            system.debug(e);
        }
        /*<AB20130917> Starts*/
        RecordType geoBINAOppOwner2 = RType.getRecordTypeByDevName('Geography_Mapping__c', 'BI_NA_Opportunity_Owner_2');        
        try{
            Geography_Mapping__c geoCountry2 = new Geography_Mapping__c(Geography__c= geoNew4.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser2.Id, Owning_Organization__c = 'BI', RecordType=geoBINAOppOwner2, RecordTypeId=geoBINAOppOwner2.id);
            //insert geoCountry2; 
            listGeographyMapping.add(geoCountry2);
            if(listGeographyMapping.size()>0){
                insert listGeographyMapping;
            }
        }
        Catch(Exception e){
            System.debug(e);
        }
        Geography.Countries countriesObject= new Geography.Countries();       
        try{
            MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>( [Select Id from Geography__c where parent__c =: countriesObject.getCountry('US').Id]);
            //DB20150617 start
             //MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>( [Select Id from Geography__c where parent__c =: countriesObject.getCountry('US').Id]);
             
            //County
            MAP<id, Geography__c> CountiesIds = new MAP<id, Geography__c>( [Select Id,code__c from Geography__c where parent__c =: stateIds.Keyset()]);
           //DB20150617 end
        }Catch(Exception e){
            System.debug(e);
        }
        
        /*<AB20130917> Ends*/
        List<External_Initiative__c> cps = new List<External_Initiative__c>();
        /*cps.add(new External_Initiative__c(name='test1',State__c='DE', County__c='New Castle',External_ID__c='01', External_Version__c=1, External_Search_Name__c='TYVEK_WPL'));
        cps.add(new External_Initiative__c(name='test2',State__c='MT', County__c='Jefferson',Country__c='United States',External_ID__c='02',External_Version__c=1, External_Search_Name__c='SURFACES_WPL'));
        cps.add(new External_Initiative__c(name='test3',State__c='AL', County__c='Pickens',External_ID__c='03',External_Search_Name__c='BOGUS_WPL'));
        cps.add(new External_Initiative__c(name='test4',State__c='BE', County__c='sLower Delaware',External_ID__c='04',External_Search_Name__c='FLUIDAPPLIED_WPL'));
        cps.add(new External_Initiative__c(name='test5',State__c='NV', County__c='Clark County',External_ID__c='05',External_Search_Name__c='TYVEK_WPL, SURFACES_PINN,FluidApplied-WPL'));
        
        */
        //insert cps;
        return cps;
        
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////DB20150617 start
    static void LoadTestDataCan(){
        Profile profileId2=[select id from Profile where Name='System Administrator'];
        fallbackUser=new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='test_User3@infosys.com',Username='test_User3test@InfyDupont11.com',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser;
        /*<AB20130917> Starts*/
        fallbackUser2=new User(LastName='test_User2',Alias='tUser1',ProfileId=profileId2.id,Email='test_User_BI_MHC@DuPont.com',Username='test_User_BI_MHC@DuPont.com',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser2;        
        /*<AB20130917> Ends*/
        fallbackAccount = new Account(name='FallBackAccount', country__c='Canada');
        insert fallbackAccount;
        LIST<BI_NA_MHC_Settings__c> settings =new LIST<BI_NA_MHC_Settings__c>();
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='TYVEK',       FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='TYVEK',           OppAgentType__c='CLT_Tyvek',    OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',            GeoMapRecordType__c='MHC_Tyvek'));
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='FLUIDAPPLIED',FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='FLUIDAPPLIED',    OppAgentType__c='CLT_Fluid',    OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',    GeoMapRecordType__c='MHC_Fluid_Applied'));
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='SURFACES',    FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='SURFACES',        OppAgentType__c='CLT_Surfaces', OppRecordTypeDevName__c='BI_NA_MHC_Opportunity',         GeoMapRecordType__c='MHC_Surfaces'));
        //settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='SURFACES1',    FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='SURFACES1',  OppAgentType__c='CLT_Surfaces', OppRecordTypeDevName__c='BI_NA_MHC_Opportunity', GeoMapRecordType__c='BI-NA Opportunity Owner 2'));
        upsert settings BI_NA_MHC_Settings__c.Name;
        
        List<BINAOwner2__c> BINAOwnerSetting = new List<BINAOwner2__c>();
        BINAOwnerSetting.add(new BINAOwner2__c(name='S_ApplicationType', value__c = 'CLT-Surfaces'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='TF_ApplicationType_CLTTyvek', value__c = 'CLT-Tyvek'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='TF_ApplicationType_CLTFluid', value__c = 'CLT-Fluid'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='TF_EISegmentL2_AnimalPlant', value__c = 'Animal/Plant'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='S_EISegmentL2_Clinic', value__c = 'Clinic'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='S_EIStage_Abandoned', value__c = 'Abandoned'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='TF_EIStage_Bidding', value__c = 'Bidding')); 
//[01272016] Merge&Spin: Added custom setting data for BI_Dodge_Filter_Helper class
        BINAOwnerSetting.add(new BINAOwner2__c(name='TF_EIValue', value__c = '250000000'));
        BINAOwnerSetting.add(new BINAOwner2__c(name='S_EIValue', value__c = '90000000'));
        insert BINAOwnerSetting;
    }
    
    static void LoadGeography_Canada(){
        List<Geography_Mapping__c> listGeographyMapping = new List<Geography_Mapping__c>();
        List<Geography__c> listGeography1= new List<Geography__c>();
        try{
            //LoadTestData();
            LoadTestDataCan();
    
        }Catch(Exception e){
            System.debug(e);
        }
        geoRTSurfaces = RType.getRecordTypeByDevName('Geography_Mapping__c', 'BI_NA_Opportunity_Owner_2');
        Geography__c geoNew5,geoNew2,geoNew3,geoNew4,geoNew1;
       
        geoNew5 = new Geography__c(Name='North America', Code__c='R_NORTH_AMERICA',Level__c=1.00,Code2__c='NORTH_AMERICA', Level_Name__c='Region');
        
        listGeography1.add(geoNew5); 
        
        try{
            geoNew2 = new Geography__c(Name='Canada', Code__c='SR_CANADA',Level__c=2.00,Code2__c='CANADA', Level_Name__c='Sub-Region',Parent__c=geoNew5.Id);
          
            listGeography1.add(geoNew2); 
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew3 = new Geography__c(Name='CANADA', Code__c='CA',Level__c=3.00,Code2__c='CAN', Level_Name__c='Country',Parent__c=geoNew2.Id);
             
            listGeography1.add(geoNew3);
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew4 = new Geography__c(Name='YT', Code__c='CA-YT',Level__c=4.00,Code2__c='YT', Level_Name__c='State',Parent__c=geoNew3.Id);
            
            listGeography1.add(geoNew4);
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            geoNew1 = new Geography__c(Name='Teslin', Code__c='124Y0A',Level__c=5.00,Code2__c='Y0A', Level_Name__c='County',Parent__c=geoNew4.Id);
            
            listGeography1.add(geoNew1);
            if(listGeography1.size()>0){
                insert listGeography1;
                
                }
                system.debug('Size of listGeography1 '+listGeography1.size());
                system.debug('List values for  listGeography1 are '+listGeography1);
        }Catch(Exception e){
            System.debug(e);
        }
        try{
            Geography_Mapping__c geoCounty1 = new Geography_Mapping__c(Geography__c= geoNew1.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser.Id, Owning_Organization__c = 'BI', RecordType=geoRTSurfaces);
            
            listGeographyMapping.add(geoCounty1);}
        catch(Exception e){
            system.debug(e);
        }
        /*<AB20130917> Starts*/
        RecordType geoBINAOppOwner2 = RType.getRecordTypeByDevName('Geography_Mapping__c', 'BI_NA_Opportunity_Owner_2');        
        try{
            Geography_Mapping__c geoCountry2 = new Geography_Mapping__c(Geography__c= geoNew4.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser2.Id, Owning_Organization__c = 'BI', RecordType=geoBINAOppOwner2, RecordTypeId=geoBINAOppOwner2.id);
            
            listGeographyMapping.add(geoCountry2);
            
        }
        Catch(Exception e){
            System.debug(e);
        }
        
        //DB20150619 start
          RecordType geoBINAOppOwner3 = RType.getRecordTypeByDevName('Geography_Mapping__c', 'BI_NA_Opportunity_Owner_2');        
        try{
            Geography_Mapping__c geoCountry3 = new Geography_Mapping__c(Geography__c= geoNew3.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser2.Id, Owning_Organization__c = 'BI', RecordType=geoBINAOppOwner2, RecordTypeId=geoBINAOppOwner2.id);
            
            listGeographyMapping.add(geoCountry3);
            if(listGeographyMapping.size()>0){
                insert listGeographyMapping;
            }
             system.debug('Size of listGeographyMapping'+listGeographyMapping.size());
                system.debug('List values for  listGeographyMapping are '+listGeographyMapping);
        }
        Catch(Exception e){
            System.debug(e);
        }
        //DB20150619 end
        //List<External_Initiative__c> cps11 = new List<External_Initiative__c>();
        //cps11.add(new External_Initiative__c(name='test1',Country__c='CA',State__c='CA-YT', County__c='124Y0A',External_ID__c='01',External_Search_Name__c='TYVEK_WPL',Segment_L1__c='4',Segment_L2__c='Food Service, Clinic',Segment_L3__c='Building Additions, New Construction',Segment_L4__c='4',Value__c=250000003,Stage__c='Planning'));
        //insert cps11;
        Geography.Countries countriesObject= new Geography.Countries(); 
        //countriesObject.getCountry(cps11[0].Country__c);      
        try{
            MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>( [Select Id from Geography__c where parent__c =: countriesObject.getCountry('CA').Id]);
            //DB20150617 start
             //MAP<id, Geography__c> stateIds = new MAP<id, Geography__c>( [Select Id from Geography__c where parent__c =: countriesObject.getCountry('US').Id]);
             
            //County
            MAP<id, Geography__c> CountiesIds = new MAP<id, Geography__c>( [Select Id,code__c from Geography__c where parent__c =: stateIds.Keyset()]);
           //DB20150617 end
        }Catch(Exception e){
            System.debug(e);
        }
        
        /*<AB20130917> Ends*/
        /*List<External_Initiative__c> cps = new List<External_Initiative__c>();
        cps.add(new External_Initiative__c(name='test1',State__c='DE', County__c='New Castle',External_ID__c='01', External_Version__c=1, External_Search_Name__c='TYVEK_WPL'));
        cps.add(new External_Initiative__c(name='test2',State__c='MT', County__c='Jefferson',Country__c='United States',External_ID__c='02',External_Version__c=1, External_Search_Name__c='SURFACES_WPL'));
        cps.add(new External_Initiative__c(name='test3',State__c='AL', County__c='Pickens',External_ID__c='03',External_Search_Name__c='BOGUS_WPL'));
        cps.add(new External_Initiative__c(name='test4',State__c='BE', County__c='sLower Delaware',External_ID__c='04',External_Search_Name__c='FLUIDAPPLIED_WPL'));
        cps.add(new External_Initiative__c(name='test5',State__c='NV', County__c='Clark County',External_ID__c='05',External_Search_Name__c='TYVEK_WPL, SURFACES_PINN,FluidApplied-WPL'));*/
        
        
        //insert cps;
       // return cps;
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////DB20150617 end
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
  
    //DB20150617 started coding
    static testMethod void BI_MHC_method2()
    {
     Test.startTest();
    //constructor
    BI_MHC.Assignment assignment=new BI_MHC.Assignment();
    List<External_Initiative__c> prjs;
    prjs = LoadProjects();
    Geography__c geoNew1 = new Geography__c(Name='Jefferson', Code__c='825874566552',Level__c=5.00,Code2__c='30043', Level_Name__c='County');
    Geography_Mapping__c geoCounty1 = new Geography_Mapping__c(Geography__c= geoNew1.Id,Account__c = fallbackAccount.Id, User__c = fallbackUser.Id, Owning_Organization__c = 'BI', RecordType=geoRTSurfaces);
    BI_MHC.Assignment assignment1=new BI_MHC.Assignment(geoCounty1);
     Test.stopTest();
       BI_MHC.Assignment assignment2=new BI_MHC.Assignment(fallbackUser.Id,fallbackAccount.Id);
       Set<Id> geoIds=new set<Id>(); 
       Set<string> rTypes=new Set<string>();
       BI_MHC.GeoAssignment geoassignment2=new BI_MHC.GeoAssignment(geoIds,rTypes);
       Geography_Mapping__c my_mapping=geoassignment2.getGeoMapping(geoNew1.Id,'Test'); 
    }
    
    static testMethod void BI_MHC_method3()
    {
     LoadGeography_Canada();
     Test.startTest();
     List<External_Initiative__c> cps = new List<External_Initiative__c>();
     cps.add(new External_Initiative__c(name='test1',Country__c='CA',State__c='CA-YT', County__c='Teslin',External_ID__c='01',External_Search_Name__c='TYVEK_WPL',Segment_L1__c='4',Segment_L2__c='Food Service, Clinic',Segment_L3__c='Building Additions',Segment_L4__c='4',Value__c=250000003,Stage__c='Planning',Data_Source__c='Dodge'));//<AS20161026> include the data source to create EI
     insert cps;
     Opportunity opp=new Opportunity(Name='TESTTYVEKCAN',Application_Type__c='CLT-Fluid',External_Initiative__c=cps[0].id,StageName='Propose',CloseDate=Date.Today());
     insert opp;
     Opportunity opp1=new Opportunity(Name='TESTTYVEKCAN1',Application_Type__c='CLT-Surfaces',External_Initiative__c=cps[0].id,StageName='Propose',CloseDate=Date.Today());
     insert opp1;
     cps[0].Value__c=250000005;
     update cps;
     BI_MHC.UpdateOpportunities(cps);
     Test.stopTest();
    
  
        
    }
    
    
   static testMethod void BI_MHC_method4()
    {
     Test.startTest();
    //Geography__c geoNew1 = new Geography__c(Name='Alliance', Code__c='124T0B',Level__c=5.00,Code2__c='T0B', Level_Name__c='FSA');
    //insert geoNew1 ;
     LoadGeography_Canada();
     List<External_Initiative__c> cps = new List<External_Initiative__c>();
     cps.add(new External_Initiative__c(name='test1',Country__c='CA',State__c='AB', County__c='Teslin',External_ID__c='01',External_Search_Name__c='TYVEK_WPL',Segment_L1__c='4',Segment_L2__c='Food Service, Clinic',Segment_L3__c='Building Additions, New Construction',Segment_L4__c='4',Value__c=250000003,Data_Source__c='Dodge'));//<AS20161026> include the data source to create EI
     insert cps;
     cps[0].Value__c=250000005;
     update cps;
     BI_MHC.UpdateOpportunities(cps);
     Test.stopTest();
    //update opportunity
  
        
    }
    
    static testMethod void BI_MHC_method5()
    {
     Test.startTest();
    
     
      Map<Integer,External_Initiative__c>EIObjectMap = new Map<Integer,External_Initiative__c>();
      External_Initiative__c EIObject2 = new External_Initiative__c(name='OppOwnerTest4',State__c='MT', County__c='US',External_ID__c='251', External_Version__c=14, External_Search_Name__c='TYVEK_WPL,SURFACES_WPL',Specification_L1__c='Fluid Applied-Tyvek',Specification_L2__c='Test3',Stage__c='Bid Result',Initiative_Size__c=20000000,Data_Source__c='Dodge');//<AS20161026> include the data source to create EI 
      
      EIObjectMap.put(2,EIObject2);
      External_Initiative__c EIObject1 = new External_Initiative__c(name='OppOwnerTest3',State__c='MT', County__c='US',External_ID__c='250', External_Version__c=12, External_Search_Name__c='TYVEK_WPL,SURFACES_WPL',Specification_L1__c='CommercialWrap',Specification_L2__c='Test2',Stage__c='Bidding',Initiative_Size__c=30000000,Data_Source__c='Dodge');//<AS20161026> include the data source to create EI
      EIObjectMap.put(1,EIObject1);
      try{insert EIObjectMap.values();
        }
        catch (Exception ex) {
            system.debug('Expected ERROR: '+ex);
        }
        LIST<ID> EIID = new LIST<ID>();
        EIID.add(EIObject1.Id);
        EIID.add(EIObject2.Id);
      List<Opportunity> OppsToUpdate = new List<Opportunity>();
      List<Opportunity> opportunityObjectList = new List<Opportunity>();
      
      OppsToUpdate = [Select Id, External_Initiative__r.External_ID__c,Application_Type__c, recordtype.name,External_Initiative__r.Stage__c, External_Initiative__r.Specification_L1__c from Opportunity where External_Initiative__r.Id IN : EIID ORDER BY ID limit 1001];
       For(Opportunity OpportunityObject: OppsToUpdate){
            if(OpportunityObject.External_Initiative__r.id == EIObject1.id){
                OpportunityObject.Opportunity_Rating__c = 'A';
                OpportunityObject.Amount =10000000;
                OpportunityObject.Application_Type__c = 'CLT-Fluid';
                opportunityObjectList.add(OpportunityObject);
                
            }
            else if(OpportunityObject.External_Initiative__r.id == EIObject2.id){
                OpportunityObject.Opportunity_Rating__c = 'B';
                OpportunityObject.Amount =10000000;
                OpportunityObject.Application_Type__c = 'CLT-Tyvek';
                opportunityObjectList.add(OpportunityObject);
            }
        }
        
        try {
            EIObjectMap.get(1).External_Search_Name__c = 'FluidAppliedNew';}
        catch (Exception ex) {
            system.debug('Expected ERROR: '+ex);
        }
        
        try{update EIObjectMap.values();
        }
        catch (Exception ex) {
            system.debug('Expected ERROR: '+ex);
        }
        
     Test.stopTest();

  
        
    }
 
 
 static testMethod void BI_MHC_method6()
    {
     Test.startTest();
     //LoadTestDataCan();
      Profile profileId2=[select id from Profile where Name='System Administrator'];
        fallbackUser=new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='test_User3@infosys.com',Username='test_User3test@InfyDupont.com.test',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser;
        /*<AB20130917> Starts*/
        fallbackUser2=new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='test_User_BI_MHC@DuPont.com',Username='test_User_BI_MHC@DuPont.com',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert fallbackUser2;        
        /*<AB20130917> Ends*/
        fallbackAccount = new Account(name='FallBackAccount', country__c='Canada');
        insert fallbackAccount;
        
        LIST<BI_NA_MHC_Settings__c> settings =new LIST<BI_NA_MHC_Settings__c>();
        
        settings.add(new BI_NA_MHC_Settings__c(SearchAgentPrefix__c='SURFACES',    FallbackOwnerId__c=fallbackUser.id, FallbackAccountId__c=fallbackAccount.id, Name='SURFACES',  OppAgentType__c='CLT_Surfaces', OppRecordTypeDevName__c='BI_NA_MHC_Opportunity', GeoMapRecordType__c='BI-NA Opportunity Owner 2'));
        upsert settings BI_NA_MHC_Settings__c.Name;
       
       
      // BI_NA_MHC_Settings__c temp=[Select id from BI_NA_MHC_Settings__c Where SearchAgentPrefix__c='SURFACES' and GeoMapRecordType__c='BI-NA Opportunity Owner 2'];
      
     List<External_Initiative__c> cps1 = new List<External_Initiative__c>();
     cps1.add(new External_Initiative__c(name='test1',Country__c='CA',State__c='AB', County__c='Teslin',External_ID__c='01',External_Search_Name__c='TYVEK_WPL',Segment_L1__c='4',Segment_L2__c='Food Service, Clinic',Segment_L3__c='Building Additions, New Construction',Segment_L4__c='4',Value__c=250000003,Data_Source__c='Dodge'));//<AS20161026> include the data source to create EI
     insert cps1;
     Id testid;
     BI_MHC.ProjectGeoAssignments prjassign=new BI_MHC.ProjectGeoAssignments(cps1);
     prjassign.getAssignment(cps1[0].id,Settings[0]);
     prjassign.getAssignment(testid,Settings[0]);
       
    }
    //DB20150617 end coding 
    
    //<AS20161026> Start, code coverage for new method 'AddOpportunities_CIC'
    static testMethod void BI_MHC_method7(){
        Test.startTest();        
        List<External_Initiative__c> eiList = new List<External_Initiative__c>();
        External_Initiative__c EIObject1 = new External_Initiative__c(name='OppOwnerTestCIC1',Description__c='test',Full_External_Initiative_Name__c='OppOwnerTestCIC1',Project_Level__c='Parent',Country__c='India',EI_Region__c='Asia-Pacific',External_ID__c='2510', External_Search_Name__c='SURFACES',Stage__c='Bid Result',Data_Source__c='CIC Construction');
        External_Initiative__c EIObject2 = new External_Initiative__c(name='OppOwnerTestCIC2',Description__c='test',Full_External_Initiative_Name__c='OppOwnerTestCIC1',Project_Level__c='Parent',Country__c='Brazil',EI_Region__c='South and Central America',External_ID__c='2511', External_Search_Name__c='SURFACES',Stage__c='Bid Result',Data_Source__c='CIC Construction');
        eiList.add(EIObject1);
        eiList.add(EIObject2);
        BI_MHC.AddOpportunities_CIC(eiList);
        Test.stopTest();
    }//<AS20161026> End 
 
    
}
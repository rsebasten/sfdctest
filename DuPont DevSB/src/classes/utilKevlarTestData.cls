/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Tabrez Ansari
Email: tabrez.ansari@tcs.com
Description:  This class is test data for the test class on the ctrlDPSYarnSpec_UT and ctrlDPSYarnSpecBasePDFUT test class.
Created Date: 9/30/2016
Version: 1.0
********************************************************************************/

@isTest
public class utilKevlarTestData{
    // Create Account
    public Account createAccount(){        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        return objAccount;
    }
    
    public User createPortalUser(){
        Account portalAccount1 = createAccount();
        Database.insert(portalAccount1);
        
        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com',
        Contact_Country__c = 'PALESTINIAN TERRITORY,OCCUPIED(PT)'
        );
        Database.insert(contact1);
        
        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE :Label.DPS_CUSTOMER_COMMUNITY_PROFILE Limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE 'Customer Service' Limit 1];
        
        User user = new User();
        user.Username = System.now().millisecond() + 'test12345@test.com';
        user.ContactId = contact1.Id;
        user.ProfileId = portalProfile.Id;
        user.Alias = 'test123';
        user.Email = 'test12345@test.com';
        user.EmailEncodingKey = 'UTF-8';
        user.FirstName = 'Test';
        user.LastName = 'McTesty';
        user.CommunityNickname = 'test12345';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        return user;
    }

    public List<Search_Criteria__c> createSearchCriteria(){
        //Account acct = createAccount();
        //insert acct;
        
        List<Search_Criteria__c> listSC = new List<Search_Criteria__c>();
        for(Integer i = 0; i < 50 ; i++){
            Search_Criteria__c objSearchCritPDF = new Search_Criteria__c();
            //objSearchCritPDF.KV_Customer__c = acct.Id;
            objSearchCritPDF.KV_OEM_Platform__c = 'Test Platform' + String.valueOf(i);
            objSearchCritPDF.KV_OEM_Country__c = 'India';
            objSearchCritPDF.KV_OEM__c = 'Test OEM';
            objSearchCritPDF.KV_Comments__c = 'Test Comment';
            objSearchCritPDF.KV_Operating_Temperature__c = '200';
            objSearchCritPDF.KV_Operating_Pressure_Value__c = 5;
            objSearchCritPDF.KV_Operating_Pressure_Unit__c = 'Bar';
            objSearchCritPDF.KV_Internal_Diameter_mm__c = 5;
            objSearchCritPDF.KV_Inner_Wall_Thickness_mm__c = 4;
            objSearchCritPDF.KV_Stitch_Length_Value__c = 5;
            objSearchCritPDF.KV_Stitch_Length_Unit__c = 'mm';
            objSearchCritPDF.KV_Knitting_Angle__c = 90;
            objSearchCritPDF.KV_Appropriate_Loop_Strength__c = 65.00;
            listSC.add(objSearchCritPDF);
        }
        return listSC;
    }
    
    // Create Product
    public Product2 createProduct(Integer i){
        Id prodrt = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(Label.DPS_Product_RecordType).getRecordTypeId();
        Product2 prod = new Product2();
        prod.Name = 'Kevlar 1670-Z60-29AP-PW1883-' + i;
        prod.KV_Spinning__c = 'Filament';
        prod.KV_Twist__c = '60 Z';
        prod.KV_Polymer__c = 'Para-aramid';
        prod.KV_Count_dtex__c = 1670;
        prod.KV_Kevlar_Product__c = true;
        if(prodrt != null)
            prod.RecordTypeId = prodrt;
        return prod;
    }

    public Lead createLead(){
        Schema.DescribeSObjectResult schDesSObjRes = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> LeadRecordTypeInfo = schDesSObjRes.getRecordTypeInfosByName();
        Id rtId = LeadRecordTypeInfo.get('DPS-Kevlar-Lead').getRecordTypeId();
    
        Lead objLead = new Lead();
        objLead.FirstName = 'Test Fname';
        objLead.LastName = 'Test Lname';
        objLead.Company = 'Test Company';
        objLead.Email = 'abc@xyz.com';
        objLead.Phone = '1234567';
        objLead.MobilePhone = '123456789';
        objLead.Lead_Country__c = 'India';
        objLead.Type__c = 'Technical Assistance';
        objLead.Description = 'Test Desc';
        objLead.Opt_In__c = True;
        objLead.RecordTypeId = LeadRecordTypeInfo.get('DPS-Kevlar-Lead').getRecordTypeId();
        objLead.Owning_Organization__c = 'DPS-Kevlar';
        objLead.Owning_SBU__c = 'Protection Solutions';
        objLead.KV_DPS_Segment__c = 'Automotive';
        objLead.KV_DPS_SubSegment__c = 'Auto-Yarn';
        objLead.Origin_Channel_Type__c = 'Web-Mobile App';
        objLead.Origin_Name__c = 'Kevlar Auto Hose App';
            
        return objLead;
    }
    
    public Campaign createCampaign(){
        
        Campaign objCamp = new Campaign();
        objCamp.Name = 'DPT Opt-In Master List';
        objCamp.Status = 'Not Started';
        objCamp.IsActive = true;
        return objCamp;
    }    
        
    public List<Yarn_Specification__c> createYarnSpecification(){
    
        List<Product2> Listprod = new List<Product2>();
        
        for(Integer i = 0; i < 50; i++){
            Product2 prod = createProduct(i);
            Listprod.add(prod);
        }
        insert Listprod;
        
        List<Yarn_Specification__c> listYarnSpecification = new List<Yarn_Specification__c>();
        for(Integer i = 0; i < 50; i++){
            Yarn_Specification__c yarnspec = new Yarn_Specification__c();
            yarnspec.KV_Product__c = Listprod[i].id;
            yarnspec.KV_Operating_Temperature__c = '200';
            yarnspec.KV_0_Cycles__c = 143.88 + i;
            yarnspec.KV_50_Cycles__c = 102.15;
            yarnspec.KV_100_Cycles__c = 71.94;
            yarnspec.KV_170_Cycles__c = 46.04;
            yarnspec.KV_250_Cycles__c = 35.97;
            yarnspec.KV_350_Cycles__c = 102.15;
            yarnspec.KV_500_Cycles__c = 0.00;
            yarnspec.KV_750_Cycles__c = 0.00;
            yarnspec.KV_1000_Cycles__c = 0.00;
            listYarnSpecification.add(yarnspec);
        }         
            
        return listYarnSpecification;
    }
    
    public DPSKevlarCustomSetting__c createCustomSetting(){
        DPSKevlarCustomSetting__c dps=new DPSKevlarCustomSetting__c();
        dps.KV_inch_to_mm__c='25.4';
        dps.KV_Knitting_angle_lower_limit__c=70;
        dps.KV_Knitting_angle_upper_limit__c=90;
        dps.KV_PSI_to_Bar__c='0.0689475728';
        dps.KV_Campaing_Name__c = 'DPT Opt-In Master List';
        dps.KV_Inner_Wall_Thickness_Upper_Limit__c = 4;
        dps.KV_Inner_Wall_Thickness_Lower_Limit__c = 0.5;
        return dps;
    }
}
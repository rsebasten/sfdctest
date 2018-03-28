/**
Copyright @ 2010 DuPont. All rights reserved.
Description: Test methods for the 
             controller : 'ctrlDPT_NomexPartnerSearch',
             APEX class : 'DPT_NomexSearchResults' 
 */
@isTest
private class ctrlDPT_NomexPartnerSearch_UT {
    //Krish: Created new method for creating a portal user
    public static User createPortalUser() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User currentUser = [SELECT Id from User where id = :UserInfo.getUserId()];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2123.dps@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        system.runas(currentUser){
        Database.insert(portalAccountOwner1);
        }
        Account portalAccount1;
        Contact contact1;
        
            //Create account
            portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
                    
            //Create contact
            contact1 = new Contact(
                FirstName = 'Test',
                    Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                    Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Community User%' Limit 1];
        User user1;
        system.runas(portalAccountOwner1){
        user1 = new User(
            Username = System.now().millisecond() + 'test1234533.dps@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);}
        return User1;
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    ////////       Test method for batch class: 'ctrlDPT_NomexPublicSearch'          /////////
    //////////////////////////////////////////////////////////////////////////////////////////
    static testMethod void myUnitTest1() {
        Account accNew = new Account(Name = 'testAccount1a', Country__C = 'India');
        insert accNew;

        Contact conNew = new Contact(FirstName = 'test_Contact1', LastName = 'testContaCT', email = 'abc.123@xyze.com', AccountId = accNew.id);
        insert conNew;

        Profile profileId1 = [select id from profile where usertype = 'PowerPartner' limit 1];
        //Profile profileId1 = [select id from Profile where Name='System Administrator'];
        //Krish: repaced exisitng code for creating portal user with call to creating portal user method
        //User user1 =new User(LastName='test_User1',ContactId=conNew.Id, Alias='tUser', ProfileId=profileId1.id, Email='test_User1@abc.com',Username='test_User1@abc.com.test2',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        //insert user1;
        User user1 = createPortalUser();
        System.runAs(user1){
            ctrlDPT_NomexPartnerSearch obj = new ctrlDPT_NomexPartnerSearch();
            List<String> qualRiskOfAreaList = new List<String>();
            qualRiskOfAreaList.add('Electrical Arc Potection');
            obj.closePopup();
            obj.showPopup();
            obj.getItemsColour();
            obj.getItemsConstructions();
            obj.getItemsSubType();
            obj.getItemsQualificationMainEndUse();
            obj.getItemsQualificationRiskArea();
            obj.setSelectQualificationRiskArea(qualRiskOfAreaList);
            obj.SelectQualificationRiskAreaValue = obj.getSelectQualificationRiskArea(); 
            obj.loadScripts();      
            obj.getQualificationListNext();
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////       Test method for batch class: 'DPT_NomexSearchResults'          /////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    static testMethod void myUnitTest2() {
        // sample data creation
        Account accNew = new Account(Name = 'testAccountA1', Country__C = 'India');
        insert accNew;

        Contact conNew = new Contact(FirstName = 'test_Contact2', LastName = 'testContaCT2', email = 'abc.123.abc@xyze.com', AccountId = accNew.id);
        insert conNew;

        Id RecordTypeIdQual =   Rtype.getIdByDevName('Qualification__c','Fabric Certification');
        Qualification__c qualNew = new Qualification__c(RecordTypeId=RecordTypeIdQual,Account_Name__c=accNew.Id,Weight__c=199,SubType__c='Fabric - Outer layer',Status__c='Approved',Other_Criteria_Met__c='High Visibility; Contact Heat Protection',Make_Visible_To__c='Catalogue',Main_End_Uses__c='Industrial',End_Date__c=Date.newInstance(2100,06,09),Construction__c='Woven- Plain',Colour__c='Piece-Dyed - Royal Blue');
        insert qualNew;

        //SFDC_Script__c scriptId = [Select Id from SFDC_Script__c where Name = 'DPP Fabric Certification'];
        SFDC_Script__c SFDCS = new SFDC_Script__c();
        SFDCS.Name = 'DPP Fabric Certification';
        insert SFDCS;
        SFDC_Script_Header__c sriptHeaderNew = new SFDC_Script_Header__c(Qualification__c=qualNew.Id, Script__c=SFDCS.Id);
        insert sriptHeaderNew;

        //SFDC_Questions__c scriptQuestion1 = [Select sq.id, sq.Name from SFDC_Questions__c sq where sq.Script__c=:SFDCS.Id and sq.Name='Extra Comfort'];
        SFDC_Questions__c scriptQuestion1 = new SFDC_Questions__c();
        scriptQuestion1.Name = 'Extra Comfort';
        scriptQuestion1.Script__c = SFDCS.id;
        insert scriptQuestion1;
        SFDC_Script_Result__c scriptResult1 = new SFDC_Script_Result__c(Script_Result__c=sriptHeaderNew.Id,QuestionId__c=scriptQuestion1.Id,Question__c='Extra Comfort',Answer__c='YES');
        insert scriptResult1;
        //SFDC_Questions__c scriptQuestion2 = [Select sq.id, sq.Name from SFDC_Questions__c sq where sq.Script__c=:SFDCS.Id and sq.Name='Extra Aesthetic Performance'];
        SFDC_Questions__c scriptQuestion2 = new SFDC_Questions__c();
        scriptQuestion2.Name = 'Extra Aesthetic Performance';
        scriptQuestion2.Script__c = SFDCS.id;
        insert scriptQuestion2;
        SFDC_Script_Result__c scriptResult2 = new SFDC_Script_Result__c(Script_Result__c=sriptHeaderNew.Id,QuestionId__c=scriptQuestion2.Id,Question__c=scriptQuestion2.Name,Answer__c='YES');
        insert scriptResult2;
        //SFDC_Questions__c scriptQuestion3 = [Select sq.id, sq.Name from SFDC_Questions__c sq where sq.Script__c=:SFDCS.Id and sq.Name='Extra Water and Oil Repellency'];
        SFDC_Questions__c scriptQuestion3 = new SFDC_Questions__c();
        scriptQuestion3.Name = 'Extra Water and Oil Repellency';
        scriptQuestion3.Script__c = SFDCS.id;
        insert scriptQuestion3;
        SFDC_Script_Result__c scriptResult3 = new SFDC_Script_Result__c(Script_Result__c=sriptHeaderNew.Id,QuestionId__c=scriptQuestion3.Id,Question__c=scriptQuestion3.Name,Answer__c='YES');
        insert scriptResult3;
        /*SFDC_Questions__c scriptQuestion4 = [Select sq.id, sq.Name from SFDC_Questions__c sq where sq.Script__c=:scriptId.Id and sq.Name='Extra Long Lasting Performance'];
        SFDC_Script_Result__c scriptResult4 = new SFDC_Script_Result__c(Script_Result__c=sriptHeaderNew.Id,QuestionId__c=scriptQuestion4.Id,Question__c=scriptQuestion4.Name,Answer__c='YES');
        insert scriptResult4;*/
        //SFDC_Questions__c scriptQuestion5 = [Select sq.id, sq.Name from SFDC_Questions__c sq where sq.Script__c=:SFDCS.Id and sq.Name='Extra Mechanical Performance'];
        SFDC_Questions__c scriptQuestion5 = new SFDC_Questions__c();
        scriptQuestion5.Name = 'Extra Mechanical Performance';
        scriptQuestion5.Script__c = SFDCS.id;
        insert scriptQuestion5;
        SFDC_Script_Result__c scriptResult5 = new SFDC_Script_Result__c(Script_Result__c=sriptHeaderNew.Id,QuestionId__c=scriptQuestion5.Id,Question__c=scriptQuestion5.Name,Answer__c='YES');
        insert scriptResult5;

        Profile profileId2 = [select id from profile where usertype = 'PowerPartner' limit 1];
        //Profile profileId1 = [select id from Profile where Name='System Administrator'];
        //Krish: repaced exisitng code for creating portal user with call to creating portal user method
        //User user2 =new User(LastName='test_User2',ContactId=conNew.Id, Alias='tUser', ProfileId=profileId2.id, Email='test_User2@abc.com',Username='test_User2@abc.com.test2',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        //insert user2;
        User user2 = createPortalUser();

        System.runAs(user2){
            List<String> riskAreaList = new List<String>();
            riskAreaList.add('High Visibility');
            riskAreaList.add('Contact Heat Protection');
            List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList> resultList = new List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList>();
            ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults obj1 = new ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults();
            resultList = obj1.hasVisibility('Woven- Plain', '%Blue%', riskAreaList, 'Industrial', 'Fabric - Outer layer', 200, 215);
            List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList> resultList1 = new List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList>();
            ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults obj2 = new ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults();
            resultList1 = obj2.hasVisibility('Woven- Plain', '%Blue%', riskAreaList, 'Industrial', 'Fabric - Outer layer', 0, 0);
            List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList> resultList2 = new List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList>();
            ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults obj3 = new ctrlDPT_NomexPartnerSearch.DPT_NomexSearchResults();
            resultList2 = obj3.hasVisibility('Woven- Plain', '%Blue%', riskAreaList, 'none', 'Fabric - Outer layer', 0, 200);
            System.debug('THE FINAL RESULT LIST SIZE IS::::::::::::::::::::::::::::'+resultList.size());
        }
    }
}
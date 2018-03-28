/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: sreedhar jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  UnitTest(s) for class ctrlDPT_NomexLeftNav
********************************************************************************/

@isTest
private class ctrlDPT_NomexLeftNav_UT{

       static GroupMember grpMember = new GroupMember();
       static GroupMember grpMember1 = new GroupMember();
       static User user = new User();

    private static void starter(){
        createUser();
    }
    
    static void createUser(){
            user.Username = 'test@us.xyz.com';
            user.LastName = 'LastTestName';
            user.Email = 'test@us.xyz.com';
            user.alias = 'testAl';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
            user.LanguageLocaleKey = 'en_US';
            user.CommunityNickname = 'Test';
            user.EPass_ID__c='NA0000';
            user.User_Owning_Org__c='CORP';
            user.User_Country__c='UNITED STATES';
            user.User_Grouping__c='CORP';
            user.User_Region__c='NA';
            insert user;
       
    }  
        static void createGrpAndGrpMember(){
            Group grp = new Group();
            grp.Name = 'DPT Nomex Fabric';
            insert grp;
            
            Group grp1 = new Group();
            grp1.Name = 'DPT Nomex Weaver';
            insert grp1;
           
            grpMember.UserOrGroupId = user.Id;
            grpMember.GroupId = grp.id;
            insert grpMember;
            grpMember1.UserOrGroupId = user.Id;
            grpMember1.GroupId = grp1.id;
            insert grpMember1;
            
        }
        
        

        static TestMethod void test_Group_Member(){
           Test.startTest();
           ctrlDPT_NomexLeftNav gmp = new ctrlDPT_NomexLeftNav();
           gmp.getGroups();
           system.debug(gmp.NewButtons);
           Test.stopTest();
           
         
        }
}
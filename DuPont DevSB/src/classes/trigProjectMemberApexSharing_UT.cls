/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Date : 26th Dec 2011
Description : Test class for trigProjectmember

* Modification Log 
* ============================================================================= 
* Ver   Date        Author                 Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   26-Dec-11   Sreedhar Jagannath     Initial Code
* 1.1   10-jan-16   Priya                  Usernames in the testCreateUsers() method
**************************************************************************************************************/

@isTest
private class trigProjectMemberApexSharing_UT{
    
    public static User sysUser;
    public static User user2;
    public static User user3;
    
    static testmethod void testCreateUsers() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        //<Priya20160216> Modified usernames
        sysUser = new User(LastName='XYZ',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='XYZ@infosys.com',UserName='XYZ_DPtest@infosys.com', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        user2 = new User(LastName='XYZ1',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='XYZ1@infosys.com',UserName='XYZ1_DPtest@infosys.com', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        user3 = new User(LastName='XYZ2',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='ain1235',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='XYZ2@abc.com',UserName='XYZ2_DPtest@abc.com', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        User [] users=new User[]{sysUser,user2,user3};
        insert users;
        
    }

     static testMethod void testAddSharesforReadWrite() {
                testCreateUsers();  
                System.RunAs(sysUser){
                CRM_IT_Project__c proj1 = new CRM_IT_Project__c(Name = 'TEST',OwnerId = sysUser.Id);
                insert proj1;
                Project_Member__c pm1 = new Project_Member__c(Access__c ='Read/Write',CRM_IT_Project__c = proj1.Id,Project_Member__c = user2.Id);
                insert pm1;
                Project_Member__c pm2 = new Project_Member__c(Access__c ='Read/Write',CRM_IT_Project__c = proj1.Id,Project_Member__c = user3.Id);
                insert pm2;
                
                List<Project_Member__c> pms = new List<Project_Member__c>();
                pms.add(pm1);
                pms.add(pm2);
                
                // get a set of all new created ids
                Set<ID> ids = new Set<ID>();
                for (Project_Member__c pm : pms)
                ids.add(pm.CRM_IT_Project__c);

                List<CRM_IT_Project__Share> shares = [select id from CRM_IT_Project__Share where 
                   ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                    //System.assertEquals(shares.size(),2);
                    
                    ProjectMemberHandler.refreshprojmembers(new SET<Id> {pm1.id});
                    delete pm1;
                }
                }
                
      static testMethod void testAddSharesforReadOnly() {
                
                testCreateUsers();
                System.RunAs(sysUser){
                CRM_IT_Project__c proj1 = new CRM_IT_Project__c(Name = 'TEST',OwnerId =sysUser.Id);
                insert proj1;
                Project_Member__c pm1 = new Project_Member__c(Access__c ='Read Only',CRM_IT_Project__c = proj1.Id,Project_Member__c = user2.Id);
                insert pm1;
                Project_Member__c pm2 = new Project_Member__c(Access__c ='Read Only',CRM_IT_Project__c = proj1.Id,Project_Member__c = user3.Id);
                insert pm2;
                
                List<Project_Member__c> pms = new List<Project_Member__c>();
                pms.add(pm1);
                pms.add(pm2);
                
                // get a set of all new created ids
                Set<ID> ids = new Set<ID>();
                for (Project_Member__c pm : pms)
                ids.add(pm.CRM_IT_Project__c);

                List<CRM_IT_Project__Share> shares = [select id from CRM_IT_Project__Share where 
                   ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                    //System.assertEquals(shares.size(),2);
                }
                }
                
       static testMethod void testUpdateProjectMembers (){
                
                testCreateUsers();
                System.RunAs(sysUser){
                CRM_IT_Project__c proj1 = new CRM_IT_Project__c(Name = 'TEST',OwnerId =sysUser.Id);
                insert proj1;
                Project_Member__c pm1 = new Project_Member__c(Access__c ='Private',CRM_IT_Project__c = proj1.Id,Project_Member__c = user2.Id);
                insert pm1;
                Project_Member__c pm2 = new Project_Member__c(Access__c ='Private',CRM_IT_Project__c = proj1.Id,Project_Member__c = user3.Id);
                insert pm2;
     
                List<Project_Member__c> pms = new List<Project_Member__c>();
                pms.add(pm1);
                pms.add(pm2);
                
                // get a set of all new created ids
                Set<ID> ids = new Set<ID>();
                for (Project_Member__c pm : pms)
                ids.add(pm.CRM_IT_Project__c);
                
                update pms;
                 
                List<CRM_IT_Project__Share> shares = [select id from CRM_IT_Project__Share where 
                   ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                    //System.assertEquals(shares.size(),0);
                
     
                for (Project_Member__c pm : pms)
                pm.Access__c = 'Read/Write';
                
                update pms;
                
                shares = [select id from CRM_IT_Project__Share where ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                //System.assertEquals(shares.size(),2);
                
                for (Project_Member__c pm : pms)
                pm.Access__c = 'Read Only';
                
                update pms;
                
                shares = [select id from CRM_IT_Project__Share where ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                //System.assertEquals(shares.size(),2);

                for (Project_Member__c pm : pms)
                pm.Access__c = 'Private';
                
                update pms;
                
                shares = [select id from CRM_IT_Project__Share where ParentId IN :ids and RowCause = 'Apex_Sharing_Access__c'];
                //System.assertEquals(shares.size(),0);
                }
             }
             
   }
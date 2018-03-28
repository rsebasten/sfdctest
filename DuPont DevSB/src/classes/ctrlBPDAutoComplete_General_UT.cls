@isTest
public class ctrlBPDAutoComplete_General_UT{
  
        static testMethod void test() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        geoValidation.validateInTestMode=false;
        
        ctrlBPDAutoComplete_General.query('Trademark_Abuse_Sample__c','a','','');
        ctrlBPDAutoComplete_General.query('Trademark_Abuse_Sample__c','a','name,Address__c','name');
        
        }
        }
        }
@IsTest
public class TMSBUTopLevel {
public static testMethod void mytest(){
    Test.startTest();
    geoValidation.DisableGeoValidationOverride = true;

    //Update to fix test class failure related to portal account owner
    Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
    UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    User owner = new User();

    System.runAs (thisUser) {
        owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',isActive = true,username='customerservice@customerservice.com');
        insert owner;
       
    }
   
    System.runAs(owner) {
        Account a = new Account(name='test', country__c='US');
        Account b = new Account(name='test2',country__c='US');
        Account c = new Account(name='test3',country__c='US');
        a.Owning_Organization__c='test-test';
        b.Owning_Organization__c='IT&S';
        c.Owning_Organization__c=' ';
        insert a;
        insert b;
        insert c;
    }
    Test.stopTest();
}       
}
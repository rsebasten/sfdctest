@isTest
private class DateTimeFieldUtils_UT {
    static testMethod void DateTimeFieldUtilsUnitTest() 
    {/*
        SVMXC__Service_Order__c so=new SVMXC__Service_Order__c();
         datetime dt = datetime.now().addDays(-1);
        so.SVMXC__Actual_Initial_Response__c =dt;
        insert so;*/
        List<RecordType > lstCaseRecTypes = new list<RecordType >();
        List<RecordType > lstaccountRecTypes = new list<RecordType >();
        lstCaseRecTypes = [select Id ,name from RecordType where sobjectType = 'Case' and name in ('CS-Internal Request', 'CS-Order', 'CS-Service Request')];
        //commented for dps
        //lstaccountRecTypes  = [select Id ,name from RecordType where sobjectType = 'account' and name ='ERP customer'];
        lstaccountRecTypes  = [select Id ,name from RecordType where sobjectType = 'account' and name ='ERP Customer-General'];
        
         //Update to fix test class failure related to portal account owner
        Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
        UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];

        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User owner = new User();

        System.runAs (thisUser) {
            owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',isActive = true,username='customerservice@customerservice.com');
            insert owner;
           
        }
        
        Account account = new Account();
        
        System.runAs(owner) {

            account = new Account(
                                        Name ='Account',
                                        ShippingStreet='ABC',
                                        ShippingCity='PQR ',
                                        ShippingState = 'XYZ',
                                        ShippingPostalCode='111',
                                        ShippingCountry='XYZ',
                                        BillingStreet='ABC',
                                        BillingCity='PQR ',
                                        BillingState = 'XYZ',
                                        BillingPostalCode='111',
                                        BillingCountry='XYZ',
                                        recordtypeId = lstaccountRecTypes[0].Id
                                        ); 
            insert account;
        }
 
 
        Contact contact = new Contact(LastName='Last',AccountId =account.Id,Email='svmxmailfortest@gmail.com');
        insert contact;
 
       
        Case case1 = new Case(Status ='New', Priority = 'Medium', 
                                        Origin = 'Email',                                        
                                        CurrencyIsoCode = 'USD',                                            
                                        ContactId =contact.Id,
                                        AccountId=account.Id,
                                        recordtypeId = lstCaseRecTypes[0].Id                                         
                                        ); 
        
        
        insert case1; 
       
        test.startTest();
       
        ApexPages.currentPage().getParameters().put('ObjId', case1.id);
        ApexPages.currentPage().getParameters().put('FieldAPIName', 'SVMXC__Actual_Initial_Response__c');
        ApexPages.currentPage().getParameters().put('ObjAPIName', 'Case');
    DateTimeFieldUtils dtf=new DateTimeFieldUtils();
    dtf.updateObject();
    ApexPages.currentPage().getParameters().put('ObjId', contact.id);
        ApexPages.currentPage().getParameters().put('FieldAPIName', 'SVMXC__Actual_Initial_Response__c');
        ApexPages.currentPage().getParameters().put('ObjAPIName', 'Case');
        DateTimeFieldUtils dtf2=new DateTimeFieldUtils();
        dtf2.updateObject();
        
        test.stopTest();
    }

}
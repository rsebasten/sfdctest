@isTest
public class ctrlOverrideNew_UT {
    public static testMethod void test_PageInit() { 
        test.startTest();
            FieldDefaults__c settings = FieldDefaults__c.getOrgDefaults();
            
            settings.DF00N4100000SIpR5__c = '@User.User_Country__c';
            settings.DF00N30000002jgSW__c = '@User.User_Country__c';
            settings.DF00N4100000SIq95__c = '@User.User_Country__c';
            insert settings;
            
            ctrlOverrideNew ctrl = new ctrlOverrideNew(new ApexPages.StandardController(new Lead()));
            system.debug(ctrl.init());
            ctrlOverrideNew ctrl1 = new ctrlOverrideNew();
            
            
            DefaultFields objDf = new DefaultFields ();
            
            DefaultFields.FieldDefaults dfd = new DefaultFields.FieldDefaults(new FieldDefaults__c());
            DefaultFields.FieldDefaults dfd2 = new DefaultFields.FieldDefaults('FieldDefaults__c');
            dfd2.defaultFor('test');
            String urlparam = dfd2.UrlParams ;
        test.stopTest();
    }
    
}
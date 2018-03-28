@isTest(SeeAllData=true)
public class productsChanged_UT{

    static testMethod void testproductsChanged_UT() {
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User u1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='test123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Naga_Neelam@Infosys.com',UserName='Naga_Neelam@Infosys.com.test', EPass_ID__c='ib2423',User_Owning_Org__c='CORP',User_Country__c='INDIA',User_Grouping__c='CORP',User_Region__c='Asia Pacific');
        insert u1;
    Final Id Rec1=RType.getIdByDevName('Qualification__c','BI_NA_Certification_Env');
     System.runAs(u1){
     Test.startTest();
    
        Account abc = new Account(Name='TestAccount', Site='INDIA', Type='Customer', BI_Account_SubType__c = 'Distribution', Account_Stage__c = 'Active', Country__c = 'UNITED STATES', Owning_Organization__c = 'BI-Env', ShippingStreet = 'Electronics City', ShippingCity = 'Bengaluru', ShippingState = 'Karnataka', ShippingPostalCode = '560100', ShippingCountry = 'INDIA');
        insert abc;
        ApexPages.currentPage().getParameters().put('accid', abc.id);
        
        Qualification__c q1 = new Qualification__c(Account_Name__c = abc.id, Certified_In_Area__c = 'DWSRCI', Primary_Contact_Name__c = 'xyz', Primary_Contact_Email__c = 'naga.neelam@infosys.com', Type__c = 'Certification', Stage__c = 'Completed Training', Channel_Manager__c = u1.id, Training_Completed__c = 'DuPont™ StraightFlash™', Products_Changed__c=false, RecordTypeId = Rec1);

        insert q1;

        Qualification__c q2 = new Qualification__c(Account_Name__c = abc.id, Certified_In_Area__c = 'DWSRCI', RecordTypeId =Rec1, Primary_Contact_Name__c = 'NAGA', Primary_Contact_Email__c = 'Naga_Neelam@Infosys.com', Type__c = 'Certification', Stage__c = 'Complete', Channel_Manager__c = u1.id, Training_Completed__c = 'DuPont™ StraightFlash™', Products_Changed__c=true);
        insert q2;
        
        ProductsChanged ProdsChanged = new ProductsChanged(new ApexPages.StandardController(q2));
        ProdsChanged.getisProductButtonDisabled();
        ProdsChanged.geturlForTriggeringDDP();
        ProdsChanged.urlForTriggeringDDP();
        
        
        Qualification__c q3 = new Qualification__c(Account_Name__c = abc.id, Certified_In_Area__c = 'DWSRCI', RecordTypeId = rec1, Primary_Contact_Name__c = 'NAGA', Primary_Contact_Email__c = 'Naga_Neelam@Infosys.com', Type__c = 'Certification', Stage__c = 'Complete', Channel_Manager__c = u1.id, Training_Completed__c = 'DuPont™ StraightFlash™', Products_Changed__c=false);
        insert q3;
        
        ProductsChanged ProdsChanged3 = new ProductsChanged (new ApexPages.StandardController(q3));
        
    Test.stopTest();     
    
    }
  }
}
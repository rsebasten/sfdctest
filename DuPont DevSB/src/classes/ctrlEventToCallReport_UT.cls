/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlEventToCallReport
*******************************************************************************/
//[01182017] Merge&Spin : Moved test method from main class 'ctrlEventToCallReport' to create new test class and updated test method.  
@isTest
public class ctrlEventToCallReport_UT {
    public static testMethod void test_ctrlMyProfile1() {

        geoValidation.DisableGeoValidationOverride=true;
        //Add tester as Contact and add to lst Campaign as status = member-transactional
        Account a = new Account(name='test', Country__c='United States');
        insert a;
        Contact c = new Contact(lastname='test', Accountid=a.id, Contact_Country__c='United States');
        insert c;
        Initiative__c Initiative = new Initiative__c();
            Initiative.Name = 'TestInitiative';
            //KT [11072017]: To remove season__c reference
            //Initiative.season__c = 'Winter';
            //KT [11072017]: To remove Profile_Year__c reference
            //Initiative.Profile_Year__c = '2014';
            Initiative.Product_Line__c = 'Sorghum';
            insert Initiative;      
        Event ev = new Event(
            //AccountId             = a.id  //not writable
            WhoId               = c.id
            ,whatId             = Initiative.Id
            ,Subject            = 'Subject Text'
            ,Direction__c       = 'Outbound'
            ,Status__c          = 'Completed'
            ,Description        = 'Description Text'
            ,Channel__c         = 'Face to Face'
            ,Activity_Type__c   = 'Customer Interaction'
            ,ActivityDateTime   = DateTime.now()
            ,location           = 'my office'
            ,DurationInMinutes  = 60
            );
        insert ev;

        Test.startTest();
    //  PageReference pageRef = Page.EventToCallReport;
        PageReference pageRef = new PageReference('/apex/EventToCallReport?id='+ev.id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id',ev.id);
        ctrlEventToCallReport controller = new ctrlEventToCallReport();
        controller.init();
        system.debug('----event--->'+controller.event);
        system.debug('----callReport--->'+controller.callReport);
        
       PageReference pg = new PageReference('/apex/EventToCallReport');
       Test.setCurrentPage(pg);
        ctrlEventToCallReport ctrl = new ctrlEventToCallReport();
        ctrl.init();

        ev.whatId = a.Id;
        update ev;
        PageReference pg1 = new PageReference('/apex/EventToCallReport?id='+ev.id);
        Test.setCurrentPage(pg1);
        
        ApexPages.currentPage().getParameters().put('id',ev.id);
        ctrlEventToCallReport ctrl1 = new ctrlEventToCallReport();
        ctrl1.init();
        Test.stopTest();
    
    }   
}
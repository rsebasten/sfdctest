@isTest                   
public class ctrlResetPassword_UT {
    static testMethod void myTest(){
    //[01032017] Merge&Spin: Replaced hard coding of user id with test user
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    UserRole ur = new UserRole(Name = 'DuPont Fully Owned');
    insert ur;
    User user1 = TestUserUtil.createTestUser(ur.id,p1.id,'Test FirstName','Test LastName');
    insert user1;
    List<SObject> lstobjectFieldMapping = new list<SObject>();
    system.runAs(user1){
        lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
        
//        IssueAutoAssignmentSettings__c assignmentSetting = new IssueAutoAssignmentSettings__c(name='AssociateHoursEndingShift',value__c='2');
//        insert assignmentSetting ;
        
        PageReference pageRef = Page.resetPassword;
        Test.setCurrentPageReference(pageRef);
        SFDC_Access_Request__c cont = new SFDC_Access_Request__c();
        cont.Type__c = 'Test';
        cont.Key_User__c = user1.id;
        cont.Program__c = 'IT';
        cont.Type__c = 'Deactivate User';
        cont.Subtype__c = 'New User Account';
        cont.SFDC_Instance__c = 'DuPont Tools';
        cont.EPass_ID__c = 'is2324';
        cont.Deactivation_Reason__c = 'Inactivity';
        cont.Like_this_User__c = user1.id;
        insert cont;
        //////// Starts <Anup08-05-15> /////////////////
        CRM_IT_Project__c crm= new CRM_IT_Project__c(name='Test');
        insert crm;
        Issue__c issue= new Issue__c(name='Test Issue');
        insert issue;
        //[01032017] Merge&Spin: Used custom settings to store field ID and remove hardcoding
        Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('SFDC Access Request_Related_Project');    
        ApexPages.currentPage().getParameters().put(objectFieldID.Field_ID__c+'_lkid',crm.id);// //Here 'CF00N3000000669QX_lkid' is a value which represents id of CRM record in URL
        //////// Ends <Anup08-05-15> /////////////////
        ApexPages.StandardController sc = new ApexPages.standardController(cont);
        ctrlResetPassword controller = new ctrlResetPassword(sc);
        
        list<SelectOption> listOptions = controller.getRecordTypes();
        PageReference peg=controller.redirect();
        ApexPages.currentPage().getParameters().put('CF00Na000000B3Idr_lkid',issue.id); 
        PageReference peg1=controller.redirect();  
        String sfar=controller.SFARRecordType;
    }
        
    }
}
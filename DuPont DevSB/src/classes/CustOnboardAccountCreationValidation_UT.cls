/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Mounika Kompalli
Email: mounika_kompalli@infosys.com
Description: Testclass written for the class CustOnboardAccountCreationValidation  
 ********************************************************************************/
@IsTest
private class CustOnboardAccountCreationValidation_UT
{
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User u = new User(Alias = 'standt45', Email='standarduser13@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1212', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser13434@testorg.com');
    private static final string TESTER_EMAIL = 'tester@test.com';
    static testMethod void CustOnboardAccountCreationValidationut()
    {
        PageReference pageRefOnboardReq = Page.COBNewCustomerCreation;  
        Test.setCurrentPage(pageRefOnboardReq);  
        Test.startTest();
       // CustOnboardAccountCreationValidation cob = new CustOnboardAccountCreationValidation();
        List<Account> acclist= new List<Account>();
        Map<ID,Account> acclist1= new MAp<ID,Account>();

        Account accl= new Account();
        accl.Name='Accountnew';
        accl.Account_Stage__c='Active';
        accl.Company_Code__c='0003';
        accl.SBU__c='F4';
        accl.Region__c='AP';

        insert accl;
        acclist.add(accl);

        List<COB_User_AccountCreationSettings__c> obj1= new List<COB_User_AccountCreationSettings__c>();

        COB_User_AccountCreationSettings__c obj= new COB_User_AccountCreationSettings__c();
        obj.Name='Accountnew';
        // obj.Account_Stage__c='Active';
        obj.Company_Code__c='0003';
        obj.SBU__c='F4';
        obj.Region__c='AP'; 
        obj.New_Account_Creation_Permit__c=false;
        insert obj;
        obj1.add(obj);

        ID ReqID=accl.id;
        CustOnboardAccountCreationValidation cob = new CustOnboardAccountCreationValidation();
        CustOnboardAccountCreationValidation.AccountCreationAccessValidation(acclist);
        CustOnboardAccountCreationValidation.insertAccSharingRules(acclist1);
         //<AlvinJohnson6/9/2015>
        //Description : commented in phase 2 no longer needed
        /*
        Account_Share_Matrix__c ac=new Account_Share_Matrix__c();
        ac.SBU__c='F4';
        ac.Owning_Organization__c='AP';
        ac.Name='Accountnew';
        insert ac;
        acclist1.put(ReqID,accl);
        CustOnboardAccountCreationValidation.AccountCreationAccessValidation(acclist); 
        CustOnboardAccountCreationValidation.insertAccSharingRules(acclist1);
        */
        //<--ChangesFinished-->
        Test.stopTest();
        
    }

}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Unit Test for AUAConfirmationPageHelper
//<AB20160808> To increase code coverage
********************************************************************************/
@isTest(SeeAllData=true)
public class AUAConfirmationPageHelper_UT {
    public static testMethod void LoadData() {
        
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole r= [Select id from UserRole where Name='PS CRM' limit 1];
        RecordType rt = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'SFAR_Modify_Access'];
       
        Account Acc1 = new Account(name='test Account1', country__c = 'UNITED STATES', ERP_Customer_Sold_To__c='ABC123');
        insert new Account[]{Acc1}; 
        Contact con1 = new Contact(LastNameLocal='test Contact1',lastname='test', AccountId =Acc1.Id,Status__c='Under Review');
        
        
        User user1=new User(LastName='XYZ',ProfileId=p.Id,Alias='sam12',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@dupont.com',UserName='test@usa.dupont.com.test1122', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America',contactId=con1.Id);//<AB20160808> 
        insert user1;
        SFDC_Access_Request__c sfar=new SFDC_Access_Request__c(key_user__c=user1.Id,Owning_Business__c='Performance Coatings',User_Access_Type__c='Portal',Program__c='CPC-LA',Type__c='Create new User',Subtype__c='New User Account',Status__c='New',RecordTypeId=rt.id);
        insert sfar;
        
        //AB20161227 Start
        CRM_IT_Project__c crmitp = new CRM_IT_Project__c(Name='Test',Project_Start_Date__c=Date.today(),Program__c='IT-Corp',TargetedGoLiveDate__c=date.Today(),SFDC_Instance__c='One-DuPont',Sandbox__c='QA',Project_Type__c='Compliance',Status__c='Active');
        Insert crmitp;
        
        User_Access_Review__c uar = new User_Access_Review__c(name='Test User Access Review Audit 2016',Process_Owner__c=UserInfo.getUserId(), Start_Date__c=Date.today(),CRM_IT_Project__c=crmitp.id);
        Insert uar;
        
        User_Access_Review_Details__c uard = new User_Access_Review_Details__c(CompanyName__c='DUPONT (THAILAND) LIMITED',Program__c='CPC',User_Owning_Org__c='AGCP-CPC' ,User_Owning_SBU_Org__c='Crop Protection',Approval__c='De-Activate',Approver__c=UserInfo.getUserId(),Audit_Process__c=uar.id,Review_Date__c=Date.today(),Name='Test User1',Org__c='DuPont',User_Email_Id__c='Test1@dupont.com',User_Id__c=UserInfo.getUserId(),User_ePass_Id__c='test4234',User_Name__c=Userinfo.getFirstName()+','+Userinfo.getLastName(),User_Permission_Sets__c='Test',User_Profile__c='Test',User_Public_Group__c='Test',User_Roles__c='Test',User_Type__c='Test',User_Grouping__C='CPC',User_Country__c='India', User_Region__c='Asia Pacific',Approving_Business__c='Corporate - IT'); ////<AB20160808> 
        User_Access_Review_Details__c uard1 = new User_Access_Review_Details__c(CompanyName__c='DUPONT (THAILAND) LIMITED',Program__c='CPC',User_Owning_Org__c='AGCP-CPC' ,User_Owning_SBU_Org__c='Crop Protection',Approval__c='De-Activate',Approver__c=UserInfo.getUserId(),Audit_Process__c=uar.id,Review_Date__c=Date.today(),Name='Test User2',Org__c='DuPont',User_Email_Id__c='Test2@dupont.com',User_Id__c=UserInfo.getUserId(),User_ePass_Id__c='test4235',User_Name__c=Userinfo.getFirstName()+','+Userinfo.getLastName(),User_Permission_Sets__c='Test',User_Profile__c='Test',User_Public_Group__c='Test',User_Roles__c='Test',User_Type__c='Test',User_Grouping__C='CPC',User_Country__c='India', User_Region__c='Asia Pacific',Approving_Business__c='Corporate - IT');////<AB20160808> 
        User_Access_Review_Details__c uard2 = new User_Access_Review_Details__c(CompanyName__c='DUPONT (THAILAND) LIMITED',Program__c='CPC',User_Owning_Org__c='AGCP-CPC' ,User_Owning_SBU_Org__c='Crop Protection',Approval__c='Modify',Approver__c=UserInfo.getUserId(),Audit_Process__c=uar.id,Review_Date__c=Date.today(),Name='Test User3',Org__c='Util',User_Email_Id__c='Test3@utility.com',User_Id__c=UserInfo.getUserId(),User_ePass_Id__c='test4236',User_Name__c=Userinfo.getFirstName()+','+Userinfo.getLastName(),User_Permission_Sets__c='Test',User_Profile__c='Test',User_Public_Group__c='Test',User_Roles__c='Test',User_Type__c='Test',User_Grouping__C='CPC',User_Country__c='India', User_Region__c='Asia Pacific',Approving_Business__c='Corporate - IT');//<AB20160808> 
        //AB20161227 End
        List<User_Access_Review_Details__c> uards = new List<User_Access_Review_Details__c>();
        uards.add(uard);
        uards.add(uard1);
        uards.add(uard2);
        
        insert uards;
        
        Test.startTest();
        apexpages.currentpage().getparameters().put('Id',uar.id);
        apexpages.currentpage().getparameters().put('changedAs',uard.id+'@@De-Activate@@Approved@@pg:frm:tspb:tspbs:tspbt:0:tsr:0:srForAS');
        executeTest(uar, sfar);
        apexpages.currentpage().getparameters().put('changedAs',uard1.id+'@@De-Activate@@Modify@@pg:frm:tspb:tspbs:tspbt:0:tsr:0:srForAS');
        executeTest(uar, sfar);
        apexpages.currentpage().getparameters().put('changedAs',uard2.id+'@@Modify@@De-Activate@@pg:frm:tspb:tspbs:tspbt:0:tsr:0:srForAS');
        executeTest(uar, sfar); 
        Test.stopTest();
    } 
    
    public static  void executeTest(User_Access_Review__c uar,SFDC_Access_Request__c sfar) {
        Test.setMock(HttpCalloutMock.class, new AUACPHMockCalloutTester_UT());
        
        AUAConfirmationPageHelper auacph = new AUAConfirmationPageHelper();
        
        if(auacph.dataOfDeActivateUARDS.size()>0){
            System.debug('test deactivate ==========>>>>>>>>>> '+auacph.dataOfDeActivateUARDS);
            auacph.sendMail(); 
        }
        
        if(auacph.dataOfModifyUARDS.size()>0){             
            System.debug('test modify ==========>>>>>>>>>> '+auacph.dataOfModifyUARDS);
            auacph.createSFARForId = auacph.dataOfModifyUARDS[0].id;
            PageReference pageRef = Page.AUAConfirmationPage;
            Test.setCurrentPage(pageRef);
            apexpages.currentpage().getparameters().put('changedAs',auacph.createSFARForId+'@@De-Activate@@Modify@@pg:frm:tspb:tspbs:tspbt:0:tsr:0:srForAS');
            apexpages.currentpage().getparameters().put('RecId',auacph.createSFARForId);
            apexpages.currentpage().getparameters().put('isApprovalDone','true');
            apexpages.currentpage().getparameters().put('isMailSent','true');
            
            auacph.createSFAR();
            
            apexpages.currentpage().getparameters().put('newid',String.valueOf(sfar.id));
            auacph.dmlOperation();
            auacph.save();
        }
        //auacph.getuardData(String.valueOf(uar.id));
        
        
    }
}
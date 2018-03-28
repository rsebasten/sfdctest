/*******************************************************************************
(C)2016
Author: krishnaveni duggaraju
Email: krishnaveni.duggaraju@tcs.com
Description:  This class is test class of Record Transfer class
 ********************************************************************************/

@istest(seeallData=true)
Public class CtrlRecordTransfer_UT{
    static testmethod void testRecordTransfer() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> userList = new List<User>();
        User user1 = new User();     
        user1.Username = 'testName1@abc.com';
        user1.LastName = 'lastname';
        user1.firstName = 'firstname';
        
        user1.Alias = 'tn';
        user1.CommunityNickname = 'test';
        user1.TimeZoneSidKey = 'America/Chicago';
        user1.LocaleSidKey = 'en_US';
        user1.EmailEncodingKey = 'UTF-8';
        user1.ProfileId = p.id;
        user1.LanguageLocaleKey = 'en_US';
        user1.email = 'testName1@abc.com';
        user1.isActive = true;
        userList.add(user1);
        
        User user2 = new User();
        user2.Username = 'testName2@abc.com';
        user2.LastName = 'name2';
        user2.Alias = 'tn2';
        user2.CommunityNickname = 'test2';
        user2.TimeZoneSidKey = 'America/Chicago';
        user2.LocaleSidKey = 'en_US';
        user2.EmailEncodingKey = 'UTF-8';
        user2.ProfileId = p.id;
        user2.LanguageLocaleKey = 'en_US';
        user2.email = 'testName2@abc.com';
        user2.isActive = true;        
        userList.add(user2);        
        
        insert userList;
        
        Issue__c issueObj = new Issue__c();
        issueObj.Name = 'test';
        issueObj.Description__c ='Test';
        //issueObj.SFDC_Instance__c = 'One Dupont Corporate';
        issueObj.Program__c = 'IT';
        issueObj.Region__c = 'Asia Pacific';
        issueObj.Type__C = 'Data';
        issueObj.lastTimeStatusChanged__c = System.now();
        issueObj.Classification__c = 'Enhance (Design)';
        //issueObj.Approving_Business__c = 'Corporate - IT';
        issueObj.Status__c = 'Accepted' ;
        issueObj.RelatedUser__c = user1.id;
        issueObj.ownerId = user1.id;        
        
        insert issueObj;
        
        user1=[select id, Username from user where id=:user1.id];
        //ApexPages.StandardController sc = new ApexPages.StandardController(issueObj);
        CtrlRecordTransfer recordTransfer = new CtrlRecordTransfer();
        
        PageReference pageRef = Page.Transfer_Of_Records;
        Test.setCurrentPage(pageRef);
        recordTransfer.selectedObject='--None--';
        recordTransfer.TransferFrom='';
        recordTransfer.u.RelatedUser__c=null;
        recordTransfer.TransferOfRecords();
        
        recordTransfer.selectedObject='Contact';
        recordTransfer.TransferFrom='testuser'+system.now();
        recordTransfer.TransferOfRecords();
        
        recordTransfer.selectedObject='--None--';
        recordTransfer.TransferFrom=user1.Username;
        recordTransfer.TransferOfRecords();
        
        recordTransfer.selectedObject='Issue__c';
        recordTransfer.TransferFrom=user1.Username;
        recordTransfer.u.RelatedUser__c=null;
        recordTransfer.TransferOfRecords();
        
        
        recordTransfer.selectedObject='Issue__c';
        recordTransfer.TransferFrom=user1.Username;
        recordTransfer.u.RelatedUser__c=user1.id;
        recordTransfer.TransferOfRecords();
        
        
        recordTransfer.selectedObject='Issue__c';
        recordTransfer.TransferFrom=user1.Username;
        recordTransfer.u.RelatedUser__c=user2.id;
        recordTransfer.TransferOfRecords();
        
        recordTransfer.selectedObject='SVMXC__RMA_Shipment_Order__c';
        recordTransfer.TransferFrom=user1.Username;
        recordTransfer.u.RelatedUser__c=user2.id;
        recordTransfer.TransferOfRecords();     
        
        recordTransfer.selectedObject='Contact';
        recordTransfer.TransferFrom=user1.Username+' ';
        recordTransfer.u.RelatedUser__c=user2.id;
        recordTransfer.TransferOfRecords();
               
       
       recordTransfer.recordsOwnedByUser('select');
       
        recordTransfer.exportResults();
        string s=recordTransfer.xlsHeader;
        recordTransfer.changeOwnerShip(new List<Account>());
           
    }
}
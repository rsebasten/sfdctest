/*
 * Modification log
 * ==================================================================================================
 * ver        Date        Author                Modification
 * ---        ----       --------------         ------------
 * 1.0      2015-12-21   Diego Delgado          Unit test class of trigger used to sum up total cost of Cost Tracking to a Case Action
*/
@isTest(seeAllData=true)
public class trigSumCost_UT {

    testMethod
        static void sumCostTest(){
            
            RecordType caseRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'DPT_Partner_Case' AND SobjectType = 'Case' LIMIT 1];
            RecordType caseActionRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Technical_Case_Action' AND SobjectType = 'Case_Action__c' LIMIT 1];
            RecordType costTrackingRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'BI_Cost_Tracking' AND SobjectType = 'Cost_Tracking__c' LIMIT 1];
            RecordType accountRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'BI_Surfaces' AND SobjectType = 'Account' LIMIT 1];
            RecordType contactRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'BI_Carpet_Backing' AND SobjectType = 'Contact' LIMIT 1];
            
            //Creating Account
            Account account = new Account();
            account.RecordTypeId = accountRecordType.Id;
            account.Name = 'Test Account';
            account.Type = 'Customer';
            account.Account_Sub_Type__c = 'Dealer';
            account.Program__c = 'PHI';
            account.Country__c = 'BRAZIL';
            
            insert account;
        
            //Creating Contact
            Contact contact = new Contact();
            contact.RecordTypeId = contactRecordType.Id;
            contact.FirstName = 'Contact';
            contact.LastName = 'LastName';
            contact.AccountId = account.Id;
            contact.Program__c = 'PHI';
            contact.Contact_Country__c = 'BRAZIL';
            contact.Prefered_Language__c = 'ENGLISH';
            
            insert contact;
            
            //Creating a Pioneer LA-AF Complaint Case
            Case caseComplaint = new Case();
            caseComplaint.RecordTypeId = caseRecordType.Id;
            caseComplaint.Type = 'Complaint';
            caseComplaint.Country__c = 'Brazil';
            caseComplaint.Status = 'New';
            caseComplaint.Subject = 'Test';
            caseComplaint.Description = 'Description';
            //KT [11072017]: To remove Sales_Year__c reference
            //caseComplaint.Sales_Year__c = '2015';
            //KT [11072017]: To remove Sales_Season__c reference
            //caseComplaint.Sales_Season__c = 'Winter';
            caseComplaint.Reason = 'Delivery';
            caseComplaint.Subreason1__c = 'Damaged Bag';
            caseComplaint.ContactId = contact.Id;
            caseComplaint.AccountId = account.Id;
            
            insert caseComplaint;
            
            //Creating Case Action
            Case_Action__c caseAction = new Case_Action__c();
            caseAction.RecordTypeId = caseActionRecordType.Id;
            caseAction.Case__c = caseComplaint.Id;
            caseAction.ActionType__c = 'Solution';
            caseAction.ActionSubtype__c = 'Pardon Debt';
            caseAction.Description__c = 'Description';
            
            insert caseAction;
            
            //Creating Cost Tracking
            Cost_Tracking__c cost1 = new Cost_Tracking__c();
            cost1.RecordTypeId = costTrackingRecordType.Id;
            cost1.Case_Action__c = caseAction.Id;
            cost1.Cost_Element_Type__c = 'Customer Credit';
            cost1.ActualCost__c = 5000;
            cost1.CurrencyIsoCode = 'USD';
            
            insert cost1;
            
            caseAction = [SELECT Id, Actual_Total_Cost__c FROM Case_Action__c WHERE Id = :caseAction.Id];
            //System.assert(caseAction.Actual_Total_Cost__c == 5000);
            
            //Creating Cost Tracking
            Cost_Tracking__c cost2 = new Cost_Tracking__c();
            cost2.RecordTypeId = costTrackingRecordType.Id;
            cost2.Case_Action__c = caseAction.Id;
            cost2.Cost_Element_Type__c = 'Customer Credit';
            cost2.ActualCost__c = 3000;
            cost2.CurrencyIsoCode = 'USD';
            
            insert cost2;
            
            caseAction = [SELECT Id, Actual_Total_Cost__c FROM Case_Action__c WHERE Id = :caseAction.Id];
            //System.assert(caseAction.Actual_Total_Cost__c == 8000);
            
            //Deleting Cost Tracking
            delete cost1;
            
            caseAction = [SELECT Id, Actual_Total_Cost__c FROM Case_Action__c WHERE Id = :caseAction.Id];
            //System.assert(caseAction.Actual_Total_Cost__c == 3000);
            
        }
}
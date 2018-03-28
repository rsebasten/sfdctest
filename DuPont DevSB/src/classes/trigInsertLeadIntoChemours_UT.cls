@isTest
public class trigInsertLeadIntoChemours_UT 
{
    @isTest static void shareLeadTest() 
    {
        Lead l=new Lead();
        l.Owning_SBU__c='Chemicals & Fluoroproducts';
        l.Owning_Organization__c='DCF-ChemSol';
        l.Country='India';
        l.Region__c='Acia Pacific';
        l.FirstName='From';
        l.LastName='TestClass';
        l.Company='Chemours';
        l.Type__c='Literature';
        l.status='Qualify';
        insert l;
        
        Lead testLead = [select Id, FirstName from Lead where Id = :l.Id];
        //System.assertEquals(testLead.FirstName, 'From');  
    }
    @isTest static void shareLeadTestMethod1() 
    {
        Lead l=new Lead();
        l.Owning_SBU__c='Chemicals & Fluoroproducts';
        l.Owning_Organization__c='DCF-ChemSol';
        l.Country='India';
        l.Region__c='Acia Pacific';
        l.FirstName='From';
        l.LastName='TestClass1';
        l.Company='Chemours';
        l.Type__c='Literature';
        l.status='Qualify';
        l.Lead_Queue__c='DCF-NA C&D-DWT Lead Queued';
        insert l;
        
        Lead testLead = [select Id, FirstName,LastName from Lead where Id = :l.Id];
       //System.assertEquals(testLead.FirstName, 'From'); 
        testLead.LastName='TestClass2';
        update testLead;
         
    }
}
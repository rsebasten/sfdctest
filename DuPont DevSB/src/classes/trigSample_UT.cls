@isTest(seeAllData=false)
private class trigSample_UT{
    static testMethod void testRecordInsert(){ 
    test.startTest();   
    Trademark_Abuse_Sample__c tas = new Trademark_Abuse_Sample__c();
    tas.Address__c ='sample address';
    tas.Batch_Number__c ='test';
    tas.Country__c ='India';
    insert tas;
    test.stopTest();
    }
}
public class TestOpportunity {

public static testMethod void mytest(){

    Test.startTest();

    Date da1 = Date.newInstance(2006,11,11);
     //[12302016] Merge&Spin; Removed Hard Coded Id of DSS Consulting Record type on opportunity
    //Commented for dps
    //string DSS_Consulting=RType.getIdByDevName('Opportunity','DSS_Consulting');
    string DSS_Consulting=RType.getIdByDevName('Opportunity','OneDuPont');
    
    Opportunity o2 = new Opportunity(Owning_Organisation__c='DSRB',RecordTypeId=DSS_Consulting,Amount=1000,Amount_Type__c='One Time - Manual - Monthly', CurrencyIsoCode='EUR', CloseDate= da1,Name='Test opp', StageName='Qualify',Commercial_Revenue_Date__c= da1);
    //Opportunity o3 = new Opportunity(Owning_Organisation__c='DSRB',RecordTypeId='012300000000hKS',Amount=1000,Amount_Type__c='One Time - Manual - Monthly', CurrencyIsoCode='USD', CloseDate= da1,Name='Test opp Manu', StageName='Qualify',Commercial_Revenue_Date__c= da1);   
    //Opportunity[] s = new Opportunity[2];
    //s[0] = o3;
    //s[1] = o2;
       insert o2;
    
    Opportunity[] testz = [select Name, New_Duration__c from Opportunity Where Name = 'Test opp'];
    //testz[0].New_Duration__c = 0;
    //update testz[0];
    /*
    Opportunity[] testz2 = [select Name, New_Duration__c from Opportunity Where Name = 'Test opp Manu'];
    testz2[0].New_Duration__c = 0;
    update testz2;

    Opportunity[] testz3 = [select Name, New_Duration__c from Opportunity Where Name = 'Test opp Manu'];
    testz2[0].New_Duration__c = 100;
    update testz3;
*/

    Test.stopTest();
}       
       
}
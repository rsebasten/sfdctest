@isTest
/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved.
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Unit Test for Opportunity Calculate Custom Probability
********************************************************************************/
private class OpportunityCalcCustomProbability_UT {

    static testMethod void test_OpportunityCalcCustomProbability() {

          //Test Data
            //RecordTypeSettings__c rts = getRecordTypeSettingsTestData('Opportunity', 'IB_Standard', 'Qualify=4&Design Solution=24&Propose=54&Close=74&Ship %26 Support=91&s=StageName&d=Probability');// Fetching the settings based on record type
            //RecordTypeSettings__c rts1 = [Select r.OppCustomProbability__c, r.Name, r.FullName__c, r.LastModifiedDate, r.Id From RecordTypeSettings__c r where r.OppCustomProbability__c <>''];
            
            UtilRT.RT rt = UtilRT.getRT('Opportunity', 'DPT_AP');
            RecordTypeSettings__c rts1=rt.upsertSetting(new RecordTypeSettings__c(name='test_OpportunityCalcCustomProbability', fullname__c='Opportunity.DPT_AP', OppCustomProbability__c='Qualify=4&Design Solution=24&Propose=54&Close=74&Ship %26 Support=91&s=StageName&d=Probability'));
            
            system.debug('Opptestdatacreator class -->'+rts1);

            Test.startTest();
            utilRT.clearSettingsCache();

            MAP<string,string> settings = Util.mapUrlVars(rts1.OppCustomProbability__c);//Split URL into Map
            system.debug('settings: '+settings);

            List <Account> accList = prepareAccountTestData();
            insert accList[0];
            List <Opportunity> oppList = prepareOpportunityTestData(accList[0]);

            try{
                if(oppList.size()>0)
                    insert oppList;
            }catch (DmlException e) {
                String errorMessage = e.getMessage();
            }

            Opportunity []opp1 = [Select o.StageName, o.RecordTypeId, o.Probability, o.Name, o.CloseDate, o.AccountId From Opportunity o where id in: oppList ];

            Test.stopTest();

            system.debug('\n\n\n\n\n ======\n'+opp1);
            for(Opportunity opp: opp1){
                if(settings.containsKey(opp.StageName)){
                    system.debug('The stage and prob for current opp is '+opp.StageName+'   '+opp.Probability);
                    system.assertEquals(Integer.valueof(Settings.get(opp.StageName)), opp.Probability);
                }
            }

    }

    private static RecordTypeSettings__c getRecordTypeSettingsTestData(String stdObject, String devName, String strOppCustomProbabilityField){

            utilRT.RT rt = utilRT.getRT(stdObject,devName);
            RecordType rtrecord = rt.record;

            string fullname = stdObject+'.'+rt.devName;

            RecordTypeSettings__c rts = rt.getSettings();
            if (rts==null) {
                rts = new RecordTypeSettings__c(name='temp', fullname__c=fullname, OppCustomProbability__c=strOppCustomProbabilityField);
                insert rts;
            }else {
                rts.fullname__c=fullname;
                rts.OppCustomProbability__c=strOppCustomProbabilityField;
                update rts;
            }
            return rts;
}

 private  static  List<Account> prepareAccountTestData(){
             //Creation of Test Account
             List<Account> lstAcc= new List<Account>();
             Account acc = new Account(name='TestCo: ', country__c='United States');
             lstAcc.add(acc);
             return lstAcc;
 }

 private  static  List<Opportunity> prepareOpportunityTestData(Account acc){
            //Creating Test Data taken from Larry S Chen Spread Sheet
            utilRT.RT rt = utilRT.getRT('Opportunity', 'DPT_AP');
            
            List<Opportunity> lstOpp = new List<Opportunity>();
            Opportunity opp = new Opportunity (account = acc, name='Test 1a', stagename='Qualify', closedate=Date.today()+30, RecordTypeId=rt.id, probability=5);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 2a', stagename='Close', closedate=Date.today()+30, RecordTypeId=rt.id, probability=75);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 3a', stagename='Design Solution', closedate=Date.today()+30, RecordTypeId=rt.id, probability=25);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 4a', stagename='Qualify', closedate=Date.today()+30, RecordTypeId=rt.id, probability=5);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 5a', stagename='Ship & Support', closedate=Date.today()+30, RecordTypeId=rt.id, probability=100);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 6a', stagename='Target Plan', closedate=Date.today()+30, RecordTypeId=rt.id, probability=0);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 7a', stagename='Propose', closedate=Date.today()+30, RecordTypeId=rt.id, probability=50);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 8a', stagename='Close', closedate=Date.today()+30, RecordTypeId=rt.id, probability=75);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 9a', stagename='Design Solution', closedate=Date.today()+30, RecordTypeId=rt.id, probability=25);
            lstOpp.add(Opp);
            opp = new Opportunity (account = acc, name='TEST 10a', stagename='Qualify', closedate=Date.today()+30, RecordTypeId=rt.id, probability=5);
            lstOpp.add(Opp);

        return lstOpp;
    }





}
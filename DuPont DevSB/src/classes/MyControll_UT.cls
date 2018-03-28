@isTest
private class MyControll_UT {

    public static testMethod void myUnitTest() {
        test.startTest(); 
        Account acc = new Account();     
        acc.Name='ParentAccount'; 
        acc.country__c='United States'; 
        insert acc;
         //someId = '005a0000008XJ8N';
           Opportunity opp=new Opportunity();
           opp.account = acc;
           opp.name='test';
           opp.stagename='target';
           opp.closeDate=Date.Today();
           opp.CurrencyIsoCode='USD';
//opportunityList = [select  accountid, name,closedate, stagename from opportunity where (Status__c='Active') order by closedate asc limit 1];                            
       
          // opportunityList.add(opp);
           //insert opportunityList;
           insert opp;
        //Test.setCurrentPage(myVfPage);  
        system.currentPageReference().getParameters().put('Id', opp.Id);
   

        
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        
           MyControll myc =  new MyControll();
            
             //myc.MyControll();
              //myc.MyControll(opp.id);    
              myc.save();
              myc.getmycontroll();

           test.stopTest();   
           
           
 }
}
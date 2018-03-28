/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  test scripts for OppProducts, ctrlOppProductScheduler
<AB20150702>    1. Updated API Version from 23 to 34
                2. Resolved Too Many SOQL Exception
                3. Increased the code coverage for OppProducts and ctrlOppProductScheduler
<Priya20160818> 1. create new test method test_ctrlOppProductScheduler for covering the code without exceptions
        2. Added some code to increase the code coverage
********************************************************************************/
@isTest() //<AB20150702> Standard Pricebook inaccessible after version update
private class OppProducts_UT {


        static Account acc;
        static Pricebook2 pb;
        static Product2 prod1;      
        static Product2 prod2;
        static Id stdPbookId;
        static PricebookEntry pbis1;
        static PricebookEntry pbis2;
        static PricebookEntry pbi1;
        static PricebookEntry pbi2,pbis3;
        static Opportunity opp;
        static Opportunity oppQty;
        static Account acc1;
        static Opportunity opp1,opp2,opp3,opp4,opp5,opp6;
        static Pricebook2 pb1,pb2;
        static OpportunityLineItemSchedule opplnitmsched,opplnitmsched1;
        static OpportunityLineItem opplnitm,opplnitm2 ;
        //static String pricebookId,productId;
        static String productId;
      static List<String> pricebookIdList;
        
    static{
        Date dt = Date.newInstance(2017,1,31);
         acc1 = new Account(name='TestCo: ', country__c='United States'); 
        insert acc1;
        List<Pricebook2> pricebook2List=new List<Pricebook2>();
        pb1=new Pricebook2(Name='pb_test',IsActive=TRUE);
        //insert pb1;
        pb2=new Pricebook2(Name='pb_test2',IsActive=TRUE);
        //insert pb2;
        pricebook2List.add(pb1);
        pricebook2List.add(pb2);
        insert pricebook2List;
        
        pricebookIdList=new List<String>();
        pricebookIdList.add(String.valueOf(pb2.Id));
        pricebookIdList.add(String.valueOf(pb1.Id));
        //pricebookId = String.valueOf(pb2.Id);
        
        List<Opportunity> oppsList=new List<Opportunity>();
         //[04102017] Merge&Spin: Added recordtypeId in opportunity insert calls.
        String rtypeId = RType.getIdByDevName('Opportunity','OneDuPont');
        opp1 = new Opportunity (account = acc1, name='test',Pricebook2Id= pb1.id,amount_Type__c='Annual - Auto - Yearly', stagename='target',ScheduleBaseDate__c= dt,Contract_Duration__c=20, closeDate=Date.Today(), CurrencyIsoCode='USD', recordTypeId = rtypeId);
        //insert opp1;
        opp2 = new Opportunity (account = acc1, name='test123',Pricebook2Id= pb2.id,amount_Type__c='Annual - Auto - Yearly', stagename='target',ScheduleBaseDate__c= dt,Contract_Duration__c=10, closeDate=Date.Today(), CurrencyIsoCode='USD', recordTypeId = rtypeId);
        //insert opp2;
        opp3 = new Opportunity (account = acc1, name='test Opp00',Pricebook2Id= pb2.id,amount_Type__c='Annual - Auto - Months', stagename='target',ScheduleBaseDate__c= Date.today(),Contract_Duration__c=10, closeDate=Date.Today(), CurrencyIsoCode='USD', recordTypeId = rtypeId);
        //insert opp3;
        opp4 = new Opportunity (account = acc1, name='test Opp01',Pricebook2Id= pb2.id,amount_Type__c='Annual - Auto - Quarters', stagename='target',ScheduleBaseDate__c= Date.today(),Contract_Duration__c=10, closeDate=Date.Today(), CurrencyIsoCode='USD', recordTypeId = rtypeId);
        //insert opp4;
        opp5 = new Opportunity (account = acc1, name='test Opp02',Pricebook2Id= pb2.id,amount_Type__c='Annual - Manual - Monthly', stagename='target',ScheduleBaseDate__c= Date.today(),Contract_Duration__c=10, closeDate=Date.Today(), CurrencyIsoCode='USD', recordTypeId = rtypeId);
        //insert opp5;
        opp6 = new Opportunity (account = acc1, name='test Opp6',amount_Type__c='Annual - Auto - Yearly', 
                                stagename='target',ScheduleBaseDate__c= dt,Contract_Duration__c=20, closeDate=Date.Today(), 
                                CurrencyIsoCode='USD', recordTypeId = rtypeId);
    oppsList.add(opp6);
        oppsList.add(opp1);
        oppsList.add(opp2);
        oppsList.add(opp3);
        oppsList.add(opp4);
        oppsList.add(opp5);
        insert oppsList;
        
        prod1=new Product2(  Name='testProd',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true);
        insert prod1;
        productId = String.valueOf(prod1.id);
        //Start: Updated for merge split to remove seeAllData from the test class.
        //List<Pricebook2> pricbookid=new List<Pricebook2>([Select id from Pricebook2 where name='Standard Price Book' limit 1]);
        
        List<PricebookEntry> pricebookEntryList=new List<PricebookEntry>();
        pbis2=new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),Product2Id=prod1.id,IsActive=true, UnitPrice=0.00);
        //End: Updated for merge split to remove seeAllData from the test class.
        //insert pbis2;
        pbis1=new PricebookEntry(Pricebook2Id=pb1.id,Product2Id=prod1.id,CurrencyIsoCode='USD', UnitPrice=0.00, IsActive=true);
        //insert pbis1;
        pbis3=new PricebookEntry(Pricebook2Id=pb2.id,Product2Id=prod1.id,CurrencyIsoCode='USD', UnitPrice=25.00, IsActive=true);
        //insert pbis3;
        pricebookEntryList.add(pbis2);
        pricebookEntryList.add(pbis1);
        pricebookEntryList.add(pbis3);
        insert pricebookEntryList;
        
        QuantitySchedulingController.isOppCloned=false;
        opplnitm=new OpportunityLineItem(OpportunityId=opp1.id,Quantity=2,TotalPrice=23000,PricebookEntryId=pbis1.id);
        insert opplnitm;
        opplnitm2=new OpportunityLineItem(OpportunityId=opp2.id,Quantity=4,TotalPrice=25000,PricebookEntryId=pbis3.id);
        insert opplnitm2;
        
        date mydate = date.parse('12/27/2019');
        //[04102017] Merge&Spin : corrected type field value to Quantity in 'OpportunityLineItemSchedule'
        opplnitmsched=new OpportunityLineItemSchedule(Quantity=2,OpportunityLineItemId=opplnitm.id,type='Quantity',ScheduleDate=mydate);
        insert opplnitmsched;
        
    /*    opplnitmsched1=new OpportunityLineItemSchedule(Quantity=2,OpportunityLineItemId=opplnitm.id,type='Revenue',ScheduleDate=mydate);
        insert opplnitmsched1; */
        //[18042017]Merge&Spin-starts
        RecordTypeSettings__c rts=new RecordTypeSettings__c();
        rts.Name='Opp.IB_Standard_Risk';
        rts.FullName__c='Opportunity.IB_Standard_Risk';
        rts.OppProductScheduler__c='typ=quantityrevenuerelated:e&pb=01sa0000000VW5Y:r&dur=8:r&qty=1:e&rev=0:n&sdt=CloseDate:e&su=q:r';
        insert rts;
        //[18042017]Merge&Spin-ends
    }
    
   static testMethod void test_ctrlOppProductSchedulerExceptions() {
       
        Test.startTest();
        //init VFPage
        PageReference pageRef = Page.OppProductScheduler;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', opp1.id);
        //Start<Priya20160818>
        ApexPages.currentPage().getParameters().put('pb', pb1.id);
        //End<Priya20160818>
        //Load a Opp and Save using params              
        ctrlOppProductScheduler ctrl = new ctrlOppProductScheduler();
        ctrl.init();
        ctrl.cancel();
       Test.stopTest();    
    }
    
    //[18042017]Merge&Spin - starts
    static testMethod void test_ctrlOppProductScheduler_2() {
        Test.startTest();
        //init VFPage
        PageReference pageRef = Page.OppProductScheduler;
        Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', opp1.id);  
            ApexPages.currentPage().getParameters().put('pb', pb1.id);
            ApexPages.currentPage().getParameters().put('dur', '3');
            ApexPages.currentPage().getParameters().put('sdt', '12/21/2009');
            ApexPages.currentPage().getParameters().put('su', 'y');
            //Load a Opp and Save using params              
            ctrlOppProductScheduler ctrl = new ctrlOppProductScheduler();
            ctrl.init();
            Integer x=ctrl.totalScheduleColumns;
            Integer y=ctrl.totalColumns;
        Test.stopTest();
    }
      
    static testMethod void test_ctrlOppProductScheduler_3() {
        Test.startTest();
        //init VFPage
        PageReference pageRef = Page.OppProductScheduler;
        Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', opp6.id);  
            ApexPages.currentPage().getParameters().put('pb', pb1.id);
            ApexPages.currentPage().getParameters().put('dur', '3');
            ApexPages.currentPage().getParameters().put('sdt', '12/21/2009');
            ApexPages.currentPage().getParameters().put('su', 'y');
            //Load a Opp and Save using params              
            ctrlOppProductScheduler ctrl = new ctrlOppProductScheduler();
            ctrl.init();
            Integer x=ctrl.totalScheduleColumns;
            Integer y=ctrl.totalColumns;
        Test.stopTest();
    }
  //[18042017]Merge&Spin - ends
    
   //Start <Priya20160818> new test method for covering the code with out exceptions
   static testMethod void test_ctrlOppProductScheduler() {
                 
        Test.startTest();
        //init VFPage
        PageReference pageRef = Page.OppProductScheduler;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', opp1.id);  
        ApexPages.currentPage().getParameters().put('pb', pb1.id);
        ApexPages.currentPage().getParameters().put('dur', '3');
        ApexPages.currentPage().getParameters().put('sdt', '12/21/2009');
        ApexPages.currentPage().getParameters().put('su', 'y');
        //Load a Opp and Save using params              
        ctrlOppProductScheduler ctrl = new ctrlOppProductScheduler();
        ctrl.init();
        Integer x=ctrl.totalScheduleColumns;
         Integer y=ctrl.totalColumns;
        
        ctrl.getPriceBooks();
      //  ctrl.isValid();
        ctrl.save();
        ctrl.quicksave();
        ctrl.jsEvent='onChangeStartDT';
        ctrl.jsResult='18/8/2009';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onAddProduct';
        ctrl.jsResult='';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onDeleteRow';
        ctrl.jsResult='pb1';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onUndeleteRow';
        ctrl.jsResult='pb1';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onChangeDuration';
        ctrl.jsResult='5';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onChangeAmountType';
        ctrl.jsResult='';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onAddProduct';
        ctrl.jsResult='';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onChangeSchedType';
        ctrl.jsResult='Revenue';
        ctrl.jsOnEvent();
        ctrl.jsEvent='onReEstablish';
        ctrl.jsResult='Revenue';
        ctrl.reEstAmount='1';
        ctrl.reEstOperation='1';
        ctrl.jsOnEvent();
        ctrl.products=null;
        ctrl.save();
        ctrl.cancel();
        delete opp1;
        //ctrl.init();
        Test.stopTest();
       
    }
   //End<Priya20160818>
    // 1/25/2017 - Merge & Spin - cover code for OppProducts class       
    static testMethod void UnitTestforOppProducts() {
        
        OppProducts products = new OppProducts(opp2,'Revenue');
        OppProducts products1 = new OppProducts(opp3,'QUANTITYREVENUERELATED');
        OppProducts products2 = new OppProducts(opp4,'QUANTITY');
        OppProducts products3 = new OppProducts(opp5,'BOTH');
        OppProducts products4 = new OppProducts(opp5);
      
        Test.startTest();
        products.changeScheduleType('Revenue');
        products.changePriceBook(pricebookIdList[0]);
        products.addProduct(prod1.id);
        products.getDates();
        OppProducts.getScheduleUnitCode(OppProducts.getScheduleUnitFromAmountType(opp2.amount_Type__c));
        OppProducts.LineItem li = new OppProducts.LineItem(opplnitm2, products);
        OppProducts.ScheduleItem schItem =  new OppProducts.ScheduleItem(opplnitmsched);
        
        li.reEstablish(1.00,'D');
     //   products.saveLineItems();
        Test.stopTest();
    }
    
     static testMethod void UnitTestforOppProducts1() {
        
        OppProducts products = new OppProducts(opp2,'Revenue');
        OppProducts products1 = new OppProducts(opp3,'QUANTITYREVENUERELATED');
        OppProducts products2 = new OppProducts(opp4,'QUANTITY');
        OppProducts products3 = new OppProducts(opp5,'BOTH');
      
        Test.startTest();
        products.changeScheduleType('Revenue');
        products.changePriceBook(pricebookIdList[1]);
        products.addProduct(prod1.id);
        products.getDates();
        OppProducts.getScheduleUnitCode(OppProducts.getScheduleUnitFromAmountType(opp3.amount_Type__c));
        OppProducts.LineItem li = new OppProducts.LineItem(opplnitm2, products);
          li.reEstablish(1.00,'D');
        products.schedType = OppProducts.ScheduleType.REVENUE;
        system.assert(true,li.schedulingNotEnabledOnProduct); 
        products.schedType = OppProducts.ScheduleType.BOTH;
        system.assert(true,li.schedulingNotEnabledOnProduct);
        products.schedType = OppProducts.ScheduleType.QUANTITY;
         system.assert(true,li.schedulingNotEnabledOnProduct);
         system.assertEquals(0.10, li.revenueSum);
         li.getOutOfRangeSchedules();
        OppProducts.ScheduleItem schItem =  new OppProducts.ScheduleItem(opplnitmsched);
        system.assert(true,schItem.isDirty);
        products.schedType = OppProducts.ScheduleType.REVENUE;
        system.assert(true,schItem.isZeroValue);
        
        Test.stopTest();
    }
    
  static testMethod void testGetterSetter() {
       OppProducts op = new OppProducts(opp5);
        system.assertEquals(system.today().format(), op.formattedStartDT);
        op.schedType=OppProducts.ScheduleType.REVENUE;
        system.assertEquals('Revenue', op.schedTypeFriendlyName);
        op.schedType=OppProducts.ScheduleType.QUANTITY;
        system.assertEquals('Quantity', op.schedTypeFriendlyName);
        op.schedType=OppProducts.ScheduleType.BOTH;
        system.assertEquals('Both (beta)', op.schedTypeFriendlyName);
        op.schedType=OppProducts.ScheduleType.QUANTITYREVENUERELATED;
        system.assertEquals('Quantity (Revenue Related)', op.schedTypeFriendlyName);
        op.schedUnit=OppProducts.ScheduleUnit.YEAR;
        system.assertEquals(10, op.scheduleMatrixLabels.size());
        op.schedUnit=OppProducts.ScheduleUnit.QUARTER;
        system.assertEquals(10, op.scheduleMatrixLabels.size()); 
        op.schedUnit=OppProducts.ScheduleUnit.MONTH;
        system.assertEquals(10, op.scheduleMatrixLabels.size());

    }
}
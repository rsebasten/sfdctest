/*
Date: 26/12/2016
Change : Updated the test class to remove seeAllData from the test class.
*/
@isTest
public class QuantitySchedulingController_UT {
      /*  public static testMethod  void QuantitySchedulingController() {
        //Start: Updated for merge and split to remove seeAllData from the test class.
        RecordTypeSettings__c RTSetting = new RecordTypeSettings__c();
        RTSetting.Name = 'Case.BI-Case';
        RTSetting.FullName__c = 'Test';
        RTSetting.CompanyMailingAddress__c = 'abc';
        insert RTSetting;
        //End: Updated for merge and split to remove seeAllData from the test class.
        //<20170123> Merge&Spin: Added system.runas() to remove mixed dml operation exception.
        user u = [select id,name from user where id=:userinfo.getuserid()];
        system.runas(u){
            Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
            insert a;        
            //<20170123>START Merge&Spin:Remove hard coded record type ID.
            //recordtype r=[select id,name from recordtype where id=:'012300000000smX'];
            id rtypeID = rtype.getIDbyDevName('Opportunity','DPT_EMEA_Standard');
            recordtype r=[select id,name from recordtype where id=:rtypeID];
            //<20170123>END                
            opportunity o=new opportunity(name='testopp',recordtypeid=r.id,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Quarterly',first_ship_date__c=system.today(),Contract_Duration__c=3);        
            insert o;        
            string rectype;
            id recid;
            rectype=r.name;
            recid=r.id;
            //<20170123> Merge&Spin: Updated query for coverage of "trigOppLineQuantitySchedules" trigger
            list__c l=new list__c(name=rectype,code_1__c=string.valueof(recid).substring(0,15),Type__c='Quantity Matrix');
            insert l;
            product2 p;
            p =new product2(name='testproduct',CanUseQuantitySchedule=true);
            insert p;        
            //Start: Updated for merge and split to remove seeAllData from the test class.
            /*
            Pricebook2 stdpb = [select id,isactive from pricebook2 where isstandard=true];
            if(!stdpb.isactive) {
                stdpb.isactive = true;
                update stdpb;
            }*/
            //End: Updated for merge and split to remove seeAllData from the test class.
         /*   pricebook2 pbook=new pricebook2(name='testpbook1');
            insert pbook;
            pricebookentry pent=new pricebookentry(product2id=p.id,isActive=true,unitprice=20,pricebook2id=Test.getStandardPricebookId());
            insert pent;
            opportunitylineitem olit=new opportunitylineitem(quantity=10,opportunityid=o.id,unitprice=20,Description='test',PricebookEntryId=pent.id);
            insert olit;        
            //<20170123> Merge&Spin: Added for coverage of "trigOppQuantitySchedules" trigger      
            o.amount_type__c='One Time - Auto - Monthly';
            o.Contract_Duration__c=4;
            o.first_ship_date__c=system.today().adddays(1);
            update o;
            
            o.amount_type__c='One Time - Auto - Yearly';
            o.Contract_Duration__c=6;
            o.first_ship_date__c=system.today();
            update o;           
            
            o.amount_type__c='One Time - Auto - Quarterly';
            o.Contract_Duration__c=12;
            o.first_ship_date__c=system.today().adddays(2);
            update o;        
            //<20170123>END Merge&Spin
            
            //opportunity_products__c opc;
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/quantitymatrix?');
            Test.setCurrentPage(pageRef);
            string abc=o.id;
            ApexPages.currentPage().getParameters().put('id',o.id);
            ApexPages.StandardController setCon = new ApexPages.StandardController(o);
            
            QuantitySchedulingController controller=new QuantitySchedulingController(setCon);
            controller.getMessage();
            try{
            controller.getScheduleHeaders();
            controller.getSecondController();
            controller.getmyclass();
            controller.getol();
            controller.sqa();
            controller.sqb();
            controller.qwerty();
            controller.get1ols();
            controller.saveChanges();
            controller.getOpp();
            }Catch(Exception e){}
            Test.stopTest();
        }
    } 
     public static testMethod  void QuantitySchedulingController1() {
        //Start: Updated for merge and split to remove seeAllData from the test class.
        RecordTypeSettings__c RTSetting = new RecordTypeSettings__c();
        RTSetting.Name = 'Case.BI-Case';
        RTSetting.FullName__c = 'Test';
        RTSetting.CompanyMailingAddress__c = 'abc';
        insert RTSetting;
        //End: Updated for merge and split to remove seeAllData from the test class.
        //<20170123> Merge&Spin: Added system.runas() to remove mixed dml operation exception.
        user u = [select id,name from user where id=:userinfo.getuserid()];
        system.runas(u){
            Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
            insert a;                
            //<20170123>START Merge&Spin:Remove hard coded record type ID.
            //recordtype r=[select id,name from recordtype where id=:'012300000000smX'];
            id rtypeID = rtype.getIDbyDevName('Opportunity','DPT_EMEA_Standard');
            recordtype r=[select id,name from recordtype where id=:rtypeID];
            //<20170123>END
            
            opportunity o=new opportunity(name='testopp',recordtypeid=r.id,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Monthly',first_ship_date__c=system.today(),Contract_Duration__c=12);
            insert o;
            string rectype;
            id recid;
            rectype=r.name;
            recid=r.id;
            list__c l=new list__c(name=rectype,code_1__c=string.valueof(recid).substring(0,15),Type__c='Quantity Matrix');
            insert l;
            product2 p;
            p =new product2(name='testproduct',CanUseQuantitySchedule=true);
            insert p;
            //Start: Updated for merge and split to remove seeAllData from the test class.
            /*
            Pricebook2 stdpb = [select id,isactive from pricebook2 where isstandard=true];
            if(!stdpb.isactive) {
                stdpb.isactive = true;
                update stdpb;
            }*/
            //End: Updated for merge and split to remove seeAllData from the test class.
          /*  pricebook2 pbook=new pricebook2(name='testpbook');
            insert pbook;
            pricebookentry pent=new pricebookentry(product2id=p.id,isActive=true,unitprice=20,pricebook2id=Test.getStandardPricebookId());
            insert pent;
            opportunitylineitem olit=new opportunitylineitem(quantity=10,opportunityid=o.id,unitprice=20,Description='test',PricebookEntryId=pent.id);
            insert olit;
            //<20170123> Merge&Spin: Added for coverage of "trigOppQuantitySchedules" trigger        
            o.amount_type__c='One Time - Auto - Monthly';
            o.Contract_Duration__c=4;
            o.first_ship_date__c=system.today().adddays(1);
            update o;
            o.amount_type__c='One Time - Auto - Yearly';
            o.Contract_Duration__c=5;        
            update o;
            o.amount_type__c='One Time - Auto - Quarterly';
            o.Contract_Duration__c=6;
            o.first_ship_date__c=system.today().adddays(2);
            update o;
            //<20170123>END Merge&Spin
            
            //opportunity_products__c opc;
            Test.startTest();
            PageReference pageRef = new PageReference('/apex/quantitymatrix?');
            Test.setCurrentPage(pageRef);
            string abc=o.id;
            ApexPages.currentPage().getParameters().put('id',o.id);
            ApexPages.StandardController setCon = new ApexPages.StandardController(o);
            QuantitySchedulingController controller=new QuantitySchedulingController(setCon);
            try{
            controller.getMessage();
            controller.getScheduleHeaders();
            controller.getSecondController();
            controller.getmyclass();
            controller.getol();
            controller.sqa();
            controller.sqb();
            controller.qwerty();
            controller.get1ols();
            controller.saveChanges();
            controller.getOpp();
            }Catch(Exception e){}
            Test.stopTest();
        }
    } 
    public static testMethod void QuantitySchedulingController2() {
        Test.startTest();
        Account a = new Account(name='test2',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        //<20170123>START Merge&Spin:Remove hard coded record type ID.
        //recordtype r=[select id,name from recordtype where id=:'012300000000smX'];
        id rtypeID = rtype.getIDbyDevName('Opportunity','DPT_EMEA_Standard');
        recordtype r=[select id,name from recordtype where id=:rtypeID];
        //<20170123>END
        List<opportunity> listOpp=new  List<opportunity>();
        opportunity o=new opportunity(name='testopp2',recordtypeid=r.id,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Yearly',first_ship_date__c=system.today(),Contract_Duration__c=1);
        listOpp.add(o);
        opportunity o1=new opportunity(name='testopp2',recordtypeid=r.id,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Monthly',first_ship_date__c=system.today(),Contract_Duration__c=12);
        listOpp.add(o1);
        opportunity o2=new opportunity(name='testopp2',recordtypeid=r.id,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Quarterly',first_ship_date__c=system.today(),Contract_Duration__c=3);
        listOpp.add(o2);
        
        insert listOpp;
        
        string rectype;
        id recid;
        rectype=r.name;
        recid=r.id;
        //<20170123> Merge&Spin: Updated query for coverage of "trigOppLineQuantitySchedules" trigger
        list__c l=new list__c(name=rectype,code_1__c=string.valueof(recid).substring(0,15),Type__c='Quantity Matrix');
        insert l;
        product2 p;
        p =new product2(name='testproduct',CanUseQuantitySchedule=true);
        insert p;
        //Start: Updated for merge and split to remove seeAllData from the test class.
        /*
        Pricebook2 stdpb = [select id,isactive from pricebook2 where isstandard=true];
        if(!stdpb.isactive) {
            stdpb.isactive = true;
            update stdpb;
        }*/
        //End: Updated for merge and split to remove seeAllData from the test class.
      /*  pricebook2 pbook=new pricebook2(name='testpbook');
        insert pbook;
        pricebookentry pent=new pricebookentry(product2id=p.id,isActive=true,unitprice=20,pricebook2id=Test.getStandardPricebookId());
        insert pent;
        List<opportunitylineitem> lstolit=new List<opportunitylineitem>();
        opportunitylineitem olit=new opportunitylineitem(quantity=2,opportunityid=o.id,unitprice=20,Description='test',PricebookEntryId=pent.id);
        //lstolit.add(olit);
        insert olit;
        opportunitylineitem olit1=new opportunitylineitem(quantity=2,opportunityid=o1.id,unitprice=20,Description='test',PricebookEntryId=pent.id);
        //lstolit.add(olit1);
        insert olit1;
        opportunitylineitem olit2=new opportunitylineitem(quantity=2,opportunityid=o2.id,unitprice=20,Description='test',PricebookEntryId=pent.id);
        //lstolit.add(olit2);
        insert olit2;        
        Test.stopTest();
        
        QuantitySchedulingController.isOppCloned=true;
        QuantitySchedulingController.oppDuration=1;
         update olit;
        opportunitylineitem lineItem1=[select id, hasquantityschedule from opportunitylineitem where id=:olit.id];
        system.debug(LoggingLevel.Error, 'test::'+lineItem1.hasquantityschedule);
        List<opportunitylineitemschedule> todelete=new List<opportunitylineitemschedule>();
        List<opportunitylineitemschedule> AllSchedules= [select id from opportunitylineitemschedule  where opportunitylineitemid = :lineItem1.id];
        delete  AllSchedules;
        update lineItem1;
        
        
        
        opportunitylineitem lineItem2=[select id, hasquantityschedule from opportunitylineitem where id=:olit1.id];
        List<opportunitylineitemschedule> AllSchedules1= [select id from opportunitylineitemschedule  where opportunitylineitemid = :lineItem2.id];
        delete  AllSchedules1;
        update lineItem2;
        
        opportunitylineitem lineItem3=[select id, hasquantityschedule from opportunitylineitem where id=:olit2.id];
        List<opportunitylineitemschedule> AllSchedules2= [select id from opportunitylineitemschedule  where opportunitylineitemid = :lineItem3.id];
        delete  AllSchedules2;
        update lineItem3;
        
        
    } 
    //<20170123> Added test method for coverage of "trigOppQuantitySchedules" trigger
    public static testMethod  void trigOppQuantitySchedules_UT()
    {
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;                
        id rtypeID = rtype.getIDbyDevName('Opportunity','DPP_Polymers');        
        opportunity o=new opportunity(name='testopp',recordtypeid=rtypeID,accountid=a.id,StageName='Target',CloseDate=system.today(),amount_type__c='One Time - Auto - Quarterly',first_ship_date__c=system.today(),Contract_Duration__c=3);
        insert o;      
        o.Actual_Commercial_Date__c = date.today();
        o.stagename='End - Won';
        update o;
        
    } */
}
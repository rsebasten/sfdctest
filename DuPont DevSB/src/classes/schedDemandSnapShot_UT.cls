/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com

Description: Test class to traverse each BI account, check for snapshot date and take snapshot 

**********************************************************************************/

@isTest 
public class schedDemandSnapShot_UT {
    static testmethod void test() {
        String CRON_EXP = '0 0 0 * * ?';
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'testAccount';
        insert a;
        
         Account acc = getAccount();
        List<Demand__c> demands = getDemands(acc);
        List<DemandItem__c> demandItems = getDemandItems(demands);
        getDemandItemSchedules(demandItems);
        
        // Schedule the test job
        
        String jobId = System.schedule('DemandForecasting',
                                       CRON_EXP, 
                                       new schedDemandSnapshot());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        Date tday = Date.today();
        Date nextFireTime =  ct.NextFireTime.Date();
        if(tday>nextFireTime)
            System.assertEquals(tday, nextFireTime);
        else
            System.assertEquals(tday.addDays(1), nextFireTime);
        
        Test.stopTest();
        
        System.assertEquals('testAccount',
                            [SELECT Id, Name FROM Account WHERE Id = :a.Id].Name);
        
    }
    
    
    public static Account getAccount(){
        
        Account acc = new Account(name='Parksite (OH) Tyvek', Site='Louisville, OH', Account_Stage__c='Active', Country__c='UNITED STATES',industry='Construction and Architecture',RecordTypeId=Schema.SObjectType.account.getRecordTypeInfosByName().get('BI - Surfaces').getRecordTypeId());        
        insert acc;
        return acc;        
    }
    
    Static List<Demand__C> getDemands(Account acc){
        List<Demand__c> demands = new List<Demand__c>();
        
        Demand__c d = new Demand__c(name='BE - Inventory1', duration__c=13, fieldset__c='Revenue', 
                                    postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Inventory',
                                    information__c='Revenue',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Inventory2', duration__c=13, fieldset__c='Quantity', 
                          postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Inventory',
                          information__c='Quantity',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Inventory3', duration__c=6, fieldset__c='Revenue', 
                          postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Inventory',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        
        demands.add(d);
        d = new Demand__c(name='BE - Inventory4', duration__c=1, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Inventory',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        //===================Sales
        d = new Demand__c(name='BE - Sales - Product1', duration__c=13, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Sales',
                          information__c='Revenue',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Sales - Product2', duration__c=13, fieldset__c='Quantity', 
                          postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Sales',
                          information__c='Quantity',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Sales - Product3', duration__c=6, fieldset__c='Revenue', 
                          postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Sales',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        
        demands.add(d);
        d = new Demand__c(name='BE - Sales - Product4', duration__c=1, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Sales',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        //===================Purchase
        d = new Demand__c(name='BE - Purchases1', duration__c=13, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Purchases',
                          information__c='Revenue',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Purchases2', duration__c=13, fieldset__c='Quantity', 
                          postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Purchases',
                          information__c='Quantity',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        d = new Demand__c(name='BE - Purchases3', duration__c=6, fieldset__c='Revenue', 
                          postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Purchases',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        
        demands.add(d);
        d = new Demand__c(name='BE - Purchases4', duration__c=1, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Purchases',
                          information__c='Both',Account__c=acc.id,snapshotday__c=Date.today().Day());
        demands.add(d);
        insert demands;
        return demands;
    }
    
    static List<DemandItem__C> getDemandItems(List<Demand__c> demands){
        List<DemandItem__c> demandItems = new List<DemandItem__c>();
        
        DemandItem__c di = new DemandItem__c(name='HomeWrap® - standard', Group__c='Wall Membranes', Demand__c= demands.get(0).id);
        demandItems.add(di);
        di = new DemandItem__c(name='HomeWrap® - Custom Logo', Group__c='Wall Membranes', Demand__c= demands.get(0).id);
        demandItems.add(di);
        di = new DemandItem__c(name='StuccoWrap®', Group__c='Wall Membranes', Demand__c= demands.get(1).id);
        demandItems.add(di);
        di = new DemandItem__c(name='DrainWrap™', Group__c='Wall Membranes', Demand__c= demands.get(1).id);
        demandItems.add(di);
        di = new DemandItem__c(name='CommercialWrap™', Group__c='Wall Membranes', Demand__c= demands.get(2).id);
        demandItems.add(di);
        di = new DemandItem__c(name='CommercialWrap D™', Group__c='Wall Membranes', Demand__c= demands.get(2).id);
        demandItems.add(di);
        di = new DemandItem__c(name='ThermaWrap™', Group__c='Wall Membranes', Demand__c= demands.get(3).id);
        demandItems.add(di);
        di = new DemandItem__c(name='ThermaWrap™ R5', Group__c='Wall Membranes', Demand__c= demands.get(3).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FlexWrap™', Group__c='Flashing', Demand__c= demands.get(4).id);
        demandItems.add(di);
        di = new DemandItem__c(name='StraightFlash™', Group__c='Flashing', Demand__c= demands.get(4).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FlexWrap NF™', Group__c='Flashing', Demand__c= demands.get(5).id);
        demandItems.add(di);
        di = new DemandItem__c(name='DuPont™ Flashing Tape', Group__c='Flashing', Demand__c= demands.get(5).id);
        demandItems.add(di);
        di = new DemandItem__c(name='Other - RW, VF, OS,TWF, etc.', Group__c='Flashing', Demand__c= demands.get(6).id);
        demandItems.add(di);
        di = new DemandItem__c(name='Non-Breathable Roof Underlayment', Group__c='Roofing', Demand__c= demands.get(6).id);
        demandItems.add(di);
        di = new DemandItem__c(name='Attic Wrap™', Group__c='Roofing', Demand__c= demands.get(7).id);
        demandItems.add(di);
        di = new DemandItem__c(name='Other - tape, sealants, etc.', Group__c='Other', Demand__c= demands.get(7).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPSEAL 10.3 OZ/305 ML CARTRDGE', Group__c='Fluid Applied', Demand__c= demands.get(8).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPSEAL 28 OZ/828 ML CARTRDGE', Group__c='Fluid Applied', Demand__c= demands.get(8).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPJOIN 10.3 OZ/305 ML CARTRDGE', Group__c='Fluid Applied', Demand__c= demands.get(9).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPJOIN 28 OZ/828 ML CARTRDGE', Group__c='Fluid Applied', Demand__c= demands.get(9).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPJOIN 3.5 GA/13.25 LT', Group__c='Fluid Applied', Demand__c= demands.get(10).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPWB 5 GA/19 LT', Group__c='Fluid Applied', Demand__c= demands.get(10).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPWB 50 GA/189 LT', Group__c='Fluid Applied', Demand__c= demands.get(11).id);
        demandItems.add(di);
        di = new DemandItem__c(name='FLDAPFLAS 10.3 OZ/305 ML CARTRDGE', Group__c='Fluid Applied', Demand__c= demands.get(11).id);
        demandItems.add(di);
        
        insert demandItems;
        
        return demandItems;
        
    }
    
    static List<DemandItemSchedule__c> getDemandItemSchedules(List<DemandItem__c> demandItems){
        
        List<DemandItemSchedule__c> demandItemSchedules = new List<DemandItemSchedule__c>();
        DemandItemSchedule__c dis;
        For(DemandItem__c di: demandItems){
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('12/01/2013') , DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('01/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('02/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('03/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('04/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('05/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('06/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('07/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('08/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('09/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('10/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('11/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);            
            dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('12/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
            demandItemSchedules.add(dis);
            
            
            
            
        }
        insert demandItemSchedules;
        return demandItemSchedules;
        
    }
    
    
  
}
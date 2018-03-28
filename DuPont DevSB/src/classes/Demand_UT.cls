/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Test(s) for : Demand, ctrlDemandView, 
********************************************************************************/
@isTest
private class Demand_UT {
    
    static Account getAccount(){
        Account acc = new Account(name='Parksite (OH) Tyvek', Site='Louisville, OH', Account_Stage__c='Active', Country__c='UNITED STATES',industry='Construction and Architecture');        
        insert acc;
        return acc;        
    }
    
    Static List<Demand__C> getDemands(Account acc){
        List<Demand__c> demands = new List<Demand__c>();
        
        Demand__c d = new Demand__c(name='BE - Inventory1', duration__c=13, fieldset__c='Revenue', 
                                    postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Inventory',
                                    information__c='Revenue',Account__c=acc.id);
        demands.add(d);
        /* d = new Demand__c(name='BE - Inventory2', duration__c=13, fieldset__c='Quantity', 
postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Inventory',
information__c='Quantity',Account__c=acc.id);
demands.add(d);
d = new Demand__c(name='BE - Inventory3', duration__c=6, fieldset__c='Revenue', 
postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Inventory',
information__c='Both',Account__c=acc.id);

demands.add(d);
d = new Demand__c(name='BE - Inventory4', duration__c=1, fieldset__c='Revenue', 
postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Inventory',
information__c='Both',Account__c=acc.id);
demands.add(d);*/
        //===================Sales
        d = new Demand__c(name='BE - Sales - Product1', duration__c=13, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Sales',
                          information__c='Revenue',Account__c=acc.id);
        demands.add(d);
        /*  d = new Demand__c(name='BE - Sales - Product2', duration__c=13, fieldset__c='Quantity', 
postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Sales',
information__c='Quantity',Account__c=acc.id);
demands.add(d);
d = new Demand__c(name='BE - Sales - Product3', duration__c=6, fieldset__c='Revenue', 
postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Sales',
information__c='Both',Account__c=acc.id);

demands.add(d);
d = new Demand__c(name='BE - Sales - Product4', duration__c=1, fieldset__c='Revenue', 
postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Sales',
information__c='Both',Account__c=acc.id);
demands.add(d);*/
        //===================Purchase
        d = new Demand__c(name='BE - Purchases1', duration__c=13, fieldset__c='Revenue', 
                          postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Purchases',
                          information__c='Revenue',Account__c=acc.id);
        demands.add(d);
        /*      d = new Demand__c(name='BE - Purchases2', duration__c=13, fieldset__c='Quantity', 
postfieldset__c='QuantityWithActualQuanity', offset__c=-1, type__c='Purchases',
information__c='Quantity',Account__c=acc.id);
demands.add(d);
d = new Demand__c(name='BE - Purchases3', duration__c=6, fieldset__c='Revenue', 
postfieldset__c='QuantityRevenueWithActualQuantityRevenue', offset__c=-1, type__c='Purchases',
information__c='Both',Account__c=acc.id);

demands.add(d);
d = new Demand__c(name='BE - Purchases4', duration__c=1, fieldset__c='Revenue', 
postfieldset__c='RevenueWithActualRevenue', offset__c=-1, type__c='Purchases',
information__c='Both',Account__c=acc.id);
demands.add(d);*/
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
        /* di = new DemandItem__c(name='CommercialWrap™', Group__c='Wall Membranes', Demand__c= demands.get(2).id);
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
*/
        insert demandItems;
        
        return demandItems;
        
    }
    
    static List<DemandItemSchedule__c> getDemandItemSchedules(List<DemandItem__c> demandItems){
        
        List<DemandItemSchedule__c> demandItemSchedules = new List<DemandItemSchedule__c>();
        For(DemandItem__c di: demandItems){
            DemandItemSchedule__c dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('12/01/2013') , DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
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
            //dis = new DemandItemSchedule__c(QtyActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevActual__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), BaseDate__c=Date.parse('12/01/2014'), DemandItem__c=di.id, QtyFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), QtyFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst1__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst2__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevFcst0__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)), RevGoal__c=(Math.round(Math.Random()*1000)*Math.round(Math.Random()*1000)));
           // demandItemSchedules.add(dis);
 			dis = new DemandItemSchedule__c(QtyActual__c=null, RevActual__c=null,BaseDate__c=Date.parse('12/01/2014'), DemandItem__c=di.id, QtyFcst1__c=null, QtyFcst2__c=null, QtyFcst0__c=null, QtyFcst__c=null, RevFcst__c=null, RevFcst1__c=null, RevFcst2__c=null, RevFcst0__c=null, Last_Snapshot_Date__c=Date.today(), Last_Snapshot_Taken_By__c=UserInfo.getUserId(),   QtyGoal__c=null, RevGoal__c=null);
            demandItemSchedules.add(dis);
                        
            
            
        }
        insert demandItemSchedules;
        return demandItemSchedules;
    }
    
    public static void getDemandGoals(List<Demand__c> demands){
        List <DemandGoal__c> demandGoals = new List<DemandGoal__c>();
        integer i =1;
        for(demand__c demand: demands){
            DemandGoal__c dg = new DemandGoal__c(Base_Date__c=Date.newInstance(2014,i,1), Business__c='BI', Name='January 2014', Goal_Period__c=Date.newInstance(2014,i,1), MDDemand__c=demand.id, Quantity_Goal__c=(Math.random()*Math.random()*1000), Revenue_Goal__c=(Math.random()*Math.random()*1000));
            
            if(i>=12){i=1;}else{i++;}
            demandGoals.add(dg);
        }
        insert demandGoals;
        
    }
    
    static testMethod void test_Demand() {
        Account acc = getAccount();
        List<Demand__c> demands = getDemands(acc);
        List<DemandItem__c> demandItems = getDemandItems(demands);
        getDemandItemSchedules(demandItems);
        getDemandGoals(demands);
        
        Test.startTest();
        
        for(Demand__c d: demands){
            Demand dmd = new Demand(d);
            dmd.load();
            Demand.DemandGoal dg = dmd.getDemandGoal();
            Demand.GrandTotal gt = dmd.getGrandTotal();
           
            dmd.getGrandTotal();
            dg.getDynamicFormatString();
            boolean isQuantityDisplayed = dmd.isQuantityDisplayed;
            Schema.FieldSet postFieldset = dmd.postFieldset;
            List<Date> getGoalPeriod = dg.getGoalPeriod();
            Map<Date,String> getmapBusiness = dg.getmapBusiness();
            Map<Date,Decimal> getmapQuantityGoals  =dg.getmapQuantityGoals();
            Map<Date,Decimal> getmapRevenueGoals = dg.getmapRevenueGoals();
            Date currentKey = dg.currentKey;
            Decimal  currentRevGoal = dg.currentRevGoal;            
            Decimal currentQtyGoal = dg.currentQtyGoal;
            Map<Date,Decimal> getactualRevGrandTotal = gt.getactualRevGrandTotal();
            Map<Date,Decimal> getactualQtyGrandTotal =  gt.getactualQtyGrandTotal();
            Map<Date,Decimal> getqtyGrandTotal = gt.getqtyGrandTotal();
            Map<Date,Decimal>  getrevGrandTotal   =  gt.getrevGrandTotal();
            Map<Date,Decimal> getrevFcst1GrandTotal = gt.getrevFcst1GrandTotal();
            Map<Date,Decimal> getrevFcst2GrandTotal = gt.getrevFcst2GrandTotal();
            Map<Date,Decimal> getrevPYMActualGrandTotal = gt.getrevPYMActualGrandTotal();
            Map<Date,Decimal> getqtyFcst1GrandTotal = gt.getqtyFcst1GrandTotal();
            Map<Date,Decimal> getqtyFcst2GrandTotal = gt.getqtyFcst2GrandTotal();
            Map<Date,Decimal> getqtyPYMActualGrandTotal = gt.getqtyPYMActualGrandTotal();
            gt.getDynamicFormatString();
            LIST<Demand.LineItemGroup> ligs = dmd.getGroups();
            for(Demand.LineItemGroup lig:ligs){
                lig.getTotals();
                Decimal rs1 = lig.items.get(0).revenueSum;
                Decimal qs1 = lig.items.get(0).quantitySum;
                Decimal asr1 = lig.items.get(0).actualRevenueSum;
                Decimal aqs1 = lig.items.get(0).actualQuantitySum;
                  lig.getColumns();
                
            }
           
            
            //     Demand.LineItemGroup grp = dmd.getGroups()[0];
            //system.assertEquals('Group A',grp.Name);  //Group A should be first (Alpha sort)
            
            // Demand.GroupColumn col = grp.getColumns()[2];
            //            grp.items[0].getSchedules()[2].quantity=1;
            //// grp.items[1].getSchedules()[2].quantity=2;
            //system.assertEquals(3.0,col.total.quantity); //1+2=3
            
            // system.debug(col.totalSubColumns);
            //            system.debug(dmd.getGroups()[0].getTotals());
            
            Demand.getScheduleDates(date.TODAY(), 5, Demand.ScheduleUnit.YEAR);
            Demand.getScheduleDates(date.TODAY(), 5, Demand.ScheduleUnit.QUARTER);
            Demand.getScheduleDates(date.TODAY(), 5, Demand.ScheduleUnit.MONTH);
            Demand.getScheduleDates(date.TODAY(), 5, Demand.ScheduleUnit.WEEK);
            Demand.normalizeDate(date.TODAY(),Demand.ScheduleUnit.Year);
            Demand.normalizeDate(Date.newInstance(2014,2,1), Demand.ScheduleUnit.QUARTER);
            Demand.normalizeDate(Date.newInstance(2014,4,1), Demand.ScheduleUnit.QUARTER);
            Demand.normalizeDate(Date.newInstance(2014,7,1), Demand.ScheduleUnit.QUARTER);
            
            Demand.getScheduleDates_LastDayOfMonth(date.TODAY(), 5, Demand.ScheduleUnit.YEAR);
            Demand.getScheduleDates_LastDayOfMonth(date.TODAY(), 5, Demand.ScheduleUnit.QUARTER);
            Demand.getScheduleDates_LastDayOfMonth(date.TODAY(), 5, Demand.ScheduleUnit.MONTH);
            Demand.getScheduleDates_LastDayOfMonth(date.TODAY(), 5, Demand.ScheduleUnit.WEEK);
            Demand.getScheduleDates_LastDayOfMonth(date.TODAY(), 5, Demand.ScheduleUnit.DAY);     
            
            
            
            dmd.save(true);
            
            
            
        }
        
        
        Demand dmd = new Demand(String.valueOf(demands[0].id),demands[0].Type__c,Integer.valueOf(demands[0].Duration__c));
        dmd.load();
        
        
        
        Test.stopTest();
    }  
    
    
    static testMethod void test_SchedDemandSnapshot() {
        
        Demand__c d = new Demand__c(name='test', duration__c=6, offset__c=0, SnapShotDay__c=Date.Today().day());
        insert d;
        DemandItem__c di = new DemandItem__c(name='Prod1', Demand__c=d.id);
        insert di;
        LIST<DemandItemSchedule__c> diss = new LIST<DemandItemSchedule__c>();
        for (integer i=1; i<=12; i++) {
            DemandItemSchedule__c dis = new DemandItemSchedule__c(name='test', DemandItem__c=di.id);
            dis.QtyFcst__c=10;
            dis.RevFcst__c=100;
            dis.basedate__c=Date.Today().addMonths(i);
            diss.add(dis);
        }
        insert diss;	
        test.starttest();
        system.schedule('TestSchedule','0 0 1 * * ?',new schedDemandSnapShot());
        test.stoptest();
    }
}
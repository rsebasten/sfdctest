/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com

Description: Class to traverse each BI account, check for snapshot date and take snapshot 

**********************************************************************************/

Global  with sharing class DemandSnapshot implements Schedulable{
    public List<Account> acc{get;set;}
    public List<DemandItem__c> di{get;set;}
    public List<DemandItemSchedule__c> dis{get;set;}
    
    global void execute(SchedulableContext SC) {
        DemandSnapshot objDemandSnapshot = new DemandSnapshot(); 
    }
    
    public DemandSnapshot(){
        Accounts objAccounts = new Accounts();
        acc = objAccounts.getAccounts();
        system.debug('acc--------->>>'+acc);
        DemandItems objDemandItem = new DemandItems(acc);
        di = objDemandItem.di;
        DemandItemSchedules objDemandItemSchedules = new DemandItemSchedules(di);
        dis = objDemandItemSchedules.dis;
        List<DemandItemSchedule__c> disUpdated = new List<DemandItemSchedule__c>();
        
        for(DemandItemSchedule__c s:dis){
            Integer monthDiff = Date.today().monthsBetween(s.BaseDate__c);
            if (Date.today().day() < s.BaseDate__c.day()) monthDiff--;
            
            if(monthDiff==1){
                s.QtyFcst1__c = s.QtyFcst__c;
                s.RevFcst1__c = s.RevFcst__c;
                disUpdated.add(s);
            }else  if(monthDiff==2){
                s.QtyFcst2__c = s.QtyFcst__c;
                s.RevFcst2__c = s.RevFcst__c;
                disUpdated.add(s);
            }
            s.Last_Snapshot_Date__c = Date.today();
            s.Last_Snapshot_Taken_By__c = UserInfo.getUserId();
        }
        
        
        upsert disUpdated;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public class DemandItemSchedules{
        public List<DemandItemSchedule__c> dis{get;set;}
        
        public DemandItemSchedules(List<DemandItem__c> di){
            dis = getDemandItemSchedules(di);            
            
        }
        
        public List<DemandItemSchedule__c> getDemandItemSchedules(List<DemandItem__c> di){            
            List<DemandItemSchedule__c> demandItemsSch = new List<DemandItemSchedule__c>();
            Set<Id> DemandItemIds = new Set<Id>();
            for(DemandItem__c d: di){
                DemanditemIds.add(d.id);
            }
            ///
            List<DemandItem__c> d1 =  Database.query(getDemandItemScheduleQuery(DemanditemIds));
            for(DemandItem__c d: d1){
                for(DemandItemSchedule__c dis: d.Schedules__r){	
                    demandItemsSch.add(dis);
                }
            }
            ///
            
            return demandItemsSch;
        }
        
        public String getDemandItemScheduleQuery(Set<Id> DemandItemIds){
            Date currentDate = Date.today();
            Date startDate =  currentDate.toStartOfMonth();
            Date nextToNextMonth = startDate.addMonths(2);
            Date endDate = Date.newInstance(nextToNextMonth.year(), nextToNextMonth.month(), Date.daysInMonth(nextToNextMonth.year(), nextToNextMonth.month()));
            //System.debug('currentDate --> '+currentDate+'currentDate.year() '+currentDate.year()+'currentDate.month() '+currentDate.month()+'startDate '+startDate+' nextToNextMonth '+nextToNextMonth);
            String strQuery = 'SELECT Name, (SELECT BaseDate__c,QtyFcst1__c,QtyFcst2__c,RevFcst1__c,RevFcst2__c,QtyFcst__c,RevFcst__c,Last_Snapshot_Date__c,Last_Snapshot_Taken_By__c FROM Schedules__r where BaseDate__c>='+String.valueOf(startDate).substring(0,10)+' AND BaseDate__c<='+String.valueOf(endDate).substring(0,10)+') FROM DemandItem__c where id IN :DemandItemIds';
            //System.debug('getDemandItemScheduleQuery ---- > '+strQuery);
            return strQuery;
        }
        
        
        
        
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public class DemandItems{
        public List<DemandItem__c> di{get;set;}
        
        
        public DemandItems(List<Account> acc){
            di = getDemandItems(acc);            
            
        }
        
        public List<DemandItem__c> getDemandItems(List<Account> acc){            
            List<DemandItem__c> demandItems = new List<DemandItem__c>();
            Set<id> DemandItemsIds = new Set<id>();
            for(Account a: acc){
                if(a.demand__r!=null && a.demand__r.size()>0){
                    
                    for(Demand__c d: a.demand__r){
                        DemandItemsIds.add(d.id);
                    }
                }
            }
            
            ///
            
            List<Demand__c> d1 = Database.query(getDemandItemsQuery(DemandItemsIds));
            for(Demand__c de: d1){           
                for(DemandItem__c di: de.Items__r){
                    demandItems.add(di);
                }
            }
            
            ///
            return demandItems;
        }
        
        public String getDemandItemsQuery(Set<Id> DemandItemsIds){
            String strQuery = 'SELECT Name, (SELECT Demand__c,Name,Id FROM Items__r) FROM Demand__c where id IN :DemandItemsIds';
            return strQuery;
        }
        
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public class Accounts{
        
        public List<Account> getAccounts(){             
            List<Account> accounts = Database.query(getAccountsQuery());
            return  accounts;
        }
        
        public String getAccountsQuery(){
            String strQuery = 'SELECT Name, Account_Name_2__c, Type, RecordTypeId, (SELECT Account__c,Offset__c,Id,SnapShotDay__c,Type__c FROM Demand__r where  snapshotday__c =  '+Date.today().day()+') FROM Account where recordtypeid in (Select id from RecordType where name like \'%BI%\')';
            return strQuery;
        }
    }
}
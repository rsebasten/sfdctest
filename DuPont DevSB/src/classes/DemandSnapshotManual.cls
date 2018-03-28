/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com

Description: Class to traverse each BI account, check for snapshot date and take snapshot 

**********************************************************************************/

public class DemandSnapshotManual{
    public List<DemandItem__c> di{get;set;}
    public List<DemandItemSchedule__c> dis{get;set;} 
    
    private final ApexPages.StandardController controller;
    
    public DemandSnapshotManual(ApexPages.StandardController stdController) {
        controller = stdController;
        
    }
    
    public DemandSnapshotManual(){
        
    }
    public void takeSnapshot(){
        DemandItems objDemandItem = new DemandItems(controller.getRecord().id);
        di = objDemandItem.di;
        DemandItemSchedules objDemandItemSchedules = new DemandItemSchedules(di);
        dis = objDemandItemSchedules.dis;
        
        updateDemandItemSchedule();
        
    }
    
    public void updateDemandItemSchedule(){
        
        List<DemandItemSchedule__c> disUpdated = new List<DemandItemSchedule__c>();
        for(DemandItemSchedule__c s:dis){
            Integer monthDiff = Date.today().monthsBetween(s.BaseDate__c);
            System.debug('monthDiff pre -->'+monthDiff+' Date.today()'+Date.today()+'s.BaseDate__c '+s.BaseDate__c);
            
            if (Date.today().day() < s.BaseDate__c.day()) monthDiff--;
            System.debug('monthDiff post -->'+monthDiff);
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
        
        
        public DemandItems(Id demandId){
            di = getDemandItems(demandId);            
            
        }
        
        public List<DemandItem__c> getDemandItems(Id demandId){            
            
            List<DemandItem__c> demandItems = new List<DemandItem__c>();
            List<Demand__c> d1 = Database.query(getDemandItemsQuery(demandId));
            for(Demand__c de: d1){           
                for(DemandItem__c di: de.Items__r){
                    demandItems.add(di);
                }
            }
            
            ///
            return demandItems;
        }
        
        public String getDemandItemsQuery(Id DemandId){
            String strQuery = 'SELECT Name, (SELECT Demand__c,Name,Id FROM Items__r) FROM Demand__c where id =\''+DemandId+'\'';
            System.debug('getDemandItemsQuery ---- > '+strQuery);
            return strQuery;
        }
        
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    public class Demands{
        
        public List<Demand__c> getDemand(Id demandId){            
            List<Demand__c> Demand = Database.query(getDemandsQuery(demandId));
            return  Demand;
        }
        
        public String getDemandsQuery(Id demandId){
            String strQuery = 'SELECT Account__c,Offset__c,Id,SnapShotDay__c,Type__c FROM Demand__r where  id=\''+demandId+'\'';
            System.debug('getDemandsQuery ---- > '+strQuery);
            return strQuery;
        }
    }
}
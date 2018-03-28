/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Thomas Snyder, Abhinav Bhatnagar
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com,abhinav.bhatanagar@dupont.com

TES20130415  initial Release
AB20140310   including GrandTotal and Demand Goal modifications
AB20140514   Multiple modifications made for whole class 
AB20141110   Multiple modifications to To provide correct Grand Totals, Goals and 
Goals Percentage for Post Period Demand Signaling for post period.
This will also take care of whether the Actuals are provided for 
the post period month or not.
AB20141118   Resolving map key not present issues
**********************************************************************************/
public with sharing class Demand {
    
    public enum ScheduleUnit { YEAR, QUARTER, MONTH, WEEK, DAY }     //Define the unit to capture and show schedule, set to month currently.
    public static boolean debug {get; set;} 
    
    public boolean              saveZero        {get; private set;}  //whether to save ZeroValue schedules
    public integer              duration        {get; private set;}  //number of months from baseDT 
    public string               dsType          {get; private set;}  //Purchase, Sales, Inventory, etc...   
    public date                 baseDT          {get; set;}          //Date to start grid
    public string               DS_fieldSet     {get; set;}          //FieldSet used for Forcasting
    public string               Post_fieldSet   {get; set;}          //FieldSet used for Post Period
    public GrandTotal           GT              {get{return getGrandTotal();}} //Grand Total 
    public DemandGoal           DG              {get{return getDemandGoal();}} //Demand Goal
    public boolean isActRevEditablePur 					{get; set;}
    public boolean isActQtyEditablePur					{get; set;}
    public boolean isActRevEditableSaIn 				{get; set;}
    public boolean isActQtyEditableSaIn					{get; set;}
    
    public string demandId;
    public MAP<string, LineItemGroup> mapGroups = new MAP<string, LineItemGroup>();
    
    public DemandGoal getDemandGoal(){
        DemandGoal DG = new DemandGoal(this); //Get Demand Goal and set to property
        return DG;
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    public static Schema.FieldSet cacheFieldSet; 
    public Schema.FieldSet fieldset {//Get the fieldset to be used
        GET {
            if (cacheFieldSet==null) {
                cacheFieldSet = Schema.SObjectType.DemandItemSchedule__c.fieldSets.getMap().get(DS_fieldSet);
                if (cacheFieldSet==null) throw new DemandException('Invalid FieldSet: '+DS_fieldSet); 
            }
            return cacheFieldSet;
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////
    public static Schema.FieldSet cachePostFieldSet; 
    public Schema.FieldSet postFieldset {//Field set for period already passed
        GET {
            if (cachePostFieldSet==null) {
                cachePostFieldSet = Schema.SObjectType.DemandItemSchedule__c.fieldSets.getMap().get(Post_fieldSet);
                if (cachePostFieldSet==null) 
                    throw new DemandException('Invalid FieldSet: '+Post_fieldSet); 
            }
            return cachePostFieldSet;
        }
    }   
    
    public boolean isQuantityDisplayed{
        GET{
            For(Schema.FieldSetMember fs:fieldset.getFields()){
                if(fs.getLabel()=='Forecast Quantity')
                    return true;
                
            }
            return false;
            
        }
        
    }
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    public Demand(demand__c d) {//Parameterize Constructor for Demand to set default values
        string strDebug=ApexPages.currentPage().getParameters().get('debug');
        debug = (strDebug!=null) ? Util.stringToBoolean(strDebug) : false;
        demandId=d.id;
        duration = d.Duration__c.intValue();
        baseDT=Date.TODAY();
        DS_fieldSet=d.FieldSet__c;
        Post_fieldSet=d.PostFieldSet__c;
        dsType=d.Type__c;
        setFieldsEditability();
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    public Demand(string id, string typ, integer dur) {//Parameterized Constructor
        string strDebug=ApexPages.currentPage().getParameters().get('debug');
        debug = (strDebug!=null) ? Util.stringToBoolean(strDebug) : false;
        demandId=id;
        duration = dur;
        baseDT=Date.TODAY();
        DS_fieldSet='Default';
        Post_fieldSet='Default';
        dsType=typ;
        setFieldsEditability();
    }
    
    public void setFieldsEditability(){
        List<PermissionSetAssignment> qry = [SELECT Id, PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.Name= 'Demand_Schedule_Editor_Internal'];
        
        if (qry!=null && qry.size()>0 && qry.get(0).PermissionSet.Name == 'Demand_Schedule_Editor_Internal') {
            isActRevEditablePur = true;
        }else{
            isActRevEditablePur = false;
        }
        
        // qry = [SELECT Id, PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.Name= 'Demand_Schedule_Editor_Internal'];
        
        if (qry!=null && qry.size()>0 && qry.get(0).PermissionSet.Name == 'Demand_Schedule_Editor_Internal') {
            isActQtyEditablePur =  true;
        }else{
            isActQtyEditablePur = false;
        }
        
        qry = [SELECT Id, PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.Name= 'Demand_Schedule_Editor_Partner'];
        
        if (qry!=null && qry.size()>0 && qry.get(0).PermissionSet.Name == 'Demand_Schedule_Editor_Partner') {
            isActRevEditableSaIn =  true;
        }else{
            isActRevEditableSaIn = false;
        }
        
        
        
        //qry = [SELECT Id, PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.Name= 'Demand_Schedule_Editor_Partner'];
        
        if (qry!=null && qry.size()>0 && qry.get(0).PermissionSet.Name == 'Demand_Schedule_Editor_Partner') {
            isActQtyEditableSaIn =  true;
        }else{
            isActQtyEditableSaIn =  false;
        }
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    public void load() {
        ///////////////////////////////////////////////
        // create Product Groups based on DemandItem.group__c
        ///////////////////////////////////////////////
        SET<string> groups = new SET<string>();
        for (DemandItem__c di : [
            SELECT group__c FROM DemandItem__c
            WHERE Demand__c =: demandId AND Demand__r.Type__c=:dsType
            ORDER BY group__c]) {//Query to fetch Demand Groups of each Demand Item
                groups.add(di.group__c);
            }   
        
        for (string grp : groups)
            mapGroups.put(grp,new LineItemGroup(grp, dsType, this));        
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    public LIST<LineItemGroup> getGroups() {//Get the groups based on the map keyset
        //return this in alpha order
        LIST<LineItemGroup> rtn = new LIST<LineItemGroup>();
        LIST<string> sortorder = new LIST<string>(mapGroups.keySet());
        sortorder.sort();
        for (string p : sortorder)
            rtn.add(mapGroups.get(p));
        return  rtn;
    }
    
    public GrandTotal getGrandTotal(){//Fetch the Grand Totals of each group
        GrandTotal           GT1 = new GrandTotal();
        GT1.calcGrandTotals(getGroups());
        return GT1;
    }
    
    public void save() { save(false); }//Save without zero values
    public void save(boolean includeZeroValueSchedules) {
        LIST<DemandItemSchedule__c> ScheduleToUpsert = new LIST<DemandItemSchedule__c>();
        for (LineItemGroup g : mapGroups.values()) {     //For each demand Item group
            for (LineItem li : g.items) {   //For each demand item in group
                for (Schedule si : li.mapSchedules.values()) {//For each schedule period in the demand item.
                    
                    if (includeZeroValueSchedules || !si.isZeroValue || true) {//Obsolete condition
                        if (si.item.Id==null) { //non-existant signal
                            si.item.DemandItem__c=li.di.id;
                            si.item.name=DateTime.newInstance(si.scheduleDate,Time.newInstance(0,0,0,0)).format('MMMM yyyy');
                            
                        }
                        ScheduleToUpsert.add(si.item); //Add in the list to save
                    }
                }
            }
        }
        if (ScheduleToUpsert.size()>0)
            upsert ScheduleToUpsert; //Update the values
        //refresh();       
        
    }
    
    //AB20140310 Starts
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    public class DemandGoal{ //Class to display Goals on Demand View page
        
        public Map<Date,String> mapBusiness;
        public List<Date> GoalPeriod; //Period for which the goal needs to be displayed
        public Demand parent    {get; set;} 
        public Map<Date,Decimal> mapQuantityGoals; //map of Quantity Demand Goals
        public Map<Date,Decimal>  mapRevenueGoals; //map of Revenue Demand Goals
        public List<Date> GoalKeys {get;set;}   // List of the keys for which goals needs to be displayed    
        
        DemandGoal(Demand parent){
            mapQuantityGoals = new Map<Date,Decimal>();
            mapRevenueGoals =  new Map<Date,Decimal>();
            mapBusiness =  new Map<Date,String>();
            loadDemandGoals(parent);
            
        }
        
        public void loadDemandGoals(Demand parent){
            List<Date> tempPeriod = new List<Date>();
            for(DemandGoal__c DG: [SELECT Base_Date__c, Business__c, Name, Goal_Period__c, MDDemand__c, 
                                   Quantity_Goal__c, Id, Revenue_Goal__c FROM DemandGoal__c where 
                                   mdDemand__c = :parent.demandId 
                                   order by createdDate]) 
            {
                //Get the demand goals for each demand
                Date dtGoalPeriod = Date.newInstance(Integer.valueOf(DG.Goal_Period__c.year()),Integer.valueOf(DG.Goal_Period__c.month()),1);
                if(DG.Quantity_Goal__c==null){//AB20141118
                    mapQuantityGoals.put(dtGoalPeriod,0);
                }else{
                    mapQuantityGoals.put(dtGoalPeriod,DG.Quantity_Goal__c);
                }
                
                if(DG.Revenue_Goal__c==null){//AB20141118
                    mapRevenueGoals.put(dtGoalPeriod,0); 
                }else{
                    mapRevenueGoals.put(dtGoalPeriod,DG.Revenue_Goal__c); 
                }
                
                tempPeriod.add(dtGoalPeriod);
                //system.debug('=========??>> '+dtGoalPeriod);
                //system.debug('=========??>> '+mapQuantityGoals.get(dtGoalPeriod));
                if(DG.Business__c==null){//AB20141118
                    mapBusiness.put(dtGoalPeriod,'');
                }else{
                    mapBusiness.put(dtGoalPeriod,DG.Business__c);
                }
                
            }
            GoalKeys = tempPeriod;
        }
        
        public List<Date> getGoalPeriod(){
            return GoalPeriod;
        }
        
        public Map<Date,String> getmapBusiness(){
            return mapBusiness;
        }
        
        public Map<Date,Decimal> getmapQuantityGoals(){
            return mapQuantityGoals;
        }
        
        public Map<Date,Decimal> getmapRevenueGoals(){
            return mapRevenueGoals;
        }
        
        public String getDynamicFormatString()
        {//Method to format the values
            Decimal value = 1000.10;
            String formattedValue = value.format();
            String thousandSep = formattedValue.substring(1,2);
            String decimalSep = formattedValue.substring(5,6);
            return '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';
        }
        
        
        
        public Date currentKey {
            GET {
                return currentKey;
            }
            
            SET {
                currentKey=value;
            }
        }   
        
        
        public Decimal currentRevGoal {
            GET {
                try{
                    return mapRevenueGoals.get(currentKey);
                }catch(Exception e){
                    return null;
                }
            }			            
        } 
        
        public Decimal currentQtyGoal {
            GET {
                try{
                    return mapQuantityGoals.get(currentKey);
                }catch(Exception e){
                    return 0;//<AB20141118>
                }
            }            
        } 
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    public class GrandTotal extends schedule{//Class to calculate and display grand total
        
        public map<Date, Decimal> qtyGrandTotal; 
        public map<Date, Decimal> revGrandTotal;
        public  map<Date, Decimal> actualRevGrandTotal; //<AB20141110> created map instead of decimal to hold multiple actuals for post period
        public  map<Date, Decimal> actualQtyGrandTotal; //<AB20141110> created map instead of decimal to hold multiple actuals for post period
        
        public map<Date, Decimal> qtyFcst1GrandTotal; 
        public map<Date, Decimal> revFcst1GrandTotal;
        public map<Date, Decimal> qtyFcst2GrandTotal; 
        public map<Date, Decimal> revFcst2GrandTotal;
        public map<Date, Decimal> qtyPYMActualGrandTotal; 
        public map<Date, Decimal> revPYMActualGrandTotal;
        
        
        
        
        public List<Date> revKeys {get;set;}
        public List<Date> qtyKeys {get;set;}  
        public List<Date> revActKeys {get;set;}  //<AB20141110> List of keys to hold values for the period in which actuals are available
        public List<Date> qtyActKeys {get;set;}  //<AB20141110> List of keys to hold values for the period in which actuals are available
        public List<Date> qtyFcst1Keys {get;set;}
        public List<Date> revFcst1Keys {get;set;}
        public List<Date> qtyFcst2Keys {get;set;}
        public List<Date> revFcst2Keys {get;set;}
        public List<Date> qtyPYMActualKeys {get;set;}
        public List<Date> revPYMActualKeys {get;set;}
        
        public GrandTotal() {  
            qtyGrandTotal = new Map<Date, Decimal>();
            revGrandTotal = new Map<Date, Decimal>();
            actualRevGrandTotal = new Map<Date, Decimal>(); //<AB20141110> 
            actualQtyGrandTotal = new Map<Date, Decimal>(); //<AB20141110> 
            
            qtyFcst1GrandTotal = new Map<Date, Decimal>(); 
            revFcst1GrandTotal = new Map<Date, Decimal>();
            qtyFcst2GrandTotal = new Map<Date, Decimal>(); 
            revFcst2GrandTotal = new Map<Date, Decimal>();
            qtyPYMActualGrandTotal = new Map<Date, Decimal>(); 
            revPYMActualGrandTotal = new Map<Date, Decimal>();
            
            revKeys = new List<Date>();
            qtyKeys = new List<Date>();
            revActKeys = new List<Date>(); //<AB20141110> 
            qtyActKeys = new List<Date>(); //<AB20141110> 
            qtyFcst1Keys  = new List<Date>();
            revFcst1Keys  = new List<Date>();
            qtyFcst2Keys  = new List<Date>();
            revFcst2Keys  = new List<Date>();
            qtyPYMActualKeys  = new List<Date>();
            revPYMActualKeys  = new List<Date>();
            
            
        }
        
        
        //<AB20141110> Starts
        public Map<Date,Decimal> getactualRevGrandTotal(){
            try{
                return actualRevGrandTotal;
            }catch(Exception e){return null;}
        }
        public Map<Date,Decimal> getactualQtyGrandTotal(){
            try{
                return actualQtyGrandTotal;
            }catch(Exception e){return null;}
        }
        //<AB20141110> Ends
        
        public Map<Date,Decimal> getqtyGrandTotal(){            
            return qtyGrandTotal;
        }
        
        public Map<Date,Decimal>  getrevGrandTotal(){            
            try{
                return revGrandTotal;
            }catch(Exception e){return null;}
        }
        
        public Map<Date,Decimal> getrevFcst1GrandTotal(){
            try{
                return revFcst1GrandTotal;
            }catch(Exception e){ return null;} 
        }
        
        public Map<Date,Decimal> getrevFcst2GrandTotal(){
            try{
                return revFcst2GrandTotal;
            }catch(Exception e){ return null;} 
        }        
        
        public Map<Date,Decimal> getrevPYMActualGrandTotal(){
            try{
                return revPYMActualGrandTotal;
            }catch(Exception e){ return null;} 
        }
        
        public Map<Date,Decimal> getqtyFcst1GrandTotal(){
            try{
                return qtyFcst1GrandTotal;
            }catch(Exception e){ return null;} 
        }
        
        public Map<Date,Decimal> getqtyFcst2GrandTotal(){
            try{
                return qtyFcst2GrandTotal;
            }catch(Exception e){ return null;} 
        }
        
        public Map<Date,Decimal> getqtyPYMActualGrandTotal(){
            try{
                return qtyPYMActualGrandTotal;
            }catch(Exception e){ return null;} 
        }
        
        public void calcGrandTotals(List<LineItemGroup> listGroups){
            Set<Date> revSet = new Set<Date>();
            Set<Date> qtySet = new Set<Date>();
            Set<Date> revActSet = new Set<Date>(); //<AB20141110> Set to avoid duplicate values
            Set<Date> qtyActSet = new Set<Date>(); //<AB20141110> Set to avoid duplicate values
            
            Set<Date> qtyFcst1Set = new Set<Date>();
            Set<Date> qtyFcst2Set = new Set<Date>();
            Set<Date> qtyPYMASet = new Set<Date>();
            Set<Date> revFcst1Set = new Set<Date>();
            Set<Date> revFcst2Set = new Set<Date>();
            Set<Date> revPYMASet = new Set<Date>();
            
            for(LineItemGroup lig : listGroups){
                for (LineItem li : lig.items) {
                    integer i = 0;
                    for (Schedule si : li.mapSchedules.values()) {
                        
                        if(si!=null && si.item.Name!=null){//<AB20141110> Starts
                            if(si.item.RevFcst__c!=null){
                                revGrandTotal = calcGrandTotalValues(si.item.RevFcst__c, si.item.BaseDate__c, revGrandTotal);
                                revSet = insertKeys(revSet,si.item.BaseDate__c,revKeys);
                            }else{
                                revGrandTotal = calcGrandTotalValues(0, si.item.BaseDate__c, revGrandTotal);
                                revSet = insertKeys(revSet,si.item.BaseDate__c,revKeys);
                            }
                            if(si.item.QtyFcst__c!=null ){
                                qtyGrandTotal = calcGrandTotalValues(si.item.QtyFcst__c,  si.item.BaseDate__c, qtyGrandTotal);
                                qtySet = insertKeys(qtySet,si.item.BaseDate__c,qtyKeys);                                
                            }else{
                                qtyGrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, qtyGrandTotal);
                                qtySet = insertKeys(qtySet,si.item.BaseDate__c,qtyKeys);
                            }
                            if(si.item.RevActual__c!=null ){
                                actualRevGrandTotal = calcActualRevGrandTotals(si.item.RevActual__c,si.item.BaseDate__c,actualRevGrandTotal);//<AB20141110> 
                                revActSet = insertKeys(revActSet,si.item.BaseDate__c,revActKeys);     
                            }else{
                                actualRevGrandTotal = calcActualRevGrandTotals(0,si.item.BaseDate__c,actualRevGrandTotal);
                                revActSet = insertKeys(revActSet,si.item.BaseDate__c,revActKeys);     
                            }
                            if(si.item.QtyActual__c!=null){
                                actualQtyGrandTotal = calcActualQtyGrandTotals(si.item.QtyActual__c,si.item.BaseDate__c,actualQtyGrandTotal);//<AB20141110> 
                                qtyActSet = insertKeys(qtyActSet,si.item.BaseDate__c,qtyActKeys);   
                            }else{
                                actualQtyGrandTotal = calcActualQtyGrandTotals(0,si.item.BaseDate__c,actualQtyGrandTotal); 
                                qtyActSet = insertKeys(qtyActSet,si.item.BaseDate__c,qtyActKeys);    
                            }
                            
                            if(si.item.RevFcst1__c!=null ){
                                revFcst1GrandTotal = calcGrandTotalValues(si.item.RevFcst1__c,  si.item.BaseDate__c, revFcst1GrandTotal);
                                revFcst1Set = insertKeys(revFcst1Set,si.item.BaseDate__c,revFcst1Keys);                                
                            }else{
                                revFcst1GrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, revFcst1GrandTotal);
                                revFcst1Set = insertKeys(revFcst1Set,si.item.BaseDate__c,revFcst1Keys); 
                            }
                            if(si.item.RevFcst2__c!=null ){
                                revFcst2GrandTotal = calcGrandTotalValues(si.item.RevFcst2__c,  si.item.BaseDate__c, revFcst2GrandTotal);
                                revFcst2Set = insertKeys(revFcst2Set,si.item.BaseDate__c,revFcst2Keys);                                
                            }else{
                                revFcst2GrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, revFcst2GrandTotal);
                                revFcst2Set = insertKeys(revFcst2Set,si.item.BaseDate__c,revFcst2Keys);     
                            }
                            if(si.item.PYMSchedule__r.RevActual__c!=null ){
                                revPYMActualGrandTotal = calcGrandTotalValues(si.item.PYMSchedule__r.RevActual__c,  si.item.BaseDate__c, revPYMActualGrandTotal);
                                revPYMASet = insertKeys(revPYMASet,si.item.BaseDate__c,revPYMActualKeys);                                
                            }else{
                                revPYMActualGrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, revPYMActualGrandTotal);
                                revPYMASet = insertKeys(revPYMASet,si.item.BaseDate__c,revPYMActualKeys);                                
                            }
                            if(si.item.QtyFcst1__c!=null ){
                                qtyFcst1GrandTotal = calcGrandTotalValues(si.item.QtyFcst1__c,  si.item.BaseDate__c, qtyFcst1GrandTotal);
                                qtyFcst1Set = insertKeys(qtyFcst1Set,si.item.BaseDate__c,qtyFcst1Keys);                                
                            }else{
                                qtyFcst1GrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, qtyFcst1GrandTotal);
                                qtyFcst1Set = insertKeys(qtyFcst1Set,si.item.BaseDate__c,qtyFcst1Keys); 
                            }
                            if(si.item.QtyFcst2__c!=null ){
                                qtyFcst2GrandTotal = calcGrandTotalValues(si.item.QtyFcst2__c,  si.item.BaseDate__c, qtyFcst2GrandTotal);
                                qtyFcst2Set = insertKeys(qtyFcst2Set,si.item.BaseDate__c,qtyFcst2Keys);                                
                            }else{
                                qtyFcst2GrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, qtyFcst2GrandTotal);
                                qtyFcst2Set = insertKeys(qtyFcst2Set,si.item.BaseDate__c,qtyFcst2Keys);  
                            }
                            if(si.item.PYMSchedule__r.QtyActual__c!=null ){
                                qtyPYMActualGrandTotal = calcGrandTotalValues(si.item.PYMSchedule__r.QtyActual__c,  si.item.BaseDate__c, qtyPYMActualGrandTotal);
                                qtyPYMASet = insertKeys(qtyPYMASet,si.item.BaseDate__c,qtyPYMActualKeys);                                
                            }else{
                                qtyPYMActualGrandTotal = calcGrandTotalValues(0,  si.item.BaseDate__c, qtyPYMActualGrandTotal);
                                qtyPYMASet = insertKeys(qtyPYMASet,si.item.BaseDate__c,qtyPYMActualKeys);                                
                                
                            }//<AB20141110> Ends
                        }
                    }
                }
            }
        }
        
        public Set<Date> insertKeys(Set<Date> s, Date d, List<Date> Keys){
            if(!s.contains(d)){
                Keys.add(d);
                s.add(d);//To have unique val
            }
            return s;
        }
        //<AB20141110> Starts
        public map<Date, Decimal> calcActualRevGrandTotals(Decimal value, Date period, map<Date, Decimal> mp){
            if(mp!=null){
                if(mp.get(period)!=null){
                    decimal temp = value + mp.get(period);
                    mp.remove(period);
                    mp.put(period, temp);                
                }else{
                    mp.put(period, value);
                }
            }
            return mp;
        }
        
        
        public map<Date, Decimal> calcActualQtyGrandTotals(Decimal value, Date period, map<Date, Decimal> mp){
            if(mp!=null){
                if(mp.get(period)!=null){
                    decimal temp = value + mp.get(period);
                    mp.remove(period);
                    mp.put(period, temp);                
                }else{
                    mp.put(period, value);
                }
            }
            return mp;
        }
        //<AB20141110> Ends
        
        public String getDynamicFormatString()
        {
            Decimal value = 1000.10;
            String formattedValue = value.format();
            String thousandSep = formattedValue.substring(1,2);
            String decimalSep = formattedValue.substring(5,6);
            return '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';
        }
        
        public map<Date, Decimal> calcGrandTotalValues(Decimal value, Date period, map<Date, Decimal> mp){
            if(mp!=null){
                if(mp.get(period)!=null){
                    decimal temp = value + mp.get(period);
                    mp.remove(period);
                    mp.put(period, temp);                
                }else{
                    mp.put(period, value);
                }
            }
            return mp;
        }
        
    }
    
    //AB20140310 Ends
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class LineItemGroup {
        
        MAP<string,LineItem> mapItems;
        MAP<string,GroupColumn> mapColumns;
        public Demand parent            {get; set;} 
        public string name              {get; set;} 
        public string forecastType      {get; set;}
        
        public LineItemGroup(String groupName, String fType, Demand p) {
            name=groupName;
            forecastType=ftype;
            parent=p;
            loadItems();
            loadColumns();
        }
        
        
        public LIST<LineItem> items {
            GET {
                LIST<LineItem>  rtn = new LIST<LineItem>();
                LIST<string> sortorder = new LIST<string>(mapItems.keySet());
                sortorder.sort();
                for (string s : sortorder)
                    rtn.add(mapItems.get(s));
                return  rtn;
            }
        }
        
        public List<DemandItemSchedule__c> addItem(DemandItem__c oli) { 
            //TODO init default values
            return addItem(new LineItem(oli, this)); 
        }
        
        public List<DemandItemSchedule__c> addItem(LineItem li) { 
            return updateAndAddItem(li);
        }
        
        public List<DemandItemSchedule__c> updateAndAddItem(LineItem li){
            Map<String,Schedule> mapOutOfRangeLi = new Map<String,Schedule>();
            List<DemandItemSchedule__c> sUpdate = new List<DemandItemSchedule__c>();
            for(Schedule s: li.getOutOfRangeSchedules()){
                mapOutOfRangeLi.put(String.valueOf(s.item.basedate__c.month())+String.valueOf(s.item.basedate__c.year()), s);
            }
            for(Schedule s: li.getSchedules()){
                String strKey = String.valueOf(s.item.basedate__c.month())+String.valueOf((s.item.basedate__c).addYears(-1).year());
                if(s.item.PYMSchedule__r==null && mapOutOfRangeLi.get(strKey)!=null){
                    s.item.PYMSchedule__r=(mapOutOfRangeLi.get(strKey)).item;
                    sUpdate.add(s.item);
                    mapItems.put(li.indx,li); 
                }else{
                    mapItems.put(li.indx,li); 
                }
            }
            return sUpdate;
        }
        
        
        private void loadItems() {
            if (mapItems!=null) 
                mapItems.clear();
            else 
                mapItems=new MAP<string,LineItem>();
            
            integer idx=0;
            //TODO:  consider, dyna-query all DS fields and moving to parent
            List<DemandItemSchedule__c> DISToBeUpdated;
            for (DemandItem__c di : [
                SELECT Id, Group__c, Demand__c, Name, 
                (    Select d.Id, d.Name, d.BaseDate__c, d.DemandItem__c, 
                 d.RevGoal__c, d.QtyGoal__c, d.RevActual__c, d.QtyActual__c,
                 d.RevFcst__c, d.RevFcst0__c, d.RevFcst1__c, d.RevFcst2__c, 
                 d.QtyFcst__c, d.QtyFcst0__c, d.QtyFcst2__c, d.QtyFcst1__c, 
                 d.fRevPYMActual__c, d.fQtyPYMActual__c, d.PYMSchedule__c, d.PYMSchedule__r.RevActual__c, 
                 d.PYMSchedule__r.QtyActual__c,d.PYMSchedule__r.BaseDate__c  
                 From Schedules__r d where (BaseDate__c <= :this.startDT and BaseDate__c >= :this.endDT) or
                 (BaseDate__c <= :this.startDT.addYears(-1) and BaseDate__c >= :this.endDT.addYears(-1))
                )
                
                FROM DemandItem__c o
                WHERE Demand__c =: parent.demandId 
                AND Demand__r.Type__c=:forecastType
                AND group__c=:name
                ORDER BY CreatedDate
            ]
                ){ 
                    DISToBeUpdated = addItem(di);
                }
            
        }
        
        
        
        private void loadColumns() {
            if (mapColumns!=null) 
                mapColumns.clear();
            else 
                mapColumns = new MAP<string,GroupColumn>();
            for(Date dt : getDates()) {
                GroupColumn col = new GroupColumn(dt, this);
                mapColumns.put(col.idx,col);
            }
        }
        
        //need to sort if returned in order by key.
        public LIST<GroupColumn> getColumns(){
            LIST<GroupColumn> rtn = new LIST<GroupColumn>();
            for (string xdt : getXmlDates())
                rtn.add(mapColumns.get(xdt));
            return rtn;
        }
        
        public GroupColumn getColumn(string xmlDate){
            return mapColumns.get(xmlDate);
        }
        
        
        public LIST<string> getXmlDates() {
            LIST<string> rtn = new LIST<string>();
            for (Date dt : getDates())
                rtn.add(Util.DateToXml(dt));
            return rtn;
        }
        
        public LIST<Date> getDates() {
            Date dt = normalizeDate(parent.baseDT, ScheduleUnit.MONTH);
            return getScheduleDates(dt, parent.duration, ScheduleUnit.MONTH);
        }
        
        public Date startDT {
            GET {
                LIST<Date> dates=getDates();
                return dates[dates.size()-1];
            }
        }       
        public Date endDT {
            GET { 
                return getDates()[0]; 
            }
        }
        
        public LIST<Totals> getTotals() {
            LIST<Totals> rtn = new LIST<Totals>();
            for (Date dt : getDates()) {
                Totals t = new Totals(dt);
                
                for (LineItem li : items){
                    t.sumSchedule(li.getSchedule(dt));                  }
                rtn.add(t);
            }
            return rtn; 
        }
        
        
        
    } //end class: ProductGroup
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    public class GroupColumn {
        public string           idx     {get; set;}
        public LineItemGroup    parent  {get; set;}
        public Date             period  {get; set;}
        
        public GroupColumn(Date dt, LineItemGroup p) {
            idx=Util.DatetoXml(dt);
            period=dt;
            parent=p;
        }
        
        public boolean isPostPeriod {
            GET { 
                return (period<normalizeDate(Date.Today(),ScheduleUnit.MONTH)); 
            }
        }
        
        public Totals total {
            GET {
                Totals rtn = new Totals(period);
                for (LineItem li : parent.items)
                    rtn.sumSchedule(li.getSchedule(period));
                
                return rtn;
            }
        }
        
        
        public Schema.FieldSet fieldset {
            GET {
                if (!this.isPostPeriod)
                    return parent.parent.fieldset;
                else
                    return parent.parent.postfieldset;
            }
        }
        
        public integer totalSubColumns {
            GET {
                return fieldset.getFields().size();
            }
        }   
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public class Totals extends Schedule {
        public Totals(Date dt) {
            super(dt);
            revenue=0;
            quantity=0;
            actualRevenue=0;
            actualQuantity=0;
        }
        public void sumSchedule(Schedule s) {
            if (s!=null) {
                revenue+=(s.item!=null && s.revenue!=null) ? s.revenue : 0;
                quantity+=(s.item!=null && s.quantity!=null) ? s.quantity : 0;
                actualRevenue+=(s.item!=null && s.actualRevenue!=null) ? s.actualRevenue : 0;
                actualQuantity+=(s.item!=null && s.actualQuantity!=null) ? s.actualQuantity : 0;
                
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public class LineItem {
        
        public LineItemGroup parent                         {get; set;}
        public string indx                                  {get; set;}
        public DemandItem__c DI                             {get; set;}
        MAP<string,Schedule> mapSchedules;              
        public boolean scheduleOutofRange                   {get; set;}
        
        
        
        //constructors
        public LineItem(DemandItem__c di, LineItemGroup ds) {
            this.DI=di;
            this.indx=DI.id;
            this.parent=ds;
            initSchedules();
            
        }
        
        public Schedule getSchedule(Date dt)        { 
            return mapSchedules.get(Util.DatetoXml(dt));    
        }
        
        public Schedule getSchedule(string xmlDate) { 
            return mapSchedules.get(xmlDate);               
        }
        
        
        //This will only get schedules records which are in range (based on ScheduleBaseDate,duration,schedUnit)
        public LIST<Schedule> getSchedules() {
            LIST<Schedule> rtn = new LIST<Schedule>();
            LIST<string> sortorder = parent.getXmlDates();
            sortorder.sort();
            for (string s : sortorder)
                rtn.add(mapSchedules.get(s));
            return  rtn;
        }
        
        public LIST<Schedule> getOutOfRangeSchedules() {
            LIST<Schedule> rtn = new LIST<Schedule>();
            SET<string> inscope = new SET<string>(parent.getXmlDates());
            for (string s : mapSchedules.keySet()) {
                if (!inscope.contains(s)) 
                    rtn.add(mapSchedules.get(s));
            }
            return  rtn;
        }
        
        //TODO: determine if this should calculate only in range items        
        public decimal revenueSum {
            GET  { 
                decimal rtn=0;
                for (Schedule si : mapSchedules.values())
                    rtn+=(si.item!=null && si.revenue!=null) ? si.revenue : 0;
                return rtn;
            }
        }
        
        //TODO: determine if this should calculate only in range items
        public decimal quantitySum {
            
            GET  { 
                decimal rtn=0;
                for (Schedule si : mapSchedules.values())
                    rtn+=(si.item!=null && si.quantity!=null) ? si.quantity : 0;
                return rtn;
            }
        }
        
        public decimal actualRevenueSum {
            
            GET  { 
                decimal rtn=0;
                for (Schedule si : mapSchedules.values())
                    rtn+=(si.item!=null && si.actualRevenue!=null) ? si.actualRevenue : 0;
                return rtn;
            }
        }
        
        public decimal actualQuantitySum {
            
            GET  { 
                decimal rtn=0;
                for (Schedule si : mapSchedules.values())
                    rtn+=(si.item!=null && si.actualQuantity!=null) ? si.actualQuantity : 0;
                return rtn;
            }
        }
        private void initSchedules() {
            
            scheduleOutofRange = false;
            mapSchedules = new MAP<string,Schedule>();  //<xmlDate,Schedule>
            
            //Create matrix empties first
            for (Date dt : parent.getDates()) {
                mapSchedules.put(Util.DatetoXml(dt),new Schedule(dt,this));
            }
            
            //Check existing data for matches 
            //scheduleOutofRange: indicates some existing schedule(s) are out of range
            for ( DemandItemSchedule__c s : DI.Schedules__r) {
                string strDT = Util.DatetoXml(s.BaseDate__c);
                if (!mapSchedules.containsKey(strDT))
                    scheduleOutofRange=true;
                mapSchedules.put(strDT, new Schedule(s,this)); 
                
            }
        }
        
        
        
        
    }//LineItem Class
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public virtual class Schedule {
        
        public  string indx                         {get; set;}
        public LineItem parent                      {get; set;}
        public  DemandItemSchedule__c item          {get; private set;}
        private DemandItemSchedule__c orig;
        
        public Schedule(DemandItemSchedule__c s, LineItem li) { this(Util.DatetoXml(s.BaseDate__c),s,li); }
        public Schedule(string idx,DemandItemSchedule__c s, LineItem li) {
            this.indx=idx;
            this.item=s;
            this.parent=li;
            orig=s.clone(true,true);
        }
        
        public Schedule(){}
        
        //creates a dummy Schedule
        public Schedule(Date dt) { this(dt,null); }
        public Schedule(Date dt, LineItem li) {
            this.item = new DemandItemSchedule__c(baseDate__c=dt);
            indx=Util.DatetoXml(dt); 
            this.parent=li;
            orig=this.item.clone(true,true);
        }
        
        public DemandItemSchedule__c goal {
            get { return item; } 
        }
        
        public Date scheduleDate {
            GET {
                return item.BaseDate__c;
            }
            SET {
                item.BaseDate__c=value;
                indx=Util.DatetoXml(item.BaseDate__c);
            }
        }   
        
        public boolean isDirty {
            GET { 
                return (item != orig); 
            }
        }
        
        public Decimal revenue {
            GET {
                return item.RevFcst__c;
            }
            SET {
                item.RevFcst__c=value;
            }
        } 
        
        public boolean revDirty {
            GET {
                return (item.RevFcst__c!=orig.RevFcst__c);
            }
        }      
        
        public boolean qtyDirty {
            GET {
                return (item.QtyFcst__c!=orig.QtyFcst__c);
            }
        }
        
        public Decimal quantity {
            GET {
                return item.QtyFcst__c;
            }
            SET {
                item.QtyFcst__c=value;
            }
        } 
        
        
        public Decimal actualQuantity {
            GET {
                return item.QtyActual__c;
            }
            SET {
                item.QtyActual__c=value;
            }
            
        }
        public Decimal actualRevenue {
            GET {
                return item.RevActual__c;
            }
            SET {
                item.RevActual__c=value;
            }
        }
        
        public GroupColumn column {
            GET {
                return parent.parent.getColumn(this.indx);
            }
        }
        
        
        public Schema.FieldSet fieldset {
            GET {
                if(this.column!=null)
                    return this.column.fieldset;
                else
                    return null;
            }
        }   
        
        
        public boolean isZeroValue {
            GET {
                if (fieldset!=null){
                    //makes sure at least one numerical field in fieldset is >0
                    for( Schema.FieldSetMember fsm : fieldset.getFields()) {
                        Schema.DisplayType typ = fsm.getType();
                        if (typ == Schema.DisplayType.Double || typ == Schema.DisplayType.Currency ||
                            typ == Schema.DisplayType.Integer || typ == Schema.DisplayType.Percent ) {
                                Decimal val=(Decimal) item.get(fsm.getFieldPath());
                                if (val!=null && val>0) return false;   
                            }           
                    }
                }
                return true;
            }
        }
        
        
    }
    
    
    /*
public string infoText {
GET{
string rtn;
rtn='Product: '+parent.OLI.material__r.name;
rtn+='\nPeriod: '+scheduleDate.format();    
rtn+='\nGoal Rev: '+goal.Revenue_Goal__c;
rtn+='\nGoal Qty: '+goal.Quantity_Goal__c;      
rtn+='\nPrior Yr/Period Rev: '+item.fPrior_YR_Month_Actual__c;  
rtn+='\nPrior Yr/Period Qty: '+item.fPrior_YR_Month_Actual_Quantity__c;
rtn+='\nPeriod -1 Rev: '+item.Current_Month_1_Outlook_Revenue__c;   
rtn+='\nPeriod -1 Qty: '+item.Current_Month_1_Outlook_Quantity__c;  
rtn+='\nPeriod -2 Rev: '+item.Current_Month_2_Outlook_Revenue__c;   
rtn+='\nPeriod -2 Qty: '+item.Current_Month_2_Outlook_Quantity__c;  
if (debug)
rtn+='\n\n\nDebug: '+this;  
return rtn; 
}
}
*/
    
    
    /*
public string infoHTML {
GET{
string rtn;
rtn='<table class="ttip">';
rtn+='<tr><td><b>Product:</b></td><td>'+parent.OLI.material__r.name+'</td></tr>';
rtn+='<tr><td><b>Period:</b></td><td>'+scheduleDate.format()+'</td></tr>';  
rtn+='<tr><td><b>Goal Rev:</b></td><td>'+goal.Revenue_Goal__c+'</td></tr>';
rtn+='<tr><td><b>Goal Qty:</b></td><td>'+goal.Quantity_Goal__c+'</td></tr>';        
rtn+='<tr><td><b>Prior Yr/Period Rev:</b></td><td>'+item.fPrior_YR_Month_Actual__c+'</td></tr>';    
rtn+='<tr><td><b>Prior Yr/Period Qty:</b></td><td>'+item.fPrior_YR_Month_Actual_Quantity__c+'</td></tr>';
rtn+='<tr><td><b>Period -1 Rev:</b></td><td>'+item.Current_Month_1_Outlook_Revenue__c+'</td></tr>'; 
rtn+='<tr><td><b>Period -1 Qty:</b></td><td>'+item.Current_Month_1_Outlook_Quantity__c+'</td></tr>';    
rtn+='<tr><td><b>Period -2 Rev:</b></td><td>'+item.Current_Month_2_Outlook_Revenue__c+'</td></tr>'; 
rtn+='<tr><td><b>Period -2 Qty:</b></td><td>'+item.Current_Month_2_Outlook_Quantity__c+'</td></tr>';
rtn+='</table>';    
if (debug)
rtn+='<BR/><BR/><BR/><b>Debug:</b> '+this;  
return rtn; 
}
}
*/
    
    /*
public static ForecastType getForecastType(string str) {
string strType = str.toUppercase();
for(ForecastType t : ForecastType.values())
if (t.name().toUppercase()==strType )
return t;

return null;
}
*/ 
    
    
    
    //*****************************************************************************************
    // SYSTEM Method(s)
    //*****************************************************************************************
    
    public static LIST<Date> getScheduleDates(Date startDT , integer duration, ScheduleUnit unit) {
        LIST<Date> rtn = new LIST<Date>();
        if (startDT!=null)
            for (integer i=0; i<duration; i++) {
                Date dt;
                if (isLastDayOfMonth(startDT)) return getScheduleDates_LastDayOfMonth(startDT ,duration,unit);
                else if (unit==ScheduleUnit.YEAR)          dt=startDT.addYears(i);  
                else if (unit==ScheduleUnit.QUARTER)       dt=startDT.addMonths(i*3);
                else if (unit==ScheduleUnit.MONTH)         dt=startDT.addMonths(i);
                else if (unit==ScheduleUnit.WEEK)          dt=startDT.addDays(i*7);
                else if (unit==ScheduleUnit.DAY)           dt=startDT.addDays(i);                              
                rtn.add(dt);  //removed since sfdc does not normalize dates....rtn.add(normalizeDate(dt,schedUnit));    
            }
        return rtn;
    }
    
    
    public static boolean isLastDayOfMonth(Date dt) {
        return (dt==normalizeToLastDate(dt, ScheduleUnit.MONTH));
    }
    
    
    public static LIST<Date> getScheduleDates_LastDayOfMonth(Date startDT , integer duration, ScheduleUnit unit) {
        LIST<Date> rtn = new LIST<Date>();
        for (integer i=0; i<duration; i++) {
            Date dt;
            if      (unit==ScheduleUnit.YEAR)       dt=normalizeToLastDate(startDT.addYears(i),ScheduleUnit.MONTH);  
            else if (unit==ScheduleUnit.QUARTER)    dt=normalizeToLastDate(startDT.addMonths(i*3),ScheduleUnit.MONTH);
            else if (unit==ScheduleUnit.MONTH)      dt=normalizeToLastDate(startDT.addMonths(i),ScheduleUnit.MONTH);
            else if (unit==ScheduleUnit.WEEK)       dt=normalizeToLastDate(startDT.addDays(i*7),ScheduleUnit.MONTH);
            else if (unit==ScheduleUnit.DAY)        dt=normalizeToLastDate(startDT.addDays(i),ScheduleUnit.MONTH);                               
            rtn.add(dt);    
        }
        return rtn;
    }
    
    public static Date normalizeDate(Date dt, ScheduleUnit schedUnit) {
        Date normalizedDT;
        if  (schedUnit==ScheduleUnit.YEAR) 
            normalizedDT = Date.newInstance(dt.Year(),1,1);
        else if (schedUnit==ScheduleUnit.MONTH)
            normalizedDT=Date.newInstance(dt.Year(),dt.Month(),1);
        else if (schedUnit==ScheduleUnit.QUARTER && dt.Month()<=3)
            normalizedDT=Date.newInstance(dt.Year(),1,1);
        else if (schedUnit==ScheduleUnit.QUARTER && dt.Month()>3 && dt.Month()<=6)
            normalizedDT=Date.newInstance(dt.Year(),4,1);
        else if (schedUnit==ScheduleUnit.QUARTER && dt.Month()>6 && dt.Month()<=9)
            normalizedDT=Date.newInstance(dt.Year(),7,1);
        else if (schedUnit==ScheduleUnit.QUARTER && dt.Month()>9)                              
            normalizedDT=Date.newInstance(dt.Year(),10,1);
        return normalizedDT;
    }
    
    public static Date normalizeToLastDate(Date dt, ScheduleUnit schedUnit) {
        Date rtn;
        Date normalizedDT=normalizeDate(dt,schedUnit);
        if  (schedUnit==ScheduleUnit.YEAR) 
            rtn=Date.newInstance(normalizedDT.Year(),12,31);
        else if (schedUnit==ScheduleUnit.MONTH)
            rtn=normalizedDT.addMonths(1).addDays(-1);
        else if (schedUnit==ScheduleUnit.QUARTER)
            rtn=normalizedDT.addMonths(3).addDays(-1);
        return rtn;
    }
    
    
    public class DemandException extends Exception {} 
    
    
}
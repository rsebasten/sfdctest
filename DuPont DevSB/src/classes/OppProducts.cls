/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  A persistent ORM for handling an Opportunity with OpportunityLineItem(s) and OpportunityLineItemSchedule(s) 
 
        scheduleType:QuantityRevenueRelated will adjust the TotalPrice on Quanity Change
        scheduleType:Quantity will adjust the UnitPrice (Sale Price) on Quanity Change
        scheduleType:Revenue will not effect the Quantity on Revenue Change
        scheduleType:Both ?
----------------------------------------------------------      
TES20110912  Autodetect ScheduleType if not passed in constructor

TES20111021  updated save() support to delete zero value schedules (if includeZeroValueSchedules==false) 


TODO:  enum schedule types

TES20131023:  Add exception handling for missing Opportunity

Change History: <Ankit20170315 11:55 AM EDT> As a fix we have added one condition to set the quantity value in backend so that it does not fall in validation loop criteria when amount type is changed as a part of Issue IS ID-00079602 Code Coverage: 79% <AK 20170321 3:08 PM EDT>

Change History: <Bhargavi20170420> Added @TestVisible annotation to make private methods visible to test class.(IS ID-00081077)

********************************************************************************/
public with sharing class OppProducts {

    public enum ScheduleType { QUANTITY, REVENUE, BOTH, QUANTITYREVENUERELATED }
  public enum ScheduleUnit { YEAR, QUARTER, MONTH, WEEK, DAY }
    
    public Opportunity  opp                 {get; set;}
    public integer      duration            {get; set;} // number of schedules to work with 
    public date         startDT             {get; set;} // starting date of schedules
    public ScheduleType schedType           {get; set;} // revenue,quantity,both
    public ScheduleUnit schedUnit           {get; set;} // yearly,quarterly,monthly
    

    MAP<string,LineItem> mapItems; //{get; set;}  //MAP<Product2Id,LineItem>
    public class OppProductsException extends Exception {}
    
    //Constructor   
    public OppProducts(Opportunity o) { this(o,''); }
    public OppProducts(Opportunity o, string strSchedType) { this(o, getScheduleType(strSchedType)); } 
    public OppProducts(Opportunity o, scheduleType aSchedType) { 
      
      if (o==null)
        throw new OppProductsException('Opportunity is Null.');
      
        this.opp=o;
        //if (opp.ScheduleBaseDate__c==null) opp.ScheduleBaseDate__c=TODAY;
        startDT=opp.ScheduleBaseDate__c;
        duration=opp.Contract_Duration__c.intValue();
        schedType=aSchedType;  
        schedUnit=getScheduleUnitFromAmountType(opp.amount_type__c);        
        loadItems(); // will autodetect schedType if unspecified 
        if (schedType==null) schedType=ScheduleType.REVENUE;  //TES20110912
    }
    //////////////////////////////////////////////////////////////

    public string schedUnitCode {GET{return getScheduleUnitCode(schedUnit);}}
    public string schedTypeCode {GET{return getScheduleTypeCode(schedType);}}


    public string schedTypeFriendlyName {
        GET {   if      (schedType == ScheduleType.REVENUE)                     return 'Revenue';
                else if (schedType == ScheduleType.QUANTITY)                    return 'Quantity';
                else if (schedType == ScheduleType.QUANTITYREVENUERELATED)      return 'Quantity (Revenue Related)';
                else if (schedType == ScheduleType.BOTH)                        return 'Both (beta)';
                return 'No Schedule';
        }
    }

    //TODO: move to controller, UI specific....used for populating stock reestablish wizard date 
    public string formattedStartDT {
        GET {   return startDT.format(); }
    }


    public LIST<String> scheduleMatrixLabels {
        GET {
            LIST<String> rtn = new LIST<String>();
            for (date dt : getDates() ) {
                if      ( schedUnit==ScheduleUnit.YEAR )     
                    rtn.add(String.valueOf(dt.Year())); 
                else if ( schedUnit==ScheduleUnit.QUARTER )
                    rtn.add('Q'+(dt.Month()/3.0).round(System.RoundingMode.CEILING)+'-'+String.valueOf(dt.Year())); //Math.ceil seems to floor
                else if ( schedUnit==ScheduleUnit.MONTH   )
                    rtn.add(dt.Month()+'-'+dt.Year()); 
                else 
                    rtn.add(dt.format());
            }
            return rtn;
        }
    }

    //Warning: this will delete any active changes
    public void changeDuration(integer dur) {
        this.duration=dur;
        this.loadItems();
    }

    //Warning: this will delete any active changes and delete all schedules related to the opp
    public void changeScheduleType(string strScheduleType) { changeScheduleType(getScheduleType(strScheduleType)); }
    public void changeScheduleType(ScheduleType aScheduleType) {
        if (aScheduleType!=null && this.schedType!=aScheduleType) {
            this.schedType=aScheduleType;
            deleteOpportunityLineItemSchedules(Opp.Id);
            this.loadItems();
        }
    }

    //Warning: this will delete all products and schedules related to the opp (SFDC limitation: 1 Pbook per Opp)
    public void changePriceBook(string newPricebookId) {
        string currPbId =null;
        try {currPbId = [Select Pricebook2Id From Opportunity where Id=:opp.id].Pricebook2Id;}catch(Exception ex){}
        if (newPricebookId != currPbId) {
            deleteOpportunityLineItems(Opp.Id);
            opp.Pricebook2Id=newPricebookId;
            update opp;
            this.loadItems();
        }
    }


    //Warning: this will delete all existing schedules and reestablish
    public void changeAmountType(string amountType) {
        deleteOpportunityLineItemSchedules(Opp.Id);
        opp.Amount_Type__c=amountType;
        update opp;
        SchedUnit = getScheduleUnitFromAmountType(opp.Amount_Type__c);
        loadItems();
    }

    
    public void shiftStartDT(Date newDT) {
        opp.ScheduleBaseDate__c=newDT;
        LIST<Date> origDates = getScheduleDates(startDT,duration, schedUnit);
        LIST<Date> newDates = getScheduleDates(newDT,duration, schedUnit);
        
        for (LineItem li : items) {
            if (li.getSchedules().size()>0) {
                MAP<string, ScheduleItem> newSchedules = new MAP<string, ScheduleItem>();
                for (integer i=0;i<origDates.size();i++) {
                    system.debug('key: '+Util.DatetoXml(origDates[i]));
                    ScheduleItem si = li.mapSchedules.get(Util.DatetoXml(origDates[i]));
                    system.debug('li: '+li);
                    system.debug('sis: '+li.mapSchedules);
                    system.debug('si: '+si);
                    si.ScheduleDate=newDates[i];
                    newSchedules.put(si.indx,si);
                }
                li.mapSchedules=newSchedules;
            }
        }
        startDT=newDT;
        update opp;
    }   

    
    /*
    ///////////////////////////////////////////////////////////////
    public integer duration {
        GET {
            return opp.Contract_Duration__c.intValue();
        }
        SET {
            opp.Contract_Duration__c=value;
            loadItems();
        }
        
    }*/


    
    public LIST<LineItem> items {

        GET {
            //sort
            LIST<LineItem> rtn = new LIST<LineItem>();
            Map<string,string> sorter = new Map<string,string>(); //MAP<SortString,LineItem>
            for ( LineItem li : mapItems.values())
                sorter.put(li.oli.PricebookEntry.Product2.name, li.indx);
            LIST<string> sortorder = new LIST<string>(sorter.keyset());
            sortorder.sort();
            for (string s : sortorder)
                rtn.add(mapItems.get(sorter.get(s)));
            return rtn; 
            }
    }   
    
    
    public LineItem getItem(string indx) {
        return mapItems.get(indx);
    }
    
    public void addItem(PricebookEntry pbe) {           
        OpportunityLineItem oli = new OpportunityLineItem(PricebookEntry=pbe);
        oli.PricebookEntryId=pbe.id;
        if ((schedType==ScheduleType.QUANTITYREVENUERELATED || schedType==ScheduleType.QUANTITY) && pbe.UnitPrice!=null)
            oli.UnitPrice=pbe.UnitPrice;
        addItem(oli);   
    }
    
    public void addItem(OpportunityLineItem oli) { 
        if ( schedType==ScheduleType.REVENUE && (oli.Quantity==null || oli.Quantity==0)) 
            oli.Quantity=1;
        if ( schedType==ScheduleType.QUANTITY && (oli.Quantity==null || oli.Quantity==0)) 
            oli.Quantity=null; //1;
        if ( schedType==ScheduleType.QUANTITYREVENUERELATED && (oli.Quantity==null || oli.Quantity==0)) 
            oli.Quantity=null; //1;
        addItem(new LineItem(oli, this)); 
        }
    public void addItem(LineItem li) { mapItems.put(li.indx,li); }
    
        
    public void deleteItem(string indx ) {
        if (mapItems.containsKey(indx)){
            mapItems.get(indx).isDeleted=true;
        } 
    }
    
    public void undeleteItem(string indx ) {
        if (mapItems.containsKey(indx)){
            mapItems.get(indx).isDeleted=false;
        } 
    }   
    
    public string addProduct(string productId) {
        try {
            if (productId!=null) {
                PricebookEntry pbe = [Select Id, Product2Id, UnitPrice, Product2.Name, Product2.CanUseRevenueSchedule, Product2.CanUseQuantitySchedule from PricebookEntry 
                    where Product2id=:productId and PriceBook2id=:Opp.Pricebook2Id and CurrencyIsoCode=:Opp.CurrencyIsoCode];
                if ( (!pbe.Product2.CanUseRevenueSchedule) && (schedType==ScheduleType.REVENUE || schedType==ScheduleType.BOTH ) ) 
                    return 'The Product chosen is not configured for Revenue scheduling.';
                if ( (!pbe.Product2.CanUseQuantitySchedule) && (schedType==ScheduleType.QUANTITY || schedType==ScheduleType.QUANTITYREVENUERELATED) ) 
                    return 'Product chosen is not configured for Quantity scheduling.';
                if (mapItems.containsKey(pbe.Product2Id))
                    return 'Product already exists.';
                addItem(pbe);
                }
            return null;
        }
        catch (Exception Ex) {
            return 'Product not in Pricebook.';
            }
    }
    
    
    
    public PageReference refresh() {
        loadItems();
        return null;
    }
        
    //load from DB (distructive)
    private void loadItems() {
        if (mapItems!=null) 
            mapItems.clear();
        else 
            mapItems=new MAP<string,LineItem>();
        integer idx=0;
        for (OpportunityLineItem oli : [
            SELECT Id, Quantity, UnitPrice, Description, TotalPrice, OpportunityId, Competition__c,
                PricebookEntry.Id, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name,
                PriceBookEntry.Product2.CanUseRevenueSchedule, PriceBookEntry.Product2.CanUseQuantitySchedule,
                ( select id, ScheduleDate, Revenue, Quantity, Type from opportunitylineitemschedules )
            FROM OpportunityLineItem
            WHERE opportunityid =:this.opp.id 
            ORDER BY CreatedDate
            ]
        ){
            system.debug(oli);    
            //TES20110912 autodetect the scheduleType based on existing data
            if (this.schedType==null && oli.opportunitylineitemschedules.size()>0) {
                this.schedType=getScheduleType(oli.opportunitylineitemschedules[0].type);
                system.debug('Autdetected scheduleType:'+this.schedType);
            }   
            addItem(oli);                                   
        }
    }
    
    
    //TES20111021  updated save() support to delete zero value schedules (if includeZeroValueSchedules==false) 
    public void save() { save(true); }
    public void save(boolean includeZeroValueSchedules) {
    
    
        //detect if a change in startDT if so shift sched 
        if (opp.ScheduleBaseDate__c !=startDT) {
            shiftStartDT(opp.ScheduleBaseDate__c);
        }
        update opp;
        
        saveLineItems(includeZeroValueSchedules);
    }
                
    public void saveLineItems() { save(true); } 
    public void saveLineItems(boolean includeZeroValueSchedules) {  
        
        //delete lineItems marked for deletion
        LIST<OpportunityLineItem> LineItemsToDelete = new LIST<OpportunityLineItem>();
            for (LineItem li : mapItems.values()) {
                if (li.isDeleted && li.oli!=null && li.oli.id!=null)
                    LineItemsToDelete.add(li.oli);
            }
        if (LineItemsToDelete.size()>0)
            delete LineItemsToDelete;   
            
        //save LineItems
        LIST<OpportunityLineItem> LineItemsToUpsert = new LIST<OpportunityLineItem>();
        for (LineItem li : mapItems.values()) {
            system.debug(li);
            if (!li.isDeleted && li.OLI!=null) {
                if (li.OLI.PriceBookEntry.Product2Id != null) {
                    if (li.OLI.id==null) {
                            li.OLI.OpportunityId=opp.id;
                            if  (schedType==ScheduleType.REVENUE)
                                li.OLI.TotalPrice=li.revenueSum; //TODO check if done auto/or need to calc
                            else if (schedType==ScheduleType.QUANTITY) {
                                li.OLI.Quantity=li.quantitySum;
                                // KT 
                                //li.OLI.TotalPrice=0;
                            }
                            else if (schedType==ScheduleType.QUANTITYREVENUERELATED) {
                                //li.OLI.UnitPrice required via VF
                                li.OLI.Quantity=li.quantitySum;
                                li.OLI.TotalPrice=null;//UnitPrice (only one of unit price or total price may be specified)
                            }
                    }
                    
                    // <Ankit20170315 11:55 AM EDT> As a fix we have added one condition to set the quantity value in backend so that it does not fall in validation loop criteria when amount type is changed as a part of Issue IS ID-00079602
                    // Code Coverage: 79% <AK 20170321 3:08 PM EDT>
                    if(li.OLI.Quantity==null)
                      li.OLI.Quantity=1; //Change ends
                    LineItemsToUpsert.add(li.OLI);
                }
            }
        }
        system.debug(LineItemsToUpsert);
        if (LineItemsToUpsert.size()>0)
            upsert LineItemsToUpsert;

        LIST<OpportunityLineItemSchedule> SchedulesToDelete = new LIST<OpportunityLineItemSchedule>();
        //TODO determine whether to always delete zero valued schedules when out-of-range
        if (!includeZeroValueSchedules) {
            //remove existing zero value schedules not in range.  (common when reducing a duration) 
            for (LineItem li : mapItems.values()) {
                if (!li.isDeleted) {
                    for (ScheduleItem si : li.getOutOfRangeSchedules()) {
                        if (si.isZeroValue)
                            SchedulesToDelete.add(si.item);
                    }
                }
            }
        }
        
        
        
        LIST<OpportunityLineItemSchedule> SchedulesToUpsert = new LIST<OpportunityLineItemSchedule>();      
        for (LineItem li : mapItems.values()) {
            if (!li.isDeleted) {
                if (li.OLI.PriceBookEntry.Product2Id != null) {
                    //loop through each Schedule in Range
                    for (ScheduleItem si : li.getSchedules()) {
                        if  (schedType==ScheduleType.REVENUE) {
                            if (si.item.Revenue!=null ) {
                                if (includeZeroValueSchedules || si.item.Revenue!=0) {
                                    if (si.item.Id==null) //System.SObjectException: Field is not writeable: OpportunityLineItemOpportunityLineItemId
                                        si.item.OpportunityLineItemId=li.OLI.id;
                                    SchedulesToUpsert.add(si.item);
                                }
                                ////TES20111021
                                else if (si.item.id!=null) {
                                    SchedulesToDelete.add(si.item);
                                }
                            }
                        }
                        else if (schedType==ScheduleType.QUANTITY || schedType==ScheduleType.QUANTITYREVENUERELATED) {
                            if (si.item.Quantity!=null ) {
                                if (includeZeroValueSchedules || si.item.Quantity!=0) {
                                    if (si.item.Id==null) //System.SObjectException: Field is not writeable: OpportunityLineItemOpportunityLineItemId
                                        si.item.OpportunityLineItemId=li.OLI.id;
                                    SchedulesToUpsert.add(si.item);
                                }
                                ////TES20111021
                                else if (si.item.id!=null) {
                                    SchedulesToDelete.add(si.item);
                                }                       
                            }
                        }
                    }
                }
            }
        }
        
        ////TES20111021
        system.debug(SchedulesToDelete);
        if (SchedulesToDelete.size()>0)
            delete SchedulesToDelete;   
        
        
        system.debug(SchedulesToUpsert);
        if (SchedulesToUpsert.size()>0)
            upsert SchedulesToUpsert;
        refresh();
    }
    

    public class LineItem {
        public OppProducts parent                           {get; set;}
        public string indx                                  {get; set;}
        public OpportunityLineItem OLI                      {get; set;}
        //public Product2 selectedproduct                   {get; set;}
        MAP<string,ScheduleItem> mapSchedules;      //{get; set;} //all schedules in/out range
        public string description2                          {get; set;}

        //public boolean durationConflict = false;
        public boolean scheduleOutofRange                   {get; set;}
        public boolean isDeleted                            {get; set;}
        
                
        //constructors
        public LineItem(OpportunityLineItem oli, OppProducts oppProd) {
            this.isdeleted=false;
            this.indx=oli.PriceBookEntry.Product2Id;
            this.OLI=oli;
            this.parent=oppProd;
            initSchedules();
        }
        
        
        public boolean schedulingNotEnabledOnProduct {
            GET {
            if      (parent.schedType==ScheduleType.REVENUE) 
                return (!oli.PriceBookEntry.product2.CanUseRevenueSchedule);
            else if (parent.schedType==ScheduleType.BOTH) 
                return (!(oli.PriceBookEntry.product2.CanUseQuantitySchedule && oli.PriceBookEntry.product2.CanUseRevenueSchedule));            
            else // quantity && quantityrevrelated          
                return (!oli.PriceBookEntry.product2.CanUseQuantitySchedule);
            }
        }
        
        
        //operation = (E)each || (D)ivide
        public void reEstablish(decimal amount, string operation) {
            decimal amt=amount;
            if (operation.toUpperCase()=='D') 
                amt=(amount/parent.duration).setScale(2);

            for (ScheduleItem si : getSchedules()) {
                if (parent.schedType==ScheduleType.REVENUE)         
                    si.item.revenue=amt;
                else if (parent.schedType==ScheduleType.QUANTITY || parent.schedType==ScheduleType.QUANTITYREVENUERELATED)  
                    si.item.quantity=amt;
            }
        }
        
        //This will only get schedules records which are in range (based on ScheduleBaseDate,duration,schedUnit)
        public LIST<ScheduleItem> getSchedules() {
            LIST<ScheduleItem> rtn = new LIST<ScheduleItem>();
            LIST<string> sortorder = parent.getXmlDates();
            sortorder.sort();
            for (string s : sortorder)
                rtn.add(mapSchedules.get(s));
            return  rtn;
        }
        
        
        public LIST<ScheduleItem> getOutOfRangeSchedules() {
            LIST<ScheduleItem> rtn = new LIST<ScheduleItem>();
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
                for (ScheduleItem si : mapSchedules.values())
                    rtn+=(si.item!=null && si.item.revenue!=null) ? si.item.revenue : 0;
                return rtn;
            }
        }
        
        //TODO: determine if this should calculate only in range items
        public decimal quantitySum {
            
            GET  { 
                decimal rtn=0;
                for (ScheduleItem si : mapSchedules.values())
                    rtn+=(si.item!=null && si.item.quantity!=null) ? si.item.quantity : 0;
                return rtn;
            }
        }
        
        private void initSchedules() {

            scheduleOutofRange = false;
            mapSchedules = new MAP<string,ScheduleItem>();
            
            //Create matrix empties first
            for (Date dt : parent.getDates()) {
                mapSchedules.put(Util.DatetoXml(dt),new ScheduleItem(parent.schedType,dt));
            }

            //Check existing data for matches 
            //scheduleOutofRange: indicates some existing schedule(s) are out of range
            for ( OpportunityLineItemSchedule s : OLI.OpportunityLineItemSchedules) {
                string strDT = Util.DatetoXml(s.ScheduleDate);
                if (getScheduleType(s.type)!=parent.schedType) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Schedule type must match existing schedules.'));
                }
                if (!mapSchedules.containsKey(strDT))
                    scheduleOutofRange=true;
                    
                mapSchedules.put(strDT, new ScheduleItem(s)); 

            }

        }

        //public LineItem(Product2 prod) {}
        
        
        /*  useful only for normaized dates
        public void shift(integer offset) {
                //refresh mapKeys to reflct new indexes
                MAP<string,ScheduleItem> newSchedules = new MAP<string,ScheduleItem>();
                for (ScheduleItem si : mapSchedules.values()) {
                    if (parent.schedUnit=='Year')
                        si.scheduleDate=si.scheduleDate.addYears(offset);
                    else if (parent.schedUnit=='Quarter')
                        si.scheduleDate=si.scheduleDate.addMonths(offset*3);
                    else if (parent.schedUnit=='Month')
                        si.scheduleDate=si.scheduleDate.addMonths(offset);
                    newSchedules.put(si.indx,si);
                }
                mapSchedules=newSchedules;
                
            }
        }
        */
    
    }//LineItem Class
    
    
    //indx = ScheduleDate (xml styled date)
    public class ScheduleItem {
        public string indx                          {get; set;}
        public OpportunityLineItemSchedule item     {get; set;}
        private OpportunityLineItemSchedule orig;

        public ScheduleItem(OpportunityLineItemSchedule s) { this(Util.DatetoXml(s.ScheduleDate),s); }
        public ScheduleItem(string idx,OpportunityLineItemSchedule s) {
            this.indx=idx;
            this.item=s;
            orig=s.clone(true,true);
        }
        //creates a ScheduleItem dummy
        public ScheduleItem(string strSchedType, Date dt) { this(getScheduleType(strSchedType),dt); }
        public ScheduleItem(ScheduleType aSchedType, Date dt) { 
            if  (aschedType==ScheduleType.REVENUE)
                this.item = new OpportunityLineItemSchedule(ScheduleDate=dt,type='Revenue', Revenue=0.0);
            else if (aschedType==ScheduleType.QUANTITY)
                this.item = new OpportunityLineItemSchedule(ScheduleDate=dt,type='Quantity', Quantity=0.0);  
            else if (aschedType==ScheduleType.QUANTITYREVENUERELATED)
                this.item = new OpportunityLineItemSchedule(ScheduleDate=dt,type='QuantityRevenueRelated', Quantity=0.0);  
            else if (aschedType==ScheduleType.BOTH)
                this.item = new OpportunityLineItemSchedule(ScheduleDate=dt,type='Both', Quantity=0.0, Revenue=0.0);
            indx=Util.DatetoXml(dt); 
        }
        
        public ScheduleType getType() {
            return getScheduleType(item.type);
        }
        
        public Date scheduleDate {
            GET {
                return item.ScheduleDate;
            }
            SET {
                item.ScheduleDate=value;
                indx=Util.DatetoXml(item.ScheduleDate);
            }
        }   
            
        public boolean isDirty {
            GET { return (item != orig); }
        }
        
        public boolean isZeroValue {
            GET {
                if (this.getType()==ScheduleType.REVENUE && ( item.quantity==null || item.revenue==0)) return true;
                else return (item.quantity==null || item.quantity==0);
            }
        }

    }   
    
    //public class Schedule {

    
        public LIST<string> getXmlDates() {
            LIST<string> rtn = new LIST<string>();
            for (Date dt : getDates())
                rtn.add(Util.DateToXml(dt));
            return rtn;
        }
        
        public LIST<Date> getDates() {
            return getScheduleDates(this.startDT, this.duration, this.schedUnit);
        }


/******************************************************************************************
    Helper Methods
******************************************************************************************/



   @TestVisible private static void deleteOpportunityLineItems(string OppId) {    //<Bhargavi20170420> Added @TestVisible
            LIST<OpportunityLineItem> olisToDelete = new LIST<OpportunityLineItem>([
                 Select Id from OpportunityLineItem where OpportunityId=:OppId ]);
            delete olisToDelete;
    }


    @TestVisible private static void deleteOpportunityLineItemSchedules(string OppId) {  //<Bhargavi20170420> Added @TestVisible
        LIST<OpportunityLineItemSchedule> schedToDelete = new LIST<OpportunityLineItemSchedule>([ 
            Select Id from OpportunityLineItemSchedule where OpportunityLineItem.OpportunityId=:OppId ]);
        delete schedToDelete;
    }


        public static ScheduleUnit getScheduleUnitFromAmountType(string amountType) {
            if (!Util.isBlank(amountType)) {
                if (amountType.toLowercase().endsWith('months')) 
                    return ScheduleUnit.MONTH;
                else if (amountType.toLowercase().endsWith('quarters')) 
                    return ScheduleUnit.QUARTER;
                else if (amountType.toLowercase().endsWith('weeks')) 
                    return ScheduleUnit.WEEK;
                else if (amountType.toLowercase().endsWith('days')) 
                    return ScheduleUnit.DAY;
                else if (amountType.toLowercase().endsWith('years')) 
                    return ScheduleUnit.YEAR;
            }
            return null;
        }


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
                if      (unit==ScheduleUnit.YEAR)    dt=normalizeToLastDate(startDT.addYears(i),ScheduleUnit.MONTH);  
                else if (unit==ScheduleUnit.QUARTER)  dt=normalizeToLastDate(startDT.addMonths(i*3),ScheduleUnit.MONTH);
                else if (unit==ScheduleUnit.MONTH)    dt=normalizeToLastDate(startDT.addMonths(i),ScheduleUnit.MONTH);
                else if (unit==ScheduleUnit.WEEK)    dt=normalizeToLastDate(startDT.addDays(i*7),ScheduleUnit.MONTH);
                else if (unit==ScheduleUnit.DAY)    dt=normalizeToLastDate(startDT.addDays(i),ScheduleUnit.MONTH);                               
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
    
        //As per discussion w/ Gerard,  schedule dates should be normalized to the last date of frequency
        //in which schedule represents (ie. for 4/12/2011 (year:2011=12/31/2011,month:2011-Q2 6/30/2011,month:2011-4 4/30/2011))
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
        
        public static scheduleType getScheduleType(string str) {
            string strType = str.toUppercase();
            for(ScheduleType t : scheduleType.values())
                if (t.name().toUppercase()==strType || getScheduleTypeCode(t)==strType)
                    return t;
                   
            return null;
        }
        
      public static string getScheduleUnitCode(ScheduleUnit schedUnit) {
      if    (schedUnit==ScheduleUnit.YEAR)                     return '4';
      
          else if (schedUnit==ScheduleUnit.QUARTER)            return '3';
          else if (schedUnit==ScheduleUnit.MONTH)              return '2';
          else if (schedUnit==ScheduleUnit.WEEK)                   return '1';
          else if (schedUnit==ScheduleUnit.DAY)              return '0';
          return '';
      }
  
      public static string getScheduleTypeCode(ScheduleType schedType) {
      if      (schedType == ScheduleType.REVENUE)                     return 'R';
        else if (schedType == ScheduleType.QUANTITY)                    return 'Q';
        else if (schedType == ScheduleType.QUANTITYREVENUERELATED)      return 'Z';
        else if (schedType == ScheduleType.BOTH)                        return 'B';
        return 'N';
      }

}
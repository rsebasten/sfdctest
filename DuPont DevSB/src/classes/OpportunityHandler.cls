/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved.
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger Handler for Opportunity
TES131023: be sure key fields exists on Opp
********************************************************************************/
public with sharing class OpportunityHandler extends TriggerHandlerBase {


    public static boolean disableShiftOpps = false;
    SET<Id> shiftSet = new SET<Id>();  //recordtype devnames


    public override void bulkBefore() {
        System.debug('In OpportunityHandler bulkBefore Method');
        OpportunityCalcCustomProbability.calcCustomProbability(Trigger.new);//Calling calculated custom probability class and passing the trigger instance
        //calcCustomProbability(Trigger.new);
        if (Trigger.isUpdate) {
            shiftSet = getOppsToShift();
        }
        //NHOpportunitiesToPrioritize();
        //NHSetUserHierarchies();//<jj02012016>Added to set User Hierarchy Lookup
    }


    //MR-Doextra 2014/11/11
    //Check to see if opportunity fields for Nutrition and Health TSR priority calculations have changed.
    public override void bulkAfter(){
        //NHOpportunitiesToPrioritizeAfter();
        //NHResetCompetitorSWOT();//<jj02012016>Added to reset Competitor SWOT
    }


    public override void andFinally() {
        if (Trigger.isBefore && Trigger.isUpdate) {
                ShiftOpps(shiftSet);
        }
    }




    public static MAP<id,Opportunity> oldOpps {GET { return (MAP<id,Opportunity>) Trigger.oldMap; } }
    public static MAP<id,Opportunity> newOpps {GET { return (MAP<id,Opportunity>) Trigger.newMap; } }





//  private void calcCustomProbability(LIST<Opportunity> opps) {
    //  OpportunityCalcCustomProbability.calcCustomProbability(opps);
    //}



    //////////////////////////////////////////////////////////////
    // SET<recordType.devName> Get SET of RecordTypes where AutoShift is set


    private SET<string> getAutoShiftRTypes() {
        SET<string> rtn = new SET<string>();  //recordtype devname

        for (string dn : RTSettings.keySet()) {
            RecordTypeSettings__c rts = RTSettings.get(dn);
            if (rts.OppProductScheduler__c!=null && rts.OppProductScheduler__c.contains('trigsdt=y'))
                rtn.add(dn);
        }
        system.debug('autoShiftRTypeIds:'+rtn);
        return rtn;
    }


    public SET<Id> getOppsToShift() {
        //Determine if any of these opps need a shift (scheduleBaseDate__c change and Rtype setting to autoshift)
        SET<string> autoShiftRType = getAutoShiftRTypes();
        SET<id> oppsToShift = new SET<id>();  //OppIds
        if (autoShiftRType.size()>0) {
            for (string dn : autoShiftRType) {
                    for (SObject so : getRecordsByRT(dn).values()) {
                        Opportunity newOpp = (Opportunity) so;
                        Opportunity oldOpp = oldOpps.get(newOpp.Id);
                        if (newOpp.scheduleBaseDate__c!=null && (newOpp.scheduleBaseDate__c!=oldOpp.scheduleBaseDate__c)) {
                            oppsToShift.add(newOpp.id);
                        }
                    }
            }
        }
        system.debug('oppsToShift:'+oppsToShift);
        return oppsToShift;
    }


public static void ShiftOpps(SET<id> oppsToShift) {
        if (oppsToShift.size()>0) {
            MAP<id,LIST<OpportunityLineItem>> lineItems = new MAP<id,LIST<OpportunityLineItem>>();
            for (OpportunityLineItem oli : [
                SELECT Id, Opportunityid,
                    ( select id, ScheduleDate, Revenue, Quantity, Type from opportunitylineitemschedules )
                FROM OpportunityLineItem
                WHERE opportunityid =:oppsToShift
                ORDER BY CreatedDate
            ]) {
                if (!lineItems.containsKey(oli.Opportunityid))
                    lineItems.put(oli.Opportunityid,new LIST<OpportunityLineItem>());
                lineItems.get(oli.Opportunityid).add(oli);

            }


            LIST<OpportunityLineItemSchedule> SchedulesToUpsert = new LIST<OpportunityLineItemSchedule>();
            for (Id oppid : oppsToShift) {
                Opportunity oldOpp=oldOpps.get(oppid);
                Opportunity newOpp=newOpps.get(oppid);
                
                //TES131023: be sure key fields exists on Opp
                if (newOpp.Amount_Type__c!=null && newOpp.Contract_Duration__c!=null && newOpp.scheduleBaseDate__c!=null) {
                    Integer duration = newOpp.Contract_Duration__c.intValue();
                    OppProducts.ScheduleUnit schedUnit = OppProducts.getScheduleUnitFromAmountType(newOpp.Amount_Type__c);
    
                    LIST<Date> origDates = OppProducts.getScheduleDates(oldOpp.scheduleBaseDate__c,duration, schedUnit);
                    LIST<Date> newDates = OppProducts.getScheduleDates(newOpp.scheduleBaseDate__c,duration, schedUnit);
    
    
                    //Loop each LI
                    if (oppId!=null && lineItems.containsKey(oppId))
                            for (OpportunityLineItem oli : lineItems.get(oppId)) {
                                //Get Orig Schedules
                                MAP<string, OppProducts.ScheduleItem> origSchedules = new MAP<string, OppProducts.ScheduleItem>();
                                for (OpportunityLineItemSchedule sched : oli.OpportunityLineItemSchedules ) {
                                    OppProducts.ScheduleItem si= new OppProducts.ScheduleItem(sched);
                                    origSchedules.put(si.indx, si);
                                }
            
                                if (origSchedules.size()>0) {
            
                                    MAP<string, OppProducts.ScheduleItem> newSchedules = new MAP<string, OppProducts.ScheduleItem>();
                                    for (integer i=0;i<origDates.size();i++) {
                                        system.debug('key: '+Util.DatetoXml(origDates[i]));
                                        OppProducts.ScheduleItem si = origSchedules.get(Util.DatetoXml(origDates[i]));
                                        if (si!=null) {
                                            system.debug('oli: '+oli);
                                            system.debug('origSchedules: '+origSchedules);
                                            system.debug('ScheduleItem: '+si);
                                            si.ScheduleDate=newDates[i];
                                            newSchedules.put(si.indx,si);
                                        }
                                    }
            
                                    //add to SchedulesToUpsert
                                    boolean includeZeroValueSchedules=true;
                                    for (OppProducts.ScheduleItem si : newSchedules.values()) {
                                        if (includeZeroValueSchedules || si.item.Revenue!=0) {
                                            if (si.item.Id==null) //System.SObjectException: Field is not writeable: OpportunityLineItemOpportunityLineItemId
                                                si.item.OpportunityLineItemId=oli.id;
                                            SchedulesToUpsert.add(si.item);
                                        }
                                    } //next si
            
                                }
                        } //next oli
                } //valid opp
            } //next oppid
        upsert SchedulesToUpsert;
        }
    }
    
/*    
//N&H Opportunity probability calculation
//N&H Opportunity priority scoring
    private void NHOpportunitiesToPrioritize(){
        map<Id,Id> UserHierarchies = new map<Id,Id>();//<jj02012016> map for User Id to User Hierarchy Id 
        list<opportunity> OppsForPriority = new list<opportunity>();
        list<opportunity> OppsForProbability = new list<opportunity>();
        LIST<SObject> sos = new list<sObject>();//inList;
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Engage').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Value_of_Change').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Analyze_Options').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_How').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Negotiate').values());

        if (sos.size()>0){
            for (SObject so:sos){
                opportunity rNew = (opportunity)so;
                if (trigger.isInsert){
                    OppsForProbability.add(rNew);
                    OppsForPriority.add(rNew);
                    UserHierarchies.put(rNew.OwnerId,null);//<jj02012016> collect OwnerIds
                }else if (trigger.oldMap.containsKey(rNew.Id)){
                    boolean bProbability = false;
                    opportunity rOld = (opportunity)trigger.oldmap.get(rNew.Id);
                    //Conditions for processing:
                    if (rNew.StageName != rOld.StageName ||
                       rNew.probability != rOld.probability ||
                       rNew.Technical_Probability__c != rOld.Technical_Probability__c ||
                       rNew.Buying_Influencer_Commitment__c  != rOld.Buying_Influencer_Commitment__c ||
                        rNew.Customer_Business_Impact__c != rOld.Customer_Business_Impact__c ){
                        OppsForProbability.add(rNew);
                        bProbability=true;
                    }
                    if (rNew.amount!=rOld.amount ||
                       rNew.probability!=rOld.probability ||
                       rNew.primarySegment__c !=rOld.primarySegment__c  ||
                       //rNew.Estimated_Max_Effort_hours__c !=rOld.Estimated_Max_Effort_hours__c ||
                       bProbability){
                        OppsForPriority.add(rNew);
                    }
                }
            }
            if (OppsForProbability.size()>0){
                NH_Segmentation_Helper.OppProbabilityCalculation(OppsForProbability);
            }
            if (OppsForPriority.size()>0){
                list<opportunity> ReqOpp = NH_Segmentation_Helper.OppPrioritizeMultiFromOpp(OppsForPriority);
                if (ReqOpp.size()>0){
                    //From the request before trigger, shouldn't have to dml Requests.
                    system.debug(ReqOpp);
                    //create after process to reconcile request id to results.
                }
            }
        }
    }
*/    

/*
    private void NHOpportunitiesToPrioritizeAfter(){
        System.debug('In OpportunityHandler bulkAfter Method');
        //LIST<SObject> sos = this.getRecordsByRT('NH_Opportunity').values();
        LIST<SObject> sos = new list<sObject>();
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Engage').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Value_of_Change').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Analyze_Options').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_How').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Negotiate').values());


        if (Trigger.isUpdate) {
            SET<Id> OppTSRToPrioritize = new set<Id>();
            if (sos.size()>0){
                for (SObject so:sos){
                    Opportunity oNew = (Opportunity)so;
                    if (trigger.oldMap.containsKey(oNew.Id)){
                        Opportunity oOld = (Opportunity)trigger.oldmap.get(oNew.Id);
                        if (oNew.amount!=oOld.amount ||
                            oNew.probability!=oOld.probability){
                            OppTSRToPrioritize.add(oNew.Id);
                        }
                    }
                }
                if (OppTSRToPrioritize.size()>0){
                    list<Technical_Service_Request__c> OppTSR = NH_Segmentation_Helper.TSRPrioritizeMultiFromOpps(OppTSRToPrioritize);
                    if (OppTSR.size()>0){
                        //From the opportunity after trigger, it's ok to update Requests.
                        system.debug(oppTSR);
                        update OppTSR;
                    }
                }
            }
        
        }
        opportunityPriorityToReconcile(sos);

        
    }
*/
    
/*    
    private void opportunityPriorityToReconcile(list<opportunity>inList){
        list<NH_Segmentation_Result__c> ResultsToUpdate = new list<NH_Segmentation_Result__c>();
        set<Id> requestIds = new set<Id>();

        for (SObject oOpp: trigger.new){
            Opportunity opp = (Opportunity)oOpp;
            Opportunity oOld = null;
            if (!trigger.isInsert){
                oOld = (Opportunity)trigger.oldMap.get(opp.Id);
            }
            system.debug(opp);
            system.debug(oOld);
            if (opp.Id!=null){
                requestIds.add(opp.Id);
            }
            set<Id>ResultsIncluded = new set<Id>();
            if ((trigger.isInsert || (opp.Priority_Result__c != oOld.Priority_Result__c)) 
                && opp.Priority_Result__c!=null && !ResultsIncluded.contains(opp.Priority_result__c)){
                ResultsToUpdate.add(new NH_Segmentation_Result__c(id=opp.Priority_Result__c, opportunity__c=opp.Id));    
                ResultsIncluded.add(opp.Priority_Result__c);    
            }
           
        } 

        if (ResultsToUpdate.size()>0){
             update ResultsToUpdate;
        }

        
    }
*/    

/*    
    //<jj02012016> START OF NEW CODE
    //N&H Assign User Hierarchy Lookup to Opportunity based on OwnerId
    private void NHSetUserHierarchies(){
        set<Id> affectedOpps = new set<Id>();
        map<Id,Id> UserHierarchies = new map<Id,Id>(); 
        LIST<SObject> sos = new list<sObject>();//inList;
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Engage').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Value_of_Change').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Analyze_Options').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_How').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Negotiate').values());
        
        if (sos.size()>0){
            for (SObject so:sos){
                opportunity rNew = (opportunity)so;
                opportunity rOld = new Opportunity();
                if(rNew.Id!=null && trigger.oldMap.containsKey(rNew.Id))
                    rOld = (Opportunity)trigger.oldMap.get(rNew.Id);
                if (trigger.isInsert || (rOld.Id != null && rNew.OwnerId != rOld.OwnerId)){
                    UserHierarchies.put(rNew.OwnerId,null);
                    if(rNew.Id!=null)
                        affectedOpps.add(rNew.Id);
                }
            }
            if (UserHierarchies.size()>0){
                //<cw11072016> changed type to Functional Leader
                for(User_Hierarchy__c uh:[Select Id, User__c from User_Hierarchy__c where User__c IN:UserHierarchies.keySet() and Type__c='Functional Leader' ]){
                //<cw11072016>
                    UserHierarchies.put(uh.User__c,uh.Id);
                } 
            }
            for (SObject so:sos){
                opportunity rNew = (opportunity)so;
                if ((trigger.isInsert || affectedOpps.contains(rNew.Id)) && UserHierarchies.containsKey(rNew.OwnerId))
                    rNew.User_Hierarchy__c = UserHierarchies.get(rNew.OwnerId);
            }
        }
    }
    
*/    
    //N&H Remove SWOT Records of Competitor when Competitor changes on Opportunity
/*    
    private void NHResetCompetitorSWOT(){
        map<Id,map<string,Id>> affectedOpps = new map<Id,map<string,Id>>(); 
        LIST<SObject> sos = new list<sObject>();//inList;
        list<Opportunity_SWOT__c> osToDelete = new list<Opportunity_SWOT__c>();
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Engage').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Value_of_Change').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Analyze_Options').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_How').values());
        sos.addAll(this.getRecordsByRT('NH_Opportunity_Negotiate').values());
        
        if (sos.size()>0 && trigger.isUpdate){
            for (SObject so:sos){
                opportunity rNew = (opportunity)so;
                opportunity rOld = new Opportunity();
                if(rNew.Id!=null && trigger.oldMap.containsKey(rNew.Id))
                    rOld = (Opportunity)trigger.oldMap.get(rNew.Id);
                if (rNew.Competitor__c != rOld.Competitor__c || rNew.Competitor_2__c != rOld.Competitor_2__c){
                    map<string,Id> si = new map<string,Id>();
                    if(rNew.Competitor__c != rOld.Competitor__c && rOld.Competitor__c != null)
                        si.put('1',rOld.Competitor__c);
                    if(rNew.Competitor_2__c != rOld.Competitor_2__c && rOld.Competitor_2__c != null)
                        si.put('2',rOld.Competitor_2__c);
                    affectedOpps.put(rNew.Id,si);
                }
            }
            for(Opportunity_SWOT__c os:[Select Id, Competitor_Id__c,opportunity__c,Type__c from Opportunity_SWOT__c where Type__c Like 'Competitor%' and opportunity__c IN:affectedOpps.keySet()]){
                if(affectedOpps.get(os.Opportunity__c).containsKey(os.Type__c.right(1)) && affectedOpps.get(os.Opportunity__c).get(os.Type__c.right(1))== os.Competitor_Id__c)
                    osToDelete.add(os);
            }
        }
        if(osToDelete.size()>0)
            delete osToDelete;
    }
    */
    //<jj02012016> END OF NEW CODE
}
/**************************************************
Change History: <Ankit20160803 10:00 PM IST> If opportunity is cloned then at before insert setting the isOppCloned variable as true and oppDuration as contract duration as a part of Issue IS ID-00071084
Change History: <Ankit20161103 12:10 IST> Upon cloning the opportunity with Products, the system is throwing NullPointerException on the duration field when the trigger was running for the first time. We have handled this exception as a part of Issue IS ID-00075925
****************************************/

trigger trigOpportunity on Opportunity ( before insert, before update, after update) {
  if(System.Label.Trigger_On_Off  == 'On'){  
    /* Change History: <Ankit20160803 10:00 PM IST> If opportunity is cloned then at before insert setting the isOppCloned variable as true and oppDuration as contract duration as a part of Issue IS ID-00071084 Change Starts */
  if(trigger.isbefore && trigger.isinsert ){
 /*  Change History: <Ankit20161103 12:10 IST> Upon cloning the opportunity with Products, the system is throwing NullPointerException on the duration field when the trigger was running for the first time. We have handled this exception as a part of Issue IS ID-00075925  Code Coverage 100% <Ankit 20161103> */
     if(trigger.new[0].amount_type__c!=null && trigger.new[0].Contract_Duration__c!=null)
     QuantitySchedulingController.isOppCloned=true;
     QuantitySchedulingController.oppDuration=trigger.new[0].Contract_Duration__c;
  }
  // Change ends
  
    OpportunityHandler h = new OpportunityHandler();
    h.onTrigger();
  }
}
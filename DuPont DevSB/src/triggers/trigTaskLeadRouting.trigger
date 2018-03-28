/*
This Rule only applies to TASKS where 'Related To'(WhatId) is a Lead Routing Object.
*/

trigger trigTaskLeadRouting on Task (after insert) {

  private List<Task> LR_createTasks = new List<Task>();
  private Set<Id> leadRoutingIds = new Set<Id>();
  if(System.Label.Trigger_On_Off  == 'On'){  
    for (Task t : Trigger.new ) {
        if(t.WhatId!=null) {
            if(String.valueof(t.WhatId).startsWith('a0Y')) {
                leadRoutingIds.add(t.WhatId);
                LR_createTasks.add(t.clone(false,true));
            }
        }
    }

    if (LR_createTasks.size()>0) {
    
        //get the 'Lead Routing' RecordType Id
        DescribeSObjectResult DSR = Task.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RTI = DSR.getRecordTypeInfosByName();
        Id LEAD_ROUTING_RTYPE = RTI.get('Lead Routing').recordTypeId; //012300000000kI5
    
        //Map<Lead_Routing__c.Id, Lead.Id> get the Lead(s) Id reference in Lead_Routing__c
        Map<Id, Lead_Routing__c> mapLR = new Map<Id, Lead_Routing__c>([
            Select Id, Lead_Name__c from Lead_Routing__c where Id in :leadRoutingIds 
            ]);
    
        //create new Lead Routing Task and associate with lead(s)
        for (Task t : LR_createTasks) {
            String leadid=mapLR.get(t.WhatId).Lead_Name__c;
            system.debug(leadid);
            t.recordTypeId=LEAD_ROUTING_RTYPE;
            t.Whoid=leadid;
            t.Whatid=null;  //SFDC Limitation - a Task with a whoId is as Lead cannot have a WhatId...
        }
        
        //Insert    
        insert LR_createTasks;
    }
  }
}
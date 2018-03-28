trigger trigCallReport on Call_Report__c (before insert, before update, after insert, after update, after delete, after undelete) {
   if(System.Label.Trigger_On_Off  == 'On'){   
       CallReportHandler crh=new CallReportHandler();
       crh.onTrigger(); 
   }
}
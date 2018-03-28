/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Batch Process to do a Daily Load from ERP Customer into Account object. 


********************************************************************************/

global class scheduleCSAccountDailyUpdate implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchCSAccountDailySync dailyBatch = new batchCSAccountDailySync(); 
      database.executebatch(dailyBatch);
   }
}
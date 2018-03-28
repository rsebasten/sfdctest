/*************************************************************************************************
Copyright Â© 2016 DuPont. All rights reserved.
Author: Kokkiripalli Vaishnavi
Email: kokkiripalli.vaishnavi@tcs.com
Description:  Batch Apex for scheduling SFAR Password Reset Class
 ********************************************************************************/
global class scheduleBatchSFARPasswordReset implements Schedulable {
        global void execute(SchedulableContext sc) {
      batchSFARPasswordReset dailyBatch = new batchSFARPasswordReset(); 
      database.executebatch(dailyBatch);
   }  
}
/*************************************************************************************************
Copyright Â© 2017 DuPont. All rights reserved.
Author: Priya Kuntamukkala
Email: kuntamukkala.priya@tcs.com
Description: Test class for scheduling email record refresh bacth class which updates the 
             lead and contact counts on records in the Email (Email__c) object.
==========================================================================================
History
-------
VERSION        AUTHOR                  DATE               DETAIL
1.0            Priya Kuntamukkala      30-Aug-2017        Initial Development
********************************************************************************/
global class SchedBatchEmailRefresh implements Schedulable {
        global void execute(SchedulableContext sc) {
      database.executebatch(new batchEmailRefresh(),200);
   }  
}
/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Arjun Sharma
Email:          arjun.sharma2@tcs.com
Description:    Schedule batch job to create External Initiatve and Lead with batch size 50

***************************************************************************************************/
global class batchCPSFJob implements Schedulable{
    
    public static final Integer batchJobSize = Integer.valueOf(Label.CPSF_Batch_Size);
    
    global void execute(SchedulableContext ctx){
        Id batchJobId = Database.executeBatch(new batchBICPProject(),batchJobSize);
    }
    
}
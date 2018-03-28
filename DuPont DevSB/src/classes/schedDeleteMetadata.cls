/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com

Description:  Schedulable class for DeleteMetadata
********************************************************************************/
global class schedDeleteMetadata implements Schedulable {
    
    string query;
    boolean softDelete;
	global schedDeleteMetadata(){}
    global schedDeleteMetadata(string q){ query=q;}
    global schedDeleteMetadata(string q, boolean softdel){ query=q;softdelete=softdel;}

    
    global void execute(SchedulableContext SC) {
    	
    	if (!utilSchedule.isApexScheduleDisabled)
    		if (softDelete==null)
    			softDelete=false;
    	
        	if (query==null)
        		Database.executeBatch(new batchDeleteMetadata(),200);
        	else
        		Database.executeBatch(new batchDeleteMetadata(query, softDelete),200);
        
        system.abortJob(sc.getTriggerId()); //remove the job once executed (only get 25 of these)
    }   
	
}
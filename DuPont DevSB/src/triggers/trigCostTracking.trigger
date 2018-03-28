/*******************************************************************************
Copyright © 2014 Delaware Digital Design, Inc. All rights reserved. 
Copyright © 2014 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  trigger for CostTracking
********************************************************************************/
trigger trigCostTracking on Cost_Tracking__c (after delete, after insert, after undelete, after update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        CostTrackingHandler h = new CostTrackingHandler();
        h.onTrigger();  
    }
}
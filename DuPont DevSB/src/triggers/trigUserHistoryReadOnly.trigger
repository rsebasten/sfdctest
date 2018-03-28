/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  this trigger is used to disallow modify and delete 
access to the UserHistory__c sobject
********************************************************************************/
trigger trigUserHistoryReadOnly on UserHistory__c (before delete, before update) {
    string CANNOT_MODIFY_USERHISTORY = 'User History cannot be modified or deleted.';
    if(System.Label.Trigger_On_Off  == 'On'){  
        for (UserHistory__c uh : Trigger.new) 
            uh.AddError(CANNOT_MODIFY_USERHISTORY);
    }
}
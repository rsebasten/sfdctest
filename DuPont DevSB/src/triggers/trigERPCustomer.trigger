/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  trigger for ERP_Customer
 ********************************************************************************/
trigger trigERPCustomer on ERP_Customer__c (after insert, after update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        ERPCustomerHandler h = new ERPCustomerHandler();
        h.onTrigger();  
    }
}
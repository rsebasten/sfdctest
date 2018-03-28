/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Core trigger for Contact
********************************************************************************/
trigger trigContact on Contact (after delete, after insert, after undelete, after update, before insert, before update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        ContactHandler h = new ContactHandler();
        h.onTrigger();
    }
}
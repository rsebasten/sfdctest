/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  General trigger for Note
********************************************************************************/
trigger trigNote on Note (after delete, after insert, after undelete) {
    if(System.Label.Trigger_On_Off  == 'On'){  
        NoteHandler h = new NoteHandler();
        h.onTrigger();
    }
}
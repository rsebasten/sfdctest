/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  General Trigger Handler for Solution
********************************************************************************/
trigger trigSolution on Solution (after delete, after insert, after undelete, after update) {
    if(System.Label.Trigger_On_Off  == 'On'){  
        SolutionHandler h = new SolutionHandler();
        h.onTrigger();
    }
}
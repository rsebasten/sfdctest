/*******************************************************************************
Email: Vinayak.Vijayakumar@usa.dupont.com
Date : 22 Jul 2011
Description:  Called from a Trigger trigUpdateTaskId to do the 
update the Task Id when the Task status is marked completed.
Used only for Case Object, BI EMEA Case Record Type and Task - Complaint Record Type
** ============================================================================= 
* Ver   Date        Author                 Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   29-Aug-11   Vinayak VijayaKumar    Initial Code
**************************************************************************************************************/
trigger trigTask on Task (After Insert,before Update,After Update, Before Delete) {
    if(System.Label.Trigger_On_Off  == 'On'){  
        TaskHandler TaskHandlerInstance=new TaskHandler();
        TaskHandlerInstance.onTrigger();
    }
}
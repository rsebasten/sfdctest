/*******************************************************************************
Email: abhinav.bhatnagar@ind.dupont.com
Date : 5 Aug 2016
********************Modification Log****************************************
Last Modified Date: 5 Aug 2016
********************************************************************************
<AB20160805> - 
Last Modified By: Abhinav Bhatnagar
Last Modified Date : 5th August 2016
Description:Added logic to calculate Case Age based on first closed date

*****************************************************************************/
trigger trigCase on Case (before Insert,before Update,after Insert, after update){//<AB20160805>
     if(System.Label.Trigger_On_Off  == 'On'){   
         CaseHandler caseHandlerInstance=new CaseHandler(); 
         caseHandlerInstance.onTrigger();
     }
}
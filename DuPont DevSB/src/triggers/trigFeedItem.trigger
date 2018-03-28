/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Udhuman Gani/Infosys
Email: udhuman.gani@usa.dupont.com
Description:  General handler trigger for Feed Item
********************************************************************************/
trigger trigFeedItem on FeedItem (before Insert){
     if(System.Label.Trigger_On_Off  == 'On'){   
         FeedItemHandler feedItemHandlerInstance=new FeedItemHandler(); 
         feedItemHandlerInstance.onTrigger();
     }
}
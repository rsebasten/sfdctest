/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Description:  General Trigger Handler for FeedComment
********************************************************************************/
trigger trigFeedComment on FeedComment(before insert){
    if(System.Label.Trigger_On_Off  == 'On'){   
        FeedCommentHandler feedCommentObj = new FeedCommentHandler();
        feedCommentObj.onTrigger();
    }
}
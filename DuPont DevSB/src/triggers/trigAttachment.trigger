/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  General controller for Attachment
********************************************************************************/
trigger trigAttachment on Attachment (before insert,after delete, after insert, after undelete) {
  if(System.Label.Trigger_On_Off  == 'On'){   
    AttachmentHandler h = new AttachmentHandler();
    h.onTrigger();
  }
}
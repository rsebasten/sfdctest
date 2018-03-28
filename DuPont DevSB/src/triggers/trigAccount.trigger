/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  General controller for Account see AccountHandler for logic
********************************************************************************/
trigger trigAccount on Account (before insert, before update, after insert, after update) {
  if(System.Label.Trigger_On_Off  == 'On'){   
    AccountHandler h = new AccountHandler();
    h.onTrigger();
  }
}
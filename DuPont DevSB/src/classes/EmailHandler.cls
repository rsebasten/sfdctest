/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Trigger Handler for Email__c 
********************************************************************************/
public class EmailHandler extends TriggerHandlerBase {
	
	public static boolean InProcess = false;   //avoid recursion,  public for UT
	
  public override void bulkafter(){
		if (!this.hasFired) //new sub-batch
			InProcess=false;
		if (!InProcess) {
			InProcess=true;
			EmailBase.email_onAfter();
		}
	}
}
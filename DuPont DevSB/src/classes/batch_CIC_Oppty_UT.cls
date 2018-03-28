/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           17/10/2016
Description:    Test class for batch_CICJob class 

***************************************************************************************************/
@isTest
public class batch_CIC_Oppty_UT
{
	public static testMethod void test_Unitcase1() 
	{
		testUtilityDatabase.createExtInitative(true);
		database.executebatch(new batch_CIC_Oppty());
	}
}
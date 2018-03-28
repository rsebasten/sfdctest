/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           12/28/2018
Description:    Test Class for ctrlCICExpireProject_Parse

***************************************************************************************************/
@isTest
public class ctrlCICExpireProject_Parse_UT 
{
    @isTest static void testCallout() 
    {
        // Creating Mock Callout class to read end point URL
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_CIC());
        testUtilityDatabase.createExtInitative(false);
        testUtilityDatabase.createCustomsett_Data_Expire();
         testUtilityDatabase.createCustomsett_Data_Expire1();
        database.executebatch(new Batch_CIC_ProjectExpire(),50); 
    }
}
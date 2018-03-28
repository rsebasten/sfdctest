/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/10/2016
Description:    Test Class for ctrlCIC_Parse 

***************************************************************************************************/
@isTest
public class ctrlCIC_Parse_UT 
{
    @isTest static void testCallout() 
    {
        // Creating Mock Callout class to read end point URL
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_CIC());
        testUtilityDatabase.createExtInitative(true);
        testUtilityDatabase.createEIforLead(true);
        testUtilityDatabase.createCustomsett_Data();
        testUtilityDatabase.createCustomsett_Data1();
        database.executebatch(new batch_CICJob()); 
    }
}
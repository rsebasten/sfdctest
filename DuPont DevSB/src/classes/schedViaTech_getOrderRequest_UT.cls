/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com

Description:  Test Class for Schedulable class
*********************************************************************************/

@isTest
public class schedViaTech_getOrderRequest_UT {
    
        static testMethod void testSchedule(){
        Test.startTest();
        system.schedule('TestSchedule','0 0 1 * * ?',new schedViaTech_getOrderRequest());
        Test.stopTest();
     }

}
/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Test Class for batchOppSFDCToSFDC batch class
********************************************************************************/
@isTest
public class batchOppSFDCToSFDC_UT {
    static testMethod void createTestData() {
        Test.startTest();
        
        batchOppSFDCToSFDC bosts = new batchOppSFDCToSFDC();
        Database.executeBatch(bosts);
        Test.stopTest();
    }
}
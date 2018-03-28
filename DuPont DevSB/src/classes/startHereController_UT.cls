/*******************************************************************************
Copyright Â© 2012 DuPont. All rights reserved. 
Author: TCS COO 
Description:  Unit testclass for startHereController on 20170124
change log:
    1. <20170124> Merge&Spin: Test class for startHereController class
********************************************************************************/

@isTest
public class startHereController_UT{
public static testmethod void teststartHereController(){
        startHereController testcontroller = new startHereController();
        testcontroller.initPageAction();
        testcontroller.getHTMLHeader();
        testcontroller.getBannerURL();
        testcontroller.getBannerImageURL();
        testcontroller.getMainBody();
        testcontroller.getSideBar();
        testcontroller.getFooter();
        testcontroller.getTracker();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorutil());
        startHereController testcontroller2 = new startHereController();
        testcontroller2.initPageAction();
        testcontroller2.getHTMLHeader();        
    }
}
/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlJQDatePicker
*******************************************************************************/
//[01172017] Merge&Spin; Test class for ctrlJQDatePicker class
@isTest
public class ctrlJQDatePicker_UT {
    public static testMethod void test1(){
        ctrlJQDatePicker ctrl = new ctrlJQDatePicker();
        ctrl.dateDefaultValue = '2015-01-12';
    }
}
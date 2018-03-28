/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlAutoComplete_SObject
//[01232017] Merge&Spin: created test class for ctrlAutoComplete_SObject class.
*******************************************************************************/
@isTest
public class ctrlAutoComplete_SObject_UT {
    public static testMethod void test1(){
        ctrlAutoComplete_SObject.query('Account', 'name != null', 'Phone,ownerId', null);
    }
}
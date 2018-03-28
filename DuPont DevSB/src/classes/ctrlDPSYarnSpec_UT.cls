/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved.
Author: Neha Badala
Email: neha.badala@tcs.com
Description: This test class is for unit testing of ctrlDPSYarnSpecBase controller.
Created Date: 9/27/2016
Version: 1.0
1.1		04-Jan-2017		Krishna Kamineni		User is assigned with system value at line 30
********************************************************************************/

@isTest
private class ctrlDPSYarnSpec_UT
{
static testMethod void createSearchCriteriaTest()
    {


        utilKevlarTestData util = new utilKevlarTestData();        
                
        List<Yarn_Specification__c> yarnspec = util.createYarnSpecification();
        insert yarnspec;
        
        DPSKevlarCustomSetting__c dps = util.createCustomSetting();
        insert dps; 
  
        User u = util.createPortalUser();
        try{
       		insert u;
        }catch(Exception e){
            u=[SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        }
            
        System.runAs(u) {
                      
            test.StartTest();
    
            ctrlDPSYarnSpecBase ctrl = new ctrlDPSYarnSpecBase();
            
            /*Test for app loop strength for Pressure in PSI and Stitch length in Per Inch*/
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'PSI';
            ctrl.sch.KV_Internal_Diameter_mm__c = 5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = 4;
            ctrl.sch.KV_Stitch_Length_Value__c = 5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'Per Inch';
            ctrl.sch.KV_Knitting_Angle__c = 75;
                    
            ctrl.displayResult();
            System.assertEquals(5.08,ctrl.INCHSTITCHVALUE);
            System.assertEquals(0.344737864,ctrl.INCHOPERATINGPRESSURE);
            
            System.assertEquals(50,ctrl.lswrap.size());                 
                    
            System.assertEquals(4.71,ctrl.appLoopStrength.setScale(2));                        
    
            /*Test for app loop strength for Pressure in Bar and Stitch length in mm*/
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'Bar';
            ctrl.sch.KV_Internal_Diameter_mm__c = 5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = 4;
            ctrl.sch.KV_Stitch_Length_Value__c = 5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'mm';
            ctrl.sch.KV_Knitting_Angle__c = 75;
            
            ctrl.displayResult();
            
            System.assertEquals(67.30,ctrl.appLoopStrength.setScale(2));              
    
            /*Test for mandatory field*/
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'Bar';
            ctrl.sch.KV_Internal_Diameter_mm__c = 5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = 4;
            ctrl.sch.KV_Stitch_Length_Value__c = 5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'mm';
    
            ctrl.displayResult();
                           
            System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));        
            
            /*Test for Knitting angle range*/            
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'Bar';
            ctrl.sch.KV_Internal_Diameter_mm__c = 5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = 4;
            ctrl.sch.KV_Stitch_Length_Value__c = 5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'mm';
            ctrl.sch.KV_Knitting_Angle__c = 65;
    
            ctrl.displayResult();
                                  
            System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));                 
            
            /*Test for Innerwall Thickness range*/            
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'Bar';
            ctrl.sch.KV_Internal_Diameter_mm__c = 5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = 5;
            ctrl.sch.KV_Stitch_Length_Value__c = 5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'mm';
            ctrl.sch.KV_Knitting_Angle__c = 75;
    
            ctrl.displayResult();
                                  
            System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
                
            /*Test for negative values*/
            ctrl.sch.KV_OEM_Platform__c = 'Test Platform';
            ctrl.sch.KV_OEM_Country__c = 'India';
            ctrl.sch.KV_OEM__c = 'Test OEM';
            ctrl.sch.KV_Comments__c = 'Test Comment';
            ctrl.sch.KV_Operating_Temperature__c = '200';
            ctrl.sch.KV_Operating_Pressure_Value__c = 5;
            ctrl.sch.KV_Operating_Pressure_Unit__c = 'Bar';
            ctrl.sch.KV_Internal_Diameter_mm__c = -5;
            ctrl.sch.KV_Inner_Wall_Thickness_mm__c = -5;
            ctrl.sch.KV_Stitch_Length_Value__c = -5;
            ctrl.sch.KV_Stitch_Length_Unit__c = 'mm';
            ctrl.sch.KV_Knitting_Angle__c = 65;
    
            ctrl.displayResult();
                                  
            System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR)); 
                                    
            test.StopTest();
        }
    }   
}
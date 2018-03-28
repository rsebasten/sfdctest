/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlGenerateExceptions
*******************************************************************************/
//[01172017] Merge&Spin: Test class for ctrlGenerateExceptions class.
@isTest
public class ctrlGenerateExceptions_UT {
    public static testMethod void testGenerateExceptions(){
        PageReference pg = new PageReference('/apex/GenerateExceptions');
        test.setCurrentPage(pg);
        ctrlGenerateExceptions ctrl = new ctrlGenerateExceptions();
        List<SelectOption> optionList = ctrl.getItems();
        try{
	        ctrl.selectedValue = 'NPE';
        	ctrl.throwException();            
        }
        catch(Exception e){
            system.assertEquals(e.getMessage(),'Attempt to de-reference a null object');
        }
        
        try{
            ctrl.selectedValue = 'AE';
            ctrl.throwException();            
        }
        catch(Exception e){
            system.assertEquals(e.getMessage(),'Divide by 0');
        }
        
        try{
            ctrl.selectedValue = 'IOOB';
            ctrl.throwException();            
        }
        catch(Exception e){
            system.assertEquals(e.getMessage(),'List index out of bounds: 1');
        }              
    }
}
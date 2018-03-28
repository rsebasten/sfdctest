/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved.
Author: Abhinav Bhatnagar 
Email:abhinav.bhatnagar@dupont.com
Description:  This is controller class for emailApexInbound functionality and generateException VisualForce Page
********************************************************************************/
public with sharing class ctrlGenerateExceptions{
        public void throwException(){
            String strExceptionType =selectedValue;
            System.debug('In exception controller class, exception type is: ' + strExceptionType);
            if(strExceptionType=='NPE')
                throwNullPointerException();
            if(strExceptionType=='IOOB')
                throwIndexOutOfBoundException();
            if(strExceptionType=='AE')
                throwArithmeticException();
        }

        public void throwNullPointerException(){
            String strNull = null;
            integer i = strNull.length();
                            }
        
        
        public void throwArithmeticException(){
            integer i = 1/0;        
        }
        
        public void throwIndexOutOfBoundException(){
            List<Integer> li = new List<Integer>();
            Integer OutOfBound = li[1];
        }

        public string selectedValue{get;set;}
 
         public ctrlGenerateExceptions()
         {
             selectedValue='NPE';
         }
         
        public List<SelectOption> getItems()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--Select--','--Select--'));
            options.add(new SelectOption('NPE','Null Pointer Exception'));
            options.add(new SelectOption('IOOB','Index Out Of Bound'));
            options.add(new SelectOption('AE','Arithmetic Exception'));
            return options;
         }

}
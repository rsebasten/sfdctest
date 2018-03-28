/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Nishanth H
Email: nishanth_h@infosys.com
Description: Test class for MultiselectController
********************************************************************************/ 

@isTest

public class MultiselectController_UT{

  static testMethod void MultiselectTest() {
  test.StartTest();
  
  List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('CANADA','Canada'));
        options.add(new SelectOption('MEXICO','Mexico'));
        
      
  
  MultiselectController con=new MultiselectController();

    con.leftOptions1 = new List<SelectOption>();
    con.leftOptions1.add(new SelectOption('US','US'));
    con.leftOptions1.add(new SelectOption('CANADA','Canada'));
    con.leftOptionsHidden ='tttt';
    
    con.rightOptions1= new List<SelectOption>();
    con.rightOptions1.add(new SelectOption('US','US'));
    con.rightOptions1.add(new SelectOption('CANADA','Canada'));
    con.rightOptionsHidden ='yyy&xxx&rrr&wwwww';


  test.StopTest();
 }
}
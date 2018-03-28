/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           11/10/2016
Description:    Test class for batch_CICJob class 

***************************************************************************************************/
@isTest
public class batch_CICJob_UT 
{
  public static testMethod void test_Unitcase1() 
      {
          try{
              test.startTest();         
              testUtilityDatabase.createExtInitative(true);
              testUtilityDatabase.createEIforLead(true);
              batch_CICJob cicbatch = new batch_CICJob();
              testUtilityDatabase.createCustomsett_Data();
              testUtilityDatabase.createCustomsett_Data1();
              //Krish: added a call to execute batch and commented out scheduling calls.
              Id batchJobId = Database.executeBatch(cicbatch, 200);
              //String schedule = '00 08 19 19 1 ? 2019';          
              //String jobID = system.schedule('cicbatchjob',schedule,cicbatch);              
              test.stopTest();
          }catch(Exception e){
              System.debug('Exception:'+e.getStackTraceString());
          }
    }   
 }
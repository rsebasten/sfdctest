/******************************************************************************* 
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Batch Class for filling first close age on cases which are closed.
This should be a one time activity.
********************************************************************************/
global class batchCSFillFCA implements Database.Batchable<sObject> {
    
    private static final String EXCEPTIONOCCURED = 'Exception Occured =====>>>>>>\n';
    private static  final Id CS_ORDER_RTYPE=Rtype.getIdByDevName('Case','CS_Order');
    private static  final Id CS_SERVICEREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_ServiceRequest');
    private static  final Id CS_INTERNALREQUEST_RTYPE=Rtype.getIdByDevName('Case','CS_InternalRequest');
    private static List<Case> testcases = null;
    private static List<Id> testcasesids = new List<Id>();
    
    public batchCSFillFCA(){        
        
    }
    public batchCSFillFCA(List<case> cs){
        testcases = cs;   
        for(Case c:testcases){
            testcasesids.add(c.id);
        }
        
    }
    //Vaishnavi14112016//
    global Database.QueryLocator start(Database.BatchableContext BC) {            
            if(Test.isRunningTest()){
                 return Database.getQueryLocator([SELECT IsClosed,first_close_age__c,ClosedDate,Id,fCaseAge__c FROM Case WHERE  
                                                 First_Close_Age__c=null AND (RecordTypeId =:CS_ORDER_RTYPE OR RecordTypeId =:CS_INTERNALREQUEST_RTYPE OR RecordTypeId =:CS_SERVICEREQUEST_RTYPE)  
                                                  AND id in : testcasesids]);
             
            }else{return Database.getQueryLocator([SELECT IsClosed,first_close_age__c,ClosedDate,Id,fCaseAge__c FROM Case WHERE  IsClosed = true AND 
                                                 First_Close_Age__c=null AND (RecordTypeId =:CS_ORDER_RTYPE OR RecordTypeId =:CS_INTERNALREQUEST_RTYPE OR RecordTypeId =:CS_SERVICEREQUEST_RTYPE)]);        
            }
    }//Vaishnavi14112016//
    
    global void execute(Database.BatchableContext BC, List<Case> cases) {
        try{
            updateFirstCloseAge(cases);
            system.debug('##################D'+cases); 
           }catch(Exception e){              
               system.debug(EXCEPTIONOCCURED+' During Execution'+e.getStackTraceString());            
           }
    }   
    
    global void finish(Database.BatchableContext BC) {
            System.debug('Batch Finished');            
    }
    
    
    public static void updateFirstCloseAge(List<Case> cases){      
        List<Case> updatedCases = new List<Case>();        
        
        for(Case c: cases){
            c.First_Close_Age__c = c.fCaseAge__c;
             system.debug('Debuglohg During Execution'+c.First_Close_Age__c);   
            
            updatedCases.add(c);                
        }        
        upsert updatedCases;
    }
    
}
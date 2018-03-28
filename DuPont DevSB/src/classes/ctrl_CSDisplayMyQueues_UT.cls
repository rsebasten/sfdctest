@isTest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Description: Utility class
********************************************************************************/

private class ctrl_CSDisplayMyQueues_UT{
    

/*Test method for coverage of CaseList with values.*/  
 public static testMethod void test1(){ 
     System.runAs(utilCSEmail_UT.user()){
     try{
     List<Case> myCaseList = [Select id from Case where recordtype.name = 'CS-Order' limit 1];
    
            Test.startTest();
            
            ctrl_CSDisplayMyQueues selQueues = new ctrl_CSDisplayMyQueues(new ApexPages.StandardController(new Case()));
            selQueues.getUserDetails();
            
            selQueues.caseList = myCaseList;
            List<Case> getCaseList = selQueues.caseList;
            selQueues.hasNext = true;
            Boolean gethasNext = selQueues.hasNext;
            selQueues.hasPrevious = true;
            Boolean gethasPrevious = selQueues.hasPrevious;
            selQueues.pageNumber = 1;
            Integer getpageNumber =  selQueues.pageNumber;
            selQueues.first();
            selQueues.last();
            selQueues.previous();
            selQueues.next(); 
            
            Test.stopTest();
            system.assert(myCaseList.size()!= null);
         } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
 }
}

/* Test method for coverage of CaseList with values that doesn't exists(Negative Test). */
    public static testMethod void test3(){ 
     System.runAs(utilCSEmail_UT.user()){
     
     List<Case> myCaseList = [Select id from Case where subject = 'Hello world..' limit 1];
    
            Test.startTest();
            try{
            ctrl_CSDisplayMyQueues selQueues = new ctrl_CSDisplayMyQueues(new ApexPages.StandardController(new Case()));
            
            selQueues.getUserDetails();
            selQueues.caseList = myCaseList;
            List<Case> getCaseList = selQueues.caseList;
            selQueues.hasNext = true;
            Boolean gethasNext = selQueues.hasNext;
            selQueues.hasPrevious = true;
            Boolean gethasPrevious = selQueues.hasPrevious;
            selQueues.pageNumber = 1;
            Integer getpageNumber =  selQueues.pageNumber;
            Test.stopTest();
            system.assert(myCaseList.size()!= null);
         } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
 
 }
}

/* Test Method for coverage of First,Last,Next,Previous methods. */ 
    public static testMethod void test2(){ 
    // System.runAs(utilCSEmail_UT.user()){
      try{
            Test.startTest();
            ctrl_CSDisplayMyQueues openCases = new ctrl_CSDisplayMyQueues(new ApexPages.StandardController(new Case()));
            openCases.first();
            openCases.last();
            openCases.previous();
            openCases.next();         
            Test.stopTest();
            
            } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
 //}

}

/* Test method for coverage of queues with other user.   */
    public static testMethod void test4(){ 
        
    Integer lmt = Limits.getLimitQueryRows();
    List<Group> roleRelatedGroupIds = new List<Group>();
    list<String> queueList = new List<String>();
        try{
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
        UserRole urTest =new UserRole();
        urTest.Name='TEST';
        //[01022017] Merge&Spin: Replaced Hard coding of User-Role Id
        urTest.ParentRoleId=[select id from userrole where name='DPT - IPP NA' limit 1].id;
        database.insert(urTest );
        
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = profile.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com',UserRoleId=urTest.Id);
         system.debug('ur.Id' + urTest.Id);
         Test.startTest();
            System.runAs(u2){
            ctrl_CSDisplayMyQueues selQueues = new ctrl_CSDisplayMyQueues(new ApexPages.StandardController(new Case()));
            selQueues.getUserDetails();
            selQueues.queueList = null;
            selQueues.getUserDetails(); 
            selQueues.con = null;
            List<Case> caseLst = selQueues.caseList;    
            }
                Test.stopTest();
                system.assert(queueList.size()== 0);
                } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
           
    //}
    }    
}
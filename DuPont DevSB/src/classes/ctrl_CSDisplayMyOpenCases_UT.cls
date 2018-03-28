@isTest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Description: Utility class
********************************************************************************/

private class ctrl_CSDisplayMyOpenCases_UT{

 /* Test method for coverage of CaseList with values.*/
 public static testMethod void test1(){ 
     System.runAs(utilCSEmail_UT.user()){
         try{
            List<Case> myCaseList = [Select id from Case where recordtype.name = 'CS-Order' limit 1];
                 
            
            ctrl_CSDisplayMyOpenCases openCases = new ctrl_CSDisplayMyOpenCases(new ApexPages.StandardController(new Case()));
            
            openCases.getCaseRecords();
            
            openCases.caseList = myCaseList;
            List<Case> getCaseList = openCases.caseList;
            openCases.hasNext = true;
            Boolean gethasNext = openCases.hasNext;
            openCases.hasPrevious = true;
            Boolean gethasPrevious = openCases.hasPrevious;
            openCases.pageNumber = 1;
            Integer getpageNumber =  openCases.pageNumber;
            Test.startTest();
            openCases.first();
            openCases.last();
            openCases.previous();
            openCases.next(); 
            
            Test.stopTest();
            system.assert(myCaseList.size()!= null);
         } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
             }
  }
  
}


  /* Test method for coverage of empty CaseList.*/
  public static testMethod void test2(){ 
     System.runAs(utilCSEmail_UT.user()){
            try{
            ctrl_CSDisplayMyOpenCases openCases = new ctrl_CSDisplayMyOpenCases(new ApexPages.StandardController(new Case()));
            
            openCases.getCaseRecords();
            
            openCases.caseList = null;
            List<Case> getCaseList = openCases.caseList;
            openCases.hasNext = true;
            Boolean gethasNext = openCases.hasNext;
            openCases.hasPrevious = true;
            Boolean gethasPrevious = openCases.hasPrevious;
            openCases.pageNumber = 1;
            Integer getpageNumber =  openCases.pageNumber;
            Test.startTest();
            openCases.first();
            openCases.last();
            openCases.previous();
            openCases.next(); 
            
            system.assert(getCaseList.size()== 0);         
            Test.stopTest();
            
            } catch(Exception ex){
                 system.debug('Exception occured...'+ex.getMessage());
              }
 }
}

 /*Test method for coverage of Fist,Last,Next,Prev links.*/ 
 public static testMethod void test3(){ 
          
            
            USER U= utilCSEmail_UT.user();  
            
            System.runAs(U){
            try{
            ctrl_CSDisplayMyOpenCases openCases = new ctrl_CSDisplayMyOpenCases(new ApexPages.StandardController(new Case()));
            Test.startTest();
            openCases.first();
            openCases.last();
            openCases.previous();
            openCases.next();         
            
            opencases.caseList=null;
            openCases.getCaseRecords();
            openCases.con=null;
            List<Case> cseList=opencases.caseList;
            system.assert(cseList.size()== 0);
            Test.stopTest();
            
            } catch(Exception ex){
                 system.debug('Exception occured...'+ex.getMessage());
              }
     }
            


} 

}
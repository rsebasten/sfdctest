/*******************************************************************************
Copyright ? 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Home Page component to display all the  Open cases for logged-in user.

//  <ShashankB20150908> Queried Parent Case from Case Object
********************************************************************************/
public with sharing class ctrl_CSDisplayMyOpenCases{

//Instantiate the StandardSetController   
public ApexPages.StandardSetController con{get; set;}
public static final String CASE_STATUS_1 = 'Closed';
public static final String CASE_STATUS_2 = 'Cancelled';
public static final String CASE_STATUS_3 = 'Closed-Unresolved';
private Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

/* Constructor of the class */
public ctrl_CSDisplayMyOpenCases(ApexPages.StandardController controller){

}

/*Description: Get the open cases for logged-in user. */
public void getCaseRecords(){      
    try{   
        Integer lmt = Limits.getLimitQueryRows();
       //  <ShashankB20150908> Queried Parent Case from Case Object
        con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Owner.Name,Case.ParentId, Account.Name,CaseCategory__c, Account.ERP_Account_Code__c,
                                                                                   Origin, Owner.id, Reason, Case.CreatedDate, CaseNumber, 
                                                                                   Subject,Status,  ClosedDate, Priority,fCaseAge__c 
                                                                            from Case 
                                                                            where ownerId =:UserInfo.getUserId() and  
                                                                                  Status NOT IN (:CASE_STATUS_1, :CASE_STATUS_2, :CASE_STATUS_3) 
                                                                            Order By priority DESC, fCaseAge__c DESC limit :lmt]));   
        
        // sets the number of records in each page set
        if(!con.getRecords().isEmpty())
            con.setPageSize(10);   
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, Label.CS_CaseErrorMessage));
            result.success = true;
        }
    }catch(Exception e){
        result.success = true;
        result.message = Label.CS_ErrorMessage;
    }
    
}

 public List<Case> caseList   
    {   
        get   
        {   
            if(con != null){   
                return (List<Case>)con.getRecords();
            }
            else{  
                return null ;   
            }
        }   
        set;}  
// indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    /* returns the first page of records */
     public void first() {
       try{
         con.first();
         result.success = true;
         }catch(Exception e){
             result.success = true;
             result.message = Label.CS_ErrorMessage;
            }
     }

     /* returns the last page of records */
     public void last() {
       try{
         con.last();
         result.success = true;
         }catch(Exception e){
             result.success = true;
             result.message = Label.CS_ErrorMessage;
            }
         
     }

     /* returns the previous page of records */
     public void previous() {
         try{
         con.previous();
         result.success = true;
         }catch(Exception e){
             result.success = true;
             result.message = Label.CS_ErrorMessage;
             }
     }

     /* returns the next page of records */
     public void next() {
         try{
         con.next();
         result.success = true;
         }catch(Exception e){
             result.success = true;
             result.message = Label.CS_ErrorMessage;
             
         }
     }



}
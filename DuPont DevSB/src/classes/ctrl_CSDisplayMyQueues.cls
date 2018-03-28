/*******************************************************************************
Copyright ? 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: Home Page component to display cases from the queues for which logged-in user is part of. 


********************************************************************************/
public with sharing class ctrl_CSDisplayMyQueues{

public ApexPages.StandardSetController con{get; set;}   
public List<String> queueList{get; set;}
public static final String CASE_STATUS_1 = 'Close';
public static final String CASE_STATUS_2 = 'Cancelled';
public static final String CASE_STATUS_3 = 'Closed-Unresolved';
public static final String ROLE_TYPE_1 = 'Role';
public static final String ROLE_TYPE_2 = 'Regular';
private Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

/* Constructor of the class */
public ctrl_CSDisplayMyQueues(ApexPages.StandardController controller) {
     queueList = new List<String>();
    }

/*Description: To get the details of group,queue this logged-in user belong to. */
public void getUserDetails(){

Integer lmt = Limits.getLimitQueryRows();
List<Group> roleRelatedGroupIds = new List<Group>();
List<Group> groupList = [SELECT id, RelatedId, Type 
                         FROM Group 
                         where RelatedId= :UserInfo.getUserRoleId() 
                         limit :lmt];
roleRelatedGroupIds.addAll(groupList);

List<String> allGroupIDs = new List<String>();
try{
for (GroupMember gm : [SELECT Id, group.id, group.name, group.type 
                       FROM GroupMember 
                       where (UserOrGroupId = :UserInfo.getUserId() AND group.type=:ROLE_TYPE_1) OR 
                             (UserOrGroupId IN :roleRelatedGroupIds AND group.type=:ROLE_TYPE_2) 
                       limit :lmt]){
    allGroupIDs.add(gm.group.id);

}


for (GroupMember gm : [SELECT Id, group.id, group.name, group.type 
                       FROM GroupMember 
                       where (UserOrGroupId =:allGroupIDs) 
                       limit :lmt]){
            queueList.add(gm.group.id);
            } 
            

if(!queueList.isEmpty()){
        
          
        
        con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id,Priority, Account.Name,CaseCategory__c, 
                                                                                   Account.ERP_Account_Code__c,Origin, Reason, 
                                                                                   Case.CreatedDate, CaseNumber, 
                                                                                   Subject, Status, ClosedDate,Owner.Name, 
                                                                                   fCaseAge__c,fCaseAgeSymbol__c 
                                                                            from Case 
                                                                            where OwnerId IN :queueList and 
                                                                                  Status NOT IN(:CASE_STATUS_1, :CASE_STATUS_2, :CASE_STATUS_3)
                                                                            Order By fCaseAge__c DESC, Priority ASC limit :lmt]));
         if(con.getRecords().isEmpty()){
            con = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, Label.CS_CaseErrorMessage));
         }
         else
         // sets the number of records in each page set   
        con.setPageSize(10);
        }
        else{
        con = null;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, Label.CS_CaseErrorMessage));
        }
          result.success = true;
        
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
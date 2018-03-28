/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Niha Saha
Email: niha.saha@tcs.com
Description:  This class handles trigger logic of Issue object
NS20160303 - For Duration of Each Status In Hours of Issue Object 
change log:
    1. RS03132016: Added methods issuesAutoAssign, findAssocaiteBasedOnShifts, AssignToDefaults and call issueAutoAssign method from beforeUpdate method.
                   Added functionality to auto assign issues to different associates ( Based on their skills in Resource detail object).   
@2016
Added afterUpdate methos if TAT more than 40 hours capture the reject comments and update it in Resolution field

RS20170308 - Removed issue auto assignment related code from class as part of issue simplification 


********************************************************************************/



global class IssueTriggerHandler2 extends TriggerHandlerBase{
    Public static Final String NOT_STARTED_TIME='TotalNoOfHoursNotStarted__c';
    Public static Final String ACCEPTED_TIME='TotalNoOFAcceptedHours__c';
    Public static Final String IN_PROGRESS_TIME='TotalNoOfHoursInProgress__c';
    //Public static Final String DUPONT_REVIEW_TIME='DuPont_Review_Time_Hours__c';
    Public static Final String ON_HOLD_TIME='TotalNoOfOnHoldHours__c';
    Public static Final String WAITING_TIME='TotalNoOfHoursWaiting__c';
    Public static Final String COMPLETED_TIME='TotalIssueCompleteHours__c';
    Public static Final String ESCALATED_TIME='TotalNoOfEscalatedHours__c';
    Public static Final String APPROVED_BY_REVIEW_TEAM_TIME='TotalApprovedByReveiwTeamHours__c';
    public static Map<String, String> deafultOwnersMap=new Map<String, String>();
       
    //before Insert logic of Issue object
    Public static void beforeInsert(List<Issue__c> lstNewIssues){
       for(Issue__c curIssue: lstNewIssues){
            curIssue.lastTimeStatusChanged__c=System.Now();
       }     
    }
    Public static void beforeUpdate(List<Issue__c> newLst, Map<Id, Issue__c> oldMap){
        CalculateTimeForDifferentStatus(newLst,oldMap);
       }

    public static void  CalculateTimeForDifferentStatus(List<Issue__c> newLst, Map<Id, Issue__c> oldMap){
        Set<string> useraliasSet = new Set<String>();
        List<User> userList  = [Select id, Alias FROM User WHERE id =:userinfo.getUserId() AND alias='TCS COO'];
        for(User us: userList){
           //Save the record
           useraliasSet.add(us.alias); 
        }
       for(Issue__c curIssue: newLst){
           if(curIssue.status__c!=null && oldMap.get(curIssue.id).status__c!=null && curIssue.status__c!= oldMap.get(curIssue.id).status__c){
               if(useraliasSet.contains('TCS COO') && oldMap.get(curIssue.id).status__c=='Not STarted' && (curIssue.status__c == 'Approved by Review Team'|| curIssue.status__c == 'In Progress'|| curIssue.status__c == 'Waiting' || curIssue.status__c == 'Completed')){
                   curIssue.adderror('Please Change the Status From Not Started to Accepted');
               }
               
               if(useraliasSet.contains('TCS COO') && (oldMap.get(curIssue.id).status__c=='Not STarted'|| oldMap.get(curIssue.id).status__c=='Accepted'|| oldMap.get(curIssue.id).status__c== 'In Progress' || oldMap.get(curIssue.id).status__c== 'Waiting') && (curIssue.status__c == 'Approved by Review Team')){
                   curIssue.adderror('Please Change the Status From Escalated to Approved by Review Team');
               }
               if(useraliasSet.contains('TCS COO') && oldMap.get(curIssue.id).status__c=='Accepted' && (curIssue.status__c == 'Waiting'|| curIssue.status__c == 'Completed') ){
                   curIssue.adderror('Please Change the Status From Accepted to In Progress ');
               }
               if(useraliasSet.contains('TCS COO') && oldMap.get(curIssue.id).status__c=='Accepted' && curIssue.status__c == 'Not STarted'){
                   curIssue.adderror('Please Do not Change the Status From Accepted to Not Started ');
               }
               if(useraliasSet.contains('TCS COO') && oldMap.get(curIssue.id).status__c=='Escalated' && (curIssue.status__c == 'Waiting' || curIssue.status__c == 'In Progress')){
                   curIssue.adderror('Please Do not Change the Status From Escalated to In Progress/Waiting,change to Approved By Review Team');
               }
               if(useraliasSet.contains('TCS COO') && oldMap.get(curIssue.id).status__c=='Completed' && (curIssue.status__c == 'Escalated' || curIssue.status__c == 'On Hold'||curIssue.status__c == 'Not Started' || curIssue.status__c == 'Accepted')){
                   curIssue.adderror('Please Do not Change the Status From Completed to Not STarted,Waiting,should be "In Progress/Waiting"');
               }
               if(curIssue.lastTimeStatusChanged__c!=null){
                   Double timeInHours=(System.Now().getTime()-curIssue.lastTimeStatusChanged__c.getTime())/1000;
                   timeInHours=timeInHours/3600;
                  Integer noOfdays=(Integer)timeInHours/24;
                  Integer noOfHoursInADay=math.mod((Integer)timeInHours, 24);
                   timeInHours=noOfdays*9+noOfHoursInADay;
                       //+ (noOfHoursInADay > 15 ? noOfHoursInADay-15 :(noOfHoursInADay > 9 ? 9  :noOfHoursInADay ));
                   
                   
                   if(oldMap.get(curIssue.id).status__c=='Not Started' ){
                       if(curIssue.get(NOT_STARTED_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(NOT_STARTED_TIME));
                       curIssue.put(NOT_STARTED_TIME,timeInHours);
                   }else if (oldMap.get(curIssue.id).status__c=='Accepted' ){
                         if(curIssue.get(ACCEPTED_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(ACCEPTED_TIME));
                        curIssue.put(ACCEPTED_TIME, timeInHours);
                   }else if(oldMap.get(curIssue.id).status__c=='In Progress' ){
                        if(curIssue.get(IN_PROGRESS_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(IN_PROGRESS_TIME));
                       curIssue.put(IN_PROGRESS_TIME, timeInHours);
                   }else if(oldMap.get(curIssue.id).status__c=='On Hold' ){
                        if(curIssue.get(ON_HOLD_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(ON_HOLD_TIME));
                       curIssue.put(ON_HOLD_TIME, timeInHours);
                   }else if (oldMap.get(curIssue.id).status__c=='Completed' || oldMap.get(curIssue.id).status__c =='Not Applicable/System Hard Closed' ){
                        if(curIssue.get(COMPLETED_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(COMPLETED_TIME));
                        curIssue.put(COMPLETED_TIME, timeInHours);
                   }else if(oldMap.get(curIssue.id).status__c=='Escalated' ){
                        if(curIssue.get(ESCALATED_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(ESCALATED_TIME));
                       curIssue.put(ESCALATED_TIME, timeInHours);
                   } else if(oldMap.get(curIssue.id).status__c=='Approved by Review Team'){
                        if(curIssue.get(APPROVED_BY_REVIEW_TEAM_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(APPROVED_BY_REVIEW_TEAM_TIME));
                       curIssue.put(APPROVED_BY_REVIEW_TEAM_TIME, timeInHours);
                   }else if (oldMap.get(curIssue.id).status__c=='Waiting' ){
                        if(curIssue.get(WAITING_TIME)!=null)
                           timeInHours=timeInHours+ Double.valueOf(curIssue.get(WAITING_TIME));
                        curIssue.put(WAITING_TIME, timeInHours);
                   }
               }
               curIssue.lastTimeStatusChanged__c=System.Now();
               }      
       }
       
    }
}
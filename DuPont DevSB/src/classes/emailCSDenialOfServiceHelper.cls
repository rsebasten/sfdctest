/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Prerna Chandak
Email: prerna.chandak@accenture.com
Description: This class will be used to check daily Customer Service cases limits 
* AA 09042015 -- Added email changes for Internal Request Case Limits.. 
* AA 09042015 -- Added Function for Internal Request Case Limits..
* KV04202016-- Changed code to remove the Team Lead India from the code that sends a notification when the email limit is maxed out for a customer
              
********************************************************************************/
public with sharing class emailCSDenialOfServiceHelper{
    private static Final String TEMPLATE_NAME = 'Over Limit Notification';
    private static Final String PUBLIC_GRP_LEAD = '%TeamLeadIndia%';
    private static Final String PUBLIC_GRP_KEYUSER = '%KeyUserSupport%';
    private static Final string EMAIL_LIMITS = 'Limits';
    private static Final string SUCCESS = 'success';
    private static Final string LIMIT_EXCEED = 'limitExceed';
    private static Final string SUCCESS_EMAIL = 'success with email';
  
    /*Description : This method will get the count of assigned cases and if count is under daily limits it will 
                    return string as "Success" else "limitExceed".
    */
    public static string getAssignedCaseDayLimit(string accountId){
        List<case> assignedCaseList = new List<case> ();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        String assignedLimit;
        Integer lmt = Limits.getLimitQueryRows(); 
        string resultValue;
        CS_Email_Limits__c assignedLimitvalue;
        
        try{
            if(CS_Email_Limits__c.getInstance() != null){
                assignedLimitvalue = CS_Email_Limits__c.getValues(EMAIL_LIMITS);
                assignedLimit = assignedLimitvalue.Cases_Per_Account_Per_Day__c;
            }
            assignedCaseList = [Select id from case where AccountId=:accountId and CreatedDate = TODAY limit :lmt ];
            

             if(assignedCaseList != null && assignedCaseList.size() == Integer.valueOf(assignedLimit)-1 ){
                resultValue=SUCCESS_EMAIL;
                
            }
            else if(assignedCaseList != null && assignedCaseList.size() < Integer.valueOf(assignedLimit ) ){
                resultValue=SUCCESS;
            }
            else{
                resultValue=LIMIT_EXCEED;
            }
        }
        catch(Exception e){
            system.debug(Label.CS_ErrorMessage+e.getMessage());
        }
        return resultValue;
    }
    /*Description : This method will get the count of Unassigned cases and if count is under daily limits it will 
                    return string as "Success" else "limitExceed".
    */
    public static string getUnAssignedCaseDayLimit(){
        List<case> assignedCaseList = new List<case> ();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        CS_Email_Limits__c unAssignedLimitvalue;
        String unassignedLimit; 
        string resultValue;        
        List<case> unassignedCaseList = new List<case> ();
        Integer lmt = Limits.getLimitQueryRows();
        try{
            unassignedCaseList = [Select id from Case where AccountId = null and CreatedDate = TODAY limit :lmt];
            if(CS_Email_Limits__c.getInstance() != null){
                unAssignedLimitvalue= CS_Email_Limits__c.getValues(EMAIL_LIMITS);
                unassignedLimit =  unAssignedLimitvalue.Unassigned_Cases_Per_Day__c;
            }
            
            if(unassignedCaseList != null && unassignedCaseList.size() == Integer.valueOf(unassignedLimit)-1 ){
                resultValue=SUCCESS_EMAIL;
                
            }
            else if(unassignedCaseList != null && unassignedCaseList.size() < Integer.valueOf(unassignedLimit)){
                resultValue=SUCCESS;
            }
            else
            {
                resultValue=LIMIT_EXCEED;
            }
        }
        catch(Exception e){
            system.debug(Label.CS_ErrorMessage+e.getMessage());
        }
        return resultValue;
    }

    /* Description : This method will get the count of Internal request cases and if count is under daily limits it will 
                    return string as "Success" else "limitExceed".
    AA 09042015 -- Added Function for Internal Request Case Limits..   
    */
    public static string getIntReqCaseDayLimit(){
        List<case> assignedCaseList = new List<case> ();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        CS_Email_Limits__c unAssignedLimitvalue;
        String unassignedLimit; 
        string resultValue;        
        List<case> unassignedCaseList = new List<case> ();
        Integer lmt = Limits.getLimitQueryRows();
        Id internalRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseIRRecordType).getRecordTypeId();
        try{
            unassignedCaseList = [Select id from Case where recordtypeid=:internalRecTypeId  and CreatedDate = TODAY limit :lmt];
            if(CS_Email_Limits__c.getInstance() != null){
                unAssignedLimitvalue= CS_Email_Limits__c.getValues(EMAIL_LIMITS);
                unassignedLimit =  unAssignedLimitvalue.Internal_Request_Cases_Per_Day__c;
            }
            
            if(unassignedCaseList != null && unassignedCaseList.size() == Integer.valueOf(unassignedLimit)-1 ){
                resultValue=SUCCESS_EMAIL;
                
            }
            else if(unassignedCaseList != null && unassignedCaseList.size() < Integer.valueOf(unassignedLimit)){
                resultValue=SUCCESS;
            }
            else
            {
                resultValue=LIMIT_EXCEED;
            }
        }
        catch(Exception e){
            system.debug(Label.CS_ErrorMessage+e.getMessage());
        }
        return resultValue;
    }
    
     /*Description : This method will be used to send the email when limit is reached to Center Lead
    */
     public static void sendEmail(Id createdCaseId, String fromAddress, String toAddress)
    {
        set<ID> RoleIds = new set<Id>();
        set<ID> groupIds = new set<ID>();
        set<ID> userIds = new set<ID>();
        Map<ID,String> userMap = new Map<ID,String>();  
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
      
        Integer lmt = Limits.getLimitQueryRows();
        try{
            EmailTemplate emailtemplate = [Select Id, Subject, HtmlValue, Body from EmailTemplate where Name =:TEMPLATE_NAME limit :lmt];
          /* <KV04202016>*/   for(Group grpUsr : [Select Id,RelatedId  from Group where (Group.DeveloperName like :PUBLIC_GRP_KEYUSER and type ='Queue')   limit :lmt]){
                if(grpUsr.RelatedId == null){
                  groupIds.add(grpUsr.id);
                
                }
                else{
                     RoleIds.add(grpUsr.RelatedId);
                   }
            }
            
           
            for(GroupMember grpMemRec: [Select UserOrGroupId from GroupMember where GroupId in :groupIds]){
            if(((String)grpMemRec.userOrGroupId).startsWith(groupType)){
                for(GroupMember grpMemRec1: [Select UserOrGroupId from GroupMember where GroupId = :grpMemRec.UserOrGroupId]){
                userIds.add(grpMemRec1.UserOrGroupId );
                }
                
           }else{
                userIds.add(grpMemRec.UserOrGroupId );
                }
            
            }
            
                
             for(User userRec: [Select Id, Name from User where (UserRoleId in :RoleIds or id in :userIds) ]){
             
                 userMap.put(userRec.Id, userRec.Name);
              
            } 
            
          
            Case modifiedCase = [SELECT Account.Id,recordtypeid, Account.Name, Contact.Name, Owner.FirstName, Owner.LastName, CaseNumber, Subject,ERP_Account_Code__c, fERP_SalesOrg__c, ERP_DistChannelCode__c, ERP_DivisionCode__c, LastModifiedBy.FirstName,  LastModifiedBy.LastName from Case where Id=:createdCaseId];
            Id internalRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CS_CaseIRRecordType).getRecordTypeId();
            String subject = emailtemplate.Subject;
            String htmlBody = emailtemplate.Body ;
            CS_Email_Limits__c emailSettings = CS_Email_Limits__c.getValues('Limits');
            String assignedLimit = emailSettings.Cases_Per_Account_Per_Day__c;
            String unassignedLimit = emailSettings.Unassigned_Cases_Per_Day__c;
            String internalLimit = emailSettings.Internal_Request_Cases_Per_Day__c;
                                                
                                                if(modifiedCase.Account != null){
                                                    // AA 09042015 -- Added email changes for Internal Request Case Limits.. 
                                                    if(internalRecTypeId==modifiedCase.recordtypeid){
                                                        subject = subject.replace('Account {!Case.Account}','Internal Requests' ); 
                                                        htmlbody = htmlBody.replace('{Limit}', internalLimit);
                                                    }else{
                                                        subject = subject.replace('{!Case.Account}', modifiedCase.Account.Name); 
                                                        htmlbody = htmlBody.replace('{Limit}', assignedLimit);
                                                    }
                                                }else{
                                                    subject = subject.replace('{!Case.Account}', ''); 
                                                    htmlbody = htmlBody.replace('{Limit}', unassignedLimit);
                                        }
                                                if(modifiedcase.ERP_Account_Code__c != null && modifiedcase.fERP_SalesOrg__c != null && modifiedcase.ERP_DistChannelCode__c != null && modifiedcase.ERP_DivisionCode__c != null)
                                                {
                                                   htmlBody = htmlBody.replace('{!Case.ERP_Account_Code__c}', modifiedCase.ERP_Account_Code__c + '-');
                                                   htmlBody = htmlBody.replace('{!Case.fERP_SalesOrg__c}', modifiedCase.fERP_SalesOrg__c + '-');
                                                   htmlBody = htmlBody.replace('{!Case.ERP_DistChannelCode__c}', modifiedCase.ERP_DistChannelCode__c + '-');
                                                   htmlBody = htmlBody.replace('{!Case.ERP_DivisionCode__c}' , modifiedCase.ERP_DivisionCode__c + '-');
                                                   htmlBody = htmlBody.replace('{fromAddress}' , fromAddress);
                                                   htmlBody = htmlBody.replace('{toAddress}' , toAddress + '@dupont.com');

                                    }else{
                                                                htmlBody = htmlBody.replace('{!Case.ERP_Account_Code__c}', '');
                                                                htmlBody = htmlBody.replace('{!Case.fERP_SalesOrg__c}', '');
                                                                htmlBody = htmlBody.replace('{!Case.ERP_DistChannelCode__c}', '');
                                                                htmlBody = htmlBody.replace('{!Case.ERP_DivisionCode__c}' , '');
                                                                htmlBody = htmlBody.replace('{fromAddress}' , fromAddress);
                                                                htmlBody = htmlBody.replace('{toAddress}' , toAddress + '@dupont.com');
                                                }
            string userName = ''; 
            List<Messaging.SingleEmailMessage> MailsList = new List<Messaging.SingleEmailMessage>();
            for(Id userid :userMap.keyset()){  
                
                if(userName ==''){ 
                htmlBody = htmlBody.replace('{!User.Name}',userMap.get(userid) ); 
                userName = userMap.get(userid); 
                }else{ 
                htmlBody = htmlBody.replace(userName,userMap.get(userid) ); 
                userName = userMap.get(userid);
                
                }
             
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
            mail.setTargetObjectId(userid );
             
            mail.setSubject(subject);
            mail.setPlainTextBody(htmlBody);
            mail.setSaveAsActivity(false);
                MailsList.add(mail);
           
            }
             Messaging.sendEmail(MailsList);
           
                                }catch(Exception e){
           system.debug(Label.CS_ErrorMessage);
        } 
    }
}
/*******************************************************************************
Email: Vinayak.Vijayakumar@usa.dupont.com
Date : 22 Jul 2011
Description:  Called from a Trigger trigUpdateTaskId to do the 
update the Task Id when the Task status is marked completed.
Used only for Case Object, BI EMEA Case Record Type and Task - Complaint Record Type
** ============================================================================= 
* Ver   Date        Author               Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   29-Aug-11   Vinayak VijayaKumar Initial Code
* 1.1   05-Sep-11   Vinayak Vijayakumar Changed Rtype.getIdByName to Rtype.getIdByDevName, 
                                           as there was Translation Issue.
* 1.2   03-Sep-13   Kusuma Kumar        Added a new method updateRequestStatusToSubmitted() to update the 
<KK03092013>                            status of the Request to Submitted whenever there is an Email sent to 
                                        Sales Aid with a particular keyword in the body of the email related to 
                                        DCF-NA Lead.
* 1.3   27-Dec-13  Srikanth Sannappa    modified this class to follow the DuPont trigger Standards.   
<SS12272013>                            Extended the generic class 'TriggerHandlerbase' and moved the method
                                        calls based on their trigger event.
**************************************************************************************************************/
/*****************************************************************************
<PS 20150205>-Added variables and a method updateBPDAttachments to create a task
 *****************************************************************************/
public without sharing class TaskHandler extends TriggerHandlerBase {
///////////////////////////////////////////////////////////////////////////////////
    public static final Id COMP_RTYPE=Rtype.getIdByDevName('Task','Complaint');
    public static final Id BI_EMEA_CASE_RTYPE=Rtype.getIdByDevName('Case','BI_EMEA_Case');
    public static final Id CUPS_RTYPE=Rtype.getIdByDevName('Task','Notification');
    /*<KK03092013>*/
    public static final Id DCF_NA_REQUEST_RTYPE=Rtype.getIdByDevName('Request__c','DCF_NA_Request_Capture'); 
    //////////////////////////////////////////////////////////////////////////////////////
    public static String BODY_SEARCHSTR = 'Below is the sample request related to Lead/Contact:';
    /*<PS 20150205> Added these 6 variables  */
    public static String BPD_PROOFOFUSE_SEARCHSTR = 'Proof of Use';
    public static String BPD_PROPERUSE_SEARCHSTR = 'Proper Use';
    public static String BPD_CD1_SEARCHSTR1 = 'Cease and Desist - Notice of Trademark Infringement';
    public static String BPD_CD1_SEARCHSTR2 = 'Cease and Desist - Unauthorized Use of';
    public static String BPD_CD2_SEARCHSTR = 'Cease & Desist - Second Notice of Trademark Infringement';
    public static String BPD_BPCLOSURE_SEARCHSTR = 'Confirmation of Trademark Compliance';
    static Id profileId=UserInfo.getProfileId();
    //static Profile userProfile=[select name from Profile where Id=:profileId limit 1]; //SA07052017
    //SA07052017 Start
    static List<Profile> ListOfProfile= [select name from Profile where Id=:profileId limit 1];
    static Profile userProfile = new Profile();
    static{
        if(ListOfProfile!=null && ListOfProfile.size()>0){
            userProfile=ListOfProfile[0];
        }
    }
    //SA07052017 End
    public override void bulkBefore(){
        if(Trigger.IsBefore && (Trigger.IsUpdate || Trigger.IsInsert)){
            //updateTaskOwner();
            preventTaskUpdation();
        }
          
        if(Trigger.IsBefore && Trigger.IsDelete)
            preventTaskDeletion();
              
    } 
    public override void bulkAfter(){
        if(Trigger.IsAfter && (Trigger.IsUpdate || Trigger.IsInsert)){
            checkStatusAndUpdateActivityId();
            updateOppForProgession(); //<jj04012016> Added method call to new method
        }
        /*<KK03092013>*/
        if(Trigger.IsInsert){        
            updateRequestStatusToSubmitted();
        }
        
        if(Trigger.IsAfter && Trigger.IsInsert)
        {
          updateBPDAttachments();
        }
        
    }
    public static void preventTaskUpdation(){
        //SA07052017 Start
        /*
        for(Sobject so : Trigger.new){
            Task t=(Task)so; 
            Task s= (Task)Trigger.oldMap.get(t.Id);
            if(Trigger.oldMap.get(t.Id)!= null){
            if(t.RecordTypeId==CUPS_RTYPE && s.Status == 'Completed'){
                            system.debug('entered into intermed');
                if(userProfile != NULL && (userProfile.Name == 'DPP-Polymers Standard CUPS PA User' || userProfile.Name == 'DPP-Polymers Standard User' || userProfile.Name == 'DPP-Polymers System Admin')){               
                t.addError('You are not authorized to update once the Task is closed');
                }
            }
            }
    }
    */
    //SA07052017 End
    }
    
/*    
    //Method to update the corresponding owner for the CUPSTask based on Status
    public static void updateTaskOwner(){
    system.debug('Hi');
    //Local variables are declared here
    List<Id> taskIdList_CA = new List<Id>();
    List<Id> taskIdList_DL = new List<Id>();
    List<Task> taskList_DL = new List<Task>();
    List<Task> taskList_CA = new List<Task>();
    List<CUPS_Request__c> cupReq_DL = new List<CUPS_Request__c>();
    List<CUPS_Request__c> cupReq_CA = new List<CUPS_Request__c>();
    Map<Id,Id> DLTaskMap = new Map<Id,Id>();
    Map<Id,Id> CATaskMap = new Map<Id,Id>();
    Map<Id,Id> reqDLTaskMap = new Map<Id,Id>();
    Map<Id,Id> reqCATaskMap = new Map<Id,Id>();
    
        for(Sobject so : Trigger.new){
            Task t=(Task)so;
            if(t.RecordTypeId==CUPS_RTYPE && t.Status!='Completed'){
                if(userProfile != NULL && userProfile.Name == 'DPP-Polymers Standard CUPS PA User'){
                    taskList_CA.add(t);
                    taskIdList_CA.add(t.whatId);
                }
                if(userProfile != NULL && userProfile.Name == 'DPP-Polymers Standard User'){
                    taskList_DL.add(t);
                    taskIdList_DL.add(t.whatId);
                }
            }
            System.debug('taskList_DL is '+taskList_DL);
        }
        
        cupReq_CA = [SELECT CUPS_Admin__c,Distribution_Leader__c FROM CUPS_Request__c WHERE Id IN: taskIdList_CA];
        cupReq_DL = [SELECT CUPS_Admin__c,Distribution_Leader__c FROM CUPS_Request__c WHERE Id IN: taskIdList_DL];
        System.debug('taskIdList_CA is '+taskIdList_CA);
        for(task tdl:taskList_DL){
            DLTaskMap.put(tdl.whatId,tdl.id);
        }
        for(task tca:taskList_CA){
            CATaskMap.put(tca.whatId,tca.id);
        }
        //Mapping the Task with the corresponding owner
        for(CUPS_Request__c req:cupReq_CA){
            reqCATaskMap.put(CATaskMap.get(req.id),req.Distribution_Leader__c);
        }
        for(CUPS_Request__c req:cupReq_DL){
            reqDLTaskMap.put(DLTaskMap.get(req.id),req.CUPS_Admin__c);
        }       
        //Updating the task with the corresponding owner
        for(task tca1:taskList_CA){
        system.debug('Updating CUPS Admin');
            tca1.Status = 'Investigate';
            tca1.ownerid = reqCATaskMap.get(tca1.id);
        }
        for(task tdl1:taskList_DL){
        system.debug('Updating Distribution Leader'+ reqDLTaskMap.get(tdl1.id));
            tdl1.Status = 'Resolved';
            tdl1.ownerid = reqDLTaskMap.get(tdl1.id);
        }
    }
*/    
   public static void checkStatusAndUpdateActivityId(){

        List<Task> whatIds = new List<Task>();
        List<Id> caseIds = new List<Id>();
        whatIds = [SELECT whatId FROM Task WHERE Id IN :Trigger.newMap.keySet()];
        
        for(Sobject so : Trigger.new){
            Task t=(Task)so;
            if(t.whatId!=null){
                if(String.valueOf(t.whatId).startswith('500')){
                    caseIds.add(t.whatId);
                } 
            }
        }
        List<Case> caseList = [SELECT Id,Activity_Id__c,RecordTypeId FROM Case WHERE Id IN :CaseIds];
        database.DMLOptions dmo = new database.DMLOptions();//SL20131120
        dmo.EmailHeader.triggerUserEmail = true;//SL20131120
        for(Sobject so : Trigger.new){
            Task t=(Task)so;
            if(t.whatId!=null){
                if(String.valueof(t.WhatId).startsWith('500') && COMP_RTYPE==t.RecordTypeId && t.Status=='Completed' ){
                    for(Case cas : caseList){
                        if(cas.Id==t.WhatId && BI_EMEA_CASE_RTYPE==cas.RecordTypeId){
                            cas.Activity_Id__c = t.Id;
                            
                        }
                }
                }
            }
        }
        //update caseList;
        database.update(caseList,dmo);//SL20131120
    }
    
    public static void preventTaskDeletion(){
        //SA07052017 Start
        /*
        for(Sobject so : Trigger.Old){
            Task t=(Task)so;
            if(userProfile != NULL && (userProfile.Name == 'DPP-Polymers Standard CUPS PA User' || userProfile.Name == 'DPP-Polymers System Admin' || userProfile.Name == 'DPP-Polymers Standard User')){
                t.addError('You are not authorized to delete the closed task');
            }
        }
        */
        //SA07052017 End
    }
    /*<KK03092013>
    *Method Name: updateRequestStatusToSubmitted
    *Description: Updates the Status value of the Request and Request Item record
    *             to "Submitted" when a task is created for Request related to 
    *             DCF-NA Lead/Contact
    ****************************************************************************/
    public static void updateRequestStatusToSubmitted(){
        Set<Id> requestIds = new Set<Id>();
        Set<Id> parentRequestIds = new Set<Id>();
        for (sObject s : Trigger.new ) {
            Task t = (Task)s;
            if(t.WhatId!=null && t.Description!=null) { 
                //if(  String.valueof(t.WhatId).startsWith('a1E') && t.Description.contains(BODY_SEARCHSTR))//SA07052017
                  if(  String.valueof(t.WhatId).startsWith(Request__c.sObjectType.getDescribe().getKeyPrefix()) && t.Description.contains(BODY_SEARCHSTR))//SA07052017
                    RequestIds.add(t.WhatId);
            }
        }
        if (RequestIds.size()>0) {
            LIST<Request__c> reqs = [Select Id,Status__c, Stage__c from Request__c where id in: RequestIds and RecordTypeId=:DCF_NA_REQUEST_RTYPE];
            for(Request__c req:reqs){
                parentRequestIds.add(req.id);
            }
            LIST<Request_Item__c> reqItems = [Select Id,Status__c, Stage__c from Request_Item__c where Request__c in: parentRequestIds];
            for (Request__c r :  reqs )
                r.Status__c='Submitted';
            for (Request_Item__c ri :  reqItems )
                ri.Status__c='Submitted';
            update reqs;
            update reqItems;
        }  
    }
   /* method to create attachments when email is sent  */ 
    public void updateBPDAttachments(){
    List<Attachment> bpdCaseAttachments = new List<Attachment>();
     for (Task bpdTask : [SELECT Subject,WhatId, Status,Description FROM TASK WHERE ID IN:trigger.new]) { 
            if(bpdTask.WhatId!=null   && bpdTask.Status == 'Completed' && !String.isBlank(bpdTask.Subject)) {
            if(bpdTask.Subject.Contains(BPD_PROPERUSE_SEARCHSTR)){
            Attachment bpdCaseAttachment = new Attachment(ParentId = bpdTask.WhatId,
             Name = 'PU- '+ bpdTask.Subject+'.doc', Body = Blob.valueOf(bpdTask.Description),contenttype='application/word');
            bpdCaseAttachments.add(bpdCaseAttachment ); 
            } 
            else if(bpdTask.Subject.Contains(BPD_PROOFOFUSE_SEARCHSTR )){
            Attachment bpdCaseAttachment = new Attachment(ParentId = bpdTask.WhatId,
             Name = 'POU- '+ bpdTask.Subject+'.doc', Body = Blob.valueOf(bpdTask.Description), contenttype='application/word');
            bpdCaseAttachments.add(bpdCaseAttachment ); 
            } 
            else if(bpdTask.Subject.Contains(BPD_CD1_SEARCHSTR1) || bpdTask.Subject.Contains(BPD_CD1_SEARCHSTR2) ){
            Attachment bpdCaseAttachment = new Attachment(ParentId = bpdTask.WhatId,
             Name = 'CD1- '+ bpdTask.Subject+'.doc', Body = Blob.valueOf(bpdTask.Description), contenttype='application/word');
            bpdCaseAttachments.add(bpdCaseAttachment ); 
            } 
            else if(bpdTask.Subject.Contains(BPD_CD2_SEARCHSTR)){
            Attachment bpdCaseAttachment = new Attachment(ParentId = bpdTask.WhatId,
             Name = 'CD2- '+ bpdTask.Subject+'.doc', Body = Blob.valueOf(bpdTask.Description), contenttype='application/word');
            bpdCaseAttachments.add(bpdCaseAttachment ); 
            } 
            else if(bpdTask.Subject.Contains(BPD_BPCLOSURE_SEARCHSTR)){
            Attachment bpdCaseAttachment = new Attachment(ParentId = bpdTask.WhatId,
             Name = 'BP- '+ bpdTask.Subject+'.doc', Body = Blob.valueOf(bpdTask.Description), contenttype='application/word');
            bpdCaseAttachments.add(bpdCaseAttachment ); 
            } 
               
            }
        }
        insert bpdCaseAttachments;
    }
    
    //<jj04012016> START NEW CODE
    //New method to Update NH Opportunities when a NH Progression Task is competed
    
    public void updateOppForProgession(){
        list<sObject> sos = new list<sObject>();//inList;
        list<Opportunity> affectedOpps = new list<Opportunity>();
        //set<Id> oppIds = new set<Id>();
        sos.addAll(this.getRecordsByRT('NH_Progression').values());
        map<Id,map<string,date>> maxByOpp = new map<Id,map<string,date>>();
        //map<Id,date> maxInternalByOpp = new map<Id,date>();
        for (SObject so:sos){
            task t = (task)so;
            task tOld = new task();
            if(t.Id!=null && trigger.isUpdate && trigger.oldMap.containsKey(t.Id))
                tOld = (task)trigger.oldMap.get(t.Id);
            if(string.valueOf(t.WhatId).left(3)=='006' && t.Status=='Completed'){
                maxByOpp.put(t.WhatId,new map<string,date>());
            }
        }
        for(AggregateResult ar:[select WhatId, Max(Completion_Date__c) max, type from Task where WhatId IN:maxByOpp.keySet() and RecordType.name='NH Progression' GROUP BY WhatId,type]){
            maxByOpp.get((Id)ar.get('WhatId')).put((string)ar.get('type'),(date)ar.get('max'));
        }
        for(Id i:maxByOpp.keySet()){
            Opportunity o = new Opportunity(Id=i);
            //KRISH: to remove reference to Last_Internal_Progression__c
            /*if(maxByOpp.get(i).containsKey('Internal') && maxByOpp.get(i).get('Internal')!=null)
                o.Last_Internal_Progression__c = maxByOpp.get(i).get('Internal');*/
            //KT [11072017]: To remove Last_Client_Progression__c reference
            //if(maxByOpp.get(i).containsKey('Client') && maxByOpp.get(i).get('Client')!=null)
            //    o.Last_Client_Progression__c = maxByOpp.get(i).get('Client');
            affectedOpps.add(o);
        }
        if(affectedOpps.size()>0)
            update affectedOpps;
    }
    //<jj04012016> END NEW CODE
}
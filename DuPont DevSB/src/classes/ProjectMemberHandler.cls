/*******************************************************************************
Email: sreedhar.jagannath@ind.dupont.com
Date : 24 Dec 2011
Description:  Called from a Trigger trigProjectmember to share Visibility access
on the Parent CRM IT Project Record
TEST020921012 :To handle refresh of Old CRM IT Project Records
********************************************************************************/
    public without sharing class ProjectMemberHandler extends TriggerHandlerBase {
        public static boolean refreshInProcess = false;
        public override void bulkBefore(){
            if(!refreshInProcess){
                refreshprojmembers(Trigger.oldMap.KeySet()) ;
            } 
            if(Trigger.isdelete){
                upondelete();
            }
        }
       
        public override void andFinally(){
             //if(Trigger.isInsert || Trigger.isUpdate)
                parentApexSharing();
        }
       //TEST020921012
        public static void refreshprojmembers(SET<Id> projectmemberids) {
                refreshInProcess=true;
                    List<Project_Member__c> projmemtoUpdate = new List<Project_Member__c>();
                        Map<Id,Project_Member__c> projmems = new Map<Id,Project_Member__c>([select Access__c,CRM_IT_Project__c,Role__c from Project_Member__c where id in : projectmemberids]);
                            for(Project_Member__c pm : projmems.values()){
                                projmemtoUpdate.add(pm);
                            }
                if (projmemtoUpdate.size()>0)
                database.update(projmemtoUpdate,false);
        }
        
       public static void parentApexSharing(){
            Map<Id,Project_Member__c> pmOldMap = (Map<Id,Project_Member__c>)Trigger.OldMap;
                    List<CRM_IT_Project__Share> sharesToCreate = new List<CRM_IT_Project__Share>();            
/***********************************************************************************************
                // inserting new records 
***********************************************************************************************/               
                if(Trigger.isInsert && Trigger.isAfter){
                    for(SObject so:Trigger.new){
                        Project_Member__c pm = (Project_Member__c)so;
                            CRM_IT_Project__Share projectshare = new CRM_IT_Project__Share();
                                if(pm.Access__c == 'Read/Write'){     
                                // create the new share with R/W access
                                projectshare.ParentId = pm.CRM_IT_Project__c;
                                    projectshare.AccessLevel = 'Edit';
                                        projectshare.RowCause = Schema.CRM_IT_Project__Share.RowCause.Apex_Sharing_Access__c;
                                    projectshare.UserOrGroupId = pm.Project_Member__c;
                                sharesToCreate.add(projectshare);
                                } 
                                else if(pm.Access__c == 'Read Only'){                          
                                // create the new share with Read Only access
                                projectshare.ParentId = pm.CRM_IT_Project__c;
                                    projectshare.AccessLevel = 'Read';
                                        projectshare.RowCause = Schema.CRM_IT_Project__Share.RowCause.Apex_Sharing_Access__c;                                        
                                    projectshare.UserOrGroupId = pm.Project_Member__c;
                                sharesToCreate.add(projectshare);
                          }                
                   } 
                //do the DML to create shares
                   if (!sharesToCreate.isEmpty())
                          insert sharesToCreate;
               }
/***********************************************************************************************
                    // updating existing records 
***********************************************************************************************/  
              else if ((Trigger.isUpdate && Trigger.isAfter)) {
                 List<ID> shareIdsToDelete = new List<ID>();
                 List<ID> userid = new List<ID>();
                    List<String> sharereasons = new List<String>();
                     for(SObject so:Trigger.new){
                        Project_Member__c pm = (Project_Member__c)so;
                    // if the record access was R/W OR Read but is now Private -- delete the existing share
                         if ((pmOldMap.get(pm.ID).Access__c == 'Read/Write' || pmOldMap.get(pm.ID).Access__c == 'Read Only' )&& (pm.Access__c == 'Private')) {
                            shareIdsToDelete.add(pm.CRM_IT_Project__c);
                            userid.add(pm.Project_Member__c); 
                                                                            
                         }
                    // if the record access now is R/W -- create the new share
                         else if (pm.Access__c == 'Read/Write') {
                            CRM_IT_Project__Share projectshare = new CRM_IT_Project__Share();
                                // create the new share with read/write access
                                projectshare.ParentId = pm.CRM_IT_Project__c;
                                    projectshare.AccessLevel = 'Edit';
                                        projectshare.RowCause = Schema.CRM_IT_Project__Share.RowCause.Apex_Sharing_Access__c;                                       
                                    projectshare.UserOrGroupId = pm.Project_Member__c;
                                sharesToCreate.add(projectshare);
                        }
                        else if (pm.Access__c == 'Read Only') {
                            CRM_IT_Project__Share projectshare = new CRM_IT_Project__Share();
                                // create the new share with read only access
                                projectshare.ParentId = pm.CRM_IT_Project__c;
                                    projectshare.AccessLevel = 'Read';
                                        projectshare.RowCause = Schema.CRM_IT_Project__Share.RowCause.Apex_Sharing_Access__c;                                   
                                    projectshare.UserOrGroupId = pm.Project_Member__c;
                                sharesToCreate.add(projectshare);
                        }
                    }  
                // do the DML to delete shares
                if (!shareIdsToDelete.isEmpty())
                  delete [select id from CRM_IT_Project__Share where (ParentId IN :shareIdsToDelete and UserOrGroupid IN :userid) and RowCause ='Apex_Sharing_Access__c'];
                 
                // do the DML to create shares
                if (!sharesToCreate.isEmpty())
                  upsert sharesToCreate;             
           }
/***********************************************************************************************/
     }
     
     public static void upondelete(){
     
         if(Trigger.isDelete && Trigger.isBefore){
         List<ID> shareIdsToDelete = new List<ID>();
                 List<ID> userid = new List<ID>();
                 for(SObject so:Trigger.old){
                        Project_Member__c pm = (Project_Member__c)so;
                        shareIdsToDelete.add(pm.CRM_IT_Project__c);
                            userid.add(pm.Project_Member__c); 
             
                 }
                 
                 if (!shareIdsToDelete.isEmpty())
                  delete [select id from CRM_IT_Project__Share where (ParentId IN :shareIdsToDelete and UserOrGroupid IN :userid) and RowCause ='Apex_Sharing_Access__c'];
                 
             }
     }
     
}
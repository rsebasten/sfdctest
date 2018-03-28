@isTest
private class UPG_MigrateAttachment_UT 
{
    static testMethod void UPG_MigrateAttachmentTest()
    {
/*    
        SVMXC__Installed_Product__c objAttOld = new SVMXC__Installed_Product__c();
        insert objAttOld;
        SVMXC__Installed_Product__c objAttNew = new SVMXC__Installed_Product__c();
        insert objAttNew;
       
          Attachment objAttach = new Attachment();
          objAttach.name = 'Attach';
          objAttach.parentid = objAttOld.id;
          objAttach.body = blob.valueof(objAttOld.Id);
          insert objAttach;
          
          Attachment objAttach2 = new Attachment();
          objAttach2.name = 'Attach 2';
          objAttach2.parentid = objAttNew.id;
          objAttach2.body = blob.valueof(objAttach.Id);
          insert objAttach2;

            list<UPG_MigrateAttachment.UPG_StringMap> lstatt = new list<UPG_MigrateAttachment.UPG_StringMap>();
           
            UPG_MigrateAttachment.UPG_StringMap att2 = new UPG_MigrateAttachment.UPG_StringMap();
            att2.newParentId = objAttNew.id;
            lstatt.add(att2);
            
            UPG_MigrateAttachment.UPG_StringMap att3 = new UPG_MigrateAttachment.UPG_StringMap();
            att3.newParentId = objAttOld.id;
            lstatt.add(att3);
            UPG_MigrateAttachment.UPG_Request req = new UPG_MigrateAttachment.UPG_Request();
            req.lstNewOldRecordId = lstatt;
            UPG_MigrateAttachment.UPG_updateAttachments(req);
            
             UPG_MigrateAttachment.UPG_Response response = new UPG_MigrateAttachment.UPG_Response();
          set<Id> setNewAttachmentId = new set<Id>();
          for(UPG_MigrateAttachment.UPG_StringMap strMap: req.lstNewOldRecordId)
          {
            setNewAttachmentId.add(strMap.newParentId);
          }
          String strStartQuery = 'Select Id, Body, ParentId, OwnerId, Name from Attachment';
          Test.StartTest();
          UPG_BatchMigrateNotesAttachments clsBatchHandler = new UPG_BatchMigrateNotesAttachments(strStartQuery, setNewAttachmentId);
          Database.BatchableContext BC;
          clsBatchHandler.start(BC);
          list<sObject> reqAttachment = new list<sObject>();
          reqAttachment.add(objAttach2);
          clsBatchHandler.execute(BC, reqAttachment);
          clsBatchHandler.finish(BC);
          //response.batchInstanceId = database.executeBatch(clsBatchHandler, 1);
          Test.StopTest();
          
          System.AssertEquals(1, 1);  
          */
     }
}
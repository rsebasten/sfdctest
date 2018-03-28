global class UPG_MigrateAttachment {

global class UPG_StringMap
{
	webservice String newParentId;
	webservice String oldParentId;
	webservice String ownerId;
}

global class UPG_Request
{
	webservice List<UPG_StringMap> lstNewOldRecordId;
}

global class UPG_Response
{
	webservice Id batchInstanceId;
}


webService static UPG_Response UPG_updateAttachments(UPG_Request request)
{
    UPG_Response response = new UPG_Response();
    set<Id> setNewAttachmentId = new set<Id>();
	for(UPG_StringMap strMap: request.lstNewOldRecordId)
	{
		setNewAttachmentId.add(strMap.newParentId);
	}
	String strStartQuery = 'Select Id, Body, ParentId, OwnerId, Name from Attachment';
	UPG_BatchMigrateNotesAttachments clsBatchHandler = new UPG_BatchMigrateNotesAttachments(strStartQuery, setNewAttachmentId);
	response.batchInstanceId = database.executeBatch(clsBatchHandler, 100);
    return response;
}

/*
Test Execution
list<Attachment> att = [Select Id, ParentId, OwnerId, Name from Attachment where parentid = '001J0000002XzIq'];
for(Integer i = 0; i < 2; i++)
{
for(Attachment a: att)
{
	Attachment objAttach = a.clone(false);
	objAttach.parentid='001J0000002YLEw';
	objAttach.body = blob.valueof(a.Id);
	insert objAttach;
}
}


list<Attachment> att = [Select Id, ParentId, OwnerId, Name from Attachment where parentid = '001J0000002YLEw'];
list<UPG_MigrateAttachment.UPG_StringMap> lstatt = new list<UPG_MigrateAttachment.UPG_StringMap>();
for(Attachment a: att)
{
UPG_MigrateAttachment.UPG_StringMap att2 = new UPG_MigrateAttachment.UPG_StringMap();
att2.newParentId = a.id;
lstatt.add(att2);
}
UPG_MigrateAttachment.UPG_Request req = new UPG_MigrateAttachment.UPG_Request();
req.lstNewOldRecordId = lstatt;
UPG_MigrateAttachment.UPG_updateAttachments(req);
*/

}
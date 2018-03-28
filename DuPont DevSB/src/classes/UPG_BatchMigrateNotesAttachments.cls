global  class UPG_BatchMigrateNotesAttachments implements Database.Batchable<SObject>
{
	global final String strStartQuery;
	global final String strExecuteQuery;
	global final set<Id> setNewAttachmentId;
	
	global UPG_BatchMigrateNotesAttachments(String startQuery, set<Id> newAttachmentId)
	{
		strStartQuery = startQuery;
		setNewAttachmentId = newAttachmentId;
	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		return Database.getQueryLocator(strStartQuery + ' where Id = :setNewAttachmentId');
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> lstAttachments)
	{
		for(sObject objAttachment: lstAttachments)
		{
			Attachment objAttach = (Attachment)objAttachment;
			objAttach.body = [Select body from Attachment where Id = :objAttach.body.toString()].body;
			update objAttach;
			objAttach.clear();
		}
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}
}
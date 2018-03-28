trigger trigRequestItem on Request_Item__c (before delete) {
	Set <Id> ids = new Set<Id>();
    for (Request_Item__c ri : Trigger.old) {
        ids.add(ri.Id);
    }
    List<Request_Item__c> ris = [SELECT Id, Request__c, Request__r.Stage__c from Request_Item__c where Id in :Ids];
    for (Request_Item__c ri : ris) {
        if (ri.Request__r.Stage__c.equals('Submitted'))
            Trigger.OldMap.get(ri.Id).addError('Items of Submitted Requests cannot be deleted');
    }
}
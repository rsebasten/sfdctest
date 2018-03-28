// <AK 20170921> Made class schedulable

global class MACreateShapeLayersByContactBatchable implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    //usage: Database.executeBatch(new MACreateShapeLayersByContactBatchable(), 25);
    global String shapeLayerFolderId {get ; set ;}

     //// <AK 20170921> Made class schedulable *starts

     global void execute(SchedulableContext SC)
    {
        database.executeBatch(new MACreateShapeLayersByContactBatchable(), 25);
    }
    // Change Ends
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<sma__MATerritory__c> territoriesToDelete = new List<sma__MATerritory__c>();
        
        for (sma__MATerritory__c terr : [SELECT Id FROM sma__MATerritory__c WHERE Auto_Created__c = true AND sma__Folder__r.Name = 'By Contact' AND sma__Folder__r.sma__ParentFolder__r.Name = 'State'])
        {
            territoriesToDelete.add(terr);
        }
        
        delete territoriesToDelete;
        
        string ContactRecordTypeId = '';
        
        for (RecordType rt : [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'BI-NA Contact'])
        {
            ContactRecordTypeId = rt.Id;
        }        
        
        if (Test.isRunningTest())
        {
            //return Database.getQueryLocator([SELECT Id, Name FROM Contact WHERE RecordTypeId = :ContactRecordTypeId AND Account.Name = 'BI (Building Innovations)' AND Status__c = 'Active' LIMIT 1]);
            return Database.getQueryLocator([SELECT Id, Name FROM Contact WHERE Status__c = 'Active' LIMIT 1]);
        }
        else
        {
            //return Database.getQueryLocator([SELECT Id, Name FROM Contact WHERE RecordTypeId = :ContactRecordTypeId AND Account.Name = 'BI (Building Innovations)' AND Status__c = 'Active']);
            return Database.getQueryLocator([SELECT Id, Name FROM Contact WHERE Status__c = 'Active']);
        }
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        MACustomLogic.MACreateShapeLayersByContactBatchable_Execute(scope);
    }
    
    global void finish(Database.BatchableContext BC)
    {
        list<string> EmailAddresses = new list<string>();
        
        EmailAddresses.add(UserInfo.getUserEmail());

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.ToAddresses = EmailAddresses;
        message.Subject = 'Shape Layers by Contact Batch Complete';
        message.PlainTextBody = 'The batch for Generating Shape Layers by Contact has finished.';
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] rslts = Messaging.sendEmail(messages);
    }
    

}
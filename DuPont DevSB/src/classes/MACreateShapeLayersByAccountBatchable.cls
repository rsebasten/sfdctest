// <AK 20170921> Made class schedulable
global class MACreateShapeLayersByAccountBatchable implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    //usage: Database.executeBatch(new MACreateShapeLayersByAccountBatchable(), 25);
    global String shapeLayerFolderId {get ; set ;}
    
    // <AK 20170921> Made class schedulable *start
    global void execute(SchedulableContext SC)
    {
        database.executeBatch(new MACreateShapeLayersByAccountBatchable(), 25);
    }
                                  // Change Ends       
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<sma__MATerritory__c> territoriesToDelete = new List<sma__MATerritory__c>();
        
        for (sma__MATerritory__c terr : [SELECT Id FROM sma__MATerritory__c WHERE Auto_Created__c = true AND sma__Folder__r.Name = 'By Account' AND sma__Folder__r.sma__ParentFolder__r.Name = 'County'])
        {
            territoriesToDelete.add(terr);
        }
        
        delete territoriesToDelete;
        
        string AccountRecordTypeId = '';
        
        for (RecordType rt : [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Account' AND Name = 'BI - Surfaces'])
        {
            AccountRecordTypeId = rt.Id;
        } 
        
        if (Test.isRunningTest())
        {
            return Database.getQueryLocator([SELECT Id, Name FROM Account 
                                            WHERE ((BI_Account_SubType__c = 'Distribution' AND RecordTypeId = :AccountRecordTypeId AND Account_Stage__c = 'Active') AND (Name LIKE '%- HQ%' OR Name LIKE 'Parksite%')) LIMIT 1]);
        }
        else
        {
            return Database.getQueryLocator([SELECT Id, Name FROM Account 
                                            WHERE ((BI_Account_SubType__c = 'Distribution' AND RecordTypeId = :AccountRecordTypeId AND Account_Stage__c = 'Active') AND (Name LIKE '%- HQ%' OR Name LIKE 'Parksite%'))]);
        }
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        MACustomLogic.MACreateShapeLayersByAccountBatchable_Execute(scope);
    }
    
    global void finish(Database.BatchableContext BC)
    {
        list<string> EmailAddresses = new list<string>();
        
        EmailAddresses.add(UserInfo.getUserEmail());

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.ToAddresses = EmailAddresses;
        message.Subject = 'Shape Layers by Account Batch Complete';
        message.PlainTextBody = 'The batch for Generating Shape Layers by Account has finished.';
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] rslts = Messaging.sendEmail(messages);
    }
    
    
}
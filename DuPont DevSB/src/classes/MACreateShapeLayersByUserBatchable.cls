// <AK 20170921> Made class schedulable

global class MACreateShapeLayersByUserBatchable implements Database.Batchable<sObject>, Database.Stateful , Schedulable 
{
    //usage: Database.executeBatch(new MACreateShapeLayersByUserBatchable(), 25);
    global String shapeLayerFolderId {get ; set ;}
     
     // <AK 20170921> Made class schedulable *Starts

     global void execute(SchedulableContext SC)
    {
        database.executeBatch(new MACreateShapeLayersByUserBatchable(), 25);
    }
      //Change Ends
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        List<sma__MATerritory__c> territoriesToDelete = new List<sma__MATerritory__c>();
        
        for (sma__MATerritory__c terr : [SELECT Id FROM sma__MATerritory__c WHERE Auto_Created__c = true AND sma__Folder__r.Name = 'By User' AND sma__Folder__r.sma__ParentFolder__r.Name = 'County'])
        {
            territoriesToDelete.add(terr);
        }
        
        delete territoriesToDelete;
        
        string DistributorProfileId = '';
        
        for (Profile pro : [SELECT Id FROM Profile WHERE Name = 'BI-NA Distributor Partner'])
        {
            DistributorProfileId = pro.Id;
        }
        
        if (Test.isRunningTest())
        {
         // return Database.getQueryLocator([SELECT Id, Name, User_Account__c  FROM User WHERE ProfileId=:DistributorProfileId AND IsActive = true LIMIT 1]);
            return Database.getQueryLocator([SELECT Id, Name FROM User WHERE ProfileId=:DistributorProfileId AND IsActive = true AND Id = '01p4100000JDUeg' LIMIT 1]);
        }
        else
        {
            return Database.getQueryLocator([SELECT Id, Name, User_Account__c FROM User WHERE ProfileId=:DistributorProfileId AND IsActive = true]);
        }
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        MACustomLogic.MACreateShapeLayersByUserBatchable_Execute(scope);
    }
    
    global void finish(Database.BatchableContext BC)
    {
        list<string> EmailAddresses = new list<string>();
        
        EmailAddresses.add(UserInfo.getUserEmail());

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.ToAddresses = EmailAddresses;
        message.Subject = 'Shape Layers by User Batch Complete';
        message.PlainTextBody = 'The batch for Generating Shape Layers by User has finished.';
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] rslts = Messaging.sendEmail(messages);
    }

}
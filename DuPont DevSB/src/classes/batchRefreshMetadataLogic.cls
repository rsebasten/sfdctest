/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  batch class that creates metadata records for ApexClass,ApexTrigger,VF pages and components
Database.executeBatch(new batchRefreshMetadataLogic(),50);  //recommended setting 50 at a time

Test Class: Metadata_UT
<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
********************************************************************************/
global class batchRefreshMetadataLogic implements Database.Batchable<Sobject> , Database.Stateful {
    
    global DmlResults unsuccessfuls;
    global batchRefreshMetadataLogic() {}
        
    global LIST<Metadata__c> start(Database.BatchableContext BC){
        unsuccessfuls = new DmlResults();
        LIST<Metadata__c> rtn = Metadata.getMetadataLogic();
        if (Test.isRunningTest()) {
            Metadata__c test=rtn[0];
//[01232017] Merge&Spin: Updated line No 22 and added Line No 23 to increase code coverage in test run
            //test.ForceId__c='test00000001';
            test.ForceId__c = rtn[0].ForceId__c;
            test.LastModifiedDT__c = DateTime.now();
            test.FullName__c='testForTheClass_batchRefreshMetadataLogic';
            return new LIST<Metadata__c> {test};
        }
        else
            return rtn;
        }  
        
    global void execute(Database.BatchableContext BC, LIST<SObject> scope) {
            
            LIST<string> forceIds = new LIST<string>();
            for ( SObject s :  scope ) {
                Metadata__c m  = (Metadata__c) s;
                if (m.ForceId__c!=null && m.ForceId__c!=null) 
                    forceIds.add(m.ForceId__c);
            }
            MAP<string,Metadata__c> lastMetas = new MAP<string,Metadata__c>();
            for(Metadata__c m : [Select Id, Name, describe__c, LastModifiedDT__c, ForceId__c,
                                                (Select Title from NotesAndAttachments ORDER BY LASTMODIFIEDDATE DESC LIMIT 1)
                                                from Metadata__c
                                                where ForceId__c=:forceIds])
                lastMetas.put(m.ForceId__c,m);
            for ( SObject s :  scope ) {
                Metadata__c m  = (Metadata__c) s;
                boolean createAttachment = false;
                Metadata__c lastm=lastMetas.get(m.ForceId__c);

                if ( lastm==null ) {
                    lastm = new Metadata__c();
                    createAttachment=true;
                }
                else if (lastm.NotesAndAttachments==null || lastm.NotesAndAttachments.size()==0)
                    createAttachment=true;
                else if (! lastm.NotesAndAttachments[0].Title.endsWith(DateTimetoXml(m.LastModifiedDT__c)))
                    createAttachment=true;
                else {
                    createAttachment=(m.LastModifiedDT__c!=lastm.LastModifiedDT__c);
                }
                
            try {
                    LIST<Metadata__c> upsertList = new LIST<Metadata__c>{m};  //DMLResults expects a list
                    if (m.ForceId__c != null) 
                        unsuccessfuls.add(new DmlResults(database.upsert(upsertList,Metadata__c.ForceId__c,false),upsertList));
                    else
                        unsuccessfuls.add(new DmlResults(database.upsert(upsertList,Metadata__c.Id,false),upsertList));

                    
                    if (createAttachment) {
                        string body;
                        if      (m.subtype__c=='Class')         body = [Select Body from ApexClass where Id=:m.forceId__c].body;
                        else if (m.subtype__c=='Trigger')       body = [Select Body from ApexTrigger where Id=:m.forceId__c].body;
                        else if (m.subtype__c=='Page')          body = [Select Markup from ApexPage where Id=:m.forceId__c].markup;
                        else if (m.subtype__c=='Component')     body = [Select Markup from ApexComponent where Id=:m.forceId__c].markup;
    
    
                        string description = '';
                        if (m.Version__c!=null)         description+=' Ver:'+String.valueOf(m.Version__c);
                        if (m.LastModifiedDT__c!=null)  description+=' LastModDT:'+String.valueOf(m.LastModifiedDT__c);
                        if (m.LastModifiedBy__c!=null) {
                            try {
                            User u=[Select name from User where Id=:m.LastModifiedBy__c];
                            description+=' LastModBy:'+u.name;
                            }catch(exception ex){}
                        }
                        
                        //Add   Body as attachment
                        Attachment a = new Attachment(ParentId = m.Id, 
                                              Name = m.Name+'__'+DateTimetoXml(m.LastModifiedDT__c), 
                                              Body = Blob.valueof(body),
                                              description = description,
                                              contentType = 'text/plain');
                       LIST<Attachment> upsertAttachment = new LIST<Attachment>{a};  //DMLResults expects a list
                        unsuccessfuls.add(new DmlResults(database.insert(upsertAttachment,false),upsertAttachment));
                    }
                } catch (Exception ex) {}

        }
    
    }
    
    global void finish(Database.BatchableContext BC) {
        unsuccessfuls.add(Metadata.processDeleteLogic());
        //<20170908:Shubham Agarwal> : Commented to restrict email notification on batch Job completion, however batch failures will be captured as issues by Batch Job monitoring Process.
       // utilEmail.batchOnFinish(BC.getJobId(), unsuccessfuls, false);  
         //<20170908:Shubham Agarwal> : End  
    }

    public static string DateTimetoXml(datetime dt) {
        return (dt==null) ? null : dt.formatGmt('yyyy-MM-dd')+'T'+ dt.formatGmt('HH:mm:ss');
    }


}
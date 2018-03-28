/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UT for has Attachment 

TES20120517:  fixed bug that causes a SOQL limit overflow
********************************************************************************/
@isTest
private class HasAttachment_UT {

    private static final    string TEST_OBJECT = 'Task';
    
    //covers logic for bulk triggers for parents of many types
    static testMethod void test_HasAttachment_trig() {

        integer objCnt = 0;
        LIST<Id> Ids = new LIST<Id>();
        for (Schema.sObjectType obj : Attachment.ParentId.getDescribe().getReferenceTo() ) {
            string parentType = String.valueOf(obj);
                LIST<sobject> sobjs = database.query('Select Id from '+parentType+' LIMIT 1');
                if (sobjs.size()>0) {
                    for (sobject so : sobjs )
                        Ids.add(so.Id);
                        //TES20120517 objCnt++; 
                }
                objCnt++;  //TES20120517  
            if (objCnt>=75) 
                break;
        }

        Blob testblob = Blob.valueof('test blob');
        LIST<Attachment> atts = new LIST<Attachment>();
        for (Id id : Ids ) {
            try {
            Attachment att = new Attachment(
            Name = 'Doc_'+Id+'.txt',
            Body = testblob,
            ParentId=id
            );
            att.ContentType='txt/html';
            att.IsPrivate=false;
            atts.add(att);
            } catch (Exception ex) {} //some objects dont allow for attachments
        }
        
        Test.startTest();   
        Database.SaveResult[] srs = database.insert(atts,false);
        
        //some objects dont allow for attachments
        SET<Id> AttIds = new SET<Id>();
        for (Database.SaveResult sr : srs) {
            if (!sr.isSuccess())
                system.debug(sr);
        }
        
        //now delete the attachments
        LIST<Attachment> delAtts = new LIST<Attachment>();
        for (Attachment att : atts) {
            if (att.Id!=null) delAtts.add(att);
        }
        delete delAtts;
        
        
        Test.stopTest();
    }
    
    //covers logic for bulk triggers for parents of many types
    static testMethod void test_HasNote_trig() {

        integer objCnt = 0;
        LIST<Id> Ids = new LIST<Id>();
        for (Schema.sObjectType obj : Note.ParentId.getDescribe().getReferenceTo() ) {
            string parentType = String.valueOf(obj);
                LIST<sobject> sobjs = database.query('Select Id from '+parentType+' LIMIT 1');
                if (sobjs.size()>0) {
                    for (sobject so : sobjs )
                        Ids.add(so.Id);
                }
                objCnt++;
            if (objCnt>=75) 
                break;
        }

        Blob testblob = Blob.valueof('test blob');
        LIST<Note> atts = new LIST<Note>();
        for (Id id : Ids ) {
            try {
            Note att = new Note();
            att.Body='test';
            att.Title='Doc_'+Id+'.txt';
            att.ParentId=id;
            atts.add(att);
            } catch (Exception ex) {} //some objects dont allow for attachments
        }
        
        Test.startTest();   
        Database.SaveResult[] srs = database.insert(atts,false);
        
        //some objects dont allow for attachments
        SET<Id> AttIds = new SET<Id>();
        for (Database.SaveResult sr : srs) {
            if (!sr.isSuccess())
                system.debug(sr);
        }
        
        //now delete the attachments
        LIST<Note> delAtts = new LIST<Note>();
        for (Note att : atts) {
            if (att.Id!=null) delAtts.add(att);
        }
        delete delAtts;
        
        
        Test.stopTest();
    }
    
    static testMethod void test_HasAttachment_batch() {
            
        
        
        //Create some sample Tasks and attachments
        LIST<Task> ts = new LIST<Task>();
        for (integer i=0;i<10;i++) {
            ts.add(new Task(subject='test'+i));
        }
        insert ts;
        
        SET<string> TaskIds = new SET<string>();
        for (Task t: ts )
            TaskIds.add(t.id);
            
        Blob testblob = Blob.valueof('test blob');
        LIST<Attachment> atts = new LIST<Attachment>();
        for (string id : TaskIds ) {
            try {
            Attachment att = new Attachment(
            Name = 'Doc_'+Id+'.txt',
            Body = testblob,
            ParentId=id
            );
            att.ContentType='txt/html';
            att.IsPrivate=false;
            atts.add(att);
            } catch (Exception ex) {} //some objects dont allow for attachments
        }   

        Test.startTest();
        
        //add attachments
        Database.SaveResult[] srs = database.insert(atts,false);

        //incorrectly set the flag false where should be true
        ts[0].put(HasAttachment.HAS_ATTACHMENT_FIELD,false);
        update ts[0];

        //incorrectly set the flag true where should be false
        ts.add(new Task(subject='newTask', hasAttachment__c=true));
        insert ts[ts.size()-1];
        TaskIds.add(ts[ts.size()-1].id);

        //now run the batch 
        string query='Select Id from TASK Where Id in '+Util.inClause(TaskIds);
        batchRecalcHasAttachment b = new batchRecalcHasAttachment(query);
        Database.executeBatch(b,200);
        

        Test.stopTest();
    }

}
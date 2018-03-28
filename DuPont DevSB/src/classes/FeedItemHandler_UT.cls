@istest
public with sharing class FeedItemHandler_UT {
    static testMethod void ctrlChatterPolicy_UTest() {       
        insert new ChatterPolicy__c( 
                SetupOwnerId=UserInfo.getOrganizationId(),
                Share_comments_on_otherCP__c    = false,
                Share_comments_on_CPG__c    = false,
                Share_Files_on_CPG__c       = false,
                Share_Files_on_OtherCP__c   = false,
                Share_Files_on_OwnCP__c     = false,
                Share_Links_on_CPG__c       = false,
                Share_Links_on_OtherCP__c   = false,
                Share_Links_on_OwnCP__c     = false);

        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        UserRole r2= [Select id from UserRole where Name='DuPont Corporate' limit 1];

        User user1 = [select id from user where IsActive=True AND ProfileId=:p1.Id AND UserRoleId=:r1.Id limit 1];
        User user2 = [select id from user where IsActive=True AND ProfileId=:p1.Id AND UserRoleId=:r2.Id limit 1];
        CollaborationGroup cg=new CollaborationGroup(Name='test2',CollaborationType = 'Public');
        insert cg;

        List<Feeditem> FeeditemTest = New List<Feeditem>();
        Blob bodyBlob1=Blob.valueOf('Testdblob');

        System.runAs(user1)    {
            Feeditem fid = new Feeditem(Body='Test', ParentId=UserInfo.getUserId()  , Type='LinkPost',LinkUrl='abc' );
            FeeditemTest.add(fid);

            Feeditem fid1 = new Feeditem(Body='Test', ParentId=UserInfo.getUserId() ,Type='ContentPost' ,ContentData=bodyBlob1 , ContentFileName='test' );
            FeeditemTest.add(fid1);

            Feeditem fid2 = new Feeditem(Body='Test', ParentId=User2.Id  , Type='LinkPost',LinkUrl='abc');
            FeeditemTest.add(fid2);

            Feeditem fid3 = new Feeditem(Body='Test', ParentId=User2.Id  , Type='TextPost');
            FeeditemTest.add(fid3);

            Feeditem fid4 = new Feeditem(Body='Test', ParentId=User2.Id  , Type='ContentPost',ContentData=bodyBlob1 , ContentFileName='test');
            FeeditemTest.add(fid4);

            Feeditem fid5 = new Feeditem(Body='Test', ParentId=cg.Id  , Type='TextPost');
            FeeditemTest.add(fid5);

            Feeditem fid6 = new Feeditem(Body='Test', ParentId=cg.Id , Type='LinkPost',LinkUrl='abc');
            FeeditemTest.add(fid6);

            Feeditem fid7 = new Feeditem(Body='Test', ParentId=cg.Id  , Type='ContentPost',ContentData=bodyBlob1 , ContentFileName='test');
            FeeditemTest.add(fid7);

            try{    
                insert FeeditemTest;
            }catch(DmlException e){
                System.debug(e);
            }

        }
    }
}
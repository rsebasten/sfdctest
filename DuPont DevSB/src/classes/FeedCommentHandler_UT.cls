@IsTest
public class FeedCommentHandler_UT
{ 
	static testmethod void FeedCommentHandler_UT(){
		Profile profileId2=[select id from Profile where Name='System Administrator'];
		User user2 =new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='divya_r11@infosys.com',Username='test_User3@dupont.com.test2',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
		insert user2;
		User user1 =new User(LastName='test_User',Alias='tUser',ProfileId=profileId2.id,Email='divya_r11@infosys.com',Username='test_User7@dupont.com.test2',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
		insert user1;
		System.runAs(user2){
			List<Account> accToInsertList = new List<Account>();
			Account accNew1 = new Account(Name='test2Account11', CurrencyISOCode='USD',Country__c='INDIA');
			accToInsertList.add(accNew1);
			Account accnew2 = new Account(Name='test2Account12', CurrencyISOCode='USD',Country__c='INDIA');
			accToInsertList.add(accNew2);
			insert accToInsertList;
			List<Account> accList = new List<Account>([SELECT id, name FROM Account limit2 WHERE Name like 'test2Account11' limit 1]);
			FeedItem feedItemObj1 = new FeedItem(Body = 'hi',parentid=accList[0].id);
			insert feedItemObj1;
			List<FeedComment> feedCommentLoadList = new List<FeedComment>();
			FeedComment feedCommentObj1 = new FeedComment(CommentBody='testing out of office',FeedItemId = feedItemObj1.id);
			insert feedCommentObj1;
			FeedComment feedCommentObj3 = new FeedComment(CommentBody='testing OUT OF THE OFFICE',FeedItemId = feedItemObj1.id);
			insert feedCommentObj3;
			feedCommentLoadList =  [select id from FeedComment where FeedItemId =: feedItemObj1.Id];
			//System.assertEquals(feedCommentLoadList.size(),2);
			try{
				FeedComment feedCommentObj2 = new FeedComment(CommentBody='testing out of office',FeedItemId = feedItemObj1.id);
				insert feedCommentObj2;
			}
			catch(Exception ee){
				//System.Assert(ee.getMessage().contains('Cannot post duplicate comment of the user with out of office string'));
			}
			feedCommentLoadList.clear();
			feedCommentLoadList =  [select id from FeedComment where FeedItemId =: feedItemObj1.Id];
			//System.assertNotEquals(feedCommentLoadList.size(),3);
			FeedComment feedCommentObj5 = new FeedComment(CommentBody='testing',FeedItemId = feedItemObj1.id);
			insert feedCommentObj5;
			feedCommentLoadList.clear();
			feedCommentLoadList =  [select id from FeedComment where FeedItemId =: feedItemObj1.Id];
			//System.assertEquals(feedCommentLoadList.size(),3);
			feedCommentLoadList.clear();
			for(Integer i=0;i<201;i++){
				FeedComment feedCommentObj11 = new FeedComment();
				feedCommentObj11.CommentBody='testing'+i;
				feedCommentObj11.FeedItemId = feedItemObj1.id;
				feedCommentLoadList.add(feedCommentObj11);
			}
			insert feedCommentLoadList;
			feedCommentLoadList.clear();
			feedCommentLoadList =  [select id from FeedComment where FeedItemId =: feedItemObj1.Id];
			//System.assertEquals(feedCommentLoadList.size(),204);
		}
		System.runAs(user1){
			List<Account> accList = [SELECT id, name FROM Account limit2 WHERE Name like 'test2Account11' limit 1];
			List<FeedItem> feedItemId = new List<FeedItem>();
			feedItemId = [Select id from FeedItem where parentid=:accList[0].id limit 1];
			FeedComment feedCommentObj1 = new FeedComment(CommentBody='testing out of office',FeedItemId = feedItemId[0].id);
			insert feedCommentObj1;
			List<FeedComment> feedCommentLoadList1 = new List<FeedComment>();
			feedCommentLoadList1 =  [select id from FeedComment where FeedItemId =: feedItemId[0].Id];
			//System.assertEquals(feedCommentLoadList1.size(),205);			
		}	
	}
}
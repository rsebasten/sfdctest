/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Description: FeedComment trigger handler :
* to avoid duplicate out of office autoreply on a feedPost 
********************************************************************************/
public  class FeedCommentHandler extends TriggerHandlerBase{
	public override void bulkBefore(){
		if (Trigger.isUpdate || Trigger.isInsert)
			handleOutOfOfficeComments(Trigger.new);
	}
	/////////////////////////////////////////////////////////////////////////////////////////
	//method invoked from bulkBefore
	/////////////////////////////////////////////////////////////////////////////////////////
    private void handleOutOfOfficeComments(List<FeedComment> newFeedCommentList){
		try{
			//Filter OUT-OF-OFFICE Comments in trigger.new and group by feedId
			//MAP<feedId,MAP<feedId+hash,FeedComment>>
			MAP<id,MAP<string,FeedComment>> commentsByfeed = new MAP<id,MAP<string,FeedComment>>();
			for(FeedComment fc: newFeedCommentList){
				if (fc.CommentBody.toUpperCase().contains('OUT OF OFFICE') || fc.CommentBody.toUpperCase().contains('OUT OF THE OFFICE')) {
					if (!commentsByfeed.containsKey(fc.FeedItemId))
						commentsByfeed.put(fc.FeedItemId,new MAP<string,FeedComment>());
					string hash=Util.createHash(fc.CommentBody.toUpperCase());
					commentsByfeed.get(fc.FeedItemId).put(fc.FeedItemId+hash+UserInfo.getUserId(),fc);
				}
			}
			//only process if the trigger.new contains an Out-of-office comment
			if (commentsByfeed.size()>0){
				//Get OUT-OF-OFFICE Comments in DB and create hash map to check for dups 
				SET<string> checkDup=new SET<string>();
				for (FeedComment dbfc : [SELECT fc.FeedItemId,fc.CommentBody,fc.InsertedById 
					FROM FeedComment fc WHERE (fc.FeedItemId IN : commentsByfeed.keySet())
					AND (fc.CommentBody LIKE  '%OUT OF OFFICE%' OR fc.CommentBody LIKE '%OUT OF THE OFFICE%')]){
					string hash=Util.createHash(dbfc.CommentBody.toUpperCase()); ///see EncodingUtil...
					checkDup.add(dbfc.FeedItemId+hash+dbfc.InsertedById);
				}
				//only process if the DB contains an Out-of-office comments 
				if(checkDup.size()>0){
				//check for duplicates
				for (id feedId : commentsByfeed.keySet())
					for (string check : commentsByfeed.get(feedId).keySet())
						if(checkDup.contains(check))
							commentsByfeed.get(feedId).get(check).addError('Cannot post duplicate comment of the user with out of office string');
				}
			}
		} 
		catch(Exception e){
			System.debug('Error is '+e.getMessage());
		}
	}
}
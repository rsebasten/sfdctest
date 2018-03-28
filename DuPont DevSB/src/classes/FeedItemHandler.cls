/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Udhuman Gani/Infosys
Email: udhuman.gani@usa.dupont.com
Description:  General handler trigger for Feed Item

TES20130425 Restrict DashboardComponentSnapshot type feeds from User Profiles and Public Groups
Used Chatter Policy Custom Setting for file(s)
 ********************************************************************************/

public with sharing class FeedItemHandler extends TriggerHandlerBase {
	public override void bulkBefore() {
		if (Trigger.isInsert) {
			applyChatterPolicy(Trigger.new);
		}
	}
	
	public static void applyChatterPolicy (LIST<FeedItem> feeds){		
		ChatterPolicy__c policy = ChatterPolicy__c.getInstance(); 
		SET<ID> groupIds = new SET<ID>();
		Schema.DescribeSObjectResult describeCollaborationGroupResult = CollaborationGroup.SObjectType.getDescribe();
		String collaborationGroupPrefix = describeCollaborationGroupResult.getKeyPrefix();
		
		for(FeedItem fid: feeds){
			if(((String)fid.parentid).startswith(collaborationGroupPrefix))
				groupIds.add(fid.ParentId);	
		}
		
		MAP<id,CollaborationGroup> publicGroups = new MAP<id,CollaborationGroup>([
			SELECT id,CollaborationType 
			FROM CollaborationGroup 
			WHERE Id in:groupIds AND CollaborationType = 'Public'
		]);
		
		Schema.DescribeSObjectResult describeUserResult = User.SObjectType.getDescribe();
		String userPrefix = describeUserResult.getKeyPrefix();

		for(FeedItem fid: feeds){			
			boolean isProfileFeed = ((String)fid.Parentid).startswith(userPrefix);		 
			boolean isOwnProfileFeed = (((string)fid.Parentid).contains(UserInfo.getUserId()));
			boolean isPublicGroup = (publicGroups.containsKey(fid.Parentid));
		 
			if(isProfileFeed){			
				if(isOwnProfileFeed) {			  
					if(fid.Type == 'LinkPost' && !policy.Share_Links_on_OwnCP__c)		
						fid.addError(Label.USER_PROFILE_LINKS_NOT_ALLOWED);

					else if(fid.Type == 'ContentPost' && !policy.Share_Files_on_OwnCP__c)		
						fid.addError(Label.USER_PROFILE_FILES_NOT_ALLOWED); 
						
					else if(fid.Type == 'DashboardComponentSnapshot' && !policy.Share_Files_on_OwnCP__c)		
						fid.addError(Label.USER_PROFILE_FILES_NOT_ALLOWED); 
				}

				else if(!isOwnProfileFeed) {
					if(fid.Type == 'TextPost' && !policy.Share_comments_on_otherCP__c) 
						fid.addError(Label.USER_PROFILE_NOT_ALLOWED);				 
					
					else if(fid.Type == 'LinkPost' && !policy.Share_Links_on_OtherCP__c)		
						fid.addError(Label.USER_PROFILE_LINKS_NOT_ALLOWED);

					else if(fid.Type == 'ContentPost' && !policy.Share_Files_on_OtherCP__c)		
						fid.addError(Label.USER_PROFILE_FILES_NOT_ALLOWED); 
						
					else if(fid.Type == 'DashboardComponentSnapshot' && !policy.Share_Files_on_OtherCP__c)		
						fid.addError(Label.USER_PROFILE_FILES_NOT_ALLOWED); 
				}			 
			}						 
			else if(isPublicGroup) {
				if(fid.Type == 'TextPost' && !policy.Share_comments_on_CPG__c)
					fid.addError(Label.PUBLIC_GROUP_NOT_ALLOWED);

				else if(fid.Type == 'LinkPost' && !policy.Share_Links_on_CPG__c)		
					fid.addError(Label.PUBLIC_GROUP_LINKS_NOT_ALLOWED);

				else if(fid.Type == 'ContentPost' && !policy.Share_Files_on_CPG__c)		
					fid.addError(Label.PUBLIC_GROUP_FILES_NOT_ALLOWED); 
					
				else if(fid.Type == 'DashboardComponentSnapshot' && !policy.Share_Files_on_CPG__c)		
					fid.addError(Label.PUBLIC_GROUP_FILES_NOT_ALLOWED);			 
			}		
		}
	}
}
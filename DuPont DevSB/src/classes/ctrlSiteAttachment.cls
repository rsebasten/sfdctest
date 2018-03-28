/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for controller: SiteAttachment
********************************************************************************/
public class ctrlSiteAttachment {
	public 	Attachment 	newAttachment						{ get; set; }
	public  string 		AttMsg	 							{ get; set; }	
	public  string 		parentId							{ get; private set; }
	public  string		Accept								{ get; set; }			
	public  ID			selectAtt							{ get; set; }
	public 	string		invalidContentType					{ get; set; }	
	
	public ctrlSiteAttachment() {
			newAttachment=new Attachment();
			AttMsg=null;
			parentId=null;
			Accept=null;
			selectAtt=null;
			invalidContentType=null;
	}
	private LIST<Attachment> siteAttachments;
///////////////////////////////////////////////////////////////////////////////////////////////	

	public integer totalAttachments {
		GET {
			if (siteAttachments==null)
				refreshAttachments();
			return siteAttachments.size(); 
		}
	}
///////////////////////////////////////////////////////////////////////////////////////////////		
	public LIST<Attachment> Attachments {
	GET { return siteAttachments; }
	}

///////////////////////////////////////////////////////////////////////////////////////////////		
	public void setParentId(string value) {
		parentId = value;
		refreshAttachments(); 
	}
///////////////////////////////////////////////////////////////////////////////////////////////	
	public void deleteAttachment() {
		if (selectAtt!=null) {
			Database.delete(selectAtt);
			selectAtt=null;
		}
		refreshAttachments();
		AttMsg='delete_successful';
	}
///////////////////////////////////////////////////////////////////////////////////////////////	
	public PageReference uploadAttachment() {
		AttMsg='';
		invalidContentType='';
		//Validate a file has been uploaded

		if (newAttachment==null || newAttachment.body==null) {
			AttMsg='file_not_found';
			newAttachment = new Attachment();
			return null;
		}
		
		//Validate ContentType
		Accept=Accept.toLowerCase();
		SET<string> ctypes = Util.splitToSet(Accept,'(,\\s*)');
		if (newAttachment.ContentType==null || (! ctypes.contains(newAttachment.ContentType.toLowercase()) ) ) {
			invalidContentType=newAttachment.ContentType;
			AttMsg='invalid_contenttype';
			newAttachment = new Attachment();
			return null;
		}
		
		if (parentid!=null) {
			try {
				newAttachment.ParentId = parentid;
				insert newAttachment;
				AttMsg='upload_successful';
				refreshAttachments();
			}
			catch (Exception ex ) {
				AttMsg='sorry_for_inconvenience'; //String.valueOf(ex);
			}
		}
		else
			AttMsg='sorry_for_inconvenience';

		newAttachment = new Attachment(); //clear out viewstate (transient will not work)
		return null;
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////			
	private void refreshAttachments() {
		if (parentId!=null) {
			siteAttachments =  new LIST<Attachment>([
				SELECT Id, Name,CreatedDate, CreatedById, ContentType, BodyLength 
				FROM Attachment
				WHERE  CreatedById = : UserInfo.getUserId()
					AND ParentId = :parentId
			]);
				
		}
		else
			siteAttachments = new LIST<Attachment>();
	}


////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////
public static testMethod void testSiteAttachment() {
		geoValidation.DisableGeoValidationOverride=true;
		
		Lead l = new Lead(lastname='tester',company='TestCo');
		insert l;

		Test.startTest();
		ctrlSiteAttachment controller = new ctrlSiteAttachment();
		controller.setParentId(l.id); //init
		controller.Accept='plain/txt';
		
		controller.newAttachment = new Attachment(
		Name='textAtt1',ContentType='plain/txt', Body=blob.valueOf('My File'));
		controller.uploadAttachment();
		
		//This should not get loaded
		controller.newAttachment = new Attachment(
		Name='textAtt2',ContentType='text/html', Body=blob.valueOf('My NonAccepted File'));
		controller.uploadAttachment();
	
		//This should not get loaded
		controller.newAttachment = new Attachment(Name=null,ContentType=null, Body=null);
		controller.uploadAttachment();
	
		for (Attachment att : controller.Attachments)
			system.debug(att);
			
		System.assertEquals(1, controller.totalAttachments);
		controller.selectAtt = controller.Attachments[0].Id;
		controller.deleteAttachment();
		controller.refreshAttachments();
		System.assertEquals(0, controller.totalAttachments);

		Test.stopTest();
	
    }   
}
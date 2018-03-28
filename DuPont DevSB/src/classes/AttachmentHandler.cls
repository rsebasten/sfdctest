/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder,Sreedhar Jagannath
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com sreedhar.jagannath@ind.dupont.com
Description: general trigger Handler

TES20120503 - refactored the Attachment triggers to user the TriggerHandlerBase 
SJAGA2012-Aug-16 - Added Logic to prevent Nomex Portal User to upload attachments to Brand License Qualifications
SJAGA2012-Aug-24 - Extended Logic to prevent Nomex Portal Users to delete Attachments(Invoices) added to Request SObject
SL20130604 - Extended Logic to prevent BI-EMEA Service Center Portal users from deleting the attachments added in Case SObject
 ***********************************************************/
public class AttachmentHandler extends TriggerHandlerBase {

	private static boolean InProcess = false;   //avoid recursion incase another trigger autocreates an Attachment
	//SJAGA2012-Aug-16
	public override void bulkBefore(){
		NomexPreventAttachFile(Trigger.New);
	}

	public override void bulkAfter(){
		if (Trigger.isInsert || Trigger.isUnDelete) {
			if (! InProcess) {
				InProcess=true;
				HasAttachment.ProcessHasNoteOrAttachment(Trigger.new, false, HasAttachment.HAS_ATTACHMENT_FIELD );
				NomexUpdateQualificationDocuments(Trigger.new); 
			}
		}
		if (Trigger.isDelete) {
			HasAttachment.ProcessHasNoteOrAttachment(Trigger.old, true, HasAttachment.HAS_ATTACHMENT_FIELD);
			NomexPreventDelete(trigger.old);
		}
	}   
	/****************************************************************************************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  Update Qualification Documents field if attachment is added to Qualification Object by Member Portal /Nomex Customer Portal User

TES20120503 - refactored the Attachment triggers to user the TriggerHandlerBase ,  this logic was in trigDPT_NomexAttachmentonQualification
	 ***********************************************************/
	private static void NomexUpdateQualificationDocuments(LIST<Attachment> atts){

		Id QUA_FCRTYPE=Rtype.getIdByDevName('Qualification__c','Fabric_Certification');

		DescribeSObjectResult DSR_Q = Qualification__c.SObjectType.getDescribe(); 
		String QualPrefix = DSR_Q.getKeyPrefix();  

		Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];
		List<Attachment> attachment = new List<Attachment>();

		Set<Id> QualIds = new Set<Id>();
		for(Attachment att : atts){
			String temp = (String)att.ParentId;
			if(temp.substring(0,3) == QualPrefix)
				QualIds.add(att.ParentId);
		}

		List<Qualification__c> updatedQualifications = new List<Qualification__c>();                    
		for(Qualification__c q :[Select Id,Owner__c,recordtypeid from Qualification__c  Where Id IN :QualIds]){
			Qualification__c finalquals = q;
			if((prof.Name.contains('wwwroot') || prof.Name.contains('Nomex'))&& (finalquals.recordtypeid == QUA_FCRTYPE)){
				finalquals.Qualification_Documents__c = 'New Unprocessed Document';
				updatedQualifications.add(finalquals);
			}
		}

		update updatedQualifications;         
	}
	/****************************************************************************************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description: Prevent Portal User to upload attachments to Brand License Qualifications
	 ***********************************************************/  
	private static void NomexPreventAttachFile(LIST<Attachment> attachments){
		String QualPrefix = Qualification__c.SObjectType.getDescribe().getKeyPrefix();
		Set<Id> qualids = new Set<Id>();
		for(Attachment attach : attachments){ 
			if(((String)attach.ParentId).substring(0,3) == QualPrefix){
				qualids.add(attach.Parentid);
			}
		} 
		if(qualids.size()>0){
			Id QUA_BLRTYPE=Rtype.getIdByDevName('Qualification__c','BrandLicense');
			Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];
			List<Qualification__c> brandlicensequals = [select id from Qualification__c where Id IN :qualids and RecordTypeid =:QUA_BLRTYPE];
			for(Qualification__c q :brandlicensequals){
				if(brandlicensequals.size()>0 && (prof.Name.contains('Nomex') || (prof.Name.contains('wwwroot')))) {
					for(Attachment att : attachments){
						att.addError('You do not have permission to add attachments for this record');
					}
				}
			}  
		}
	}

	//TES20120503 - Refactored using existing trigger trigAttachmentDelete logic
	private static void NomexPreventDelete(LIST<Attachment> atts) {
		List<String> SObjectPrefix = new List<String>{};
		SObjectPrefix.add(Qualification__c.SObjectType.getDescribe().getKeyPrefix());
		SObjectPrefix.add(Request__c.SObjectType.getDescribe().getKeyPrefix()); //SJAGA2012-Aug-24
		SObjectPrefix.add(Case.SObjectType.getDescribe().getKeyPrefix());//SL20130604
		Set<Id> SObjectids = new Set<Id>();
		for (Attachment att:atts){
			String strparentId = string.valueof(att.ParentId).substring(0,3);
			for(String s:SObjectPrefix){ 
				if(s.startswith(strparentId)){
					SObjectids.add(att.ParentId);
				}
			}
		}
		if(SObjectids.size()>0){
			User user = [select AccessType__c, Id,UserName,Profile.Name from User where Id = :UserInfo.getUserId()]; 
			String CasePrefix = Case.SObjectType.getDescribe().getKeyPrefix(); //SL20130604
			for(Attachment att : atts){
				String strparentId = string.valueof(att.ParentId).substring(0,3);//SL20130604
				if((user.Profile.Name.contains('Nomex')&& !strparentId.contains(CasePrefix))||(user.Profile.Name.contains('BI-EMEA Service Center')&& strparentId.contains(CasePrefix))){
					att.addError(label.Delete_Attachment_Error);
				}
			}
		}
	} 
}
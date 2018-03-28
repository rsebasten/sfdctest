trigger trigAttachmentDelete on Attachment (after delete) {
    String qualKey = 'a0i';
    User user = [select AccessType__c, Id,UserName,Profile.Name from User where Id = :UserInfo.getUserId()];
    if(System.Label.Trigger_On_Off  == 'On'){   
        if(Trigger.isDelete) {
            for (Attachment att: trigger.old){
                String strparentId = string.valueof(att.ParentId).substring(0,3);
                if(strparentId.contains(qualKey)&& (user.Profile.Name.contains('Nomex'))){
                    att.addError(label.Delete_Attachment_Error);
                }
            }
        }
    }
}
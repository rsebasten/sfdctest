public class ctrlPrivacy {
	public boolean Agree {set; get;}
	public User currUser {set; get;}
	public void init() {
		curruser = [Select Id, PrivacyAgreementDate__c from User where id=:UserInfo.getUserId()];
		Agree = ( curruser.PrivacyAgreementDate__c != null );
	}

	public void save() {
		curruser.PrivacyAgreementDate__c=DateTime.now();
		update currUser;
	}
}
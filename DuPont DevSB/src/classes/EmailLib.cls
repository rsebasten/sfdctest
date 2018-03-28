public class EmailLib {


 /*********************************************************************************************************	
	getHeaders
		 returns email Headers in readable text format
 **********************************************************************************************************/
	public static string getHeaders(Messaging.InboundEmail.Header[] headers) {
	  	String rtn='';
	  	if  ( headers != null )
		  	for ( Messaging.InboundEmail.Header h : headers )
		  		rtn += h.name + ':' + h.value + '\n';
	  	return rtn;
	  }
	  
/*********************************************************************************************************	
	AttachHtmlBody
		 if htmlBody then add as attachment
 **********************************************************************************************************/
public static void AttachHtmlBody(string parentId, string htmlBody) {		
		//if html Body as attachment
		if (htmlBody != null && htmlBody.length()>0 ) {
			Attachment a = new Attachment(ParentId = parentId, 
                                          Name = 'MessageBody.html', 
                                          Body = Blob.valueof(htmlBody),
                                          contentType = 'text/html');
			insert a;
		}
}
 /*********************************************************************************************************	
**********************************************************************************************************/
  	  public static void AttachAttachments(string parentId, Messaging.inboundEmail email) {
			//Add Text Attachments
			if (email.textAttachments!=null && email.textAttachments.size() > 0) {
				
				for (integer i = 0 ; i < email.textAttachments.size() ; i++) {
					string contentType = (email.textAttachments[i].mimeTypeSubType.length()>0) ? email.textAttachments[i].mimeTypeSubType : null;
					insert new Attachment(ParentId = parentId, 
                          Name = email.textAttachments[i].filename, 
                          Body = Blob.valueOf(email.textAttachments[i].body),
                          contentType = ContentType);
				}
			}

	 		//Add Binary Attachments
			if (email.binaryAttachments!=null && email.binaryAttachments.size() > 0) {
				
				for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
					string contentType = (email.binaryAttachments[i].mimeTypeSubType.length()>0) ? email.binaryAttachments[i].mimeTypeSubType : null;
					insert new Attachment(ParentId = parentId, 
                          Name = email.binaryAttachments[i].filename, 
                          Body = email.binaryAttachments[i].body,
                          contentType = ContentType);
				}
			}
	  	
	  }
/*********************************************************************************************************	
**********************************************************************************************************/  

	public static Messaging.InboundEmail CreateTestEmail(Messaging.InboundEmailHandler SVCObj, String fromAddress ) {
		return CreateTestEmail(SVCObj, fromAddress, 'test subject...', 'test body...');
	}
	public static Messaging.InboundEmail CreateTestEmail(Messaging.InboundEmailHandler SVCObj, String fromAddress, String subject ) {
		return CreateTestEmail(SVCObj, fromAddress, subject, 'test body...');
	}
	public static Messaging.InboundEmail CreateTestEmail(Messaging.InboundEmailHandler SVCObj, String fromAddress, String subject, String body ) {
		// Create a new email, envelope object and Attachment
	   Messaging.InboundEmail email = new Messaging.InboundEmail();
	   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	   Messaging.InboundEmail.BinaryAttachment bAtt = new Messaging.InboundEmail.BinaryAttachment();
	   Messaging.InboundEmail.textAttachment tAtt = new Messaging.InboundEmail.textAttachment();
	   Messaging.InboundEmail.Header header = new Messaging.InboundEmail.Header();
	   email.subject = subject; //'testing...';
	   email.fromName = 'from Name';
	   email.PlainTextBody=body; //'test';
	   email.htmlBody = '<H1>TEST</H1>';
	   email.fromAddress = fromAddress;
	   env.fromAddress = fromAddress;
	   
	   header.name='XTest';
	   header.value='true';
	   email.headers=new Messaging.InboundEmail.Header[]{header};
     
	   // set the body of the attachments
	   bAtt.body = blob.valueOf('test binary');
	   bAtt.fileName = 'test binary attach';
	   bAtt.mimeTypeSubType = 'plain/txt';
	   tAtt.body = EmailLib.getHeaders(email.headers);
	   tAtt.fileName = 'test text attach';
	   tAtt.mimeTypeSubType = 'text';
	   
	   email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {bAtt }; 
	   email.textAttachments = new Messaging.inboundEmail.textAttachment[] {tAtt }; 
	   
	   //emailReachInbound emailServiceObj = new emailReachInbound();
	   SVCObj.handleInboundEmail(email, env );
	   
	   return email;
	}
/*********************************************************************************************************	
**********************************************************************************************************/
	 /*
	  private class parseEmail {
	  	public string firstName {set;get;}
	  	public string lastName {set;get;}
	  	
	  	parseEmail(string value) {
	  		//is email?
	  		if (value.indexOf('@')>0) {
	  			value=value.substring(value.indexOf('@')+1,value.length());
	  			string[] arr = value.split('.',-2);
	  			firstName = arr[0];
	  			lastName  = arr[arr.size()-1];
	  		}
	  		else {
	  			string[] arr = value.split(' ',-2);
	  			firstName = arr[0];
	  			lastName  = arr[arr.size()-1];
	  		}	
	  	}
	  }
	  */
	  
/*********************************************************************************************************/
  	
static testMethod void test1() {
    Test.startTest();
    EmailLib.CreateTestEmail(new emailPQRInbound(),'test@dupont.com');
    Test.stopTest();
}
	
	
}
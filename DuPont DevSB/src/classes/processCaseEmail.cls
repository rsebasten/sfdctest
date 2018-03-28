/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Pranitha S
Email: Pranitha_S@infosys.com
Description:  Class for email service to capture user email response in salesforce
** ============================================================================= 
* Ver   Date        Author               Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.1   14-Apr-15  Isha Taneja     Updated Task Owner to be set as Case Owner
<IT 20150414>
 *****************************************************************************/
 
global class processCaseEmail implements Messaging.InboundEmailHandler {


 global Messaging.InboundEmailResult handleInboundEmail(
  Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

String subject  = email.subject.substring(0,8);
String myPlainText= '';
myPlainText = email.plainTextBody;
Task newTask = new Task();
Case emailCase;
emailCase = [select ID,Description,OwnerId from Case where CaseNumber =
             :subject limit 1];

/*<IT 20150414> Added OwnerId to be set to Case Owner*/             
newTask  = new Task(Description =  myPlainText,
           Priority = 'Low',
           Status = 'Close',
           Subject = email.subject,
           IsReminderSet = false,
           WhatId =  emailCase.Id,
           OwnerId = emailCase.OwnerId);
     insert newTask; 
 

if (email.binaryAttachments != null){
for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments)
{

Attachment a = new Attachment(ParentId = newTask.Id,
Name = bAttachment.filename,
Body = bAttachment.body);
insert a;
  }
  }
 result.success = true;
return result;
}
    
}
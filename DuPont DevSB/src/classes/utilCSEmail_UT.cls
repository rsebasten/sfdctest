@isTest
/******************************************************************************* 
Copyright ? 2015 DuPont. All rights reserved. 
Author: Prerna Chandak 
Email: prerna.chandak@accenture.com
Last Modified: sanchit.dua@accenture.com - 15/5/2015
Description: Utility class
********************************************************************************/

public class utilCSEmail_UT {

    private static final List<String> PLACEHOLDERS = new List<String>{
        '{"erpIdWithMsg":{},"erpIds":["a1B180000000HXyEAM","a1B180000000OZbEAM","a1B180000000HaxEAE","a1B180000000Oa3EAE","a1B180000000OJOEA2","a1B180000000ECcEAM","a1B180000000X93EAE","a1B180000000OZzEAM"],"consolidatedMsgs":[],"commonMessages":["Required fields are missing: [BillingAddressAccuracy__c]"]}',
        '{"erpIdWithMsg":{"a1B180000000HXyEAM": "Hey There!"},"erpIds":["a1B180000000HXyEAM","a1B180000000OZbEAM","a1B180000000HaxEAE","a1B180000000Oa3EAE","a1B180000000OJOEA2","a1B180000000ECcEAM","a1B180000000X93EAE","a1B180000000OZzEAM"],"consolidatedMsgs":[],"commonMessages":["Required fields are missing: [BillingAddressAccuracy__c]"]}',
        '{"erpIdWithMsg":{},"erpIds":[],"consolidatedMsgs":[],"commonMessages":[]}',
        '{"erpIdWithMsg":{},"erpIds":[],"consolidatedMsgs":[],"commonMessages":[]}',
        '{"erpIdWithMsg":{},"erpIds":["a1B180000000HXyEAM","a1B180000000OZbEAM","a1B180000000HaxEAE","a1B180000000Oa3EAE","a1B180000000OJOEA2","a1B180000000ECcEAM","a1B180000000X93EAE","a1B180000000OZzEAM"],"consolidatedMsgs":[{"erpId":"abc", "errMsg": "Hey There"}],"commonMessages":["Required fields are missing: [BillingAddressAccuracy__c]"]}',
        '{"erpIdWithMsg":{},"erpIds":[],"consolidatedMsgs":[],"commonMessages":[]}'
    };

    /* Method to create test User */
    testmethod public static  User user(){
        User user = NULL;
        
        try{
            Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1];         
            user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', 
                              LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                              ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', 
                              UserName='testuserdev@testaAcc.com'); 
        } catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
         }
        return user;
    }

    /* This method creates a Contact with an Account*/
    testmethod public static Contact createContact(){
        Contact contact = null;
        try{
            List<RecordType> rt = [select id,Name from RecordType where SobjectType='Account' and Name='ERP Customer' Limit 1];
            Account account = new Account(name = 'Test Account',Status__c = 'Active');
            if(rt <>null && rt.size()>0){
                account.recordTypeId = rt[0].id;
            }           
            database.insert(account);   
            
            List<RecordType> contactRecType = [select id,Name from RecordType where SobjectType='Contact' and Name='CS-Contact' limit 1];        
            contact = new Contact(lastname = 'DuPont Customer Service', AccountID=account.id);   
            if(contactRecType <>null && contactRecType.size()>0){
                contact.recordTypeId = contactRecType[0].id;
            }               
            contact.email = 'test@test.com';
            database.insert(contact); 
        } catch(Exception ex){
             system.debug('Exception occured...'+ex);
            }
        return contact;       
    }
    


    /* Method to create test data for custom setting with Order record type. */
    testmethod public static  CS_EmailAddressSettings__c newOrder(){
        CS_EmailAddressSettings__c csEmail1 = NULL;
        try{
            csEmail1 = new CS_EmailAddressSettings__c();
            csEmail1.CS_Region__c = 'Global';
            csEmail1.CS_RequestType__c = 'New Order';
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            csEmail1.name = envelope.toAddress.substring(0,envelope.toAddress.indexOf('@'));
            database.insert(csEmail1);   
        }catch(Exception ex){
            system.debug('Exception occured...'+ex.getMessage());
            }
        return csEmail1;
    }

    /* Method to create test data for custom setting with Service Request record type. */
    testmethod public static  CS_EmailAddressSettings__c newServieRequest(){
        CS_EmailAddressSettings__c csEmail1 = NULL;
        try{
            csEmail1 = new CS_EmailAddressSettings__c();
            csEmail1.CS_Region__c = 'Global';
            csEmail1.CS_RequestType__c = 'New Service Request';
            Messaging.InboundEnvelope envelope = utilCSEmail_UT.envelope();
            csEmail1.name = envelope.toAddress.substring(0,envelope.toAddress.indexOf('@'));
            database.insert(csEmail1);    
        } catch(Exception ex){ 
            system.debug('Exception occured...'+ex.getMessage());
            }
        return csEmail1;
    }
  
     /* Method to create test data for custom setting with Accont load values. */
     testmethod public static  CS_Account_Load_Settings__c accountLoadSettings(){
        CS_Account_Load_Settings__c accs = NULL;
        try{
            accs = new CS_Account_Load_Settings__c();
            accs.name = 'Test Batch';
            accs.AccountGroup__c= 'Z001 ( Sold-to party )';
            accs.AccountOwner__c= 'Customer Service';
            accs.AccountOwnerUserName__c= 'testUser@test.com';
            accs.RecordType_Name__c= 'ERP Customer - Extended Data';
            accs.SendErrorNotificationTo__c = 'testuser@test.com';
            database.insert(accs);
        } catch(Exception ex){
          system.debug('Exception occured...'+ex.getMessage());
         }
        return accs;
    }
    
    
    /* This method creates an inbound email. */
    testmethod public static  Messaging.InboundEmail email(){
        Messaging.InboundEmail email = NULL;
        try{
            email = new Messaging.InboundEmail();
            Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    
            email.plainTextBody = 'Test Class Sample Email';            
            email.fromAddress ='test@test.com';                       
            
            String contactEmail = 'testi_inbounnd@testing.email';            
            email.ccAddresses = new String[] {'Test Address <' + contactEmail + '>'};        
            email.subject = 'Dummy Case name 123 [ ref: asdjsaklf :ref ]';                 
            email.plainTextBody = 'Test Class Sample Email [ ref: asdjsaklf :ref ]';
            email.fromAddress ='test@test.com';
            
            inAtt.body = blob.valueOf('test');
            inAtt.fileName = 'my attachment name';
            inAtt.mimeTypeSubType = 'plain/txt';
            
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
            attachmenttext.body = 'my attachment text';
            attachmenttext.fileName = 'textfiletwo3.txt';
            attachmenttext.mimeTypeSubType = 'texttwo/plain';
              
            email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
            utilCSEmailService.handleThreadEmail(email);
            //utilCSEmailService.getCaseRecordFromThreadId(email.subject);
        } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
         }
        return email;
        
    }
    
    /* This method creates an inbound email. */
    testmethod public static  Messaging.InboundEmail emailwithNullSubject(){
        Messaging.InboundEmail email = NULL;
        try{
            email = new Messaging.InboundEmail();
            Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    
            String contactEmail = 'testi_inbounnd@testing.email';            
            email.ccAddresses = new String[] {'Test Address <' + contactEmail + '>'};        
            email.subject = null;                 
            email.plainTextBody = 'Test Class Sample Email [ ref: asdjsaklf :ref ]';
            email.fromAddress ='test@test.com';
            
            inAtt.body = blob.valueOf('test');
            inAtt.fileName = 'my attachment name';
            inAtt.mimeTypeSubType = 'plain/txt';
            
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
            attachmenttext.body = 'my attachment text';
            attachmenttext.fileName = 'textfiletwo3.txt';
            attachmenttext.mimeTypeSubType = 'texttwo/plain';
              
            email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            utilCSEmailService.handleThreadEmail(email);
            //utilCSEmailService.getCaseRecordFromThreadId(email.subject);
        } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
         }
        return email;
        
    }
    /* This method creates an inbound email with html text. */
    testmethod public static  Messaging.InboundEmail emailhtml(){
        Messaging.InboundEmail email = NULL;
        try{
            email = new Messaging.InboundEmail();
            Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    
            email.htmlBody= 'test';            
            email.fromAddress ='test@test.com';                       
            
            String contactEmail = 'testi_inbounnd@testing.email';            
            email.ccAddresses = new String[] {'Test Address <' + contactEmail + '>'};        
            email.subject = 'Dummy Case name 123 [ ref: asdjsaklf :ref ]';                 
            email.plainTextBody = '';
            email.fromAddress ='test@test.com';
            
            inAtt.body = blob.valueOf('<html><body>test</body></html>');
            inAtt.fileName = 'my attachment name';
            inAtt.mimeTypeSubType = 'html/txt';
            
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
            attachmenttext.body = 'my attachment text';
            attachmenttext.fileName = 'textfiletwo3.txt';
            attachmenttext.mimeTypeSubType = 'text/html';
              
            email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            utilCSEmailService.handleThreadEmail(email);
            //utilCSEmailService.getCaseRecordFromThreadId(email.subject);
        } catch(Exception ex){
             system.debug('Exception occured...'+ex.getMessage());
         }
        return email;
        
    }
    
    /* This method creates an inbound envelope*/
    testmethod public static  Messaging.InboundEnvelope envelope(){
        Messaging.InboundEnvelope envelope = NULL;
        try{
            envelope = new Messaging.InboundEnvelope(); 
            Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
            envelope.fromAddress ='test@test.com';            
            envelope.toAddress ='order.test@test.com'; 
        } catch(Exception ex){
         system.debug('Exception occured...'+ex.getMessage());
         }
        return envelope;
    }
    
    /* Method to create test data for custom setting SVMXListSettings. */
    testmethod public static  void cSetting(){
        
     
        try{
            
            Set<String> testString = new Set<String> ();
            testString.add('WarrantyLA');
            testString.add('ContractLA');
            testString.add('BillableEMEA');
            testString.add('WarrantyEMEA');
            testString.add('Hardware ServiceEMEA');
            testString.add('Hardware SalesEMEA');
            testString.add('ContractEMEA');
            testString.add('Uptime ContractTypeEMEA');
            testString.add('Uptime ContractEMEA');
/*PKH        
            List<SVMXListSettings__c> csSVMXList = new List<SVMXListSettings__c>(); 
            List<SVMXListSettings__c> csSVMX = [select id,name,Static_Value__c from SVMXListSettings__c where Name IN:testString limit 1];
            Map<String,SVMXListSettings__c> csMap = new Map<String,SVMXListSettings__c>();        
            if(csSVMX <> null && csSVMX.size()>0){
                for(SVMXListSettings__c cSVMXList: csSVMX ){
                    csMap.put(cSVMXList.name,cSVMXList);
                }
            }
            
            if(!csMap.containsKey('WarrantyLA')){
                SVMXListSettings__c csSVMXc1 = new SVMXListSettings__c(name='WarrantyLA',Static_Value__c='Warranty');
                csSVMXList.add(csSVMXc1);
            }
            if(!csMap.containsKey('ContractLA')){
                SVMXListSettings__c csSVMXc2 = new SVMXListSettings__c(name='ContractLA',Static_Value__c='Contract');
                csSVMXList.add(csSVMXc2 );   
            }            
            if(!csMap.containsKey('BillableEMEA')){
                SVMXListSettings__c csSVMXc3 = new SVMXListSettings__c(name='BillableEMEA' ,Static_Value__c='Billable');            
                csSVMXList.add(csSVMXc3 );                    
            }            
            if(!csMap.containsKey('WarrantyEMEA')){
                SVMXListSettings__c csSVMXc4 = new SVMXListSettings__c(name='WarrantyEMEA' ,Static_Value__c='Warranty');            
                csSVMXList.add(csSVMXc4 );
            }            
            if(!csMap.containsKey('Hardware ServiceEMEA')){
                SVMXListSettings__c csSVMXc5 = new SVMXListSettings__c(name='Hardware ServiceEMEA' ,Static_Value__c = 'Hardware Service'); 
                csSVMXList.add(csSVMXc5 );
            }            
            if(!csMap.containsKey('Hardware SalesEMEA')){
                SVMXListSettings__c csSVMXc6 = new SVMXListSettings__c(name='Hardware SalesEMEA',Static_Value__c = 'Hardware Sales'); 
                csSVMXList.add(csSVMXc6 );
            }            
            if(!csMap.containsKey('ContractEMEA')){
                SVMXListSettings__c csSVMXc7 = new SVMXListSettings__c(name='ContractEMEA' ,Static_Value__c='Contract');            
                csSVMXList.add(csSVMXc7 );
            }            
            if(!csMap.containsKey('Uptime ContractTypeEMEA')){
                SVMXListSettings__c csSVMXc8 = new SVMXListSettings__c(name='Uptime ContractTypeEMEA',Static_Value__c='Uptime ContractType');
                csSVMXList.add(csSVMXc8 );
            }            
            if(!csMap.containsKey('Uptime ContractEMEA')){
                SVMXListSettings__c csSVMXc9 = new SVMXListSettings__c(name='Uptime ContractEMEA' ,Static_Value__c='Lease');
                csSVMXList.add(csSVMXc9 );
            }
PKH*/            
        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
//PKH        database.insert(csSVMXList);    
    }

    /* Method to create test data for Case with Account. */
    testmethod public static  Case caseWithAccount(){
        Case emailToCase = NULL;
        try{
            utilCSEmail_UT.cSetting();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Internal_Request_Cases_Per_Day__c='10',Cases_Per_Account_Per_Day__c ='10',
                                                                        Unassigned_Cases_Per_Day__c='10');
            database.insert(unassignedLimit);
    
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            
            emailToCase = new Case();
               emailToCase.AccountID=utilCSEmail_UT.createContact().AccountId;
                emailToCase.Subject = email.Subject;
                emailToCase.Description = email.plainTextBody;
                emailToCase.Origin = 'Fax';
                emailToCase.CaseCategory__c='New Order';
                emailToCase.SuppliedEmail = email.fromAddress;
                database.insert(emailToCase);
                
        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
        return emailToCase;
    }

    /* Method to create test data for a list of case with Account. */
    testmethod public static  List<Case> caseWithAccountList(){

        List<Case> cList = new List<Case>();
        try{
            utilCSEmail_UT.cSetting();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Cases_Per_Account_Per_Day__c ='10',
                                                                        Unassigned_Cases_Per_Day__c='10');
            database.insert(unassignedLimit);
    
            Messaging.InboundEmail email = utilCSEmail_UT.email();
            
            
            String toAdd = 'test.order@test.com';
           // String fromAdd = 'abc@test.com';
            Id acId = utilCSEmail_UT.createContact().AccountId;
                Case emailToCase = new Case();
                for(Integer i=0;i<=8;i++){
                    emailToCase = new Case();        
                    emailToCase.AccountID= acId;
                    emailToCase.Subject = email.Subject;
                    emailToCase.Description = email.plainTextBody;
                    emailToCase.Origin = 'Fax';
                    emailToCase.CaseCategory__c='New Order';
                    emailToCase.SuppliedEmail = email.fromAddress;
                    cList.add(emailToCase);
            }
            database.insert(cList);
            emailCSDenialOfServiceHelper.sendEmail(emailToCase.id, emailToCase.SuppliedEmail ,  toAdd );
        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
        return cList;
    }
    
     /* Method to create test data for a list of case with Account. */
     testmethod public static  List<Case> caseWithoutAccountList(){

        List<Case> cList = new List<Case>();
        String toAdd = 'test.order@test.com';
        try{
            utilCSEmail_UT.cSetting();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Cases_Per_Account_Per_Day__c ='10',
                                                                        Unassigned_Cases_Per_Day__c='10');
            database.insert(unassignedLimit);
            Messaging.InboundEmail email = utilCSEmail_UT.email();

                Case emailToCase ;
                for(Integer i=0;i<=8;i++){
                    emailToCase = new Case();    
                    emailToCase.Subject = email.Subject;
                    emailToCase.Description = email.plainTextBody;
                    emailToCase.Origin = 'Fax';
                    emailToCase.CaseCategory__c='New Order';
                    emailToCase.SuppliedEmail = email.fromAddress;
                    cList.add(emailToCase);
                 }
            database.insert(cList);
            emailCSDenialOfServiceHelper.sendEmail(emailToCase.id, emailToCase.SuppliedEmail, toAdd );
        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
        return cList;
    }

     /* Method to create test data for Case without Account. */
     testmethod public static  Case caseWithoutAccount(){
        Case emailToCase = new Case();
        String toAdd = 'test.order@test.com';
           try{
            utilCSEmail_UT.cSetting();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Cases_Per_Account_Per_Day__c ='10', 
                                                                        Unassigned_Cases_Per_Day__c='10');
            insert unassignedLimit;
    
            Messaging.InboundEmail email = utilCSEmail_UT.email();
               emailToCase.Subject = email.Subject;
                emailToCase.Description = email.plainTextBody;
                emailToCase.Origin = 'Fax';
                emailToCase.SuppliedEmail = email.fromAddress;
                insert(emailToCase);
                emailCSDenialOfServiceHelper.sendEmail(emailToCase.id, emailToCase.SuppliedEmail, toAdd);

        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
        return emailToCase;
    }
    /* Method to create test data for Case without Account. */
     testmethod public static  Case caseWithoutAccountWithNullSubject(){
        Case emailToCase = new Case();
        String toAdd = 'test.order@test.com';
           try{
            utilCSEmail_UT.cSetting();
            CS_Email_Limits__c unassignedLimit = new CS_Email_Limits__c(name='Limits',Cases_Per_Account_Per_Day__c ='10', 
                                                                        Unassigned_Cases_Per_Day__c='10');
            insert unassignedLimit;
    
                Messaging.InboundEmail email = utilCSEmail_UT.emailwithNullSubject();
                emailToCase.Subject = email.Subject;
                emailToCase.Description = email.plainTextBody;
                emailToCase.Origin = 'Fax';
                emailToCase.SuppliedEmail = email.fromAddress;
                insert(emailToCase);
                emailCSDenialOfServiceHelper.sendEmail(emailToCase.id, emailToCase.SuppliedEmail, toAdd);

        } catch(Exception ex){
         system.debug('Exception occured...'+ex);
         }
        return emailToCase;
    }
    
    /*
     * Test Method
     */
    testmethod private static void finishEmailTest(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(0), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', true);
    } // END testmethod private static void finishEmailTest()
    /*
     * Test Method
     */
    testmethod private static void finishEmailTestFlow2(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(1), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', true);
    } // END testmethod private static void finishEmailTest()
    
    /*
     * Test Method
     */
    testmethod private static void finishEmailTestFlow3(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(2), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', true);
    } // END testmethod private static void finishEmailTest()
    
    /*
     * Test Method
     */
    testmethod private static void finishEmailTestFlow4(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(3), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', false);
    } // END testmethod private static void finishEmailTest()
    
    /*
     * Test Method
     */
    testmethod private static void finishEmailTestFlow5(){
        CS_Account_Load_Settings__c settingRecord = utilCSBatchAccountLoad_UT.createAccountLoadSettingRecord();
        insert settingRecord;
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(4), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', false);
    } // END testmethod private static void finishEmailTest()
    
    /*
     * Test Method
     */
    testmethod private static void finishEmailTestFlow6(){
        
        UtilCSBatchErrorLog uce = (UtilCSBatchErrorLog) JSON.deserialize(PLACEHOLDERS.get(5), UtilCSBatchErrorLog.class);
        utilCSEmail.finishEmail(uce, 'Abc', false);
    } // END testmethod private static void finishEmailTest()
    
}
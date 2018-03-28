/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Helper class for AUA Confirmation Page
//<AB20160808>  - Changes to prepopulate the SFAR form page from custom setting rather than tooling api
//<AB20160811> - Changes to auto submit SFAR for approval
//<AB20160826> - Changes to maintain confirmation page state after creation of multiple SFARs
//AB20161227 - Updated for UAR enhancements
//1.    Text filters by Role, Profile (may actually be done with the name search that Abhinav is currently doing)
//2.    Grid Improvements - Keep the header in place when scrolling (Deferred)
//3.    Verify if Column Picker is used or if that could be removed to allow for more screen real estate.
//4.    Record Count improvements - have the count change based on the # of records returned with the filters (not just their overall total records to be reviewed)
//5.    Add Lookup to CRM IT Project on the UAR object.  TCS could then attach the yearly UAR CRM IT Project to the header record.  Then attach that CRM IT Project to all SFARs that are created from this process (this would make for an easy way to monitor all SFARs created from this process)
//6.    NOT REQUIRED NOW --- Add ability to re-assign Approving Business (this may not be needed when new Orgs are created as this will be easier to manage)
//7.    Deactivation email - show the correct Org (currently it always shows OneDuPont)
********************************************************************************/

public class AUAConfirmationPageHelper {
    public String changedAS { get; set; }
    public List<sObject> ObjectList{get;set;}
    public List<User_Access_Review_Details__c> changedUARDS{get;set;}
    public List<User_Access_Review_Details__c> dataOfChangedUARDS{get;set;}
    public List<User_Access_Review_Details__c> dataOfApprovedUARDS{get;set;}
    public List<User_Access_Review_Details__c> dataOfModifyUARDS{get;set;}
    public List<User_Access_Review_Details__c> dataOfDeActivateUARDS{get;set;}
    private Map<String, AUA_SFARFieldIdMapping__c> mapOfCustomSettings; //<AB20160808>
    
    public List<columsdata> columnLabels{ get; set; }
    public String createSFARForId{ get; set; }
    public Id SFARAccessRequestObjectId{get; set;}
    public Map<String,Id> SFARAccessRequestFieldsIds{get; set;}
    public boolean disableSendMailBtn{get; set;}
    public String SFARURL{get; set;}
    public String isApprovalDoneProp{get; set;}
    public String isMailSentProp{get; set;}
    public Set<String> idsUARDRecordSFARCreated{get; set;}
    public String uarid{get; set;}
    
    private static final String SFAROBJECT = 'SFDC_Access_Request';
    private static final String NEWLYCREATEDRECORDID = 'newid';
    private static final String RECORDID = 'RecId';
    private static final String RECORDSDELIMITER = ';;';
    private static final String FIELDSDELIMITER = '@@';
    private static final String BLANK = '';
    private static final String DUPONTINSTANCE = 'DuPont';
    private static final String UTILITYINSTANCE = 'Util';
    private static final String PIONEERUSER = 'Pioneer';
    private static final String BCCEMAILADDRESS = '';
    private static final String MAILSENDERDISPLAYNAME = 'User Access Review Approver';
    private static final String MAILSUBJECT = 'Salesforce.com User Access Review – Access Removal';
    private static final String APPROVED = 'Approved';
    private static final String MODIFY = 'Modify';
    private static final String DEACTIVATE = 'De-Activate';
    private static final String COMMADELIMITER = ',';
    private static final String HEADERAUTHORIZATION = 'Authorization';
    private static final String HEADERBEARER = 'Bearer ';
    private static final String HEADERCONTENTTYPE = 'Content-Type';
    private static final String HEADERJSON = 'application/json';
    private static final String ENDPOINT = '/services/data/v36.0/tooling/query/?q=Select+Id,+DeveloperName,+NamespacePrefix,+TableEnumOrId+From+CustomField+Where+TableEnumOrId+=+\'';
    private static final String ENDPOINTSFDCACCESSREQUEST = '/services/data/v36.0/tooling/query/?q=Select+Id,+DeveloperName,+NamespacePrefix+From+CustomObject+Where+DeveloperName+=+\'SFDC_Access_Request\'';
    private static final String GET = 'GET';
    private static final String YES = 'True';
    private static final String NO = 'False';
    private static final String ISAPPROVALDONE = 'isApprovalDone';
    private static final String ISMAILSENT = 'isMailSent';
    private static final String COMMA = ',';
    private static final String SPACE = ' ';
    private static final String CustomField = 'CF';
    
    
    public AUAConfirmationPageHelper(){
        initializeValues();
        initializeReadyState();             
    }
    
    public void initializeValues(){
        changedUARDS = new List<User_Access_Review_Details__c>();//AB20161227
        changedAS = ApexPages.currentPage().getParameters().get('ChangedAS');
        uarid = ApexPages.currentPage().getParameters().get('uarid');
        
        mapOfCustomSettings = AUA_SFARFieldIdMapping__c.getAll();//<AB20160808>
        
        columnLabels = new List<columsdata>();
        columnLabels.add(new columsdata('User Name','User_Name__c') );
        columnLabels.add(new columsdata('Email','User_Email_Id__c') );
        columnLabels.add(new columsdata('ePass','User_ePass_Id__c') );
        columnLabels.add(new columsdata('User Type','User_Type__c') );
        columnLabels.add(new columsdata('Org','Org__c') );
        columnLabels.add(new columsdata('Country','User_Country__c') );
        columnLabels.add(new columsdata('Region','User_Region__c') );
        
        dataOfApprovedUARDS = new List<User_Access_Review_Details__c>();
        dataOfModifyUARDS = new List<User_Access_Review_Details__c>();
        dataOfDeActivateUARDS = new List<User_Access_Review_Details__c>();
        
        idsUARDRecordSFARCreated = new Set<String>();
        
    }
    
    public void initializeReadyState(){
        getRedirectionStatus();        
        getChangedRecords();
        getDataforChangedUARDS();
        getUARDSByApprovalStatus();       
        
        getidsUARDRecordSFARCreated();
    }
    
    public void getidsUARDRecordSFARCreated(){
        String pageURL = ApexPages.currentPage().getURL();
        pageURL = pageURL==null?'':pageURL;
        String[] queryStringTokens = EncodingUtil.urlDecode(pageURL, 'UTF-8').split('&'); //AB20160826
        //pageURL.replaceAll('%26', '&').replaceAll('%3D','=').replaceAll('%2C',',').split('&');
        for(String queryStringToken: queryStringTokens){
            System.debug('=========>>>>>>>> '+queryStringToken);
            //AB26082016 Start
            if(queryStringToken.containsIgnoreCase('RecId')&&queryStringToken.split('=').size()>0){
                System.debug('RecId all=========>>>>>>>> '+queryStringToken+'     '+queryStringToken.split('=')[1]);
                String[] oldrecTokens = queryStringToken.split('=')[1].split(',');
                for(String recToken: oldrecTokens){ 
                    idsUARDRecordSFARCreated.add(recToken);
                }
            }
            //AB26082016 End
        }
    }
    public void getRedirectionStatus(){
        isApprovalDoneProp = ApexPages.currentPage().getParameters().get(ISAPPROVALDONE);
        isMailSentProp = ApexPages.currentPage().getParameters().get(ISMAILSENT);        
        isApprovalDoneProp = (isApprovalDoneProp!=null && isApprovalDoneProp!='False')?YES:NO;
        isMailSentProp = (isMailSentProp!=null && isMailSentProp!='False')?YES:NO;
        if(isApprovalDoneProp==YES){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Users in Approved section are approved now.');
            ApexPages.addMessage(myMsg);            
        }
        
        if(isMailSentProp==YES){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Emails are sent to users in De-Activate section to respond to their account de-activation request.');
            ApexPages.addMessage(myMsg);            
        }
    }
    
    public void dmlOperation(){
        if(ApexPages.currentPage().getParameters().get(NEWLYCREATEDRECORDID)!=null){
            SFDC_Access_Request__c newSFARRecord = [SELECT name,user__r.UserName,id,user__r.Name FROM SFDC_Access_Request__c where id =: ApexPages.currentPage().getParameters().get(NEWLYCREATEDRECORDID)] ;
            
            //<AB20160811> Start
            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
            app.setObjectId(newSFARRecord.id);
            Approval.ProcessResult result = Approval.process(app);
            //<AB20160811> End
            
            
            
            User_Access_Review_Details__c uardToBeUpdated;
            for(User_Access_Review_Details__c dataOfModifyUARD:dataOfModifyUARDS){
                if(dataOfModifyUARD.id==ApexPages.currentPage().getParameters().get(RECORDID).split(',')[0]){  
                    uardToBeUpdated = dataOfModifyUARD;
                    break;
                }
            }
            uardToBeUpdated.description__c = (uardToBeUpdated.description__c==null)?  'Approval Status: Modify Access, SFAR - '+newSFARRecord.name+' Record Entry On - '+DateTime.Now() : uardToBeUpdated.description__c+' & Approval Status: Modify Access, SFAR - '+newSFARRecord.name+' Record Entry On - '+DateTime.Now();
            uardToBeUpdated.Approval__c = 'Modify';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Last SFAR Created: SFAR No. '+newSFARRecord.name+' has been created successfully, for user - '+newSFARRecord.User__r.UserName);
            ApexPages.addMessage(myMsg); 
            update  uardToBeUpdated;
        }        
    }
    
    
    public void getChangedRecords(){
        List<String> changedRecords = changedAs.split(RECORDSDELIMITER);
        Boolean isUnique = true;//AB20161227
        
        for(String record:changedRecords){
            List<String> fields = record.split(FIELDSDELIMITER);
            if(fields.get(0)!=null && fields.get(0)!=BLANK){
        //AB20161227 Start
                for(User_Access_Review_Details__c changedUARD:changedUARDS){
                    if(changedUARD.id==fields.get(0)){
                        isUnique=false;
                    }
                }
                if(isUnique){
        
                changedUARDS.add(new User_Access_Review_Details__c(id=fields.get(0),Approval__c=fields.get(2),Approver__c =UserInfo.getUserId(),Review_Date__c = Date.Today()));
                }
                isUnique = true;//AB20161227 End
            }
        }
    }
    
    public void getDataforChangedUARDS(){
        List<Id> changedUARDSIDs = new List<Id>();
        for(User_Access_Review_Details__c uard: changedUARDS){
            changedUARDSIDs.add(uard.id);
        }
        dataOfChangedUARDS = [SELECT Approval__c,Approver__c,Audit_Process__c,CompanyName__c,CreatedById,CreatedDate,Description__c,Id,LastActivityDate,LastModifiedById,LastModifiedDate,Name,Org__c,Program__c,Review_Date__c,User_Country__c,User_Email_Id__c,User_ePass_Id__c,User_Grouping__c,User_Id__c,User_Name__c,User_Owning_Org__c,User_Owning_SBU_Org__c,User_Permission_Sets__c,User_Profile__c,User_Public_Group__c,User_Region__c,User_Roles__c,User_Type__c,Approving_Business__c,User_Access_Type__c  FROM User_Access_Review_Details__c where id in : changedUARDSIDs];
    }
    
    public void getUARDSByApprovalStatus(){
        for(User_Access_Review_Details__c docuard: dataOfChangedUARDS){
            for(User_Access_Review_Details__c cuard: changedUARDS){
                if(docuard.id==cuard.id){
                    docuard.Approval__c = cuard.Approval__c;
                    docuard.Approver__c = cuard.Approver__c;
                    docuard.Review_Date__c = cuard.Review_Date__c;
                    
                    if(cuard.Approval__c==APPROVED){      
                        docuard.Description__c =(docuard.Description__c==null)?'Approval Status: Approved Access, SFAR - Not Required. Record Entry On - '+DateTime.Now() : docuard.Description__c+' & Approval Status: Approved Access, SFAR - Not Required. Record Entry On - '+DateTime.Now();
                        dataOfApprovedUARDS.add(docuard);                        
                    }else if(cuard.Approval__c==MODIFY){
                        dataOfModifyUARDS.add(docuard);   
                    }else if(cuard.Approval__c==DEACTIVATE){
                        docuard.Description__c =(docuard.Description__c==null)?'Approval Status: De-Activate Access, SFAR - Not Created. Record Entry On - '+DateTime.Now():docuard.Description__c+' & Approval Status: De-Activate Access, SFAR - Not Created. Record Entry On - '+DateTime.Now();
                        dataOfDeActivateUARDS.add(docuard);   
                    }                    
                }
            } 
        }
    }
    
    public PageReference save(){
        try{
            Upsert dataOfApprovedUARDS;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Users in Approved section are approved now.');
            ApexPages.addMessage(myMsg);
            isApprovalDoneProp = YES;
        }catch(Exception e){
            System.debug('An Error has occured '+e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An ERROR has occured, please contact support. Approval is not done.');
            ApexPages.addMessage(myMsg);
            
        }
        return Null;
    }
    
    public PageReference sendMail(){
        try{
            setSendMailData(dataOfDeActivateUARDS);
            Upsert dataOfDeActivateUARDS;            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Emails are sent to users in De-Activate section to respond to their account de-activation request.');
            ApexPages.addMessage(myMsg);
            isMailSentProp = YES;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An ERROR has occured, please contact support. Mail has not been sent.');
            ApexPages.addMessage(myMsg);
        }
        return Null;
    }
    
    private void setSendMailData(List<User_Access_Review_Details__c> dataOfDeActivateUARDS){
        Set<String> bccAddressesForUtility = new Set<String>();
        Set<String> bccAddressesForOneDuPont = new Set<String>();
        
        for(User_Access_Review_Details__c uard: dataOfDeActivateUARDS){
            //AB20161227 Start
             String strOrgName = uard.Org__c;
            String strUsrEmailId = uard.User_Email_Id__c;
            if((strUsrEmailId!=null && strOrgName!=null) 
               &&((strOrgName.containsIgnoreCase(DUPONTINSTANCE) || strOrgName.containsIgnoreCase(UTILITYINSTANCE) ) 
                  || (strUsrEmailId.containsIgnoreCase(DUPONTINSTANCE) || strUsrEmailId.containsIgnoreCase(PIONEERUSER) || strUsrEmailId.containsIgnoreCase(UTILITYINSTANCE)))){//<AB20160808> //AB20161227
               
               if(strOrgName!=null && strOrgName.containsIgnoreCase(UTILITYINSTANCE)){
                    bccAddressesForUtility.add(strUsrEmailId);
                }else if(strOrgName!=null && strOrgName.containsIgnoreCase(DUPONTINSTANCE)){
                    bccAddressesForOneDuPont.add(strUsrEmailId);
                }else{
                    uard.description__c=(uard.description__c==null)?'Approval Status: De-Activate Access, SFAR - Sending Mail is Not Applicable for Non Employee. Record Entry On - '+DateTime.Now() : uard.description__c+' & Approval Status: De-Activate Access, SFAR - Sending Mail is Not Applicable for Non Employee. Record Entry On - '+DateTime.Now();
                }
                uard.description__c=(uard.description__c==null)?'Approval Status: De-Activate Access, SFAR - Mail has been sent. Record Entry On - '+DateTime.Now() : uard.description__c+' & Approval Status: De-Activate Access, SFAR - Mail has been sent. Record Entry On - '+DateTime.Now();
            }else{
                uard.description__c=(uard.description__c==null)?'Approval Status: De-Activate Access, SFAR - Sending Mail is Not Applicable for Non Employee. Record Entry On - '+DateTime.Now() : uard.description__c+' & Approval Status: De-Activate Access, SFAR - Sending Mail is Not Applicable for Non Employee. Record Entry On - '+DateTime.Now();
            }
            //AB20161227 End
        }
        
        //CB20180222 Updated OneDupont reference to take from Labels
        createBatchMail(bccAddressesForOneDuPont,System.UserInfo.getOrganizationName());
        
        createBatchMail(bccAddressesForUtility,System.Label.UtilOrgName);
        
        disableSendMailBtn = true;
    }
    
    public void createBatchMail(Set<String> bccAddressesForOrgs, String orgName){
        String[] bccAddresses = new String[]{};
            integer iCount=1;//limit of addresses and mails sending is 10*10 users at a time
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        for(String bccAddress:bccAddressesForOrgs){
            bccAddresses.add(bccAddress);
            
            if(iCount<9){
                iCount++;
            } else{
                iCount=1;
                doSendMail(bccAddresses,mail, orgName);
                bccAddresses.clear();
                mail = new Messaging.SingleEmailMessage();
            }
        }
        
        if(bccAddresses!=null && bccAddresses.size()>0){
            doSendMail(bccAddresses,mail,orgName);
        }
    }
    
    
    public void doSendMail(String[]bccAddresses,Messaging.SingleEmailMessage mail,String orgName){
        if(BCCEMAILADDRESS!=BLANK){
            bccAddresses.add(BCCEMAILADDRESS);
        }
        mail.setBccAddresses(bccAddresses);
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(MAILSENDERDISPLAYNAME);
        mail.setSubject(MAILSUBJECT);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody(getHTMLBody(orgName));
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /* Convert list of opportunities into more readable format */
    private String getHTMLBody(String orgName){
        String strHTMLBody = BLANK;
        strHTMLBody = strHTMLBody +' <html>';        
        strHTMLBody = strHTMLBody +'Hi,';
        strHTMLBody = strHTMLBody +'<BR><BR><BR>';
        strHTMLBody = strHTMLBody +'Your access to the Salesforce.com '+orgName+' org is being removed.';
        strHTMLBody = strHTMLBody + '<BR>If you disagree with this change, please let '+UserInfo.getFirstName()+' '+UserInfo.getLastName()+' know within 7 days. If not, your access will be removed.';
        strHTMLBody = strHTMLBody + '<BR><BR>Thank You,<BR> User Access Review Team<BR>';        
        strHTMLBody = strHTMLBody + '<BR>PS: This is a system generated email, please do not reply back.';
        
        return strHTMLBody;
    }
    
    Public PageReference createSFAR(){
        PageReference pr = prePopulateSFAR();               
        ApexPages.Message myMsg = (pr==null)?new ApexPages.Message(ApexPages.Severity.ERROR, 'An ERROR has occured, please contact support.'):new ApexPages.Message(ApexPages.Severity.INFO, 'SFAR No.'+'test'+' has been created for User'+'test');
        ApexPages.addMessage(myMsg);
        
        return pr; 
    }
    
    public User_Access_Review_Details__c getuardData(String uardId){
        for( User_Access_Review_Details__c uardData: dataOfChangedUARDS){
            if(uardData.Id==id.valueof(uardId)){
                return uardData;
            }
        }
        return new User_Access_Review_Details__c();
    }
    
    
    public PageReference prePopulateSFAR(){
        try{
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            DescribeSObjectResult result = gd.get('SFDC_Access_Request__c').getDescribe();
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = result.getRecordTypeInfosByName();
            String recordTypeId = recordTypeInfo.get('SFAR - Modify Access').getRecordTypeId();
            User_Access_Review_Details__c uardData = getuardData(createSFARForId);
            SFDC_Access_Request__c sfar = new SFDC_Access_Request__c();
            //AB26082016 Start
            String oldRecords = '';
            for(id recid: idsUARDRecordSFARCreated){
                System.debug('oldrecord=========sdf=>>>>>>>>>'+recid);
                oldRecords=(oldRecords=='')?String.valueOf(recid):oldRecords+','+String.valueOf(recid);
            }
            System.debug('oldrecordall=========sdf=>>>>>>>>>'+oldRecords);
            //AB26082016 End
            PageReference pr = new PageReference('/'+result.getKeyPrefix()+'/e');
            String strnewid = pr.getParameters().get('newid');
            pr.getParameters().put('nooverride','1');
            pr.getParameters().put('RecordType',recordTypeId);
            pr.getParameters().remove('retURL');
            pr.getParameters().remove('saveURL');
            //AB26082016 Start
            pr.getParameters().remove('RecId');
            pr.getParameters().remove('oldRecId');
            String curURL =ApexPages.currentPage().getURL();
            String curSelectiveURL = curURL.replaceAll('AJAXREQUEST=_viewRoot&',BLANK).replaceAll('&isApprovalDone=True',BLANK).replaceAll('&isApprovalDone=False',BLANK).replaceAll('&isMailSent=True',BLANK).replaceAll('&isMailSent=False',BLANK).replaceAll('%26newid%3D','%26SFARID%3D').replaceAll('&newid=','&SFARID=');
            String tempretURL = (curSelectiveURL.containsIgnoreCase('&RecId='))?curSelectiveURL.replaceAll('&RecId=', '&RecId='+uardData.Id+','):curSelectiveURL+'&RecId='+uardData.Id;
            String retURL = tempretURL+'&isApprovalDone='+isApprovalDoneProp+'&isMailSent='+isMailSentProp;
            String saveURL = retURL;
            pr.getParameters().put('retURL',retURL);        
            pr.getParameters().put('saveURL',saveURL);          
            System.debug('REturn URL is ========>>>>>>>>>>>> '+retURL);
            //AB26082016 END
            //<AB20160808> Start
            pr.getParameters().put( mapOfCustomSettings.get('Type').Ids__c,'Security & Permissions');
            pr.getParameters().put( mapOfCustomSettings.get('Subtype').Ids__c,'Modify User Details');
            pr.getParameters().put( mapOfCustomSettings.get('User_Region').Ids__c,uardData.User_Region__c);
            pr.getParameters().put( mapOfCustomSettings.get('User_Country').Ids__c,uardData.User_Country__c);
            pr.getParameters().put( mapOfCustomSettings.get('Owning_Organization').Ids__c,uardData.User_Owning_Org__c);
            pr.getParameters().put( mapOfCustomSettings.get('Profile').Ids__c,uardData.User_Profile__c!=null?uardData.User_Profile__c:BLANK);
            pr.getParameters().put( mapOfCustomSettings.get('Role').Ids__c,uardData.User_Roles__c!=null?uardData.User_Roles__c:BLANK);
            pr.getParameters().put( mapOfCustomSettings.get('Description').Ids__c,'User ID - '+uardData.User_Id__c);
            // pr.getParameters().put(truncateIds(SFARAccessRequestFieldsIds.get('Approving_Business')),uardData.Approving_Business__c);
            pr.getParameters().put( mapOfCustomSettings.get('Employment_Status').Ids__c,uardData.User_Type__c);            
            //CB20180222 Updated OneDupont reference to take from Labels
            pr.getParameters().put( mapOfCustomSettings.get('SFDC_Instance').Ids__c, (uardData.Org__c!=null && uardData.Org__c!=BLANK)?(uardData.Org__c.containsIgnoreCase('Util')?System.Label.UtilOrgName:System.Label.OrgName):BLANK);
            pr.getParameters().put(CUSTOMFIELD+ mapOfCustomSettings.get('User').Ids__c+'_mlktp', (uardData.User_Access_Type__c!=null && uardData.User_Access_Type__c!=BLANK)?((uardData.User_Access_Type__c.containsIgnoreCase('Partner') || uardData.User_Access_Type__c.containsIgnoreCase('Portal'))?'PartnerUserLookup':'005'):BLANK);
            pr.getParameters().put(CUSTOMFIELD+ mapOfCustomSettings.get('User').Ids__c, (uardData.Name!=null && uardData.Name!=BLANK && !uardData.Org__c.containsIgnoreCase('Util'))?uardData.Name.replaceAll(COMMA,SPACE):BLANK);
            pr.getParameters().put( mapOfCustomSettings.get('EPass_ID').Ids__c,uardData.User_ePass_Id__c);
            pr.getParameters().put(CUSTOMFIELD+ mapOfCustomSettings.get('Key_User').Ids__c, UserInfo.getName());
            pr.getParameters().put( mapOfCustomSettings.get('Username').Ids__c, uardData.User_Name__c);
            pr.getParameters().put( mapOfCustomSettings.get('User_Access_Type').Ids__c, uardData.User_Access_Type__c);
            
            //<AB20160808> End
            
            SFARURL = pr.getUrl();
            pr.setRedirect(true);
            return pr;
        }catch(Exception e){
            System.debug('An error has occured '+e.getStackTraceString());
        }
        return null;
        
    }
    //<AB20160808> Removed Deprecated code
    
    
    //wrapper class having name and label of selected fields of selected object  
    public class columsdata
    {
        public string name;
        public string label;
        
        public columsdata(string label, string name){            
            this.name = name;
            this.label = label;
        }
        
        public string getName(){
            return name;
        }
        
        public string getLabel(){
            return label;            
        }        
    }
}
/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  
        BCCEmail is executed via a Contact list view button and used to
    send a section of contacts a general email (not personalized).  This is done
     by adding the contacts email in the BCC text area of the standard send email task.
    
        By default the activity is also added to each of these contacts, this can be 
    inactivated by unchecking the 'Log Activity' checkbox.
    
        Because this is leveraging the standard email task, It does not count
    against the organizational daily email limit. (currenly 1000 per day)
    
    
********************************************************************************/
public with sharing class ctrlBCCEmail {
    private static integer  MAX_RECIPIENTS  = 50;
    private static final DescribeSObjectResult               DSR_Task        =Task.SObjectType.getDescribe();
    private static final Map<String,Schema.RecordTypeInfo>   RTINFO_Task     =DSR_Task.getRecordTypeInfosByName();
    private static final ID                                  RTYPE_BCCEmail  =RTINFO_Task.get('BCC Email').recordTypeId; 
    private List<String>        recipientIds;
    private LIST<Contact>       recipients;             
    private LIST<Contact>       skips_Email;   
    private LIST<Contact>       skips_Unowned;              
    private LIST<ContactTask>   LogStatus;
    

    public boolean              isBCCFax                {set; get;}
    public boolean              LogActivity             {set; get;}
    public task                 emailTask               {set; get;}
    public boolean              showSettings            {set; get;}
    public boolean              showLogStatus           {set; get;}
    public boolean              showResults             {set; get;}
    public boolean              showNoAccess            {set; get;}
    private string              BCC;                     //{set; private get;}
    private string              Template;               //{set; get;}
    public string               selectedFolder          {set; get;}
    public string               selectedTemplate        {set; get;}
    public string               AccessLevel             {set; get;} //{'none', 'ownership', 'visibility'}
    public boolean              AccessFax               {set; get;}
    
   private MAP<string, LIST<SelectOption>> emailTemplates;
   private LIST<SelectOption> emailFolders;

//////////////////////////////////////////////////////////////////////////////////      
    public pageReference init() {
        showNoAccess=true;
        showSettings=false;
        showLogStatus=false;
        showResults=false;
        LogActivity=true;
        //RTYPE_BCCEmail=[Select Id From recordtype where name='BCC Email'].Id;

        User u = [SELECT BCCEmail__c from User WHERE id=:UserInfo.getUserId()];
        if (u.BCCEmail__c==null ) AccessLevel = 'none';
        else if (u.BCCEmail__c.toLowerCase().contains('visibility')) AccessLevel ='visibility';
        else if (u.BCCEmail__c.toLowerCase().contains('ownership' )) AccessLevel ='ownership';
        else AccessLevel = 'none';
        AccessFax = (u.BCCEmail__c!=null && u.BCCEmail__c.toLowerCase().contains('fax')) ? true : false;

        
        isBCCFax=false;
        isBCCFax = ApexPages.currentPage().getParameters().containskey('fax');
        if (isBCCFax)   {
            MAX_RECIPIENTS=100;
            if (! AccessFax) 
                AccessLevel = 'none';
        }


        if (AccessLevel != 'none') {
            showNoAccess=false;
            showSettings=true;
            

            
            recipientIds = ApexPages.currentPage().getParameters().get('ids').split(',',-2);
            if (recipientIds.size()>MAX_RECIPIENTS) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Cannot select more than '+MAX_RECIPIENTS+' recipients. Please go back and modify your selection.'));
            }
            else {
                recipients = new LIST<Contact>();   
                skips_Email = new LIST<Contact>();    
                skips_Unowned = new LIST<Contact>();  
                for (Contact c :  [Select ID, Name, email, fax, ownerid from Contact where id in: recipientIds]) {
                    if (( isBCCFax==false && c.email==null ) || (isBCCFax==true && c.fax==null)) 
                        skips_Email.add(c);
                    else if (c.ownerid!=Userinfo.getUserId() && AccessLevel=='ownership')           
                        skips_Unowned.add(c);
                    else 
                        recipients.add(c);
                }
            }
        }
        
        initEmailFoldersandTemplates();
        return null;
    }
    
  
/*
    public pageReference usefax() {
        pageReference pg = Page.BCCEmail;  
        PageReference p = new PageReference('https://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl()+'?fax=1&ids='+recipientIds);
        p.setRedirect(true);
        return p;
    }
*/
    
  private void initEmailFoldersandTemplates() {
    if (emailFolders == null || emailTemplates == null) {
        emailFolders = new LIST<SelectOption>();
        emailTemplates = new MAP<string, LIST<SelectOption>>();
        
        for ( EmailTemplate t : [
                Select Id, Name, DeveloperName, FolderId, Folder.Name 
                From EmailTemplate 
                WHERE IsActive=true AND Folder.DeveloperName LIKE 'BCC%'
                ] ) {
            if ( ! emailTemplates.containskey(t.FolderId)) {
                emailFolders.add(new SelectOption(String.ValueOf(t.FolderId), t.Folder.Name));
                emailTemplates.put(t.FolderId, new LIST<SelectOption>());
            }
            emailTemplates.get(t.FolderId).add(new SelectOption(String.ValueOf(t.Id), t.Name));
        }       
            
        if ( selectedFolder==null && emailFolders.size()>0 ) 
            selectedFolder=emailFolders[0].getValue();
    }
}
//////////////////////////////////////////////////////////////////////////////////     

public List<SelectOption> getEmailFolders() {
    //if ( selectedFolder==null && emailFolders.size()>0 ) 
    //  selectedFolder=emailFolders[0].getValue();
    return emailFolders;
}
//////////////////////////////////////////////////////////////////////////////////     

public List<SelectOption> getEmailTemplates() {

    if ( selectedFolder==null && emailFolders.size()>0 ) 
        selectedFolder=emailFolders[0].getValue();
    
    if ( emailTemplates.containskey(selectedFolder) )
        return emailTemplates.get(selectedFolder);
    else
        return new List<SelectOption>();
}
//////////////////////////////////////////////////////////////////////////////////  
    public string getBCC() { 
        if ( recipients!=null && recipients.size()>0 )
            if (isBCCFax)
                BCC=joinFax(recipients,', ');
            else
                BCC=joinEmails(recipients,', ');
        else 
            BCC= '';
        return BCC;
    }
    public void setBCC(string val) {
        BCC=val;
    } 
//////////////////////////////////////////////////////////////////////////////////  
    public string getTemplate() {
        Template=selectedTemplate;
        return Template;
    }
    public void setTemplate(string val) { 
        Template=val;
    } 
//////////////////////////////////////////////////////////////////////////////////  
    public integer getBCCSize() {
        return getBCC().length();
    }
//////////////////////////////////////////////////////////////////////////////////  
    public LIST<ContactTask> getLogStatus() {
        return LogStatus;
    }
//////////////////////////////////////////////////////////////////////////////////  

    Public String getSkipEmailLinks() {
        
        String out='';
        String delim=', ';
        if (skips_Email != null) {
            for (Contact c : skips_Email) out+='<a href="/'+c.Id+'" target="_blank">'+c.Name+'</a>'+delim;
        }
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }   
//////////////////////////////////////////////////////////////////////////////////  

    Public String getSkipUnownedLinks() {
        String out='';
        String delim=', ';
        if (skips_Unowned != null) {
            for (Contact c : skips_Unowned) out+='<a href="/'+c.Id+'" target="_blank">'+c.Name+'</a>'+delim;
        }
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }   
//////////////////////////////////////////////////////////////////////////////////  
    private String joinEmails(LIST<sobject> alist, String delim) {
        String out='';
        //for (sobject c :alist) out+=c.get('Email')+'x'+delim;
        for (sobject c :alist) out+=c.get('Email')+delim;
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }   
//////////////////////////////////////////////////////////////////////////////////  
    private String joinFax(LIST<sobject> alist, String delim) {
        String out='';
        for (sobject c :alist) {
            string em=createFaxEmail((string)c.get('Fax'));
            //string em=(string) c.get('Fax');
            //em=em.replaceAll('[^0-9]','');
            if (em!=null)
                out+=em+delim;
        }
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }  
//////////////////////////////////////////////////////////////////////////////////      
    private string createFaxEmail(string fax) {
        string rtn=fax.replaceAll('[^0-9]','');
        if ( rtn.startsWith('1') && rtn.length()==11 ) return rtn+'@venali.net';
        else if ( (! rtn.startsWith('1')) && rtn.length()==10 ) return '1'+rtn+'@venali.net';
        else return null;
    }
    /*
    private String joinField(LIST<sobject> alist, string fieldname, String delim) {
        String out='';
        for (sobject s :alist) out+=s.get(fieldname)+'x'+delim;
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    } 
    
//////////////////////////////////////////////////////////////////////////////////  
    private String joint(LIST<String> alist, String delim) {
        String out='';
        for (String s :alist) out+=s+delim;
        return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
    }
    */
//////////////////////////////////////////////////////////////////////////////////  

    public PageReference Email_AfterSend() {
        showResults=true;
        List<Task> tasks = [Select t.Id, t.WhoId, t.WhatId, t.Subject, t.Status,  t.RecordTypeId, 
        t.OwnerId,  t.Description, t.CreatedDate, t.CreatedById,  t.ActivityDate, t.AccountId From Task t
        Where t.OwnerId=:UserInfo.getUserId() and t.status='Completed'
        order by CreatedDate desc
        limit 1];
        
        if (tasks.size()>0) {
            emailTask=tasks[0];
            if (LogActivity) {
                showLogStatus=true;
                AddActivityToBCCList();
            }
        }
        return null;
    }
//////////////////////////////////////////////////////////////////////////////////  
    private void AddActivityToBCCList() {
        if (Recipients!=null) {
            LogStatus = new LIST<ContactTask>();
            List<Task> newTasks = new List<Task>();
            for (Contact c : Recipients) {
                Task newTask = emailTask.clone(false,true);
                newTask.WhoId = c.Id;
                if (isBCCFax)
                    newTask.Subject = 'FAX '+emailTask.Subject;
                else
                    newTask.Subject = 'BCC '+emailTask.Subject;
                newTask.RecordTypeId = RTYPE_BCCEmail;
                if (newTask.Subject.length()>80) newTask.Subject=newTask.Subject.substring(0,79);
                newTasks.add(newTask);
                system.debug('----------------->'+ c);
                LogStatus.add(new ContactTask(c,newTask));
            }
        insert newTasks;
        }
    }
//////////////////////////////////////////////////////////////////////////////////    
    public boolean getShowSkipsUnowned() {
        return (getSkipUnOwnedLinks().length()>0);
    }    
//////////////////////////////////////////////////////////////////////////////////    
    public boolean getShowSkipsEmail() {
        return (getSkipEmailLinks().length()>0);
    }
////////////////////////////////////////////////////////////////////////////////// 
    public PageReference CreateEmail() {
        showSettings=false;
        
        return null;
    }
    
////////////////////////////////////////////////////////////////////////////////// 
    public PageReference TemplateFolder_OnChange() {
        initEmailFoldersandTemplates();
        return null;
    }
////////////////////////////////////////////////////////////////////////////////// 
    public PageReference Close() {
        PageReference page = new PageReference('/003');
        page.setRedirect(true);
        return page;
    }
//////////////////////////////////////////////////////////////////////////////////  
    public class ContactTask {
        public Contact contact {set; get;}
        public Task task {set; get;}
        
        ContactTask(Contact c, Task t) {
            this.Contact = c;
            this.task = t;
        }
    }



/********************************************************************************************   
//  TEST METHODS
********************************************************************************************/
private static void testController(string aAccessLevel){
        ctrlBCCEmail controller = new ctrlBCCEmail();
        controller.init();
        controller.AccessLevel=aAccessLevel;
        controller.getBCC();
        controller.getBCCsize();
        controller.getShowSkipsEmail();     
        controller.getShowSkipsUnowned(); 
        controller.getSkipUnownedLinks();
        controller.getSkipEmailLinks();
        
        controller.getEmailFolders();
        controller.getEmailTemplates(); 
        controller.getTemplate();
        controller.TemplateFolder_OnChange();   
        controller.getTemplate();
        
        
        controller.getLogStatus();
        controller.CreateEmail();
        controller.Email_AfterSend();
        controller.close();
}

public static testMethod void testBCCEmail() {
        geoValidation.DisableGeoValidationOverride=true;
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        Contact c1 = new Contact(lastname='test', email='tester@dupont.comx', fax='1-800-111-2222');
        Contact c2 = new Contact(lastname='test', email='tester2@dupont.comx', fax='(222)-333-4444');
        Contact c3 = new Contact(lastname='test', email='');
        insert new Contact[]{c1,c2,c3};
        

        Test.startTest();
        PageReference pageRef = Page.BCCEmail;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ids', c1.id+','+c2.id+','+c3.id);
        update new User(id=userInfo.getUserId(),BCCEmail__c='visibility');
        testController('visibility');
        update new User(id=userInfo.getUserId(),BCCEmail__c='ownership');
        testController('ownership');        
        update new User(id=userInfo.getUserId(),BCCEmail__c=null);
        testController('none');
        
        ApexPages.currentPage().getParameters().put('fax','1');
        update new User(id=userInfo.getUserId(),BCCEmail__c='visibility with fax');
        testController('visibility with fax');
        Test.stopTest();
        
        
    }  
     


}
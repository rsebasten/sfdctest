/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  User Summary Report
********************************************************************************/

public with sharing class ctrlSummaryReport {

private static final decimal    DEFAULT_SETTINGSMASK = 3;

public User             user    {set; get;}
public string           userId  {set; get;}
public string           lang  {set; get;}
MAP<Id, Initiative__c>  initiatives;
List<Call_Report__c>    callReports;
List<Call_Report__c>    callReportsHighlight;
List<Call_Report__c>    callReportsSummary;
List<Opportunity>       opportunities;
private double          SUMY1; 
private double          SUMTarget;
private double          SUMInitativeYTD;

public  boolean         showSettings {set; get;}
public static decimal   settingsmask {set; get;}
public static long  mask {set; get;}
public Task             DateRangeTask {set; get;}  //holder for date range,  used for datepicker
public Section  sec1 {set; get;}
public Section  sec2 {set; get;}
public Section  sec3 {set; get;}
public Section  sec4 {set; get;}
public Section  sec5 {set; get;}
public Section  sec6 {set; get;}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
    public PageReference init() {
            lang='en';
            userId = ApexPages.currentPage().getParameters().get('id');
            user = [Select Name, Country, UserRole.Name, User_Country__c
                    from user where Id=:userId ];

            
            if (ApexPages.currentPage().getParameters().get('smask')!=null) {
                showSettings=false;
                settingsmask = Decimal.valueOf(ApexPages.currentPage().getParameters().get('smask'));
                mask = Long.valueOf(ApexPages.currentPage().getParameters().get('smask'));
                }
            else {
                showSettings=true;
                settingsmask = [Select SummaryReportMask__c from User where Id=:UserInfo.getUserId()].SummaryReportMask__c;
                if (settingsmask == null || settingsmask == 0)
                    settingsmask = DEFAULT_SETTINGSMASK;
                    mask = DEFAULT_SETTINGSMASK.longvalue();
            }
            
            
            //get Date Range
            date startDate = (ApexPages.currentPage().getParameters().get('startdt')!=null) ? 
                    Date.valueof(ApexPages.currentPage().getParameters().get('startdt')) :
                    Date.today().toStartOfMonth().addMonths(-1);
                    
            date endDate = (ApexPages.currentPage().getParameters().get('enddt')!=null) ? 
                    Date.valueof(ApexPages.currentPage().getParameters().get('enddt')) :
                    Date.today().toStartOfMonth().addDays(-1);
            

            //ReportDates = new Contract(CompanySignedDate=endDate, StartDate=startDate);
            DateRangeTask = new Task(Desired_Start_Date__c=startDate, Completion_Date__c=endDate);
            
            
            createReportSections(); 
            getInitiatives();  //for doing initative calculations even if initiative are not shown.
            return null;
    }
    
    
    
    public string getSUMY1() {return 'USD '+DecimaltoCurrency(SUMY1);}
    public string getSUMTarget() {return 'USD '+DecimaltoCurrency(SUMTarget);}
    public string getSUMInitativeYTD() {return 'USD '+DecimaltoCurrency(SUMInitativeYTD);}
    
    public void createReportSections() {
        sec1 = new Section('User Section', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,0).LongValue()),'detail')} 
                );
        sec2 =  new Section('Initiatives', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,4).LongValue()),'list'), 
                    new SelectOption(String.ValueOf(Math.pow(2,5).LongValue()),'detail')} 
                );  
        sec3 = new Section('Opportunities', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,8).LongValue()),'list')} 
                ); 
                      
        sec4 = new Section('Call Report', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,12).LongValue()),'list')} 
                );
        
        sec5 = new Section('Highlighted Call Report', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,16).LongValue()),'detail')} 
                );              
                
        sec6 = new Section('Summary  Report', 
                new List<SelectOption>{new SelectOption('0','none'), 
                    new SelectOption(String.ValueOf(Math.pow(2,20).LongValue()),'detail')} 
                ); 
    }
    
    
    public string getHeaderDT() {
        return DateRangeTask.Desired_Start_Date__c.format()+' - '+DateRangeTask.Completion_Date__c.format();
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
    private long getCurrentSettings() {
        return sec1.selected+sec2.selected+sec3.selected+sec4.selected+sec5.selected+sec6.selected;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    public PageReference RunReport() {
       settingsmask=getCurrentSettings();
        update new User(Id=UserInfo.getUserId(), SummaryReportMask__c=settingsmask);
        return null;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
    public PageReference HideSettings() {
        settingsmask=getCurrentSettings();
        update new User(Id=UserInfo.getUserId(), SummaryReportMask__c=settingsmask);
        showSettings=false;
        return null;
    }
    

    public class Section {
        public string               title       {get; set;}
        public SelectOption[]       options     {get; set;}
        public long                 selected    {get; set;}
        
        Section(string aTitle, SelectOption[] aOptions) {
            this.title=aTitle;
            this.options=aOptions;
            DetermineSelected(settingsmask.longValue());
        }
        
        public void DetermineSelected(long amask) {
            long lsum=0L;
            for (SelectOption so : this.options) {
                 lsum=+Long.valueOf(so.getValue());
            }
            selected = amask&lsum;
        }
        
    }

/*  
        public long getMaskfromSections() {
            long l=0;
            for (Section s : ReportSections )
                l=+Long.ValueOf(s.selected);
        return l;
        }
        
    
    public class Sections {
        public Section[] sections {set; get;}
        
        public long getMask() {
            long l=0;
            for (Section s : this.sections )
                l=+Long.ValueOf(s.selected);

        }
        
        
    }

*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////   
    
    /*
    public class Settings {

        public long userInfo {set; get;}
        public long callReports {set; get;}
        public long callReportsHighlight {set; get;}
        public long initiatives {set; get;}
        public long opportunities {set; get;}
        
        Settings(List<Section> mySections) {
            userInfo=Long.valueOf(mySections[0].selected); 
            callReports=Long.valueOf(mySections[1].selected);
            callReportsHighlight=Long.valueOf(mySections[2].selected);
            initiatives=Long.valueOf(mySections[3].selected);
            opportunities=Long.valueOf(mySections[4].selected);
        }
            

        public long getMask() {
            long amask=this.UserInfo+this.CallReports+this.callReportsHighlight+this.callReportsHighlight
                +this.initiatives+this.opportunities;
            return amask;
            
        }

    }
    */
/////////////////////////////////////////////////////////////////////////////////////////////////////////   

    private void calcInitiatives() {    
        SUMY1=0;
        SUMTarget=0;
        SUMInitativeYTD=0;
        
        for ( Initiative__c i : initiatives.values() ) {
            if (i.Rev_Growth_Year_1__c != null) 
                SUMY1+=i.Rev_Growth_Year_1__c;
            if (i.Revenue_Growth_Target__c != null) 
                SUMTarget+=i.Revenue_Growth_Target__c;
                
            for   ( Initiative_Metric__c im : i.Metrics__r ) {
                if (im.Rev_Y1_YTD__c != null && im.Date_Y1__c !=null &&
                    im.Date_Y1__c.year() == DateRangeTask.Completion_Date__c.year()
                    ) 
                    SUMInitativeYTD+=im.Rev_Y1_YTD__c; 
            }
        }   
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////       
    public List<Initiative__c> getInitiatives() {
        //if (initiatives==null) {
            initiatives = new MAP<Id, Initiative__c> (
                        [Select i.id, i.Update__c, i.Status__c, i.Stage__c, i.Next_Steps__c, i.Name, SubType__c, LastModifiedDate,
                            convertCurrency(i.Revenue_Growth_Target__c), convertCurrency(i.Rev_Growth_Year_1__c), i.End_Date__c, i.Status_vs_Plan__c,StatusvsPlan_img__c,
                            (Select Id, Account.Name, Name, StageName, convertCurrency(Amount), CloseDate From Opportunity__r) ,
                            (Select convertCurrency(Rev_Y1_YTD__c), Date_Y1__c From Metrics__r )
                            From Initiative__c i
                            WHERE OwnerId=:userId
                            AND i.Status__c not in ('Completed','Abandoned')
                            AND ( NOT  ((i.End_Date__c < :DateRangeTask.Desired_Start_Date__c) OR (i.Start_Date__c > :DateRangeTask.Completion_Date__c) ) )
                            AND i.Stage__c IN ('Active','End' )
                            ]);
           calcInitiatives();
        //} 
        return initiatives.values();
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////       
    public List<Call_Report__c> getCallReportsSummary() {
            //KT [11072017]: To remove Training_Update__c reference
            callReportsSummary = [
                            Select c.Name,  c.Id, c.Call_Date__c, Account__r.Name,
                                Summary__c,  Next_Steps__c, c.Status__c, c.Issues__c, c.Type__c
                            From Call_Report__c c
                            WHERE CreatedById=:userId
                            AND ( c.Call_Date__c >= :DateRangeTask.Desired_Start_Date__c AND c.Call_Date__c<= :DateRangeTask.Completion_Date__c ) //LAST_YEAR //LAST_MONTH
                            AND c.Type__c = 'Monthly Highlight Only'
                            ];
        return callReportsSummary;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////       
    public List<Call_Report__c> getcallReportsHighlight() {
        //if (callReportsHighlight==null) 
            //KT [11072017]: To remove Training_Update__c reference
            callReportsHighlight = [Select c.Name, c.Monthly_Highlight__c, c.Id, c.Channel__c, c.Call_Date__c, c.Issues__c,
                                Summary__c, Account__r.Name, Next_Steps__c, c.Related_Initiative__r.Name, c.Status__c, c.Type__c 
                            From Call_Report__c c
                            WHERE CreatedById=:userId
                            AND ( c.Call_Date__c >= :DateRangeTask.Desired_Start_Date__c AND c.Call_Date__c<= :DateRangeTask.Completion_Date__c ) //LAST_YEAR //LAST_MONTH
                            AND c.Monthly_Highlight__c = true
                            ];
        return callReportsHighlight;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////       
    public List<Call_Report__c> getCallReports() {
        //if (callReports==null) 
            //KT [11072017]: To remove Training_Update__c reference
            callReports = [Select c.Name, c.Monthly_Highlight__c, c.Id, c.Channel__c, c.Call_Date__c,
                            c.Related_Initiative__r.Name, c.Account__r.name, c.Status__c, c.Type__c, c.Issues__c
                            From Call_Report__c c
                            WHERE CreatedById=:userId
                            AND ( c.Call_Date__c >= :DateRangeTask.Desired_Start_Date__c AND c.Call_Date__c<= :DateRangeTask.Completion_Date__c ) //LAST_MONTH
                            AND (NOT (c.Type__c like 'Monthly%' ))
                            ];
        return callReports;
    }   
/////////////////////////////////////////////////////////////////////////////////////////////////////////       
    public List<Opportunity> getOpportunities() {
            if (opportunities==null) 
                opportunities = [Select o.Account.Name, o.Name, o.StageName, o.CloseDate, convertCurrency(o.Amount) 
                                    From Opportunity o
                                WHERE OwnerId=:userId
                                AND ( (o.CloseDate >= :DateRangeTask.Desired_Start_Date__c AND o.CloseDate<= :DateRangeTask.Completion_Date__c) OR
                                      (o.CreatedDate >= :D2DT(DateRangeTask.Desired_Start_Date__c) AND CreatedDate <= :D2DT(DateRangeTask.Completion_Date__c) )
                                     )
                                ];
            return opportunities;
    }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////     
    private string DecimaltoCurrency(Decimal val) {
        if (val == null ) return '0.00';
        else {
            string str = val.divide(1,2,RoundingMode.HALF_UP).format();
            integer dec = str.lastindexOf('.');
            if (dec==-1) return str+'.00';
            else if (dec>str.length()-3) return str+'0';
            else return str.substring(0,dec+2);
        }
    }  
 /////////////////////////////////////////////////////////////////////////////////////////////////////////  
    private DateTime D2DT(Date d) {
        return DateTime.newInstance(d.year(),d.month(),d.day());
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////           
    public PageReference EmailToMe() {
        settingsmask=sec1.selected+sec2.selected+sec3.selected+sec4.selected+sec5.selected;

        string email = [Select email from User where id=:UserInfo.getUserId()].email;
    
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.useSignature =false;
        msg.setToAddresses(new String[] {email});
        PageReference c = Page.PeriodSummaryReport;
        PageReference p = new PageReference('https://'+ApexPages.CurrentPage().getHeaders().get('Host')+c.getUrl()+'?id='+userId);
        p.getParameters().put('smask', String.valueOf(settingsmask));
        p.getParameters().put('startdt',String.valueOf(DateRangeTask.Desired_Start_Date__c));
        p.getParameters().put('enddt',String.valueOf(DateRangeTask.Completion_Date__c));
        p.getParameters().put('pdf', '1');
        
        // set the body of the attachments
        try {
           Messaging.EmailFileAttachment bAtt = new Messaging.EmailFileAttachment();
           bAtt.body = p.getContent();
           bAtt.fileName = 'SummaryReport.pdf';
           msg.fileAttachments = new Messaging.EmailFileAttachment[] {bAtt }; 
           
           //email.textAttachments = new Messaging.inboundEmail.textAttachment[] {tAtt }; 
            
            msg.setHtmlBody('report:');
            //system.debug('URL------------------->https://'+ApexPages.CurrentPage().getHeaders().get('Host')+ApexPages.CurrentPage().getUrl()+'?id='+userId);
            //msg.setHtmlBody(ApexPages.currentPage().getContent().toString());
            msg.setSubject('Period Summary Report -('+getHeaderDT()+')');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
        }
        catch(exception e) {
            system.debug('Error sending email: ' + e);
        }
        return null;
    }
    
  /////////////////////////////////////////////////////////////////////////////////////////////////////////           
/********************************************************************************************   
//  TEST METHODS
********************************************************************************************/


private static void testController(){
        ctrlSummaryReport controller = new ctrlSummaryReport();
        controller.init();
        controller.getHeaderDT();
        controller.getcallReports();
        controller.getcallReportsHighlight();
        controller.getcallReportsSummary();
        controller.getInitiatives();
        controller.getOpportunities();
        controller.getSUMY1();
        controller.getSUMTarget();
        controller.getSUMInitativeYTD();
        controller.RunReport();
        controller.HideSettings();
        controller.EmailToMe();
}

//////////////////////////////////////////////////////////////////////////////////////////////// 

public static testMethod void testSummaryReport() {
    Account acc = new Account(name='testacc', country__c='United States');
    insert acc;
    Initiative__c init = new Initiative__c(name='testinit', status__c='open', stage__c='Active', start_date__c=Date.Today(), End_Date__c=Date.Today(), Revenue_Growth_Target__c=200.20,Rev_Growth_Year_1__c=300.50);
    insert init;
    Opportunity opp = new Opportunity(name='testopp', stagename='Won' , CloseDate=Date.Today(), accountid=acc.id, Related_Initiative__c=init.id, amount=100.10);
    insert opp;


        Test.startTest();
        PageReference pageRef = Page.PeriodSummaryReport;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(UserInfo.getUserId()));
        ApexPages.currentPage().getParameters().put('smask', '4294967295'); //FFFFFFFF  (32 bit)
        ApexPages.currentPage().getParameters().put('startdt',String.valueOf(Date.Today()-1));
        ApexPages.currentPage().getParameters().put('enddt',String.valueOf(Date.Today()+1));
        ApexPages.currentPage().getParameters().put('pdf', '1');        
        testController();
        Test.stopTest();
    } 
   
   //Without a smask
   public static testMethod void testSummaryReport2() {

        Test.startTest();
        PageReference pageRef = Page.PeriodSummaryReport;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(UserInfo.getUserId()));        
        testController();
        
        Test.stopTest();
    }  
  
}
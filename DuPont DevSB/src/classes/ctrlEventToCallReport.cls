/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: EventToCallReport

TES20131023:  fix to unhandled exceptions:  Added try/catch around insert/update and
 truncate event.subject to 80chars when coverting to call report
********************************************************************************/
public with sharing class ctrlEventToCallReport {
    
    public static final string INITIATIVE_PREFIX    = Initiative__c.sObjectType.getDescribe().getKeyPrefix();
    public static final string CALLREPORT_PREFIX    = Call_Report__c.sObjectType.getDescribe().getKeyPrefix();

    public string               errMsg                  { get; set;}    
    public Event                event                   { get; set;} 
    public Contact              contact                 { get; private set;} 
    public Call_Report__c       callReport              { get; private set;} 
    
    public PageReference init() {
        string Id = ApexPages.currentPage().getParameters().get('id');
        
        try {
            event = [
                SELECT Id, AccountId, WhoId, WhatId, Subject, Direction__c, Description, Level_Of_Effort__c,
                Channel__c, Activity_Type__c, ActivityDate, Status__c, StartDateTime, EndDateTime, location
                FROM Event 
                WHERE id=:Id 
                LIMIT 1][0];
            system.debug('EVENT: --------->'+event);
        }
        catch (Exception ex) {
            errMsg='Unable to determine event. '+ex;
            return null;
        }

        if (event==null) {  
                errMsg='Unable to determine event. ';
                return null;
        }
        else {  
            
            if (event.WhatId!=null && String.valueOf(event.WhatId).startsWith(CALLREPORT_PREFIX)) {
                errMsg='Call Report already exists.';
                return null;
            }
            //Event must link to a contact or Account
            if ( ! (    ( event.WhoId!=null && String.valueOf(event.WhoId).startsWith('003')) || 
                        ( event.WhatId!=null && String.valueOf(event.WhatId).startsWith('001'))
                    )) {
                errMsg='The event must Relate to an Account or Contact. ';
                return null;
            }
            
    
            Call_Report__c callReport = new Call_Report__c();
            callReport.Account__c               = event.AccountId;
            callReport.Contact__c               = event.WhoId;
            callReport.Name                     = (event.subject.length()>80) ? event.subject.substring(0,80) : event.subject;
            //KT [11072017]: To remove Direction__c reference
            //callReport.Direction__c             = event.Direction__c;
            callReport.Status__c                = event.Status__c;
            callReport.Channel__c               = event.Channel__c;
            callReport.Activity_Type__c         = event.Activity_Type__c;
            callReport.Activity_Date__c         = event.ActivityDate;
            //KT [11082017]: To remove Level_of_Effort_hours__c reference
            //callReport.Level_of_Effort_hours__c = event.Level_Of_Effort__c;
            //KT [11072017]: To remove Origin_Channel_Type__c reference
            //callReport.Origin_Channel_Type__c   = 'Event';
    
            //description
            string descr='';
            if (event.StartDateTime != null)        descr+='StartTime: '    + event.StartDateTime.format()+'\n';
            if (event.EndDateTime   != null)        descr+='EndTime: '      + event.EndDateTime.format()+'\n';
            if (event.location      != null)        descr+='Location: '     + event.Location+'\n';
            if (event.Description   != null)        descr+='Description: '  + event.Description;
            callReport.Activity_Description__c=descr;
                
            if (event.WhatId!=null) {
                if ( String.valueOf(event.WhatId).startsWith(INITIATIVE_PREFIX)) {
                    callReport.Related_Initiative__c=event.WhatId;
                }
                else if (String.valueOf(event.WhatId).startsWith('001')) {
                    //do nothing,  just allow
                }
                else {
                    errMsg='The event RelatedTo can only be of type: Initiative or Account';
                    return null;
                }
            } //WhatId!=null
        
            system.debug('callReport: --------->'+callReport);
            //TES20131023 Added try/catch around insert/update
            try {
                insert callReport;
                system.debug('callReportId: --------->'+callReport.id);
                update new Event(id=event.id, WhatId=callReport.id);
            }catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: '+ex));
            }
        
            //Redirect to CallSCript in Edit mode....
            string url = '/'+callReport.id+'/e?retURL=/'+callReport.id;
            PageReference p = new PageReference(url);
            p.setRedirect(true);
            return p;   
            
        }  //event!=null
        
        return null;
    }



////////////////////////////////////////////////////////////////////////////////////
//      Test script(s)
////////////////////////////////////////////////////////////////////////////////////



    //public class EventToCallReportException extends Exception {}

}
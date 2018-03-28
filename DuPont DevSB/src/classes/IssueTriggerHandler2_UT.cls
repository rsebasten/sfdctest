/*******************************************************************************
Copyright Â© 2012 DuPont. All rights reserved. 
Author: TCS COO 
Email: niha.saha@tcs.com
Description:  Unit testclass for IssueTriggerHandler2 on 04032016
change log:
    1. RS03132016: Added methods testAutoAssignment
    2. 26/12/2016 Updated the test class to remove seeAllData from the test class.
********************************************************************************/

@isTest()
private class IssueTriggerHandler2_UT {
    
    static testMethod void testIssueTriggerHandler2() {
    Map<Id, Issue__c> oldMap = new Map<Id, Issue__c>();
    List<Issue__c> issueList = new List<Issue__c>();
        Issue__c objIssue = new Issue__c();
        objIssue.Name = 'test';
        objIssue.Description__c ='Test';
        objIssue.SFDC_Instance__c = 'One Dupont Corporate';
        objIssue.Program__c = 'IT';
        objIssue.Region__c = 'Asia Pacific';
        objIssue.Type__C = 'Data';
        objIssue.lastTimeStatusChanged__c = System.now();
        objIssue.Classification__c = 'Adhoc';
        objIssue.Status__c = 'Not Started' ;
        issueList.add(objIssue);
        INSERT issueList;
      
        System.debug('OLD value'+ issueList[0].Status__c );
        objIssue.Status__c = 'Accepted' ;
        
        UPDATE issueList;

        oldMap.put(issueList[0].id, issueList[0]);
        System.debug('NEW value'+ issueList[0].Status__c );
        System.debug('Map Values' + oldMap.values() );
        objIssue.Application__c = 'Service Max' ;
        objIssue.Status__c = 'IN Progress';
        UPDATE issueList;
        objIssue.status__c = 'Waiting';
        objIssue.Sub_Status__c = 'Waiting with Customer';
        UPDATE issueList;
        objIssue.status__c = 'On Hold';
        UPDATE issueList;
        objIssue.status__c = 'Escalated';
        UPDATE issueList;
        objIssue.status__c = 'Approved by Review Team';
        UPDATE issueList;
        objIssue.status__c = 'DuPont Review';
        UPDATE issueList;
        objIssue.Date_Closed__c = System.now();
        objIssue.Resolution__c = 'Resolution along with RCA is mandatory Minimum characters to be entered for Config changes 25 characters ';
        objIssue.status__c = 'Completed';
        UPDATE issueList;
        objIssue.status__c = 'In Progress';
        objIssue.Application__c = 'Service Max' ;
        UPDATE issueList;
        
        IssueTriggerHandler2.beforeUpdate(issueList,oldMap);
        
    }
     //Rohit saini 03/13/2016 IS ID-00068452 Added functionality to auto assign issues.
    static testMethod void testAutoAssignment() {
       
        Map<String, Id> recordTypeMap=getIssueRecordTypeMap();
        List<Issue__c> issueList = new List<Issue__c>();
        issueList.add(createIssue('CRM (Standard functionality)', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('FinancialForce PSA', 'Email Templates' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Product Finder', 'Data' ,'Data migration/Go-live', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Global Dealer/Locator', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Price Approval', 'Pre-Deploy Review' ,'Data migration/Go-live', recordTypeMap.get('Issues and Ideas') ));
        
        issueList.add(createIssue('CRM (Standard functionality)', 'Campaign' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('FinancialForce PSA', 'Email-Tool' ,'Data migration/Go-live', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Product Finder', 'Data' ,'Data migration/Go-live', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Global Dealer/Locator', 'Audit IT Controls' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        
        issueList.add(createIssue('CRM (Standard functionality)', 'Page Layouts' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('FinancialForce PSA', 'Data Model Review' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Product Finder', 'Request Item' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Global Dealer/Locator', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        
        issueList.add(createIssue('CRM (Standard functionality)', 'Sales Aid Fulfillment' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('FinancialForce PSA', 'Fields or Picklists' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Product Finder', 'Audit IT Controls' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Global Dealer/Locator', 'Data' ,'Adhoc', recordTypeMap.get('Issues and Ideas') ));
        issueList.add(createIssue('Price Approval', 'Data' ,'Program', recordTypeMap.get('Issues and Ideas') ));
        
        INSERT issueList;
        // 3/8/2017 - Merge&Spin - Inserting Users      
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];       
        system.runas(thisUser){       
            Profile p1 = [select id from profile where Name='System Administrator' limit 1];      
            UserRole ur = new UserRole(Name = 'Agriculture');     
            insert ur;        
                  
          }
 
       Issue__c newIssue=createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue;
       try{
       Issue__c newIssue2=createIssue('', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue2;
       }catch(Exception e){
       }
       
       Issue__c newIssue3=createIssue('CRM (Standard functionality)', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue3;
       
       for(Issue__c issue: issueList){
            issue.Status__c = 'In Progress';
        }
        update issueList;
        
        test.startTest();
        
        Issue__c newIssue4=createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue4;
       
       Issue__c newIssue5=createIssue('CRM (Standard functionality)', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue5;
       
       for(Issue__c issue: issueList){
            issue.Date_Closed__c = System.now();
            issue.Resolution__c = 'Resolution along with RCA is mandatory Minimum characters to be entered for Config changes 25 characters ';
            issue.Status__c = 'Completed'; 
            issue.Date_Accepted__c = System.now();
        }
        update issueList;
       
        Issue__c newIssue6=createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue6;
       
       Issue__c newIssue7=createIssue('CRM (Standard functionality)', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue7;
       
       update issueList;
       
        Issue__c newIssue8=createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue8;
       
       Issue__c newIssue9=createIssue('CRM (Standard functionality)', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue9;
       Issue__c newIssue10=createIssue('Price Approval', 'Data' ,'Correct (Break/Fix)', recordTypeMap.get('Price Approval')  );
       insert newIssue10;
       Issue__c newIssue11=createIssue('Price Approval', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue11;
        
        
        test.Stoptest();
       
        
        List<Issue__c> lstIss=new List<Issue__c>();
        newIssue.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue);
        
        newIssue11.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue11);
        
        
        newIssue3.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue3);
        
        newIssue4.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue4);
        
        newIssue5.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue5);
        
        newIssue6.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue6);
        
        
        newIssue8.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue8);
        
        newIssue9.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue9);
        
        newIssue10.ownerId= UserInfo.getUserId();  
        lstIss.add(newIssue10);
                
        update lstIss;
        
        
        Issue__c newIssue12=createIssue('FinancialForce PSA', 'Data' ,'Adhoc', recordTypeMap.get('Price Approval')  );
       insert newIssue12;
       
        
    }

public static Issue__c createIssue(string application, string type, string classification, string recordTypeId){
        Issue__c objIssue = new Issue__c();
        objIssue.Name = 'test';
        objIssue.Description__c ='Test';
        objIssue.SFDC_Instance__c = 'One Dupont Corporate';
        objIssue.Program__c = 'IT';
        objIssue.Region__c = 'Asia Pacific';
        objIssue.Type__C = type;
        objIssue.Classification__c = classification;
        objIssue.Status__c = 'Not Started' ;
        objIssue.Application__c =application;
        objIssue.recordTypeId=recordTypeId;
        
        return objIssue;
    }
    
    
 public static Map<string, Id> getIssueRecordTypeMap(){
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Issue__c' and isActive=true];
    
        Map<string, Id> recordTypeNameIdMap=new Map<string, Id>();
        for(RecordType rec: rtypes ){
            recordTypeNameIdMap.put(rec.name, rec.id);
        }
        return recordTypeNameIdMap;
    }
   
}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Arjun Sharma
Email: arjun.sharma2@tcs.com
Description:  Unit test for BI_CPRoleHandler, BI_CPCompanyHandler, BI_CPContactHandler
and BI_CPUtil

<AS20161101>
Modified By: Arjun Sharma
Modification Date: 01-Nov-2016
Modification: To increase code coverage, and run test class as specific user.


<AS20170428>
Modified By: Arjun Sharma
Modification Date: 28-Apr-2017
Modification: To increase code coverage, and run test class as specific user.
********************************************************************************/
@isTest(seealldata=false)
private class BI_CPRoleHandler_UT {
    static List<ConstructionPts__CP_Project__c> cpProjectList = new List<ConstructionPts__CP_Project__c>();
    static List<ConstructionPts__CP_Company__c> cpCompanyList = new List<ConstructionPts__CP_Company__c>();
    static List<ConstructionPts__CP_Contact__c> cpContactList = new List<ConstructionPts__CP_Contact__c>();
    static List<ConstructionPts__CP_Role_Type__c> cpRoleTypeList = new List<ConstructionPts__CP_Role_Type__c>();
    static List<External_Initiative__c> extInitList = new List<External_Initiative__c>();
    static List<ConstructionPts__CP_Roles__c> dodgeRoleList = new List<ConstructionPts__CP_Roles__c>();
    static batchCPSFJob cpsfbatch = new batchCPSFJob();
    static String schedule = '00 08 19 19 1 ? 2019';
    static Date myDate = System.today();
    static String leadRtypeId = Rtype.getIdByDevName('Lead','BI-All');
     
    static List <ConstructionPts__CP_Roles__c> recordCreated(){
        User u = [Select id ,name from User where username =:Label.Batch_SFDC_Deploy_User_Name];//<AS20161101>
        for(Integer i = 1; i <= 2; i++){
            cpProjectList.add(new ConstructionPts__CP_Project__c(Name='project'+i,ConstructionPts__Report_Number__c='00-000'+i,ConstructionPts__ProjectID__c=''+i,
                                                                 ConstructionPts__SFDC_Upload_Time__c=myDate,
                                                                 ConstructionPts__Report_Version__c=''+i,ConstructionPts__Bid_Date__c=myDate,
                                                                 ConstructionPts__Address__c='150 E. Blackstock Rd. Ste. B',ConstructionPts__City__c='SPARTANBURG',
                                                                 ConstructionPts__Country__c='United States',ConstructionPts__County__c='SPARTANBURG',
                                                                 ConstructionPts__Features_Info__c='Approx 25,000 sq ft interior build-out',ConstructionPts__Search_Names__c='Surfaces , Tyvek',
                                                                 ConstructionPts__Project_Report_URL__c='https://dodge',ConstructionPts__Stories_above__c=8,ConstructionPts__Stories_below__c=1,
                                                                 ConstructionPts__Total_Sq_Ft__c='136829 Total Square Feet',ConstructionPts__Market_Segment_Name__c='Leisure,Engineering',
                                                                 ConstructionPts__Project_Type__c='Supermarket/Convenience Store',ConstructionPts__Type_Of_Work__c='New Project',
                                                                 ConstructionPts__Ownership__c='Local Government',ConstructionPts__Structural__c='Structural Steel',
                                                                 ConstructionPts__Stage255__c='GC Bidding-Invitation',ConstructionPts__State__c='SC',
                                                                 ConstructionPts__Value__c=2000000.00,ConstructionPts__Zipcode__c='29301',
                                                                 ConstructionPts__Status__c='Planholder - GC bids to Owner (by invitation only) September 20 (time per bid invite) (private bid opening)'  
                                                                ));
            cpCompanyList.add(new ConstructionPts__CP_Company__c(Name='company'+i,ConstructionPts__Company_key__c='TES00-000'+i,ConstructionPts__CompanyID__c=''+i,
                                                                 ConstructionPts__Address__c='305 SAINT PETER ST',ConstructionPts__City__c='SAINT PAUL',
                                                                 ConstructionPts__State__c='MN',ConstructionPts__Zipcode__c='55102-1607',
                                                                 ConstructionPts__Country__c='United States',ConstructionPts__County__c='Ramsey County'
                                                                ));
            cpContactList.add(new ConstructionPts__CP_Contact__c(Name='fName'+i+' lName'+i,ConstructionPts__ContactID__c=i,
                                                                 ConstructionPts__Contact_phone__c='00112211',ConstructionPts__Contact_extension__c='000',
                                                                 ConstructionPts__Contact_email__c='abc@abc.com',ConstructionPts__Contact_title__c='Project Architect'
                                                                ));
            cpRoleTypeList.add(new ConstructionPts__CP_Role_Type__c(name='Role'+i,ConstructionPts__RoleTypeID__c=i));
        }
        //<AS20161101>
        System.runAs(u){
            insert cpProjectList;
            insert cpCompanyList;
            insert cpContactList;
            insert cpRoleTypeList;
        }
        if(cpProjectList != null && cpProjectList.size()>0){
            for(Integer i = 0;i < cpProjectList.size();i++){
                dodgeRoleList.add(new ConstructionPts__CP_Roles__c(ConstructionPts__CP_Project__c=cpProjectList[i].id,
                                                                   ConstructionPts__CP_Company__c=cpCompanyList[i].id,
                                                                   ConstructionPts__CP_Role_Type__c=cpRoleTypeList[i].id,
                                                                   ConstructionPts__CP_Contact__c=cpContactList[i].id));     
            }
        }
        //<AS20161101>
        System.runAs(u){
            insert dodgeRoleList;
        }
        return dodgeRoleList;
    }
    //<AS20161101>
    //<AS20170428>
    static List<Lead>createLead(){
        List <Lead> leadList = new List<Lead>();
        leadList.add(new Lead(Firstname='fName1',LastName=' lName1',Company='aaa',Name_ID__c='1',Dodge_Company_Id__c='TES00-0001',Legacy_Lead_ID__c='CPSF_00-0001^TES00-0001^1^1',OwnerId=Label.External_Initiative_Owner_Name,RecordTypeId=leadRtypeId)); 
        leadList.add(new Lead(Firstname='fName2',LastName=' lName2',Company='aaa',Name_ID__c='2',Dodge_Company_Id__c='TES00-0002',Legacy_Lead_ID__c='CPSF_00-0002^TES00-0002^2^2',OwnerId=Label.External_Initiative_Owner_Name,RecordTypeId=leadRtypeId));  
        leadList.add(new Lead(Firstname='fName3',LastName=' lName3',Company='aaa',Name_ID__c='1',Dodge_Company_Id__c='TES00-0001',Legacy_Lead_ID__c='CPSF_00-0002^TES00-0001^1^1',OwnerId=Label.External_Initiative_Owner_Name,RecordTypeId=leadRtypeId));  
        
        upsert leadList;
        return leadList;
    }
    
    static testMethod void testLeadInserted(){
        Test.startTest();
        //<AS20161101>
        User u = [Select id ,name from User where username =:Label.Batch_SFDC_Deploy_User_Name];
        System.runAs(u){
            List <ConstructionPts__CP_Roles__c> cpRole =  recordCreated();
            
            String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
            cpRole[0].ConstructionPts__CP_Project__c=cpProjectList[1].id;
            update cpRole[0];
        }
        Test.stopTest(); 
    }
    
    static testMethod void testContactMetadataUpdated(){
        Test.startTest();
        //<AS20161101>
        User u = [Select id ,name from User where username =:Label.Batch_SFDC_Deploy_User_Name];
        System.runAs(u){
            recordCreated();
            List <Lead> extlead = createLead();
            ConstructionPts__CP_Contact__c cpConUpdate = [select id,Name,ConstructionPts__Contact_phone__c,ConstructionPts__Contact_email__c,
                                                          ConstructionPts__Contact_title__c,ConstructionPts__Contact_extension__c from ConstructionPts__CP_Contact__c where ConstructionPts__ContactID__c=1];
            
            cpConUpdate.Name='test1test2';
            cpConUpdate.ConstructionPts__Contact_email__c='abc@cba';
            cpConUpdate.ConstructionPts__Contact_phone__c='0000000';
            cpConUpdate.ConstructionPts__Contact_title__c='test';
            update cpConUpdate;
            String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        }
        Test.stopTest();
    }
    
    static testMethod void testCompanyMetadataUpdated(){
        Test.startTest();
        //<AS20161101>
        User u = [Select id ,name from User where username =:Label.Batch_SFDC_Deploy_User_Name];
        system.debug('*******'+u);
        System.runAs(u){
            List <ConstructionPts__CP_Roles__c> cpRole = recordCreated();
            List <Lead> extlead = createLead();
            cpRole[0].ConstructionPts__CP_Contact__c=null;
            update cpRole[0];
            ConstructionPts__CP_Company__c cpCompany = [select id,Name,ConstructionPts__Address__c,ConstructionPts__City__c,ConstructionPts__State__c,
                                                        ConstructionPts__Zipcode__c,ConstructionPts__Country__c,ConstructionPts__County__c from 
                                                        ConstructionPts__CP_Company__c where ConstructionPts__Company_key__c='TES00-0001'];
            cpCompany.name='testcom1';
            cpCompany.ConstructionPts__Country__c='USA';
            update cpCompany;
            String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        }
        Test.stopTest();
    }
}
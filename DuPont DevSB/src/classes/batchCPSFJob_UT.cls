/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Arjun Sharma
Email: arjun.sharma2@tcs.com
Description:  Unit test for batchBICPProject,batchBICPRoleHandler, batchBICPCompanyHandler, batchBICPContactHandler
			  and batchCPSFJob

<AS20161220>
Modified By: Arjun Sharma
Modification Date: 20-Dec-2016
Modification: add SFDC Upload Time field in CP Project to increase code coverage
********************************************************************************/
@isTest
public class batchCPSFJob_UT {
    static List<ConstructionPts__CP_Project__c> cpProjectList = new List<ConstructionPts__CP_Project__c>();
    static List<ConstructionPts__CP_Company__c> cpCompanyList = new List<ConstructionPts__CP_Company__c>();
    static List<ConstructionPts__CP_Contact__c> cpContactList = new List<ConstructionPts__CP_Contact__c>();
    static List<ConstructionPts__CP_Role_Type__c> cpRoleTypeList = new List<ConstructionPts__CP_Role_Type__c>();
    static List<External_Initiative__c> extInitList = new List<External_Initiative__c>();
    static List<ConstructionPts__CP_Roles__c> dodgeRoleList = new List<ConstructionPts__CP_Roles__c>();
    
    static Date myDate = Date.newInstance(2016, 8, 31);
    static DateTime myDateTime = System.today();//<AS20161220>
    
    static void recordCreated(){
        
        for(Integer i = 1; i <= 2; i++){
            cpProjectList.add(new ConstructionPts__CP_Project__c(Name='project'+i,ConstructionPts__Report_Number__c='00-000'+i,ConstructionPts__ProjectID__c=''+i,
                                                                 ConstructionPts__SFDC_Upload_Time__c=myDateTime,//<AS20161220>
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
        
        insert cpProjectList;
        insert cpCompanyList;
        insert cpContactList;
        insert cpRoleTypeList;
        
        if(cpProjectList != null && cpProjectList.size()>0){
            for(Integer i = 0;i < cpProjectList.size();i++){
            	dodgeRoleList.add(new ConstructionPts__CP_Roles__c(ConstructionPts__CP_Project__c=cpProjectList[i].id,
                                                                   ConstructionPts__CP_Company__c=cpCompanyList[i].id,
                                                                   ConstructionPts__CP_Role_Type__c=cpRoleTypeList[i].id,
                                                                   ConstructionPts__CP_Contact__c=cpContactList[i].id));     
            }
        }
        
        insert dodgeRoleList;
    }
    public static testMethod void test_Unitcase(){
        Test.startTest();
        recordCreated();
        batchCPSFJob cpsfbatch = new batchCPSFJob();
        String schedule = '00 08 19 19 1 ? 2019';
        String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        Test.stopTest(); 
    }
}
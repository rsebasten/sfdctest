/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Arjun Sharma
Email: arjun.sharma2@tcs.com
Description:  Unit test for BI_CPProjectHandler

<AS20161101>
Modified By: Arjun Sharma
Modification Date: 01-Nov-2016
Modification: To increase code coverage. 
********************************************************************************/
@isTest(seealldata=false)
private class BI_CPProjectHandler_UT {
    static List<ConstructionPts__CP_Project__c> cpProjectList = new List<ConstructionPts__CP_Project__c>();
 //[01172017] Merge&Spin: changed mydate value to system.today() 
    static Date myDate = System.today();
    static batchCPSFJob cpsfbatch = new batchCPSFJob();
    static String schedule = '00 08 19 19 1 ? 2019';
    static void recordCreated(){
        for(Integer i = 1; i <= 3; i++){
  //[01172017] Merge&Spin: Added  ConstructionPts__SFDC_Upload_Time__c new field in test record
            cpProjectList.add(new ConstructionPts__CP_Project__c(Name='project'+i,ConstructionPts__Report_Number__c='00-000'+i,ConstructionPts__ProjectID__c=''+i,
                                                                 ConstructionPts__SFDC_Upload_Time__c=myDate,
                                                                 ConstructionPts__Report_Version__c=''+i,ConstructionPts__Bid_Date__c=myDate,
                                                                 ConstructionPts__Address__c='150 E. Blackstock Rd. Ste. B',ConstructionPts__City__c='SPARTANBURG',
                                                                 ConstructionPts__Country__c='United States',ConstructionPts__County__c='SPARTANBURG',
                                                                 ConstructionPts__Features_Info__c='Approx 25,000 sq ft interior build-out',ConstructionPts__Search_Names__c='Surfaces , Tyvek',
                                                                 ConstructionPts__Project_Report_URL__c='https://dodge',ConstructionPts__Stories_above__c=8,ConstructionPts__Stories_below__c=1,
                                                                 ConstructionPts__Total_Sq_Ft__c='136829 Total Square Feet',ConstructionPts__Market_Segment_Name__c='Leisure,Engineering',
                                                                 ConstructionPts__Project_Type__c='Supermarket/Convenience Store,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall',//<AS20161015>
                                                                 ConstructionPts__Type_Of_Work__c='New Project',
                                                                 ConstructionPts__Ownership__c='Local Government',ConstructionPts__Structural__c='Structural Steel',
                                                                 ConstructionPts__Stage255__c='GC Bidding-Invitation,Pre-Design',ConstructionPts__State__c='SC',
                                                                 ConstructionPts__Value__c=2000000.00,ConstructionPts__Zipcode__c='29301',
                                                                 ConstructionPts__Spec_Alerts__c='Supermarket/Convenience Store,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall,Parking Garage,Food/Beverage Service,Office,Retail (Other),Shopping Center/Strip Mall',//<AS20161015>
                                                                 ConstructionPts__Status__c='Planholder - GC bids to Owner (by invitation only) September 20 (time per bid invite) (private bid opening)'  
                                                                ));
        }
        
        insert cpProjectList;
    }
    
    static testMethod void testcreateExtInit(){
        Test.startTest();
        recordCreated();
        String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        Test.stopTest();
    }
    
    static testMethod void testupdateExtInit(){
        Test.startTest();
        recordCreated();
        ConstructionPts__CP_Project__c cpProject = [Select Name from ConstructionPts__CP_Project__c where ConstructionPts__Report_Number__c='00-0001'];
        cpProject.Name='ExtInit';
        update cpProject;
		String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        Test.stopTest();
    }
}
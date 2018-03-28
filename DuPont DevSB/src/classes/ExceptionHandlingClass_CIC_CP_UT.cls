/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Vijay Laxmi
Email: vijay.laxmi1@tcs.com
Date:   10/5/2016
Description:  Unit test for ExceptionHandlingClass_CIC_CP
********************************************************************************/
@isTest(seealldata=false)
public class ExceptionHandlingClass_CIC_CP_UT
{
    static List<ConstructionPts__CP_Project__c> cpProjectList = new List<ConstructionPts__CP_Project__c>();
    
    static List<ConstructionPts__CP_Company__c> cpCompanyList = new List<ConstructionPts__CP_Company__c>();
    static List<ConstructionPts__CP_Contact__c> cpContactList = new List<ConstructionPts__CP_Contact__c>();
    static List<ConstructionPts__CP_Role_Type__c> cpRoleTypeList = new List<ConstructionPts__CP_Role_Type__c>();
    static List<ConstructionPts__CP_Roles__c> dodgeRoleList = new List<ConstructionPts__CP_Roles__c>();    
    static Date myDate = Date.newInstance(2016, 8, 31);
    static batchCPSFJob cpsfbatch = new batchCPSFJob();
    static String schedule = '00 08 19 19 1 ? 2019';
    
    static List <ConstructionPts__CP_Roles__c> recordCreated(){
        User u = [Select id ,name from User where username =:Label.Batch_SFDC_Deploy_User_Name];//<AS20161101>
        for(Integer i = 1; i <= 2; i++){
            cpProjectList.add(new ConstructionPts__CP_Project__c(Name='project'+i,ConstructionPts__Report_Number__c='00-000'+i,ConstructionPts__ProjectID__c=''+i,
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
        Integer i = 3;
        cpProjectList.add(new ConstructionPts__CP_Project__c(Name='project'+i,ConstructionPts__Report_Number__c='00-000'+i,ConstructionPts__ProjectID__c=''+i,
                                                                 ConstructionPts__Report_Version__c=''+i,ConstructionPts__Bid_Date__c=myDate,
                                                                 ConstructionPts__Address__c='150 E. Blackstock Rd. Ste. B',ConstructionPts__City__c='SPARTANBURG',
                                                                 ConstructionPts__Country__c='United States',ConstructionPts__County__c='SPARTANBURG',
                                                                 ConstructionPts__Features_Info__c='Approx 25,000 sq ft interior build-out',ConstructionPts__Search_Names__c='Surfaces , Tyvek',
                                                                 ConstructionPts__Project_Report_URL__c='https://dodge',ConstructionPts__Stories_above__c=8000,ConstructionPts__Stories_below__c=1,
                                                                 ConstructionPts__Total_Sq_Ft__c='136829 Total Square Feet',ConstructionPts__Market_Segment_Name__c='Leisure,Engineering',
                                                                 ConstructionPts__Project_Type__c='Supermarket/Convenience Store',ConstructionPts__Type_Of_Work__c='New Project',
                                                                 ConstructionPts__Ownership__c='Local Government',ConstructionPts__Structural__c='Structural Steel',
                                                                 ConstructionPts__Stage255__c='GC Bidding-Invitation',ConstructionPts__State__c='SC',
                                                                 ConstructionPts__Value__c=2000000.00,ConstructionPts__Zipcode__c='29301',
                                                                 ConstructionPts__Status__c='Planholder - GC bids to Owner (by invitation only) September 20 (time per bid invite) (private bid opening)'  
                                                                ));
        
        System.runAs(u){
            insert cpProjectList;
            insert cpCompanyList;
            insert cpContactList;
            insert cpRoleTypeList;
        }
        if(cpCompanyList != null && cpCompanyList.size()>0){
            for(Integer j = 0;j < cpCompanyList.size();j++){
                dodgeRoleList.add(new ConstructionPts__CP_Roles__c(ConstructionPts__CP_Project__c=cpProjectList[j].id,
                                                                   ConstructionPts__CP_Company__c=cpCompanyList[j].id,
                                                                   ConstructionPts__CP_Role_Type__c=cpRoleTypeList[j].id,
                                                                   ConstructionPts__CP_Contact__c=cpContactList[j].id));     
            }
        }
        System.runAs(u){
            insert dodgeRoleList;
        }
        return dodgeRoleList;
    }
    
    static testMethod void testcreateExtInit(){
        Test.startTest();
        recordCreated();
        String jobID = system.schedule('batchCPSFJob',schedule,cpsfbatch);
        Test.stopTest();
    }
    static testMethod void method_2()
	{
        Test.startTest();
        try{
            recordCreated();
            String s;
            s.toLowerCase();
        }catch(Exception e){
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException(e,'testobject','testapp');
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException_xml(e,'errorstring','xmlink','testapp');
            ExceptionHandlingClass_CIC_CP.autoCreatedpsException_SchJob_xml('schedule fail','uploadxmltest','xmlink','testapp');
        } 
        Test.stopTest();
    }
	static testMethod void createEI_Lead() 
	{
		String str ='<Projects><Project><Id>1111111152342</Id>'+
					'<LastUpdated>2016-05-30</LastUpdated>'+
					'<ProjectName>Lanitis – Aphrodite Hills Resort Development – Cyprus</ProjectName>'+
					'<ProjectUrl>http://www.constructionic.com/Projects/Overview/152342</ProjectUrl>'+
					'<ProjectStage>Execution</ProjectStage>'+
					'<ProjectType>New</ProjectType>'+
					'<ProjectLevel>Parent</ProjectLevel>'+
					'<ProjectValue>USD 400.00 million</ProjectValue>'+
					'<Country>CyprusTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT</Country>'+
					'<City>Paphos</City>'+
					'<Region>Europe</Region>'+
					'<ProjectAnnouncementQuarter>2000Q1</ProjectAnnouncementQuarter>'+
					'<ProjectEndQuarter>2017Q2</ProjectEndQuarter>'+
					'<ConstructionStartQuarter>2001Q1</ConstructionStartQuarter>'+
					'<ProjectOverview>Lanitis Development Limited (Lanitis) </ProjectOverview>'+
					'<LatestUpdate>May 2016 – Construction activities are 5 – </LatestUpdate>'+
					'<PrimarySector>Golf Courses; Hotels</PrimarySector>'+  
					'<SecondarySector>ParkTest</SecondarySector>'+
					'<ProjectKeyContacts>'+
					'<KeyContact>'+
					'<KeyContactId>107510111111</KeyContactId>'+
					'<KeyContactType>Main Contractor</KeyContactType>'+
					'<ContactDivision>Contractor</ContactDivision>'+
					'<LeadContact>Neil Oldfield</LeadContact>'+
					'<Company>Southern Golf Ltd</Company>'+
					'<CompanyId>2393588111111</CompanyId>'+
					'<JobTitle>Director</JobTitle>'+
					'<Address>7 Old Square, Warwick</Address>'+
					'<KeyContactCity>Warwickshire</KeyContactCity>'+
					'<KeyContactCountry>United Kingdom</KeyContactCountry>'+
					'<PostCode>CV34 4RA</PostCode>'+
					'<Email>town.hall@pafos.org.cytest</Email>'+
					'<KeyContactCountry>Cyprustset</KeyContactCountry>'+
					'<Telephone>(+44) 1926 4009853331111111111111111111111111111111111111111111111111111111</Telephone>'+
					'<Website>www.southerngolf.co.uk</Website>'+
					'</KeyContact>'+
					'</ProjectKeyContacts>'+
					'</Project></Projects>'; 
		 ctrlCIC_Parse.parseResponseDom(str);  
    }
}
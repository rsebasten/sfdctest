/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/24/2016
Description:    Test class for Batch_CIC_InitialLoad class 

***************************************************************************************************/
@isTest
public class Batch_CIC_InitialLoad_UT 
{
  public static testMethod void test_Unitcase1() 
      {
         test.startTest();
          
          
          
          Document document;

                document = new Document();
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
                document.Body = Blob.valueOf(str);
                document.ContentType = 'application/xml';
                document.DeveloperName = 'my_document';
                document.IsPublic = true;
                document.Name = 'My Document';
                document.FolderId = [select id from folder where name = 'CIC'].id;
          
          system.debug(LoggingLevel.ERROR,'#########'+document);
                insert document;
                testUtilityDatabase.createExtInitative(true);
                testUtilityDatabase.createEIforLead(true);
               database.executebatch(new Batch_CIC_InitialLoad());
         
         test.stopTest();
         
    }   
 }
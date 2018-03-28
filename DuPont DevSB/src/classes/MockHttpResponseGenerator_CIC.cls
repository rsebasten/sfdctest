/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Vijay Laxmi
Email:          vijay.laxmi1@tcs.com
Date:           10/12/2016
Description:    Test Class for ctrlCIC_Parse Mock Response

***************************************************************************************************/
@isTest
global class MockHttpResponseGenerator_CIC implements HttpCalloutMock 
{
	global HTTPResponse respond(HTTPRequest req) 
	{
		
		// Creating XML to Parse "ctrlCICParse" Class
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
		System.assertEquals('GET', req.getMethod());
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/xml');
		res.setBody(str);
		res.setStatusCode(200);
		return res;
	}
}
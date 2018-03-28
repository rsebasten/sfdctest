/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com

TES20130318 refactor HTTP Callout testing to use new MockHTTPCallout interface
********************************************************************************/public class geoProvider_MapQuest2 implements Geography.IGeocodeProvider {

    private static final string PROVIDER_NAME   = 'MAPQUEST2';	
	//private static final string API_KEY    		= 'Dmjtd%7Cluu72968ng%2C2w%3Do5-5wyg1 ';   	//dev: https://www.3ddd.com
	private static final string API_KEY    		= 'Gmjtd%7Clu6zn1ua2d%2C7s%3Do5-lu1g0';   	//prod: https://dupont.secure.force.com
    private static final string API_ENDPOINT    = 'https://www.mapquestapi.com/geocoding/v1/address?key='+API_KEY+'&outFormat=xml&inFormat=xml';  //prod   

 	private static final string MAX_HITS 		= '10';
   	private static final string TEST_RESPONSE 	= '<?xml version="1.0" encoding="UTF-8"?><response><info><statusCode>0</statusCode><messages/><copyright><imageUrl>http://tile21.mqcdn.com/res/mqlogo.gif</imageUrl><imageAltText>© 2010 MapQuest, Inc.</imageAltText><text>© 2010 MapQuest, Inc.</text></copyright></info><results><result><providedLocation><postalCode>63376-6463</postalCode><adminArea1>UNITED STATES</adminArea1><street>4170 N Service Rd</street><adminArea3>MO</adminArea3><adminArea5>Saint Peters</adminArea5></providedLocation><locations><location><street>4170 N Service Rd</street><adminArea5 type="City">Saint Peters</adminArea5><adminArea3 type="State">MO</adminArea3><adminArea4 type="County">St. Charles County</adminArea4><postalCode>63376-6463</postalCode><adminArea1 type="Country">US</adminArea1><geocodeQuality>POINT</geocodeQuality><geocodeQualityCode>P1AAA</geocodeQualityCode><dragPoint>false</dragPoint><sideOfStreet>R</sideOfStreet><displayLatLng><latLng><lat>38.7969</lat><lng>-90.57371</lng></latLng></displayLatLng><linkId>20704847</linkId><type>s</type><latLng><lat>38.79637</lat><lng>-90.57377</lng></latLng></location></locations></result></results><options><maxResults>10</maxResults><thumbMaps>false</thumbMaps><ignoreLatLngInput>false</ignoreLatLngInput><boundingBox/></options></response>';
    private HttpResponse response;                  //This response from the last call
    private HttpRequest request;

    /*-----------------------------------------------------------------------------------
    IGeocodeProvider specific members
    -----------------------------------------------------------------------------------*/
    
    //IGeocodeProvider::getProviderName
    public virtual String getProviderName() {return PROVIDER_NAME;}
    
    //IGeocodeProvider::geocode
    public virtual Geography.GeoCodeResults geocode(Geography.Address aAddress) {
    	string stat;
        if (Geography.IS_TESTMETHOD)	{
        	stat='200';
        }
        else {
	        callService_GeoCode(aAddress);
	        stat = String.valueOf(response.getStatusCode());
		}
	    if (stat == '200')
	        return new Geography.GeoCodeResults(true,stat,'',parse());
	    else
	        return new Geography.GeoCodeResults(false,stat,response.getStatus(),null);
	}

    //IGeocodeProvider::getHttpRequest & getHttpResponse
    public virtual HttpRequest  getHttpRequest()    {return request;}
    public virtual HttpResponse getHttpResponse()   {return response;}
    
    //IGeocodeProvider::parse
    public virtual Geography.GeoAddresses parse() {
		if (Geography.IS_TESTMETHOD)
      			return parseBody(TEST_RESPONSE);  
		else {
			if (response == null)
				return null;
			else 	
				return parseBody(response.getBody());
		}
    }
    	
    //IGeocodeProvider::getAccuracyDesc
	public virtual string getAccuracyDesc(String accuracy) {
		if (accuracy.length()>2) {
			string rtn='<b>Granularity:</b> '+ MapQuestAccuracyDesc.get(accuracy.substring(0,2))+'<br/>';
			rtn +='<b>Street Accuracy:</b> '+StreetAccuracyDesc.get(accuracy.substring(2,3))+'<br/>';
			rtn +='<b>AdminArea Accuracy:</b> '+AdminAreaAccuracyDesc.get(accuracy.substring(3,4))+'<br/>';
			rtn +='<b>Postal Accuracy:</b> '+PostalAccuracyDesc.get(accuracy.substring(4,5));
			return rtn;
		}
		else return 'No Accuracy.';	
	}
    
    
    
    /*
    public Geography.GeoCodeResults batchGeocode(Geography.GeoAddresses gas) {
    	string stat;
        if (Geography.IS_TESTMETHOD)	{
        	stat='200';
        }
        else {
	        callService_BatchGeoCode(gas);
	        stat = String.valueOf(response.getStatusCode());
		}
	    if (stat == '200')
	        return new Geography.GeoCodeResults(true,stat,'', parseBatchGeocodeResponse(response.getBody()) );
	    else
	        return new Geography.GeoCodeResults(false,stat,response.getStatus(),null);
	}
    */
    
    /*-----------------------------------------------------------------------------------
    MAPQUEST specific members
    -----------------------------------------------------------------------------------*/

	private static final MAP<String,String> MapQuestAccuracyDesc = new MAP<String,String> {
		'P1' => 'A specific point location.',
	    'L1' => 'Location: A specific address location.',
		'I1' => 'Intersection: An intersection.',
		'B3' => 'Nearest Numbered Block: The center of a single street block whose numbered range is nearest to the input number. House number range is returned.',
		'B2' => 'Nearest Block Centroid: The center of a single street block, which is located closest to the geographic center of all matching street blocks. No house number range is returned.',
		'B1' => 'Block:	The center of a single street block. House number ranges are returned if available.',
		'Z4' => 'Postal Code: (smallest) Postal code centroid.',
		'A7' => 'Admin Area: (smallest Division) A point representing the center of the administrative area.',
		'Z3' => 'Zip+4:	Postal code centroid.',
		'Z2' => 'Zip+2:	Postal code centroid.',
		'Z1' => 'Zip Code: Postal code centroid.',
		'A6' => 'Admin Area: A point representing the center of the administrative area. Rarely used.',
		'A5' => 'City: A point representing the center of the administrative area. Typically a city center.',
		'A4' => 'County: A point representing the center of the administrative area. Typically a county center.',
		'A3' => 'State:	A point representing the center of the administrative area.',
		'A2' => 'Region: A point representing the center of the administrative area.',
		'A1' => 'Country: A point representing the center of the administrative area. Typically a country center.'
    };
    
    
    	private static final MAP<String,String> StreetAccuracyDesc = new MAP<String,String> {
	    'A' =>  'Exact: Includes standard variations of road types, directionals, numbered roads, and common abbreviations. Examples include Road vs. RD, North vs. N, 2ND vs. Second, and Mount vs. MT.',
		'B' =>  'Good: Includes differences in road type and directionals when they can be determined. Examples include Road vs. Street, North vs. South. This includes matches where the type and directional are supplied but not found in the match or found in the match but not supplied.',
		'C' =>  'Approximate: This includes Soundex, partial, or other fuzzy matching used by the geocoder.',
		'X' =>  'None/NA: Allows no matches at this granularity level.'
    };
    
		private static final MAP<String,String> AdminAreaAccuracyDesc = new MAP<String,String> {
	    'A' =>  'Exact: Areas: Includes common abbreviations when they can be determined. Examples include Mount vs. MT.',
		'B' =>  'Good: Includes differences in road type and directionals when they can be determined. Examples include Road vs. Street, North vs. South. This includes matches where the type and directional are supplied but not found in the match or found in the match but not supplied.',
		'C' =>  'Approximate: Returned administrative areas do match the input administrative areas. This may occur when the postal code input determines the match.',
		'X' =>  'None/NA: Allows no matches at this granularity level.'
    }; 
    
		private static final MAP<String,String> PostalAccuracyDesc = new MAP<String,String> {
	    'A' =>  'Exact: The returned code exactly matches the input postal code at the granularity input. The matched postal code may be more precise than the input.',
		'B' =>  'Good: Returned postal code does not exactly match the input at the granularity of the input. However, it does match the input at a lower granularity level.',
		'C' =>  'Approximate: Returned postal code does not match the input postal code. This may occur when the administrative area input determines the match.',
		'X' =>  'None/NA: Allows no matches at this granularity level.'
    }; 
    
    
	private Geography.GeoAddresses parseBody(string body) {
		Geography.GeoAddresses gas = new Geography.GeoAddresses();
		XMLDom dom = new xmldom(body);   
        //dom.dumpAll(); 
       return parseGeoAddresses(dom.getElementByTagName('locations'));
	}
	

    

  
	/***
   	parseGeoAddresses return all the GeoAddresses in element argument
    ***/
  	private static Geography.GeoAddresses parseGeoAddresses(XMLdom.Element e) {
		Geography.GeoAddresses gas = new Geography.GeoAddresses();
		if (e!=null) {
	        for(XMLdom.Element ee : e.getElementsByTagName('location') ) {
	            gas.add(parseGeoAddress(ee));
	        }
		}
		return gas;
	}  
	
	
	/***
   	parseGeoAddresses parse GeoAddress XML element to Geography.GeoAddress
    ***/	
	private static Geography.GeoAddress parseGeoAddress(XMLdom.Element ee) {
		Geography.geoAddress ga = new Geography.geoAddress();
		ga.Address = new Geography.Address(ee.getValue('street'),ee.getValue('adminArea5'),ee.getValue('adminArea3'),ee.getValue('postalCode'),ee.getValue('adminArea1'));
		ga.County = ee.getValue('adminArea4');
		ga.LngLat = new Geography.LngLat(ee.getValue('Lng'),ee.getValue('Lat'));
		ga.accuracy = ee.getValue('geocodeQualityCode');
		return ga;
	}
   
   
   // <address><location><street>Lancaster,PA</street></location><options><thumbMaps>false</thumbMaps><maxResults>10</maxResults></options></address>
    //build a request
    private static string getRequestBody(Geography.Address address) {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('UTF-8','1.0');
        w.writeStartElement(null,'address',null);
            w.writeAttribute(null,null,'Version','1');
            w.writeStartElement(null,'location',null);
                writeSimpleElement(w,'adminArea1', address.Country);
                writeSimpleElement(w,'adminArea3', address.State);
                writeSimpleElement(w,'adminArea5', address.City);
                writeSimpleElement(w,'postalCode', address.PostalCode);
                writeSimpleElement(w,'street', address.Street);
            w.writeEndElement();   
			w.writeStartElement(null,'options',null);
				writeSimpleElement(w,'thumbMaps', 'false');
				writeSimpleElement(w,'maxResults', MAX_HITS);
			w.writeEndElement(); 
		w.writeEndElement();  
        return w.getXMLString();            
    }
    
    private static void writeSimpleElement(XmlStreamWriter w, string nodename, string value)
    {
        if (value !=null && nodename != null) {
            w.writeStartElement(null,nodename,null);
            w.writeCharacters(value);
            w.writeEndElement();
        }
    }
    
    
    HttpResponse callService_GeoCode(Geography.Address aAddress)
    {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');
        request.setHeader('Cache-Control','no-cache');
        request.setHeader('referer', 'https://dupont.secure.force.com'); 
        request.setEndpoint(API_ENDPOINT);
        request.setBody(getRequestBody(aAddress));
        Http http = new http();
        response = http.send(request);
		for (string h : response.getHeaderKeys())
			if (h!=null)
				system.debug('-----RESPONSE HEADER: ---> '+h+':'+response.getHeader(h));
        return response;
    }
    
    /*
    //Batch mode
	public HttpResponse callService_BatchGeoCode(Geography.geoAddresses gas)
    {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');
        //req.setHeader('referer','https://www.salesforce.com');
        request.setEndpoint(API_ENDPOINT);
        request.setBody(getBatchGeocodeRequest(gas));
        system.debug('----OUTBOUND PAYLOAD---->'+request.getBody());
        Http http = new http();
        response = http.send(request);
        system.debug('----INBOUND PAYLOAD---->'+response.getBody());
        return response;
    } 
*/
    

/*
************************************************************************************************
    tests
************************************************************************************************
*/
    Public static testMethod void testMapQuest2() {
        Geography.Address add = new Geography.Address('12 Main St', 'Newark', 'DE','19711','US');
        system.debug(add);
        system.debug(getRequestBody(add));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UtilUT.MockHttpResponse(TEST_RESPONSE));
        geoProvider_MapQuest2 p = new geoProvider_MapQuest2();
        p.getProviderName();
        Geography.GeoAddresses gas = p.geocode(add).GeoAddresses;
        system.debug(p.getHttpRequest());
        system.debug(p.getHttpResponse());
        
        system.debug(gas.size());
        system.debug(p.getAccuracyDesc(gas.getGeoAddress(0).accuracy));
        Test.stopTest();

    }

}
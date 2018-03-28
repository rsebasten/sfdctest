/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com

TES20130318 refactor HTTP Callout testing to use new MockHTTPCallout interface
********************************************************************************/
public class geoProvider_MapQuest implements Geography.IGeocodeProvider {
//CLIENT_ID = "31987";
//PASSWORD = "LMfqB4nt";
    //private static final string API_PASSWORD  = 'mJ7pU2uJ';   //dev
    //private static final string API_CLIENTID  = '75756';      //dev
    //private static final string API_ENDPOINT  = 'http://geocode.dev.mapquest.com/mq/mqserver.dll?e=5';  //dev
    
    private static final string PROVIDER_NAME   = 'MAPQUEST';	
    private static final string API_PASSWORD    = 'LMfqB4nt';   //prod
    private static final string API_CLIENTID    = '31987';      //prod
    private static final string API_ENDPOINT    = 'http://geocode.access.mapquest.com/mq/mqserver.dll?e=5';  //prod   

 	private static final string MAX_HITS 		= '10';
   	private static final string TEST_RESPONSE 	= '<?xml version="1.0" encoding="ISO-8859-1"?><GeocodeResponse><LocationCollection Count="1"><GeoAddress><AdminArea1>US</AdminArea1><AdminArea3>DE</AdminArea3><AdminArea4>New Castle County</AdminArea4><AdminArea5>Newark</AdminArea5><PostalCode>19711</PostalCode><LatLng><Lat>39.702700</Lat><Lng>-75.735900</Lng></LatLng><ResultCode>Z1XAA</ResultCode><SourceId>tana</SourceId></GeoAddress></LocationCollection></GeocodeResponse>';
    
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
    
    
    /*-----------------------------------------------------------------------------------
    MAPQUEST specific members
    -----------------------------------------------------------------------------------*/

	private static final MAP<String,String> MapQuestAccuracyDesc = new MAP<String,String> {
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
       return parseGeoAddresses(dom.getElementByTagName('LocationCollection'));
	}
	
	

	
	

    //class object to represents the MapQuest geoAddress Object
    public class mqGeoAddress {
        /* Constructors */
        public mqGeoAddress(){}//clear();
        public mqGeoAddress(
            string Street, string City, string State, string PostalCode, string Country ) {
            //clear();
            this.AdminArea1=Country;
            this.AdminArea3=State;
            this.AdminArea5=City;
            this.Street=Street;
            this.PostalCode=PostalCode;
        }
        public string AdminArea1 {set; get;}    //Country
        public string AdminArea2 {set; get;}    //?
        public string AdminArea3 {set; get;}    //State Providence
        public string AdminArea4 {set; get;}    //County or Similar
        public string AdminArea5 {set; get;}    //City
        public string AdminArea6 {set; get;}
        public string AdminArea7 {set; get;}
        public string PostalCode {set; get;}
        public string Street {set; get;}
        public string Lat {set; get;}
        public string Lng {set; get;}
        public string ResultCode {set; get;}
        public string DistAlong {set; get;}
        public string SourceId {set; get;}
        
        /*
        public void clear() {
            //setting these values to a empty corrects issue on retrieving previous values
            AdminArea1='';
            AdminArea2='';
            AdminArea3='';
            AdminArea4='';
            AdminArea5='';
            AdminArea6='';
            AdminArea7='';
            PostalCode='';
            Street='';
            Lat='';
            Lng='';
            ResultCode='';
            DistAlong='';
            SourceId='';
        }
        */
        public Geography.geoAddress toGeoAddress() {
            return new Geography.geoAddress(new Geography.Address(Street,AdminArea5,AdminArea3,PostalCode,AdminArea1),AdminArea4,null,null,null,
                new Geography.LngLat(Lng,Lat),ResultCode);
        }
    }
    

    
    public static mqGeoAddress[] parseResponse(string Response) {
        List<mqGeoAddress> gas = new List<mqGeoAddress>();
        xmldom d = new xmldom(Response);  
        d.dumpAll(); 
        //system.debug ( d.getElementsByTagName('GeoAddress') ); 
        for(XMLdom.Element ee:d.getElementsByTagName('GeoAddress')) {
            mqGeoAddress ga = new mqGeoAddress();
            //ga.clear();
            ga.AdminArea1 =  ee.getValue('AdminArea1');
            ga.AdminArea2 =  ee.getValue('AdminArea2');
            ga.AdminArea3 =  ee.getValue('AdminArea3');
            ga.AdminArea4 =  ee.getValue('AdminArea4');
            ga.AdminArea5 =  ee.getValue('AdminArea5');
            ga.PostalCode =  ee.getValue('PostalCode');
            ga.Street     =  ee.getValue('Street');
            ga.Lng        =  ee.getValue('Lng');
            ga.Lat        =  ee.getValue('Lat');
            ga.ResultCode =  ee.getValue('ResultCode');
            ga.DistAlong  =  ee.getValue('DistAlong');
            ga.SourceId   =  ee.getValue('SourceId');
            gas.add(ga);
            } 
        //XMLdom.Element ee = new xmldom.Element();  
        return gas;
    }
    
    private static string getBatchGeocodeRequest(Geography.geoAddresses gas) {
		XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('utf-8','1.0');
        w.writeStartElement(null,'BatchGeocode',null);
        	w.writeStartElement(null,'LocationCollection',null);
	            w.writeAttribute(null,null,'Count',String.valueof(gas.size()));
	            for ( Geography.geoAddress ga : gas.getMap().values() ) {
		            w.writeStartElement(null,'Address',null);
		                writeSimpleElement(w,'AdminArea1', ga.address.Country);
		                writeSimpleElement(w,'AdminArea3', ga.address.state);
		                writeSimpleElement(w,'AdminArea5', ga.address.City);
		                writeSimpleElement(w,'PostalCode', ga.address.PostalCode);
		                writeSimpleElement(w,'Street', ga.address.Street);
		            w.writeEndElement();   
	            } 
			w.writeEndElement(); 
            w.writeStartElement(null,'AutoGeocodeCovSwitch',null);
                writeSimpleElement(w,'Name', 'mqgauto');
                writeSimpleElement(w,'MaxMatches', '2');
            w.writeEndElement();   
            w.writeStartElement(null,'Authentication',null);
                w.writeAttribute(null,null,'Version','2');  
                writeSimpleElement(w,'Password', API_PASSWORD);
                writeSimpleElement(w,'ClientId', API_CLIENTID);
        	w.writeEndElement();         
		w.writeEndElement();    
        return w.getXMLString(); 
    }
    
    
    
    /***
    parseBatchGeocodeResponse return the first GeoAddress in Each LocationCollection
    ***/
    public Geography.GeoAddresses parseBatchGeocodeResponse(string xml) {
    	Geography.GeoAddresses gas = new geography.GeoAddresses();
		XMLDom dom = new xmldom(xml);  
		XMLdom.Element lcc = dom.getElementByTagName('LocationCollectionCollection');
		for(XMLdom.Element ee : lcc.getElementsByTagName('LocationCollection')) {
	        	gas.add(parseGeoAddress(ee.getElementByTagName('GeoAddress')));
			}
		return gas;	
		}
  
	/***
   	parseGeoAddresses return all the GeoAddresses in element argument
    ***/
  	private static Geography.GeoAddresses parseGeoAddresses(XMLdom.Element e) {
		Geography.GeoAddresses gas = new Geography.GeoAddresses();
        for(XMLdom.Element ee : e.getElementsByTagName('GeoAddress') ) {
            gas.add(parseGeoAddress(ee));
        }
        return gas;
	}  
	
	
	/***
   	parseGeoAddresses parse GeoAddress XML element to Geography.GeoAddress
    ***/	
	private static Geography.GeoAddress parseGeoAddress(XMLdom.Element ee) {
		Geography.geoAddress ga = new Geography.geoAddress();
		ga.Address = new Geography.Address(ee.getValue('Street'),ee.getValue('AdminArea5'),ee.getValue('AdminArea3'),ee.getValue('PostalCode'),ee.getValue('AdminArea1'));
		ga.County = ee.getValue('AdminArea4');
		ga.LngLat = new Geography.LngLat(ee.getValue('Lng'),ee.getValue('Lat'));
		ga.accuracy = ee.getValue('ResultCode');
		return ga;
	}
   
    //build a request
    private static string getRequestBody(mqGeoAddress address) {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('utf-8','1.0');
        w.writeStartElement(null,'Geocode',null);
            w.writeAttribute(null,null,'Version','1');
            w.writeStartElement(null,'Address',null);
                writeSimpleElement(w,'AdminArea1', address.AdminArea1);
                writeSimpleElement(w,'AdminArea3', address.AdminArea3);
                writeSimpleElement(w,'AdminArea5', address.AdminArea5);
                writeSimpleElement(w,'PostalCode', address.PostalCode);
                writeSimpleElement(w,'Street', address.Street);
            w.writeEndElement();    
			w.writeStartElement(null,'AutoGeocodeCovSwitch',null);
				writeSimpleElement(w,'Name', 'mqgauto');
				writeSimpleElement(w,'MaxMatches', MAX_HITS);
			w.writeEndElement(); 
            w.writeStartElement(null,'Authentication',null);
                w.writeAttribute(null,null,'Version','2');  
                writeSimpleElement(w,'Password', API_PASSWORD);
                writeSimpleElement(w,'ClientId', API_CLIENTID);     
            w.writeEndElement();    
            w.writeEndElement();    
        return w.getXMLString();            
    }
    
    
    //build a request
    private static string getRequestBody(Geography.Address address) {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument('utf-8','1.0');
        w.writeStartElement(null,'Geocode',null);
            w.writeAttribute(null,null,'Version','1');
            w.writeStartElement(null,'Address',null);
                writeSimpleElement(w,'AdminArea1', address.Country);
                writeSimpleElement(w,'AdminArea3', address.State);
                writeSimpleElement(w,'AdminArea5', address.City);
                writeSimpleElement(w,'PostalCode', address.PostalCode);
                writeSimpleElement(w,'Street', address.Street);
            w.writeEndElement();   
       /*            
			 <GeocodeOptionsCollection Count="1">
				<GeocodeOptions>
						<CoverageName>navt</CoverageName>
						<QualityType>0</QualityType>
						<MaxMatches>10</MaxMatches>
						<MaxType>12</MaxType>
				</GeocodeOptions>
			</GeocodeOptionsCollection>    
		*/ 
			/*     
            w.writeStartElement(null,'GeocodeOptionsCollection',null);
                w.writeAttribute(null,null,'Count','1');
				w.writeStartElement(null,'GeocodeOptions',null);
					writeSimpleElement(w,'CoverageName', '');
	                writeSimpleElement(w,'QualityType', '0');
	                writeSimpleElement(w,'MaxMatches', '20');
	                writeSimpleElement(w,'MaxType', '0');
                w.writeEndElement(); 
            w.writeEndElement(); 
            */
    		/*             
			<AutoGeocodeCovSwitch>
				<Name>mqgauto</Name>
			<MaxMatches>2</MaxMatches>
				</AutoGeocodeCovSwitch>                
      		*/           
            
			w.writeStartElement(null,'AutoGeocodeCovSwitch',null);
				writeSimpleElement(w,'Name', 'mqgauto');
				writeSimpleElement(w,'MaxMatches', MAX_HITS);
			w.writeEndElement(); 
                
            w.writeStartElement(null,'Authentication',null);
                w.writeAttribute(null,null,'Version','2');  
                writeSimpleElement(w,'Password', API_PASSWORD);
                writeSimpleElement(w,'ClientId', API_CLIENTID);     
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
        //req.setHeader('referer','https://www.salesforce.com');
        request.setEndpoint(API_ENDPOINT);
        request.setBody(getRequestBody(aAddress));
        Http http = new http();
        response = http.send(request);
        return response;
    }
    
    
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

    

/*
************************************************************************************************
    tests
************************************************************************************************
*/
    Public static testMethod void testMapQuest() {

        mqGeoAddress a = new mqGeoAddress('12 Main St', 'Newark', 'DE','19711','US');
        system.debug(getRequestBody(a));
        mqGeoAddress[] results = parseResponse(TEST_RESPONSE);
        system.debug(results[0]);
        
        Geography.Address add = a.toGeoAddress().address;
        system.debug(add);
        system.debug(getRequestBody(add));
        
 		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UtilUT.MockHttpResponse(TEST_RESPONSE));       
        geoProvider_MapQuest p = new geoProvider_MapQuest();
        p.getProviderName();
        Geography.GeoAddresses gas = p.geocode(add).GeoAddresses;
        system.debug(p.getHttpRequest());
        system.debug(p.getHttpResponse());
        
        system.debug(gas.size());
        system.debug(p.getAccuracyDesc(gas.getGeoAddress(0).accuracy));
        system.debug(p.getAccuracyDesc(''));
        system.debug(p.getAccuracyDesc('XXXXX'));
		Test.stopTest();
    }

}
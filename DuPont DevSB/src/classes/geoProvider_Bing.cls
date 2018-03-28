/*******************************************************************************
TES20130318 refactor HTTP Callout testing to use new MockHTTPCallout interface
********************************************************************************/
public class geoProvider_Bing implements Geography.IGeocodeProvider {

	private static final string PROVIDER_NAME 		= 'BING';				
	private static final string TEST_RESPONSE 		= '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><GeocodeResponse xmlns="http://dev.virtualearth.net/webservices/v1/geocode/contracts"><GeocodeResult xmlns:a="http://dev.virtualearth.net/webservices/v1/geocode" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><BrandLogoUri xmlns="http://dev.virtualearth.net/webservices/v1/common">http://dev.virtualearth.net/Branding/logo_powered_by.png</BrandLogoUri><ResponseSummary xmlns="http://dev.virtualearth.net/webservices/v1/common"><AuthenticationResultCode>ValidCredentials</AuthenticationResultCode><Copyright>Copyright © 2010 Microsoft and its suppliers. All rights reserved. This API cannot be accessed and the content and any results may not be used, reproduced or transmitted in any manner without express written permission from Microsoft Corporation.</Copyright><FaultReason i:nil="true"/><StatusCode>Success</StatusCode><TraceId>f7f854ac535a4b6180ba902e58cd2310|BL1AQ23519|02.00.48.300|AQ23405</TraceId></ResponseSummary><a:Results xmlns:b="http://dev.virtualearth.net/webservices/v1/common"><b:GeocodeResult><b:Address><b:AddressLine>222 Planet Rd</b:AddressLine><b:AdminDistrict>DE</b:AdminDistrict><b:CountryRegion>United States</b:CountryRegion><b:District/><b:FormattedAddress>222 Planet Rd, Newark, DE 19711-2927</b:FormattedAddress><b:Locality>Newark</b:Locality><b:PostalCode>19711-2927</b:PostalCode><b:PostalTown/></b:Address><b:BestView><b:Northeast><b:Altitude>0</b:Altitude><b:Latitude>39.761269717570677</b:Latitude><b:Longitude>-75.718396891181513</b:Longitude></b:Northeast><b:Southwest><b:Altitude>0</b:Altitude><b:Latitude>39.753544282429324</b:Latitude><b:Longitude>-75.731795108818474</b:Longitude></b:Southwest></b:BestView><b:Confidence>High</b:Confidence><b:DisplayName>222 Planet Rd, Newark, DE 19711-2927</b:DisplayName><b:EntityType>Address</b:EntityType><b:Locations><b:GeocodeLocation><b:Altitude>0</b:Altitude><b:Latitude>39.757407</b:Latitude><b:Longitude>-75.725096</b:Longitude><b:CalculationMethod>Parcel</b:CalculationMethod></b:GeocodeLocation><b:GeocodeLocation><b:Altitude>0</b:Altitude><b:Latitude>39.757397</b:Latitude><b:Longitude>-75.725542</b:Longitude><b:CalculationMethod>Interpolation</b:CalculationMethod></b:GeocodeLocation></b:Locations><b:MatchCodes xmlns:c="http://schemas.microsoft.com/2003/10/Serialization/Arrays"><c:string>Good</c:string></b:MatchCodes></b:GeocodeResult></a:Results></GeocodeResult></GeocodeResponse></s:Body></s:Envelope>';
	private static final string API_KEY				= 'AgukyZB9hEcG9ub_EdW34UKzKpzFiWZpHtbATf7NeM7Jj3F6TCYBmYnXDdAV2l2N';
	private static final string API_ENDPOINT		= 'https://dev.virtualearth.net/webservices/v1/geocodeservice/GeocodeService.svc';
	private static final string SOAPACTION			= 'http://dev.virtualearth.net/webservices/v1/geocode/contracts/IGeocodeService/Geocode';
	private static string envelope='';
	
	static {
			envelope+='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:m0="http://dev.virtualearth.net/webservices/v1/common" xmlns:m1="http://dev.virtualearth.net/webservices/v1/geocode">';
			envelope+='<SOAP-ENV:Body><m:Geocode xmlns:m="http://dev.virtualearth.net/webservices/v1/geocode/contracts">';
			envelope+='<m:request><m0:Credentials><m0:ApplicationId>{0}</m0:ApplicationId></m0:Credentials>';
			envelope+='<m0:Culture>{2}</m0:Culture>';
			envelope+='<m0:ExecutionOptions><m0:SuppressFaults>false</m0:SuppressFaults></m0:ExecutionOptions>';
			envelope+='<m1:Query>{1}</m1:Query></m:request></m:Geocode></SOAP-ENV:Body></SOAP-ENV:Envelope>';
	}
			
    private HttpResponse response;  
    private HttpRequest request;
    
    
    /*-----------------------------------------------------------------------------------
    IGeocodeProvider specific members  
    (will eventually try to make these abstract methods.. 
    try to keep consistant across providers were possible. )
    -----------------------------------------------------------------------------------*/
    
    //IGeocodeProvider::getProviderName
    public virtual String getProviderName() {return PROVIDER_NAME;}
    
	//IGeocodeProvider::geocode
    public virtual Geography.GeoCodeResults geocode(Geography.Address aAddress) {
    	string stat;
        if (Geography.IS_TESTMETHOD)	{
        	stat='Success';
        }
        else {
	        callService_GeoCode(aAddress);
	        //stat = String.valueOf(response.getStatusCode());
	        stat = parseStatus(response.getBody());
		}
	    if (stat == 'Success')
	        return new Geography.GeoCodeResults(true,stat,'',parse());
	    else {
	    	string errmsg=stat; //TODO:  get the FaultReason
	    	return new Geography.GeoCodeResults(false,stat,errmsg,null);
	    }  
	}
	
    //IGeocodeProvider::getHttpRequest & getHttpResponse
    public virtual HttpRequest  getHttpRequest()    {return request;}
    public virtual HttpResponse getHttpResponse()   {return response;}
    
    
    //IGeocodeProvider::parse
    public virtual Geography.GeoAddresses parse() {
      		if (Geography.IS_TESTMETHOD)
      			return parseBody(TEST_RESPONSE);  
			else
			if (response == null)
				return null;
			else 	
				return parseBody(response.getBody());
    }
    
    	public virtual string getAccuracyDesc(String accuracy) {
			return accuracy;
	}
    

/*
//////////////////////////////////////////////////////////////////////////////////////////////

*/
	private Geography.GeoAddresses parseBody() { return parseBody(TEST_RESPONSE); }
	private Geography.GeoAddresses parseBody(string body) {
		Geography.GeoAddresses gas = new Geography.GeoAddresses();
		XmlDom dom = new xmldom(body);   
        //dom.dumpAll(); 
        XMLdom.Element eResults = dom.getElementByTagName('a:Results');
        for(XMLdom.Element ee: eResults.getElementsByTagName('b:GeocodeResult')) {
            Geography.geoAddress ga = new Geography.geoAddress();
            ga.Address = new Geography.Address(ee.getValue('b:AddressLine'),ee.getValue('b:Locality'),ee.getValue('b:AdminDistrict'),ee.getValue('b:PostalCode'),ee.getValue('b:CountryRegion'));
            ga.County = ee.getValue('b:District');
            ga.CityDistrict = ee.getValue('b:PostalTown');
            ga.LngLat = new Geography.LngLat(ee.getValue('b:Longitude'),ee.getValue('b:Latitude'));
            ga.accuracy = ee.getValue('b:Confidence');
            gas.add(ga);
            } 
        return gas;
        
	}
	
   	private string getRequestBody(Geography.Address aAddress)
    {
    	return String.format(envelope, new LIST<string>{API_KEY, aAddress.format(), UserInfo.getLocale().replace('_','-')} );
    }
    
    
    HttpResponse callService_GeoCode(Geography.Address aAddress)
    {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');
        request.setHeader('SOAPAction',SOAPACTION);
        request.setEndpoint(API_ENDPOINT);
        request.setBody(getRequestBody(aAddress));
        Http http = new http();
        response = http.send(request);
        return response;
    }
    
     public static string parseStatus(String axml) {
		XmlDom dom = new xmldom(axml);   
        return dom.root.getValue('StatusCode');  
    }
    
 
    static testMethod void testBing() {
    	
        parseStatus(TEST_RESPONSE);
        Geography.Address add = new Geography.Address('12 Main St', 'Newark', 'DE','19711','US');
        system.debug(add);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UtilUT.MockHttpResponse(TEST_RESPONSE));
        
        geoProvider_Bing p = new geoProvider_Bing();
        system.debug(p.getProviderName());
        Geography.GeoAddresses gas = p.geocode(add).GeoAddresses;
        system.debug(gas);
        system.debug(p.getHttpRequest());
        system.debug(p.getHttpResponse());
        
        system.debug(gas.size());
        system.debug(p.getAccuracyDesc(gas.getGeoAddress(0).accuracy));
        system.debug(p.getAccuracyDesc(''));
        system.debug(p.getAccuracyDesc('XXXXX'));
        Test.stopTest();

    }
        
}
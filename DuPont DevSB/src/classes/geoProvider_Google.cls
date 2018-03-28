/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com

TES20130318 refactor HTTP Callout testing to use new MockHTTPCallout interface
********************************************************************************/
public class geoProvider_Google implements Geography.IGeocodeProvider{

	private static final string PROVIDER_NAME = 'GOOGLE2';				
	private static final string TEST_RESPONSE = 	'<?xml version="1.0" encoding="utf-8" ?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>35764 Tarpon Dr 19958 DE USA</name><Status><code>200</code><request>geocode</request></Status><Placemark id="p1"><address>35764 Tarpon Dr, Lewes, DE 19958, USA</address><AddressDetails xmlns="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0" Accuracy="8"><Country><CountryNameCode>US</CountryNameCode><AdministrativeArea><AdministrativeAreaName>DE</AdministrativeAreaName><Locality><LocalityName>Lewes</LocalityName><Thoroughfare><ThoroughfareName>35764 Tarpon Dr</ThoroughfareName></Thoroughfare><PostalCode><PostalCodeNumber>19958</PostalCodeNumber></PostalCode></Locality></AdministrativeArea></Country></AddressDetails><Point><coordinates>-75.126489,38.763439,0</coordinates></Point></Placemark></Response></kml>';  									   
    //private static final string API_KEY='ABQIAAAAuIWSkGrGNZqgHHypd712uxS3_1N4Yxz2oiPkYQK94qz_LJ5BihSVItmuTw3l48GPyNBgMQ7KHmwDfA';  //orig working
	//private static final string API_KEY='ABQIAAAAuIWSkGrGNZqgHHypd712uxSaxC92qWpvsfLMnPYt2YVHzVh2whSk4St6QNzEw19EcHck5PydvqI9Jg'; //http://force.com
	//private static final string API_KEY='ABQIAAAAuIWSkGrGNZqgHHypd712uxQvLd5AS3Z1MVIjYhUrL70me9fKcRQnNt-vG3QDV7nf_wQVG3s_4DVbkg'; //https://force.com
	//private static final string API_KEY='ABQIAAAAuIWSkGrGNZqgHHypd712uxT4L3W42chgXTqU01Fy6SUXHySjORSISsfPTgL_96uzcVQzTNmgEtszUw'; //http://proxy-sjl.salesforce.com
	private static final string API_KEY='ABQIAAAAuIWSkGrGNZqgHHypd712uxQV02rfU2EFnRAMOYWcnS79hwPLEBTgD4K4dQbUjLuh0mIJkCkXkMwyIw'; //https://proxy-sjl.salesforce.com
	private static string userlanguage = null;
	private static string userCountry  = null;
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
			else
			if (response == null)
				return null;
			else 	
				return parseBody(response.getBody());
    }
    
    	public virtual string getAccuracyDesc(String accuracy) {
			return AccuracyDescription.get(accuracy);
	}
    

/*
//////////////////////////////////////////////////////////////////////////////////////////////
*/


	private Geography.GeoAddresses parseBody(string body) {
		Geography.GeoAddresses gas = new Geography.GeoAddresses();
		XmlDom dom = new xmldom(body);   
        //dom.dumpAll(); 
        for(XMLdom.Element ee:dom.getElementsByTagName('Placemark')) {
            Geography.geoAddress ga = new Geography.geoAddress();
            ga.Address = new Geography.Address(ee.getValue('ThoroughfareName'),ee.getValue('LocalityName'),ee.getValue('AdministrativeAreaName'),ee.getValue('PostalCodeNumber'),ee.getValue('CountryNameCode'));
            ga.County = ee.getValue('SubAdministrativeAreaName');
            ga.CityDistrict = ee.getValue('DependentLocalityName');
            ga.LngLat = new Geography.LngLat(ee.getValue('Coordinates'));
            ga.accuracy = ee.getElementByTagName('AddressDetails').getAttribute('Accuracy');
            gas.add(ga);
            } 
        return gas;
	}

    private string getQueryString(Geography.Address a){
        string q='';
        if (a != null) {
            if (a.Street != null)            q += a.Street + ' ';
            if (a.City != null )             q += a.City + ' ';
            if (a.State != null )            q += a.State + ' ';
            if (a.PostalCode!= null )        q += a.PostalCode + ' ';
            if (a.Country != null )          q += a.Country;
            }
        return EncodingUtil.urlEncode(q,'UTF-8');
    }
    
    private string getUserLanguage() {
    	if (userlanguage == null) {
    		if (UserInfo.getLanguage().length() >=2) 
    			userlanguage=UserInfo.getLanguage().substring(0,2);
    		else
    			userlanguage='en';
    	}
    	return userlanguage;
    }
    
    private string getUserCountry() {
    	if (userCountry == null) {
    		if (UserInfo.getLocale().length() >=2) 
    			userCountry=UserInfo.getLocale().substring(0,2);
    		else
    			userCountry='us';
    	}
    	return userCountry;
    }
    
    HttpResponse callService_GeoCode(Geography.Address aAddress)
    {
        request = new HttpRequest();
        Http http = new http();
        request.setMethod('GET');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        //request.setHeader('referer','https://www.salesforce.com');
        request.setHeader('referer','https://proxy-sjl.salesforce.com');
        
        request.setEndpoint('http://maps.google.com/maps/geo?q='+getQueryString(aAddress)+'&output=xml&oe=utf8&sensor=false&hl='+getUserLanguage()+'&gl='+getUserCountry()+'&v=2.1&key='+API_KEY);
        response = http.send(request);
        return response;
    }
   
   
   /**   
    public class OASIS_xAL {
        public String thoroughfareName {set; get;}
        public String countryNameCode {set; get;}
        public String administrativeAreaName  {set; get;}
        public String subAdministrativeAreaName  {set; get;}
        public String localityName  {set; get;}
        public String postalCodeNumber {set; get;}
        //public LngLat Coordinates {set; get;}
        //public String Accuracy {set; get;}
    }
	**/
    
    
   public class GoogPlacemark {
        public String url {set; get;}
        public String id {set; get;}
        public String thoroughfareName {set; get;}
        public String countryNameCode {set; get;}
        public String administrativeAreaName  {set; get;}
        public String subAdministrativeAreaName  {set; get;}
        public String localityName  {set; get;}
        public String postalCodeNumber {set; get;}
        public String coordinates {set; get;}
        public String accuracy {set; get;}
    }
    
    public class googCoor {
        public Double Lng {set; get;}
        public Double Lat {set; get;}
        
        googCoor(String Coordinates) {
            String[] coor = Coordinates.split(',',3);
            if (coor.size()>1) {
                Lng = Double.valueOf(coor[0]);
                Lat = Double.valueOf(coor[1]);
            }
        }
    }
    
    
    public static googPlacemark[] parseKML(String kml) {
        googPlacemark[] placemarks = new googPlacemark[0];
        XmlStreamReader r = new XmlStreamReader(kml);
        while (r.hasnext()) {
            if ( r.getEventType()== XmlTag.START_ELEMENT ) {
                if (r.getLocalName() == 'Placemark' ) {
                    googPlacemark placemark = parsePlacemark(r);
                    placemark.url=accountURL(placemark);
                    placemarks.add(placemark);
                }
            }
            r.next();
        }
        return placemarks;
    }
    
     public static string parseKMLStatus(String kml) {
        XmlStreamReader r = new XmlStreamReader(kml);
         return getValue(r,'Code');
    }
    
 
    
    private static googPlacemark parsePlacemark(XmlStreamReader r) {
            googPlacemark pm = new googPlacemark();
            //pm.clear();
            pm.id = r.getAttributeValue(null,'id');
            while (r.hasnext()) {
                if ( r.getEventType()== XmlTag.END_ELEMENT && r.getLocalName() == 'Placemark')
                    break;
                else if ( r.getEventType()== XmlTag.START_ELEMENT ) {
                    string ln=r.getLocalName();
                    if (ln == 'ThoroughfareName' ) pm.thoroughfareName = getValue(r,ln);
                    else if (ln == 'CountryNameCode' ) pm.countryNameCode = getValue(r,ln);
                    else if (ln == 'AdministrativeAreaName' ) pm.administrativeAreaName = getValue(r,ln);
                    else if (ln == 'SubAdministrativeAreaName' ) pm.subAdministrativeAreaName = getValue(r,ln);
                    else if (ln == 'LocalityName' ) pm.localityName = getValue(r,ln);
                    else if (ln == 'PostalCodeNumber' ) pm.postalCodeNumber = getValue(r,ln);
                    else if (ln == 'Coordinates' ) pm.coordinates = getValue(r,ln);
                    else if (ln == 'AddressDetails' ) pm.accuracy = r.getAttributeValue(null,'Accuracy');
                    }
            r.next();
            }
        return pm;
        }

    private static string accountURL(googPlacemark pm) {
        String url ='/001/e?retURL=%2F001%2Fo';
        if (pm != null) {
            if (pm.ThoroughfareName != null)                url += '&acc17street=' + EncodingUtil.urlEncode(pm.ThoroughfareName,'UTF-8');
            if (pm.LocalityName != null )                   url += '&acc17city=' + EncodingUtil.urlEncode(pm.LocalityName,'UTF-8');
            if (pm.AdministrativeAreaName != null )         url += '&acc17state=' + EncodingUtil.urlEncode(pm.AdministrativeAreaName,'UTF-8');
            if (pm.PostalCodeNumber!= null )                url += '&acc17zip=' + EncodingUtil.urlEncode(pm.PostalCodeNumber,'UTF-8');
            if (pm.CountryNameCode != null )                url += '&acc17country=' + EncodingUtil.urlEncode(pm.CountryNameCode,'UTF-8');
        }
        return url;
    }
    
private static final MAP<String,String> AccuracyDescription = new MAP<String,String> {
	'0' => 'Unknown location. ',
	'1' => 'Country level accuracy.',
	'2' => 'Region (state, province, prefecture, etc.) level accuracy.',
	'3' => 'Sub-region (county, municipality, etc.) level accuracy. ',
	'4' => 'Town (city, village) level accuracy. ',
	'5' => 'Post code (zip code) level accuracy. ',
	'6' => 'Street level accuracy. ',
	'7' => 'Intersection level accuracy. ',
	'8' => 'Address level accuracy. '
    };

    private static final MAP<String,String> StatusDescription = new MAP<String,String> {
    '200' => 'G_GEO_SUCCESS (200) No errors occurred; the address was successfully parsed and its geocode has been returned. (Since 2.55)',
    '400' => 'G_GEO_BAD_REQUEST (400) A directions request could not be successfully parsed. (Since 2.81)',
    '500' => 'G_GEO_SERVER_ERROR (500) A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known. (Since 2.55)', 
    '601' => 'G_GEO_MISSING_QUERY (601) The HTTP q parameter was either missing or had no value. For geocoding requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input. (Since 2.81)', 
    '602' => 'G_GEO_UNKNOWN_ADDRESS (602) No corresponding geographic location could be found for the specified address. This may be due to the fact that the address is relatively new, or it may be incorrect. (Since 2.55)', 
    '603' => 'G_GEO_UNAVAILABLE_ADDRESS (603) The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons. (Since 2.55)', 
    '604' => 'G_GEO_UNKNOWN_DIRECTIONS (604) The GDirections object could not compute directions between the points mentioned in the query. This is usually because there is no route available between the two points, or because we do not have data for routing in that region. (Since 2.81)', 
    '610' => 'G_GEO_BAD_KEY (610) The given key is either invalid or does not match the domain for which it was given. (Since 2.55) ',
    '620' => 'G_GEO_TOO_MANY_QUERIES (620) The given key has gone over the requests limit in the 24 hour period. (Since 2.55)'
    };
/*
    WITH XMLNAMESPACES (DEFAULT 'http://earth.google.com/kml/2.0', 'urn:oasis:names:tc:ciq:xsdschema:xAL:2.0' as oasis )
    INSERT @outtab

    Select  P.PM.value('(@id)[1]','nvarchar(10)') id,
            P.PM.value('(address)[1]','nvarchar(1024)') address,    
            P.PM.value('(.//oasis:Country/oasis:CountryNameCode)[1]','nchar(2)') CountryNameCode,   
            P.PM.value('(.//oasis:AdministrativeArea/oasis:AdministrativeAreaName)[1]','nvarchar(255)') AdministrativeAreaName,
            P.PM.value('(.//oasis:SubAdministrativeArea/oasis:SubAdministrativeAreaName)[1]','nvarchar(255)') SubAdministrativeAreaName,
            P.PM.value('(.//oasis:Locality/oasis:LocalityName)[1]','nvarchar(255)') LocalityName,
            P.PM.value('(.//oasis:Locality/oasis:Thoroughfare/oasis:ThoroughfareName)[1]','nvarchar(255)') ThoroughfareName,
            P.PM.value('(.//oasis:Locality/oasis:PostalCode/oasis:PostalCodeNumber)[1]','nvarchar(20)') PostalCodeNumber,
            P.PM.value('(Point/coordinates)[1]','nvarchar(50)') Coordinates,
            Lat=COOR.lat,
            Lon=COOR.lng,   
            Accuracy = Acc.AccuracyId,
            AccuracyDesc = Acc.AccuracyDesc
    From @Kml.nodes('//Placemark') P(PM)
        OUTER APPLY dbo.tvf_CoorToLatLng(P.PM.value('(Point/coordinates)[1]','nvarchar(50)'))  COOR
        Inner join dbo.tKML_Accuracy Acc on P.PM.value('(.//oasis:AddressDetails/@Accuracy)[1]','int')=AccuracyID
    RETURN
*/

      private static string getValue(XmlStreamReader reader, string sn) { 
        String value=null; 
          while(reader.hasNext()) {
             if (reader.isEndElement() && reader.getLocalName() == sn) 
              break;
             if (reader.isCharacters() ) { 
              value = reader.getText();
             }
             reader.next();
          } 
          //system.debug( 'getValue: '+ sn + ' = ' + value);
          return value;
    }
    
    
    static testMethod void testGoogleMap() {
        parseKMLStatus(TEST_RESPONSE);
        googPlacemark[] pm = parseKML(TEST_RESPONSE);
        System.assertEquals('Lewes',pm[0].LocalityName);
        System.debug(accountURL(pm[0]));
        googCoor coor = new googCoor(pm[0].Coordinates);

        Geography.Address add = new Geography.Address('12 Main St', 'Newark', 'DE','19711','US');
        system.debug(add);
        
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UtilUT.MockHttpResponse(TEST_RESPONSE));
        geoProvider_Google p = new geoProvider_Google();
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
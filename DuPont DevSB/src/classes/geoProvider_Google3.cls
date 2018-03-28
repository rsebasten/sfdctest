/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  geoProvider adaptor for Google V3 MAP API 
********************************************************************************/
public with sharing class geoProvider_Google3 extends geoProviderBase {
    public geoProvider_Google3(){}
	public override String getProviderName() 		{return 'GOOGLE'; }
    public override  String getTest_Response() 		{ 
    	string rtn='\n<?xml version="1.0" encoding="UTF-8"?>\n<GeocodeResponse>\n <status>OK</status>\n <result>';
    	rtn+='\n  <type>route</type>\n  <formatted_address>Kaiserstraße, 61169 Friedberg, Germany</formatted_address>\n  <address_component>\n   <long_name>Kaiserstraße</long_name>\n   <short_name>Kaiserstraße</short_name>\n   <type>route</type>\n  </address_component>\n  <address_component>\n   <long_name>Friedberg</long_name>\n   <short_name>Friedberg</short_name>\n';
    	rtn+='<type>locality</type>\n   <type>political</type>\n  </address_component>\n  <address_component>\n   <long_name>Wetteraukreis</long_name>\n   <short_name>Wetteraukreis</short_name>\n   <type>administrative_area_level_3</type>\n   <type>political</type>\n  </address_component>\n  <address_component>\n   <long_name>Darmstadt</long_name>\n';
    	rtn+='<short_name>DA</short_name>\n   <type>administrative_area_level_2</type>\n   <type>political</type>\n  </address_component>\n  <address_component>\n   <long_name>Hessen</long_name>\n   <short_name>HE</short_name>\n   <type>administrative_area_level_1</type>\n   <type>political</type>\n  </address_component>\n  <address_component>\n';
    	rtn+='<long_name>Germany</long_name>\n   <short_name>DE</short_name>\n   <type>country</type>\n   <type>political</type>\n  </address_component>\n  <address_component>\n   <long_name>61169</long_name>\n   <short_name>61169</short_name>\n   <type>postal_code</type>\n  </address_component>\n  <geometry>\n   <location>\n    <lat>50.3348071</lat>\n';
    	rtn+='<lng>8.7523879</lng>\n   </location>\n   <location_type>GEOMETRIC_CENTER</location_type>\n   <viewport>\n    <southwest>\n     <lat>50.3295400</lat>\n     <lng>8.7495989</lng>\n    </southwest>\n    <northeast>\n     <lat>50.3402200</lat>\n     <lng>8.7548582</lng>\n    </northeast>\n   </viewport>\n   <bounds>\n    <southwest>\n';
    	rtn+='<lat>50.3295400</lat>\n     <lng>8.7495989</lng>\n    </southwest>\n    <northeast>\n     <lat>50.3402200</lat>\n     <lng>8.7548582</lng>\n    </northeast>\n   </bounds>\n  </geometry>\n </result>\n</GeocodeResponse>\n';
    	return rtn;   
    }
    
    public override Geography.GeoAddresses parseBody(string body) {
    	system.debug(body);
    	Dom.Document doc = new Dom.Document();
		doc.load(body);
		GeocodeResponse r = new GeocodeResponse(doc.getRootElement());
		system.debug(r);
		return r.toGeoAddresses();
	 }   
	 
	public override HttpRequest getHttpRequest() {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('referer','https://proxy-sjl.salesforce.com');
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/xml?address='+AddressToQueryString(this.address)+'&sensor=false&language='+getUserLanguage()+'&region='+getUserCountry());
        return request;
	}
	
	public override string getAccuracyDesc(String accuracy) {
		return AccuracyDescription.get(accuracy);
	}

	/////////////////////////////////////////////////////////
	// Inner classes
	/////////////////////////////////////////////////////////

	private class GeocodeResponse {
		public string						status;
		public LIST<GeocodeResponseResult> 	results;
				
		GeocodeResponse(dom.xmlNode root) {
			results = new LIST<GeocodeResponseResult>();
			for (dom.Xmlnode n : root.getChildElements()) {
				if (n.getName()=='result')
					results.add(new GeocodeResponseResult(n));
				else if (n.getName()=='status')
					status= n.getText();
			}
		}
		
		public Geography.GeoAddresses toGeoAddresses() {
			Geography.GeoAddresses gas = new Geography.GeoAddresses();
			for (GeocodeResponseResult grr : results)
				gas.add(grr.toGeoAddress());
			return gas;
		}				
	} 	
	/////////////////////////////////////////////////////////
	private class GeocodeResponseResult {
		public MAP<string, AddressComponent> 	addressComponents;
		public Geography.LngLat		lnglat;	
		public string 				result_type;
		public string				location_type;
		public string				formatted_address;
	
		GeocodeResponseResult(dom.xmlNode r) {
			addressComponents = new  MAP<string, AddressComponent>();
			for (dom.Xmlnode n : r.getChildElements()) {
				if (n.getName()=='address_component') {
					AddressComponent ap = new AddressComponent(n); 
					addressComponents.put(ap.types[0],ap);
				}
				else if (n.getName()=='geometry') {
					dom.xmlNode l = n.getChildElement('location',null);
					if (l!=null)
						lnglat = new Geography.LngLat(l.getChildElement('lng',null).getText(),l.getChildElement('lat',null).getText());
					dom.xmlNode lt = n.getChildElement('location_type',null);
					if (lt!=null)
						location_type= lt.getText();
				}
				else if (n.getName()=='type')
					result_type= n.getText();
				else if (n.getName()=='formatted_address')
					formatted_address= n.getText();

			}
		}
					
		private string getAddrName(string c) {
			return  addressComponents.containsKey(c) ? addressComponents.get(c).long_name : null ;
		}
		private string getShortName(string c) {
			return  addressComponents.containsKey(c) ? addressComponents.get(c).short_name : null ;
		}		
		private string getStreet() {
			string rtn = getAddrName('street_address');
			if (rtn==null) {
				string street = getAddrName('route');
				if (street==null) street=getAddrName('intersection');
				string numb = getAddrName('street_number');
				if (numb!=null) {
					SET<string> reverse = new SET<string>{'DE'};
					if (reverse.contains(getCountryCode()))
						rtn= street+ ' ' +numb;
					else 
						rtn=numb+ ' ' +street;
				}
				else
					rtn=street;
			}
			return (rtn==null) ? null : rtn.trim();
		}
		
		private string getCounty() {
			if (getCountryCode()=='DE')
				return getAddrName('administrative_area_level_3');
			else
				return getAddrName('administrative_area_level_2');
		}

		private string getCountryCode() {
			return getShortName('country');
		}	
			
		public Geography.GeoAddress toGeoAddress() {
			//Address aAddress, String aCounty, String aFips, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy, String aCityDistrict, String aStateName
			Geography.GeoAddress rtn = new Geography.GeoAddress(
           		new Geography.Address(
           			getStreet(),
					getAddrName('locality'),
           			getAddrName('administrative_area_level_1'),
           			getAddrName('postal_code'),
           			getAddrName('country')
           		),
				getCounty(),
            	null,null,null,lnglat,
				location_type, 	//Accuracy?
				getAddrName('sublocality'),		//CityDistrict
				null);
			return rtn;
		}
	}
	/////////////////////////////////////////////////////////
	private class  AddressComponent {
		public string			long_name;
		public string			short_name;
		public LIST<string> 	types;
		AddressComponent() {}
		AddressComponent(dom.xmlNode x) {
				types = new LIST<string>();
				for (dom.Xmlnode n : x.getChildElements() ) {
					if (n.getName()=='type')
						types.add(n.getText());
					else if (n.getName()=='long_name')
						long_name= n.getText();
					else if (n.getName()=='short_name')
						short_name= n.getText();					
				}
		}				
	} 
	/////////////////////////////////////////////////////////
	
	
		
	private static final MAP<String,String> AccuracyDescription = new MAP<String,String> {
		'ROOFTOP' 				=> 'indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision.',
		'RANGE_INTERPOLATED' 	=> 'indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address.',
		'GEOMETRIC_CENTER'  	=> 'indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) or polygon (region).',
		'APPROXIMATE'  			=> 'indicates that the returned result is approximate.'
	};
	
	
	/////////////////////////////////////////////////////////
	// Test Methods
	////////////////////////////////////////////////////////
	
		
	
	
	static testMethod void test() {

		Geography.Address addr = new Geography.Address('12 Main St \nsuite 21', 'Newark', 'DE','19711','US');
		geoProvider_Google3 p = new geoProvider_Google3();
        p.getProviderName();
		system.debug(p.getProviderName());
        Geography.GeoAddresses gas = p.geocode(addr).GeoAddresses;
        system.debug(gas);
        system.debug(p.getHttpRequest());
        system.debug(p.getHttpResponse());  
        system.debug(gas.size());

    }
	
	
}
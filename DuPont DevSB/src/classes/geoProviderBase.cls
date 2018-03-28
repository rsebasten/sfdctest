/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Abstract Class to aid in geoProvider creation 
********************************************************************************/
public abstract class geoProviderBase implements Geography.IGeocodeProvider {
	protected Geography.Address address;
    private HttpResponse response;  
    private static string userLanguage;
    private static string userCountry;   
    
	//IGeocodeProvider::geocode
    public virtual Geography.GeoCodeResults geocode(Geography.Address aAddress) {
    	address=aAddress;
    	string stat;
        if (Test.isRunningTest()){
        	stat='200';
        }
        else {
	        executeGeocode(aAddress);
	        stat = getStatusCode(response);
		}
	    if (stat == '200')
	        return new Geography.GeoCodeResults(true,stat,'',parse());
	    else
	        return new Geography.GeoCodeResults(false,stat,getStatusMessage(response),null);
	}
    
    
    //MUST OVERRIDE
    public virtual String getProviderName() 		{return null; }
    public virtual String getTest_Response() 		{return null; }   
	public virtual HttpRequest getHttpRequest() { return new HttpRequest(); }
	public virtual string getAccuracyDesc(String accuracy) { return null; } 
	
	   
	  	
	public virtual string getStatusCode(HttpResponse response) { 
		return String.valueOf(response.getStatusCode()); 
	}  	
	public virtual string getStatusMessage(HttpResponse response) { 
		return response.getStatus(); 
	}  		
	
	
    public virtual Geography.GeoAddresses parseBody(string body) 	{
    	//return fake address
    	Geography.GeoAddresses gas = new Geography.GeoAddresses();
		Geography.geoAddress ga = new Geography.geoAddress();
		ga.Address = new Geography.Address('1313 Mockingbird Ln','Newark','DE','19711','US');
        gas.add(ga);
        return gas;
	 }   

    
    //IGeocodeProvider::getHttpRequest & getHttpResponse
    public virtual HttpResponse getHttpResponse()   {return response;} 
    
    //IGeocodeProvider::parse
    public virtual Geography.GeoAddresses parse() {
      		if (Test.isRunningTest())
      			return parseBody(getTest_Response());  
			else
			if (response == null)
				return null;
			else 	
				return parseBody(response.getBody());
    }
    
    
	public virtual HttpResponse executeGeocode(Geography.Address aAddress) {
        HttpRequest request = getHttpRequest();
        Http http = new http();
        response = http.send(request);
        return response;
    }
	
	public static string AddressToQueryString(Geography.Address a) {
        string q='';
        if (a != null) {
            if (a.Street != null)            q += a.Street.replace('\n', ' ').trim() + ' ';
            if (a.City != null )             q += a.City + ' ';
            if (a.State != null )            q += a.State + ' ';
            if (a.PostalCode!= null )        q += a.PostalCode + ' ';
            if (a.Country != null )          q += a.Country;
            }
        return EncodingUtil.urlEncode(q,'UTF-8');        
	}
	
	
	
	public static string getUserLanguage() {
    	if (userlanguage == null) {
    		if (UserInfo.getLanguage().length() >=2) 
    			userlanguage=UserInfo.getLanguage().substring(0,2);
    		else
    			userlanguage='en';
    	}
    	return userlanguage;
    }
    
	public static string getUserCountry() {
    	if (userCountry == null) {
    		if (UserInfo.getLocale().length() >=2) 
    			userCountry=UserInfo.getLocale().substring(0,2);
    		else
    			userCountry='us';
    	}
    	return userCountry;
    }
	
	
	
}
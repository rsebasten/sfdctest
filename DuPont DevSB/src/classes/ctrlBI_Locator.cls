/*
Modifications:
TES111027:  	
	1.   added method scrub() - JS code being passed to client was failing due to invalid JSON due to /r in feed.
	Strip /r and set replace of /n from '' to ' ' (space) 
	2.   added class BoundingBox() used to optimized query to handle a first pass at the DB to reduce not only time but
		script statements that were starting to limit

TES20140109:
	1. Migrated to 1DD and renamed from ctrlLocator to ctrlBI_Locator		
	2. Removed MapQuest Map and dependacies for discontinued version
	
*/
public without sharing class ctrlBI_Locator {

public String origin_zipcode{set; get;}
public String origin_country{set; get;}
public String map_js {set; get;}
public String zip_error{set; get;}
public String search_message{set; get;}
public String locator_type{set; get;}

private Decimal origin_lat;
private Decimal origin_lon;
private Geography.state origin_geography_state;
private Geography.county origin_geography_county;
private Geography.country origin_geography_country;
private boolean foundlocations;

private String TYVEK_RESIDENTIAL_SPECIALIST_RECORDTYPE_NAME='Tyvek Residential Specialist';
private String TYVEK_COMMERCIAL_SPECIALIST_RECORDTYPE_NAME='Tyvek Commercial Specialist';


public void searchByZip(){
    //origin_city='';
    //origin_state=null;
    clearMessages();
    
    if ((origin_zipcode=='')||(origin_zipcode==null))
    {
        showZipError();
        return;
    }
    origin_zipcode=origin_zipcode.trim();
    origin_zipcode=origin_zipcode.replace(' ','');

    if ((origin_country=='')||(origin_country==null)) { origin_country='US'; }
    
    if (origin_country=='US')
    {
        if (origin_zipcode.length()>5) {origin_zipcode=origin_zipcode.substring(0,5); }
        boolean isValid = Pattern.matches('\\d{5}',origin_zipcode);
        if (isValid==false)
        {
            showZipError();
            return;
        }
    }

    if (origin_country=='CA')
    {
        if (origin_zipcode.length()>6) {origin_zipcode=origin_zipcode.substring(0,6); }
        boolean isValid = Pattern.matches('[ABCEGHJKLMNPRSTVXY]\\d[A-Z]\\d[A-Z]\\d',origin_zipcode);
        if (isValid==false)
        {
            showZipError();
            return;
        }
        origin_zipcode=origin_zipcode.substring(0,3) + ' ' + origin_zipcode.substring(3,6);
    }
    
    Geography.Address a = new Geography.Address('','','',origin_zipcode,origin_country);
    if (geocodeOrigin(a)){findLocations();}
    else{showMessage('Cannot find your location.');}
}

public void clearZip(){
    origin_zipcode='';
	map_js='<script>hideResults();</script>';
}

public void showZipError(){
    zip_error='<span id="zip_error">Please enter valid zip or postal code.</span><br/>';
}


public void clearMessages(){
    foundlocations=false;
    zip_error='';
    search_message='';
}

private boolean geocodeOrigin(Geography.Address address)
{
    boolean success=true;
    Geography.IGeocodeProvider gcp = Geography.getProvider('MAPQUEST2');
    Geography.GeoCodeResults gcr = new Geography.GeoCodeResults();
    gcr=Geography.geocode(address, gcp);
    Geography.GeoAddress gadd = new Geography.GeoAddress();
    system.debug(gcr);
    //check for any results, if no results return false
    if (gcr.success){
        gadd=gcr.GeoAddresses.getGeoAddress(0);
        Geography.LngLat coor = new Geography.LngLat();
        coor=gadd.lnglat;
        origin_lat=coor.Lat;
        origin_lon=coor.Lng;
        origin_geography_county=gadd.getCountyInfo(false);
        origin_geography_state=gadd.getStateInfo(false);
    }
    else{
        success=false;
    }
    return success;
}

public void findLocations(){
    foundlocations=false;
    String tmp=getTyvekSpecialists();
 if (foundlocations)
 	map_js=tmp;
 else
 	showMessage('No locations found in your area.<script>hideResults();</script>');

}

public void showMessage(String m){
    search_message=m;
}

public String getTyvekSpecialists(){ 
    String js_code='<script>';
    Integer counter=0;
    String js_line='';

    if (origin_country=='US')
    {
    	system.debug(origin_geography_county);
        if (origin_geography_county==null) {
            js_code+='</script>';
        }
        else {
            List<Geography_mapping__c> geographymap = [
            	SELECT geography_mapping__c.name,geography_mapping__c.recordtype.name,user__r.firstname,user__r.lastname,user__r.companyname,user__r.phone,user__r.fax,user__r.email 
            	FROM geography_mapping__c 
            	WHERE (geography_mapping__c.recordtype.name=:TYVEK_RESIDENTIAL_SPECIALIST_RECORDTYPE_NAME OR geography_mapping__c.recordtype.name=:TYVEK_COMMERCIAL_SPECIALIST_RECORDTYPE_NAME) AND geography_mapping__c.geography__r.id = :origin_geography_county.id];
            for(Geography_mapping__c gm: geographymap )
            {
                foundlocations=true;
                js_line='dlocations['+counter+']=new dlocation("'+gm.user__r.firstname+ ' ' +gm.user__r.lastname+'","' + gm.user__r.companyname + '","' + gm.user__r.phone+ '","' + gm.user__r.fax+ '","' + gm.user__r.email+ '","'+gm.recordtype.name+'");\n';
                js_line=scrub(js_line); //TES111027
                js_code+=js_line+'\n';
                counter=counter+1;
            }
            js_code+='buildList();</script>';
        }
    }
    
    if (origin_country=='CA')
    {
        String subcode;
        subcode=origin_zipcode.trim();
        subcode=subcode.toUpperCase();
        subcode=subcode.substring(0,3);
        List<Geography_mapping__c> geographymap = [SELECT geography_mapping__c.name,geography_mapping__c.recordtype.name,user__r.firstname,user__r.lastname,user__r.companyname,user__r.phone,user__r.fax,user__r.email FROM geography_mapping__c where (geography_mapping__c.recordtype.name=:TYVEK_RESIDENTIAL_SPECIALIST_RECORDTYPE_NAME OR geography_mapping__c.recordtype.name=:TYVEK_COMMERCIAL_SPECIALIST_RECORDTYPE_NAME) AND geography_mapping__c.geography__r.Code2__c = :subcode] ;
        for(Geography_mapping__c gm: geographymap )
        {
            foundlocations=true;
            js_line='dlocations['+counter+']=new dlocation("'+gm.user__r.firstname+ ' ' +gm.user__r.lastname+'","' + gm.user__r.companyname + '","' + gm.user__r.phone+ '","' + gm.user__r.fax+ '","' + gm.user__r.email+ '","'+gm.recordtype.name+'");\n';
            js_line=scrub(js_line); //TES111027
            js_code+=js_line+'\n';
            counter=counter+1;
        }
        js_code+='buildList();</script>';
    }
    return js_code;   
}


//TES111027
private string scrub(string str) {
	string rtn=str.replace('\r\n',' ');
	rtn=rtn.replace('\n',' ');
	rtn=rtn.replace('\r',' ');
	return rtn;
}

/*

//TES111027 - optimize Query via this bounding box
private class BoundingBox { 

	decimal earthR = 3959; //miles: 3959; km: 6371
	public decimal maxLat;
	public decimal maxLon;
	public decimal minLat;
	public decimal minLon;

	BoundingBox(Decimal lat, Decimal lon, Decimal rad){
	  maxLat = lat+radToDeg(rad/earthR);
	  minLat = lat-radToDeg(rad/earthR);
	  maxLon = lon+radToDeg(rad/earthR/Math.cos(degTorad(lat)));
	  minLon = lon-radToDeg(rad/earthR/Math.cos(degTorad(lat))); 
	}
}

	public static decimal radToDeg(decimal rad) {
	    return rad * 57.29577951308232; // rad/pi*180)
	}
	
	public static decimal degToRad(decimal deg) {
		return (deg/180)*3.1415926535897932;  //pi
	}


private boolean isCanada(String province){
    boolean c=false;
    if ((province=='Alberta')||(province=='British Columbia')||(province=='Manitoba')||(province=='New Brunswick')||(province=='Newfoundland and Labrador')||(province=='Northwest Territories')||(province=='Nunavut')||(province=='Nova Scotia')||(province=='Ontario')||(province=='Prince Edward Island')||(province=='Quebec')||(province=='Saskatchewan')||(province=='Yukon')){c=true;}
    return c;
}

*/

/*
public static testMethod void testCtrlLocator(){
    ctrlBI_Locator ctr=new ctrlBI_Locator();
    
    ctr.clearZip();
    ctr.showZipError();
    ctr.clearCityState();
    ctr.showCityStateError();
    ctr.clearMessages();
    ctr.showMessage('test');
    
    ctr.origin_zipcode='';
    ctr.searchByZip();
    
    ctr.origin_zipcode='123';
    ctr.searchByZip();
    
    ctr.origin_country='';
    ctr.searchByZip();
    
    ctr.origin_city='';
    ctr.searchByCityState();
    
    ctr.origin_state='';
    ctr.searchByCityState();
    
    ctr.origin_zipcode='H2Y 1C6';
    ctr.origin_country='CA';
    String js=ctr.getTyvekSpecialists();
    
    ctr.origin_country='US';
    js=ctr.getTyvekSpecialists();
    
    ctr.origin_lat=39;
    ctr.origin_lon=75;
    ctr.setMaxRows(10);
    ctr.locator_distance='10000';ctr.getTyvekSuppliers();
    ctr.locator_distance='0';ctr.getTyvekSuppliers();
    ctr.locator_distance='x';ctr.getTyvekSuppliers();
   
    ctr.origin_zipcode='19805';
    ctr.findLocations();
    
    ctr.origin_zipcode='xxxxxxxx';
    ctr.origin_country='US';
    ctr.searchByZip(); 
    
    ctr.origin_zipcode='xxxxxxxx';
    ctr.origin_country='CA';
    ctr.searchByZip(); 
    
    ctr.origin_city='Montreal';
    ctr.origin_state='Quebec';
    ctr.searchByCityState();
}
*/

}
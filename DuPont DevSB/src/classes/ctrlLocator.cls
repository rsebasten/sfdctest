/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Manasa Gupta,Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com,manasa.gupta@ind.dupont.com,
Description: Controller for the Page Locator
SJAGA 2012-20-Jun - Added Bounding Box functionality for the Dealer Search 
//<RB20141811> Rajiv Kumar Bhatter
 // Description:Commented the DPC record type which is used and also removed it from the condition.
 ********************************************************************************/
public without sharing class ctrlLocator {
   //<RB20141811> Removed the DPC Record Type initialization
  public String origin_zipcode{set; get;}
  public String origin_city{set; get;}
  public String origin_state{set; get;}
  public String origin_country{set; get;}
  public String map_js{set; get;}
  public String zip_error{set; get;}
  public String city_error{set; get;}
  public String state_error{set; get;}
  public String search_message{set; get;}
  public String locator_type{set; get;}
  public String locator_acctype{set; get;}
  public String locator_product{set; get;}
  public String locator_distance{set; get;}
  public String locator_ownorg {set; get;}
  public String locator_country {set; get;}
  public String locator_qualprogram {set; get;}
  public List<Qualification__c> qualist;
  private Decimal origin_lat;
  private Decimal origin_lon;
  private Geography.state origin_geography_state;
  private Geography.county origin_geography_county;
  private Geography.country origin_geography_country;
  private boolean foundlocations;
  private Integer MAX_ROWS = 100000;
  private String locale;
  private Map<String, Map<String,String>> error_message;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Constructor
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  public ctrlLocator()
  {
    init();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //accessing parameters from the URL
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  

  public void init(){
    locator_acctype=ApexPages.currentPage().getParameters().get('acctype');
    locator_ownorg=ApexPages.currentPage().getParameters().get('ownorg');
    locator_country=ApexPages.currentPage().getParameters().get('country');
    locator_qualprogram=ApexPages.currentPage().getParameters().get('qualprogram');
    locator_distance=ApexPages.currentPage().getParameters().get('distance');
    if (ApexPages.currentPage().getParameters().get('type')<>'')
    {locator_type=ApexPages.currentPage().getParameters().get('type');}
    if (ApexPages.currentPage().getParameters().get('product')<>'')
    {locator_product=ApexPages.currentPage().getParameters().get('product');}   
    //SET TYPE BASED ON PAGE
   //<RB20141811>
   // String url=ApexPages.currentPage().getURL();    
   // if (url!=null)
    //{                
    //  if (url.indexOf('DPCJobberLocator_US')>-1) {locator_type='dpc_jobber_us';locator_country='United States';locale='en_US';}
   //   if (url.indexOf('DPCShopLocator_US')>-1) {locator_type='dpc_shop_us';locator_country='United States';locale='en_US';}
   //   if (url.indexOf('DPCLocator_DE')>-1) {locator_type='dpc_germany';locator_country='Germany';locale='de_DE';}  
    //}
   // else
    //{
      locator_country='United States';
      locale='en_US';
     // locator_type='dpc_jobber_us';
    //}                  
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Zip Code validation
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  

  public void searchByZip(){
    origin_city='';
    origin_state=null;
    clearMessages(); 
    Geography.Countries  cs  = new Geography.Countries();  
    Geography.Utilities gu = new Geography.Utilities();
    boolean isValid;
    origin_zipcode=origin_zipcode.trim();
    origin_zipcode=origin_zipcode.replace(' ','');

    if ((locator_country=='')||(locator_country==null)) { 
      origin_country='US'; 
    }
    else{
      origin_country = cs.getCountry(locator_country).A2;
    }
    Boolean temp=gu.validateZipcode(origin_country,origin_zipcode);
    if(temp == false){
      showZipError();
      return;
    }
    origin_zipcode=gu.getOriginZipcode(origin_country,origin_zipcode);
    Geography.Address a = new Geography.Address('','','',origin_zipcode,origin_country);
    if (geocodeOrigin(a)){findLocations();}
    else{showMessage('Cannot find your location.');}
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //City Validation
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  public void searchByCity(){
    origin_zipcode='';
    clearMessages();
    if ((origin_city==''))
    {
      showCityError();
      return;
    }
    Geography.Countries  cs  = new Geography.Countries(); 
    origin_country=cs.getCountry(locator_country).A2; 
    Geography.Address a = new Geography.Address('',origin_city,'','',origin_country);
    if (geocodeOrigin(a)){findLocations();}
    else{showMessage('Cannot find your location.');}
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Action to Clear the City information
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  public void clearCityState(){
    origin_city=null;
    origin_state=null;
    clearMessages();
    map_js='<script>hideResults();</script>';
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Error meassage for City
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  private void showCityError(){
    if (origin_city==''){city_error='<span id="city_error">'+'Please enter a valid City'+'</span>';}
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Action to Clear the Zip code information
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  public void clearZip(){
    origin_zipcode='';
    clearMessages();
    map_js='<script>hideResults();</script>';
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Error meassage for Zip code
  ///////////////////////////////////////////////////////////////////////////////////////////////////////     
  private void showZipError(){
    zip_error='<span id="zip_error">'+'Please enter a valid Zip Code' + '</span><br/>';
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //City State Validation
  /////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void searchByCityState(){
    origin_zipcode='';
    clearMessages();
    if ((origin_city=='')||(origin_state==null)){
      showCityStateError();
      return;
    }

    if ((origin_country=='')||(origin_country==null)) { origin_country='US'; }  
    if (isCanada(origin_state)==true) { origin_country='CA'; }
    if (origin_state=='MP' || origin_state=='GU' ||  origin_state=='VI') { origin_country=origin_state; }    
    Geography.Address a = new Geography.Address('',origin_city,origin_state,'',origin_country);
    if (geocodeOrigin(a)){findLocations();}
    else{showMessage('Cannot find your location.');}
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //State City Error
  /////////////////////////////////////////////////////////////////////////////////////////////////////// 
  private void showCityStateError(){
    if (origin_city==''){city_error='<span id="city_error">'+'Please enter a valid City'+'</span>';}
    if (origin_state==null){state_error='<span id="state_error">'+'Please select a valid State'+'</span>';}
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Initializing Error meassages
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  private void clearMessages(){
    foundlocations=false;
    zip_error='';
    city_error='';
    state_error='';
    search_message='';
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Retrieving data from Mapquest 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  private boolean geocodeOrigin(Geography.Address address)
  {
    boolean success=true;
    Geography.IGeocodeProvider gcp = Geography.getProvider('MAPQUEST2');
    Geography.GeoCodeResults gcr = new Geography.GeoCodeResults();
    gcr=Geography.geocode(address, gcp);
    Geography.GeoAddress gadd = new Geography.GeoAddress();
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
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Retrieving Results based on Selected Criteria 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  public void findLocations(){
    foundlocations=false;
    String tmp='';
    System.debug('#########'+locator_type);
    //<RB20141811> Removing the condition where dpc locator are used
  
    if(locator_type==''){tmp = getDealerAccounts(); } 
    if(foundlocations)
    {map_js=tmp;}
    else
    {
      map_js='';
      showMessage('No Locations Found for the Current Search'+'\n<script>hideResults();</script>');
    }

  }
  ////////////////////////////////////////////////////////////////
  // Province is in canada
  ////////////////////////////////////////////////////////////////
  private boolean isCanada(String province){
    boolean c=false;
    if ((province=='Alberta')||(province=='British Columbia')||(province=='Manitoba')||(province=='New Brunswick')||(province=='Newfoundland and Labrador')||(province=='Northwest Territories')||(province=='Nunavut')||(province=='Nova Scotia')||(province=='Ontario')||(province=='Prince Edward Island')||(province=='Quebec')||(province=='Saskatchewan')||(province=='Yukon')){c=true;}
    return c;
  }
  //////////////////////////////////////////////////////////////
  //Messages
  //////////////////////////////////////////////////////////////
  private void showMessage(String m){
    search_message=m;
  }
  //////////////////////////////////////////////////////////////////////////
  //German Locator
  //////////////////////////////////////////////////////////////////////////
  private String getDPCDE(){
    Integer d=50;
    String js_code='\n<script>\norigin= new MQLatLng('+ origin_lat +',' + origin_lon + ');\n';
    Integer counter=0;
    Double distance=0;
    BoundingBox bbox=new BoundingBox(origin_lat,origin_lon,d);
 //<RB20141811> Removing the ussge of the DPC record type from the Select query
           
      for (Account a : [SELECT name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,Phone,Fax,Website,ShippingLatitude__C,ShippingLongitude__c,Customer_Segment__c FROM Account where ShippingLongitude__c!=null and ShippingLatitude__c!=null and Mb_of_Marketing_Program__c includes ('Classic Partner') and Account_Stage__c='Active' and Country__c='GERMANY' and (ShippingLongitude__c>=:bbox.MinLon) and (ShippingLongitude__c<=:bbox.MaxLon) and (ShippingLatitude__c<=:bbox.MaxLat) and (ShippingLatitude__c>=:bbox.MinLat) LIMIT :MAX_ROWS]){
      
      distance=calculateDistance(origin_lat,origin_lon,a.ShippingLatitude__c,a.ShippingLongitude__c);
      if (distance<d){
        foundlocations=true;
        String deShippingStreet=a.ShippingStreet.replace('\r','');
        deShippingStreet=deShippingStreet.replace('\n',' ');          
        js_code+='dlocations['+counter+']=new dlocation(' + distance + ',"'+a.name+'","'+deShippingStreet+'","'+ a.ShippingCity+'","'+a.ShippingState+'","'+a.ShippingPostalCode+'","'+a.phone+'","'+a.fax+'","'+a.website+'",'+a.ShippingLatitude__c+','+a.ShippingLongitude__c+');';
        counter++;
      }
    }
    js_code+='buildList();</script>';
    return js_code;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //US Jobber Locator
  /////////////////////////////////////////////////////////////////////////////////////////////////////// 
  private String getDPCUSJobbers(){
    String product;
 // if (locator_product=='DuPontRefinish'){product='DuPont Refinish';}
    if (locator_product=='Standox'){product='Standox';}
    if (locator_product=='SpiesHecker'){product='Spies Hecker';}
    if (locator_product=='Nason'){product='Nason';}
    if (locator_product=='HotHues'){product='Hot Hues';}
    if (locator_product=='DuPontIndustrialCoatings'){product='DuPont Industrial Coatings';}
    Integer d=25;
    String js_code='\n<script>\norigin= new MQLatLng('+ origin_lat +',' + origin_lon + ');\n';
    Integer counter=0;
    Integer JobberAccCounter=0;
    Double distance=0;
    BoundingBox bbox=new BoundingBox(origin_lat,origin_lon,d);
    //<RB20141811> Removing the usage of the DPC record type from the Select query
    for (Account a : [SELECT name,Id,ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,Phone,Fax,Website,ShippingLatitude__C,ShippingLongitude__c,Customer_Segment__c FROM Account where ShippingLongitude__c!=null and ShippingLatitude__c!=null and Sub_Type_2__c='' and Account_Stage__c!='Inactive' and Account_Stage__c!='Under Review' and (ShippingLongitude__c>=:bbox.MinLon) and (ShippingLongitude__c<=:bbox.MaxLon) and (ShippingLatitude__c<=:bbox.MaxLat) and (ShippingLatitude__c>=:bbox.MinLat) and (not name like '%test%') LIMIT :MAX_ROWS]){
      distance=calculateDistance(origin_lat,origin_lon,a.ShippingLatitude__c,a.ShippingLongitude__c);
      if (a.name =='Hedahls Inc - HQ') {
      }       
      if (distance<=d){
        foundlocations=true;
        String jShippingStreet=a.ShippingStreet.replace('\r','');
        jShippingStreet=jShippingStreet.replace('\n',' ');
        js_code+='dlocations['+counter+']=new dlocation(' + distance + ',"'+a.name+'","'+jShippingStreet+'","'+ a.ShippingCity+'","'+a.ShippingState+'","'+a.ShippingPostalCode+'","'+a.phone+'","'+a.fax+'","'+a.website+'",'+a.ShippingLatitude__c+','+a.ShippingLongitude__c+',"'+a.Customer_Segment__c+'");'; 
        counter++;
      }
    }
    js_code+='buildList();</script>';
    return js_code;

  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //US Shopper Locator
  /////////////////////////////////////////////////////////////////////////////////////////////////////// 
  private String getDPCUSShops(){ 
    String product='collision';
    if (locator_product=='Commercial'){product='commercial';}  
    Integer d=25;
    String tjs='';
    String js_code='\n<script>\norigin= new MQLatLng('+ origin_lat +',' + origin_lon + ');\n';
    Integer counter=0;
    Integer ShopAccCounter=0;
    Double distance=0;
    BoundingBox bbox=new BoundingBox(origin_lat,origin_lon,d);
    //<RB20141811> Removing the usage of the DPC record type from the Select query
    for (Qualification__c q : [SELECT account_name__r.name,account_name__r.Id,account_name__r.ShippingStreet,account_name__r.ShippingCity,account_name__r.ShippingState,account_name__r.ShippingPostalcode,account_name__r.Phone,account_name__r.Fax,account_name__r.Website,account_name__r.ShippingLatitude__C,account_name__r.ShippingLongitude__c,qualification_program__r.name FROM Qualification__c where subtype__c='Value Added Program' and account_name__r.ShippingLongitude__c!=null and account_name__r.ShippingLatitude__c!=null and (account_name__r.ShippingLongitude__c>=:bbox.MinLon) and (account_name__r.ShippingLongitude__c<=:bbox.MaxLon) and ( account_name__r.ShippingLatitude__c<=:bbox.MaxLat) and ( account_name__r.ShippingLatitude__c>=:bbox.MinLat) and account_name__r.Type='Customer' and account_name__r.account_stage__c!='Inactive' and stage__c='Active' LIMIT :MAX_ROWS]){
      distance=calculateDistance(origin_lat,origin_lon,q.account_name__r.ShippingLatitude__c,q.account_name__r.ShippingLongitude__c);
      ShopAccCounter++;      
      if (distance<=d){
        if ((product=='collision' && q.Qualification_Program__r.name!='AOQ - C') || (product=='commercial' && q.Qualification_Program__r.name=='AOQ - C'))
        {
          foundlocations=true;                          
          String sShippingStreet=q.account_name__r.ShippingStreet.replace('\r','');
          sShippingStreet=sShippingStreet.replace('\n',' ');
          tjs='dlocations['+counter+']=new dlocation(' + distance + ',"'+q.account_name__r.name+'","'+sShippingStreet+'","'+ q.account_name__r.ShippingCity+'","'+q.account_name__r.ShippingState+'","'+q.account_name__r.ShippingPostalCode+'","'+q.account_name__r.phone+'","'+q.account_name__r.fax+'","'+q.account_name__r.website+'",'+q.account_name__r.ShippingLatitude__c+','+q.account_name__r.ShippingLongitude__c+',"' + q.Qualification_Program__r.name + '");';      
          tjs=tjs.replace('\n','');
          js_code+=tjs+'\n';
          counter++;
        }
      }
    }
    js_code+='buildList();\n</script>';
    return js_code;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Searching for Dealer accounts for necessary parameters (Generic Locator)
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  private String getDealerAccounts(){
    Decimal d = Decimal.valueOf(locator_distance);   
    String tjs='';
    String js_code='\n<script>\norigin= new MQLatLng('+ origin_lat +',' + origin_lon + ');\n';
    Integer counter=0;
    Integer dealerCounter=0;
    Double distance=0;
    System.debug('Origin Latitude'+origin_lat);
    System.debug('Origin Longitude'+origin_lon );

    BoundingBox bbox=new BoundingBox(origin_lat,origin_lon,d); //SJAGA 20122006
    System.debug('Box Min Latitude'+bbox.MinLat);
    System.debug('Box Max Latitude'+bbox.MaxLat);
    System.debug('Box Min Longitude'+bbox.MinLon);
    System.debug('Box Max Longitude'+bbox.MaxLon);

    for (Qualification__c q : [SELECT account_name__r.name,account_name__r.Id,account_name__r.ShippingStreet,account_name__r.ShippingCity,account_name__r.ShippingState,account_name__r.ShippingPostalcode,account_name__r.Phone,account_name__r.Fax,account_name__r.Website,account_name__r.ShippingLatitude__c,account_name__r.ShippingLongitude__c,Qualification_Program__r.name FROM Qualification__c where Qualification_Program__r.name=:locator_qualprogram and account_name__r.Owning_Organization__c =:locator_ownorg and account_name__r.Country__c=:locator_country and (account_name__r.ShippingLongitude__c>=:bbox.MinLon) and (account_name__r.ShippingLongitude__c<=:bbox.MaxLon) and ( account_name__r.ShippingLatitude__c<=:bbox.MaxLat) and ( account_name__r.ShippingLatitude__c>=:bbox.MinLat) and account_name__r.account_stage__c='Active' and account_name__r.Type=:locator_acctype and stage__c='Active' LIMIT :MAX_ROWS]){
      distance=calculateDistance(origin_lat,origin_lon,q.account_name__r.ShippingLatitude__c,q.account_name__r.ShippingLongitude__c);dealerCounter++;
      if (distance<=d){
        foundlocations=true;
        js_code+='dlocations['+counter+']=new dlocation(' + distance + ',"'+q.account_name__r.name+'","'+q.account_name__r.ShippingStreet+'","'+ q.account_name__r.ShippingCity+'","'+q.account_name__r.ShippingState+'","'+q.account_name__r.ShippingPostalCode+'","'+q.account_name__r.phone+'","'+q.account_name__r.fax+'","'+q.account_name__r.website+'",'+q.account_name__r.ShippingLatitude__c+','+q.account_name__r.ShippingLongitude__c+',"' + q.Qualification_Program__r.name + '");';
        counter++;
      }
    }
    js_code+='buildList();\n</script>';
    return js_code;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  //Calculating the distance 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  private Double calculateDistance(Decimal origin_latitude,Decimal origin_longitude,Decimal site_latitude,Decimal site_longitude){
    Double d2r;
    Double distance;
    Double dLat;
    Double dLon;
    Double temp1;
    Double temp2;
    Double temp3;
    Double EARTH_RADIUS_MILES;

    d2r=0.017453293;
    EARTH_RADIUS_MILES=3961;

    dLat = d2r * (site_latitude-origin_latitude);
    dLon = d2r * (site_longitude-origin_longitude); 
    temp1 = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(d2r*(site_latitude)) * Math.cos(d2r*(origin_latitude)) * Math.sin(dLon/2) * Math.sin(dLon/2); 
    temp2 = 2 * Math.atan2(Math.sqrt(temp1), Math.sqrt(1-temp1)); 
    temp3 = EARTH_RADIUS_MILES * temp2;
    distance=Math.round(temp3);
    return distance;
  }

  //SJAGA 20122006
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

  /*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Manasa Gupta,Sreedhar Jagannath
Email: manasa.gupta@ind.dupont.com,sreedhar.jagannath@ind.dupont.com
Description:  Unit Test for the controller class ctrlLocators
   ********************************************************************************/

  public static testMethod void testCtrlLocator(){
    
    if (Test.isRunningTest()) 
    {
        ctrlLocator ctr=new ctrlLocator();
        ctrlLocator.BoundingBox bb=new ctrlLocator.BoundingBox(1,1,1);
        Double distance;
        distance=ctr.calculateDistance(0,0,0,0);
        System.assertEquals(distance,0);
        String test;
        test='Alberta';
        boolean c=ctr.isCanada(test);
        System.assertEquals(c,true);
        Account a = new Account(Name='Tst Dealer',Product_2__c='Test',Type='Customer',Owning_Organization__c='test',ShippingStreet='20',ShippingCity='SBC',ShippingState='KTK',ShippingPostalcode='560100',Phone='8792331033',Fax='111',Website='www.google.com',ShippingLatitude__C=39,ShippingLongitude__c=75,Customer_Segment__c='abc',Account_Stage__c='Active',Mb_of_Marketing_Program__c='Classic Partner',Country__c='GERMANY');
        insert a;
        initiative__c init = new initiative__c(Name='Classic Partner');
        insert init;
        Qualification__c qual = new Qualification__c (Account_Name__c = a.id,Qualification_Program__c = init.id,Stage__c='Active',subtype__c='Value Added Program');
        insert qual;
        Geography__c g1 = new Geography__c(Parent__c=null, name='United States', Level__c=Geography.LEVEL_COUNTRY, Level_Name__c='Country', Code__c='US', Code2__c='USA', Aliases__c='', Numeric_Code__c=null);
        Geography__c g2 = new Geography__c(Parent__c=null, name='Germany', Level__c=Geography.LEVEL_COUNTRY, Level_Name__c='Country', Code__c='DE', Code2__c='IT', Aliases__c='Italie\nItalia');
        Geography__c[] rtn = new Geography__c[] {g1,g2};
        upsert rtn Code__c;
    
        Geography.Countries  cs  = new Geography.Countries(); 
    
        ctr.init();
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
    
        ctr.origin_country='US';
        ctr.origin_lat=39;
        ctr.origin_lon=75;
      test=ctr.getDPCDE();
      test=ctr.getDPCUSJobbers();
      test=ctr.getDPCUSShops();
        ctr.locator_distance='50';
        test=ctr.getDealerAccounts();
    
        ctr.origin_zipcode='19805';
        ctr.locator_distance='50';
        ctr.findLocations();
    
        ctr.origin_zipcode='xxxxxxxx';
        ctr.origin_country='US';
        ctr.searchByZip(); 
    
        ctr.origin_zipcode='xxxxxxxx';
        ctr.origin_country='CA';
        ctr.searchByZip(); 
    
        ctr.origin_city='';
        ctr.origin_country='DE';
        ctr.searchByCity(); 
    
        ctr.origin_city='Montreal';
        ctr.origin_state='Quebec';
//[05112017] Merge&Spin : added mock test to increase code coverage
        System.Test.startTest();
        string TEST_RESPONSE 	= '<?xml version="1.0" encoding="UTF-8"?><response><info><statusCode>0</statusCode><messages/><copyright><imageUrl>http://tile21.mqcdn.com/res/mqlogo.gif</imageUrl><imageAltText>© 2010 MapQuest, Inc.</imageAltText><text>© 2010 MapQuest, Inc.</text></copyright></info><results><result><providedLocation><postalCode>63376-6463</postalCode><adminArea1>UNITED STATES</adminArea1><street>4170 N Service Rd</street><adminArea3>MO</adminArea3><adminArea5>Saint Peters</adminArea5></providedLocation><locations><location><street>4170 N Service Rd</street><adminArea5 type="City">Saint Peters</adminArea5><adminArea3 type="State">MO</adminArea3><adminArea4 type="County">St. Charles County</adminArea4><postalCode>63376-6463</postalCode><adminArea1 type="Country">US</adminArea1><geocodeQuality>POINT</geocodeQuality><geocodeQualityCode>P1AAA</geocodeQualityCode><dragPoint>false</dragPoint><sideOfStreet>R</sideOfStreet><displayLatLng><latLng><lat>38.7969</lat><lng>-90.57371</lng></latLng></displayLatLng><linkId>20704847</linkId><type>s</type><latLng><lat>38.79637</lat><lng>-90.57377</lng></latLng></location></locations></result></results><options><maxResults>10</maxResults><thumbMaps>false</thumbMaps><ignoreLatLngInput>false</ignoreLatLngInput><boundingBox/></options></response>';
        System.Test.setMock(HttpCalloutMock.class, new UtilUT.MockHttpResponse(TEST_RESPONSE));
        ctr.searchByCityState();
       // ctr.getDPCDE();
        SYstem.Test.stopTest();
      }
    }

}
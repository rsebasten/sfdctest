/*******************************************************************************
(C)2008 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Geographic Library for Dupont-One Instance

TES20110510  allow inner classes to be extended (virtual)
SJAGA20120711 - added method for zip code validation
SJAGA20120718 - Change in Zip Code Pattern Matcher for United Kingdom
<AB20160322> - Modified to get non FSA County, FSA is not used in code till now, 
				to accomodate it FSA is added in the key to Identify it from NON FSA
 ********************************************************************************/
public class Geography {
	public static boolean IS_TESTMETHOD = false;

	public static final Integer LEVEL_COUNTRY   = 3;
	public static final Integer LEVEL_STATE     = 4;
	public static final Integer LEVEL_COUNTY    = 5;

	//Geography caching
	private static MAP<String, Country> mapCountriesCache;              //cache of all Countries
	private static MAP<String,String> mapCountryAliasesCache;           //cache of all country aliases MAP<alias,name>
	private static MAP<id,MAP<String, State>> mapStatesCache;           //cache of all states
	private static MAP<id,MAP<String,String>> mapStateAliasesCache;     //cache of all state aliases MAP<countryId,MAP<alias,name>> 
	private static MAP<Id,MAP<String, County>> mapCountiesCache;        //cache of all counties
	private static MAP<id,MAP<String,String>> mapCountyAliasesCache;    //cache of all county aliases MAP<stateId,MAP<alias,name>> 


	/* ******************************************************************************
        Geocode

    IGeocodeProvider Interface for IGeocodeProviders (currently Mapquest and google)
    getProvider() returns default provider
    getProvider(string) returns provider

	 ******************************************************************************* */
	public static final String PREFERRED_PROVIDER = 'MapQuest2';


	public interface IGeocodeProvider {
		String getAccuracyDesc(String accuracy);
		String getProviderName();
		GeoCodeResults geocode(Address aAddress);
		GeoAddresses parse();
		HttpResponse getHttpResponse();
		HttpRequest getHttpRequest();
	}

	public static IGeocodeProvider getProvider() {return getProvider(PREFERRED_PROVIDER);}
	public static IGeocodeProvider getProvider(string aProvider) {

		if      ( aProvider.toUpperCase() =='MAPQUEST')         return new geoProvider_MapQuest();
		if      ( aProvider.toUpperCase() =='MAPQUEST2')        return new geoProvider_MapQuest2();
		else if ( aProvider.toUpperCase() =='GOOGLE')           return new geoProvider_Google3();
		else if ( aProvider.toUpperCase() =='GOOGLE2')          return new geoProvider_Google();
		else if ( aProvider.toUpperCase() =='BING')             return new geoProvider_Bing();
		else 
			return null;
	}


	public static GeoCodeResults geocode(Address a) {return geocode(a,getProvider());}
	public static GeoCodeResults geocode(Address a, string strp) {return geocode(a,getProvider(strp));}
	public static GeoCodeResults geocode(Address a, IGeocodeProvider p) {return p.geocode(a);}

	public class GeoCodeResults {
		public GeoCodeResults(){}
		public GeoCodeResults(boolean aSuccess,string aStatusCode, string aMessage, GeoAddresses aGeoAddresses) {
			success=aSuccess;
			statusCode=aStatusCode;
			message=aMessage;
			GeoAddresses=aGeoAddresses;
		}
		public boolean success              {get; private set;}
		public string  message              {get; private set;}
		public GeoAddresses GeoAddresses    {get; private set;}
		public string  statusCode           {get; private set;}
	}

	/* ******************************************************************************
    class Address

    description:  basic address information

    constructors:
        Address()
        Address(string aStreet, string aCity, string aState, string aPostalCode,string aCountry) {
        Address(Account a)
        Address(Account a, Boolean useShipping)
        Address(Contact c)
        Address(Contact c, Boolean useOther)
        Address(Lead l)

    Methods:
        writeTo(Account a, [Boolean useShipping])
        writeTo(Contact c, [Boolean useOther])
        writeTo(Lead l)

	 ******************************************************************************* */
	public virtual class Address {
		public String Street {set; get;}
		public String City {set; get;}
		public String State  {set; get;}
		public String PostalCode {set; get;}
		public String Country {set; get;}
		//public String County {set; get;}
		public boolean secondary {set; get;}

		//----------------------------------------------------------------
		//Constructors
		//----------------------------------------------------------------
		public Address(){}
		public Address(string aStreet, string aCity, string aState, string aPostalCode, string aCountry) { 
			Street=     aStreet;
			City=       aCity;
			State=      aState;
			PostalCode= aPostalCode;
			Country=    aCountry;
		} 
		public Address(string aStreet, string aCity, string aState, string aPostalCode,string aCountry, boolean aSecondary) {
			Street=     aStreet;
			City=       aCity;
			State=      aState;
			PostalCode= aPostalCode;
			Country=    aCountry;
			secondary=  aSecondary;
		}

		public Address(sObject obj) {this(obj,false);}
		public Address(sObject obj, boolean useSecondary) {
			if      (obj.GetSObjectType() == Account.sObjectType ) {this((Account) obj,useSecondary);   }
			else if (obj.GetSObjectType() == Lead.sObjectType   ) {this((Lead)   obj);              }
			else if (obj.GetSObjectType() == Contact.sObjectType ) {this((Contact) obj,useSecondary);   }
		}
		public Address(Account a) {this(a,false);}
		public Address(Account a, Boolean useShipping) {
			System.debug('----------START SCRIPT STATEMENTS (Address(Account a, Boolean useShipping))---------->'+Limits.getScriptStatements());
			if (!useShipping)
			{this(a.BillingStreet,a.BillingCity,a.BillingState,a.BillingPostalCode,
					((a.Country__c == null || a.Country__c == '') && a.BillingCountry != null) ? a.BillingCountry : a.Country__c,useShipping);}
			else
			{this(a.ShippingStreet,a.ShippingCity,a.ShippingState,a.ShippingPostalCode,
					((a.Country__c == null || a.Country__c == '') && a.ShippingCountry != null) ? a.ShippingCountry : a.Country__c,useShipping);}
			System.debug('----------END SCRIPT STATEMENTS (Address(Account a, Boolean useShipping))---------->'+Limits.getScriptStatements());
		}
		public Address(Contact c) {this(c,false);}
		public Address(Contact c, Boolean useOther) {           
			if (!useOther)
			{this(c.MailingStreet,c.MailingCity,c.MailingState,c.MailingPostalCode,
					((c.Contact_Country__c == null || c.Contact_Country__c == '') && c.MailingCountry != null) ? c.MailingCountry : c.Contact_Country__c, useOther);}
			else
			{this(c.OtherStreet,c.OtherCity,c.OtherState,c.OtherPostalCode,
					(c.Contact_Country__c == null && c.OtherCountry != null) ? c.OtherCountry : c.Contact_Country__c, useOther);}
		}
		public Address(Lead l) {
			this(l.Street,l.City,l.State,l.PostalCode,
					((l.Lead_Country__c == null || l.Lead_Country__c == '' ) && l.Country != null) ? l.Country : l.Lead_Country__c,false);
		}
		//----------------------------------------------------------------


		public boolean equals(Address addr) {
			return ( City.equalsIgnoreCase(addr.City)               && State.equalsIgnoreCase(addr.State)       &&
					PostalCode.equalsIgnoreCase(addr.PostalCode)   && Country.equalsIgnoreCase(addr.Country) );
		}

		public void writeTo(Account a) {writeTo(a,false);}
		public void writeTo(Account a, boolean useShipping) {
			if (!useShipping) {
				a.BillingStreet = Street;
				a.BillingCity = City;
				a.BillingState = State;
				a.BillingPostalCode = PostalCode;
				a.Country__c = Country;
			}
			else{
				a.ShippingStreet = Street;
				a.ShippingCity = City;
				a.ShippingState = State;
				a.ShippingPostalCode = PostalCode;
				a.Country__c = Country;
			}
		}
		public void writeTo(Contact c) {writeTo(c,false);}
		public void writeTo(Contact c, boolean useOther) {
			if (!useOther) {
				c.MailingStreet = Street;
				c.MailingCity = City;
				c.MailingState = State;
				c.MailingPostalCode = PostalCode;
			}
			else{
				c.OtherStreet = Street;
				c.OtherCity = City;
				c.OtherState = State;
				c.OtherPostalCode = PostalCode;
			}
			c.Contact_Country__c = Country;
		}       
		public void writeTo(Lead l) {
			l.Street = Street;
			l.City = City;
			l.State = State;
			l.PostalCode = PostalCode;
		}

		public string format() {
			string s='';
			if (Street != null)         s += Street.replace('\n', ' ') + ' ';
			if (City != null )          s += City + ' ';
			if (State != null )         s += State + ' ';
			if (PostalCode!= null )     s += PostalCode + ' ';
			if (Country != null )       s += Country;
			return s;
		}

		public string blockformat() { return blockformat('\n'); }
		public string blockformat(string crlf) {
			return String.format('{1}{0}{2}, {3} {4}{0}{5}', new LIST<string>{crlf,Street,City,State,PostalCode,Country} );
		}
		public string blockformatHtml() { return blockformat('<br/>'); }
	}

	/////////////////////////////////////////////////////////////////////////////////////////////
	public virtual class GeoAddresses {
		MAP<integer,GeoAddress> mapGeoAddresses;

		public GeoAddresses(){
			mapGeoAddresses = new MAP<integer,GeoAddress>();
		}

		public integer add(GeoAddress value) {
			value.index=mapGeoAddresses.size();
			mapGeoAddresses.put(value.index,value);
			return value.index;
		}
		public integer add(GeoAddress value,string key) {
			value.index=mapGeoAddresses.size();
			mapGeoAddresses.put(value.index,value);
			value.key=key;
			return value.index;
		}

		public Map<id,integer> addSObjectMap(MAP<Id,sobject> mapSobj, boolean useSecondary) {
			Map<id,integer> rtn = new Map<id,integer>();  //sobject key to geoaddress index mapping

			//By constructing the geoAddress via a concreat:sobject saved ALOT of script staements
			if  (mapSobj.GetSObjectType() == Account.sObjectType ) {
				for (id key : mapSobj.keyset()) {
					//converting from address to geoaddress saves 11 script staements per loop
					rtn.put(key,add(new GeoAddress(new Address((Account)mapSobj.get(key),useSecondary)),key));
					System.debug('----------SCRIPT STATEMENTS ---------->'+Limits.getScriptStatements());
				}
			}
			else if (mapSobj.GetSObjectType() == Lead.sObjectType   ) {
				for (id key : mapSobj.keyset())
					rtn.put(key,add(new GeoAddress(new Address((Lead)mapSobj.get(key),useSecondary)),key));
			}       
			else if (mapSobj.GetSObjectType() == Contact.sObjectType ) {
				for (id key : mapSobj.keyset())
					rtn.put(key,add(new GeoAddress(new Address((Contact)mapSobj.get(key),useSecondary)),key));
			}
			else  {
				for (id key : mapSobj.keyset())
					rtn.put(key,add(new GeoAddress(mapSobj.get(key),useSecondary),key));
			}
			return rtn;
		}

		public integer size() { 
			if (mapGeoAddresses == null) return 0; 
			else return mapGeoAddresses.size(); 
		}
		public MAP<integer,GeoAddress> getMap() {
			return this.mapGeoAddresses;
		}
		public GeoAddress getGeoAddress(integer i) {
			return mapGeoAddresses.get(i);
		}


		public void resolveCountries() {
			for (GeoAddress ga : mapGeoAddresses.values() ) 
				ga.resolveCountry();
			/*
            //only performs a country lookup for each unique value
            //This maybe OBSOLETE now since we cache the aliases 
            Map<string, Country> mapC = new Map<string,Country>();
                //get country names
                for (GeoAddress ga : mapGeoAddresses.values() ) {
                    if (ga.address.country != null)
                        mapC.put(ga.address.country.toUpperCase(),null);
                    }
                //map names to Country
                Countries countries = new Countries();
                for (string countrynm : mapC.keyset() )
                    mapC.put(countrynm,countries.getCountry(countrynm));

                //update CountryInfo
                for (GeoAddress ga : mapGeoAddresses.values() ) {
                    ga.CountryInfo=mapC.get(ga.address.country.toUpperCase());
                    ga.resolveCountry();
                }

			 */
		}

		public void getCountryInfos() {
			countries gc = new Countries();
			for ( GeoAddress ga : mapGeoAddresses.values() ) {
				ga.countryInfo = gc.getCountry(ga.address.country);
				System.debug('----------SCRIPT STATEMENTS (getCountryInfos)---------->'+Limits.getScriptStatements());
			}       
		}       


		public void getCountryStateInfos() {                            
			getCountryInfos();
			states gs = new States(getCountryIds()); 
			for ( GeoAddress ga : mapGeoAddresses.values() ) {
				try {
					ga.StateInfo = gs.getState(ga.countryInfo.id, ga.address.state);
				}
				catch (exception e) {}
				System.debug('----------SCRIPT STATEMENTS (getCountryStateInfos)---------->'+Limits.getScriptStatements());
			}   
		}


		public void resolveCountriesAndStates() {
			//Optimized Bulk call for states (uses 5% less script statements)
			//The call (new states(getCountryIds()) will add all states in the used countries to cache
			//otherwise a SOQL hit will be used for each country in geoadresses
			resolveCountries();
			states s = new States(getCountryIds()); 
			for ( GeoAddress ga : mapGeoAddresses.values() ) {  
				if (s!=null && ga.countryInfo!=null && ( ga.address.state != null || ga.address.state != '' )) {
					ga.stateInfo = s.getState(ga.countryInfo.id, ga.address.state);
					system.debug('--ga.stateInfo--->: '+ga.stateInfo);
					if (ga.stateInfo!=null) {
						ga.address.state    = ga.stateInfo.name;
						ga.statename        = ga.stateInfo.fullname;
					}
					else
						ga.statename=null;
				}
			}
		}       

		public void resolveAll() {
			resolveCountriesAndStates();
			//The call (new Counties(getStateIds())) will add all counties in the used states to cache
			//otherwise a SOQL hit will be used for each state in geoadresses
			Counties c = new Counties(getStateIds()); 
			for ( GeoAddress ga : mapGeoAddresses.values() ) 
				ga.resolveCounty();
		}

		private SET<Id> getCountryIds() {
			SET<Id> ids = new SET<Id>();
			for ( GeoAddress ga : mapGeoAddresses.values() ) 
				if (ga.CountryInfo!=null) ids.add(ga.CountryInfo.id);
			return ids;
		}

		private SET<Id> getStateIds() {
			SET<Id> ids = new SET<Id>();
			for ( GeoAddress ga : mapGeoAddresses.values() ) 
				if (ga.StateInfo!=null) ids.add(ga.StateInfo.id);
			return ids;
		}

	}

	/* ******************************************************************************
    class GeoAddress 

    description:  detailed address information typically resulted from a geocode provider

    constructors:
        GeoAddress()
        GeoAddress(Address aAddress, String aCounty, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy)
        GeoAddress(Address aAddress, String aCounty, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy, string citydistrict) 
        GeoAddress(Account a)
        GeoAddress(Account a, Boolean useShipping)

    methods:    
        public void writeTo(Account a)
        public void writeTo(Account a, boolean useShipping)
        //future: toKML
        //future: toJSON
        //future: toGeoRSS
	 ******************************************************************************* */
	public virtual class GeoAddress {
		public Country      countryInfo {get; protected set; }
		public State        stateInfo   {get; protected set; }
		public County       countyInfo  {get; protected set; }
		protected integer   index {set; get;}
		public string       key {set; get;}
		public Address      address {set; get;}
		public String       statename {set; get;}
		public String       county {set; get;}
		public String       fips {set; get;}
		public String       subRegion {set; get;}
		public String       region {set; get;}
		public LngLat       lnglat {set; get;}
		public String       accuracy {set; get;}
		public String       citydistrict {set; get;}

		//----------------------------------------------------------------
		//Constructors
		//----------------------------------------------------------------
		public GeoAddress(){}
		public GeoAddress(Address aAddress) {
			address         = aAddress;
		}
		//Version 0.1 compliance
		public GeoAddress(Address aAddress, String aCounty, String aFips, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy) {
			this(aAddress, aCounty, aFips, aSubRegion, aRegion, aLngLat, aAccuracy, null, null);
		}
		public GeoAddress(Address aAddress, String aCounty, String aFips, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy, String aCityDistrict) {
			this(aAddress, aCounty, aFips, aSubRegion, aRegion, aLngLat, aAccuracy, aCityDistrict, null);
		}
		public GeoAddress(Address aAddress, String aCounty, String aFips, String aSubRegion, String aRegion, LngLat aLngLat, String aAccuracy, String aCityDistrict, String aStateName) {
			//clear();
			address         = aAddress;
			statename       = aStateName;
			county          = aCounty;
			fips            = aFips;
			subRegion       = aSubRegion;
			region          = aRegion;
			LngLat          = aLngLat;
			Accuracy        = aAccuracy;
			citydistrict    = aCityDistrict;
		}

		public GeoAddress(sObject obj) {this(obj,false);}
		public GeoAddress(sObject obj, boolean useSecondary) {
			if      (obj.GetSObjectType() == Account.sObjectType ) {this((Account) obj,useSecondary);   }
			else if (obj.GetSObjectType() == Lead.sObjectType   ) {this((Lead)   obj);              }
			else if (obj.GetSObjectType() == Contact.sObjectType ) {this((Contact) obj,useSecondary);   }
		}

		public GeoAddress(Account a) {this(a,false);}
		public GeoAddress(Account a, Boolean useSecondary) {
			this(
					new Address(a,useSecondary),  
					useSecondary ? a.ShippingCounty__c : a.BillingCounty__c , 
							useSecondary ? a.ShippingFIPS__c : a.BillingFIPS__c ,  
									a.SubRegion__c, 
									a.Region__c,   
									useSecondary ? new LngLat(a.ShippingLongitude__c,a.ShippingLatitude__c) : new LngLat(a.BillingLongitude__c,a.BillingLatitude__c) ,  
											useSecondary ? a.ShippingAddressAccuracy__c : a.BillingAddressAccuracy__c,   
													useSecondary ? a.ShippingCityDistrict__c : a.BillingCityDistrict__c,
															useSecondary ? a.ShippingStateName__c : a.BillingStateName__c 
			);
		}
		public GeoAddress(Contact c) {this(c,false);}
		public GeoAddress(Contact c, Boolean useSecondary) {
			this(
					new Address(c,useSecondary),  
					useSecondary ? c.MailingCounty__c : null , 
							useSecondary ? c.MailingFIPS__c : null ,  
									c.SubRegion__c, 
									c.Region__c,   
									useSecondary ? new LngLat(c.MailingLongitude__c,c.MailingLatitude__c) : null ,  
											useSecondary ? c.MailingAddressAccuracy__c : null ,   
													useSecondary ? c.MailingCityDistrict__c : null,
															useSecondary ? c.MailingStateName__c : null
			);
		}   
		public GeoAddress(Lead l) {
			this(new Address(l),l.County__c, l.FIPS__c, l.SubRegion__c ,l.Region__c, new LngLat(l.Longitude__c,l.Latitude__c) ,l.AddressAccuracy__c, l.CityDistrict__c, l.StateName__c);
		}

		public integer getIndex() {return index;}
		public void clear() {
			address         = null;
			county          = null;
			fips            = null;
			subRegion       = null;
			region          = null;
			LngLat          = null;
			Accuracy        = null;
			CityDistrict    = null;
		}

		public Country getCountryInfo() { return getCountryInfo(true); }
		public Country getCountryInfo(boolean useCaching) {
			if (CountryInfo==null || ! useCaching ) {
				if (address.country == null || address.country == '') return null;
				Countries gc = new Countries();
				countryInfo = gc.getCountry(address.country);
			}
			return CountryInfo;
		}


		public State getStateInfo() { return getStateInfo(true); }
		public State getStateInfo(boolean useCaching) {
			if (StateInfo==null || ! useCaching ) {
				if (address.state == null || address.state == '') return null;
				if (getCountryInfo(true) != null) { //must have country to get state
					States states = new States(countryInfo.id);
					stateInfo = states.getState(countryInfo.id, address.state);
				}
				else return null;
			}
			return stateInfo;
		}

		public County getCountyInfo() { return getCountyInfo(true); }
		public County getCountyInfo(boolean useCaching) {
			if (county == null || county == '') return null;
			if (CountyInfo==null || ! useCaching ) {
				if (getStateInfo(true) != null) {  //must have state to get county
					Counties counties = new Counties(stateInfo.id);
					countyInfo = counties.getCounty(stateInfo.id, county);
				}
				else return null;
			}
			return countyInfo;
		}


		public boolean resolveCountry() {
			Country c = getCountryInfo(true);
			if (c!=null) {
				address.country     = c.name;
				subRegion           = c.subregion;
				region              = c.region;
				return true;
			}
			else {
				subRegion           = null;
				region              = null;
				return false; 
			}   
		}

		public boolean resolveState() {
			State s = getStateInfo(true);
			if (s!=null) {
				address.state   = s.name;
				statename         = s.fullname;
				return true;
			}
			else {
				statename         = null;
				return false; 
			} 
		}

		public boolean resolveCounty() {
			County c = getCountyInfo(true);
			if (c!=null) {
				county          = c.name;
				fips            = c.fips;
				return true;
			}
			else {
				fips            = null;
				return false; 
			}   
		}

		public void writeTo(sObject obj) {writeTo(obj,false);}
		public void writeTo(sObject obj, boolean useSecondary) {
			if      (obj.GetSObjectType() == Account.sObjectType ) { writeTo((Account) obj,useSecondary);   }
			else if (obj.GetSObjectType() == Lead.sObjectType   ) { writeTo((Lead)  obj);               }
			else if (obj.GetSObjectType() == Contact.sObjectType ) { writeTo((Contact) obj,useSecondary);   }
		}

		public void writeTo(Account a) {writeTo(a,false);}
		public void writeTo(Account a, boolean useSecondary) {
			address.writeTo(a,useSecondary);
			//Country
			if (CountryInfo != null) {
				a.Country__c    = CountryInfo.name;
				a.SubRegion__c  = CountryInfo.subRegion;
				a.Region__c     = CountryInfo.region;
			}
			if (useSecondary) {
				//State
				if (StateInfo != null) {
					a.ShippingState              = StateInfo.Name;
					a.ShippingStateName__c       = StateInfo.fullname;
				}
				//County                
				if (CountyInfo != null) {
					a.ShippingCounty__c         = CountyInfo.name;
					a.ShippingFIPS__c           = CountyInfo.fips;
				}
				else if (county !=null) 
					a.ShippingCounty__c = county;

				//CityDistrict
				if (citydistrict !=null) 
					a.ShippingCityDistrict__c   = citydistrict;         

				if (LngLat != null) {
					a.ShippingLongitude__c      = LngLat.Lng;
					a.ShippingLatitude__c       = LngLat.Lat;
					a.ShippingAddressAccuracy__c = accuracy;
				}
			}

			else {
				if (StateInfo != null) {
					a.BillingState               = StateInfo.Name;
					a.BillingStateName__c        = StateInfo.fullname;
				}
				if (CountyInfo != null) {
					a.BillingCounty__c      = CountyInfo.name;
					a.BillingFIPS__c            = CountyInfo.fips;
				}
				else if (county !=null) 
					a.BillingCounty__c = county;

				//CityDistrict
				if (citydistrict !=null) 
					a.BillingCityDistrict__c    = citydistrict; 

				if (LngLat != null) {
					a.BillingLongitude__c       = LngLat.Lng;
					a.BillingLatitude__c        = LngLat.Lat;
					a.BillingAddressAccuracy__c = accuracy;
				}


			}
		}
		public void writeTo(Contact c) {writeTo(c,false);}
		public void writeTo(Contact c, boolean useSecondary) { 
			address.writeTo(c,useSecondary);
			if (CountryInfo != null) {
				c.Contact_Country__c    = CountryInfo.name;
				c.SubRegion__c          = CountryInfo.subRegion;
				c.Region__c             = CountryInfo.region;
			}
			if (useSecondary)  {
				if (StateInfo != null) {
					c.OtherState                 = StateInfo.Name;
					//c.OtherStateName__c        = StateInfo.fullname;
				}
				/*  No Fields Exist
                if (CountyInfo != null) {
                    c.OtherCounty__c        = CountyInfo.name;
                    c.OtherFIPS__c          = CountyInfo.fips;
                }
                else
                    c.OtherCounty__c        = county;
                if (LngLat != null) {
                    c.OtherLongitude__c         = LngLat.Lng;
                    c.OtherLatitude__c          = LngLat.Lat;
                }

                c.OtherCityDistrict__c  = citydistrict;
                c.OtherAddressAccuracy__c = accuracy;
				 */
			}
			else {
				if (StateInfo != null) {
					c.MailingState               = StateInfo.Name;
					c.MailingStateName__c        = StateInfo.fullname;
				}
				if (CountyInfo != null) {
					c.MailingCounty__c      = CountyInfo.name;
					c.MailingFIPS__c            = CountyInfo.fips;
				}
				else if (county!=null)
					c.MailingCounty__c      = county;

				if (LngLat != null) {
					c.MailingLongitude__c       = LngLat.Lng;
					c.MailingLatitude__c        = LngLat.Lat;
					c.MailingAddressAccuracy__c = accuracy;
				}

				if (citydistrict!=null)
					c.MailingCityDistrict__c    = citydistrict;

			}           
		}   
		public void writeTo(Lead l) { 
			address.writeTo(l);
			if (CountryInfo != null) {
				l.Lead_Country__c       = CountryInfo.name;
				l.SubRegion__c          = CountryInfo.subRegion;
				l.Region__c             = CountryInfo.region;
			}
			if (StateInfo != null) {
				l.State              = StateInfo.Name;
				l.StateName__c       = StateInfo.fullname;
			}
			if (CountyInfo != null) {
				l.County__c         = CountyInfo.name;
				l.FIPS__c           = CountyInfo.fips;
			}
			else if (county!=null)
				l.County__c         = county;

			if (citydistrict!=null)
				l.CityDistrict__c   = citydistrict;

			if (LngLat != null) {
				l.Longitude__c          = LngLat.Lng;
				l.Latitude__c           = LngLat.Lat;
				l.AddressAccuracy__c = accuracy;
			}


		}
	}
	/******************************************************************************
    class LngLat

    description:  base class for geo cooridinates

    Constructors:
        LngLat(String LngLat)
        LngLat(String aLng, String aLat)
        LngLat(Double aLng, Double aLat)
        GeoAddress(Account a, Boolean useShipping)

    Methods:
        string getLatLng() = 'Lat, Lng'
        string getValue()  = 'Lng, Lat'
	 ****************************************************************************** */

	public virtual class LngLat {
		public Double Lng {set; get;}
		public Double Lat {set; get;}

		public LngLat() {
			Lng = 0;
			Lat = 0;
		}

		public LngLat(String LngLat) {
			try {
				String[] coor = LngLat.split(',',3);
				if (coor.size()>1) {
					Lng = Double.valueOf(coor[0]);
					Lat = Double.valueOf(coor[1]);
				}
			}
			catch(Exception e) {                
				Lng = 0;
				Lat = 0;
			}
		}

		public LngLat(String aLng, String aLat) {
			try {
				Lng = Double.valueOf(aLng);
				Lat = Double.valueOf(aLat);
			}
			catch(Exception e) {
				Lng = 0;
				Lat = 0;
			}
		}
		public LngLat(Double aLng, Double aLat) {
			Lng = aLng;
			Lat = aLat;
		}

		public LngLat(Decimal aLng, Decimal aLat) {
			Lng = aLng;
			Lat = aLat;
		}


		public string getLatLng() {return String.valueOf(Lat)+','+String.valueOf(Lng); }
		public string getValue() {return String.valueOf(Lng)+','+String.valueOf(Lat); }
	}


	/* ******************************************************************************
    Country
	 ****************************************************************************** */
	public virtual class Countries {
		public Countries() {
			if (Geography.mapCountriesCache == null) this.getCountries();
		}

		public integer size() { return mapCountriesCache.size(); }

		public MAP<String, Country> getMap() {
			return Geography.mapCountriesCache;
		}

		public Country getCountry(string CountryName) {
			if (CountryName==null) return null;
			CountryName=CountryName.trim().toUpperCase();
			if ( mapCountriesCache.containsKey(CountryName)) return mapCountriesCache.get(CountryName);
			else return getCountryByAlias(CountryName);
		}


		private MAP<string,string> getAliases() {
			if (mapCountryAliasesCache!=null) return mapCountryAliasesCache;
			else {
				mapCountryAliasesCache = new MAP<String,String>();
				for ( Country c : mapCountriesCache.values() ) {
					if (c.A2 !=null) mapCountryAliasesCache.put(c.A2.toUpperCase(),c.name.toUpperCase()); 
					if (c.A3 !=null) mapCountryAliasesCache.put(c.A3.toUpperCase(),c.name.toUpperCase());
					if (c.Aliases != null ) {
						for (string alias : c.Aliases.split('\n',-2))
							mapCountryAliasesCache.put(alias.trim().toUpperCase(),c.name.toUpperCase());
					}
				} //next state
				return mapCountryAliasesCache;
			}
		}

		public Country getCountryByAlias(string CountryName) {
			if ( getAliases().containskey(CountryName.toUpperCase()) )
				return mapCountriesCache.get(mapCountryAliasesCache.get(CountryName.toUpperCase()));
			else
				return null;
		}

		/* OBSOLETE
        public Country getCountryByA2(string A2) {
            for (Country c : mapCountriesCache.values() )
                if (A2 == c.A2) return c;
            return null;
            }

        public Country getCountryByA3(string A3) {
            for (Country c : mapCountriesCache.values() )
                if (A3 == c.A3) return c;
            return null;
            }
		 */

		private void getCountries() {
			Integer sz=Limits.getHeapSize();
			mapCountriesCache = new Map<String,country>(); 
			Map<id, Geography__c>  geoEntity = new Map<id, Geography__c>([
			                                                              SELECT Id, Name, Code__c, Code2__c, Aliases__c, 
			                                                              Parent__r.Name, Parent__r.Parent__r.Name
			                                                              FROM Geography__c
			                                                              WHERE Level__c=:LEVEL_COUNTRY ORDER BY Name
			                                                              ]);

			for (Geography__c g : geoEntity.values()) {
				country c = new country();
				c.Id = g.Id;
				//c.GeoHier=new String[]{null, g.Parent__r.Parent__r.Id, g.Parent__r.id, g.Id};
				c.name=g.Name;
				c.A2=g.Code__c;
				c.A3=g.Code2__c;
				c.Aliases=g.Aliases__c;
				c.subregion=g.Parent__r.Name;
				c.region=g.Parent__r.Parent__r.Name;
				Geography.mapCountriesCache.put(g.Name.toUpperCase(), c);
			}
			System.debug('HEAP Countries Cost/LIMIT/Total Cost/Remaining '+ (Limits.getHeapSize()-sz)+'/'+Limits.getLimitHeapSize()+'/'+Limits.getHeapSize()+'/'+(Limits.getLimitHeapSize()-Limits.getHeapSize())); 
			System.debug(mapCountriesCache);            

		}
	}   
	/////////////////////////////////////////////////////////////////////////////////////////////
	public virtual class Country {

		public void clear() {
			Id=null;
			//GeoHier=null;
			name=null;
			A2=null;
			A3=null;
			Aliases=null;
			subregion=null;
			region=null;
		}
		public ID       Id {get; set;} 
		//public ID[]   GeoHier {get; set;}
		public String   name {get; set;}        
		public String   A2 {get; set;}          
		public String   A3 {get; set;}              
		public String   Aliases {get; set;}         
		public String   subregion {get; set;}       
		public String   region {get; set;}              

	}   


	/* ******************************************************************************
    CountryStates
    States or Providences (level 4) fo a single Country
/* ******************************************************************************
  /*  public class CountryStates {
        private States States; 
        private String Country;

        public CountryStates(string acountry) { 
            Country = acountry;
            if (States == null) States = new States(new SET<string>{acountry}); 
            }
        public integer size() { return counties.size(); }
        public Counties getCounties() { return counties; }
        public String getStateCode()  { return stateCode; }

        public States getStates(string countyName) {
            return counties.getStates(countyName,stateCode);
        }
    }
	 */

	/* ******************************************************************************
    States
	 ****************************************************************************** */

	public virtual class States {
		private MAP<id,MAP<String, Geography.State>> mapStates;  //represent as single grouping of states

		//constructor

		public States(Id countryIds) { this.getStates(new SET<Id>{countryIds}); }
		public States(SET<Id> countryIds) {this.getStates(countryIds); } //preload states for multiple-country

		//public integer size() { return mapStates.size(); }

		public MAP<id,MAP<String, Geography.State>> getMap() {
			return mapStates;
		}

		public MAP<String, Geography.State> getMapByCountryId(id countryid) {
			return mapStates.get(countryid);
		}

		public State getState(string StateName) {
			//multi-country search
			if ( StateName == null ) return null;
			//first check all name matches
			for (MAP<String, Geography.State> countryStates : mapStates.values()) {
				if ( countryStates.containsKey(StateName.toUpperCase())) 
					return countryStates.get(StateName.toUpperCase());
			}
			State s;
			for (id countryid : mapStates.keySet() ) {
				s=getStateByAlias(countryid,StateName);
			}
			return s;
		}

		//country state map (mapStates) must be populated prior to calling this function
		public State getState(id countryId, string StateName){
			if ( countryId == null || mapStates.containskey(countryid)==null || StateName == null ) 
				return null;
			StateName=StateName.trim();
			if (mapStates.get(countryid).containsKey(StateName.toUpperCase())) 
				return mapStates.get(countryid).get(StateName.toUpperCase());
			else 
				return getStateByAlias(countryId,StateName);
		}   

		private MAP<string,string> getStateAliasesByCountry(id cid) {
			if (mapStateAliasesCache==null) 
				mapStateAliasesCache = new MAP<id,MAP<String,String>>();
			if ( mapStateAliasesCache.containsKey(cid) )
				return mapStateAliasesCache.get(cid);
			else {
				MAP<string,string> aliases = new MAP<string,string>();
				for (state s : mapStates.get(cid).values() ) {
					if (s.fullname !=null) aliases.put(s.fullname.toUpperCase(),s.name); 
					if (s.fullnameAscii !=null) aliases.put(s.fullnameAscii.toUpperCase(),s.name);
					if (s.ISO2 !=null) aliases.put(s.ISO2.toUpperCase(),s.name);  
					if (s.Aliases != null ) {
						for (string alias : s.Aliases.split('\n',-2))
							aliases.put(alias.trim().toUpperCase(),s.name);
					}
				} //next state
				mapStateAliasesCache.put(cid,aliases);
				system.debug('---State Aliases:->'+aliases);
				return aliases;
			}
		}

		private State getStateByAlias(id cid, string StateName) {
			MAP<string,string> aliases = getStateAliasesByCountry(cid);
			if (aliases.containsKey(StateName.toUpperCase()))
				return mapStates.get(cid).get(aliases.get(StateName.toUpperCase()).toUpperCase());
			else 
				return null;
		}

		/*
        private void getStates() {
            for (Geography__c g : [
                SELECT Id, Code__c,
                    (   SELECT Id, Name, Code2__c, Aliases__c 
                        FROM Geography__r )
                FROM Geography__c
                WHERE Level__c=:LEVEL_COUNTRY
            ]) {
                Map<String,State> CountryStates = new Map<String,State>(); 
                for (Geography__c gstate : g.Geography__r ) {
                    State s = new State();
                    s.id=gstate.Id;
                    s.name=gstate.Name;
                    s.A2=gstate.Code2__c;
                    s.aliases=gstate.Aliases__c;
                    s.parentid=g.id;
                    CountryStates.put(s.name.toUpperCase(), s);
                }
                mapStates.put(g.id,CountryStates);
            }
        }
		 */

		private void getStates(SET<id> countryIds) {
			//init cache if non-existant
			if (mapStatesCache==null) 
				mapStatesCache = new MAP<id,MAP<String, State>>(); 

			mapStates = new MAP<id,MAP<string,State>>();

			SET<id> missingFromCache = new SET<id>();
			for(id cid :countryIds) {
				if ( mapStatesCache.containsKey(cid) )
					mapStates.put(cid, mapStatesCache.get(cid));
				else
					missingFromCache.add(cid);   
			}

			if (missingFromCache.size()>0) {
				Integer sz=Limits.getHeapSize();

				for (Geography__c g : [
				                       SELECT Id, Code__c,
				                       (   SELECT Id, Name, Code2__c, Aliases__c, FullName__c, FullNameAscii__c
				                    		   FROM Geography__r )
				                    		   FROM Geography__c
				                    		   WHERE Level__c=:LEVEL_COUNTRY and id in : missingFromCache
				                    		   ]) {
					Map<String,State> countryStates = new Map<String,State>(); 
					for (Geography__c gstate : g.Geography__r ) {
						State s = new State();
						s.id=gstate.Id;
						s.parentid=g.id;
						s.name=gstate.Name;
						s.ISO2=gstate.Code2__c;
						s.fullName=gstate.fullName__c;
						s.fullNameAscii=gstate.fullNameAscii__c;
						s.aliases=gstate.Aliases__c;
						countryStates.put(s.name.toUpperCase(), s);
					}
					mapStates.put(g.id,CountryStates);
					mapStatesCache.put(g.id,CountryStates); 
				}
				System.debug('HEAP States Cost/LIMIT/Total Cost/Remaining '+ (Limits.getHeapSize()-sz)+'/'+Limits.getLimitHeapSize()+'/'+Limits.getHeapSize()+'/'+(Limits.getLimitHeapSize()-Limits.getHeapSize()));  
				System.debug('---------mapStatesCache--------: '+mapStatesCache);  

			} 
		}


	}

	/////////////////////////////////////////////////////////////////////////////////////////////

	public virtual class State {
		public  Id              id              {get; set;}
		public  Id              parentId        {get; set;} 
		public  String          name            {get; set;}
		public  String          ISO2            {get; set;}
		public  String          fullname        {get; set;}
		public  String          fullnameAscii   {get; set;}
		private Country         country;                    
		public  String          aliases     {get; set;} 

		public Counties getCounties()  {
			if ( id != null )
				return new Counties(id); 
			else
				return null;
		}


		//public void setCounties(StateCounties value)  {
			//      counties = value;  
			//  }   
	} 

	/* ******************************************************************************
    County
        list of counties , not state specific

    DONE...TODO: consider a MAP<String, Counties> mapAllCounties; //MAP<state, Counties>
    to cache county request results,  this can provide a less hits to the database for
    requests at the cost of heap size????  it would only be poulated with the states the were 
    previously queried and add new states only when unpopulated.  

    TODO: add a pub method to clear the cache.

	 ****************************************************************************** */
	//MAP<Id, Counties> MAP<StateId, AllCountiesState>
	public virtual class Counties {
		private MAP<Id, MAP<String, County>> mapCounties; 

		//contructor
		public Counties(Id stateId) { this.getCounties(new SET<Id>{stateId}); }
		public Counties(SET<Id> stateIds) {this.getCounties(stateIds); }

		//public integer size() { return mapCounties.size(); }

		public MAP<Id, MAP<String, County>> getMap() {return mapCounties;}

		public MAP<String, County> getMapByStateId(id stateid) {
			if ( mapCounties.containsKey(stateid))
				return mapCounties.get(stateid);
			else 
				return new MAP<String, County>();
		}




		//state County map (mapCounties) must be populated prior to calling this function
		public County getCounty(id stateId, string CountyName){
			if ( stateId == null || mapCounties.containskey(stateid)==null || CountyName == null ) 
				return null;
			CountyName=countyName.toUpperCase().replace('COUNTY','').trim();
			if (mapCounties.get(stateid).containsKey(CountyName) ) 
				return mapCounties.get(stateid).get(CountyName);
			else 
				return getCountyByAlias(stateId,CountyName);
		}   

		private MAP<string,string> getCountyAliasesByState(id sid) {
			if (mapCountyAliasesCache==null) 
				mapCountyAliasesCache = new MAP<id,MAP<String,String>>();
			if ( mapCountyAliasesCache.containsKey(sid) )
				return mapCountyAliasesCache.get(sid);
			else {
				MAP<string,string> aliases = new MAP<string,string>();
				for (County c : mapCounties.get(sid).values() ) {
					if (c.fips !=null) aliases.put(c.fips.toUpperCase(),c.name); 
					if (c.Aliases != null ) {
						for (string alias : c.Aliases.split('\n',-2))
							aliases.put(alias.trim().toUpperCase(),c.name);
					}
				} //next County
				mapCountyAliasesCache.put(sid,aliases);
				return aliases;
			}
		}

		private County getCountyByAlias(id sid, string CountyName) {
			MAP<string,string> aliases = getCountyAliasesBystate(sid);
			if (aliases.containsKey(CountyName.toUpperCase()))
				return mapCounties.get(sid).get(aliases.get(CountyName.toUpperCase()).toUpperCase());
			else 
				return null;
		}


		/*
        public County getCounty(string CountyName) {
            //multi-state search
            if ( CountyName == null ) return null;
            //first check all name matches
            for (MAP<String, Geography.County> stateCounties : mapCounties.values()) {
                if ( stateCounties.containsKey(CountyName.toUpperCase())) 
                    return stateCounties.get(CountyName.toUpperCase());
            }
            County county;
            for (id stateid : mapCounties.keySet() ) {
                county=getCountyByAlias(stateid,CountyName);
            }
            return county;
        }



        public County getCounty(Id stateid, string countyName) {
            if ( stateid == null || countyName == null ) return null;
            countyName=countyName.toUpperCase().replace('COUNTY','').trim();
            if ( getMapByStateId(stateid).containsKey(countyName.toUpperCase())) 
                    return getMapByStateId(stateid).get(countyName.toUpperCase()); 
            else 
                return getCountyByAlias(stateid, countyName);
        }

        public County getCountyByAlias(Id stateid, string countyName) {
            if ( stateid == null || countyName == null ) return null;
            countyName=countyName.toUpperCase().replace('COUNTY','').trim();
            for (County c : getMapByStateId(stateid).values()) {
                if (c.Aliases!=null) {
                    for (string alias : c.Aliases.split('\n',-2))
                        if (countyName == alias.trim().toUpperCase()) return c;
                }
            }
            return null;
        }

		 */




		private void getCounties(SET<id> stateIds) {
			if (mapCountiesCache==null)
				mapCountiesCache = new MAP<id,MAP<String, County>>(); 
			mapCounties = new MAP<id,MAP<string,County>>();
			SET<id> missingFromCache = new SET<id>();
			for(id sid :stateIds) {
				if ( mapCountiesCache.containsKey(sid) )
					mapCounties.put(sid, mapCountiesCache.get(sid));
				else
					missingFromCache.add(sid);   
			}

			if (missingFromCache.size()>0) {
				Integer sz=Limits.getHeapSize();                 
				for (Geography__c g : [
				                       SELECT Id, Code__c,
				                       (   SELECT Id, Name, Code2__c, Aliases__c, Level_Name__c //<AB20160322> - Modified to get non FSA County
				                    		   FROM Geography__r)
				                    		   FROM Geography__c
				                    		   WHERE Level__c=:LEVEL_STATE and id in : missingFromCache
				                    		   ]) {
					Map<String,County> stateCounties = new Map<String,County>(); 
					for (Geography__c gcount : g.Geography__r ) {
						county c = new county();
						c.id=gcount.Id;
						c.parentId=g.id;
						c.name=gcount.Name;
						c.fips=gcount.Code2__c;
						c.aliases=gcount.Aliases__c;
                        //<AB20160322> - Modified to get non FSA County, FSA is not used in code till now, to accomodate it FSA is added in the key to Identify it from NON FSA
                        String tmpstateCountiesKey = (gcount.Level_Name__c=='FSA')?c.Name.toUpperCase()+' FSA':c.Name.toUpperCase();
						stateCounties.put(tmpstateCountiesKey,c);
					}
					mapCountiesCache.put(g.id,stateCounties);
					mapCounties.put(g.id,stateCounties);
				}
				System.debug('HEAP Cost/LIMIT/Total Cost/Remaining '+ (Limits.getHeapSize()-sz)+'/'+Limits.getLimitHeapSize()+'/'+Limits.getHeapSize()+'/'+(Limits.getLimitHeapSize()-Limits.getHeapSize())); 
			} 
		}

	} //end class: Counties     


	public virtual class County {
		public Id       id {get; set;}
		public Id       parentId {get; set;}
		public String   name {get; set;}        
		public String   fips {get; set;}
		public String   stateCode {get; set;}   
		protected State state   {get; set;}     
		public String   aliases {get; set;} 

		public State getState() {
			if ( state != null ) return state;
			else return null;
		}

		// public void setState(State value)   {
			//      state = value; 
			//  }                   
	}


	public static void ClearCache() {
		mapCountriesCache=null;         
		mapCountryAliasesCache=null;        
		mapStatesCache=null;        
		mapStateAliasesCache=null;      
		mapCountiesCache=null;  
	}


	/*******************************************************************
    Utility 
	 *******************************************************************/
	public static Utilities Utility = new Utilities();
	public virtual class Utilities {

		// gets sobject with all geodata by id
		public sobject getGeoDataById(String Id) {
			sobject rtn;
			if (Id != null ) {

				try {
					if (Id.startsWith('001')) {
						rtn = [ Select Id, Name, Country__c, Region__c, SubRegion__c,
						        BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingStateName__c,
						        BillingCounty__c, BillingFIPS__c, BillingCityDistrict__c, BillingLongitude__c, BillingLatitude__c, BillingAddressAccuracy__c,
						        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingStateName__c,
						        ShippingCounty__c, ShippingFIPS__c, ShippingCityDistrict__c, ShippingLongitude__c, ShippingLatitude__c, ShippingAddressAccuracy__c
						        From Account where id= : Id ];
					}
					else if (Id.startsWith('00Q')) {
						rtn = [ Select Id, Name, Lead_Country__c, Region__c, SubRegion__c,
						        Street, City, State, PostalCode, Country, StateName__c,
						        County__c, FIPS__c, CityDistrict__c, Longitude__c, Latitude__c, AddressAccuracy__c
						        From Lead where id= : Id ];
					}
					else if (Id.startsWith('003')) {
						rtn = [ Select Id, Name, Contact_Country__c, Region__c, SubRegion__c,
						        MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateName__c,
						        MailingCounty__c, MailingFIPS__c, MailingCityDistrict__c, MailingLongitude__c, MailingLatitude__c, MailingAddressAccuracy__c,
						        OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry //, OtherStateName__c
						        From Contact where id= : Id ];
					}           
				}
				catch (Exception Ex) {
					rtn=null;
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You do not have access to Object Id: '+Id));
				}
			}
			return rtn;
		}

		/************************************************************************************************ 
          CAN Postalcodes returned via the Geocode Providers (google and mapquest) only return the 
         First 3 chars.  this function will replace the postal code in the goeaddress to the search address if 
         the first 3 chars match.   
		 ************************************************************************************************/ 
		public string scrubPostalCode(string old_pcode, string new_pcode,  string country) {
			if ( new_pcode == null ) return null;
			if ( old_pcode != null ) {
				if ( country == 'CANADA' ) {
					if ( new_pcode.length()==3 && old_pcode.length()>3 &&
							new_pcode.substring(0,3).toUpperCase()==old_pcode.substring(0,3).toUpperCase() 
					)
						return old_pcode.toUpperCase();
					else return new_pcode.toUpperCase();
				}
				else if ( country == 'UNITED STATES' ) {
					if ( new_pcode.length()==5 && old_pcode.length()>5 &&
							new_pcode.substring(0,5).toUpperCase()==old_pcode.substring(0,5).toUpperCase() 
					)
						return old_pcode.toUpperCase();
					else return new_pcode.toUpperCase();
				}
				else return new_pcode; 
			}
			else return new_pcode; 
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		//Zip Code Format Validation
		///////////////////////////////////////////////////////////////////////////////////////////////////////  
		public boolean validateZipcode(String CountryIsoCode,String zipcode){
			Boolean isValid;
			if(CountryIsoCode== 'US' || CountryIsoCode=='DE' || CountryIsoCode=='IT' || CountryIsoCode=='ES'){
				if (zipcode.length()>5) {
					zipcode=zipcode.substring(0,5); 
				}
				isValid = Pattern.matches('\\d{5}',zipcode);
			}
			else if (CountryIsoCode=='CA'){
				if (zipcode.length()>6){
					zipcode=zipcode.substring(0,6); 
				}
				isValid = Pattern.matches('[ABCEGHJKLMNPRSTVXYZ]\\d[A-Z]\\d[A-Z]\\d',zipcode);
			}
			else if (CountryIsoCode=='NL'){
				if (zipcode.length()>6){
					zipcode=zipcode.substring(0,6); 
				}
				isValid = Pattern.matches('\\d{4}[ABCEGHJKLMNPRSTVXYZ][ABCEGHJKLMNPRSTVXYZ]',zipcode);
			}
			else if (CountryIsoCode=='DK' || CountryIsoCode=='NO' ||CountryIsoCode=='PT'){
				if(zipcode.length()>4){
					zipcode=zipcode.substring(0,4);
				} 
				isValid = Pattern.matches('\\d{4}',zipcode);
			}
			else if (CountryIsoCode=='RU'){
				if (zipcode.length()>6){
					zipcode=zipcode.substring(0,6); 
				}
				isValid = Pattern.matches('\\d{6}',zipcode);
			}
			else if (CountryIsoCode=='PL'){
				zipcode=zipcode.replace('-','');
				zipcode=zipcode.trim();
				if (zipcode.length()>5){
					zipcode=zipcode.substring(0,5); 
				}
				isValid = Pattern.matches('\\d{5}',zipcode);
			}
			else if (CountryIsoCode=='GB'){
				if (zipcode.length()==5){
					zipcode=zipcode.substring(0,5); 
					isValid = Pattern.matches('[A-Z]\\d\\d[A-Z][A-Z]',zipcode);  //SJAGA20120718
				}      
				else if (zipcode.length()==6){
					zipcode=zipcode.substring(0,6); 
					isValid = Pattern.matches('[A-Z][A-Z0-9][A-Z0-9]\\d[A-Z][A-Z]',zipcode);  //SJAGA20120718
				}
				else if (zipcode.length()==7){
					zipcode=zipcode.substring(0,7); 
					isValid = Pattern.matches('[A-Z][A-Z]\\d[A-Z0-9]\\d[A-Z][A-Z]',zipcode); //SJAGA20120718
				}
			}
			else {
				isValid = true;   
			}
			return isValid;
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////
		//Zip code Format Sent to Mapquest 
		///////////////////////////////////////////////////////////////////////////////////////////////////////  
		public String getOriginZipcode(String CountryIsoCode,String zipcode){
			String OriginZipCode;
			if (CountryIsoCode=='CA'){
				OriginZipCode=zipcode.substring(0,3) + ' ' +zipcode.substring(3,6);
			}  
			else if(CountryIsoCode=='NL'){
				OriginZipCode=zipcode.substring(0,4) + ' ' +zipcode.substring(4,6);
			}
			else if(CountryIsoCode=='PL'){
				if(!zipcode.contains('-')){
					OriginZipCode=zipcode.substring(0,2) + '-' +zipcode.substring(2,5);
				}
				else{
					OriginZipCode=zipcode;
				}
			}
			else{
				OriginZipCode=zipcode;
			}
			return OriginZipCode;
		}

	}

}
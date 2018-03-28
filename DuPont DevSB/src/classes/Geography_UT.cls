/*******************************************************************************
Copyright © 2008 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Unit Test for Geography


********************************************************************************/
@isTest
private class Geography_UT {

/*
    static void testMapCountriesCache() {
        Geography.mapCountriesCache = new MAP<string,Geography.Country>();
        for ( Geography__c g : testdataCountries() ) {
            Geography.country c = new Geography.country();
            c.Id = g.Id;
            c.name=g.Name;
            c.A2=g.Code__c;
            c.A3=g.Code2__c;
            c.Aliases=g.Aliases__c;
            c.subregion=g.Parent__r.Name;
            c.region=g.Parent__r.Parent__r.Name;
            Geography.mapCountriesCache.put(g.Name, c);
        }
        system.debug('-----testMapCountriesCache:------>'+Geography.mapCountriesCache);
    }
*/

    static Geography__c[] testdataCountries()   {
        Geography__c g1 = new Geography__c(Parent__c=null, name='United States', Level__c=Geography.LEVEL_COUNTRY, Level_Name__c='Country', Code__c='US', Code2__c='USA', Aliases__c='', Numeric_Code__c=null);
        Geography__c g2 = new Geography__c(Parent__c=null, name='Italy', Level__c=Geography.LEVEL_COUNTRY, Level_Name__c='Country', Code__c='IT', Code2__c='IT', Aliases__c='Italie\nItalia');
        Geography__c[] rtn = new Geography__c[] {g1,g2};
        upsert rtn Code__c;
        return rtn;
        }

    static Geography__c[] testdataStates()  {
        Geography__c[] c = testdataCountries();
        Geography__c g1 = new Geography__c(Parent__c=c[0].id, name='DE', fullname__c='Delaware', Level__c=Geography.LEVEL_STATE, Level_Name__c='State', Code__c='US.DE', Code2__c='DE', Aliases__c='', Numeric_Code__c=null);
        Geography__c g2 = new Geography__c(Parent__c=c[0].id, name='MD', fullname__c='Maryland', Level__c=Geography.LEVEL_STATE, Level_Name__c='State', Code__c='US.MD', Code2__c='MD', Aliases__c='mary\'s land');
        Geography__c g3 = new Geography__c(Parent__c=c[0].id, name='PA', fullname__c='Pennsylvania', Level__c=Geography.LEVEL_STATE, Level_Name__c='State', Code__c='US.PA', Code2__c='PA', Aliases__c='');
        Geography__c[] rtn = new Geography__c[] {g1,g2,g3};
        upsert rtn Code__c;
        return rtn;
    }

    static Geography__c[] testdataCounties()    {
        Geography__c[] c = testdataCountries();
        Geography__c[] s = testdataStates();
        Geography__c g1 = new Geography__c(Parent__c=s[0].id, name='Sussex', Level__c=Geography.LEVEL_COUNTY, Level_Name__c='County', Code__c='US.DE.10005', Code2__c='10005', Aliases__c='sLower Delaware', Numeric_Code__c=10005);
        Geography__c g2 = new Geography__c(Parent__c=c[0].id, name='Chester', Level__c=Geography.LEVEL_COUNTY, Level_Name__c='County', Code__c='US.PA.Chester', Code2__c='029', Aliases__c='');
        Geography__c[] rtn = new Geography__c[] {g1,g2};
        upsert rtn Code__c;
        return rtn;
    }   



    static testMethod void testCountry1() {
        testdataCountries();
        Geography.Country c = new Geography.Country();
        c.clear();
        
    
        system.debug('Starting testCountry1...');
            Geography.Countries cs = new Geography.Countries();
            system.debug('TRY ITALY:'+ cs.getCountry('ITALY'));     //by name
            system.debug('TRY ITALIA:'+ cs.getCountry('ITALIA'));   //by alias
            system.debug('TRY Italie :'+ cs.getCountry('Italie ')); // by another alias
            system.debug('TRY US :'+ cs.getCountry('US'));          // by ISO A2 Code__c
            system.debug('TRY US :'+ cs.getCountry('USA'));         // by ISO A3 Code__c
            system.debug('TRY US :'+ cs.getCountry('X1'));          // invalid ISO A2 Code__c
            system.debug('TRY US :'+ cs.getCountry('A1X'));         // invalid ISO A3 Code__c
            system.debug('TRY US :'+ cs.size());  
            
              
        }



    static testMethod void testStates() {  
        testdataStates();
        //States Contructor...
        Geography.Countries c= new Geography.Countries();
        Geography.States s = new Geography.States(new SET<Id>{c.getCountry('US').Id}); //by Country GeoIds(s)
        //s = new Geography.states(new SET<String>{'DE','MD','PA'});            //by List of States
        
        id cid = c.getCountry('US').Id;       
        //system.debug(s.getState(cid,'PA').getCounties().getCounty('Chester'));
        //system.debug(s.getState(cid,'delaware').getCounties().getCounty('Kent'));
        system.debug(s.getState(cid,'mary\'s land'));
        
        //s = new Geography.States();  //get all the states
        //system.debug('TRY State Size() :'+s.size());
        //system.debug('TRY first state name :'+ s.getMap().values()[1].name);
        //system.debug('TRY Get Country :'+ s.getState('Delaware').countryA2);
        
        system.debug(s.getState('XX')); //invalid State 
        
    }

    static testMethod void testStateCounties() {
        testdataCounties();
        Geography.countries c = new Geography.countries();
        Geography.states s = new Geography.states(c.getCountry('US').id);
        Geography.counties sc = new Geography.counties(s.GetState('DE').id);
        //system.debug(sc.size());  
        system.debug(s.GetState('DE').getCounties());  
        //system.debug(sc.getCounty('Sussex')); 
        //system.debug(sc.getStateCode()); 
    }

/*
static testMethod void testCounties() {
        testdataCounties();
        system.debug('Starting Geography.Counties testing...');
        Geography.Counties cs = new Geography.Counties(new SET<String>{'DE','PA'});
        system.debug(cs.getMap());
        system.debug('TRY getCountyByFIPS 10005 and getState:'+ cs.getCountyByFIPS('10005').getState());
        system.debug('TRY DE-Sussex:'+ cs.getCounty('SUSSEX','DE'));

        system.debug('TRY sLower Delaware:'+ cs.getCounty('sLower Delaware','DE'));
        system.debug('TRY West Chester:'+ cs.getCounty('Chester','PA'));
        system.debug('TRY Size() :'+ cs.size()); 
        system.debug(cs.getCountyByFIPS('10005').getState().getCounties());
         
        
       //will rtn null
        system.debug(cs.getCounty(null,'DE')); 
        system.debug(cs.getCountyByAlias(null,'XX'));
        system.debug(cs.getCountyByAlias('No such County','XX'));
        system.debug(cs.getCountyByFIPS('99989'));
        }

    ////////////////////////////////////////////////////////////////////////////////////////////////
*/

    static testMethod void testUtilities() {
        //allow inserts of each these objects wo/ going over limits
/*PKH       
        geoValidation.validateInTestMode=true;
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        geoValidation.DisableGeoValidationOverride=true;
        Contact c = new Contact(lastname='test', Account=a,MailingStreet='14 Main St',MailingPostalCode='19711', Contact_Country__c='United States');
        insert c;
        Lead l = new Lead(lastname='test', Company='test',Street='14 Main St',PostalCode='19711', Lead_Country__c='United States');
        insert l;
        
        Geography.Utility.getGeoDataById(a.id);
        Geography.Utility.getGeoDataById(c.id);
        Geography.Utility.getGeoDataById(l.id);
        
        Geography.Utility.scrubPostalCode('19711-1234', '19711', 'UNITED STATES');
        Geography.Utility.scrubPostalCode('ABC DEF', 'ABC', 'CANADA');
        Geography.Utility.scrubPostalCode('19711-1234', '19711', 'UNITED STATES');
        Geography.Utility.scrubPostalCode('ABC', 'ABC DEF', 'CANADA');
        Geography.Utility.scrubPostalCode('19711', '19711-1234', 'UNITED STATES');
*/        
    }
    
 ////////////////////////////////////////////////////////////////////////////////////////////////

    
    static testMethod void testGeoAddress1() {
        geoValidation.validateInTestMode=true;
        Geography.GeoAddress add1 = new Geography.GeoAddress();
        add1 = new Geography.GeoAddress(new Geography.Address('Test1 Street','Newark', 'Delaware', '19711', 'UNITED STATES',false) , 'New Castle', '10003', 'United States', 'NA', new Geography.LngLat(10,10), 'NA');
        Geography.GeoAddress add2 = new Geography.GeoAddress(new Geography.Address('Test2 Street',null, null, '19808', 'US',false) , 'Sussex', '10001', 'United States', 'NA', new Geography.LngLat(10,10), 'NA');
        add1.getIndex();

        sobject a = new Account();
        sobject l = new Lead();
        sobject c = new Contact();
    
        add1.WriteTo(a);
        add2.WriteTo(a,true);
        add1.WriteTo(l);
        add1.WriteTo(c);
        add2.WriteTo(c,true);  
        add1.WriteTo((Account) a);
        add1.WriteTo((Contact)c);
     
        system.debug(a);
        system.debug(c);
        system.debug(l);
        //Address add = new Address();
        system.debug(new Geography.GeoAddress(a));                  //GeoAddress from Sobject.Account.Billing
        system.debug(new Geography.GeoAddress(a,true));             //GeoAddress from Sobject.Account.Shipping
        system.debug(new Geography.GeoAddress(c));                  //GeoAddress from Sobject.Contact.Mailing
        system.debug(new Geography.GeoAddress(c,true));             //GeoAddress from Sobject.Contact.Other
        system.debug(new Geography.GeoAddress(l));                  //GeoAddress from Sobject.Lead
        system.debug(new Geography.GeoAddress((account) a));        //GeoAddress from Account.Billing
        system.debug(new Geography.GeoAddress((contact) c));        //GeoAddress from Contact.Mailing

        add1.resolveCountry();
        add1.getCountryInfo();
        add1.resolveState();
        add1.getStateInfo();
        add1.resolveCounty();
        add1.getCountyInfo();
        add1.clear();
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    static testMethod void testAddress1() {
        geoValidation.validateInTestMode=true;
        Geography.Address add1 = new Geography.Address();
        add1 = new Geography.Address('Test1 Street','Newark', 'Delaware', '19711', 'UNITED STATES');
        Geography.Address add2 = new Geography.Address('Test2 Street',null, null, '19808', 'US',false);

        sobject a = new Account();
        sobject l = new Lead();
        sobject c = new Contact();

        add1.WriteTo((Account) a);
        add2.WriteTo((Account) a,true);
        add1.WriteTo((Lead) l);
        add1.WriteTo((Contact)c);
        add2.WriteTo((Contact)c,true);
        system.debug(a);
        system.debug(c);
        system.debug(l);
        system.debug(new Geography.Address(a));                         //GeoAddress from Sobject.Account.Billing
        system.debug(new Geography.Address(c));                         //GeoAddress from Sobject.Contact.Mailing
        system.debug(new Geography.Address(l));                         //GeoAddress from Sobject.Lead
        system.debug(new Geography.Address((account) a));           //GeoAddress from Account.Billing
        system.debug(new Geography.Address((contact) c));           //GeoAddress from Contact.Mailing
        system.debug(add1.format());
        system.debug(add1.blockformat());
        system.debug(add1.blockformatHtml());
        system.debug(add1.equals(add2));
        system.debug(add1.equals(add1));
    }
      ////////////////////////////////////////////////////////////////////////////////////////////////  
    static testMethod void testLngLat() {
        Geography.LngLat coor = new Geography.LngLat();
        coor = new Geography.LngLat('75,45');
        coor = new Geography.LngLat('A,45');
        coor = new Geography.LngLat('A','45');
        coor = new Geography.LngLat(75,45);
        System.debug(coor.getLatLng());
        System.debug(coor.getValue());
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    static testMethod void testGeocoder() {
        Geography.IS_TESTMETHOD = true;
        testdataCounties();
        Geography.IGeocodeProvider gcp = Geography.getProvider();
        gcp = Geography.getProvider('');
        gcp = Geography.getProvider('MAPQUEST');        
        gcp = Geography.getProvider('GOOGLE');  
        Geography.Address add1 = new Geography.Address('12 Main Street','Newark', 'DE', '19711', 'UNITED STATES',false);
        System.debug(gcp.getProviderName());
        //System.debug(gcp.getHttpRequest().getEndpoint());
        //System.debug(gcp.getHttpRequest().getBody());
        
        
        Geography.GeoAddresses gadds = new Geography.GeoAddresses();
        system.debug(gadds.size());
        gadds.add(new Geography.GeoAddress(add1, 'New Castle', '10003', 'United States', 'NA', new Geography.LngLat(10,10), 'NA'));
        system.debug(gadds.size());
        system.debug(gadds.getMap());
        system.debug(gadds.getGeoAddress(0));
        gadds.resolveAll();
        Geography.GeoCodeResults gcr = new Geography.GeoCodeResults();
        gcr = new Geography.GeoCodeResults(true,'200', 'Test Message', gadds);

        }  
        

      static testMethod void test_zipcodevalidator() {
          String Countrycode ='DE';
          String Zipcode ='83093';
          Geography.Utilities gu = new Geography.Utilities();
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
  
          Countrycode ='CA';
          Zipcode ='A2A2A2';
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
          
          Countrycode ='NL';
          Zipcode ='3334 KG';
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
          
          Countrycode ='DK';
          Zipcode ='3336';
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
          
          Countrycode ='RU';
          Zipcode ='333612';
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
          
          Countrycode ='PL';
          Zipcode ='01-932';
          gu.validateZipcode(Countrycode,Zipcode);
          
          Countrycode ='GB';
          Zipcode ='AA23SD';
          gu.validateZipcode(Countrycode,Zipcode);
          gu.getOriginZipcode(Countrycode,Zipcode);
          
          Countrycode ='GB';
          Zipcode ='AA324QW';
          gu.validateZipcode(Countrycode,Zipcode);
  } 
}
/*************************************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Authors:        TCS COO
Date:           25/01/2017
Description:    Test Class for generating Mock Response

***************************************************************************************************/
@isTest
global class MockHttpResponseGeneratorutil implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {   
        //Mock Response for geoProviderBase class
        if(req.getEndpoint()==null){
            String testXMLresponse = '<?xml version="1.0" encoding="UTF-8"?><statuscode></statuscode>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(testXMLresponse);
            res.setStatusCode(200);
            return res;
        }
        
        // Mock response for "SVMX_Batch_Geocoder" Class
        else if(req.getEndpoint().contains('http://maps.google.com/maps/geo?key'))
        {
            String testXMLresponse ='<?xml version="1.0" encoding="UTF-8"?><statuscode></statuscode><lat>231.123654</lat><lang>231.123654</lang>';            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(testXMLresponse);
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('http://www.mapquestapi.com/geocoding/v1/address?key'))
        {
            String testXMLresponse ='<?xml version="1.0" encoding="UTF-8"?><code></code><coordinates>231.123654,231.123654</coordinates>';            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(testXMLresponse);
            res.setStatusCode(200);
            return res;
        }  
        // Mock response for "startHereController" Class
        else if(req.getEndpoint().contains('http://www.apexdevnet.com/ootbe/starthere/catalog'))
        {
            String testXMLresponse ='<?xml version="1.0" encoding="UTF-8"?><htmlheader>Test Header</htmlheader><bannerURL>TestURL</bannerURL>';            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(testXMLresponse);
            res.setStatusCode(404);
            return res;
        }
        
        else if(req.getEndpoint().contains('https://www.mapquestapi.com/geocoding/v1/address')){
        	String testXMLresponse ='<?xml version="1.0" encoding="UTF-8"?><response><info><statusCode>0</statusCode><messages/><copyright><imageUrl>http://tile21.mqcdn.com/res/mqlogo.gif</imageUrl><imageAltText>© 2010 MapQuest, Inc.</imageAltText><text>© 2010 MapQuest, Inc.</text></copyright></info><results><result><providedLocation><postalCode>63376-6463</postalCode><adminArea1>UNITED STATES</adminArea1><street>4170 N Service Rd</street><adminArea3>MO</adminArea3><adminArea5>Saint Peters</adminArea5></providedLocation><locations><location><street>4170 N Service Rd</street><adminArea5 type="City">Saint Peters</adminArea5><adminArea3 type="State">MO</adminArea3><adminArea4 type="County">St. Charles County</adminArea4><postalCode>63376-6463</postalCode><adminArea1 type="Country">US</adminArea1><geocodeQuality>POINT</geocodeQuality><geocodeQualityCode>P1AAA</geocodeQualityCode><dragPoint>false</dragPoint><sideOfStreet>R</sideOfStreet><displayLatLng><latLng><lat>38.7969</lat><lng>-90.57371</lng></latLng></displayLatLng><linkId>20704847</linkId><type>s</type><latLng><lat>38.79637</lat><lng>-90.57377</lng></latLng></location></locations></result></results><options><maxResults>10</maxResults><thumbMaps>false</thumbMaps><ignoreLatLngInput>false</ignoreLatLngInput><boundingBox/></options></response>';            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(testXMLresponse);
            res.setStatusCode(200);
            return res;    
        }
        return null;
    }
}
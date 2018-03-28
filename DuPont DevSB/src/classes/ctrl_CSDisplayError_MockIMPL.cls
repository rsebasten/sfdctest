/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: This class is providing the mock response
 * email sanchit.dua@accenture.com
 * Change history (key updates):
 * 29th May, 2015 -> created the class
**/
//[06142017] Merge&Spin: Added @isTest as its a test mock response class
@isTest
global without sharing class ctrl_CSDisplayError_MockIMPL implements HttpCalloutMock {

    private static final String AUTHORIZATIONERROR = 'Insufficient Authorization';
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String CONTENTTYPEVAL = 'text/xml';
    
    /**
     * @param req
     * @return 
     */ 
    global HTTPResponse respond(HTTPRequest req) {
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader(CONTENTTYPE, CONTENTTYPEVAL);
        res.setBody(AUTHORIZATIONERROR);
        res.setStatusCode(200);
        return res;
    }

}
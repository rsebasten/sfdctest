@isTest	
public with sharing class utilUT {

	public class MockHttpResponse implements HttpCalloutMock {
	    // Implement this interface method
	    string mpayload='';
	    MAP<string,string> mheaders = new MAP<string,string>();
	   	public integer mstatusCode=200;
	   	
	    //Constructors
	    public MockHttpResponse() {
	    	mheaders.put('Content-Type', 'application/xml');
	    }
	    public MockHttpResponse(string payload) {
	    	mpayload=payload;
	    	mheaders.put('Content-Type', 'application/xml');
	    }    
	    public MockHttpResponse(string payload, MAP<string,string> headers) {
	    	mpayload=payload;
	    	mheaders=headers;
	    } 
	    
	   public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse res = new HttpResponse();
	        for(string nm : mheaders.keySet())
	        	res.setHeader(nm,mheaders.get(nm));
	        res.setBody(mpayload);
	        res.setStatusCode(mstatusCode);
	        return res;
	    }
	}


}
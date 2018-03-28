@isTest
global class COBWebServiceUtlityMockError implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Fault><faultstring>fsdf</faultstring><faultcode>200</faultcode></Fault></Body></Envelope>');
        res.setStatusCode(300);
        return res;
    }
}
/*
 *  Test class for testing:
 *  - Class SampleRequestWS 
 */
@istest
global class SampleRequestWS_UT {
    private static final Id SAR_CAPTURE_RTYPE   =   utilRT.getRT('Request__c','SalesAidCapture').Id;
    private static final Id SAR_SUBMITTED_RTYPE =   utilRT.getRT('Request__c','SalesAidSubmitted').Id;
    
    @isTest
    static void testCallout() {
        Account a = new Account();
        a.RecordTypeId = utilRT.getRT('Account','DuPont').Id;
        a.Name = 'Test';
        a.Country__c = 'UNITED STATES';
        a.Owning_Organization__c = 'AGCP';
        insert a;
        Catalog__c cat = new Catalog__c();
        cat.TransportProtocol__c = 'FTP';
        cat.Active__c = true;
        cat.Fulfillment_Supplier__c = a.Id;
        insert cat;
        Catalog_Item__c ci = new Catalog_Item__c();
        ci.Name = 'ItemTest';
        ci.Catalog__c = cat.Id;
        ci.Item_Status__c = 'Active';
        insert ci;
        Contact c=new Contact();
        c.LastName='test cont';
        insert c;
        Request__c r1=new Request__c();
        r1.RecordTypeId=SAR_CAPTURE_RTYPE;
        r1.Status__c = 'In Progress';
        r1.Sample_Request_Catalog__c=cat.Id;
        r1.Lead__c=null;
        r1.Contact__c=c.Id;
        r1.Send_to_Contact__c='testa testb';
        insert r1;
        Request_Item__c ri = new Request_Item__c();
        ri.Request__c = r1.Id;
        ri.Catalog_Item__c = ci.Id;
        insert ri;
        r1.RecordTypeId=SAR_SUBMITTED_RTYPE;
        r1.Status__c = 'In Progress';
        update r1;

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SampleRequestWS_UT.SampleRequestMockHttpResponse());
        /*r1.Stage__c = 'Submitted';
        update r1;*/
        List<Id> ids = new List<Id>();
        ids.add(r1.id);
        SampleRequestWS.callWS(ids);
        test.stopTest();
    }
    
    global class SampleRequestMockHttpResponse implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
            Organization org = [SELECT InstanceName, IsSandbox FROM Organization];
            if (org.IsSandbox)
                System.assertEquals('http://testfulfillment.cgx.com/PmOmsws/order.asmx', req.getEndpoint());
            else
                System.assertEquals('http://fulfillment.cgx.com/PmOmsws/order.asmx', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            res.setBody('<AddOrderResponse xmlns="http://sma-promail/"><AddOrderResult><OrderSeqID>69916</OrderSeqID><OrderID>RQ-181675</OrderID></AddOrderResult></AddOrderResponse>');
            res.setStatusCode(200);
            return res;
        }
    }
}
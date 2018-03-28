@isTest
private class API_UT {
    
    static testMethod void test_API() {
         Test.StartTest();
        system.debug(API.listMetadataCompact('','CustomObject'));
        system.debug(API.listMetadata('','CustomObject','filter'));
        LIST<API.FileProperties> fps = API.listMetadata('','CustomObject');
        system.debug(fps[0]);
        system.debug(API.listMetadataMap('','CustomObject'));
        system.debug(API.listMetadataMapbyId('','CustomObject'));
        system.debug(API.query('Select Name from Account where id=001000000000001'));
        API.LoginResponse lr = API.login('Joe.User@email.com','MyPassword',true);
        system.debug(lr.serverPod);
 //[01302017] Called below method to increase code coverage of API class.
        API.SOAPEnvelope SOAPEnv = new API.SOAPEnvelope(lr);
        
        system.debug(API.describeLayout('Metadata__c', new SET<Id>{'012000000000001','012000000000002'})); 
        
         API ap = new API();
        String testRep = api.TESTRESPONSE;
        Id testId = '012000000000001';
        API.FileProperties fp = new API.FileProperties(testId,'abc');
        API.metaSend('abc');
        XmlStreamReader reader1 = new XmlStreamReader(API.TESTRESPONSE_LoginResponse);
        API.FileProperties fpr = new API.FileProperties(reader1);
        Test.StopTest();
    }
    
}
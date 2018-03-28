///////////////////////////////////////
//<RB20141126> Rajiv Kumar Bhatter
//Description: Added a new Test method DecimaltoCurrency()



//////////////////////////////////////



@isTest
private class Punchout_UT {

    static string TEST_RESPONSE=CXML.createMessage(new CXML.Response('200','OK', 'https://somewhere.com/app?token=123')); 
    static string TEST_POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>111111111111111111222222222222222222___bip</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';
    
    public static testMethod void punchout_test1() {
            
            // Test.setMock(Punchout.IPunchoutService.class, new Punchout());
            Punchout.IPunchoutService ipunchout = Punchout.getService('bip','colornet');
            
            geoValidation.DisableGeoValidationOverride = false;
            CXML.PunchOutOrderMessage poom = new CXML.PunchOutOrderMessage(TEST_POOM);
            
            Account acc = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711',shippingstate='US', Country__c='United States');
            insert acc;
            Opportunity opp = new Opportunity(name='testopp', stagename='Won' , CloseDate=Date.Today(), accountid=acc.id, amount=100.10,
                //sales_program__c='asdad', Approval_Status__c='Approved'
                Approval_Status__c='Approved'
                );
            insert opp;
            Equipment__c eq = new Equipment__c( account_name__c=acc.id);
            insert eq;
            //<RB20141126>
            Contact con=new COntact(firstname='rajiv',lastname='kumar',AccountId=acc.Id,email='abc@abc.com');
            insert con;
            //Opportunity_Investment__c oppInv = new Opportunity_Investment__c(name='testoppinv', type__c='Products' ,opportunity__c=opp.id);
            //insert oppInv;
            //Request__c req = new Request__c(account__c=acc.id, type__c='bip', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
            //insert req;
            
            Test.startTest();
            //BIP from OPP
            Punchout.IPunchoutService svc = Punchout.getService('bip', opp.id);
            PageReference pageRef = svc.onInit(new Map<string,string>{'id'=>opp.id,'type' => 'bip'});
            //<RB20141126>
            Punchout.BuyerCookie bc=new Punchout.BuyerCookie();
            CXML.item x=new CXML.item();
            Punchout.OMSProduct op = new Punchout.OMSProduct(x);

            
            //BIP from OppInv wo/ Request
            string oppinvId=pageRef.getParameters().get('id');
            svc = Punchout.getService('bip', oppinvId);
            pageRef = svc.onInit(new Map<string,string>{'id'=>oppinvId,'type' => 'bip'});
            //system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL()));
            system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL(), TEST_RESPONSE));
            pageRef = svc.onBrowserPost(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+oppinvId+'___bip',10.00,'edit',poom.getItemMap()));
            
            //BIP from Request
            string requestId = pageRef.getUrl().substring(1);
            //OnInit and getSetupRequest() from request
            system.debug(requestId); 
            svc = Punchout.getService('bip', requestId);
            pageRef = svc.onInit(new Map<string,string>{'id'=>requestId,'type' => 'bip'});
            system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL(), TEST_RESPONSE));
            pageRef = svc.onBrowserPost(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+requestId+'___bip',10.00,'edit',poom.getItemMap()));
            
            //BIP from OppInv w/ request
            svc = Punchout.getService('bip', oppinvId);
            pageRef = svc.onInit(new Map<string,string>{'id'=>oppinvId,'type' => 'bip'});
            system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL(), TEST_RESPONSE));
           // system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL()));
            pageRef = svc.onBrowserPost(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+oppinvId+'___bip',10.00,'edit',poom.getItemMap()));
            pageRef = svc.OnCancel(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+oppinvId+'___bip',10.00,'edit',poom.getItemMap()));
            
            //Colornet from Equip
            svc = Punchout.getService('colornet', eq.id);
            pageRef = svc.onInit(new Map<string,string>{'id'=>eq.id,'type' => 'colornet'});
            system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL(), TEST_RESPONSE));
            //system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL()));
            pageRef = svc.onBrowserPost(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+eq.id+'___colornet',10.00,'edit',poom.getItemMap()));
            
            //Colornet from Request
            requestId = [Select Id from request__c limit 1].id;
         //   where Equipment__c =: eq.id removed the where clause as part of remediation -- kk
            svc = Punchout.getService('colornet', requestId);
            pageRef = svc.onInit(new Map<string,string>{'id'=>requestId,'type' => 'colornet'});
            system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL(), TEST_RESPONSE));
            //system.debug(Punchout.sendRequest(svc.getSetupRequest(), svc.getSetupRequestURL()));
            pageRef = svc.onBrowserPost(new cxml.PunchOutOrderMessage(UserInfo.getOrganizationId()+requestId+'___colornet',10.00,'edit',poom.getItemMap()));
            
            
            
            
            system.debug(Punchout.OMS_CreateCxmlHeader());
            //system.debug(getExtrinsicsByAccountId(new SetupRequest('edit',UserInfo.getOrganizationId()+eq.id+'___colornet','http://nowhere'),acc.id));
                        
            Punchout.BuyerCookie bc1 = new Punchout.BuyerCookie('111111111111111111222222222222222222___bip');
            system.debug(bc1);
            Punchout.BuyerCookie bc2 = new Punchout.BuyerCookie('111111111111111111222222222222222___bip');
            system.debug(bc2);
            
            Test.stopTest();
            
        }  
  
    
/********************************************************************************************   
//  TEST METHODS
********************************************************************************************/

    //public static testMethod void testBIP() {
    @isTest static void testBIP(){
            if (!System.Test.isRunningTest()){
                Punchout.IPunchoutService Ipunchout = Punchout.getService('bip','colornet');
                Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
                insert a;
                Request__c r = new Request__c(account__c=a.id, type__c='bip', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
                insert r;
                Test.startTest();
                PageReference pageRef = Page.Punchout_OMS;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', r.id);
                ApexPages.currentPage().getParameters().put('type', 'bip');
                ctrlPunchout controller = new ctrlPunchout();
                controller.init();
                Test.stopTest();
            }
        }  
         
  
    //public static testMethod void testColornet() {
    @isTest static void testColornet(){
            if (!System.Test.isRunningTest()){
                Punchout.IPunchoutService Ipunchout = Punchout.getService('bip','colornet');
                Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
                insert a;
                Request__c r = new Request__c(account__c=a.id, type__c='colornet', ExternalRequestId__c='123', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
                insert r;
                Test.startTest();
                PageReference pageRef = Page.Punchout_OMS;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', r.id);
                ApexPages.currentPage().getParameters().put('type', 'colornet');
                ctrlPunchout controller = new ctrlPunchout();
                controller.init();
                Test.stopTest();
            }
        }   
        
    public static testMethod void testBPHandler() {
            
            Punchout.IPunchoutService ipunchout = Punchout.getService('bip','colornet');
            
            Account acc = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
            insert acc;
            Request__c r = new Request__c(account__c=acc.id, type__c='colornet',Stage__c='submitted', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
            insert r;
            Equipment__c eq = new Equipment__c( account_name__c=acc.id);
            insert eq;
            
            Test.startTest();
            PageReference pageRef = Page.Punchout_BPHandler;
            Test.setCurrentPage(pageRef);
 //[02012017] Merge&Spin: added code to increase code coverage for 'ctrlPunchoutBPHandler' class           
            //missing Buyercookie and base64
            string POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';           
            ApexPages.currentPage().getParameters().put('cxml-base64',EncodingUtil.base64Encode(Blob.valueof(POOM)));
        ApexPages.currentPage().getheaders().put('Key','Value');    
        ctrlPunchoutBPHandler controller = new ctrlPunchoutBPHandler();
            system.debug(controller.headers);
            controller.init();
            
            //good one
            ApexPages.currentPage().getParameters().clear();
            POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>'+UserInfo.getOrganizationId()+eq.id+'___colornet</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';         
            ApexPages.currentPage().getParameters().put('cxml-urlencoded',POOM);
            controller.init();
            
            ApexPages.currentPage().getParameters().clear();
            POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie></BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader><ItemIn quantity="1"><ItemID><SupplierPartID>1</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="ex1">exvalue1</Extrinsic><Extrinsic name="ex2">exvalue2</Extrinsic></ItemDetail></ItemIn><ItemIn quantity="3"><ItemID><SupplierPartID>2</SupplierPartID><SupplierPartAuxiliaryID>cartid</SupplierPartAuxiliaryID></ItemID><ItemDetail><UnitPrice><Money currency="USD">16.50</Money></UnitPrice><Description xml:lang="en"/><UnitOfMeasure>each</UnitOfMeasure><Classification domain="CLASS1">classification 1</Classification><Classification domain="CLASS2">classification 2</Classification><Extrinsic name="test">testExtrinsic</Extrinsic></ItemDetail></ItemIn></PunchOutOrderMessage></Message></cXML>';         
            ApexPages.currentPage().getParameters().put('cxml-urlencoded',POOM);
            controller.init();
        
            ApexPages.currentPage().getParameters().clear();
            POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><</Message></cXML>';         
            ApexPages.currentPage().getParameters().put('cxml-urlencoded',POOM);
            controller.init();        
        
            //a cancel (no items)
            POOM='<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd"><cXML payloadID="@@payloadID" xml:lang="en-US" timestamp="@@timestamp"><Header><From><Credential domain="DUNS"><Identity>050983451</Identity></Credential></From><To><Credential domain="NetworkId"><Identity>586000814</Identity></Credential></To><Sender><Credential domain="degnanco"><Identity>support@degnanco.com</Identity></Credential><UserAgent>Punch_TapOutSite</UserAgent></Sender></Header><Message><PunchOutOrderMessage><BuyerCookie>'+UserInfo.getOrganizationId()+eq.id+'___colornet</BuyerCookie><PunchOutOrderMessageHeader operationAllowed="edit"><Total><Money currency="USD">33.00</Money></Total></PunchOutOrderMessageHeader></PunchOutOrderMessage></Message></cXML>';         
            ApexPages.currentPage().getParameters().put('cxml-urlencoded',POOM);
            controller.init();


            //Bad poom msg w/ debug
            POOM='garbage';         
            ApexPages.currentPage().getParameters().put('cxml-urlencoded',POOM);
            ApexPages.currentPage().getParameters().put('debug','1');
            controller.init();

            //invalid http Parameter
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('garbage',POOM);
            controller.init();
            
            Test.stopTest();
        }    
    //<RB20141126>
    public static testMethod void DecimaltoCurrency(){
    
            Punchout.IPunchoutService ipunchout = Punchout.getService('bip','colornet');
            
            Punchout  myItem = new Punchout();
            string returnValueString = '';
            
            test.startTest();
            returnValueString = myItem.test_DecimaltoCurrency(0.1);
            myitem.test_c('021365478901236');
            
            test.stopTest();
        }
        //<NC20141126>
        @isTest static void ListClass(){
        //public static testmethod void ListClass(){
            if (!System.Test.isRunningTest()){
            Punchout.IPunchoutService ipunchout = Punchout.getService('bip','colornet');
            Account acc = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711',shippingstate='US', Country__c='United States');
            insert acc;
            Request__c req = new Request__c(account__c=acc.id, type__c='bip', recordtypeid=Punchout.PUNCHOUT_REQUEST_RTYPEID);
            insert req;
            test.starttest();
            List<Punchout.OMSProduct> oms= new List<Punchout.OMSProduct>();
            Punchout.getOMSProducts(req,oms);
            test.stopTest();
            }
            
        }
}
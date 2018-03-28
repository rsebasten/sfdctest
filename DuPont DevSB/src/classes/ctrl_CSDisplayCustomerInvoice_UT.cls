/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * @author sanchit.dua
 * Description: Test class for the class ctrl_CSDisplayCustomerInvoice
 * Change history (key updates):
 * 1st April, 2015 -> created the class
 * Merge&Spin - Removed (seeAllData=true) and created Test Custom Settings
**/
@isTest
private class ctrl_CSDisplayCustomerInvoice_UT {
    private static final String INVOICE = 'Invoice';
    private static final String SANDBOXINVOICE = 'Sandbox_Invoices';
    
    private static final String INVOICEMSG = 'You should take care I mean it\'s just defining the Custom Settings - CS_Links__c with Name field \'Invoice\'';
    private static final String SANDINVOICEMSG = 'oh hell You should take care I mean it\'s just defining the Custom Settings - CS_Settings__c with Name field \'Sandbox_Invoices\'';
    
    private static final String INVOICESTR1 = '{"invoiceNo":"","fromDate":"1/21/2015","toDate":"5/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';    
    private static final String INVOICESTR2 = '{"invoiceNo":"","fromDate":"1/21/2015","toDate":"5/21/2015","distributionChannel":"","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR3 = '{"invoiceNo":"","fromDate":"1/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR4 = '{"invoiceNo":"","fromDate":"2/21/2015","toDate":"1/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR5 = '{"invoiceNo":"","fromDate":"10/21/2015","toDate":"11/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR6 = '{"invoiceNo":"","fromDate":"1/21/2015","toDate":"5/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":""}';
    private static final String INVOICESTR7 = '{"invoiceNo":"","fromDate":"6/21/2015","toDate":"5/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR8 = '{"invoiceNo":"","fromDate":"4/21/2015","toDate":"5/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR9 = '{"invoiceNo":"7611513166","fromDate":"4/21/2015","toDate":"5/21/2015","distributionChannel":"10","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
    private static final String INVOICESTR10 = '{"invoiceNo":"","fromDate":"4/21/2015","toDate":"5/21/2015","distributionChannel":"","division":"2","salesOrg":"F450","customerNumber":"55030508"}';
   
      // Merge&Spin - Create test custom settings
      Static{
         CS_Links__c csLink = new CS_Links__c(name ='Invoice');
        csLink.link__c = 'http://sapd03.lvs.dupont.com:8000/sap/bc/gui/sap/its/webgui/?~transaction=VF03&sap-client=301&+VBRK-VBELN=<Invoice Number>&~OKCODE=ENT2';
        insert csLink;
        CS_Settings__c csSetting = new CS_Settings__c(name ='Sandbox_Invoices');
        csSetting.End_Point__c = 'https://pg3.pioneer.com:443/sfdc_E2E/cSAP/service/InvoiceData';
        insert csSetting;
        }
        
   
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testMethod1(){
        Test.startTest();
        User u = new User(id=UserInfo.getUserId());   
              System.runAs(u){
            ApexPages.StandardController sc = new ApexPages.standardController(new Account());
            ctrl_CSDisplayCustomerInvoice CSD = new ctrl_CSDisplayCustomerInvoice(sc);
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayCustomerInvoices_MockIMPL());
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR3);
           /* ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR4);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR1);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR5); */
            system.debug('-----assert'+CS_Links__c.getInstance(INVOICE));
        }
        
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(INVOICE) != NULL, INVOICEMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXINVOICE) != NULL, SANDINVOICEMSG);
        
    } // END testmethod private static void testMethod1()
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testMethod2(){   
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayCustomerInvoices_MockIMPL());
            
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR2);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR6);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR7);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR1);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR8);
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR9);
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(INVOICE) != NULL, INVOICEMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXINVOICE) != NULL, SANDINVOICEMSG);
        
    } // END testmethod private static void testMethod2()
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testMethod3(){   
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayCustomerInvoices_MockIMPL());
            
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR2);
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(INVOICE) != NULL, INVOICEMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXINVOICE) != NULL, SANDINVOICEMSG);
        
    } // END testmethod private static void testMethod3()
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod private static void testMethod4(){   
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayBlankInvoices_MockIMPL ());
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR10);
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(INVOICE) != NULL, INVOICEMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXINVOICE) != NULL, SANDINVOICEMSG);
        
    } // END testmethod private static void testMethod4()

    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod static void TestMethod5(){
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayError_MockIMPL());
            ctrl_CSDisplayCustomerInvoice.parseInvoiceXml(INVOICESTR10);
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(INVOICE) != NULL, INVOICEMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXINVOICE) != NULL, SANDINVOICEMSG);
    
    } // END testmethod static void TestMethod5()

} // END private class ctrl_CSDisplayCustomerInvoice_UT
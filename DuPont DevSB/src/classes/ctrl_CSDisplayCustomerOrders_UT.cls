/**
 * Copyright (c) 2015, Sanchit Dua
 * All rights reserved.
 * Email: sanchit.dua@accenture.com
 * Description: Test class for the class ctrl_CSDisplayCustomerOrders
 * @author sanchit.dua
 * Change history (key updates):
 * 22nd April, 2015 -> created the class
 * Merge&Spin - Removed (seeAllData=true)
**/
@isTest
private class ctrl_CSDisplayCustomerOrders_UT {

    private static final String ORDER = 'Order';
    private static final String SANDBOXORDER = 'Sandbox_Orders';
    
    private static final String ORDERMSG = 'You should take care I mean it\'s just defining the Custom Settings - CS_Links__c with Name field \'Order\'';
    private static final String SANDORDERMSG = 'You should take care I mean it\'s just defining the Custom Settings - CS_Settings__c with Name field \'Sandbox_Orders\'';
    
    private static final String ORDERSTR1 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"2/24/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR2 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR3 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"2/20/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR4 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"6/20/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR5 = '{"orderNo":"0000001128","customerPO":"","fromDate":"2/1/2015","toDate":"4/2/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR6 = '{"orderNo":"","customerPO":"","fromDate":"2/1/2015","toDate":"4/2/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';
    private static final String ORDERSTR7 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String ORDERSTR8 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String ORDERSTR9 = '{"orderNo":"","customerPO":"test","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String ORDERSTR10 = '{"orderNo":"0000002658","customerPO":"test","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String ORDERSTR11 = '{"orderNo":"0000002658","customerPO":"test","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String LINKNAME = 'Order-123';
    private static final String LINKVAL = 'http://abcde.com';
    private static final String ORDERSTR12 = '{"orderNo":"0000002658","customerPO":"test","fromDate":"2/21/2015","toDate":"4/21/2015","distributionChannel":"10","division":"B","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"xyz"}';
    private static final String ORDERSTR13 = '{"orderNo":"","customerPO":"","fromDate":"2/21/2015","toDate":"2/24/2015","distributionChannel":"10","division":"B9","salesOrg":"TW02","customerNumber":"55512137","sourceCluster":"WP1"}';

    // Merge&Spin - Create test custom settings
      Static{
         CS_Links__c csLink = new CS_Links__c(name ='Order');
        csLink.link__c = 'http://sapd03.lvs.dupont.com:8000/sap/bc/gui/sap/its/webgui/?~transaction=VA03&sap-client=301&+VBAK-VBELN=<Order Number>&~OKCODE=ENT2';
        insert csLink;
        CS_Settings__c csSetting = new CS_Settings__c(name ='Sandbox_Orders');
        csSetting.End_Point__c = 'https://pg3.pioneer.com:443/sfdc_E2E/cSAP/service/OrderDetail';
        insert csSetting;
        }
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testMethod private static void testMethod0(){
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            ctrl_CSDisplayCustomerOrders.parseOrderXml(null);
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER) != NULL, SANDORDERMSG);      
        
    } // END testMethod public static void testMethod0()

    /**
     * Test Method 
     * @author sanchit.dua
     */    
    testMethod private static void testmethod1(){
       
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayCustomerOrders_MockIMPL());
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER ) != NULL, SANDORDERMSG);
        
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR1);
        
        ApexPages.StandardController sc = new ApexPages.standardController(new Account());
        ctrl_CSDisplayCustomerOrders CSD = new ctrl_CSDisplayCustomerOrders(sc);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR2);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR3);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR4);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR5);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR6);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR7);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR8);
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR9);   
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR10);   
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> 
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR11);   
        
    } // END testMethod public static void testmethod1()

    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod static void TestMethod2(){
        // ¸.·´¯`·.´¯`·.¸¸.·´¯`·.¸><(((º> GENERATING the callout exception based on the following DML inputs
        CS_Links__c myLinks = new CS_Links__c();
        myLinks.Name = LINKNAME;
        myLinks.Link__c = LINKVAL;
        insert myLinks;
        
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayCustomerOrders_MockIMPL());
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER) !=NULL, SANDORDERMSG);
        
        ctrl_CSDisplayCustomerOrders.parseOrderXml(null);
        
    } // END testmethod static void TestMethod2()

    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod static void TestMethod3(){
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayBlankCustOrders_MockIMPL());
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER) !=NULL, SANDORDERMSG);
        
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR12);
        
    } // END testmethod static void TestMethod3()
    
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod static void TestMethod4(){
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayErrorCustOrders_MockIMPL());
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER) !=NULL, SANDORDERMSG);
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR13);        
    
    } // END testmethod static void TestMethod4()
    
    /**
     * Test Method 
     * @author sanchit.dua
     */
    testmethod static void TestMethod5(){
        Test.startTest();
        System.runAs(new User(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new ctrl_CSDisplayError_MockIMPL());
        }
        Test.stopTest();
        System.assert(CS_Links__c.getInstance(ORDER) != NULL, ORDERMSG);
        System.assert(CS_Settings__c.getInstance(SANDBOXORDER) !=NULL, SANDORDERMSG);
        ctrl_CSDisplayCustomerOrders.parseOrderXml(ORDERSTR13);        
    
    } // END testmethod static void TestMethod5()
    

} // END public class ctrl_CSDisplayCustomerOrders_UT
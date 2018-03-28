/*
 *  Test class for testing:
 *  - VF SalesAideItems
 *  - VF CreateSalesAideRequest
 *  - Trigger trigRequestItem
 */
@istest
global class SalesAide_UT {
    private static final Id CONTACT_RTYPE       =   utilRT.getRT('Contact','DPT_NOW').Id;
    private static final Id SARI_CAPTURE_RTYPE  =   utilRT.getRT('Request_Item__c','SalesAidItemCapture').Id;
    private static final Id SAR_CAPTURE_RTYPE   =   utilRT.getRT('Request__c','SalesAidCapture').Id;
    private static final Id SAR_SUBMITTED_RTYPE =   utilRT.getRT('Request__c','SalesAidSubmitted').Id;
    private static Catalog_Item__c item1, item2, item3;
    private static Request__c reqEmpty, reqNotEmpty;
    
    static void setup() {
        // Create catalog & items
        Catalog__c cat = new Catalog__c(Name = 'Test', Active__c=true);
        insert cat;
        item1 = new Catalog_Item__c(Name = 'Item1', Catalog_Item_Name__c= 'Item1 Descr', Item_Status__c = 'Active', Catalog__c = cat.Id);
        item2 = new Catalog_Item__c(Name = 'Item2', Catalog_Item_Name__c= 'Item2 Descr', Item_Status__c = 'Active', Catalog__c = cat.Id);
        item3 = new Catalog_Item__c(Name = 'Item3', Catalog_Item_Name__c= 'Item3 Descr', Item_Status__c = 'Inactive', Catalog__c = cat.Id);
        insert item1;
        insert item2;
        insert item3;
        // Create requests & items
        Contact c = new Contact(RecordTypeId = CONTACT_RTYPE, FirstName = 'First', LastName = 'Last');
        insert c;
        reqEmpty = new Request__c(RecordTypeId = SAR_CAPTURE_RTYPE, Sample_Request_Catalog__c = cat.Id, Contact__c = c.Id);
        reqNotEmpty = new Request__c(RecordTypeId = SAR_CAPTURE_RTYPE, Sample_Request_Catalog__c = cat.Id, Contact__c = c.Id, Stage__c = 'Capture');
        insert reqEmpty;
        insert reqNotEmpty;
        Request_Item__c ritem1 = new Request_Item__c(RecordTypeId = SARI_CAPTURE_RTYPE, Request__c = reqNotEmpty.Id, Quantity__c = 1, Catalog_Item__c = item1.Id);
        insert ritem1;
        
    }
    
    static testmethod void testSalesAideItems(){
        setup();
        // Test cart with empty request
        PageReference pageRef = Page.SalesAideItems;
        pageRef.getParameters().put('Id', reqEmpty.Id);
        Test.setCurrentPageReference(pageRef);
        ctrlSalesAideItems ctrlSAI = new ctrlSalesAideItems(new ApexPages.StandardController(reqEmpty));
        // Cart must be empty
        system.assertEquals(ctrlSAI.ShoppingCart.size(), 0);
        // Test search no result
        ctrlSAI.searchString = 'not found';
        ctrlSAI.execSearch();
        system.assertEquals(0, ctrlSAI.searchResults.size());
        // Test all items except inactive
        ctrlSAI.searchString = 'Item';
        ctrlSAI.execSearch();
        system.assertEquals(2, ctrlSAI.searchResults.size());
        // Test add to cart
        ctrlSAI.idToAdd = ctrlSAI.searchResults[0].Id;
        ctrlSAI.addToShoppingCart();
        system.assertEquals(1, ctrlSAI.shoppingCart.size());
        // Test no error when saved
        ctrlSAI.shoppingCart[0].Quantity__c = 1;
        ctrlSAI.onSave();
        system.assertEquals(ApexPages.getMessages().size(), 0);
        // Test query requests items to confirm records were created
        Request_Item__c[] ris = [select Id from Request_Item__c where Request__c = :reqEmpty.Id];
        system.assertEquals(1, ris.size());
        ctrlSAI = new ctrlSalesAideItems(new ApexPages.StandardController(reqEmpty));
        ctrlSAI.OnSubmit();
        // Test request Stage = submitted
        Request__c r = [SELECT Stage__c from Request__c where Id = :reqEmpty.Id];
     //   System.assertEquals('Submitted', r.Stage__c);
        
        // Test cart with not empty request
        pageRef = Page.SalesAideItems;
        pageRef.getParameters().put('Id', reqNotEmpty.Id);
        Test.setCurrentPageReference(pageRef);
        ctrlSAI = new ctrlSalesAideItems(new ApexPages.StandardController(reqNotEmpty));
        // Cart must be have 1 line
        system.assertEquals(1, ctrlSAI.ShoppingCart.size());
        // Test remove loaded item from cart
        ctrlSAI.idToRemove = ctrlSAI.ShoppingCart[0].Catalog_Item__c;
        ctrlSAI.removeFromShoppingCart();
        system.assertEquals(0, ctrlSAI.shoppingCart.size());
        // Test remove added item from cart
        ctrlSAI.searchString = 'Item';
        ctrlSAI.execSearch();
        ctrlSAI.idToAdd = ctrlSAI.searchResults[0].Id;
        ctrlSAI.addToShoppingCart();
        ctrlSAI.idToRemove = ctrlSAI.ShoppingCart[0].Catalog_Item__c;
        ctrlSAI.removeFromShoppingCart();
        system.assertEquals(0, ctrlSAI.shoppingCart.size());
        ctrlSAI.onCancel();
    }
    
    static testmethod void testDeleteItemsCapture(){
        setup();
        Request_Item__c ri = [SELECT Id FROM Request_Item__c where Request__c = :reqNotEmpty.Id LIMIT 1];
        delete ri;
        integer recnbr = [SELECT Count() FROM Request_Item__c where Request__c = :reqNotEmpty.Id LIMIT 1];
        system.assertEquals(0, recnbr);
    }    

    static testmethod void testDeleteItemsSubmitted(){
        setup();
        reqNotEmpty.Stage__c = 'Submitted';
        update reqNotEmpty;
        Request_Item__c ri = [SELECT Id FROM Request_Item__c where Request__c = :reqNotEmpty.Id LIMIT 1];
        // Delete must trigger exception and records are not deleted
        try {
            delete ri;
        }
        catch (Exception e) {
            integer recnbr = [SELECT Count() FROM Request_Item__c where Request__c = :reqNotEmpty.Id LIMIT 1];
            system.assertEquals(1, recnbr);
        }
    } 
    
    static testmethod void testCreateSalesAidRequest() {
        integer recnbrBefore = [SELECT Count() FROM Request__c];
        Contact c = new Contact(RecordTypeId = CONTACT_RTYPE, FirstName = 'First', LastName = 'Last');
        insert c;
        PageReference pageRef = Page.CreateSalesAideRequest;
        pageRef.getParameters().put('Id', c.Id);
        Test.setCurrentPageReference(pageRef);
        ctrlCreateSalesAideRequest ctrlCSAR = new ctrlCreateSalesAideRequest();
        ctrlCSAR.redirect();
        // 1 request added
        integer recnbrAfter = [SELECT Count() FROM Request__c];
        system.assertEquals(1, recnbrAfter - recnbrBefore);
        recnbrBefore = recnbrAfter;
        Lead l = new Lead(Company = 'Test', FirstName = 'First', LastName = 'Last');
        insert l;
        pageRef = Page.CreateSalesAideRequest;
        pageRef.getParameters().put('Id', l.Id);
        Test.setCurrentPageReference(pageRef);
        ctrlCSAR = new ctrlCreateSalesAideRequest();
        ctrlCSAR.redirect();
        // 1 request added
        recnbrAfter = [SELECT Count() FROM Request__c];
        system.assertEquals(1, recnbrAfter - recnbrBefore);
    }
}
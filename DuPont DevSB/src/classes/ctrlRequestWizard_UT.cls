/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UT for controller: ctrlRequestWizard
********************************************************************************/
@isTest
private class ctrlRequestWizard_UT {
    

    static testMethod void ctrlRequestWizard_fromContact() { 

        Account a =new Account(name='TestCo', country__c='United States');
        insert a;
        Contact c =new Contact(accountid=a.id, lastname='TestCo: ', email='tester@test.com' , MailingStreet= 'TestStreet');
        insert c;

        Catalog__c catalog = new Catalog__c(Name='Test',Active__c=TRUE);
        insert catalog;
        Catalog_Item__c catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Approval');
        insert catitem1;
        Catalog_Item__c catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Warning');
        insert catitem2;
        Catalog_Item__c catitem3 = new Catalog_Item__c(Name='003',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Error');
        insert catitem3;
        

        Test.startTest();
        PageReference pageRef = Page.RequestWizard;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);        
        ctrlRequestWizard ctrl = new ctrlRequestWizard(); 
   
        ctrl.useSosl = True;
        ctrl.init();
        ctrl.getCatalogSelectOptions();
        /////////////////////////////////////////
        //STEP 1:  Search for items
        /////////////////////////////////////////
       // ctrl.CatalogId=catalog.id;
        ctrl.SearchString = '002';
        ctrl.catalogId= null;
        ctrl.Search_onClick();
        ctrl.RefreshSearchResults();
        //return items from entire catalog
        system.debug(ctrl.searchResults);
        //system.assertEquals(1,ctrl.searchResults.size());
        
        //all under limit
       // ctrl.searchResults[0].quantity=1; 
       // ctrl.searchResults[1].quantity=1;
       // ctrl.searchResults[2].quantity=1;
        
        ctrl.Add_onClick();
        system.debug(ctrl.cart);
        
        ctrl.onConfirm();
        ctrl.version=1;
        ctrl.onCheckout();
        ctrl.refresh();
        ctrl.initRequest('00p');       
        Test.stopTest();
    }
    
    static testMethod void ctrlRequestWizard_fromLead() { 

        Lead lead = new Lead(Company = 'Infosys',lastname = 'test', firstname ='testdata1');
        insert lead;

        Catalog__c catalog = new Catalog__c(Name='Test',Active__c=TRUE);
        insert catalog;
        Catalog_Item__c catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Approval');
        insert catitem1;
        Catalog_Item__c catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Warning');
        insert catitem2;
        Catalog_Item__c catitem3 = new Catalog_Item__c(Name='003',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Error');
        insert catitem3;
        

        Test.startTest();
        PageReference pageRef = Page.RequestWizard;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', lead.id);        
        ctrlRequestWizard ctrl = new ctrlRequestWizard(); 
   
   
        ctrl.init();
        ctrl.getCatalogSelectOptions();
        /////////////////////////////////////////
        //STEP 1:  Search for items
        /////////////////////////////////////////
       // ctrl.CatalogId=catalog.id;
        ctrl.SearchString = null;
        ctrl.catalogId= catalog.id;      
        ctrl.Search_onClick();        
        //return items from entire catalog
       // system.debug(ctrl.searchResults);
        system.assertEquals(3,ctrl.searchResults.size());
        
        //all over limit
        ctrl.searchResults[0].quantity=60; 
        ctrl.searchResults[1].quantity=60;
        ctrl.searchResults[2].quantity=60;
        
        ctrl.Add_onClick();
        system.debug(ctrl.cart+'////////////////////////////////////////////////');
        system.assertEquals(1,ctrl.cart.items.size());
        
        ctrl.onConfirm();
        ctrl.onBackToSelect();
        ctrl.eventid=ctrl.searchResults[0].indx;
        List<SelectOption> temp = ctrl.searchResults[0].sizeOptions;
        ctrl.deleteItem();
        ctrl.onCheckout();
        ctrl.refresh();
        
        
        Test.stopTest();
    }
  
   static testMethod void ctrlRequestWizard_fromContact1() { 

        Account a =new Account(name='TestCo', country__c='United States');
        insert a;
        Contact c =new Contact(accountid=a.id, lastname='TestCo: ', email='tester@test.com' , MailingStreet= 'TestStreet');
        insert c;

        Catalog__c catalog = new Catalog__c(Name='Test',Active__c=TRUE);
        insert catalog;
        Catalog_Item__c catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Approval');
        insert catitem1;
        Catalog_Item__c catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Warning');
        insert catitem2;
        Catalog_Item__c catitem3 = new Catalog_Item__c(Name='003',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Error');
        insert catitem3;
        

        Test.startTest();
        PageReference pageRef = Page.RequestWizard;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);        
        ctrlRequestWizard ctrl = new ctrlRequestWizard(); 
        //searchResult sr=new searchResult();
        ctrl.useSosl = false;
        ctrl.init();
        ctrl.getCatalogSelectOptions();
        /////////////////////////////////////////
        //STEP 1:  Search for items
        /////////////////////////////////////////
       // ctrl.CatalogId=catalog.id;
        ctrl.SearchString = '1';
        ctrl.catalogId= null;
        ctrl.Search_onClick();
        ctrl.RefreshSearchResults();
        //return items from entire catalog
        system.debug(ctrl.searchResults);
        //system.assertEquals(1,ctrl.searchResults.size());
        
        //all under limit
       // ctrl.searchResults[0].quantity=1; 
       // ctrl.searchResults[1].quantity=1;
       // ctrl.searchResults[2].quantity=1;
        
        ctrl.Add_onClick();
        system.debug(ctrl.cart);
        
        ctrl.onConfirm();
        ctrl.version=1;
        ctrl.onCheckout();
        ctrl.refresh();
        ctrl.initRequest('00p');       
        Test.stopTest();
    }
    
}
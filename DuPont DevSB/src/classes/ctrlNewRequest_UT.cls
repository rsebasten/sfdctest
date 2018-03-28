/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Sreedhar Jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  Unit Test for the controller ctrlNewRequest

* Modification Log 
* ============================================================================= 
* Ver   Date        Author                 Modification 
* ---   ---------   ----------- ----------------------------------------------- 
* 1.0   03-Sep-2012   Sreedhar Jagannath     Initial Code
* 2.0    04-Dec-2012  Ankit Gupta            Modified Test Class  

**************************************************************************************************************/
@isTest
private class ctrlNewRequest_UT{
             
    static testMethod void ctrlNewRequestforPortalUser_UT()
    {     
         String selecteditemid = 'test';
        System.assertEquals(selecteditemid,'test');
        Profile p  = [select id from Profile where UserLicense.Name like '%Partner %' limit 1];
        //Update to fix test class failure related to portal account owner
        Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
        UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];
        
        User owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsreeee',isActive = true,username='a@testingq1.com');
        insert owner;
        
        Account a = new Account();
        Contact con = new Contact();       
        
        System.runAs(owner) {

            a =new Account(name='TestCo', country__c='UNITED STATES',OwnerId =owner.Id);
            insert a;
            con =new Contact(OwnerId =owner.Id,accountid=a.id, firstname='Tom', lastname='Tester', email='tester@test.com');
            insert con;  
          
        }

        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User user1 = new User();
        Qualification__c qual = new Qualification__c();   
        Catalog_Item__c catitem1 = new Catalog_Item__c();
        Catalog_Item__c catitem2 = new Catalog_Item__c();
        
        List<SObject> lstobjectFieldMapping = new list<SObject>();
        System.runAs (owner) {
            //[20170103] Merge&Spin: Load test data for custom setting
            lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
            
            Profile p1 = [select id from profile where usertype = 'PowerPartner' limit 1];
            user1=new User( contactId=con.Id, LastName='sree56', ProfileId=p.Id,Alias='custP',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='jagasree@test.com' ,UserName='jagasree@test.com', EPass_ID__c='NA0000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
            insert user1;                          
            Catalog__c catalog = new Catalog__c(Name='Test',Ownerid=user1.id,active__c=true); 
            insert catalog;
            Initiative__c init = new Initiative__c (Name = 'Teflon® Extensions',Status_vs_Plan__c ='Green',Sponsor__c = con.Id,Priority__c='Medium',Stage__c='Active',Status__c='In Progress',Type__c='Management',SubType__c ='Reporting',Channel__c ='eMail',Start_Date__c = Date.today(), End_Date__c = Date.today()+5,Segment_Group__c='Construction',Geography__c = 'EMEA',Involved_Org__c='ABS',Objectives__c = 'test',Next_Steps__c='test',
                    Initiative_Group__c ='FLPR',Effort_Actual__c =100.00,Cost_Actual__c=100,Related_Catalog__c=catalog.Id,Ownerid=user1.id);
            insert init;
            qual = new Qualification__c(SubType__c='Garment',Qualification_Program__c = init.Id,Account_Name__c=a.id,Stage__c='Active',Colour__c='Piece-Dyed - Royal Blue',Colour_Reference__c='93 Royal blue',Reference_Id__c='12333',Colour_Comments__c='55 Navy Blue',Construction__c='Woven- Twill 2/1', Status__c='Approved' );
            insert qual;
            
             catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each');
            insert catitem1;
             catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each');
            insert catitem2;  
       }
       System.runAs(user1)  {
            ctrlNewRequest labelreq = new ctrlNewRequest(); 
            labelreq.catalogid = qual.Qualification_Program__r.Related_Catalog__c;
            system.debug('Qulaification &&&&' +labelreq.catalogid);
            labelreq.getCatalogSelectOptions();
            PageReference pageRef = Page.DPT_NomexLabelOrderRequest;
           pageRef.getParameters().put('conid',con.id);
            pageRef.getParameters().put('qualid',qual.id);
            Test.setCurrentPageReference(pageRef);
        //  labelreq.Cart.put('test',catitem1);
            labelreq.init();
            labelreq.initNomex();
            labelreq.getSearchResults();
            labelreq.Search_onClick();
            labelreq.searchResults[0].quantity = 5;
            labelreq.Add_onClick();
           List<string> lst=new List<string>();
           lst.addAll(labelreq.cart.keySet());
           pageRef.getParameters().put('cartid',lst[0]);
           labelreq.deleteItem();
            labelreq.getCart();
            labelreq.sortActiveCertGarments(new list<qualification__c>{qual});
            labelreq.onSave();

        } 
    }
    //< KV10172017 created new method to handle exception>
    static testMethod void ctrlNewRequestforPortalUserex_UT2()
    {     
        Profile p  = [select id from Profile where UserLicense.Name like '%Partner %' limit 1];
        
        //Update to fix test class failure related to portal account owner
        Profile sysadmin  = [select id from Profile where Name like '%System Administrator%' limit 1];
        UserRole role = [select Id from UserRole WHERE PortalType ='None' limit 1];
        
        User owner = new User(alias = 'testing', email='a@testing.com',emailencodingkey='UTF-8',FirstName = 'hello',lastname='Testing12',languagelocalekey='en_US',localesidkey='en_US',profileid = sysadmin.Id,UserRoleId= role.Id, timezonesidkey='America/Los_Angeles',CommunityNickname = 'testsreeee',isActive = true,username='a@testingq1.com');
        insert owner;
        
        Account a = new Account();
        Contact con = new Contact();
        
        System.runAs(owner) {

            a =new Account(name='TestCo', country__c='UNITED STATES',OwnerId =owner.Id);
            insert a;
            con =new Contact(OwnerId =owner.Id,accountid=a.id, firstname='Tom', lastname='Tester', email='tester@test.com');
            insert con;
        }

        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User user1 = new User();
        Qualification__c qual = new Qualification__c();          
        List<SObject> lstobjectFieldMapping = new list<SObject>();
        System.runAs (owner) {
            //[20170103] Merge&Spin: Load test data for custom setting
            lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
            
            Profile p1 = [select id from profile where usertype = 'PowerPartner' limit 1];
            user1=new User( contactId=con.id, LastName='sree56', ProfileId=p.Id,Alias='custP',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='jagasree@test.com' ,UserName='jagasree@test.com', EPass_ID__c='NA0000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
            insert user1;                          
            Catalog__c catalog = new Catalog__c(Name='Test',Ownerid=user1.id); 
            insert catalog;
            Initiative__c init = new Initiative__c (Name = 'Teflon® Extensions',Status_vs_Plan__c ='Green',Sponsor__c = con.Id,Priority__c='Medium',Stage__c='Active',Status__c='In Progress',Type__c='Management',SubType__c ='Reporting',Channel__c ='eMail',Start_Date__c = Date.today(), End_Date__c = Date.today()+5,Segment_Group__c='Construction',Geography__c = 'EMEA',Involved_Org__c='ABS',Objectives__c = 'test',Next_Steps__c='test',
                    Initiative_Group__c ='FLPR',Effort_Actual__c =100.00,Cost_Actual__c=100,Related_Catalog__c=catalog.Id,Ownerid=user1.id);
            insert init;
            qual = new Qualification__c(SubType__c='Garment',Qualification_Program__c = init.Id,Account_Name__c=a.id,Stage__c='Active',Colour__c='Piece-Dyed - Royal Blue',Colour_Reference__c='93 Royal blue',Reference_Id__c='12333',Colour_Comments__c='55 Navy Blue',Construction__c='Woven- Twill 2/1', Status__c='Approved' );
            insert qual;
            
            Catalog_Item__c catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each');
            insert catitem1;
            Catalog_Item__c catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each');
            insert catitem2;       
       }
       System.runAs(user1)  {
            ctrlNewRequest labelreq = new ctrlNewRequest(); 
            labelreq.catalogid = qual.Qualification_Program__r.Related_Catalog__c;
            system.debug('Qulaification &&&&' +labelreq.catalogid);
            labelreq.getCatalogSelectOptions();
            PageReference pageRef = Page.DPT_NomexLabelOrderRequest;
            pageRef.getParameters().put('conid',con.id);
            pageRef.getParameters().put('qualid',qual.id);
            Test.setCurrentPageReference(pageRef);
            labelreq.init();
            labelreq.initNomex();
            labelreq.getSearchResults();
            labelreq.Search_onClick();
            labelreq.searchResults[0].quantity = 5;
            labelreq.Add_onClick();
            labelreq.deleteItem();
            labelreq.getCart();
            labelreq.onSave();
            

        } 
    }

    static testMethod void ctrlNewRequestforNonPortalUser_UT()
    { 
     //[01022017] Merge&Spin: Replaced Hard coding of Record type Id
        string AGCP_CPC_EMEA_Moderate_RType = RType.getIdByDevName('Account','DPT_ES');  
        Account testAccount = new Account(Name='Test',Type='Distributor',Account_Stage__c='Active',Program__c='CPC',Country__c='France',Owning_Organization__c='AGC-CPC',RecordTypeId=AGCP_CPC_EMEA_Moderate_RType );
        insert testAccount;
        Contact con = new Contact(AccountId = testAccount.id,lastname = 'test', firstname ='testdata1',Importance__c = 'Main');
        insert con; 
        Lead lead = new Lead(Company = 'Infosys',lastname = 'test', firstname ='testdata1');
        insert lead;

        Profile p  = [select id from Profile where Name='System Administrator' limit 1];
         List<SObject> lstobjectFieldMapping = new list<SObject>();
        lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
          
        User user=new User(LastName='gjhsj', ProfileId=p.Id,Alias='custP',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='jaga@infosys.com' ,UserName='jaga@infosys.com', EPass_ID__c='NA1000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
        insert user; 
        Catalog__c catalog = new Catalog__c(Name='Test',Ownerid=user.id,Active__c=TRUE);
        insert catalog;
        Catalog_Item__c catitem1 = new Catalog_Item__c(Name='001',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=19,Quantity_Limit_Max_Action__c='Warning');
        insert catitem1;
        Catalog_Item__c catitem2 = new Catalog_Item__c(Name='002',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Warning');
        insert catitem2;
        Catalog_Item__c catitem3 = new Catalog_Item__c(Name='003',Item_Status__c='Active',Catalog__c=catalog.id,Unit_of_Measure__c='Each',Quantity_Limit_Max__c=50,Quantity_Limit_Max_Action__c='Error');
        insert catitem3;
        System.runAs(user){
            ctrlNewRequest labelreq = new ctrlNewRequest();  
            ctrlNewRequest.cartitem   cartitem1=new ctrlNewRequest.cartitem();
            Catalog_Item__c catitem4 =cartitem1.getCatalogItem();
            cartitem1.setcatalogItem(catitem4);
            cartitem1.qualItem=cartItem1.getqualItem();
            labelreq.getCatalogSelectOptions();
            labelreq.sortedCart.add(cartitem1);
            PageReference pageRef1 = Page.NewRequest;
            pageRef1.getParameters().put('conid',con.id);
            pageRef1.getParameters().put('qualid',null);            
            Test.setCurrentPageReference(pageRef1);
            labelreq.init();
            labelreq.catalog=catalog.id;
            labelreq.SearchString='00';
            labelreq.Search_onClick();            
            labelreq.getSearchResults();
            Catalog_Item__c cii=labelreq.searchResults[0].catalogItem;
            labelreq.searchResults[0].quantity = 5;
            labelreq.Add_onClick();
            labelreq.getCart();
            labelreq.onSave();

            ctrlNewRequest labelreq1 = new ctrlNewRequest();     
            labelreq1.getCatalogSelectOptions();
            PageReference pageRef11 = Page.NewRequest;
            pageRef11.getParameters().put('leadid',lead.id);
            Test.setCurrentPageReference(pageRef11);
            labelreq1.init();
            labelreq1.SearchString='00';
            labelreq1.catalog=catalog.id;
            labelreq1.getSearchResults();
            labelreq1.Search_onClick();           
            //labelreq.searchResults[0].quantity = 5;
            labelreq1.Add_onClick();
            labelreq1.getCart();
            labelreq1.onSave();
            
             ctrlNewRequest labelreq2 = new ctrlNewRequest();     
            labelreq2.getCatalogSelectOptions();
            PageReference pageRef3 = Page.NewRequest;
            pageRef3.getParameters().put('conid',con.id);
            Test.setCurrentPageReference(System.Page.DPT_NomexLabelOrderRequest);
            labelreq2.init();
            labelreq2.catalog=catalog.id;
            labelreq2.SearchString='00';
            labelreq2.getSearchResults();
            labelreq2.Search_onClick();           
            //labelreq.searchResults[0].quantity = 5;
            labelreq2.Add_onClick();
            labelreq2.getCart();
            labelreq2.onSave();

        } 
    }
}
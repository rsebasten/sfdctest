///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Name :ctrlBIeWarrantyInput_UT
//Author :Manasa.R
//Description: This is the test class for ctrleWarrantyInput, eWarrantyGetDealerAccRecords and trigCreateWarranty.
//************************************<MG-20120725>***************************************************//
//Email :Manasa.Gupta@ind.dupont.com
//Date :2012/07/25
//Description : Added UT for the new methods added in controller class.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Last Modified By : Ankit Gupta   Last Modified Date : 2013/06/04
//Description : Added the test logic for Corian color selector and Q&A's. 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@isTest
public with sharing class ctrlBIeWarrantyInput_UT {
    
    static testMethod void myUnitTest() {
    List<Material__c > mate =New List<Material__c >();
        Profile profileId=[select id from Profile where Name='System Administrator'];
        User user =new User(LastName='test_User',Alias='tUser',ProfileId=profileId.id,Email='divya_r11@infosys.com',Username='test_User3@dupont.com.dev5',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert user;
        System.runAs(user){
            
            /* fetch all the required record types*/
            Id entRecTypeId = ctrlBIeWarrantyInput.ENTRECTYPEID;          
            Id servconRecTypeId = Rtype.getIdByDevName('servicecontract','BI_EMEA_Service_Contract');
            Id accRecTypeId = Rtype.getIdByDevName('Account','ConstructionEMEA');
            Id conRecTypeId = Rtype.getIdByDevName('Contact','ConstructionEMEA');
            Id quaTypeId = Rtype.getIdByDevName('Qualification__c','BIPartnerCertification');
            Id initiativeRecTypeId = Rtype.getIdByDevName('Initiative__c','MarketingImplementation');
            Id proRecTypeId = Rtype.getIdByDevName('Product2','OneDuPontProduct');
            Id campRecTypeId = Rtype.getIdByDevName('Campaign','CampaignAdminMaster');
            Date todayDate = date.today();             
            ctrlBIeWarrantyInput.displayMessage('FATAL','Test error message');
            ctrlBIeWarrantyInput.displayMessage('INFO','Test info message');          
            /*insert all the required records*/
            Account fabAcc = new Account(Name='Test_Account_Fabricator',RecordTypeId=accRecTypeId,Type='Customer',Sub_Type_2__c='Fabricator',SubRegion__c='WE',
                                    Region__c='EMEA',Product_2__c='Corian',Phone='1234',Owning_Organization__c='BI',Mb_of_Marketing_Program__c='5 star Kitchen dealer',
                                    Country__c='ITALY',Account_Stage__c='Existing',OwnerId=user.id,Industry='Construction and Architecture');
            insert fabAcc;
            Account dealerAcc = new Account(Name='Test_Account_Dealer',RecordTypeId=accRecTypeId,Type='Customer',Sub_Type_2__c='Retailer',SubRegion__c='WE',
                                    Region__c='EMEA',Product_2__c='Corian',Phone='1234',Owning_Organization__c='M&S',Mb_of_Marketing_Program__c='Dealer Locator',
                                    Country__c='ITALY',Account_Stage__c='Existing',OwnerId=user.id);
            insert dealerAcc;
            Contact con = new Contact(LastName='Fabricator',AccountId=dealerAcc.id,Phone=dealerAcc.Phone,RecordTypeId=conRecTypeId,Migration_DB_id__c='121212');
            insert con;
            Product2 product = new Product2(RecordTypeId=proRecTypeId, Product_L2__c='EMEA', Product_L1__c='BI', Owning_Org__c='BI', Name='Test_Product', 
                                            Family='BI', Commercialisation_Stage__c='Commercial');
            insert product; 
            Material__c mat = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_Material', Material_Type__c='Product');
             mate.add(mat);                                 
            //insert mat; 
     ////////////////////////Added by Ankit Gupta///////////////////
            
            Material__c mat1 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_CorianColor1', Material_Type__c='Color');
            mate.add(mat1);
            //insert mat1;
            Material__c mat2 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_TEST_CorianColor2', Material_Type__c='Color');
            mate.add(mat2);
            //insert mat2;
            Material__c mat3 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_TEST_CorianColor3', Material_Type__c='Color');
           mate.add(mat3);
           insert mate;
            //insert mat3;  
    ////////////////////////////////////////////////////
                  
            ServiceContract servcon = new ServiceContract(Name='Test_ServiceContract',RecordTypeId=servconRecTypeId,StartDate=todayDate,OwnerId=user.Id,
                                                          AccountId=fabAcc.id,Entitlement_Start_Code__c=100,Entitlement_End_Code__c=200,Material__c=mat.id);
            insert servcon; 
            Campaign camp = new Campaign(Name='Test_Campaign',RecordTypeId=campRecTypeId,Type='Marketing Communication',OwnerId=user.Id,
                                                          StartDate=todayDate,Status='In Progress',EndDate=todayDate.addYears(10),Geography__c='EMEA-WE-Italy');
            insert camp;  
            
            Initiative__c init = new Initiative__c(Type__c='Marketing Implementation', SubType__c='Marketing Communication  ',Status_vs_Plan__c='Green', 
                                                   Status__c='In Progress', Start_Date__c=todayDate, RecordTypeId=initiativeRecTypeId, Priority__c='Medium', OwnerId=user.id, Name='Test_Initiative', Main_Product__c=product.id, Involved_Org__c='BI', Initiative_Group__c='BI', Geography__c='EMEA; EMEA-WE-Italy', End_Date__c=todayDate.addYears(10));
            insert init;                        
            Qualification__c qua = new Qualification__c(Account_Name__c=dealerAcc.Id,Geography__c='EMEA',RecordTypeId=quaTypeId,
                                                        Related_Contact__c=con.id,Type__c='Brand License',Stage__c='Active',Qualification_Program__c=init.id);
            insert qua;
            eWarrantyMapping__c testCustSettings = new eWarrantyMapping__c(Name='Test_Settings',Account_Currency__c='EUR',Application_2__c='Test',Owning_Organization__c='BI-Surf',Product_2__c='Corain',Subtype__c='Warranty',
                                                   Type__c='Warranty',RecordType_Account__c=accRecTypeId,RecordType_Contact__c=conRecTypeId,
                                                   Country__c='UNITED KINGDOM',Origin__c='eWarranty_UK',Campaign_Id__c=camp.id,Entitlement_Type__c='Warranty',Qualification_Program_ID__c=init.id,Info_link__c='www.google.com',termsConditions_link__c='www.yahoo.com',homePage_link__c='www.corian.com');                                    
            insert testCustSettings;
            ApexPages.currentPage().getParameters().put('webOrigin','Test_Settings');
            ctrlBIeWarrantyInput testInput = new ctrlBIeWarrantyInput();
            System.debug('$$$$$$$$'+testCustSettings );
            List<Entitlement> listent = new List<Entitlement>();
            listent = [select Entitlement_Code__c,Status from Entitlement where ServiceContractId=:servcon.Id];           
            ctrlBIeWarrantyInput.fetchColorData fetchClrData=new ctrlBIeWarrantyInput.fetchColorData();
            String fetch = testInput.getFetchedData();
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////Test cases for page 1
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            pagereference page1;
            page1 = new PageReference('apex/BI_eWarrantyInputPage');
            
            
            ApexPages.currentPage().getParameters().put('lang','russ');       
            ApexPages.currentPage().getParameters().put('warrantyCode',listent[0].Entitlement_Code__c);
            //ApexPages.currentPage().getParameters().put('lang','it'); 
           // ApexPages.currentPage().getParameters().put('lang','it'); 
           // ApexPages.currentPage().getParameters().put('lang','it'); 
                 
            //ID cupsEntityID=System.currentPageReference().getParameters().get('cupsrecordId');
            Test.StartTest();
            // Calling static methods
            ctrlBIeWarrantyInput.setwebOrigin('test');
            ctrlBIeWarrantyInput.setlangValue('test');
            
            // calling get methods
            testInput.getInfoLink();
            testInput.TermNConditionsLink();
            testInput.HomePageLink();
            testInput.searchColor();
            
           
            /*both fields null*/
            testInput.entitlementCode='';
            testInput.dateofPurchase=null;
            testInput.verifyWarrantyCode();
            
            /*invalid entitlement*/
            testInput.entitlementCode='abcx';
            testInput.dateofPurchase=Date.today();
            testInput.verifyWarrantyCode();
            
            /*invalid date*/
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.dateofPurchase=Date.today().addYears(10);
            testInput.verifyWarrantyCode();
            
            /* valid data*/
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.dateofPurchase=Date.today();
            testInput.verifyWarrantyCode();                  
            
            /*valid Data for Montelli*/
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.sellerid='121212';
            testInput.verifyMontelli();
            
            /*invalid Data for Montelli*/
            testInput.entitlementCode='ankit';
            testInput.sellerid='121212';
            testInput.verifyMontelli();
            
            /*invalid Data for Montelli*/
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.sellerid='121212345';
            testInput.verifyMontelli();            
            
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////Test cases for page 2
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            List<SelectOption> listcountry= testInput.getListCountry();
            List<SelectOption> listbrand= testInput.getListBrand();
            String strEnt = testInput.getstrEntitlementCode();
            testInput.setstrEntitlementCode(listent[0].Entitlement_Code__c);
            String strdop = testInput.getstrDoP();
            testInput.setstrDoP(String.valueOf(Date.today()));
            
            //entitlement and  date of purchase null
            testInput.strEntitlementCode='';
            testInput.strDoP='';
            testInput.addDetails();
            
            /* user details null */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='';
            testInput.custDetails.lastName='';
            testInput.custDetails.postalAddr='';
            testInput.custDetails.zipCode='';
            testInput.custDetails.province='';
            testInput.custDetails.city='';
            testInput.custDetails.country='';
            testInput.custDetails.email='';
            testInput.custDetails.telephone=''; 
            testInput.custDetails.kitchenBrand='';
            testInput.custDetails.kitchenBrandOther='';
            testInput.addDetails();
            
            /* country value null */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='none';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='12345'; 
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.custDetails.kitchenBrandOther='';
            testInput.termsCheck=true;
            testInput.addDetails();            
            
            /* Invalid telephone */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='dzfgf'; 
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.custDetails.kitchenBrandOther='';
            testInput.termsCheck=true;
            testInput.addDetails();
            
            /* dealer details null */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='12324'; 
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=null;
            testInput.dealerInfo=null;
            testInput.termsCheck=true;
            testInput.addDetails();
            
            /* Invalid Email*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta';
            testInput.custDetails.telephone='214345';  
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.addDetails();
            
            /* dealer info null updated*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='214345';  
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=null;
            testInput.dealerInfo='';
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.addDetails();
            
            /* dealer ID updated*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='214345';  
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.addDetails();
            
             /* dealer Info updated*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='34546';
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=null;
            testInput.dealerInfo='Test Dealer,Test street,Test province,124,Test Country';
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.addDetails();
            
            /* Other selected for brand and other text field null*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='54657';  
            testInput.custDetails.kitchenBrand='Other';
            testInput.custDetails.kitchenBrandOther='';
            testInput.custDetails.kitchenBrandName='Other';
            testInput.custDetails.selCorianColor='test';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.brandOther();
            testInput.addDetails();
            
            /* Other selected for brand*/
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='54657'; 
            testInput.custDetails.kitchenBrand='Other';
            testInput.custDetails.kitchenBrandOther='Test_Other';
            testInput.custDetails.kitchenBrandName='Other';
            testInput.custDetails.selCorianColor='test';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.brandOther();
            testInput.showPopupColor();
            testInput.searchColor();
                       
            //testInput.colorRecs();
            testInput.colorItemId=mat1; 
            testInput.addDetails();
            
            /* private check box unchecked */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='547657'; 
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=false;
            testInput.termsCheck=true;
            testInput.brandOther();
            testInput.addDetails();
            testInput.dealerName='TEST';          
            
            /* terms check box unchecked */
            
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='547657';  
            testInput.custDetails.kitchenBrand='Other';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=false;
            testInput.termsCheck=false;
            testInput.brandOther();
            testInput.addDetails();
            testInput.dealerName='TEST';
            testInput.selectedDealerName='TEST';
            testInput.radioStatus='yes';
            testInput.displayPopup=true;
            testInput.colorName='Test';
            testInput.selectedColorName='Test';
            testInput.showPopup();
            testInput.closePopup();

            testInput.outPanel='yes';
            
            //testInput.searchDealer(); 
            
            
            //testInput.dealerAccount=dealerAcc.id;
            //testInput.dealerRecs();
            
            //testInput.colorItem=mat1.id;
            //testInput.colorRecs();
            
             testInput.completeDealerName='Test_AddDealer';
             testInput.dealerPostalAddr='TestDealerAddr';
             testInput.dealerZipCode='1345';
             testInput.dealerProvince='TestdealerProvince';
             testInput.dealerCity='TestDealerCity';
             testInput.dealerCountry='TestDealerCountry';
             testInput.tempMsg='testing';
             testInput.myMsg=new ApexPages.Message(ApexPages.Severity.FATAL, 'Kindly enter the mandatory fields');
             testInput.addDealer();
             
             testInput.completeDealerName=null;
             testInput.addDealer();
             testInput.renderAddDealer();
             
             /* delete all dealer account */
          /*  List<Qualification__c> allQuaDealerAccount = new List<Qualification__c>();
            allQuaDealerAccount = [Select id from Qualification__c where Qualification_Program__r.id!=''];
            delete(allQuaDealerAccount);        
            testInput.strEntitlementCode=listent[3].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='214345'; 
            testInput.custDetails.kitchenBrand='Boffi';            
            testInput.custDetails.privateCheck=true;
            testInput.termsCheck=true;
            testInput.addDetails(); */
          
            
             /*entitlement registered */ 
             
             
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.dateofPurchase=Date.today();
            //Test.StartTest();
           Test.StopTest();
            testInput.verifyWarrantyCode();
            //Rohit saini 20160331 start
            testInput.dealerRecs(); 
            ctrlBIeWarrantyInput.fetchColorData fetch2=new ctrlBIeWarrantyInput.fetchColorData();
            fetch2.url='';
            fetch2.Name='';
            fetch2.Id='';
            testInput.dealerAccount=null;
            testInput.showPopup();
            testInput.dealerRecs();
              ApexPages.currentPage().getParameters().put('warrantyCode','');
            testInput.searchColor();
            //Rohit saini 20160331 end


            //Test.StopTest();
        }
    }
    static testMethod void myUnitTest1() {
    List<Material__c > mate =New List<Material__c >();
        Profile profileId=[select id from Profile where Name='System Administrator'];
        User user =new User(LastName='test_User',Alias='tUser',ProfileId=profileId.id,Email='divya_r11@infosys.com',Username='test_User3@dupont.com.dev5',IsActive=true,TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
        insert user;
        System.runAs(user){
            
            /* fetch all the required record types*/
            Id entRecTypeId = ctrlBIeWarrantyInput.ENTRECTYPEID;          
            Id servconRecTypeId = Rtype.getIdByDevName('servicecontract','BI_EMEA_Service_Contract');
            Id accRecTypeId = Rtype.getIdByDevName('Account','ConstructionEMEA');
            Id conRecTypeId = Rtype.getIdByDevName('Contact','ConstructionEMEA');
            Id quaTypeId = Rtype.getIdByDevName('Qualification__c','BIPartnerCertification');
            Id initiativeRecTypeId = Rtype.getIdByDevName('Initiative__c','MarketingImplementation');
            Id proRecTypeId = Rtype.getIdByDevName('Product2','OneDuPontProduct');
            Id campRecTypeId = Rtype.getIdByDevName('Campaign','CampaignAdminMaster');
            Date todayDate = date.today();             
            ctrlBIeWarrantyInput.displayMessage('FATAL','Test error message');
            ctrlBIeWarrantyInput.displayMessage('INFO','Test info message');          
            /*insert all the required records*/
            Account fabAcc = new Account(Name='Test_Account_Fabricator',RecordTypeId=accRecTypeId,Type='Customer',Sub_Type_2__c='Fabricator',SubRegion__c='WE',
                                    Region__c='EMEA',Product_2__c='Corian',Phone='1234',Owning_Organization__c='BI',Mb_of_Marketing_Program__c='5 star Kitchen dealer',
                                    Country__c='ITALY',Account_Stage__c='Existing',OwnerId=user.id,Industry='Construction and Architecture');
            insert fabAcc;
            Account dealerAcc = new Account(Name='Test_Account_Dealer',RecordTypeId=accRecTypeId,Type='Customer',Sub_Type_2__c='Retailer',SubRegion__c='WE',
                                    Region__c='EMEA',Product_2__c='Corian',Phone='1234',Owning_Organization__c='M&S',Mb_of_Marketing_Program__c='Dealer Locator',
                                    Country__c='ITALY',Account_Stage__c='Existing',OwnerId=user.id);
            insert dealerAcc;
            Contact con = new Contact(LastName='Fabricator',AccountId=dealerAcc.id,Phone=dealerAcc.Phone,RecordTypeId=conRecTypeId,Migration_DB_id__c='121212');
            insert con;
            Product2 product = new Product2(RecordTypeId=proRecTypeId, Product_L2__c='EMEA', Product_L1__c='BI', Owning_Org__c='BI', Name='Test_Product', 
                                            Family='BI', Commercialisation_Stage__c='Commercial');
            insert product; 
            Material__c mat = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_Material', Material_Type__c='Product');
             mate.add(mat);                                 
            //insert mat; 
     ////////////////////////Added by Ankit Gupta///////////////////
            
            Material__c mat1 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_CorianColor1', Material_Type__c='Color');
            mate.add(mat1);
            //insert mat1;
            Material__c mat2 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_TEST_CorianColor2', Material_Type__c='Color');
            mate.add(mat2);
            //insert mat2;
            Material__c mat3 = new Material__c(/*Geography__c='EMEA',Owning_Business__c ='Building Innovations',*/Owning_Org__c='BI', 
                                              Name='TEST_TEST_CorianColor3', Material_Type__c='Color');
           mate.add(mat3);
           insert mate;
            //insert mat3;  
    ////////////////////////////////////////////////////
                  
            ServiceContract servcon = new ServiceContract(Name='Test_ServiceContract',RecordTypeId=servconRecTypeId,StartDate=todayDate+10,OwnerId=user.Id,
                                                          AccountId=fabAcc.id,Entitlement_Start_Code__c=100,Entitlement_End_Code__c=200,Material__c=mat.id);
            insert servcon; 
            Campaign camp = new Campaign(Name='Test_Campaign',RecordTypeId=campRecTypeId,Type='Marketing Communication',OwnerId=user.Id,
                                                          StartDate=todayDate,Status='In Progress',EndDate=todayDate.addYears(10),Geography__c='EMEA-WE-Italy');
            insert camp;  
            
            Initiative__c init = new Initiative__c(Type__c='Marketing Implementation', SubType__c='Marketing Communication  ',Status_vs_Plan__c='Green', 
                                                   Status__c='In Progress', Start_Date__c=todayDate, RecordTypeId=initiativeRecTypeId, Priority__c='Medium', OwnerId=user.id, Name='Test_Initiative', Main_Product__c=product.id, Involved_Org__c='BI', Initiative_Group__c='BI', Geography__c='EMEA; EMEA-WE-Italy', End_Date__c=todayDate.addYears(10));
            insert init;                        
            Qualification__c qua = new Qualification__c(Account_Name__c=dealerAcc.Id,Geography__c='EMEA',RecordTypeId=quaTypeId,
                                                        Related_Contact__c=con.id,Type__c='Brand License',Stage__c='Active',Qualification_Program__c=init.id);
            insert qua;
            eWarrantyMapping__c testCustSettings = new eWarrantyMapping__c(Name='Test_Settings',Account_Currency__c='EUR',Application_2__c='Test',Owning_Organization__c='BI-Surf',Product_2__c='Corain',Subtype__c='Warranty',
                                                   Type__c='Warranty',RecordType_Account__c=accRecTypeId,RecordType_Contact__c=conRecTypeId,
                                                   Country__c='UNITED KINGDOM',Origin__c='eWarranty_UK',Campaign_Id__c=camp.id,Entitlement_Type__c='Warranty',Qualification_Program_ID__c=init.id,Info_link__c='www.google.com',termsConditions_link__c='www.yahoo.com',homePage_link__c='www.corian.com');                                    
            insert testCustSettings;
            ApexPages.currentPage().getParameters().put('webOrigin','Test_Settings');
            ctrlBIeWarrantyInput testInput = new ctrlBIeWarrantyInput();
            System.debug('$$$$$$$$'+testCustSettings );
            List<Entitlement> listent = new List<Entitlement>();
            listent = [select Entitlement_Code__c,Status from Entitlement where ServiceContractId=:servcon.Id];           
            ctrlBIeWarrantyInput.fetchColorData fetchClrData=new ctrlBIeWarrantyInput.fetchColorData();
            String fetch = testInput.getFetchedData();
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////Test cases for page 1
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            pagereference page1;
            page1 = new PageReference('apex/BI_eWarrantyInputPage');
            
            
            ApexPages.currentPage().getParameters().put('lang','eng');       
            ApexPages.currentPage().getParameters().put('warrantyCode',listent[0].Entitlement_Code__c);
            //ApexPages.currentPage().getParameters().put('lang','it'); 
           // ApexPages.currentPage().getParameters().put('lang','it'); 
           // ApexPages.currentPage().getParameters().put('lang','it'); 
                 
            //ID cupsEntityID=System.currentPageReference().getParameters().get('cupsrecordId');
           Test.StartTest();
            // Calling static methods
            ctrlBIeWarrantyInput.setwebOrigin('test');
            ctrlBIeWarrantyInput.setlangValue('test');
            
            // calling get methods
            testInput.getInfoLink();
            testInput.TermNConditionsLink();
            testInput.HomePageLink();
            
            /* private check box unchecked */
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='547657'; 
            testInput.custDetails.kitchenBrand='Boffi';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=false;
            testInput.termsCheck=true;
            testInput.brandOther();
            
                       
            
            /* terms check box unchecked */
            
            testInput.strEntitlementCode=listent[0].Entitlement_Code__c;
            testInput.strDoP=String.valueOf(Date.today());
            testInput.custDetails.firstName='Manasa';
            testInput.custDetails.lastName='Gupta';
            testInput.custDetails.postalAddr='Infosys';
            testInput.custDetails.zipCode='560100';
            testInput.custDetails.province='EC';
            testInput.custDetails.city='Bangalore';
            testInput.custDetails.country='Italy';
            testInput.custDetails.email='manasa_gupta@infosys.com';
            testInput.custDetails.telephone='547657';  
            testInput.custDetails.kitchenBrand='Other';
            testInput.dealerAccId=dealerAcc;
            testInput.custDetails.privateCheck=false;
            testInput.termsCheck=false;
            testInput.brandOther();
            testInput.addDetails();
            testInput.dealerName='Test_Account_Dealer';
            testInput.selectedDealerName='TEST';
            testInput.radioStatus='yes';
            testInput.displayPopup=true;
            testInput.colorName='Test';
            testInput.selectedColorName='Test';
            
            testInput.searchDealer();
            
            //testInput.dealerAccount=null;
            
            //testInput.dealerRecs();
            
            testInput.colorItem=mat1.id;
            testInput.colorRecs();
            
             testInput.completeDealerName='Test_AddDealer';
             testInput.dealerPostalAddr='TestDealerAddr';
             testInput.dealerZipCode='1345';
             testInput.dealerProvince='TestdealerProvince';
             testInput.dealerCity='TestDealerCity';
             testInput.dealerCountry='TestDealerCountry';
             testInput.tempMsg='testing';
             testInput.myMsg=new ApexPages.Message(ApexPages.Severity.FATAL, 'Kindly enter the mandatory fields');
             testInput.addDealer();
             
             testInput.completeDealerName=null;
             testInput.addDealer();
             testInput.colorItem=null;
             testInput.colorRecs();
             testInput.renderAddDealer();
             
            /*entitlement registered*/
             ///////////////////////////////
            testInput.entitlementCode=listent[0].Entitlement_Code__c;
            testInput.dateofPurchase=Date.today();
            testInput.verifyWarrantyCode();
            testInput.brandId=product.id;
            testInput.verifyWarrantyCode();
            ApexPages.currentPage().getParameters().put('warrantyCode','');
            testInput.searchColor();
            Test.StopTest();
        }
    }
}
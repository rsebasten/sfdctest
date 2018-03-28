@isTest
public class ctrlCOBCustomerDataRequest_UT {
public static final string Miscellaneous_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Miscellaneous_customer_data_request');
public static final string NewCustomer_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','New_Customer_Creation');
public static final string ModifyExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Modify_Existing_Customer_Data');         
 public static final string Partner_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Create_partner_function_Link_Contact_Link_Existing_Partner');
    public static final string ExtendExisting_COB_RTYPE = Rtype.getIdByDevName('Customer_Data_Request__c','Extend_Existing_Customer'); 
     public static string CompanyCodeCountry_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Country_Selling_Company_Code_Rules');
     public static string Queue_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Queue_Rules');
     public static string NOtification_Rule_Rtype = Rtype.getIdByDevName('Business_Rules__c','Notification_Rules');
     
    static testMethod void testMyControllerNew() {
        
        
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];   
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       // Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
       /* GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;

        
       
        System.runAs(U1){        
        
       
        ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        insert ERPCust;
        
        RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust.id);
        insert acc;
        
        COB_Region__c CobCustom= new COB_Region__c();
        CobCustom.Name='abc';
        CobCustom.Country__c='IN - India'; 
        CobCustom.Region__c='IN - 22 - Tamil Nadu';
        insert CobCustom;

           Customer_Data_Request__c customerData = new Customer_Data_Request__c();
        /*    Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br; 
            */
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '4860 - DUP (Thailand) Ltd';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'TH - Thailand';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Activity_Code__c='12';
customerData.Distribution_Type__c='Ab';
customerData.Tax_Code_1__c='12';
customerData.Tax_Code_2__c='34';
customerData.Tax_Number_Category__c='qwe';
customerData.Business_Type__c='Abc';
customerData.Argentina_Tax_Categories__c='acv';
customerData.Business_Strategic__c='qwe';
customerData.Geocode__c='123';
customerData.Unloading_Point__c='ewe';
customerData.Business_Category__c='qwew';
customerData.Ownership_Type__c='ewqe';
customerData.Business_Partner_ID_Grouping__c='qweq';
customerData.Jurisdiction_Code__c='qw';
customerData.Registration_Number__c='21';
customerData.Ultimate_Consign_Type_attribute__c='re';
customerData.Argentina_Withholding_Tax__c='wqe';
customerData.CFOP__c='uyt';
customerData.Preferred_Bank_Name__c='Axis';
customerData.Estimated_Average_Monthly_Purchases__c=10;
customerData.Estimated_Number_of_Orders_per_Month__c=20;
customerData.Proposed_Customer_Group__c='we';
customerData.Customer_Currency__c='Inr';             

            insert customerData;
            
                Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();
test.startTest();
Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='4860 - DUP (Thailand) Ltd';
br1.CDR_Sold_to_Country__c= 'TH - Thailand';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
Business_Rules__c br3 = new Business_Rules__c();
br3.selling_company_code__c ='0078 - ELECT. MATLS DUP DONGGUAN';
br3.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br3);
Business_Rules__c br4 = new Business_Rules__c();
br4.recordtypeid = Queue_Rule_Rtype;
br4.destination_queue__c='Customer On-boarding CSR - China Queue';
br4.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
brlist.add(br4);
insert brlist;       
                   
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
           
          
            
            
            
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);

            
        Test.setCurrentPageReference(new PageReference('Page.COBNewCustomerCreation'));
        System.currentPageReference().getParameters().put('Id', customerData.id); 
        System.currentPageReference().getParameters().put('Account', acc.Id); 
        System.currentPageReference().getParameters().put('RecordTypeId', NewCustomer_COB_RTYPE);
        System.currentPageReference().getParameters().put('ERPCustomer', ERPCust.Id);
        System.currentPageReference().getParameters().put('Clone','null');
        System.currentPageReference().getParameters().put('AccountLink','null');
        System.currentPageReference().getParameters().put('Case','null');
        ApexPages.currentPage().getParameters().put('Account','null');  
     //ApexPages.currentPage().getParameters().put('Id','null');  
     ApexPages.currentPage().getParameters().put('Case','abc'); 
     ApexPages.currentPage().getParameters().put('search','Extend');       
    Apexpages.currentPage().getParameters().put('sixthParam','abc');
    Apexpages.currentPage().getParameters().put('seventhParam','qwe');
        ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();
        controller = new ctrlCOBCustomerDataRequest(); 
        controller.sellingCompanyCode = '0003 - E.I. DuPont India Private Limited';
        controller.SBUCode            = 'A6 - Building Innovations';
        controller.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c = 'ALL - Albanian Lek';  
        controller.selectedNotificationUsers();
       // controller.getNotifyUsers();
                     
       Selling_Company_Code_Dependency__c scdobj = new Selling_Company_Code_Dependency__c();
       scdobj.name = 'Test';
       scdobj.Selling_Company_Code__c = '0003 - E.I. DuPont India Private Limited';
       scdobj.Tax_Category__c = 'Tax Category 1';
       scdobj.Sales_Org_Code__c = 'A203';
       scdobj.Group_key__c = '95GE999';
       scdobj.Sub_Business__c = 'DPT';
       scdobj.SBU__c = 'A6 - Building Innovations';
       insert scdobj;
             
             
       controller.OnboardingReq.Activity_Code__c='2';
controller.OnboardingReq.Distribution_Type__c='Asb';
controller.OnboardingReq.Tax_Code_1__c='2';
controller.OnboardingReq.Tax_Code_2__c='4';
controller.OnboardingReq.Tax_Number_Category__c='we';
controller.OnboardingReq.Business_Type__c='bc';
controller.OnboardingReq.Argentina_Tax_Categories__c='cv';
controller.OnboardingReq.Business_Strategic__c='qe';
controller.OnboardingReq.Geocode__c='13';
controller.OnboardingReq.Unloading_Point__c='ee';
controller.OnboardingReq.Business_Category__c='qww';
controller.OnboardingReq.Ownership_Type__c='ewq';
controller.OnboardingReq.Business_Partner_ID_Grouping__c='qwq';
controller.OnboardingReq.Jurisdiction_Code__c='w';
controller.OnboardingReq.Registration_Number__c='1';
controller.OnboardingReq.Ultimate_Consign_Type_attribute__c='r';
controller.OnboardingReq.Argentina_Withholding_Tax__c='we';
controller.OnboardingReq.CFOP__c='ut';
controller.OnboardingReq.Preferred_Bank_Name__c='Ais';
controller.OnboardingReq.Estimated_Average_Monthly_Purchases__c=1;
controller.OnboardingReq.Estimated_Number_of_Orders_per_Month__c=2;
controller.OnboardingReq.Proposed_Customer_Group__c='wew';
controller.OnboardingReq.Customer_Currency__c='Ir';
           
        
       
        controller.fetchSellingCompanyDependents();
        controller.fetchSBUDependents();
        controller.checkOtherGroupKey();
        controller.redirectLink();
        controller.IsLeverageCSRRender=true;
        controller.modeSet();    
        controller.populateCurrency();
        controller.notification();
        controller.gettaxValues();
        List<SelectOption> selOpts=controller.SellingCompanyOptions; 
        List<SelectOption> selUser=controller.selectedUsers;
         
                         
       // String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><getDetailResponse xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0050161945</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION/><NAME1>LEFFINGWELL AG SALES CO INC</NAME1><NAME2>Test Name2 AG SALES CO INC</NAME2><NAME3>123</NAME3><NAME4>123</NAME4><CITY1>TERRA BELLA</CITY1><CITY2>TULARE</CITY2><CITYP_CODE>123</CITYP_CODE><PO_BOX>10009</PO_BOX><TRANSPZONE>CA001</TRANSPZONE><HOUSE_NUM1>112</HOUSE_NUM1><HOUSE_NUM2>111</HOUSE_NUM2><REGION>CA</REGION><SORT1>P/LEFFINGW</SORT1><TEL_NUMBER>(999)555-2350</TEL_NUMBER><FAX_NUMBER>(999)555-2351</FAX_NUMBER><EXTENSION1>(999)555-2351</EXTENSION1><EXTENSION2>(999)555-2351</EXTENSION2><SMTP_SRCH>EXAMPLE@EMAIL.COM</SMTP_SRCH><URI_SRCH>WWW.TERRABELLA.COM</URI_SRCH><URI_ADDR>www.terrabella.com</URI_ADDR><STRAS>23576 AVE 96</STRAS></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>11</KUNNR><BUKRS>11</BUKRS><ZUAWA>11</ZUAWA><BUSAB>11</BUSAB><AKONT>11</AKONT><KNRZE>11</KNRZE><ZWELS>11</ZWELS><VZSKZ>11</VZSKZ><ZINRT>00</ZINRT><EIKTO>11</EIKTO><ZSABE>11</ZSABE><KVERM>11</KVERM><FDGRV>11</FDGRV><XAUSZ>11</XAUSZ><LOCKB>11</LOCKB><XEDIP>11</XEDIP><TLFXS>11</TLFXS><INTAD>11</INTAD><GUZTE>11</GUZTE><GRICD>11</GRICD><GRIDT>11</GRIDT><TLFNS>11</TLFNS></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055022797</KUNNR><TAXGR>111</TAXGR><ADRNR>0050161945</ADRNR><BAHNE>CDRCD159362</BAHNE><BAHNS>00000</BAHNS><BBBNR>0000000</BBBNR><BRSCH>000000</BRSCH><BUBKZ>0</BUBKZ><DATLT>00000</DATLT><FISKN>000000</FISKN><KONZS>000000</KONZS><KUKLA>000000</KUKLA><LIFNR>000000</LIFNR><LOCCO>A</LOCCO><SPRAS>E</SPRAS><STCD1>A</STCD1><STCD2>A</STCD2><STKZA>A</STKZA><STKZU>A</STKZU><STCEG>A</STCEG><VBUND/><KATR5>A</KATR5><STKZN>A</STKZN><FITYP>A</FITYP><STCDT>A</STCDT><STCD3>A</STCD3><STCD4>A</STCD4><J_1KFTBUS>A</J_1KFTBUS><MINDK>A</MINDK><TEL_NUMBER>(999)555-2350</TEL_NUMBER><TTX_NUMBER>333</TTX_NUMBER><TLX_NUMBER>444</TLX_NUMBER></PE_PERSONALDATA><PE_RETURN><TYPE/><ID/><NUMBER>000</NUMBER><MESSAGE/><LOG_NO/><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1/><MESSAGE_V2/><MESSAGE_V3/><MESSAGE_V4/></PE_RETURN><PE_SALESDATA><KUNNR/><VKORG/><VTWEG/><SPART/><BEGRU>888</BEGRU><VERSG>444</VERSG><KALKS>443</KALKS><BZIRK>333</BZIRK><KONDA>464</KONDA><AWAHR>000</AWAHR><ANTLF>0</ANTLF><AUTLF>424</AUTLF><KZTLF>242</KZTLF><KZAZU>234</KZAZU><LPRIO>00</LPRIO><VSBED>533</VSBED><MRNKZ>353</MRNKZ><PERFK>342</PERFK><PERRL>332</PERRL><KLABC>211</KLABC><KTGRD>119</KTGRD><ZTERM>865</ZTERM><VWERK>422</VWERK><VKGRP>325</VKGRP><VSORT>3563</VSORT><BOKRE>2255</BOKRE><KURST>3523</KURST><PRFRE>353</PRFRE><KABSS>242</KABSS><KKBER>4222</KKBER><RDOFF>4252</RDOFF><AGREL>35423</AGREL><MEGRU>5353</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>0.0</UEBTK><PVKSM>331</PVKSM><PODKZ>867</PODKZ><PODTG>0</PODTG><ZZSLOC>220</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>000</ZZ00CPBKMSG><ZZDUTYIND>00</ZZDUTYIND><ZZONBYDATE>000</ZZONBYDATE><SBU>00</SBU><SHIPPING_INSTR>11123</SHIPPING_INSTR><WAREHOUSE_INSTR>35436</WAREHOUSE_INSTR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR/><TAXGR>111</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR/><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKA>Third Bank of Wilmington</BANKA><STRAS>3131 Walnut St</STRAS><ORT01>Wilmington, 19104</ORT01><SWIFT/><BRNCH>City Hall Branch</BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>0055022797</KUNNR><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKN>12345</BANKN><BKONT/><KOINH/><IBAN/></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055022797</KUNNR><PARNR>0000007299</PARNR><NAME1>Thompson</NAME1><ABTNR/><TELF1>009</TELF1><PAFKT/><TITEL_AP/><PRSNR>0051886247</PRSNR><SMTP_SRCH>FREDDYT@TERRABELLA.C</SMTP_SRCH><FAX_NUMBER>(302) 884-3838</FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055022797</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP/><KRAUS/><GRUPP/><SBDAT>0000-00-00</SBDAT><CASHC/><DBPAY/><DBRTG/><DBWAE/></PE_CONTROLDETAILS><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>BE</ALAND><TATYP>ZAO1</TATYP><TAXKD/></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO3</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>FR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWAS</TATYP><TAXKD>3</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MX01</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>MWST</TATYP><TAXKD>0</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE><ERROR_CODE> </ERROR_CODE></ERROR_CODE><ERROR_DESC><ERROR_DESC> </ERROR_DESC></ERROR_DESC></Response></getDetailResponse></Body></Envelope>';
        
        String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Y_GVCUSTOMER_GETDETAIL.Response xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0000145318</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION></NATION><NAME1>VISHAY DALE ELECTRONICS INC</NAME1><NAME2>VISHAY DALE ELECTRONICS INC-2</NAME2><NAME3>VISHAY DALE ELECTRONICS INC-3</NAME3><NAME4>VISHAY DALE ELECTRONICS INC-4</NAME4><CITY1>COLUMBUS</CITY1><CITY2>POLK</CITY2><CITYP_CODE></CITYP_CODE><PO_BOX>609</PO_BOX><TRANSPZONE>0000000015</TRANSPZONE><HOUSE_NUM1>2222222</HOUSE_NUM1><HOUSE_NUM2>1111111</HOUSE_NUM2><REGION>13</REGION><SORT1>DALCOLDAL</SORT1><TEL_NUMBER>123456789</TEL_NUMBER><FAX_NUMBER>987654321</FAX_NUMBER><EXTENSION1>abcd</EXTENSION1><EXTENSION2>987654321</EXTENSION2><SMTP_SRCH>ABC@EMAIL.COM</SMTP_SRCH><URI_SRCH>HOMEPAGE@Dupont.COM</URI_SRCH><URI_ADDR>homepage@Dupont.com</URI_ADDR><STRAS>1122 23RD STREET-PLANT #2</STRAS><COUNTRY>JP</COUNTRY><PO_BOX_LOC>Other</PO_BOX_LOC><POST_CODE1>68601</POST_CODE1><LCL_LANGU>E</LCL_LANGU><LCL_NAME1>VISHAY DALE ELECTRONICS INC</LCL_NAME1><LCL_NAME2>VISHAY DALE ELECTRONICS INC-2</LCL_NAME2><LCL_NAME3>VISHAY DALE ELECTRONICS INC-3</LCL_NAME3><LCL_NAME4>VISHAY DALE ELECTRONICS INC-4</LCL_NAME4><LCL_EXTENSION1>abcd</LCL_EXTENSION1><LCL_CITY2>oot</LCL_CITY2><LCL_HOUSE_NUM1>2222</LCL_HOUSE_NUM1><LCL_POST_CODE1>68601</LCL_POST_CODE1><LCL_REGION>13</LCL_REGION><LCL_SORT1>DALCOLDAL</LCL_SORT1><LCL_STREET>sss</LCL_STREET><LCL_EXTENSION2>987654321</LCL_EXTENSION2></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><ZUAWA>009</ZUAWA><BUSAB>VR</BUSAB><AKONT>0012101000</AKONT><KNRZE>0055001120</KNRZE><ZWELS>E</ZWELS><VZSKZ>TRUE</VZSKZ><ZINRT>01</ZINRT><EIKTO>123454321</EIKTO><ZSABE>10234</ZSABE><KVERM>Testing</KVERM><FDGRV>E2</FDGRV><XAUSZ>2</XAUSZ><LOCKB>EBO</LOCKB><XEDIP>TRUE</XEDIP><TLFXS>no. 123456789</TLFXS><INTAD>abc@abc.com</INTAD><GUZTE></GUZTE><GRICD></GRICD><GRIDT></GRIDT><TLFNS>123456789</TLFNS><LOEVM>X</LOEVM><SPERR>X</SPERR></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055110426</KUNNR><ADRNR>0000145318</ADRNR><BAHNE>Express station</BAHNE><BAHNS>Train station</BAHNS><BBBNR>0012345</BBBNR><BRSCH>FINS</BRSCH><BUBKZ>0</BUBKZ><DATLT>abcd</DATLT><FISKN>0055000943</FISKN><KONZS>1235</KONZS><KUKLA>01</KUKLA><LIFNR>0000001453</LIFNR><LOCCO>123456</LOCCO><SPRAS>E</SPRAS><STCD1></STCD1><STCD2></STCD2><STKZA>TRUE</STKZA><STKZU>TRUE</STKZU><STCEG>123 456789</STCEG><VBUND>06</VBUND><KATR5>D</KATR5><STKZN>TRUE</STKZN><FITYP>22</FITYP><STCDT></STCDT><STCD3>STCD3</STCD3><STCD4>STCD4</STCD4><STCD5>STCD5</STCD5><J_1KFTBUS></J_1KFTBUS><MINDK></MINDK><TEL_NUMBER>123456789</TEL_NUMBER><TTX_NUMBER>987654321</TTX_NUMBER><TLX_NUMBER>987654321</TLX_NUMBER><KTOKD>Z001</KTOKD><LOEVM>X</LOEVM><BBSNR>01234</BBSNR><SPERR>X</SPERR><CASSD>X</CASSD></PE_PERSONALDATA><PE_RETURN><TYPE></TYPE><ID></ID><NUMBER>000</NUMBER><MESSAGE></MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1></MESSAGE_V1><MESSAGE_V2></MESSAGE_V2><MESSAGE_V3></MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></PE_RETURN><PE_SALESDATA><KUNNR>0055110426</KUNNR><VKORG>F450</VKORG><VTWEG>10</VTWEG><SPART>02</SPART><BEGRU>ZTXZ</BEGRU><VERSG>1</VERSG><KALKS>1</KALKS><BZIRK>USF3F4</BZIRK><KONDA>Z2</KONDA><AWAHR>100</AWAHR><ANTLF>0</ANTLF><AUTLF>TRUE</AUTLF><KZTLF>TRUE</KZTLF><KZAZU>TRUE</KZAZU><LPRIO>00</LPRIO><VSBED>11</VSBED><MRNKZ>TRUE</MRNKZ><PERFK>ZZ</PERFK><PERRL>ZZ</PERRL><KLABC>AB</KLABC><KTGRD>01</KTGRD><ZTERM>Y030</ZTERM><VWERK>YF12</VWERK><VKGRP>US6</VKGRP><VSORT>7500003828</VSORT><BOKRE>TRUE</BOKRE><KURST>M</KURST><PRFRE>TRUE</PRFRE><KABSS>ZZZZ</KABSS><KKBER>2350</KKBER><RDOFF>TRUE</RDOFF><AGREL>TRUE</AGREL><MEGRU>UNTE</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>TRUE</UEBTK><PVKSM>Z5</PVKSM><PODKZ>TRUE</PODKZ><PODTG>0</PODTG><ZZSLOC>1201</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>FALSE</ZZ00CPBKMSG><ZZDUTYIND>TRUE</ZZDUTYIND><ZZONBYDATE>BY</ZZONBYDATE><SBU></SBU><SHIPPING_INSTR>SHELF LIFE TO APPEAR ON ALL LABELS PER B. NISSAN</SHIPPING_INSTR><WAREHOUSE_INSTR>Warehouse Instructions</WAREHOUSE_INSTR><VTEXT>·¢Æ±ÈÕÆð30ÌìÄÚ¸¶¿î</VTEXT><BEZEI20>A Material</BEZEI20><CTEXT>Standard</CTEXT><GTEXT>Consumer</GTEXT><BEZEI></BEZEI><STEXT>Air Consolidated</STEXT><LTEXT>365 W/D - All Days/Work Days - 7 by 24</LTEXT><ITEXT>365 W/D - All Days/Work Days - 7 by 24</ITEXT><ATEXT>Domestic Revenues</ATEXT><CURVW>Standard translation at average rate</CURVW><PEZEI>No Payment Guarantee Required</PEZEI><PTEXT>Item Prop. (No Hist)</PTEXT><DDTEXT>Create a delivery with qty greater than zero</DDTEXT><ZZTEXT>Req. Del. date BY</ZZTEXT><FAKSD>08</FAKSD><KVGR1>Y</KVGR1><KVGR2>A05</KVGR2><KVGR3>SEZ</KVGR3><KVGR4>A23</KVGR4><KVGR5>A12</KVGR5><LOEVM>X</LOEVM><LIFSD>08</LIFSD><INCO1>142</INCO1><INCO2>FOB SHIPPOINT</INCO2><PLTYP>A6</PLTYP><CASSD>X</CASSD><VKBUR>F400</VKBUR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR>0055110426</KUNNR><TAXGR>IBZ</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR></EXNR><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>NON</BANKS><BANKL></BANKL><BANKA></BANKA><STRAS></STRAS><ORT01></ORT01><SWIFT></SWIFT><BRNCH></BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>NONE</KUNNR><BANKS></BANKS><BANKL></BANKL><BANKN></BANKN><BKONT></BKONT><KOINH></KOINH><IBAN></IBAN></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055110426</KUNNR><PARNR>0000016647</PARNR><NAME1>ABC</NAME1><ABTNR>0003</ABTNR><TELF1></TELF1><PAFKT>03</PAFKT><TITEL_AP></TITEL_AP><PRSNR>0001796770</PRSNR><SMTP_SRCH></SMTP_SRCH><FAX_NUMBER></FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055110426</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP>00P</SBGRP><KRAUS>987654321</KRAUS><GRUPP>B200</GRUPP><SBDAT>2015-04-21</SBDAT><CASHC></CASHC><DBPAY>125</DBPAY><DBRTG>12456</DBRTG><DBWAE>ARS</DBWAE><REVDB>2015-04-01</REVDB><DTREV>2015-04-07</DTREV><NXTRV>2015-04-21</NXTRV></PE_CONTROLDETAILS><PE_DUNNINGDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><MABER></MABER><MAHNA>0003</MAHNA><BUSAB>0K</BUSAB></PE_DUNNINGDATA><PE_LOADINGPOINTS><KUNNR>0055110426</KUNNR><ABLAD>US</ABLAD><DEFAB></DEFAB></PE_LOADINGPOINTS><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZCC1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>IE</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZCJ1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZCK1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZTW1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_CODE><ERROR_DESC xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_DESC></Response></Y_GVCUSTOMER_GETDETAIL.Response></Body></Envelope>';
        controller.parseWebserviceResponse(ResponseXMLString); 
         
        controller.currentUserProfile();
        controller.queryPublicGroup();
        controller.populateRequestorInformation();
        controller.fetchRecordTypeName();
        controller.Done();
        controller.FormRenderValidation();
        controller.populateAccountInformation(acc.id);
         
       controller.fetchAccountDetails(acc.id);
        
        controller.OnboardingReq.Customer__c = ERPCust.id;
      controller.fetchCustomerInformation(ERPCust.id);
        test.stopTest();
        controller.populateExistingCustomerInformation();
        
        controller.OnboardingReq.Bank_statement__c = '120';
        controller.fieldmodified(); 
        
        controller.OnboardingReq.Leveraged_CSR__c = true;
        //controller.OnboardingReq.Assigned_to_Leverage_CSR__c = true;
       // controller.OnboardingReq.Request_Status__c = 'Draft/Data Gathering';
        
        controller.RequestFlow();
        controller.Cancel();
        controller.CancelAndClose();
        controller.RedirectCancelAndClose();
        controller.IsSaveOrSubmit='Save';
        controller.SaveAndSubmit();
        controller.IsSaveOrSubmit='Submit';
        controller.SaveAndSubmit();
        controller.getItems();
        controller.requireCreditApproval();
        controller.checkPOD();
        controller.RelatedlistItemsValidation();
        controller.checkLocalLanguage();
        controller.fetchRegionValues();
        controller.fetchLocalRegionValues();
        controller.PrepopulateCreditLimit();
        controller.fetchCountryCode();
        controller.CopyProposedToApprovedCredit(controller.OnboardingReq);
        controller.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE;
        controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
        controller.creditValidationModify();
        
        controller.OnboardingReq.Leveraged_CSR__c = false;
        controller.OnboardingReq.Account_Group__c = 'Z001 ( Sold-to party )';
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.RequestFlow();
        
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE; 
        controller.OnboardingReq.Sold_to_Country__c='CN - China';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.Data_line__c=null;
         controller.RequiredValidations();
          
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='CN - China';
        controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Telebox__c=null;
            
        controller.RequiredValidations() ;
         
         
        }
    }
      static testMethod void testMyControllerNew1() {
        
       //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
      //  Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;

        
       
        System.runAs(U1){        
        test.startTest();
       
        ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        insert ERPCust;
        
        RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust.id);
        insert acc;

             Customer_Data_Request__c customerData = new Customer_Data_Request__c();
            Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Cash In Advance';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();
            Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='2791 - Du Pont China Holding Co.';
br1.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
Business_Rules__c br3 = new Business_Rules__c();
br3.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br3.selling_company_code__c ='0078 - ELECT. MATLS DUP DONGGUAN';
br3.CDR_Sold_to_Country__c = 'CN - China';
brlist.add(br3);
insert brlist;  
            
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '2791 - Du Pont China Holding Co.';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'CN - China';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            CustomerData.Request_Status__c ='Draft/Data Gathering';
            customerData.Preferred_Bank_Name__c='ertrty';
            customerData.IsCreditApproved__c=true;
                    
            insert customerData;
                   
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
            
           // test.stopTest();
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);

            
        Test.setCurrentPageReference(new PageReference('Page.COBNewCustomerCreation'));
        System.currentPageReference().getParameters().put('Id', customerData.id); 
        System.currentPageReference().getParameters().put('Account', acc.Id); 
        System.currentPageReference().getParameters().put('RecordTypeId', NewCustomer_COB_RTYPE);
        System.currentPageReference().getParameters().put('ERPCustomer', ERPCust.Id);
        System.currentPageReference().getParameters().put('Clone','null');
        System.currentPageReference().getParameters().put('AccountLink','null');
        System.currentPageReference().getParameters().put('Case','null');
            Apexpages.currentPage().getParameters().put('Search','Extend');
            Apexpages.currentPage().getParameters().put('firstParam','qwe');
            Apexpages.currentPage().getParameters().put('secondParam','qwe');
            Apexpages.currentPage().getParameters().put('thirdParam','qwe');
            Apexpages.currentPage().getParameters().put('fourthParam','qwe');

        ctrlCOBCustomerDataRequest controller1 = new ctrlCOBCustomerDataRequest();
        controller1.RequestFlow();
        
        controller1.OnboardingReq.Account_Group__c='Z001 ( Sold-to party )';
        controller1.RequestFlow();
        String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Y_GVCUSTOMER_GETDETAIL.Response xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0000145318</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION></NATION><NAME1>VISHAY DALE ELECTRONICS INC</NAME1><NAME2>VISHAY DALE ELECTRONICS INC-2</NAME2><NAME3>VISHAY DALE ELECTRONICS INC-3</NAME3><NAME4>VISHAY DALE ELECTRONICS INC-4</NAME4><CITY1>COLUMBUS</CITY1><CITY2>POLK</CITY2><CITYP_CODE></CITYP_CODE><PO_BOX>609</PO_BOX><TRANSPZONE>0000000015</TRANSPZONE><HOUSE_NUM1>2222222</HOUSE_NUM1><HOUSE_NUM2>1111111</HOUSE_NUM2><REGION>13</REGION><SORT1>DALCOLDAL</SORT1><TEL_NUMBER>123456789</TEL_NUMBER><FAX_NUMBER>987654321</FAX_NUMBER><EXTENSION1>abcd</EXTENSION1><EXTENSION2>987654321</EXTENSION2><SMTP_SRCH>ABC@EMAIL.COM</SMTP_SRCH><URI_SRCH>HOMEPAGE@Dupont.COM</URI_SRCH><URI_ADDR>homepage@Dupont.com</URI_ADDR><STRAS>1122 23RD STREET-PLANT #2</STRAS><COUNTRY>JP</COUNTRY><PO_BOX_LOC>Other</PO_BOX_LOC><POST_CODE1>68601</POST_CODE1><LCL_LANGU>E</LCL_LANGU><LCL_NAME1>VISHAY DALE ELECTRONICS INC</LCL_NAME1><LCL_NAME2>VISHAY DALE ELECTRONICS INC-2</LCL_NAME2><LCL_NAME3>VISHAY DALE ELECTRONICS INC-3</LCL_NAME3><LCL_NAME4>VISHAY DALE ELECTRONICS INC-4</LCL_NAME4><LCL_EXTENSION1>abcd</LCL_EXTENSION1><LCL_CITY2>oot</LCL_CITY2><LCL_HOUSE_NUM1>2222</LCL_HOUSE_NUM1><LCL_POST_CODE1>68601</LCL_POST_CODE1><LCL_REGION>13</LCL_REGION><LCL_SORT1>DALCOLDAL</LCL_SORT1><LCL_STREET>sss</LCL_STREET><LCL_EXTENSION2>987654321</LCL_EXTENSION2></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><ZUAWA>009</ZUAWA><BUSAB>VR</BUSAB><AKONT>0012101000</AKONT><KNRZE>0055001120</KNRZE><ZWELS>E</ZWELS><VZSKZ>TRUE</VZSKZ><ZINRT>01</ZINRT><EIKTO>123454321</EIKTO><ZSABE>10234</ZSABE><KVERM>Testing</KVERM><FDGRV>E2</FDGRV><XAUSZ>2</XAUSZ><LOCKB>EBO</LOCKB><XEDIP>TRUE</XEDIP><TLFXS>no. 123456789</TLFXS><INTAD>abc@abc.com</INTAD><GUZTE></GUZTE><GRICD></GRICD><GRIDT></GRIDT><TLFNS>123456789</TLFNS><LOEVM>X</LOEVM><SPERR>X</SPERR></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055110426</KUNNR><ADRNR>0000145318</ADRNR><BAHNE>Express station</BAHNE><BAHNS>Train station</BAHNS><BBBNR>0012345</BBBNR><BRSCH>FINS</BRSCH><BUBKZ>0</BUBKZ><DATLT>abcd</DATLT><FISKN>0055000943</FISKN><KONZS>1235</KONZS><KUKLA>01</KUKLA><LIFNR>0000001453</LIFNR><LOCCO>123456</LOCCO><SPRAS>E</SPRAS><STCD1></STCD1><STCD2></STCD2><STKZA>TRUE</STKZA><STKZU>TRUE</STKZU><STCEG>123 456789</STCEG><VBUND>06</VBUND><KATR5>D</KATR5><STKZN>TRUE</STKZN><FITYP>22</FITYP><STCDT></STCDT><STCD3>STCD3</STCD3><STCD4>STCD4</STCD4><STCD5>STCD5</STCD5><J_1KFTBUS></J_1KFTBUS><MINDK></MINDK><TEL_NUMBER>123456789</TEL_NUMBER><TTX_NUMBER>987654321</TTX_NUMBER><TLX_NUMBER>987654321</TLX_NUMBER><KTOKD>Z002</KTOKD><LOEVM>X</LOEVM><BBSNR>01234</BBSNR><SPERR>X</SPERR><CASSD>X</CASSD></PE_PERSONALDATA><PE_RETURN><TYPE></TYPE><ID></ID><NUMBER>000</NUMBER><MESSAGE></MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1></MESSAGE_V1><MESSAGE_V2></MESSAGE_V2><MESSAGE_V3></MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></PE_RETURN><PE_SALESDATA><KUNNR>0055110426</KUNNR><VKORG>F450</VKORG><VTWEG>10</VTWEG><SPART>02</SPART><BEGRU>ZTXZ</BEGRU><VERSG>1</VERSG><KALKS>1</KALKS><BZIRK>USF3F4</BZIRK><KONDA>Z2</KONDA><AWAHR>100</AWAHR><ANTLF>0</ANTLF><AUTLF>TRUE</AUTLF><KZTLF>TRUE</KZTLF><KZAZU>TRUE</KZAZU><LPRIO>00</LPRIO><VSBED>11</VSBED><MRNKZ>TRUE</MRNKZ><PERFK>ZZ</PERFK><PERRL>ZZ</PERRL><KLABC>AB</KLABC><KTGRD>01</KTGRD><ZTERM>Y030</ZTERM><VWERK>YF12</VWERK><VKGRP>US6</VKGRP><VSORT>7500003828</VSORT><BOKRE>TRUE</BOKRE><KURST>M</KURST><PRFRE>TRUE</PRFRE><KABSS>ZZZZ</KABSS><KKBER>2350</KKBER><RDOFF>TRUE</RDOFF><AGREL>TRUE</AGREL><MEGRU>UNTE</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>TRUE</UEBTK><PVKSM>Z5</PVKSM><PODKZ>TRUE</PODKZ><PODTG>0</PODTG><ZZSLOC>1201</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>FALSE</ZZ00CPBKMSG><ZZDUTYIND>TRUE</ZZDUTYIND><ZZONBYDATE>BY</ZZONBYDATE><SBU></SBU><SHIPPING_INSTR>SHELF LIFE TO APPEAR ON ALL LABELS PER B. NISSAN</SHIPPING_INSTR><WAREHOUSE_INSTR>Warehouse Instructions</WAREHOUSE_INSTR><VTEXT>·¢Æ±ÈÕÆð30ÌìÄÚ¸¶¿î</VTEXT><BEZEI20>A Material</BEZEI20><CTEXT>Standard</CTEXT><GTEXT>Consumer</GTEXT><BEZEI></BEZEI><STEXT>Air Consolidated</STEXT><LTEXT>365 W/D - All Days/Work Days - 7 by 24</LTEXT><ITEXT>365 W/D - All Days/Work Days - 7 by 24</ITEXT><ATEXT>Domestic Revenues</ATEXT><CURVW>Standard translation at average rate</CURVW><PEZEI>No Payment Guarantee Required</PEZEI><PTEXT>Item Prop. (No Hist)</PTEXT><DDTEXT>Create a delivery with qty greater than zero</DDTEXT><ZZTEXT>Req. Del. date BY</ZZTEXT><FAKSD>08</FAKSD><KVGR1>Y</KVGR1><KVGR2>A05</KVGR2><KVGR3>SEZ</KVGR3><KVGR4>A23</KVGR4><KVGR5>A12</KVGR5><LOEVM>X</LOEVM><LIFSD>08</LIFSD><INCO1>142</INCO1><INCO2>FOB SHIPPOINT</INCO2><PLTYP>A6</PLTYP><CASSD>X</CASSD><VKBUR>F400</VKBUR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR>0055110426</KUNNR><TAXGR>IBZ</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR></EXNR><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>NON</BANKS><BANKL></BANKL><BANKA></BANKA><STRAS></STRAS><ORT01></ORT01><SWIFT></SWIFT><BRNCH></BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>NONE</KUNNR><BANKS></BANKS><BANKL></BANKL><BANKN></BANKN><BKONT></BKONT><KOINH></KOINH><IBAN></IBAN></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055110426</KUNNR><PARNR>0000016647</PARNR><NAME1>ABC</NAME1><ABTNR>0003</ABTNR><TELF1></TELF1><PAFKT>03</PAFKT><TITEL_AP></TITEL_AP><PRSNR>0001796770</PRSNR><SMTP_SRCH></SMTP_SRCH><FAX_NUMBER></FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055110426</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP>00P</SBGRP><KRAUS>987654321</KRAUS><GRUPP>B200</GRUPP><SBDAT>2015-04-21</SBDAT><CASHC></CASHC><DBPAY>125</DBPAY><DBRTG>12456</DBRTG><DBWAE>ARS</DBWAE><REVDB>2015-04-01</REVDB><DTREV>2015-04-07</DTREV><NXTRV>2015-04-21</NXTRV></PE_CONTROLDETAILS><PE_DUNNINGDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><MABER></MABER><MAHNA>0003</MAHNA><BUSAB>0K</BUSAB></PE_DUNNINGDATA><PE_LOADINGPOINTS><KUNNR>0055110426</KUNNR><ABLAD>US</ABLAD><DEFAB></DEFAB></PE_LOADINGPOINTS><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZCC1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>IE</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZCJ1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZCK1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZTW1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_CODE><ERROR_DESC xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_DESC></Response></Y_GVCUSTOMER_GETDETAIL.Response></Body></Envelope>';
        
     ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();
        controller.gettaxValues();
        controller.parseWebserviceResponse(ResponseXMLString); 
        controller.sellingCompanyCode= '0078 - ELECT. MATLS DUP DONGGUAN';
        controller.populateCurrency();
        controller.creditValidationModify(); 
        controller.getPicklistValues('Customer_Data_Request__c','Division__c') ;   
        controller.RequestFlow();
        controller.gettaxValues();
        controller.sellingCompanyCode= '0029 - DU PONT CHINA LIMITED';
        controller.modeSet();    
        controller.RequestFlow();    
        controller.gettaxValues();
        controller.MiscIntent='Block';
        controller.requireCreditApproval();
        controller.MiscIntent='Others';
        controller.requireCreditApproval();
        controller.notification();
        controller.CopyProposedToApprovedCredit(customerData);
        controller.getItems();
        controller.fetchAccountDetails(acc.id);
        controller.fetchRecordTypeName();
        
        controller.Done();
        controller.Cancel();
        controller.CancelAndClose();
        controller.RedirectCancelAndClose();    
        controller.RequiredValidations();
        controller.fetchRegionValues();
        controller.fieldmodified();
        controller.currentUserProfile();
        controller.populateAccountInformation(acc.id);
        controller.fetchCustomerInformation(ERPCust.id);    
        controller.getItems();
        
     ApexPages.currentPage().getParameters().put('Id','null');   
     controller.NotifyUsersAvailable();
     controller.FormRenderValidation();
     controller.RequiredValidations(); 
        
       test.StopTest();
        
 
        
       }
       }
       
       
       
      
    static testMethod void testMyControllerNew2() {
        
        Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        
        
        //commented for dps
        //Profile p2 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p2 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U2= new User(Firstname='System1',Alias='SUser2', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p2.id,
        Username='Nish@dupont.com.test4', LastName='nish',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U2;
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
      /*  GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;
        
        
       System.runAs(U2){        
           
        test.startTest();
       
        ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        ERPCustGen.Sales_Org_Code__c='F803';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        insert ERPCust;
        
        RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust.id);
        insert acc;

             Customer_Data_Request__c customerData = new Customer_Data_Request__c();
             Id busId = [Select Id, Name from RecordType where DeveloperName = 'Notification_Rules' limit 1].Id;
          Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
           // br.CDR_Credit_Limit_Upper__c = 50000;
           // br.CDR_Credit_Limit_Lower__c = 0;
            br.Selling_Company_Code__c='0003 - E.I. DuPont India Private Limited';
            br.Sub_Business__c='DPP';
            br.RecordTypeId=busId ;
           // br.Recepient_Name__c='nish';
          //  br.Notification_Recepient_Name__c='nish';
            insert br; 
            
            
            
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            customerData.RecordTypeId = ModifyExisting_COB_RTYPE ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0003 - E.I. DuPont India Private Limited';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z001 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'IN - India';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Extended_Account_Group__c= 'abc';
            customerData.Customer__c=ERPCustGen.Id;
            customerData.Account__c=acc.Id;
           
            insert customerData;
            
            CDR_Notification__c notify=new CDR_Notification__c();
            notify.Customer_Data_Request__c=customerData.id;
            notify.User__c=U2.Id;
            insert notify; 
            
                   
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);
String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Y_GVCUSTOMER_GETDETAIL.Response xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0000145318</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION></NATION><NAME1>VISHAY DALE ELECTRONICS INC</NAME1><NAME2>VISHAY DALE ELECTRONICS INC-2</NAME2><NAME3>VISHAY DALE ELECTRONICS INC-3</NAME3><NAME4>VISHAY DALE ELECTRONICS INC-4</NAME4><CITY1>COLUMBUS</CITY1><CITY2>POLK</CITY2><CITYP_CODE></CITYP_CODE><PO_BOX>609</PO_BOX><TRANSPZONE>0000000015</TRANSPZONE><HOUSE_NUM1>2222222</HOUSE_NUM1><HOUSE_NUM2>1111111</HOUSE_NUM2><REGION>13</REGION><SORT1>DALCOLDAL</SORT1><TEL_NUMBER>123456789</TEL_NUMBER><FAX_NUMBER>987654321</FAX_NUMBER><EXTENSION1>abcd</EXTENSION1><EXTENSION2>987654321</EXTENSION2><SMTP_SRCH>ABC@EMAIL.COM</SMTP_SRCH><URI_SRCH>HOMEPAGE@Dupont.COM</URI_SRCH><URI_ADDR>homepage@Dupont.com</URI_ADDR><STRAS>1122 23RD STREET-PLANT #2</STRAS><COUNTRY>JP</COUNTRY><PO_BOX_LOC>Other</PO_BOX_LOC><POST_CODE1>68601</POST_CODE1><LCL_LANGU>E</LCL_LANGU><LCL_NAME1>VISHAY DALE ELECTRONICS INC</LCL_NAME1><LCL_NAME2>VISHAY DALE ELECTRONICS INC-2</LCL_NAME2><LCL_NAME3>VISHAY DALE ELECTRONICS INC-3</LCL_NAME3><LCL_NAME4>VISHAY DALE ELECTRONICS INC-4</LCL_NAME4><LCL_EXTENSION1>abcd</LCL_EXTENSION1><LCL_CITY2>oot</LCL_CITY2><LCL_HOUSE_NUM1>2222</LCL_HOUSE_NUM1><LCL_POST_CODE1>68601</LCL_POST_CODE1><LCL_REGION>13</LCL_REGION><LCL_SORT1>DALCOLDAL</LCL_SORT1><LCL_STREET>sss</LCL_STREET><LCL_EXTENSION2>987654321</LCL_EXTENSION2></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><ZUAWA>009</ZUAWA><BUSAB>VR</BUSAB><AKONT>0012101000</AKONT><KNRZE>0055001120</KNRZE><ZWELS>E</ZWELS><VZSKZ>TRUE</VZSKZ><ZINRT>01</ZINRT><EIKTO>123454321</EIKTO><ZSABE>10234</ZSABE><KVERM>Testing</KVERM><FDGRV>E2</FDGRV><XAUSZ>2</XAUSZ><LOCKB>EBO</LOCKB><XEDIP>TRUE</XEDIP><TLFXS>no. 123456789</TLFXS><INTAD>abc@abc.com</INTAD><GUZTE></GUZTE><GRICD></GRICD><GRIDT></GRIDT><TLFNS>123456789</TLFNS><LOEVM>X</LOEVM><SPERR>X</SPERR></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055110426</KUNNR><ADRNR>0000145318</ADRNR><BAHNE>Express station</BAHNE><BAHNS>Train station</BAHNS><BBBNR>0012345</BBBNR><BRSCH>FINS</BRSCH><BUBKZ>0</BUBKZ><DATLT>abcd</DATLT><FISKN>0055000943</FISKN><KONZS>1235</KONZS><KUKLA>01</KUKLA><LIFNR>0000001453</LIFNR><LOCCO>123456</LOCCO><SPRAS>E</SPRAS><STCD1></STCD1><STCD2></STCD2><STKZA>TRUE</STKZA><STKZU>TRUE</STKZU><STCEG>123 456789</STCEG><VBUND>06</VBUND><KATR5>D</KATR5><STKZN>TRUE</STKZN><FITYP>22</FITYP><STCDT></STCDT><STCD3>STCD3</STCD3><STCD4>STCD4</STCD4><STCD5>STCD5</STCD5><J_1KFTBUS></J_1KFTBUS><MINDK></MINDK><TEL_NUMBER>123456789</TEL_NUMBER><TTX_NUMBER>987654321</TTX_NUMBER><TLX_NUMBER>987654321</TLX_NUMBER><KTOKD>Z001</KTOKD><LOEVM>X</LOEVM><BBSNR>01234</BBSNR><SPERR>X</SPERR><CASSD>X</CASSD></PE_PERSONALDATA><PE_RETURN><TYPE></TYPE><ID></ID><NUMBER>000</NUMBER><MESSAGE></MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1></MESSAGE_V1><MESSAGE_V2></MESSAGE_V2><MESSAGE_V3></MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></PE_RETURN><PE_SALESDATA><KUNNR>0055110426</KUNNR><VKORG>F450</VKORG><VTWEG>10</VTWEG><SPART>02</SPART><BEGRU>ZTXZ</BEGRU><VERSG>1</VERSG><KALKS>1</KALKS><BZIRK>USF3F4</BZIRK><KONDA>Z2</KONDA><AWAHR>100</AWAHR><ANTLF>0</ANTLF><AUTLF>TRUE</AUTLF><KZTLF>TRUE</KZTLF><KZAZU>TRUE</KZAZU><LPRIO>00</LPRIO><VSBED>11</VSBED><MRNKZ>TRUE</MRNKZ><PERFK>ZZ</PERFK><PERRL>ZZ</PERRL><KLABC>AB</KLABC><KTGRD>01</KTGRD><ZTERM>Y030</ZTERM><VWERK>YF12</VWERK><VKGRP>US6</VKGRP><VSORT>7500003828</VSORT><BOKRE>TRUE</BOKRE><KURST>M</KURST><PRFRE>TRUE</PRFRE><KABSS>ZZZZ</KABSS><KKBER>2350</KKBER><RDOFF>TRUE</RDOFF><AGREL>TRUE</AGREL><MEGRU>UNTE</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>TRUE</UEBTK><PVKSM>Z5</PVKSM><PODKZ>TRUE</PODKZ><PODTG>0</PODTG><ZZSLOC>1201</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>FALSE</ZZ00CPBKMSG><ZZDUTYIND>TRUE</ZZDUTYIND><ZZONBYDATE>BY</ZZONBYDATE><SBU></SBU><SHIPPING_INSTR>SHELF LIFE TO APPEAR ON ALL LABELS PER B. NISSAN</SHIPPING_INSTR><WAREHOUSE_INSTR>Warehouse Instructions</WAREHOUSE_INSTR><VTEXT>·¢Æ±ÈÕÆð30ÌìÄÚ¸¶¿î</VTEXT><BEZEI20>A Material</BEZEI20><CTEXT>Standard</CTEXT><GTEXT>Consumer</GTEXT><BEZEI></BEZEI><STEXT>Air Consolidated</STEXT><LTEXT>365 W/D - All Days/Work Days - 7 by 24</LTEXT><ITEXT>365 W/D - All Days/Work Days - 7 by 24</ITEXT><ATEXT>Domestic Revenues</ATEXT><CURVW>Standard translation at average rate</CURVW><PEZEI>No Payment Guarantee Required</PEZEI><PTEXT>Item Prop. (No Hist)</PTEXT><DDTEXT>Create a delivery with qty greater than zero</DDTEXT><ZZTEXT>Req. Del. date BY</ZZTEXT><FAKSD>08</FAKSD><KVGR1>Y</KVGR1><KVGR2>A05</KVGR2><KVGR3>SEZ</KVGR3><KVGR4>A23</KVGR4><KVGR5>A12</KVGR5><LOEVM>X</LOEVM><LIFSD>08</LIFSD><INCO1>142</INCO1><INCO2>FOB SHIPPOINT</INCO2><PLTYP>A6</PLTYP><CASSD>X</CASSD><VKBUR>F400</VKBUR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR>0055110426</KUNNR><TAXGR>IBZ</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR></EXNR><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>NON</BANKS><BANKL></BANKL><BANKA></BANKA><STRAS></STRAS><ORT01></ORT01><SWIFT></SWIFT><BRNCH></BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>NONE</KUNNR><BANKS></BANKS><BANKL></BANKL><BANKN></BANKN><BKONT></BKONT><KOINH></KOINH><IBAN></IBAN></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055110426</KUNNR><PARNR>0000016647</PARNR><NAME1>ABC</NAME1><ABTNR>0003</ABTNR><TELF1></TELF1><PAFKT>03</PAFKT><TITEL_AP></TITEL_AP><PRSNR>0001796770</PRSNR><SMTP_SRCH></SMTP_SRCH><FAX_NUMBER></FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055110426</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP>00P</SBGRP><KRAUS>987654321</KRAUS><GRUPP>B200</GRUPP><SBDAT>2015-04-21</SBDAT><CASHC></CASHC><DBPAY>125</DBPAY><DBRTG>12456</DBRTG><DBWAE>ARS</DBWAE><REVDB>2015-04-01</REVDB><DTREV>2015-04-07</DTREV><NXTRV>2015-04-21</NXTRV></PE_CONTROLDETAILS><PE_DUNNINGDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><MABER></MABER><MAHNA>0003</MAHNA><BUSAB>0K</BUSAB></PE_DUNNINGDATA><PE_LOADINGPOINTS><KUNNR>0055110426</KUNNR><ABLAD>US</ABLAD><DEFAB></DEFAB></PE_LOADINGPOINTS><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZCC1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>IE</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZCJ1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZCK1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZTW1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_CODE><ERROR_DESC xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_DESC></Response></Y_GVCUSTOMER_GETDETAIL.Response></Body></Envelope>';

        
            
        Test.setCurrentPageReference(new PageReference('Page.COBNewCustomerCreation'));
        System.currentPageReference().getParameters().put('Id', customerData.id); 
        System.currentPageReference().getParameters().put('Account', acc.Id); 
        System.currentPageReference().getParameters().put('RecordTypeId', NewCustomer_COB_RTYPE);
        System.currentPageReference().getParameters().put('ERPCustomer', ERPCust.Id);
        System.currentPageReference().getParameters().put('Clone','null');
        System.currentPageReference().getParameters().put('AccountLink','null');
        System.currentPageReference().getParameters().put('Case','null');
        ApexPages.currentPage().getParameters().put('Search','Extend');

        ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();
        controller.gettaxValues();
        controller.sellingCompanyCode= '0078 - ELECT. MATLS DUP DONGGUAN';
        controller.parseWebserviceResponse(ResponseXMLString); 
        controller.gettaxValues();
        controller.sellingCompanyCode= '0029 - DU PONT CHINA LIMITED';
        controller.gettaxValues();
        controller.MiscIntent='Block';
        controller.requireCreditApproval();
        controller.MiscIntent='Others';
        controller.requireCreditApproval();
        controller.notification();
        controller.CopyProposedToApprovedCredit(customerData);
        controller.getItems();
        controller.fetchAccountDetails(acc.id);
        controller.fetchRecordTypeName();
        test.StopTest();
        controller.Done();
        controller.Cancel();
        controller.RequiredValidations();
        controller.fetchRegionValues();
        controller.fieldmodified();
        controller.currentUserProfile();
        controller.populateAccountInformation(acc.id);
        controller.getItems();
        
     ApexPages.currentPage().getParameters().put('Id','null');   
     controller.NotifyUsersAvailable();
     controller.FormRenderValidation();
  
     
     
     }
    }
    
    
    static testMethod void testMyControllerNew3() 
    
    {
    
      test.startTest();
        Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1; 
        
        //commented for dps
        //Profile p2 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p2 =[SELECT Id FROM Profile where name='Customer Service' limit 1]; 
        User U2= new User(Firstname='System1',Alias='SUser2', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p2.id,
        Username='Nishr4@dupont.com.test4', LastName='Nish',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U2;
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
     /*   GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);*/
        
        insert GMlist;
  
     System.runAs(U1){ 
    
    
    
      Customer_Data_Request__c customerData = new Customer_Data_Request__c();
                   Id busId = [Select Id, Name from RecordType where DeveloperName = 'Notification_Rules' limit 1].Id;
          Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
           // br.CDR_Credit_Limit_Upper__c = 50000;
           // br.CDR_Credit_Limit_Lower__c = 0;
            br.Selling_Company_Code__c='2380 - Dup Austl Pty Ltd';
            br.Sub_Business__c='DPP';
            br.RecordTypeId=busId ;
            br.CDR_Sold_to_Country__c= 'AU - Australia';
           // br.Recepient_Name__c='nish';
          //  br.Notification_Recepient_Name__c='nish';
            insert br; 
 
            customerData.RecordTypeId = NewCustomer_COB_RTYPE;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '2380 - Dup Austl Pty Ltd';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'AU - Australia';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            insert customerData;
            
              CDR_Notification__c notify=new CDR_Notification__c();
            notify.Customer_Data_Request__c=customerData.id;
            notify.User__c=U1.Id;
            insert notify;
    
     ApexPages.currentPage().getParameters().put('Account','null');  
     ApexPages.currentPage().getParameters().put('Id',customerData.id);  
     ApexPages.currentPage().getParameters().put('Case','abc');  
      
    
   ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();  
    ApexPages.currentPage().getParameters().put('RecordTypeId',NewCustomer_COB_RTYPE); 
    ApexPages.currentPage().getParameters().put('Clone','null'); 
     ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        ERPCustGen.Sales_Org_Code__c='F803';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        ERPCust.Customer_Name_2__c='name';
        ERPCust.PO_Box__c='12133';
        ERPCust.Street__c='ew';
        ERPCust.City__c='ew';
        ERPCust.ZIP_Postal_Code__c='312';
        ERPCust.State_Province__c='Kerala';
        ERPCust.Country_Code__c='3123';
        ERPCust.Incoterms_1_Code__c='eqwe';
        ERPCust.Incoterms_2__c='qeqw';
        ERPCust.DUNS_Number__c='12312';
        ERPCust.Terms_of_Payment__c='qweqe';
        ERPCust.Sales_Org_Code__c='3123';
        ERPCust.Sales_Org__c='0003';
        insert ERPCust;
        
        
        
    RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
    Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound');
    insert acc;
    ApexPages.currentPage().getParameters().put('Account',acc.Id);  
    ctrlCOBCustomerDataRequest controller1 = new ctrlCOBCustomerDataRequest();  
     controller1.selectedNotifyUsers.add(new selectOption(U2.Id,'test'));
    controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
    controller1.ReqId=null;
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
    controller1.SaveAndSubmit();
   
    
    controller1.IsSaveOrSubmit='Submit';
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =false;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
     controller1.SaveAndSubmit();
     
     controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
  
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =false;
    controller1.ReqId=customerData.Id ;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
    controller1.SaveAndSubmit();
     controller1.IsSaveOrSubmit='Submit';
    controller1.SaveAndSubmit();
    ApexPages.currentPage().getParameters().put('Account',acc.Id); 
    Apexpages.currentPage().getParameters().put('firstParam','abd');
    Apexpages.currentPage().getParameters().put('secondParam','abc');
    Apexpages.currentPage().getParameters().put('thirdParam','qwe');
    Apexpages.currentPage().getParameters().put('fourthParam','ewq');
    controller1.OnboardingReq.Local_Version__c='EN';
    controller1.checkLocalLanguage();
    //controller1.getCreditDataFields();
    test.StopTest();
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='tes';
    controller1.OnboardingReq.Sold_to_Country__c='AU - Australia';
    controller1.sellingCompanyCode = '2380 - Dup Austl Pty Ltd';
    controller1.OnboardingReq.Leveraged_CSR__c=false;
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='Open Credit' ;
    controller1.OnboardingReq.Proposed_Credit_Limit_Est__c='999999999';
    controller1.OnboardingReq.Account_Group__c='Z001 ( Sold-to party )';
    controller1.requestorAccount.ERP_Customer__c=ERPCust.Id;
    controller1.RequestFlow();
    controller1.OnboardingReq.Customer__c=ERPCust.Id;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE ;
    controller1.populateExistingCustomerInformation();
    controller1.RequestFlow();
    controller1.OnboardingReq.RecordTypeId=Miscellaneous_COB_RTYPE;
    controller1.RequestFlow();
    controller1.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE ;
    controller1.OnboardingReq.Proposed_Terms_of_Payment__c =null;
    controller1.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c=null;
    controller1.OnboardingReq.Proposed_Credit_Limit__c=null;
    controller1.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
    controller1.OnboardingReq.Estimated_Number_of_Orders_per_Month__c =null;
  
    controller1.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
    controller1.creditValidationModify();
      controller1.OnboardingReq.recordTypeId = ExtendExisting_COB_RTYPE;
        controller1.creditValidationModify();
    } 
    }
    
     static testMethod void testMyControllerNew3a() 
    
    {
    
      test.startTest();
        Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1; 
        
        //commented for dps
        //Profile p2 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p2 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U2= new User(Firstname='System1',Alias='SUser2', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p2.id,
        Username='Nishr4@dupont.com.test4', LastName='Nish',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U2;
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
     /*   GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);*/
        
        insert GMlist;
  
     System.runAs(U1){ 
    
    
    
      Customer_Data_Request__c customerData = new Customer_Data_Request__c();
                   Id busId = [Select Id, Name from RecordType where DeveloperName = 'Notification_Rules' limit 1].Id;
          Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
           // br.CDR_Credit_Limit_Upper__c = 50000;
           // br.CDR_Credit_Limit_Lower__c = 0;
            br.Selling_Company_Code__c='0003 - E.I. DuPont India Private Limited';
            br.Sub_Business__c='DPP';
            br.RecordTypeId=busId ;
            br.CDR_Sold_to_Country__c= 'IN - India';
           // br.Recepient_Name__c='nish';
          //  br.Notification_Recepient_Name__c='nish';
            insert br; 
 
            customerData.RecordTypeId = Partner_COB_RTYPE ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0003 - E.I. DuPont India Private Limited';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'IN - India';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            insert customerData;
            
              CDR_Notification__c notify=new CDR_Notification__c();
            notify.Customer_Data_Request__c=customerData.id;
            notify.User__c=U1.Id;
            insert notify;
    
     ApexPages.currentPage().getParameters().put('Account','null');  
     ApexPages.currentPage().getParameters().put('Id','null');  
     ApexPages.currentPage().getParameters().put('Case','abc');  
      
    
   ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();  
    ApexPages.currentPage().getParameters().put('RecordTypeId',Partner_COB_RTYPE ); 
    ApexPages.currentPage().getParameters().put('Clone','null'); 
     ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        ERPCustGen.Sales_Org_Code__c='F803';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        ERPCust.Customer_Name_2__c='name';
        ERPCust.PO_Box__c='12133';
        ERPCust.Street__c='ew';
        ERPCust.City__c='ew';
        ERPCust.ZIP_Postal_Code__c='312';
        ERPCust.State_Province__c='Kerala';
        ERPCust.Country_Code__c='3123';
        ERPCust.Incoterms_1_Code__c='eqwe';
        ERPCust.Incoterms_2__c='qeqw';
        ERPCust.DUNS_Number__c='12312';
        ERPCust.Terms_of_Payment__c='qweqe';
        ERPCust.Sales_Org_Code__c='3123';
        ERPCust.Sales_Org__c='0003';
        insert ERPCust;
        
        
        
    RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
    Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound');
    insert acc;
    ApexPages.currentPage().getParameters().put('Account',acc.Id);  
    ctrlCOBCustomerDataRequest controller1 = new ctrlCOBCustomerDataRequest();  
     controller1.selectedNotifyUsers.add(new selectOption(U2.Id,'test'));
    controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
    controller1.ReqId=null;
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
    controller1.SaveAndSubmit();
   
    
    controller1.IsSaveOrSubmit='Submit';
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =false;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
     controller1.SaveAndSubmit();
     
     controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
    controller1.radioSelected = 'true';     
      
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =false;
    controller1.ReqId=customerData.Id ;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
    controller1.SaveAndSubmit();
     controller1.IsSaveOrSubmit='Submit';
    controller1.SaveAndSubmit();
    ApexPages.currentPage().getParameters().put('Account',acc.Id); 
    Apexpages.currentPage().getParameters().put('firstParam','abd');
    Apexpages.currentPage().getParameters().put('secondParam','abc');
    Apexpages.currentPage().getParameters().put('thirdParam','qwe');
    Apexpages.currentPage().getParameters().put('fourthParam','ewq');
    controller1.OnboardingReq.Local_Version__c='';
    controller1.checkLocalLanguage();
    //controller1.getCreditDataFields();
    test.StopTest();
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='tes';
    controller1.OnboardingReq.Sold_to_Country__c='IN - India';
    controller1.sellingCompanyCode = '0003 - E.I. DuPont India Private Limited';
    controller1.OnboardingReq.Leveraged_CSR__c=false;
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='Open Credit' ;
    controller1.OnboardingReq.Proposed_Credit_Limit_Est__c='999999999';
    controller1.OnboardingReq.Account_Group__c='Z001 ( Sold-to party )';
    controller1.requestorAccount.ERP_Customer__c=ERPCust.Id;
    controller1.RequestFlow();
    controller1.OnboardingReq.Customer__c=ERPCust.Id;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE ;
    controller1.populateExistingCustomerInformation();
    controller1.RequestFlow();
    controller1.OnboardingReq.RecordTypeId=Miscellaneous_COB_RTYPE;
    controller1.RequestFlow();
    controller1.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE ;
    controller1.OnboardingReq.Proposed_Terms_of_Payment__c =null;
    controller1.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c=null;
    controller1.OnboardingReq.Proposed_Credit_Limit__c=null;
    controller1.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
    controller1.OnboardingReq.Estimated_Number_of_Orders_per_Month__c =null;
  
    controller1.OnboardingReq.Fields_Modified_2__c='Proposed Terms of Payment';
    controller1.OnboardingReq.Proposed_Terms_of_Payment__c='test';
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='';
    controller1.creditValidationModify();
      controller1.OnboardingReq.recordTypeId = ExtendExisting_COB_RTYPE;
        controller1.creditValidationModify();
        List<SelectOption> selOpts=controller1.SellingCompanyOptions;
    } 
    }
    
    static testMethod void testMyControllerNew3b() 
    
    {
    
           Profile p1 =[SELECT Id FROM Profile where name='System Administrator' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1; 
        
        //commented for dps
        //Profile p2 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p2 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U2= new User(Firstname='System1',Alias='SUser2', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p2.id,
        Username='Nishr4@dupont.com.test4', LastName='Nish',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U2;
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
        //Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
     /*   GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4);*/
        
        insert GMlist;
  
     System.runAs(U1){ 
    
    
    
      Customer_Data_Request__c customerData = new Customer_Data_Request__c();
                   Id busId = [Select Id, Name from RecordType where DeveloperName = 'Notification_Rules' limit 1].Id;
      /*    Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
           // br.CDR_Credit_Limit_Upper__c = 50000;
           // br.CDR_Credit_Limit_Lower__c = 0;
            br.Selling_Company_Code__c='3874 - Du Pont Co. (Singapore) Pte';
            br.CDR_Sold_to_Country__c= 'SG - Singapore';
            br.Sub_Business__c='DPP';
            br.RecordTypeId=busId ;
           // br.Recepient_Name__c='nish';
          //  br.Notification_Recepient_Name__c='nish';
            insert br; */
 
            customerData.RecordTypeId = NewCustomer_COB_RTYPE;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '3874 - Du Pont Co. (Singapore) Pte';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'SG - Singapore';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            insert customerData;
         
            Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 25000000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();
test.startTest();
Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='3940 - DUP MALAYSIA';
br1.CDR_Sold_to_Country__c= 'MY - Malaysia';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
Business_Rules__c br3 = new Business_Rules__c();
br3.selling_company_code__c ='0078 - ELECT. MATLS DUP DONGGUAN';
br3.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br3);

insert brlist;
            
              CDR_Notification__c notify=new CDR_Notification__c();
            notify.Customer_Data_Request__c=customerData.id;
            notify.User__c=U1.Id;
            insert notify;
    
     ApexPages.currentPage().getParameters().put('Account','null');  
     ApexPages.currentPage().getParameters().put('Id',customerdata.id);  
     ApexPages.currentPage().getParameters().put('Case','abc');  
      Apexpages.currentPage().getParameters().put('firstParam','qwe');
            Apexpages.currentPage().getParameters().put('secondParam','qwe');
            Apexpages.currentPage().getParameters().put('thirdParam','qwe');
            Apexpages.currentPage().getParameters().put('fourthParam','qwe');   
      
    
   ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();  
    ApexPages.currentPage().getParameters().put('RecordTypeId',Miscellaneous_COB_RTYPE); 
    ApexPages.currentPage().getParameters().put('Clone','null'); 
     ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        ERPCustGen.Sales_Org_Code__c='F803';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        ERPCust.Customer_Name_2__c='name';
        ERPCust.PO_Box__c='12133';
        ERPCust.Street__c='ew';
        ERPCust.City__c='ew';
        ERPCust.ZIP_Postal_Code__c='312';
        ERPCust.State_Province__c='Kerala';
        ERPCust.Country_Code__c='3123';
        ERPCust.Incoterms_1_Code__c='eqwe';
        ERPCust.Incoterms_2__c='qeqw';
        ERPCust.DUNS_Number__c='12312';
        ERPCust.Terms_of_Payment__c='qweqe';
        ERPCust.Sales_Org_Code__c='3123';
        ERPCust.Sales_Org__c='0003';
        insert ERPCust;
        
        
        
    RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
    Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound');
    insert acc;
    ApexPages.currentPage().getParameters().put('Account',acc.Id);  
    ctrlCOBCustomerDataRequest controller1 = new ctrlCOBCustomerDataRequest();  
     controller1.selectedNotifyUsers.add(new selectOption(U2.Id,'test'));
    controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
    controller1.ReqId=null;
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
    ApexPages.currentPage().getParameters().put('Account','null');  
     ApexPages.currentPage().getParameters().put('Id',customerdata.id);  
     ApexPages.currentPage().getParameters().put('Case','abc');      
    controller1.SaveAndSubmit();
   
    
    controller1.IsSaveOrSubmit='Submit';
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =true;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE;
     controller1.SaveAndSubmit();
     
     controller1.IsSaveOrSubmit='Save';
    controller1.IsClone=false;
    controller1.radioSelected = 'true';     
      
    controller1.IsError=false;
    controller1.OnboardingReq.Proposed_Credit_Limit__c='5';
    
    controller1.OnboardingReq.Leveraged_CSR__c =true;
    controller1.OnboardingReq.Assigned_to_Leverage_CSR__c =true;
    controller1.ReqId=customerData.Id ;
    controller1.OnboardingReq.RecordTypeId=NewCustomer_COB_RTYPE;
    controller1.SaveAndSubmit();
     controller1.IsSaveOrSubmit='Submit';
    controller1.SaveAndSubmit();
    ApexPages.currentPage().getParameters().put('Account','null'); 
    Apexpages.currentPage().getParameters().put('firstParam','abd');
    Apexpages.currentPage().getParameters().put('secondParam','abc');
    Apexpages.currentPage().getParameters().put('thirdParam','qwe');
    Apexpages.currentPage().getParameters().put('fourthParam','ewq');
    controller1.OnboardingReq.Local_Version__c='';
    controller1.checkLocalLanguage();
    //controller1.getCreditDataFields();
    test.StopTest();
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='tes';
    controller1.OnboardingReq.Sold_to_Country__c='SG - Singapore';
    controller1.sellingCompanyCode = '3874 - Du Pont Co. (Singapore) Pte';
    controller1.OnboardingReq.Leveraged_CSR__c=false;
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='Open Credit' ;
    controller1.OnboardingReq.Proposed_Credit_Limit_Est__c='999999999';
    controller1.OnboardingReq.Account_Group__c='Z001 ( Sold-to party )';
    controller1.requestorAccount.ERP_Customer__c=ERPCust.Id;
    controller1.RequestFlow();
    controller1.OnboardingReq.Customer__c=ERPCust.Id;
    controller1.OnboardingReq.RecordTypeId=ModifyExisting_COB_RTYPE ;
    controller1.populateExistingCustomerInformation();
    controller1.RequestFlow();
    controller1.OnboardingReq.RecordTypeId=Miscellaneous_COB_RTYPE;
    controller1.RequestFlow();
    controller1.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE ;
    controller1.OnboardingReq.Proposed_Terms_of_Payment__c =null;
    controller1.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c=null;
    controller1.OnboardingReq.Proposed_Credit_Limit__c=null;
    controller1.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
    controller1.OnboardingReq.Estimated_Number_of_Orders_per_Month__c =null;
    controller1.OnboardingReq.Local_Version__c='arabic'   ;     
  
    controller1.OnboardingReq.Fields_Modified_2__c='Proposed Terms of Payment';
    controller1.OnboardingReq.Proposed_Terms_of_Payment__c='test';
    controller1.OnboardingReq.Proposed_Credit_Term_Type__c='';
    controller1.creditValidationModify();
      controller1.OnboardingReq.recordTypeId = ExtendExisting_COB_RTYPE;
        controller1.creditValidationModify();
        List<SelectOption> selOpts=controller1.SellingCompanyOptions;
         
          controller.OnboardingReq.RecordTypeId = Miscellaneous_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='SG - Singapore';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='3874 - Du Pont Co. (Singapore) Pte';
         controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
         controller.OnboardingReq.Invoice_Type__c='VAT';
            controller.OnboardingReq.Local_Version__c='arabic'   ;
       		controller.OnboardingReq.Miscellaneous_Type_Intent__c='Mass load - finance data'; 
            controller.openLocalLanguagePanel=true;
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Telebox__c=null;
         controller.OnboardingReq.Teletex_Number__c=null;
         controller.OnboardingReq.Proposed_Credit_Limit__c=null;
         controller.OnboardingReq.Account_Group__c  ='Z001 ( Ship-to party )'; 
         controller.RequiredValidations();
         
         controller.validateFieldModified();
       
    } 
    }
    
    
  static testMethod void testMyControllerNew4() {
    
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       // Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_hong_kong'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
       /* GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); */
        
        insert GMlist;

        
       
        System.runAs(U1){        
        
       
        ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        insert ERPCust;
        
        RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust.id);
        insert acc;
        
        COB_Region__c CobCustom= new COB_Region__c();
        CobCustom.Name='abc';
        CobCustom.Country__c='IN - India'; 
        CobCustom.Region__c='IN - 22 - Tamil Nadu';
        insert CobCustom;

           Customer_Data_Request__c customerData = new Customer_Data_Request__c();
        /*    Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br; 
            */
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '0029 - DU PONT CHINA LIMITED';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'CN - China';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Activity_Code__c='12';
customerData.Distribution_Type__c='Ab';
customerData.Tax_Code_1__c='12';
customerData.Tax_Code_2__c='34';
customerData.Tax_Number_Category__c='qwe';
customerData.Business_Type__c='Abc';
customerData.Argentina_Tax_Categories__c='acv';
customerData.Business_Strategic__c='qwe';
customerData.Geocode__c='123';
customerData.Unloading_Point__c='ewe';
customerData.Business_Category__c='qwew';
customerData.Ownership_Type__c='ewqe';
customerData.Business_Partner_ID_Grouping__c='qweq';
customerData.Jurisdiction_Code__c='qw';
customerData.Registration_Number__c='21';
customerData.Ultimate_Consign_Type_attribute__c='re';
customerData.Argentina_Withholding_Tax__c='wqe';
customerData.CFOP__c='uyt';
customerData.Preferred_Bank_Name__c='Axis';
customerData.Estimated_Average_Monthly_Purchases__c=10;
customerData.Estimated_Number_of_Orders_per_Month__c=20;
customerData.Proposed_Customer_Group__c='we';
customerData.Customer_Currency__c='Inr';             

            insert customerData;
            
                Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 250;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();
test.startTest();
Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='4860 - DUP (Thailand) Ltd';
br1.CDR_Sold_to_Country__c= 'TH - Thailand';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
Business_Rules__c br3 = new Business_Rules__c();
br3.selling_company_code__c ='0078 - ELECT. MATLS DUP DONGGUAN';
br3.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br3);

insert brlist;       
                   
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
           
          
            
            
            
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);

            
        Test.setCurrentPageReference(new PageReference('Page.COBNewCustomerCreation'));
        System.currentPageReference().getParameters().put('Id', customerData.id); 
        System.currentPageReference().getParameters().put('Account', acc.Id); 
        System.currentPageReference().getParameters().put('RecordTypeId', NewCustomer_COB_RTYPE);
        System.currentPageReference().getParameters().put('ERPCustomer', ERPCust.Id);
        System.currentPageReference().getParameters().put('Clone','null');
        System.currentPageReference().getParameters().put('AccountLink','null');
        System.currentPageReference().getParameters().put('Case','null');
         
    Apexpages.currentPage().getParameters().put('sixthParam','abc');
    Apexpages.currentPage().getParameters().put('seventhParam','qwe');
           // Apexpages.currentPage().getParameters().put('ERPCustomer','null');
         Apexpages.currentPage().getParameters().put('fifthParam','qwe');
          Apexpages.currentPage().getParameters().put('firstParam','qwe');
            Apexpages.currentPage().getParameters().put('secondParam','qwe');
            Apexpages.currentPage().getParameters().put('thirdParam','qwe');
            Apexpages.currentPage().getParameters().put('fourthParam','qwe');
        ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();
        controller = new ctrlCOBCustomerDataRequest(); 
        controller.sellingCompanyCode = '0003 - E.I. DuPont India Private Limited';
        controller.SBUCode            = 'A6 - Building Innovations';
        controller.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c = 'ALL - Albanian Lek';  
        controller.selectedNotificationUsers();
       // controller.getNotifyUsers();
                     
       Selling_Company_Code_Dependency__c scdobj = new Selling_Company_Code_Dependency__c();
       scdobj.name = 'Test';
       scdobj.Selling_Company_Code__c = '0003 - E.I. DuPont India Private Limited';
       scdobj.Tax_Category__c = 'Tax Category 1';
       scdobj.Sales_Org_Code__c = 'A203';
       scdobj.Group_key__c = 'Other';
       scdobj.Sub_Business__c = 'DPT';
       scdobj.SBU__c = 'A6 - Building Innovations';
       insert scdobj;
             
             
       controller.OnboardingReq.Activity_Code__c='2';
controller.OnboardingReq.Distribution_Type__c='Asb';
controller.OnboardingReq.Tax_Code_1__c='2';
controller.OnboardingReq.Tax_Code_2__c='4';
controller.OnboardingReq.Tax_Number_Category__c='we';
controller.OnboardingReq.Business_Type__c='bc';
controller.OnboardingReq.Argentina_Tax_Categories__c='cv';
controller.OnboardingReq.Business_Strategic__c='qe';
controller.OnboardingReq.Geocode__c='13';
controller.OnboardingReq.Unloading_Point__c='ee';
controller.OnboardingReq.Business_Category__c='qww';
controller.OnboardingReq.Ownership_Type__c='ewq';
controller.OnboardingReq.Business_Partner_ID_Grouping__c='qwq';
controller.OnboardingReq.Jurisdiction_Code__c='w';
controller.OnboardingReq.Registration_Number__c='1';
controller.OnboardingReq.Ultimate_Consign_Type_attribute__c='r';
controller.OnboardingReq.Argentina_Withholding_Tax__c='we';
controller.OnboardingReq.CFOP__c='ut';
controller.OnboardingReq.Preferred_Bank_Name__c='Ais';
controller.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
controller.OnboardingReq.Estimated_Number_of_Orders_per_Month__c=null;
controller.OnboardingReq.Proposed_Customer_Group__c='wew';
controller.OnboardingReq.Customer_Currency__c='Ir';
controller.OnboardingReq.Telex_Number__c=null;  
controller.OnboardingReq.Tax_code_1__c=null;  
controller.onboardingreq.local_version__c='chinese';            
controller.OnboardingReq.customer_name__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_2__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_3__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_4__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_1__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry';             
controller.OnboardingReq.local_customer_name_2__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_3__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_4__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.Local_Language_Street__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.openLocalLanguagePanel=true;            
           
        
       
        controller.fetchSellingCompanyDependents();
        controller.fetchSBUDependents();
        controller.checkOtherGroupKey();
        controller.redirectLink();
                              
        controller.populateCurrency();
        controller.notification();
        controller.gettaxValues();
         
                         
       // String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><getDetailResponse xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0050161945</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION/><NAME1>LEFFINGWELL AG SALES CO INC</NAME1><NAME2>Test Name2 AG SALES CO INC</NAME2><NAME3>123</NAME3><NAME4>123</NAME4><CITY1>TERRA BELLA</CITY1><CITY2>TULARE</CITY2><CITYP_CODE>123</CITYP_CODE><PO_BOX>10009</PO_BOX><TRANSPZONE>CA001</TRANSPZONE><HOUSE_NUM1>112</HOUSE_NUM1><HOUSE_NUM2>111</HOUSE_NUM2><REGION>CA</REGION><SORT1>P/LEFFINGW</SORT1><TEL_NUMBER>(999)555-2350</TEL_NUMBER><FAX_NUMBER>(999)555-2351</FAX_NUMBER><EXTENSION1>(999)555-2351</EXTENSION1><EXTENSION2>(999)555-2351</EXTENSION2><SMTP_SRCH>EXAMPLE@EMAIL.COM</SMTP_SRCH><URI_SRCH>WWW.TERRABELLA.COM</URI_SRCH><URI_ADDR>www.terrabella.com</URI_ADDR><STRAS>23576 AVE 96</STRAS></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>11</KUNNR><BUKRS>11</BUKRS><ZUAWA>11</ZUAWA><BUSAB>11</BUSAB><AKONT>11</AKONT><KNRZE>11</KNRZE><ZWELS>11</ZWELS><VZSKZ>11</VZSKZ><ZINRT>00</ZINRT><EIKTO>11</EIKTO><ZSABE>11</ZSABE><KVERM>11</KVERM><FDGRV>11</FDGRV><XAUSZ>11</XAUSZ><LOCKB>11</LOCKB><XEDIP>11</XEDIP><TLFXS>11</TLFXS><INTAD>11</INTAD><GUZTE>11</GUZTE><GRICD>11</GRICD><GRIDT>11</GRIDT><TLFNS>11</TLFNS></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055022797</KUNNR><TAXGR>111</TAXGR><ADRNR>0050161945</ADRNR><BAHNE>CDRCD159362</BAHNE><BAHNS>00000</BAHNS><BBBNR>0000000</BBBNR><BRSCH>000000</BRSCH><BUBKZ>0</BUBKZ><DATLT>00000</DATLT><FISKN>000000</FISKN><KONZS>000000</KONZS><KUKLA>000000</KUKLA><LIFNR>000000</LIFNR><LOCCO>A</LOCCO><SPRAS>E</SPRAS><STCD1>A</STCD1><STCD2>A</STCD2><STKZA>A</STKZA><STKZU>A</STKZU><STCEG>A</STCEG><VBUND/><KATR5>A</KATR5><STKZN>A</STKZN><FITYP>A</FITYP><STCDT>A</STCDT><STCD3>A</STCD3><STCD4>A</STCD4><J_1KFTBUS>A</J_1KFTBUS><MINDK>A</MINDK><TEL_NUMBER>(999)555-2350</TEL_NUMBER><TTX_NUMBER>333</TTX_NUMBER><TLX_NUMBER>444</TLX_NUMBER></PE_PERSONALDATA><PE_RETURN><TYPE/><ID/><NUMBER>000</NUMBER><MESSAGE/><LOG_NO/><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1/><MESSAGE_V2/><MESSAGE_V3/><MESSAGE_V4/></PE_RETURN><PE_SALESDATA><KUNNR/><VKORG/><VTWEG/><SPART/><BEGRU>888</BEGRU><VERSG>444</VERSG><KALKS>443</KALKS><BZIRK>333</BZIRK><KONDA>464</KONDA><AWAHR>000</AWAHR><ANTLF>0</ANTLF><AUTLF>424</AUTLF><KZTLF>242</KZTLF><KZAZU>234</KZAZU><LPRIO>00</LPRIO><VSBED>533</VSBED><MRNKZ>353</MRNKZ><PERFK>342</PERFK><PERRL>332</PERRL><KLABC>211</KLABC><KTGRD>119</KTGRD><ZTERM>865</ZTERM><VWERK>422</VWERK><VKGRP>325</VKGRP><VSORT>3563</VSORT><BOKRE>2255</BOKRE><KURST>3523</KURST><PRFRE>353</PRFRE><KABSS>242</KABSS><KKBER>4222</KKBER><RDOFF>4252</RDOFF><AGREL>35423</AGREL><MEGRU>5353</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>0.0</UEBTK><PVKSM>331</PVKSM><PODKZ>867</PODKZ><PODTG>0</PODTG><ZZSLOC>220</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>000</ZZ00CPBKMSG><ZZDUTYIND>00</ZZDUTYIND><ZZONBYDATE>000</ZZONBYDATE><SBU>00</SBU><SHIPPING_INSTR>11123</SHIPPING_INSTR><WAREHOUSE_INSTR>35436</WAREHOUSE_INSTR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR/><TAXGR>111</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR/><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKA>Third Bank of Wilmington</BANKA><STRAS>3131 Walnut St</STRAS><ORT01>Wilmington, 19104</ORT01><SWIFT/><BRNCH>City Hall Branch</BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>0055022797</KUNNR><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKN>12345</BANKN><BKONT/><KOINH/><IBAN/></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055022797</KUNNR><PARNR>0000007299</PARNR><NAME1>Thompson</NAME1><ABTNR/><TELF1>009</TELF1><PAFKT/><TITEL_AP/><PRSNR>0051886247</PRSNR><SMTP_SRCH>FREDDYT@TERRABELLA.C</SMTP_SRCH><FAX_NUMBER>(302) 884-3838</FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055022797</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP/><KRAUS/><GRUPP/><SBDAT>0000-00-00</SBDAT><CASHC/><DBPAY/><DBRTG/><DBWAE/></PE_CONTROLDETAILS><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>BE</ALAND><TATYP>ZAO1</TATYP><TAXKD/></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO3</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>FR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWAS</TATYP><TAXKD>3</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MX01</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>MWST</TATYP><TAXKD>0</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE><ERROR_CODE> </ERROR_CODE></ERROR_CODE><ERROR_DESC><ERROR_DESC> </ERROR_DESC></ERROR_DESC></Response></getDetailResponse></Body></Envelope>';
        
        String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Y_GVCUSTOMER_GETDETAIL.Response xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0000145318</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION></NATION><NAME1>VISHAY DALE ELECTRONICS INC</NAME1><NAME2>VISHAY DALE ELECTRONICS INC-2</NAME2><NAME3>VISHAY DALE ELECTRONICS INC-3</NAME3><NAME4>VISHAY DALE ELECTRONICS INC-4</NAME4><CITY1>COLUMBUS</CITY1><CITY2>POLK</CITY2><CITYP_CODE></CITYP_CODE><PO_BOX>609</PO_BOX><TRANSPZONE>0000000015</TRANSPZONE><HOUSE_NUM1>2222222</HOUSE_NUM1><HOUSE_NUM2>1111111</HOUSE_NUM2><REGION>13</REGION><SORT1>DALCOLDAL</SORT1><TEL_NUMBER>123456789</TEL_NUMBER><FAX_NUMBER>987654321</FAX_NUMBER><EXTENSION1>abcd</EXTENSION1><EXTENSION2>987654321</EXTENSION2><SMTP_SRCH>ABC@EMAIL.COM</SMTP_SRCH><URI_SRCH>HOMEPAGE@Dupont.COM</URI_SRCH><URI_ADDR>homepage@Dupont.com</URI_ADDR><STRAS>1122 23RD STREET-PLANT #2</STRAS><COUNTRY>JP</COUNTRY><PO_BOX_LOC>Other</PO_BOX_LOC><POST_CODE1>68601</POST_CODE1><LCL_LANGU>E</LCL_LANGU><LCL_NAME1>VISHAY DALE ELECTRONICS INC</LCL_NAME1><LCL_NAME2>VISHAY DALE ELECTRONICS INC-2</LCL_NAME2><LCL_NAME3>VISHAY DALE ELECTRONICS INC-3</LCL_NAME3><LCL_NAME4>VISHAY DALE ELECTRONICS INC-4</LCL_NAME4><LCL_EXTENSION1>abcd</LCL_EXTENSION1><LCL_CITY1>oou</LCL_CITY1><LCL_CITY2>oot</LCL_CITY2><LCL_HOUSE_NUM1>2222</LCL_HOUSE_NUM1><LCL_POST_CODE1>68601</LCL_POST_CODE1><LCL_REGION>13</LCL_REGION><LCL_SORT1>DALCOLDAL</LCL_SORT1><LCL_STREET>sss</LCL_STREET><LCL_EXTENSION2>987654321</LCL_EXTENSION2></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><ZUAWA>009</ZUAWA><BUSAB>VR</BUSAB><AKONT>0012101000</AKONT><KNRZE>0055001120</KNRZE><ZWELS>E</ZWELS><VZSKZ>TRUE</VZSKZ><ZINRT>01</ZINRT><EIKTO>123454321</EIKTO><ZSABE>10234</ZSABE><KVERM>Testing</KVERM><FDGRV>E2</FDGRV><XAUSZ>2</XAUSZ><LOCKB>EBO</LOCKB><XEDIP>TRUE</XEDIP><TLFXS>no. 123456789</TLFXS><INTAD>abc@abc.com</INTAD><GUZTE></GUZTE><GRICD></GRICD><GRIDT></GRIDT><TLFNS>123456789</TLFNS><LOEVM>X</LOEVM><SPERR>X</SPERR></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055110426</KUNNR><ADRNR>0000145318</ADRNR><BAHNE>Express station</BAHNE><BAHNS>Train station</BAHNS><BBBNR>0012345</BBBNR><BRSCH>FINS</BRSCH><BUBKZ>0</BUBKZ><DATLT>abcd</DATLT><FISKN>0055000943</FISKN><KONZS>1235</KONZS><KUKLA>01</KUKLA><LIFNR>0000001453</LIFNR><LOCCO>123456</LOCCO><SPRAS>E</SPRAS><STCD1></STCD1><STCD2></STCD2><STKZA>TRUE</STKZA><STKZU>TRUE</STKZU><STCEG>123 456789</STCEG><VBUND>06</VBUND><KATR5>D</KATR5><STKZN>TRUE</STKZN><FITYP>22</FITYP><STCDT></STCDT><STCD3>STCD3</STCD3><STCD4>STCD4</STCD4><J_1KFTBUS></J_1KFTBUS><MINDK></MINDK><TEL_NUMBER>123456789</TEL_NUMBER><TTX_NUMBER>987654321</TTX_NUMBER><TLX_NUMBER>987654321</TLX_NUMBER><KTOKD>Z001</KTOKD><LOEVM>X</LOEVM><BBSNR>01234</BBSNR><SPERR>X</SPERR><CASSD>X</CASSD></PE_PERSONALDATA><PE_RETURN><TYPE></TYPE><ID></ID><NUMBER>000</NUMBER><MESSAGE></MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1></MESSAGE_V1><MESSAGE_V2></MESSAGE_V2><MESSAGE_V3></MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></PE_RETURN><PE_SALESDATA><KUNNR>0055110426</KUNNR><VKORG>F450</VKORG><VTWEG>10</VTWEG><SPART>02</SPART><BEGRU>ZTXZ</BEGRU><VERSG>1</VERSG><KALKS>1</KALKS><BZIRK>USF3F4</BZIRK><KONDA>Z2</KONDA><AWAHR>100</AWAHR><ANTLF>0</ANTLF><AUTLF>TRUE</AUTLF><KZTLF>TRUE</KZTLF><KZAZU>TRUE</KZAZU><LPRIO>00</LPRIO><VSBED>11</VSBED><MRNKZ>TRUE</MRNKZ><PERFK>ZZ</PERFK><PERRL>ZZ</PERRL><KLABC>AB</KLABC><KTGRD>01</KTGRD><ZTERM>Y030</ZTERM><VWERK>YF12</VWERK><VKGRP>US6</VKGRP><VSORT>7500003828</VSORT><BOKRE>TRUE</BOKRE><KURST>M</KURST><PRFRE>TRUE</PRFRE><KABSS>ZZZZ</KABSS><KKBER>2350</KKBER><RDOFF>TRUE</RDOFF><AGREL>TRUE</AGREL><MEGRU>UNTE</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>TRUE</UEBTK><PVKSM>Z5</PVKSM><PODKZ>TRUE</PODKZ><PODTG>0</PODTG><ZZSLOC>1201</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>FALSE</ZZ00CPBKMSG><ZZDUTYIND>TRUE</ZZDUTYIND><ZZONBYDATE>BY</ZZONBYDATE><SBU></SBU><SHIPPING_INSTR>SHELF LIFE TO APPEAR ON ALL LABELS PER B. NISSAN</SHIPPING_INSTR><WAREHOUSE_INSTR>Warehouse Instructions</WAREHOUSE_INSTR><VTEXT>·¢Æ±ÈÕÆð30ÌìÄÚ¸¶¿î</VTEXT><BEZEI20>A Material</BEZEI20><CTEXT>Standard</CTEXT><GTEXT>Consumer</GTEXT><BEZEI></BEZEI><STEXT>Air Consolidated</STEXT><LTEXT>365 W/D - All Days/Work Days - 7 by 24</LTEXT><ITEXT>365 W/D - All Days/Work Days - 7 by 24</ITEXT><ATEXT>Domestic Revenues</ATEXT><CURVW>Standard translation at average rate</CURVW><PEZEI>No Payment Guarantee Required</PEZEI><PTEXT>Item Prop. (No Hist)</PTEXT><DDTEXT>Create a delivery with qty greater than zero</DDTEXT><ZZTEXT>Req. Del. date BY</ZZTEXT><FAKSD>08</FAKSD><KVGR1>Y</KVGR1><KVGR2>A05</KVGR2><KVGR3>SEZ</KVGR3><KVGR4>A23</KVGR4><KVGR5>A12</KVGR5><LOEVM>X</LOEVM><LIFSD>08</LIFSD><INCO1>142</INCO1><INCO2>FOB SHIPPOINT</INCO2><PLTYP>A6</PLTYP><CASSD>X</CASSD><VKBUR>F400</VKBUR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR>0055110426</KUNNR><TAXGR>IBZ</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR></EXNR><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>NON</BANKS><BANKL></BANKL><BANKA></BANKA><STRAS></STRAS><ORT01></ORT01><SWIFT></SWIFT><BRNCH></BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>NONE</KUNNR><BANKS></BANKS><BANKL></BANKL><BANKN></BANKN><BKONT></BKONT><KOINH></KOINH><IBAN></IBAN></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055110426</KUNNR><PARNR>0000016647</PARNR><NAME1>ABC</NAME1><ABTNR>0003</ABTNR><TELF1></TELF1><PAFKT>03</PAFKT><TITEL_AP></TITEL_AP><PRSNR>0001796770</PRSNR><SMTP_SRCH></SMTP_SRCH><FAX_NUMBER></FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055110426</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP>00P</SBGRP><KRAUS>987654321</KRAUS><GRUPP>B200</GRUPP><SBDAT>2015-04-21</SBDAT><CASHC></CASHC><DBPAY>125</DBPAY><DBRTG>12456</DBRTG><DBWAE>ARS</DBWAE><REVDB>2015-04-01</REVDB><DTREV>2015-04-07</DTREV><NXTRV>2015-04-21</NXTRV></PE_CONTROLDETAILS><PE_DUNNINGDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><MABER></MABER><MAHNA>0003</MAHNA><BUSAB>0K</BUSAB></PE_DUNNINGDATA><PE_LOADINGPOINTS><KUNNR>0055110426</KUNNR><ABLAD>US</ABLAD><DEFAB></DEFAB></PE_LOADINGPOINTS><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZCC1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>IE</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZCJ1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZCK1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZTW1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_CODE><ERROR_DESC xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_DESC></Response></Y_GVCUSTOMER_GETDETAIL.Response></Body></Envelope>';
        controller.parseWebserviceResponse(ResponseXMLString); 
         
        controller.currentUserProfile();
        controller.queryPublicGroup();
        controller.populateRequestorInformation();
        controller.fetchRecordTypeName();
        controller.Done();
        controller.FormRenderValidation();
        controller.populateAccountInformation(acc.id);
         
       controller.fetchAccountDetails(acc.id);
        
        controller.OnboardingReq.Customer__c = ERPCust.id;
      controller.fetchCustomerInformation(ERPCust.id);
        test.stopTest();
        controller.populateExistingCustomerInformation();
        
        controller.OnboardingReq.Bank_statement__c = '120';
        controller.fieldmodified(); 
        
        controller.OnboardingReq.Leveraged_CSR__c = true;
        //controller.OnboardingReq.Assigned_to_Leverage_CSR__c = false;
        controller.OnboardingReq.Request_Status__c = 'Request Completed in SAP';
        
        controller.OnboardingReq.Proposed_Terms_of_Payment__c='CIA-Payment in Advance';
        controller.OnboardingReq.Proposed_Credit_limit__c='111';
        
        controller.RequestFlow();
     
        controller.Cancel();
        controller.CancelAndClose();
        controller.RedirectCancelAndClose();
        controller.IsSaveOrSubmit='Save';
        controller.SaveAndSubmit();
        controller.IsSaveOrSubmit='Submit';
        controller.SaveAndSubmit();
        controller.getItems();
        controller.requireCreditApproval();
        controller.checkPOD();
        controller.RelatedlistItemsValidation();
        controller.checkLocalLanguage();
        controller.fetchRegionValues();
        controller.fetchLocalRegionValues();
        controller.PrepopulateCreditLimit();
        controller.fetchCountryCode();
        controller.CopyProposedToApprovedCredit(controller.OnboardingReq);
        controller.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE;
        controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
        controller.creditValidationModify();
        
        
        controller.OnboardingReq.Leveraged_CSR__c = false;
        controller.OnboardingReq.Account_Group__c = 'Z001 ( Sold-to party )';
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.RequestFlow();
        
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE; 
        controller.OnboardingReq.Sold_to_Country__c='CN - China';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Telebox__c=null;
         Controller.OnboardingReq.Teletex_Number__c=null;
         controller.OnboardingReq.Tax_number_5__c=null;
         controller.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
         controller.OnboardingReq.Estimated_Number_of_Orders_per_Month__c=null;   
            controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.local_version__c='arabic'; 
         controller.openLocalLanguagePanel=false;
         controller.OnboardingReq.Customer_Name__c.length(); 
         controller.OnboardingReq.Customer_Name_2__c.length();             
         controller.OnboardingReq.Customer_Name_3__c.length();                         
         controller.OnboardingReq.Customer_Name_4__c.length();                         
         controller.OnboardingReq.Local_Customer_Name_1__c.length();
         controller.OnboardingReq.Local_Customer_Name_2__c.length();
         controller.OnboardingReq.Local_Customer_Name_3__c.length();
         controller.OnboardingReq.Local_Customer_Name_4__c.length();   
         controller.OnboardingReq.Data_line__c=null;
         controller.RequiredValidations();
          
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='CN - China';
        controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Telebox__c=null;
         controller.OnboardingReq.Local_Version__c='chinese'   ;
         controller.openLocalLanguagePanel=true;
         controller.OnboardingReq.Local_Customer_Name_1__c.length();
         controller.OnboardingReq.Local_Customer_Name_2__c.length();
         controller.OnboardingReq.Local_Customer_Name_3__c.length();
         controller.OnboardingReq.Local_Customer_Name_4__c.length();
         controller.OnboardingReq.Local_Language_Street__c.length();   
         controller.RequiredValidations() ;
          controller.OnboardingReq.Local_Version__c='Chinese';
          controller.RequiredValidations() ;
          controller.OnboardingReq.RecordTypeId = ModifyExisting_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='CN - China';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
         controller.OnboardingReq.Invoice_Type__c='VAT';
            controller.OnboardingReq.Local_Version__c='chinese'   ;
            controller.openLocalLanguagePanel=true;
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Telebox__c=null;
         controller.OnboardingReq.Teletex_Number__c=null;
         controller.OnboardingReq.Proposed_Credit_Limit__c=null;
         controller.OnboardingReq.Account_Group__c  ='Z001 ( Ship-to party )'; 
        controller.RequiredValidations();
         controller.validateFieldModified(); 
            
       
        }
  }
      static testMethod void testMyControllerNew5() {
    
        //commented for dps
        //Profile p1 =[SELECT Id FROM Profile where name='Customer Service Representative' limit 1];
        Profile p1 =[SELECT Id FROM Profile where name='Customer Service' limit 1];  
        User U1= new User(Firstname='System',Alias='SUser', Email='Sai_Lakkimsetty@infosys.com', 
        User_Country__c='UNITED STATES', profileid = p1.id,
        Username='User4@dupont.com.test4', LastName='user',
        TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
        EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert U1;   
        
        Group grp1 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_India'];
        Group grp2 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_China'];
        Group grp3 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_Thailand'];
       Group grp4 =[Select id, DeveloperName,Name,Type From Group Where DeveloperName ='DuPont_CDR_Users_ASEAN'];

        GroupMember GM1 = new GroupMember();
        GroupMember GM2 = new GroupMember();
        GroupMember GM3 = new GroupMember();
        GroupMember GM4 = new GroupMember();
        List<GroupMember> GMlist = new List<GroupMember>();
        GM1.GroupId = grp1.id;
        GM1.UserOrGroupId = U1.Id;
        GMlist.add(GM1);

        GM2.GroupId = grp2.id;
        GM2.UserOrGroupId = U1.Id;
        GMlist.add(GM2);

        GM3.GroupId = grp3.id;
        GM3.UserOrGroupId = U1.Id;
        GMlist.add(GM3);
        
        GM4.GroupId = grp4.id;
        GM4.UserOrGroupId = U1.Id;
        GMlist.add(GM4); 
        
        insert GMlist;

        
       
        System.runAs(U1){        
        
       
        ERP_Customer__c ERPCustGen = new ERP_Customer__c ();
        ERPCustGen.Name = 'TestCustomer134';
        ERPCustGen.Currency_Code__c= 'INR';
        ERPCustGen.Country_Code__c='IN';
        ERPCustGen.DUNS_Number__c='2323232';
        insert ERPCustGen;
       
        ERP_Customer__c ERPCust = new ERP_Customer__c ();
        ERPCust.Name = 'TestCustomer';
        ERPCust.Currency_Code__c= 'INR';
        ERPCust.Country_Code__c='IN';
        ERPCust.DUNS_Number__c='2323232';
        ERPCust.Account_Group__c='Z001(Sold-to Party)';
        ERPCust.Customer_General_Data__c = ERPCustGen.Id;
        insert ERPCust;
        
        RecordType recAccID = Rtype.getRecordTypeByDevName('Account', 'DPP_Polymers_CUPS');
        Account acc = new Account(Name='testPolyOne1111',RecordType=recAccID,Country__c='CANADA',BillingCountry='CANADA', BillingCity='BRAMTPON', CurrencyIsoCode='USD', UOM__c='Pound',ERP_Customer__c = ERPCust.id);
        insert acc;
        
        COB_Region__c CobCustom= new COB_Region__c();
        CobCustom.Name='abc';
        CobCustom.Country__c='IN - India'; 
        CobCustom.Region__c='IN - 22 - Tamil Nadu';
        insert CobCustom;

           Customer_Data_Request__c customerData = new Customer_Data_Request__c();
        /*    Business_Rules__c br = new Business_Rules__c();
      br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 50000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br; 
            */
            Id newCustomerRecId = [Select Id, Name from RecordType where DeveloperName = 'New_Customer_Creation' limit 1].Id;
            customerData.RecordTypeId = newCustomerRecId ;
            customerData.SF_Region__c = 'Asia Pacific';
            customerData.Company_Code__c = '3940 - DUP MALAYSIA';
            customerData.Group_Key__c = '6000000';
            customerData.Sub_Business__c = 'DPP';
            customerData.Distribution_Channel__c = '10-Dupont Std';
            customerData.Account_Group__c = 'Z002 (Ship-to party)';
            customerData.Division__c = '01-Product Division 01';
            customerData.Customer_Name__c = 'Test Customer';
            customerData.Sold_to_Street__c = 'Walters Street';
            customerData.Sold_to_City__c = 'New Jersey';
            customerData.Sold_to_Country__c = 'MY - Malaysia';
            customerData.Sold_to_e_mail__c = 'sam@gmail.com';
            customerData.Sold_To_Office_House_Number__c = '401';
            customerData.Sold_to_State_Province__c = 'California';
            customerData.Fields_Modified_2__c = 'Teletex Number';
            customerData.Fields_Modified_1__c = 'Activity Code';
            customerData.Sales_Organization__c = 'A203';
            customerData.Distribution_Channel__c = '10- DuPont Std';
            customerData.Division__c = '10-EP FILAMENTS B9';
            customerData.Activity_Code__c='12';
customerData.Distribution_Type__c='Ab';
customerData.Tax_Code_1__c='12';
customerData.Tax_Code_2__c='34';
customerData.Tax_Number_Category__c='qwe';
customerData.Business_Type__c='Abc';
customerData.Argentina_Tax_Categories__c='acv';
customerData.Business_Strategic__c='qwe';
customerData.Geocode__c='123';
customerData.Unloading_Point__c='ewe';
customerData.Business_Category__c='qwew';
customerData.Ownership_Type__c='ewqe';
customerData.Business_Partner_ID_Grouping__c='qweq';
customerData.Jurisdiction_Code__c='qw';
customerData.Registration_Number__c='21';
customerData.Ultimate_Consign_Type_attribute__c='re';
customerData.Argentina_Withholding_Tax__c='wqe';
customerData.CFOP__c='uyt';
customerData.Preferred_Bank_Name__c='Axis';
customerData.Estimated_Average_Monthly_Purchases__c=10;
customerData.Estimated_Number_of_Orders_per_Month__c=20;
customerData.Proposed_Customer_Group__c='we';
customerData.Customer_Currency__c='Inr';             

            insert customerData;
            
                Business_Rules__c br = new Business_Rules__c();
            br.CDR_Proposed_Credit_Term_Type__c = 'Open Credit';
            br.CDR_Delegation_Limit__c = 25000000;
            //br.CDR_Credit_Limit_Upper__c = 50000;
            //br.CDR_Credit_Limit_Lower__c = 0;
            insert br;   
            List<Business_Rules__c> brlist = new List<Business_Rules__c>();
test.startTest();
Business_Rules__c br1 = new Business_Rules__c();
br1.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br1.selling_company_code__c ='3940 - DUP MALAYSIA';
br1.CDR_Sold_to_Country__c= 'MY - Malaysia';
brlist.add(br1);
Business_Rules__c br2 = new Business_Rules__c();
br2.recordtypeid = CompanyCodeCountry_Rule_Rtype ;
br2.selling_company_code__c ='0029 - DU PONT CHINA LIMITED';
br2.CDR_Sold_to_Country__c= 'HK - Hong Kong';
brlist.add(br2);
Business_Rules__c br3 = new Business_Rules__c();
br3.selling_company_code__c ='0078 - ELECT. MATLS DUP DONGGUAN';
br3.CDR_Sold_to_Country__c= 'CN - China';
brlist.add(br3);

insert brlist;       
                   
            String requestId = String.valueOf(customerData.Id);
            String selectedRecordTypeId = String.valueOf(newCustomerRecId);
            ctrlCOBCustomerOnboardingRequestSubmit.InitVar initVarInstance = new ctrlCOBCustomerOnboardingRequestSubmit.InitVar();
           
          
            
            
            
            string result = ctrlCOBCustomerOnboardingRequestSubmit.DirectSubmit(requestId,selectedRecordTypeId,initVarInstance);

            
        Test.setCurrentPageReference(new PageReference('Page.COBNewCustomerCreation'));
        System.currentPageReference().getParameters().put('Id', customerData.id); 
        System.currentPageReference().getParameters().put('Account', acc.Id); 
        System.currentPageReference().getParameters().put('RecordTypeId', NewCustomer_COB_RTYPE);
        System.currentPageReference().getParameters().put('ERPCustomer', ERPCust.Id);
        System.currentPageReference().getParameters().put('Clone','null');
        System.currentPageReference().getParameters().put('AccountLink','null');
        System.currentPageReference().getParameters().put('Case','null');
         
    Apexpages.currentPage().getParameters().put('sixthParam','abc');
    Apexpages.currentPage().getParameters().put('seventhParam','qwe');
           // Apexpages.currentPage().getParameters().put('ERPCustomer','null');
         Apexpages.currentPage().getParameters().put('fifthParam','qwe');
          Apexpages.currentPage().getParameters().put('firstParam','qwe');
            Apexpages.currentPage().getParameters().put('secondParam','qwe');
            Apexpages.currentPage().getParameters().put('thirdParam','qwe');
            Apexpages.currentPage().getParameters().put('fourthParam','qwe');
        ctrlCOBCustomerDataRequest controller = new ctrlCOBCustomerDataRequest();
        controller = new ctrlCOBCustomerDataRequest(); 
        controller.sellingCompanyCode = '0003 - E.I. DuPont India Private Limited';
        controller.SBUCode            = 'A6 - Building Innovations';
        controller.OnboardingReq.Proposed_Credit_Limit_Currency_Code__c = 'ALL - Albanian Lek';  
        controller.selectedNotificationUsers();
       // controller.getNotifyUsers();
                     
       Selling_Company_Code_Dependency__c scdobj = new Selling_Company_Code_Dependency__c();
       scdobj.name = 'Test';
       scdobj.Selling_Company_Code__c = '0003 - E.I. DuPont India Private Limited';
       scdobj.Tax_Category__c = 'Tax Category 1';
       scdobj.Sales_Org_Code__c = 'A203';
       scdobj.Group_key__c = 'Other';
       scdobj.Sub_Business__c = 'DPT';
       scdobj.SBU__c = 'A6 - Building Innovations';
       insert scdobj;
             
             
       controller.OnboardingReq.Activity_Code__c='2';
controller.OnboardingReq.Distribution_Type__c='Asb';
controller.OnboardingReq.Tax_Code_1__c='2';
controller.OnboardingReq.Tax_Code_2__c='4';
controller.OnboardingReq.Tax_Number_Category__c='we';
controller.OnboardingReq.Business_Type__c='bc';
controller.OnboardingReq.Argentina_Tax_Categories__c='cv';
controller.OnboardingReq.Business_Strategic__c='qe';
controller.OnboardingReq.Geocode__c='13';
controller.OnboardingReq.Unloading_Point__c='ee';
controller.OnboardingReq.Business_Category__c='qww';
controller.OnboardingReq.Ownership_Type__c='ewq';
controller.OnboardingReq.Business_Partner_ID_Grouping__c='qwq';
controller.OnboardingReq.Jurisdiction_Code__c='w';
controller.OnboardingReq.Registration_Number__c='1';
controller.OnboardingReq.Ultimate_Consign_Type_attribute__c='r';
controller.OnboardingReq.Argentina_Withholding_Tax__c='we';
controller.OnboardingReq.CFOP__c='ut';
controller.OnboardingReq.Preferred_Bank_Name__c='Ais';
controller.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
controller.OnboardingReq.Estimated_Number_of_Orders_per_Month__c=null;
controller.OnboardingReq.Proposed_Customer_Group__c='wew';
controller.OnboardingReq.Customer_Currency__c='Ir';
controller.OnboardingReq.Telex_Number__c=null;  
controller.OnboardingReq.Tax_code_1__c=null;  
controller.onboardingreq.local_version__c='chinese';            
controller.OnboardingReq.customer_name__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_2__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_3__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.customer_name_4__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_1__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry';             
controller.OnboardingReq.local_customer_name_2__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_3__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.local_customer_name_4__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.OnboardingReq.Local_Language_Street__c='setertertergdfbcfbfghnsfdhdgsdgdfgfhfghfgjhdfgsefertry'; 
controller.openLocalLanguagePanel=true;            
           
        
       
        controller.fetchSellingCompanyDependents();
        controller.fetchSBUDependents();
        controller.checkOtherGroupKey();
        controller.redirectLink();
                              
        controller.populateCurrency();
        controller.notification();
        controller.gettaxValues();
         
                         
       // String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><getDetailResponse xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0050161945</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION/><NAME1>LEFFINGWELL AG SALES CO INC</NAME1><NAME2>Test Name2 AG SALES CO INC</NAME2><NAME3>123</NAME3><NAME4>123</NAME4><CITY1>TERRA BELLA</CITY1><CITY2>TULARE</CITY2><CITYP_CODE>123</CITYP_CODE><PO_BOX>10009</PO_BOX><TRANSPZONE>CA001</TRANSPZONE><HOUSE_NUM1>112</HOUSE_NUM1><HOUSE_NUM2>111</HOUSE_NUM2><REGION>CA</REGION><SORT1>P/LEFFINGW</SORT1><TEL_NUMBER>(999)555-2350</TEL_NUMBER><FAX_NUMBER>(999)555-2351</FAX_NUMBER><EXTENSION1>(999)555-2351</EXTENSION1><EXTENSION2>(999)555-2351</EXTENSION2><SMTP_SRCH>EXAMPLE@EMAIL.COM</SMTP_SRCH><URI_SRCH>WWW.TERRABELLA.COM</URI_SRCH><URI_ADDR>www.terrabella.com</URI_ADDR><STRAS>23576 AVE 96</STRAS></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>11</KUNNR><BUKRS>11</BUKRS><ZUAWA>11</ZUAWA><BUSAB>11</BUSAB><AKONT>11</AKONT><KNRZE>11</KNRZE><ZWELS>11</ZWELS><VZSKZ>11</VZSKZ><ZINRT>00</ZINRT><EIKTO>11</EIKTO><ZSABE>11</ZSABE><KVERM>11</KVERM><FDGRV>11</FDGRV><XAUSZ>11</XAUSZ><LOCKB>11</LOCKB><XEDIP>11</XEDIP><TLFXS>11</TLFXS><INTAD>11</INTAD><GUZTE>11</GUZTE><GRICD>11</GRICD><GRIDT>11</GRIDT><TLFNS>11</TLFNS></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055022797</KUNNR><TAXGR>111</TAXGR><ADRNR>0050161945</ADRNR><BAHNE>CDRCD159362</BAHNE><BAHNS>00000</BAHNS><BBBNR>0000000</BBBNR><BRSCH>000000</BRSCH><BUBKZ>0</BUBKZ><DATLT>00000</DATLT><FISKN>000000</FISKN><KONZS>000000</KONZS><KUKLA>000000</KUKLA><LIFNR>000000</LIFNR><LOCCO>A</LOCCO><SPRAS>E</SPRAS><STCD1>A</STCD1><STCD2>A</STCD2><STKZA>A</STKZA><STKZU>A</STKZU><STCEG>A</STCEG><VBUND/><KATR5>A</KATR5><STKZN>A</STKZN><FITYP>A</FITYP><STCDT>A</STCDT><STCD3>A</STCD3><STCD4>A</STCD4><J_1KFTBUS>A</J_1KFTBUS><MINDK>A</MINDK><TEL_NUMBER>(999)555-2350</TEL_NUMBER><TTX_NUMBER>333</TTX_NUMBER><TLX_NUMBER>444</TLX_NUMBER></PE_PERSONALDATA><PE_RETURN><TYPE/><ID/><NUMBER>000</NUMBER><MESSAGE/><LOG_NO/><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1/><MESSAGE_V2/><MESSAGE_V3/><MESSAGE_V4/></PE_RETURN><PE_SALESDATA><KUNNR/><VKORG/><VTWEG/><SPART/><BEGRU>888</BEGRU><VERSG>444</VERSG><KALKS>443</KALKS><BZIRK>333</BZIRK><KONDA>464</KONDA><AWAHR>000</AWAHR><ANTLF>0</ANTLF><AUTLF>424</AUTLF><KZTLF>242</KZTLF><KZAZU>234</KZAZU><LPRIO>00</LPRIO><VSBED>533</VSBED><MRNKZ>353</MRNKZ><PERFK>342</PERFK><PERRL>332</PERRL><KLABC>211</KLABC><KTGRD>119</KTGRD><ZTERM>865</ZTERM><VWERK>422</VWERK><VKGRP>325</VKGRP><VSORT>3563</VSORT><BOKRE>2255</BOKRE><KURST>3523</KURST><PRFRE>353</PRFRE><KABSS>242</KABSS><KKBER>4222</KKBER><RDOFF>4252</RDOFF><AGREL>35423</AGREL><MEGRU>5353</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>0.0</UEBTK><PVKSM>331</PVKSM><PODKZ>867</PODKZ><PODTG>0</PODTG><ZZSLOC>220</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>000</ZZ00CPBKMSG><ZZDUTYIND>00</ZZDUTYIND><ZZONBYDATE>000</ZZONBYDATE><SBU>00</SBU><SHIPPING_INSTR>11123</SHIPPING_INSTR><WAREHOUSE_INSTR>35436</WAREHOUSE_INSTR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR/><TAXGR>111</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR/><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKA>Third Bank of Wilmington</BANKA><STRAS>3131 Walnut St</STRAS><ORT01>Wilmington, 19104</ORT01><SWIFT/><BRNCH>City Hall Branch</BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>0055022797</KUNNR><BANKS>US</BANKS><BANKL>001802100</BANKL><BANKN>12345</BANKN><BKONT/><KOINH/><IBAN/></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055022797</KUNNR><PARNR>0000007299</PARNR><NAME1>Thompson</NAME1><ABTNR/><TELF1>009</TELF1><PAFKT/><TITEL_AP/><PRSNR>0051886247</PRSNR><SMTP_SRCH>FREDDYT@TERRABELLA.C</SMTP_SRCH><FAX_NUMBER>(302) 884-3838</FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055022797</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP/><KRAUS/><GRUPP/><SBDAT>0000-00-00</SBDAT><CASHC/><DBPAY/><DBRTG/><DBWAE/></PE_CONTROLDETAILS><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>AR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>BE</ALAND><TATYP>ZAO1</TATYP><TAXKD/></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>CH</ALAND><TATYP>ZAO3</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>FR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWAS</TATYP><TAXKD>3</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MWST</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>MX01</TATYP><TAXKD>9</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>MX</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>MWST</TATYP><TAXKD>0</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055022797</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE><ERROR_CODE> </ERROR_CODE></ERROR_CODE><ERROR_DESC><ERROR_DESC> </ERROR_DESC></ERROR_DESC></Response></getDetailResponse></Body></Envelope>';
        
        String ResponseXMLString ='<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><Y_GVCUSTOMER_GETDETAIL.Response xmlns="http://soap.sforce.com/schemas/class/GVCustomerGetDetail"><Response><PE_ADDRESSDATA><ADDRNUMBER>0000145318</ADDRNUMBER><DATE_FROM>0001-01-01</DATE_FROM><NATION></NATION><NAME1>VISHAY DALE ELECTRONICS INC</NAME1><NAME2>VISHAY DALE ELECTRONICS INC-2</NAME2><NAME3>VISHAY DALE ELECTRONICS INC-3</NAME3><NAME4>VISHAY DALE ELECTRONICS INC-4</NAME4><CITY1>COLUMBUS</CITY1><CITY2>POLK</CITY2><CITYP_CODE></CITYP_CODE><PO_BOX>609</PO_BOX><TRANSPZONE>0000000015</TRANSPZONE><HOUSE_NUM1>2222222</HOUSE_NUM1><HOUSE_NUM2>1111111</HOUSE_NUM2><REGION>13</REGION><SORT1>DALCOLDAL</SORT1><TEL_NUMBER>123456789</TEL_NUMBER><FAX_NUMBER>987654321</FAX_NUMBER><EXTENSION1>abcd</EXTENSION1><EXTENSION2>987654321</EXTENSION2><SMTP_SRCH>ABC@EMAIL.COM</SMTP_SRCH><URI_SRCH>HOMEPAGE@Dupont.COM</URI_SRCH><URI_ADDR>homepage@Dupont.com</URI_ADDR><STRAS>1122 23RD STREET-PLANT #2</STRAS><COUNTRY>JP</COUNTRY><PO_BOX_LOC>Other</PO_BOX_LOC><POST_CODE1>68601</POST_CODE1><LCL_LANGU>E</LCL_LANGU><LCL_NAME1>VISHAY DALE ELECTRONICS INC</LCL_NAME1><LCL_NAME2>VISHAY DALE ELECTRONICS INC-2</LCL_NAME2><LCL_NAME3>VISHAY DALE ELECTRONICS INC-3</LCL_NAME3><LCL_NAME4>VISHAY DALE ELECTRONICS INC-4</LCL_NAME4><LCL_EXTENSION1>abcd</LCL_EXTENSION1><LCL_CITY1>oou</LCL_CITY1><LCL_CITY2>oot</LCL_CITY2><LCL_HOUSE_NUM1>2222</LCL_HOUSE_NUM1><LCL_POST_CODE1>68601</LCL_POST_CODE1><LCL_REGION>13</LCL_REGION><LCL_SORT1>DALCOLDAL</LCL_SORT1><LCL_STREET>sss</LCL_STREET><LCL_EXTENSION2>987654321</LCL_EXTENSION2></PE_ADDRESSDATA><PE_COMPANYDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><ZUAWA>009</ZUAWA><BUSAB>VR</BUSAB><AKONT>0012101000</AKONT><KNRZE>0055001120</KNRZE><ZWELS>E</ZWELS><VZSKZ>TRUE</VZSKZ><ZINRT>01</ZINRT><EIKTO>123454321</EIKTO><ZSABE>10234</ZSABE><KVERM>Testing</KVERM><FDGRV>E2</FDGRV><XAUSZ>2</XAUSZ><LOCKB>EBO</LOCKB><XEDIP>TRUE</XEDIP><TLFXS>no. 123456789</TLFXS><INTAD>abc@abc.com</INTAD><GUZTE></GUZTE><GRICD></GRICD><GRIDT></GRIDT><TLFNS>123456789</TLFNS><LOEVM>X</LOEVM><SPERR>X</SPERR></PE_COMPANYDATA><PE_PERSONALDATA><KUNNR>0055110426</KUNNR><ADRNR>0000145318</ADRNR><BAHNE>Express station</BAHNE><BAHNS>Train station</BAHNS><BBBNR>0012345</BBBNR><BRSCH>FINS</BRSCH><BUBKZ>0</BUBKZ><DATLT>abcd</DATLT><FISKN>0055000943</FISKN><KONZS>1235</KONZS><KUKLA>01</KUKLA><LIFNR>0000001453</LIFNR><LOCCO>123456</LOCCO><SPRAS>E</SPRAS><STCD1></STCD1><STCD2></STCD2><STKZA>TRUE</STKZA><STKZU>TRUE</STKZU><STCEG>123 456789</STCEG><VBUND>06</VBUND><KATR5>D</KATR5><STKZN>TRUE</STKZN><FITYP>22</FITYP><STCDT></STCDT><STCD3>STCD3</STCD3><STCD4>STCD4</STCD4><J_1KFTBUS></J_1KFTBUS><MINDK></MINDK><TEL_NUMBER>123456789</TEL_NUMBER><TTX_NUMBER>987654321</TTX_NUMBER><TLX_NUMBER>987654321</TLX_NUMBER><KTOKD>Z001</KTOKD><LOEVM>X</LOEVM><BBSNR>01234</BBSNR><SPERR>X</SPERR><CASSD>X</CASSD></PE_PERSONALDATA><PE_RETURN><TYPE></TYPE><ID></ID><NUMBER>000</NUMBER><MESSAGE></MESSAGE><LOG_NO></LOG_NO><LOG_MSG_NO>000000</LOG_MSG_NO><MESSAGE_V1></MESSAGE_V1><MESSAGE_V2></MESSAGE_V2><MESSAGE_V3></MESSAGE_V3><MESSAGE_V4></MESSAGE_V4></PE_RETURN><PE_SALESDATA><KUNNR>0055110426</KUNNR><VKORG>F450</VKORG><VTWEG>10</VTWEG><SPART>02</SPART><BEGRU>ZTXZ</BEGRU><VERSG>1</VERSG><KALKS>1</KALKS><BZIRK>USF3F4</BZIRK><KONDA>Z2</KONDA><AWAHR>100</AWAHR><ANTLF>0</ANTLF><AUTLF>TRUE</AUTLF><KZTLF>TRUE</KZTLF><KZAZU>TRUE</KZAZU><LPRIO>00</LPRIO><VSBED>11</VSBED><MRNKZ>TRUE</MRNKZ><PERFK>ZZ</PERFK><PERRL>ZZ</PERRL><KLABC>AB</KLABC><KTGRD>01</KTGRD><ZTERM>Y030</ZTERM><VWERK>YF12</VWERK><VKGRP>US6</VKGRP><VSORT>7500003828</VSORT><BOKRE>TRUE</BOKRE><KURST>M</KURST><PRFRE>TRUE</PRFRE><KABSS>ZZZZ</KABSS><KKBER>2350</KKBER><RDOFF>TRUE</RDOFF><AGREL>TRUE</AGREL><MEGRU>UNTE</MEGRU><UEBTO>0.0</UEBTO><UNTTO>0.0</UNTTO><UEBTK>TRUE</UEBTK><PVKSM>Z5</PVKSM><PODKZ>TRUE</PODKZ><PODTG>0</PODTG><ZZSLOC>1201</ZZSLOC><ZZ00ORGBOL>00</ZZ00ORGBOL><ZZ00CPYBOL>00</ZZ00CPYBOL><ZZ00CPBKMSG>FALSE</ZZ00CPBKMSG><ZZDUTYIND>TRUE</ZZDUTYIND><ZZONBYDATE>BY</ZZONBYDATE><SBU></SBU><SHIPPING_INSTR>SHELF LIFE TO APPEAR ON ALL LABELS PER B. NISSAN</SHIPPING_INSTR><WAREHOUSE_INSTR>Warehouse Instructions</WAREHOUSE_INSTR><VTEXT>·¢Æ±ÈÕÆð30ÌìÄÚ¸¶¿î</VTEXT><BEZEI20>A Material</BEZEI20><CTEXT>Standard</CTEXT><GTEXT>Consumer</GTEXT><BEZEI></BEZEI><STEXT>Air Consolidated</STEXT><LTEXT>365 W/D - All Days/Work Days - 7 by 24</LTEXT><ITEXT>365 W/D - All Days/Work Days - 7 by 24</ITEXT><ATEXT>Domestic Revenues</ATEXT><CURVW>Standard translation at average rate</CURVW><PEZEI>No Payment Guarantee Required</PEZEI><PTEXT>Item Prop. (No Hist)</PTEXT><DDTEXT>Create a delivery with qty greater than zero</DDTEXT><ZZTEXT>Req. Del. date BY</ZZTEXT><FAKSD>08</FAKSD><KVGR1>Y</KVGR1><KVGR2>A05</KVGR2><KVGR3>SEZ</KVGR3><KVGR4>A23</KVGR4><KVGR5>A12</KVGR5><LOEVM>X</LOEVM><LIFSD>08</LIFSD><INCO1>142</INCO1><INCO2>FOB SHIPPOINT</INCO2><PLTYP>A6</PLTYP><CASSD>X</CASSD><VKBUR>F400</VKBUR></PE_SALESDATA><PE_TAXGROUPINGS><KUNNR>0055110426</KUNNR><TAXGR>IBZ</TAXGR><SBJDF>0000-00-00</SBJDF><SBJDT>0000-00-00</SBJDT><EXNR></EXNR><EXRT>0.00</EXRT><EXDF>0000-00-00</EXDF><EXDT>0000-00-00</EXDT></PE_TAXGROUPINGS><PE_BANKDATA><BANKS>NON</BANKS><BANKL></BANKL><BANKA></BANKA><STRAS></STRAS><ORT01></ORT01><SWIFT></SWIFT><BRNCH></BRNCH></PE_BANKDATA><PE_BANKDETAILSDATA><KUNNR>NONE</KUNNR><BANKS></BANKS><BANKL></BANKL><BANKN></BANKN><BKONT></BKONT><KOINH></KOINH><IBAN></IBAN></PE_BANKDETAILSDATA><PE_CONTACTPARTNER><KUNNR>0055110426</KUNNR><PARNR>0000016647</PARNR><NAME1>ABC</NAME1><ABTNR>0003</ABTNR><TELF1></TELF1><PAFKT>03</PAFKT><TITEL_AP></TITEL_AP><PRSNR>0001796770</PRSNR><SMTP_SRCH></SMTP_SRCH><FAX_NUMBER></FAX_NUMBER></PE_CONTACTPARTNER><PE_CONTROLDETAILS><KUNNR>0055110426</KUNNR><KKBER>2350</KKBER><KLIMK>1.00</KLIMK><CTLPC>Z99</CTLPC><SBGRP>00P</SBGRP><KRAUS>987654321</KRAUS><GRUPP>B200</GRUPP><SBDAT>2015-04-21</SBDAT><CASHC></CASHC><DBPAY>125</DBPAY><DBRTG>12456</DBRTG><DBWAE>ARS</DBWAE><REVDB>2015-04-01</REVDB><DTREV>2015-04-07</DTREV><NXTRV>2015-04-21</NXTRV></PE_CONTROLDETAILS><PE_DUNNINGDATA><KUNNR>0055110426</KUNNR><BUKRS>2350</BUKRS><MABER></MABER><MAHNA>0003</MAHNA><BUSAB>0K</BUSAB></PE_DUNNINGDATA><PE_LOADINGPOINTS><KUNNR>0055110426</KUNNR><ABLAD>US</ABLAD><DEFAB></DEFAB></PE_LOADINGPOINTS><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>CN</ALAND><TATYP>ZCC1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>DE</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>GB</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>IE</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>JP</ALAND><TATYP>ZCJ1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>KR</ALAND><TATYP>ZCK1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>PR</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZAO1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>TW</ALAND><TATYP>ZTW1</TATYP><TAXKD></TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>UTXJ</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><PE_TAXINDICATOR><KUNNR>0055110426</KUNNR><ALAND>US</ALAND><TATYP>ZAO1</TATYP><TAXKD>1</TAXKD></PE_TAXINDICATOR><ERROR_CODE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_CODE><ERROR_DESC xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"></ERROR_DESC></Response></Y_GVCUSTOMER_GETDETAIL.Response></Body></Envelope>';
        controller.parseWebserviceResponse(ResponseXMLString); 
         
        controller.currentUserProfile();
        controller.queryPublicGroup();
        controller.populateRequestorInformation();
        controller.fetchRecordTypeName();
        controller.Done();
        controller.FormRenderValidation();
        controller.populateAccountInformation(acc.id);
         
       controller.fetchAccountDetails(acc.id);
        
        controller.OnboardingReq.Customer__c = ERPCust.id;
      controller.fetchCustomerInformation(ERPCust.id);
        test.stopTest();
        controller.populateExistingCustomerInformation();
        
        controller.OnboardingReq.Bank_statement__c = '120';
        controller.fieldmodified(); 
        
        controller.OnboardingReq.Leveraged_CSR__c = true;
        //controller.OnboardingReq.Assigned_to_Leverage_CSR__c = false;
        controller.OnboardingReq.Request_Status__c = 'Request Completed in SAP';
        
        controller.OnboardingReq.Proposed_Terms_of_Payment__c='CIA-Payment in Advance';
        controller.OnboardingReq.Proposed_Credit_limit__c='111';
        
        controller.RequestFlow();
     
        controller.Cancel();
        controller.CancelAndClose();
        controller.RedirectCancelAndClose();
        controller.IsSaveOrSubmit='Save';
        controller.SaveAndSubmit();
        controller.IsSaveOrSubmit='Submit';
        controller.SaveAndSubmit();
        controller.getItems();
        controller.requireCreditApproval();
        controller.checkPOD();
        controller.RelatedlistItemsValidation();
        controller.checkLocalLanguage();
        controller.fetchRegionValues();
        controller.fetchLocalRegionValues();
        controller.PrepopulateCreditLimit();
        controller.fetchCountryCode();
        controller.CopyProposedToApprovedCredit(controller.OnboardingReq);
        controller.OnboardingReq.recordTypeId = ModifyExisting_COB_RTYPE;
        controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
        controller.creditValidationModify();
        
        
        controller.OnboardingReq.Leveraged_CSR__c = false;
        controller.OnboardingReq.Account_Group__c = 'Z001 ( Sold-to party )';
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.RequestFlow();
        
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE; 
        controller.OnboardingReq.Sold_to_Country__c='MY - Malaysia';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='0078 - ELECT. MATLS DUP DONGGUAN';
         controller.OnboardingReq.Telebox__c=null;
         Controller.OnboardingReq.Teletex_Number__c=null;
         controller.OnboardingReq.Tax_number_5__c=null;
         controller.OnboardingReq.Estimated_Average_Monthly_Purchases__c=null;
         controller.OnboardingReq.Estimated_Number_of_Orders_per_Month__c=null;   
            controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.local_version__c='arabic'; 
         controller.openLocalLanguagePanel=false;
         controller.OnboardingReq.Customer_Name__c.length(); 
         controller.OnboardingReq.Customer_Name_2__c.length();             
         controller.OnboardingReq.Customer_Name_3__c.length();                         
         controller.OnboardingReq.Customer_Name_4__c.length();                         
         controller.OnboardingReq.Local_Customer_Name_1__c.length();
         controller.OnboardingReq.Local_Customer_Name_2__c.length();
         controller.OnboardingReq.Local_Customer_Name_3__c.length();
         controller.OnboardingReq.Local_Customer_Name_4__c.length();   
         controller.OnboardingReq.Data_line__c=null;
         controller.RequiredValidations();
          
        controller.OnboardingReq.RecordTypeId = NewCustomer_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='MY - Malaysia';
        controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='3940 - DUP MALAYSIA';
         controller.OnboardingReq.Invoice_Type__c='VAT';
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Telebox__c=null;
         controller.OnboardingReq.Sold_to_e_mail__c=null;
         controller.OnboardingReq.Registration_number__c=null;
         controller.OnboardingReq.Local_Version__c='chinese'   ;
         controller.openLocalLanguagePanel=true;
         controller.OnboardingReq.Local_Customer_Name_1__c.length();
         controller.OnboardingReq.Local_Customer_Name_2__c.length();
         controller.OnboardingReq.Local_Customer_Name_3__c.length();
         controller.OnboardingReq.Local_Customer_Name_4__c.length();
         controller.OnboardingReq.Local_Language_Street__c.length();   
         controller.RequiredValidations() ;
          controller.OnboardingReq.Local_Version__c='Chinese';
          controller.RequiredValidations() ;
          controller.OnboardingReq.RecordTypeId = ModifyExisting_COB_RTYPE ;
        controller.OnboardingReq.Sold_to_Country__c='MY - Malaysia';
         controller.OnboardingReq.Customer_Currency__c ='CNY - Chinese Renminbi' ;
         controller.OnboardingReq.Company_Code__c='3940 - DUP MALAYSIA';
         controller.OnboardingReq.Fields_Modified_2__c='Proposed Credit Limit';
         controller.OnboardingReq.Invoice_Type__c='VAT';
            controller.OnboardingReq.Local_Version__c='chinese'   ;
            controller.openLocalLanguagePanel=true;
         controller.OnboardingReq.Data_line__c=null;
         controller.OnboardingReq.Tax_code_1__c=null;
         controller.OnboardingReq.Sold_to_telephone__c=null;   
         controller.OnboardingReq.Teletex_Number__c=null;
         controller.OnboardingReq.Proposed_Credit_Limit__c=null;
           
         controller.OnboardingReq.Account_Group__c  ='Z001 ( Ship-to party )'; 
        controller.RequiredValidations();
         controller.validateFieldModified(); 
        
        }
    }
    }
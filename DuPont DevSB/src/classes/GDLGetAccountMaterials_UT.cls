/*****************************************************************************
Author: Rohit saini
Email: rohitkumar.saini@tcs.com
Description:  test class of GDLGetAccountMaterials class in GDL periodic activity

********************************************************************************/
@isTest
public class GDLGetAccountMaterials_UT {

@isTest
    private static void testDoPost(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        insertTestData();
       
        RecordType rt=[select id from RecordType where developerName='BI_Surfaces' 
                      and SObjectType='Account'Limit 1];
       
      Account a2=new Account(name='test NA', BI_Account_SubType__c ='Dealer', recordTypeid=rt.id, Region__c='North America', Locators__c='BI-Surf Retailer Locator', 
                             ShippingLatitude__c=2.0,ShippingLongitude__c=34.9, ShippingStreet='', Account_Stage__c='Active',  ShippingCity='test',
                             ShippingState='', ShippingCountry='test', ShippingPostalCode='123456', Owning_Organization__c='BI-Env',Type='Indirect Customer', Rating='test', ShippingFIPS__c='te', ShippingAddressAccuracy__c='tes' );
     
      insert a2;
      
      RecordType rt2=[select id from RecordType where developerName='BI_Tyvek' 
                      and SObjectType='Account'Limit 1];
         
      Account a3=new Account(name='test NA',  BI_Account_SubType__c ='', recordTypeid=rt2.id, Region__c='North America', Locators__c='BI-Surf Retailer Locator', 
                              ShippingLatitude__c=2.0,ShippingLongitude__c=34.9,Account_Stage__c='Active', ShippingStreet='test"test', ShippingCity='',
                             ShippingState='test', ShippingCountry='', ShippingPostalCode='', Owning_Organization__c='',Type='', Rating='Platinum', Fax='1234567', Phone='12345678' );
     
      insert a3;

        Material__c materialvalue= new Material__c(name='BI Authorization',Owning_Org__c='BI');
        insert materialvalue;
  
        Account_Material__c accountMaterial1 = new Account_Material__c(Account_Name__c=a2.id,Line_Description__c='test desc',Product_Name__c=materialvalue.id);
        Account_Material__c accountMaterial2 = new Account_Material__c(Account_Name__c=a3.id,Line_Description__c='test desc',Product_Name__c=materialvalue.id);
        insert new LIST<Account_Material__c> {accountMaterial1,accountMaterial2};

       
        
        req.requestURI = '/services/oauth2/token/services/apexrest/GetAccountMaterials';  
        req.httpMethod = 'GET';
        req.addParameter('type', 'Surfaces');
        RestContext.request = req;
        RestContext.response = res;
        GDLGetAccountMaterials.GetAccountMaterialIds();
        
        req.addParameter('type', 'Tyvek');
        RestContext.request = req;
        RestContext.response = res;
        GDLGetAccountMaterials.GetAccountMaterialIds();
        
        req.httpMethod = 'Post';
        string requestBody='{  "records" : [ {'+
                            ' "accMatId" : "'+accountMaterial1.id+'"  },'+
                                '{ "accMatId" : "'+accountMaterial2.id+'"  } ]}';
        req.requestBody=Blob.valueof(requestBody);
        RestContext.request = req;
        RestContext.response = res;
        GDLGetAccountMaterials.GDLGetAccountMaterials();
      
        
        
    }  
    
  public static void  insertTestData(){
      
        List<GDLActivityAutomation__c> gdlSettingList=new List<GDLActivityAutomation__c>();
        gdlSettingList.add(new GDLActivityAutomation__c(Name='AcctMatrlids_Surf', Setting_Name__c='AcctMatrlids_Surf', Value__c='Select Id FROM Account_Material__c where Account_Name__r.Region__c=\'North America\' and Account_Name__r.recordtype.name in (\'BI - Surfaces\') and Account_Name__r.ShippingLatitude__c!=null and Account_Name__r.ShippingLongitude__c!=null and'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='AcctMatrlids_Surf2', Setting_Name__c='AcctMatrlids_Surf', Value__c='Account_Name__r.Account_Stage__c!=\'Inactive\' and Account_Name__r.Locators__c!=null'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='AcctMatrlids_Tyvek', Setting_Name__c='AcctMatrlids_Tyvek', Value__c='Select Id FROM Account_Material__c where Account_Name__r.Region__c=\'North America\' and Account_Name__r.recordtype.name in (\'BI - Tyvek\') and Account_Name__r.ShippingLatitude__c!=null and Account_Name__r.ShippingLongitude__c!=null and'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='AcctMatrlids_Tyvek2', Setting_Name__c='AcctMatrlids_Tyvek', Value__c='Account_Name__r.Account_Stage__c!=\'Inactive\' and Account_Name__r.Locators__c!=null'));
        
      gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsEMEA', Setting_Name__c='GetAccountIdsEMEA', Value__c='select id, Accountid from Contact where ( Account.Mb_of_Marketing_Program__c includes (\'Dealer Locator\') and Role__c=\'Company Mailing Address\' and Region__c=\'EMEA\' and Account.Account_Stage__c!=\'Inactive\' and'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsEMEA2', Setting_Name__c='GetAccountIdsEMEA', Value__c='( (Account.Product_2__c includes (\'Corian\') and Account.Country__c in (\'FRANCE\',\'GERMANY\',\'IRELAND\', \'UNITED KINGDOM\')) or (Account.Product_2__c includes (\'Montelli\') and Account.Country__c=\'RUSSIAN FEDERATION\') or'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsEMEA3', Setting_Name__c='GetAccountIdsEMEA', Value__c='(Account.Product_2__c=\'Corian\' and Account.Country__c=\'SPAIN\')))'));
    
      gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsNA', Setting_Name__c='GetAccountIdsNA', Value__c='select Id from Account where BI_Account_SubType__c IN (\'Dealer\',\'Fabricating Retailer\',\'Retailer\') AND (((RecordType.developerName IN (\'BI_Surfaces\',\'BI_Tyvek\') AND Region__c=\'North America\' AND'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsNA2', Setting_Name__c='GetAccountIdsNA', Value__c='Locators__c INCLUDES (\'BI-Surf Retailer Locator\',\'BI-Env Dealer Locator\') AND ShippingLatitude__c!=NULL AND ShippingLongitude__c!=NULL AND Account_Stage__c!=\'Inactive\' AND (ShippingStreet!=NULL OR ShippingCity!=NULL'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountIdsNA3', Setting_Name__c='GetAccountIdsNA', Value__c='OR ShippingState!=NULL OR ShippingCountry!=NULL OR ShippingPostalCode!=NULL)) AND Owning_Organization__c IN (\'BI-Env\',\'BI-Surf\')) AND Type=\'Indirect Customer\')'));
    
      gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountsEMEA1', Setting_Name__c='GetAccountsEMEA', Value__c='select Accountid, Account.Name, Account.Country__c,MailingStreet,MailingCity,MailingState,MailingPostalCode, Account.BillingAddressAccuracy__c,Email,Account.BillingLatitude__c,Account.BillingLongitude__c,Account.Phone,Account.Fax, Account.BillingFIPS__c,'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountsEMEA2', Setting_Name__c='GetAccountsEMEA', Value__c='Account.Website, Account.Owning_Organization__c, Account.Type, Account.BI_Account_SubType__c from Contact'));
      
      gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAccountsNA', Setting_Name__c='GetAccountsNA', Value__c='select Id,Name,Owning_Organization__c,Type,BI_Account_SubType__c,ShippingLatitude__c,ShippingLongitude__c,ShippingFIPS__c,ShippingAddressAccuracy__c,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,Rating,fax,Phone from Account'));
        gdlSettingList.add(new GDLActivityAutomation__c(Name='GetAcctMatrls', Setting_Name__c='GetAcctMatrls', Value__c='Select Id,Account_Name__c,Account_Name__r.name,Product_Name__c,Product_Name__r.name FROM Account_Material__c where Id IN :accMatIds'));
      
      insert  gdlSettingList;
      
    }
}
/*******************************************************************************
Copyright © 2017 DuPont. All rights reserved. 
Author: Shyam Bansal
Email: bansal.shyam@tcs.com
Description:  Unit Test(s) for : ctrlAutoComplete_Products
//[01202017] Merge&Spin: created test class for ctrlAutoComplete_Products class.
/*******************************************************************************/
@isTest
public class ctrlAutoComplete_Products_UT {
    public static testMethod void test1(){
        pricebook2 pbook=new pricebook2(name='testpbook1');
        insert pbook;
        RecordType recPro = Rtype.getRecordTypeByDevName('Product2', 'OneDuPontProduct');
        Product2 prodObj1 =new Product2(Name ='testProduct1',CanUseQuantitySchedule=true,CanUseRevenueSchedule = true, Product_L4__c='MECH', RecordTypeId = recPro.Id, family = 'ELEC',PRODUCTCODE='LCPSQ', ISACTIVE = True, CURRENCYISOCODE = 'USD', Description = 'TestDescription');
        insert prodObj1;
        pricebookentry pent=new pricebookentry(product2id=prodObj1.id,isActive=true,unitprice=20,pricebook2id=Test.getStandardPricebookId(),currencyIsoCode = 'USD');
        insert pent;
        ctrlAutoComplete_Products.Search('testProduct1', Test.getStandardPricebookId() , 'USD') ;
        ctrlAutoComplete_Products.getProducts('testProduct1', Test.getStandardPricebookId(), 'USD', 'R', '2');
         ctrlAutoComplete_Products.getProducts('testProduct1', Test.getStandardPricebookId(), 'USD', 'Q', '2');
    }
}
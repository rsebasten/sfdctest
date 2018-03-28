/*******************************************************************************
Copyright Â© 2012 DuPont. All rights reserved. 
Author: Vijay Laxmi
Email: vijay.laxmi1@tcs.com
Description:  Unit testclass for trigLeadParseW2LExtendedData on 20170428
   
********************************************************************************/

@isTest
public class trigLeadParseW2LExtendedData_UT{
    public static testMethod void testtrigLeadParseW2LExtendedData(){

        Campaign camp = new Campaign(name='Test MemberPortal Campaign ');
        insert camp;        

        SiteObject__c so = new SiteObject__c(Name='Test MP', PublicName__c='Test MP',
             RecordTypeId=MemberPortal.RTYPE_SO_MEMBERPORTAL,
             IsPublic__c=true, ExternalId__c='00Dundefined',campaign__c=camp.id, ReturnUrl__c='apex/somepage');
        insert so;

        Lead l=new Lead();
        l.Owning_SBU__c='Chemicals & Fluoroproducts';
        l.Owning_Organization__c='DCF-ChemSol';
        l.Country='India';
        l.Region__c='Acia Pacific';
        l.FirstName='From';
        l.LastName='TestClass';
        l.Company='Dupont';
        l.W2L_ExtendedData__c = '00Dundefined:yes';
        l.Type__c='Literature';
        l.status='Qualify';
        l.email = 'test@test.com';
        insert l;   
    }
}
/*******************************************************************************
Copyright © 2016 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Test Class for ExternalInitiativeHandler Handler class
15-March-2016 : Created to increase code coverage of ExternalInitiativeHandler Class

<AS20160919>
Modified By: Arjun Sharma
Modification Date: 19-Sept-2016
Modification: Record type name 'BI-NA External Initiative' changed to 'BI External Initiative' and
Data Source 'Dodge' is added to create External Initiative for CPSF

<AS20161015>
Modification: Record type name is reverted as per business requirement.
********************************************************************************/
@isTest(seeAllData=false)
public class ExternalInitiativeHandler_UT {
    static testMethod void testEIH() {
        try{
            Test.startTest();
            String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'External_Initiative__c' and Name = 'BI-NA External Initiative'].Id;//<AS20161015>
            List<External_Initiative__c> cps = new List<External_Initiative__c>();
            cps.add(new External_Initiative__c(name='S2S Test EI QA Tyvek - 01',State__c='DE', County__c='New Castle',External_ID__c='01TEST15032016', External_Version__c=1, External_Search_Name__c='Tyvek,Surfaces',Stage__c='Bid',Owning_Organization__c='BI',RecordTypeId=strRecordTypeId,Segment_L1__c='Test',Segment_L2__c='Warehouse Other1',Segment_L3__c='Building Additions',Segment_L4__c='Test',Specification_L1__c='Test',Specification_L2__c='Test',Value__c=20000000,Data_Source__c='Dodge'));//<AS20160919>
           
            insert cps;
            External_Initiative__c ei = [Select name,State__c,County__c,External_ID__c,External_Version__c,External_Search_Name__c,Stage__c,Owning_Organization__c,RecordTypeId,Segment_L1__c,Segment_L2__c,Segment_L3__c,Segment_L4__c,Specification_L1__c,Specification_L2__c,Value__c from External_Initiative__c where External_ID__c='01TEST15032016'];
            ei.Specification_L2__c='Test Update';
            upsert ei;
            Test.stopTest();
            
        }catch(Exception e){
            system.debug('--->>>Exception Occured '+e.getStackTraceString());
        }
    }
}
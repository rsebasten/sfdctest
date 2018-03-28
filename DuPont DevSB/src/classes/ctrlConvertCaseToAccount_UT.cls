/*
 * 26/12/2016 Merge&Spin - Removed (SeeAllData=true)
*/

@isTest
public class ctrlConvertCaseToAccount_UT {
    Final static Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
    Final static Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
      
    public static testmethod void unitest1(){
        String caseId=createTestData();
        //[20170103] Merge&Spin: Load test data for custom setting
        List<SObject> lstobjectFieldMapping = Test.loadData(Object_Field_ID_Mapping__c.sObjectType,'ObjectFieldIDMapping');
        PageReference pageRef = Page.ConvertCaseToAccount;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('id',caseId);
        test.startTest();
        ctrlConvertCaseToAccount convert=new ctrlConvertCaseToAccount();
        convert.selectedChoice='Use existing Account';
        convert.redirect();
        convert.searchText='';
        convert.redirect();
        convert.searchText='prospect';
        convert.redirect();
        convert.selectedChoice='Create new Account';
        convert.redirect();
        test.stopTest();
        
    }
    
    public static ID createTestData(){
        
       BPD_Sample_Settings__c bpd1 = new BPD_Sample_Settings__c();
       bpd1.Name='abc';
       bpd1.Distinguisher_Field__c='Brand';
       bpd1.Owning_Org__c='test';
       insert bpd1;
       
        Date d = Date.newinstance(2014, 12, 27);
        // Merge&Spin - Create Test Custom Setting data
//PKH        Svmx_TestData_Util_UT.createCustomSettingData();
              
        Case cas1 = new Case();
        cas1.Owning_SBU__c='Building Innovations';
        cas1.Priority='Low';
        cas1.RecordTypeId = CaseRecordType;
        cas1.Country__c='India';
        insert cas1;
        
        
        Case_Details__c  c1= new Case_Details__c();
        c1=[select id from Case_Details__c where Related_Case__c = :cas1.Id];
        c1.Type_of_Record__c='Web';
        c1.How_Trademark_is_Used__c='Company Name';
        c1.Infringement_Type__c='Copyright';
        c1.Infringing_Product_Description__c='aaa';
        c1.Company__c='bbb';
        c1.Procedural_Status__c='Legal - In Progress';
        c1.Address__c='abc';
        c1.City__c='d';
        c1.State__c='e';
        c1.Website__c='test.com';
        c1.Phone__c='123456789';
        c1.Fax__c='123456789';
        c1.Target_Country__c='i';
        c1.Zip_Postal_Code__c='100';
        c1.Crop_Phase_Status__c='Incident';
        c1.RecordTypeId = CaseDetailsRecordType;
       
        update c1;
        
        
        return cas1.id;
    }

}
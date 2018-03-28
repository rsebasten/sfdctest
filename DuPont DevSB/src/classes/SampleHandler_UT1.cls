@isTest(seealldata=false)
private class SampleHandler_UT1{
    public static final Id CropSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c', 'Brand_Protection_Abuse_Sample');
    static testMethod void testmethod1(){ 
        test.startTest(); 
        BPD_Sample_Settings__c bd = new BPD_Sample_Settings__c();
        bd.Name='Flupysulfuron methyl (FLU)';
        bd.Abbreviation__c='FLU';
        bd.Distinguisher_Field__c='Country';
       insert bd;
       BPD_Sample_Settings__c bd1 = new BPD_Sample_Settings__c();
        bd1.Name='INDIA';
        bd1.Abbreviation__c='IND';
        bd1.Distinguisher_Field__c='Country';
       insert bd1;
       /*
        SVMXListSettings__c sv = new SVMXListSettings__c(Name='WarrantyLA',Static_Value__c = 'WarrantyLA');
        insert sv;
        SVMXListSettings__c sv1 = new SVMXListSettings__c(Name='ContractLA',Static_Value__c = 'WarrantyLA');
        insert sv1;
        SVMXListSettings__c sv2 = new SVMXListSettings__c(Name='BillableEMEA',Static_Value__c = 'WarrantyLA');
        insert sv2;
        SVMXListSettings__c sv3 = new SVMXListSettings__c(Name='WarrantyEMEA',Static_Value__c = 'WarrantyLA');
        insert sv3;
        SVMXListSettings__c sv4 = new SVMXListSettings__c(Name='Hardware ServiceEMEA',Static_Value__c = 'WarrantyLA');
        insert sv4;
        SVMXListSettings__c sv5 = new SVMXListSettings__c(Name='Hardware SalesEMEA',Static_Value__c = 'WarrantyLA');
        insert sv5;
        SVMXListSettings__c sv6 = new SVMXListSettings__c(Name='ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv6;
        SVMXListSettings__c sv7 = new SVMXListSettings__c(Name='Uptime ContractTypeEMEA',Static_Value__c = 'WarrantyLA');
        insert sv7;
        SVMXListSettings__c sv8 = new SVMXListSettings__c(Name='Uptime ContractEMEA',Static_Value__c = 'WarrantyLA');
        insert sv8;
        */
            Case cs=new Case(Status='Close',Type='Support',Origin='Phone',Reason='EMC',Owning_Organization__c='DEC-Packaging Graphics',Priority='Medium');
            insert cs;
        
        Case_Details__c cd = new Case_Details__c ();
        cd.Related_Case__c =cs.id;
        cd.Address__c='hiiii';
        insert cd;
          
        Trademark_Abuse_Sample__c tas = new Trademark_Abuse_Sample__c();
        tas.Sample_Name__c='444444444';
        tas.Address__c ='sample address';
        tas.Batch_Number__c ='test';
        tas.Country__c ='INDIA';
        
        tas.recordtypeid= CropSample;
        tas.Active_Ingredients__c='Flupysulfuron methyl (FLU)';
        tas.Identification_Date__c= date.newInstance(2014, 5, 6);
        insert tas;
        
        Trademark_Abuse_Sample__c tas1 = new Trademark_Abuse_Sample__c();
        tas1.Sample_Name__c='444444444';
        tas1.Address__c ='sample address';
        tas1.Batch_Number__c ='test';
        tas1.Country__c ='INDIA';
        
        tas1.recordtypeid= CropSample;
        tas1.Active_Ingredients__c='Flupysulfuron methyl (FLU)';
        tas1.Identification_Date__c= date.newInstance(2014, 5, 6);
        insert tas1;
        
        tas.Country__c ='CHINA';
        update tas;
        
        tas.Case__c=cs.id;
        update tas;
        
        test.stopTest();
        
    }

}
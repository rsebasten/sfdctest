@isTest

/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Sreedhar T Jagannath
Email: Sreedhar.Jagannath@ind.dupont.com
Description: Unit test class for the class ctrlHierarchy
********************************************************************************/

private class ctrlHierarchy_UT {
    
    static testMethod void ctrlHierarchy_UT ()
        { 
        //[01022017] Merge&Spin: Replaced Hard coding of Record type Id
            string AGCP_CPC_EMEA_Moderate_RType = RType.getIdByDevName('Account','DPT_Car_Protect');
            Account testAccount = new Account(Name='Test',Type='Distributor',Account_Stage__c='Active',Program__c='CPC',Country__c='France',Owning_Organization__c='AGC-CPC',RecordTypeId=AGCP_CPC_EMEA_Moderate_RType );
            insert testAccount;

            Account  testAccount1 = new Account(Name='Test1',Type='Distributor',Account_Stage__c='Active',Program__c='CPC',Country__c='France',Owning_Organization__c='AGC-CPC',RecordTypeId=AGCP_CPC_EMEA_Moderate_RType ,Member_of_Association__c='Regional2');
            insert testAccount1;

            Account testAccount2 = new Account(Name='Test2',Type='Distributor',Account_Stage__c='Active',Program__c='CPC',Country__c='France',Owning_Organization__c='AGC-CPC',RecordTypeId=AGCP_CPC_EMEA_Moderate_RType ,Member_of_Association__c='Regional1');
            insert testAccount2;

            Account  testAccount3 = new Account(Name='Test3',Type='Distributor',Account_Stage__c='Active',Program__c='CPC',Country__c='France',Owning_Organization__c='AGC-CPC',RecordTypeId=AGCP_CPC_EMEA_Moderate_RType ,Member_of_Association__c='National');
            insert testAccount3;

                Partner partner = new Partner(
                Role='Distributor Of',AccountFromId=testAccount.Id,AccountToId=testAccount1.Id);
                insert partner;
    
                Partner partner1 = new Partner(
                Role='Distributor Of',AccountFromId=testAccount1.Id,AccountToId=testAccount2.Id);
                insert partner1;
    
                Partner partner2 = new Partner(
                Role='Distributor Of',AccountFromId=testAccount2.Id,AccountToId=testAccount3.Id);
                insert partner2;

 
                    PageReference pref = Page.PartnerHierarchy;
                    Test.setCurrentPage(pref);
 
                        ApexPages.StandardController stdcon = new ApexPages.StandardController(testAccount);
                        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(testAccount1);  
                            ctrlHierarchy cntHier = new ctrlHierarchy(stdcon);
                            ctrlHierarchy cntHier1 = new ctrlHierarchy(stdcon1);
                            cntHier.getAccountName();
                            cntHier.setAccountName('Test');
                            cntHier.getRoles();
                            cntHier.getPartnerRole();
                            cntHier.setPartnerRole('Distributor Of');
                            cntHier.searchpartner();
                            cntHier1.getAccountName();
                            cntHier1.setAccountName('Test3');
                            cntHier1.getRoles();
                            cntHier1.getPartnerRole();
                            cntHier1.setPartnerRole('Distributor Of');
                            cntHier1.searchpartner();

        }
}
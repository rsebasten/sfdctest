/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Kavya Kunam<kavya_kunam@infosys.com>, Pranitha S<Pranitha_S@infosys.com>
Description: This class is Unit Test class for class ctrlBPDCaseSave
***************************************************************************************/

@isTest
private class ctrlBPDCaseSave_UT{
        static testMethod void testctrlBPDCaseSave_UT() {
        
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Final Id CaseDetailsRecordType=Rtype.getIdByDevName('Case_Details__c','BPD_Case_Details');
       Final Id ContactRType=Rtype.getIdByDevName('Contact' ,'Brand_Protection_Contact');
         Final Id AccountRType=Rtype.getIdByDevName('Account' ,'Brand_Infringers');
         Final Id BrandProtectionAbuseSample=Rtype.getIdByDevName('Trademark_Abuse_Sample__c','Brand_Protection_Abuse_Sample');
         Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        UserRole r1= [Select id from UserRole where Name='PS CRM' limit 1];
        User user1 = new User(LastName='abc',UserRoleId=r1.Id,ProfileId=p1.Id,Alias='kav123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='kavya_kunam@infosys.com',UserName='kavya@infosys.com.t12', EPass_ID__c='NA0000',User_Owning_Org__c='AGCP-CPC',User_Country__c='India',User_Grouping__c='CPC',User_Region__c='Latin America');
        insert user1;
        System.runas(user1){  
        
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH  Svmx_TestData_Util_UT.createCustomSettingData();     
        //PKH Svmx_TestData_Util_UT.createDocument('BPDAttachmentImage');
        Document document;

        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'BPDAttachmentImage';
        document.FolderId = userinfo.getuserid();
        insert document;
                
        geoValidation.validateInTestMode=false;
        
        Contact con = new Contact(Lastname='TestLastname');
        insert con;
        
        Date d = Date.newinstance(2014, 12, 27);
        
        Case cas = new Case();
        cas.Sample_Received_Date__c = d;
        cas.status = 'new';
        cas.Brand__c= 'Kevlar';
        cas.Subject= 'test';
        cas.Description= 'This is a test case';
        cas.Qty__c=20.00;
        cas.product_selected__c='abc';
        cas.RecordTypeId = CaseRecordType;
        insert cas;
        
        List<Attachment> ra=new List<Attachment>();
        Attachment a = new Attachment();
        a.ParentId=cas.id;
        a.name='POU-';
        a.body = blob.valueof('Attachment inside');
        //insert a;
        ra.add(a);
        
        Attachment a1 = new Attachment();
        a1.ParentId=cas.id;
        a1.name='CD1-';
        a1.body = blob.valueof('Attachmdsfent inside');
        //insert a1;
        ra.add(a1);
        
        Attachment a2 = new Attachment();
        a2.ParentId=cas.id;
        a2.name='CD2-';
        a2.body = blob.valueof('Attachmfsent inside');
        //insert a2;
        ra.add(a2);
        Attachment a3 = new Attachment();
        a3.ParentId=cas.id;
        a3.name='CDH-';
        a3.body = blob.valueof('Attasdfsachment inside');
        //insert a3;
        ra.add(a3);
       
       Attachment a4 = new Attachment(); 
       a4.ParentId=cas.id;
        a4.name='LCD-';
        a4.body = blob.valueof('Attacfdsfhment inside');
        //insert a4;
        ra.add(a4);
        
        Attachment a5 = new Attachment(); 
       a5.ParentId=cas.id;
        a5.name='PU-';
        a5.body = blob.valueof('Attacfdsfhmenfdgdt inside');
        //insert a5;
        ra.add(a5);
        
       Attachment a6 = new Attachment(); 
       a6.ParentId=cas.id;
        a6.name='RI-';
        a6.body = blob.valueof('Attach inside');
        //insert a6; 
        ra.add(a6);
        Attachment a7 = new Attachment(); 
       a7.ParentId=cas.id;
        a7.name='IC-';
        a7.body = blob.valueof('Attac inside');
        //insert a7; 
        ra.add(a7);
        
        Attachment a8 = new Attachment(); 
       a8.ParentId=cas.id;
        a8.name='IB-';
        a8.body = blob.valueof('Attacfds inside');
        //insert a8;
        ra.add(a8); 
        
        Attachment a9 = new Attachment(); 
       a9.ParentId=cas.id;
        a9.name='AB-';
        a9.body = blob.valueof('Attacfdsf inside');
        //insert a9; 
        ra.add(a9);
        
        Attachment a10 = new Attachment(); 
       a10.ParentId=cas.id;
        a10.name='IR-';
        a10.body = blob.valueof('Attacfdsfhm inside');
        //insert a10; 
        ra.add(a10);
        
        Attachment a11 = new Attachment(); 
       a11.ParentId=cas.id;
        a11.name='OD-';
        a11.body = blob.valueof('Attacfdsfhme inside');
        //insert a11; 
        ra.add(a11);
        Attachment a12 = new Attachment(); 
       a12.ParentId=cas.id;
        a12.name='RR-';
        a12.body = blob.valueof('inside');
        //insert a12; 
        ra.add(a12);
        Attachment a13 = new Attachment(); 
       a13.ParentId=cas.id;
        a13.name='CMS-';
        a13.body = blob.valueof('Attainside');
        //insert a13;
        ra.add(a13);
        Attachment a14 = new Attachment(); 
       a14.ParentId=cas.id;
        a14.name='PL-';
        a14.body = blob.valueof('Attaide');
        //insert a14;
        ra.add(a14);
        Attachment a15 = new Attachment(); 
       a15.ParentId=cas.id;
        a15.name='DIS-';
        a15.body = blob.valueof('Attaside');
        //insert a15;
        ra.add(a15);
        Attachment a16 = new Attachment(); 
       a16.ParentId=cas.id;
        a16.name='MOT-';
        a16.body = blob.valueof('Attasiide');
        //insert a16;
        ra.add(a16);
       Attachment a17 = new Attachment(); 
       a17.ParentId=cas.id;
        a17.name='JUD-';
        a17.body = blob.valueof('Attinsidde');
        //insert a17; 
        ra.add(a17);
        Attachment a18 = new Attachment(); 
       a18.ParentId=cas.id;
        a18.name='LD-';
        a18.body = blob.valueof('Ainside');
        //insert a18; 
        ra.add(a18);
        Attachment a19 = new Attachment(); 
       a19.ParentId=cas.id;
        a19.name='PR-';
        a19.body = blob.valueof('Ainside');
        //insert a19;
        ra.add(a19);
        Attachment a21 = new Attachment(); 
        a21.ParentId=cas.id;
        a21.name='SET--';
        a21.body = blob.valueof('Afgsg inside');
        //insert a21;
        ra.add(a21);
        Attachment a22 = new Attachment(); 
        a22.ParentId=cas.id;
        a22.name='RES-';
        a22.body = blob.valueof('Afgsg inside');
        //insert a22;
        ra.add(a22);
        Attachment a23 = new Attachment(); 
        a23.ParentId=cas.id;
        a23.name='BP-';
        a23.body = blob.valueof('atttt inside');
        //insert a23;
        ra.add(a23);
         //<vaishnavi11262015>start
            Attachment a24 = new Attachment(); 
        a24.ParentId=cas.id;
        a24.name='TRO-';
        a24.body = blob.valueof('TRO inside');
        ra.add(a24);
            //<vaishnavi11262015>end id tho SFAR matrame undi
            //
        insert ra;
        Trademark_Abuse_Sample__c s = new Trademark_Abuse_Sample__c();
        s.Case__c = cas.Id;
        s.Sample_Technical_Analysis__c = 'abc';
        s.Trap_Purchase_Technical_Analysis__c = 'abcd';
        s.RecordTypeId = BrandProtectionAbuseSample;
        insert s;
        
        Attachment a20 = new Attachment(); 
        a20.ParentId=s.id;
        a20.name='TP-';
        a20.body = blob.valueof('A inside');
        insert a20;
        //<vaishnavi1162015>stat_test classes added
         LIST<CaseContactRole> CCRList = new LIST<CaseContactRole>();
         CaseContactRole ccr1= new CaseContactRole();
         ccr1.ContactId=con.Id;
         ccr1.CasesId=cas.id;
         ccr1.Role='Customs Authority';
         CCRList.add(ccr1);
         
         CaseContactRole ccr2=new CaseContactRole();
         ccr2.ContactId=con.Id;
         ccr2.CasesId=cas.id;
         ccr2.Role='Customs Seizure Outside Counsel';
         CCRList.add(ccr2);
         
         CaseContactRole ccr3=new CaseContactRole();
         ccr3.ContactId=con.Id;
         ccr3.CasesId=cas.id;
         ccr3.Role='Government Authority Contact';
         CCRList.add(ccr3);
         
         CaseContactRole ccr4=new CaseContactRole();
         ccr4.ContactId=con.Id;
         ccr4.CasesId=cas.id;
         ccr4.Role='Enforcement Action Outside Counsel';
         CCRList.add(ccr4);
         
         CaseContactRole ccr5=new CaseContactRole();
         ccr5.ContactId=con.Id;
         ccr5.CasesId=cas.id;
         ccr5.Role='Investigator';
         CCRList.add(ccr5);
         
         CaseContactRole ccr6=new CaseContactRole();
            ccr6.ContactId=con.Id;
         ccr6.CasesId=cas.id;
         ccr6.Role='Third Party Contact(s)';
         CCRList.add(ccr6);
         
         insert ccrList;
         //<vaishnavi11262015>end

          
       
      Date da = Date.newinstance(2015, 01, 02);
        
        Case_Details__c  c= new Case_Details__c();
        c=[select id from Case_Details__c where Related_Case__c =: cas.Id];
        c.Custom_Seizure_Volume__c ='abc';
        c.Raid_Action_Volume__c='bcd';
        c.Procedural_Status__c='Brand Protection - Closed';
        c.Customs_Seizure_Date__c=d;
        c.Sample_Received__c='Yes';
        c.Quantity_Unit_of_Measure__c ='abc';
        c.DuPont_matter_Billing_Ref_No__c='ghi';
        c.Raid_Action_Date__c=d;
        c.Counsel__c='vgh';
        c.Enforcement_Action_Description__c='zxy';
        c.Company__c = 'Infosys';
        c.Hard_Benefit_Amount_Actual__c=1;
        c.Hard_Benefit_Amount_USD__c=2;
        c.Hard_Benefit_Justification__c='abc';
        c.Hard_Benefit_Currency__c='AUD';
        c.Soft_Benefit_Amount_Actual__c=3;
        c.Soft_Benefit_Amount_USD__c=4;
        c.Soft_Benefit_Justification__c='def';
        c.Soft_Benefit_Currency__c='ARS';
        c.Legal_Recovery_Amount__c=1;
        c.Legal_Recovery_Currency__c='ARS';
        c.Legal_Recovery_Amount_USD__c=12;
        c.BP_Close_Date__c=da;
        c.RecordTypeId = CaseDetailsRecordType;
        c.Hard_Benefit_Amount_Date__c=da;
        c.Soft_Benefit_Amount_Date__c=da;
        c.Legal_Recovery_Amount_Date__c=da;
        c.Sample_Available__c='Yes';
        c.Infringement_Confirmed__c='Authentic';
      
        update c;

        PageReference pageRef = Page.BPDCaseSave;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
                
        ApexPages.currentPage().getParameters().put('id',cas.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(cas);
                
        ctrlBPDCaseSave cs = new ctrlBPDCaseSave(controller);
        cs.seizureBrand='Kev';
        cs.currentCaseDetail.Customs_Seizure_Date__c=da;
        cs.currentCaseDetail.Sample_Received__c='Yes';
        cs.currentCaseDetail.Custom_Seizure_Volume__c='aaaa';
        cs.currentCaseDetail.Quantity_Unit_of_Measure__c='abc';
        cs.currentCaseDetail.DuPont_matter_Billing_Ref_No__c='ghi';
        cs.whoisString='kevlar.com';
        cs.currentCase.Id = cas.Id;
        cs.bl =  blob.valueof('Contains Attachment');
        cs.CD1bl = blob.valueof('Contains Attachment1');
        cs.CD2bl = blob.valueof('Contains Attachment2');
        cs.CDHardcopybl = blob.valueof('Contains Attachment3');
        cs.legalbl = blob.valueof('Contains Attachment4');
        cs.properusebl = blob.valueof('Contains Attachment5');
        cs.responsebl = blob.valueof('Contains Attachment6');
        cs.industrybl = blob.valueof('Contains Attachment7');
        cs.initialBudgetbl = blob.valueof('Contains Attachment8');
        cs.additionalBudgetbl = blob.valueof('Contains Attachment9');
        cs.investigationReportbl = blob.valueof('Contains Attachment10');
        cs.otherDocumentsbl = blob.valueof('Contains Attachment11');
        cs.raidReportbl = blob.valueof('Contains Attachment12');
        cs.caseSchedulebl = blob.valueof('Contains Attachment13');
        cs.pleadingsbl = blob.valueof('Contains Attachment14');
        cs.discoverybl = blob.valueof('Contains Attachment15');
        cs.motionsbl = blob.valueof('Contains Attachment16');
        cs.settlementbl = blob.valueof('Contains Attachment17');
        cs.legalDocbl = blob.valueof('Contains Attachment18');
        cs.priviledgedDocbl = blob.valueof('Contains Attachment19');
        cs.judgementDocbl = blob.valueof('Contains Attachment21');
        cs.resolutionDocbl = blob.valueof('Contains Attachment22');
        cs.bpClosureDocbl = blob.valueof('Contains Attachment23');
        
        cs.savingCase();
        cs.savingCaseDetail();
        cs.saveInternetEvidence();
        cs.saveCustomsSeizure();
        cs.saveBudget();
        cs.saveInvestigationEvidence();
        cs.saveRaidAction();
        cs.saveResolution();
        cs.saveTarget();
        cs.saveLegal();
        cs.saveFinance();
            
        Test.stopTest();
        }
     }
    static testMethod void testctrlBPDCaseSave_UT1() {
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createCustomSettingData();  
        //PKH Svmx_TestData_Util_UT.createDocument('BPDAttachmentImage');
        Document document;

        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'BPDAttachmentImage';
        document.FolderId = userinfo.getuserid();
        insert document;
                
        Case_Details__c  c1= new Case_Details__c();
        Case cas1 = new Case();
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Date d1 = Date.newinstance(2014, 12, 27);
         cas1.Sample_Received_Date__c = d1;
        cas1.status = 'new';
        cas1.Brand__c= 'Kevlar';
        cas1.Subject= 'test';
        cas1.Description= 'This is a test case';
        cas1.Qty__c=20.00;
        cas1.product_selected__c='abc';
        cas1.RecordTypeId = CaseRecordType;
        insert cas1;
        c1=[select id from Case_Details__c where Related_Case__c =: cas1.Id];
        c1.Legal_Recovery_Amount__c=12;
        c1.Legal_Recovery_Amount_USD__c=1;
        c1.Legal_Recovery_Currency__c=null;
        c1.Soft_Benefit_Amount_Actual__c=1;
        c1.Soft_Benefit_Amount_USD__c=1;
        c1.Soft_Benefit_Currency__c=null;
        c1.Hard_Benefit_Amount_Actual__c=1;
        c1.Hard_Benefit_Amount_USD__c=7;
        c1.Hard_Benefit_Currency__c=null;
        c1.Soft_Benefit_Amount_Date__c=null;
        c1.Hard_Benefit_Amount_Date__c=null;
        c1.Legal_Recovery_Amount_Date__c=null;
        c1.Hard_Benefit_Justification__c='';
        c1.Soft_Benefit_justification__c='';
        
        update c1;
        
        PageReference pageRef = Page.BPDCaseSave;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();                
                           
        ApexPages.currentPage().getParameters().put('id',cas1.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(cas1);
        
        ctrlBPDCaseSave cs1 = new ctrlBPDCaseSave(controller);
        cs1.seizureBrand='Kev';
        cs1.currentCaseDetail.Customs_Seizure_Date__c=d1;
        cs1.currentCaseDetail.Sample_Received__c='Yes';
        cs1.currentCaseDetail.Custom_Seizure_Volume__c='aaaa';
        cs1.currentCaseDetail.Quantity_Unit_of_Measure__c='abc';
        cs1.currentCaseDetail.DuPont_matter_Billing_Ref_No__c='ghi';
        cs1.whoisString='kevlar.com';
        cs1.currentCase.Id = cas1.Id;
        cs1.bl =  blob.valueof('Contains Attachment');
        cs1.CD1bl = blob.valueof('Contains Attachment1');
        cs1.CD2bl = blob.valueof('Contains Attachment2');
        cs1.CDHardcopybl = blob.valueof('Contains Attachment3');
        cs1.legalbl = blob.valueof('Contains Attachment4');
        cs1.properusebl = blob.valueof('Contains Attachment5');
        cs1.responsebl = blob.valueof('Contains Attachment6');
        cs1.industrybl = blob.valueof('Contains Attachment7');
        cs1.initialBudgetbl = blob.valueof('Contains Attachment8');
        cs1.additionalBudgetbl = blob.valueof('Contains Attachment9');
        cs1.investigationReportbl = blob.valueof('Contains Attachment10');
        cs1.otherDocumentsbl = blob.valueof('Contains Attachment11');
        cs1.raidReportbl = blob.valueof('Contains Attachment12');
        cs1.caseSchedulebl = blob.valueof('Contains Attachment13');
        cs1.pleadingsbl = blob.valueof('Contains Attachment14');
        cs1.discoverybl = blob.valueof('Contains Attachment15');
        cs1.motionsbl = blob.valueof('Contains Attachment16');
        cs1.settlementbl = blob.valueof('Contains Attachment17');
        cs1.legalDocbl = blob.valueof('Contains Attachment18');
        cs1.priviledgedDocbl = blob.valueof('Contains Attachment19');
        cs1.judgementDocbl = blob.valueof('Contains Attachment21');
        cs1.resolutionDocbl = blob.valueof('Contains Attachment22');
        cs1.bpClosureDocbl = blob.valueof('Contains Attachment23');
        
         cs1.savingCase();
        cs1.savingCaseDetail();
        cs1.saveInternetEvidence();
        cs1.saveCustomsSeizure();
        cs1.saveBudget();
        cs1.saveInvestigationEvidence();
        cs1.saveRaidAction();
        cs1.saveResolution();
        cs1.saveTarget();
        cs1.saveLegal();
        cs1.saveFinance();
        Test.stopTest();
    }
    static testMethod void testctrlBPDCaseSave_UT2(){
        //[12262016] Merge&Spin: Called Utility Test class for custom setting data
        //PKH Svmx_TestData_Util_UT.createCustomSettingData();           
        //PKH Svmx_TestData_Util_UT.createDocument('BPDAttachmentImage');
        Document document;

        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'BPDAttachmentImage';
        document.FolderId = userinfo.getuserid();
        insert document;
        
        Case_Details__c  c2= new Case_Details__c();
        Case cas2 = new Case();
        Final Id CaseRecordType=Rtype.getIdByDevName('Case','Brand_Protection_Legal_Case');
        Date d2 = Date.newinstance(2014, 12, 27);
         cas2.Sample_Received_Date__c = d2;
        cas2.status = 'new';
        cas2.Brand__c= 'Kevlar';
        cas2.Subject= 'test';
        cas2.Description= 'This is a test case';
        cas2.Qty__c=20.00;
        cas2.product_selected__c='abc';
        cas2.RecordTypeId = CaseRecordType;
        insert cas2;
        c2=[select id from Case_Details__c where Related_Case__c =: cas2.Id];
        c2.Legal_Recovery_Amount__c=12;
        c2.Legal_Recovery_Amount_USD__c=1;
        c2.Legal_Recovery_Currency__c=null;
        c2.Soft_Benefit_Amount_Actual__c=1;
        c2.Soft_Benefit_Amount_USD__c=null;
        c2.Soft_Benefit_Currency__c=null;
        c2.Hard_Benefit_Amount_Actual__c=1;
        c2.Hard_Benefit_Amount_USD__c=null;
        c2.Hard_Benefit_Currency__c=null;
        c2.Soft_Benefit_Amount_Date__c=null;
        c2.Hard_Benefit_Amount_Date__c=null;
        c2.Legal_Recovery_Amount_Date__c=null;
        update c2;
        Test.startTest();                                          
        
        ApexPages.currentPage().getParameters().put('id',cas2.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(cas2);
        
        ctrlBPDCaseSave cs2 = new ctrlBPDCaseSave(controller);
        cs2.seizureBrand='Kev';
        cs2.currentCaseDetail.Customs_Seizure_Date__c=d2;
        cs2.currentCaseDetail.Sample_Received__c='Yes';
        cs2.currentCaseDetail.Custom_Seizure_Volume__c='aaaa';
        cs2.currentCaseDetail.Quantity_Unit_of_Measure__c='abc';
        cs2.currentCaseDetail.DuPont_matter_Billing_Ref_No__c='ghi';
        cs2.whoisString='kevlar.com';
        cs2.currentCase.Id = cas2.Id;
        cs2.bl =  blob.valueof('Contains Attachment');
        cs2.CD1bl = blob.valueof('Contains Attachment1');
        cs2.CD2bl = blob.valueof('Contains Attachment2');
        cs2.CDHardcopybl = blob.valueof('Contains Attachment3');
        cs2.legalbl = blob.valueof('Contains Attachment4');
        cs2.properusebl = blob.valueof('Contains Attachment5');
        cs2.responsebl = blob.valueof('Contains Attachment6');
        cs2.industrybl = blob.valueof('Contains Attachment7');
        cs2.initialBudgetbl = blob.valueof('Contains Attachment8');
        cs2.additionalBudgetbl = blob.valueof('Contains Attachment9');
        cs2.investigationReportbl = blob.valueof('Contains Attachment10');
        cs2.otherDocumentsbl = blob.valueof('Contains Attachment11');
        cs2.raidReportbl = blob.valueof('Contains Attachment12');
        cs2.caseSchedulebl = blob.valueof('Contains Attachment13');
        cs2.pleadingsbl = blob.valueof('Contains Attachment14');
        cs2.discoverybl = blob.valueof('Contains Attachment15');
        cs2.motionsbl = blob.valueof('Contains Attachment16');
        cs2.settlementbl = blob.valueof('Contains Attachment17');
        cs2.legalDocbl = blob.valueof('Contains Attachment18');
        cs2.priviledgedDocbl = blob.valueof('Contains Attachment19');
        cs2.judgementDocbl = blob.valueof('Contains Attachment21');
        cs2.resolutionDocbl = blob.valueof('Contains Attachment22');
        cs2.bpClosureDocbl = blob.valueof('Contains Attachment23');
        
         cs2.savingCase();
        cs2.savingCaseDetail();
        cs2.saveInternetEvidence();
        cs2.saveCustomsSeizure();
        cs2.saveBudget();
        cs2.saveInvestigationEvidence();
        cs2.saveRaidAction();
        cs2.saveResolution();
        cs2.saveTarget();
        cs2.saveLegal();
        cs2.saveFinance();
        Test.stopTest();
        
    } 
   }
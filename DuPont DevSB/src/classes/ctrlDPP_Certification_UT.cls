@isTest
/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  UnitTest(s) for  ctrlDPP_Certification
********************************************************************************/
private class ctrlDPP_Certification_UT {

  public static Account testAccount {   GET { return new Account(name='TestCo: ', country__c='United States'); }}
  public static Contact testContact {   GET { return new Contact(lastname='TestCo: ', email='tester@test.com'); }}
  public static Campaign testCampaign {  GET { return new Campaign(name='TestCampaign '); }}

  private static string createMemberPortal() {
    geovalidation.DisableGeoValidationOverride=true;
    Account a = testAccount;
    insert a;
    Contact c = testContact;
    c.accountid=a.id;
    insert c;
    Campaign camp = testCampaign;
    insert camp;
    insert new CampaignMember(campaignid=camp.id, ContactId=c.id);
    
    SiteObject__c so = new SiteObject__c(Name='Test MP', PublicName__c= ctrlDPP_Certification.MEMBERPORTAL_NAME,
       RecordTypeId=MemberPortal.RTYPE_SO_MEMBERPORTAL,
       IsPublic__c=true, campaign__c=camp.id, ReturnUrl__c='/apex/DPPCertification');
    insert so;
    
    return MemberPortal.createKey(so.id,a.id,c.id);
  }
  
  
public static string createScript() {
  
  SFDC_Script__c s1 = new SFDC_Script__c(
    name='DPP Fabric',
    Available_With__c ='Qualification__cs',
    WriteToObject__c='Qualification__c',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null, 
    ReturnToType__c='script header'
    );
  insert s1;
  
  SFDC_Questions__c q1 = new SFDC_Questions__c( 
    WriteToField__c='id',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='WriteToID', 
    IsVisible__c=false,
    IsRequired__c=false,
    DataType__c='Text',
    AllowChange__c=false
    );

  SFDC_Questions__c q2 = new SFDC_Questions__c( 
    WriteToField__c='Weight_g_m2__c', 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_FabricWeight',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c=null,
    Name='Question 3', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DataType__c='Integer',
    Answer_Format__c=null,
    AllowChange__c=true,
    DefaultAnswer__c='210'
    );
  
  SFDC_Questions__c q3 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_PerformanceISO_13934_Warp',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='3934 Warp', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DefaultAnswer__c='A',
    DataType__c='Integer',
    Answer_Format__c=null,
    AllowChange__c=true
    );
    
  SFDC_Questions__c q4 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_PerformanceISO_13934_Weft',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='Question 2', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='tester',
    DataType__c='Integer',
    Answer_Format__c=null,
    AllowChange__c=true
    );

  SFDC_Questions__c q5 = new SFDC_Questions__c( 
    WriteToField__c='Account_Name__c', 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c=null,
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c=null,
    Name='Account_Name__c', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsReadOnly__c=true,
    IsRequired__c=true,
    DataType__c='TEXT',
    Answer_Format__c=null,
    AllowChange__c=false,
    DefaultAnswer__c='@memberportal.accountid'
    );
  
    SFDC_Questions__c q6 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c=ctrlDPP_Certification.COLOR_Q_PREFIX+ctrlDPP_Certification.COLOR_Q_PREFIX_Garment+'_1',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c=null,
    Name='color', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsReadOnly__c=false,
    IsRequired__c=true,
    DataType__c='TEXT',
    Answer_Format__c=null,
    AllowChange__c=false,
    DefaultAnswer__c='blue'
    );
  
  SFDC_Questions__c q7 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_PerformanceISO_12947',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='SimpleGreaterThan test', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='60000',  //pass
    DataType__c='Integer',
    Answer_Format__c=null,
    AllowChange__c=true
    );
  
  SFDC_Questions__c q8 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_PerformanceISO_5077_Warp',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='SimpleLessThan test', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='3',  
    DataType__c='Integer',
    Answer_Format__c=null,
    AllowChange__c=true
    );  

    SFDC_Questions__c q9 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c=ctrlDPT_NomexCert.COLOR_Q_PREFIX_Garment+'_1',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c=null,
    Name='color', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsReadOnly__c=false,
    IsRequired__c=true,
    DataType__c='TEXT',
    Answer_Format__c=null,
    AllowChange__c=false,
    DefaultAnswer__c='blue'
    );

    SFDC_Questions__c q10 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='EXTERNAL_READONLY_DPP_PerformanceNAR',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='NAR TEST', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='3',  
    DataType__c='Decimal',
    Answer_Format__c=null,
    AllowChange__c=true
    ); 
    
    SFDC_Questions__c q11 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='DPP_PerformanceATPV',
    Script__c=s1.id,
    SaveResult__c=true,
    Question_Coach__c='help',
    OutParameter__c='out',
    Name='ARC MAN', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='3',  
    DataType__c='Decimal',
    Answer_Format__c=null,
    AllowChange__c=true
    );   
    
    insert new LIST<SFDC_Questions__c> {q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11};
    
    SFDC_FollowOnQuestion__c fq1 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq2 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q2.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq3 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q3.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq4 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q4.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq5 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q5.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq6 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q6.id, QuestionOrder__c=6);
    SFDC_FollowOnQuestion__c fq7 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q7.id, QuestionOrder__c=7);
    SFDC_FollowOnQuestion__c fq8 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q8.id, QuestionOrder__c=8);
    SFDC_FollowOnQuestion__c fq9 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q9.id, QuestionOrder__c=9);
    SFDC_FollowOnQuestion__c fq10 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q10.id, QuestionOrder__c=10);
    SFDC_FollowOnQuestion__c fq11 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q11.id, QuestionOrder__c=11);
    insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8,fq9,fq10,fq11};
    
    //SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=1, Order__c=1, Answer__c='A', Questions__c=q1.id);
    //SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=2, Order__c=2, Answer__c='B', Questions__c=q1.id);
    //SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=3, Order__c=3, Answer__c='C', Questions__c=q1.id);
    //insert new LIST<SFDC_Answer__c> {an1,an2,an3};  
    
    return s1.id;
}
  
  public static testMethod void test_DPP_Certification() {  
    /*
    ApexPages.currentPage().getParameters().put('key', key);
    Test.setCurrentPage(pageRef);
    
    ctrlMemberPortal ctrlMP = new ctrlMemberPortal();
    Test.setCurrentPage(ctrlMP.MemberPortal_OnLoad());
    */
    string scriptId=createScript();
    
    string key=createMemberPortal();
    ApexPages.currentPage().getParameters().put('key', key);
    ctrlDPP_Certification ctrlDPP = new ctrlDPP_Certification();
    ctrlDPP.page = PageBase.getInstance();

    
    //Open test SiteScript and fill out form
    ctrlDPP.newScriptId=scriptId;
    ctrlDPP.NewCert();
    //Score 2
    ctrlDPP.script.getQuestion('DPP_FabricWeight').answer='200';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_13934_Weft').answer='111';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_13934_Warp').answer='221';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_12947').answer='62000';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_5077_Warp').answer='2';
    ctrlDPP.Save();
    
    //Score 1
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_12947').answer='45000';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_5077_Warp').answer='3';
    ctrlDPP.Save();
    
    //Score 0
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_12947').answer='20000';
    ctrlDPP.script.getQuestion('DPP_PerformanceISO_5077_Warp').answer='4';
    ctrlDPP.Save();
    
    //Add a color
    ctrlDPP.AddColor();
    ctrlDPP.script.getQuestion(ctrlDPP_Certification.COLOR_Q_PREFIX+ctrlDPP_Certification.COLOR_Q_PREFIX_Garment +'_1').answer='blue';
    ctrlDPP.SaveColor();
    
    ctrlDPP.AddGarmentType();
    ctrlDPP.script.getQuestion(ctrlDPP_Certification.COLOR_Q_PREFIX+ctrlDPP_Certification.COLOR_Q_PREFIX_Garment +'_1').answer='blue';
    ctrlDPP.SaveGarmentType();
    
    //Show result on Home
    ctrlDPP.goHome();
    system.debug(ctrlDPP.NewButtons);
    
    For(ctrlDPP_Certification.Cert cert : ctrlDPP.Certs) {
      system.debug(cert);
    }
    
    //show active certs
    system.debug(ctrlDPP.activeCerts);
    ctrlDPP.initpdf();
    
    //Select a cert
    ctrlDPP.selectedCertId=ctrlDPP.Certs[0].qualificationid;
    ctrlDPP.SelectCert();
    ctrlDPP_Certification.Cert cert = ctrlDPP.getSelectedCert();
    system.debug(cert.qualificationId);
    system.debug(cert.referenceId);
    system.debug(cert.certtype);
    system.debug(cert.datetaken);
    system.debug(cert.status);
    system.debug(cert.scriptId);
    system.debug(cert.headerId);
    system.debug(cert.score);
    system.debug(cert.createddate);
    system.debug(cert.colorReference);
    system.debug(cert.color);
    system.debug(cert.startDate);
    system.debug(cert.endDate);
    system.debug(cert.weight);
    system.debug(cert.result);
    system.debug(cert.brand  );
    system.debug(cert.construction);
    system.debug(cert.stage);
    system.debug(cert.parentReferenceId);
    system.debug(cert.parentId);
        
    ApexPages.currentPage().getParameters().put('cid',ctrlDPP.selectedCertId);
    ctrlDPP.initpdf();  //used for PDF page

  }


}
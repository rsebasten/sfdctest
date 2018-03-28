/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: sreedhar jagannath
Email: sreedhar.jagannath@ind.dupont.com
Description:  UnitTest(s) for ctrlDPT_NomexCert
********************************************************************************/
@isTest
private class ctrlDPT_NomexCert_UT {
   /* public static String qualid ;
    public static User user1;
    
    //Krish: replaced existing createportaluser method with new method for creation of portal user.
    /*
    public static string createPortalUser() {
    Profile p  = [select id from Profile where UserLicense.Name like '%Customer Portal%' limit 1];
    Account a =new Account(name='TestCo', country__c='UNITED STATES');
    insert a;
    Contact con =new Contact(accountid=a.id, lastname='Tester', email='tester@test.com');
    insert con;
    
        Profile p1 = [select id from profile where usertype = 'PowerPartner' limit 1];
        user1=new User( contactId=con.Id, LastName='TESTER', ProfileId=p.Id,Alias='custP',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US', Email='test@test.com' ,UserName='test@test.com', EPass_ID__c='NA0000',User_Owning_Org__c='CORP',User_Country__c='UNITED STATES',User_Grouping__c='CORP',User_Region__c='NA');
       
       insert user1;
      
      System.runAs(user1){
      system.assertEquals(a.id, PortalUser.getInstance().accountId);
      system.debug('Hi'+PortalUser.getInstance().accountId);
        
   }
        return PortalUser.getInstance().accountId;
   } 
     */
   /*public static string createPortalUser() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2_dps@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        Account portalAccount1;
        Contact contact1;
        
            //Create account
            portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
                    
            //Create contact
            contact1 = new Contact(
                FirstName = 'Test',
                    Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                    Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
        //Create user
        //commented for dps
        //Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Community%' Limit 1];
        system.runas(portalAccountOwner1){
        user1 = new User(
            Username = System.now().millisecond() + 'test12345_dps@test.com',
            //ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);}
        String accId;
        System.runAs(user1){
            accId = PortalUser.getInstance().accountId;
        }
        return accId;
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
    DefaultAnswer__c='@portaluser.accountid'
    );
  
    SFDC_Questions__c q6 = new SFDC_Questions__c( 
    WriteToField__c=null, 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c=ctrlDPT_NomexCert.COLOR_Q_PREFIX+'_1',
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
    //insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8};
    
    //SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=1, Order__c=1, Answer__c='A', Questions__c=q1.id);
    //SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=2, Order__c=2, Answer__c='B', Questions__c=q1.id);
    //SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=3, Order__c=3, Answer__c='C', Questions__c=q1.id);
    //insert new LIST<SFDC_Answer__c> {an1,an2,an3};  
    
    return s1.id;
}
    
public static testMethod void test_DPT_NomexCert() { 
    
    string scriptId=createScript();
    User cu = [SELECT Id from User where Id = :UserInfo.getUserId()];
    system.runas(cu){
    System.debug('Script Id'+scriptId );
    string PortalaccountId=createPortalUser();
    System.debug('Account Id'+PortalaccountId);
    }
    Test.startTest();        
    
    PageReference pageRef = Page.DPT_NomexCert;      
    
    Test.setCurrentPage(pageRef);      
     Account accNew = new Account(Name = 'testAccountA1', Country__C = 'India');
            insert accNew;
            Id RecordTypeIdQual =   Rtype.getIdByDevName('Qualification__c','Fabric Certification');
    Qualification__c qualNew = new Qualification__c(RecordTypeId=RecordTypeIdQual,Account_Name__c=accNew.Id,Weight__c=199,SubType__c='Fabric - Outer layer',Status__c='Approved',Other_Criteria_Met__c='High Visibility; Contact Heat Protection',Make_Visible_To__c='Catalogue',Main_End_Uses__c='Industrial',End_Date__c=Date.newInstance(2100,06,09),Construction__c='Woven- Plain',Colour__c='Piece-Dyed - Royal Blue');
    insert qualNew;
    
    ApexPages.currentPage().getParameters().put('id', scriptId);
    //ApexPages.currentPage().getParameters().put('id', qualNew.id);
    ctrlDPT_NomexCert ctrlDPP = new ctrlDPT_NomexCert();
    
    //Open test SiteScript and fill out form
        ApexPages.currentPage().getParameters().put('scriptId', scriptId);
        ctrlDPP.newScriptId=scriptId;
        ctrlDPP.NewCert();
        //ctrlDPP.script=new SiteScript(ctrlDPP.newScriptId);
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
        
        qualId = ctrlDPP.script.WriteToId;      
    
        if (qualId <> null && qualId <> '') {
            ApexPages.currentPage().getParameters().put('id',qualId);
            //Add a color
            ctrlDPP.AddColor();
            ctrlDPP.script.getQuestion(ctrlDPP_Certification.COLOR_Q_PREFIX+'_1').answer='blue';
            ctrlDPP.SaveColor();
            
            ctrlDPP.AddGarmentType();
            ctrlDPP.script.getQuestion(ctrlDPT_NomexCert.COLOR_Q_PREFIX_Garment+'_1').answer='blue';
            ctrlDPP.SaveGarmentType();
            
            //Show result on Home
            ctrlDPP.goHome();
            ctrlDPP.goBack();
        
    
    For(ctrlDPT_NomexCert.Cert cert : ctrlDPP.Certs) {
      system.debug(cert);
    }
    
    //show active certs
    //system.debug(ctrlDPP.activeCerts);
    ApexPages.currentPage().getParameters().put('cid',null);
    ctrlDPP.initpdf();
    
    //Select a cert
    ctrlDPP.selectedCertId=ctrlDPP.Certs[0].qualificationid;
    ctrlDPP.SelectCert();
    ctrlDPT_NomexCert.Cert cert = ctrlDPP.getSelectedCert();
    
    ApexPages.currentPage().getParameters().put('cid',ctrlDPP.selectedCertId);
    ctrlDPP.initpdf();  //used for PDF page
    }
    Test.stopTest();
  }
 //[01252017] Merge&Spin: Created test method to increase code coverage for ctrlDPT_NomexCert class. 
    public static testMethod void test_DPT_NomexCert1() { 
    
    string scriptId=createScript();
    User cu = [SELECT Id from User where Id = :UserInfo.getUserId()];
        system.runas(cu){
            Account accNew = new Account(Name = 'testAccountA1', Country__C = 'India');
            insert accNew;
            Id RecordTypeIdQual =   Rtype.getIdByDevName('Qualification__c','Fabric Certification');
            Qualification__c qualNew = new Qualification__c(RecordTypeId=RecordTypeIdQual,Account_Name__c=accNew.Id,Weight__c=199,SubType__c='Fabric - Outer layer',Status__c='Approved',Other_Criteria_Met__c='High Visibility; Contact Heat Protection',Make_Visible_To__c='Catalogue',Main_End_Uses__c='Industrial',End_Date__c=Date.newInstance(2100,06,09),Construction__c='Woven- Plain',Colour__c='Piece-Dyed - Royal Blue');
            insert qualNew;
            system.debug('qualNew-->>'+qualNew);
            SFDC_Script_Header__c sh = new SFDC_Script_Header__c(Qualification__c=qualNew.id);
            insert sh;            
            Test.startTest();        
            PageReference pageRef = Page.DPT_NomexCert;      
    
            Test.setCurrentPage(pageRef);      
    
            ApexPages.currentPage().getParameters().put('id', qualNew.Id);
            ApexPages.currentPage().getParameters().put('gtyp', 'gtype');
            ctrlDPT_NomexCert ctrlDPP = new ctrlDPT_NomexCert();
            ctrlDPP.selectedCertId = qualNew.Id;
            System.debug(ctrlDPP.uploadMsg);
            System.debug(ctrlDPP.errorMsg);
            System.debug(ctrlDPP.AccName);
            System.debug(ctrlDPP.qualsubtype);
            ctrlDPP.initPDF();
            ctrlDPP.init();
            ctrlDPT_NomexCert.Cert ctrlCert = new ctrlDPT_NomexCert.Cert(qualNew);
            string referenceIdString = ctrlCert.referenceId ;
            string   certtype = ctrlCert.certtype;
            string   status = ctrlCert.status;
            datetime createddate = ctrlCert.createddate;
            string   colorReference = ctrlCert.colorReference ;
            string   color = ctrlCert.color;
            string   startDate = ctrlCert.startDate;
            string   endDate = ctrlCert.endDate;
            integer  weight = ctrlCert.weight;
            string   result = ctrlCert.result;
            string   brand = ctrlCert.brand;
            string   construction = ctrlCert.construction;
            string   stage  = ctrlCert.stage;
            string   finish = ctrlCert.finish;
            string   parentReferenceId = ctrlCert.parentReferenceId;
            string   parentId = ctrlCert.parentId;
            string   account = ctrlCert.account;
            string   owner = ctrlCert.owner;
            string   subtype = ctrlCert.subtype;

        }
    }
    */
}
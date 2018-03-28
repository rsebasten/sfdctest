/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesRegistration_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_EnvelopesRegistration
// AK20150204 modified the test class to increase the code coverage.
//************************************<MG-20140827>***************************************************//

@isTest
public class ctrlBINA_EnvelopesRegistration_UT{

 static testMethod void testctrlBINA_EnvelopesRegistration() {
    Final Id SITERECTYPEID = Rtype.getIdByDevName('SFDC_Script__c','SiteScript');
    Profile p=[SELECT id,name from Profile where Name=:'System Administrator' LIMIT 1];
    User user1=[SELECT id,name from User where IsActive=: true and ProfileId =: p.Id LIMIT 1];
    Final Id PRODUCTlABOUR_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    Final Id PRODUCTFLUID_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
    Final Id PRODUCT_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');

     System.runAs(user1){

  SFDC_Script__c ss1 = new SFDC_Script__c(
    name='Project Information',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
    
   
  SFDC_Script__c ss2 = new SFDC_Script__c(
    name='Certified Installer Information',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
   
   
  SFDC_Script__c ss3 = new SFDC_Script__c(
    name='Related Contact Information',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
   
   
  SFDC_Script__c ss4 = new SFDC_Script__c(
    name='Estimated Product Exposure Time(in Days)',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
   
   
  SFDC_Script__c ss5 = new SFDC_Script__c(
    name='Project Information - Product Only',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
     
        
 SFDC_Script__c ss6 = new SFDC_Script__c(
    name='Warranty Dates',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
   insert new LIST<SFDC_Script__c> {ss1,ss2,ss3,ss4,ss5,ss6};
   
   
   SFDC_Questions__c Ques1=new SFDC_Questions__c(Name='RegistrationID',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='id',DefaultAnswer__c='@param.var',
                     WriteToField__c='id',AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques2=new SFDC_Questions__c(Name='Building Height (number of stories)',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Building Height (number of stories)',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques3=new SFDC_Questions__c(Name='Building Size (sq. ft.)',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Building Size',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques4=new SFDC_Questions__c(Name='Sheathing Type',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Sheathing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques5=new SFDC_Questions__c(Name='Wall Cladding Type',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Wall Cladding Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true, IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques6=new SFDC_Questions__c(Name='Framing Type',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Framing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques7=new SFDC_Questions__c(Name='Certified Installer Name',Script__c=ss2.Id,Answer_Format__c='Checkbox',ShortName__c='Certified Installer Name',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques8=new SFDC_Questions__c(Name='Certified Installer #',Script__c=ss2.Id,Answer_Format__c='Checkbox',ShortName__c='Certified Installer',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques9=new SFDC_Questions__c(Name='Related Account',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Account',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques10=new SFDC_Questions__c(Name='Related Account Sub Type',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Account Sub Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques11=new SFDC_Questions__c(Name='Related Contact Name',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Name',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques12=new SFDC_Questions__c(Name='Related Contact Email',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Email',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques13=new SFDC_Questions__c(Name='Related Contact Phone Number',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Phone Number',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques14=new SFDC_Questions__c(Name='Estimated Product Exposure Time(In Days)',Script__c=ss4.Id,Answer_Format__c='Checkbox',ShortName__c='Estimated Product Exposure Time(In Days)',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques15=new SFDC_Questions__c(Name='Date of Pre-Installation Meeting',Script__c=ss6.Id,Answer_Format__c='Checkbox',ShortName__c='Date of Pre-Installation Meeting',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Date', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
    SFDC_Questions__c Ques16=new SFDC_Questions__c(Name='Date of Substantial Completion (AIAG704)',Script__c=ss4.Id,Answer_Format__c='Checkbox',ShortName__c='Date of Substantial Completion',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Date', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');                  
      
   
   insert new LIST<SFDC_Questions__c> {Ques1,Ques2,Ques3,Ques4,Ques5,Ques6,Ques7,Ques8,Ques9,Ques10,Ques11,Ques12,Ques13,Ques14,Ques15,Ques16};
   
    SFDC_FollowOnQuestion__c fq1 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq2 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques2.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq3 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques3.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq4 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques4.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq5 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques5.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq6 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques6.id, QuestionOrder__c=6);
    SFDC_FollowOnQuestion__c fq7 = new SFDC_FollowOnQuestion__c(Script__c=ss2.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq8 = new SFDC_FollowOnQuestion__c(Script__c=ss2.id, Question__c=Ques7.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq9 = new SFDC_FollowOnQuestion__c(Script__c=ss2.id, Question__c=Ques8.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq10 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq11 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques9.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq12 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques10.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq13 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques11.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq14 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques12.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq15 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques13.id, QuestionOrder__c=6);
    SFDC_FollowOnQuestion__c fq16 = new SFDC_FollowOnQuestion__c(Script__c=ss4.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq17 = new SFDC_FollowOnQuestion__c(Script__c=ss4.id, Question__c=Ques14.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq18 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq19 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques2.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq20 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques3.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq21 = new SFDC_FollowOnQuestion__c(Script__c=ss6.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq22 = new SFDC_FollowOnQuestion__c(Script__c=ss6.id, Question__c=Ques15.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq23 = new SFDC_FollowOnQuestion__c(Script__c=ss6.id, Question__c=Ques16.id, QuestionOrder__c=3);
    

    insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8,fq9,fq10,fq11,fq12,fq13,fq14,fq15,fq16,fq17,fq18,fq19,fq20,fq21,fq22,fq23};
         
    SFDC_Answer__c an4 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Sheathing - Plywood', Questions__c=Ques4.id);
    SFDC_Answer__c an5 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Sheathing - OSB', Questions__c=Ques4.id);
    SFDC_Answer__c an6 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Sheathing - Exterior Insulation', Questions__c=Ques4.id);
    insert new LIST<SFDC_Answer__c> {an4,an5,an6};
    
    SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Wall Cladding - Brick Mason', Questions__c=Ques5.id);
    SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Wall Cladding - Stone Venn', Questions__c=Ques5.id);
    SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Wall Cladding - Stucco', Questions__c=Ques5.id);
    insert new LIST<SFDC_Answer__c> {an1,an2,an3};
    
    SFDC_Answer__c an7 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Framing - 2X4 Wood', Questions__c=Ques6.id);
    SFDC_Answer__c an8 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Framing - 2X6 Wood', Questions__c=Ques6.id);
    SFDC_Answer__c an9 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Framing - 2X8 Wood', Questions__c=Ques6.id);
    insert new LIST<SFDC_Answer__c> {an7,an8,an9}; 
    
    geoValidation.validateInTestMode=false;
    Account acc= new Account(name='testacc');
    insert acc;
        
    Entitlement ent= new Entitlement();
           
    DateTime dT = System.now();
      
    Entitlement__C e5=new Entitlement__C(Name='DuPont™ StraightFlash™',Record_Type__c='Product Only',Products__C='DuPont™ StraightFlash™', Application__c='< 5 Stories');
    Entitlement__C e6=new Entitlement__C(Name='Tyvek® HomeWrap®',Record_Type__c='Product Only',Products__C='Tyvek® HomeWrap®',Application__c='< 5 Stories');
    Entitlement__C e1=new Entitlement__C(Name='DuPont™ StraightFlash™_p',Accessories__c='3" Tyvek® Tape',Record_Type__c='Product & Labor',Category__C='Flash',Products__C='DuPont™ StraightFlash™', Application__c='< 5 Stories');
    Entitlement__C e2=new Entitlement__C(Name='Tyvek® CommercialWrap®',Accessories__c='DuPont™ Wrap Caps',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap®',Application__c='< 5 Stories');
    Entitlement__C e7=new Entitlement__C(Name='DuPont™ StraightFlash™_p1',Accessories__c='3" Tyvek® Tape',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap® D', Application__c='< 5 Stories',WRB_Only__c=true);
    Entitlement__C e8=new Entitlement__C(Name='Tyvek® CommercialWrap®1',Accessories__c='DuPont™ Wrap Caps',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap®',Application__c='< 5 Stories', WRB_Only__c=true);
    Entitlement__C e3=new Entitlement__C(Name='Tyvek® CommercialWrap® D',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap® D',Application__c='< 5 Stories');
    Entitlement__C e4=new Entitlement__C(Name='Tyvek® Fluid Applied WB',Record_Type__c='Fluid Applied Product Only',Products__C='Tyvek® Fluid Applied WB');
    insert new LIST<Entitlement__C> {e1,e2,e3,e4,e5,e6,e7,e8};
            
    test.StartTest();
    System.debug('recordtype id is'+PRODUCTFLUID_REG_RTYPE);
    
    ///// product only
    
    Entitlement ent1 = new entitlement();
    ent1.name='sanjay';
    ent1.Registration_Address__c='somnething';
    ent1.Registration_City__c='Infosys';
    ent1.Registration_State_Province__c='AK';
    ent1.Registration_Postal_Code__c='5601';
    ent1.Registration_Country1__c='United States';
    ent1.Lot_Nb__c='abc';
    ent1.startdate=date.newinstance(2016,02, 29);
    ent1.WRB_Only__c=true;
    ent1.Building_Type__c='Residential / Duplex';
    ent1.Lot_Nb__c='12';
    ent1.Registration_Postal_Code__c='56010';
    ent1.Application__c='< 5 Stories';
    
    ApexPages.currentPage().getParameters().put('RecordType',PRODUCT_RTYPE);
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    ApexPages.currentPage().getParameters().put('ent','Entitlement');
    ApexPages.currentPage().getParameters().put('retURL','abc');
    ApexPAges.StandardController sc1 = new ApexPages.StandardController(ent1);
    ctrlBINA_EnvelopesRegistration c3 = new ctrlBINA_EnvelopesRegistration (sc1);
    c3.entit.Product_Answer1__c='';
    c3.saveEnt();
    ent1.Product_Answer1__c='DuPont™ StraightFlash™';
    c3.saveEnt();
    c3.Script3=new SiteScript(ss3.id);
    c3.Script4=new SiteScript(ss4.id);
    c3.Script5=new SiteScript(ss5.id);
    c3.script5.getQuestion('Building Height (number of stories)').answer='1';
    c3.script5.getQuestion('Building Size').answer= '2';
    c3.script3.getQuestion('Related Account').answer='sa';
    c3.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c3.saveEnt();
    c3.productSelection();
    
    // Product and labour
    ApexPages.currentPage().getParameters().put('RecordType',PRODUCTlABOUR_REG_RTYPE);
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    ApexPages.currentPage().getParameters().put('ent','Entitlement');
    ApexPages.currentPage().getParameters().put('retURL','abc');
    ApexPAges.StandardController sc = new ApexPages.StandardController(ent);
    ctrlBINA_EnvelopesRegistration c2 = new ctrlBINA_EnvelopesRegistration (sc);
        
    ent.name='sanjay';
    ent.Registration_Address__c='somnething';
    ent.Registration_City__c='Infosys';
    ent.Registration_State_Province__c='AK';
    ent.Registration_Postal_Code__c='5601';
    ent.Registration_Country1__c='United States';
    ent.Lot_Nb__c='abc';
    ent.startdate=date.newinstance(2016,02, 29);
    ent.WRB_Only__c=true;
    ent.Building_Type__c='Residential / Duplex';
    ent.Application_Type__c='Residential';
    
    c2.initScript();
    c2.cancel();
    c2.productAnswer();
    c2.validationScript();
    c2.checkBox1=false;
    c2.checkBox2=false;
    c2.productSelection();
    c2.saveEnt();
    
    ent.Lot_Nb__c='12';
    ent.Registration_Postal_Code__c='56010';
    ent.Application__c='< 5 Stories';
    c2.checkBox1=true;
    c2.checkBox2=true;
    c2.saveEnt();
    c2.entit.Product_Answer1__c='';
    c2.saveEnt();
    c2.selectedMaterials.add(new SelectOption('Tyvek® CommercialWrap® D', 'Tyvek® CommercialWrap® D'));
    c2.saveEnt();
    c2.script1.getQuestion('Building Height (number of stories)').answer='1';
    c2.script1.getQuestion('Building Size').answer= '2';
    c2.script1.getQuestion('Framing Type').answer=an7.answer__c;
    c2.script1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    c2.script1.getQuestion('Sheathing Type').answer=an4.answer__c;
    c2.script3.getQuestion('Related Account').answer='sanjay';
    c2.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c2.script6.getQuestion('Date of Pre-Installation Meeting').answer='10/30/2014';
    c2.script6.getQuestion('Date of Substantial Completion').answer='10/9/2014';
    c2.saveEnt();
    c2.selectedMaterials.clear();
    ent.WRB_Only__c=false;
    c2.saveEnt();
    c2.selectedMaterials.add(new SelectOption('Tyvek® CommercialWrap® D', 'Tyvek® CommercialWrap® D'));
    c2.saveEnt();
    c2.selectedMaterials.add(new SelectOption('DuPont™ StraightFlash™','DuPont™ StraightFlash™' ));
    c2.script6.getQuestion('Date of Pre-Installation Meeting').answer='10/1/2014';
    ent.startdate=date.newinstance(2014,02, 29);
    c2.saveEnt();        
    c2.productSelection();
    
    /// Fluid Applied
    
    Entitlement ent2 = new entitlement();
    ent2.name='sanjay';
    ent2.Registration_Address__c='somnething';
    ent2.Registration_City__c='Infosys';
    ent2.Registration_State_Province__c='AK';
    ent2.Registration_Country1__c='United States';
    ent2.Lot_Nb__c='abc';
    ent2.startdate=date.newinstance(2014,02, 29); //AK20150204
    ent2.WRB_Only__c=true;
    ent2.Building_Type__c='Residential / Duplex';
    ent2.Lot_Nb__c='12';
    ent2.Registration_Postal_Code__c='56010';
    ent2.Application__c='< 5 Stories';
    ent2.Application_Type__c='Residential'; //AK20150204
    
    ApexPages.currentPage().getParameters().put('RecordType',PRODUCTFLUID_REG_RTYPE);
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    ApexPages.currentPage().getParameters().put('ent','Entitlement');
    ApexPages.currentPage().getParameters().put('retURL','abc');
    ApexPAges.StandardController sc2 = new ApexPages.StandardController(ent2);
    ctrlBINA_EnvelopesRegistration c4 = new ctrlBINA_EnvelopesRegistration (sc2);
    c4.checkBox1=true;
    c4.checkBox2=true;
   
    c4.Script1=new SiteScript(ss1.id);
    c4.Script2=new SiteScript(ss2.id);
    c4.Script4=new SiteScript(ss4.id);
    c4.Script3=new SiteScript(ss3.id);
    c4.selectedMaterials.add(new SelectOption('Tyvek® Fluid Applied WB','Tyvek® Fluid Applied WB' ));
    c4.script1.getQuestion('Building Height (number of stories)').answer='1';
    c4.script1.getQuestion('Building Size').answer= '2';
    c4.script1.getQuestion('Framing Type').answer=an7.answer__c;
    c4.script1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    c4.script1.getQuestion('Sheathing Type').answer=an4.answer__c;
    c4.script3.getQuestion('Related Account').answer='sanjay';
    c4.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c4.script2.getQuestion('Certified Installer Name').answer='sanjay';
    c4.script2.getQuestion('Certified Installer').answer='nandi';
    ApexPages.currentPage().getParameters().put('def_account_id',NULL);
    c4.saveEnt();
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    c4.saveEnt();
    c4.productSelection();
       
    Test.StopTest();
      }
  }
}
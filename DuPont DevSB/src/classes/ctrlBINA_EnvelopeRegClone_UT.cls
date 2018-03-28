/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopeRegClone_UT
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_EnvelopeRegClone
//************************************<MG-20140827>***************************************************//

@isTest
public class ctrlBINA_EnvelopeRegClone_UT{

 static testMethod void testctrlBINA_EnvelopeRegClone() {
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
         
          //<SA20171208>
    SFDC_Script__c ss7 = new SFDC_Script__c(
    name='Project Information WB+',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
         
    SFDC_Script__c ss8 = new SFDC_Script__c(
    name='Certified Installer Information WB',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );     
         
    SFDC_Script__c ss9 = new SFDC_Script__c(
    name='Project Information WB+ w/EIFS',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
         
        
         
   insert new LIST<SFDC_Script__c> {ss1,ss2,ss3,ss4,ss5,ss6,ss7,ss8,ss9};
   
   
   SFDC_Questions__c Ques1=new SFDC_Questions__c(Name='RegistrationId',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='id',DefaultAnswer__c='@param.var',
                     WriteToField__c='id',AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques2=new SFDC_Questions__c(Name='Building Height (number of stories)',DefaultAnswer__c='',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Building Height (number of stories)',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques3=new SFDC_Questions__c(Name='Building Size (sq. ft.)',DefaultAnswer__c='',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Building Size',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques4=new SFDC_Questions__c(Name='Sheathing Type',DefaultAnswer__c='',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Sheathing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques5=new SFDC_Questions__c(Name='Wall Cladding Type',DefaultAnswer__c='',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Wall Cladding Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true, IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques6=new SFDC_Questions__c(Name='Framing Type',DefaultAnswer__c='',Script__c=ss1.Id,Answer_Format__c='Checkbox',ShortName__c='Framing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques7=new SFDC_Questions__c(Name='Certified Installer Name',DefaultAnswer__c='',Script__c=ss2.Id,Answer_Format__c='Checkbox',ShortName__c='Certified Installer Name',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques8=new SFDC_Questions__c(Name='Certified Installer #',DefaultAnswer__c='',Script__c=ss2.Id,Answer_Format__c='Checkbox',ShortName__c='Certified Installer',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
   SFDC_Questions__c Ques9=new SFDC_Questions__c(Name='Related Account',DefaultAnswer__c='',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Account',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques10=new SFDC_Questions__c(Name='Related Account Sub Type',DefaultAnswer__c='',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Account Sub Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques11=new SFDC_Questions__c(Name='Related Contact Name',DefaultAnswer__c='',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Name',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques12=new SFDC_Questions__c(Name='Related Contact Email',DefaultAnswer__c='',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Email',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques13=new SFDC_Questions__c(Name='Related Contact Phone Number',DefaultAnswer__c='',Script__c=ss3.Id,Answer_Format__c='Checkbox',ShortName__c='Related Contact Phone Number',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques14=new SFDC_Questions__c(Name='Estimated Product Exposure Time(In Days)',DefaultAnswer__c='',Script__c=ss4.Id,Answer_Format__c='Checkbox',ShortName__c='Estimated Product Exposure Time(In Days)',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques15=new SFDC_Questions__c(Name='Date of Pre-Installation Meeting',DefaultAnswer__c='',Script__c=ss6.Id,Answer_Format__c='Checkbox',ShortName__c='Date of Pre-Installation Meeting',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Date', Question_Coach__c='BINA TYVEK');
    SFDC_Questions__c Ques16=new SFDC_Questions__c(Name='Date of Substantial Completion (AIAG704)',DefaultAnswer__c='',Script__c=ss4.Id,Answer_Format__c='Checkbox',ShortName__c='Date of Substantial Completion',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Date', Question_Coach__c='BINA TYVEK');                  
      
   
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
    
    Entitlement__C e5=new Entitlement__C(Name='DuPont™ StraightFlash™',Record_Type__c='Product Only',Products__C='DuPont™ StraightFlash™', Application__c='< 5 Stories - Residential');
    Entitlement__C e6=new Entitlement__C(Name='Tyvek® HomeWrap®',Record_Type__c='Product Only',Products__C='Tyvek® HomeWrap®',Application__c='< 5 Stories - Residential');
    Entitlement__C e1=new Entitlement__C(Name='DuPont™ StraightFlash™_p',Accessories__c='3" Tyvek® Tape',Record_Type__c='Product & Labor',Category__C='Flash',Products__C='DuPont™ StraightFlash™', Application__c='< 5 Stories - Residential');
    Entitlement__C e2=new Entitlement__C(Name='Tyvek® CommercialWrap®',Accessories__c='DuPont™ Wrap Caps',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap®',Application__c='< 5 Stories - Residential');
    Entitlement__C e3=new Entitlement__C(Name='Tyvek® CommercialWrap® D',Record_Type__c='Product & Labor',Category__C='Wrap',Products__C='Tyvek® CommercialWrap® D',Application__c='< 5 Stories - Residential');
    Entitlement__C e4=new Entitlement__C(Name='Tyvek® Fluid Applied WB',Record_Type__c='Fluid Applied Product Only',Products__C='Tyvek® Fluid Applied WB');
     Entitlement__C e7=new Entitlement__C(Name='Tyvek® Fluid Applied Flashing',Record_Type__c='Fluid Applied Product Only',Products__C='Tyvek® Fluid Applied Flashing - Brush Formulation');
    insert new LIST<Entitlement__C> {e1,e2,e3,e4,e5,e6,e7};
    
   SiteScript     Scripts1=new SiteScript(ss1.id);
   SiteScript     Scripts2=new SiteScript(ss2.id);
   SiteScript     Scripts3=new SiteScript(ss3.id);
   SiteScript     Scripts4=new SiteScript(ss4.id);
   SiteScript     Scripts5=new SiteScript(ss5.id);
   SiteScript     Scripts6=new SiteScript(ss6.id);
    geoValidation.validateInTestMode=false;
    Account acc= new Account(name='testacc');
    insert acc;
    Entitlement ent3= new Entitlement();
    Entitlement ent1= new Entitlement();
    Entitlement ent2= new Entitlement();
    DateTime dT = System.now();
    
    ent3.name='sanjay';
    ent3.Registration_Address__c='somnething';
    ent3.Registration_City__c='Infosys';
    ent3.Registration_State_Province__c='AK'; 
    ent3.Registration_Postal_Code__c='5601';
    ent3.Registration_Country1__c='United States';
    ent3.startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    ent3.Application__c='< 5 Stories - Residential';
    ent3.Building_Type__c='Residential / Duplex';
    ent3.Application_Type__c='Residential';
    ent3.Product_Answer1__c='Tyvek® Fluid Applied WB';
    ent3.Lot_Nb__c='12';
    ent3.recordTypeId=PRODUCTFLUID_REG_RTYPE;
    ent3.AccountId=acc.id;
        
    ent1.name='sanjay1';
    ent1.Registration_Address__c='somnething';
    ent1.Registration_City__c='Infosys';
    ent1.Registration_State_Province__c='AK';
    ent1.Registration_Postal_Code__c='5601';
    ent1.Registration_Country1__c='United States';
    ent1.startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    ent1.Application__c='< 5 Stories - Residential';
    Ent1.Building_Type__c='Residential / Duplex';
    ent1.Application_Type__c='Residential';    
    ent1.Product_Answer1__c='DuPont™ StraightFlash™; Tyvek® CommercialWrap® D';
    ent1.Lot_Nb__c='abc';
    ent1.recordTypeId=PRODUCTlABOUR_REG_RTYPE;
    ent1.AccountId=acc.id;
        
    ent2.name='sanjay2';
    ent2.Registration_Address__c='somnething';
    ent2.Registration_City__c='Infosys';
    ent2.Registration_State_Province__c='AK';
    ent2.Registration_Postal_Code__c='5601';
    ent2.Registration_Country1__c='United States';
    ent2.startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    ent2.Application__c='< 5 Stories - Residential';
    Ent2.Building_Type__c='Residential / Duplex';
    ent2.Product_Answer1__c='DuPont™ StraightFlash™';
    ent2.Application_Type__c='Residential';    
    ent2.Lot_Nb__c='12';
    ent2.recordTypeId=PRODUCT_RTYPE;
    ent2.AccountId=acc.id;
    
       
    insert new List<Entitlement>{ent3,ent1,ent2};
    Entitlement entnew1= new Entitlement();
    Entitlement entnew2= new Entitlement();
    Entitlement entnew3= new Entitlement();
    
    scripts1.getQuestion('Building Height (number of stories)').answer='1';
    scripts1.getQuestion('Building Size').answer= '2';
    scripts1.getQuestion('Framing Type').answer=an7.answer__c;
    scripts1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    scripts1.getQuestion('Sheathing Type').answer=an4.answer__c;
    scripts3.getQuestion('Related Account').answer='sanjay';
    scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    scripts6.getQuestion('Date of Pre-Installation Meeting').answer='date.newinstance(dT.year(), dT.month(), dT.day())+2';
    scripts6.getQuestion('Date of Substantial Completion').answer='date.newinstance(dT.year(), dT.month(), dT.day())';   
    scripts1.getQuestion('id').answer=ent1.id;
    scripts3.getQuestion('id').answer=ent1.id;
    scripts4.getQuestion('id').answer=ent1.id;
    scripts6.getQuestion('id').answer=ent1.id;
    
    scripts1.save();
    scripts6.save();
    scripts4.save();
    scripts3.save();
    
    
    scripts1.getQuestion('Building Height (number of stories)').answer='1';
    scripts1.getQuestion('Building Size').answer='2';
    scripts1.getQuestion('Framing Type').answer=an7.answer__c;
    scripts1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    scripts1.getQuestion('Sheathing Type').answer=an4.answer__c;
    scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    scripts2.getQuestion('Certified Installer Name').answer='sanjay';
    scripts3.getQuestion('Related Account').answer='sanjay';
    scripts2.getQuestion('Certified Installer').answer='nandi';
    scripts1.getQuestion('id').answer=ent3.id;
    scripts3.getQuestion('id').answer=ent3.id;
    scripts4.getQuestion('id').answer=ent3.id;
    scripts2.getQuestion('id').answer=ent3.id;
    Scripts1.save();
    Scripts3.save();
    Scripts4.save();
    Scripts2.save();
    
    
     scripts5.getQuestion('Building Height (number of stories)').answer='1';
     scripts5.getQuestion('Building Size').answer='2';
     scripts3.getQuestion('Related Account').answer='sanjay';
     scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
     scripts3.getQuestion('id').answer=ent2.id;
     scripts4.getQuestion('id').answer=ent2.id;
     scripts5.getQuestion('id').answer=ent2.id;
     Scripts3.save();
     Scripts4.save();
     Scripts5.save();
     
    Test.StartTest();
    
   
       
    ApexPages.currentPage().getParameters().put('id',ent1.id);
    ApexPAges.StandardController sc1= new ApexPages.StandardController(entnew1);
    ctrlBINA_EnvelopeRegClone c1= new ctrlBINA_EnvelopeRegClone (sc1);
    c1.checkBox1=false;
    c1.saveEnt();
    c1.entit.Lot_Nb__c='12';
    c1.saveEnt();
    c1.entit.name='sanjaynandi';
    c1.saveEnt();
    c1.checkBox1=true;
    c1.entit.Registration_Postal_Code__c='56010';
    c1.entit.Product_Answer1__c='';
    c1.entit.WRB_Only__c = true;
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('Tyvek® CommercialWrap® D', 'Tyvek® CommercialWrap® D'));
    c1.saveEnt();
    c1.entit.WRB_Only__c = false;
    c1.selectedMaterials.clear();
    c1.entit.Product_Answer1__c='';
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('Tyvek® CommercialWrap® D', 'Tyvek® CommercialWrap® D'));
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('DuPont™ StraightFlash™','DuPont™ StraightFlash™' ));
    c1.script1.getQuestion('Building Height (number of stories)').answer='1';
    c1.script1.getQuestion('Building Size').answer= '2';
    c1.script1.getQuestion('Framing Type').answer=an7.answer__c;
    c1.script1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    c1.script1.getQuestion('Sheathing Type').answer=an4.answer__c;
    c1.script3.getQuestion('Related Account').answer='sanjay';
    c1.redirectToPage();
    c1.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c1.script6.getQuestion('Date of Pre-Installation Meeting').answer='10/30/2014';
    c1.script6.getQuestion('Date of Substantial Completion').answer='10/1/2014';
    c1.saveEnt();
    c1.script6.getQuestion('Date of Pre-Installation Meeting').answer='10/1/2014';
    c1.saveEnt(); 
    //DB20150818 Added this code
    c1.script6.getQuestion('Date of Pre-Installation Meeting').answer='10/1/2016';
    c1.saveEnt();
    c1.script6.getQuestion('Date of Substantial Completion').answer='10/1/2016';
    c1.saveEnt();
    //DB20150818 Added this code            
    c1.productValidation();     
  
    
    
    
    ApexPages.currentPage().getParameters().put('id',ent3.id);
    ApexPAges.StandardController sc= new ApexPages.StandardController(entnew1);
    ctrlBINA_EnvelopeRegClone c= new ctrlBINA_EnvelopeRegClone (sc);
    c.entit.name='sanjaynandi1';
    c.entit.Lot_Nb__c='12';
    c.entit.StartDate=date.newinstance(2016, 2, 29);
    c.entit.Registration_Postal_Code__c='56010';
    c.entit.Product_Answer1__c=NULL;
    c.saveEnt();
    c.selectedMaterials.add(new SelectOption('Tyvek® Fluid Applied WB','Tyvek® Fluid Applied WB' ));
    c.script1.getQuestion('Building Height (number of stories)').answer='1';
    c.script1.getQuestion('Building Size').answer= '2';
    c.script1.getQuestion('Framing Type').answer=an7.answer__c;
    c.script1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    c.script1.getQuestion('Sheathing Type').answer=an4.answer__c;
    c.script3.getQuestion('Related Account').answer='sanjay';
    c.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c.script2.getQuestion('Certified Installer Name').answer='sanjay';
    c.script2.getQuestion('Certified Installer').answer='nandi';
    c.saveEnt();
    c.productValidation();
     
     
     
     ApexPages.currentPage().getParameters().put('id',ent2.id);
     ApexPAges.StandardController sc3= new ApexPages.StandardController(ent2);
     ctrlBINA_EnvelopeRegClone c3= new ctrlBINA_EnvelopeRegClone (sc3);
     c3.entit.name='sanjaynandi2';
     c3.entit.Lot_Nb__c='12';
     c3.entit.Registration_Postal_Code__c='56010';
     c3.selectedMaterials.add(new SelectOption('DuPont™ StraightFlash™','DuPont™ StraightFlash™' ));
     c3.script5.getQuestion('Building Height (number of stories)').answer='1';
     c3.script5.getQuestion('Building Size').answer= '2';
     c3.script3.getQuestion('Related Account').answer='sa';
     c3.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
     c3.saveEnt();
     c3.productValidation();
     ApexPages.currentPage().getParameters().put('mode','Edit');
     c3.dataInitial();
     c3.saveEnt();
      Test.stopTest();

    
    }
    }
//<SA20171208> added the new method to increase the code coverage of new record types
    static testMethod void testctrlBINA_EnvelopeRegClone1() {
    Final Id SITERECTYPEID = Rtype.getIdByDevName('SFDC_Script__c','SiteScript');
    Profile p=[SELECT id,name from Profile where Name=:'System Administrator' LIMIT 1];
    User user1=[SELECT id,name from User where IsActive=: true and ProfileId =: p.Id LIMIT 1];
    Final Id PRODUCTlABOUR_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor');
    Final Id PRODUCTFLUID_REG_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied');
    Final Id PRODUCT_RTYPE=RType.getIdByDevName('Entitlement','BI_NA_Env_Product_Only');
    Final Id PRODUCT_ONLY_FLUID_WB_REG_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Only_Fluid_Applied_WB');
    Final Id PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE = Rtype.getIdByDevName('Entitlement','BI_NA_Env_Product_Labor_Fluid_Applied_WB_w_EIFS');    

     System.runAs(user1){

  SFDC_Script__c ss1 = new SFDC_Script__c(
    name='Project Information WB+',
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
   
   // Added 
  SFDC_Script__c ss5 = new SFDC_Script__c(
    name='Certified Installer Information WB',
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
         
    SFDC_Script__c ss7 = new SFDC_Script__c(
    name='Project Information WB+ w/EIFS',
    Available_With__c ='Account;Contact;Lead;Case;Qualification__c;Entitlements',
    WriteToObject__c='Entitlement',
    ReturnToType__c='WriteToObject',
    AllowContinuation__c=true,
    Use_Scoring__c=true,
    ReturnToValue__c=null 
 
    );
         
        
         
   insert new LIST<SFDC_Script__c> {ss1,ss2,ss3,ss4,ss5,ss6,ss7};
   
   
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
    SFDC_Questions__c Ques15=new SFDC_Questions__c(Name='RegistrationID',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='id',DefaultAnswer__c='@param.var',
                     WriteToField__c='id',AllowChange__c=True, SaveResult__c=True,IsRequired__C= false,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques16=new SFDC_Questions__c(Name='Building Height (number of stories)',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='Building Height (number of stories)',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques17=new SFDC_Questions__c(Name='Building Size (sq. ft.)',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='Building Size',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Integer', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   SFDC_Questions__c Ques18=new SFDC_Questions__c(Name='Sheathing Type',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='Sheathing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
  
  SFDC_Questions__c Ques19=new SFDC_Questions__c(Name='EIFS System',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='EIFS System',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
  SFDC_Questions__c Ques20=new SFDC_Questions__c(Name='EIFS Manufacturer',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='EIFS System',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='Text', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
  
  SFDC_Questions__c Ques21=new SFDC_Questions__c(Name='Framing Type',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='Framing Type',
                      AllowChange__c=True, SaveResult__c=True,IsRequired__C= true,IsVisible__c=True,DataType__c='MultiSelect Picklist', Question_Coach__c='BINA TYVEK',Group__c='BINA TYVEK');
   
  insert new LIST<SFDC_Questions__c> {Ques1,Ques2,Ques3,Ques4,Ques5,Ques6,Ques7,Ques8,Ques9,Ques10,Ques11,Ques12,Ques13,Ques14,Ques15,Ques16,Ques17,Ques18,Ques19,Ques20,Ques21};

   
    SFDC_FollowOnQuestion__c fq1 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq2 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques2.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq3 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques3.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq4 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques4.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq5 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques5.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq6 = new SFDC_FollowOnQuestion__c(Script__c=ss1.id, Question__c=Ques6.id, QuestionOrder__c=6);
         
    SFDC_FollowOnQuestion__c fq7 = new SFDC_FollowOnQuestion__c(Script__c=ss2.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq8 = new SFDC_FollowOnQuestion__c(Script__c=ss2.id, Question__c=Ques7.id, QuestionOrder__c=2);
    
    SFDC_FollowOnQuestion__c fq9 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq19 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques7.id, QuestionOrder__c=2);   
    SFDC_FollowOnQuestion__c fq20 = new SFDC_FollowOnQuestion__c(Script__c=ss5.id, Question__c=Ques8.id, QuestionOrder__c=3);
         
    SFDC_FollowOnQuestion__c fq10 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq11 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques9.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq12 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques10.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq13 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques11.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq14 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques12.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq15 = new SFDC_FollowOnQuestion__c(Script__c=ss3.id, Question__c=Ques13.id, QuestionOrder__c=6);
    SFDC_FollowOnQuestion__c fq16 = new SFDC_FollowOnQuestion__c(Script__c=ss4.id, Question__c=Ques1.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq17 = new SFDC_FollowOnQuestion__c(Script__c=ss4.id, Question__c=Ques14.id, QuestionOrder__c=2);
    
    SFDC_FollowOnQuestion__c fq18 = new SFDC_FollowOnQuestion__c(Script__c=ss6.id, Question__c=Ques1.id, QuestionOrder__c=1);
     
    SFDC_FollowOnQuestion__c fq21 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques15.id, QuestionOrder__c=1);
    SFDC_FollowOnQuestion__c fq22 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques16.id, QuestionOrder__c=2);
    SFDC_FollowOnQuestion__c fq23 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques17.id, QuestionOrder__c=3);
    SFDC_FollowOnQuestion__c fq24 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques18.id, QuestionOrder__c=4);
    SFDC_FollowOnQuestion__c fq25 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques19.id, QuestionOrder__c=5);
    SFDC_FollowOnQuestion__c fq26 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques20.id, QuestionOrder__c=6);
     
    

    insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8,fq9,fq10,fq11,fq12,fq13,fq14,fq15,fq16,fq17,fq18,fq19,fq20,fq21,fq22,fq23,fq24,fq25,fq26};
         
    SFDC_Answer__c an4 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Sheathing - Plywood', Questions__c=Ques4.id);
    SFDC_Answer__c an5 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Sheathing - OSB', Questions__c=Ques4.id);
    SFDC_Answer__c an6 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Sheathing - Exterior Insulation', Questions__c=Ques4.id);
    SFDC_Answer__c an10 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='  Sheathing - None', Questions__c=Ques4.id);
    SFDC_Answer__c an11 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='  Sheathing - OSB', Questions__c=Ques4.id);
    insert new LIST<SFDC_Answer__c> {an4,an5,an6,an10,an11};
    
    SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Wall Cladding - Brick Mason', Questions__c=Ques5.id);
    SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Wall Cladding - Stone Venn', Questions__c=Ques5.id);
    SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Wall Cladding - Stucco', Questions__c=Ques5.id);
    insert new LIST<SFDC_Answer__c> {an1,an2,an3};
    
    SFDC_Answer__c an7 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Framing - 2X4 Wood', Questions__c=Ques6.id);
    SFDC_Answer__c an8 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Framing - 2X6 Wood', Questions__c=Ques6.id);
    SFDC_Answer__c an9 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Framing - 2X8 Wood', Questions__c=Ques6.id);
    insert new LIST<SFDC_Answer__c> {an7,an8,an9}; 
    
    Entitlement__C e1=new Entitlement__C(Name='5_Tyvek® Fluid Applied WB+™',Record_Type__c='Product Only WB+',Products__C='Tyvek® Fluid Applied WB+™', Application__c='< 5 Stories');
    Entitlement__C e2=new Entitlement__C(Name='5_Tyvek® Fluid Applied Flashing',Record_Type__c='Product Only WB+',Products__C='Tyvek® Fluid Applied Flashing & Joint Compound+',Application__c='< 5 Stories');
    Entitlement__C e3=new Entitlement__C(Name='5_DuPont™ Sealant for Tyvek®',Record_Type__c='Product Only WB+',Products__C='DuPont™ Sealant for Tyvek® Fluid Applied',Application__c='< 5 Stories');
    insert new LIST<Entitlement__C> {e1,e2,e3};
    
   SiteScript     Scripts1=new SiteScript(ss1.id);
   SiteScript     Scripts2=new SiteScript(ss2.id);
   SiteScript     Scripts3=new SiteScript(ss3.id);
   SiteScript     Scripts4=new SiteScript(ss4.id);
   SiteScript     Scripts5=new SiteScript(ss5.id);
   SiteScript     Scripts6=new SiteScript(ss6.id);
    geoValidation.validateInTestMode=false;
    Account acc= new Account(name='testacc');
    insert acc;
    Entitlement ent3= new Entitlement();
    Entitlement ent1= new Entitlement();
    Entitlement ent2= new Entitlement();
    DateTime dT = System.now();
    
    ent3.name='Sai';
    ent3.Registration_Address__c='somnething';
    ent3.Registration_City__c='TCS';
    ent3.Registration_State_Province__c='AK'; 
    ent3.Registration_Postal_Code__c='5601';
    ent3.Registration_Country1__c='United States';
    ent3.startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    ent3.Application__c='< 5 Stories - Residential';
    ent3.Building_Type__c='Multi-Family';
    ent3.Application_Type__c='Commercial';
    ent3.Product_Answer1__c='Tyvek® Fluid Applied WB';
    ent3.Lot_Nb__c='12';
    ent3.recordTypeId=PRODUCT_ONLY_FLUID_WB_REG_RTYPE;
    ent3.AccountId=acc.id;
        
    ent1.name='PQR';
    ent1.Registration_Address__c='somnething';
    ent1.Registration_City__c='TCS';
    ent1.Registration_State_Province__c='AK';
    ent1.Registration_Postal_Code__c='5601';
    ent1.Registration_Country1__c='United States';
    ent1.startdate=date.newinstance(dT.year(), dT.month(), dT.day());
    ent1.Application__c='< 5 Stories - Residential';
    Ent1.Building_Type__c='Residential / Duplex';
    ent1.Application_Type__c='Residential';    
    ent1.Product_Answer1__c='Tyvek® Fluid Applied WB+™; DuPont™ Sealant for Tyvek® Fluid Applied';
    ent1.Lot_Nb__c='abc';
    ent1.recordTypeId=PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE;
    ent1.AccountId=acc.id;
        
    
    
       
    insert new List<Entitlement>{ent3,ent1};
    Entitlement entnew1= new Entitlement();
    Entitlement entnew3= new Entitlement();
    
    scripts1.getQuestion('Building Height (number of stories)').answer='1';
    scripts1.getQuestion('Building Size').answer= '2';
    scripts1.getQuestion('Framing Type').answer=an7.answer__c;
    scripts1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    scripts1.getQuestion('Sheathing Type').answer=an4.answer__c;
    scripts3.getQuestion('Related Account').answer='Sai';
    scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
   
    scripts1.getQuestion('id').answer=ent1.id;
    scripts3.getQuestion('id').answer=ent1.id;
    scripts4.getQuestion('id').answer=ent1.id;
   
    
    scripts1.save();
    
    scripts4.save();
    scripts3.save();
    
    
    scripts1.getQuestion('Building Height (number of stories)').answer='1';
    scripts1.getQuestion('Building Size').answer='2';
    scripts1.getQuestion('Framing Type').answer='Framing - 2X4 Wood';
    scripts1.getQuestion('Wall Cladding Type').answer='Wall Cladding - Brick Mason';
    scripts1.getQuestion('Sheathing Type').answer='Sheathing - Plywood';
    scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    scripts2.getQuestion('Certified Installer Name').answer='sai';
    scripts3.getQuestion('Related Account').answer='sai';
  //  scripts2.getQuestion('Certified Installer  ').answer='nandi';
    scripts1.getQuestion('id').answer=ent3.id;
    scripts3.getQuestion('id').answer=ent3.id;
    scripts4.getQuestion('id').answer=ent3.id;
    scripts2.getQuestion('id').answer=ent3.id;
    Scripts1.save();
    Scripts3.save();
    Scripts4.save();
    Scripts2.save();
    
    
     
     scripts3.getQuestion('Related Account').answer='shub';
     scripts4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
     scripts3.getQuestion('id').answer=ent2.id;
     scripts4.getQuestion('id').answer=ent2.id;
     scripts5.getQuestion('id').answer=ent2.id;
     Scripts3.save();
     Scripts4.save();
    
     
    Test.StartTest();
    
   
     System.debug(LoggingLevel.ERROR,'@#debug'+[Select id, recordTypeId from entitlement where id = :ent1.id]);  
    ApexPages.currentPage().getParameters().put('id',ent1.id);
    
         ApexPAges.StandardController sc1= new ApexPages.StandardController(entnew1);
    ctrlBINA_EnvelopeRegClone c1= new ctrlBINA_EnvelopeRegClone (sc1);
    c1.checkBox1=false;
    c1.saveEnt();
    c1.entit.Lot_Nb__c='12';
    c1.saveEnt();
    c1.entit.name='xyz';
    c1.saveEnt();
    c1.checkBox1=true;
    c1.entit.Registration_Postal_Code__c='56010';
    c1.entit.Product_Answer1__c='';
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('Tyvek® Fluid Applied WB+™', 'Tyvek® Fluid Applied WB+™'));
    c1.saveEnt();
    c1.selectedMaterials.clear();
    c1.entit.Product_Answer1__c='';
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('DuPont™ Sealant for Tyvek® Fluid Applied', 'DuPont™ Sealant for Tyvek® Fluid Applied'));
    c1.saveEnt();
    c1.selectedMaterials.add(new SelectOption('Tyvek® Fluid Applied WB+™','Tyvek® Fluid Applied WB+™' ));
    c1.Script1=new SiteScript(ss7.id);
    c1.Script2=new SiteScript(ss5.id);
    c1.Script3=new SiteScript(ss3.id);
       
    c1.redirectToPage();
    c1.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    
    c1.saveEnt();
   
    
   c1.productValidation();     
  
    ApexPages.currentPage().getParameters().put('id',ent3.id);
    ApexPAges.StandardController sc= new ApexPages.StandardController(entnew1);
    ctrlBINA_EnvelopeRegClone c= new ctrlBINA_EnvelopeRegClone (sc);
    c.entit.name='sanjaynandi1';
    c.entit.Lot_Nb__c='12';
    c.entit.StartDate=date.newinstance(2016, 2, 29);
    c.entit.Registration_Postal_Code__c='56010';
    c.entit.Product_Answer1__c=NULL;
    c.saveEnt();
    c.selectedMaterials.add(new SelectOption('Tyvek® Fluid Applied WB','Tyvek® Fluid Applied WB' ));
    c.script1.getQuestion('Building Height (number of stories)').answer='1';
    c.script1.getQuestion('Building Size').answer= '2';
    c.script1.getQuestion('Framing Type').answer=an7.answer__c;
    c.script1.getQuestion('Wall Cladding Type').answer=an1.answer__c;
    c.script1.getQuestion('Sheathing Type').answer=an4.answer__c;
    c.script3.getQuestion('Related Account').answer='sanjay';
    c.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';
    c.script2.getQuestion('Certified Installer Name').answer='sai';
    c.script2.getQuestion('Certified Installer').answer='nandi';
    c.saveEnt();
    c.productValidation();
     
     
      Test.stopTest();

    
    }
    }

    
    
 }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2017 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesRegistration_WB_UT
//Author : Sairam Kumar
//Description: This  UT class for controller ctrlBINA_EnvelopesRegistration_WB 

//***************************************************************************************//

@isTest
public class ctrlBINA_EnvelopesRegistration_WB_UT{

  static testMethod  void testctrlBINA_EnvelopesRegistration_WB_UT() {
     
    Final Id SITERECTYPEID = Rtype.getIdByDevName('SFDC_Script__c','SiteScript');
    Profile p=[SELECT id,name from Profile where Name=:'System Administrator' LIMIT 1];
    User user1=[SELECT id,name from User where IsActive=: true and ProfileId =: p.Id LIMIT 1];
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

   insert new LIST<SFDC_Script__c> {ss1,ss2,ss3,ss5,ss4,ss6,ss7};
   
   
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

    SFDC_Questions__c Ques14=new SFDC_Questions__c(Name='Estimated Product Exposure Time(In Days)',Script__c=ss4.Id,Answer_Format__c='text',ShortName__c='Estimated Product Exposure Time(In Days)',
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
  SFDC_Questions__c Ques20=new SFDC_Questions__c(Name='EIFS Manufacturer',Script__c=ss7.Id,Answer_Format__c='Checkbox',ShortName__c='EIFS Manufacturer',
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
    SFDC_FollowOnQuestion__c fq27 = new SFDC_FollowOnQuestion__c(Script__c=ss7.id, Question__c=Ques21.id, QuestionOrder__c=7);
    
    insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8,fq9,fq10,fq11,fq12,fq13,fq14,fq15,fq16,fq17,fq18,fq19,fq20,fq21,fq22,fq23,fq24,fq25,fq26,fq27};
         
    SFDC_Answer__c an4 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='Sheathing - Exterior Gypsum', Questions__c=Ques4.id);
    SFDC_Answer__c an5 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='Sheathing - Exterior Insulation', Questions__c=Ques4.id);
    SFDC_Answer__c an6 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='Sheathing - Glass Faced Gypsum', Questions__c=Ques4.id);
    SFDC_Answer__c an10 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='	Sheathing - None', Questions__c=Ques4.id);
    SFDC_Answer__c an11 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='	Sheathing - OSB', Questions__c=Ques4.id);
         
    insert new LIST<SFDC_Answer__c> {an4,an5,an6,an10,an11};
    
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
    Entitlement ent1= new Entitlement();     
           
    DateTime dT = System.now();
      
    Entitlement__C e1=new Entitlement__C(Name='5_Tyvek® Fluid Applied WB+™',Record_Type__c='Product Only WB+',Products__C='Tyvek® Fluid Applied WB+™', Application__c='< 5 Stories');
    Entitlement__C e2=new Entitlement__C(Name='5_Tyvek® Fluid Applied Flashing',Record_Type__c='Product Only WB+',Products__C='Tyvek® Fluid Applied Flashing & Joint Compound+',Application__c='< 5 Stories');
    Entitlement__C e3=new Entitlement__C(Name='5_DuPont™ Sealant for Tyvek®',Record_Type__c='Product Only WB+',Products__C='DuPont™ Sealant for Tyvek® Fluid Applied',Application__c='< 5 Stories');
    insert new LIST<Entitlement__C> {e1,e2,e3};
            
    test.StartTest();
         
    System.debug('recordtype id is'+PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE);
    
   
    
   // Product and labour Fluid Applied WB EIFS
  
    ApexPages.currentPage().getParameters().put('RecordType',PRODUCTlABOUR_FLUID_WB_EIFS_REG_RTYPE);
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    ApexPages.currentPage().getParameters().put('ent','Entitlement');
    ApexPages.currentPage().getParameters().put('retURL','abc');
    ApexPAges.StandardController sc = new ApexPages.StandardController(ent);
    ctrlBINA_EnvelopesRegistration_WB c2 = new ctrlBINA_EnvelopesRegistration_WB (sc);
        
    ent.name='test';
    ent.Registration_Address__c='somnething';
    ent.Registration_City__c='xyz';
    ent.Registration_State_Province__c='AK';
    ent.Registration_Postal_Code__c='560188';
    ent.Registration_Country1__c='United States';
    ent.Lot_Nb__c='abc';
    ent.startdate=date.newinstance(2017,12,31);
    ent.Building_Type__c='Multi-Family';
    ent.Application_Type__c='Commercial';
    ent.Product_Answer1__c='';
  
    
    c2.initScript();
    c2.cancel();
    c2.productAnswer();
    c2.validationScript();
    c2.checkBox1=false;
    c2.checkBox2=false;
    c2.checkBox3=false;     
    c2.productSelection();
    c2.entit.Product_Answer1__c='';
    c2.saveEnt();
    
    ent.Lot_Nb__c='12';
    ent.Registration_Postal_Code__c='56010';
    
    c2.checkBox1=true;
    c2.checkBox2=true;
    c2.checkBox3=true;     
    c2.saveEnt();
    
   
    c2.script1.getQuestion('Building Height (number of stories)').answer='1';
    System.debug('Script1 is' +c2.script1);
    c2.script1.getQuestion('Building Size').answer= '2';
    c2.script2.getQuestion('Certified Installer Name').answer='shub';
    c2.script3.getQuestion('Related Account').answer='sairam';
    c2.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';

    c2.saveEnt();
    c2.selectedMaterials.clear();
    c2.saveEnt();
    ent.startdate=date.newinstance(2014,02, 29);
    c2.saveEnt();        
   
    /// Product Only Fluid Applied WB+
    //
   
    ApexPages.currentPage().getParameters().put('RecordType',PRODUCT_ONLY_FLUID_WB_REG_RTYPE);
    ApexPages.currentPage().getParameters().put('def_account_id',acc.id);
    ApexPages.currentPage().getParameters().put('ent','Entitlement');
    ApexPages.currentPage().getParameters().put('retURL','abc');  
    ApexPAges.StandardController sc1 = new ApexPages.StandardController(ent1);
    ctrlBINA_EnvelopesRegistration_WB c3 = new ctrlBINA_EnvelopesRegistration_WB (sc1);
        
    ent1.name='test';
    ent1.Registration_Address__c='somnething';
    ent1.Registration_City__c='xyz';
    ent1.Registration_State_Province__c='AK';
    ent1.Registration_Postal_Code__c='56018';
    ent1.Registration_Country1__c='United States';
    ent1.Lot_Nb__c='12';
    ent1.startdate=date.newinstance(2016,01,01);
    ent1.Building_Type__c='Multi-Family';
    ent1.Application__c='< 5 Stories';
    ent1.Application_Type__c='Commercial';
    
    
    c3.initScript();
    c3.cancel();
    c3.productAnswer();
    c3.validationScript();
    c3.checkBox1=true;
    c3.checkBox2=true;
    c3.checkBox3=true; 
     c3.productSelection();
  //  c3.saveEnt();
    
    ent1.Lot_Nb__c='12';
    ent1.Registration_Postal_Code__c='56010';
    
    
    c3.checkBox1=true;
    c3.checkBox2=true;
    c3.checkBox3=true;     
 
    
    c3.AllMaterials.add(new SelectOption('DuPont™ Sealant for Tyvek® Fluid Applied', 'DuPont™ Sealant for Tyvek® Fluid Applied'));
    c3.SelectedMaterials.add(new SelectOption('DuPont™ Sealant for Tyvek® Fluid Applied', 'DuPont™ Sealant for Tyvek® Fluid Applied'));
    c3.saveEnt();
         
  
   
    c3.Script1=new SiteScript(ss7.id);
    c3.script4=new SiteScript(ss4.id);   
         
    c3.script1.getQuestion('Building Height (number of stories)').answer='1';
    c3.script1.getQuestion('Building Size').answer= '2';
    c3.script1.getQuestion('Framing Type').answer='Framing - 2X6 Wood';
    c3.script1.getQuestion('Sheathing Type').answer='Sheathing - OSB';
    c3.script1.getQuestion('EIFS System').answer='sairam';
    c3.script1.getQuestion('EIFS Manufacturer').answer='pqr';  
    c3.script4.getQuestion('Estimated Product Exposure Time(In Days)').answer='12';  
    c3.Script2=new SiteScript(ss5.id);
    c3.Script3=new SiteScript(ss3.id);
    c3.saveEnt();
    c3.selectedMaterials.clear();
   
    c3.productSelection();
    

       Test.StopTest();
      }
  }
    
}
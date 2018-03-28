@isTest(SeeAllData=true)
public class ctrlBIRetailerAuthProcess_UT{

static testMethod void testBIReatailerAuthProcess(){
Profile p=[SELECT Id,Name FROM Profile WHERE Name=:'System Administrator' LIMIT 1];
User u=[SELECT Id,Name FROM User where IsActive=:true and ProfileId=:p.Id LIMIT 1];
UtilRT.RT accrt = UtilRT.getRT('Account', 'DPT_NOW');
UtilRT.RT conrt = UtilRT.getRT('Contact', 'DPT_EMEA');
UtilRT.RT sfdcrt = UtilRT.getRT('SFDC_Script__c', 'CallScript');
UtilRT.RT accmatrt = UtilRT.getRT('Account_Material__c', 'Account_Material');
System.runAs(u){


Account acc = new Account(Name='testAccount',Country__c='Canada',recordTypeId=accrt.Id,Owning_Organization__c='BI_Surf',fax='546545',website='www.dupont.com',phone='4541243453',ShippingStreet='Hosur road', ShippingCity='Bangalore',shippingState='Karnataka', shippingPostalCode='560100', locators__c='test',Mb_of_Marketing_Program__c='Reatiler Authorization');
insert acc;
//Account acc= [SELECT id, name,fax,website,phone, ShippingStreet,shippingCity,shippingState,shippingPostalCode,Country__c,locators__c,Mb_of_Marketing_Program__c from account where id='00118000002eF3I'];
acc.Mb_of_Marketing_Program__c='AdvantEdge';
acc.Mb_of_Marketing_Program__c='Authorized Retailer';
Contact con= new Contact(LastName='testContact',AccountID=acc.id,recordTypeId=conrt.Id,Status__C='Active',Contact_Country__c='Canada',Prefered_Language__c='English',Phone='102365564',Comments__c='testing');
insert con;

PageReference pageRef = Page.BI_AuthorizationForm;
Test.setCurrentPage(pageRef);
ApexPages.currentPage().getParameters().put('aid',acc.id);
ApexPages.StandardController controller = new ApexPages.StandardController(acc);

SFDC_Script__c  s1= new SFDC_Script__c(   
   ReturnToValue__c='http://buildinginnovations.us.dupont.com/AuthorizedRetailer-TY',
   RecordTypeId=sfdcrt.Id,
   AllowContinuation__c=True,
   Available_With__c='Accounts;Contacts;Qualification__cs',
   Use_Scoring__c=True,
   Passing_Score__c=0,
   WriteToObject__c='Qualification__c',
   ReturnToType__c='ReturnURL');
   insert s1; 

SFDC_Script__c  s2= new SFDC_Script__c(   
   RecordTypeId=sfdcrt.Id,
   AllowContinuation__c=false,
   Available_With__c='Accounts',
   Use_Scoring__c=True,
   Passing_Score__c=0
);
   insert s2;    
   SiteScript scriptTest = new SiteScript(s1.id);
   SiteScript scriptTest2 = new SiteScript(s2.id);
     
      
SFDC_Questions__c q1 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please enter Account Name',
    ShortName__c='myName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Account Name', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='testAccount',
    DataType__c='TEXT'
    );   
    insert q1;
    
SFDC_Questions__c q2 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myFax',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Fax', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DefaultAnswer__c='10101',
    DataType__c='TEXT'
    );
    insert q2;
         
SFDC_Questions__c q3 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myWebsite',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Website', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DefaultAnswer__c='www.dupont.com',
    DataType__c='TEXT'
    );
    insert q3;  
    
SFDC_Questions__c q4 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='relatedAccount',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Account Id', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=false,
    IsRequired__c=false,
    DefaultAnswer__c=acc.id,
    DataType__c='TEXT',
    WriteToField__c='Account_Name__c',
    AllowChange__c=True
    );
    insert q4;
    
    
SFDC_Questions__c q5 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='otherPhone',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Phone Number', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='1010101',
    DataType__c='Text'
    ); 
    insert q5;   
   

SFDC_Questions__c q6 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please fill the street name',
    ShortName__c='myStreetName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Mailing Street', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='Hosur road',
    DataType__c='TEXT'
    ); 
    insert q6;
    
SFDC_Questions__c q7 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please fill the city name',
    ShortName__c='myCityName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Mailing City', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='Bangalore',
    DataType__c='TEXT'
    );
    insert q7;  
    
SFDC_Questions__c q8 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please fill the state name',
    ShortName__c='myStateName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Mailing State', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='Florida',
    DataType__c='PICKLIST'
    );
    insert q8; 
    
SFDC_Questions__c q9 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please fill the zipcode',
    ShortName__c='myZipCode',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='ZipCode', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='560100',
    DataType__c='TEXT'
    ); 
    insert q9;
    
SFDC_Questions__c q10 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please fill the country name',
    ShortName__c='myCountryName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Country', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='Bangalore',
    DataType__c='PICKLIST'
    );
    insert q10; 
    
SFDC_Questions__c q11 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c='Please enter Email',
    ShortName__c='myContactEmail',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Email', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='jharna_Sinha@infosys.com',
    DataType__c='TEXT'
    );   
    insert q11;
    
SFDC_Questions__c q12 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='RelatedContact',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Email Address', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c=con.id,
    DataType__c='TEXT',
    WriteToField__c='Related_Contact__c'
    );   
    insert q12; 
    
SFDC_Questions__c q13 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myLastName',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Contact Name', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=true,
    DefaultAnswer__c='Authorization01',
    DataType__c='Text'
    ); 
    insert q13; 
    
SFDC_Questions__c q14 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myOptin',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='I wish to receive product and/or promotional communications by e-mail/fax/SMS/M', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DataType__c='Checkbox',
    DefaultAnswer__c='true'
    ); 
    insert q14;  
    
SFDC_Questions__c q15 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myComments',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='Comments', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DataType__c='Textarea',
    DefaultAnswer__c='testing'
    ); 
    insert q15;  

SFDC_Questions__c q16 = new SFDC_Questions__c( 
    ValidationRegEx__c=null,
    ValidationError__c=null,
    ShortName__c='myOptin',
    Script__c=s1.id,
    SaveResult__c=true,
    Name='I wish to receive product and/or promotional communications by e-mail/fax/SMS/M', 
    MinNumber__c=null, 
    MaxNumber__c=null,
    IsVisible__c=true,
    IsRequired__c=false,
    DataType__c='Checkbox',
    DefaultAnswer__c='true'
    ); 
    insert q16; 
    
 con.Opt_In__c=true;
 update con;
 system.assertequals(con.Opt_In__c,true);        
//insert new LIST<SFDC_Questions__c> {q1,q2,q3,q4,q5,q6,q7,q8,q9,q10};

SFDC_Answer__c testAns1 = new SFDC_Answer__c(Score__c=0, Order__c=1, Answer__c='A', Questions__c=q1.id);
SFDC_Answer__c testAns2 = new SFDC_Answer__c(Score__c=0, Order__c=2, Answer__c='S', Questions__c=q2.id);
SFDC_Answer__c testAns3 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='C', Questions__c=q3.id);
SFDC_Answer__c testAns4 = new SFDC_Answer__c(Score__c=0, Order__c=4, Answer__c='D', Questions__c=q4.id);
SFDC_Answer__c testAns5 = new SFDC_Answer__c(Score__c=0, Order__c=5, Answer__c='R', Questions__c=q5.id);
SFDC_Answer__c testAns6 = new SFDC_Answer__c(Score__c=0, Order__c=3, Answer__c='T', Questions__c=q6.id);
SFDC_Answer__c testAns7 = new SFDC_Answer__c(Score__c=0, Order__c=7, Answer__c='R', Questions__c=q7.id);

insert new LIST<SFDC_Answer__c> {testAns1,testAns2,testAns3,testAns4,testAns5,testAns6,testAns7};


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
SFDC_FollowOnQuestion__c fq12 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q12.id, QuestionOrder__c=12);
SFDC_FollowOnQuestion__c fq13 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q13.id, QuestionOrder__c=13);
SFDC_FollowOnQuestion__c fq14 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q14.id, QuestionOrder__c=14);
SFDC_FollowOnQuestion__c fq15 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q15.id, QuestionOrder__c=15);
SFDC_FollowOnQuestion__c fq16 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q16.id, QuestionOrder__c=16);
insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8,fq9,fq10,fq11,fq12,fq13,fq14,fq15,fq16};

Campaign cmp= new Campaign(name='BI Opt-In member List', isActive=true);
insert cmp;
CampaignMember cm= New CampaignMember(CampaignId=cmp.id, ContactId= con.Id , Status='Member-Opt-In');
insert cm;

   

Material__c materialvalue= new Material__c(name='BI Authorization',Owning_Org__c='BI');
insert materialvalue;
material__c m1=new Material__C(name='material1',Parent_Material__c=materialvalue.id );
insert m1;
material__c m2=new Material__C(name='material2',Parent_Material__c=materialvalue.id );
insert m2;
material__c m3=new Material__C(name='material3',Parent_Material__c=materialvalue.id );
insert m3;  

system.debug(materialvalue.id);
Account_Material__c accountMaterial1 = new Account_Material__c(RecordTypeId=accmatrt.Id,Account_Name__c=acc.id,Line_Description__c='test desc',Product_Name__c=materialvalue.id);
Account_Material__c accountMaterial2 = new Account_Material__c(RecordTypeId=accmatrt.Id,Account_Name__c=acc.id,Line_Description__c='test desc',Product_Name__c=materialvalue.id);
insert new LIST<Account_Material__c> {accountMaterial1,accountMaterial2};

////////////////////////////////

Material__c productvalue=new Material__c(name='Corian');
insert productvalue;
Material__c productvalue1=new Material__c(name='Zodiaq');
insert productvalue1;
Account_Material__c accountMaterial3 = new Account_Material__c(RecordTypeId=accmatrt.Id,Account_Name__c=acc.id,Line_Description__c='test desc',Product_Name__c=productvalue.id);
insert accountMaterial3;

////////////////////////////////
boolean flag=false;
//System.assertEquals(acc.Mb_of_Marketing_Program__c,'Authorized Retailer'); 
            String[] tmpString = acc.Mb_of_Marketing_Program__c.split(';');
            for(String s: tmpString ){
            if (s=='Authorized Retailer'){
            flag=true;
            break;
            }
            }
            if(flag==false)
            acc.Mb_of_Marketing_Program__c=acc.Mb_of_Marketing_Program__c + ';' + 'Authorized Retailer';

ctrlBIRetailerAuth ctrObj=new ctrlBIRetailerAuth();
ctrObj.SelectedProducts.add(new SelectOption(productvalue.name,productvalue.name));
   ctrObj.script=scriptTest;
   ctrObj.script2=scriptTest2;
   ctrObj.init();
   ctrObj.save(); 
   apexpages.currentpage().getparameters().put('Id',acc.id);
   ctrObj.SelectedMaterials.add(new SelectOption(m2.name,m2.name));
   ctrObj.searchProduct='material1';
   ctrObj.searchProductValue(); 
   ctrObj.productAnswer();
   ctrObj.noProduct=false;
   ctrObj.script.getQuestion('myOptin').answer='true';
   ctrObj.productAnswer2();
     
 
ctrlBIRetailerAuth ctrObj2=new ctrlBIRetailerAuth();
   ctrObj2.script=scriptTest;
   ctrObj2.script2=scriptTest2;
   ctrObj2.init();
   ctrObj2.save(); 
   ctrObj2.searchProduct='one';
   ctrObj2.searchProductValue(); 
   ctrObj2.productAnswer();
   ctrObj2.productAnswer2();
   
ctrlBIRetailerAuth ctrObj3=new ctrlBIRetailerAuth();
ctrObj3.SelectedProducts.add(new SelectOption(productvalue.name,productvalue.name));
   ctrObj3.SelectedProducts.add(new SelectOption(productvalue1.name,productvalue1.name));  
   ctrObj3.script=scriptTest;
   ctrObj3.script2=scriptTest2;
   ctrObj3.init();
   ctrObj3.SelectedMaterials.add(new SelectOption(m2.name,m2.name));
   ctrObj3.SelectedMaterials.add(new SelectOption(m3.name,m3.name));
   ctrObj3.save(); 
   ctrObj3.searchProduct='two';
   ctrObj3.searchProductValue(); 
   ctrObj3.script.getQuestion('myOptin').answer='false';      
   ctrObj3.productAnswer();
   ctrObj3.productAnswer2();
                  
}
}





}
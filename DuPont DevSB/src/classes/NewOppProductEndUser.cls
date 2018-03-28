/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Constructor Class to override the New button on the custom
         Opportunity Products related list.
Modifications: <AB20140324> for to handle 'System.ListException: List index out of bounds: 0'
********************************************************************************/

public class NewOppProductEndUser {

opportunity_products__c o;
opportunity []oppo;
list__c []l;
public string RetOppId{get;set;}
public string OppName{get;set;}
public string accname{get;set;}
public id accid{get;set;}
public string accidd{get;set;}
public string accnma{get;set;}
public string rectype{get;set;}
string returl;
string returl1;
id rect;
recordtype r;
string recordid;

public NewOppProductEndUser(ApexPages.StandardController controller) {
    returl=apexpages.currentpage().getparameters().get('retURL'); 
    rect=apexpages.currentpage().getparameters().get('RecordType');   
    recordtype r=[select id,name from recordtype where id=:rect];  
    rectype=r.name;
    
   
    List<String> s=new List<String>();
    s=returl.split('/');
    integer sizee=s.size();
    String s1=s[sizee-1];
    s1=s1.substring(0,15);
    //RetOppId=returl.substring(1,16);
    RetOppId=s1;
    
    oppo=[select Account.name,recordtype.name,account.id,id,name from opportunity where id=:RetOppId];
    //<AB20140324> Starts
    if(oppo == null){
        oppo=[select Account.name,recordtype.name,account.id,id,name from opportunity where id=:returl];        
    }
    else if(oppo != null && oppo.size() == 0){
        oppo=[select Account.name,recordtype.name,account.id,id,name from opportunity where id=:returl];        
    } 

    if(oppo != null && oppo.size() != 0){
        OppName=oppo[0].name;   
        accname=oppo[0].account.name;
        accid=oppo[0].account.id;
        l=[select name,code_1__c,code_2__c,code_3__c from list__c where name=:rectype];   
        if(l.size()!=0){
            accidd=l[0].code_1__c;
            accnma=l[0].code_2__c;
        }
    }//<AB20140324> Ends
}
Public opportunity_products__c getOppprods(){
    
    if(o==null){
        o=new opportunity_products__c(opportunity__c=RetOppId,recordtypeid=rect);       
    }
    return o;

}

/*****************************************************
Function called from the page "NewOppProductReference"
for the onclick event of the New button on the custom
Opportunity Products related list.
*****************************************************/

public PageReference CheckRecordType(){
    if(l.size()!=0){       
        if(apexpages.currentpage().getparameters().get('RecordType')==l[0].code_3__c){
            
            PageReference customPage;
            custompage = new PageReference('/apex/NewOppProductPage?'); 
            custompage.getParameters().put('retURL',oppo[0].id);
            String a = apexpages.currentpage().getparameters().get('retUrl');          
            if (ApexPages.currentPage().getParameters().containsKey('RecordType')) 
                custompage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType')); 
            custompage.setRedirect(true); 
            return custompage;

        }
    }
    else if(l.size()==0){
        
        //[20170102] Merge&Spin: Used custom settings to store field ID and remove hardcoding
        Object_Field_ID_Mapping__c objectFieldID = Object_Field_ID_Mapping__c.getInstance('Opportunity-Product_Opportunity');     
        
        pagereference page;
        page = new PageReference('/a07/e?'); 
        page.getParameters().put('retURL',oppo[0].id);        
        page.getParameters().put(objectFieldID.Field_ID__c,oppo[0].name);
        if (ApexPages.currentPage().getParameters().containsKey('RecordType')) 
            page.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType')); 
        page.getParameters().put('nooverride','1');
        page.setRedirect(true); 
        return page;
    }
    return null;
}
/*****************************************************
Function called from the page "NewOppProductPage"
for the onclick event of the Save button on the custom
Visualforce page for edit Opportunity Products.
*****************************************************/

public PageReference savechange() {
    
    product2 []p=[select id,name from product2 where name=:o.productofopportunity__c];
    if (p.size()!=0){
        o.productofopportunity__c=p[0].id;
    }
    else if (p.size()==0){
        PageReference customPage1;
            custompage1 = new PageReference('/apex/NewOppProductPage?'); 
            custompage1.getParameters().put('retURL',oppo[0].id);
            if (ApexPages.currentPage().getParameters().containsKey('RecordType')) 
                custompage1.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType')); 
            custompage1.setRedirect(true); 
            return custompage1;   
    }
    opportunity_products__c o1=new opportunity_products__c(opportunity__c=o.opportunity__c,productofopportunity__c=o.productofopportunity__c,CurrencyIsoCode=o.CurrencyIsoCode,Line_Description__c=o.Line_Description__c,quantity__c=o.quantity__c,sales_price__c=o.sales_price__c,recordtypeid=o.recordtypeid);
    insert o1;
    PageReference opptyPage = new PageReference('/' +o1.id);
    opptyPage.setRedirect(true);
    return opptyPage;
    return null;
}

/*****************************************************
        Test Methods
*****************************************************/
/*
public static testMethod void NewOppProductEndUser() {
                             
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        //[20170103] Merge&Spin: Remove hardcoded record type ID
        recordtype r=[select id,name from recordtype where developername=:'DPTIPP' limit 1];
        opportunity o=new opportunity(name='testopp',accountid=a.id,StageName='Target',CloseDate=system.today());
        insert o;
        string rectype;
        id recid;
        rectype=r.name;
        recid=r.id;
        system.debug('+++++recid++++'+recid);
        list__c l=new list__c(name=rectype,code_3__c=recid);
        insert l;
        product2 p;
        p =new product2(name='testproduct');
        insert p;
        opportunity_products__c opc;
        opc=new opportunity_products__c(opportunity__c=o.id,recordtypeid=recid,productofopportunity__c=p.id);
        insert opc;
        Test.startTest();        
        PageReference pageRef = new PageReference('/apex/NewOppProductPage?');
        Test.setCurrentPage(pageRef);
        string abc=o.id;
        ApexPages.currentPage().getParameters().put('retURL',abc);
        ApexPages.currentPage().getParameters().put('RecordType',r.id);
        ApexPages.StandardController setCon = new ApexPages.StandardController(opc);
        NewOppProductEndUser controller=new NewOppProductEndUser(setCon);
        controller.CheckRecordType();
        controller.getOppprods();
        controller.savechange();
        Test.stopTest();
    }  */
}
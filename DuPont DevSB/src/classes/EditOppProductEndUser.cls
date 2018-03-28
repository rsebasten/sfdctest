/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Constructor Class to override the Edit button on the custom
         Opportunity Products related list.
********************************************************************************/

public class EditOppProductEndUser {

opportunity_products__c o;
opportunity_products__c opc;
opportunity_products__c o111;
opportunity oppo;
list__c []l;
public string OppName{get;set;}
public id accid{get;set;}
public string accidd{get;set;}
public string accnma{get;set;}
public string accname{get;set;}
public string prname{get;set;}
string i;

public EditOppProductEndUser(ApexPages.StandardController controller) {
    opc=[select id,Total_Price__c,quantity__c,sales_price__c,RecordType.name,Name,Opportunity__c,CurrencyIsoCode,Line_Description__c,ProductOfOpportunity__c from opportunity_products__c where id=:System.currentPageReference().getParameters().get('id')];
    oppo=[select Account.name,account.id,id,name,recordtype.name from opportunity where id=:opc.opportunity__c];
    product2[] a=[select name,id from product2 where id=:opc.ProductOfOpportunity__c];
    if(a.size()!=0)
        prname=a[0].name;
    else if(a.size()==0)
        prname=null;
    OppName=oppo.name;
    accname=oppo.account.name;
    accid=oppo.account.id;
    l=[select name,code_1__c,code_2__c,code_3__c from list__c where name=:opc.recordtype.name];
    if(l.size()!=0){
        accidd=l[0].code_1__c;
        accnma=l[0].code_2__c;
    }
}
public opportunity_products__c getoppd(){
    return opc;
}
public opportunity_products__c getoppd1(){
    o111=[select id,productofopportunity__c from opportunity_products__c where id=:opc.id];
    return o111;
}

/*****************************************************
Function called from the page "EditOppProductReference"
for the onclick event of the Edit button on the custom
Opportunity Products related list.
*****************************************************/

public PageReference CheckRecordType(){ 
    id i=apexpages.currentpage().getparameters().get('id');
    opportunity_products__c opci=[select id,recordtypeid from opportunity_products__c where id=:i];
    if(l.size()!=0){
        if(opci.recordtypeid==l[0].code_3__c){ 
            PageReference customPage; 
                    customPage= new PageReference('/apex/EditOppProductPage?'); 
            customPage.getParameters().put('id',opc.id);
                customPage.getParameters().put('retURL',oppo.id); 
                if(ApexPages.currentPage().getParameters().containsKey('RecordType')) 
                    customPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType')); 
                customPage.setRedirect(true);  
            return customPage; 
        }
    }
    else if(l.size()==0){
        pagereference page;
        page = new PageReference('/'+opc.id+'/e?'); 
            page.getParameters().put('retURL',oppo.id); 
            if (ApexPages.currentPage().getParameters().containsKey('RecordType')) 
                page.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType')); 
            page.getParameters().put('nooverride','1');
            page.setRedirect(true);  
            return page; 
    }
        return null;
}

/*****************************************************
Function called from the page "EditOppProductPage"
for the onclick event of the Save button on the custom
Visualforce page for edit Opportunity Products.
*****************************************************/

public PageReference savechange() {
    product2 []p=[select id,name from product2 where id=:opc.productofopportunity__c];
    if (p.size()!=0){
        opc.productofopportunity__c=p[0].id;
        o111.productofopportunity__c=p[0].id;
    }
    else if (p.size()==0){
        opc.productofopportunity__c=null;
        o111.productofopportunity__c=null;
    }
    upsert opc;
    PageReference opptyPage = new PageReference('/' +opc.id);
    opptyPage.setRedirect(true);
    return opptyPage;
    return null;
}


/*****************************************************
        Test Methods
*****************************************************/

public static testMethod void EditOppProductEndUser() {
        Account a = new Account(name='test',BillingStreet='14 Main St',BillingPostalCode='19711', Country__c='United States');
        insert a;
        //commented for dps
        //recordtype r=[select id,name from recordtype where id=:'01230000000pcOQ'];
        recordtype r=[select id,name from recordtype where developername=:'DPT_IPP_EMEA_END_USER'];//01230000000pcOQ

        opportunity o=new opportunity(name='testopp',accountid=a.id,StageName='Target',CloseDate=system.today());
        insert o;
        string rectype;
        id recid;
        rectype=r.name;
        recid=r.id;
        list__c l=new list__c(name=rectype,code_3__c=recid);
        insert l;
        product2 p;
        p =new product2(name='testproduct');
        insert p;
        opportunity_products__c opc;
        opc=new opportunity_products__c(opportunity__c=o.id,recordtypeid=recid,productofopportunity__c=p.id);
        insert opc;
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/EditOppProductPage?');
        Test.setCurrentPage(pageRef);
        string abc=o.id;
        ApexPages.currentPage().getParameters().put('id',opc.id);
        ApexPages.StandardController setCon = new ApexPages.StandardController(opc);
        EditOppProductEndUser controller=new EditOppProductEndUser(setCon);
        controller.getoppd();
        controller.getoppd1();
        controller.CheckRecordType();
        controller.savechange();
        Test.stopTest();
 }  
}
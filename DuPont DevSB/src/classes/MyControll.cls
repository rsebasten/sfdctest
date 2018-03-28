public class MyControll {
//private final opportunity_products__c ops; //1-16-17 commented by OrgSplit project since the references were commented in the below code
opportunity opp;
public id nam{get;set;}
public MyControll() {
opp=[select id, name from opportunity where id =:ApexPages.currentPage().getParameters().get('id')];
//nam=name;
//ops = [select id,ProductOfOpportunity__c,opportunity__c,name from opportunity_products__c where opportunity__c =
//:opp.name];
}
public MyControll(id name)
{
nam=name;
system.debug(nam);
}
public mycontroll getmycontroll() 
{ 
id n;
//n=ops.ProductOfOpportunity__c;
n=opp.id;
return new mycontroll(n);
}
public PageReference save() {
update opp;
return null;
}
}
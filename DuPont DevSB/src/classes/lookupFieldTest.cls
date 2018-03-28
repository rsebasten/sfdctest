public class lookupFieldTest {

    public lookupFieldTest(ApexPages.StandardController controller) {

    }


public opportunity_products__c getlookupFieldTest() 
{
Id id = System.currentPageReference().getParameters().get('id'); 
return id == null ? new opportunity_products__c() : [SELECT Id,productofopportunity__r.recordtype.name FROM opportunity_products__c WHERE productofopportunity__r.recordtype.name like'DPT%'];  

//String lookupParam = ApexPages.currentPage().getParameters().get('lookup');
//String Qry = 'select id from opportunity_products__c where' + lookupParam + '!=null';
//List<opportunity_products__c> P = Database.Query(Qry); 
  // return P;
    }
}
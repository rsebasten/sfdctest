public with sharing class ctrlBINA_SurfaceVFPanel {
    public entitlement en;
    private case cs;
    public contact con {get;set;}
    public ctrlBINA_SurfaceVFPanel (ApexPages.StandardController controller) {    
       string id= ApexPages.currentPage().getParameters().get('ID');
       if ([SELECT ID from entitlement where Id=:id].size()==0){
          en=[SELECT Id, Primary_Contact__c from entitlement where Id In (select EntitlementID from case where Id=:id)];
        }
       else {
          en = [SELECT Id, Primary_Contact__c from entitlement where Id=:id];
        }
    con=[select firstname,lastname,Email,MailingCity,Mailingstreet,MobilePhone,Phone,MailingState,MailingPostalCode,MailingCountry from contact where id=:en.primary_Contact__c];
   }
}
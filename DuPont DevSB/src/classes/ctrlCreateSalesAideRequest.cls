public class ctrlCreateSalesAideRequest {
    private static final Id SAR_CAPTURE_RTYPE    =   utilRT.getRT('Request__c','SalesAidCapture').Id;
    private String Id;

    public ctrlCreateSalesAideRequest() {
        id = Apexpages.currentPage().getParameters().get('ID');
    }
    
    public PageReference redirect() {
        Request__c r = null;
        if (id.startsWith('003')) {
            Contact c = [SELECT ID, AccountId, Account.Name, FirstName, LastName, MailingStreet, MailingCity, MailingPostalCode, MailingState, Contact_Country__c, Phone, Email from Contact where Id = :id];
            r = new Request__c();
            r.RecordTypeId = SAR_CAPTURE_RTYPE;
            r.Account__c = c.AccountId;
            r.Contact__c = c.id;
            r.Send_to_Company__c = c.Account.Name;
            r.Send_to_Contact__c = c.FirstName + ' ' + c.LastName;
            r.Request_Shipping_City__c = c.MailingCity;
            r.Request_Shipping_Country__c = c.Contact_Country__c;
            r.Request_Shipping_Postal_Code__c = c.MailingPostalCode;
            r.Request_Shipping_State__c = c.MailingState;
            r.Request_Shipping_Street__c = c.MailingStreet;
            r.Phone__c = c.Phone;
            r.Email__c = c.Email;
            insert r;
        }
        else if (id.startsWith('00Q')) {
            Lead l = [SELECT ID, Company, FirstName, LastName, Street, City, PostalCode, State, Lead_Country__c, Phone, Email from Lead where Id = :id];
            r = new Request__c();
            r.RecordTypeId = SAR_CAPTURE_RTYPE;
            r.Lead__c = l.Id;
            r.Send_to_Company__c = l.Company;
            r.Send_to_Contact__c = l.FirstName + ' ' + l.LastName;
            r.Request_Shipping_City__c = l.City;
            r.Request_Shipping_Country__c = l.Lead_Country__c;
            r.Request_Shipping_Postal_Code__c = l.PostalCode;
            r.Request_Shipping_State__c = l.State;
            r.Request_Shipping_Street__c = l.Street;
            r.Phone__c = l.Phone;
            r.Email__c = l.Email;
            insert r;
        }
        if (r != null)
            return new PageReference('/' + r.Id + '/e?retURL=' + r.Id);
        else
            return null;
    }
}
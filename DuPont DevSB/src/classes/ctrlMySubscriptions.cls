public class ctrlMySubscriptions {

    public LIST<SiteObjectValue__c> sovs    {set; get;}
    public LIST<CampaignMember>     members {set; get;}
    public string                   email   {set; get;}
    
//////////////////////////////////////////////////////////////////////////////////////
    public pageReference init() {
        
        email = ApexPages.currentPage().getParameters().get('em');

        sovs = [
            SELECT Id, Value__c,  SiteObject__c, SiteObject__r.Id, SiteObject__r.Name, Name, LastUpdatedLocation__c, 
            LastModifiedDate, LastModifiedById, 
            ExternalId__c, Email__c,  ConnectionSentId, ConnectionReceivedId From SiteObjectValue__c s
            Where Email__c = : email
            ORDER BY SiteObject__r.Name
            ];
        
        
        
        members = [
            SELECT CampaignId, campaign.PublicName__c, Status, LeadId, ContactId,
             HasResponded, FirstRespondedDate
            From CampaignMember
            Where fEmail__c = : email and campaign.recordType.name='Subscriber List'
            ORDER BY campaign.PublicName__c Limit 1000
            
        ];
        
        
        
        return null;
    }
    
    
////////////////////////////////////////////////////////////////////////////////////
//      Test script(s)
////////////////////////////////////////////////////////////////////////////////////

public static testMethod void test_ctrlMySubscriptions() {

        Test.startTest();
        PageReference pageRef = Page.MySubscriptions;
        Test.setCurrentPage(pageRef);
        ctrlMySubscriptions controller = new ctrlMySubscriptions();
        controller.init();
        Test.stopTest();
    
    } 

}
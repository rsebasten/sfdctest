public with sharing class ctrlSalesAideItems {
    public Request__c request {get;set;}
    public Request_Item__c[] shoppingCart {get;set;}
    public Boolean canEdit {get; set;}
    public String searchString {get;set;}
    public Catalog_Item__c[] searchResults {get;set;}
    public Boolean overLimit {get;set;}
    public Boolean noRecords {get;set;}
    public String idToAdd {get; set;}
    public String idToRemove {get; set;}
    private Request_Item__c[] forDeletion = new Request_Item__c[]{};
    private static final Id SARI_CAPTURE_RTYPE   =   utilRT.getRT('Request_Item__c','SalesAidItemCapture').Id;
    private static final Id SAR_CAPTURE_RTYPE    =   utilRT.getRT('Request__c','SalesAidCapture').Id;
    private static final Id SAR_SUBMITTED_RTYPE    =   utilRT.getRT('Request__c','SalesAidSubmitted').Id;

    public ctrlSalesAideItems(ApexPages.StandardController controller) {
        request = [select Id, Name, Sample_Request_Catalog__c, RecordTypeId, Stage__c, Submitted_Datetime__c from Request__c where Id = :controller.getRecord().Id limit 1];
        if (request.Sample_Request_Catalog__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You must add a catalog to the request before adding items');
            ApexPages.addMessage(msg);
        }
        else {
            shoppingCart = [SELECT Id, Catalog_Item__c, Catalog_Item__r.Name, Catalog_Item__r.Catalog_Item_Name__c, Quantity__c, Catalog_Item__r.Unit_of_Measure__c, 
                        Catalog_Item__r.Quantity_Limit_Max__c, Special_Handling__c
                        FROM Request_Item__c where Request__c=:request.Id];
            canEdit = request.Stage__c == 'Capture';
            execSearch();
        }
    }
    
    public PageReference addToShoppingCart() {
        for(Catalog_Item__c ci : searchResults){
            if((String)ci.Id==idToAdd){
                Request_Item__c ri = new Request_Item__c(Request__c=request.Id, Catalog_Item__c=ci.Id, RecordTypeId=SARI_CAPTURE_RTYPE, Special_Handling__c = ci.Special_Handling__c);
                ri.Catalog_Item__r = ci;
                shoppingCart.add(ri);
                break;
            }
        }
        
        execSearch(); 
        return null;
     }
    
     public PageReference removeFromShoppingCart() {
        Integer row = 0;

         for(Request_Item__c ri : shoppingCart){
            if((String)ri.Catalog_Item__c==idToRemove){
                if(ri.Id!=null)
                    forDeletion.add(ri);
                shoppingCart.remove(row);
                break;
            }
            row++;
        }
        system.debug('Remove from cart:' +shoppingCart.size());        
        execSearch();
        return null;
     }
    
    public void execSearch() {
        String qString = 'select Id, Name, Catalog_Item_Name__c, Quantity_Limit_Max__c, Quantity_Limit_Min__c, Unit_of_Measure__c, Special_Handling__c from Catalog_Item__c where Item_Status__c=\'Active\' and Catalog__c =\'' + request.Sample_Request_Catalog__c + '\'';
        if(searchString!=null && searchString != ''){
            qString+= ' AND (Name Like \'%' + searchString + '%\' OR Catalog_Item_Name__c Like  \'%' + searchString + '%\' OR Reference_Keywords__c Like \'%' + searchString + '%\') ';
        }
        // Add filter for removing selected catalog items
        Set<Id> selectedEntries = new Set<Id>();
        for(Request_Item__c ri:shoppingCart){
            selectedEntries.add(ri.Catalog_Item__c);
        }
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
                
        qString+= ' order by Catalog_Item_Name__c';
        qString+= ' limit 51';
        
        system.debug('qString:' +qString);        
        searchResults = database.query(qString);
        overLimit = searchResults.size()==51;
        noRecords = searchResults.size()==0;
        if(overLimit){
            searchResults.remove(50);
        }
    }
    
    public PageReference onSubmit() {
        try{
            if(forDeletion.size()>0)
                delete(forDeletion);
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
            request.RecordTypeId = SAR_SUBMITTED_RTYPE;
            request.Stage__c = 'Submitted';
            request.Submitted_Datetime__c = string.valueOfGmt(System.now());
            update request;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }          
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onSave() {
        try{
            if(forDeletion.size()>0)
                delete(forDeletion);
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
     }
    
    public PageReference onCancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }    
}
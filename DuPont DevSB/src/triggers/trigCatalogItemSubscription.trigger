trigger trigCatalogItemSubscription on Catalog_Item_Subscription__c (after insert, before insert, 
before update) {

    //////////////////////////////////////////////////////////////////////////////////////////////////////
    //MAP lookup Object (Contact)
   /**  Not sure if we need this to validate address, or copy address over, etc...
    private Map<Id,Contact> Map_Contact() {
        Set<Id> ParentIds = new Set<Id>();
        for(Integer i=0;i<Trigger.size;i++) ParentIds.add(Trigger.new[i].Contact__c);
        return new MAP<Id,Contact>(
            [   
                SELECT Id, MailingStreet, Email  from Contact
                WHERE Id in :ParentIds
            ]);
    }
  ***/
  
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    //MAP lookup Object (Catalog_Item__c)
    private Map<Id,Catalog_Item__c> Map_CatItem() {
        Set<Id> ParentIds = new Set<Id>();
        for(Integer i=0;i<Trigger.size;i++) ParentIds.add(Trigger.new[i].CatalogItem__c);
        return new Map<Id,Catalog_Item__c>(
            [   
                SELECT Id, Subscription_Routing_Methods__c, Quantity_Limit_Max__c,
                  Quantity_Limit_Max_Action__c  from Catalog_Item__c
                WHERE Id in :ParentIds
            ]);
    }
    
    private MAP<id,LIST<Catalog_Item_Subscription__c>> Map_Siblings() {
        MAP<id,LIST<Catalog_Item_Subscription__c>> rtn = new MAP<id,LIST<Catalog_Item_Subscription__c>>();
        
        for(Integer i=0;i<Trigger.size;i++)
            rtn.put(Trigger.new[i].Contact__c, new LIST<Catalog_Item_Subscription__c>() );
      
        for (Catalog_Item_Subscription__c cis : 
            [   
                SELECT Id, Contact__c, CatalogItem__c, Routing_Method__c
                from Catalog_Item_Subscription__c
                WHERE Contact__c in :rtn.KeySet() ORDER by Contact__c
            ] ) {
                rtn.get(cis.Contact__c).add(cis);
            }
        return rtn;
    }  
    

    /*
    private LIST<Catalog_Item_Subscription__c> Map_Siblings() {
        Set<Id> ParentIds = new Set<Id>();
        for(Integer i=0;i<Trigger.size;i++) ParentIds.add(Trigger.new[i].Contact__c);
        return 
            [   
                SELECT Id, Contact__c, CatalogItem__c, Routing_Method__c
                from Catalog_Item_Subscription__c
                WHERE Contact__c in :ParentIds
            ];
    }  
    */


    //*********************************************************************************
    //BEFORE INSERT/Update
     //1. Check that the Routing Method is Supported By the Catalog Item.
    //*********************************************************************************/
    if(System.Label.Trigger_On_Off  == 'On'){   

        if ( Trigger.isBefore) {
            
            Map<Id,Catalog_Item__c> CatItem_info = Map_CatItem();
            Map<Id,LIST<Catalog_Item_Subscription__c>> Siblings = Map_Siblings();
            
            for(Integer i=0;i<Trigger.size;i++) {
                Catalog_Item_Subscription__c n = Trigger.new[i];
                Catalog_Item__c ci = CatItem_info.get(n.CatalogItem__c);
                
                //validate Quantity     
                CatalogItemSubscription.validateQuantity(n,ci);
                
                //validate Routing method
                if (Trigger.isInsert ) { 
                    CatalogItemSubscription.validateRoutingMethod(n,ci);
                        
                    if ( Siblings.containskey(n.Contact__c)) {                          
                        for (Catalog_Item_Subscription__c s : Siblings.get(n.Contact__c))
                            if (    s.Contact__c == n.Contact__c &&
                                    s.CatalogItem__c == n.CatalogItem__c &&
                                    s.Routing_Method__c == n.Routing_Method__c )
                                n.AddError(CatalogItemSubscription.ERR_DUPLICATE);  
                    }
                }
                
                if (Trigger.isUpdate) {
                    Catalog_Item_Subscription__c o = Trigger.old[i];
                    
                    
                    //Do not allow changes to...
                    //no longer needed (MD relation) -- if (n.Contact__c != o.Contact__c)                   n.Contact__c.AddError(CatalogItemSubscription.ERR_CANNOT_UPDATE_FIELD);
                    if (n.CatalogItem__c != o.CatalogItem__c)           n.CatalogItem__c.AddError(CatalogItemSubscription.ERR_CANNOT_UPDATE_FIELD);
                    if (n.Routing_Method__c != o.Routing_Method__c)     n.Routing_Method__c.AddError(CatalogItemSubscription.ERR_CANNOT_UPDATE_FIELD);
                    
                    //Quantity Change... Resubmit for Approval if required
                    else if (   n.Quantity__c       != o.Quantity__c && 
                                n.ApprovalStage__c  == CatalogItemSubscription.APPROVAL_STAGE_REQUIRED )
                        n.ApprovalStatus__c = CatalogItemSubscription.APPROVAL_STATUS_SUBMIT;
                
                    //Check for dups... Note only check for dups on committed records does not check for dups withing the batch
                    if (Siblings.containskey(n.Contact__c)) {   
                        for (Catalog_Item_Subscription__c s : Siblings.get(n.Contact__c) )
                            if (    s.Contact__c == n.Contact__c &&
                                    s.CatalogItem__c == n.CatalogItem__c &&
                                    s.Routing_Method__c == n.Routing_Method__c &&
                                    s.Id != o.Id )
                                n.AddError(CatalogItemSubscription.ERR_DUPLICATE);
                    }   
                }
                
                
                    
            }//next i 
    }

    // Auto submit
    if ( Trigger.isAfter) {
         for(Catalog_Item_Subscription__c n : Trigger.new )
            try {
                CatalogItemSubscription.AutoSubmitApproval(n);
            }
            catch(Exception ex) {} //NO_APPLICABLE_PROCESS
    }
    
   }
}
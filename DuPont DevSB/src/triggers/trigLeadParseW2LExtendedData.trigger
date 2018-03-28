/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 

<VL20170428>
Modified By: Vijay Laxmi
Modification Date: 28-Apr-2017
Modification: Added if conition to not run the trigger for CPSF Project Lead creation       
********************************************************************************/

trigger trigLeadParseW2LExtendedData on Lead (after insert) {
    
     
    string SITEOBJECT_PREFIX = SiteObject__c.sObjectType.getDescribe().getKeyPrefix();
    
    LIST<campaignMember> members = new LIST<campaignMember>();
    MAP<string,SiteObjectValue__c> SOVsToUpsert = new MAP<string,SiteObjectValue__c>();
    
    //<VL20170428>start
    if(!BI_CPUtil.CPSF_leadTrigPass){
    //<VL20170428>End 
    //MAP<Id,MAP<Id,string>> extendedData = new MAP<Id,MAP<Id,string>>();
    
    for (lead l : trigger.new) {
        if (l.W2L_ExtendedData__c!= null) {
                parseExtendedData(l);
        }
    }
    
    if (members.size()>0)
        //try {
            system.debug('insert members');
            insert members;
        //}
        //catch (exception ex) {}
    
    if (SOVsToUpsert.size()>0)
        //try {
            upsert SOVsToUpsert.values() ExternalId__c;
        //}
        //catch (exception ex) {}
    
    }
    /////////////////////////////////////////////////////////////////////////////
    private void parseExtendedData(lead l) {
        for (string i : l.W2L_ExtendedData__c.split(';',-2)) {
            string[] arr=i.split(':',-2);
            if  (arr.size()==2) {
                //Campaign Member entry
                if (i.startsWith('701')) {
                     members.add(new campaignmember(campaignid=arr[0],status=arr[1], leadid=l.id));
                    }
                else if (i.startsWith('00D') && l.email !=null) {
                    string SOVExternalId = arr[0]+l.email.toLowercase();
                    string opt = '';
                    if (arr[1].toLowerCase()=='in')  opt=SubscriptionCenter.OPT_IN;
                    if (arr[1].toLowerCase()=='out') opt=SubscriptionCenter.OPT_OUT;
                    SiteObject__c so = new SiteObject__c(ExternalId__c=arr[0]);
                    SOVsToUpsert.put(SOVExternalId, new SiteObjectValue__c(
                    ExternalId__c=SOVExternalId, 
                    SiteObject__r=so,
                    value__c=opt,
                    email__c=l.email.toLowercase(),
                    lastUpdatedLocation__c='Web2Lead'));        
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////  
}
/*************************************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Authors:        Divya Ramakrishnaiah, Thomas Snyder
Email:          divya.ramakrishnaiah@usa.dupont.com, thomas.snyder@usa.dupont.com/ tom@3ddd.com
Description:    Trigger handler for External Initiative
Event:          After Insert : 
                Create new Opportunities based on newly inserted External Initiative,
                of record type - 'BI_NA_External_Initiative'. Assignment is based on Project county.
                Before Update : 
                Create Opportunities related to External Initiative,
                of record type - 'BI_NA_External_Initiative', if not already present.  
Notes:          Best practice for bulk inserts of ExternalInitiative would be to sort the 
                the data to import by the state prior to upload. This is because all counties 
                are Mapped by each unique state per batch (typically 200 rows)
<KK20130828>
Modified By: Kusuma Kumar
Modification Date: 28-Aug-2013
Modification: Added a new method updateOpportunityOwner2 to update the Opportunity Owner2 field with the Contact based 
			  on the External Initiative parameters and Opportunity Rating,Net Amount and Application Type
<AB20160307>
Modified By: Abhinav Bhatnagar
Modification Date: 07-Mar-2016
Modification: Updated each method to avoid creating/updating any associated opportunities with External Intiative which have Stage set 
			   as 'Abandoned' OR 'Deferred'. This is done to accomodate the changes made at the side of Ingenium, third party partner which
				send payload to DuPont SQL Server. Earlier Ingenium used to send EI whose stage are not 'Abandoned' OR 'Deferred' OR 'Construct'
				However, for stage 'Construct' Every thing is to remain same.
<AB20160613>
Modified By: Abhinav Bhatnagar
Modification Date: 13-Jun-2016
Modification: Commented updateOpportunityOwner2() method in bulkAfter method to avoid updates on manully done owner2 changes.

<AS20160919>
Modified By: Arjun Sharma
Modification Date: 19-Sept-2016
Modification: Updated each method with new picklist value of Stage for Dodge data


***************************************************************************************************/
public without sharing class ExternalInitiativeHandler extends TriggerHandlerBase{
    public override void bulkAfter(){
        if(Trigger.IsInsert){
            addOpportunityOnInsert();
            /*<KK20130828>*/
            updateOpportunityOwner2();
        }
        /*<KK20130828>*/
       /*AB20160613 if(Trigger.IsUpdate){
        	updateOpportunityOwner2();
        } AB20160613*/
    }
    public override void bulkbefore(){
        if(Trigger.IsUpdate){
            updateExtInitWithOpps();
        }
    }
        
    /***************************************************
    For Record type : 'BI_NA_External_Initiative'
    Add Opportunities to External Initiative, based on 'External Search Name' field value
    ***************************************************/
    public void addOpportunityOnInsert(){
        List<External_Initiative__c> MHCExtInitList = new List<External_Initiative__c>();
        for (Sobject so  : this.getRecordsByRT('BI_NA_External_Initiative').values()){
            External_Initiative__c  extInitRec = (External_Initiative__c)so;
            //<AB20160307>
            if ( (extInitRec.Data_Source__c == Label.External_Initiative_Data_Source )  && ( extInitRec.stage__c!='Abandoned' && (extInitRec.stage__c!='Deferred' && extInitRec.stage__c!='Delayed'))) //<AS20160919>
            	MHCExtInitList.add(extInitRec);
        }
        BI_MHC.AddOpportunities(MHCExtInitList);
    }
    /***************************************************
    For Record type : 'BI_NA_External_Initiative'
    Before Update - Dont allow import of an older version of External Initiative
    Add Opportunities if not added earlier
    ****************************************************/
    public void updateExtInitWithOpps(){
        List<External_Initiative__c> MHCExtInitList = new List<External_Initiative__c>();
        External_Initiative__c  extInitRec;
        External_Initiative__c oldExtInitRec;
        for (Sobject so : this.getRecordsByRT('BI_NA_External_Initiative').values()){
            extInitRec = (External_Initiative__c)so;
            oldExtInitRec = (External_Initiative__c)Trigger.oldMap.get(extInitRec.Id);
            if(extInitRec.External_Version__c < oldExtInitRec.External_Version__c)
                extInitRec.External_Version__c.addError('Cannot update Commercial Project to a prior version.');
            //<AB20160307>
            if ( (extInitRec.Data_Source__c == Label.External_Initiative_Data_Source )  && ( extInitRec.stage__c!='Abandoned' && (extInitRec.stage__c!='Deferred' && extInitRec.stage__c!='Delayed'))) //<AS20160919>
            MHCExtInitList.add(extInitRec);
        }
        BI_MHC.AddOpportunities(MHCExtInitList);
    }
    
    /*<KK20130828>*/
    /***********************************************************
    For Record type : 'BI_NA_External_Initiative'
    After Update and After Insert - Updates the Opportunity Owner2 
    of the Opportunity records related to External Initiative.
    ************************************************************/
    public void updateOpportunityOwner2(){
        List<External_Initiative__c> MHCExtInitList = new List<External_Initiative__c>();
        for (Sobject so  : this.getRecordsByRT('BI_NA_External_Initiative').values()){
            External_Initiative__c  extInitRec = (External_Initiative__c)so;
            //<AB20160307>
            if ( (extInitRec.Data_Source__c == Label.External_Initiative_Data_Source || extInitRec.Data_Source__c == Label.CIC_External_Initiative_Data_Source)  && ( extInitRec.stage__c!='Abandoned' && (extInitRec.stage__c!='Deferred' && extInitRec.stage__c!='Delayed'))) //<AS20160919>
            MHCExtInitList.add(extInitRec);
        }
        BI_MHC.UpdateOpportunities(MHCExtInitList);
    }
}
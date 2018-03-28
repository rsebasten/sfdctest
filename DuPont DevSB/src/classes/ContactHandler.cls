/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Contact trigger handler

TES20131104 - Added logic for dealing with trigger sub-batching (this.hasFired)
********************************************************************************/
public with sharing class ContactHandler extends TriggerHandlerBase {
    public static boolean InProcess = false;   //avoid recursion,  public for UT


    public override void bulkBefore(){
        if (Trigger.IsInsert) {
            GeoValidation.geoValidateContact();
        }
            
        else if (Trigger.IsUpdate) {
            GeoValidation.geoValidateContact();
        }
        //NH_Contact_Helper.AssignRegion(this);
    } 

    public override void beforeInsert(SObject n) {
            Contact c = (Contact) n;
            //Hash email
            if (c.email!=null) c.EmailHash__c = System.Encodingutil.base64Encode(Blob.valueof(c.email));
    }
    
    public override void beforeUpdate(SObject o,SObject n) {
            Contact c   = (Contact) n;
            Contact old = (Contact) o;
            //Hash email
            if (c.email!=null) c.EmailHash__c = System.Encodingutil.base64Encode(Blob.valueof(c.email));
    }
        
    public override void bulkAfter(){
        if (!this.hasFired) //new sub-batch
            InProcess=false;
        if (!InProcess) {
            InProcess=true;
            if (Trigger.IsInsert) {
                EmailBase.contacts_OnAfter();
            }
            
            else if (Trigger.IsUpdate) {
                EmailBase.contacts_OnAfter();
            }
        }
    } 

}
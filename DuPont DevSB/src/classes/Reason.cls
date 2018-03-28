/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Primary class for Reason related methods
Last Modified By: Kusuma Kumar
Last Modified Date: 23th Jul 2012 
KK20120723 Added root__c field to Reason
********************************************************************************/
public class Reason {


    // This method is used from the trigReason to handle the 
    // taging of the inherited fields.
    public static void inherit(LIST<Reason__c> newReasons) {
        //get parents parent__c and seg.primaryReason__c (OneDupont Std)
        //these are used for getting the inherited details
        SET<string> parentIds = new SET<string>();
        SET<string> stdParentIds = new SET<string>();
        for (Reason__c rea : newReasons) {
            if (rea.parent__c!=null)            parentIds.add(rea.parent__c);
            if (rea.primaryReason__c!=null)    stdParentIds.add(rea.primaryReason__c);
        }
            
        MAP<Id,Reason__c> parents = new MAP<Id,Reason__c>([
            Select Id, ReasonL1__c,ReasonL2__c,ReasonL3__c,ReasonL4__c,Hierarchy__c, SIC__c,Root__c,
                StdReasonL1__c,StdReasonL2__c,StdReasonL3__c,StdReasonL4__c, StdHierarchy__c, StdSIC__c
            FROM Reason__c where Id in:parentIds
            ]);
            
        MAP<Id,Reason__c> stdParents = new MAP<Id,Reason__c>([
            Select Id, ReasonL1__c,ReasonL2__c,ReasonL3__c,ReasonL4__c,Hierarchy__c, SIC__c
            FROM Reason__c where Id in:stdParentIds
            ]);         
            
        //update the L1-L4, SIC and Hier via parent__c
        for (Reason__c rea : newReasons) {   
            system.debug(rea);
            Reason__c p=null;
            if (rea.parent__c!=null && parents.containsKey(rea.parent__c)!=null) {
                p = parents.get(rea.parent__c);
                if (rea.fLevel__c==1){
                    rea.ReasonL1__c=rea.Name;
                    rea.Root__c=rea.parent__c;
                }
                else if (rea.fLevel__c==2) {
                    rea.ReasonL1__c=p.ReasonL1__c;
                    rea.ReasonL2__c=rea.Name;
                    rea.ReasonL3__c=null;
                    rea.ReasonL4__c=null;
                    rea.Root__c=p.Root__c;
                }
                else if (rea.fLevel__c==3) {
                    rea.ReasonL1__c=p.ReasonL1__c;
                    rea.ReasonL2__c=p.ReasonL2__c;
                    rea.ReasonL3__c=rea.Name;  
                    rea.ReasonL4__c=null;
                    rea.Root__c=p.Root__c;  
                }
                else if (rea.fLevel__c==4) {
                    rea.ReasonL1__c=p.ReasonL1__c;
                    rea.ReasonL2__c=p.ReasonL2__c;
                    rea.ReasonL3__c=p.ReasonL3__c;
                    rea.ReasonL4__c=rea.Name;
                    rea.Root__c=p.Root__c;
                }
                string pref = (p.Hierarchy__c!=null) ? p.Hierarchy__c.replace('root','') : '';
                rea.Hierarchy__c=pref+'>'+rea.Name;
                rea.SIC__c=p.SIC__c;
                
            }
            
                //if primaryReason__c is defined the get details otherwise inherit from parent
            if (rea.primaryReason__c!=null && stdParents.containsKey(rea.primaryReason__c)) {
                    Reason__c stdp = stdParents.get(rea.primaryReason__c);
                        rea.StdReasonL1__c=stdp.ReasonL1__c;
                        rea.StdReasonL2__c=stdp.ReasonL2__c;
                        rea.StdReasonL3__c=stdp.ReasonL3__c;
                        rea.StdReasonL4__c=stdp.ReasonL4__c;
                        rea.StdHierarchy__c=stdp.Hierarchy__c;
                        rea.StdSIC__c=stdp.SIC__c;
                }
            else {
                if (p!=null) {
                    rea.StdReasonL1__c=p.StdReasonL1__c;
                    rea.StdReasonL2__c=p.StdReasonL2__c;
                    rea.StdReasonL3__c=p.StdReasonL3__c;
                    rea.StdReasonL4__c=p.StdReasonL4__c;
                    rea.StdHierarchy__c=p.StdHierarchy__c;
                    rea.StdSIC__c=p.StdSIC__c;
                }
            }

        }
    }


    //redirect to ReasonWizard if required
    public static PageReference redirectReasonIsRequired(SObject so) {
        PageReference returnURL;  

        if (so!=null) {
            try {
                string rtId = (string) so.get('RecordTypeId');    
                RecordTypeSettings__c rts = RType.getSettingsById(rtId);
                string ps = (string) so.get('PrimaryReason__c');
                system.debug('PrimaryReason__c:'+so.get('PrimaryReason__c'));
                //ps = [Select PrimaryReason__c from Opportunity where id=:so.id].PrimaryReason__c;
             
                if (rts!=null && rts.ReasonIsRequired__c && ps==null ) {
                    returnURL = Page.ReasonWizard;
                    returnURL.getParameters().put('rtype', rtId);
                    returnURL.getParameters().put('ancor', so.id);
                    returnURL.getParameters().put('req', '1');
                    returnURL.setRedirect(true);                          
                    return returnURL;  
                } 
            } catch(Exception ex){}
        }
        return null;
  
    }
    

}
/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Generic Controller for Any page to override the view

Currently this has a redirect to the segmentationWizard if the 
recordtypesettings__c.SegmentIsRequired__c = true and the primarySegment__c field 
is a valid field but is not not populated.

EX page stub:
<apex:page standardController="MyObject__c" 
    extensions="ctrlOverrideView" action="{!init}"/>
    
 Modification Log:
 <NC-20130621>
 Email :narmadha.chandrasekar@usa.dupont.com
 Description :Passing all the invoked parameters to Return URL
 ********************************************************************************/
public class ctrlOverrideView {

    public SObject so { get; set; }
    public string soid;
    
    public ctrlOverrideView(ApexPages.StandardController controller ) {
        try {
            // Add fields here needed for redirect criteria.
            // NOTE: the fields need to exists for all objects leverageing this controller,
            // also if you require many fields it would be better to pass the id to 
            // the method handling the redirect logic then to include them all here.
            controller.addFields(new LIST<string>{'id', 'recordtypeid'});
        } catch(Exception ex){}     
        //now that you added the fields you can load the object
        soid=controller.getId();
        so=controller.getRecord();
        system.debug(so);

    }


    public PageReference init(){   
        PageReference returnURL;  

        //Method used for Redirecting page the segmentation wizard if marked required
        //returns NULL if no redirect needed
        returnURL = Segmentation.redirectSegmentIsRequired(so); 
        //if (returnURL==null) returnURL=CLS.redirectCLSMember(so);  
        if (returnURL==null) returnURL=Reason.redirectReasonIsRequired(so);
        //if (returnURL==null) returnURL=CUPS.redirectCUPSRequest(so);
        //... //add additional redirects here

        //Return to standard Page
        if (returnURL==null) {
            returnURL=  new PageReference('/'+soid);
            returnURL.getParameters().putAll(ApexPages.currentPage().getParameters());//<NC-20130621>
            returnURL.getParameters().put('nooverride', '1');
            returnURL.setRedirect(false);  
        }                        
        return returnURL;     
    }


}
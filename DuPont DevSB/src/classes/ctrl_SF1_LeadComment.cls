/*******************************************************************************
Author: Martin Ryder
Email: martin.ryder@doextra.com
Description:  SF1_LeadComment controller class
********************************************************************************/
//simple controller extension to leads which prepends the product comments field with the entered text, matching the javascript button functionality.
//The corresponding visualforce page is marked as available for SF1 and mobile apps, and is intended to be added to the relevant Lead page layouts as a "mobile card".
//This should be 56 pixels high.

public class ctrl_SF1_LeadComment {
    public string newComment {get;set;}
    public Lead currentLead {get;set;}
    
    public ctrl_SF1_LeadComment(apexpages.StandardController sc){
        currentLead = (Lead)sc.getRecord();
        
    }
    public pagereference updateComment (){
        Date dt = date.today();
        String nm = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
		currentLead.Product_Comments__c = dt.format() + '(' + nm + ')\n-------------------------------------\n' + newComment + '\n\n' + currentLead.Product_Comments__c;
        update currentLead;
        return null;
    }
}
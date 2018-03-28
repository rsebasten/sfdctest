/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Constructor Class to select the right URL for the 
             onclick event of the button "Instruction" on the
             opportunity page layout.
********************************************************************************/

public class InstructionsSet{
opportunity oppo;
public InstructionsSet(ApexPages.StandardController controller) {
    oppo=[select id,recordtypeid from opportunity where id=:System.currentPageReference().getParameters().get('id')];
}

/*****************************************************
Function called from the page "InstructionReference"
for the onclick even of the Instruction button on 
opportunity page layout.
*****************************************************/

public pagereference CheckRecordType(){
    list__c []l;
    string recid;
    recid=oppo.recordtypeid;
    string recidtomap;
    recidtomap=recid.substring(0,15);
    l=[select id,Website__c,code_1__c,name,type__c from list__c where code_1__c=:recidtomap and type__c='Instruction URL'];
    if(l.size()!=null){
        PageReference customPage= new PageReference(l[0].website__c);
        customPage.setRedirect(true);
        return customPage;
    }
    if(l.size()==null){
        PageReference customPage= new PageReference('/'+oppo.id+'/');
        customPage.setRedirect(true);
        return customPage;
    }
    return null;
}




}
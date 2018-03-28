/**
*
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.0
*
* Copyright © 2010 DuPont. All rights reserved. 
*
* Controller for page: OppCompanyMassAdd
*/
 

public with sharing class ctrlOppCompanyMassAdd {
    public static final integer NUM_ROWS = 5;
    public LIST<Opportunity_Company__c> newRecords      { get; set; }
    public string oppid                                 { get; set; }
    public string ErrMsg                                { get; set; }
    public RecordTypeSettings__c rt=RType.getSettingsByFullName('Opportunity_Company__c.DPP_Polymers');    
    public Boolean getFlag(){         
      if(ApexPages.currentPage().getParameters().get('RecordType')==String.valueof(Rtype.getIdByDevName('Opportunity','DPP_Polymers')).substring(0,15)){
         return true;}
         else {return false;}
    }
         
    public List<SelectOption> getPickValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(String pickVal : rt.OppCompanyRole__c.split('&')){
            options.add(new SelectOption(pickVal, pickVal));  
        }     
        return options;
    }
    
    public ctrlOppCompanyMassAdd() {       
        oppid=ApexPages.currentPage().getParameters().get('oppid');
        Opportunity_Company__c rec = new Opportunity_Company__c(opportunity__c=oppid);            
        newRecords = new LIST<Opportunity_Company__c>();
        for (integer i=0; NUM_ROWS>i; i++) {
            newRecords.add(rec.clone());
        }
    }
/*
    public ctrlOppCompanyMassAdd(ApexPages.StandardController controller) {
        Opportunity_Company__c rec = (Opportunity_Company__c) controller.getRecord();
        
        newRecords = new LIST<Opportunity_Company__c>();
        for (integer i=0; NUM_ROWS<i; i++) {
            newRecords.add(rec.clone());
        }
    }
*/
    
    public PageReference Save() {
        ErrMsg='';
         LIST<Opportunity_Company__c> insertions = new  LIST<Opportunity_Company__c>();
         boolean err=false;
        for (Opportunity_Company__c r : newRecords) {
            if ( r.Company__c!=null && r.Company_Role__c!=null )
                insertions.add(r);
    
            else if ( r.Company__c!=null || r.Company_Role__c!=null ) {
                ErrMsg='Company and Role are Required.';
                err=true;
                }
        }
        if (!err) {
            insert insertions;
            return Done();
        }
        else { 
            //ApexPages.addMessage(new ApexPages.Message('Company and Role are Required.'));
            return null;
            }
    }
    
    public PageReference Done() {
        return new PageReference('/'+oppid);
    }


//*****************************************************************************************
// TEST Method(s)
//*****************************************************************************************
  /* public static testMethod void testOppCompanyMassAdd() {

        GeoValidation.DisableGeoValidationOverride=true;
        Account acc = new Account(name='TestCo: ', country__c='United States'); 
        insert acc;
        Opportunity opp = new Opportunity (account = acc, name='test', stagename='won', closedate=Date.TODAY() );
        insert opp;
        Test.startTest();
        PageReference pageRef = Page.OppCompanyMassAdd;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', opp.id);        
        ctrlOppCompanyMassAdd ctrl = new ctrlOppCompanyMassAdd();
       
       //Will err
        ctrl.newRecords[0].Company__c=acc.id;
        ctrl.save();
        
        //Will not err
        ctrl.newRecords[0].Company_Role__c = 'Prospect';
        ctrl.save();
        Test.stopTest();
    }  
  */
}
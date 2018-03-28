/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: OppInvestmentMassAdd
********************************************************************************/
public with sharing class ctrlOppInvestmentMassAdd {
        public static final integer NUM_ROWS = 5;
        public LIST<Opportunity_Investment__c> newRecords			{ get; set; }
        public string oppid											{ get; set; }
        public string ErrMsg										{ get; set; }
        
        
        public ctrlOppInvestmentMassAdd() {
                oppid=ApexPages.currentPage().getParameters().get('oppid');
                string rtypeid = Rtype.getIdByDevName('Opportunity_Investment__c', 'Opportunity_Resources');
                Opportunity_Investment__c rec = new Opportunity_Investment__c(
                        opportunity__c=oppid,
                        RecordTypeId=rtypeid
                        );
                
        
                newRecords = new LIST<Opportunity_Investment__c>();
                for (integer i=0; NUM_ROWS>i; i++) {
                        newRecords.add(rec.clone());
                }
        }

        
        public PageReference Save() {
                ErrMsg='';
                 LIST<Opportunity_Investment__c> insertions = new  LIST<Opportunity_Investment__c>();
                 boolean err=false;
                 
                 //Get the contact names to show as Opportunity_Investment__c.Name
                 SET<id> contactIds = new SET<id>();
                 for (Opportunity_Investment__c i : newRecords)
                        if ( i.Contact__c!=null)
                                contactIds.add(i.contact__c);
                 MAP<id,Contact> contactNames = new MAP<id,Contact> (
                        [Select Id, Name from Contact where id in: contactIds]);        
                        
                                
                for (Opportunity_Investment__c r : newRecords) {

                        if ( r.Contact__c!=null && (r.Role__c==null || r.FTE__c==null) ) {
                                ErrMsg='Role and FTE are Required.';
                                err=true;
                                }
                        else if ( r.Contact__c!=null) {
                                r.name='Resource: '+contactNames.get(r.Contact__c).Name;
                                insertions.add(r);
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
   public static testMethod void testOppInvestmentMassAdd() {

                Account acc = new Account(name='TestCo: ', country__c='United States'); 
                insert acc;
                Opportunity opp = new Opportunity (account = acc, name='test', stagename='won', closedate=Date.TODAY() );
                insert opp;
        Test.startTest();
        PageReference pageRef = Page.OppInvestmentMassAdd;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', opp.id);        
        ctrlOppInvestmentMassAdd ctrl = new ctrlOppInvestmentMassAdd();
       
       //Will err
        ctrl.newRecords[0].Contact__c=acc.id;
        ctrl.save();
        system.debug(ctrl.ErrMsg);

		//Will not err
        ctrl.newRecords[0].Role__c = 'Prospect';
        ctrl.save();
        system.debug(ctrl.ErrMsg);
        Test.stopTest();
    } 
 
  
}
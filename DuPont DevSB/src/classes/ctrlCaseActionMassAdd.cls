public with sharing class ctrlCaseActionMassAdd {
	
	private integer NUM_ROWS = 5;
	public LIST<Case_Action__c> newRecords				{ get; set; }
	public string id									{ get; set; }
	public string rtype									{ get; set; }
	public string ErrMsg								{ get; set; }
	//public Case_Action__c tmp							{ get; set; }
	
	public ctrlCaseActionMassAdd() { 
	//public ctrlCaseObjectMassAdd(ApexPages.StandardController controller) {
		id			=ApexPages.currentPage().getParameters().get('cid');
		rtype		=ApexPages.currentPage().getParameters().get('rt');
		string sz	=ApexPages.currentPage().getParameters().get('sz');
		if (Util.stringToInteger(sz)!=null) 
			NUM_ROWS=Util.stringToInteger(sz);		
		
		Case_Action__c tmp = new Case_Action__c(case__c=id);
		if (!Util.IsBlank(rtype))
			tmp.recordtypeid=rtype;
			
		newRecords = new LIST<Case_Action__c>();
		for (integer i=0; NUM_ROWS>i; i++) {
			newRecords.add(tmp.clone());
		}	
	}
	
	//ActionSubtype__c, ActionType__c
	public PageReference Save() {
		ErrMsg='';
		 LIST<Case_Action__c> insertions = new  LIST<Case_Action__c>();
		 boolean err=false;
		for (Case_Action__c r : newRecords) {
			if ( r.ActionType__c!=null && r.ActionSubtype__c!=null )
				insertions.add(r);
			else if ( r.ActionType__c!=null && r.ActionSubtype__c==null ) {
				ErrMsg=Label.CaseActionMassAddError_001;
				err=true;
				}
		}
		if (!err) {
			insert insertions;
			return Done();
		}
		else { 
			return null;
			}
	}
	
	public PageReference Done() {
		return new PageReference('/'+id);
	}

//*****************************************************************************************
// TEST Method(s)
//*****************************************************************************************
   public static testMethod void test_ctrlCaseActionMassAdd() {

		GeoValidation.DisableGeoValidationOverride=true;
		Account acc = new Account(name='TestCo: ', country__c='United States'); 
		insert acc;
		Case cs = new Case (account = acc); // stagename='won', closedate=Date.TODAY() );
		insert cs;
        Test.startTest();
        PageReference pageRef = Page.CaseActionMassAdd;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cid', cs.id);
		ApexPages.currentPage().getParameters().put('rt', null);
		ApexPages.currentPage().getParameters().put('sz', '6');          
        ctrlCaseActionMassAdd ctrl = new ctrlCaseActionMassAdd(); //ctrlCaseObjectMassAdd(new ApexPages.StandardController(new Case_Action__c()));
       
       //Will err
        ctrl.newRecords[0].ActionType__c='some val';
        ctrl.save();
        
		//Will not err
        ctrl.newRecords[0].ActionSubtype__c = 'some other val';
        ctrl.save();
        Test.stopTest();
    }  
}
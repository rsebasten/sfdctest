public class CatalogItemSubscription {

/**********************************************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Catalog Items Subscription

Delivery Method:  
----------------
A delivery Method can be will be set on create.  The Catalog Item contains a field called: 
Subscription_Rounting_Methods__c this field contains a list of availible delivery methods for
that item.


 Developer Notes:  This currently only supports 'Postal Service' but could easily allow 
 us to allow permit other delivery methods such as email, etc..  consider using a recordtype to drive the delivery method
 since each method would have different requirements. (i.e. Postal Service needs a quantity and physical address., 
	Email would requires an email address(es), and possibly a document to email, if delivering directly from SFDC.


Approval Stage/Status
---------------------
A change in Quantity will trigger an Approval Process if the Catalog_Item__c.Quantity_Limit_Max_Action__c
equals 'Approval' and the Quantity field exceeds the CreditItem field: Quantity_Limit_Max__c.

if Quantity_Limit_Max__c or Quantity_Limit__Max_Action__c  is null,  no action is performed.
if the Quantity_Limit_Max__c = 0 then the Approval Process will be submit on all quantity changes.

below are the Approval Stage/Status possibilities:

Stage    					Status		Description
-----						------		----------------
Approval Not Needed			N/A			No Approval Needed
Approval Required			Draft		Recall or Rejection has been issued, change quantity to resubmit
Approval Required			Submit		Approval has been Submitted, (also triggers the Approval Process on save)
Approval Required			Approved	Subscription has been Approved

Approval Process 
-----------------
	Inital Action:
		lock record.
	Recall Action:
		unlock record.
	Reject Action:
		unlock record.	
	Final Approval:
		1.  FIELD UPDATE: set status__c to 'Approved'.
		2.  FIELD UPDATE  copy the Quantity__c to ApprovedQuantity__c.
		3.  unlock record.


**********************************************************************************************************/


	public static final	string APPROVAL_STAGE_REQUIRED 			= 'Approval Required';
	public static final	string APPROVAL_STAGE_NOTREQUIRED 		= 'Approval Not Needed';
	public static final	string APPROVAL_STATUS_SUBMIT			= 'Submit';
	public static final	string ERR_CANNOT_UPDATE_FIELD 			= 'Cannot Update this Field.';
	public static final	string ERR_UNSUPPORTED_METHOD			= 'This Delivery method is not supported by this item.';
	public static final	string ERR_UNSUPPORTED_SUBSC			= 'This Catalog Item does not support subscriptions.';
	public static final	string ERR_EXCEED_MAX_QUANTITY			= 'You have exceeded the maximum quantity limit for this catalog item.';
	public static final string ERR_DUPLICATE					= 'Duplicate:  A record already exists for this Catalog Item and delivery method.';
/////////////////////////////////////////////////////////////////////////////////////////////////////	
	public static void validateQuantity(Catalog_Item_Subscription__c n, Catalog_Item__c ci) {
		try {
				if ( n.Quantity__c > ci.Quantity_Limit_Max__c ) {
					 	if (ci.Quantity_Limit_Max_Action__c == 'Approval') {
					 		n.ApprovalStage__c=APPROVAL_STAGE_REQUIRED;
					 	}
					 	else if (ci.Quantity_Limit_Max_Action__c == 'Error') {
					 		n.Quantity__c.AddError(ERR_EXCEED_MAX_QUANTITY + ' (Max:  '+ ci.Quantity_Limit_Max_Action__c + ')' );
					 	}
				}
				else {
					n.ApprovalStage__c=APPROVAL_STAGE_NOTREQUIRED;
					n.ApprovalStatus__c = 'N/A';
					n.ApprovedQuantity__c = n.Quantity__c;
				}
			}
			catch (Exception e) {
				n.ApprovalStage__c=APPROVAL_STAGE_NOTREQUIRED;
				n.ApprovalStatus__c = 'N/A';
				n.ApprovedQuantity__c = n.Quantity__c;
				system.debug('The Quantity_Limit_Max__c and/or Max_Quantity_Limit_Action__c are not specified so ignore any validation.');
			}
		system.debug('------> validateQuantity.ApprovalStage__c):' + n.ApprovalStage__c);
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////	
	public static void validateRoutingMethod(Catalog_Item_Subscription__c n,Catalog_Item__c ci) {
		try {
			system.debug('------> validateDeliveryMethod.Subscription_Delivery_Methods__c:' + ci.Subscription_Routing_Methods__c);
			system.debug('------> validateRoutingMethod.Routing_Method__c:' + n.Routing_Method__c);
			
			if ( ! ci.Subscription_Routing_Methods__c.contains(n.Routing_Method__c) )
        		n.Routing_Method__c.AddError(ERR_UNSUPPORTED_METHOD);
    	}
	     catch (Exception e) {
	     	n.CatalogItem__c.AddError(ERR_UNSUPPORTED_SUBSC);
	     }
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////
	public static void  AutoSubmitApproval(Catalog_Item_Subscription__c n) {
		if (n.ApprovalStatus__c == APPROVAL_STATUS_SUBMIT) {
			Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
			req.setObjectId(n.id);
			Approval.ProcessResult result = Approval.process(req);
		}
	}
	


static testMethod void test1() {
	
    Account Aa = new Account(name='Test Account1', country__c = 'UNITED STATES');
    insert new Account[]{Aa};
	Contact Ca = new Contact(lastname='Tester');
	Contact Cb = new Contact(lastname='Tester2');
	insert new Contact[]{Ca, Cb};
	
    Catalog__c CATa = new Catalog__c(name='Test Catalog');
    insert CATa;
    Catalog_Item__c CIa = new Catalog_Item__c(Catalog__c=CATa.Id,name='ItemA');
    Catalog_Item__c CIb = new Catalog_Item__c(Catalog__c=CATa.Id,name='ItemB', Quantity_Limit_Max__c=1, Quantity_Limit_Max_Action__c='Error', Subscription_Routing_Methods__c='Email;Postal Service;');
    Catalog_Item__c CIc = new Catalog_Item__c(Catalog__c=CATa.Id,name='ItemC', Quantity_Limit_Max__c=1, Quantity_Limit_Max_Action__c='Approval', Subscription_Routing_Methods__c='Email;Postal Service;');
    Catalog_Item__c CId = new Catalog_Item__c(Catalog__c=CATa.Id,name='ItemD', Subscription_Routing_Methods__c='Postal Service');
    Catalog_Item__c CIe = new Catalog_Item__c(Catalog__c=CATa.Id,name='ItemE', Quantity_Limit_Max__c=null, Quantity_Limit_Max_Action__c='Approval', Subscription_Routing_Methods__c='Email;Postal Service;');
  
    insert new Catalog_Item__c[]{CIa,CIb,CIc,CId, CIe};
    
    
	Test.startTest();   
	
	//Successful Insert
	Catalog_Item_Subscription__c Saa = new Catalog_Item_Subscription__c(CatalogItem__c=CIc.Id, Contact__c=Ca.Id, Quantity__c=2, Routing_Method__c='Email');
	Catalog_Item_Subscription__c Sab = new Catalog_Item_Subscription__c(CatalogItem__c=CIc.Id, Contact__c=Ca.Id, Quantity__c=1, Routing_Method__c='Postal Service');
	Catalog_Item_Subscription__c Sac = new Catalog_Item_Subscription__c(CatalogItem__c=CId.Id, Contact__c=Ca.Id, Quantity__c=3, Routing_Method__c='Postal Service');
	Catalog_Item_Subscription__c Sad = new Catalog_Item_Subscription__c(CatalogItem__c=CIb.Id, Contact__c=Ca.Id, Quantity__c=1, Routing_Method__c='Postal Service');
	Catalog_Item_Subscription__c Sae = new Catalog_Item_Subscription__c(CatalogItem__c=CIe.Id, Contact__c=Ca.Id, Quantity__c=1, Routing_Method__c='Postal Service');
	insert new Catalog_Item_Subscription__c[]{ Saa,Sab,Sac,Sad,Sae };
	//insert Saa;
	//insert Sab;
	//insert Sac;
	//insert Sad;
	//insert Sae;
	
	//UnSuccessful Inserts (Routing Method)
	Catalog_Item_Subscription__c Sb = new Catalog_Item_Subscription__c(CatalogItem__c=CIa.Id, Contact__c=Ca.Id, Quantity__c=1, Routing_Method__c='Email');
	try { insert Sb; } catch (DMLException e){}
	Sb.CatalogItem__c=CIc.Id;
	try { insert Sb; } catch (DMLException e){}	
	Sb.CatalogItem__c=CIa.Id;
	Sb.Routing_Method__c='Snail Mail';
	try { insert Sb; } catch (DMLException e){}	
	Sb.Routing_Method__c='Email';
	Sb.Quantity__c=null;
	try { insert Sb; } catch (DMLException e){}	
	
	
	
	//UnSuccessful Insert, Quantity Error
	Catalog_Item_Subscription__c Sc = new Catalog_Item_Subscription__c(CatalogItem__c=CIb.Id, Contact__c=Ca.Id, Quantity__c=2, Routing_Method__c='Email');
	try { insert Sc; } catch (DMLException e){}

	
	//Successful Update
	Sab.Quantity__c=2;
	update Sab; 
	
	
	
	//Unsuccessful Updates
	Saa.Routing_Method__c='BOGUS METHOD';
	try { update Saa; } catch (DMLException e){ System.Debug(e.getDMLMessage(0));} 
	Saa.Routing_Method__c='Postal Service';
	//try { update Saa; } catch (DMLException e){ System.Assert(e.getDMLMessage(0).indexOf(ERR_CANNOT_UPDATE_FIELD) > -1);} 
	try { update Saa; } catch (DMLException e){ System.Debug(e.getDMLMessage(0));} 
	Saa.Routing_Method__c='Email'; //go back to Email
	Saa.CatalogItem__c=CIa.Id;
	try { update Saa; } catch (DMLException e){ System.Debug(e.getDMLMessage(0));} 

    Test.stopTest();   
        
        
    }
   
	
}  //end class
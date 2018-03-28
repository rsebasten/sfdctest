/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Primary class for Segmentation related methods

TES20110601 Added root__c field to segmentation
********************************************************************************/
public class Segmentation {


	// This method is used from the trigSegmentation to handle the 
	// taging of the inherited fields.
	public static void inherit(LIST<Segmentation__c> newSegments) {
		//get parents parent__c and seg.primarySegment__c (OneDupont Std)
		//these are used for getting the inherited details
		SET<string> parentIds = new SET<string>();
		SET<string> stdParentIds = new SET<string>();
		for (Segmentation__c seg : newSegments) {
			if (seg.parent__c!=null) 			parentIds.add(seg.parent__c);
			if (seg.primarySegment__c!=null) 	stdParentIds.add(seg.primarySegment__c);
		}
			
		MAP<Id,Segmentation__c> parents = new MAP<Id,Segmentation__c>([
			Select Id, SegmentL1__c,SegmentL2__c,SegmentL3__c,SegmentL4__c,Hierarchy__c, SIC__c, Root__c,
				StdSegmentL1__c,StdSegmentL2__c,StdSegmentL3__c,StdSegmentL4__c, StdHierarchy__c, StdSIC__c
			FROM Segmentation__c where Id in:parentIds
			]);
			
		MAP<Id,Segmentation__c> stdParents = new MAP<Id,Segmentation__c>([
			Select Id, SegmentL1__c,SegmentL2__c,SegmentL3__c,SegmentL4__c,Hierarchy__c, SIC__c
			FROM Segmentation__c where Id in:stdParentIds
			]);			
			
		//update the L1-L4, SIC and Hier via parent__c
		for (Segmentation__c seg : newSegments) {	
			system.debug(seg);
			Segmentation__c p=null;
			if (seg.parent__c!=null && parents.containsKey(seg.parent__c)!=null) {
				p = parents.get(seg.parent__c);
				if (seg.fLevel__c==1) {
					seg.SegmentL1__c=seg.Name;
					seg.Root__c=seg.parent__c;
				}
				else if (seg.fLevel__c==2) {
					seg.SegmentL1__c=p.SegmentL1__c;
					seg.SegmentL2__c=seg.Name;
					seg.SegmentL3__c=null;
					seg.SegmentL4__c=null;
					seg.Root__c=p.Root__c;
				}
				else if (seg.fLevel__c==3) {
					seg.SegmentL1__c=p.SegmentL1__c;
					seg.SegmentL2__c=p.SegmentL2__c;
					seg.SegmentL3__c=seg.Name;	
					seg.SegmentL4__c=null;	
					seg.Root__c=p.Root__c;
				}
				else if (seg.fLevel__c==4) {
					seg.SegmentL1__c=p.SegmentL1__c;
					seg.SegmentL2__c=p.SegmentL2__c;
					seg.SegmentL3__c=p.SegmentL3__c;
					seg.SegmentL4__c=seg.Name;
					seg.Root__c=p.Root__c;
				}
				string pref = (p.Hierarchy__c!=null) ? p.Hierarchy__c.replace('root','') : '';
				seg.Hierarchy__c=pref+'>'+seg.Name;
				seg.SIC__c=p.SIC__c;
			}
			
				//if primarySegment__c is defined the get details otherwise inherit from parent
			if (seg.primarySegment__c!=null && stdParents.containsKey(seg.primarySegment__c)) {
					Segmentation__c stdp = stdParents.get(seg.primarySegment__c);
						seg.StdSegmentL1__c=stdp.SegmentL1__c;
						seg.StdSegmentL2__c=stdp.SegmentL2__c;
						seg.StdSegmentL3__c=stdp.SegmentL3__c;
						seg.StdSegmentL4__c=stdp.SegmentL4__c;
						seg.StdHierarchy__c=stdp.Hierarchy__c;
						seg.StdSIC__c=stdp.SIC__c;
				}
			else {
				if (p!=null) {
					seg.StdSegmentL1__c=p.StdSegmentL1__c;
					seg.StdSegmentL2__c=p.StdSegmentL2__c;
					seg.StdSegmentL3__c=p.StdSegmentL3__c;
					seg.StdSegmentL4__c=p.StdSegmentL4__c;
					seg.StdHierarchy__c=p.StdHierarchy__c;
					seg.StdSIC__c=p.StdSIC__c;
				}
			}

		}
	}


	//redirect to SegmentationWizard if required
	public static PageReference redirectSegmentIsRequired(SObject so) {
		PageReference returnURL;  

		if (so!=null) {
			try {
				string rtId = (string) so.get('RecordTypeId');    
				RecordTypeSettings__c rts = RType.getSettingsById(rtId);
				string ps = (string) so.get('PrimarySegment__c');
				system.debug('PrimarySegment__c:'+so.get('PrimarySegment__c'));
				//ps = [Select PrimarySegment__c from Opportunity where id=:so.id].PrimarySegment__c;
			 
				if (rts!=null && rts.SegmentIsRequired__c && ps==null ) {
					returnURL = Page.SegmentationWizard;
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
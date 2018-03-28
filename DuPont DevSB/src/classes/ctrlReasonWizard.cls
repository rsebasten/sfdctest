/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: ReasonWizard

Modifications:
TES20120208: Uses NodeBuilder, NodeBase, INode classes
TES20120612: extends NodeSelector
IS ID-00072807 added code for supporting IE 11
********************************************************************************/

public with sharing class ctrlReasonWizard extends NodeSelector {
    
    //public sobject            selected    {get; set;} 
    public string           id          {get; set;}
    public string           errMsg      {get; set;}
    
    
    
    public override PageReference init() {
        //kV 20160810 added code for supporting IE 11
        ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        
        //get scope Id from Legacy Reason fields if needed.
        scopeId = ApexPages.currentPage().getParameters().get('scope');
        if  (scopeId==null) {
            string rtypeId = ApexPages.currentPage().getParameters().get('rtype');
            if  (rtypeId==null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must provide a rtype or scope parmameter.')); return null; }
            RecordTypeSettings__c rts = Rtype.getSettingsById(rtypeId);
            if (rts==null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid or Missing CustomSetting: RecordTypeSettings for rtype: '+rtypeId)); return null; }
                else { 
                //get scopeId       
                try {
                    //create rootNode via recordtype (old method)
                    Reason__c seg = [ Select id from Reason__c
                        Where UniqueName__c =:rts.ReasonRoot__c ];
                    scopeId=seg.id;
                    System.currentPageReference().getParameters().put('scope',seg.id);
                }
                catch(Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Missing or Invalid ReasonRoot__c in RecordTypeSettings.\n\n'+ex)); 
                }
            }
        }
        super.init();
        
        selectedItem = ancorObject!=null ? ((ancorObject.get(ancorField)!=null) ? String.valueOf(ancorObject.get(ancorField)) : scopeId) : scopeId;
        return null;
    }

/*            
/////////////////////////////////////////
//  START: NodeBuilder Overrides
/////////////////////////////////////////
    public override MAP<id, sobject> createDataMap(SET<id> pIds) {
        MAP<id, Reason__c> rtn;
        if (pIds.size()!=0)
            rtn = new MAP<Id, Reason__c>([
                Select id, Name, parent__c, IsSelectable__c
                from Reason__c 
                Where parent__c in :pIds 
                ]);
        else
            rtn = new MAP<id, Reason__c>([
                    Select id, Name, parent__c, IsSelectable__c
                    from Reason__c 
                    Where parent__c=null
                    //LIMIT 2
                ]);
            system.debug(rtn);
            return rtn;
    }
    
    
    public override INode createNode(sobject s) {
        Reason__c obj = (Reason__c) s;
        INode rtn =  new NodeBase(obj.id, obj.name);
        rtn.setSelectable(obj.IsSelectable__c);
        rtn.setTitle(obj.Name);
        return rtn;
    }   
    
    
    public override PageReference onDblClick(string eventItem, INode n) {
        this.selectedItem=eventItem;
        return Add();
    }
    
/////////////////////////////////////////
//  END: NodeBuilder Overrides
/////////////////////////////////////////   
*/

    
}
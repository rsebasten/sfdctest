/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: SegmentationWizard

Modifications:
TES20120208: Uses NodeBuilder, NodeBase, INode classes
TES20120612: extends NodeSelector
TES20131023: bug ix to ensure ancor object is not null before inspects
IS ID-00072807 added code for supporting IE 11
********************************************************************************/

public with sharing class ctrlSegmentationWizard extends NodeSelector {
    
    //public sobject            selected    {get; set;} 
    public string           id          {get; set;}
    public string           errMsg      {get; set;}

    
    public override PageReference init() {
        //kV 20160824 added code for supporting IE 11
        ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        //get scope Id from Legacy Segmentation fields if needed.
        scopeId = ApexPages.currentPage().getParameters().get('scope');
        if  (scopeId==null) {
            string rtypeId = ApexPages.currentPage().getParameters().get('rtype');
            system.debug('++rtypeId+++'+rtypeId);
            if  (rtypeId==null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Must provide a rtype or scope parmameter.')); return null; }
            RecordTypeSettings__c rts = Rtype.getSettingsById(rtypeId);
            system.debug('++rts+++'+rts);
            if (rts==null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid or Missing CustomSetting: RecordTypeSettings for rtype: '+rtypeId)); return null; }
                else { 
                //get scopeId       
                try {
                    //create rootNode via recordtype (old method)
                    Segmentation__c seg = [ Select id from Segmentation__c
                        Where UniqueName__c =:rts.SegmentationRoot__c ];
                    scopeId=seg.id;
                    System.currentPageReference().getParameters().put('scope',seg.id);
                }
                catch(Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Missing or Invalid SegmentationRoot__c in RecordTypeSettings.\n\n'+ex)); 
                }
            }
        }
        //set the default field to bind
        System.currentPageReference().getParameters().put('ancorfld','primarySegment__c');
        super.init();
        selectedItem = (ancorObject!=null && ancorObject.get(ancorField)!=null) ? String.valueOf(ancorObject.get(ancorField)) : scopeId;
        return null;
    }
 
/*           
/////////////////////////////////////////
//  START: NodeBuilder Overrides
/////////////////////////////////////////
    public override MAP<id, sobject> createDataMap(SET<id> pIds) {
        MAP<id, Segmentation__c> rtn;
        if (pIds.size()!=0)
            rtn = new MAP<Id, Segmentation__c>([
                Select id, Name, parent__c, IsSelectable__c
                from Segmentation__c 
                Where parent__c in :pIds 
                ]);
        else
            rtn = new MAP<id, Segmentation__c>([
                    Select id, Name, parent__c, IsSelectable__c
                    from Segmentation__c 
                    Where parent__c=null
                    //LIMIT 2
                ]);
            system.debug(rtn);
            return rtn;
    }
    
    
    public override INode createNode(sobject s) {
        Segmentation__c obj = (Segmentation__c) s;
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
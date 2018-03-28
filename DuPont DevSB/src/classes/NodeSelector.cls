/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Abstract Base class for building a nodetree and treeView Selector handling 

TES20120530 Added 'max' parameter
TES20120607 Added 'del' parameter
TES20120619 Added 'dyna' and 'autocom' parameter
TES20130315 bug fix with deleting the primary (added break,  instead of return line: 344)
TES20130320 fix to mantain expand/contract state when using dynamic
TES20130322 fix to allow re-add to a recent delete
TODO: Add ability to support drag-drop
********************************************************************************/
public abstract class NodeSelector extends NodeBuilder {
    
    public static final string ERR_MAX_SELECTED_NODES = 'Maximum Items Selected.';
        
    public boolean      noAncorMode         {get; set;}             //if no ancor is defined this will be treated as a view only mode
    public string       ancortype           {get; set;}             //ancor object type, exposed for obtaining fieldset
    public string       primarySegment      {get; set;}             //Node Id of the primary segment
    public integer      deleteMode          {get; private set;}     //0=none;1=only unsaved;2=any ( 2 is untested);
    public boolean      showAutoComplete    {get; private set; }    //show the autocomplete control on UI           
    public sobject      ancorObject         {get; private set;}     //sObjectType of ancor object
    public boolean      isMulti             {get; set;}             //allow selection of multiple items otherwise returns to ancor object once selected     
    protected string    mcr;                                        //API childrelationship name (for multi node binding)
    protected string    mcrField;                                   //API fieldname on childrelationship object to bind the selected Nodes (for multi node binding)
    protected integer   maxSelectedNodes;                           //null=unlimited
    protected string    ancorId;                                    //Ancor id  - record to bind the primary selected node
    protected string    ancorField;                                 //API fieldname on ancor to bind primary selected node
    protected string    fs_snl;                                     //FieldSet: Selected Node List
    
    //event specific properties
    public string       event               {get; set;}
    public string       eventItem           {get; set;}
    public string       hierField           {get; set;}
    
    //selector specific properties 
    protected SelectedNodes         selectedNodes       {get; set;}
    public string                   selectedItem        {get; set;}
    
    //constructor
    public NodeSelector(){
        super();
        selectedNodes = new SelectedNodes();    
        noAncorMode=true;
    }
    

    public virtual PageReference init() {
        
        ////////////////////////////////////////////////////////////
        //get all parameters from rtype settings and url
        /////////////////////////////////////////////////////////// 
        string rtypeId      = System.currentPageReference().getParameters().get('rtype');
        string rtypesetting = System.currentPageReference().getParameters().get('setting');
        RecordTypeSettings__c rts = Rtype.getSettingsById(rtypeId);
        if (rtypesetting!=null && rts!=null && rts.get(rtypesetting)!=null ) {
            for (string parm : String.valueOf(rts.get(rtypesetting)).split('&')) {
                if (parm.contains('=')) {
                    string[] arr = parm.split('=');
                    if (! System.currentPageReference().getParameters().containsKey(arr[0].tolowercase()) )
                        System.currentPageReference().getParameters().put(arr[0].tolowercase(),arr[1]+'');
                }
            }
        }
        MAP<string,string> params = System.currentPageReference().getParameters();
        system.debug(params);
        scopeId             = params.get('scope');      
        ancorId             = params.get('ancor');
        ancorField          = params.get('ancorfld');
        isMulti             = (params.get('multi')!=null) ?  Util.stringToBoolean(params.get('multi')) : false;
        mcr                 = params.get('mcr');
        mcrField            = params.get('mcrfld');
        fs_snl              = params.get('fs_snl'); 
        hierField           = params.get('hierfld');
        maxSelectedNodes    = (params.get('max')!=null) ?  Util.stringToInteger(params.get('max')) : null;
        deleteMode          = (params.get('del')!=null && Util.stringToInteger(params.get('del'))!=null) ?  Util.stringToInteger(params.get('del')) : 0;
        dynamic             = (params.get('dyna')!=null) ?  Util.stringToBoolean(params.get('dyna')) : false;
        showAutoComplete    = (params.get('autocom')!=null) ?  Util.stringToBoolean(params.get('autocom')) : true;  
            
        if (!Util.isBlank(hierField)) 
            parentNodeField=hierField;
        ////////////////////////////////////////////////////////////        
        //load the nodes
        //TODO add load depth for dynamic transending
        if (Util.IsBlank(scopeId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Missing scope.'));
            return null;
        }
        
        load(); 

        ////////////////////////////////////////////////////////////
        // Ancor handling
        ////////////////////////////////////////////////////////////    
        if  (ancorId==null)  { 
            noAncorMode=true;  //if no ancor provided treat as view only interface
            selectedItem=rootNode.getId();
        }
        else {
            ancortype = Util.TypeById(ancorid);
            system.debug(scopeType);
            string default_ancorfield = (scopeType!=null && scopeType.endsWith('__c')) ? 'primary'+scopeType : 'primary'+scopeType+'__c';
            if (ancorField  ==  null) ancorField = default_ancorfield;
            if (mcrField    ==  null) mcrField = default_ancorfield;    
            noAncorMode=false;
            loadAncor();
        }

        return null;
    }
    

    public Schema.FieldSet selectListFieldSet {
        GET {
            if(fs_snl==null) return null;
            Schema.FieldSet rtn;
            try {
                    rtn = Schema.getGlobalDescribe().get(multiType).getDescribe().fieldSets.getMap().get(fs_snl);
            } catch(Exception ex){}
            return rtn;
        }
    }

    public virtual void loadAncor() {
        
        string soql;
        if (!isMulti) {
            soql='SELECT Id, '+Util.getNameField(ancortype)+', '+ancorField+' from '+ancortype+' WHERE id=\''+ancorid+'\'';
        }   
        else {
            string multiObj = String.valueOf(multiRelation.getChildSObject());
            Util.Describe multiDesc = new Util.Describe(multiObj);
            soql='SELECT Id, '+Util.getNameField(ancortype)+', '+ancorField+
                +', (SELECT '+util.joint(multiDesc.AccessibleFieldMap.values(),',')+' FROM '+mcr+')'
                +' FROM '+ancortype+' WHERE id=\''+ancorid+'\'';
        }
        system.debug('----------soql------------->'+soql);
        ancorObject = database.query(soql);
        system.debug('----------ancorObject------------->'+ancorObject);
    
        //default selection
        Id primaryId = (ancorObject!=null && ancorObject.get(ancorField)!=null) ? String.valueOf(ancorObject.get(ancorField)) : null;
        
        if (isMulti) {
            //Util.Describe ancorDesc = new Util.Describe(ancortype);
            SelectedNodes.items.clear();
            SET<Id> multiIds = new SET<Id>(); 
            SET<Id> missingNodes = new SET<Id>(); 
            if (ancorObject.getSObjects(mcr)!=null) {       
                for (sObject so : ancorObject.getSObjects(mcr)) {
                    string nodeid = (String) so.get(mcrField);
                    if (nodeid!=null && nodeMap.containskey(nodeid)) {  
                        INode sn = nodeMap.get(nodeid);
                        //sn.ancorId=(String) so.get('Id');
                        sn.setBinding(so);
                        SelectedNodes.add(sn);
                    }
                    else if(nodeid!=null) {
                        //missing multiple related node in nodemap (due to the use of dynamic or node has been deleted)
                        missingNodes.add(nodeid);
                        INode sn = new NodeBase(nodeid);
                        sn.setBinding(so);
                        SelectedNodes.add(sn);
                    }
                }
            }
            
            //missing multiple related node in nodemap (due to the use of dynamic or node has been deleted)
            if (missingNodes.size()>0) {
                string soqlDisconn='Select Id, ' + scopeNameField +', '+parentNodeField;
                soqlDisconn+=' FROM ' + scopeType; 
                soqlDisconn+=' WHERE Id IN : missingNodes';
                LIST<sobject> mapDisconnectedObjects = database.query(soqlDisconn);
                for (sobject so : mapDisconnectedObjects) {
                    if (SelectedNodes.getItem(so.id)!=null)
                        SelectedNodes.getItem(so.id).setLabel((string) so.get(scopeNameField));
                }
            }
            
            
            if (primaryId!=null) {
                SelectedNodes.primaryId=primaryId;
                //add primary to SelectedNodes if not existant
                if (SelectedNodes.primaryNode==null && nodeMap.containsKey(primaryId)) {
                    createNewSelectedNode(nodeMap.get(primaryId));          
                }
            }
        }
        selectedItem = (primaryId!=null) ? primaryId : scopeId;         
    }

    private transient Schema.ChildRelationship cacheMultiRelation;  
    public Schema.ChildRelationship multiRelation { 
        GET {
            if (cacheMultiRelation==null && mcr!=null)
                cacheMultiRelation=getChildRelation(ancortype,mcr);
            return cacheMultiRelation;
        }
    }

    public string multiType {
        GET {
            if (mcr==null || multiRelation==null) return null;
            string rtn;
            try { rtn=String.valueOf(multiRelation.getChildSObject());} catch(Exception ex) {}
            return rtn;
        }
    }

    
    public PageReference saveMulti() {
            //sobject so = database.query('SELECT Id from '+Util.TypeById(ancorid)+' WHERE id=\''+ancorid+'\'');
            //set the primary
            //TODO: make this an atomic transaction
            try {
                system.debug('---Update Primary-- (field:'+ancorField+', value:'+selectedNodes.primaryId+')');
                ancorObject.put(ancorField,selectedNodes.primaryId);
                update ancorObject;
                
                LIST<sObject> mcrNewRecords = new LIST<sObject>();
                LIST<sObject> mcrUpdateRecords = new LIST<sObject>();
                for (INode sn : SelectedNodes.items) {
                    if (sn.getBinding()!=null && sn.getBinding().id!=null) {
                        //handle existing record changes
                        //DML on generic List<SObject> only allowed for insert, update or delete 
                        mcrUpdateRecords.add(sn.getBinding());
                    }
                    else {      
                        mcrNewRecords.add(sn.getBinding());
                    }
                }
    
                system.debug('---------------saveMuti(new):'+mcrNewRecords );
                if (mcrNewRecords.size()>0)
                    insert mcrNewRecords;
                system.debug('---------------saveMuti(existing):'+mcrUpdateRecords );   
                if (mcrUpdateRecords.size()>0)
                    update mcrUpdateRecords; 
                return new PageReference('/'+ancorid);
            } 
            catch(Exception ex) {
                //if (ex.getTypeName()=='FIELD_FILTER_VALIDATION_EXCEPTION')
                //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'A Lookup filter is preventing this relationship.'));
                //else 
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, String.valueOf(ex)));
                return null;                    
            }
            
       // }
       // catch (exception ex) {
        //  return null;
        //}     

    } 
    
    public string ancorName { 
        get { 
        return (ancorObject!=null) ? String.valueOf(ancorObject.get(Util.getNameField(ancortype))) : 'Parent Object'; 
        } 
    }
     
 
     public INode selectedNode {
        GET {
            if (nodeMAP.get(selectedItem)!=null) {
                INode n=nodeMAP.get(selectedItem);
                if (SelectedNodes.getItem(selectedItem)!=null)
                    n.setSelectable(false);  //already selected
                return n;
            }
            return null;
        }
    }   
    
    public SelectedNodes getSelectedNodes() {
        return selectedNodes;
    }   
    
    
    public virtual void createNewSelectedNode(INode n) {
        //check if node already exists before adding
        if (selectedNodes.getItem(n.getId())==null) {
                //add dummy ancor object to selected node
                system.debug(multiRelation);
                sObject so = multiRelation.getChildSObject().newSObject();
                so.put(multiRelation.getField(),ancorid);       
                so.put(mcrField,n.getId());
                n.setBinding(so);
                selectedNodes.add(n);
            }
        }   
    
    
    public PageReference Add() {
        if (noAncorMode)
            return null;
        else if (isMulti) {
            if (maxSelectedNodes!=null && selectedNodes.items.size()>=maxSelectedNodes)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ERR_MAX_SELECTED_NODES+'(max: '+String.valueOf(maxSelectedNodes)+')'));
            else
                createNewSelectedNode(this.selectedNode);
            return null;
        }
        else
            try {
                sobject so = database.query('SELECT Id from '+Util.TypeById(ancorid)+' WHERE id=\''+ancorid+'\'');
                so.put(ancorField,selectedItem);
                update so;
                return new PageReference('/'+ancorid);
            }
            catch (exception ex) {
                return null;
            }
    }    
    
    ////////////////////////////////////////////////////////////////////////////////////
    // Node Event Handler
    ///////////////////////////////////////////////////////////////////////////////////

    public virtual PageReference onEvent() {
        INode n = nodeMap.get(eventItem);       
        if (n!=null) {
            if (event=='selectedNode_Add')
                return selectedNode_Add(eventItem,n);
            if (event=='dblclick')
                return onDblClick(eventItem,n);
            else if (event=='click' || event=='otherClick')  //IE7 reports as otherClick
                return onClick(eventItem,n);
            else if (event=='expand')
                return onExpand(eventItem,n);   
            else if (event=='delete')
                return onDelete(eventItem,n);
            else if (event=='toggleExpand')
                return onToggleExpanded(eventItem,n);                   
        }
        return null;
    }
  
    public virtual PageReference onDelete(string eventItem, INode n) {
        
        
        if (deleteMode>=1) {
            for (integer i=0; i<selectedNodes.items.size();i++) {
                if (selectedNodes.items[i].getId()==n.getId()) { //by NodeId
                    if (deleteMode==2 && selectedNodes.items[i].getBinding().id!=null)
                        delete selectedNodes.items[i].getBinding();
                    selectedNodes.items.remove(i);
                    n.setSelectable(true); //TES20130322 (fix to allow re-add to a recent delete)
                    break; //TES20130315
                }
            }
        }
        
        //handle deletion of primary
        if (deleteMode==2) {
            if (selectedNodes.primaryId==n.getId()) {
                selectedNodes.primaryId=(selectedNodes.items.size()==0) ? null : selectedNodes.items[0].getId();
                ancorObject.put(ancorField,selectedNodes.primaryId);
               update ancorObject;              
            }
        }
                            
        return null;
    }
    
    public virtual PageReference onToggleExpanded(string eventItem, INode n) {
        n.setExpanded(!n.getExpanded());    
        return null;
    } 
      
    public virtual PageReference selectedNode_Add(string eventItem, INode n) {
        selectedItem=eventItem;
        return Add();
    }
    
    public virtual PageReference onClick(string eventItem, INode n) {
        selectedItem=eventItem;
        return null;
    } 
    
    public virtual PageReference onDblClick(string eventItem, INode n) {
        selectedItem=eventItem;
        if (n.getSelectable()) {
            return Add();
        }
        else return null;
    }
 
    public virtual PageReference onExpand(string eventItem, INode n) {
        ExpandNode(nodeMap.get(eventItem));
        return null;
    }
    
    public virtual void ExpandNode(INode n) {
        system.debug('---------ExpandNode--------'+n);
        if (n!=null) {
            if (n.getChildrenLoaded()!=true) {
                n.setExpanded(true);
                n.setChildrenLoaded(true);
                createNodes(n.getid(),(!dynamic));
            }
            else {
                n.setExpanded(!n.getExpanded());
            }
        }
    }
    
    public virtual PageReference refresh() {
        return null;
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    // Inner classes
    ///////////////////////////////////////////////////////////////////////////////////
    
    /*
    public interface ISelectedNode {
        getNode();
        getSObject();
        isPrimary();
    }
    */
    
    /*
    public virtual class SelectedNode extends NodeBase {
        protected   sObject ancorObj;       //cache ancor
        public      string ancorId          {get; set;}     //objectId that has lookup to hier object
        public      boolean isDeleted       {get; set;}     
            
        public SelectedNode(INode n) {
            super(n);
        }
        
        public virtual sobject getBinding() {
            system.debug('------ancorObj---------->'+ancorObj);
            system.debug('------ancorId---------->'+ancorId);
            if (ancorObj==null && !Util.isBlank(ancorId)) {
                ancorObj=Util.getRecord(ancorId);
                system.debug('------ancorObj2---------->'+ancorObj);
            }
            return ancorObj;
        }
        
        public virtual void setBinding(sobject value) {
                ancorObj=value;
        }
    }
    */

    //NOTE: Removed Map,  VFP did not retain order and causes corruption
    public virtual class SelectedNodes {
        //public MAP<Id,INode> snodeMAP         {get; set;}
        public LIST<INode>  items               {get; set;}
        public string primaryId                 {get; set;}
        
        public selectedNodes() {
            //snodeMAP=new MAP<Id,INode>();
             items=new LIST<INode>();
        }
        
        //public virtual SelectedNode add(INode n) { return add(new SelectedNode(n)); }
        public virtual INode add(INode n) {
            //snodeMAP.put(n.getId(),n);
            items.add(n);   
            if (items.size()==1) 
                this.primaryId=n.getId(); //first one added is primary
            return n;
        }
                
        public virtual INode getItem(string id) {
                for (INode n : this.items) 
                    if (n.getId()==id)
                        return n;
                return null;
        }
        
        public INode primaryNode {
            GET {
                return getItem(primaryId);
            }
        }   
    }

    ////////////////////////////////////////////////////////////////////////////////////
    // Static Methods
    ///////////////////////////////////////////////////////////////////////////////////

    private static Schema.ChildRelationship getChildRelation(string parentType, string relationshipName) {
        Util.Describe ancorDesc = new Util.Describe(parentType);
        return ancorDesc.getChildRelationship(relationshipName);
    }
    
    
}
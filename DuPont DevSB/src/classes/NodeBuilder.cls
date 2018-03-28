/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Abstract Base class for building a nodetree 

TES20130131  nodeMap changed from MAP<Id,INode> to MAP<string,INode>
********************************************************************************/
public abstract class NodeBuilder {
	
	private static string DEFAULT_HIERFIELD='Parent__c';


    public string scopeId					{get; set;}		//root id of heirarchy
 	public string scopeType					{get; private set;}   	//sobjectType of the hierarchial object
 	public string scopeNameField        	{get; private set;} 	//the name field for the Object used as the 
 	public string scopeTitleField       	{get; private set;} 	//the title field to use 
 	public string scopeIsSelectableField	{get; private set;} 	//the IsSelectedable  (boolean)

   
   //datarelated properties (consider wrapping and making protected for damage control)
    public INode 			rootNode			{get; set;} 
	public boolean 			dynamic				{get; set;}
	public string 			parentNodeField		{get; set;}
    public MAP<string,INode>	nodeMap = new MAP<string,INode>();  

	
	public NodeBuilder(){
		//defaults
		dynamic				= false;
		parentNodeField		= DEFAULT_HIERFIELD;
		rootNode			= new NodeBase('root');
	}
	
	
	public INode load(string rootId) {
		this.scopeId=rootId;
		return load();	
	}
	
    public INode load() {
    	try {
		sObject scopeRecord = Util.getRecord(scopeId);   
		scopeType=String.valueOf(scopeRecord.getSObjectType());	
		Util.Describe descr = new Util.Describe(scopeType);
		if (scopeNameField==null) scopeNameField=Util.getNameField(scopeType);
		if (scopeIsSelectableField==null && descr.FieldExist('IsSelectable__c'))
				scopeIsSelectableField='IsSelectable__c';
		if (scopeIsSelectableField==null && descr.FieldExist('Title__c'))
				scopeIsSelectableField='Title__c';				
		system.debug('----------scopeType-----------'+scopeType);
		rootNode = createNode(scopeRecord);
		rootNode.setChildrenLoaded(true);
		rootNode.setExpanded(true);
		nodeMap.put(scopeId,RootNode);
		createNodes(scopeId, (!dynamic));
    	} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid scopeId or unable to access hierarchial object.( scopeId='+scopeId+')\n\n'+ex));
		}
		return rootNode;
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////
// data specific logic 
//////////////////////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////
	//This will need to be overwritten for querying the child records
	// SET<id> pIds : parentIds
	////////////////////////////////////////////////////////////////////
	public MAP<string, sobject> createDataMap() { return createDataMap(new SET<id>());} 
    public MAP<string, sobject> createDataMap(string pId ) { return createDataMap(new LIST<string>{pId});} 
  	public virtual MAP<string, sobject> createDataMap(SET<Id> pIds) { return createDataMap(pIds);}
  	public virtual MAP<string, sobject> createDataMap(LIST<string> pIds) {
  		MAP<string, Sobject> rtn;
  		try {
  			string soql='Select Id, ' + scopeNameField+', '+parentNodeField;
			if (scopeIsSelectableField!=null)	soql+=', '+scopeIsSelectableField;
			if (scopeTitleField!=null)			soql+=', '+scopeTitleField;
			soql+=' FROM ' + scopeType; 
			
  			if (pIds.size()!=0)
				soql+=' WHERE '+parentNodeField+' IN : pIds';
  			else
				soql+=' WHERE '+parentNodeField+'= NULL';
			
			//rtn = (MAP<id, sobject>) database.query(soql);
			rtn=new MAP<string, Sobject>();
			for (sobject so : database.query(soql))	
				rtn.put(so.id, so);	

  		} catch(Exception ex){ system.debug(ex); }

		system.debug(rtn);
		return rtn;
	}
	
	
	//Typically this will need to be overwritten for creating nodes.
	//by default it just uses the Id,Name of SObject
	public virtual INode createNode(sobject s) {

		//NodeBase(string id, string alabel, LIST<INode> nodes, boolean aSelectable, boolean aExpanded)
		NodeBase rtn = new NodeBase(s.id, (string) s.get(scopeNameField), null, true, false);
		try {
		rtn.setSelectable(Util.StringToBoolean(String.valueOf(s.get('IsSelectable__c'))));
		rtn.title=String.valueOf(s.get('Title__c'));
		} catch(Exception ex) {system.debug(ex);}
		if (System.currentPageReference().getParameters().get('debug')=='1')
		rtn.title=String.valueOf(rtn);
		
		return rtn;
		
	}	
	
//////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////	
		
	
	// Recursively create Nodes from SObject (Loop for each Level)
	public void createNodes() 							{ createNodes(new SET<string>(),true);} 
	public void createNodes(boolean deep) 				{ createNodes(new SET<string>(),deep);} 
	public void createNodes(string pId ) 				{ createNodes(new SET<string>{pId},true);} 
	public void createNodes(string pId, boolean deep)	{ createNodes(new SET<string>{pId},deep);} 
	public void createNodes(SET<string> pIds) 			{ createNodes(pIds,true);} 
	public virtual void createNodes(SET<string> pIds, boolean deep) {
		long i=0;          
        MAP<string, sobject> objs = createDataMap(new LIST<string>(pIds));
        if (objs.size()>0) {
            //add object to nodeMap, added as child to parent (add parent to if non existant)
            for (SObject o : objs.values()) {
            	INode currNode = createNode(o);
            	nodeMap.put(o.id,currNode);
            	if ( deep ) currNode.setChildrenLoaded(true);
            	Id parentId = (id) o.get(parentNodeField);
            	
            	if (currNode.getParent()==null) {
                	if (nodeMap.containsKey(parentId))
                		nodeMap.get(parentId).addChild(currNode);
                	else
						rootNode.addChild(currNode);
            	}
            }
            if ( deep ) createNodes(objs.keyset());
        }
    }
	
	




}
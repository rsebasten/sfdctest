/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: MetadataExplorer

TES20120612: extends NodeSelector
********************************************************************************/
public class ctrlMetadataExplorer extends NodeSelector {
   
   	public sobject    		selectedSObject		{get; set;} 
	public string    		selectedSObjectId	{get; set;}
	public string 			errMsg				{get; set;}
	public boolean			firstRun			{get; set;}
	
    public override PageReference init() {
 		selectedSObjectId=ApexPages.currentPage().getParameters().get('m');
 		this.dynamic=true;
 		if (selectedSObjectId!=null && !firstRun) 
 			LoadSObject();
 		firstRun=true;
 		return null;
    }
        
 
 	public LIST<SelectOption> sObjects {
		GET {
			return Util.createSelectOptions([Select id, Name from Metadata__c where Type__c='SOBJECT' Order by Name],true);
		}
	}
 
 
 

  	public override MAP<string, sobject> createDataMap(LIST<string> pIds) {
  		system.debug('---------meta-createDataMap--------'+pIds);
  		MAP<string, Metadata__c> rtn;
  		
		if ( pIds.size()==1 && (!Util.isId(pIds[0])) )  {
	        rtn = new MAP<string, Metadata__c>([
	                Select id, Name, Parent__c, label__c, Type__c, subtype__c //isSelectable
	                from Metadata__c 
	                Where parent__c=:selectedSObjectId and Type__c=:pIds[0]
	          		and Type__c<>'ListView'
	            ]);			
			return rtn;
		}
		
  		
  		if (pIds.size()!=0)
	        rtn = new MAP<string, Metadata__c>([
	                Select id, Name, Parent__c, label__c, Type__c, subtype__c //isSelectable
	                from Metadata__c 
	                Where parent__c in :pIds and Type__c<>'ListView'
	                
	            ]);
		else
			rtn = new MAP<string, Metadata__c>([
	                Select id, Name, Parent__c, label__c, Type__c, subtype__c //isSelectable
	                from Metadata__c 
	                Where parent__c=null and Type__c<>'ListView'
	                //LIMIT 2
	            ]);
            system.debug(rtn);
            return rtn;
	}
	
	
	//This will need to be overwritten for creating nodes.....
	public override INode createNode(sobject s) {
		system.debug('---------meta-createNode--------'+s);
		Metadata__c md = (Metadata__c) s;
		INode n = new NodeBase(md.id,md.name,null,true, false);
		n.setTitle(md.label__c);

		if (md.Parent__c==selectedSObjectId && nodeMap.containsKey(md.Type__c))
			nodeMap.get(md.Type__c).addChild(n);
			
			string typ=(md.type__c!=null) ? md.type__c.toLowerCase() : '';
			if (typ=='field' || typ=='workflow' || typ=='apex_code')
				typ=md.subtype__c.toLowerCase();
			n.setNodeType(typ);
		
		if (! new SET<string>{'sobject','picklist','multipicklist'}.contains(n.getNodeType()) )
			n.setChildrenLoaded(true); //treat as leaf if no children (used for dynamic queries)
		
		return n;
	}	
	

	public class typeQuery {
		public string parentId;
		public string typ;
		public typeQuery(string pId, string atyp) {parentId=pId; typ=atyp;}
	}


    public void LoadSObject() {
    	if (selectedSObjectId!=null) {
    		
    		//create rootNode
			selectedItem=selectedSObjectId;
			selectedSObject = [Select Id, Name from Metadata__c where id=:selectedSObjectId];
			RootNode = new NodeBase(selectedSObject,false,true);
			RootNode.setNodeType('sobject');
			
			nodeMap = new MAP<string,INode>();
			nodeMap.put(selectedSObjectId,RootNode);
			//createNodes(selectedSObjectId, (!dynamic));
			
			
			//get all Types related to an SObject
			LIST<string> types = new LIST<string>();
			for (AggregateResult ar : [Select type__c typ from Metadata__c 
					where parent__c=:selectedSObjectId and Type__c<>'ListView' group by Type__c]) {
				types.add((string)ar.get('typ'));
			}
			system.debug(types);			
			
			for (string typ : types) {
				//if (!typ.toLowerCase().startswith('field')) {
					string json = System.JSON.serialize(new typeQuery(selectedSObjectId, typ));
					INode typeNode=new NodeBase(json,typ,null,false, false);
					typeNode.setId(typ);
					typeNode.setNodeType('folder');
					RootNode.addChild(typeNode);
					typeNode.setChildrenLoaded(false);
					nodeMap.put(typ,typeNode);
				//}
			}	
			
			system.debug(rootNode);
	  		system.debug(nodeMap);
		}

    }
    
	public PageReference sObjectOnSelect() {
		LoadSObject();
  		return null;
	}
	
}
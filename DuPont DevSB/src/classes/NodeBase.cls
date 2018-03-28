/**
* @file     Nodebase.cls 
* @author   Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version  1.0
*
* Copyright © 2012 DuPont. All rights reserved. 

//TES20130705  fixed bug when sorting children with same label 
*/ 
 
public virtual class NodeBase implements INode {
    string id;                        
    INode parent;                        // { get; protected set; } // SET by adding child
    string label;                        
	MAP<string,INode> mapChildren;       
    boolean selectable;
    boolean expanded;  
    sobject record;  					//	concrete record representing the node    
    sobject binding;
    MAP<string,string> attributes;
                   
    public 	boolean sortChildren                 { get; set; }
    
	boolean childrenLoaded;		               //used for dynamic tree generation to determine whether to show the [+] and/or attempt callback to get data
    public string nodeType;                     //node type is added to the li.span class and can be used for adding style such as icons to to the tree
    public string title;
    private LIST<INode> sortedChildren;         //cache - saves script statements
	                                                   

    public NodeBase() {}
    public NodeBase(string label)                                                   { this(label,null,null,null,null);      }
    public NodeBase(string id, string label)                                        { this(id,label,null,null,null);        }
    public NodeBase(string id, string label, LIST<INode> nodes)                     { this(id,label,nodes,null,null);       }
    public NodeBase(string id, string label, LIST<INode> nodes, boolean Selectable) { this(id,label,nodes,Selectable,null);}    
    public NodeBase(string id, string alabel, LIST<INode> nodes, boolean aSelectable, boolean aExpanded) {
        this.mapChildren = new MAP<string,INode>();
        this.id = id;
        this.label          = (alabel!=null)            ? alabel        : id;
        this.selectable     = (aSelectable!=null)       ? aSelectable   : true;
        this.expanded       = (aExpanded!=null)         ? aExpanded     : false;
        this.sortChildren   = true;
        if (nodes!=null)
            for (INode n : nodes)
                addChild(n);
    }

    public NodeBase(SObject so) { this(so,true,false); }
    public NodeBase(SObject so, boolean aSelectable, boolean aExpanded) {
        this((string) so.get('Id'),(string) so.get(Util.getNameField(String.valueOf(so.getSObjectType()))),null,aSelectable, aExpanded);
    }
    
    
	public NodeBase(INode n) {
		this.mapChildren = n.getChildrenMap();
        this.id 			= n.getid();
        this.label          = n.getLabel();
        this.selectable     = n.getSelectable();
        this.expanded       = n.getExpanded();		
	}
	

    public virtual string getId() { return id; }
    public virtual void setId(string value) {id=value; }   

    public virtual string getLabel() { return label; }
    public virtual void setLabel(string value) {label=value; } 
    
    public virtual boolean getSelectable() { return selectable; }
    public virtual void setSelectable(boolean value) {selectable=value; }

    public virtual boolean getExpanded() { return expanded; }
    public virtual void setExpanded(boolean value) {expanded=value; }    
    
 	public virtual boolean getChildrenLoaded() { return childrenLoaded;}
    public virtual void setChildrenLoaded(boolean value) { childrenLoaded=value; } 
 
    public virtual INode getParent() { return parent; }
    public virtual void setParent(INode value) { parent=value; }   


    public virtual sObject getRecord() { 
				if (record==null)
					record=Util.getRecord(this.id);
				return record;
			}
    public virtual void setRecord(sObject value) { record=value; }       
    
	
	//the underlying record that the node is bound
	public virtual sobject getBinding() {
		if (binding==null)
			binding=Util.getRecord(this.id);
		return binding;
	}
	public virtual void setBinding(sObject value)  {
		binding=value;
	}
	//public virtual void setBinding(Id bid) {
	//	binding=Util.getRecord(bid);
	//}	
	
	
	//extrinsic fields to append to node
	public virtual MAP<string,string> getAttributes() {
		if (attributes==null)
			attributes=new MAP<string,string>();
		return attributes;
	}
	public virtual void setAttributes(MAP<string,string> value) {	
		attributes=value;
	}

    public virtual string getSObjectType() {
    	string rtn;
		try {
    		rtn=String.valueOf(this.getRecord().getSObjectType());
		} catch(Exception ex){}
		return rtn;
    }
    
    
    public virtual MAP<string,INode> getChildrenMap() { return mapChildren; }
    public virtual string getNodeType() { return nodeType; }
	public virtual void setNodeType(string value) { nodeType=value; }    
    public virtual string getTitle() { return title; }     
    public virtual void setTitle(string value) { title=value; }     
	
	//TES20130705  fixed bug when sorting children with same label   
    private LIST<INode> getSortedChildren() {
            LIST<INode> rtn = new LIST<INode>();
            MAP<string,LIST<string>> mapLabel = new MAP<string,LIST<string>>();  //label=>id
            //LIST<string> orderLabel = new LIST<string>();
            for (INode n : mapChildren.values()) {
                string lbl=n.getLabel();
                if (!mapLabel.containsKey(lbl))
                	mapLabel.put(lbl,new LIST<string>());
                mapLabel.get(lbl).add(n.getId());
                //orderLabel.add(lbl);
            }
            LIST<string> orderLabel=new LIST<string>(mapLabel.keySet());
            orderLabel.sort();
            for (string sortVal : orderLabel)
             	for (string id : mapLabel.get(sortVal))
                	rtn.add(mapChildren.get(id));
            return rtn;
    }
    
    public virtual LIST<INode> getChildren() {
        
            if (!this.sortChildren) return mapChildren.values();
            //else return getSortedChilden();
            
            // caching
            else {
                if (sortedChildren==null)
                    sortedChildren=getSortedChildren();
                return sortedChildren;
            }
            ///
    }
    

    public virtual void addChilden(LIST<INode> nodes) {
        for (INode n : nodes)
            addChild(n);
    }
    
    public string link {
        GET {
            if (selectable)
                return '<a href="javascript:alert(\'ID: '+this.id+'\')">'+this.label+'</a>';
            else
                return this.label;
        }
    }
    public virtual boolean hasChildren() { 
        return (mapChildren.size()>0);
        }
    
    public virtual void addChild(INode n) { 
        n.setParent(this);
        this.sortedChildren=null; //reset order
        mapChildren.put(n.getId(),n); 
        }
    public virtual INode getChild(string s) { return this.mapChildren.get(s); }
    public virtual void removeChild(string s) {this.mapChildren.remove(s); }
    
    public virtual void MoveTo(INode n) {
    	if (Parent!=null)
        	Parent.removeChild(this.id);
        n.AddChild(this);
    }
    
    

    public virtual boolean isLastSibling() { 
            if (this.parent!=null) {
                return (this.Parent.getChildren()[this.Parent.getChildren().size()-1]==this); 
                }
            else
                return false;
    }
    






    
    //format used for AutoComplete component
    public string getJSON() {
            MAP<string,INode> nodeMap = new MAP<string,INode>();
            NodeBase.MAPNodes(this, nodeMap);
            string rtn='[';
            for (INode n: nodeMap.values() ) {
                if (n.getSelectable()) {
                    string plabel=(n.getParent()!=null)?'&nbsp;&nbsp;<i>&lt;'+n.getParent().getlabel()+'&gt;</i>':'';
                    rtn+='\n{"label": "'+n.getlabel()+' '+plabel+'", "value": "'+n.getId()+'", "type": "'+n.getNodeType()+'"},';
                }
            }
            if (rtn!='[')
            	rtn=rtn.substring(0,rtn.length()-1);
            rtn+=']';
            return rtn;
    }   
    
/////////////////////////////////////////////////////////////////////////////// 
// Helper functions
///////////////////////////////////////////////////////////////////////////////     
/*  
    public static void MAPNodes (INode node, MAP<string,INode> out) {
            out.put(node.getid(),node);
            for (INode cn : node.getChildrenMap().values()) {
                MAPNodes(cn,out);
            }
        }
      
      */
    public static void MAPNodes (INode node, MAP<string,INode> out) {
            out.putAll(node.getChildrenMap());
            for (INode n : node.getChildrenMap().values()) {
                MAPNodes(n,out);
            }
        }   
        
    public static INode FindNodeById(INode node, string id) {
        if (node.getChild(id)!=null) return node.getChild(id);
        else {
            for (INode n : node.getChildrenMap().values()) {
                INode result=FindNodeById(n,id);
                if (result!=null) return result;
            }
        }
        return null;
    }
    


/*      
    public MAP<id,SET<id>> createNodeHierarchyMap(LIST<Nodes> nodes) {
        MAP<id,SET<id>> rtn = new MAP<id,SET<id>>();
        //add to hier
        for (Node n : nodes ) {
                if (!rtn.containsKey(n.parentNode.id)
                    hier.put(o.get('parent__c'),new SET<id>());
                hier.get(o.get('parent__c')).add(o.id);
            }
            //add to data
            data.putAll(kids);
            getAllChildren(kids.keyset());
        }
    */
}
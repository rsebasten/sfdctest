/**
 * @author  SNYDERT
 */
public virtual interface INode {
	
	//unique id for node
	string getId();
	void setId(string id);
	
	//parent INode
	/**
	 * @uml.property  name="parent"
	 * @uml.associationEnd  
	 */
	INode getParent();	
	/**
	 * @param n
	 * @uml.property  name="parent"
	 */
	void setParent(INode n);
		
	//Label for Node			
	string getLabel();		
	void setLabel(string s);
				
	//can this Node be selected?	
	boolean getSelectable();
	void setSelectable(boolean tf);	
			
	//Is this Node shown expanded (tree view)
	boolean getExpanded();
	void setExpanded(boolean tf);
	
	//has this Node Children been loaded (for dynamic rendering in tree view) 
	boolean getChildrenLoaded();		//used for dynamic tree generation to determine whether to show the [+] and/or attempt callback to get data
	void setChildrenLoaded(boolean tf);
			
	//Is this the last Sibling,  used for a tree view styling
	boolean isLastSibling();
	
	//get Map of children
	MAP<string,INode> getChildrenMap();				
	
	//node type is added to the li.span class and can be used for adding style such as icons to to the tree
	string getNodeType();
	void setNodeType(string value);
	
		
	//title for Node, (value on title attribute for LI)		
	string getTitle();
	void setTitle(string title);
	
		
	//List of child nodes,  sorted if NodeBase.sortedChildern=true;			
	LIST<INode> getChildren();
	
	//add child nodes to curent Node
	void addChilden(LIST<INode> nodes);
	
	//does current node have childer?
	boolean hasChildren();
	
	//add single child node to curent Node	
	void addChild(INode n);
	
	//get child node by id
	INode getChild(string id);
	
	//remove child node by id
	void removeChild(string id);
	
	//Move current node to new parent
	void MoveTo(INode n);
	
	//export as JSON (format for jQuery autocomplete)
	string getJSON();
	
	//the underlying record that the node represents
	sobject getRecord();
	void setRecord(sObject value);
	
	//the underlying record that the node is bound
	sobject getBinding();
	void setBinding(sObject value);
	
	//extrinsic fields to append to node
	MAP<string,string> getAttributes();
	void setAttributes(MAP<string,string> value);	
	
}
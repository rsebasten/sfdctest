/*********************************************************
Copyright (c) 2010 tgerm.com
All rights reserved.

Modified by: Tom Snyder


* utilXmlNode class definition

This following class implements a small portion of the wc3 xml dom model.
Generally useful for simple XML return objects.

for a properties and methods complete list see:
http://www.w3schools.com/dom/dom_node.asp

For simplicity, Nodes are the same as Elements in this class.
Nodes have text directly in them, rather than a seperate text node child
The following describes the implemented portion, some w3c properties are now methods.

Property Description
======== ============
childNodes Returns a NodeList of child nodes for a node
firstChild Returns the first child of a node
lastChild Returns the last child of a node
namespaceURI Returns the namespace URI of a node
nextSibling Returns the node immediately following a node
nodeName Returns the name of a node, depending on its type
nodeType Returns the type of a node
nodeValue Sets or returns the value of a node, depending on its type
parentNode Returns the parent node of a node
prefix Sets or returns the namespace prefix of a node
previousSibling Returns the node immediately before a node
textContent Sets or returns the textual content of a node and its descendants
xml Returns the XML of a node and its descendants.


Methods
-------

Method Description
====== ===========
hasAttributes() Returns true if a node has any attributes, otherwise it returns false
hasChildNodes() Returns true if a node has any child nodes, otherwise it returns false
isDefaultNamespace(URI) Returns whether the specified namespaceURI is the default
lookupNamespaceURI() Returns the namespace URI matching a specified prefix
lookupPrefix() Returns the prefix matching a specified namespace URI
removeChild() Removes a child node
cloneNode(boolean deep) Clones a node


TODO:
=====
Implement and add testMethods for each of the following, As spring 10 API doesn't have direct methods for doing so many of the
following methods might involve recursions etc to clone, compare and append/replace/insert child
appendChild() Adds a new child node to the end of the list of children of a node
compareDocumentPosition() Compares the document position of two nodes
getUserData(key) Returns the object associated to a key on a this node. The object must first have been set to this node by calling setUserData with the same key
isEqualNode() Checks if two nodes are equal
isSameNode() Checks if two nodes are the same node

COSTLY TO ADD APIs for LATER CONSIDERATION
===========================================
insertBefore() Inserts a new child node before an existing child node. TGERM: We can implement this but there is no such API from Spring 10 classes and doing this on
own might eat a lot of script statements.
replaceChild() Replaces a child node. TGERM: we can't replace the same child again, because of the same reason, we might need to eat a lot of script statements to do so.

WILL NOT BE INCLUDED IN API
============================
Following methods are there in w3c DOM Node but we will not implement them
baseURI Returns the absolute base URI of a node
localName Returns the local part of the name of a node
isSupported(feature,version) Returns whether a specified feature is supported on a node
normalize() Puts all text nodes underneath a node (including attributes) into a "normal" form where only structure (e.g., elements, comments, processing instructions, CDATA sections, and entity references) separates Text nodes, i.e., there are neither adjacent Text nodes nor empty Text nodes
setUserData(key,data,handler) Associates an object to a key on a node
text Returns the text of a node and its descendants.
ownerDocument Returns the root element (document object) for a node. TGERM: we are giving Root instead
getFeature(feature,version) Returns a DOM object which implements the specialized APIs of the specified feature and version

*/

public virtual class utilXmlNode {
	public static final Integer 	MAX_ELEMENTS_TILL_LEAF = -1;
	public 				Dom.XmlNode xmlNode {get;private set;} 	//native Dom.XMLNode
	

	//constructor
	public utilXmlNode(Dom.XmlNode node) {
	xmlNode = node;
	}

	public String nodeName {
		get{ return xmlNode.getName(); } 
		protected set;
	}

	public String nodeValue {
		get { return xmlNode.getText(); }
		set {
			Dom.XmlNode[] existing = xmlNode.getChildren();
			if (existing != null && !existing.isEmpty())
				for (Dom.XmlNode n : existing)
					if (n.getNodeType() == dom.XmlNodeType.TEXT) 
						xmlNode.removeChild(n);
			xmlNode.addTextNode(value);
		}
	}

	//Returns a NodeList of child nodes for a node
	public List<utilXmlNode> childNodes {
		get {
			Dom.XmlNode[] kids = this.xmlNode.getChildren();
			childNodes = new List<utilXmlNode>();
			if (kids != null && !kids.isEmpty()) {
				for (Dom.XmlNode kid: kids )
					childNodes.add(new utilXmlNode(kid));
			}
		return childNodes;
		} 
		protected set;
	}

	//The firstChild property returns the first child node of this Dom Element.
	public utilXmlNode firstChild {
		get {
			Dom.XmlNode[] kids = this.xmlNode.getChildren();
			return kids != null && !kids.isEmpty() ? new utilXmlNode(kids[0]) : null;
		} 
		protected set;
	}

	//The lastChild property returns the last child node of this Dom Element.
	public utilXmlNode lastChild {
		get {
			Dom.XmlNode[] kids = this.xmlNode.getChildren();
			return kids != null && !kids.isEmpty() ? new utilXmlNode(kids[kids.size() - 1]) : null;
		} 
		protected set;
	}

	//The namespaceURI property sets or returns the namespace URI of this element.
	public String namespaceURI {
		get { return xmlNode.getNamespace(); }
		set { xmlNode.setNamespace('', value); }
	}


	//Returns the node immediately following a node
	public utilXmlNode nextSibling {
		get {
			utilXmlNode next = null;
			Dom.XmlNode parent = xmlNode.getParent();
			if (parent == null) return next;
			Dom.XmlNode[] kids = parent.getChildren();
			Integer thisNodeIdx = -1;
			if (kids != null && !kids.isEmpty()) {
				for (Integer idx = 0; idx < kids.size() ; idx++) {
					Dom.XmlNode kid = kids[idx];
					if (kid == this.xmlNode) {
						thisNodeIdx = idx;
						break;
					}
				}
				if (thisNodeIdx >= 0 && thisNodeIdx < (kids.size() -1)) {
					next = new utilXmlNode(kids [thisNodeIdx + 1]);
				}
			}
			return next;
		} 
		protected set;
	}

/*
Returns the root element for a node
*/
public utilXmlNode root {
get {
Dom.XmlNode ret = this.xmlNode;
while( ret.getParent() != null) { ret = ret.getParent(); }
// if one is at root return this otherwise create a new root element
return ret == this.xmlNode ? this : new utilXmlNode(ret) ;
}
}


/*
Returns the parent node of a node
*/
public utilXmlNode parentNode {
get{
Dom.XmlNode p = xmlNode.getParent();
return p != null ? new utilXmlNode(p): null;
}
protected set;
}

/*
Returns the namespace prefix of a node
LIMITATION: We are not allowing to change the prefix
*/
public String prefix {
get {
return xmlNode.getNamespace() != null ? xmlNode.getPrefixFor(xmlNode.getNamespace()) : null;
} private set;
}

/*
Returns the node immediately before a node
*/
public utilXmlNode previousSibling {
get {
utilXmlNode prev = null;
Dom.XmlNode parent = xmlNode.getParent();
if (parent == null) return prev;
Dom.XmlNode[] kids = parent.getChildren();
Integer thisNodeIdx = -1;
if (kids != null && !kids.isEmpty()) {
Integer idx = kids.size() - 1;
for (; idx > -1; idx--) {
Dom.XmlNode kid = kids[idx];
if (kid == this.xmlNode) {
thisNodeIdx = idx;
break;
}
}
if (thisNodeIdx > 0) {
prev = new utilXmlNode(kids [thisNodeIdx - 1]);
}
}

return prev;
} protected set;
}


/*
Returns the Node type out of all 12 nodetypes only 3 are supported
• COMMENT
• ELEMENT
• TEXT

ZERO (0) is returned on unsupported type
*/
public Integer nodeType {
get{
if (nodeType == null) {
dom.XmlNodeType nt = xmlNode.getNodeType();
if (nt == dom.XmlNodeType.ELEMENT)
nodeType = 1;
else if (nt == dom.XmlNodeType.TEXT)
nodeType = 3;
else if (nt == dom.XmlNodeType.COMMENT)
nodeType = 8;
else
nodeType = 0;
}
return nodeType;
} protected set;
}

/*
The textContent property sets or returns the textual content of a node and its descendants.
On setting, any child nodes are removed and replaced by a single Text node containing the string this property is set to.
*/
public String textContent{
get {
return getTextContents(xmlNode);
}
set {
Dom.XmlNode[] existing = xmlNode.getChildren();
if (existing != null && !existing.isEmpty())
for (Dom.XmlNode n : existing)
xmlNode.removeChild(n);
xmlNode.addTextNode(value);
}
}

protected Map<String,String> attributes {
get {
if (attributes != null) return attributes;
attributes = new Map<String, String>();
Integer attribCount = xmlNode.getAttributeCount();
for (Integer idx = 0 ; idx < attribCount ; idx ++) {
String aNs = xmlNode.getAttributeKeyNsAt(idx);
String aKey = xmlNode.getAttributeKeyAt(idx);
String aVal = xmlNode.getAttributeValue(aKey, aNs);
attributes.put(aKey, aVal);
}
return attributes;
} protected set;
}

/*
Returns attribute value for the attribute name
*/
public virtual String getAttribute(string name) {
return attributes.get(name);
}

/**
Returns all the Elements matching the specified tag name.
*/
public virtual List<utilXmlNode> getElementsByTagName(String nam) {
NodeNameInfo nameInfo = getNamespaceFromNodeName(nam, this.xmlNode);
List<utilXmlNode> ret = new List<utilXmlNode>();
loadChildElementsForTagName(this.xmlNode, nameInfo.localName, nameInfo.namespaceURI, ret);
return ret;
}

/**
Returns all the Elements matching the specified tag name.
*/
public virtual List<utilXmlNode> getElementsByTagNameNS (String namespaceURI, String nam) {
List<utilXmlNode> ret = new List<utilXmlNode>();
loadChildElementsForTagName(this.xmlNode, nam, namespaceURI, ret);
return ret;
}

/*
Returns single Element matching the specified tag name.
*/
public virtual utilXmlNode getElementByTagName(String nam) {
NodeNameInfo nameInfo = getNamespaceFromNodeName(nam, this.xmlNode);
return loadChildElementForTagName(this.xmlNode, nameInfo.localName, nameInfo.namespaceURI);
}

//TES20100708  backward comp with XmlDom
public string getValue(String nam) {
	utilXmlNode e = getElementByTagName(nam); 
	return (e==null?null:e.nodeValue); 
}

/*
Returns the namespace URI matching a specified prefix
*/
public virtual String lookupNamespaceURI(String prefix) {
return xmlNode.getNamespaceFor(prefix);
}

/*
Returns the prefix matching a specified namespace URI
*/
public virtual String lookupPrefix(String nsURI) {
return xmlNode.getPrefixFor(nsURI);
}


/*
Returns true if a node has any attributes, otherwise it returns false
*/
public virtual Boolean hasAttributes() {
return xmlNode.getAttributeCount() > 0;
}

/*
Returns true if a node has any child nodes, otherwise it returns false
*/
public virtual Boolean hasChildNodes() {
Dom.XmlNode [] nativeKids = xmlNode.getChildren();
return nativeKids != null && !nativeKids.isEmpty();
}

/*
Returns whether the specified namespaceURI is the default
*/
public virtual Boolean isDefaultNamespace(String uri) {
return uri == this.xmlNode.getNamespace();
}

/*
Removes a child node
*/
public virtual Boolean removeChild (utilXmlNode child) {
return this.xmlNode.removeChild(child.xmlNode);
}

/**
Clones this node.
@param deep to clone child nodes too.
*/
public virtual utilXmlNode cloneNode (boolean deep) {
// setting ownerdocument of cloned node as null, we don't want this
return new utilXmlNode(clone(this.xmlNode, deep));
}

/**
Appends the given node to this node
@param nodeToAppend the node that will get appended
@return The node that was actually added
*/
public virtual utilXmlNode appendChild (utilXmlNode nodeToAppend) {
return appendChild(nodeToAppend.xmlNode);
}


/**
Appends the given node to this node
@param nodeToAppend the node that will get appended
@return The node that was actually added
*/
public virtual utilXmlNode appendChild (Dom.XmlNode nodeToAppend) {
Dom.XmlNode ret = appendChild(this.xmlNode, nodeToAppend);
return ret != null ? new utilXmlNode(ret) : null;
}


/*
Returns Xml Rep of this node
*/
public String toXmlString() {
return toXmlString(xmlNode);
}


static void loadChildElementsForTagName(Dom.XmlNode fromNode, String nam, string nameSpace, List<utilXmlNode> ret) {
// Check if this node is matching the mentioned tag name.
if (fromNode.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(fromNode.getNamespace())))
ret.add(new utilXmlNode(fromNode));

// Add kids and their kids
for (Dom.XmlNode kid: fromNode.getChildElements()) {
if (kid.getChildElements().isEmpty()) {
if (kid.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(kid.getNamespace())))
ret.add(new utilXmlNode(kid));
} else {
loadChildElementsForTagName(kid, nam, nameSpace, ret);
}
}
}

static utilXmlNode loadChildElementForTagName(Dom.XmlNode fromNode, String nam, string nameSpace) {
// Check if this node is matching the mentioned tag name.
if (fromNode.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(fromNode.getNamespace())))
return new utilXmlNode(fromNode);

// Add kids and their kids
for (Dom.XmlNode kid: fromNode.getChildElements()) {
if (kid.getChildElements().isEmpty()) {
if (kid.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(kid.getNamespace())))
return new utilXmlNode(kid);
} else {
utilXmlNode ret = loadChildElementForTagName(kid, nam, nameSpace);
if (ret != null) return ret;
}
}
return null;
}
//////////////////////////////////////////////////////////////////////////////////////////////
// Helper methods
//////////////////////////////////////////////////////////////////////////////////////////////
	/**
	Class that encapsulates info about a Node's localName and its NameSpaceURI
	*/
	public class NodeNameInfo {
		public String localName 		{get;set;}
		public String namespaceURI 		{get;set;}
		public String nameSpacePrefix 	{get;set;}
		
		public NodeNameInfo(String lName, String nsURI, String nsPrefix) {
			this.localName = lName;
			this.namespaceURI = nsURI;
			this.nameSpacePrefix = nsPrefix;
		}
	}
	public static NodeNameInfo getNamespaceFromNodeName(String nodeName, Dom.XmlNode baseNode) {
		String nameSpace = null;
		String nameSpacePrefix = null;
		Integer colonIdx = nodeName.indexOf(':');
		if (colonIdx > 0 ) {
			nameSpacePrefix = nodeName.substring(0, colonIdx);
			nodeName = nodeName.substring(colonIdx + 1);
			nameSpace = baseNode.getNamespaceFor(nameSpacePrefix);	
		}
		return new NodeNameInfo(nodeName, nameSpace, nameSpacePrefix);
	}	

	public static String toXmlString(Dom.XmlNode xmlNode) {
		String ns = xmlNode.getNamespace();
		String prefix = ns == null ? '' : xmlNode.getPrefixFor(ns);
		prefix = prefix == '' || prefix == null ? '' : prefix + ':';   
		String xmlrep = '<' +  prefix + xmlNode.getName() ;
		Integer attribCount = xmlNode.getAttributeCount();
		for (Integer idx = 0 ; idx < attribCount ; idx ++) {
			String aNs = xmlNode.getAttributeKeyNsAt(idx);
			String aKey = xmlNode.getAttributeKeyAt(idx);
			String aVal = xmlNode.getAttributeValue(aKey, aNs);
			String aPrefix = '';
			aPrefix = aNs == null ? '' : xmlNode.getPrefixFor(aNs);
			aPrefix = aPrefix == '' || aPrefix == null ? '' : aPrefix + ':';
			xmlrep += ' ' +aPrefix + aKey + '=\'' + aVal + '\'' ;
		}
		xmlrep += '>';
		
		Dom.XmlNode [] children = xmlNode.getChildren();
		if (children != null && !children.isEmpty()) {
			for (Dom.XmlNode child : children) {
				if (child.getNodeType() == dom.XmlNodeType.TEXT) {
					xmlrep += child.getText();
				} else if (child.getNodeType() == dom.XmlNodeType.COMMENT) {
					// do nothing !	
				} else if (child.getNodeType() == dom.XmlNodeType.ELEMENT) {
					xmlrep += toXmlString(child);
				}
			}	
		} 
					
		return xmlrep + '</' + prefix + xmlNode.getName() + '>';
	}
	
	public static void copyAttributes(Dom.XmlNode fromN, Dom.XmlNode toN) {
		Integer attribCount = fromN.getAttributeCount();
		for (Integer idx = 0 ; idx < attribCount ; idx ++) {
			String aNs = fromN.getAttributeKeyNsAt(idx);
			String aKey = fromN.getAttributeKeyAt(idx);
			String aVal = fromN.getAttributeValue(aKey, aNs);
			String vNs = fromN.getAttributeValueNs(aKey, aNs);
			toN.setAttributeNs(aKey, aVal, aNs, vNs);
			String aPrefix = aNs != null ? fromN.getPrefixFor(aNs) : null;
			String vPrefix = vNs != null ? fromN.getPrefixFor(vNs) : null;
			if (aPrefix != null)toN.setNamespace(aPrefix, aNs);
			if (vPrefix != null)toN.setNamespace(vPrefix, vNs);
		}
	}
	
	public static Dom.XmlNode appendChild (Dom.XmlNode inNode, Dom.XmlNode nodeToAppend) {
		Dom.XmlNode addedNode = null;
		// Elements can only be added to ELEMENT Nodes. Other 2 supported by Spring 10 Apex XML DOM API
		// are COMMENT and TEXT that can't have child nodes
		// We are intentionally leaving the error handling upto Spring 10 API, I checked
		// on such situations Xml DOM API throw System.Xmlexception
		String nsURI = nodeToAppend.getNamespace();
		String nsPrefix = nsURI != null ? nodeToAppend.getPrefixFor(nsURI) : null;
		addedNode = inNode.addChildElement(nodeToAppend.getName(), nsURI, nsPrefix);
		
		// Copy attributes from the original node to the appended node.
		copyAttributes(nodeToAppend, addedNode);
		// copy the kids from the original to the appended node.
		copyKids(nodeToAppend, addedNode); 
		return addedNode;
	}	
	
	public static Dom.XmlNode clone(Dom.XmlNode xmlNode, boolean deep) {
		String nsURI = xmlNode.getNamespace();
		String nsPrefix = nsURI != null ? xmlNode.getPrefixFor(nsURI) : null;
		Dom.Document domc = new Dom.Document();
		Dom.XmlNode cloned = domc.createRootElement(xmlNode.getName(), nsURI, nsPrefix);
		
		// Copy the node attributes
		copyAttributes(xmlNode, cloned);
		// if deep clone, copy the kids too.
		if (deep) copyKids(xmlNode, cloned); 
		
		return cloned;
	}
	
	public static void copyKids(Dom.xmlnode fromNode, Dom.xmlnode toNode) {
		Dom.XmlNode [] children = fromNode.getChildren();
		if (children != null && !children.isEmpty()) {
			for (Dom.XmlNode child : children) {
				String kidName = child.getName();
				String kidNSURI = child.getNamespace();
				String kidPrefix = kidNSURI != null ? child.getPrefixFor(kidNSURI) : null;
				
				if (child.getNodeType() == dom.XmlNodeType.TEXT) {
					toNode.addTextNode(child.getText());
				} else if (child.getNodeType() == dom.XmlNodeType.COMMENT) {
					toNode.addCommentNode(child.getText());
				} else if (child.getNodeType() == dom.XmlNodeType.ELEMENT) {
					Dom.XmlNode copiedChild = toNode.addChildElement(kidName, kidNSURI, kidPrefix);
					copyAttributes(child, copiedChild);
					copyKids(child, copiedChild);
				}
			}	
		}
	
	}
	
	public static String getTextContents(Dom.XmlNode node) {
		String textRep = '';
		Dom.XmlNode [] children = node.getChildren();
		if (children != null && !children.isEmpty()) {
			for (Dom.XmlNode child : children) {
				if (child.getNodeType() == dom.XmlNodeType.TEXT) {
					textRep += ' ' + child.getText();
				} else if (child.getNodeType() == dom.XmlNodeType.ELEMENT) {
					textRep += ' ' + getTextContents(child);
				}
			}	
		} 
		return textRep.trim() ;
	}

}
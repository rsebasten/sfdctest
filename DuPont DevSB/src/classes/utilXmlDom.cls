/*
Copyright (c) 2010 tgerm.com
All rights reserved.

modified by: Tom Snyder
*/
public class utilXmlDom {
	
	private Dom.Document domDoc = new Dom.Document();
	// everything in the dom is found as childNodes under this root element
	public utilXmlNode root {get; private set;}
	
	// utility dom functions
	public Dom.Document ownerDocument { get {return domDoc;} private set; }

	// dump out the element tree
	public String toXmlString() { return domDoc.toXmlString(); }
	
	// Constructor
	public utilXmlDom(String xml) {
		domDoc.load(xml);
		Dom.XmlNode rootXmlNode = domDoc.getRootElement();
		root = new utilXmlNode(rootXmlNode); 
	}
	
	public utilXmlDom(String rootElementName, String rootElementNamespace, String rootElementPrefix) { 
		Dom.XmlNode rootXmlNode  = domDoc.createRootElement(rootElementName, rootElementNamespace, rootElementPrefix);
		root = new utilXmlNode(rootXmlNode);
	}
	
	 
	// FACTORY METHODS //
	public static utilXmlDom createForRootElement(String rootElementName) {
		return new utilXmlDom(rootElementName, null, null);	
	}	
	
	public static utilXmlDom createForRootElement(String rootElementName, String rootElementNamespace, String rootElementPrefix) {
		return new utilXmlDom(rootElementName, rootElementNamespace, rootElementPrefix);
	}		
	
	public static utilXmlDom createFromXml(String xml) {
		return new utilXmlDom(xml);
	}
}
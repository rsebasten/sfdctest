@isTest
private class utilXmlDom_UT {

	static testMethod void testCreateFromXml() {
		utilXmlDom dom = utilXmlDom.createFromXml('<price>29.99</price>');
		String asXml = dom.root.toXmlString();
		System.assertEquals('<price>29.99</price>', asXml);
	}
	
	static testMethod void testCreateForRootElement() {
		utilXmlDom dom = utilXmlDom.createForRootElement('price');
		System.assertEquals('price', dom.root.nodeName);
	}
	
	static testMethod void testCreateForRootElement2() {
		utilXmlDom dom = utilXmlDom.createForRootElement('price', null, null);
		System.assertEquals('price', dom.root.nodeName);
	}
	
	static testMethod void testToXmlString() {
		utilXmlDom dom = utilXmlDom.createFromXml('<price>29.99</price>');
		System.assertEquals('<?xml version="1.0" encoding="UTF-8"?><price>29.99</price>', dom.toXmlString());
	}
	
	static testMethod void testOwnerDocument() {
		utilXmlDom dom = utilXmlDom.createFromXml('<price>29.99</price>');
		System.assert(null != dom.ownerDocument);
	}
	
	// Used example XML from http://www.w3schools.com/dom/books.xml
	public static String sampleXml = '<bookstore>'
		+ '<book xmlns:c="http://www.w3schools.com/children/" category="CHILDREN">'
		+ '<!-- Test Comment 1 -->'
		+ '<c:title c:lang="en">Harry Potter</c:title>'
		+ '<c:author>J K. Rowling</c:author>'
		+ '<c:year>2005</c:year>'
		+ '<!-- Test Comment 2 -->'
		+ '<c:price>29.99</c:price>'
		+ '</book>'
		+ '<book xmlns:x="http://www.w3schools.com/xml/" category="WEB">'
		+ '<x:title x:lang="en">Learning XML</x:title>'
		+ '<x:author>Erik T. Ray</x:author>'
		+ '<x:year>2003</x:year>'
		+ '<x:price>39.95</x:price>'
		+ '</book>'
		+ '</bookstore>';
	
	static testMethod void testGetElementsByTagName() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		List<utilXmlNode> books = root.getElementsByTagName('book');
		System.assertEquals(2, books.size());
		// with uptoLead flag as false
		List<utilXmlNode> titles = null;
		
		titles = root.getElementsByTagName('title');
		System.assertEquals(2, titles.size());
	}
	
	static testMethod void testGetElementsByTagNameNS() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		List<utilXmlNode> titles = root.getElementsByTagNameNS('http://www.w3schools.com/children/','title');
		System.assertEquals(1, titles.size());
	}
	
	
	static testMethod void testGetElementByTagName() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertNotEquals(null, book);
	}
	
	static testMethod void testChildNodes() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertNotEquals(null, book);
		List<utilXmlNode> childNodes = book.childNodes;
		Integer commentCount = 0;
		Integer elementCount = 0;
		Integer textNodeCount = 0;
		for (utilXmlNode child: childNodes) {
			if (child.nodeType == 8) commentCount++;
			if (child.nodeType == 1) elementCount++;
			if (child.nodeType == 3) textNodeCount++;
		}
		System.assertEquals(2, commentCount);
		// There is no direct textnode under book.
		System.assertEquals(0, textNodeCount);
		System.assertEquals(4, elementCount);
		
		utilXmlNode title = book.getElementByTagName('c:title');
		childNodes = title.childNodes;
		commentCount = 0;
		elementCount = 0;
		textNodeCount = 0;
		for (utilXmlNode child: childNodes) {
			if (child.nodeType == 8) commentCount++;
			if (child.nodeType == 1) elementCount++;
			if (child.nodeType == 3) textNodeCount++;
		}
		System.assertEquals(0, commentCount);// no comments are there
		// There is no direct textnode under book.
		System.assertEquals(1, textNodeCount);
		System.assertEquals(0, elementCount);
	
	}
	
	static testMethod void testNodeName() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		System.assertEquals('bookstore', root.nodeName);
		utilXmlNode book = root.getElementByTagName('book');
		System.assertNotEquals(null, book);
		System.assertEquals('book', book.nodeName);
	}
	
	static testMethod void testGetAttribute() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		List<utilXmlNode> books = root.getElementsByTagName('book');
		System.assertEquals(2, books.size());
		System.assertEquals('CHILDREN', books[0].getAttribute('category'));
		System.assertEquals('WEB', books[1].getAttribute('category'));
	}
	
	static testMethod void testNodeToXmlString() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		utilXmlNode title = book.getElementByTagName('c:title');
		System.assertEquals('<c:title c:lang=\'en\'>Harry Potter</c:title>', title.toXmlString());
	}
	
	static testMethod void testTextContent() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals('Harry Potter J K. Rowling 2005 29.99', book.textContent);
		utilXmlNode title = book.getElementByTagName('c:title');
		System.assertEquals('Harry Potter', title.textContent);
		title.textContent = 'Modified Text Content';
		System.assertEquals('Modified Text Content', title.textContent);
	}
	
	static testMethod void testNodeValue() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		utilXmlNode title = book.getElementByTagName('c:title');
		System.assertEquals('Harry Potter', title.nodeValue);
		String newVal = 'Abhinav Gupta';
		title.nodeValue = newVal;
		System.assertEquals(newVal, title.nodeValue);
	}
	
	static testMethod void testFirstChild() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode fc = root.firstChild;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals(fc.xmlNode, book.xmlNode);
	}
	
	static testMethod void testLastChild() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		utilXmlNode lc = book.lastChild;
		System.assertEquals('price', lc.nodeName);
	}
	
	static testMethod void testNamespaceURI() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		System.assertEquals(null, root.namespaceURI);
		root.namespaceURI = 'http://www.tgerm.com';
		System.assertEquals('http://www.tgerm.com', root.namespaceURI);
	}
	
	static testMethod void testNextSibling() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		//must be a book tag
		utilXmlNode firstKid = root.firstChild;
		utilXmlNode nextBookTag = firstKid.nextSibling;
		System.assertEquals('book', nextBookTag.nodeName);
		String category = nextBookTag.getAttribute('category');
		System.assertEquals('WEB', category);
	}
	
	static testMethod void testParentNode() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.firstChild;
		System.assertEquals(root.xmlNode, book.parentNode.xmlNode);
	}
	
	static testmethod void testPrefix() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		System.assertEquals(null, root.prefix);
	}
	
	
	static testMethod void testPreviousSibling() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode[] books = root.getElementsByTagName('book');
		System.assertEquals(2, books.size());
		utilXmlNode secondBook = books[1];
		System.assertEquals(books[0].xmlNode, secondBook.previousSibling.xmlNode);
	}
	
	static testMethod void testHasAttributes() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals(true, book.hasAttributes());
	}
	
	static testMethod void testHasChildNodes() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals(true, book.hasChildNodes());
	}
	
	static testMethod void testIsDefaultNamespace() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals(true, book.isDefaultNamespace(root.namespaceURI));
	}
	
	
	static testMethod void testRemoveChild() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		utilXmlNode title = book.getElementByTagName('title');
		Boolean deleted = book.removeChild(title);
		System.assertEquals(true, deleted);
		//fetch the same again
		title = book.getElementByTagName('title');
		System.assertEquals(null, title);
	}
	
	static testMethod void testRoot() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode title = root.getElementByTagName('title');
		System.assertEquals(root.xmlNode, title.root.xmlNode);
	}

	static testMethod void testLookupPrefix() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals('c', book.lookupPrefix('http://www.w3schools.com/children/'));
	}

	static testMethod void testLookupNamespaceURI() {
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		utilXmlNode book = root.getElementByTagName('book');
		System.assertEquals('http://www.w3schools.com/children/', book.lookupNamespaceURI('c'));
	}

	static testMethod void testCloneNode() {
			utilXmlDom dom = new utilXmlDom(sampleXml);
			utilXmlNode root = dom.root;
			utilXmlNode book = root.getElementByTagName('book');
			utilXmlNode bookCloned = book.cloneNode(true);
			System.assertEquals(book.xmlNode.getChildren().size(), bookCloned.xmlNode.getChildren().size());
			System.assertEquals(book.getAttribute('category'), bookCloned.getAttribute('category'));
			
			utilXmlNode title = book.getElementByTagName('title');
			utilXmlNode titleCloned = bookCloned.getElementByTagName('title');
			
			System.assertEquals(title.nodeValue, titleCloned.nodeValue);
			System.assertEquals(title.nodeType, titleCloned.nodeType);
			
			// Now lets try without deep cloning
			bookCloned = book.cloneNode(false);
			// No child should be there in the cloned node
			System.assertEquals(0, bookCloned.xmlNode.getChildren().size());
			// Attributes should be copied
			System.assertEquals(book.getAttribute('category'), bookCloned.getAttribute('category'));
	}

	static testMethod void testAppendChild() {
		String xmlToAppend = '<book xmlns:x="http://www.w3schools.com/xml/" category="MODDED">'
		+ '<x:title x:lang="en">TGerm</x:title>'
		+ '<x:author>Abhinav Gupta</x:author>'
		+ '<x:year>2010</x:year>'
		+ '<x:price>100.00</x:price>'
		+ '</book>' ;
		
		utilXmlDom dom = new utilXmlDom(sampleXml);
		utilXmlNode root = dom.root;
		
		utilXmlNode book = root.getElementByTagName('book');
		
		utilXmlNode nodeToAppend = new utilXmlDom(xmlToAppend).root;
		
		root.appendChild(nodeToAppend);
		
		utilXmlNode[] books = root.getElementsByTagName('book');
		
		System.assertEquals(3, books.size());
		System.assertEquals('Abhinav Gupta', books[2].getElementByTagName('author').nodeValue);
		System.assertEquals('TGerm', books[2].getElementByTagName('title').nodeValue);
		System.assertEquals('2010', books[2].getElementByTagName('year').nodeValue);
		System.assertEquals('100.00', books[2].getElementByTagName('price').nodeValue);
	}
}
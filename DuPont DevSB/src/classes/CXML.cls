/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  CXML Library

Modifications: 
 TES20100708 converted from XmlDom to utilXmlDom (dropped 8111 to 4795 script statements (UT test1))
********************************************************************************/

public class CXML {

public static final string USER_AGENT = 'SFDC_cXML';
public static final string DOCTYPE = '<!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.014/cXML.dtd">';



/********************************************************************************
 MessageBody interface
 	currently supported Messages:   
 		PunchoutSetupRequest
 		OrderRequest
 		Response
*********************************************************************************/
public interface IMessageBody {
        void writeTo(XmlStreamWriter w);
    }

/********************************************************************************************
SetupRequest -  PunchoutSetupRequest

writeTo()  output the PunchoutSetupRequest message

********************************************************************************************/

public class SetupRequest implements IMessageBody {
	
	public string operation  {get; private set;}
	public string buyerCookie  {get; private set;}
	public string browserPostUrl  {get; private set;}
	public string cartid  {get; private set;}
	public MAP<string,string> extrinsics  {get; private set;}
	
	
	//constructor for create
	public SetupRequest(string aoperation, string abuyerCookie, string abrowserPostUrl) {
		this(aoperation,abuyerCookie,abrowserPostUrl,null);
		}
	//constructor for edit,inspect
	public SetupRequest(string aoperation, string abuyerCookie, string abrowserPostUrl, string acartid) {
		this.operation=aoperation;
		this.buyerCookie=abuyerCookie;
		this.browserPostUrl=abrowserPostUrl;
		this.cartid=acartid;
		this.extrinsics = new MAP<string,string>(); 
	}
	
	public virtual void writeTo(XmlStreamWriter w) {
	    w.writeStartElement(null,'PunchOutSetupRequest',null);
		    w.writeAttribute(null,null,'operation',this.operation);
		    writeElement(w,'BuyerCookie', this.buyerCookie);
		    for (string ename : this.extrinsics.keySet() ) {
	    		if (this.extrinsics.get(ename)!=null) {
	    			w.writeStartElement(null,'Extrinsic',null);
	    			w.writeAttribute(null,null,'name',ename);
	    			w.writeCharacters(this.extrinsics.get(ename));
	    			w.writeEndElement();
	    		}
		    }
			w.writeStartElement(null,'BrowserFormPost',null);
				writeElement(w,'URL', this.browserPostUrl);
			w.writeEndElement(); 
			
			if ( this.operation == 'edit' || this.operation == 'inspect') {
				w.writeStartElement(null,'ItemOut',null);
					w.writeAttribute(null,null,'quantity','1');
					w.writeStartElement(null,'ItemID',null);
						w.writeEmptyElement(null,'SupplierPartID',null);
						writeElement(w,'SupplierPartAuxiliaryID', this.cartid);
					w.writeEndElement();
				w.writeEndElement();
			}
		w.writeEndElement();		
	}    
}

/********************************************************************************************
Simple OrderRequest

********************************************************************************************/
public class OrderRequest implements IMessageBody {
	public string RequestName {set; get;} 
	public decimal totalAmount {set; get;}
	public string totalAmountString {set; get;}
	public string orderId {set; get;}
	public datetime orderDate {set; get;}
	public string orderType {set; get;}
	public string cartid {set; get;}
	public string comments {set; get;}
	public Address billToAddress {set; get;}
	public Address shipToAddress {set; get;}
	public MAP<string,string> extrinsics {set; get;}
	public MAP<string,Item> items {set; get;} //using map to avoid dups productIds
		
	//OrderRequest
	public OrderRequest(string xml) { load(xml); }
	public OrderRequest(string aorderId, decimal TotalAmount ) {
		this.RequestName= 'OrderRequest'; 
		this.orderId=aorderId;
		this.orderDate=DateTime.now();
		this.totalAmount=totalAmount;
		this.orderType='new';
	}
	
	public virtual void writeTo(XmlStreamWriter w) {
	    w.writeStartElement(null,'OrderRequest',null);
	    	w.writeStartElement(null,'OrderRequestHeader',null);
		    	w.writeAttribute(null,null,'orderID',this.orderId);
		    	w.writeAttribute(null,null,'orderDate',this.orderDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ssZ'));
		    	w.writeAttribute(null,null,'type',this.orderType);
		    	w.writeStartElement(null,'Total',null);
		    		w.writeStartElement(null,'Money',null);
		    		w.writeAttribute(null,null,'currency','USD');
					w.writeCharacters(String.valueOf(this.totalAmount));
					w.writeEndElement();
	    		w.writeEndElement();
	    		w.writeStartElement(null,'ShipTo',null);
	    			shipToAddress.writeTo(w);
				w.writeEndElement();
	    		w.writeStartElement(null,'BillTo',null);
	    			billToAddress.writeTo(w);
	    		w.writeEndElement();
				writeElement(w,'Comments', this.comments);
				
				for (string ename : this.extrinsics.keySet() ) {
		    		if (this.extrinsics.get(ename)!=null) {
		    			w.writeStartElement(null,'Extrinsic',null);
		    			w.writeAttribute(null,null,'name',ename);
		    			w.writeCharacters(this.extrinsics.get(ename));
		    			w.writeEndElement();
		    		}
			    }
			w.writeEndElement(); //OrderRequestHeader
			for ( Item item : Items.values() ) {
				w.writeStartElement(null,'ItemOut',null);
					item.writeTo(w);
				w.writeEndElement();
			}
		w.writeEndElement();		
	}
	
	private void load(string xml) {
		utilXmlDom dom = new utilXmlDom(xml); 
		parseOrderRequest(dom.root.getElementByTagName('OrderRequest'));
	}
	
	private void parseOrderRequest(utilXmlNode orderRq) {
			this.Items = new MAP<string,Item>();
			this.extrinsics = new MAP<string,string>();
			utilXmlNode orderRqHeader;

			try {
				orderRqHeader=orderRq.getElementByTagName('OrderRequestHeader');
				this.orderId = orderRqHeader.getAttribute('orderID');
				this.orderDate = Util.XmltoDateTime(orderRqHeader.getAttribute('orderDate'));
				this.orderType = orderRqHeader.getAttribute('type');
			}
			catch (exception e) {}		
	
			
			if (orderRqHeader!=null) {
				try{
					this.totalAmountString = orderRqHeader.getElementByTagName('Total').getValue('Money'); 	
					this.totalAmount = ( totalAmountString != '' ) ? Decimal.valueOf(totalAmountString) : Decimal.valueOf('0.0');
					}
				catch (exception e) {}	
				
				this.shipToAddress = new Address(orderRqHeader.getElementByTagName('ShipTo'));
				this.billToAddress = new Address(orderRqHeader.getElementByTagName('BillTo'));
				this.comments=orderRqHeader.getValue('Comments');
				for (utilXmlNode ext: orderRqHeader.getElementsByTagName('Extrinsic')) 
	        		this.extrinsics.put(ext.getAttribute('name'), ext.textContent);
				
			}
        	//Get Items
        	for(utilXmlNode ei : orderRq.getElementsByTagName('ItemOut')) {
        		Item item = new Item(ei);
            	this.Items.put(item.supplierPartID,item);
			}
	}		
}

/////////////////////////////////////////////////////////////////////////////////////////////////////


/********************************************************************************************
	Header
	methods: 
	--------
	void 			constructor ();
	void 			constructor (HeaderEntry[] he);	
	void 			constructor (utilXmlNode h);		//parse Header Node
	void 			constructor (string xml);			//parse cxml string
	void 			writeTo(XmlStreamWriter w); 
	headerEntry		getEntry(string name);  
********************************************************************************************/
public class Header {

	private LIST<headerEntry> headerEntries;
	
	//Constructors
	public Header() {this.headerEntries = new LIST<headerEntry>();}
	public Header(LIST<HeaderEntry> he) {this.headerEntries = he;}
	public Header(utilXmlNode h) {parseHeader(h);}
	public Header(string xml) { Load(xml);}
	
	
	public LIST<HeaderEntry> getEntries() {
		return headerEntries;
	}
	
	public HeaderEntry getEntry(string nm) {
		for ( HeaderEntry he : headerEntries ) 
			if ( he.Name.toLowerCase() == nm.toLowerCase() ) 
				return he;
		return null;
	}

	private void parseHeader(utilXmlNode Header) {
		this.headerEntries = new LIST<headerEntry>();
		for ( utilXmlNode credential : Header.getElementsByTagName('Credential') ) {
			headerEntries.add(new headerEntry(credential));	
		}
	}

	private void Load(string xml) {
		utilXmlDom dom = new utilXmlDom(xml); 
		parseHeader(dom.root.getElementByTagName('Header'));
	}
	
	
		/*
			utilXmlNode fromHeader = dom.getElementByTagName('Header').getElementByTagName('From');
			headerEntries.add(new headerEntry('From', 
				fromHeader.getElementByTagName('Credential').getAttribute('domain'), 
				fromHeader.getElementByTagName('Credential').getValue('Identity') ));
			utilXmlNode toHeader = dom.getElementByTagName('Header').getElementByTagName('To');
			headerEntries.add(new headerEntry('To', 
				toHeader.getElementByTagName('Credential').getAttribute('domain'), 
				toHeader.getElementByTagName('Credential').getValue('Identity') ));	
			utilXmlNode senderHeader = dom.getElementByTagName('Header').getElementByTagName('Sender');
			headerEntries.add(new headerEntry('Sender', 
				senderHeader.getElementByTagName('Credential').getAttribute('domain'), 
				senderHeader.getElementByTagName('Credential').getValue('Identity'),
				senderHeader.getElementByTagName('Credential').getValue('SharedSecret'),
				senderHeader.getValue('UserAgent') ));
		*/
		
	public void writeTo(XmlStreamWriter w) {
		if (headerEntries.size()>0) {
		    w.writeStartElement(null,'Header',null);
		    for ( headerEntry he : headerEntries ) {
		    	w.writeStartElement(null,he.name,null);
		    		w.writeStartElement(null,'Credential',null);
		        		w.writeAttribute(null,null,'domain',he.domain);
		        		writeElement(w,'Identity', he.identity);
		        		if (he.sharedSecret != null && he.name == 'Sender') writeElement(w,'SharedSecret', he.sharedSecret);
		        	w.writeEndElement(); 
		        	if (he.name == 'Sender') writeElement(w,'UserAgent', 'SFDC-cXML');
		        w.writeEndElement();   
			}
			w.writeEndElement();
		}            
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
public class HeaderEntry {
	public string name  {get; private set;}
	public string domain  {get; private set;}
	public string identity  {get; private set;}
	public string sharedSecret  {get; private set;}
	public string userAgent  {get; private set;}
	
	public headerEntry(utilXmlNode credential) {
		this(credential.parentNode.nodeName,
				credential.getAttribute('domain'), 
				credential.getValue('Identity'),
				credential.getValue('SharedSecret'),
				credential.parentNode.getValue('UserAgent'));
	}
	public headerEntry(string aname, string adomain, string aidentity) {
		this(aname,adomain,aidentity,null,null);
		}
	public headerEntry(string aname, string adomain, string aidentity, string asharedSecret) {
		this(aname,adomain,aidentity,asharedSecret,null);
	}
	public headerEntry(string aname, string adomain, string aidentity, string asharedSecret,string auserAgent) {
		this.name=aname;
		this.domain=adomain;
		this.identity=aidentity;
		this.sharedSecret=asharedSecret;
		this.userAgent=auserAgent;
	}

}



/********************************************************************************
	Create Message
*********************************************************************************/
public static string createMessage(IMessageBody msg) { return createMessage(msg,null,false); }
public static string createMessage(IMessageBody msg, Header h) { return createMessage(msg,h,false); }
public static string createMessage(IMessageBody msg, Header h, boolean isTest) {
	XmlStreamWriter w = new XmlStreamWriter();
    w.writeStartElement(null,'cXML',null);
		w.writeAttribute('','','payloadID',generatePayLoadId());
    	w.writeAttribute('xml','','lang','en-US');
    	w.writeAttribute('','','timestamp',DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ssZ'));
		
		if ( msg instanceOf Response ) 
			msg.writeTo(w);
		else {
			if (h!=null)
				h.writeTo(w);
			if ( msg instanceOf PunchOutOrderMessage )
				w.writeStartElement(null,'Message',null);
			else
			 	w.writeStartElement(null,'Request',null);
			 	
			w.writeAttribute(null,null,'deploymentMode',
				(isTest) ? 'test' : 'production');
			msg.writeTo(w);
			w.writeEndElement();    
		}
    w.writeEndElement();   // </cXML>
    return '<?xml version="1.0" encoding="utf-8"?>'+DOCTYPE+w.getXMLString();	
	}

/**


Support two response type PunchOutSetupResponse and a General Response (OrderResponse)

Response:
<Response>
	<Status code="200" text="success"/>
</Response>

PunchOutSetupResponse: 
<Response>
	<Status code="200" text="success"/>
	<PunchOutSetupResponse>
		<StartPage><URL>https://somewhere.com/app?token=123</URL></StartPage>
	</PunchOutSetupResponse>
</Response>


*/

public class Response implements IMessageBody {
        public string statusCode  {get; set;}
		public string statusText {get; set;}
		public string statusMessage {get; set;}
		public string url	{get; set;}
		
		public Response(string xml) { Load(xml);}
		public Response(string astatusCode,string astatusText) { this(astatusCode,astatusText,null);}
		public Response(string astatusCode,string astatusText, string aurl) {
			statusCode=astatusCode;
			statusText=astatusText;
			url=aurl;
		}

		private void Load(string xml) {
			utilXmlDom dom = new utilXmlDom(xml);  
			utilXmlNode status = dom.root.getElementByTagName('Status');
			statusCode = status.getAttribute('code');
			statusText = status.getAttribute('text');
			statusMessage = status.nodeValue;
			//TES20100708 url = (dom.getElementByTagName('URL')!=null) ? dom.getElementByTagName('URL').getValue('URL') : null;
			url =dom.root.getValue('URL');
			}
			
		public virtual void writeTo(XmlStreamWriter w) {
			w.writeStartElement(null,'Response',null);
				w.writeStartElement(null,'status',null);
					w.writeAttribute('','','code',this.statusCode);
					w.writeAttribute('','','text',this.statusText);
					if (this.statusMessage!=null) w.writeCharacters(this.statusMessage);
				w.writeEndElement(); 

				//treate as PunchOutSetupResponse
				if ( url != null && this.statusCode=='200') {
					w.writeStartElement(null,'PunchOutSetupResponse',null);
						w.writeStartElement(null,'StartPage',null);
							writeElement(w,'URL',url);
						w.writeEndElement();
					w.writeEndElement(); 
					}
			w.writeEndElement(); 
		} 
		
		public string toXml() { 
			return createMessage(this);
		}
			/*
		public string toXml() {
			XmlStreamWriter w = new XmlStreamWriter();
        	w.writeStartElement(null,'cXML',null);
				w.writeAttribute('','','payloadID',generatePayLoadId());
        		w.writeAttribute('xml','','lang','en-US');
        		w.writeAttribute('','','timestamp',DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ssZ'));
				writeTo(w);
        	w.writeEndElement();    
        	return '<?xml version="1.0" encoding="utf-8"?>'+DOCTYPE+w.getXMLString();
        }
        */
        	
		
		
    }

	public class PunchOutOrderMessage implements IMessageBody {
		public string buyerCookie  		{get; private set;}
		public decimal totalAmount 		{get; private set;}
		public string operationAllowed	{get; private set;}
		private MAP<string,Item> Items;  //using map to avoid dups productIds
		
		
		//constructors
		public PunchOutOrderMessage(string xml) { Load(xml);}
		public PunchOutOrderMessage(utilXmlNode poom) { parsePOOM(poom);}
	
		//public PunchOutOrderMessage(string abuyerCookie, decimal atotalAmount, string aoperationAllowed) {
		//	this(abuyerCookie,atotalAmount,aoperationAllowed, new MAP<string,Item>());
		//}
		public PunchOutOrderMessage(string abuyerCookie, decimal atotalAmount, string aoperationAllowed, MAP<string,Item> Items) { 
			this.buyerCookie=abuyerCookie;
			this.totalAmount=atotalAmount;
			this.operationAllowed=aoperationAllowed;
			this.Items=Items;
		}
	
		//Item functions
		public List<Item> 		getItems() 				{ return Items.values(); }
		public MAP<string,Item> getItemMap() 			{ return Items; }	
		public Item 			getItem(string partid) 	{ return Items.get(partid); }

		
		
	public virtual void writeTo(XmlStreamWriter w) {
	    w.writeStartElement(null,'PunchOutOrderMessage',null);
	    	writeElement(w,'BuyerCookie', this.buyerCookie);
	    	w.writeStartElement(null,'PunchOutOrderMessageHeader',null);
		    	w.writeAttribute(null,null,'operationAllowed',this.operationAllowed);
		    	w.writeStartElement(null,'Total',null);
		    		w.writeStartElement(null,'Money',null);
		    		w.writeAttribute(null,null,'currency','USD');
					w.writeCharacters(String.valueOf(this.totalAmount));
					w.writeEndElement();
	    		w.writeEndElement();
			w.writeEndElement();
			for ( Item item : Items.values() ) {
				w.writeStartElement(null,'ItemIn',null);
				item.writeTo(w);
				w.writeEndElement();
			}
		w.writeEndElement();		
	}
		
		private void Load(string xml) {
			utilXMLDom dom = new utilXMLDom(xml);  
			parsePOOM(dom.root.getElementByTagName('PunchOutOrderMessage'));
		}		
			
		private void parsePOOM(utilXmlNode poom) {
			this.Items = new MAP<string,Item>();
			utilXmlNode poomHeader;
			
			//get buyercookie REQUIRED
			try {
				this.buyerCookie = poom.getValue('BuyerCookie');
				poomHeader=poom.getElementByTagName('PunchOutOrderMessageHeader');
			}
			catch (exception e) {}		
			
			
			if (poomHeader!=null) {
				if ( poomHeader.getAttribute('operationAllowed') != null )
					this.operationAllowed = poomHeader.getAttribute('operationAllowed');
				
				try {	
					string total = poomHeader.getElementByTagName('Total').getValue('Money'); 	
					this.totalAmount = ( total != '' ) ? Decimal.valueOf(total) : Decimal.valueOf('0.0');
				}
				catch (exception e) {}			
			}
        	//Get Items
        	for(utilXmlNode ee : poom.getElementsByTagName('ItemIn')) {
        		Item item = new Item(ee);
            	this.Items.put(item.supplierPartID,item);
			}
		}
	}


/********************************************************************************
	Item  (ItemIn or ItemOut)
*********************************************************************************/
	public class Item {
		public string quantity {set; get;}
		public string supplierPartID {set; get;} 
		public string supplierPartAuxiliaryID {set; get;}
		public string unitPrice {set; get;}
		public string description {set; get;}
		public string manufacturerName {set; get;}
		public string unitOfMeasure {set; get;}
		public MAP<string,string> classifications {set; get;}
		public MAP<string,string> extrinsics  {set; get;}
		
		
		//constructors
		public Item() {
			classifications= new MAP<string,string>();
			extrinsics= new MAP<string,string>();
		}
		public Item(utilXmlNode ie) {
				classifications= new MAP<string,string>();
				extrinsics= new MAP<string,string>();
	        	this.quantity = ie.getAttribute('quantity');
	        	utilXmlNode itemid = ie.getElementByTagName('ItemID');
	        	this.supplierPartID = itemid.getValue('SupplierPartID');
	        	this.supplierPartAuxiliaryID = itemid.getValue('SupplierPartAuxiliaryID');
	        	utilXmlNode itemdetail = ie.getElementByTagName('ItemDetail');
	        	this.unitPrice = itemdetail.getElementByTagName('UnitPrice').getValue('Money');
	        	this.description = itemdetail.getValue('Description');
	        	this.unitOfMeasure = itemdetail.getValue('UnitOfMeasure');
	        	for (utilXmlNode c: itemdetail.getElementsByTagName('Classification')) 
	        		this.classifications.put(c.getAttribute('domain'), c.textContent);
	        	this.manufacturerName = itemdetail.getValue('ManufacturerName');
				for (utilXmlNode ext: itemdetail.getElementsByTagName('Extrinsic')) 
	        		this.extrinsics.put(ext.getAttribute('name'), ext.textContent);
			}
		
		public void writeTo(XmlStreamWriter w) {
			w.writeAttribute(null,null,'quantity',this.quantity);
			w.writeStartElement(null,'ItemID',null);
				writeElement(w,'SupplierPartID', this.supplierPartID);
				writeElement(w,'SupplierPartAuxiliaryID', this.supplierPartAuxiliaryID);
			w.writeEndElement();
			w.writeStartElement(null,'ItemDetail',null);
				w.writeStartElement(null,'UnitPrice',null);
					w.writeStartElement(null,'Money',null);
		    			w.writeAttribute(null,null,'currency','USD');
						w.writeCharacters(this.unitPrice);
					w.writeEndElement();
				w.writeEndElement();
				w.writeStartElement(null,'Description',null );											
					w.writeAttribute('xml','','lang','en');
					w.writeCharacters(this.description);
				w.writeEndElement();
				writeElement(w,'UnitOfMeasure',this.unitOfMeasure);
				
			    for (string cdomain : this.classifications.keySet() ) {
		    		if (this.classifications.get(cdomain)!=null) {
		    			w.writeStartElement(null,'Classification',null);
		    			w.writeAttribute(null,null,'domain',cdomain);
		    			w.writeCharacters(this.classifications.get(cdomain));
		    			w.writeEndElement();
		    		}
			    }
			    for (string ename : this.extrinsics.keySet() ) {
		    		if (this.extrinsics.get(ename)!=null) {
		    			w.writeStartElement(null,'Extrinsic',null);
		    			w.writeAttribute(null,null,'name',ename);
		    			w.writeCharacters(this.extrinsics.get(ename));
		    			w.writeEndElement();
		    		}
			    }
			w.writeEndElement();	
		}            

	}

/*
 <Address>
     <Name xml:lang="en">Craig Brimley</Name>
     <PostalAddress name="default">
         <DeliverTo>Craig Brimley</DeliverTo>
         <Street>2 Rector St, 25th Floor</Street>
         <City>New York</City>
         <State>NY</State>
         <PostalCode>10006</PostalCode>
         <Country isoCountryCode="US">US	                             </Country>
     </PostalAddress>
 </Address>
*/
public class Address {
		public string name {set; get;}
		public string deliverTo {set; get;} 
		public string street {set; get;}
		public string city {set; get;}
		public string state {set; get;}
		public string postalCode {set; get;}
		public string country {set; get;}
		public string isoCountryCode {set; get;}
		
		//constructors
		public Address() {}
		public Address(utilXmlNode addr) {
        	this.name = addr.getValue('Name');
        	utilXmlNode postalAddr = addr.getElementByTagName('PostalAddress');
        	this.deliverTo = postalAddr.getValue('DeliverTo');
        	this.street = postalAddr.getValue('Street');
        	this.city = postalAddr.getValue('City');
        	this.state = postalAddr.getValue('State');        	
        	this.postalCode = postalAddr.getValue('PostalCode');
        	this.country = postalAddr.getValue('Country');
        	this.isoCountryCode = postalAddr.getElementByTagName('Country').getAttribute('isoCountryCode');
        	
			}
		
		public Geography.Address postalAddress {
			GET {
				return new Geography.Address(street,city,state,postalCode,country);
			}
			SET {
	        	this.street = value.street;
	        	this.city = value.city;
	        	this.state = value.state;        	
	        	this.postalCode = value.postalcode;
	        	this.country = value.country;
				this.isoCountryCode=new Geography.GeoAddress(value).getCountryInfo().A2;
			}
		}
		
		public void writeTo(XmlStreamWriter w) {
			w.writeStartElement(null,'Address',null);
				w.writeStartElement(null,'Name',null );											
					w.writeAttribute('xml','','lang','en');
					w.writeCharacters(this.name);
				w.writeEndElement();
				w.writeStartElement(null,'PostalAddress',null);
					w.writeAttribute(null,null,'name','default');
					writeElement(w,'DeliverTo', this.deliverTo);
					writeElement(w,'Street', this.street);
					writeElement(w,'City', this.city);
					writeElement(w,'State', this.state);
					writeElement(w,'PostalCode', this.postalCode);
					w.writeStartElement(null,'Country',null);											
						w.writeAttribute(null,null,'isoCountryCode',this.isoCountryCode);
						w.writeCharacters(this.country);
					w.writeEndElement();
				w.writeEndElement();
			w.writeEndElement();	
		} 
		           
	}
//////////////////////////////////////////////////////////////////////////////////////////////
	private static string generatePayLoadId() {
		return UserInfo.getOrganizationId()+UserInfo.getUserId()+DateTime.now().formatGmt('yyyyMMddHHmmssSSSS');
	}
	

//////////////////////////////////////////////////////////////////////////////////////////////
	private static void writeElement(XmlStreamWriter w, string nodename, string value) {
        if (value !=null && nodename != null) {
            w.writeStartElement(null,nodename,null);
            w.writeCharacters(value);
            w.writeEndElement();
        }
    }	

    
}
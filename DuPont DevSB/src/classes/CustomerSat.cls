/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Class used to communicate to CustomerSAT (markettools.com)

CSAT Contact: Jon Noblejas ph:1-415-536-3334

Description: CustomerSAT API Integration

Notes:
	-A BOM is required on the UTF-8 payload for endpoint to determine encoding
	-Send variables have a limit of 1020 characters  (TYPE=Text)
	-FeedbackResponse FilterIds unlike the send variables have a different id for each surveyid
	 because of this, the filters are no longer being used.

TESII20110802 - added new showTranslation feature
TESII20110321 - bug in simpleEmail

********************************************************************************/
global class CustomerSat {
 

	private static final string ADMIN_EMAIL            	= 'thomas.snyder@usa.dupont.com,robin.l.russell@usa.dupont.com';
    private static final string CRYPAUTH            	= 'uuzhGuzPsb/LcQSCP+MMxVW4nI0VRxEJrvliRsFfazFD6oDekp/ahxtqtdjmEcR8';
    private static final string SURVEY_SCHEMA_VER   	= '1.0';
    private static final string CSATBASE_URL        	= 'https://apiconnectservices.customersat.com/WebConnectService.svc/';
 	public  static string HTTP_RESPONSE		 			= '';
	public  static string		DEFAULT_SURVEYID      	= '8755';
	private static Util.Describe mDescribe_CLS;		
	private static MAP<String,String> cacheMAP_CSAT_PUSH;
	private static MAP<String,String> cacheMAP_CSAT_PULL;
	

	
	//GETS MAPPING (CLS TO CSAT(QIDS) 
    public static MAP<String,String> MAP_CSAT_PUSH {
    	get {
    		if (cacheMAP_CSAT_PUSH==null) {
	    		cacheMAP_CSAT_PUSH=new MAP<String,String>();
	    		for (CSAT_CLSMapping__c m : CSAT_CLSMapping__c.getAll().values()) {
	    			if ( m.direction__c=='push' || m.direction__c=='both' )
	    				cacheMAP_CSAT_PUSH.put(m.CLS_FieldName__c.toLowercase(),m.CSAT_QID__c );
	    		}
			}
			return cacheMAP_CSAT_PUSH;
    	}
    }
    
	public static MAP<String,String> MAP_CSAT_PULL {
    	get {
    		if (cacheMAP_CSAT_PULL==null) {
	    		cacheMAP_CSAT_PULL= new MAP<String,String>();
	    		for (CSAT_CLSMapping__c m : CSAT_CLSMapping__c.getAll().values()) {
	    			if ( m.direction__c=='pull' || m.direction__c=='both' )
	    				cacheMAP_CSAT_PULL.put(m.CSAT_QID__c, m.CLS_FieldName__c.toLowercase() );
	    		}
    		}
    		return cacheMAP_CSAT_PULL;
    		
    	}
    }
   
   	public static string CSAT_PUSH_SOQL {
    	get {
        	MAP<string,string> flds = Describe_CLS.AccessibleFieldMap;
        	SET<string> fs = flds.keyset().clone();
        	for (string f : fs) {
        		if (!MAP_CSAT_PUSH.containsKey(f)) flds.remove(f);
        	}
			string soql='SELECT '+ Util.joint(flds.values(), ',')+' FROM CustomerLoyaltySurvey__c';
			return soql;	
		}
	}

   	private static Util.Describe describe_CLS {
   		GET { if (mDescribe_CLS==null)
			mDescribe_CLS = new Util.Describe('CustomerLoyaltySurvey__c');
		return mDescribe_CLS;
   		}
   	}

    public static string sendSampleData(string surveyId, string SurveyPeriod) {
    	string query = CSAT_PUSH_SOQL + ' WHERE DeploymentQtr__c = \''+SurveyPeriod+'\'';
        return Database.executeBatch(new batchCustomerSat_Send(surveyId, query),100);
    }  
    
    public static HttpResponse sendSampleDataStatus(string fileId)  {
        return sendRequest(CSATBASE_URL+'sampledatastatus?FileID='+fileId);
    }
   
   
   
   
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
  	//  Filter Methods
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    public static MAP<string,string> getFilters()  { return getFilters(DEFAULT_SURVEYID); }
	public static MAP<string,string> getFilters(string surveyId) {
		if ( Test.isRunningTest())
			return parseFilterRequest(HTTP_RESPONSE);
   		else {
	        //SEND HTTP Request
	        HttpResponse myresp = sendFilterRequest(surveyId);
			string payload=myresp.getBody();
			// Remove BOM char,  otherwise (XML Error: Content is not allowed in prolog.)
        	if (payload!=null && payload.substring(0,1)!='<') payload=payload.substring(1);
			return parseFilterRequest(payload);
		}
	}   
	//////////////////////////////////////////////////////////////////////////////////////////
    public static HttpResponse sendFilterRequest()  { return sendFilterRequest(DEFAULT_SURVEYID); }
    public static HttpResponse sendFilterRequest(string filterId)  {
        return sendRequest(CSATBASE_URL+'getFilters?SID='+filterId);
    }
    
	//////////////////////////////////////////////////////////////////////////////////////////
    public static MAP<string,string> parseFilterRequest(string xml) {
		MAP<string,string> rtn = new MAP<string,string>();
		utilXMLDom dom = new utilXmlDom(xml);  
		for(utilXmlNode re : dom.root.getElementsByTagName('Filter')) {
			rtn.put(re.getValue('FilterName').trim(),re.getValue('FilterID').trim());
		}
		return rtn;
	}   
   //////////////////////////////////////////////////////////////////////////////////////////
  
  
  
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
  	//  Properties (QID) Methods
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
	public static MAP<string,string> getProperties()  { return getProperties(DEFAULT_SURVEYID); }
	public static MAP<string,string> getProperties(string surveyId) {
		if ( Test.isRunningTest())
			return parseFilterRequest(HTTP_RESPONSE);
   		else {
	        //SEND HTTP Request
	        HttpResponse myresp = sendSurveyProperties(surveyId);
			string payload=myresp.getBody();
			// Remove BOM char,  otherwise (XML Error: Content is not allowed in prolog.)
        	if (payload!=null && payload.substring(0,1)!='<') payload=payload.substring(1);
			return parseSurveyProperties(payload);
		}
	}   
	//////////////////////////////////////////////////////////////////////////////////////////
 	public static HttpResponse sendSurveyProperties() { return  SendSurveyProperties(DEFAULT_SURVEYID); } 
    public static HttpResponse sendSurveyProperties(string sid)  {
        return sendRequest(CSATBASE_URL+'getsurveyproperties?SID='+sid);
    }
    
	//////////////////////////////////////////////////////////////////////////////////////////
    public static MAP<string,string> parseSurveyProperties(string xml) {
		MAP<string,string> rtn = new MAP<string,string>();
		utilXMLDom dom = new utilXmlDom(xml);  
		//for(utilXmlNode re : dom.root.getElementsByTagName('Filter')) {
		//	rtn.put(re.getValue('FilterName').trim(),re.getValue('FilterID').trim());
		//}
		return rtn;
	}   
   //////////////////////////////////////////////////////////////////////////////////////////
  
  

    
    
    //CustomerSat.getFeedBackResponse(Date.valueof('2007-01-01'),Date.valueOf('2009-12-31'),null,null);
    //FilterId=145374
    
    public static string getFeedBackUrl()			 								  								{  return getFeedBackUrl(null,null,null,null,null,false);			}
    public static string getFeedBackUrl(string aSurveyId)                                  							{  return getFeedBackUrl(aSurveyId,null,null,null,null,false);      }
    public static string getFeedBackUrl(string aSurveyId, integer page)                    							{  return getFeedBackUrl(aSurveyId,null,null,page,null, false);     }
    public static string getFeedBackUrl(string aSurveyId, integer page, string filterId)   							{  return getFeedBackUrl(aSurveyId,null,null,page,filterId,false);  }
 	public static string getFeedBackUrl(string aSurveyId, date startDT, date EndDT, integer page, string filterId ) {  return getFeedBackUrl(aSurveyId,startDT,EndDT,page,filterId,false); }  
    public static string getFeedBackUrl(string aSurveyId, date startDT, date EndDT, integer page, string filterId, boolean translations ) {
        
        //Construct URL
        if (aSurveyId==null) aSurveyId=DEFAULT_SURVEYID;
        
        string url = CSATBASE_URL+'feedbackresponses?SID='+aSurveyId;
        if (startDT     ==  null) startDT=Date.Today().addMonths(-3);
        if (endDT       ==  null) endDT=Date.Today();
        url+='&responseStartdate='+String.valueOf(startDT);
        url+='&responseEnddate='+String.valueOf(endDT);
        if (page        !=  null) url+='&page='+String.valueOf(page);
        if (filterId    !=  null) url+='&filterID='+String.valueOf(filterId);
        if (translations) url+='&showTranslation=true';  //TESII20110802
        system.debug('----url: '+url);
        
        return url;
    }
   
   
   public static FeedbackResponse getFeedBackResponse(string url, string batchname) { return getFeedBackResponse(url,batchname,null); } 
   public static FeedbackResponse getFeedBackResponse(string url, string batchname, string testid) {   	
   		string payload;
   		
   		if ( Test.isRunningTest() || testid!=null ) {
			payload=string.format(HTTP_RESPONSE, new string[] {testid});
   		}
   		else {
	        //SEND HTTP Request
	        HttpResponse myresp = SendRequest(url);
			payload=myresp.getBody();
		}
   		
        // Remove BOM char,  otherwise (XML Error: Content is not allowed in prolog.)
        if (payload!=null && payload.substring(0,1)!='<') payload=payload.substring(1);
        FeedbackResponse fr = new FeedbackResponse(payload,batchname);
        system.debug('------FeedbackResponse------>'+fr);
        return fr;
   
    }

 //////////////////////////////////////////////////////////////////////////////////////////
 // SampleData
 //////////////////////////////////////////////////////////////////////////////////////////  
    
    public class SampleData {
            
        public string surveySchemaVersion               {set; get;}
        public string surveyID                          {set; get;}         
        public MAP<string,sampleRow> sampleRows         {set; get;}
        public string fileID                            {set; get;}             
        //constructor(s)

        
        public SampleData(string surveyId, MAP<ID,CustomerLoyaltySurvey__c> CLSs) { this(surveyId, CLSs.values()); }
        public SampleData(string surveyId, LIST<CustomerLoyaltySurvey__c> CLSs) { 
            this.SurveySchemaVersion=SURVEY_SCHEMA_VER;
            this.SurveyID=surveyId;
            
            sampleRows = new MAP<string,sampleRow>();
            for (CustomerLoyaltySurvey__c CLS : CLSs) {
                sampleRow sr=new SampleRow(CLS);
                sampleRows.put(CLS.id,sr);
            }
        }
        
        /*        
        public void addTestEmail(){
            integer cnt=1;
            for (sampleRow sr : this.sampleRows.values())
                sr.QIDs.put(QID_EMAIL, String.format(TEST_EMAIL, new String[]{ String.valueOf(cnt++)}) );
        }
        */
        
        public string toXml() {
            //string Declaration = '<?xml version="1.0" encoding="utf-8"?>'; //'<?xml version="1.0" encoding="utf-8"?>';
            //string DOCTYPE='';
            
            Xmlstreamwriter w = new Xmlstreamwriter();
        	w.writeStartDocument('utf-8','1.0');
            writeTo(w);
            //Add a BOM: EncodingUtil.base64decode('77u/').toString()
            string rtn=EncodingUtil.base64decode('77u/').toString()+w.getXMLString();
            w.close();
            return rtn; 
        }
    
        public virtual void writeTo(XmlStreamWriter w) {
            w.writeStartElement(null,'SampleData',null);
                w.writeAttribute(null,null,'SurveySchemaVersion',this.SurveySchemaVersion);
                w.writeAttribute(null,null,'CustomerSampleDate', DateTime.now().formatGmt('yyyy-MM-dd')); 
                w.writeAttribute(null,null,'SurveyID',this.SurveyID);
                for ( sampleRow r : sampleRows.values() )
                    r.writeTo(w);
            w.writeEndElement();        
        }
        
        public virtual HttpResponse send() { return Send(generatePayLoadId()); }
        public virtual HttpResponse send(string filename) {
                string url = CSATBASE_URL+'sampledata?SID='+this.SurveyID+'&FileName='+filename+'.xml';
                //string payload = this.ToXml();
                string payload = this.ToXml(); //Add BOM
                
                system.debug('URL: '+ URL);
                system.debug('payload: '+ payload);
                return SendRequest(URL, payload );
        }
        
    } //class:  sampleData


//////////////////////////////////////////////////////////////////////////////////////////
 // SampleRow
 //////////////////////////////////////////////////////////////////////////////////////////     
    
    public class SampleRow {
            
        public MAP<string, string> QIDs  {get; set;}
            
        public sampleRow(CustomerLoyaltySurvey__c CLS) { 
            QIDs = new MAP<string, string>();
            applyMapping(MAP_CSAT_PUSH, CLS);
        }
        
                        
        public virtual void writeTo(XmlStreamWriter w) {
            w.writeStartElement(null,'SampleRow',null);
            for (string ename : QIDs.keyset() ) {
                writeElement(w,'QID-'+ename,this.QIDs.get(ename));
            }
            w.writeEndElement();
        }
        
        public virtual void add(string id, string val) {
             if ( val != null) QIDs.put(id,val);
        }
        
        private void applyMapping(MAP<string,string> mapQID, sObject obj) {
            if (obj!=null) {
                for (string fld : mapQID.keyset() ) {
                    try {
                        string val = String.valueOf(obj.get(fld));
                        this.add(mapQID.get(fld),val);
                    }
                    catch( Exception ex ) {}
                 }
            }
        }       
                
    } //class:  sampleRow
 

 //////////////////////////////////////////////////////////////////////////////////////////

 //////////////////////////////////////////////////////////////////////////////////////////
 // FeedbackResponse
 // TES20100915 changed to global to use as iterator
 //////////////////////////////////////////////////////////////////////////////////////////  
    
global class FeedbackResponse {
        
        public integer page                         {get; set;}
        public boolean isLastPage                   {get; set;}     
        public MAP<string, Response> responses      {get; set;}
        public string batchName						{get; set;}
        
		public FeedbackResponse(string xml) { this(xml,null); }    
        public FeedbackResponse(string xml, string aBatchName) {
        	
        	if (aBatchName!=null) 
        		this.BatchName=aBatchName;
			else
        		this.BatchName='B'+DateTime.now().formatGmt('yyyyMMddHHmm');
        	
            System.debug('-------XML length:  '+xml.length());
            this.Responses = new MAP<string, Response>(); 
            this.IsLastPage = true;
            utilXMLDom dom = new utilXmlDom(xml);  
            //if (dom.containsElement'FeedbackResponse') != null)
            parse(dom.root.getElementByTagName('FeedbackResponse'));
            
            }
      

        public LIST<CustomerLoyaltySurvey__c> toCLSs() {
            
            //get Set of valid CLSIds;
            SET<string> CLSIds = new SET<string> ();
            for (Response r : this.Responses.values()) {
            	
            	//DEBUG Force all response to ID below
            	//r.Values.put(MAP_CSAT_PULL.get('id'),'a2aQ00000008PZk'); 
            	//CLSIds.add('a2aQ00000008PZk');
            	
            	if ( r.CLSId!=null )
                	CLSIds.add(r.CLSId);
            }
            
            
            system.debug('--------CLS IDs to Update------>'+CLSIds);
            
            //Pull for Update
            MAP<id, CustomerLoyaltySurvey__c> CLSs = new MAP<id, CustomerLoyaltySurvey__c>([
                Select Id FROM CustomerLoyaltySurvey__c
                WHERE Id in :CLSIds
                ]);
                
            //WriteTo CLS records
            if (CLSs.size()>0) {
	            for (Response r : this.Responses.values()) {
	            	//convert string to ID
	            	Id id;
	            	try { id=r.CLSId; } catch(exception ex) {}
	            	
	                if ( id!=null && CLSs.containskey(id)) {
	                	CustomerLoyaltySurvey__c CLS = CLSs.get(id);
	                    r.writeToCLS(CLS);
	                }
	            }
            }
            return CLSs.values();
        }

            
        private void parse(utilXmlNode fre) {
            if (fre!=null) {
	            utilXmlNode pageE=fre.getElementByTagName('Page');
	            if (pageE!=null) {
	                this.Page = Integer.valueOf(pageE.textContent);
	                this.IsLastPage = ( pageE.getAttribute('IsLastPage')=='true' );
	            }
	            //Get Responses
	            for(utilXmlNode re : fre.getElementsByTagName('Response')) {
	                Response r = new Response(re);
	                this.Responses.put(r.ID,r);
	            }
            }
        }                       
    }

 //////////////////////////////////////////////////////////////////////////////////////////
 // Response
 //////////////////////////////////////////////////////////////////////////////////////////  

public class Response {
        
        public string id                    		{get; set;}
        public datetime responseDateTime    		{get; set;}
        public MAP<string, string> values   		{get; set;}
        public string clsId							{get; private set;}
        
        public Response(utilXmlNode re) { 
                values=new MAP<string,string>();
                this.ID = re.getAttribute('ID');
                this.ResponseDateTime = Util.xmlToDateTime(re.getAttribute('ResponseDateTime'));
                for (utilXmlNode v: re.getElementsByTagName('Value')) {
                	string qid=v.getAttribute('ID');
                	if (v.nodeValue!=null)
                    	this.values.put(qid,v.nodeValue.trim());
                    
                    // start TESII20110802
                    string trans = v.getValue('TranslationText');
                    if (trans!=null)
						this.values.put(qid+'T',trans.trim());
					// end TESII20110802	
                    if ( MAP_CSAT_PULL.get(qid) == 'id') {
                    	this.clsId=v.textContent;
						system.debug('New response for QID:'+qid);
                    }
                }
            }
                        
         public void writeToCLS(CustomerLoyaltySurvey__c CLS) {
         	MAP<string,string> writeToMap = new MAP<string,string>();
			for (string qid : MAP_CSAT_PULL.keyset()) {
				string val=this.Values.get(qid);
            	if (!Util.isBlank(val)) 
            		writeToMap.put(MAP_CSAT_PULL.get(qid),val);
			}
			writeToMap.put('Response_ID__c',this.id);
			writeToMap.put('Response_DateTime__c',String.valueOf(this.responseDateTime));
			Util.SobjectPutMap(CLS, writeToMap, Describe_CLS);
         }      
    } //class:  Response


//
//		<Question>
//			<ID>204006</ID>
//			<TypeID>6</TypeID>
//			<PageOrderNo>4</PageOrderNo>
//			<SeqNumber>1</SeqNumber>
//			<Text>What is the number one area [External Business Name] could improve to make you more likely to recommend?</Text>
//		</Question>


//////////////////////////////////////////////////////////////////////////////////////////////
//  Helper Methods
//////////////////////////////////////////////////////////////////////////////////////////////

    public static HttpResponse sendRequest(string endPoint) { return SendRequest(endPoint,null); }  //HTTP GET
    public static HttpResponse sendRequest(string endPoint, string payload) {                       //HTTP POST
        HttpRequest request = new HttpRequest();
        if ( payload == null ) 
            request.setMethod('GET');
        else {
            request.setMethod('POST');
            //request.setHeader('Content-Length',String.valueof(payload.length()));
            //request.setCompressed(true);  /does not handle gzip
            request.setBody(payload);
            //request.setHeader('Content-Length',String.valueof(request.getBody().length()));
            system.debug('header:Content-Length = '+request.getHeader('Content-Length'));

        }
        
        request.setTimeout(60000);
        request.setHeader('Content-Type','text/plain; charset=utf-8');
        system.debug('header:Content-Type = '+request.getHeader('Content-Type'));
        
        request.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(ctrlEncrypt.decrypt(CRYPAUTH))));
        system.debug('header:Authorization = '+request.getHeader('Authorization'));
        request.setEndpoint(endPoint);
        
        system.debug('----OUTBOUND PAYLOAD---->'+request.getBody());
        Http http = new http();
        HttpResponse response;
        try {
			if ( !Test.isRunningTest() ) {
		        response = http.send(request);
		        system.debug('----Response PAYLOAD---->'+response.getBody());
		        if ( response.getStatusCode()!=200 ) {
		        	string msg = String.format('Request:\n\n{0}\n{1}\n\n\n\nResponse:\n\n{2}\n{3}', new string[]{ String.valueOf(request),request.getBody(),String.valueOf(response),response.getBody() });
		        	utilEmail.simpleEmail(ADMIN_EMAIL , 'Error: '+response.getStatus()+' (CustomerSat.SendRequest)', msg );
		        }
			}
        }
        catch (exception ex) {
            system.debug('HTTP ERROR: '+ex);
        	if ( !Test.isRunningTest() ) {
        		string msg = String.format('Request:\n\n{0}\n\n\n\n\nResponse:\n\n{2}\n\n\nException:\n\n{4}', new string[]{ String.valueOf(request),String.valueOf(response),String.valueOf(ex) });
        		utilEmail.simpleEmail(ADMIN_EMAIL , 'Error: '+ex+' (CustomerSat.SendRequest)', msg );
        	}
        }
        return response;
    } 

    //////////////////////////////////////////////////////////////////////////////////////////////
        private static string generatePayLoadId() {
        //UserInfo.getOrganizationId()+
        return UserInfo.getOrganizationId()+UserInfo.getUserId()+DateTime.now().formatGmt('yyyyMMddHHmm');
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    private static void writeElement(XmlStreamWriter w, string nodename, string value) {
        if (value !=null && nodename != null) {
            w.writeStartElement(null,nodename,null);
            w.writeCharacters(value);
            w.writeEndElement();
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    public static void sendTestToMe(ID id) {
		LIST<CustomerLoyaltySurvey__c> CLSs = database.query(CSAT_PUSH_SOQL + ' WHERE id = \''+id+'\' OR campaign__c = \''+id+'\'');
        system.debug('-----CLS records:' + CLSs.size());
        CustomerSat.SampleData sd = new CustomerSat.SampleData('0101', CLSs);
        string em = [Select email from User where id=:UserInfo.getUserId()].email;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { em, 'thomas.snyder@usa.dupont.com' });
        mail.setSubject('CustomerSat.Send_SampleData Test Payload');
        Messaging.EmailFileAttachment tAtt = new Messaging.EmailFileAttachment();
	    tAtt.fileName = 'payload.xml';
		tAtt.setBody(Blob.valueOf(sd.ToXml()));
		mail.setFileAttachments(new Messaging.EmailFileAttachment[] {tAtt});
        mail.setPlainTextBody('payload sent:\n\n');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

    
}
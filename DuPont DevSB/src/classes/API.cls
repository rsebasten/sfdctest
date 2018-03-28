/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Apex to SFDC SOAP API Library 

TES20110621 Pull POD from Util that leverages new URL class (v22.0) no need to hardcode
TES20111121 cleaned up fieldProperties object, added method listMetadataMap()
TES20120127 Added Partner.Login
TES20120608 Added Partner.Query
<SA20170115>  Renamed the inner class userinfo to userinfo_inner and increased the timelimit to 2mins using custom label 'Session_Time_Out'
********************************************************************************/

public class API {

  public static final string VERSION            = '25.0';
  public static final string NS_SOAP            = 'http://schemas.xmlsoap.org/soap/envelope/';
  public static final string NS_PARTNER           = 'urn:partner.soap.sforce.com';  
  public static final string NS_META            = 'http://soap.sforce.com/2006/04/metadata';
  public static string TESTRESPONSE  {get; set;}
  public static string SESSION     {get; set;}
  public static string POD      {get; set;}
  
  public static final string TESTRESPONSE_listMetadata  = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://soap.sforce.com/2006/04/metadata"><soapenv:Body><listMetadataResponse><result><createdById>00530000000yWfBAAU</createdById><createdByName>Floris de Klerk</createdByName><createdDate>2008-09-04T08:16:00.000Z</createdDate><fileName>objects/Call_Report_Item__c.object</fileName><fullName>Call_Report_Item__c</fullName><id>01I300000008UZsEAM</id><lastModifiedById>00530000000yWfBAAU</lastModifiedById><lastModifiedByName>Floris de Klerk</lastModifiedByName><lastModifiedDate>2010-01-11T06:06:20.000Z</lastModifiedDate><manageableState>unmanaged</manageableState><type>CustomObject</type></result><result><createdById>00530000000znVUAAY</createdById><createdByName>Tom Snyder</createdByName><createdDate>2010-09-20T17:45:43.000Z</createdDate><fileName>objects/Metadata__c.object</fileName><fullName>Metadata__c</fullName><id>01IS0000000DZ3iMAG</id><lastModifiedById>00530000000znVUAAY</lastModifiedById><lastModifiedByName>Tom Snyder</lastModifiedByName><lastModifiedDate>2010-10-15T18:38:11.000Z</lastModifiedDate><manageableState>unmanaged</manageableState><type>CustomObject</type></result><result><createdById>00530000003aJU1AAM</createdById><createdByName>Joe Ferraro</createdByName><createdDate>2010-03-07T16:37:59.000Z</createdDate><fileName>objects/SVMXC__Site__c.object</fileName><fullName>SVMXC__Site__c</fullName><id>01I300000011pRbEAI</id><lastModifiedById>00530000003aJU1AAM</lastModifiedById><lastModifiedByName>Joe Ferraro</lastModifiedByName><lastModifiedDate>2010-03-07T16:46:34.000Z</lastModifiedDate><manageableState>installed</manageableState><namespacePrefix>SVMXC</namespacePrefix><type>CustomObject</type></result></listMetadataResponse></soapenv:Body></soapenv:Envelope>';
  //[01312017] Merge&Spin: replaced hard coding of page layout Id for 'Picklist' page layout on Metadata__c object through custom Label
    public static final string TESTRESPONSE_describeLayout  = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><describeLayoutResponse><result><layouts><buttonLayoutSection><detailButtons><custom>false</custom><label>Edit</label><name>Edit</name></detailButtons><detailButtons><custom>false</custom><label>Delete</label><name>Delete</name></detailButtons><detailButtons><custom>false</custom><label>Clone</label><name>Clone</name></detailButtons><detailButtons><custom>false</custom><label>Sharing</label><name>Share</name></detailButtons></buttonLayoutSection><detailLayoutSections><columns>2</columns><heading>Information</heading><layoutRows><layoutItems><editable>false</editable><label>API Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>1</tabOrder><type>Field</type><value>Name</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Parent</label><layoutComponents><displayLines>1</displayLines><tabOrder>12</tabOrder><type>Field</type><value>Parent__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Label</label><layoutComponents><displayLines>1</displayLines><tabOrder>2</tabOrder><type>Field</type><value>Label__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Is Custom</label><layoutComponents><displayLines>1</displayLines><tabOrder>13</tabOrder><type>Field</type><value>IsCustom__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>3</tabOrder><type>Field</type><value>Type__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Control</label><layoutComponents><displayLines>1</displayLines><tabOrder>14</tabOrder><type>Field</type><value>Control__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Edit Layout</label><layoutComponents><displayLines>1</displayLines><tabOrder>4</tabOrder><type>Field</type><value>fEditLayout__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>ReferenceTo Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>15</tabOrder><type>Field</type><value>ReferenceTo__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>5</tabOrder><type>Field</type><value>LastModifiedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>ReferenceTo</label><layoutComponents><displayLines>1</displayLines><tabOrder>16</tabOrder><type>Field</type><value>ReferenceToMetadata__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>6</tabOrder><type>Field</type><value>CreatedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Last Modified</label><layoutComponents><displayLines>1</displayLines><tabOrder>7</tabOrder><type>Field</type><value>LastModifiedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Created</label><layoutComponents><displayLines>1</displayLines><tabOrder>8</tabOrder><type>Field</type><value>CreatedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Namespace</label><layoutComponents><displayLines>1</displayLines><tabOrder>9</tabOrder><type>Field</type><value>Namespace__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Business Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>10</tabOrder><type>Field</type><value>BusinessOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>TechnicalOwner</label><layoutComponents><displayLines>1</displayLines><tabOrder>11</tabOrder><type>Field</type><value>TechnicalOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>11</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>false</useHeading></detailLayoutSections><detailLayoutSections><columns>1</columns><heading>New Section</heading><layoutRows><layoutItems><editable>false</editable><label>FullName</label><layoutComponents><displayLines>1</displayLines><tabOrder>32</tabOrder><type>Field</type><value>FullName__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>ForceId</label><layoutComponents><displayLines>1</displayLines><tabOrder>33</tabOrder><type>Field</type><value>ForceId__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Description</label><layoutComponents><displayLines>5</displayLines><tabOrder>34</tabOrder><type>Field</type><value>Description__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Administrator Notes (rtf)</label><layoutComponents><displayLines>1</displayLines><tabOrder>35</tabOrder><type>Field</type><value>rtfAdminNotes__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><rows>4</rows><useCollapsibleSection>true</useCollapsibleSection><useHeading>true</useHeading></detailLayoutSections><detailLayoutSections><columns>2</columns><heading>System Information</heading><layoutRows><layoutItems><editable>false</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>40</tabOrder><type>Field</type><value>CreatedById</value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>41</tabOrder><type>Separator</type><value>, </value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>42</tabOrder><type>Field</type><value>CreatedDate</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>44</tabOrder><type>Field</type><value>LastModifiedById</value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>45</tabOrder><type>Separator</type><value>, </value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>46</tabOrder><type>Field</type><value>LastModifiedDate</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Record Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>43</tabOrder><type>Field</type><value>RecordTypeId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>47</tabOrder><type>Field</type><value>OwnerId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>2</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>false</useHeading></detailLayoutSections><editLayoutSections><columns>2</columns><heading>Information</heading><layoutRows><layoutItems><editable>true</editable><label>API Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>17</tabOrder><type>Field</type><value>Name</value></layoutComponents><placeholder>false</placeholder><required>true</required></layoutItems><layoutItems><editable>true</editable><label>Parent</label><layoutComponents><displayLines>1</displayLines><tabOrder>27</tabOrder><type>Field</type><value>Parent__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Label</label><layoutComponents><displayLines>1</displayLines><tabOrder>18</tabOrder><type>Field</type><value>Label__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>Is Custom</label><layoutComponents><displayLines>1</displayLines><tabOrder>28</tabOrder><type>Field</type><value>IsCustom__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>19</tabOrder><type>Field</type><value>Type__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>Control</label><layoutComponents><displayLines>1</displayLines><tabOrder>29</tabOrder><type>Field</type><value>Control__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>20</tabOrder><type>Field</type><value>LastModifiedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>ReferenceTo Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>30</tabOrder><type>Field</type><value>ReferenceTo__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>21</tabOrder><type>Field</type><value>CreatedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>ReferenceTo</label><layoutComponents><displayLines>1</displayLines><tabOrder>31</tabOrder><type>Field</type><value>ReferenceToMetadata__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Last Modified</label><layoutComponents><displayLines>1</displayLines><tabOrder>22</tabOrder><type>Field</type><value>LastModifiedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Created</label><layoutComponents><displayLines>1</displayLines><tabOrder>23</tabOrder><type>Field</type><value>CreatedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Namespace</label><layoutComponents><displayLines>1</displayLines><tabOrder>24</tabOrder><type>Field</type><value>Namespace__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Business Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>25</tabOrder><type>Field</type><value>BusinessOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>TechnicalOwner</label><layoutComponents><displayLines>1</displayLines><tabOrder>26</tabOrder><type>Field</type><value>TechnicalOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>10</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><editLayoutSections><columns>1</columns><heading>New Section</heading><layoutRows><layoutItems><editable>true</editable><label>FullName</label><layoutComponents><displayLines>1</displayLines><tabOrder>36</tabOrder><type>Field</type><value>FullName__c</value></layoutComponents><placeholder>false</placeholder><required>true</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>ForceId</label><layoutComponents><displayLines>1</displayLines><tabOrder>37</tabOrder><type>Field</type><value>ForceId__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Description</label><layoutComponents><displayLines>5</displayLines><tabOrder>38</tabOrder><type>Field</type><value>Description__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Administrator Notes (rtf)</label><layoutComponents><displayLines>1</displayLines><tabOrder>39</tabOrder><type>Field</type><value>rtfAdminNotes__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><rows>4</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><editLayoutSections><columns>2</columns><heading>System Information</heading><layoutRows><layoutItems><editable>false</editable><label>Record Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>48</tabOrder><type>Field</type><value>RecordTypeId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>49</tabOrder><type>Field</type><value>OwnerId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>1</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><id>00hS0000000XX6mIAG</id><relatedLists><columns><field>MetadataItem__c.Name</field><format xsi:nil="true"/><label>MDR</label><name>Name</name></columns><columns><field>Metadata__c.Name</field><format xsi:nil="true"/><label>Related Metadata</label><name>RelatedMetadata__r.Name</name></columns><columns><field>MetadataItem__c.Type__c</field><format xsi:nil="true"/><label>Type</label><name>Type__c</name></columns><custom>true</custom><field>Metadata__c</field><label>MetadataRelations</label><limitRows>5</limitRows><name>MetadataRelations__r</name><sobject>MetadataItem__c</sobject></relatedLists><relatedLists><columns><field>MetadataItem__c.Name</field><format xsi:nil="true"/><label>MDR</label><name>Name</name></columns><columns><field>Metadata__c.Name</field><format xsi:nil="true"/><label>Metadata</label><name>Metadata__r.Name</name></columns><columns><field>MetadataItem__c.Type__c</field><format xsi:nil="true"/><label>Type</label><name>Type__c</name></columns><custom>true</custom><field>RelatedMetadata__c</field><label>MetadataRelations (children)</label><limitRows>5</limitRows><name>RelatedMetadata__r</name><sobject>MetadataItem__c</sobject></relatedLists></layouts><recordTypeMappings><available>true</available><defaultRecordTypeMapping>true</defaultRecordTypeMapping><layoutId>'+System.Label.Metadata_Picklist_LayoutId+'</layoutId><name>Master</name><picklistsForRecordType><picklistName>CRIM_Support__c</picklistName><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Categorized</label><value>Categorized</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Inherited</label><value>Inherited</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>System</label><value>System</value></picklistValues></picklistsForRecordType><picklistsForRecordType><picklistName>Control__c</picklistName><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Corporate</label><value>Corporate</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Business Select</label><value>Business Select</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Business Free</label><value>Business Free</value></picklistValues></picklistsForRecordType><recordTypeId>012000000000000AAA</recordTypeId></recordTypeMappings><recordTypeSelectorRequired>true</recordTypeSelectorRequired></result></describeLayoutResponse></soapenv:Body></soapenv:Envelope>';
  public static final string TESTRESPONSE_LoginResponse  = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://na1-api.salesforce.com/services/Soap/m/21.0/00D3000000066BQ</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>false</sandbox><serverUrl>https://na1-api.salesforce.com/services/Soap/u/21.0/00D3000000066BQ</serverUrl><sessionId>00D3000000066BQ!ARgAQElcWGyej7wiCGRHPnEedV0jI8InxIdQNqWrLOQltUuC4Ary4LZvRVz0jpYLKntCryO8mfSihaZU6gtFRtIxiXrGCSyt</sessionId><userId>00530000000znVUAAY</userId><userInfo><accessibilityMode>false</accessibilityMode><currencySymbol xsi:nil="true"/><orgAttachmentFileSizeLimit>26214400</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode xsi:nil="true"/><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D3000000066BQEAY</organizationId><organizationMultiCurrency>true</organizationMultiCurrency><organizationName>All DuPont</organizationName><profileId>00e30000000m7ZSAAY</profileId><roleId>00E30000000nOolEAE</roleId><sessionSecondsValid>7200</sessionSecondsValid><userDefaultCurrencyIsoCode>USD</userDefaultCurrencyIsoCode><userEmail>thomas.snyder@usa.dupont.com</userEmail><userFullName>Tom Snyder</userFullName><userId>00530000000znVUAAY</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>tom.snyder@usa.dupont.com</userName><userTimeZone>America/New_York</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>';  
  public static final string TESTRESPONSE_queryAggregate  = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sf="urn:sobject.partner.soap.sforce.com" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soapenv:Body><queryResponse><result xsi:type="QueryResult"><done>true</done><queryLocator xsi:nil="true"/><records xsi:type="sf:sObject"><sf:type>AggregateResult</sf:type><sf:Id xsi:nil="true"/><sf:Type xsi:nil="true"/><sf:cnt xsi:type="xsd:int">24430</sf:cnt></records><records xsi:type="sf:sObject"><sf:type>AggregateResult</sf:type><sf:Id xsi:nil="true"/><sf:Type>Account</sf:Type><sf:cnt xsi:type="xsd:int">1363</sf:cnt></records><records xsi:type="sf:sObject"><sf:type>AggregateResult</sf:type><sf:Id xsi:nil="true"/><sf:Type>Agent</sf:Type><sf:cnt xsi:type="xsd:int">203</sf:cnt></records><size>3</size></result></queryResponse></soapenv:Body></soapenv:Envelope>';
  
  public enum APIType {Partner, Metadata}
  
  static {
    
    SESSION  = UserInfo.getSessionId();
    POD=Util.POD;
  }
  
  /////////////////////////////////////////////////////////////////////////////  
  public static HttpResponse postListMetadata(string folder, string objectType) { return postListMetadata(folder,objectType,new SOAPEnvelope()); }
  public static HttpResponse postListMetadata(string folder, string objectType, SOAPEnvelope env) {
    string str='<SOAP-ENV:Body>';
    str+='<m:listMetadata xmlns:m="http://soap.sforce.com/2006/04/metadata"><m:queries><m:folder>'+folder+'</m:folder><m:type>'+objectType+'</m:type></m:queries><m:asOfVersion>'+VERSION+'</m:asOfVersion></m:listMetadata>';
    str+='</SOAP-ENV:Body>';
    return metaSend(str,env);
  }
  
  ////////////////////////////////////////////////////////////////////////////
  // returns:  MAP<ForceId,FullName>
  public static MAP<string,String> listMetadataCompact(string folder, string objectType) {
      return listMetadataCompact(folder,objectType,''); 
  }
  public static MAP<string,String> listMetadataCompact(string folder, string objectType, string fullNameFilter) {
    HttpResponse resp = API.postListMetadata(folder, objectType);
      MAP<string,String> rtn=new MAP<string,String>();
      dom.Document resDOM=getDOM(resp,TESTRESPONSE_listMetadata);
    dom.Xmlnode eLMR = resDOM.getRootElement().getChildElement('Body', NS_SOAP).getChildElement('listMetadataResponse',NS_META);
    for (dom.Xmlnode result : eLMR.getChildElements()) {
      string fullName=result.getChildElement('fullName',NS_META).getText();
      string id=result.getChildElement('id',NS_META).getText();
      if ((!Util.isBlank(id)) && (Util.isBlank(fullNameFilter) || fullName.startsWith(fullNameFilter)) )
        rtn.put(id,fullName);  
    }
    return rtn;
  }
  
  private static dom.Document getDOM(HttpResponse resp) { return getDOM(resp, TESTRESPONSE ); }
  private static dom.Document getDOM(HttpResponse resp, string testResp) {
    if (System.Test.isRunningTest()) {
      if (testResp==null) testResp=TESTRESPONSE;
      dom.Document doc = new dom.Document();
      doc.load(testResp);
      return doc;
    }
    else
      return resp.getBodyDocument();
  }
  
  /*
  public static MAP<string,MAP<String,String>> listMetadataToMap(string folder, string objectType) {
    HttpResponse resp = API.postListMetadata(folder, objectType);
  
      MAP<string,MAP<String,String>> rtn=new MAP<string,MAP<String,String>>();
      dom.Document resDOM = resp.getBodyDocument();
    dom.Xmlnode eLMR = resDOM.getRootElement().getChildElement('Body', NS_SOAP).getChildElement('listMetadataResponse',NS_META);
    for (dom.Xmlnode result : eLMR.getChildElements()) {
        rtn.put(id,new MAP<String,String>());
        for ( dom.Xmlnode e : result.getChildElements())
          rtn.get(id).put(e.getName(),e.getText());
    }
    return rtn;
  }
*/


  //Added a fullNamefilter to help with to Heap and script statement issues when dealing with a large result set (ex: CustomField)
  public static LIST<FileProperties> listMetadata(string folder, string objectType) { return listMetadata(new SOAPEnvelope(),folder,objectType,null); }
  public static LIST<FileProperties> listMetadata(string folder, string objectType, string fullNameFilter) { return listMetadata(new SOAPEnvelope(),folder,objectType,fullNameFilter); }
  public static LIST<FileProperties> listMetadata(SOAPEnvelope env, string folder, string objectType, string fullNameFilter) {
    LIST<FileProperties> rtn = new LIST<FileProperties>();  
    for (dom.Xmlnode result : getDOM(API.postListMetadata(folder, objectType,env), TESTRESPONSE_listMetadata).getRootElement().getChildElement('Body', NS_SOAP).getChildElement('listMetadataResponse',NS_META).getChildElements() ) {
      string fullName=result.getChildElement('fullName',NS_META).getText();
      if ( Util.isBlank(fullNameFilter) || fullName.startsWith(fullNameFilter) )
        rtn.add(new FileProperties(result,true));
    }
    return rtn;
  }


  //Added a fullNamefilter to help with to Heap and script statement issues when dealing with a large result set (ex: CustomField)
  //MAP<FullName,FileProperties>
  public static MAP<string,FileProperties> listMetadataMap(string folder, string objectType) { return listMetadataMap(new SOAPEnvelope(),folder,objectType,null); }
  public static MAP<string,FileProperties> listMetadataMap(string folder, string objectType, string fullNameFilter) { return listMetadataMap(new SOAPEnvelope(),folder,objectType,fullNameFilter); }
  public static MAP<string,FileProperties> listMetadataMap(SOAPEnvelope env, string folder, string objectType, string fullNameFilter) {
    MAP<string,FileProperties> rtn = new MAP<string,FileProperties>();  
    for (dom.Xmlnode result : getDOM(API.postListMetadata(folder, objectType, env), TESTRESPONSE_listMetadata).getRootElement().getChildElement('Body', NS_SOAP).getChildElement('listMetadataResponse',NS_META).getChildElements() ) {
      string fullName=result.getChildElement('fullName',NS_META).getText();
      if ( Util.isBlank(fullNameFilter) || fullName.startsWith(fullNameFilter) )
        rtn.put(fullName,new FileProperties(result,true));
    }
    return rtn;
  }

  //MAP<ForceId,FileProperties>  some objectTypes do not contain an Id therfor the map will be incompelete.  use listMetadataMap() for these
  public static MAP<Id,FileProperties> listMetadataMapById(string folder, string objectType) {return listMetadataMapById(new SOAPEnvelope(),folder,objectType); }
  public static MAP<Id,FileProperties> listMetadataMapById(SOAPEnvelope env, string folder, string objectType) {
    MAP<Id,FileProperties> rtn = new MAP<Id,FileProperties>();  
    for (dom.Xmlnode result : getDOM(API.postListMetadata(folder, objectType, env), TESTRESPONSE_listMetadata).getRootElement().getChildElement('Body', NS_SOAP).getChildElement('listMetadataResponse',NS_META).getChildElements() ) {
      string idn=result.getChildElement('id',NS_META).getText();
      if (!Util.isBlank(idn))
        rtn.put(idn,new FileProperties(result,true));
    }
    return rtn;
  }
  
  
  
  /*
    <SOAP-ENV:Body>
    <m:query xmlns:m="urn:partner.soap.sforce.com">
      <m:queryString>String</m:queryString>
    </m:query>
  </SOAP-ENV:Body>
  */
  public static dom.Document query(string soql) { return query(new SOAPEnvelope(),soql); }
  public static dom.Document query(SOAPEnvelope env,string soql) { 
    string str='<SOAP-ENV:Body><m:query xmlns:m="urn:partner.soap.sforce.com"><m:queryString>'+soql+'</m:queryString></m:query></SOAP-ENV:Body>';
    return getDom(partnerSend(str),TESTRESPONSE_queryAggregate);  
  }
  /*  
  ////////////////////////////////////////////////////////////////////////////
  //  This callout produces a large payload (4.5MB) well over the allotted
  //  Heapspace Limit,  however I have found that if the heap is kept in the dom
  // you can cercomvent
  // Note:  passing the dom.xmlNode as an argument will cause a heap exception 
  // however by passing as a list as in dom.xmlNode.getChildElements() will work
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  public static LIST<FileProperties> listMetadata(string folder, string objectType) {return listMetadata(folder,objectType,false);}
  public static LIST<FileProperties> listMetadata(string folder, string objectType, boolean includeAuditInfo) {
    LIST<FileProperties> rtn = new LIST<FileProperties>();
    XmlStreamReader reader = API.postListMetadata(folder, objectType).getXmlStreamReader();
    reader.setNamespaceAware(false);
     do {
       if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'fileProperties')
        //rtn.add(new FileProperties(reader));
      reader.next();
     } while(reader.next()!=null);
    system.debug('HEAP:'+Limits.getHeapSize());
    return rtn;
  }
  */

  ////////////////////////////////////////////////////////////////////////////
  public static dom.Document describeLayout(string SObjectType) { return describeLayout(SObjectType, new SET<Id>()); }
  public static dom.Document describeLayout(string SObjectType, SET<Id> rtypeIds) {  
    string Rtype='';
    try{
      for (Id id : rtypeIds)
        Rtype += '<m:recordTypeIds>'+string.valueOf(id).substring(0,15)+'</m:recordTypeIds>';
    } catch (exception ex) {}
    string str='<SOAP-ENV:Body><m:describeLayout xmlns:m="urn:partner.soap.sforce.com"><m:sObjectType>'+SObjectType+'</m:sObjectType>'+Rtype+'</m:describeLayout></SOAP-ENV:Body>';
    return getDom(partnerSend(str),TESTRESPONSE_describeLayout);  
  }
  
////////////////////////////////////////////////////////////////////////////////////////////////////
// inner Classes
////////////////////////////////////////////////////////////////////////////////////////////////////

  public class LoginResponse {
    
    public string metadataServerUrl    {get; set;}
    public string passwordExpired    {get; set;}
    public string sandbox        {get; set;}
    public string serverUrl        {get; set;} //https://cs12-api.salesforce.com/services/Soap/u/21.0/00DV000000096Zc
    public string sessionId       {get; set;}
    public string userId         {get; set;}
    public UserInfo_inner  userinfo      {get; set;} //< SA20170115>renamed userinfo method to userinfo_inner
    
    public LoginResponse(dom.xmlNode result) {
      metadataServerUrl    =result.getChildElement('metadataServerUrl',NS_PARTNER).getText();
      passwordExpired      =result.getChildElement('passwordExpired',NS_PARTNER).getText();
      sandbox          =result.getChildElement('sandbox',NS_PARTNER).getText();
      serverUrl        =result.getChildElement('serverUrl',NS_PARTNER).getText();
      sessionId        =result.getChildElement('sessionId',NS_PARTNER).getText();
      userId          =result.getChildElement('userId',NS_PARTNER).getText();
      userinfo        = new UserInfo_inner(result.getChildElement('userInfo',NS_PARTNER));
    }
    
    public string serverPod {
      GET {
        string rtn='';
        string regex = 'https://([A-Za-z0-9]+)-';
        Pattern emailPattern = Pattern.compile(regex);
        Matcher emailMatcher = emailPattern.matcher(this.serverUrl);
        if (emailMatcher.find()) {
          if (emailMatcher.groupCount()==1)
            rtn=emailMatcher.group(1);
        }
        return rtn;
      }
    }
  }
  
/////////////////////////////////////////////////////////////////////////////////////////////////
//<SA20170115>renamed userinfo method to userinfo_inner
  public class UserInfo_inner {
    public string accessibilityMode        {get; set;}
    public string currencySymbol        {get; set;}
    public long orgAttachmentFileSizeLimit    {get; set;}
    public string orgDefaultCurrencyIsoCode    {get; set;}
    public boolean orgDisallowHtmlAttachments  {get; set;}
    public boolean orgHasPersonAccounts      {get; set;}
    public string organizationId        {get; set;}
    public string organizationMultiCurrency    {get; set;}
    public string organizationName         {get; set;}
    public string profileId           {get; set;}
    public string roleId             {get; set;}
    public integer sessionSecondsValid      {get; set;}
    public string userDefaultCurrencyIsoCode  {get; set;}
    public string userEmail            {get; set;}
    public string userFullName          {get; set;}
    public string userId            {get; set;}
    public string userLanguage          {get; set;}
    public string userLocale          {get; set;}
    public string userName            {get; set;}
    public string userTimeZone          {get; set;}
    public string userType            {get; set;}
    public string userUiSkin          {get; set;}
    
/////////////////////////////////////////////////////////////////////////////////////////////////    
    //<SA20170115> renamed userinfo method to userinfo_inner
    public UserInfo_inner(dom.xmlNode result) {
      //TODO:Complete
      system.debug(result);
      organizationId        =result.getChildElement('organizationId',NS_PARTNER).getText();
      organizationName      =result.getChildElement('organizationName',NS_PARTNER).getText();
      userId            =result.getChildElement('userId',NS_PARTNER).getText();
      userFullName        =result.getChildElement('userFullName',NS_PARTNER).getText();
      userName          =result.getChildElement('userName',NS_PARTNER).getText();
      userEmail          =result.getChildElement('userEmail',NS_PARTNER).getText();
      userTimeZone        =result.getChildElement('userTimeZone',NS_PARTNER).getText();
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////

  public class FileProperties {
    //private dom.xmlNode result;
    
    public string id               {get; set;}
    public string fileName            {get; set;}
    public string fullName            {get; set;}
    public string manageableState        {get; set;}
    public string namespacePrefix        {get; set;}
    public Id createdById            {get; set;}
    public datetime createdDate          {get; set;}
    public Id lastModifiedById          {get; set;}
    public datetime lastModifiedDate      {get; set;}
    public string resultType          {get; set;}
    
    public FileProperties(XmlStreamReader r) {
      while (r.hasnext()) {
        if ( r.getEventType()== XmlTag.END_ELEMENT && r.getLocalName() == 'fileProperties')
          break;
        else if ( r.getEventType()== XmlTag.START_ELEMENT ) {
          string ln=r.getLocalName();
          if (ln == 'id' )               id = r.getText();
          else if (ln == 'fileName' )         fullname = r.getText();
          else if (ln == 'lastModifiedById' )     lastModifiedById = r.getText();
          }
      r.next();
      }
    }
    
    public FileProperties(Id aId, string aFullName) {
      id=aId;
      fullName=aFullName;
      }
    
    //public Id id {GET{return result.getChildElement('id',NS_META).getText(); }}
    
    public FileProperties(object oresult) {this((dom.xmlNode) oresult); }
    public FileProperties(dom.xmlNode result) {this(result, false); }
    public FileProperties(dom.xmlNode result, boolean includeAuditInfo) {
      dom.xmlNode idn = result.getChildElement('id',NS_META);
      if (idn!=null) id=idn.getText();
      
      fullName=result.getChildElement('fullName',NS_META).getText();
      resultType=result.getChildElement('type',NS_META).getText();
      fileName=result.getChildElement('fileName',NS_META).getText();
      
      dom.xmlNode ms = result.getChildElement('manageableState',NS_META);
      if (ms!=null) manageableState=ms.getText();
      dom.xmlNode ns = result.getChildElement('namespacePrefix',NS_META);
      if (ns!=null) namespacePrefix=ns.getText();

      if (includeAuditInfo) { //save some scriptstatements
        dom.xmlNode creatbyId = result.getChildElement('createdById',NS_META);
        dom.xmlNode creatDate = result.getChildElement('createdDate',NS_META);
        dom.xmlNode lmodbyId = result.getChildElement('lastModifiedById',NS_META);
        dom.xmlNode lmodDate = result.getChildElement('lastModifiedDate',NS_META);
        createdById = (creatbyId!=null) ? creatbyId.getText() : null;
        createdDate = (creatDate!=null) ? Util.XmltoDateTime(creatDate.getText()) : null;
        lastModifiedById = (lmodbyId!=null) ? lmodbyId.getText() : null;
        lastModifiedDate = (lmodDate!=null) ? Util.XmltoDateTime(lmodDate.getText()) : null;
      }
    }
    
    public FileProperties(Dom.XmlNode[] nodes) {
      for (Dom.XmlNode n : nodes) {
        if (n.getName()=='id')            id=n.getText();
        else if (n.getName()=='fullName')        fullName=n.getText();
        else if (n.getName()=='namespacePrefix')    namespacePrefix=n.getText();
        else if (n.getName()=='lastModifiedDate')    lastModifiedDate=Util.XmltoDateTime(n.getText());
        else if (n.getName()=='lastModifiedById')    lastModifiedById=n.getText();
      }
    }
  }
    
////////////////////////////////////////////////////////////////////////////////////////////////////
// SOAP Send methods  (Partner and Metadata API)
////////////////////////////////////////////////////////////////////////////////////////////////////
  public static HttpResponse partnerSend(string soapBody) { return partnerSend(soapBody,new SOAPEnvelope()); }
  public static HttpResponse partnerSend(string soapBody, SOAPEnvelope env) {
    HttpRequest req=env.createRequest(soapBody, false);
    Http http=new Http();
    if (! System.Test.isRunningTest()) {
      HttpResponse res=http.send(req);
      system.debug(res.getBody());
      return res;
    }
      else
        return new HttpResponse();
  }
////////////////////////////////////////////////////////////////////////////////////////////////////
  public static HttpResponse metaSend(string soapBody) { return metaSend(soapBody,new SOAPEnvelope()); }
  public static HttpResponse metaSend(string soapBody, SOAPEnvelope env) {
    HttpRequest req=env.createRequest(soapBody, true);
    Http http=new Http();
    if (! System.Test.isRunningTest()) {
      HttpResponse res=http.send(req);
      system.debug(res.getBody());
      return res;
    }
      else
        return new HttpResponse();
  }  
  
/*  
Replaced w/ SOAPEnvelope
////////////////////////////////////////////////////////////////////////////////////////////////////
  private static HttpRequest createSOAPRequest_Partner(string soapBody) {
    string str='<?xml version="1.0" encoding="utf-8"?>';
    str+='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:m0="urn:sobject.partner.soap.sforce.com">';
    str+='<SOAP-ENV:Header><m:SessionHeader xmlns:m="urn:partner.soap.sforce.com"><m:sessionId>'+SESSION+'</m:sessionId></m:SessionHeader>';    
    str+='<m:QueryOptions xmlns:m="urn:partner.soap.sforce.com"><m:batchSize>200</m:batchSize></m:QueryOptions>';
    str+='</SOAP-ENV:Header>';
    str+=soapBody;
    str+='</SOAP-ENV:Envelope>';
    string Partner_Server_URL = 'https://'+POD+'-api.salesforce.com/services/Soap/u/'+VERSION+'/'+UserInfo.getOrganizationId().substring(0, 15);
    HttpRequest req=new HttpRequest();
    req.setEndPoint(Partner_Server_URL);
    req.setTimeout(60000);
    req.setHeader('Content-Type','text/xml');
    req.setHeader('SOAPAction','<se:Header xmlns:sfns=\'partner.soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>');
    req.setBody(str);
    req.setMethod('POST');  
    return req;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////
  private static HttpRequest createSOAPRequest_Meta(string soapBody) {
    string str='<?xml version="1.0" encoding="utf-8"?>';
    str+='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';    
    str+='<SOAP-ENV:Header><m:SessionHeader xmlns:m="http://soap.sforce.com/2006/04/metadata"><m:sessionId>'+SESSION+'</m:sessionId></m:SessionHeader>'; 
    str+='<m:CallOptions xmlns:m="http://soap.sforce.com/2006/04/metadata"><m:client>3ddd_APEX</m:client></m:CallOptions>';
    if (soapBody.contains('<m:queryString>'))
      str+='<m:QueryOptions xmlns:m="urn:partner.soap.sforce.com"><m:batchSize>200</m:batchSize></m:QueryOptions>'
    str+='</SOAP-ENV:Header>';
    str+=soapBody;
    str+='</SOAP-ENV:Envelope>';
       string Metadata_Server_URL = 'https://'+POD+'-api.salesforce.com/services/Soap/m/'+VERSION+'/'+UserInfo.getOrganizationId().substring(0, 15);  
    HttpRequest req=new HttpRequest();
    req.setEndPoint(Metadata_Server_URL);
    req.setTimeout(60000);
    req.setHeader('Content-Type','text/xml');
    req.setHeader('SOAPAction','<se:Header xmlns:sfns=\'soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>');
    req.setBody(str);
    req.setMethod('POST');
    return req;
  }

*/


  

  public class SOAPEnvelope {
    public string sessionId      {get; set;}
    public boolean isSandbox    {get; set;}
    public string metaUrl       {get; set;}
    public string partnerUrl    {get; set;}
    public integer batchsize    {get; set;}
    
    
    //SESSION,  ISSANDBOX
    public SOAPEnvelope() {
      string orgId=UserInfo.getOrganizationId().substring(0, 15);
      batchsize=2000;
      isSandbox=(!Util.isProduction);
      sessionId = (API.SESSION!=null) ? API.SESSION : UserInfo.getSessionId();
      metaUrl='https://'+Util.POD+'-api.salesforce.com/services/Soap/m/'+VERSION+'/'+orgId;
      partnerUrl='https://'+Util.POD+'-api.salesforce.com/services/Soap/u/'+VERSION+'/'+orgId;
    }
    //LoginResponse:[metadataServerUrl=https://cs3-api.salesforce.com/services/Soap/m/23.0/00DQ0000000ECt5, passwordExpired=false, sandbox=true, serverPod=null, serverUrl=https://cs3-api.salesforce.com/services/Soap/u/23.0/00DQ0000000ECt5, sessionId=00DQ0000000ECt5!AQgAQCtZc7B3ESSkxlhPtF1LOcLILbR0wQtT7pT_7hSkIp9Z11jw9mMdfXH9nfAR_zuUYDTZeA520pXZON8acod30WfWCu2., userId=00530000000znVUAAY, userinfo=UserInfo:[accessibilityMode=null, currencySymbol=null, orgAttachmentFileSizeLimit=null, orgDefaultCurrencyIsoCode=null, orgDisallowHtmlAttachments=null, orgHasPersonAccounts=null, organizationId=00DQ0000000ECt5MAG, organizationMultiCurrency=null, organizationName=All DuPont, profileId=null, roleId=null, sessionSecondsValid=null, userDefaultCurrencyIsoCode=null, userEmail=thomas.snyder@usa.dupont.com, userFullName=Tom Snyder, userId=00530000000znVUAAY, userLanguage=null, userLocale=null, userName=tom.snyder@usa.dupont.com.qa, userTimeZone=America/New_York, userType=null, userUiSkin=null]]
    public SOAPEnvelope(LoginResponse lr) {
      metaUrl=lr.metadataServerUrl;
      partnerUrl=lr.serverUrl;
      isSandbox=Util.stringToBoolean(lr.sandbox);
      sessionId=lr.sessionId;
    }

    public HttpRequest createRequest(string soapBody, boolean isMeta) {
      HttpRequest req=new HttpRequest();
      req.setTimeout(Integer.valueOf(system.label.Session_Time_Out)); //<SA20170115> included custom label to 
      req.setHeader('Content-Type','text/xml');
      req.setMethod('POST');  
            
      string payload='<?xml version="1.0" encoding="utf-8"?>';
      payload+='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"';
      
      if (isMeta) {
        req.setEndPoint(this.metaUrl);
        req.setHeader('SOAPAction','<se:Header xmlns:sfns=\'soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>');
        payload+='><SOAP-ENV:Header><m:SessionHeader xmlns:m="http://soap.sforce.com/2006/04/metadata"><m:sessionId>'+this.sessionId+'</m:sessionId></m:SessionHeader>'; 
        payload+='<m:CallOptions xmlns:m="http://soap.sforce.com/2006/04/metadata"><m:client>3ddd_APEX</m:client></m:CallOptions>';
      }
      else {
        req.setEndPoint(this.partnerUrl);
        req.setHeader('SOAPAction','<se:Header xmlns:sfns=\'partner.soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>');
        payload+=' xmlns:m0="urn:sobject.partner.soap.sforce.com"><SOAP-ENV:Header><m:SessionHeader xmlns:m="urn:partner.soap.sforce.com"><m:sessionId>'+this.sessionId+'</m:sessionId></m:SessionHeader>';    
        payload+='<m:QueryOptions xmlns:m="urn:partner.soap.sforce.com"><m:batchSize>'+String.valueOf(batchsize)+'</m:batchSize></m:QueryOptions>';
      }
      payload+='</SOAP-ENV:Header>';
      payload+=soapBody;
      payload+='</SOAP-ENV:Envelope>';
      system.debug('---SOAP REQUEST----->'+payload);
      req.setBody(payload);
      return req;
    }

  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //needs required list__c fields
  /*
  public static LoginResponse login(string conn, boolean isSandBox) {
    LoginResponse rtn;
    try {
      List__c cred = [Select Secret1__c, Secret2__c from List__c where UniqueName__c=:conn];
      rtn = login(cred.Secret1__c, cred.Secret2__c,isSandBox);
    }catch(Exception ex) {}
    return rtn;  
  }
  */
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  public static LoginResponse login(string un, string pw, boolean isSandBox) {
    string str='<?xml version="1.0" encoding="utf-8"?>';
    str+='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';    
    str+='<SOAP-ENV:Header/>';
    str+='<SOAP-ENV:Body><m:login xmlns:m="urn:partner.soap.sforce.com"><m:username>'+un+'</m:username><m:password>'+pw+'</m:password></m:login></SOAP-ENV:Body>';
    str+='</SOAP-ENV:Envelope>';
    HttpRequest req=new HttpRequest();
    if (isSandbox)
      req.setEndPoint('https://test.salesforce.com/services/Soap/u/'+VERSION);
    else
      req.setEndPoint('https://www.salesforce.com/services/Soap/u/'+VERSION);
     req.setTimeout(Integer.valueOf(system.label.Session_Time_Out)); //<SA20170115> included custom label to increase timeout
    req.setHeader('Content-Type','text/xml');
    //req.setHeader('SOAPAction','');
    req.setHeader('SOAPAction','<se:Header xmlns:sfns=\'partner.soap.sforce.com\'><sfns:CallOptions><sfns:client></sfns:client></sfns:CallOptions><sfns:SessionHeader><sessionId></sessionId></sfns:SessionHeader></se:Header>');
    req.setBody(str);
    req.setMethod('POST');  
    
    Http http=new Http();
    HttpResponse res;
    if (! System.Test.isRunningTest()) {
      res=http.send(req);
      system.debug(res.getBody());
    }
      else
        res=new HttpResponse();    
      
    dom.Xmlnode root = getDOM(res, TESTRESPONSE_LoginResponse).getRootElement();
    dom.Xmlnode lrnode = root.getChildElement('Body', NS_SOAP).getChildElement('loginResponse',NS_PARTNER);
    dom.Xmlnode result = lrnode.getChildElement('result',NS_PARTNER);
    system.debug(result);
    LoginResponse lr = new LoginResponse(result);

    return lr;
  }




  /*
  Obtain an Access Token from a Refresh Token
  
      POST /services/oauth2/token HTTP/1.1
      Host: https://login.salesforce.com/ 
      grant_type=refresh_token
      &client_id=consumerKey goes here
      &client_secret=consumerSecret goes here  (optional)
      &refresh_token=your token here 
  */
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //needs required list__c fields
  /*
  public static OAUTHResponse OAUTH_login(string conn, boolean isSandBox) {
    OAUTHResponse rtn;
    try {
      List__c cred = [Select Secret1__c, Secret2__c from List__c where UniqueName__c=:conn];
      rtn = OATH_refreshToken(cred.Secret1__c, cred.Secret2__c,isSandBox);
    }catch(Exception ex) {}
    return rtn;  
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  public static OAUTHResponse OATH_refreshToken(string consumerKey, string refreshToken, boolean isSandbox) {
    string domain = 'https://login.salesforce.com';
    if (isSandbox) {
      domain = 'https://test.salesforce.com';     
    }
    return OATH_refreshToken(consumerKey,refreshToken,domain+'/services/oauth2/token');
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  public static OAUTHResponse OATH_refreshToken(string consumerKey, string refreshToken, string endpoint) {
    OAUTHResponse rtn;
    string payload  ='grant_type=refresh_token&client_id='+consumerKey+'&refresh_token='+refreshToken+'&format=xml';
    system.debug(payload);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setBody(payload);
    req.setHeader('Accept','application/xml');
    req.setMethod('POST');
    Http http=new Http();
    HttpResponse res=http.send(req);
    if (res.getStatusCode()==200)
      rtn = new OAUTHResponse(res);
    system.debug(res);
    system.debug(rtn);
    return rtn;
}

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  public virtual class OAUTHResponse {
    public string id          {get; set;} //<id>https://login.salesforce.com/id/00DU0000000HjSXMA0/005U0000000Vb7YIAS</id>
    public string issued_at      {get; set;} //<issued_at>1326889504460</issued_at>
    public string instance_url     {get; set;}  //<instance_url>https://na12.salesforce.com</instance_url>
    public string signature      {get; set;}  //<signature>40fsHtYgSVdE+YrY+MUaZksi7PVR6BOPYoNDsfKh9TA=</signature>
    public string access_token    {get; set;}  //<access_token>00DU0000000HjSX!AQYAQPP5TSmsOOhI0DUoE7WeEB_HBhZHWOFTc3ZJudfLxYSZPEwu5qx2elxbpT0hJ0ND9XcLYCEbolgE6Tk23q_m3ylGqXc6</access_token>
  
    public OAUTHResponse(HttpResponse resp) {
      this(resp.getBodyDocument().getRootElement());
    }
    public OAUTHResponse(dom.xmlNode oauth) {
        system.debug(oauth);
        id        =oauth.getChildElement('id',null).getText();
        issued_at    =oauth.getChildElement('issued_at',null).getText();
        instance_url  =oauth.getChildElement('instance_url',null).getText();
        signature    =oauth.getChildElement('signature',null).getText();
        access_token  =oauth.getChildElement('access_token',null).getText();
    }
  }//OAUTHResponse
  */


}
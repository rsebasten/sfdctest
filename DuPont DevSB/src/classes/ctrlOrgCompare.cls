/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for page: OrgCompare
********************************************************************************/
public with sharing class ctrlOrgCompare {

	public string un 						{get; set;}
	public string pw 						{get; set;}
	public boolean isSandBox 				{get; set;}
	public API.LoginResponse session		{get; set;}
	public boolean showExacts				{get; set;}
	
	public string mdfolder 					{get; set;}
	public string mdtype 					{get; set;}
	public string mdfilter 					{get; set;}
	
	public transient FilePropComparison compare	{get; set;}
	
	public ctrlOrgCompare() {
		try {
			un=ApexPages.currentPage().getCookies().get('un').getValue();
		}catch(Exception Ex){}
		mdfolder='';
		mdfilter='';
		mdtype='CustomObject';
		showExacts=true;
	}
	

	public Pagereference compare() {
			if (Util.IsBlank(mdtype)) { 
				mdtype='CustomObject';
				mdfolder='';
			}
			if ( parentType=='Workflow' )
				return compareWF();
			try { 
					compare = new FilePropComparison();
					compare.showExactMatches=showExacts;
					MAP<string,API.FileProperties> A=API.listMetadataMap(new API.SOAPEnvelope(), mdfolder, mdtype, mdfilter); 
					MAP<string,API.FileProperties> B=API.listMetadataMap(new API.SOAPEnvelope(session) ,mdfolder, mdtype, mdfilter);
					compare.compare(A,B);
			} catch(Exception Ex) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: '+string.valueOf(Ex)));
				compare.clear();
			}
			return null;
	}
	
		public Pagereference compareWF() {
		try { 
				compare = new FilePropComparison();
				compare.showExactMatches=showExacts;
				MAP<string,API.FileProperties> A = new MAP<string,API.FileProperties>();
				MAP<string,API.FileProperties> B = new MAP<string,API.FileProperties>();
				for (string typ :  WorkflowTypes.keyset()) {
					A.putAll(API.listMetadataMap(new API.SOAPEnvelope(), mdfolder, typ, mdfilter)); 
					B.putAll(API.listMetadataMap(new API.SOAPEnvelope(session) ,mdfolder, typ, mdfilter));
				}
				compare.compare(A,B);
		} catch(Exception Ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: '+string.valueOf(Ex)));
			compare.clear();
		}
		return null;
	}


	public Pagereference LogoutB() {
	session=null;
	return null;	
	}
	
	public Pagereference BackToCustomObject() {
		mdfolder='';
		mdtype='CustomObject';
		compare();
		return null;
	}

	public void Login() {
		try {
			//Store user's name
			ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('un', un,null,315569260,false)});
		
			session=API.login(un, pw, isSandBox);
		} catch(Exception ex){}	
		if (session==null) 
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: Login Failure.'));
			else
				compare();
		
	}
	
	
	public class FilePropCompareResult {
		public API.FileProperties a		{get; set;}
		public API.FileProperties b		{get; set;}
		
		public FilePropCompareResult() {}
		public FilePropCompareResult(API.FileProperties aa, API.FileProperties bb) {
			a=aa;
			b=bb;
		}
		
		public string getType() {
			if (a!=null)
				return a.resultType;
			else if (b!=null)
				return b.resultType;
			else
				return null;
		}
		
		public string getName() {
			if (a!=null)
				return a.fullName;
			else if (b!=null)
				return b.fullName;
			else
				return null;
		}
		
		public string getMatchType() {
			string stra = String.valueOf(a);
			string strb = String.valueOf(b);
			
			if (stra==strb)
				return 'exact'; //black
			else if (a!=null && b!= null) 
				return 'partial'; //blue
			else if (a!=null)				
				return 'missing'; //red
			else if (b!=null)				
				return 'new';  //grean
			else
				return null;	
			}
		
	}
	
	public string mdDescr {
		GET {
			return metadataTypes.get(mdtype);
		}
	}
	
	public LIST<SelectOption> getMetadataTypes(){
		LIST<string> lst = new LIST<string>(metadataTypes.keyset());
		lst.sort();
		return Util.createSelectOptions(lst);
	}
	
	public LIST<SelectOption> getSObjectChildTypes(){
		SET<string> stdObj = new SET<string>{'Account', 'Case', 'Campaign', 'Contact', 'Opportunity', 'Lead'};
		LIST<string> lst = new LIST<string>(sObjectChildTypes.keyset());
		if (mdfolder.endswith('__c')) {
			lst.add('CustomObjectCriteriaBasedSharingRule');
			lst.add('CustomObjectOwnerSharingRule');
		}
		else if (stdObj.contains(mdfolder)) {
			lst.add(mdfolder+'CriteriaBasedSharingRule');
			lst.add(mdfolder+'ContactOwnerSharingRule');
		}
		lst.sort();
		return Util.createSelectOptions(lst);
	}	
	
	public string rootMetadataType {
		get{ return mdtype;}
		set{ mdtype=value; }
	}
	
	
	public string parentType {
		get {
			if (!Util.isBlank(mdfolder)) {
				if (mdType=='Document') 						return 'DocumentFolder';
				if (mdType=='Dashboard') 						return 'DashboardFolder';
				if (mdType=='EmailTemplate') 					return 'EmailFolder';
				if (mdType=='Report') 							return 'ReportFolder';
				if (mdType=='Workflow') 						return 'Workflow';  //phsudo type
				if ( sObjectChildTypes.containsKey(mdType) 
					|| mdType.endswith('SharingRule'))			return 'CustomObject';
			}
			return null;
		}
	}
	
	public class FilePropComparison {
		public boolean showExactMatches			{get; set;}
		private MAP<string,FilePropCompareResult> results;
		
		//construct
		public FilePropComparison(){
			showExactMatches=true; 
			results = new MAP<string,FilePropCompareResult>(); 
		}


		public void compare(MAP<string,API.FileProperties> amap, MAP<string,API.FileProperties> bmap) {
			results = new MAP<string,FilePropCompareResult>();
			for (API.FileProperties a : amap.values()) {
				results.put(a.fullname, new FilePropCompareResult(a, bmap.containsKey(a.fullname) ? bmap.get(a.fullname) : null));
			}
			for (API.FileProperties b : bmap.values()) {
				if (!results.containsKey(b.fullname)) 
					results.put(b.fullname,new FilePropCompareResult(null,b));
			}			
		}
		
		public integer total {
			get { return results.size(); }
		}
		
		public integer totalDiffs {
			get { return getDiff().size(); }
		}
	
		public void clear() {
			results.clear();
		}
		public LIST<FilePropCompareResult> getResults() {
			if (showExactMatches)
				return results.values();
			else 
				return getDiff();
		}
		
		public LIST<LIST<FilePropCompareResult>> getBlocks() {
			if (showExactMatches)
				return createBlocks(results.values());
			else 
				return createBlocks(getDiff());
		}
		
		public LIST<FilePropCompareResult> getDiff() {
			LIST<FilePropCompareResult> rtn = new LIST<FilePropCompareResult>();
			for (FilePropCompareResult fpr : results.values())
				if (fpr.getMatchType()!='exact')
					rtn.add(fpr);
			return rtn;
		}
	}



public static LIST<LIST<FilePropCompareResult>> createBlocks(LIST<FilePropCompareResult> lst){
	LIST<LIST<FilePropCompareResult>> rtn = new LIST<LIST<FilePropCompareResult>>();
	LIST<FilePropCompareResult> block;
	
	integer blockcnt=0;
	integer recordcnt=0;
	rtn.Add(new LIST<FilePropCompareResult>()); 
	for (FilePropCompareResult fcr : lst ) {
		recordcnt++;
		rtn.get(rtn.size()-1).add(fcr);	
		if (recordcnt>=1000) {
			blockcnt++;
			rtn.Add(new LIST<FilePropCompareResult>()); 
		}
	}
	return rtn;	
}

public static MAP<string,string> metadataTypes = new MAP<string,string> {
	//'AccountCriteriaBasedSharingRule' => 'Account criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'AccountOwnerSharingRule' => 'Account ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	'AnalyticSnapshot'=>'Represents an analytic snapshot. An analytic snapshot lets you report on historical data. Authorized users can save tabular or summary report results to fields on a custom object, then map those fields to corresponding fields on a target object. They can then schedule when to run the report to load the custom object\'s fields with the report\'s data. Analytic snapshots enable you to work with report data similarly to how you work with other records in Salesforce.',
	'ApexClass'=>'Represents an Apex class. An Apex class is a template or blueprint from which Apex objects are created. Classes consist of other classes, user-defined methods, variables, exception types, and static initialization code.',
	'ApexComponent'=>'Represents a Visualforce component.',
	'ApexPage'=>'Represents a Visualforce page.',
	'ApexTrigger'=>'Represents an Apex trigger. A trigger is Apex code that executes before or after specific data manipulation language (DML) events occur, such as before object records are inserted into the database, or after records have been deleted.',
	//treated like custom object 'ArticleType'=>'Represents the metadata associated with an article type.',
	//'BaseSharingRule'=>'Represents the base container for criteria-based and owner-based sharing rules.',
	'BusinessProcess'=>'The BusinessProcess metadata type enables you to display different picklist values for users based on their profile.',
	//'CampaignCriteriaBasedSharingRule' => 'Campaign criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'CampaignOwnerSharingRule' => 'Campaign ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	//'CaseCriteriaBasedSharingRule' => 'Casecriteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'CaseOwnerSharingRule' => 'Case ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	//'ContactCriteriaBasedSharingRule' => 'Contact criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'ContactOwnerSharingRule' => 'Contact ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	'CustomApplication'=>'CustomApplication represents a custom application. An application is a list of tab references, with a description and a logo.',
	'CustomApplicationComponent'=>'Represents a custom console component (Visualforce page) assigned to a CustomApplication that is marked as a Service Cloud console. Custom console components extend the capabilities of Service Cloud console apps.',
	// too many 'CustomField'=>'Represents the metadata associated with a custom field. Use this metadata type to create, update, or delete custom field definitions.',
	//  not each label but the one file  'CustomLabels'=>'This metadata type allows you to create custom labels that can be localized for use in different languages, countries, and currencies.',
	'CustomObject'=>'Represents a custom object that stores data unique to your organization.',
	'CustomObjectTranslation'=>'This metadata type allows you to translate custom objects for a variety of languages.',
	'CustomPageWebLink'=>'Represents a web link defined in a home page component.',
	'CustomSite'=>'Represents a Force.com site. Force.comSites enables you to create public websites and applications that are directly integrated with yourSalesforce organization—without requiring users to log in with a username and password.',
	'CustomTab'=>'Represents a custom tab. A custom tab is a user interface component you create to display custom object data or other web content embedded in the application. When a tab displays a custom object, the tab name is the same as the custom object name; for page, s-control, or URL tabs, the name is arbitrary.',
	//child of Folder 'Dashboard'=>'Represents a dashboard. Dashboards are visual representations of data that allow you to see key metrics and performance at a glance.',
	// single record like customlabel 'DataCategoryGroup'=>'Represents a data category group.',
	//child of Folder'Document'=>'Represents a Document. All documents must be in a document folder, for example sampleFolder/TestDocument.',
	//child of Folder'EmailTemplate'=>'Represents an email template.',
	'EntitlementTemplate'=>'Represents an entitlement template. Entitlement templates are predefined terms of customer support that you can quickly add to products. For example, you can create entitlement templates for Web or phone support so that users can easily add entitlements to products offered to customers.',
	'FieldSet'=>'Represents a field set. A field set is a grouping of fields. For example, you could have a field set that contains fields describing a user\'s first name, middle name, last name, and business title.',
	'Flow'=>'Represents the metadata associated with a flow. With Flow, you can create an application that navigates users through a series of screens to query and update records in the database. You can also execute logic and provide branching capability based on user input to build dynamic applications.',
	//does not work 'Folder'=>'Represents a folder.',
	'DocumentFolder'=>'Represents a document folder.',
	'EmailFolder'=>'Represents a email template folder.',	
	'DashboardFolder'=>'Represents a dashboard folder.',	
	'Group'=>'Represents a set of public groups, which can have users, roles and other groups.',
	'HomePageComponent'=>'Represents the metadata associated with a home page component. You can customize the Home tab to include components such as sidebar links, a company logo, or a dashboard snapshot.',
	'HomePageLayout'=>'Represents the metadata associated with a home page layout. You can customize home page layouts and assign the layouts to users based on their user profile.',
	'Layout'=>'Represents the metadata associated with a page layout.',
	'Letterhead'=>'Represents formatting options for the letterhead in an email template. Letterheads define the look and feel of your HTML email templates. Your HTML email templates can inherit the logo, color, and text settings from a letterhead.',
	'LeadCriteriaBasedSharingRule' => 'Lead criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	'LeadOwnerharingRule' => 'Lead ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	// too many 'ListView'=>'ListView allows you to see a filtered list of records such as contacts, accounts, or custom objects.',
	// abstract 'Metadata'=>'This is the base class for all metadata types. You cannot edit this object. A component is an instance of a metadata type.',
	//abstract 'MetadataWithContent'=>'This is the base type for all metadata types that contain content, such as documents or email templates.',
	'NamedFilter'=>'Represents the metadata associated with a lookup filter. Use this metadata type to create, update, or delete lookup filter definitions.',
	//'OpportunityCriteriaBasedSharingRule' => 'Opportunity criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'OpportunityOwnerSharingRule' => 'Opportunity ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	//abstract 'OwnerSharingRule'=>'Represents an ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	// not supported v25 'Package'=>'Used to specify metadata components to be retrieved as part of a retrieve() call, or to define a package of components.',
	'PermissionSet'=>'Represents a set of permissions that\'s used to grant additional access to one or more users without changing their profile or reassigning profiles. You can use permission sets to grant access, but not to deny access.',
	//'Picklist (Including Dependent Picklist)'=>'Represents a picklist (or dependent picklist) definition for a custom field in a custom object or a custom or standard field in a standard object, such as an account. Note that picklist values cannot be deleted from a picklist that has been saved to your organization, since data rows might exist that would need to be interactively remapped.',
	'Portal'=>'The Portal metadata type represents a partner portal or Customer Portal.',
	'Profile'=>'Represents a user profile. A profile defines a user\'s permission to perform different functions within Salesforce.',
	'Queue'=>'Represents a holding area for items before they are processed.',
	'RecordType'=>'Represents the metadata associated with a record type. Record types allow you to offer different business processes, picklist values, and page layouts to different users based on their profiles.',
	'RemoteSiteSetting'=>'Represents a remote site setting. Before any Visualforce page, Apex callout, or JavaScript code using XmlHttpRequest in an s-control or custom button can call an external site, that site must be registered in the Remote Site Settings page, or the call will fail.',
	//'Report'=>'Represents a report.',
	'ReportFolder'=>'Represents a report folder.',
	'ReportType'=>'Represents the metadata associated with a custom report type.',
	'Role'=>'Represents a role in your organization.',
	// abstract 'RoleOrTerritory'=>'This represents the common base type and valid values for role or territory.',
	'Scontrol'=>'Deprecated. Represents an Scontrol component, corresponding to an s-control in the Salesforce user interface.',
	//?'SearchLayouts'=>'Represents the metadata associated with the Search Layouts related list for a custom object. You can customize which custom object fields display for users in search results, in lookup dialogs, and in the key lists on custom tab home pages.',
	'SecuritySettings'=>'Represents an organization’s security settings. Security settings define trusted IP ranges for network access, password and login requirements, and session expiration and security settings.',
	'SharingReason'=>'Represents an Apex sharing reason, which is used to indicate why sharing was implemented for a custom object.',
	//?'SharingRecalculation'=>'Represents Apex classes that recalculate the Apex managed sharing for a specific custom object.',
	//?'SharingRules'=>'Represents a set of sharing rules. SharingRules enables you to share records with a set of users, using rules that specify the access level of the target user group.',
	'StaticResource'=>'Represents a static resource file, often a code library in a ZIP file.',
	'Territory'=>'Represents a territory in your organization.',
	'Translations'=>'This metadata type allows you to work with translations for a variety of languages.',
	'ValidationRule'=>'Represents a validation rule, which is used to verify that the data a user enters in a record is valid and can be saved. A validation rule contains a formula or expression that evaluates the data in one or more fields and returns a value of true or false. Validation rules also include an error message that your client application can display to the user when the rule returns a value of true due to invalid data.',
	'WebLink'=>'Represents a Weblink defined in a custom object.',
	'Workflow'=>'Represents the metadata associated with a workflow rule. A workflow rule sets workflow actions into motion when its designated conditions are met. You can configure workflow actions to execute immediately when a record meets the conditions in your workflow rule, or set time triggers that execute the workflow actions on a specific day.',
	'WorkflowRule'=>'This metadata type represents a workflow rule. It extends the Metadata metadata type and inherits its fullName field.',
	'WorkflowAlert'=>'WorkflowAlert represents an email alert associated with a workflow rule.',
	'WorkflowFieldUpdate'=>'WorkflowFieldUpdate represents a workflow field update. Field updates allow you to automatically update a field value to one that you specify when a workflow rule is triggered. For more information, see “Defining Field Updates” in the Salesforce online help.',	
	'WorkflowOutboundMessage'=>'WorkflowOutboundMessage represents an outbound message associated with a workflow rule. Outbound messages are workflow and approval actions that send the information you specify to an endpoint you designate, such as an external service. An outbound message sends the data in the specified fields in the form of a SOAP message to the endpoint. For more information, see “Defining Outbound Messages” in the Salesforce online help.',	
	'WorkflowTask'=>'This metadata type references an assigned workflow task.'
};



public static MAP<string,string> sObjectChildTypes = new MAP<string,string> {
	//'BusinessProcess' => 'The BusinessProcess metadata type enables you to display different picklist values for users based on their profile.',
	//'CustomObjectCriteriaBasedSharingRule' => 'Custom Object criteria-based sharing rule. CriteriaBasedSharingRule enables you to share records based on specific criteria.',
	//'CustomObjectOwnerSharingRule' => 'Custom Object ownership-based sharing rule. OwnerSharingRule enables you to share records owned by a set of users with another set, using rules that specify the access level of the target user group.',
	'CustomField' => 'Represents the metadata associated with a custom field. ',
	'FieldSet' => 'Represents a field set. A field set is a grouping of fields. For example, you could have a field set that contains fields describing a user\'s first name, middle name, last name, and business title.',
	'Layout'=>'Represents the metadata associated with a page layout.',
	'ListView' => 'ListView allows you to see a filtered list of records such as contacts, accounts, or custom objects.',
	//'NamedFilter' => 'Represents the metadata associated with a lookup filter. Use this metadata type to create, update, or delete lookup filter definitions.',
	'RecordType' => 'Represents the metadata associated with a record type. Record types allow you to offer different business processes, picklist values, and page layouts to different users based on their profiles.',
	//'SharingReason' => 'Represents an Apex sharing reason, which is used to indicate why sharing was implemented for a custom object.',
	'ValidationRule' => 'Represents a validation rule, which is used to verify that the data a user enters in a record is valid and can be saved. A validation rule contains a formula or expression that evaluates the data in one or more fields and returns a value of true or false. Validation rules also include an error message that your client application can display to the user when the rule returns a value of true due to invalid data.',
	'WebLink' => 'Represents a Weblink defined in a custom object.',
	'Workflow' => 'Represents the metadata associated with a workflow rule. A workflow rule sets workflow actions into motion when its designated conditions are met. You can configure workflow actions to execute immediately when a record meets the conditions in your workflow rule, or set time triggers that execute the workflow actions on a specific day.  !! It works but is Kind of useless'
	//'WorkflowAlert' => 'WorkflowAlert represents an email alert associated with a workflow rule.',
	//'WorkflowFieldUpdate' => 'WorkflowFieldUpdate represents a workflow field update. Field updates allow you to automatically update a field value to one that you specify when a workflow rule is triggered. For more information, see “Defining Field Updates” in the Salesforce online help.',
	//'WorkflowOutboundMessage' => 'WorkflowOutboundMessage represents an outbound message associated with a workflow rule. Outbound messages are workflow and approval actions that send the information you specify to an endpoint you designate, such as an external service. An outbound message sends the data in the specified fields in the form of a SOAP message to the endpoint. For more information, see “Defining Outbound Messages” in the Salesforce online help.',
	//'WorkflowRule' => 'This metadata type represents a workflow rule. It extends the Metadata metadata type and inherits its fullName field.',
	//'WorkflowTask' => 'This metadata type references an assigned workflow task.'
};


public static MAP<string,string> WorkflowTypes = new MAP<string,string> {
	'WorkflowAlert' => 'WorkflowAlert represents an email alert associated with a workflow rule.',
	'WorkflowFieldUpdate' => 'WorkflowFieldUpdate represents a workflow field update. Field updates allow you to automatically update a field value to one that you specify when a workflow rule is triggered. For more information, see “Defining Field Updates” in the Salesforce online help.',
	'WorkflowOutboundMessage' => 'WorkflowOutboundMessage represents an outbound message associated with a workflow rule. Outbound messages are workflow and approval actions that send the information you specify to an endpoint you designate, such as an external service. An outbound message sends the data in the specified fields in the form of a SOAP message to the endpoint. For more information, see “Defining Outbound Messages” in the Salesforce online help.',
	'WorkflowRule' => 'This metadata type represents a workflow rule. It extends the Metadata metadata type and inherits its fullName field.',
	'WorkflowTask' => 'This metadata type references an assigned workflow task.'
};



}
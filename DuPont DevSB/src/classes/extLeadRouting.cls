/*******************************************************************************
<SL20120828>
Email:sai-sravanthhi.lakkimsetty@bra.dupont.com
Description: Added two lines of code to copy Lead Phone and Email to Lead Routing  
<PC20130627>
Email: preethi.chandrasekharan@usa.dupont.com
Description: Added a line of code to copy Lead Id to Lead Routing                
********************************************************************************/
public class extLeadRouting {


	private final String leadId;
	protected Lead_Routing__c leadRouting  = new Lead_Routing__c();
	private MAP<Id, SFDC_Script_Header__c> scripts;
	public boolean showScriptlist{get;set;}
	public string selectedScript{get;set;}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Constructor
	public extLeadRouting(ApexPages.StandardController controller) {
		this.leadId = controller.getId();
		showScriptlist = false;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//runs after constructor
	public PageReference init() {

		//get all scripts related to this lead
		if (scripts == null && leadId != null) {
			scripts = new MAP<Id, SFDC_Script_Header__c>([     
			                                              SELECT s.Id, s.Script__r.Name, s.Script__c, s.Score__c, s.Name, 
			                                              s.Date_Taken__c, s.CreatedBy.Name, s.CreatedById, s.CreatedDate
			                                              FROM SFDC_Script_Header__c s Where Lead__c =: leadId
			                                              ]);
		} 

		if ( scripts == null )    return save(); 
		if ( scripts.size()==0 )    return save(); 
		selectedScript=getLatestScript();
		showScriptlist = true;
		return null;    
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private string getLatestScript() {
		string rtn = null;
		datetime dt;
		for (SFDC_Script_Header__c sh : scripts.values()) {
			if (rtn == null || dt < sh.CreatedDate) {
				rtn=sh.id; 
				dt = sh.CreatedDate;
			}
		}
		return rtn;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public List<SFDC_Script_Header__c> getScripts() {
		if ( scripts != null ) return scripts.values();
		else return new List<SFDC_Script_Header__c>();
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public PageReference clearScript() {
		selectedScript=null;
		return null;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public PageReference cancel() {
		PageReference RequestPage = new PageReference('/'+leadId);
		RequestPage.setRedirect(true);
		return RequestPage;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public PageReference save() {

		System.debug('Saving...');

		//Get lead data
		CopyLeadToLeadRouting();

		//get script
		AddScript();

		//get Campaigns
		AddCampaigns();

		//get solutions
		AddSolutions();

		//overwrite Owner
		leadRouting.OwnerId=UserInfo.getUserId();

		//Lead is now owned by an Individual (Queue)
		string ownerid=leadRouting.Lead_OwnerId__c;
		if (! ownerid.startsWith('005'))  {
			leadRouting.Lead_OwnerId__c = null;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'A lead owned by a queue cannot be routed.  please assign ownership to an individual before routing.'));
			showScriptlist = false;
			return null;
		}

		//Create the leadRouting Object
		upsert leadRouting;

		//Redirect to outbound email
		PageReference RequestPage = new PageReference('/email/author/emailauthor.jsp?retURL=%2F'+leadId+'&p3_lkid='+leadRouting.Id);
		RequestPage.setRedirect(true);
		return RequestPage;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private String joint(SET<String> aset, String delim) {
		String out='';
		for (String s :aset) out+=s+delim;
		return (out.length()>0) ? out.substring(0,out.length()-(delim.length())) : out;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void CopyLeadToLeadRouting() {

		MAP<String,String> mapping = new MAP<String,String>();
		SET<String> selectFields = new SET<string>();

		// AutoMap rule based mapping of field from Lead to Lead Routing
		// {LeadField}={LeadRoutingField} were api fields exacty match
		// {LeadField}={LeadRoutingField}+'__c' match with '__c' suffix on lead routing
		// {LeadField}='Lead_'+{LeadRoutingField}+'__c' match with 'Lead_' prefix and '__c' suffix on lead routing
		Schema.DescribeSObjectResult dsrLead = Lead.SObjectType.getDescribe();
		Schema.DescribeSObjectResult dsrLRO = Lead_Routing__c.SObjectType.getDescribe();
		Map<String, SObjectField> fLead = dsrLead.fields.getMap();
		Map<String, SObjectField> fLRO = dsrLRO.fields.getMap();
		for (string lf : fLead.keyset()) {        
			Schema.DescribeFieldResult dfr_l = fLead.get(lf).getDescribe() ;
			if ( dfr_l.isAccessible() ) {
				selectFields.add(lf);
				if (fLRO.containsKey(lf)) 
					mapping.put(lf,lf);
				else
					for (string lrf : fLRO.keyset()) {
						if (lf+'__c'==lrf || 'lead_'+lf+'__c'==lrf) {
							Schema.DescribeFieldResult dfr_lr = fLRO.get(lrf).getDescribe() ;
							system.debug(dfr_lr);
							if ( dfr_lr.isUpdateable() ) mapping.put(lf,lrf);
							break;
						}
					}
			}
		}

		//hardCoded Selections 
		//(all accessable fields directly on lead are already added.)
		selectFields.add('CreatedBy.Name');
		selectFields.add('Owner.Name');

		//hardcoded mappings this will overrride any auto mappings 
		//( use lower case)
		mapping.put('id','lead_name__c');
		mapping.put('ownerid','lead_owner__c');
		//mapping.put('leadsource','lead_source__c');
		//mapping.put('firstname','lead_first_name__c');
		//mapping.put('lastname','lead_last_name__c');
		//mapping.put('firstnamelocal','first_name_local__c');
		//mapping.put('lastnamelocal','last_name_local__c');
		//mapping.put('companylocal','company_name_local__c');
		//mapping.put('opt_in_dupont__c','dupont_opt_in__c');
		//mapping.put('donotcall','do_not_call__c');
		//mapping.put('owning_organization__c','owning_org__c');
		//mapping.put('mobilephone','lead_mobile__c');
		//mapping.put('influence_type__c','buying_process_role__c');
		//mapping.put('distributor_or_partner__c','distributor__c');


		//Remove these Mappings
		if (mapping.containskey('createddate'))          mapping.remove('createddate');
		if (mapping.containskey('createdbyid'))          mapping.remove('createdbyid');
		if (mapping.containskey('lastmodifieddate'))        mapping.remove('lastmodifieddate');
		if (mapping.containskey('lastmodifiedbyid'))        mapping.remove('lastmodifiedbyid');   

		//Query Lead and populate lead routing Object
		String soql = 'SELECT ' + joint(selectFields,',') + ' FROM lead where Id = \'' + leadId + '\'';
		Lead l = Database.query(soql);
		for (string m : mapping.keyset() ) {
			try {
				if (String.valueof(l.get(m)) != null)
					leadRouting.put(mapping.get(m),l.get(m));
			}
			catch( Exception ex ) {
				system.debug('!!!!Exception!!!!! (Field: '+m+') : '+ex);
			}
		}

		//add non-standard mappings
		try {
			geography.Address addr = new geography.Address(l);
			leadRouting.Lead_Address__c = addr.blockformat();
		} catch(Exception ex) {}

		leadRouting.Lead_OwnerId__c = l.OwnerId;
		leadRouting.Lead_Owner__c = l.Owner.Name;
		leadRouting.Lead_Created_By__c=l.CreatedBy.Name;
		leadRouting.Annual_Revenue__c=String.valueof(l.AnnualRevenue);
		leadRouting.Lead_Created_Date__c=l.CreatedDate;
		leadRouting.Legacy_Created_Datetime__c=l.Legacy_Created_Datetime__c;
		leadRouting.Lead_Created_Time__c=l.Lead_Created_Time__c;
		leadRouting.Lead_Email__c=l.Email;//SL20120828
		leadRouting.Lead_Phone__c=l.Phone;//SL20120828
		leadRouting.Lead_ID__c=l.Id;//PC20130627
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private void AddCampaigns() {
		Set<String> c = new Set<String>();
		for (CampaignMember cm : [Select Campaign.Name from CampaignMember where LeadId= :leadId])
			c.add(cm.Campaign.Name);
		leadRouting.Campaign__c=joint(c,'; ');
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void AddScript() {
		if (selectedScript != null)
			if ( selectedScript != '') {
				List<SFDC_Script_Result__c> srs = new List<SFDC_Script_Result__c>([
				                                                                   Select Answer__c, CreatedById, CreatedDate, CurrencyIsoCode, Id, 
				                                                                   LastModifiedById, LastModifiedDate, Name, Question__c, Score__c 
				                                                                   FROM SFDC_Script_Result__c WHERE Script_Result__c =: selectedScript
				                                                                   ORDER BY Id
				                                                                   ]);
				String scriptresults = '';
				for (SFDC_Script_Result__c sr : srs )
					scriptresults += 'QUESTION: ' + sr.Question__c + '\n' + 'ANSWER: ' + sr.Answer__c + '\n\n'; 

				leadRouting.Script_Results__c=scriptresults;
				leadRouting.Script_Header_ID__c = selectedScript;
				leadRouting.Script_Name__c=scripts.get(selectedScript).Script__r.Name;
				leadRouting.Date_Taken__c=scripts.get(selectedScript).Date_Taken__c;    
				leadRouting.Score__c=scripts.get(selectedScript).Score__c;  
				leadRouting.Script_Header_Created_By__c=scripts.get(selectedScript).CreatedBy.Name; 
			}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void AddSolutions() {
		String sol = '';
		integer i=0;
		for (Solution_Lead__c s : [ Select CreatedDate, Quantity__c, Solution__r.Generic_Name_Code__c, 
		                            Solution__r.SolutionName 
		                            from Solution_Lead__c where Lead__c = :leadId]) {
			i++;
			if (i<6) {
				leadRouting.put('Created_Date_'+String.valueof(i)+'__c',s.CreatedDate);
				leadRouting.put('Quantity_'+String.valueof(i)+'__c',s.Quantity__c);
				leadRouting.put('Generic_Name_Code_'+String.valueof(i)+'__c',s.Solution__r.Generic_Name_Code__c);
				leadRouting.put('Solution_'+String.valueof(i)+'__c',s.Solution__r.SolutionName);
			}
			sol+='[ '+s.CreatedDate+' ] - [ '+s.Quantity__c+' ] - [ '+s.Solution__r.Generic_Name_Code__c+' ] - [ '+s.Solution__r.SolutionName+' ] \n';
		}
		if ( sol.length()>0 ) {
			sol = '[ Created Date ] - [ Quantity ] - [ Generic Name/Code ] - [ Solution ] \n'+sol;
			leadRouting.Solutions__c = sol;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////



	//Pick a lead w/ call scripts and solutions
	public static testMethod void test1(){
	  //[03102017] Merge&Spin: Created test data for the test method
    Lead leadRec=new Lead(Owning_SBU__c='Chemicals & Fluoroproducts',Owning_Organization__c='DCF-FPS SPS',LastName='sample1',Email='smita.sample@usa.dupont.com',Company='XYZ',Lead_Country__c='INDIA',Region__c='ASIA PACIFIC',Origin_Channel_Type__c='Phone',Origin_Name__c='www.dupont.com/teflon/sample',Type__c='Literature',Status='Capture',LeadSource='Website' ,RecordTypeId=RType.getIdByDevName('Lead','DPT_ES'),Lead_Queue__c=' DPT_AP_Level_2_Leads');
    insert leadRec;
    SFDC_Script_Header__c sh1 = new SFDC_Script_Header__c(Lead__c=leadRec.id, SFDC_Legacy_Id__c = 'Test1');
    insert sh1;
        Lead l = [
		          Select Id from Lead 
		          WHERE Id in (SELECT Lead__c FROM SFDC_Script_Header__c )
            /*Rambabu: Commented to remove reference to Solution_Lead__c
		          AND Id in ( Select  Lead__c FROM Solution_Lead__c ) */
		          LIMIT 1
		          ];

		Test.startTest();    
		extLeadRouting elr = new extLeadRouting(new ApexPages.StandardController(l) );
		elr.init();
		system.debug(elr.getScripts());
		elr.save();

		//test trigger
		Lead_Routing__c lro = [Select Id from Lead_Routing__c where Lead_Name__c=:l.id LIMIT 1];
		Task t = new Task(WhatId=elr.leadRouting.Id, Subject='Email testing');
		insert t;

		Test.stopTest();
	}   
/*
	//Pick a lead wo/ call scripts and owned by a queue and in a acampaign
	public static testMethod void test2(){
	   //[03102017] Merge&Spin: Created test data for the test method
        Group grp = new Group(Name='TestCampaignOwnerQ', type='Queue');
        insert grp;

        System.runAs(new User(Id=UserInfo.getUserId())) {
            QueuesObject que = new QueueSObject(QueueID = grp.id, SobjectType = 'Lead');
            insert que;
        }
        Lead l = [
		          Select Id from Lead 
		          WHERE Id not in (SELECT Lead__c FROM SFDC_Script_Header__c )
		          AND Id in (SELECT LeadId FROM CampaignMember )
		          AND Owner.type = 'Queue'
		        	  LIMIT 1
		        	  ];
		Test.startTest();
		extLeadRouting elr = new extLeadRouting(new ApexPages.StandardController(l) );
		elr.init();
		elr.cancel();
		Test.stopTest();
	}   
*/




}
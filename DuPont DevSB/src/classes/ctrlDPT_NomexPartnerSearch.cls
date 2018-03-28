/**********************************************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author	:	Sreedhar Jagannath/ Divya Ramakrishnaih
Email	:	Sreedhar.Jagannath@ind.dupont.com/ Divya Ramakrishnaih@usa.dupont.com
Date 	:	12th Sep 2011
Apex class	:	ctrlDPT_NomexPartnerSearch
Description	:	Controller for Nomex Fabric Search. Accepts the filter criteria entered by the user on the 
				VF page 'DPT_NomexPartnerSearch' and invokes the hasVisibility method of 'DPT_NomexSearchResults' class. 
***********************************************************************************************************/
public without sharing class ctrlDPT_NomexPartnerSearch {
	//Variables Declaration
	public Integer maxWeight{get; set;}
	public Integer minWeight{get;set;}
	public User userLoggedIn {get;set;}
	public boolean displayPopup {get; set;}
	static Schema.DescribeFieldResult qualMainEndUsesDescr = Qualification__c.Main_End_Uses__c.getDescribe();
	static List<Schema.PicklistEntry> qualMainEndUsesPicklistValues = qualMainEndUsesDescr.getPicklistValues();
	static Schema.DescribeFieldResult qualOtherCriteriaDescr = Qualification__c.Other_Criteria_Met__c.getDescribe();
	static List<Schema.PicklistEntry> qualOtherCriteriaPicklistValues = qualOtherCriteriaDescr.getPicklistValues();
	public String qualificationMainEndUse{get;set;}
	public String fabricColour{get;set;}
	public String qualConstruction{get;set;}
	public String qualSubType{get;set;}
	public List<String> SelectQualificationRiskAreaValue = new List<String>();
	List<NomexUserInputResultList> NomexScriptResultsList = new List<NomexUserInputResultList>();
	DPT_NomexSearchResults nomexSearchResultObj = new DPT_NomexSearchResults();
	public void closePopup() {
		displayPopup = false;
	}
	public void showPopup() {
		displayPopup = true;
	}

	/**********************************************************************************************
	* Inner class that holds the variables of fields from Qualification and Script Results objects, 
	* used to populate the result panel on the VF page
	***********************************************************************************************/
	public class NomexUserInputResultList {
		public string accountId{get; set;}
		public string accountName{get; set;}
		public string productReference{get; set;}
		public string color{get; set;}
		public string weight{get; set;}
		public string useAs{get; set;}
		public string construction{get; set;}
		public string extraComfort{get; set;}
		public string extraMechanicalPerformance{get; set;}
		public string extraWaterAndOilRepellency{get; set;}
		public string extraLongLastingPerformance{get; set;}
		public string extraAestheticPerformance{get; set;}
	}

	/**********************************************************************************************************
	Apex class	:	DPT_NomexSearchResults
	Description	:	Inner class for Nomex Fabric Search. Processes the query to DB based on the accepted filter 
					criteria applied by the user, invoked through 'ctrlDPT_NomexPublicSearch'
					and returns the filtered result list.
	***********************************************************************************************************/
	public without sharing class DPT_NomexSearchResults {

		/******************************************************************************************************
		*Method Name: hasVisibility
		*Description: Invoked by loadScripts method of ctrlDPT_NomexPublicSearch class, by passing the filter criteria entered by the user as parameters.
		*			 This method formualtes the query string based on received paramters and queries the DB to get the filtered records.
		*			 Populates the list of type NomexUserInputResultList used for displaying on VF page, which is returned to the calling method.
		*Return Type: list<NomexUserInputResultList>
		********************************************************************************************************/
		public List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList> hasVisibility(String Constructions,String Colours,List<String> SelectQualificationRiskAreaValue,String QualificationMainEndUse,String SubType,Integer MinWeight, Integer MaxWeight){ 
			List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList> finalScriptResultList = new List<ctrlDPT_NomexPartnerSearch.NomexUserInputResultList>();
			List<DPT_Nomex_Search_Results__c> custSettinglist = new List<DPT_Nomex_Search_Results__c>();
			List<SFDC_Script_Header__c> scriptHeaderList;
			List<SFDC_Script_Result__c> scriptResultList;
			User userLoggedIn ;
			String riskOfArea;
			String fieldOfUse;
			try{
				// to mandate the entry of main end use field by the user as it should be compulsory
				if(QualificationMainEndUse == 'none'){
					ApexPages.Message requiredField=new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for \'Main End Use\', as it is required for filtering.');
					ApexPages.addMessage(requiredField);
				}
				else{
					Set<Id> custSettingScriptIdSet = new Set<Id>();
					Set<Id> scriptHeaderSet = new Set<Id>();
					finalScriptResultList = new List<NomexUserInputResultList>();
					List<String> custSettingQuestionIdList = new List<String>();
					String approved = 'Approved';
					String query1;
					String queryDynamic = '';
					String query2;
					String queryFinal;
					scriptResultList = new List<SFDC_Script_Result__c>();
					userLoggedIn = [Select Name,Id from User where id = :UserInfo.getUserId() limit 1];
					//Query the list of custom settings DPT_Nomex_Search_Results__c to get the scripts and question Ids
					custSettinglist = [Select Script_Id__c, Question_Id__c, Question_Name__c from DPT_Nomex_Search_Results__c];
					for(DPT_Nomex_Search_Results__c c:custSettinglist){
						custSettingQuestionIdList.add(c.Question_Id__c);
						custSettingScriptIdSet.add(c.Script_Id__c);
					}
					query1 = 'Select sh.Id, sh.Script__c, sh.Script__r.Id,sh.Qualification__r.Id, sh.Qualification__r.CreatedById, sh.Qualification__r.Account_Name__r.name, sh.Qualification__r.Account_Name__c, sh.Qualification__r.Make_Visible_To__c, sh.Qualification__r.Reference_Id__c,sh.Qualification__r.Weight__c, sh.Qualification__r.SubType__c, sh.Qualification__r.Colour__c, sh.Qualification__r.Construction__c from SFDC_Script_Header__c sh ';
					query1 = query1 + 'where (sh.Script__r.Id IN :custSettingScriptIdSet) and (sh.Qualification__r.Status__c =:approved) and (sh.Qualification__r.Make_Visible_To__c = \'Catalogue\')';
					String Colour = '%'+Colours+'%';
					// dynamic formation of the query string depending on the filters applied by the user on the VF page
					if (Colours != 'None'){
						query1 =query1 + ' and (sh.Qualification__r.Colour__c like : Colour)';
					}
					if(Constructions != 'None'){
						query1 =query1 + ' and (sh.Qualification__r.Construction__c=:Constructions)';
					}
					if(QualificationMainEndUse != 'None'){
						query1 = query1 + ' and (sh.Qualification__r.Main_End_Uses__c includes (\''+QualificationMainEndUse+'\'))';
					}
					if(SubType!= 'None'){
						query1 = query1 + 'and (sh.Qualification__r.SubType__c =:SubType)';
					}
					if((SelectQualificationRiskAreaValue.size()!=0) && (SelectQualificationRiskAreaValue[0]!='none')){
						riskOfArea = SelectQualificationRiskAreaValue[0];
							for(Integer i=1;i<SelectQualificationRiskAreaValue.size();i++)
								riskOfArea = riskOfArea+';'+SelectQualificationRiskAreaValue[i];
							query1 = query1 + 'and (sh.Qualification__r.Other_Criteria_Met__c includes (\''+riskOfArea+'\'))';
					}
					if((MinWeight == 0 && MaxWeight == 0) || (MinWeight != 0.0 && MaxWeight == 0)){
						queryDynamic = ' and (sh.Qualification__r.Weight__c >=: MinWeight)';
					}
					else if (MinWeight == 0 && MaxWeight != 0){
						queryDynamic = ' and (sh.Qualification__r.Weight__c <=: MaxWeight)';
					}
					else if(MinWeight != 0 && MaxWeight != 0){
						queryDynamic = ' and (sh.Qualification__r.Weight__c >=: MinWeight and sh.Qualification__r.Weight__c <=: MaxWeight)';
					}
					query2 = 'order by sh.Qualification__r.Account_Name__r.name';   
					queryFinal = query1 + queryDynamic + query2;
					scriptHeaderList = new List<SFDC_Script_Header__c>();
					scriptHeaderList = database.query(queryFinal);
					for(SFDC_Script_Header__c sh:scriptHeaderList)
						scriptHeaderSet.add(sh.Id);
					scriptResultList = [Select sr.Id, sr.Question__c, sr.Answer__c, sr.Script_Result__c from SFDC_Script_Result__c sr where (sr.Script_Result__c IN :scriptHeaderSet)   and (sr.QuestionId__c IN :custSettingQuestionIdList)];
					// to polulate the final list displayed as output on the VF page,by iterating through the filtered records of the objects 
					for(SFDC_Script_Header__c scrptHeader:scriptHeaderList){
						NomexUserInputResultList obj = new NomexUserInputResultList();
						obj.accountId=scrptHeader.Qualification__r.Account_Name__c;
						obj.accountName=scrptHeader.Qualification__r.Account_Name__r.Name;
						obj.productReference=scrptHeader.Qualification__r.Reference_Id__c;
						obj.color=scrptHeader.Qualification__r.Colour__c;
						obj.weight=String.valueOf(scrptHeader.Qualification__r.Weight__c);
						obj.useAs=scrptHeader.Qualification__r.SubType__c;
						obj.construction=scrptHeader.Qualification__r.Construction__c;
						for(SFDC_Script_Result__c scrptResult:scriptResultList){
							if(scrptResult.Script_Result__c == scrptHeader.Id){
								if(scrptResult.Question__c == 'Extra Comfort')
									obj.extraComfort=scrptResult.Answer__c;
								if(scrptResult.Question__c == 'Extra Mechanical Performance')
									obj.extraMechanicalPerformance=scrptResult.Answer__c;
								if(scrptResult.Question__c == 'Extra Water and Oil Repellency')
									obj.extraWaterAndOilRepellency=scrptResult.Answer__c;
								if(scrptResult.Question__c == 'Extra Long Lasting Performance')
									obj.extraLongLastingPerformance=scrptResult.Answer__c;
								if(scrptResult.Question__c == 'Extra Aesthetic Performance')
									obj.extraAestheticPerformance=scrptResult.Answer__c;
							}
						}
						finalScriptResultList.add(obj);
					}
					//to check and let the user know if the filter entered by the user didn't return any results
					if (finalScriptResultList.size() == 0){
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No results available for your search. Kindly modify your search criteria.'));
					}
				}
				return finalScriptResultList;
			}
			catch(Exception ex){
				return null;
			}
		}
	}

	// method to populate Fabric Colour drop down on VF page
	public List<SelectOption> getItemsColour(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('None','None'));
		options.add(new SelectOption('Yellow','Yellow'));
		options.add(new SelectOption('Orange','Orange'));
		options.add(new SelectOption('Red','Red'));
		options.add(new SelectOption('Blue','Blue'));
		options.add(new SelectOption('Green','Green'));
		options.add(new SelectOption('Grey','Grey'));
		options.add(new SelectOption('Black','Black'));
		options.add(new SelectOption('Brown','Brown'));
		options.add(new SelectOption('White','White'));
		return options;
	}
	// method to populate risk area drop down on VF page, from database picklist values of other criteria met field
	public List<SelectOption> getItemsQualificationRiskArea(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('none','None'));
		for(Integer i = 0;i < qualOtherCriteriaPicklistValues.size();i++ ){
			options.add(new SelectOption(qualOtherCriteriaPicklistValues[i].getValue(),qualOtherCriteriaPicklistValues[i].getLabel()));
		}
		return options;
	}
	// getter and setter methods for Risk Area
	public void setSelectQualificationRiskArea(List<String> SelectQualificationRiskAreaValue){
		this.SelectQualificationRiskAreaValue = SelectQualificationRiskAreaValue;
	}
	public List<String> getSelectQualificationRiskArea(){
		return SelectQualificationRiskAreaValue;
	}
	// method to populate main end use drop down on VF page, from database picklist values of other criteria met field
	public List<SelectOption> getItemsQualificationMainEndUse(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('none','None'));
		for(Integer i = 0;i < qualMainEndUsesPicklistValues.size();i++ ){
			options.add(new SelectOption(qualMainEndUsesPicklistValues[i].getValue(),qualMainEndUsesPicklistValues[i].getLabel()));
		}
		return options;
	}
	// method to populate Constructions drop down on VF page
	public List<SelectOption> getItemsConstructions(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('None','None'));
		options.add(new SelectOption('Honeycomb','Honeycomb'));
		options.add(new SelectOption('Interlock','Interlock'));
		options.add(new SelectOption('Quilted','Quilted'));
		options.add(new SelectOption('Special single jersey','Special single jersey'));
		options.add(new SelectOption('Woven- Plain','Woven- Plain'));
		options.add(new SelectOption('Woven- Plain Ripstop','Woven- Plain Ripstop'));
		options.add(new SelectOption('Woven- Twill Ripstop','Woven- Twill Ripstop'));
		options.add(new SelectOption('Woven- Twill 2/1','Woven- Twill 2/1'));
		return options;
	}
	// method to populate Sub Type drop down on VF page
	public List<SelectOption> getItemsSubType(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('None','None'));
		options.add(new SelectOption('Fabric - Inner liner','Inner liner'));
		options.add(new SelectOption('Fabric - Outer layer','Outer layer'));
		options.add(new SelectOption('Fabric - Knit','Fabric - Knit'));
		return options;
	}

	/*constructor of the class*/
	public ctrlDPT_NomexPartnerSearch (){
		minWeight=0;
	}

	/******************************************************************************************************
	*Method Name: loadScripts
	*Description: Action method invoked on the click of Submit button on VF page.
	*			 This method internally invokes the 'hasVisibility' method of the 'DPT_NomexSearchResults', 
	*			 by passing the filter criteria applied by the user on the VF page as parameters to the method.
	*			 Assigns the list 'NomexScriptResultsList' with the result list returned by the method invoked
	********************************************************************************************************/
	public void loadScripts(){
		NomexScriptResultsList = nomexSearchResultObj.hasVisibility(qualConstruction, fabricColour, SelectQualificationRiskAreaValue, qualificationMainEndUse, qualSubType, minWeight, maxWeight);
	}

	/*method that returns the final result list to the VF page displayed as search results, on the click of Submit button*/
	public List <NomexUserInputResultList> getQualificationListNext(){
		return NomexScriptResultsList;
	}
}
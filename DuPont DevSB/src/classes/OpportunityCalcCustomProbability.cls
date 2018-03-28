/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved.
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Controller class to calculate the custom probability for the Opportunity Object
********************************************************************************/
public with sharing class OpportunityCalcCustomProbability{

	public static void calcCustomProbability(LIST<Opportunity> opps) {

			for (Opportunity o : opps) {//For all opportunities
				//RecordTypeSettings__c rts = rTypeIdToSetting(o.recordtypeid);
				RecordTypeSettings__c rts = utilRT.getRTById(o.recordtypeid).getSettings(); //fetch the record type settings  based on record ID
				System.debug('In calcCustomProbabbility Method rts is -->'+rts);
                
                if (rts!=null && rts.OppCustomProbability__c!=null) {//If record type exists having custom probability field filled
					System.debug('In calcCustomProbability Method OppCustomProbability__c is -->'+rts.OppCustomProbability__c);
					string source='StageName'; //set source field as Stage Name
					string destination='Probability';//set destination field as Probability
					MAP<string,string> settings = Util.mapUrlVars(rts.OppCustomProbability__c);//Split URL into Map

					if (settings.get('s')!=null) {
						source=settings.get('s');//Fetching source value
						settings.remove('s');//Remove source from settings
					}

					if (settings.get('d')!=null) {
						destination=settings.get('d');//Fetching destination value
						settings.remove('d');//Remove destination from settings
					}

					system.debug('Assigned settings: '+settings);
					system.debug('Assigned source: '+source);
					system.debug('Assigned destination: '+destination);
					string decodedSourceVal=EncodingUtil.urldecode((string)o.get(source),'UTF-8');
					system.debug('encodedSourceVal: '+decodedSourceVal);

					if (settings.containsKey(decodedSourceVal)!=null) {
						try {
							o.put(destination,Decimal.valueOf(settings.get(decodedSourceVal)));
						}catch(exception ex){
						}
					}
				}
			}
		}
}
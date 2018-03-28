/******************************************************************************* 
Copyright © 2014 DuPont. All rights reserved. 
Author: Abhinav Bhatnagar
Email: abhinav.bhatnagar@dupont.com
Description:  Batch Class for Salesforce To Salesforce Functionality. The
primary funtionality of the batch class is to-
1. Fetch the custom settings or Load Defaults if custom settings are not available
2. Query and get valid Opportunities are not sent already to Parksite
3. Call ctrlOppSFDCToSFDC helper class and pass list of valid 1000 opportunties at a time

Updated
<AB20141111> updated End – Lost with End - Lost changed long hyphen with short hyphen
<AB20141111> updated End – Won with End - Won changed long hyphen with short hyphen

<AS20160919>
Modified By: Arjun Sharma
Modification Date: 19-Sept-2016
Modification: As per new requirement of CP for SF picklist values have changed for Stage, Segment L2 and Segment L3 
added new picklist values in the code. Old values are not removed.
********************************************************************************/
global class batchOppSFDCToSFDC implements Database.Batchable<sObject> {
    /* Global Private Constants used through out the class */
    private static final String CUSTOMSETTINGFORFILTER = 'BINASFDCToSFDC'; //Name of the custom settings from where filters needs to be fetched
    private static final String BLANK = '';
    private static final Integer NONE = 0;
    private static final Date STARTINGDATE = Date.newInstance(2013, 1, 1);
    private static final String BATCH = 'Batch';
    
    /*Global Variables*/
    private String AccountNameCustomSettings = BLANK;
    private String RecordTypeNameCustomSettings = BLANK;
    private String ApplicationTypeCustomSettings = BLANK;
    private Integer ValueCustomSettings = NONE; 
    private Date   StartingDateCustomSettings = STARTINGDATE;
    
    SET<String> EISegmentL2CustomSettings = new SET<String>();
    SET<String> EISegmentL3CustomSettings = new SET<String>();
    SET<String> EIStageCustomSettings = new SET<String>();
    SET<String> OppStageCustomSettings = new SET<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        try{
            boolean fetchingSuccessfull = getCustomSettingsSetFilters();//Get the custom settings and set them as filters for query
            
            If(!fetchingSuccessfull || Test.isRunningTest()){//If fetching of custom settings is unsuccessfull then load default settings.
                loadDefaultSettings(); 
            }
            Account acc = getAccount();
            RecordType rt = getRecordType();
            
            return Database.getQueryLocator([SELECT fId18__c, Name, External_Initiative__c, AccountId FROM Opportunity where AccountId = : acc.id AND RecordTypeId = : rt.id AND  Application_Type__c = : ApplicationTypeCustomSettings AND StageName not in : OppStageCustomSettings AND CloseDate > : StartingDateCustomSettings AND External_Initiative__r.Segment_L2__c not in : EISegmentL2CustomSettings AND External_Initiative__r.Value__c >= : ValueCustomSettings AND External_Initiative__r.Segment_L3__c in : EISegmentL3CustomSettings AND External_Initiative__r.Stage__c not in : EIStageCustomSettings AND id not in (SELECT LocalRecordId FROM PartnerNetworkRecordConnection) ORDER BY id LIMIT 1000 ]);
        
        }catch(Exception e){
            system.debug('Exception Occured '+e.getStackTraceString());
            return  Database.getQueryLocator([SELECT ID FROM Opportunity where name = 'This is not an existing Opportunity']);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        ctrlOppSFDCToSFDC costsObject = new ctrloppSFDCToSFDC(oppList);
        costsObject.callSFDCToSFDC(BATCH,BLANK);           
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
    
    /*Filter Criteria -
Account  is Parksite (IL) Tyvek - HQ 
Opportunity Record Type is ‘BI-NA MHC Opportunity’
Other Validation Criteria -
Value greater or equal to "2,500,000"
AND Segment L2 does not contain Animal/Plant,Bath/Beach,Bowling,Communications,Custom House,Factories,oFlood Dam,
Other Terminal, Parks/Playground, Prisons, Spec Houses, Special, Swim Pools, Warehouse Other, Warehouse Refrigerated, Water Treatment
AND Stage not equal to any of the Pre-Planning, Occupancy, Abandoned, Deferred
AND Segment L3 equal to Building Additions, New Construction
AND Application Type equal to  CLT-Tyvek
AND Stage not equal to End - Lost OR End - Won . 
AND Close Date greater OR equal 1/1/2013
Method to compare values between each opportunity Metadata and fetched custom settings value to validate it */
    
    private boolean getCustomSettingsSetFilters(){
        try{
            Map<String, BINASFDCToSFDC__C> mapOfCustomSettings = BINASFDCToSFDC__C.getAll(); 
            Set<String> EISegmentL2 = new Set<String>();
            Set<String> EISegmentL3 = new Set<String>();
            Set<String> EIStage = new Set<String>();
            for(String key:mapOfCustomSettings.keySet()){
                if(key.contains('EI Segment L2')){
                    EISegmentL2CustomSettings.add(mapOfCustomSettings.get(key).Value__c);
                }else if(key.contains('EI Segment L3')){
                    EISegmentL3CustomSettings.add(mapOfCustomSettings.get(key).Value__c);
                }else if(key.contains('EI Stage')){
                    EIStageCustomSettings.add(mapOfCustomSettings.get(key).Value__c);
                }else if(key.contains('Stage End ')){
                    OppStageCustomSettings.add(mapOfCustomSettings.get(key).Value__c);
                }
            }
            AccountNameCustomSettings = mapOfCustomSettings.get('Account').value__c;  
            system.debug('AccountNameCustomSettings '+AccountNameCustomSettings);
            RecordTypeNameCustomSettings = mapOfCustomSettings.get('Opportunity Record Type').value__c; 
            system.debug('RecordTypeNameCustomSettings '+RecordTypeNameCustomSettings);
            ApplicationTypeCustomSettings =  mapOfCustomSettings.get('Application Type').value__c;
            StartingDateCustomSettings = Date.parse(mapOfCustomSettings.get('Close Date').value__c);
            ValueCustomSettings = Integer.valueOf(mapOfCustomSettings.get('Value').value__c);
            return true;
        }Catch(Exception e){
            
            return false;
        }
    }
    
    private void loadDefaultSettings(){
        
        AccountNameCustomSettings = 'Parksite (IL) Tyvek - HQ';
        RecordTypeNameCustomSettings = 'BI-NA MHC Opportunity';
        StartingDateCustomSettings = STARTINGDATE;
        
        EISegmentL2CustomSettings.add('Animal/Plant');
        EISegmentL2CustomSettings.add('Bath/Beach');
        EISegmentL2CustomSettings.add('Bowling');
        EISegmentL2CustomSettings.add('Communications');
        EISegmentL2CustomSettings.add('Custom House');
        EISegmentL2CustomSettings.add('Factories');
        EISegmentL2CustomSettings.add('Flood Dam');
        EISegmentL2CustomSettings.add('Other Terminal');
        EISegmentL2CustomSettings.add('Parks/Playground'); 
        EISegmentL2CustomSettings.add('Prisons');
        EISegmentL2CustomSettings.add('Spec Houses');
        EISegmentL2CustomSettings.add('Special');
        EISegmentL2CustomSettings.add('Swim Pools'); 
        EISegmentL2CustomSettings.add('Warehouse Other');
        EISegmentL2CustomSettings.add('Warehouse Refrigerated');
        EISegmentL2CustomSettings.add('Water Treatment');
        /*<AS20160919> Start*/
        EISegmentL2CustomSettings.add('Animal/Plant/Fish Facility');
        EISegmentL2CustomSettings.add('Beach/Marina Facility');
        EISegmentL2CustomSettings.add('Bowling Alley');
        EISegmentL2CustomSettings.add('Communication Building');
        EISegmentL2CustomSettings.add('Custom Homes');
        EISegmentL2CustomSettings.add('Manufacturing Building');
        EISegmentL2CustomSettings.add('Flood Control');
        EISegmentL2CustomSettings.add('Passenger Terminal (Other)');
        EISegmentL2CustomSettings.add('Park/Playground');
        EISegmentL2CustomSettings.add('Site Development');
        EISegmentL2CustomSettings.add('Prison/Jail');
        EISegmentL2CustomSettings.add('Sale/Spec Homes');
        EISegmentL2CustomSettings.add('Miscellaneous Education Building');
        EISegmentL2CustomSettings.add('Pre-School');
        EISegmentL2CustomSettings.add('Swimming Pool');
        EISegmentL2CustomSettings.add('Warehouse');
        EISegmentL2CustomSettings.add('Warehouse (Refrigerated)');
        EISegmentL2CustomSettings.add('Water Treatment Plant');
        /*<AS20160919> End*/
        
        EISegmentL3CustomSettings.add('Building Additions');
        EISegmentL3CustomSettings.add('New Construction');
        /*<AS20160919> Start*/
        EISegmentL3CustomSettings.add('Additions');
        EISegmentL3CustomSettings.add('New Porject');
        /*<AS20160919> End*/
        
        EIStageCustomSettings.add('Pre-Planning');
        EIStageCustomSettings.add('Occupancy');
        EIStageCustomSettings.add('Abandoned');
        EIStageCustomSettings.add('Deferred');
        /*<AS20160919> Start*/
        EIStageCustomSettings.add('Request for Proposals');
        EIStageCustomSettings.add('Request for Qualifications');
        EIStageCustomSettings.add('Pre-Design');
        EIStageCustomSettings.add('Notice of Completion');
        EIStageCustomSettings.add('Leasing');
        EIStageCustomSettings.add('Service Bidding');
        EIStageCustomSettings.add('Retrofit');
        EIStageCustomSettings.add('Delayed');
        /*<AS20160919> End*/
        
        ValueCustomSettings = 2500000;
        
        ApplicationTypeCustomSettings = 'CLT-Tyvek';
        
        OppStageCustomSettings.add('End - Lost');//<AB20141111> updated End – Lost with End - Lost changed long hyphen with short hyphen
        OppStageCustomSettings.add('End - Won');//<AB20141111> updated End – Won with End - Won changed long hyphen with short hyphen
        
    }
    
    private Account getAccount(){
        return  [Select id, name from Account where name= : AccountNameCustomSettings LIMIT 1];
    }
    
    private RecordType getRecordType(){
        return [Select id, name from RecordType where name = : RecordTypeNameCustomSettings LIMIT 1];
    }
}